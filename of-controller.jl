# XXX isn't there some kind of type I can define for this?
# XXX this type should convert between string representation and integers by
# itself efficiently

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
const OFPFW_IN_PORT = 1 <<  # Switch input port.
const OFPFW_DL_VLAN = 1 <<  # VLAN id.
const OFPFW_DL_SRC = 1 <<  # Ethernet source address.
const OFPFW_DL_DST = 1 <<  # Ethernet destination address.
const OFPFW_DL_TYPE = 1 <<  # Ethernet frame type.
const OFPFW_NW_PROTO = 1 <<  # IP protocol.
const OFPFW_TP_SRC = 1 <<  # TCP/UDP source port.
const OFPFW_TP_DST = 1 <<  # TCP/UDP destination port.
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

# Other used constants
const OFP_MAX_ETH_ALEN = 6
const OFP_MAX_PORT_NAME_LEN = 16

# We will be using a lot of byte/octect arrays here
typealias Bytes Vector{Uint8}

abstract OfpStruct
immutable OfpHeader <: OfpStruct
    protoversion::Uint8
    msgtype::Uint8
    msglen::Uint16
    msgidx::Uint32
end
OfpHeader(msgtype::Uint8, msglen::Uint16, msgidx::Uint32=0x00000000) = OfpHeader(0x01,
    msgtype, msglen, msgidx)
# XXX implement proper conversion functions
function tostring(header::OfpHeader)
    "<Version: $(header.protoversion), type: $(header.msgtype), length: $(header.msglen), idx: $(header.msgidx)>"
end
# XXX implement proper conversion functions
function bytes(header::OfpHeader)
    msg = zeros(Uint8, 8)
    msg[1] = header.protoversion
    msg[2] = header.msgtype
    msg[3] = uint8(header.msglen>>8)
    msg[4] = uint8(header.msglen)
    msg[5] = uint8(header.msgidx>>24)
    msg[6] = uint8(header.msgidx>>16)
    msg[7] = uint8(header.msgidx>>8)
    msg[8] = uint8(header.msgidx)
    msg
end
function readofpheader(socket)
    protoversion = read(socket, Uint8, 1)[1]
    msgtype = read(socket, Uint8, 1)[1]
    msglen = ntoh(read(socket, Uint16, 1)[1])
    msgidx = ntoh(read(socket, Uint32, 1)[1])
    OfpHeader(protoversion, msgtype, msglen, msgidx)
end
# XXX replace all the give_length methods by including padding in the message
# definitions and using sizeof.
give_length(header::Type{OfpHeader}) = 8

abstract OfpMessage <: OfpStruct
immutable OfpError <: OfpMessage
    header::OfpHeader
    etype::Uint16 # Should be "type", which however is a keyword in Julia.
    code::Uint16
    data::Bytes # TODO Implement the interpretation of the error message.
end
function OfpError(header::OfpHeader, body::Bytes)
    OfpError(header, # header.
        btoui(body[1:2]), # (e)type.
        btoui(body[3:4]), # code.
        body[5:end] # data.
    )
end
# Description of physical port
immutable OfpPhyPort <: OfpStruct
    port_no::Uint16
    hw_addr::Bytes # TODO length of array: OFP_MAX_ETH_ALEN
    name::Bytes # Null-terminated. TODO Length: OFP_MAX_PORT_NAME_LEN.
                            # XXX what size does the OFP spec assume for chars?
    config::Uint32 # Bitmap of OFPC_* flags.
    state::Uint32 # Bitmap of OFPS_* flas.
    # Bitmaps of OFPPF_* that describe features. All bits zeroed if unsupported
    # or unavailable.
    curr::Uint32 # Current features.
    advertised::Uint32 # Features being advertised by the port.
    supported::Uint32 # Features supported by the port.
    peer::Uint32 # Features advertised by peer.
end
OfpPhyPort(bytes::Bytes) = begin
    # XXX make this more legible somehow?
    port_no = btoui(bytes[1:2])
    hw_addr = bytes[3:3+OFP_MAX_ETH_ALEN-1]
    name = bytes[3+OFP_MAX_ETH_ALEN:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN-1]
    config = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN:
                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 4 - 1])
    state = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 4:
                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 8 - 1])
    curr = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 8:
                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 12 - 1])
    advertised = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 12:
                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 16 - 1])
    supported = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 16:
                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 20 - 1])
    peer = btoui(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 20:
                            3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 24 - 1])
    OfpPhyPort(port_no, hw_addr, name, config, state, curr, advertised,
                supported, peer)
end
give_length(port::Type{OfpPhyPort}) = 26 + OFP_MAX_ETH_ALEN + OFP_MAX_PORT_NAME_LEN
# Switch features
immutable OfpFeatures <: OfpMessage
    header::OfpHeader
    datapath_id::Uint64 # Datapath unique ID. The lower 48-bits are for a MAC
                        # address, while the upper 16 bits are implementer-defined
    n_buffers::Uint32 # Max packets buffered at once
    n_tables::Uint8 # Number of tables supported by datapath
    # pad::Bytes # Align to 64 bits; length 3; Nothing to do here,
    # since we are doing the rendering manually
    capabilities::Uint32 # Bitmap of supported "ofp_capabilities"
    actions::Uint32 # Bitmap of supported "ofp_action_types"
    ports::Vector{OfpPhyPort} # Port definitions. The number of ports is
                            # inferred from the length field in the header.
end
OfpFeatures(header::OfpHeader, body::Bytes) = begin
    # XXX write the array of ports should be created by its own function that
    # takes the corresponding octects
    # compute the number of ports
    numports = uint16((header.msglen - 8 - 24)/48) # len(OfpPhyPort) == 48
    ports::Vector{OfpPhyPort} = Array(OfpPhyPort, numports)
    for p = 1:numports
        ports[p] = OfpPhyPort(body[25 + (p - 1)*48:25 + p*48 - 1])
    end
    OfpFeatures(header, btoui(body[1:8]), btoui(body[9:12]), body[13],
                btoui(body[17:20]), btoui(body[21:24]), ports)
end
give_length(features::OfpFeatures) = begin
    len = give_length(OfpHeader) + 16 
    for port in features.ports
        len += give_length(OfpPhyPort)
    end
    len
end
tostring(msg::OfpFeatures) = begin
    str = "<header: $(tostring(msg.header)), datapath_id: $(msg.datapath_id), n_buffers: $(msg.n_buffers), n_tables: $(msg.n_tables), capabilities: $(msg.capabilities), actions: $(msg.actions), ports: $(msg.ports)>"
end
# Switch configuration
immutable OfpSwitchConfig <: OfpMessage
    header::OfpHeader
    flags::Uint16 # OFPC_* flags.
    miss_send_len::Uint16 # Max bytes of new flow that datapath should send to
                            # the controller
end
OfpSwitchConfig(header::OfpHeader, body::Bytes) =
                OfpSwitchConfig(header, btoui(body[1:2]), btoui(body[3:4]))
# XXX why does lead to an error that seems completely unrelated to the following line?
#convert(::Type{ASCIIString}, msg::OfpSwitchConfig) = println("Someone just invoked the conversion")
tostring(msg::OfpSwitchConfig) = begin
    str = "<flags: $(msg.flags), miss_send_len: $(msg.miss_send_len)>"
end
give_length(switchconig::Type{OfpSwitchConfig}) = give_length(OfpHeader) + 4
# Flow match structures
immutable OfpMatch <: OfpStruct
    wildcards::Uint32 # Wildcards fields
    in_port::Uint16 # Input switch port.
    dl_src::Bytes # Length: OFP_MAX_ETH_ALEN; Ethernet source address.
    dl_dst::Bytes # Length: OFP_MAX_ETH_ALEN; Ehternet destination address.
    dl_vlan::Uint16 # Input VLAN id.
    dl_vlan_pcp::Uint8 # Input VLAN priority.
    # pad1::Uint8 # Align to 64 bits.
    dl_type::Uint16 # Ethernet frame type.
    nw_tos::Uint8 # IP ToS (actually DSCP field, 6 bits).
    nw_proto::Uint8 # IP protocol or lower 8 bits of ARP opcode.
    # pad2::Bytes # Length: 2; Algin to 64 bits.
    nw_src::Uint32 # IP source address.
    nw_dst::Uint32 # IP destination address.
    tp_src::Uint16 # TCP/UDP source port.
    tp_dst::Uint16 # TCP/UDP destination port.
end
OfpMatch(body::Bytes) = OfpMatch(
    btoui(body[1:4]), # wildcards
    btoui(body[5:6]), # in_port
    # XXX the spec (1.0.0) says it should be OFP_MAX_ETH_ALEN, but never defines
    # it. The text actually refers to OFP_MAX_ETH_ALEN, so I am replacing the
    # constant in the followin accordingly.
    body[7:7 + OFP_MAX_ETH_ALEN - 1], # dl_src
    body[7 + OFP_MAX_ETH_ALEN : 7 + 2OFP_MAX_ETH_ALEN - 1], # dl_dst
    btoui(body[7 + 2OFP_MAX_ETH_ALEN:7 + 2OFP_MAX_ETH_ALEN + 1]), # dl_vlan
    body[7 + 2OFP_MAX_ETH_ALEN + 2], # dl_vlan_pcp
    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 4:7 + 2OFP_MAX_ETH_ALEN + 5]), # dl_type
    body[7 + 2OFP_MAX_ETH_ALEN + 6], # nw_tos
    body[7 + 2OFP_MAX_ETH_ALEN + 7], # nw_proto
    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 10:7 + 2OFP_MAX_ETH_ALEN + 13]), # nw_src
    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 14:7 + 2OFP_MAX_ETH_ALEN + 17]), # nw_dst
    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 18:7 + 2OFP_MAX_ETH_ALEN + 19]), # tp_src
    btoui(body[7 + 2OFP_MAX_ETH_ALEN + 20:7 + 2OFP_MAX_ETH_ALEN + 21]) # tp_dst
)
give_length(match::Type{OfpMatch}) = 2OFP_MAX_ETH_ALEN + 28
function bytes(match::OfpMatch)
    byts::Bytes = zeros(Uint8, give_length(OfpMatch))
    byts[1:4] = bytes(match.wildcards)
    byts[5:6] = bytes(match.in_port)
    byts[7:7 + OFP_MAX_ETH_ALEN - 1] = match.dl_src
    byts[7 + OFP_MAX_ETH_ALEN : 7 + 2OFP_MAX_ETH_ALEN - 1] = match.dl_dst
    byts[7 + 2OFP_MAX_ETH_ALEN:7 + 2OFP_MAX_ETH_ALEN + 1] = bytes(match.dl_vlan)
    byts[7 + 2OFP_MAX_ETH_ALEN + 2] = bytes(match.dl_vlan_pcp)
    byts[7 + 2OFP_MAX_ETH_ALEN + 3:7 + 2OFP_MAX_ETH_ALEN + 4] =
        bytes(match.dl_type)
    byts[7 + 2OFP_MAX_ETH_ALEN + 5] = match.nw_tos
    byts[7 + 2OFP_MAX_ETH_ALEN + 6] = match.nw_proto
    byts[7 + 2OFP_MAX_ETH_ALEN + 7:7 + 2OFP_MAX_ETH_ALEN + 10] =
        bytes(match.nw_src)
    byts[7 + 2OFP_MAX_ETH_ALEN + 11:7 + 2OFP_MAX_ETH_ALEN + 14] =
        bytes(match.nw_dst)
    byts[7 + 2OFP_MAX_ETH_ALEN + 15:7 + 2OFP_MAX_ETH_ALEN + 16] =
        bytes(match.tp_src)
    byts[7 + 2OFP_MAX_ETH_ALEN + 17:7 + 2OFP_MAX_ETH_ALEN + 18] =
        bytes(match.tp_dst)
    byts
end
immutable OfpActionHeader <: OfpStruct
    htype::Uint16 # One of OFPAT_*. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined.
    # pad::Bytes Length: 4
end
give_length(actionheader::Type{OfpActionHeader}) = 8
function bytes(actionheader::OfpActionHeader)
    byts::Bytes = zeros(Uint8, 8)
    byts[1:2] = bytes(actionheader.htype)
    byts[3:4] = bytes(actionheader.len)
    byts
end
function bytes(headers::Vector{OfpActionHeader})
    numh = length(headers)
    hlen = give_length(OfpActionHeader)
    byts::Bytes = zeros(Uint8, numh*hlen)
    for i = 1:numh
        byts[hlen*(i-1)+1:hlen*i] = bytes(headers[i])
    end
    byts
end
OfpActionHeader(body::Bytes) = OfpActionHeader(btoui(body[1:2]),
    btoui(body[3:4]))
OfpActionHeader(htype::Unsigned, len::Unsigned) = OfpActionHeader(convert(Uint16, htype),
    convert(Uint16, len))
OfpActionHeaders(body::Bytes) = begin
    numheaders = length(body)/8
    headers::Vector{OfpActionHeader} = Array(OfpActionHeader, numheaders)
    for i = 1:numheaders
        headers[i] = OfpActionHeader(body[(i - 1)*8+1:i*8])
    end
    headers
end
give_length(actionheaders::Vector{OfpActionHeader}) = length(actionheaders)*give_length(OfpActionHeader)
# Packet in messages
immutable OfpPacketIn <: OfpMessage
    header::OfpHeader 
    buffer_id::Uint32 # ID assigned by datapath.
    total_len::Uint16 # Full length of frame.
    in_port::Uint16 # Port on which frame was received.
    reason::Uint8 # Reason packet is being sent (one of OFPR_*).
    # pad::Uint8
    data::Bytes  # Ethernet frame, halfway through 32-bit word, so the
                           # IP header is 32-bit aligned. The amount of data is inferred from the length
                           # field in the header. Because of padding, offsetof(struct ofp_packet_in,
                           # data) == sizeof(struct ofp_packet_in) - 2.
end
tostring(msg::OfpPacketIn) = "<header: $(tostring(msg.header)), buffer_id: $(msg.buffer_id), total_len: $(msg.total_len), in_port: $(msg.in_port), reason: $(msg.reason), data: $(msg.data)>"
OfpPacketIn(header::OfpHeader, body::Bytes) = begin
    datalen = length(body) - 10
    data = zeros(Uint8, datalen)
    for i = 1:datalen
        data[i] = body[11 + i - 1]
    end
    OfpPacketIn(header, btoui(body[1:4]), btoui(body[5:6]), btoui(body[7:8]), body[9], data)
end
# Port status messages
immutable OfpPortStatus <: OfpMessage
    header::OfpHeader
    reason::Uint8 # One of OFPPR_*
    # pad::Bytes # length: 7; Align to 64 bits
    desc::OfpPhyPort
end
OfpPortStatus(header::OfpHeader, body::Bytes) = OfpPortStatus(header, body[1], OfpPhyPort(body[17:64]))
give_length(portstatus::Type{OfpPortStatus}) = give_length(OfpHeader) + 8 +
    give_length(OfpPhyPort)
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
    OfpFlowMod(header::OfpHeader, body::Bytes) = begin
        OfpFlowMod(OfpMatch(body[1:40]), # match
        btoui(body[41:48]), # cookie
        btoui(body[49:50]), # command
        btoui(body[51:52]), # idle_timeout
        btoui(body[53:54]), # hard_timeout
        btoui(body[55:56]), # priority
        btoui(body[57:60]), # buffer_id
        btoui(body[61:62]), # out_port
        btoui(body[63:64]), # flags
        OfpActionHeaders(body[65:end]), # actions
        header) # header 
    end
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
            uint16(give_length(flowmod)))
        flowmod.header = header
        flowmod
    end
end
give_length(flowmod::OfpFlowMod) = give_length(OfpHeader) + give_length(OfpMatch) + 24 + give_length(flowmod.actions)
# XXX Just as reading the length it should be possible to serialize messages
# seamlessly and automaically using the fields. Some metaprogramming maybe?
bytes(flowmod::OfpFlowMod) = begin
    matchlen = give_length(OfpMatch)
    byts::Bytes = zeros(Uint8, flowmod.header.msglen)
    byts[1:8] = bytes(flowmod.header)
    byts[9:9+matchlen-1] = bytes(flowmod.match)
    byts[9+matchlen:9+matchlen+8-1] = bytes(flowmod.cookie)
    byts[9+matchlen+8:9+matchlen+10-1] = bytes(flowmod.command)
    byts[9+matchlen+10:9+matchlen+12-1] = bytes(flowmod.idle_timeout)
    byts[9+matchlen+12:9+matchlen+14-1] = bytes(flowmod.hard_timeout)
    byts[9+matchlen+14:9+matchlen+16-1] = bytes(flowmod.priority)
    byts[9+matchlen+16:9+matchlen+20-1] = bytes(flowmod.buffer_id)
    byts[9+matchlen+20:9+matchlen+22-1] = bytes(flowmod.out_port)
    byts[9+matchlen+22:9+matchlen+24-1] = bytes(flowmod.flags)
    actionbytes = bytes(flowmod.actions)
    byts[9+matchlen+24:end] = actionbytes
    byts
end
immutable OfpEmptyMessage <: OfpMessage
    header::OfpHeader
end
give_length(empty::Type{OfpEmptyMessage}) = give_length(OfpHeader)

type UnrecognizedMessageError <: Exception
end

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
            info("Got FEATURES_REPLY: $(tostring(message))")
        elseif message.header.msgtype == OFPT_ECHO_REQUEST
            info("Got ECHO_REQUEST, replying ECHO_REPLY")
            write(socket, bytes(OfpHeader(OFPT_ECHO_REPLY, 0x0008)))
        elseif message.header.msgtype == OFPT_GET_CONFIG_REPLY
            info("Got GET_CONFIG_REPLY: $(tostring(message))")
        elseif message.header.msgtype == OFPT_PACKET_IN
            info("Got PACKET_IN: $(tostring(message))")
            # Assuming we just got the ARP request from host 1
            # TODO send a message to forward broadcasts
            write(socket, bytes(create_arp_request_flowmod()))
        elseif message.header.msgtype == OFPT_ERROR
            warn("Got ERROR")
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
        return OfpFeatures(header, body)
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

function create_arp_request_flowmod()
    OfpFlowMod(
        OfpMatch(
            uint32(0), # Wildcards fields
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
        uint32(0), # buffer_id; XXX set the buffer id based on the PACKET_IN
        uint16(OFPP_NONE), # out_port.
        uint16(OFPFF_SEND_FLOW_REM), # flags.
        [OfpActionHeader(
            OFPAT_OUTPUT, # header type.
            0x0008 # Action length.
        )] # actions
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
function bytes(ui::Uint8)
    ui
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

start_server()
