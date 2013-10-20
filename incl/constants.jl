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
const OFPFW_IN_PORT = 1 << 0 # Switch input port.
const OFPFW_DL_VLAN = 1 << 1 # VLAN id.
const OFPFW_DL_SRC = 1 << 2 # Ethernet source address.
const OFPFW_DL_DST = 1 << 3 # Ethernet destination address.
const OFPFW_DL_TYPE = 1 << 4 # Ethernet frame type.
const OFPFW_NW_PROTO = 1 << 5 # IP protocol.
const OFPFW_TP_SRC = 1 << 6 # TCP/UDP source port.
const OFPFW_TP_DST = 1 << 7 # TCP/UDP destination port.
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

# Error messages.
# OFP_ERROR_TYPE
const OFPET_HELLO_FAILED = 0x00 # Hello protocol failed.
const OFPET_BAD_REQUEST = 0x01 # Request was not understood.
const OFPET_BAD_ACTION = 0x02 # Error in action description.
const OFPET_FLOW_MOD_FAILED = 0x03 # Problem modifying flow entry.
const OFPET_PORT_MOD_FAILED = 0x04 # Port mod request failed.
const OFPET_QUEUE_OP_FAILED = 0x05 # Queue operation failed.
# OFP_BAD_REQUEST_CODE
const OFPBRC_BAD_VERSION = 0x00 # ofp_header.version not supported.
const OFPBRC_BAD_TYPE = 0x01 # ofp_header.type not supported.
const OFPBRC_BAD_STAT = 0x02 # ofp_stats_request.type not supported.
const OFPBRC_BAD_VENDOR = 0x03 # Vendor not supported (in ofp_vendor_header or
    # ofp_stats_request or ofp_stats_reply).
const OFPBRC_BAD_SUBTYPE = 0x04 # Vendor subtype not supported.
const OFPBRC_EPERM = 0x05 # Permissions error.
const OFPBRC_BAD_LEN = 0x06 # Wrong request length for type.
const OFPBRC_BUFFER_EMPTY = 0x07 # Specified buffer has already been used.
const OFPBRC_BUFFER_UNKNOWN = 0x08 # Specified buffer does not exist.
# OFP_BAD_ACTION_CODE
# ofp_error_msg 'code' values for OFPET_BAD_ACTION. 'data' contains at least the
# first 64 bytes of the failed request.
const OFPBAC_BAD_TYPE = 0x00 # Unknown action type.
const OFPBAC_BAD_LEN = 0x01 # Length problem in actions.
const OFPBAC_BAD_VENDOR = 0x02 # Unkown vendor id specified.
const OFPBAC_BAD_VENDOR_TYPE = 0x03 # Unkown action type for vendor id.
const OFPBAC_BAD_OUT_PORT = 0x04 # Problem validating output action.
const OFPBAC_BAD_ARGUMENT = 0x05 # Bad action argument.
const OFPBAC_EPERM = 0x06 # Permissions error.
const OFPBAC_TOO_MANY = 0x07 # Can't handle this many actions.
const OFPBAC_BAD_QUEUE = 0x08 # Problem validating output queue.
# OFP_FLOW_MOD_FAILED_CODE
# ofp_error_msg 'code' values for OFPET_FLOW_MOD_FAILED. 'data' contains at
# least the first 64 bytes of the failed request.
const OFPFMFC_ALL_TABLES_FULL =  # Flow not added because of full tables.
const OFPFMFC_OVERLAP =  # Attempted to add overlapping flow with CHECK_OVERLAP
    # flag set.
const OFPFMFC_EPERM =  # Permissions error.
const OFPFMFC_BAD_EMERG_TIMEOUT =  # Flow not added because of non-zero
    # idle/hard timeout.
const OFPFMFC_BAD_COMMAND =  # Unknown command.
const OFPFMFC_UNSUPPORTED =  # Unsupported action list - cannot process in the
    # order specified.
# OFP_PORT_MOD_FAILED_CODE
# ofp_error_msg 'code' values for OFPET_PORT_MOD_FAILED> 'data' contains at
# least the first 64 bytes of the failed request.
const OFPMFC_BAD_PORT = 0x00 # Specified port does not exist.
const OFPMFC_BAD_HW_ADDR = 0x01 # Specified hardware address is wrong.
# OFP_QUEUE_OP_FAILED_CODE
# ofp_error msg 'code' values for OFPET_QUEUE_OP_FAILED. 'data' contains at
# least the first 64 bytes of the failed request.
const OFPQOFC_BAD_PORT = 0x00 # Invalid port (or port does not exist).
const OFPQOFC_BAD_QUEUE = 0x01 # Queue does not exist.
const OFPQOFC_EPERM = 0x02 # Permissions error.
# OfpQueueProperties
const OFPQT_NONE = 0 # No property defined for a queue (default).
const OFPQT_MIN_RATE = 1 # Minimum datarate guaranteed.
                           # Other rates should be added here (i.e. max rate,
                           # precedence, etc).
# OFP_STATS_TYPES
const OFPST_DESC = 0x00 # Description of this OpenFlow switch. The request body
    # is empty. The reply body is struct ofp_desc-stats.
const OFPST_FLOW = 0x01 # Individual flow statistics. The request body is struct
    # ofp_flow_stats_request. The reply body is an array of structu ofp_flow_stats.
const OFPST_AGGREGATE = 0x02 # Aggregate flow statistics. The request body is
    # struct ofp_aggregate_stats_request. The reply body is struct
    # ofp_aggregate_reply.
const OFPST_TABLE = 0x03 # Flow table statistics. The request body is empty. The
    # reply body is an array of struct ofp_table_stats.
const OFPST_PORT = 0x04 # Physical port statistics. The request body is struct
    # ofp_port_stats_request. The reply body is an array of struct ofp_port_stats.
const OFPST_QUEUE = 0x05 # Queue statistics for a port. The request body defines
    # the port. The reply body is an array of struct ofp_queue_stats. 
const OFPST_VENDOR = 0xffff # Vendor extension. The request and reply bodies
    # begin witha 32-bit vendor ID, which takes the same form as in "struct
    # ofp_vendor_header". The request and reply bodies are otherwise
    # vendor-defined.
# OFP_FLOW_REMOVED_REASON
const OFPRR_IDLE_TIMEOUT = 0x00 # Flow idle time exceeded idle_timeout.
const OFPRR_HARD_TIMEOUT = 0x01 # Time exceeded hard_timeout.
const OFPRR_DELTE = 0x02 # Evicted by a DELETE flow mod.
# Other used constants
const OFP_MAX_ETH_ALEN = 6
const OFP_MAX_PORT_NAME_LEN = 16
const DESC_STR_LEN = 256
const SERIAL_NUM_LEN = 32
const OFP_MAX_TABLE_NAME_LEN = 32

