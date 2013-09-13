module OpenFlow
# TODO Put in some asserts at least until there will be some tests.
# XXX isn't there some kind of type I can define for this?
# XXX this type should convert between string representation and integers by
# itself efficiently
# TODO For all types provide bytes, both constructors (fields and bytes),
# string. Use constructors and bytes in unit tests.
# TODO API
# TODO Convenience constructors to expose via API without header creation.
# TODO Tests
# TODO Minimum constructors. Create all which is implicit automatically in an
# inner constructor.
# TODO License
# TODO TLS
# TODO consider taking all the types and generating all written macros directly,
# without typing all of the macros for each of the types by hand.
# TODO Command line control.

# OFP_TYPE
# Immutable messages
const OFPT_HELLO = 0x00 # Symmetric message
const OFPT_ERROR = 0x01 # Symmetric message
const OFPT_ECHO_REQUEST = 0x02 # Symmetric message
const OFPT_ECHO_REPLY = 0x03 # Symmetric message
const OFPT_VENDOR = 0x04 # Symmetric message
# Switch configuration messages
const OFPT_FEATURES_REQUEST = 0x05 # Controller/switch message
const OFPT_FEATURES_REPLY = 0x06 # Controller/switch message
const OFPT_GET_CONFIG_REQUEST = 0x07 # Controller/switch message
const OFPT_GET_CONFIG_REPLY = 0x08 # Controller/switch message
const OFPT_SET_CONFIG = 0x09 # Controller/switch message
# Asynchronous messages
const OFPT_PACKET_IN = 0x0a # Async message
const OFPT_FLOW_REMOVED = 0x0b # Async message
const OFPT_PORT_STATUS = 0x0c # Async message
# Controller command messages
const OFPT_PACKET_OUT = 0x0d # Controller/switch message
const OFPT_FLOW_MOD = 0x0e # Controller/switch message
const OFPT_PORT_MOD = 0x0f # Controller/switch message
# Statistics messages
const OFPT_STATS_REQUEST = 0x10 # Controller/switch message
const OFPT_STATS_REPLY = 0x11 # Controller/switch message
# Barrier messages
const OFPT_BARRIER_REQUEST = 0x12 # Controller/switch message
const OFPT_BARRIER_REPLY = 0x13 # Controller/switch message
# Queue configuration messages
const OFPT_QUEUE_GET_CONFIG_REQUEST = 0x14 # Controller/switch message
const OFPT_QUEUE_GET_CONFIG_REPLY = 0x15 # Controller/switch message

# Port-related constants
# OFP_PORT_CONFIG Flags to indicate behavior of the physical port. These flags
    # are used in ofp_py_port to describe the current configuration. They are used
    # in the ofp_port_mod message to configure the port's behavior.
const OFPPC_PORT_DOWN = 1 << 0 # Port is administratively down
const OFPPC_NO_STP = 1 << 1 # Disable 802.1D spanning tree on port.
const OFPPC_NO_RECV = 1 << 2 # Drop all packets except 802.1D spanning tree packets.
const OFPPC_NO_RECV_STP = 1 << 3 # Drop received 802.1D STP packets.
const OFPPC_NO_FLOOD = 1 << 4 # Do not include this port when flooding.
const OFPPC_NO_FWD = 1 << 5 # Drop packets forwarded to port.
const OFPPC_NO_PACKET_IN = 1 << 6 # Do not send packet-in msgs fort port.
# OFP_PORT_STATE Current state of the physical port. These are not configurable
    # from the controller.
const OFPPS_LINK_DOWN = 1 << 0 # No physical link present.
# The OFPPS_STP_* bits have no effect on switch operation. The controller must
    # adjust OFPPC_NO_RECV, OFPPC_NO_FWD, and OFPPC_NO_PACKET_IN appropriately to
    # fully implement an 802.1D spanning tree.
const OFPPS_STP_LISTEN = 0 << 8 # Not learning or relaying frames.
const OFPPS_STP_LEARN = 1 << 8 # Learning but not relaying frames.
const OFPPS_STP_FORWARD = 2 << 8 # Learning and relaying frames.
const OFPPS_STP_BLOCK = 3 << 8 # Not part of spanning tree.
const OFPPS_STP_MASK = 3 << 8 # Bit mask for OFPPS_STP_* values.
# OFP_PORT Port numbering. Physical ports are numbered starting from 1.
# Maximum number of physical switch ports.
const OFPP_MAX = 0xff00
# Fake output "ports".
const OFPP_IN_PORT = 0xfff8 # Send the packet out the input port. This virtual
    # port must be explicitly used in order to send back out the input port.
const OFPP_TABLE = 0xfff9 # Perform actions in flow table. NB: This can only be
    # the destination port for packet-out messages.
const OFPP_NORMAL = 0xfffa # Process with normal L2/L3 switching.
const OFPP_FLOOD = 0xfffb # All physical ports except input port and those
# disabled by STP.
const OFPP_ALL = 0xfffc # All physical ports except input port.
const OFPP_CONTROLLER = 0xfffd # Send to controller.
const OFPP_LOCAL = 0xfffe # Local openflow "port".
const OFPP_NONE = 0xffff # Not associated with a physical port.
# OFP_PORT_FEATURES Features of physical ports available in a datapath.
const OFPPF_10MB_HD = 1 << 0 # 10 Mb half-duplex rate support.
const OFPPF_10MB_FD = 1 << 1 # 10 Mb full-duplex rate suport.
const OFPPF_100MB_HD = 1 << 2 # 100 Mb half-duplex rate support.
const OFPPF_100MB_FD = 1 << 3 # 100 Mb full-duplex rate support.
const OFPPF_1GB_HD = 1 << 4 # 1 Gb half-duplex rate support.
const OFPPF_1GB_FD = 1 << 5 # 1 Gb full-duplex rate support.
const OFPPF_10GB_FD = 1 << 6 # 10Gb full-duplex rate support.
const OFPPF_COPPER = 1 << 7 # Copper medium.
const OFPPF_FIBER = 1 << 8 # Fiber medium.
const OFPPF_AUTONEG = 1 << 9 # Auto-negotiation.
const OFPPF_PAUSE = 1 << 10 # Pause.
const OFPPF_PAUSE_ASYM = 1 << 11 # Asymmetric pause.

# OFP_CAPABILITIES Capabilities supported by datapath.
const OFPC_FLOW_STATS = 1 << 0 # Flow statistics.
const OFPC_TABLE_STATS = 1 << 1 # Table statistics.
const OFPC_PORT_STATS = 1 << 2 # Port statistics.
const OFPC_STP = 1 << 3 # 802.1d spanning tree.
const OFPC_RESERVED = 1 << 4 # Reserved, must be zero.
const OFPC_IP_REASM = 1 << 5 # Can reassemble IP fragments.
const OFPC_QUEUE_STATS = 1 << 6 # Queue statistics.
const OFPC_ARP_MATCH_IP = 1 << 7 # Match IP addressed in ARP pkts.

# Switch configuration flags
# OFP_CONFIG_FLAGS
# Handling of IP fragments.
const OFPC_FRAG_NORMAL = 0 # No special handling for fragments.
const OFPC_FRAG_DROP = 1 # Drop fragments.
const OFPC_FRAG_REASM = 2 # Reassemble (only if OFPC_IP_REASM set).
const OFPC_FRAG_MASK = 3 

# Packet in reasons
# OFP_PACKET_IN_REASON
const OFPR_NO_MATCH =  0x00 # No matching flow.
const OFPR_ACTION = 0x00 # Action explicitly output to controller.

# Port status
# OFP_PORT_REASON
# What changed about the physical port.
const OFPPR_ADD = 0x00 # The port was added.
const OFPPR_DELETE = 0x01 # The port was removed.
const OFPPR_MODIFY = 0x02 # Some attribute of the port has changed.

# Flow wildcards
# OFP_FLOW_WILDCARDS
const OFPFW_IN_PORT = 1 << 0 # Switch input port.
const OFPFW_DL_VLAN = 1 << 1 # VLAN id.
const OFPFW_DL_SRC = 1 << 2 # Ethernet source address.
const OFPFW_DL_DST = 1 << 3 # Ethernet destination address.
const OFPFW_DL_TYPE = 1 << 4 # Ethernet frame type.
const OFPFW_NW_PROTO = 1 << 5 # IP protocol.
const OFPFW_TP_SRC = 1 << 6 # TCP/UDP source port.
const OFPFW_TP_DST = 1 << 7 # TCP/UDP destination port.
# IP source address wildcard bit count. 0 is exact match, 1 ignores the LSB, 2
# ignores the 2 least significant bits, ..., 32 and higher wildcard the entire
# field. This is the *opposite* of the usual convention where e.g. /24 indicates
# that 8 bits (not 24 bits) are wildcarded.
const OFPFW_NW_SRC_SHIFT = 8
const OFPFW_NW_SRC_BITS = 6 
const OFPFW_NW_SRC_MASK = ((1 << OFPFW_NW_SRC_BITS) - 1) << OFPFW_NW_SRC_SHIFT
const OFPFW_NW_SRC_ALL = 32 << OFPFW_NW_SRC_SHIFT
# IP destination address wildcard bit count. Same format as source.
const OFPFW_NW_DST_SHIFT = 14
const OFPFW_NW_DST_BITS = 6
const OFPFW_NW_DST_MASK = ((1 << OFPFW_NW_DST_BITS) - 1) << OFPFW_NW_DST_SHIFT
const OFPFW_NW_DST_ALL = 32 << OFPFW_NW_DST_SHIFT
const OFPFW_DL_VLAN_PCP = 1 << 20 # VLAN priority.
const OFPFW_NW_TOS = 1 << 21 # IP ToS (DSCP field, 6 bits).
# Wildcards all fields.
const OFPFW_ALL = (1 << 22) - 1 

# OFP_ACTION_TYPE
const OFPAT_OUTPUT = 0x00 # Output to switch port.
const OFPAT_SET_VLAN_VID = 0x01 # Set the 802.1q VLAN id.
const OFPAT_SET_VLAN_PCP = 0x02 # Set the 802.1q priority.
const OFPAT_STRIP_VLAN = 0x03 # Strip the 802.1q header.
const OFPAT_SET_DL_SRC = 0x04 # Ethernet source address.
const OFPAT_SET_DL_DST = 0x05 # Ethernet destination address.
const OFPAT_SET_NW_SRC = 0x06 # IP source address.
const OFPAT_SET_NW_DST = 0x07 # IP destination address.
const OFPAT_SET_NW_TOS = 0x08 # IP ToS (DSCP field, 6 bits).
const OFPAT_SET_TP_SRC = 0x09 # TCP/UDP source port.
const OFPAT_SET_TP_DST = 0x0a # TCP/UDP destination port.
const OFPAT_ENQUEUE = 0x0b # Output to queue.
const OFPAT_VENDOR = 0xffff

# OFP_FLOW_MOD_COMMAND
const OFPFC_ADD = 0x00 # New flow.
const OFPFC_MODIFY = 0x01 # Modify all matching flows.
const OFPFC_MODIFY_STRICT = 0x02 # Modify entry strictly matching wildcards.
const OFPFC_DELETE = 0x03 # Delete all matching flows.
const OFPFC_DELETE_STRICT = 0x04 # Strictly match wildcards and priority.

# OFP_FLOW_MOD_FLAGS
const OFPFF_SEND_FLOW_REM = 1 << 0 # Send flow removed message when flow expires
                                    # or is deleted
const OFPFF_CHECK_OVERLAP = 1 << 1 # Check for overlapping entries first.
const OFPFF_EMERG = 1 << 2 # Remark this is for emergency.

# Error messages.
# OFP_ERROR_TYPE
const OFPET_HELLO_FAILED = 0x00 # Hello protocol failed.
const OFPET_BAD_REQUEST = 0x01 # Request was not understood.
const OFPET_BAD_ACTION = 0x02 # Error in action description.
const OFPET_FLOW_MOD_FAILED = 0x03 # Problem modifying flow entry.
const OFPET_PORT_MOD_FAILED = 0x04 # Port mod request failed.
const OFPET_QUEUE_OP_FAILED = 0x05 # Queue operation failed.
# OFP_BAD_REQUEST_CODE
const OFPBRC_BAD_VERSION = 0x00 # ofp_header.version not supported.
const OFPBRC_BAD_TYPE = 0x01 # ofp_header.type not supported.
const OFPBRC_BAD_STAT = 0x02 # ofp_stats_request.type not supported.
const OFPBRC_BAD_VENDOR = 0x03 # Vendor not supported (in ofp_vendor_header or
    # ofp_stats_request or ofp_stats_reply).
const OFPBRC_BAD_SUBTYPE = 0x04 # Vendor subtype not supported.
const OFPBRC_EPERM = 0x05 # Permissions error.
const OFPBRC_BAD_LEN = 0x06 # Wrong request length for type.
const OFPBRC_BUFFER_EMPTY = 0x07 # Specified buffer has already been used.
const OFPBRC_BUFFER_UNKNOWN = 0x08 # Specified buffer does not exist.
# OFP_BAD_ACTION_CODE
# ofp_error_msg 'code' values for OFPET_BAD_ACTION. 'data' contains at least the
# first 64 bytes of the failed request.
const OFPBAC_BAD_TYPE = 0x00 # Unknown action type.
const OFPBAC_BAD_LEN = 0x01 # Length problem in actions.
const OFPBAC_BAD_VENDOR = 0x02 # Unkown vendor id specified.
const OFPBAC_BAD_VENDOR_TYPE = 0x03 # Unkown action type for vendor id.
const OFPBAC_BAD_OUT_PORT = 0x04 # Problem validating output action.
const OFPBAC_BAD_ARGUMENT = 0x05 # Bad action argument.
const OFPBAC_EPERM = 0x06 # Permissions error.
const OFPBAC_TOO_MANY = 0x07 # Can't handle this many actions.
const OFPBAC_BAD_QUEUE = 0x08 # Problem validating output queue.
# OFP_FLOW_MOD_FAILED_CODE
# ofp_error_msg 'code' values for OFPET_FLOW_MOD_FAILED. 'data' contains at
# least the first 64 bytes of the failed request.
const OFPFMFC_ALL_TABLES_FULL =  # Flow not added because of full tables.
const OFPFMFC_OVERLAP =  # Attempted to add overlapping flow with CHECK_OVERLAP
    # flag set.
const OFPFMFC_EPERM =  # Permissions error.
const OFPFMFC_BAD_EMERG_TIMEOUT =  # Flow not added because of non-zero
    # idle/hard timeout.
const OFPFMFC_BAD_COMMAND =  # Unknown command.
const OFPFMFC_UNSUPPORTED =  # Unsupported action list - cannot process in the
    # order specified.
# OFP_PORT_MOD_FAILED_CODE
# ofp_error_msg 'code' values for OFPET_PORT_MOD_FAILED> 'data' contains at
# least the first 64 bytes of the failed request.
const OFPMFC_BAD_PORT = 0x00 # Specified port does not exist.
const OFPMFC_BAD_HW_ADDR = 0x01 # Specified hardware address is wrong.
# OFP_QUEUE_OP_FAILED_CODE
# ofp_error msg 'code' values for OFPET_QUEUE_OP_FAILED. 'data' contains at
# least the first 64 bytes of the failed request.
const OFPQOFC_BAD_PORT = 0x00 # Invalid port (or port does not exist).
const OFPQOFC_BAD_QUEUE = 0x01 # Queue does not exist.
const OFPQOFC_EPERM = 0x02 # Permissions error.
# OfpQueueProperties
const OFPQT_NONE = 0 # No property defined for a queue (default).
const OFPQT_MIN_RATE = 1 # Minimu datarate guaranteed.
                           # Other rates should be added here (i.e. max rate,
                           # precedence, etc).
# OFP_STATS_TYPES
const OFPST_DESC = 0x00 # Description of this OpenFlow switch. The request body
    # is empty. The reply body is struct ofp_desc-stats.
const OFPST_FLOW = 0x01 # Individual flow statistics. The request body is struct
    # ofp_flow_stats_request. The reply body is an array of structu ofp_flow_stats.
const OFPST_AGGREGATE = 0x02 # Aggregate flow statistics. The request body is
    # struct ofp_aggregate_stats_request. The reply body is struct
    # ofp_aggregate_reply.
const OFPST_TABLE = 0x03 # Flow table statistics. The request body is empty. The
    # reply body is an array of struct ofp_table_stats.
const OFPST_PORT = 0x04 # Physical port statistics. The request body is struct
    # ofp_port_stats_request. The reply body is an array of struct ofp_port_stats.
const OFPST_QUEUE = 0x05 # Queue statistics for a port. The request body defines
    # the port. The reply body is an array of struct ofp_queue_stats. 
const OFPST_VENDOR = 0xffff # Vendor extension. The request and reply bodies
    # begin witha 32-bit vendor ID, which takes the same form as in "struct
    # ofp_vendor_header". The request and reply bodies are otherwise
    # vendor-defined.
# OFP_FLOW_REMOVED_REASON
const OFPRR_IDLE_TIMEOUT = 0x00 # Flow idle time exceeded idle_timeout.
const OFPRR_HARD_TIMEOUT = 0x01 # Time exceeded hard_timeout.
const OFPRR_DELTE = 0x02 # Evicted by a DELETE flow mod.
# Other used constants
const OFP_MAX_ETH_ALEN = 6
const OFP_MAX_PORT_NAME_LEN = 16
const DESC_STR_LEN = 256
const SERIAL_NUM_LEN = 32
const OFP_MAX_TABLE_NAME_LEN = 32

# We will be using a lot of byte/octect arrays here
typealias Bytes Vector{Uint8}

bytes(byts::Bytes) = byts
function bytes(ui::Uint8)
    [ui]
end
function bytes(ui::Uint16)
    byts = zeros(Uint8, 2)
    byts[1] = uint8(ui >> 8)
    byts[2] = uint8(ui)
    byts
end
function bytes(ui::Uint32)
    byts = zeros(Uint8, 4)
    byts[1] = uint8(ui >> 24)
    byts[2] = uint8(ui >> 16)
    byts[3] = uint8(ui >> 8)
    byts[4] = uint8(ui)
    byts
end
function bytes(ui::Uint64)
    byts = zeros(Uint8, 8)
    byts[1] = uint8(ui >> 56)
    byts[2] = uint8(ui >> 48)
    byts[3] = uint8(ui >> 40)
    byts[4] = uint8(ui >> 32)
    byts[5] = uint8(ui >> 24)
    byts[6] = uint8(ui >> 16)
    byts[7] = uint8(ui >> 8)
    byts[8] = uint8(ui)
    byts
end

give_length(arr::Bytes) = length(arr)
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
        for i = 1:length(typs)
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
        # No idea how to interpolate field access, so explicit code generation
        # will have to do for now.
        ex = Expr(:., :obj, Expr(:quote, fields[i]))
        exs[i] = quote
            bs = bytes($ex)
            byts[pos:pos + length(bs) - 1] = bs
            pos += length(bs)
        end
    end
    quote
        function $(esc(:bytes))(obj::$(typ))
            objsize = give_length(obj)
            byts::Bytes = zeros(Uint8, objsize)
            bs::Bytes
            pos::Integer = 1
            $(exs...)
            byts
        end
    end
end
# A @string macro; probably quite similar to the bytes macro
# TODO add a second argument, that will allow us to provide a hint on the depth
# of this string and thus how many tabs to prepend to each line.
macro string(typ)
    t::DataType = eval(typ)
    fields::Vector{Symbol} = names(t)
    typs::Tuple = t.types
    exs::Vector{Expr} = Array(Expr, length(fields))
    exs[1] = :(strs[1] = string("\n$(repeat("\t", tabs))Type: ", $(typ), "\n"))
    for i = 2:length(typs)
        objacc = Expr(:., :obj, Expr(:quote, fields[i]))
        if typs[i] <: OfpStruct || eltype(typs[i]) <:OfpStruct
            exs[i] = :(strs[$(i)] = string($(Expr(:quote, fields[i])), " = ",
                string($(objacc), tabs + 1), "\n"))
        else
            exs[i] = :(strs[$(i)] = string(repeat("\t", tabs), $(Expr(:quote,
                fields[i])), " = ", string($(objacc)), "\n"))
        end
    end
    quote
        import Base.string
        $(esc(:string))(obj::$(typ)) = $(esc(:string))(obj, 0)
        function $(esc(:string))(obj::$(typ), tabs::Int)
            strs::Vector{String} = Array(String, length($(typ).types))
            $(exs...)
            "$(strs...)"
        end
    end
end
# Create a byte-based constructor for the given type.
# TODO handle parametric types
# TODO arrays with run time-defined length
# TODO constructing arrays of OfpStruct types.
macro bytesconstructor(t, szs...)
    typ::Type = eval(t)
    fields::Vector{Symbol} = names(typ)
    typs::Tuple = typ.types
    sizes::Dict{Symbol, Int} = length(szs) > 0 ? eval(szs[1]) : Dict{Symbol,
        Int}()
    # Expanding the array dynamically since we need to filter out the padding.
    # The penalty should be quite low, since there are rather few fields in each
    # type, and the construction macro is going to be called just once per type.
    exs::Vector{Expr} = Expr[]
    hasheader::Bool = false
    for i = 1:length(fields)
        # Padding fields are set by the constructors. We do not have any access
        # to those fields from here.
        # The OfpHeader needs to be created by the inner constructor implicitly.
        len::Integer
        ex::Expr
        if ismatch(r"^pad.*", string(fields[i]))
            if typs[i] <: Number
                continue
            elseif typs[i] <: Array
                ex = :(pos += $(sizes[fields[i]]))
            else
                error("Unrecognized type for padding.")
            end
        elseif typs[i] <: Number
            len = sizeof(typs[i])
            ex = quote
                fieldvals = {fieldvals..., btoui(bytes[pos:pos + $(len) - 1])}
                pos += $(len)
            end
        elseif typs[i] == OfpHeader
            hasheader = true
            ex = :(fieldvals = [fieldvals..., header])
        elseif typs[i] <: OfpStruct
            len = length(typs[i])
            ex = quote
                fieldvals = {fieldvals..., $(t)(bytes[pos:pos + $(len) - 1])}
                pos += $(len)
            end
        elseif typs[i] <: Bytes
            ex = quote
                append!(fieldvals, {bytes[pos:pos + $(sizes[fields[i]]) - 1]})
                pos += $(sizes[fields[i]])
            end
        elseif typs[i] <: Array
            # TODO for both byte arrays and arrays of OfpStruct.
            error("Constructing array-based fields from bytes not yet
                implemented!")
        end
        exs = [exs..., ex]
    end
    args::Vector{Expr} = hasheader ? [:(header::OfpHeader), :(bytes::Bytes)] :
        [:(bytes::Bytes)]
    quote
        function $(esc(t))($(args...))
            # Values of the fields to be passed in to the inner constructor
            fieldvals::Vector{Any} = {}
            pos = 1
            $(exs...)
            $(t)(fieldvals...)
        end
    end
end

abstract OfpStruct
# TODO go through all iterative computations and try to apply map instead.
give_length{T<:OfpStruct}(arr::Vector{T}) = sum(map(give_length, arr))
# XXX Is his slow? Maybe it is faster to first obtain the required size, then
# allocate the array, then writing the value, iterative style. 
bytes{T<:OfpStruct}(arr::Vector{T}) = [map(bytes, arr)...]
import Base.string
string{T<:OfpStruct}(arr::Vector{T}, tabs=0) = "$(map((x)->(string(x, tabs)), arr)...)"
immutable OfpHeader <: OfpStruct
    protoversion::Uint8
    msgtype::Uint8
    msglen::Uint16
    msgidx::Uint32
end
OfpHeader(msgtype::Uint8, msglen::Uint16, msgidx::Uint32=0x00000000) = OfpHeader(0x01,
    msgtype, msglen, msgidx)
# XXX implement proper conversion functions
# TODO String conversion in Julia is idiomatic by actually creating a new string
# object using the original type as argument ==> import the string function (is
# it not imported implicitly already?) and provide external constructor methods
# for it. ==> probably all "tostring" just need to be renamed to "string".
#function tostring(header::OfpHeader)
#    "<Version: $(header.protoversion), type: $(header.msgtype), length: $(header.msglen), idx: $(header.msgidx)>"
#end
# XXX implement proper conversion functions
#function bytes(header::OfpHeader)
#    msg = zeros(Uint8, 8)
#    msg[1] = header.protoversion
#    msg[2] = header.msgtype
#    msg[3] = uint8(header.msglen>>8)
#    msg[4] = uint8(header.msglen)
#    msg[5] = uint8(header.msgidx>>24)
#    msg[6] = uint8(header.msgidx>>16)
#    msg[7] = uint8(header.msgidx>>8)
#    msg[8] = uint8(header.msgidx)
#    msg
#end
@bytes OfpHeader
@length OfpHeader
@string OfpHeader
function readofpheader(socket)
    protoversion = read(socket, Uint8, 1)[1]
    msgtype = read(socket, Uint8, 1)[1]
    msglen = ntoh(read(socket, Uint16, 1)[1])
    msgidx = ntoh(read(socket, Uint32, 1)[1])
    OfpHeader(protoversion, msgtype, msglen, msgidx)
end
#give_length(header::Type{OfpHeader}) = 8

abstract OfpMessage <: OfpStruct
# Query for port configuration.
# ofp_queue_get_config_request
immutable OfpQueueGetConfigRequest <: OfpMessage
    header::OfpHeader
    port::Uint16 # Port to be queried. Should refer to a valid physical port
                    # (i.e. < OFPP_MAX).
    pad::Bytes # Length: 2; 32-bits alignment.
    OfpQueueGetConfigRequest(header, port) = begin
        @assert header.msgtype == OFPT_QUEUE_GET_CONFIG_REQUEST
        @assert header.msglen == 12
        new(header, port, zeros(Uint8, 2))
    end
end
@length OfpQueueGetConfigRequest
@bytes OfpQueueGetConfigRequest
@string OfpQueueGetConfigRequest
@bytesconstructor OfpQueueGetConfigRequest [:pad=>2]
#give_length(::Type{OfpQueueGetConfigRequest}) =
#    give_length(OfpHeader) + 4
#function bytes(queueconfigreq::OfpQueueGetConfigRequest)
#    byts::Bytes = zeros(Uint8, give_length(OfpQueueGetConfigRequest))
#    byts[1:8] = queueconfigreq.header
#    byts[9:10] = queueconfigreq.port
#    byts
#end
# Creating a new type to bundle all OfpQueueProperties.
abstract OfpQueueProp <: OfpStruct
# Common description for a queue.
immutable OfpQueuePropHeader <: OfpStruct
    property::Uint16 # One of OFPQT_*.
    len::Uint16 # Length of property, including this header.
    pad::Bytes # Length: 4; 64-bit alignment.
    OfpQueuePropHeader(prop::Uint16, len::Uint16) = new(prop, len, zeros(Uint8,
        4))
end
@bytes OfpQueuePropHeader
@length OfpQueuePropHeader
@string OfpQueuePropHeader
@bytesconstructor OfpQueuePropHeader [:pad=>4]
#function bytes(queuepropheader::OfpQueuePropHeader)
#    byts::Bytes = zeros(Uint8, give_length(queuepropheader))
#    byts[1:2] = bytes(queuepropheader.property)
#    byts[3:4] = bytes(queuepropheader.len)
#    byts
#end
#OfpQueuePropHeader(body::Bytes) = OfpQueuePropHeader(btoui(body[1:2]), btoui(body[3:4]))
#give_length(queuepropheader::OfpQueuePropHeader) = 8
immutable OfpQueuePropNone <: OfpQueueProp
    header::OfpQueuePropHeader
    function OfpQueuePropNone(header::OfpQueuePropHeader) 
        @assert header.property == OFPQT_NONE
        @assert header.len == 8
        new(header)
    end
end
@bytes OfpQueuePropNone
@length OfpQueuePropNone
@string OfpQueuePropNone
# XXX bytesconstructor
#@bytesconstructor OfpQueuePropNone
immutable UnknownQueueProperty <: Exception
end

# XXX Why is it not allowed to create a constructor for the abstract type?
function OfpQueuePropFactory(body::Bytes)
    header::OfpQueuePropHeader = OfpQueuePropHeader(body[1:8])
    if header.property == OFPQT_MIN_RATE
        @assert length(body) == header.len
        return OfpQueuePropMinRate(header, body[9:end])
    elseif header.propert == OFPQT_NONE
        @assert length(body) == 8
        return OfpQueuePropNone(header)
    else
        throw(UnknownQueueProperty())
    end
end
function nextqueueprop(body::Bytes)
    header::OfpQueuePropHeader = OfpQueuePropHeader(body[1:8])
    (OfpQueuePropFactory(body[1:8 + header.len]), length(body) > 8 + header.len ?
        body[8 + header.len + 1:end] : nothing)
end
function OfpQueueProps(body::Bytes)
    props = Array(OfpQueueProp, 1)
    bdy = body
    while bdy != nothing
        (prop::OfpQueueProp, bdy) = nextqueueprop(bdy)
        append(props, [prop])
    end
    props
end
# Min-Rate queue property description. 
immutable OfpQueuePropMinRate <: OfpQueueProp
    header::OfpQueuePropHeader # prop: OFPQT_MIN_RATE, len: 16.
    rate::Uint16 # In 1/10 of a percent; >1000 -> disabled.
    pad::Bytes # Length 6; 64-bit alginment.
    OfpQueuePropMinRate(header, rate::Uint16) = begin
        @assert header.msgtype == OFPQT_MIN_RATE
        new(header, rate, zeros(Uint8, 6))
    end
end
#function OfpQueuePropMinRate(header::OfpQueuePropHeader, body::Bytes)
#    @assert header.property == OFPQT_MIN_RATE
#    @assert header.len == 16
#    OfpQueuePropMinRate(btoui(body))
#end
@length OfpQueuePropMinRate
@bytes OfpQueuePropMinRate
@string OfpQueuePropMinRate
# XXX bytesconstructor
#@bytesconstructor OfpQueuePropMinRate [:pad=>6]
#give_length(queuepropminrate::OfpQueuePropMinRate) =
#    queuepropminrate.header.len
#function bytes(propminrate::OfpQueuePropMinRate)
#    byts::Bytes = zeros(Uint8, give_length(propminrate))
#    byts[1:8] = bytes(propminrate.header)
#    byts[9:10] = bytes(rate)
#    byts
#end
# Full description for a queue.
# TODO Consider making these kinds of types generic by parameterizing with
# abstract types used in collections as fields. In this type this would amount
# to parameterizing for OfpQueueProp. Probably parameterizing the whole type
# would be a bad idea, but at least providing conversion would be good.
# Promotion and conversion rules? Only the constructor should be parameterized,
# then there need to be conversion rules for collections of concrete types of
# OfpQueueProp. Then conversion rules will convert in the respective
# constructors.
immutable OfpPacketQueue <: OfpStruct
    queue_id::Uint32 # id for the specific queue.
    len::Uint16 # Length in bytes of this queue desc.
    pad::Bytes # Length: 2; 64-bit alignment.
    properties::Vector{OfpQueueProp} # List of properties. XXX The spec lists
        # OfpQueuePropHeader as type of properties. Probably however the list is
        # not supposed to only contain the headers but also the full properties. 
    OfpPacketQueue(queue_id::Uint32, len::Uint16,
        properties::Vector{OfpQueueProp}) = new(queue_id, len, zeros(Uint8, 2),
        properties)
end
@length OfpPacketQueue
@bytes OfpPacketQueue
@string OfpPacketQueue
#give_length(queue::OfpPacketQueue) = 8 + give_length(queue.properties)
#function give_length(qs::Vector{OfpPacketQueue})
#    len = 0
#    for q in queues
#        len += give_length(q)
#    end
#    len
#end
#function bytes(queue::OfpPacketQueue)
#    byts::Bytes = zeros(Uint8, give_length(queue))
#    byts[1:4] = bytes(queue.queue_id)
#    byts[5:6] = bytes(queue.len)
#    byts[9:end] = bytes(queue.properties)
#    byts
#end
#function bytes(qs::Vector{OfpPacketQueue})
#    byts::Bytes = zeros(Uint8, give_length(qs))
#    pos = 1
#    for q in qs
#        bs = bytes(q)
#        len = length(bs)
#        byts[pos:pos+len-1] = bs
#        pos += len
#    end
#    byts
#end
function OfpPacketQueue(body::Bytes)
    OfpPacketQueue(btoui(body[1:4], btoui(body[5:6]),
        OfpQueueProps(body[9:end])))
end
function nextpacketqueue(body::Bytes)
    qlen = btoui(body[5:6])
    (OfpPacketQueue(body[1:qlen]), length(body) > qlen ?
        body[qlen + 1:end] : nothing)
end
function OfpPacketQueues(body::Bytes)
    pqs = Array(OfpPacketQueue, 1)
    bdy = body
    while bdy != nothing
        (pq::OfpPacketQueue, bdy) = nextpacketqueue(bdy)
        append(pqs, [pq])
    end
    pqs
end
# Queue configuration for a given port.
# ofp_queue_get_config_reply
immutable OfpQueueGetConfigReply <: OfpMessage
    port::Uint16 
    pad::Bytes # Length 6;
    queues::Vector{OfpPacketQueue} # List of configured queues.
    header::OfpHeader
    # This one is for when we are creating this message to be sent.
    function OfpQueueGetConfigReply(port::Uint16, queues::Vector{OfpPacketQueue})
        configreply = new(port, zeros(Uint8, 6), queues)
        len = give_length(configreply)
        configreply.header = OfpHeader(OFPT_GET_CONFIG_REPLY, uint16(len))
        configreply
    end
    # This one is for when we are assembling the message from bytes.
    function OfpQueueGetConfigReply(port, queues, header)
        configreply = new(port, zeros(Uint8, 6), queues, header)
        len = give_length(configreply)
        @assert header.msglen == len
        @assert header.msgtype == OFPT_GET_CONFIG_REPLY
        configreply
    end
end
OfpQueueGetConfigReply(header::OfpHeader, body::Bytes) = new(btoui(body[1:2]), OfpPacketQueues(body[9:end]), header)
@bytes OfpQueueGetConfigReply
@length OfpQueueGetConfigReply
@string OfpQueueGetConfigReply
#give_length(configreply::OfpQueueGetConfigReply) = give_length(OfpHeader) + 8 + give_length(configreply.queues)
#function bytes(configreply::OfpQueueGetConfigReply)
#    byts::Bytes = zeros(Uint8, give_length(configreply))
#    byts[1:8] = bytes(configreply.header)
#    byts[9:10] = bytes(configreply.port)
#    byts[17:end] = bytes(configreply.queues)
#    byts
#end
immutable OfpError <: OfpMessage
    header::OfpHeader
    typ::Uint16 # Should be "type", which however is a keyword in Julia.
    code::Uint16 
    data::Bytes # ASCII text for OFPET_HELLO FAILED, at least 64 bytes of the
        # failed request for OFP_BAD_REQUEST CODE, OFP_BAD_ACTION_CODE, 
        # OFP_FLOW_MOD_FAILED_CODE, OFP_PORT_MOD_FAILED_CODE or
        # OFPET_QUEUE_OP_FAILED.
    # TODO Constructor that ensures the invariants.
end
function OfpError(header::OfpHeader, body::Bytes)
    OfpError(header, # header.
        btoui(body[1:2]), # (e)type.
        btoui(body[3:4]), # code.
        body[5:end] # data.
    )
end
@bytes OfpError
@length OfpError
@string OfpError
# bytesconstructor
#@bytesconstructor OfpError
import Base.string
function string(error::OfpError)
    # XXX Solve this in a nicer way. Using reflection, or a dictionary or
    # anything, but hard coding.
    typestr = if error.typ == OFPET_HELLO_FAILED
        "OFPET_HELLO_FAILED"
    elseif error.typ == OFPET_BAD_REQUEST
        "OFPET_BAD_REQUEST"
    elseif error.typ == OFPET_BAD_ACTION
        "OFPET_BAD_ACTION"
    elseif error.typ == OFPET_FLOW_MOD_FAILED
        "OFPET_FLOW_MOD_FAILED"
    elseif error.typ == OFPET_PORT_MOD_FAILED
        "OFPET_PORT_MOD_FAILED"
    elseif error.typ == OFPET_QUEUE_OP_FAILED
        "OFPET_QUEUE_OP_FAILED"
    else
        throw(UnrecognizedErrorType(error))
    end
    codestr = if error.code == OFPBRC_BAD_VERSION
        "OFPBRC_BAD_VERSION"
    elseif error.code == OFPBRC_BAD_TYPE
        "OFPBRC_BAD_TYPE"
    elseif error.code == OFPBRC_BAD_STAT
        "OFPBRC_BAD_STAT"
    elseif error.code == OFPBRC_BAD_VENDOR
        "OFPBRC_BAD_VENDOR"
    elseif error.code == OFPBRC_BAD_SUBTYPE
        "OFPBRC_BAD_SUBTYPE"
    elseif error.code == OFPBRC_EPERM
        "OFPBRC_EPERM"
    elseif error.code == OFPBRC_BAD_LEN
        "OFPBRC_BAD_LEN"
    elseif error.code == OFPBRC_BUFFER_EMPTY
        "OFPBRC_BUFFER_EMPTY"
    elseif error.code == OFPBRC_BUFFER_UNKNOWN
        "OFPBRC_BUFFER_UNKNOWN"
    else
        throw(UnrecognizedErrorCode(error))
    end
    str::String = "<header: $(string(error.header)), type:
        $(typestr)($(error.typ)), code: $(codestr)($(error.code)), data:
        $(error.data)>"
    str
end
type UnrecognizedErrorType <: Exception
    error::OfpError
end
type UnrecognizedErrorCode <: Exception
    error::OfpError
end
# Description of physical port
immutable OfpPhyPort <: OfpStruct
    port_no::Uint16
    hw_addr::Bytes # length of array: OFP_MAX_ETH_ALEN
    name::Bytes # Null-terminated. Length: OFP_MAX_PORT_NAME_LEN.
    config::Uint32 # Bitmap of OFPC_* flags.
    state::Uint32 # Bitmap of OFPS_* flas.
    # Bitmaps of OFPPF_* that describe features. All bits zeroed if unsupported
    # or unavailable.
    curr::Uint32 # Current features.
    advertised::Uint32 # Features being advertised by the port.
    supported::Uint32 # Features supported by the port.
    peer::Uint32 # Features advertised by peer.
    OfpPhyPort(port_no, hw_addr, name, config, state, curr, advertised,
        supported, peer) = begin
        @assert length(hw_addr) == OFP_MAX_ETH_ALEN
        @assert length(name) == OFP_MAX_PORT_NAME_LEN
        new(port_no, hw_addr, name, config, state, curr, advertised, supported,
            peer)
    end
end
#OfpPhyPort(bytes::Bytes) = begin
#    # XXX make this more legible somehow?
#    port_no = btoui(bytes[1:2])
#    hw_addr = bytes[3:3+OFP_MAX_ETH_ALEN-1]
#    name = bytes[3+OFP_MAX_ETH_ALEN:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN-1]
#    config = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN:
#                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 4 - 1])
#    state = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 4:
#                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 8 - 1])
#    curr = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 8:
#                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 12 - 1])
#    advertised = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 12:
#                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 16 - 1])
#    supported = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 16:
#                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 20 - 1])
#    peer = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 20:
#                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 24 - 1])
#    OfpPhyPort(port_no, hw_addr, name, config, state, curr, advertised,
#                supported, peer)
#end
# give_length(port::Type{OfpPhyPort}) = 26 + OFP_MAX_ETH_ALEN + OFP_MAX_PORT_NAME_LEN
@length OfpPhyPort
@string OfpPhyPort
@bytes OfpPhyPort
@bytesconstructor OfpPhyPort [:hw_addr=>OFP_MAX_ETH_ALEN, :name=>OFP_MAX_PORT_NAME_LEN]
# Switch features
immutable OfpSwitchFeatures <: OfpMessage
    header::OfpHeader
    datapath_id::Uint64 # Datapath unique ID. The lower 48-bits are for a MAC
                        # address, while the upper 16 bits are implementer-defined
    n_buffers::Uint32 # Max packets buffered at once
    n_tables::Uint8 # Number of tables supported by datapath
    pad::Bytes # Length 3; Align to 64 bits
    capabilities::Uint32 # Bitmap of supported "ofp_capabilities"
    actions::Uint32 # Bitmap of supported "ofp_action_types"
    ports::Vector{OfpPhyPort} # Port definitions. The number of ports is
                            # inferred from the length field in the header.
    OfpSwitchFeatures(header::OfpHeader, datapath_id::Uint64, n_buffers::Uint32,
        n_tables::Uint8, capabilities::Uint32, actions::Uint32,
        ports::Vector{OfpPhyPort}) = new(header, datapath_id, n_buffers,
        n_tables, zeros(Uint8, 3), capabilities, actions, ports)
end
OfpSwitchFeatures(header::OfpHeader, body::Bytes) = begin
    # XXX write the array of ports should be created by its own function that
    # takes the corresponding octects
    # compute the number of ports
    numports = uint16((header.msglen - 8 - 24)/48) # len(OfpPhyPort) == 48
    ports::Vector{OfpPhyPort} = Array(OfpPhyPort, numports)
    for p = 1:numports
        ports[p] = OfpPhyPort(body[25 + (p - 1)*48:25 + p*48 - 1])
    end
    OfpSwitchFeatures(header, btoui(body[1:8]), btoui(body[9:12]), body[13],
                btoui(body[17:20]), btoui(body[21:24]), ports)
end
@bytes OfpSwitchFeatures
@length OfpSwitchFeatures
@string OfpSwitchFeatures
# XXX bytesconstructor
#@bytesconstructor OfpSwitchFeatures [:pad=>3]
#give_length(features::OfpSwitchFeatures) = begin
#    len = give_length(OfpHeader) + 16 
#    for port in features.ports
#        len += give_length(OfpPhyPort)
#    end
#    len
#end
#string(msg::OfpSwitchFeatures) = begin
#    str = "<header: $(tostring(msg.header)), datapath_id: $(msg.datapath_id), n_buffers: $(msg.n_buffers), n_tables: $(msg.n_tables), capabilities: $(msg.capabilities), actions: $(msg.actions), ports: $(msg.ports)>"
#end
# Switch configuration
immutable OfpSwitchConfig <: OfpMessage
    header::OfpHeader
    flags::Uint16 # OFPC_* flags.
    miss_send_len::Uint16 # Max bytes of new flow that datapath should send to
                            # the controller
    OfpSwitchConfig(header, flags, miss_send_len) = begin 
        @assert header.msgtype == OFPT_GET_CONFIG_REQUEST || header.msgtype ==
            OFPT_GET_CONFIG_REPLY
        new(header, flags, miss_send_len)
    end
end
#OfpSwitchConfig(header::OfpHeader, body::Bytes) =
#                OfpSwitchConfig(header, btoui(body[1:2]), btoui(body[3:4]))
@bytes OfpSwitchConfig
@length OfpSwitchConfig
@string OfpSwitchConfig
@bytesconstructor OfpSwitchConfig
# XXX why does lead to an error that seems completely unrelated to the following line?
#convert(::Type{ASCIIString}, msg::OfpSwitchConfig) = println("Someone just invoked the conversion")
#tostring(msg::OfpSwitchConfig) = begin
#    str = "<flags: $(msg.flags), miss_send_len: $(msg.miss_send_len)>"
#end
#give_length(switchconig::Type{OfpSwitchConfig}) = give_length(OfpHeader) + 4
# Flow match structures
immutable OfpMatch <: OfpStruct
    wildcards::Uint32 # Wildcards fields
    in_port::Uint16 # Input switch port.
    dl_src::Bytes # Length: OFP_MAX_ETH_ALEN; Ethernet source address.
    dl_dst::Bytes # Length: OFP_MAX_ETH_ALEN; Ehternet destination address.
    dl_vlan::Uint16 # Input VLAN id.
    dl_vlan_pcp::Uint8 # Input VLAN priority.
    pad1::Uint8 # Align to 64 bits.
    dl_type::Uint16 # Ethernet frame type.
    nw_tos::Uint8 # IP ToS (actually DSCP field, 6 bits).
    nw_proto::Uint8 # IP protocol or lower 8 bits of ARP opcode.
    pad2::Bytes # Length: 2; Algin to 64 bits.
    nw_src::Uint32 # IP source address.
    nw_dst::Uint32 # IP destination address.
    tp_src::Uint16 # TCP/UDP source port.
    tp_dst::Uint16 # TCP/UDP destination port.
    # XXX Is it better to use type annotations on constructors, which will
    # probably lead to a not method error, which is hard to read or to create a
    # catch all constructor, which will probably throw an error about a specific
    # type mismatch (no conversion)?
    OfpMatch(wildcards, in_port, dl_src, dl_dst, dl_vlan, dl_vlan_pcp, dl_type,
        nw_tos, nw_proto, nw_src, nw_dst, tp_src, tp_dst) = new(wildcards,
        in_port, dl_src, dl_dst, dl_vlan, dl_vlan_pcp, 0x00, dl_type,
        nw_tos, nw_proto, b"\x00\x00", nw_src, nw_dst, tp_src, tp_dst)
end
#OfpMatch(body::Bytes) = OfpMatch(
#    btoui(body[1:4]), # wildcards
#    btoui(body[5:6]), # in_port
#    # XXX the spec (1.0.0) says it should be OFP_MAX_ETH_ALEN, but never defines
#    # it. The text actually refers to OFP_MAX_ETH_ALEN, so I am replacing the
#    # constant in the followin accordingly.
#    body[7:7 + OFP_MAX_ETH_ALEN - 1], # dl_src
#    body[7 + OFP_MAX_ETH_ALEN : 7 + 2OFP_MAX_ETH_ALEN - 1], # dl_dst
#    btoui(body[7 + 2OFP_MAX_ETH_ALEN:7 + 2OFP_MAX_ETH_ALEN + 1]), # dl_vlan
#    body[7 + 2OFP_MAX_ETH_ALEN + 2], # dl_vlan_pcp
#    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 4:7 + 2OFP_MAX_ETH_ALEN + 5]), # dl_type
#    body[7 + 2OFP_MAX_ETH_ALEN + 6], # nw_tos
#    body[7 + 2OFP_MAX_ETH_ALEN + 7], # nw_proto
#    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 10:7 + 2OFP_MAX_ETH_ALEN + 13]), # nw_src
#    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 14:7 + 2OFP_MAX_ETH_ALEN + 17]), # nw_dst
#    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 18:7 + 2OFP_MAX_ETH_ALEN + 19]), # tp_src
#    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 20:7 + 2OFP_MAX_ETH_ALEN + 21]) # tp_dst
#)
@bytes OfpMatch
@length OfpMatch
@string OfpMatch
@bytesconstructor OfpMatch [:pad2=>2, :dl_src=>OFP_MAX_ETH_ALEN, :dl_dst=>OFP_MAX_ETH_ALEN]
#give_length(match::Type{OfpMatch}) = 2OFP_MAX_ETH_ALEN + 28
#function bytes(match::OfpMatch)
#    byts::Bytes = zeros(Uint8, give_length(OfpMatch))
#    byts[1:4] = bytes(match.wildcards)
#    byts[5:6] = bytes(match.in_port)
#    byts[7:7 + OFP_MAX_ETH_ALEN - 1] = match.dl_src
#    byts[7 + OFP_MAX_ETH_ALEN : 7 + 2OFP_MAX_ETH_ALEN - 1] = match.dl_dst
#    byts[7 + 2OFP_MAX_ETH_ALEN:7 + 2OFP_MAX_ETH_ALEN + 1] = bytes(match.dl_vlan)
#    byts[7 + 2OFP_MAX_ETH_ALEN + 2] = bytes(match.dl_vlan_pcp)
#    byts[7 + 2OFP_MAX_ETH_ALEN + 3:7 + 2OFP_MAX_ETH_ALEN + 4] =
#        bytes(match.dl_type)
#    byts[7 + 2OFP_MAX_ETH_ALEN + 5] = match.nw_tos
#    byts[7 + 2OFP_MAX_ETH_ALEN + 6] = match.nw_proto
#    byts[7 + 2OFP_MAX_ETH_ALEN + 7:7 + 2OFP_MAX_ETH_ALEN + 10] =
#        bytes(match.nw_src)
#    byts[7 + 2OFP_MAX_ETH_ALEN + 11:7 + 2OFP_MAX_ETH_ALEN + 14] =
#        bytes(match.nw_dst)
#    byts[7 + 2OFP_MAX_ETH_ALEN + 15:7 + 2OFP_MAX_ETH_ALEN + 16] =
#        bytes(match.tp_src)
#    byts[7 + 2OFP_MAX_ETH_ALEN + 17:7 + 2OFP_MAX_ETH_ALEN + 18] =
#        bytes(match.tp_dst)
#    byts
#end
# XXX Using the naming from the spec. It is not really a header but rather
# something of a supertype for all actions. OfpAction would be a more suitable
# name.
abstract OfpActionHeader <: OfpStruct
# TODO Probably it would be best to add methods to Base.length for all the
    # special types. => rename all give_length methods to be methods of
    # Base.length or whichever the standard length function is.
#give_length(action::OfpActionHeader) = action.len 
#function bytes(action::OfpActionHeader)
#    byts::Bytes = zeros(Uint8, give_length(action))
#    byts[1:2] = bytes(action.typ)
#    byts[3:4] = bytes(action.len)
#    # subbytes start after the length field
#    byts[5:end] = subbytes(action)
#    byts
#end
#function bytes(actions::Vector{OfpActionHeader})
#    blen = 0
#    # TODO Use map and summaton.
#    for a in actions
#        blen += give_length(a)
#    end
#    byts::Bytes = zeros(Uint8, blen)
#    # TODO Functional style?
#    pos = 1
#    for a in actions
#        abyts = bytes(a)
#        alen = length(abyts)
#        byts[pos:pos + alen - 1] = abyts
#        pos += alen
#    end
#    byts
#end
#function give_length(actions::Vector{OfpActionHeader})
#    len = 0
#    # XXX This could be done more elegantly by combingin map and sum.
#    for a in actions
#        len += give_length(a)
#    end
#    len
#end
function OfpActionHeaderFactory(body::Bytes)
    typ::Uint16 = btoui(body[1:2])
    if typ == OFPAT_OUTPUT
        return OfpActionOutput(body)
    elseif typ == OFPAT_ENQUEUE
        return OfpActionEnqueue(body)
    elseif typ == OFPAT_SET_VLAN_VID
        return OfpActionVlanVid(body)
    elseif typ == OFPAT_SET_VLAN_PCP
        return OfpActionVlanPcp(body)
    elseif typ == OFPAT_SET_DL_SRC || typ == OFPAT_SET_DL_DST
        return OfpActionDlAddress(body)
    elseif typ == OFPAT_SET_NW_SRC || typ == OFPAT_SET_NW_DST
        return OfpActionNwAddress(body)
    elseif typ == OFPAT_SET_NW_TOS
        return OfpActionNwTos(body)
    elseif typ == OFPAT_SET_TP_SRC || typ == OFPAT_SET_TP_DST
        return OfpActionTpPort(body)
    elseif typ == OFPAT_VENDOR
        return OfpActionVendor(body)
    elseif typ == OFPAT_STRIP_VLAN
        return OfpActionEmpty(body)
    end
end
function nextactionheader(body::Bytes)
    len = btoui(body[3:4])
    (OfpActionHeaderFactory(body[1:len]), length(body) > len ? body[len + 1:end]
        : nothing)
end
function OfpActionHeaders(body::Bytes)
    actions::Vector{OfpActionHeader} = Array(OfpActionHeader, 0)
    bdy = body
    while bdy != nothing
        (action, bdy) = nextactionheader(bdy)
        actions = [actions, action]
    end
    actions
end
immutable OfpActionEmpty <: OfpActionHeader
    typ::Uint16 # OFPAT_STRIP_VLAN. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 4.
end
#OfpActionEmpty(body::Bytes) = OfpActionEmtpy(btoui(body[1:2], btoui(body[3:4])))
@bytes OfpActionEmpty
@length OfpActionEmpty
@string OfpActionEmpty
@bytesconstructor OfpActionEmpty
#function bytes(act::OfpActionEmpty)
#    byts::Bytes = zeros(Uint8, 4)
#    byts[1:2] = bytes(act.typ)
#    byts[3:4] = bytes(act.len)
#    byts
#end
immutable OfpActionOutput <: OfpActionHeader
    typ::Uint16 # OFPAT_OUTPUT. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    port::Uint16 # Output port.
    max_len::Uint16 # Max length to send to the controller.
    OfpActionOutput(typ, len, port, max_len) = begin
        @assert typ == OFPAT_OUTPUT
        @assert len == 8
        new(typ, len, port, max_len)
    end
end
#function OfpActionOutput(body::Bytes)
#    typ::Uint16 = btoui(body[1:2])
#    len::Uint16 = btoui(body[3:4])
#    port::Uint16 = btoui(body[5:6])
#    max_len::Uint16 = btoui(body[7:8])
#    OfpActionOutput(typ, len, port, max_len)
#end
@bytes OfpActionOutput
@length OfpActionOutput
@string OfpActionOutput
@bytesconstructor OfpActionOutput
#function subbytes(action::OfpActionOutput)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1:2] = bytes(action.port)
#    byts[3:4] = bytes(action.max_len)
#    byts
#end
immutable OfpActionEnqueue <: OfpActionHeader
    typ::Uint16 # OFPAT_ENQUEUE. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    port::Uint16 # Port that queue belongs to. Should refer to a vlid physical
        # port (i.e. < OFPP_MAX) or OFPP_IN_PORT.
    pad::Bytes # Length: 6 bytes for 64-bit alignment
    queue_id::Uint32 # Where to enqueue the packets.
    OfpActionEnqueue(typ, len, port, queue_id) = begin
        @assert typ == OFPAT_ENQUEUE
        @assert len == 16
        new(typ, len, port, zeros(Uint8, 6), queue_id)
    end
end
#function OfpActionEnqueue(body::Bytes)
#    typ::Uint16 = btoui(body[1:2])
#    len::Uint16 = btoui(body[3:4])
#    port::Uint16 = btoui(body[5:6])
#    queue_id::Uint32 = btoui(body[13:16])
#    OfpActionEnqueue(typ, len, port, queue_id)
#end
@bytes OfpActionEnqueue
@length OfpActionEnqueue
@string OfpActionEnqueue
@bytesconstructor OfpActionEnqueue [:pad=>6]
#function subbytes(action::OfpActionEnqueue)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1:2] = bytes(action.port)
#    byts[end-3:end] = bytes(action.queue_id)
#    byts
#end
immutable OfpActionVlanVid <: OfpActionHeader
    typ::Uint16 # OFPAT_OUTPUT. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    vlan_vid::Uint16 # VLAN id.
    pad::Bytes # Length: 2 bytes for 64-bit alignment
    OfpActionVlanVid(typ, len, vlan_vid) = begin
        @assert typ == OFPAT_SET_VLAN_VID
        @assert len == 8
        new(typ, len, vlan_vid, zeros(Uint8, 2))
    end
end
#function OfpActionVlanVid(body::Bytes)
#    typ::Uint16 = btoui(body[1:2])
#    len::Uint16 = btoui(body[3:4])
#    vlan_vid::Uint16 = btoui(body[5:6])
#    OfpActionVlanVid(typ, len, vlan_vid)
#end
@bytes OfpActionVlanVid
@length OfpActionVlanVid
@string OfpActionVlanVid
@bytesconstructor OfpActionVlanVid [:pad=>2]
#function subbytes(action::OfpActionVlanVid)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1:2] = bytes(action.vlan_vid)
#    byts
#end
immutable OfpActionVlanPcp <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_VLAN_PCP. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    vlan_pcp::Uint8 # VLAN priority.
    pad::Bytes # Length: 3
    OfpActionVlanPcp(typ, len, vlan_pcp) = begin
        @assert typ == OFPAT_SET_VLAN_PCP
        @assert len == 8
        new(typ, len, vlan_pcp, zeros(Uint8, 3))
    end
end
#function OfpActionVlanPcp(body::Bytes)
#    typ::Uint16 = btoui(body[1:2])
#    len::Uint16 = btoui(body[3:4])
#    vlan_pcp::Uint8 = btoui(body[5])
#    OfpActionVlanPcp(typ, len, vlan_pcp)
#end
@bytes OfpActionVlanPcp
@length OfpActionVlanPcp
@string OfpActionVlanPcp
@bytesconstructor OfpActionVlanPcp [:pad=>3]
#function subbytes(action::OfpActionVlanPcp)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1] = bytes(action.vlan_vid)
#    byts
#end
# Exception for message constructors which rely on providing the right constant
# as message type.
type WrongMessageType <: Exception
end
# Excpetion thrown if the constructor arguments do not satisfy some invariance
# constraints.
type MessageInvarianceException <: Exception
end
# OFPAT_SET_DL_SRC/DST
immutable OfpActionDlAddress <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_DL_SRC/DST. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    dl_addr::Bytes # Length: OFP_MAX_ETH_ALEN; Ethernet address.
    pad::Bytes # Length: 6
    OfpActionDlAddress(typ, len, dl_addr) = begin
        @assert typ == OFPAT_SET_DL_SRC || typ == OFPAT_SET_DL_DST
        @assert length(dl_addr) == OFP_MAX_ETH_ALEN
        new(typ, len, dl_addr, zeros(Uint8, 6))
    end
end
function OfpActionDlAddress(body::Bytes)
    typ::Uint16 = btoui(body[1:2])
    len::Uint16 = btoui(body[3:4])
    dl_addr::Bytes = btoui(body[5:5 + OFP_MAX_ETH_ALEN - 1])
    OfpActionDlAddress(typ, len, dl_addr)
end
@bytes OfpActionDlAddress
@length OfpActionDlAddress
@string OfpActionDlAddress
#function subbytes(action::OfpActionDlAddress)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1:OFP_MAX_ETH_ALEN] = bytes(action.dl_addr)
#    @assert length(byts) - OFP_MAX_ETH_ALEN == 6
#    byts
#end
# OFPAT_SET_NW_SRC/DST
immutable OfpActionNwAddress <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_NW_SRC/DST. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    nw_addr::Uint32 # IP address.
    OfpActionNwAddress(typ, len, nw_addr) = begin
        @assert typ == OFPAT_SET_NW_SRC || typ == OFPAT_SET_NW_DST
        @assert len == 8
        new(typ, len, nw_addr)
    end
end
#function OfpActionNwAddress(body::Bytes)
#    typ::Uint16 = btoui(body[1:2])
#    len::Uint16 = btoui(body[3:4])
#    nw_addr::Uint32 = btoui(body[5:8])
#    OfpActionNwAddress(typ, len, nw_addr)
#end
@bytes OfpActionNwAddress
@length OfpActionNwAddress
@string OfpActionNwAddress
@bytesconstructor OfpActionNwAddress
#function subbytes(action::OfpActionNwAddress)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1:4] = bytes(action.nw_addr)
#    @assert length(byts) - 4 == 0
#    byts
#end
# OFPAT_SET_NW_TOS
immutable OfpActionNwTos <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_NW_TOS. XXX Accroding to spec it should be "type",
                # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    nw_tos::Uint8 # IP ToS (DSCP field, 6 bits).
    pad::Bytes # Length 3.
    OfpActionNwTos(typ, len, nw_tos) = begin
        @assert typ == OFPAT_SET_NW_TOS
        @assert len == 8
        new(typ, len, nw_tos, zeros(Uint8, 3))
    end
end
@bytes OfpActionNwTos
@length OfpActionNwTos
@string OfpActionNwTos
@bytesconstructor OfpActionNwTos [:pad=>3]
#function subbytes(action::OfpActionNwTos)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1] = action.nw_tos
#    @assert length(byts) - 1 == 3
#    byts
#end
# OFPAT_TP_PORT
immutable OfpActionTpPort <: OfpStruct
    typ::Uint16 # OFPAT_SET_TP_SRC/DST. XXX Accroding to spec it should be "type",
                # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    tp_port::Uint16 # TCP/UDP port.
    pad::Bytes # Length 2.
    OfpActionNwTos(typ, len, tp_port) = begin
        if typ != OFPAT_SET_TP_SRC && typ != OFPAT_SET_TP_DST
            throw(WrongMessageType())
        end
        @assert typ == OFPAT_SET_TP_SRC || typ == OFPAT_SET_TP_DST
        @assert len == 8
        new(typ, len, tp_port, zeros(Uint8, 2))
    end
end
#function OfpActionTpPort(body::Bytes)
#    typ::Uint16 = btoui(body[1:2])
#    len::Uint16 = btoui(body[3:4])
#    tp_port::Uint16 = btoui(body[5:6])
#    OfpActionTpPort(typ, len, tp_port)
#end
@bytes OfpActionTpPort
@length OfpActionTpPort
@string OfpActionTpPort
@bytesconstructor OfpActionTpPort [:pad=>2]
#function subbytes(action::OfpActionTpPort)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1:2] = bytes(action.tp_port)
#    @assert length(byts) - 1 == 2
#    byts
#end
# OFPAT_VENDOR
immutable OfpActionVendor <: OfpStruct
    typ::Uint16 # OFPAT_VENDOR. XXX Accroding to spec it should be "type",
                # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    vendor::Uint32 # Vendor ID, which takes the same form as in OfpVendorHeader.
    body::Bytes # Vendor-specific extension.
    OfpActionVendorHeader(vendor::Uint32, body::Bytes) = new(OFPAT_VENDOR,
        uint16(8 + length(body)), vendor, body)
end
function OfpActionVendor(body::Bytes)
    typ::Uint16 = btoui(body[1:2])
    len::Uint16 = btoui(body[3:4])
    vendor::Uint32 = btoui(body[5:8])
    bdy::Bytes = body[9:end]
    OfpActionVendor(typ, len, vendor, bdy)
end
@bytes OfpActionVendor
@length OfpActionVendor
@string OfpActionVendor
#function subbytes(action::OfpActionVendor)
#    byts::Bytes = zeros(Uint8, give_length(action) - 4)
#    byts[1:4] = bytes(action.vendor)
#    bytes[5:end] = action.body
#    @assert length(byts) - 1 == 0
#    byts
#end
# Packet in messages
immutable OfpPacketIn <: OfpMessage
    header::OfpHeader 
    buffer_id::Uint32 # ID assigned by datapath.
    total_len::Uint16 # Full length of frame.
    in_port::Uint16 # Port on which frame was received.
    reason::Uint8 # Reason packet is being sent (one of OFPR_*).
    pad::Uint8
    data::Bytes  # Ethernet frame, halfway through 32-bit word, so the
                           # IP header is 32-bit aligned. The amount of data is inferred from the length
                           # field in the header. Because of padding, offsetof(struct ofp_packet_in,
                           # data) == sizeof(struct ofp_packet_in) - 2.
    OfpPacketIn(header, buffer_id, total_len, in_port, reason, data) = begin
        @assert header.msglen == OFPT_PACKET_IN
        new(header, buffer_id, total_len, in_port, reason, 0x00, data)
    end
end
#tostring(msg::OfpPacketIn) = "<header: $(tostring(msg.header)), buffer_id:
#    $(msg.buffer_id), total_len: $(msg.total_len), in_port: $(msg.in_port), reason:
#    $(msg.reason), data: $(msg.data)>"
OfpPacketIn(header::OfpHeader, body::Bytes) = begin
    datalen = length(body) - 10
    data = zeros(Uint8, datalen)
    for i = 1:datalen
        data[i] = body[11 + i - 1]
    end
    OfpPacketIn(header, btoui(body[1:4]), btoui(body[5:6]), btoui(body[7:8]), body[9], data)
end
@bytes OfpPacketIn
@length OfpPacketIn
@string OfpPacketIn
#@bytesconstructor OfpPacketIn
# Port status messages
immutable OfpPortStatus <: OfpMessage
    header::OfpHeader
    reason::Uint8 # One of OFPPR_*
    pad::Bytes # length: 7; Align to 64 bits
    desc::OfpPhyPort
    OfpPortStatus(header, reason, desc) = begin
        @assert header.msgtype == OFPT_PORT_STATUS
        new(header, reason, zeros(Uint8, 7), desc)
    end
end
#OfpPortStatus(header::OfpHeader, body::Bytes) = OfpPortStatus(header, body[1], OfpPhyPort(body[17:64]))
@bytes OfpPortStatus
@length OfpPortStatus
@string OfpPortStatus
# XXX bytesconstructor
#@bytesconstructor OfpPortStatus [:pad=>7]
#give_length(portstatus::Type{OfpPortStatus}) = give_length(OfpHeader) + 8 +
#    give_length(OfpPhyPort)
# Modify StateMessages
# Flow setup and teardown (controller -> datapath)
# XXX try to make the type immutable again --> resolve incomplete initialization
# for immutable type.
type OfpFlowMod <: OfpMessage
    # NB: the header is first in the message. We just moved it to the end to
    # allow for incomplete initialization!
    match::OfpMatch # Fields to match
    cookie::Uint64 # Opaque controller-issued identifier.
    # Flow actions.
    command::Uint16 # One of OFPFC_*.
    idle_timeout::Uint16 # Idle time before discarding (seconds).
    hard_timeout::Uint16 # Max time before discarding (seconds).
    priority::Uint16 # Priority level of flow entry.
    buffer_id::Uint32 # Buffered packet to apply to (or -1). Not meaningful for OFPFC_DELETE*.
    out_port::Uint16 # For OFPFC_DELETE* commands, require matching entries to
                        # include this as an output port. A value of OFPP_NONE indicates no
                        # restriction.
    flags::Uint16 # One of OFPFF_*.
    actions::Vector{OfpActionHeader} # The action length is inferred from the
                                        # length field in the header.
    header::OfpHeader
    # Since the header needs to contain the length of the whole message, the
    # messages are kind of self-referential. Thus we first create an unfinished
    # object that is missing the header, then we obtain its length, which is
    # independent of the header's actual instance, then we instantiate the
    # header with the correct result. I love coding.
    # XXX Apparently this does not work with an immutable type, even in the
    # constructor. Now I need to make the type mutable. I hate coding.
    OfpFlowMod(match::OfpMatch, cookie::Uint64, command::Uint16,
        idle_timeout::Uint16, hard_timeout::Uint16, priority::Uint16,
        buffer_id::Uint32, out_port::Uint16, flags::Uint16,
        actions::Vector{OfpActionHeader}) = begin
            # Create the partially initialized object.
            flowmod = new(match, cookie, command, idle_timeout, hard_timeout,
                priority, buffer_id, out_port, flags, actions) 
            # Get its length and create the corresponding header.
            header::OfpHeader = OfpHeader(OFPT_FLOW_MOD,
                t16(give_length(flowmod)))
            flowmod.header = header
            flowmod
    end
    # TODO A constructor that takes the header for creating this message from
    # bytes.
end
@bytes OfpFlowMod
@length OfpFlowMod
@string OfpFlowMod
# XXX bytesconstructor
#@bytesconstructor OfpFlowMod
#give_length(flowmod::OfpFlowMod) = give_length(OfpHeader) + give_length(OfpMatch) + 24 + give_length(flowmod.actions)
# XXX Just as reading the length it should be possible to serialize messages
# seamlessly and automaically using the fields. Some metaprogramming maybe?
#bytes(flowmod::OfpFlowMod) = begin
#    matchlen = give_length(OfpMatch)
#    byts::Bytes = zeros(Uint8, flowmod.header.msglen)
#    byts[1:8] = bytes(flowmod.header)
#    byts[9:9+matchlen-1] = bytes(flowmod.match)
#    byts[9+matchlen:9+matchlen+8-1] = bytes(flowmod.cookie)
#    byts[9+matchlen+8:9+matchlen+10-1] = bytes(flowmod.command)
#    byts[9+matchlen+10:9+matchlen+12-1] = bytes(flowmod.idle_timeout)
#    byts[9+matchlen+12:9+matchlen+14-1] = bytes(flowmod.hard_timeout)
#    byts[9+matchlen+14:9+matchlen+16-1] = bytes(flowmod.priority)
#    byts[9+matchlen+16:9+matchlen+20-1] = bytes(flowmod.buffer_id)
#    byts[9+matchlen+20:9+matchlen+22-1] = bytes(flowmod.out_port)
#    byts[9+matchlen+22:9+matchlen+24-1] = bytes(flowmod.flags)
#    actionbytes = bytes(flowmod.actions)
#    byts[9+matchlen+24:end] = actionbytes
#    byts
#end
immutable OfpPortMod <: OfpMessage
    header::OfpHeader
    port_no::Uint16
    hw_addr::Bytes # Length: OFP_MAX_ETH_ALEN. The hardware address is not
        # configurable. This is used to sanity-check the request, so it must be the
        # same as returned in an ofp_phy_port struct.
    config::Uint32 # Bitmap of OFPPC_* flags.
    mask::Uint32 # Bitmap of OFPPC_* flags to be changed.
    advertise::Uint32 # Bitmap of "ofp_port_feature"s. Zero all bits to prevent
                        # any action taking place.
    pad::Bytes # Length 4. Pad to 64-bits.
    OfpPortMod(header, port_no, hw_addr, config, mask, advertise) = begin
        @assert header.msgtype == OFPT_PORT_MOD
        @assert header.msglen == length(OfpPortMod)
        new(header, port_no,
            hw_addr, config, mask, advertise, zeros(Uint8, 4))
    end
end
@bytes OfpPortMod
@length OfpPortMod
@string OfpPortMod
#give_length(portmod::OfpPortMod) = give_length(portmod.header) + 16 +
#    OFP_MAX_ETH_ALEN
#function bytes(portmod::OfpPortMod)
#    byts::Bytes = zeros(Uint8, give_length(portmod))
#    byts[1:8] = bytes(portmod.header)
#    byts[9:10] = bytes(portmod.port_no)
#    byts[11:11 + OFP_MAX_ETH_ALEN - 1] = portmod.hw_addr
#    byts[11 + OFP_MAX_ETH_ALEN:11 + OFP_MAX_ETH_ALEN + 3] = portmod.config
#    byts[11 + OFP_MAX_ETH_ALEN + 4:11 + OFP_MAX_ETH_ALEN + 7] = portmod.mask
#    byts[11 + OFP_MAX_ETH_ALEN + 8:11 + OFP_MAX_ETH_ALEN + 11] =
#        portmod.advertise
#    byts
#end
immutable OfpEmptyMessage <: OfpMessage
    header::OfpHeader
end
@bytes OfpEmptyMessage
@length OfpEmptyMessage
@string OfpEmptyMessage
@bytesconstructor OfpEmptyMessage
#give_length(empty::Type{OfpEmptyMessage}) = give_length(OfpHeader)

type UnrecognizedMessageError <: Exception
end

# New types that will be used to bundle the body-types for
# ofp_stat_request. Furthermore it will serve for parameterizing
# OfpStatsRequest.
abstract OfpStatsRequestBody <: OfpStruct
# ofp_stat_reply. Furthermore it will serve for parameterizing
# OfpStatsReply.
abstract OfpStatsReplyBody <: OfpStruct
# Body of reply to OFPST_DESC request. Each entry is a NULL-terminated ASCII
# string.
immutable OfpDescStats <: OfpStatsReplyBody
    # Strings are zero-padded to the left with '\0'
    mfr_desc::Bytes # Length: DESC_STR_LEN; Manufacturer description.
    hw_desc::Bytes # Length: DESC_STR_LEN; Hardware description.
    sw_desc::Bytes # Length: DESC_STR_LEN; Software description.
    serial_num::Bytes # Length: SERIAL_NUM_LEN; Serial number.
    dp_desc::Bytes # Length: DESC_STR_LEN; Human readable description of
        # datapath.
end
@bytes OfpDescStats
@length OfpDescStats
@string OfpDescStats
@bytesconstructor OfpDescStats [:mfr_desc=>DESC_STR_LEN, :hw_desc=>DESC_STR_LEN, :sw_desc=>DESC_STR_LEN, :serial_num=>SERIAL_NUM_LEN, :dp_desc=>DESC_STR_LEN]
#function OfpDescStats(body::Bytes)
#    mfr_desc::Bytes = body[1:DESC_STR_LEN]
#    hw_desc::Bytes = body[DESC_STR + 1:2DESC_STR_LEN]
#    sw_desc::Bytes = body[2DESC_STR + 1:3DESC_STR_LEN]
#    serial_num::Bytes = 
#        body[3DESC_STR + 1:3DESC_STR_LEN + SERIAL_NUM_LEN]
#    dp_desc::Bytes = 
#        body[3DESC_STR + SERIAL_NUM_LEN + 1:4DESC_STR_LEN + SERIAL_NUM_LEN]
#    OfpDescStats(mfr_desc, hw_desc, sw_desc, serial_num, dp_desc)
#end
#give_length(::Type{OfpDescStats}) = 4DESC_STR_LEN + SERIAL_NUM_LEN
# Body for ofp_stats_request for type OFPST_FLOW.
immutable OfpFlowStatsRequest <: OfpStatsRequestBody
    match::OfpMatch # Fields to match.
    table_id::Uint8 # ID of table to read (from ofp_table_stats), 0xff for all
        # tables or 0xfe for emergency. 
    pad::Uint8 # Align to 32-bits.
    out_port::Uint16 # Require matching entries to include this as an output
        # port. A value of OFPP_NONE indicates no restriction. 
    OfpFlowStatsRequest(match, table_id, out_port) = new(match, table_id, 0x00,
        out_port)
end
@bytes OfpFlowStatsRequest
@length OfpFlowStatsRequest
@string OfpFlowStatsRequest
# XXX bytesconstructor
#@bytesconstructor OfpFlowStatsRequest
#function bytes(statsreq::OfpFlowStatsRequest)
#    byts::Bytes = zeros(Uint8, give_length(statsreq))
#    byts[1:40] = bytes(statsreq.match)
#    byts[41] = statsreq.table_id
#    byts[43:44] = statsreq.out_port
#    byts
#end
#give_length(::Type{OfpFlowStatsRequest}) = give_length(OfpMatch) + 4
# Body of reply to OFPST_FLOW request.
immutable OfpFlowStats <: OfpStatsReplyBody
    length::Uint16 # Length of this entry.
    table_id::Uint8 # ID of table flow came from.
    pad::Uint8
    match::OfpMatch # Description of fields.
    duration_sec::Uint32 # Time flow has been alive in seconds.
    duration_nsec::Uint32 # Time flow has been alive in nanoseconds byeond
        # duration_sec.
    priority::Uint16 # Priority of the entry. Only meaningful when this is not
        # an exact-match entry.
    idle_timeout::Uint16 # Number of seconds idle before expiration.
    hard_timeout::Uint16 # Number of secondsbefore expiration.
    pad::Bytes # Length: 6; Align to 64-bits.
    cookie::Uint64 # Opaque controller-issued identifier.
    packet_count::Uint64 # Number of packets in flow.
    byte_count::Uint64 # Number of bytes in flow.
    actions::Vector{OfpActionHeader} # Actions.
    OfpFlowStats(length, table_id, match, duration_sec, duration_nsec, priority,
        idle_timeout, hard_timeout, cookie, packet_count, byte_count, actions) = 
        new(length, table_id, 0x00, match, duration_sec, duration_nsec, priority,
        idle_timeout, hard_timeout, zeros(Uint8, 6), cookie, packet_count, byte_count, actions)
end
@bytes OfpFlowStats
@length OfpFlowStats
@string OfpFlowStats
#give_length(flowstats::OfpFlowStats) = 48 + give_length(OfpMatch) + give_length(flowstats.actions)
function OfpFlowStats(body::Bytes)
    length::Uint16 = btoi(body[1:2])
    table_id::Uint8 = body[3]
    match::OfpMatch = OfpMatch(body[5:44])
    duration_sec::Uint32 = btoui(body[45:48])
    duration_nsec::Uint32 = btoui(body[49:52])
    priority::Uint16 = btoui(body[53:54])
    idle_timeout::Uint16 = btoui(body[55:56])
    hard_timeout::Uint16 = btoui(body[57:58])
    cookie::Uint64 = btoui(body[65:72])
    packet_count::Uint64 = btoui(body[73:80])
    byte_count::Uint64 = btoui(body[81:88])
    actions::Vector{OfpActionHeader} = OfpActionHeaders(body[89:end])
    OfpFlowStats(length, table_id, match, duration_sec, duration_nsec, priority,
        idle_timeout, hard_timeout, cookie, packet_count, byte_count, actions)
end

# Body for ofp_stats_request of type OFPST_AGGREGATE
immutable OfpAggregateStatsRequest <: OfpStatsRequestBody
    match::OfpMatch # Fields to match.
    table_id::Uint8 # ID of table to read (from ofp_table_stats). 0xff for all
        # tables or 0xfe for emergency. 
    # pad::Uint8 Align to 32 bits.
    out_port::Uint16 # Require matching entries to include this as an output
        # port. A value of OFPP_ONE indicates no restriction.
end
@bytes OfpAggregateStatsRequest
@length OfpAggregateStatsRequest
@string OfpAggregateStatsRequest
# XXX bytesconstructor
#@bytesconstructor OfpAggregateStatsRequest
#give_length(::Type{OfpAggregateStatsRequest}) = give_length(OfpMatch) + 4
#function bytes(req::OfpAggregateStatsRequest)
#    byts::Bytes = zeros(Uint8, give_length(OfpAggregateStatsRequest))
#    byts[1:40] = bytes(req.match)
#    byts[41] = req.table_id
#    byts[43:44] = bytes(out_port)
#    byts
#end

# Body of reply to OFPST_AGGREGATE request.
immutable OfpAggregateStatsReply <: OfpStatsReplyBody
    packet_count::Uint64 # Number of packets in flows.
    byte_count::Uint64 # Number of bytes in flows. 
    flow_count::Uint32 # Number of flows.
    pad::Bytes # Length: 4; Align to 64 bits.
    OfpAggregateStatsReply(packet_count, byte_count, flow_count) =
        new(packet_count, byte_count, flow_count, zeros(Uint8, 4))
end
@bytes OfpAggregateStatsReply
@length OfpAggregateStatsReply
@string OfpAggregateStatsReply
@bytesconstructor OfpAggregateStatsReply [:pad=>4]
#give_length(::Type{OfpAggregateStatsReply}) = 24
#function OfpAggregateStatsReply(body::Bytes)
#   packet_count::Uint64 = btoui(body[1:8])
#    byte_count::Uint64 = btoui(body[9:16])
#    flow_count::Uint32 = btoui(body[17:20])
#    OfpAggregateStatsReply(packet_count, byte_count, flow_count)
#end

# Body of reply to OFPST_TABLE request.
immutable OfpTableStats <: OfpStatsReplyBody
    table_id::Uint8 # Identifier of table. Lower numbered tables are consulted
        # first.
    pad::Bytes # Length: 3; Align to 32-bits.
    name::Bytes # Length: OFP_MAX_TABLE_NAME_LEN
    wildcards::Uint32 # Bitmap of OFPFW_* wildcards that are supported by the
        # table.
    max_entries::Uint32 # Max number of entries supported.
    active_count::Uint32 # Number of active entries.
    lookup_count::Uint64 # Number of packets looked up in table.
    matched_count::Uint64 # Number of packets that hit table.
    OfpTableStats(table_id, name, wildcards, max_entries, active_count,
        lookup_count, matched_count) = new(table_id, zeros(Uint8, 3), name,
        wildcards, max_entries, active_count, lookup_count, matched_count)
end
@bytes OfpTableStats
@length OfpTableStats
@string OfpTableStats
#give_length(::Type{OfpTableStats}) = 32 + OFP_MAX_TABLE_NAME_LEN
function OfpTableStats(body::Bytes)
    table_id::Uint8 = btoui(body[1:2])
    name::Bytes = body[3:3 + OFP_MAX_TABLE_NAME_LEN - 1]
    wildcards::Uint32 = 
        btoui(body[3 + OFP_MAX_TABLE_NAME_LEN : 3 + OFP_MAX_TABLE_NAME_LEN + 4 - 1])
    max_entries::Uint32 = 
        btoui(body[3 + OFP_MAX_TABLE_NAME_LEN + 4 : 3 + OFP_MAX_TABLE_NAME_LEN + 8 - 1])
    active_count::Uint32 = 
        btoui(body[3 + OFP_MAX_TABLE_NAME_LEN + 8 : 3 + OFP_MAX_TABLE_NAME_LEN + 12 - 1])
    lookup_count::Uint64 = 
        btoui(body[3 + OFP_MAX_TABLE_NAME_LEN + 12 : 3 + OFP_MAX_TABLE_NAME_LEN + 20 - 1])
    matched_count::Uint64 = 
        btoui(body[3 + OFP_MAX_TABLE_NAME_LEN + 20 : 3 + OFP_MAX_TABLE_NAME_LEN + 28 - 1])
    OfpTableStats(table_id, name, wildcards, max_entries, active_count,
        lookup_count, matched_count)
end

# Body for ofp_stats_request of type OFPST_PORT.
immutable OfpPortStatsRequest <: OfpStatsRequestBody
    port_no::Uint16 # OFPST_PORT message must request statistics either for a
        #single port (specified in port_no) or for all ports (if port_no ==
        # OFPP_NONE).
    pad::Bytes # Length: 6
    OfpPortStatsRequest(port_no) = new(port_no, zeros(Uint8, 6))
end
@bytes OfpPortStatsRequest
@length OfpPortStatsRequest
@string OfpPortStatsRequest
@bytesconstructor OfpPortStatsRequest [:pad=>6]
#give_length(::Type{OfpPortStatsRequest}) = 8
#OfpPortStatsRequest(body::Bytes) = OfpPortStatsRequest(btoui(body[1:2]))
#function bytes(req::OfpPortStatsRequest)
#    byts::Bytes = zeros(Uint8, give_length(req))
#    byts[1:2] = bytes(req.port_no)
#    byts
#end

# Body of reply to OFPST_PORT request. If a counter is unsupported, set the
# field to all ones.
immutable OfpPortStats <: OfpStatsReplyBody
    port_no::Uint16
    pad::Bytes # Length: 6; Align to 64-bits.
    rx_packets::Uint64 # Number of received packets.
    tx_packets::Uint64 # Number of transmitted packets.
    rx_bytes::Uint64 # Number of received bytes.
    tx_bytes::Uint64 # Number of transmitted bytes.
    rx_dropped::Uint64 # Number of packets dropped by RX.
    tx_dropped::Uint64 # Number of packets dropped by TX.
    rx_errors::Uint64 # Number of receive errors. This is a super-set of more
        # specific receive errors and should be greater than or equal to the sum
        # of all rx_*_err values.
    tx_errors::Uint64 # Number of transmit errors . Thsi is a super-set of more
        # specific transmit errors and should be greater than or equal to the
        # sum of all tx_*_err values (none currently defined.)
    rx_frame_err::Uint64 # Number of frame alignment errors.
    rx_over_err::Uint64 # Number of packets with RX overrun.
    rx_crc_err::Uint64 # Number of CRC errors.
    collisions::Uint64 # Number of collisions.
    OfpPortStats(port_no, rx_packets, tx_packets, rx_bytes, tx_bytes,
        rx_dropped, tx_dropped, rx_errors, tx_errors, rx_frame_err, rx_over_err,
        rx_crc_err, collisions) = new(port_no, zeros(Uint8, 6), rx_packets,
        tx_packets, rx_bytes, tx_bytes, rx_dropped, tx_dropped, rx_errors,
        tx_errors, rx_frame_err, rx_over_err, rx_crc_err, collisions)
end
@bytes OfpPortStats
@length OfpPortStats
@string OfpPortStats
@bytesconstructor OfpPortStats [:pad=>6]

immutable OfpQueueStatsRequest <: OfpStatsRequestBody
    # TODO OFPT_ALL and OFPQ_ALL are nowhere defined yet.
    port_no::Uint16 # All ports if OFPT_ALL.
    pad::Bytes # Length:2; Align to 32-bits.
    queue_id::Uint32 # All queues if OFPQ_ALL.
    OfpQueueStatsRequest(port_no, queue_id) = new(port_no, zeros(Uint8, 2),
        queue_id)
end
@bytes OfpQueueStatsRequest
@length OfpQueueStatsRequest
@string OfpQueueStatsRequest
@bytesconstructor OfpQueueStatsRequest [:pad=>2]

immutable OfpQueueStats <: OfpStatsReplyBody
    port_no::Uint16
    pad::Bytes # Length: 2; Align to 32-bits.
    queue_id::Uint32 # Queue id.
    tx_bytes::Uint64 # Number of transmitted bytes.
    tx_packets::Uint64 # Number of transmitted packets.
    tx_errors::Uint64 # Number of packets dropped due to overrun.
    OfpQueueStats(port_no, queue_id, tx_bytes, tx_packets, tx_errors) =
        new(port_no, zeros(Uint8, 2), queue_id, tx_bytes, tx_packets, tx_errors)
end
@bytes OfpQueueStats
@length OfpQueueStats
@string OfpQueueStats
@bytesconstructor OfpQueueStats [:pad=>2]

immutable OfpVendorStatsRequest <: OfpStatsRequestBody
    vendor_id::Bytes # Length: 4
    body::Bytes # The rest of the message is vendor-defined.
end
@bytes OfpVendorStatsRequest
@length OfpVendorStatsRequest
@string OfpVendorStatsRequest

immutable OfpVendorStatsReply <: OfpStatsReplyBody
    vendor_id::Bytes # Length: 4
    body::Bytes # The rest of the message is vendor-defined.
end
@bytes OfpVendorStatsReply
@length OfpVendorStatsReply
@string OfpVendorStatsReply

# ofp_stats_request
immutable OfpStatsRequest{T<:OfpStatsRequestBody} <: OfpMessage
    header::OfpHeader
    typ::Uint16 # One of the OFPST_* constants.
    flags::Uint16 # OFPSF_REQ_* flags (none yet defined).
    body::T  # Body of the request.
end
@bytes OfpStatsRequest
@length OfpStatsRequest
@string OfpStatsRequest
# XXX bytesconstructor
#@bytesconstructor OfpStatsRequest

# ofp_stats_reply
immutable OfpStatsReply{T<:OfpStatsReplyBody} <: OfpMessage
    header::OfpHeader
    typ::Uint16 # One of the OFPST_* constants.
    flags::Uint16 # OFPSF_REPLY_* flags.
    body::T # Body of the reply.
end
@bytes OfpStatsReply
@length OfpStatsReply
@string OfpStatsReply
# XXX bytesconstructor
#@bytesconstructor OfpStatsReply

# ofp_packet_out
# Send packet (controller -> datapath).
immutable OfpPacketOut <: OfpMessage
    header::OfpHeader
    buffer_id::Uint32 # ID assigned by datapath (-1 if none).
    in_port::Uint16 # Packet's input port (OFPP_NONE if none).
    actions_len::Uint16 # Size of action array in bytes.
    actions::Vector{OfpActionHeader} # Actions.
    # data::Bytes XXX For some reason this is commented out in the spec.
end
@bytes OfpPacketOut
@length OfpPacketOut
@string OfpPacketOut

# Flow removed (datapath -> controller).
# ofp_flow_removed
immutable OfpFlowRemoved <: OfpMessage
    header::OfpHeader
    match::OfpMatch # 
    cookie::Uint64 # 
    priority::Uint16 # Priority level of flow entry.
    reason::Uint8 # One of OFPRR_*.
    pad::Uint8 # Align to 32-bits.
    duration_sec::Uint32 # Time flow was alive in seconds.
    duration_nsec::Uint32 # Time flow was alive in nanoseconds beyond
        # duration_sec.
    idle_timeout::Uint16 # Idle timeout from original flow mod.
    pad2::Bytes # Length:2; Align to 64-bits.
    packet_count::Uint64
    byte_count::Uint64
    OfpFlowRemoved(header, match, cookie, priority, reason, duration_sec,
        duration_nsec, idle_timeout, packet_count, byte_count) = begin
        @assert header.msgtype == OFPT_FLOW_REMOVED
        new(header, match, cookie, priority, reason, 0x00, duration_sec,
            duration_nsec, idle_timeout, zeros(Uint8, 2), packet_count, byte_count)
    end
end
@bytes OfpFlowRemoved
@length OfpFlowRemoved
@string OfpFlowRemoved
# XXX bytesconstructor
#@bytesconstructor OfpFlowRemoved

# Vendor extension.
# ofp_vendor_header
immutable OfpVendorHeader <: OfpMessage
    header::OfpHeader # Type OFPT_VENDOR
    vendor::Uint32 # Vendor ID:
                    # - MSB 0: low-order bytes are IEEE OUI.
                    # - MSB != 0: defined by OpenFlow consortium.
    body::Bytes # Vendor-defined arbitrary additional data.
    OfpVendorHeader(header, vendor, body) = begin
        @assert header.msgtype == OFPT_VENDOR
        @assert header.msglen == 12 + length(body)
        new(header, vendor, body)
    end
end
@bytes OfpVendorHeader
@length OfpVendorHeader
@string OfpVendorHeader

function processrequest(message::OfpMessage, socket::TcpSocket)
    try
        if message.header.msgtype == OFPT_HELLO
            info("Got HELLO, replying HELLO")
            # XXX how does the msgidx work?
            write(socket, bytes(OfpHeader(OFPT_HELLO, 0x0008)))
            info("Sending FEATURES_REQUEST")
            write(socket, bytes(OfpHeader(OFPT_FEATURES_REQUEST, 0x0008)))
            info("Sending GET_CONFIG_REQUEST")
            write(socket, bytes(OfpHeader(OFPT_GET_CONFIG_REQUEST, 0x0008)))
        elseif message.header.msgtype == OFPT_FEATURES_REPLY
            # TODO convert the body to a proper body type and output the contents
            info("Got FEATURES_REPLY: $(string(message))")
        elseif message.header.msgtype == OFPT_ECHO_REQUEST
            info("Got ECHO_REQUEST, replying ECHO_REPLY")
            write(socket, bytes(OfpHeader(OFPT_ECHO_REPLY, 0x0008)))
        elseif message.header.msgtype == OFPT_GET_CONFIG_REPLY
            info("Got GET_CONFIG_REPLY: $(string(message))")
        elseif message.header.msgtype == OFPT_PACKET_IN
            info("Got PACKET_IN: $(string(message))")
            # Assuming we just got the ARP request from host 1
            # TODO send a message to forward broadcasts
            write(socket, bytes(create_arp_request_flowmod(message.buffer_id)))
        elseif message.header.msgtype == OFPT_ERROR
            warn("Got ERROR: $(string(message))")
        end
    catch e
        Base.error_show(STDERR, e, catch_backtrace())
        error("Processing message of type <$(message.header.msgtype)> failed: $e")
    end
end

function assemblemessage(header::OfpHeader, body::Bytes)
    # determine the message type first
    if header.msgtype == OFPT_HELLO
        assert(length(body) == 0)
        return OfpEmptyMessage(header)
    elseif header.msgtype == OFPT_ECHO_REQUEST
        assert(length(body) == 0)
        return OfpEmptyMessage(header)
    elseif header.msgtype == OFPT_FEATURES_REPLY
        return OfpSwitchFeatures(header, body)
    elseif header.msgtype == OFPT_GET_CONFIG_REPLY
        return OfpSwitchConfig(header, body)
    elseif header.msgtype == OFPT_PACKET_IN
        return OfpPacketIn(header, body)
    elseif header.msgtype == OFPT_ERROR
        return OfpError(header, body)
    else
        warn("Got an unrecognized message of type $(header.msgtype), which I am ignoring")
        #throw(UnrecognizedMessageError())
    end
end

function create_arp_request_flowmod(buffer_id::Uint32)
    actions::Vector{OfpActionHeader} = Array(OfpActionHeader, 1)
    actions[1] = OfpActionOutput(
        OFPP_ALL, # Port.
        0x0100 # max_len.
    )
    OfpFlowMod(
        OfpMatch(
            uint32(OFPFW_ALL), # Wildcards fields
            0x0000, # Input switch port.
            zeros(Uint8, OFP_MAX_ETH_ALEN), # Length: OFP_MAX_ETH_ALEN; Ethernet source address.
            zeros(Uint8, OFP_MAX_ETH_ALEN), # Length: OFP_MAX_ETH_ALEN; Ehternet destination address.
            uint16(0), # Input VLAN id.
            uint8(0), # Input VLAN priority.
            0x0806, # Ethernet frame type.
            0x08, # IP ToS (actually DSCP field, 6 bits).
            0x01, # IP protocol or lower 8 bits of ARP opcode.
            0x00000000, # IP source address.
            0x00000000, # IP destination address.
            0x0000, # TCP/UDP source port.
            0x0000 # TCP/UDP destination port.
        ), # OfpMatch
        uint64(0), # cookie
        uint16(OFPFC_ADD), # command
        uint16(60), # idle_timeout; XXX What is a good/default value here?
        uint16(60), # hard_timeout; XXX What is a good/default value here?
        uint16(0), # priority
        uint32(buffer_id), # buffer_id; The buffer id is set based on the
            # corresponding value in PACKET_IN
        uint16(OFPP_ALL), # out_port.
        uint16(OFPFF_SEND_FLOW_REM), # flags.
        actions # actions.
    )
end

type UnexpectedIntLength <: Exception
end
# XXX there must be something like this somewhere in Julia's API
# utility functions for assembling bytes to Uints
# TODO how about writing "convert" methods for this?
function btoui(bytes::Bytes)
    blen = length(bytes)
    # Why? Because I can. The ternary operator is right associative btw.
    ui = blen == 1 ? bytes[1] : blen == 2 ? uint16(0) : blen == 4 ?
        uint32(0) : blen == 8 ? uint64(0) : throw(UnexpectedIntLength())
    for i = 1:blen
        ui |= convert(typeof(ui), bytes[i]) << 8(i-1)
    end
    ntoh(ui)
end
function start_server(port = 6633)
	server = listen(port)
	@async begin
		while true
			socket = accept(server)
			@async begin
                while true
                    # read the header
                    header::OfpHeader = readofpheader(socket)
                    # read the body
                    msgbody = read(socket, Uint8, header.msglen - 8)
                    # assemble the corresponding message
                    message::OfpMessage = assemblemessage(header, msgbody)
                    # handle the message
                    processrequest(message, socket)
                end
			end
		end
	end
end

function sendhello()
    info("Sending HELLO")
    sock = connect(6633)
    write(sock, bytes(OfpHeader(OFPT_HELLO, 0x0008)))
end

# XXX DEBUG
start_server()
end

