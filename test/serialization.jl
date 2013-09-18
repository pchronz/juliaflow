# TODO Check whether faulty results are caught as well.
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

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.


# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.
# Test length.

println("It seems that all went fine, congratulations!")

