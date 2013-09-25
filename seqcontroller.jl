require("of-controller.jl")
module SequentialController
using OpenFlow

# Catch-all message handler.
function processrequest!(message::OfpMessage, socket::TcpSocket)
    warn("Got a message for which there is no processing rule: $(string(message))")
end

# OfpQueueGetConfigRequest
function processrequest!(msg::OfpQueueGetConfigRequest, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_QUEUE_GET_CONFIG_REQUEST
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    elseif msg.header.msgtype == OFPT_QUEUE_GET_CONFIG_REPLY
        info("Got OFPT_QUEUE_GET_CONFIG_REPLY")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        info(string(msg))
    end
    resp
end

# OfpQueueGetConfigReply
function processrequest!(msg::OfpQueueGetConfigReply, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_QUEUE_GET_CONFIG_REPLY
        info("Got OFPT_QUEUE_GET_CONFIG_REPLY")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        info(string(msg))
    end
    resp
end

# OfpError
function processrequest!(msg::OfpError, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_ERROR
        warn("Got ERROR: $(string(msg))")
        warn(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpSwitchFeatures
function processrequest!(msg::OfpSwitchFeatures, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_FEATURES_REQUEST
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    elseif msg.header.msgtype == OFPT_FEATURES_REPLY
        info("Got OFPT_FEATURES_REPLY")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpSwitchConfig
function processrequest!(msg::OfpSwitchConfig, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_GET_CONFIG_REQUEST
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    elseif msg.header.msgtype == OFPT_SET_CONFIG
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    elseif msg.header.msgtype == OFPT_GET_CONFIG_REPLY
        info("Got OFPT_GET_CONFIG_REPLY")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# Known locations. (DL_addr=>Port)
# OfpPacketIn
function processrequest!(msg::OfpPacketIn, socket::TcpSocket)
    extractl2(frame::Bytes) = begin
        # dl_src, dl_dst, dl_type
        frame[1:6], frame[7:12], btoui(frame[13:14])
    end
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PACKET_IN
        info("Got OFPT_PACKET_IN")
        info(string(msg))
        table = tables[socket]
        dl_dst, dl_src, dl_type = extractl2(msg.data)
        dl_src_ui = btoui(append!(zeros(Uint8, 2), dl_src))
        dl_dst_ui = btoui(append!(zeros(Uint8, 2), dl_dst))
        # Do we know the source? If not store it in the controller.
        if !haskey(table, dl_src_ui)
            # Add dl_src to the local table and add a flow entry.
            table[dl_src_ui] = msg.in_port
        elseif table[dl_src_ui] != msg.in_port
            warn("DL_ADDR $(dl_src) has moved from port $(table[dl_src_ui]) to $(msg.in_port)")
            table[dl_src_ui] = msg.in_port
            # TODO update the flow entry.
            # TODO remove the old flow entry.
        end
        # Do we know the destination? If yes create a flow, if not flood.
        if haskey(table, dl_dst_ui)
            match = OfpMatch(
                OFPFW_ALL $ (OFPFW_DL_SRC | OFPFW_DL_DST),
                0x0000,
                dl_src,
                dl_dst,
                0x0000,
                0x00,
                0x0000,
                0x00,
                0x00,
                uint32(0),
                uint32(0),
                0x0000,
                0x0000
            )
            actions = OfpActionHeader[OfpActionOutput(
                OFPAT_OUTPUT,
                0x0008,
                table[dl_dst_ui],
                0x0060
            )]
            flomod = OfpFlowMod(
                OfpHeader(OFPT_FLOW_MOD),
                match,
                uint64(0),
                OFPFC_ADD,
                FLOW_IDLE_TIMEOUT,
                FLOW_HARD_TIMEOUT,
                0x8000,
                msg.buffer_id,
                OFPP_NONE,
                OFPFF_SEND_FLOW_REM,
                actions
            )
            push!(resp, flomod)
            # Create a flow for the other direction as well.
            match = OfpMatch(
                OFPFW_ALL $ (OFPFW_DL_SRC | OFPFW_DL_DST),
                0x0000,
                dl_dst,
                dl_src,
                0x0000,
                0x00,
                0x0000,
                0x00,
                0x00,
                uint32(0),
                uint32(0),
                0x0000,
                0x0000
            )
            actions = OfpActionHeader[OfpActionOutput(
                OFPAT_OUTPUT,
                0x0008,
                table[dl_src_ui],
                0x0060
            )]
            flomod = OfpFlowMod(
                OfpHeader(OFPT_FLOW_MOD),
                match,
                uint64(0),
                OFPFC_ADD,
                FLOW_IDLE_TIMEOUT,
                FLOW_HARD_TIMEOUT,
                0x8000,
                0xffffffff,
                OFPP_NONE,
                OFPFF_SEND_FLOW_REM,
                actions
            )
            push!(resp, flomod)
        else
            actions = OfpActionHeader[OfpActionOutput(OFPAT_OUTPUT, 0x0008,
                OFPP_FLOOD, 0x0080)]
            pout = OfpPacketOut(OfpHeader(OFPT_PACKET_OUT), msg.buffer_id,
                msg.in_port, give_length(actions), actions)
            push!(resp, pout)
        end
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpPortStatus
function processrequest!(msg::OfpPortStatus, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PORT_STATUS
        info("Got OFPT_PORT_STATUS")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpFlowMod
function processrequest!(msg::OfpFlowMod, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_FLOW_MOD
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpPortMod
function processrequest!(msg::OfpPortMod, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PORT_MOD
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpStatsRequest
function processrequest!(msg::OfpStatsRequest, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_STATS_REQUEST
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpStatsReply
function processrequest!(msg::OfpStatsReply, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_STATS_REPLY
        info("Got OFPT_STATS_REPLY")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpPacketOut
function processrequest!(msg::OfpPacketOut, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PACKET_OUT
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpFlowRemoved
function processrequest!(msg::OfpFlowRemoved, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_FLOW_REMOVED
        info("Got OFPT_FLOW_REMOVED")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end
# OfpEmptyMessage handler.
function processrequest!(msg::OfpEmptyMessage, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_HELLO
        info("Got HELLO, replying HELLO")
        info(string(msg))
        tables[socket] = Dict{Uint8, Uint16}()
        # XXX how does the msgidx work?
        push!(resp, OfpEmptyMessage(OfpHeader(OFPT_HELLO, 8)))
        push!(resp, OfpEmptyMessage(OfpHeader(OFPT_FEATURES_REQUEST, 8)))
        push!(resp, OfpEmptyMessage(OfpHeader(OFPT_GET_CONFIG_REQUEST, 0x0008)))
    elseif msg.header.msgtype == OFPT_ECHO_REQUEST
        info("Got ECHO_REQUEST, replying ECHO_REPLY")
        info(string(msg))
        push!(resp, OfpEmptyMessage(OfpHeader(OFPT_ECHO_REPLY, 8)))
    elseif msg.header.msgtype == OFPT_ECHO_REQUEST
        info("Got ECHO_REPLY.")
        info(string(msg))
    elseif msg.header.msgtype == OFPT_BARRIER_REQUEST
        warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        warn(string(msg))
    elseif msg.header.msgtype == OFPT_BARRIER_REPLY
        info("Got OFPT_BARRIER_REPLY")
        info(string(msg))
    end
    resp
end

# OfpVendorHeader
function processrequest!(msg::OfpVendorHeader, socket::TcpSocket)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_VENDOR
        info("Got OFPT_VENDOR")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# (datapath_id => (mac => port))
tables = Dict{TcpSocket, Dict{Uint8, Uint16}}()
const FLOW_IDLE_TIMEOUT = 8
const FLOW_HARD_TIMEOUT = 8

start_server(processrequest!)

# XXX Use this at some point.
function create_arp_request_flowmod(buffer_id::Uint32)
    actions::Vector{OfpActionHeader} = Array(OfpActionHeader, 1)
    actions[1] = OfpActionOutput(
        OFPAT_OUTPUT, # Type.
        0x0008, # Length.
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

end

