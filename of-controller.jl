# XXX isn't there some kind of type I can define for this?
# XXX this type should convert between string representation and integers by itself efficiently
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
# OFP_PORT_CONFIG Flags to indicate behavior of the physical port. These flags are used in ofp_py_port to describe the current configuration. They are used in the ofp_port_mod message to configure the port's behavior.
const OFPPC_PORT_DOWN = 1 << 0 # Port is administratively down
const OFPPC_NO_STP = 1 << 1 # Disable 802.1D spanning tree on port.
const OFPPC_NO_RECV = 1 << 2 # Drop all packets except 802.1D spanning tree packets.
const OFPPC_NO_RECV_STP = 1 << 3 # Drop received 802.1D STP packets.
const OFPPC_NO_FLOOD = 1 << 4 # Do not include this port when flooding.
const OFPPC_NO_FWD = 1 << 5 # Drop packets forwarded to port.
const OFPPC_NO_PACKET_IN = 1 << 6 # Do not send packet-in msgs fort port.
# OFP_PORT_STATE Current state of the physical port. These are not configurable from the controller.
const OFPPS_LINK_DOWN = 1 << 0 # No physical link present.
# The OFPPS_STP_* bits have no effect on switch operation. The controller must adjust OFPPC_NO_RECV, OFPPC_NO_FWD, and OFPPC_NO_PACKET_IN appropriately to fully implement an 802.1D spanning tree.
const OFPPS_STP_LISTEN = 0 << 8 # Not learning or relaying frames.
const OFPPS_STP_LEARN = 1 << 8 # Learning but not relaying frames.
const OFPPS_STP_FORWARD = 2 << 8 # Learning and relaying frames.
const OFPPS_STP_BLOCK = 3 << 8 # Not part of spanning tree.
const OFPPS_STP_MASK = 3 << 8 # Bit mask for OFPPS_STP_* values.
# OFP_PORT Port numbering. Physical ports are numbered starting from 1.
# Maximum number of physical switch ports.
const OFPP_MAX = 0xff00
# Fake output "ports".
const OFPP_IN_PORT = 0xfff8 # Send the packet out the input port. This virtual port must be explicitly used in order to send back out the input port.
const OFPP_TABLE = 0xfff9 # Perform actions in flow table. NB: This can only be the destination port for packet-out messages.
const OFPP_NORMAL = 0xfffa # Process with normal L2/L3 switching.
const OFPP_FLOOD = 0xfffb # All physical ports except input port and those disabled by STP.
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

abstract OfpStruct
immutable OfpHeader <: OfpStruct
    protoversion::Uint8
    msgtype::Uint8
    msglen::Uint16
    msgidx::Uint32
end
OfpHeader(protoversion::Integer, msgtype::Integer, msglen::Integer, msgidx::Integer) = OfpHeader(convert(Uint8, protoversion), convert(Uint8, msgtype), convert(Uint16, msglen), convert(Uint32, msgidx))
# XXX implement proper conversion functions
function tostring(header::OfpHeader)
    "<Version: $(header.protoversion), type: $(header.msgtype), length: $(header.msglen), idx: $(header.msgidx)>"
end
# XXX implement proper conversion functions
function headertobytes(header::OfpHeader)
    msg = Array(Uint8, header.msglen)
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

abstract OfpMessage <: OfpStruct
# Description of physical port
immutable OfpPhyPort <: OfpStruct
    port_no::Uint16
    hw_addr::Array{Uint8,1} # TODO length of array: OFP_MAX_ETH_ALEN
    name::Array{Uint8,1} # Null-terminated. TODO Length: OFP_MAX_PORT_NAME_LEN. XXX what size does the OFP spec assume for chars?
    config::Uint32 # Bitmap of OFPC_* flags.
    state::Uint32 # Bitmap of OFPS_* flas.
    # Bitmaps of OFPPF_* that describe features. All bits zeroed if unsupported or unavailable.
    curr::Uint32 # Current features.
    advertised::Uint32 # Features being advertised by the port.
    supported::Uint32 # Features supported by the port.
    peer::Uint32 # Features advertised by peer.
end
OfpPhyPort(bytes::Array{Uint8,1}) = begin
    # XXX make this more legible somehow?
    port_no = btouint16(bytes[1:2])
    hw_addr = bytes[3:3+OFP_MAX_ETH_ALEN-1]
    name = bytes[3+OFP_MAX_ETH_ALEN:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN-1]
    config = btouint32(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 4 - 1])
    state = btouint32(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 4:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 8 - 1])
    curr = btouint32(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 8:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 12 - 1])
    advertised = btouint32(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 12:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 16 - 1])
    supported = btouint32(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 16:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 20 - 1])
    peer = btouint32(bytes[3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 20:3+OFP_MAX_ETH_ALEN+OFP_MAX_PORT_NAME_LEN + 24 - 1])
    OfpPhyPort(port_no, hw_addr, name, config, state, curr, advertised, supported, peer)
end
# Switch features
immutable OfpFeatures <: OfpMessage
    header::OfpHeader
    datapath_id::Uint64 # Datapath unique ID. The lower 48-bits are for a MAC address, while the upper 16 bits are implementer-defined
    n_buffers::Uint32 # Max packets buffered at once
    n_tables::Uint8 # Number of tables supported by datapath
    # pad::Array{Uint8,1} # Align to 64 bits; length 3; Nothing to do here, since we are doing the rendering manually
    capabilities::Uint32 # Bitmap of supported "ofp_capabilities"
    actions::Uint32 # Bitmap of supported "ofp_action_types"
    ports::Vector{OfpPhyPort} # Port definitions. The number of ports is inferred from the length field in the header.
end
OfpFeatures(header::OfpHeader, body::Array{Uint8,1}) = begin
    # XXX write the array of ports should be created by its own function that
    # takes the corresponding octects
    # compute the number of ports
    numports = uint16((header.msglen - 8 - 24)/48) # len(OfpPhyPort) == 48
    ports::Vector{OfpPhyPort} = Array(OfpPhyPort, numports)
    for p = 1:numports
        ports[p] = OfpPhyPort(body[25 + (p - 1)*48:25 + p*48 - 1])
    end
    OfpFeatures(header, btouint64(body[1:8]), btouint32(body[9:12]), body[13], btouint32(body[17:20]), btouint32(body[21:24]), ports)
end
tostring(msg::OfpFeatures) = begin
    str = "<header: $(tostring(msg.header)), datapath_id: $(msg.datapath_id), n_buffers: $(msg.n_buffers), n_tables: $(msg.n_tables), capabilities: $(msg.capabilities), actions: $(msg.actions), ports: $(msg.ports)>"
end
# Switch configuration
immutable OfpSwitchConfig <: OfpMessage
    header::OfpHeader
    flags::Uint16 # OFPC_* flags.
    miss_send_len::Uint16 # Max bytes of new flow that datapath should send to the controller
end
OfpSwitchConfig(header::OfpHeader, body::Array{Uint8,1}) = OfpSwitchConfig(header, btouint16(body[1:2]), btouint16(body[3:4]))
# XXX why does lead to an error that seems completely unrelated to the following line?
#convert(::Type{ASCIIString}, msg::OfpSwitchConfig) = println("Someone just invoked the conversion")
tostring(msg::OfpSwitchConfig) = begin
    str = "<flags: $(msg.flags), miss_send_len: $(msg.miss_send_len)>"
end
# Flow match structures
immutable OfpMatch <: OfpStruct
    wildcards::Uint32 # Wildcards fields
    in_port::Uint16 # Input switch port.
    dl_src::Array{Uint8,1} # Length: OFP_ETH_ALEN; Ethernet source address.
    dl_dst::Array{Uint8,1} # Length: OFP_ETH_ALEN; Ehternet destination address.
    dl_vlan::Uint16 # Input VLAN id.
    dl_vlan_pcp::Uint8 # Input VLAN priority.
    # pad1::Uint8 # Align to 64 bits.
    dl_type::Uint16 # Ethernet frame type.
    nw_tos::Uint8 # IP ToS (actually DSCP field, 6 bits).
    nw_proto::Uint8 # IP protocol or lower 8 bits of ARP opcode.
    # pad2::Array{Uint8,1} # Length: 2; Algin to 64 bits.
    nw_src::Uint32 # IP source address.
    nd_dst::Uint32 # IP destination address.
    tp_src::Uint16 # TCP/UDP source port.
    tp_dst::Uint16 # TCP/UDP destination port.
end
OfpMatch(body::Array{Uint8,1}) = OfpMatch(
    btouint32(body[1:4]), # wildcards
    btouint16(body[5:6]), # in_port
    # XXX the spec (1.0.0) say it should be OFP_ETH_MAX_ALEN, but never defines
    # it. The text actually refers to OFP_ETH_MAX_ALEN, so I am replacing the
    # constant in the followin accordingly.
    body[7:7 + OFP_ETH_MAX_ALEN - 1], # dl_src
    body[7 + OFP_ETH_MAX_ALEN : 7 + 2*OFP_ETH_MAX_ALEN - 1], # dl_dst
    btouint16(body[7 + 2*OFP_ETH_MAX_ALEN:7 + 2*OFP_ETH_MAX_ALEN + 1]), # dl_vlan
    body[7 + 2*OFP_ETH_MAX_ALEN + 2], # dl_vlan_pcp
    btouint16(body[7 + 2*OFP_ETH_MAX_ALEN + 3:7 + 2*OFP_ETH_MAX_ALEN + 4]), # dl_type
    body[7 + 2*OFP_ETH_MAX_ALEN + 5], # nw_tos
    body[7 + 2*OFP_ETH_MAX_ALEN + 6], # nw_proto
    btouint32(body[7 + 2*OFP_ETH_MAX_ALEN + 7:7 + 2*OFP_ETH_MAX_ALEN + 10]), # nw_src
    btouint32(body[7 + 2*OFP_ETH_MAX_ALEN + 11:7 + 2*OFP_ETH_MAX_ALEN + 14]), # nw_dst
    btouint16(body[7 + 2*OFP_ETH_MAX_ALEN + 15:7 + 2*OFP_ETH_MAX_ALEN + 16]), # tp_src
    btouint16(body[7 + 2*OFP_ETH_MAX_ALEN + 17:7 + 2*OFP_ETH_MAX_ALEN + 18]), # tp_dst
)
immutable OfpActionHeader <: OfpStruct
    htype::Uint16 # One of OFPAT_*. XXX Accroding to spec it should be "type",
                    # which in Julia is a keyword however.
    len::Uint16 # Length of action, including this header. This is the length of
                # action, including any padding to make it 64-bit algined.
    # pad::Array{Uint8,1} Length: 4
end
OfpActionHeader(body::Array{Uint8,1}) = OfpActionHeader(btouint16(body[1:2]),
btouint16(body[3:4]))
OfpActionHeaders(body::Array{Uint8,1}) = begin
    numheaders = length(body)/8
    headers::Array{OfpHeader,1} = Array(Ofpheader, numheaders)
    for i = 1:numheaders
        headers[i] = OfpHeader(body[(i - 1)*8+1:i*8])
    end
    headers
end
# Packet in messages
immutable OfpPacketIn <: OfpMessage
    header::OfpHeader 
    buffer_id::Uint32 # ID assigned by datapath.
    total_len::Uint16 # Full length of frame.
    in_port::Uint16 # Port on which frame was received.
    reason::Uint8 # Reason packet is being sent (one of OFPR_*).
    # pad::Uint8
    data::Array{Uint8,1}  # Ethernet frame, halfway through 32-bit word, so the
                           # IP header is 32-bit aligned. The amount of data is inferred from the length
                           # field in the header. Because of padding, offsetof(struct ofp_packet_in,
                           # data) == sizeof(struct ofp_packet_in) - 2.
end
tostring(msg::OfpPacketIn) = "<header: $(tostring(msg.header)), buffer_id: $(msg.buffer_id), total_len: $(msg.total_len), in_port: $(msg.in_port), reason: $(msg.reason), data: $(msg.data)>"
OfpPacketIn(header::OfpHeader, body::Array{Uint8,1}) = begin
    datalen = length(body) - 10
    data = Array(Uint8, datalen)
    for i = 1:datalen
        data[i] = body[11 + i - 1]
    end
    OfpPacketIn(header, btouint32(body[1:4]), btouint16(body[5:6]), btouint16(body[7:8]), body[9], data)
end
# Port status messages
immutable OfpPortStatus <: OfpMessage
    header::OfpHeader
    reason::Uint8 # One of OFPPR_*
    # pad::Array{Uint8,1} # length: 7; Align to 64 bits
    desc::OfpPhyPort
end
OfpPortStatus(header::OfpHeader, body::Array{Uint8,1}) = OfpPortStatus(header, body[1], OfpPhyPort(body[17:64]))
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
    out_port::Uint16 # For OFPFC_DELETE* commands, require matching entries to include this as an output port. A value of OFPP_NONE indicates no restriction.
    flags::Uint16 # One of OFPFF_*.
    actions::Array{OfpActionHeader,1} # The action length is inferred from the length field in the header.
end
OfpFlowMod(header::OfpHeader, body::Array{Uint8,1}) = begin
    OfpFlowMod(header, # header
    OfpMatch(body[1:40]), # match
    btouint64(body[41:48]), # cookie
    btouint16(body[49:50]), # command
    btouint16(body[51:52]), # idle_timeout
    btouint16(body[53:54]), # hard_timeout
    btouint16(body[55:56]), # priority
    btouint32(body[57:60]), # buffer_id
    btouint16(body[61:62]), # out_port
    btouint16(body[63:64]), # flags
    OfpActionHeaders(body[65:end])) # actions
end
# Empty messages, no body, but a header (HELLO, ECHO, ...)
immutable OfpEmptyMessage <: OfpMessage
    header::OfpHeader
end

type UnrecognizedMessageError <: Exception
end

function processrequest(message::OfpMessage, socket::TcpSocket)
    try
        if message.header.msgtype == OFPT_HELLO
            info("Got HELLO, replying HELLO")
            # XXX how does the msgidx work?
            write(socket, headertobytes(OfpHeader(1, OFPT_HELLO, 8, 0xff)))
            info("Sending FEATURES_REQUEST")
            write(socket, headertobytes(OfpHeader(1, OFPT_FEATURES_REQUEST, 8, 0xfe)))
            info("Sending GET_CONFIG_REQUEST")
            write(socket, headertobytes(OfpHeader(1, OFPT_GET_CONFIG_REQUEST, 8, 0xfd)))
        elseif message.header.msgtype == OFPT_FEATURES_REPLY
            # TODO convert the body to a proper body type and output the contents
            info("Got FEATURES_REPLY: $(tostring(message))")
        elseif message.header.msgtype == OFPT_ECHO_REQUEST
            info("Got ECHO_REQUEST, replying ECHO_REPLY")
            write(socket, headertobytes(OfpHeader(1, OFPT_ECHO_REPLY, 8, 0xfa)))
        elseif message.header.msgtype == OFPT_GET_CONFIG_REPLY
            info("Got GET_CONFIG_REPLY: $(tostring(message))")
        elseif message.header.msgtype == OFPT_PACKET_IN
            info("Got PACKET_IN: $(tostring(message))")
        end
    catch e
        error("Processing message of type <$(message.header.msgtype)> failed: $e")
        Base.error_show(STDERR, e, catch_backtrace())
    end
end

function assemblemessage(header::OfpHeader, body::Array{Uint8,1})
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
    else
        warn("Got an unrecognized message of type $(header.msgtype), which I am ignoring")
        #throw(UnrecognizedMessageError())
    end
end

# XXX there must be something like this somewhere in Julia's API
# utility functions for assembling bytes to Uints
# TODO how about writing "convert" methods for this?
function btouint16(bytes)
    ui = uint16(bytes[2]) << 8
    ui |= uint16(bytes[1])
    ntoh(ui)
end
function btouint32(bytes)
    ui = uint32(bytes[4]) << 24
    ui |= uint32(bytes[3]) << 16
    ui |= uint32(bytes[2]) << 8
    ui |= uint32(bytes[1])
    ntoh(ui)
end
function btouint64(bytes)
    ui = uint64(bytes[8]) << 56
    ui |= uint64(bytes[7]) << 48
    ui |= uint64(bytes[6]) << 40
    ui |= uint64(bytes[5]) << 32
    ui |= uint64(bytes[4]) << 24
    ui |= uint64(bytes[3]) << 16
    ui |= uint64(bytes[2]) << 8
    ui |= uint64(bytes[1])
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
    write(sock, headertobytes(OfpHeader(1, OFPT_HELLO, 8, 255)))
end

start_server()

