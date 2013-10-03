require("of-controller.jl")
module L2LearningSwitch
using OpenFlow

# Catch-all message handler.
function processrequest!(message::OfpMessage, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    # warn("Got a message for which there is no processing rule: $(string(message))")
    (OfpMessage[], socket_data)
end

# OfpQueueGetConfigRequest
function processrequest!(msg::OfpQueueGetConfigRequest, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_QUEUE_GET_CONFIG_REQUEST
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    elseif msg.header.msgtype == OFPT_QUEUE_GET_CONFIG_REPLY
        # info("Got OFPT_QUEUE_GET_CONFIG_REPLY")
        # info(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # info(string(msg))
    end
    (resp, socket_data)
end

# OfpQueueGetConfigReply
function processrequest!(msg::OfpQueueGetConfigReply, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_QUEUE_GET_CONFIG_REPLY
        # info("Got OFPT_QUEUE_GET_CONFIG_REPLY")
        # info(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # info(string(msg))
    end
    (resp, socket_data)
end

# OfpError
function processrequest!(msg::OfpError, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_ERROR
        # warn("Got ERROR: $(string(msg))")
        # warn(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# OfpSwitchFeatures
function processrequest!(msg::OfpSwitchFeatures, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_FEATURES_REQUEST
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    elseif msg.header.msgtype == OFPT_FEATURES_REPLY
        # info("Got OFPT_FEATURES_REPLY")
        # info(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# OfpSwitchConfig
function processrequest!(msg::OfpSwitchConfig, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_GET_CONFIG_REQUEST
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    elseif msg.header.msgtype == OFPT_SET_CONFIG
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    elseif msg.header.msgtype == OFPT_GET_CONFIG_REPLY
        # info("Got OFPT_GET_CONFIG_REPLY")
        # info(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# Known locations. (DL_addr=>Port)
# OfpPacketIn
function processrequest!(msg::OfpPacketIn, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PACKET_IN
        # info("Got OFPT_PACKET_IN")
        # info(string(msg))
        table = socket_data
        dl_src = msg.data[7:12]
        dl_dst = msg.data[1:6]
        dl_type = btoui(msg.data[13], msg.data[14])
        dl_src_ui = btoui(0x00, 0x00, dl_src[1], dl_src[2], dl_src[3], dl_src[4], dl_src[5], dl_src[6])
        dl_dst_ui = btoui(0x00, 0x00, dl_dst[1], dl_dst[2], dl_dst[3], dl_dst[4], dl_dst[5], dl_dst[6])
        # Do we know the source? If not store it in the controller.
        if !haskey(table, dl_src_ui)
            # Add dl_src to the local table and add a flow entry.
            table[dl_src_ui] = msg.in_port
        elseif table[dl_src_ui] != msg.in_port
            # warn("DL_ADDR $(dl_src) has moved from port $(table[dl_src_ui]) to $(msg.in_port)")
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
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, table)
end

# OfpPortStatus
function processrequest!(msg::OfpPortStatus, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PORT_STATUS
        # info("Got OFPT_PORT_STATUS")
        # info(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# OfpFlowMod
function processrequest!(msg::OfpFlowMod, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_FLOW_MOD
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# OfpPortMod
function processrequest!(msg::OfpPortMod, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PORT_MOD
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# OfpStatsRequest
function processrequest!(msg::OfpStatsRequest, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_STATS_REQUEST
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# OfpStatsReply
function processrequest!(msg::OfpStatsReply, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_STATS_REPLY
        # info("Got OFPT_STATS_REPLY")
        # info(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# OfpPacketOut
function processrequest!(msg::OfpPacketOut, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_PACKET_OUT
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

# OfpFlowRemoved
function processrequest!(msg::OfpFlowRemoved, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_FLOW_REMOVED
        # info("Got OFPT_FLOW_REMOVED")
        # info(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end
# OfpEmptyMessage handler.
function processrequest!(msg::OfpEmptyMessage, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_HELLO
        # info("Got HELLO, replying HELLO")
        # info(string(msg))
        socket_data = Dict{Uint8, Uint16}()
        # XXX how does the msgidx work?
        push!(resp, OfpEmptyMessage(OfpHeader(OFPT_HELLO, 8)))
        push!(resp, OfpEmptyMessage(OfpHeader(OFPT_FEATURES_REQUEST, 8)))
        #push!(resp, OfpEmptyMessage(OfpHeader(OFPT_GET_CONFIG_REQUEST, 0x0008)))
    elseif msg.header.msgtype == OFPT_ECHO_REQUEST
        # info("Got ECHO_REQUEST, replying ECHO_REPLY")
        # info(string(msg))
        push!(resp, OfpEmptyMessage(OfpHeader(OFPT_ECHO_REPLY, 8)))
    elseif msg.header.msgtype == OFPT_ECHO_REQUEST
        # info("Got ECHO_REPLY.")
        # info(string(msg))
    elseif msg.header.msgtype == OFPT_BARRIER_REQUEST
        # warn("Got a message of type $(msg). Since I am a controller, I really should not get this type of message.")
        # warn(string(msg))
    elseif msg.header.msgtype == OFPT_BARRIER_REPLY
        # info("Got OFPT_BARRIER_REPLY")
        # info(string(msg))
    end
    (resp, socket_data)
end

# OfpVendorHeader
function processrequest!(msg::OfpVendorHeader, socket_id::Integer,
    socket_data::Dict{Uint8, Uint16})
    resp::Vector{OfpMessage} = Array(OfpMessage, 0)
    if msg.header.msgtype == OFPT_VENDOR
        # info("Got OFPT_VENDOR")
        # info(string(msg))
    else
        # warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
        # warn(string(msg))
    end
    (resp, socket_data)
end

function socketdata(socket_id::Integer)
    haskey(tables, socket_id) ? tables[socket_id] : Dict{Uint8, Uint16}()
end

function update_socket_data(socket_id::Integer, data)
    tables[socket_id] = data
end

# (socket_id => (mac => port))
tables = Dict{Integer, Dict{Uint8, Uint16}}()
const FLOW_HARD_TIMEOUT = 8
const FLOW_IDLE_TIMEOUT = 8
export FLOW_IDLE_TIMEOUT, FLOW_HARD_TIMEOUT, processrequest!, socketdata,
    update_socket_data

end

