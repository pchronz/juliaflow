module OpenFlow
# TODO Tests
# TODO API
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
#start_server()

include("incl/exports.jl")
end

