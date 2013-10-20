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

module OpenFlow
# TODO Write a macro that prints infos only in debug mode.
# TODO Controller-initiated messages.
# TODO Use the improved bytesconstructor macro on the types that require
# factory methods.
# TODO Break down the large macros into functions.
# TODO Convenience constructors to expose via API without header creation.
# TODO Promotion for type creation or at least generic external constructors.
# TODO License
# TODO Command line interface.
# TODO TLS
# TODO Dictionary for the constants for pretty printing.
# TODO Use get/setfield() for field access.
# TODO Use rpad when creating strings to be converted to Bytes. Actually combine
# rpad and ascii.
# TODO Document the core code.
# TODO How to disable all of the potentially slowing assertions when running in production?
# TODO Extend @string to provide show method.
# TODO Try out using hex2bytes(hex(Int)) and the other way round for
# (de)serialization.

include("incl/constants.jl")

# We will be using a lot of byte/octect arrays here
typealias Bytes Vector{Uint8}

bytes(byts::Bytes) = byts
function bytes(ui::Uint8)
    [ui]
end
bytes(s::ASCIIString) = Uint8[int(c) for c in s]
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
include("incl/macros.jl")
include("incl/ofptypes.jl")

function assemblemessage(header::OfpHeader, body::Bytes)
    if header.msgtype == OFPT_HELLO
        if length(body) != 0 
            return nothing
        else
            return OfpEmptyMessage(header)
        end
    elseif header.msgtype == OFPT_ERROR
        return OfpError(header, body)
    elseif header.msgtype == OFPT_ECHO_REQUEST
        if length(body) != 0 
            return nothing
        else
            return OfpEmptyMessage(header)
        end
    elseif header.msgtype == OFPT_ECHO_REPLY
        if length(body) != 0 
            return nothing
        else
            return OfpEmptyMessage(header)
        end
    elseif header.msgtype == OFPT_VENDOR
        if length(body) != 0 
            return nothing
        else
            return OfpVendorHeader(header, body)
        end
    elseif header.msgtype == OFPT_FEATURES_REQUEST
        if length(body) != 0 
            return nothing
        else
            return OfpEmptyMessage(header)
        end
    elseif header.msgtype == OFPT_FEATURES_REPLY
        return OfpSwitchFeatures(header, body)
    elseif header.msgtype == OFPT_GET_CONFIG_REQUEST
        if length(body) != 0 
            return nothing
        else
            return OfpEmptyMessage(header)
        end
    elseif header.msgtype == OFPT_GET_CONFIG_REPLY
        return OfpSwitchConfig(header, body)
    elseif header.msgtype == OFPT_SET_CONFIG
        return OfpSwitchConfig(header, body)
    elseif header.msgtype == OFPT_PACKET_IN
        return OfpPacketIn(header, body)
    elseif header.msgtype == OFPT_FLOW_REMOVED
        return OfpFlowRemoved(header, body)
    elseif header.msgtype == OFPT_PORT_STATUS
        return OfpPortStatus(header, body)
    elseif header.msgtype == OFPT_PACKET_OUT
        return OfpPacketOut(header, body)
    elseif header.msgtype == OFPT_FLOW_MOD
        return OfpFlowMod(header, body)
    elseif header.msgtype == OFPT_PORT_MOD
        return OfpPortMod(header, body)
    elseif header.msgtype == OFPT_STATS_REQUEST
        return OfpStatsRequest(header, body)
    elseif header.msgtype == OFPT_STATS_REPLY
        return OfpStatsReply(header, body)
    elseif header.msgtype == OFPT_BARRIER_REQUEST
        if length(body) != 0 
            return nothing
        else
            return OfpEmptyMessage(header)
        end
    elseif header.msgtype == OFPT_BARRIER_REPLY
        if length(body) != 0 
            return nothing
        else
            return OfpEmptyMessage(header)
        end
    elseif header.msgtype == OFPT_QUEUE_GET_CONFIG_REQUEST
        return OfpQueueGetConfigRequest(header, body)
    elseif header.msgtype == OFPT_QUEUE_GET_CONFIG_REPLY
        return OfpQueueGetConfigReply(header, body)
    else
        return nothing
    end
end

type UnexpectedIntLength <: Exception
end
# XXX there must be something like this somewhere in Julia's API
# utility functions for assembling bytes to Uints
# TODO how about writing "convert" methods for this?
function btoui(b1::Uint8, b2::Uint8, b3::Uint8, b4::Uint8, b5::Uint8, b6::Uint8,
    b7::Uint8, b8::Uint8)
    ui::Uint64 = uint64(0)
    ui |= b1
    ui = ui << 8
    ui |= b2
    ui = ui << 8
    ui |= b3
    ui = ui << 8
    ui |= b4
    ui = ui << 8
    ui |= b5
    ui = ui << 8
    ui |= b6
    ui = ui << 8
    ui |= b7
    ui = ui << 8
    ui |= b8
    ui
end
function btoui(b1::Uint8, b2::Uint8, b3::Uint8, b4::Uint8)
    ui::Uint32 = uint32(0)
    ui |= b1
    ui = ui << 8
    ui |= b2
    ui = ui << 8
    ui |= b3
    ui = ui << 8
    ui |= b4
    ui
end
function btoui(b1::Uint8, b2::Uint8)
    ui::Uint16 = uint16(0)
    ui |= b1
    ui = ui << 8
    ui |= b2
    ui
end
btoui(b1::Uint8) = b1

function seek_next_header(sock::TcpSocket)
    v::Uint8 = 0xff
    while true
        v = read(sock, Uint8, 1)[1]
        if v == 0x01
            t = read(sock, Uint8, 1)[1]
            if 0x00 <= t <= 0x15
                l = ntoh(read(sock, Uint16, 1)[1])
                if l >= 0x0008
                    i = ntoh(read(sock, Uint32, 1)[1])
                    return OfpHeader(v, t, l, i)
                end
            end
        end
    end
end

function start_server(msghandler::Function, port = 6633)
    info("Julia SDN server is up and running.")
	server = listen(port)
    # XXX Probably it would be a good idead to set this dynamically based on the
    # number of sockets and the amount of available memory.
    max_buf = 1024*1024*8
    @sync begin
        @async begin
            while true
                socket = accept(server)
                socket.line_buffered = false
                info("Created a new socket: $(hash(socket))")
                @async begin
                    begin
                        let socket = socket
                            while true
                                try
                                    waiting = nb_available(socket.buffer)
                                    if waiting > max_buf
                                        read(socket, Uint8, waiting)
                                    end
                                    # read the header
                                    header::OfpHeader = seek_next_header(socket)
                                    # read the body
                                    msgbody = read(socket, Uint8, header.msglen - 8)
                                    # assemble the corresponding message
                                    message::Union(OfpMessage, Nothing) = assemblemessage(header, msgbody)
                                    if message != nothing
                                        # handle the message
                                        responses::Vector{OfpMessage} = msghandler(message, hash(socket))
                                        for r in responses
                                            write(socket, bytes(r))
                                        end
                                    end
                                catch e
                                    if isa(e, EOFError)
                                        break
                                    end
                                end
                                yield()
                            end
                        end
                    end
                end
            end
        end
    end
end

include("incl/exports.jl")
end

