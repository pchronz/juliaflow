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

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.


# Ofp
# Test the constructor.
# Test the serialization.
# Test the deserialization.

println("It seems that all went fine, congratulations!")

