module OpenFlow
# TODO Parallel version.
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
        assert(length(body) == 0)
        return OfpEmptyMessage(header)
    elseif header.msgtype == OFPT_ERROR
        return OfpError(header, body)
    elseif header.msgtype == OFPT_ECHO_REQUEST
        assert(length(body) == 0)
        return OfpEmptyMessage(header)
    elseif header.msgtype == OFPT_ECHO_REPLY
        return OfpEmptyMessage(header)
    elseif header.msgtype == OFPT_VENDOR
        return OfpVendorHeader(header, body)
    elseif header.msgtype == OFPT_FEATURES_REQUEST
        return OfpEmptyMessage(header)
    elseif header.msgtype == OFPT_FEATURES_REPLY
        return OfpSwitchFeatures(header, body)
    elseif header.msgtype == OFPT_GET_CONFIG_REQUEST
        return OfpEmptyMessage(header)
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
        return OfpEmptyMessage(header)
    elseif header.msgtype == OFPT_BARRIER_REPLY
        return OfpEmptyMessage(header)
    elseif header.msgtype == OFPT_QUEUE_GET_CONFIG_REQUEST
        return OfpQueueGetConfigRequest(header, body)
    elseif header.msgtype == OFPT_QUEUE_GET_CONFIG_REPLY
        return OfpQueueGetConfigReply(header, body)
    else
        warn("Got an unrecognized message of type $(header.msgtype).")
    end
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

function start_server(msghandler::Function, port = 6633)
	server = listen(port)
	@async begin
		while true
			socket = accept(server)
			@async begin
                let socket = socket
                    while true
                        # read the header
                        header::OfpHeader = readofpheader(socket)
                        # read the body
                        msgbody = read(socket, Uint8, header.msglen - 8)
                        # TODO Probably we should create another task per read
                        # message here. Actually this task should run in another
                        # process, assemble the message, prepare the responses and
                        # return here. 
                        # assemble the corresponding message
                        message::OfpMessage = assemblemessage(header, msgbody)
                        # handle the message
                        responses = msghandler(message, socket)
                        for r in responses
                            write(socket, bytes(r))
                        end
                    end
                end
			end
		end
	end
end

include("incl/exports.jl")
end

