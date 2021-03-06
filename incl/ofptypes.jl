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

abstract OfpStruct
give_length{T<:OfpStruct}(arr::Vector{T}) = sum(map(give_length, arr))
# XXX Is this slow? Maybe it is faster to first obtain the required size, then
# allocate the array, then writing the value, iterative style. 
bytes{T<:OfpStruct}(arr::Vector{T}) = [map(bytes, arr)...]
import Base.string
string{T<:OfpStruct}(arr::Vector{T}, tabs=0) = "$(map((x)->(string(x, tabs)), arr)...)"

# XXX Is there any chance we could make the header immutable again?
type OfpHeader <: OfpStruct
    protoversion::Uint8
    msgtype::Uint8
    msglen::Uint16
    msgidx::Uint32
end
OfpHeader(msgtype, msglen=0x0000, msgidx::Uint32=0x00000000) = OfpHeader(0x01,
    convert(Uint8, msgtype), convert(Uint16, msglen), convert(Uint32, msgidx))
@bytes OfpHeader
@length OfpHeader
@string OfpHeader

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
        obj = new(header, port, zeros(Uint8, 2))
        obj.header.msglen = 12
        obj
    end
end
@length OfpQueueGetConfigRequest
@bytes OfpQueueGetConfigRequest
@string OfpQueueGetConfigRequest
@bytesconstructor OfpQueueGetConfigRequest [:pad=>2]

# Creating a new type to bundle all OfpQueueProperties.
abstract OfpQueueProp <: OfpStruct
# Common description for a queue.

immutable OfpQueuePropHeader <: OfpStruct
    property::Uint16 # One of OFPQT_*.
    len::Uint16 # Length of property, including this header.
    pad::Bytes # Length: 4; 64-bit alignment.
    OfpQueuePropHeader(prop, len) = new(prop, len, zeros(Uint8,
        4))
end
@bytes OfpQueuePropHeader
@length OfpQueuePropHeader
@string OfpQueuePropHeader
@bytesconstructor OfpQueuePropHeader [:pad=>4]

immutable OfpQueuePropNone <: OfpQueueProp
    header::OfpQueuePropHeader
    function OfpQueuePropNone(header::OfpQueuePropHeader) 
        @assert header.property == OFPQT_NONE
        obj = new(header)
        @assert obj.header.len == 8
        obj
    end
end
@bytes OfpQueuePropNone
@length OfpQueuePropNone
@string OfpQueuePropNone
@bytesconstructor OfpQueuePropNone

immutable UnknownQueueProperty <: Exception
end

# XXX Why is it not allowed to create a constructor for the abstract type?
function OfpQueuePropFactory(body::Bytes)
    header::OfpQueuePropHeader = OfpQueuePropHeader(body[1:8])
    if header.property == OFPQT_MIN_RATE
        @assert length(body) == header.len
        return OfpQueuePropMinRate(body)
    elseif header.property == OFPQT_NONE
        @assert length(body) == 8
        return OfpQueuePropNone(body)
    else
        throw(UnknownQueueProperty())
    end
end
function nextqueueprop(body::Bytes)
    header::OfpQueuePropHeader = OfpQueuePropHeader(body[1:8])
    (OfpQueuePropFactory(body[1:header.len]), length(body) > header.len ?
        body[header.len + 1:end] : nothing)
end
function OfpQueueProps(body::Bytes)
    props = Array(OfpQueueProp, 0)
    bdy = body
    while bdy != nothing
        (prop::OfpQueueProp, bdy) = nextqueueprop(bdy)
        append!(props, [prop])
    end
    props
end

# Min-Rate queue property description. 
immutable OfpQueuePropMinRate <: OfpQueueProp
    header::OfpQueuePropHeader # prop: OFPQT_MIN_RATE, len: 16.
    rate::Uint16 # In 1/10 of a percent; >1000 -> disabled.
    pad::Bytes # Length 6; 64-bit alginment.
    OfpQueuePropMinRate(header, rate) = begin
        @assert header.property == OFPQT_MIN_RATE
        new(header, rate, zeros(Uint8, 6))
    end
end
@length OfpQueuePropMinRate
@bytes OfpQueuePropMinRate
@string OfpQueuePropMinRate
@bytesconstructor OfpQueuePropMinRate [:pad=>6]

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
    OfpPacketQueue(queue_id, len, properties::Vector{OfpQueueProp}) = begin
            obj = new(queue_id, len, zeros(Uint8, 2), properties)
            @assert len == give_length(obj)
            obj
    end
end
@length OfpPacketQueue
@bytes OfpPacketQueue
@string OfpPacketQueue
function OfpPacketQueue(body::Bytes)
    queue_id = btoui(body[1], body[2], body[3], body[4])
    len = btoui(body[5], body[6])
    OfpPacketQueue(queue_id, len, OfpQueueProps(body[9:len]))
end

immutable OfpQueueGetConfigReply <: OfpMessage
    header::OfpHeader
    port::Uint16 
    pad::Bytes # Length 6;
    queues::Vector{OfpPacketQueue} # List of configured queues.
    # This one is for when we are creating this message to be sent.
    function OfpQueueGetConfigReply(port::Uint16, queues::Vector{OfpPacketQueue})
        configreply = new(OfpHeader(OFPT_GET_CONFIG_REPLY, uint16(8)), port, zeros(Uint8, 6), queues)
        len = give_length(configreply)
        configreply.header.msglen = uint16(len)
        configreply
    end
    # This one is for when we are assembling the message from bytes.
    function OfpQueueGetConfigReply(header, port, queues)
        configreply = new(header, port, zeros(Uint8, 6), queues)
        len = give_length(configreply)
        configreply.header.msglen = len
        @assert header.msgtype == OFPT_QUEUE_GET_CONFIG_REPLY
        configreply
    end
end
@bytes OfpQueueGetConfigReply
@length OfpQueueGetConfigReply
@string OfpQueueGetConfigReply
@bytesconstructor OfpQueueGetConfigReply [:pad=>6]

immutable OfpError <: OfpMessage
    header::OfpHeader
    typ::Uint16 # Should be "type", which however is a keyword in Julia.
    code::Uint16 
    data::Bytes # ASCII text for OFPET_HELLO FAILED, at least 64 bytes of the
        # failed request for OFP_BAD_REQUEST CODE, OFP_BAD_ACTION_CODE, 
        # OFP_FLOW_MOD_FAILED_CODE, OFP_PORT_MOD_FAILED_CODE or
        # OFPET_QUEUE_OP_FAILED.
    OfpError(header, typ, code, data) = begin
        @assert header.msgtype == OFPT_ERROR
        obj = new(header, typ, code, data)
        obj.header.msglen = give_length(obj)
        obj
    end
end
@bytes OfpError
@length OfpError
@string OfpError
@bytesconstructor OfpError
import Base.string
function string(error::OfpError)
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
    state::Uint32 # Bitmap of OFPPS_* flags.
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
@length OfpPhyPort
@string OfpPhyPort [:name]
@bytes OfpPhyPort
@bytesconstructor OfpPhyPort [:hw_addr=>OFP_MAX_ETH_ALEN, :name=>OFP_MAX_PORT_NAME_LEN]

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
    OfpSwitchFeatures(header, datapath_id, n_buffers, n_tables, capabilities,
        actions, ports) = begin
        @assert header.msgtype == OFPT_FEATURES_REPLY
        obj = new(header, datapath_id, n_buffers, n_tables, zeros(Uint8, 3), capabilities, actions, ports)
        obj.header.msglen = give_length(obj)
        obj
    end
end
@bytes OfpSwitchFeatures
@length OfpSwitchFeatures
@string OfpSwitchFeatures
@bytesconstructor OfpSwitchFeatures [:pad=>3]

# Switch configuration
immutable OfpSwitchConfig <: OfpMessage
    header::OfpHeader
    flags::Uint16 # OFPC_* flags.
    miss_send_len::Uint16 # Max bytes of new flow that datapath should send to
                            # the controller
    OfpSwitchConfig(header, flags, miss_send_len) = begin 
        @assert header.msgtype == OFPT_GET_CONFIG_REQUEST || header.msgtype ==
            OFPT_GET_CONFIG_REPLY
        obj = new(header, flags, miss_send_len)
        obj.header.msglen = 12
        obj
    end
end
@bytes OfpSwitchConfig
@length OfpSwitchConfig
@string OfpSwitchConfig
@bytesconstructor OfpSwitchConfig

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
        nw_tos, nw_proto, nw_src, nw_dst, tp_src, tp_dst) = begin
        @assert length(dl_src) == OFP_MAX_ETH_ALEN
        @assert length(dl_dst) == OFP_MAX_ETH_ALEN
        new(wildcards, in_port, dl_src, dl_dst, dl_vlan, dl_vlan_pcp, 0x00,
            dl_type, nw_tos, nw_proto, b"\x00\x00", nw_src, nw_dst, tp_src,
            tp_dst)
    end
end
@bytes OfpMatch
@length OfpMatch
@string OfpMatch
@bytesconstructor OfpMatch [:pad2=>2, :dl_src=>OFP_MAX_ETH_ALEN, :dl_dst=>OFP_MAX_ETH_ALEN]

# XXX Using the same naming scheme as in the spec. It is not really a header but rather
# a supertype for all actions. OfpAction would be a more suitable name.
abstract OfpActionHeader <: OfpStruct
function OfpActionHeaderFactory(body::Bytes)
    typ::Uint16 = btoui(body[1], body[2])
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
    else
        error("Unsupported action header type: $(typ)")
    end
end
function nextactionheader(body::Bytes)
    len = btoui(body[3], body[4])
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
    typ::Uint16 # OFPAT_STRIP_VLAN. 
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 4.
    OfpActionEmpty(typ, len) = begin
        @assert typ == OFPAT_STRIP_VLAN
        obj = new(typ, len)
        obj.len == 4
        obj
    end
end
@bytes OfpActionEmpty
@length OfpActionEmpty
@string OfpActionEmpty
@bytesconstructor OfpActionEmpty

immutable OfpActionOutput <: OfpActionHeader
    typ::Uint16 # OFPAT_OUTPUT. 
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    port::Uint16 # Output port.
    max_len::Uint16 # Max length to send to the controller.
    OfpActionOutput(typ, len, port, max_len) = begin
        @assert typ == OFPAT_OUTPUT
        obj = new(typ, len, port, max_len)
        @assert obj.len == 8
        obj
    end
end
@bytes OfpActionOutput
@length OfpActionOutput
@string OfpActionOutput
@bytesconstructor OfpActionOutput

immutable OfpActionEnqueue <: OfpActionHeader
    typ::Uint16 # OFPAT_ENQUEUE. 
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 16.
    port::Uint16 # Port that queue belongs to. Should refer to a valid physical
        # port (i.e. < OFPP_MAX) or OFPP_IN_PORT.
    pad::Bytes # Length: 6 bytes for 64-bit alignment
    queue_id::Uint32 # Where to enqueue the packets.
    OfpActionEnqueue(typ, len, port, queue_id) = begin
        @assert typ == OFPAT_ENQUEUE
        obj = new(typ, len, port, zeros(Uint8, 6), queue_id)
        @assert obj.len == 16
        obj
    end
end
@bytes OfpActionEnqueue
@length OfpActionEnqueue
@string OfpActionEnqueue
@bytesconstructor OfpActionEnqueue [:pad=>6]

immutable OfpActionVlanVid <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_VLAN_VID.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    vlan_vid::Uint16 # VLAN id.
    pad::Bytes # Length: 2 bytes for 64-bit alignment
    OfpActionVlanVid(typ, len, vlan_vid) = begin
        @assert typ == OFPAT_SET_VLAN_VID
        obj = new(typ, len, vlan_vid, zeros(Uint8, 2))
        @assert obj.len == 8
        obj
    end
end
@bytes OfpActionVlanVid
@length OfpActionVlanVid
@string OfpActionVlanVid
@bytesconstructor OfpActionVlanVid [:pad=>2]

immutable OfpActionVlanPcp <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_VLAN_PCP.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    vlan_pcp::Uint8 # VLAN priority.
    pad::Bytes # Length: 3
    OfpActionVlanPcp(typ, len, vlan_pcp) = begin
        @assert typ == OFPAT_SET_VLAN_PCP
        obj = new(typ, len, vlan_pcp, zeros(Uint8, 3))
        @assert obj.len == 8
        obj
    end
end
@bytes OfpActionVlanPcp
@length OfpActionVlanPcp
@string OfpActionVlanPcp
@bytesconstructor OfpActionVlanPcp [:pad=>3]

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
    typ::Uint16 # OFPAT_SET_DL_SRC/DST. 
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    dl_addr::Bytes # Length: OFP_MAX_ETH_ALEN; Ethernet address.
    pad::Bytes # Length: 6
    OfpActionDlAddress(typ, len, dl_addr) = begin
        @assert typ == OFPAT_SET_DL_SRC || typ == OFPAT_SET_DL_DST
        @assert length(dl_addr) == OFP_MAX_ETH_ALEN
        obj = new(typ, len, dl_addr, zeros(Uint8, 6))
        @assert obj.len == give_length(obj)
        obj
    end
end
@bytes OfpActionDlAddress
@length OfpActionDlAddress
@string OfpActionDlAddress
@bytesconstructor OfpActionDlAddress [:dl_addr=>OFP_MAX_ETH_ALEN, :pad=>6]

# OFPAT_SET_NW_SRC/DST
immutable OfpActionNwAddress <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_NW_SRC/DST. 
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    nw_addr::Uint32 # IP address.
    OfpActionNwAddress(typ, len, nw_addr) = begin
        @assert typ == OFPAT_SET_NW_SRC || typ == OFPAT_SET_NW_DST
        obj = new(typ, len, nw_addr)
        @assert obj.len == 8
        obj
    end
end
@bytes OfpActionNwAddress
@length OfpActionNwAddress
@string OfpActionNwAddress
@bytesconstructor OfpActionNwAddress

# OFPAT_SET_NW_TOS
immutable OfpActionNwTos <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_NW_TOS. 
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    nw_tos::Uint8 # IP ToS (DSCP field, 6 bits).
    pad::Bytes # Length 3.
    OfpActionNwTos(typ, len, nw_tos) = begin
        @assert typ == OFPAT_SET_NW_TOS
        obj = new(typ, len, nw_tos, zeros(Uint8, 3))
        @assert obj.len == 8
        obj
    end
end
@bytes OfpActionNwTos
@length OfpActionNwTos
@string OfpActionNwTos
@bytesconstructor OfpActionNwTos [:pad=>3]

# OFPAT_TP_PORT
immutable OfpActionTpPort <: OfpActionHeader
    typ::Uint16 # OFPAT_SET_TP_SRC/DST. 
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    tp_port::Uint16 # TCP/UDP port.
    pad::Bytes # Length 2.
    OfpActionTpPort(typ, len, tp_port) = begin
        if typ != OFPAT_SET_TP_SRC && typ != OFPAT_SET_TP_DST
            throw(WrongMessageType())
        end
        @assert typ == OFPAT_SET_TP_SRC || typ == OFPAT_SET_TP_DST
        obj = new(typ, len, tp_port, zeros(Uint8, 2))
        @assert obj.len == 8
        obj
    end
end
@bytes OfpActionTpPort
@length OfpActionTpPort
@string OfpActionTpPort
@bytesconstructor OfpActionTpPort [:pad=>2]

# OFPAT_VENDOR
immutable OfpActionVendor <: OfpActionHeader
    typ::Uint16 # OFPAT_VENDOR. 
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined. 8.
    vendor::Uint32 # Vendor ID, which takes the same form as in OfpVendorHeader.
    body::Bytes # Vendor-specific extension.
    OfpActionVendor(typ, len, vendor, body::Bytes) = begin
        @assert typ == OFPAT_VENDOR
        obj = new(OFPAT_VENDOR, len, vendor, body)
        @assert obj.len == 8 + length(body) 
        obj
    end
end
@bytes OfpActionVendor
@length OfpActionVendor
@string OfpActionVendor
@bytesconstructor OfpActionVendor [] [:body=>:(len - 8)]

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
        @assert header.msgtype == OFPT_PACKET_IN
        obj = new(header, buffer_id, total_len, in_port, reason, 0x00, data)
        obj.header.msglen = 8 + 10 + length(data)
        obj
    end
end
@bytes OfpPacketIn
# perf
#@length OfpPacketIn
give_length(pi::OfpPacketIn) = 8 + 10 + length(pi.data)
@string OfpPacketIn
@bytesconstructor OfpPacketIn

# Port status messages
immutable OfpPortStatus <: OfpMessage
    header::OfpHeader
    reason::Uint8 # One of OFPPR_*
    pad::Bytes # length: 7; Align to 64 bits
    desc::OfpPhyPort
    OfpPortStatus(header, reason, desc) = begin
        @assert header.msgtype == OFPT_PORT_STATUS
        obj = new(header, reason, zeros(Uint8, 7), desc)
        obj.header.msglen = give_length(obj)
        obj
    end
end
@bytes OfpPortStatus
@length OfpPortStatus
@string OfpPortStatus
@bytesconstructor OfpPortStatus [:pad=>7]

# Modify StateMessages
# Flow setup and teardown (controller -> datapath)
immutable OfpFlowMod <: OfpMessage
    header::OfpHeader
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
    OfpFlowMod(header, match, cookie, command, idle_timeout, hard_timeout,
        priority, buffer_id, out_port, flags, actions) = begin
            @assert header.msgtype == OFPT_FLOW_MOD
            # Create the partially initialized object.
            obj = new(header, match, cookie, command, idle_timeout, hard_timeout,
                priority, buffer_id, out_port, flags, actions) 
            obj.header.msglen = give_length(obj)
            obj
    end
    OfpFlowMod(match, cookie, command, idle_timeout, hard_timeout,
        priority, buffer_id, out_port, flags, actions) = begin
        ofpflowmod = new(OfpHeader(OFPT_FLOW_MOD, uint8(8)), match, cookie,
            command, idle_timeout, hard_timeout, priority, buffer_id, out_port,
            flags, actions)
        ofpflowmod.header.msglen = give_length(ofpflowmod)
        ofpflowmod
    end
end
@bytes OfpFlowMod
@length OfpFlowMod
@string OfpFlowMod
@bytesconstructor OfpFlowMod

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
        @assert length(hw_addr) == OFP_MAX_ETH_ALEN
        obj = new(header, port_no, hw_addr, config, mask, advertise, zeros(Uint8, 4))
        obj.header.msglen = give_length(obj)
        obj
    end
end
@bytes OfpPortMod
@length OfpPortMod
@string OfpPortMod
@bytesconstructor OfpPortMod [:hw_addr=>OFP_MAX_ETH_ALEN, :pad=>4]

immutable OfpEmptyMessage <: OfpMessage
    header::OfpHeader
end
@bytes OfpEmptyMessage
@length OfpEmptyMessage
@string OfpEmptyMessage
@bytesconstructor OfpEmptyMessage

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
    OfpDescStats(mfr_desc, hw_desc, sw_desc, serial_num, dp_desc) = begin
        @assert length(mfr_desc) == DESC_STR_LEN
        @assert length(hw_desc) == DESC_STR_LEN
        @assert length(sw_desc) == DESC_STR_LEN
        @assert length(serial_num) == SERIAL_NUM_LEN
        @assert length(dp_desc) == DESC_STR_LEN
        new(mfr_desc, hw_desc, sw_desc, serial_num, dp_desc)
    end
end
@bytes OfpDescStats
@length OfpDescStats
@string OfpDescStats [:mfr_desc, :hw_desc, :sw_desc, :serial_num, :dp_desc]
@bytesconstructor OfpDescStats [:mfr_desc=>DESC_STR_LEN, :hw_desc=>DESC_STR_LEN, :sw_desc=>DESC_STR_LEN, :serial_num=>SERIAL_NUM_LEN, :dp_desc=>DESC_STR_LEN]

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
@bytesconstructor OfpFlowStatsRequest

# Body of reply to OFPST_FLOW request.
immutable OfpFlowStats <: OfpStatsReplyBody
    length::Uint16 # Length of this entry.
        # avoid a naming conflict with the function "length", which can collide
        # inside the macros
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
    pad2::Bytes # Length: 6; Align to 64-bits.
    cookie::Uint64 # Opaque controller-issued identifier.
    packet_count::Uint64 # Number of packets in flow.
    byte_count::Uint64 # Number of bytes in flow.
    actions::Vector{OfpActionHeader} # Actions.
    OfpFlowStats(length, table_id, match, duration_sec, duration_nsec, priority,
        idle_timeout, hard_timeout, cookie, packet_count, byte_count, actions) =
        begin
            obj = new(length, table_id, 0x00, match, duration_sec,
                duration_nsec, priority, idle_timeout, hard_timeout,
                zeros(Uint8, 6), cookie, packet_count, byte_count, actions)
            @assert obj.length == give_length(obj)
            obj
        end
end
@bytes OfpFlowStats
@length OfpFlowStats
@string OfpFlowStats
@bytesconstructor OfpFlowStats [:pad2=>6]

# Body for ofp_stats_request of type OFPST_AGGREGATE
immutable OfpAggregateStatsRequest <: OfpStatsRequestBody
    match::OfpMatch # Fields to match.
    table_id::Uint8 # ID of table to read (from ofp_table_stats). 0xff for all
        # tables or 0xfe for emergency. 
    pad::Uint8 # Align to 32 bits.
    out_port::Uint16 # Require matching entries to include this as an output
        # port. A value of OFPP_NONE indicates no restriction.
    OfpAggregateStatsRequest(match, table_id, out_port) = new(match, table_id,
        0x00, out_port)
end
@bytes OfpAggregateStatsRequest
@length OfpAggregateStatsRequest
@string OfpAggregateStatsRequest
@bytesconstructor OfpAggregateStatsRequest

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
        lookup_count, matched_count) = begin
        @assert length(name) == OFP_MAX_TABLE_NAME_LEN
        new(table_id, zeros(Uint8, 3), name, wildcards, max_entries,
            active_count, lookup_count, matched_count)
    end
end
@bytes OfpTableStats
@length OfpTableStats
@string OfpTableStats [:name]
@bytesconstructor OfpTableStats [:pad=>3, :name=>OFP_MAX_TABLE_NAME_LEN]

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
    port_no::Uint16 # All ports if OFPP_ALL.
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
    OfpVendorStatsRequest(vendor_id, body) = begin
        @assert length(vendor_id) == 4
        new(vendor_id, body)
    end
end
@bytes OfpVendorStatsRequest
@length OfpVendorStatsRequest
@string OfpVendorStatsRequest
@bytesconstructor OfpVendorStatsRequest [:vendor_id=>4]

immutable OfpVendorStatsReply <: OfpStatsReplyBody
    vendor_id::Bytes # Length: 4
    body::Bytes # The rest of the message is vendor-defined.
    OfpVendorStatsReply(vendor_id, body) = begin
        @assert length(vendor_id) == 4
        new(vendor_id, body)
    end
end
@bytes OfpVendorStatsReply
@length OfpVendorStatsReply
@string OfpVendorStatsReply
@bytesconstructor OfpVendorStatsReply [:vendor_id=>4]

# ofp_stats_request
immutable OfpStatsRequest{T<:OfpStatsRequestBody} <: OfpMessage
    header::OfpHeader
    typ::Uint16 # One of the OFPST_* constants.
    flags::Uint16 # OFPSF_REQ_* flags (none yet defined).
    body::T  # Body of the request.
    OfpStatsRequest(header, typ, flags, body) = begin
        obj = new(header, typ, flags, body)
        @assert header.msgtype == OFPT_STATS_REQUEST
        obj.header.msglen = give_length(obj)
        obj
    end
end
@bytes OfpStatsRequest
@length OfpStatsRequest
@string OfpStatsRequest
function OfpStatsRequest(header::OfpHeader, body::Bytes)
    @assert header.msgtype == OFPT_STATS_REQUEST
    typ::Uint16 = btoui(body[1], body[2])
    flags::Uint16 = btoui(body[3], body[4])
    if typ == OFPST_FLOW
        bdy = OfpFlowStatsRequest(body[5:end])
    elseif typ == OFPST_AGGREGATE
        bdy = OfpAggregateStatsRequest(body[5:end])
    elseif typ == OFPST_PORT
        bdy = OfpPortStatsRequest(body[5:end])
    elseif typ == OFPST_QUEUE
        bdy = OfpQueueStatsRequest(body[5:end])
    elseif typ == OFPST_VENDOR
        bdy = OfpVendorStatsRequest(body[5:end])
    else
        error("Unsupported type $(typ) for OfpStatsRequest.")
    end
    obj = OfpStatsRequest{typeof(bdy)}(header, typ, flags, bdy)
    obj.header.msglen = give_length(obj)
    obj
end

# ofp_stats_reply
immutable OfpStatsReply{T<:OfpStatsReplyBody} <: OfpMessage
    header::OfpHeader
    typ::Uint16 # One of the OFPST_* constants.
    flags::Uint16 # OFPSF_REPLY_* flags.
    body::T # Body of the reply.
    OfpStatsReply(header, typ, flags, body) = begin
        @assert header.msgtype == OFPT_STATS_REPLY
        obj = new(header, typ, flags, body)
        obj.header.msglen = give_length(obj)
        obj
    end
end
@bytes OfpStatsReply
@length OfpStatsReply
@string OfpStatsReply
function OfpStatsReply(header::OfpHeader, body::Bytes)
    typ::Uint16 = btoui(body[1], body[2])
    flags::Uint16 = btoui(body[3], body[4])
    if typ == OFPST_DESC
        bdy = OfpDescStats(body[5:end])
    elseif typ == OFPST_FLOW
        bdy = OfpStats(body[5:end])
    elseif typ == OFPST_AGGREGATE
        bdy = OfpAggregateStatsReply(body[5:end])
    elseif typ == OFPST_TABLE
        bdy = OfpTableStats(body[5:end])
    elseif typ == OFPST_PORT
        bdy = OfpPortStats(body[5:end])
    elseif typ == OFPST_QUEUE
        bdy = OfpQueueStats(body[5:end])
    elseif typ == OFPST_VENDOR
        bdy = OfpVendorStatsReply(body[5:end])
    else
        error("Unsupported type $(typ) for OfpStatsReply.")
    end
    obj = OfpStatsReply{typeof(bdy)}(header, typ, flags, bdy)
    obj.header.msglen = give_length(obj)
    obj
end

# ofp_packet_out
# Send packet (controller -> datapath).
immutable OfpPacketOut <: OfpMessage
    header::OfpHeader
    buffer_id::Uint32 # ID assigned by datapath (-1 if none). Short quiz
        # question: How do you assign a value of -1 to an unsigned integer type?
        # --> 0xFFFFFFFF.
    in_port::Uint16 # Packet's input port (OFPP_NONE if none).
    actions_len::Uint16 # Size of action array in bytes.
    actions::Vector{OfpActionHeader} # Actions.
    # data::Bytes XXX For some reason this is commented out in the spec.
    OfpPacketOut(header, buffer_id, in_port, actions_len, actions) = begin
        @assert header.msgtype == OFPT_PACKET_OUT
        obj = new(header, buffer_id, in_port, actions_len, actions)
        obj.header.msglen = give_length(obj)
        obj
    end
end
@bytes OfpPacketOut
#@length OfpPacketOut
give_length(po::OfpPacketOut) = 8 + 8 + reduce((l, a)->l + give_length(a), 0, po.actions)
@string OfpPacketOut
@bytesconstructor OfpPacketOut

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
        obj = new(header, match, cookie, priority, reason, 0x00, duration_sec,
            duration_nsec, idle_timeout, zeros(Uint8, 2), packet_count, byte_count)
        obj.header.msglen = give_length(obj)
        obj
    end
end
@bytes OfpFlowRemoved
@length OfpFlowRemoved
@string OfpFlowRemoved
@bytesconstructor OfpFlowRemoved [:pad2=>2]

# Vendor extension.
# ofp_vendor_header
# TODO Make this a parametric type, with the body value being of the parameter
# type.
immutable OfpVendorHeader <: OfpMessage
    header::OfpHeader # Type OFPT_VENDOR
    vendor::Uint32 # Vendor ID:
                    # - MSB 0: low-order bytes are IEEE OUI.
                    # - MSB != 0: defined by OpenFlow consortium.
    body::Bytes # Vendor-defined arbitrary additional data.
    OfpVendorHeader(header, vendor, body) = begin
        @assert header.msgtype == OFPT_VENDOR
        obj = new(header, vendor, body)
        obj.header.msglen = 12 + length(body)
        obj
    end
end
@bytes OfpVendorHeader
@length OfpVendorHeader
@string OfpVendorHeader
@bytesconstructor OfpVendorHeader

