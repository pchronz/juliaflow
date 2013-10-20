# Copyright 2013 Peter Chronz
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

macro length(typ)
    # Check whether this type contains any fields whose size cannot be
    # inferred right now. Assuming we can only get the size of Numbers (is this
    # true?) reliably.
    tayp::Type = eval(typ)
    typs = tayp.types
    dirty = false
    for t in typs
        if !(t<:Number)
            dirty = true
            break
        end
    end
    if !dirty
        # Return both a generic version and a specific one that delegates to the
        # generic one.
        quote
            function $(esc(:give_length))(::Type{$(typ)})
                # TODO XXX Is there a 1-to-1 correspondence between the literal
                # type definition of fields, what names returns and what types
                # contains? The ordering in specific is of importance!
                typs = $(tayp).types
                len = 0
                for t in typs
                    len += sizeof(t)
                end
                len
            end
            function $(esc(:give_length))(obj::$(typ))
                $(esc(:give_length))($(typ))
            end
        end
    else
        # Expression to access a certain field of the object. This is spliced in
        # below.
        fields = names(tayp)
        typs = tayp.types
        exs::Array{Expr} = Array(Expr, length(fields))
        for i = 1:Base.length(typs)
            accex = Expr(:quote, :($(fields[i])))
            exs[i] = typs[i] <: Number ? :(len += sizeof(obj.($(accex)))) : :(len += give_length(obj.($(accex))))
        end
        # Return only the specific one.
        quote
            function $(esc(:give_length))(obj::$(typ))
                len = 0
                $(exs...)
                len
            end
        end
    end
end
# Create a function that will convert your given type to bytes.
macro bytes(typ)
    t::DataType = eval(typ)
    fields = names(t)
    typs = t.types
    exs = Array(Expr, length(fields))
    for i = 1:length(fields)
        ex = Expr(:., :obj, Expr(:quote, fields[i]))
        exs[i] = quote
            bs = bytes($ex)
            bs_len = length(bs)
            byts[pos:pos + bs_len - 1] = bs
            pos += bs_len
        end
    end
    quote
        function $(esc(:bytes))(obj::$(typ))
            objsize = give_length(obj)
            byts::Bytes = Array(Uint8, objsize)
            bs::Bytes
            pos::Integer = 1
            $(exs...)
            byts
        end
    end
end
# A @string macro; probably quite similar to the bytes macro
macro string(typ, args...)
    t::DataType = eval(typ)
    fields::Vector{Symbol} = names(t)
    strfields::Vector{Symbol}
    if length(args) > 0 
        strfields = eval(args[1])
    else
        strfields = Symbol[]
    end
    typs::Tuple = t.types
    exs::Vector{Expr} = Array(Expr, 0)
    push!(exs, :(strs[1] = string("\n$(repeat("\t", tabs))Type: ", $(typ), "\n")))
    push!(exs, :(pos::Int = 2))
    for i = 2:length(typs)
        objacc = Expr(:., :obj, Expr(:quote, fields[i]))
        if ismatch(r"^pad.*", string(fields[i]))
            continue
        elseif typs[i] <: OfpStruct || eltype(typs[i]) <: OfpStruct
            push!(exs, :(strs[pos] = string($(Expr(:quote, fields[i])), " = ",
                string($(objacc), tabs + 1), "\n")))
            push!(exs, :(pos += 1))
        elseif typs[i] <: Bytes && contains(strfields, fields[i])
            push!(exs, :(strs[pos] = string(repeat("\t", tabs), $(Expr(:quote,
                fields[i])), " = ", ascii($(objacc)), "\n")))
            push!(exs, :(pos += 1))
        else
            push!(exs, :(strs[pos] = string(repeat("\t", tabs), $(Expr(:quote,
                fields[i])), " = ", string($(objacc)), "\n")))
            push!(exs, :(pos += 1))
        end
    end
    quote
        import Base.string
        $(esc(:string))(obj::$(typ)) = $(esc(:string))(obj, 0)
        function $(esc(:string))(obj::$(typ), tabs::Int)
            strs::Vector{String} = Array(String, length($(typ).types))
            $(exs...)
            "$(strs[1:(pos - 1)]...)"
        end
    end
end
# Create a byte-based constructor for the given type.
function bytesconstructor(t::Symbol, typ::Type, fields::Vector{Symbol},
    typs::Tuple, sizes::Dict{Symbol, Int}, varsizes::Dict{Symbol, Expr})
    # Expanding the array dynamically since we need to filter out the padding.
    # The penalty should be quite low, since there are rather few fields in each
    # type, and the construction macro is going to be called just once per type.
    exs::Vector{Expr} = Expr[]
    hasheader::Bool = false
    for i = 1:length(fields)
        # Padding fields are set by the constructors. We do not have any access
        # to those fields from here.
        # The OfpHeader needs to be created by the inner constructor implicitly.
        ex::Expr
        if ismatch(r"^pad.*", string(fields[i]))
            if typs[i] <: Number
                ex = :(pos += $(sizeof(typs[i])))
            elseif typs[i] <: Array
                ex = :(pos += $(sizes[fields[i]]))
            else
                error("Unrecognized type for padding.")
            end
        elseif typs[i] == Uint8
            ex = quote
                val = bytes[pos]
                local $(fields[i]) = val
                field_len += 1
                fieldvals[field_len] = val
                pos += 1
            end
        elseif typs[i] == Uint16
            ex = quote
                val = btoui(bytes[pos], bytes[pos + 1])
                local $(fields[i]) = val
                field_len += 1
                fieldvals[field_len] = val
                pos += 2
            end
        elseif typs[i] == Uint32
            ex = quote
                val = btoui(bytes[pos], bytes[pos + 1], bytes[pos + 2], bytes[pos + 3])
                local $(fields[i]) = val
                field_len += 1
                fieldvals[field_len] = val
                pos += 4
            end
        elseif typs[i] == Uint64
            ex = quote
                val = btoui(bytes[pos], bytes[pos + 1], bytes[pos + 2], bytes[pos + 3], bytes[pos + 4], bytes[pos + 5], bytes[pos + 6], bytes[pos + 7])
                local $(fields[i]) = val
                field_len += 1
                fieldvals[field_len] = val
                pos += 8
            end
        elseif typs[i] == OfpHeader
            hasheader = true
            ex = :((field_len += 1; fieldvals[field_len] = header))
        elseif typs[i] <: OfpStruct
            ex = quote
                o = $(typs[i])(bytes[pos:end])
                isa(o, $(typs[i]))
                field_len += 1
                fieldvals[field_len] = o
                pos += give_length(o)
            end
        elseif typs[i] <: Bytes
            lenex::Expr = if haskey(sizes, fields[i])
                :(pos + $(sizes[fields[i]]) - 1)
            elseif haskey(varsizes, fields[i])
                :(pos + $(varsizes[fields[i]]) - 1)
            elseif i == length(fields)
                :(length(bytes))
            else
                error("Cannot process a byte array of unknown length if it is not the last field!")
            end
            ex = quote
                field_len += 1
                fieldvals[field_len] = bytes[pos:$(lenex)]
                pos = $(lenex) + 1
            end
        elseif typs[i] <: Array
            eltyp = eltype(typs[i])
            if !(eltype(typs[i]) <: OfpStruct)
                error("Handling array fields works only with element types that
                    subtype OfpStruct and not with $(typs[i])!")
            end
            ex = quote
                arr = Array($(eltyp), 0)
                # XXX If I change the following 4 lines to a conditional
                # statement, where "constructor" is declared and defined within
                # the body of the if-statement, then I get a strange looking
                # error which tells me that constructor is not defined. Bug in
                # Julia?
                constructor = $(eltyp)
                if !isleaftype($(eltyp))
                    constructor = $(symbol(string(eltyp, "Factory")))
                end
                while pos <= Base.length(bytes)
                    o = constructor(bytes[pos:end])
                    arr = [arr..., o]
                    len = give_length(o)
                    pos += len
                end
                field_len += 1
                fieldvals[field_len] = arr
            end
        end
        exs = [exs..., ex]
    end
    args::Vector{Expr} = hasheader ? [:(header::OfpHeader), :(bytes::Bytes)] :
        [:(bytes::Bytes)]
    quote
        function $(esc(t))($(args...))
            # Values of the fields to be passed in to the inner constructor
            fieldvals = cell(16)
            field_len = 0
            pos = 1
            $(exs...)
            $(t)(fieldvals[1:field_len]...)
        end
    end
end
# szs[1]-->Dict{Symbol, Int}: length of a field
# szs[2]-->Dict{Symbol, Expr}: expression to compute the length of a field
macro bytesconstructor(t, szs...)
    typ::Type = eval(t)
    fields::Vector{Symbol} = names(typ)
    typs::Tuple = typ.types
    sizes::Dict{Symbol, Int} = length(szs) > 0 ? (length(eval(szs[1])) > 0 ?
        eval(szs[1]) : Dict{Symbol, Int}()) : Dict{Symbol, Int}()
    varsizes::Dict{Symbol, Expr} = length(szs) > 1 ? (length(eval(szs[2])) > 0 ?
        eval(szs[2]) : Dict{Symbol, Expr}()) : Dict{Symbol, Expr}()
    bytesconstructor(t, typ, fields, typs, sizes, varsizes)
end

