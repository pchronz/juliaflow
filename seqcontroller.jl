require("of-controller.jl")
module SequentialController
using OpenFlow

# Catch-all message handler.
function processrequest(message::OfpMessage)
    warn("Got a message for which there is no processing rule: $(string(message))")
end

# OfpQueueGetConfigRequest
function processrequest(msg::OfpQueueGetConfigRequest)
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
function processrequest(msg::OfpQueueGetConfigReply)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_
        info("Got ")
        info(string(msg))
        push!(resp, Ofp())
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        info(string(msg))
    end
    resp
end

# OfpError
function processrequest(msg::OfpError)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_ERROR
        warn("Got ERROR: $(string(message))")
        warn(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpSwitchFeatures
function processrequest(msg::OfpSwitchFeatures)
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
function processrequest(msg::OfpSwitchConfig)
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

# OfpPacketIn
function processrequest(msg::OfpPacketIn)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PACKET_IN
        info("Got OFPT_PACKET_IN")
        info(string(msg))
        # Assuming we just got the ARP request from host 1
        # TODO send a message to forward broadcasts
        push!(resp, create_arp_request_flowmod(msg.buffer_id))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

# OfpPortStatus
function processrequest(msg::OfpPortStatus)
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
function processrequest(msg::OfpFlowMod)
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
function processrequest(msg::OfpPortMod)
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
function processrequest(msg::OfpStatsRequest)
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
function processrequest(msg::OfpStatsReply)
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
function processrequest(msg::OfpPacketOut)
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
function processrequest(msg::OfpFlowRemoved)
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
function processrequest(msg::OfpEmptyMessage)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_HELLO
        info("Got HELLO, replying HELLO")
        info(string(msg))
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
function processrequest(msg::OfpVendorHeader)
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_
        info("Got OFPT_VENDOR")
        info(string(msg))
    else
        warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        warn(string(msg))
    end
    resp
end

start_server(processrequest)

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

