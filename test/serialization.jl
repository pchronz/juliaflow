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

using Base.Test
require("../of-controller.jl")
using OpenFlow

info("Starting tests...")
tic()

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
header = OfpHeader(OFPT_QUEUE_GET_CONFIG_REQUEST)
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
header = OfpHeader(OFPT_QUEUE_GET_CONFIG_REPLY)
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
header = OfpHeader(OFPT_ERROR)
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
header = OfpHeader(OFPT_FEATURES_REPLY)
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
header = OfpHeader(OFPT_GET_CONFIG_REPLY)
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
header = OfpHeader(OFPT_PACKET_IN)
# Test the constructor.
packin = OfpPacketIn(header, uint32(13), uint16(42), uint16(2), OFPR_NO_MATCH,
    zeros(Uint8, 16))
@test packin.header ==  header
@test packin.buffer_id == 13
@test packin.total_len == 42
@test packin.in_port == 2
@test packin.reason == OFPR_NO_MATCH
@test packin.data == zeros(Uint8, 16)
# Test the serialization.
packinbyts = bytes(header)
append!(packinbyts, b"\x00\x00\x00\x0D")
append!(packinbyts, b"\x00\x2A")
append!(packinbyts, b"\x00\x02")
append!(packinbyts, b"\x00")
append!(packinbyts, b"\x00")
append!(packinbyts, b"\x00\x00\x00\x00\x00\x00\x00\x00")
append!(packinbyts, b"\x00\x00\x00\x00\x00\x00\x00\x00")
@test bytes(packin) == packinbyts
# Test the deserialization.
packindeser = OfpPacketIn(header, packinbyts[9:end])
@test packindeser.header ==  header
@test packindeser.buffer_id == 13
@test packindeser.total_len == 42
@test packindeser.in_port == 2
@test packindeser.reason == OFPR_NO_MATCH
@test packindeser.data == zeros(Uint8, 16)
# Test length.
@test give_length(packin) == length(packinbyts)
@test give_length(packindeser) == length(packinbyts)

# OfpPortStatus
header = OfpHeader(OFPT_PORT_STATUS)
# Test the constructor.
hw_addr = Array(Uint8, OFP_MAX_ETH_ALEN)
name = Array(Uint8, OFP_MAX_PORT_NAME_LEN)
phyport = OfpPhyPort(uint16(1), hw_addr, name, OFPC_FLOW_STATS, OFPPS_LINK_DOWN,
    OFPPF_10MB_HD, OFPPF_100MB_HD, OFPPF_1GB_HD, OFPPF_COPPER)
portstatus = OfpPortStatus(header, OFPPR_ADD, phyport)
@test portstatus.header == header
@test portstatus.reason == OFPPR_ADD
@test portstatus.desc == phyport
# Test the serialization.
portstatusbyts = bytes(header)
append!(portstatusbyts, b"\x00")
append!(portstatusbyts, b"\x00\x00\x00\x00\x00\x00\x00")
append!(portstatusbyts, bytes(phyport))
@test bytes(portstatus) == portstatusbyts
# Test the deserialization.
portstatusdeser = OfpPortStatus(header, portstatusbyts[9:end])
@test portstatusdeser.header == header
@test portstatusdeser.reason == OFPPR_ADD
@test portstatusdeser.desc.port_no == 1
@test portstatusdeser.desc.hw_addr == hw_addr
@test portstatusdeser.desc.name == name
@test portstatusdeser.desc.config == OFPC_FLOW_STATS
@test portstatusdeser.desc.state == OFPPS_LINK_DOWN
# Test length.
@test give_length(portstatus) == length(portstatusbyts)
@test give_length(portstatusdeser) == length(portstatusbyts)

# OfpFlowMod
header = OfpHeader(OFPT_FLOW_MOD)
dl_src = Array(Uint8, OFP_MAX_ETH_ALEN)
dl_dst = Array(Uint8, OFP_MAX_ETH_ALEN)
match = OfpMatch(uint32(0), uint16(13), dl_src, dl_dst, uint16(13), uint16(13),
    uint16(3), uint8(1), uint8(3), uint32(13), uint32(14), uint16(3), uint16(4))
actout = OfpActionOutput(OFPAT_OUTPUT, uint16(8), uint16(3), uint16(64))
actven = OfpActionVendor(OFPAT_VENDOR, uint16(24), uint32(63), ones(Uint8, 16))
acttp = OfpActionTpPort(OFPAT_SET_TP_SRC, uint16(8), uint16(13))
# Test the constructor.
flomod = OfpFlowMod(header, match, uint64(13), OFPFC_DELETE, uint16(5),
    uint16(7), uint16(1), uint32(15), uint16(2), OFPFF_SEND_FLOW_REM, [actout,
    actven, acttp])
@test flomod.header == header
@test flomod.match == match
@test flomod.cookie == 13
@test flomod.command == OFPFC_DELETE
@test flomod.idle_timeout == 5
@test flomod.hard_timeout == 7
@test flomod.priority == 1
@test flomod.buffer_id == 15
@test flomod.out_port == 2
@test flomod.flags == OFPFF_SEND_FLOW_REM
@test flomod.actions == [actout, actven, acttp]
# Test the serialization.
flomodbyts = bytes(header)
append!(flomodbyts, bytes(match))
append!(flomodbyts, b"\x00\x00\x00\x00\x00\x00\x00\x0D")
append!(flomodbyts, b"\x00\x03")
append!(flomodbyts, b"\x00\x05")
append!(flomodbyts, b"\x00\x07")
append!(flomodbyts, b"\x00\x01")
append!(flomodbyts, b"\x00\x00\x00\x0F")
append!(flomodbyts, b"\x00\x02")
append!(flomodbyts, b"\x00\x01")
append!(flomodbyts, reduce((els, el)->([els, bytes(el)]), Uint8[], [actout,
    actven,acttp]))
@test bytes(flomod) == flomodbyts
# Test the deserialization.
flomoddeser = OfpFlowMod(header, flomodbyts[9:end])
@test flomoddeser.header == header
@test flomoddeser.match.wildcards == 0
@test flomoddeser.match.in_port == 13
@test flomoddeser.match.dl_src == dl_src
@test flomoddeser.match.dl_dst == dl_dst
@test flomoddeser.match.dl_vlan == 13
@test flomoddeser.match.dl_vlan_pcp == 13
@test flomoddeser.match.dl_type == 3
@test flomoddeser.match.nw_tos == 1
@test flomoddeser.match.nw_proto == 3
@test flomoddeser.match.nw_src == 13
@test flomoddeser.match.nw_dst == 14
@test flomoddeser.match.tp_src == 3
@test flomoddeser.match.tp_dst == 4
@test flomoddeser.cookie == 13
@test flomoddeser.command == OFPFC_DELETE
@test flomoddeser.idle_timeout == 5
@test flomoddeser.hard_timeout == 7
@test flomoddeser.priority == 1
@test flomoddeser.buffer_id == 15
@test flomoddeser.out_port == 2
@test flomoddeser.flags == OFPFF_SEND_FLOW_REM
@test bytes(flomoddeser.actions[1]) == bytes(actout)
@test bytes(flomoddeser.actions[2]) == bytes(actven)
@test bytes(flomoddeser.actions[3]) == bytes(acttp)
# Test length.
@test give_length(flomod) == length(flomodbyts)
@test give_length(flomoddeser) == length(flomodbyts)

# OfpPortMod
header = OfpHeader(OFPT_PORT_MOD)
# Test the constructor.
hw_addr = Array(Uint8, OFP_MAX_ETH_ALEN)
pormod = OfpPortMod(header, uint16(11), hw_addr, OFPPC_PORT_DOWN, OFPPC_NO_STP,
    uint32(0))
@test pormod.header == header
@test pormod.port_no == 11
@test pormod.hw_addr == hw_addr
@test pormod.config == OFPPC_PORT_DOWN
@test pormod.mask == OFPPC_NO_STP
@test pormod.advertise == 0
# Test the serialization.
pormodbyts = bytes(header)
append!(pormodbyts, b"\x00\x0B")
append!(pormodbyts, hw_addr)
append!(pormodbyts, b"\x00\x00\x00\x01")
append!(pormodbyts, b"\x00\x00\x00\x02")
append!(pormodbyts, b"\x00\x00\x00\x00")
append!(pormodbyts, b"\x00\x00\x00\x00")
@test bytes(pormod) == pormodbyts
# Test the deserialization.
pormoddeser = OfpPortMod(header, pormodbyts[9:end])
@test pormoddeser.header == header
@test pormoddeser.port_no == 11
@test pormoddeser.hw_addr == hw_addr
@test pormoddeser.config == OFPPC_PORT_DOWN
@test pormoddeser.mask == OFPPC_NO_STP
@test pormoddeser.advertise == 0
# Test length.
@test give_length(pormod) == length(pormodbyts)
@test give_length(pormoddeser) == length(pormodbyts)

# OfpEmptyMessage
header = OfpHeader(OFPT_STATS_REPLY)
# Test the constructor.
empty = OfpEmptyMessage(header)
@test empty.header == header
# Test the serialization.
emptybyts = bytes(header)
@test bytes(empty) == emptybyts
# Test the deserialization.
emptydeser = OfpEmptyMessage(header, Uint8[])
@test emptydeser.header == header
# Test length.
@test give_length(empty) == 8
@test give_length(emptydeser) == 8

# OfpDescStats
# Test the constructor.
mfr_desc = Array(Uint8, DESC_STR_LEN)
hw_desc = Array(Uint8, DESC_STR_LEN)
sw_desc = Array(Uint8, DESC_STR_LEN)
serial_num = Array(Uint8, SERIAL_NUM_LEN)
dp_desc = Array(Uint8, DESC_STR_LEN)
descstats = OfpDescStats(mfr_desc, hw_desc, sw_desc, serial_num, dp_desc)
@test descstats.mfr_desc == mfr_desc
@test descstats.hw_desc == hw_desc
@test descstats.sw_desc == sw_desc
@test descstats.serial_num == serial_num
@test descstats.dp_desc == dp_desc
# Test the serialization.
descstatsbyts = copy(mfr_desc)
append!(descstatsbyts, hw_desc)
append!(descstatsbyts, sw_desc)
append!(descstatsbyts, serial_num)
append!(descstatsbyts, dp_desc)
@test bytes(descstats) == descstatsbyts
# Test the deserialization.
descstatsdeser = OfpDescStats(descstatsbyts)
@test descstatsdeser.mfr_desc == mfr_desc
@test descstatsdeser.hw_desc == hw_desc
@test descstatsdeser.sw_desc == sw_desc
@test descstatsdeser.serial_num == serial_num
@test descstatsdeser.dp_desc == dp_desc
# Test length.
@test give_length(descstats) == length(descstatsbyts)
@test give_length(descstatsdeser) == length(descstatsbyts)

# OfpFlowStatsRequest
# Test the constructor.
dl_src = Array(Uint8, OFP_MAX_ETH_ALEN)
dl_dst = Array(Uint8, OFP_MAX_ETH_ALEN)
match = OfpMatch(uint32(0), uint16(13), dl_src, dl_dst, uint16(13), uint16(13),
    uint16(3), uint8(1), uint8(3), uint32(13), uint32(14), uint16(3), uint16(4))
flostare = OfpFlowStatsRequest(match, 0xff, OFPP_NONE)
@test flostare.match == match
@test flostare.table_id == 0xff
@test flostare.out_port == OFPP_NONE
# Test the serialization.
flostarebyts = bytes(match)
append!(flostarebyts, [0xff])
append!(flostarebyts, b"\x00")
append!(flostarebyts, b"\xff\xff")
@test bytes(flostare) == flostarebyts
# Test the deserialization.
flostaredeser = OfpFlowStatsRequest(flostarebyts)
@test flostaredeser.match.wildcards == 0
@test flostaredeser.match.in_port == 13
@test flostaredeser.match.dl_src == dl_src
@test flostaredeser.match.dl_dst == dl_dst
@test flostaredeser.match.dl_vlan == 13
@test flostaredeser.match.dl_vlan_pcp == 13
@test flostaredeser.match.dl_type == 3
@test flostaredeser.match.nw_tos == 1
@test flostaredeser.match.nw_proto == 3
@test flostaredeser.match.nw_src == 13
@test flostaredeser.match.nw_dst == 14
@test flostaredeser.match.tp_src == 3
@test flostaredeser.match.tp_dst == 4
@test flostaredeser.table_id == 0xff
@test flostaredeser.out_port == OFPP_NONE
# Test length.
@test give_length(flostare) == length(flostarebyts)
@test give_length(flostaredeser) == length(flostarebyts)

# OfpFlowStats
dl_src = Array(Uint8, OFP_MAX_ETH_ALEN)
dl_dst = Array(Uint8, OFP_MAX_ETH_ALEN)
match = OfpMatch(uint32(0), uint16(13), dl_src, dl_dst, uint16(13), uint16(13),
    uint16(3), uint8(1), uint8(3), uint32(13), uint32(14), uint16(3), uint16(4))
actout = OfpActionOutput(OFPAT_OUTPUT, uint16(8), uint16(3), uint16(64))
actven = OfpActionVendor(OFPAT_VENDOR, uint16(24), uint32(63), ones(Uint8, 16))
acttp = OfpActionTpPort(OFPAT_SET_TP_SRC, uint16(8), uint16(13))
# Test the constructor.
flowstats = OfpFlowStats(0x0080, 0x01, match, uint32(10), uint32(50), uint16(3),
    uint16(15), uint16(17), uint64(42), uint64(15), uint64(78), [actout, actven,
    acttp])
@test flowstats.length == 48 + give_length(match) + reduce((l, x)->l +
    give_length(x), 0, [actout, actven, acttp])
@test flowstats.table_id == 1
@test flowstats.match == match
@test flowstats.duration_sec == 10
@test flowstats.duration_nsec == 50
@test flowstats.priority == 3
@test flowstats.idle_timeout == 15
@test flowstats.hard_timeout == 17
@test flowstats.cookie == 42
@test flowstats.packet_count == 15
@test flowstats.byte_count == 78
@test flowstats.actions[1] == actout
@test flowstats.actions[2] == actven
@test flowstats.actions[3] == acttp
# Test the serialization.
flowstatsbyts = b"\x00\x80"
append!(flowstatsbyts, b"\x01\x00")
append!(flowstatsbyts, bytes(match))
append!(flowstatsbyts, b"\x00\x00\x00\x0A")
append!(flowstatsbyts, b"\x00\x00\x00\x32")
append!(flowstatsbyts, b"\x00\x03")
append!(flowstatsbyts, b"\x00\x0F")
append!(flowstatsbyts, b"\x00\x11")
append!(flowstatsbyts, b"\x00\x00\x00\x00\x00\x00")
append!(flowstatsbyts, b"\x00\x00\x00\x00\x00\x00\x00\x2A")
append!(flowstatsbyts, b"\x00\x00\x00\x00\x00\x00\x00\x0F")
append!(flowstatsbyts, b"\x00\x00\x00\x00\x00\x00\x00\x4E")
reduce((bs, act)->append!(bs, bytes(act)), flowstatsbyts, [actout, actven, acttp])
@test bytes(flowstats) == flowstatsbyts
# Test the deserialization.
flowstatsdeser = OfpFlowStats(flowstatsbyts)
@test flowstatsdeser.length == 48 + give_length(match) + reduce((l, x)->l +
    give_length(x), 0, [actout, actven, acttp])
@test flowstatsdeser.table_id == 1
@test flowstatsdeser.match.wildcards == 0
@test flowstatsdeser.match.in_port == 13
@test flowstatsdeser.match.dl_src == dl_src
@test flowstatsdeser.match.dl_dst == dl_dst
@test flowstatsdeser.match.dl_vlan == 13
@test flowstatsdeser.match.dl_vlan_pcp == 13
@test flowstatsdeser.match.dl_type == 3
@test flowstatsdeser.match.nw_tos == 1
@test flowstatsdeser.match.nw_proto == 3
@test flowstatsdeser.match.nw_src == 13
@test flowstatsdeser.match.nw_dst == 14
@test flowstatsdeser.match.tp_src == 3
@test flowstatsdeser.match.tp_dst == 4
@test flowstatsdeser.duration_sec == 10
@test flowstatsdeser.duration_nsec == 50
@test flowstatsdeser.priority == 3
@test flowstatsdeser.idle_timeout == 15
@test flowstatsdeser.hard_timeout == 17
@test flowstatsdeser.cookie == 42
@test flowstatsdeser.packet_count == 15
@test flowstatsdeser.byte_count == 78
@test isa(flowstatsdeser.actions[1], OfpActionOutput)
@test isa(flowstatsdeser.actions[2], OfpActionVendor)
@test isa(flowstatsdeser.actions[3], OfpActionTpPort)
# Test length.
@test give_length(flowstats) == length(flowstatsbyts)
@test give_length(flowstatsdeser) == length(flowstatsbyts)

# OfpAggregateStatsRequest
dl_src = Array(Uint8, OFP_MAX_ETH_ALEN)
dl_dst = Array(Uint8, OFP_MAX_ETH_ALEN)
match = OfpMatch(uint32(0), uint16(13), dl_src, dl_dst, uint16(13), uint16(13),
    uint16(3), uint8(1), uint8(3), uint32(13), uint32(14), uint16(3), uint16(4))
# Test the constructor.
aggstatreq = OfpAggregateStatsRequest(match, 0xff, OFPP_NONE)
@test aggstatreq.match == match
@test aggstatreq.table_id == 0xff
@test aggstatreq.out_port == OFPP_NONE
# Test the serialization.
aggstatreqbyts = bytes(match)
append!(aggstatreqbyts, b"\xff")
append!(aggstatreqbyts, b"\x00")
append!(aggstatreqbyts, b"\xff\xff")
@test bytes(aggstatreq) == aggstatreqbyts
# Test the deserialization.
aggstatreqdeser = OfpAggregateStatsRequest(aggstatreqbyts)
@test aggstatreqdeser.match.wildcards == 0
@test aggstatreqdeser.match.in_port == 13
@test aggstatreqdeser.match.dl_src == dl_src
@test aggstatreqdeser.match.dl_dst == dl_dst
@test aggstatreqdeser.match.dl_vlan == 13
@test aggstatreqdeser.match.dl_vlan_pcp == 13
@test aggstatreqdeser.match.dl_type == 3
@test aggstatreqdeser.match.nw_tos == 1
@test aggstatreqdeser.match.nw_proto == 3
@test aggstatreqdeser.match.nw_src == 13
@test aggstatreqdeser.match.nw_dst == 14
@test aggstatreqdeser.match.tp_src == 3
@test aggstatreqdeser.match.tp_dst == 4
@test aggstatreq.table_id == 0xff
@test aggstatreq.out_port == OFPP_NONE
# Test length.
@test give_length(aggstatreq) == length(aggstatreqbyts)
@test give_length(aggstatreqdeser) == length(aggstatreqbyts)

# OfpAggregateStatsReply
# Test the constructor.
aggstatrep = OfpAggregateStatsReply(uint64(3), uint64(14), uint32(13))
@test aggstatrep.packet_count == 3
@test aggstatrep.byte_count == 14
@test aggstatrep.flow_count == 13
# Test the serialization.
aggstatrepbyts = b"\x00\x00\x00\x00\x00\x00\x00\x03"
append!(aggstatrepbyts, b"\x00\x00\x00\x00\x00\x00\x00\x0E")
append!(aggstatrepbyts, b"\x00\x00\x00\x0D")
append!(aggstatrepbyts, b"\x00\x00\x00\x00")
@test bytes(aggstatrep) == aggstatrepbyts
# Test the deserialization.
aggstatrepdeser = OfpAggregateStatsReply(aggstatrepbyts)
@test aggstatrepdeser.packet_count == 3
@test aggstatrepdeser.byte_count == 14
@test aggstatrepdeser.flow_count == 13
# Test length.
@test give_length(aggstatrep) == length(aggstatrepbyts)
@test give_length(aggstatrepdeser) == length(aggstatrepbyts)

# OfpTableStats
# Test the constructor.
name = Array(Uint8, OFP_MAX_TABLE_NAME_LEN)
tablstat = OfpTableStats(0x01, name, OFPFW_IN_PORT, uint32(3),
    uint32(15), uint64(38), uint64(98))
@test tablstat.table_id == 1
@test tablstat.name == name
@test tablstat.wildcards == OFPFW_IN_PORT
@test tablstat.max_entries == 3
@test tablstat.active_count == 15
@test tablstat.lookup_count == 38
@test tablstat.matched_count == 98
# Test the serialization.
tablstatbyts = b"\x01\x00\x00\x00"
append!(tablstatbyts, name)
append!(tablstatbyts, b"\x00\x00\x00\x01")
append!(tablstatbyts, b"\x00\x00\x00\x03")
append!(tablstatbyts, b"\x00\x00\x00\x0F")
append!(tablstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x26")
append!(tablstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x62")
@test bytes(tablstat) == tablstatbyts
# Test the deserialization.
tablstatdeser = OfpTableStats(tablstatbyts)
@test tablstatdeser.table_id == 1
@test tablstatdeser.name == name
@test tablstatdeser.wildcards == OFPFW_IN_PORT
@test tablstatdeser.max_entries == 3
@test tablstatdeser.active_count == 15
@test tablstatdeser.lookup_count == 38
@test tablstatdeser.matched_count == 98
# Test length.
@test give_length(tablstat) == length(tablstatbyts)
@test give_length(tablstatdeser) == length(tablstatbyts)

# OfpPortStatsRequest
# Test the constructor.
portstatreq = OfpPortStatsRequest(uint16(13))
@test portstatreq.port_no == 13
# Test the serialization.
portstatreqbyts = b"\x00\x0D\x00\x00\x00\x00\x00\x00"
@test bytes(portstatreq) == portstatreqbyts
# Test the deserialization.
portstatreqdeser = OfpPortStatsRequest(portstatreqbyts)
@test portstatreqdeser.port_no == 13
# Test length.
@test give_length(portstatreq) == length(portstatreqbyts)
@test give_length(portstatreqdeser) == length(portstatreqbyts)

# OfpPortStats
# Test the constructor.
portstat = OfpPortStats(0x0003, uint64(1), uint64(2), uint64(3), uint64(4),
    uint64(5), uint64(6), uint64(7), uint64(8), uint64(9), uint64(10),
    uint64(11), uint64(12))
@test portstat.port_no == 3
@test portstat.rx_packets == 1
@test portstat.tx_packets == 2
@test portstat.rx_bytes == 3
@test portstat.tx_bytes == 4
@test portstat.rx_dropped == 5
@test portstat.tx_dropped == 6
@test portstat.rx_errors == 7
@test portstat.tx_errors == 8
@test portstat.rx_frame_err == 9
@test portstat.rx_over_err == 10
@test portstat.rx_crc_err == 11
@test portstat.collisions == 12
# Test the serialization.
portstatbyts = b"\x00\x03\x00\x00\x00\x00\x00\x00"
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x01")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x02")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x03")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x04")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x05")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x06")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x07")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x08")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x09")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x0A")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x0B")
append!(portstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x0C")
@test bytes(portstat) == portstatbyts
# Test the deserialization.
portstatdeser = OfpPortStats(portstatbyts)
@test portstatdeser.port_no == 3
@test portstatdeser.rx_packets == 1
@test portstatdeser.tx_packets == 2
@test portstatdeser.rx_bytes == 3
@test portstatdeser.tx_bytes == 4
@test portstatdeser.rx_dropped == 5
@test portstatdeser.tx_dropped == 6
@test portstatdeser.rx_errors == 7
@test portstatdeser.tx_errors == 8
@test portstatdeser.rx_frame_err == 9
@test portstatdeser.rx_over_err == 10
@test portstatdeser.rx_crc_err == 11
@test portstatdeser.collisions == 12
# Test length.
@test give_length(portstat) == length(portstatbyts)
@test give_length(portstatdeser) == length(portstatbyts)

# OfpQueueStatsRequest
# Test the constructor.
qstatreq = OfpQueueStatsRequest(uint16(1), uint32(2))
@test qstatreq.port_no == 1
@test qstatreq.queue_id == 2
# Test the serialization.
qstatreqbyts = b"\x00\x01"
append!(qstatreqbyts, b"\x00\x00")
append!(qstatreqbyts, b"\x00\x00\x00\x02")
@test bytes(qstatreq) == qstatreqbyts
# Test the deserialization.
qstatreqdeser = OfpQueueStatsRequest(qstatreqbyts)
@test qstatreqdeser.port_no == 1
@test qstatreqdeser.queue_id == 2
# Test length.
@test give_length(qstatreq) == length(qstatreqbyts)
@test give_length(qstatreqdeser) == length(qstatreqbyts)

# OfpQueueStats
# Test the constructor.
qstat = OfpQueueStats(uint16(1), uint32(2), uint64(3), uint64(4), uint64(5))
@test qstat.port_no == 1
@test qstat.queue_id == 2
@test qstat.tx_bytes == 3
@test qstat.tx_packets == 4
@test qstat.tx_errors == 5
# Test the serialization.
qstatbyts = b"\x00\x01"
append!(qstatbyts, b"\x00\x00")
append!(qstatbyts, b"\x00\x00\x00\x02")
append!(qstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x03")
append!(qstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x04")
append!(qstatbyts, b"\x00\x00\x00\x00\x00\x00\x00\x05")
@test bytes(qstatbyts) == qstatbyts
# Test the deserialization.
qstatdeser = OfpQueueStats(qstatbyts)
@test qstatdeser.port_no == 1
@test qstatdeser.queue_id == 2
@test qstatdeser.tx_bytes == 3
@test qstatdeser.tx_packets == 4
@test qstatdeser.tx_errors == 5
# Test length.
@test give_length(qstat) == length(qstatbyts)
@test give_length(qstatdeser) == length(qstatbyts)

# OfpVendorStatsRequest
# Test the constructor.
venstatreq = OfpVendorStatsRequest(b"\x00\x00\x00\x01", b"\x00\x02")
@test venstatreq.vendor_id == b"\x00\x00\x00\x01"
@test venstatreq.body == b"\x00\x02"
# Test the serialization.
venstatreqbyts = b"\x00\x00\x00\x01\x00\x02"
@test bytes(venstatreq) == venstatreqbyts
# Test the deserialization.
venstatreqdeser = OfpVendorStatsRequest(venstatreqbyts)
@test venstatreqdeser.vendor_id == b"\x00\x00\x00\x01"
@test venstatreqdeser.body == b"\x00\x02"
# Test length.
@test give_length(venstatreq) == length(venstatreqbyts)
@test give_length(venstatreqdeser) == length(venstatreqbyts)

# OfpVendorStatsReply
# Test the constructor.
venstatrep = OfpVendorStatsReply(b"\x00\x00\x00\x01", b"\x00\x02")
@test venstatrep.vendor_id == b"\x00\x00\x00\x01"
@test venstatrep.body == b"\x00\x02"
# Test the serialization.
venstatrepbyts = b"\x00\x00\x00\x01\x00\x02"
@test bytes(venstatrep) == venstatrepbyts
# Test the deserialization.
venstatrepdeser = OfpVendorStatsReply(venstatrepbyts)
@test venstatrepdeser.vendor_id == b"\x00\x00\x00\x01"
@test venstatrepdeser.body == b"\x00\x02"
# Test length.
@test give_length(venstatrep) == length(venstatrepbyts)
@test give_length(venstatrepdeser) == length(venstatrepbyts)

# OfpStatsRequest
header = OfpHeader(OFPT_STATS_REQUEST)
venstatreq = OfpVendorStatsRequest(b"\x00\x00\x00\x01", b"\x00\x02")
# Test the constructor.
statreq = OfpStatsRequest{OfpVendorStatsRequest}(header, OFPST_VENDOR, uint16(13),
    venstatreq)
@test statreq.header == header
@test statreq.typ == OFPST_VENDOR
@test statreq.flags == 13
@test statreq.body == venstatreq
# Test the serialization.
statreqbyts = bytes(header)
append!(statreqbyts, b"\xff\xff")
append!(statreqbyts, b"\x00\x0D")
append!(statreqbyts, bytes(venstatreq))
@test bytes(statreq) == statreqbyts
# Test the deserialization.
statreqdeser = OfpStatsRequest(header, statreqbyts[9:end])
@test statreqdeser.header == header
@test statreqdeser.typ == OFPST_VENDOR
@test statreqdeser.flags == 13
@test statreqdeser.body.vendor_id == b"\x00\x00\x00\x01"
@test statreqdeser.body.body == b"\x00\x02"
# Test length.
@test give_length(statreq) == length(statreqbyts)
@test give_length(statreqdeser) == length(statreqbyts)

# OfpStatsReply
header = OfpHeader(OFPT_STATS_REPLY)
venstatrep = OfpVendorStatsReply(b"\x00\x00\x00\x01", b"\x00\x02")
# Test the constructor.
statrep = OfpStatsReply{OfpVendorStatsReply}(header, OFPST_VENDOR, uint16(13), venstatrep)
@test statrep.header == header
@test statrep.typ == OFPST_VENDOR
@test statrep.flags == 13
@test statrep.body == venstatrep
# Test the serialization.
statrepbyts = bytes(header)
append!(statrepbyts, b"\xff\xff")
append!(statrepbyts, b"\x00\x0D")
append!(statrepbyts, bytes(venstatrep))
@test bytes(statrep) == statrepbyts
# Test the deserialization.
statrepdeser = OfpStatsReply(header, statrepbyts[9:end])
@test statrepdeser.header == header
@test statrepdeser.typ == OFPST_VENDOR
@test statrepdeser.flags == 13
@test statrepdeser.body.vendor_id == b"\x00\x00\x00\x01"
@test statrepdeser.body.body == b"\x00\x02"
# Test length.
@test give_length(statrep) == length(statrepbyts)
@test give_length(statrepdeser) == length(statrepbyts)

# OfpPacketOut
actout = OfpActionOutput(OFPAT_OUTPUT, uint16(8), uint16(3), uint16(64))
actven = OfpActionVendor(OFPAT_VENDOR, uint16(24), uint32(63), ones(Uint8, 16))
acttp = OfpActionTpPort(OFPAT_SET_TP_SRC, uint16(8), uint16(13))
actlen = mapreduce(give_length, +, [actout, actven, acttp])
header = OfpHeader(OFPT_PACKET_OUT)
# Test the constructor.
packout = OfpPacketOut(header, uint32(15), uint16(16), uint16(actlen), [actout,
    actven, acttp])
@test packout.header == header
@test packout.buffer_id == 15
@test packout.in_port == 16
@test packout.actions_len == actlen
@test packout.actions[1] == actout
@test packout.actions[2] == actven
@test packout.actions[3] == acttp
# Test the serialization.
packoutbyts = bytes(header)
append!(packoutbyts, b"\x00\x00\x00\x0F")
append!(packoutbyts, b"\x00\x10")
append!(packoutbyts, b"\x00\x28")
packoutbyts = reduce((bs, act)->append!(bs, bytes(act)), packoutbyts, [actout, actven, acttp])
@test bytes(packout) == packoutbyts
# Test the deserialization.
packoutdeser = OfpPacketOut(header, packoutbyts[9:end])
@test packoutdeser.header == header
@test packoutdeser.buffer_id == 15
@test packoutdeser.in_port == 16
@test packoutdeser.actions_len == actlen
@test bytes(packout.actions[1]) == bytes(actout)
@test bytes(packout.actions[2]) == bytes(actven)
@test bytes(packout.actions[3]) == bytes(acttp)
# Test length.
@test give_length(packout) == length(packoutbyts)
@test give_length(packoutdeser) == length(packoutbyts)

# OfpFlowRemoved
dl_src = Array(Uint8, OFP_MAX_ETH_ALEN)
dl_dst = Array(Uint8, OFP_MAX_ETH_ALEN)
match = OfpMatch(uint32(0), uint16(13), dl_src, dl_dst, uint16(13), uint16(13),
    uint16(3), uint8(1), uint8(3), uint32(13), uint32(14), uint16(3), uint16(4))
header = OfpHeader(OFPT_FLOW_REMOVED)
# Test the constructor.
florem = OfpFlowRemoved(header, match, uint64(1), uint16(1), OFPRR_IDLE_TIMEOUT,
    uint32(10), uint32(10), uint16(15), uint64(13), uint64(26))
@test florem.header == header
@test florem.match == match
@test florem.cookie == 1
@test florem.priority == 1
@test florem.reason == OFPRR_IDLE_TIMEOUT
@test florem.duration_sec == 10
@test florem.duration_nsec == 10
@test florem.idle_timeout == 15
@test florem.packet_count == 13
@test florem.byte_count == 26
# Test the serialization.
florembyts = bytes(header)
append!(florembyts, bytes(match))
append!(florembyts, b"\x00\x00\x00\x00\x00\x00\x00\x01")
append!(florembyts, b"\x00\x01")
append!(florembyts, b"\x00\x00")
append!(florembyts, b"\x00\x00\x00\x0A")
append!(florembyts, b"\x00\x00\x00\x0A")
append!(florembyts, b"\x00\x0F\x00\x00")
append!(florembyts, b"\x00\x00\x00\x00\x00\x00\x00\x0D")
append!(florembyts, b"\x00\x00\x00\x00\x00\x00\x00\x1A")
@test bytes(florem) == florembyts
# Test the deserialization.
floremdeser = OfpFlowRemoved(header, florembyts[9:end])
@test floremdeser.header == header
@test floremdeser.match.wildcards == 0
@test floremdeser.match.in_port == 13
@test floremdeser.match.dl_src == dl_src
@test floremdeser.match.dl_dst == dl_dst
@test floremdeser.match.dl_vlan == 13
@test floremdeser.match.dl_vlan_pcp == 13
@test floremdeser.match.dl_type == 3
@test floremdeser.match.nw_tos == 1
@test floremdeser.match.nw_proto == 3
@test floremdeser.match.nw_src == 13
@test floremdeser.match.nw_dst == 14
@test floremdeser.match.tp_src == 3
@test floremdeser.match.tp_dst == 4
@test floremdeser.cookie == 1
@test floremdeser.priority == 1
@test floremdeser.reason == OFPRR_IDLE_TIMEOUT
@test floremdeser.duration_sec == 10
@test floremdeser.duration_nsec == 10
@test floremdeser.idle_timeout == 15
@test floremdeser.packet_count == 13
@test floremdeser.byte_count == 26
# Test length.
@test give_length(florem) == length(florembyts)
@test give_length(floremdeser) == length(florembyts)

# OfpVendorHeader
header = OfpHeader(OFPT_VENDOR)
# Test the constructor.
venhed = OfpVendorHeader(header, uint32(3), b"\x11\x11\x11\x11")
@test venhed.header == header
@test venhed.vendor == 3
@test venhed.body == b"\x11\x11\x11\x11"
# Test the serialization.
venhedbyts = bytes(header)
append!(venhedbyts, b"\x00\x00\x00\x03")
append!(venhedbyts, b"\x11\x11\x11\x11")
@test bytes(venhed) == venhedbyts
# Test the deserialization.
venheddeser = OfpVendorHeader(header, venhedbyts[9:end])
@test venheddeser.header == header
@test venheddeser.vendor == 3
@test venheddeser.body == b"\x11\x11\x11\x11"
# Test length.
@test give_length(venhed) == 16
@test give_length(venheddeser) == 16

toc()
println("It seems that all went fine, congratulations!")

