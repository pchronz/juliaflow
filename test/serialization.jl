# TODO Check whether faulty inputs are caught.
using Base.Test
require("../of-controller.jl")
using OpenFlow

# OfpHeader
# Test the constructor.
header = OfpHeader(OFPT_HELLO, uint16(8))
@test header.protoversion == 0x01
@test header.msgtype == OFPT_HELLO
@test header.msglen == uint16(8)
@test header.msgidx == uint32(0)
# Test the serialization.
headerbyts = b"\x01\x00\x00\x08\x00\x00\x00\x00"
@test bytes(header) == headerbyts
@test give_length(header) == 8

# OfpQueueGetConfigRequest
# Test the constructor.
header = OfpHeader(OFPT_QUEUE_GET_CONFIG_REQUEST, 0x00C)
qgcreq = OfpQueueGetConfigRequest(header, 0xAB)
@test qgcreq.port == 0xAB
# Test the serialization.
qgcreqbyts = b"\x01\x14\x00\x0C\x00\x00\x00\x00\x00\xAB\x00\x00"
@test bytes(qgcreq) == qgcreqbyts
# Test the deserialization.
qgcrdeser = OfpQueueGetConfigRequest(header, qgcreqbyts[9:end])
@test qgcrdeser.port == 0xAB
# Test length.
@test give_length(qgcreq) == 12
@test give_length(qgcrdeser) == 12

# OfpQueuePropHeader
# Test the constructor.
qpheader = OfpQueuePropHeader(uint16(OFPQT_MIN_RATE), uint16(8))
@test qpheader.property == OFPQT_MIN_RATE
@test qpheader.len == 8
# Test the serialization.
qphbyts = b"\x00\x01\x00\x08\x00\x00\x00\x00"
@test bytes(qpheader) == qphbyts
# Test the deserialization.
qpheaderdeser = OfpQueuePropHeader(qphbyts)
@test qpheaderdeser.property == OFPQT_MIN_RATE
@test qpheaderdeser.len == 8
# Test length.
@test give_length(qpheader) == 8
@test give_length(qpheaderdeser) == 8

# OfpQueuePropNone
# Test the constructor.
qpheader = OfpQueuePropHeader(uint16(OFPQT_NONE), uint16(8))
qpnone = OfpQueuePropNone(qpheader)
@test qpnone.header == qpheader
# Test the serialization.
qpnonebyts = b"\x00\x00\x00\x08\x00\x00\x00\x00"
@test bytes(qpnone) == qpnonebyts
# Test the deserialization.
qpnonedeser = OfpQueuePropNone(qpnonebyts)
@test qpnonedeser.header.property == qpheader.property
@test qpnonedeser.header.len == qpheader.len
# Test length.
@test give_length(qpnone) == 8
@test give_length(qpnonedeser) == 8

# OfpQueuePropMinRate
qpheader = OfpQueuePropHeader(uint16(OFPQT_MIN_RATE), uint16(16))
# Test the constructor.
qpminrate = OfpQueuePropMinRate(qpheader, uint16(10))
@test qpminrate.rate == 10
# Test the serialization.
qpminratebyts = b"\x00\x01\x00\x10\x00\x00\x00\x00\x00\x0A\x00\x00\x00\x00\x00\x00"
@test bytes(qpminrate) == qpminratebyts
# Test the deserialization.
qpminratedeser = OfpQueuePropMinRate(qpminratebyts)
@test qpminratedeser.rate == 10
# Test length.
@test give_length(qpminrate) == 16
@test give_length(qpminratedeser) == 16

# OfpPacketQueue
# Test the constructor.
pqueue = OfpPacketQueue(uint32(1), uint16(32), [qpminrate, qpnone])
@test pqueue.queue_id == 1
@test pqueue.len == 32
@test contains(pqueue.properties, qpminrate)
@test contains(pqueue.properties, qpnone)
# Test the serialization.
pqueuebyts = b"\x00\x00\x00\x01\x00\x20\x00\x00\x00\x01\x00\x10\x00\x00\x00\x00\x00\x0A\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00"
@test bytes(pqueue) == pqueuebyts
# Test the deserialization.
pqueuedeser = OfpPacketQueue(pqueuebyts)
@test pqueuedeser.queue_id == 1
@test pqueuedeser.len == 32
@test pqueuedeser.properties[1].rate == qpminrate.rate
@test pqueuedeser.properties[2].header.property == qpnone.header.property
# Test length.
@test give_length(pqueue) == 32
@test give_length(pqueuedeser) == 32

# OfpQueueGetConfigReply
header = OfpHeader(OFPT_QUEUE_GET_CONFIG_REPLY, uint16(80))
# Test the constructor.
qgcreply = OfpQueueGetConfigReply(header, uint16(1), [pqueue, pqueue])
@test qgcreply.header == header
@test qgcreply.port == 1
@test qgcreply.queues == [pqueue, pqueue]
# Test the serialization.
qgcrbyts = b"\x01\x15\x00\x50\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00"
pqueuebyts = b"\x00\x00\x00\x01\x00\x20\x00\x00\x00\x01\x00\x10\x00\x00\x00\x00\x00\x0A\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00"
append!(qgcrbyts, pqueuebyts)
append!(qgcrbyts, pqueuebyts)
@test bytes(qgcreply) == qgcrbyts
# Test the deserialization.
qgcrdeser = OfpQueueGetConfigReply(header, qgcrbyts[9:end])
@test qgcrdeser.header.msgtype == header.msgtype
@test qgcrdeser.header.msglen == header.msglen
@test qgcrdeser.port == 1
@test qgcrdeser.queues[1].queue_id == 1
@test qgcrdeser.queues[1].len == 32
@test qgcrdeser.queues[2].queue_id == 1
@test qgcrdeser.queues[2].len == 32
# Test length.
@test give_length(qgcreply) == length(qgcrbyts)
@test give_length(qgcrdeser) == length(qgcrbyts)

# OfpError
header = OfpHeader(OFPT_ERROR, uint16(100))
# Test the constructor.
teststr = ascii("Something went really wrong over here! I think we should do
something about it, quickly.")
err = OfpError(header, uint16(OFPET_BAD_REQUEST), uint16(OFPBRC_BAD_VERSION),
    convert(Bytes, teststr))
convert(Bytes, teststr)
@test err.header == header
@test err.typ == OFPET_BAD_REQUEST
@test err.code == OFPBRC_BAD_VERSION
@test ascii(err.data) == teststr
# Test the serialization.
errbyts = bytes(header)
append!(errbyts, b"\x00\x01\x00\x00")
append!(errbyts, convert(Bytes, teststr))
@test bytes(err) == errbyts
# Test the deserialization.
errdeser = OfpError(header, errbyts[9:end])
@test errdeser.header == header
@test errdeser.typ == OFPET_BAD_REQUEST
@test errdeser.code == OFPBRC_BAD_VERSION
@test ascii(errdeser.data) == teststr
# Test length.
@test 100 == give_length(err)
@test 100 == give_length(errdeser)

# OfpPhyPort
# Test the constructor.
hw_addr = Array(Uint8, OFP_MAX_ETH_ALEN)
name = Array(Uint8, OFP_MAX_PORT_NAME_LEN)
phyport = OfpPhyPort(uint16(1), hw_addr, name, OFPC_FLOW_STATS, OFPPS_LINK_DOWN,
    OFPPF_10MB_HD, OFPPF_100MB_HD, OFPPF_1GB_HD, OFPPF_COPPER)
@test phyport.port_no == 1
@test phyport.hw_addr == hw_addr
@test phyport.name == name
@test phyport.config == OFPC_FLOW_STATS
@test phyport.state == OFPPS_LINK_DOWN
@test phyport.curr ==  OFPPF_10MB_HD
@test phyport.advertised == OFPPF_100MB_HD
@test phyport.supported == OFPPF_1GB_HD
@test phyport.peer == OFPPF_COPPER
# Test the serialization.
phyportbyts = b"\x00\x01"
append!(phyportbyts, hw_addr)
append!(phyportbyts, name)
append!(phyportbyts, b"\x00\x00\x00\x01")
append!(phyportbyts, b"\x00\x00\x00\x01")
append!(phyportbyts, b"\x00\x00\x00\x01")
append!(phyportbyts, b"\x00\x00\x00\x04")
append!(phyportbyts, b"\x00\x00\x00\x10")
append!(phyportbyts, b"\x00\x00\x00\x80")
@test bytes(phyport) == phyportbyts
# Test the deserialization.
phyportdeser = OfpPhyPort(phyportbyts)
@test phyportdeser.port_no == 1
@test phyportdeser.hw_addr == hw_addr
@test phyportdeser.name == name
@test phyportdeser.config == OFPC_FLOW_STATS
@test phyportdeser.state == OFPPS_LINK_DOWN
@test phyportdeser.curr ==  OFPPF_10MB_HD
@test phyportdeser.advertised == OFPPF_100MB_HD
@test phyportdeser.supported == OFPPF_1GB_HD
@test phyportdeser.peer == OFPPF_COPPER
# Test length.
@test length(phyportbyts) == give_length(phyport)
@test length(phyportbyts) == give_length(phyportdeser)

# OfpSwitchFeatures
# Test the constructor.
header = OfpHeader(OFPT_FEATURES_REPLY, uint16(128))
phyport = OfpPhyPort(uint16(1), hw_addr, name, OFPC_FLOW_STATS, OFPPS_LINK_DOWN,
    OFPPF_10MB_HD, OFPPF_100MB_HD, OFPPF_1GB_HD, OFPPF_COPPER)
swfeat = OfpSwitchFeatures(header, uint64(42), uint32(15), uint8(3),
    uint32(OFPC_FLOW_STATS), uint32(OFPAT_SET_VLAN_VID), [phyport, phyport])
@test swfeat.header == header
@test swfeat.datapath_id == 42
@test swfeat.n_buffers == 15
@test swfeat.n_tables == 3
@test swfeat.capabilities == OFPC_FLOW_STATS
@test swfeat.actions == OFPAT_SET_VLAN_VID
@test swfeat.ports == [phyport, phyport]
# Test the serialization.
swfeatbyts = bytes(header)
append!(swfeatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x2A")
append!(swfeatbyts, b"\x00\x00\x00\x0F")
append!(swfeatbyts, b"\x03")
append!(swfeatbyts, b"\x00\x00\x00")
append!(swfeatbyts, b"\x00\x00\x00\x01")
append!(swfeatbyts, b"\x00\x00\x00\x01")
append!(swfeatbyts, bytes(phyport))
append!(swfeatbyts, bytes(phyport))
@test bytes(swfeat) == swfeatbyts
# Test the deserialization.
swfeatdeser = OfpSwitchFeatures(header, swfeatbyts[9:end])
@test swfeatdeser.header == header
@test swfeatdeser.datapath_id == 42
@test swfeatdeser.n_buffers == 15
@test swfeatdeser.n_tables == 3
@test swfeatdeser.capabilities == OFPC_FLOW_STATS
@test swfeatdeser.actions == OFPAT_SET_VLAN_VID
@test swfeatdeser.ports[1].port_no == 1
# Test length.
@test give_length(swfeat) == length(swfeatbyts)
@test give_length(swfeatdeser) == length(swfeatbyts)

# OfpSwitchConfig
header = OfpHeader(OFPT_GET_CONFIG_REPLY, uint16(12))
# Test the constructor.
swconf = OfpSwitchConfig(header, OFPC_FLOW_STATS, uint16(64))
@test swconf.header == header
@test swconf.flags == OFPC_FLOW_STATS
@test swconf.miss_send_len == 64
# Test the serialization.
swconfbyts = bytes(header)
append!(swconfbyts, b"\x00\x01")
append!(swconfbyts, b"\x00\x40")
@test bytes(swconf) == swconfbyts
# Test the deserialization.
swconfdeser = OfpSwitchConfig(header, swconfbyts[9:end])
@test swconfdeser.header == header
@test swconfdeser.flags == OFPC_FLOW_STATS
@test swconfdeser.miss_send_len == 64
# Test length.
@test give_length(swconf) == 12
@test give_length(swconfdeser) == 12

# OfpMatch
# Test the constructor.
dl_src = Array(Uint8, OFP_MAX_ETH_ALEN)
dl_dst = Array(Uint8, OFP_MAX_ETH_ALEN)
match = OfpMatch(uint32(0), uint16(13), dl_src, dl_dst, uint16(13), uint16(13),
    uint16(3), uint8(1), uint8(3), uint32(13), uint32(14), uint16(3), uint16(4))
@test match.wildcards == 0
@test match.in_port == 13
@test match.dl_src == dl_src
@test match.dl_dst == dl_dst
@test match.dl_vlan == 13
@test match.dl_vlan_pcp == 13
@test match.dl_type == 3
@test match.nw_tos == 1
@test match.nw_proto == 3
@test match.nw_src == 13
@test match.nw_dst == 14
@test match.tp_src == 3
@test match.tp_dst == 4
# Test the serialization.
matchbyts = b"\x00\x00\x00\x00"
append!(matchbyts, b"\x00\x0D")
append!(matchbyts, dl_src)
append!(matchbyts, dl_dst)
append!(matchbyts, b"\x00\x0D")
append!(matchbyts, b"\x0D")
append!(matchbyts, b"\x00")
append!(matchbyts, b"\x00\x03")
append!(matchbyts, b"\x01")
append!(matchbyts, b"\x03")
append!(matchbyts, b"\x00\x00")
append!(matchbyts, b"\x00\x00\x00\x0D")
append!(matchbyts, b"\x00\x00\x00\x0E")
append!(matchbyts, b"\x00\x03")
append!(matchbyts, b"\x00\x04")
@test bytes(match) == matchbyts
# Test the deserialization.
matchdeser = OfpMatch(matchbyts)
@test matchdeser.wildcards == 0
@test matchdeser.in_port == 13
@test matchdeser.dl_src == dl_src
@test matchdeser.dl_dst == dl_dst
@test matchdeser.dl_vlan == 13
@test matchdeser.dl_vlan_pcp == 13
@test matchdeser.dl_type == 3
@test matchdeser.nw_tos == 1
@test matchdeser.nw_proto == 3
@test matchdeser.nw_src == 13
@test matchdeser.nw_dst == 14
@test matchdeser.tp_src == 3
@test matchdeser.tp_dst == 4
# Test length.
@test give_length(match) == length(matchbyts)
@test give_length(matchdeser) == length(matchbyts)

# OfpActionEmpty
# Test the constructor.
actempty = OfpActionEmpty(OFPAT_STRIP_VLAN, uint16(4))
@test actempty.typ == OFPAT_STRIP_VLAN
@test actempty.len == 4
# Test the serialization.
actemptybyts = b"\x00\x03\x00\x04"
@test bytes(actempty) == actemptybyts
# Test the deserialization.
actemptydeser = OfpActionEmpty(actemptybyts)
@test actemptydeser.typ == OFPAT_STRIP_VLAN
@test actemptydeser.len == 4
# Test length.
@test give_length(actempty) == 4
@test give_length(actemptydeser) == 4

# OfpActionOutput
# Test the constructor.
actout = OfpActionOutput(OFPAT_OUTPUT, uint16(8), uint16(3), uint16(64))
@test actout.typ == OFPAT_OUTPUT
@test actout.len == 8
@test actout.port == 3
@test actout.max_len == 64
# Test the serialization.
actoutbyts = b"\x00\x00\x00\x08\x00\x03\x00\x40"
@test bytes(actout) == actoutbyts
# Test the deserialization.
actoutdeser = OfpActionOutput(actoutbyts)
@test actoutdeser.typ == OFPAT_OUTPUT
@test actoutdeser.len == 8
@test actoutdeser.port == 3
@test actoutdeser.max_len == 64
# Test length.
@test give_length(actout) == 8
@test give_length(actoutdeser) == 8

# OfpActionEnqueue
# Test the constructor.
actenq = OfpActionEnqueue(OFPAT_ENQUEUE, uint16(16), uint16(3), uint32(16))
@test actenq.typ == OFPAT_ENQUEUE
@test actenq.len == 16
@test actenq.port == 3
@test actenq.queue_id == 16
# Test the serialization.
actenqbyts = b"\x00\x0b\x00\x10\x00\x03"
append!(actenqbyts, b"\x00\x00\x00\x00\x00\x00")
append!(actenqbyts, b"\x00\x00\x00\x10")
@test bytes(actenq) == actenqbyts
# Test the deserialization.
actenqdeser = OfpActionEnqueue(actenqbyts)
@test actenqdeser.typ == OFPAT_ENQUEUE
@test actenqdeser.len == 16
@test actenqdeser.port == 3
@test actenqdeser.queue_id == 16
# Test length.
@test give_length(actenq) == 16
@test give_length(actenqdeser) == 16

# OfpActionVlanVid
# Test the constructor.
actvid = OfpActionVlanVid(OFPAT_SET_VLAN_VID, uint16(8), uint16(13))
@test actvid.typ == OFPAT_SET_VLAN_VID
@test actvid.len == 8
@test actvid.vlan_vid == 13
# Test the serialization.
actvidbyts = b"\x00\x01\x00\x08\x00\x0D\x00\x00"
@test bytes(actvid) == actvidbyts
# Test the deserialization.
actviddeser = OfpActionVlanVid(actvidbyts)
@test actviddeser.typ == OFPAT_SET_VLAN_VID
@test actviddeser.len == 8
@test actviddeser.vlan_vid == 13
# Test length.
@test give_length(actvid) == 8
@test give_length(actviddeser) == 8

# OfpActionVlanPcp
# Test the constructor.
actvpcp = OfpActionVlanPcp(OFPAT_SET_VLAN_PCP, uint16(8), uint8(3))
@test actvpcp.typ == OFPAT_SET_VLAN_PCP
@test actvpcp.len == 8
@test actvpcp.vlan_pcp == 3
# Test the serialization.
actvpcpbyts = b"\x00\x02\x00\x08\x03\x00\x00\x00"
@test bytes(actvpcp) == actvpcpbyts
# Test the deserialization.
actvpcpdeser = OfpActionVlanPcp(actvpcpbyts)
@test actvpcpdeser.typ == OFPAT_SET_VLAN_PCP
@test actvpcpdeser.len == 8
@test actvpcpdeser.vlan_pcp == 3
# Test length.
@test give_length(actvpcp) == 8
@test give_length(actvpcpdeser) == 8

# OfpActionDlAddress
# Test the constructor.
dl_addr = Array(Uint8, OFP_MAX_ETH_ALEN)
actdl = OfpActionDlAddress(OFPAT_SET_DL_SRC, uint16(16), dl_addr)
@test actdl.typ == OFPAT_SET_DL_SRC
@test actdl.len == 16
@test actdl.dl_addr == dl_addr
# Test the serialization.
actdlbyts = b"\x00\x04\x00\x10"
append!(actdlbyts, dl_addr)
append!(actdlbyts, b"\x00\x00\x00\x00\x00\x00")
@test bytes(actdl) == actdlbyts
# Test the deserialization.
actdldeser = OfpActionDlAddress(actdlbyts)
@test actdldeser.typ == OFPAT_SET_DL_SRC
@test actdldeser.len == 16
@test actdldeser.dl_addr == dl_addr
# Test length.
@test give_length(actdl) == 16
@test give_length(actdldeser) == 16

# OfpActionNwAddress
# Test the constructor.
actnw = OfpActionNwAddress(OFPAT_SET_NW_SRC, uint16(8), uint32(13))
@test actnw.typ == OFPAT_SET_NW_SRC
@test actnw.len == 8
@test actnw.nw_addr == 13
# Test the serialization.
actnwbyts = b"\x00\x06\x00\x08\x00\x00\x00\x0D"
@test bytes(actnw) == actnwbyts
# Test the deserialization.
actnwdeser = OfpActionNwAddress(actnwbyts)
@test actnwdeser.typ == OFPAT_SET_NW_SRC
@test actnwdeser.len == 8
@test actnwdeser.nw_addr == 13
# Test length.
@test give_length(actnw) == 8
@test give_length(actnwdeser) == 8

# OfpActionNwTos
# Test the constructor.
actnwtos = OfpActionNwTos(OFPAT_SET_NW_TOS, uint16(8), uint8(3))
@test actnwtos.typ == OFPAT_SET_NW_TOS
@test actnwtos.len == 8
@test actnwtos.nw_tos == 3
# Test the serialization.
actnwtosbyts = b"\x00\x08\x00\x08\x03\x00\x00\x00"
@test bytes(actnwtos) == actnwtosbyts
# Test the deserialization.
actnwtosdeser = OfpActionNwTos(actnwtosbyts)
@test actnwtosdeser.typ == OFPAT_SET_NW_TOS
@test actnwtosdeser.len == 8
@test actnwtosdeser.nw_tos == 3
# Test length.
@test give_length(actnwtos) == 8
@test give_length(actnwtosdeser) == 8

# OfpActionTpPort
# Test the constructor.
acttp = OfpActionTpPort(OFPAT_SET_TP_SRC, uint16(8), uint16(13))
@test acttp.typ == OFPAT_SET_TP_SRC
@test acttp.len == 8
@test acttp.tp_port == 13
# Test the serialization.
acttpbyts = b"\x00\x09\x00\x08\x00\x0D\x00\x00"
@test bytes(acttp) == acttpbyts
# Test the deserialization.
acttpdeser = OfpActionTpPort(acttpbyts)
@test acttpdeser.typ == OFPAT_SET_TP_SRC
@test acttpdeser.len == 8
@test acttpdeser.tp_port == 13
# Test length.
@test give_length(acttp) == 8
@test give_length(acttpdeser) == 8

# OfpActionVendor
# Test the constructor.
actven = OfpActionVendor(OFPAT_VENDOR, uint16(24), uint32(63), ones(Uint8, 16))
@test actven.typ == OFPAT_VENDOR
@test actven.len == 24
@test actven.vendor == 63
@test actven.body == ones(Uint8, 16)
# Test the serialization.
actvenbyts = b"\xff\xff\x00\x18\x00\x00\x00\x3f"
append!(actvenbyts, b"\x01\x01\x01\x01\x01\x01\x01\x01")
append!(actvenbyts, b"\x01\x01\x01\x01\x01\x01\x01\x01")
@test bytes(actven) == actvenbyts
# Test the deserialization.
actvendeser = OfpActionVendor(actvenbyts)
@test actvendeser.typ == OFPAT_VENDOR
@test actvendeser.len == 24
@test actvendeser.vendor == 63
@test actvendeser.body == ones(Uint8, 16)
# Test length.
@test give_length(actven) == 24
@test give_length(actvendeser) == 24

# OfpPacketIn
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpPortStatus
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpFlowMod
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpPortMod
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpEmptyMessage
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpDescStats
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpFlowStatsRequest
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# 30
# OfpFlowStats
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpAggregateStatsRequest
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpAggregateStatsReply
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpTableStats
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpPortStatsRequest
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpPortStats
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpQueueStatsRequest
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpQueueStats
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpVendorStatsRequest
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpVendorStatsReply
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# 40
# OfpStatsRequest
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpStatsReply
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpPacketOut
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpFlowRemoved
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# OfpVendorHeader
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

println("It seems that all went fine, congratulations!")

