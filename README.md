JuliaFlow
=========
JuliaFlow is a controller for software-defined networking ([SDN](http://en.wikipedia.org/wiki/Software-defined_networking)) that implements the [OpenFlow Controller Specification 1.0.0](https://www.opennetworking.org/images/stories/downloads/sdn-resources/onf-specifications/openflow/openflow-spec-v1.0.0.pdf). It is coded entirely using [Julia](http://julialang.org), which is a fast, dynamic language for technical computing.

Intro
-----
Software-defined networks separate the data-path and the control logic that usually resides in a switch into distinct components. This allows one to use low-cost commodity switches. These are sometimes referred to as dumb switches, since their functionality is greatly reduced in contrast to full-blown enterprise-grade switches. In SDNs the actually interesting logic resides in the controller, which is a software component, that can be run on off-the-shelf hardware.

The concept of separating data-path from control-path has a number of benefits:

* researchers can implement and experiment with their own alternatives to established network and transport protocols,
* researchers can experiment with novel switching and routing algorithms to manage security, quality of service and many other criteria,
* providers can flexibly program their networking infrastructure and achieve a new level of vendor-independence.

All this can entirely be achieved by using software-based switches and controllers. For production deployments one can use high performance hardware switches to boost throughput and achieve increased efficiency.

SDN components (data-path and controller) usually implement the OpenFlow Specification to communicate with each other. Although OpenFlow has reached version 1.4.0 already, the most widely implemented version is 1.0.0.

JuliaFlow implements a controller for SDNs based on OpenFlow version 1.0.0. The language of choice is called Julia, which is a novel language for technical computing. Although it bears a resemblance to Octave and Matlab it is much more powerful in terms of expressiveness. This makes Julia a good choice for an SDN controller, since it allows it to be extended with ease. At the same time Julia reaches high performance, which is often within a factor of two of the performance of C programs. JuliaFlow leverages Julia's benefits to deliver great extensibility and great performance at the same time!

Features
--------
These are JuliaFlow's most striking features:

* Provides a layer 2 learning switch out-of-the-box,
* allows easy extension by implementing reactive handler functions,
* delivers a performance that compares well with [Pox](http://www.noxrepo.org/pox/about-pox/) (Python) and [Nox](http://www.noxrepo.org/nox/about-nox/) (C++),
* integrates seamlessly with [Julia's long list of packages](http://docs.julialang.org/en/latest/packages/packagelist/) (e.g. optimisation, statistical analysis, distributed map-reduce, plotting, signal processing),
* can easily be ported to a newer version of OpenFlow.

The last point is striking and has a simple explanation: Most of JuliaFlow's controller is actually generated at start-up via Julia macros, which are very similar to Lisp macros. This means, that JuliaFlow's implementation with regards to complying to OpenFlow relies mostly on typing in the C-structs from the OpenFlow spec faithfully as Julia types. Serialisation and deserialization are handled by applying the prepared macros. By extension this approach makes JuliaFlow a prime candidate to implement a highly performant OpenFlow switch.

In summary JuliaFlow hits a sweet spot between **performance** and simple **extensibility**. 

Performance
-----------
The performance of OpenFlow-based SDN controllers is usually tested using a benchmarking tool called [cbench](http://www.openflowhub.org/display/floodlightcontroller/Cbench+%28New%29). On a MacBook Air (i7) JuliaFlow handles approximately 17K flow modification messages (FlowMods) per second. Pox reaches approximately 7K FlowMods per second.

Usage
-----
To try out JuliaFlow you need to install Julia at least in version 0.2. Please refer to the corresponding documentation of the Julia project. Once you have Julia up and running, clone this repository and start the layer 2 learning switch with the following command on your CLI:

`julia start_l2learning.jl`

Alternatively you can start up Julia's REPL ("julia") and evaluate the startup script there:

    julia
    include("start_l2learning.jl")

These commands will start the controller, which will listen on port *6633* on *localhost*. 

Since an OpenFlow controller without a switch does not make too much sense, feel free to try it out with [Mininet](http://mininet.org), [Open vSwitch](http://openvswitch.org) or benchmark it using cbench.

Implementing your own controller
--------------------------------
Implementing your own controller requires you implement handlers for request coming from the switch. The type of incoming message is distinguished by leveraging Julia's multiple dispatch feature. Incoming messages will automatically be serialised to a value of corresponding type. Multiple dispatch will then choose the most specific handler for the given message type. In practice this means that you can just provide the handler methods, which you would actually like to use. For all other message types you can define a catch-all method. The most generic message type in JuliaFlow is called `OfpMessage`, thus you can define a catch-all method like this:

    # Catch-all message handler.
    function processrequest!(message::OfpMessage, socket_id::Integer)
        # warn("Got a message for which there is no processing rule: $(string(message))")
    end

`processrequest!` is the name of our handler-function. The naming is up to you, but it needs to be the same for all the method that you are implementing. Note that the name should and with an exclamation mark, since it potentially changes the state of the second argument (`socket_id`). The first argument is the de-serialised message. In the catch-all method it is of type OfpMessage, which is an abstract type. If there is no more specific method (e.g. with OfpQueueGetConfigRequest as second argument type), this handler is going to be called for all kinds of incoming messages. The second argument is always the same: an opaque identifier for the switch that has contacted us.

Often handler methods will mirror a pattern that checks for the concrete message type of a potentially ambiguous message, before preparing and returning response messages that will be sent source of the request:

    function processrequest!(msg::OfpEmptyMessage, socket_id::Integer)
        resp::Vector{OfpMessage} = Array(OfpMessage, 0)
        if msg.header.msgtype == OFPT_HELLO
            info("Got HELLO, replying HELLO")
            info(string(msg))
            tables[socket_id] = Dict{Uint8, Uint16}()
            push!(resp, OfpEmptyMessage(OfpHeader(OFPT_HELLO, 8)))
            push!(resp, OfpEmptyMessage(OfpHeader(OFPT_FEATURES_REQUEST, 8)))
        elseif msg.header.msgtype == OFPT_ECHO_REQUEST
            info("Got ECHO_REQUEST, replying ECHO_REPLY")
            info(string(msg))
            push!(resp, OfpEmptyMessage(OfpHeader(OFPT_ECHO_REPLY, 8)))
        elseif ...
            ...
        end
        resp
    end

In the example above we receive an empty message, which means there is no message body. We test the header for the actual message type. In case it is a `HELLO`-request, we prepare a `HELLO`-response. This message and a request for the switch configuration is then added to a previously prepared collection, which serves as container for response messages. Each handler method is expected to return a vector of messages (`Vector{OfpMessage}`) even if it is empty. This is good practice anyway, since one should write 'type-stable' functions (i.e. functions that always return values of the same type') for reasons of performance. Note that in our example we use a variable `tables`. This is a reference to a variable which resides in the top-level scope of our current module. You can define such variables as required. In the case of a L2 learning switch the tables variables links data-link addresses to ports for a certain switch.

Once you have implemented all the handlers your controller requires, you can start the controller by providing your handler like this:

    require("l2learningswitch.jl")
    OpenFlow.start_server(L2LearningSwitch.processrequest!, 6633)

The second argument specifies the port, is optional and defaults to 6633, which is the default port for OpenFlow communication according to the specification. 


Code examples
-------------
What follows is an example for the handler method of the L2 learning switch for the `OFP_PACKET_IN` request. 

    # Known locations. (DL_addr=>Port)
    # OfpPacketIn
    function processrequest!(msg::OfpPacketIn, socket_id::Integer)
        resp::Vector{OfpMessage} = Array(OfpMessage, 0)
        if msg.header.msgtype == OFPT_PACKET_IN
            info("Got OFPT_PACKET_IN")
            info(string(msg))
            table = tables[socket_id]
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
            warn("Got a message of type $(msg) containing a header with msgtype: $(msg.header.msgtype). Something is wrong!")
            warn(string(msg))
        end
        resp
    end

This example is analogous to Pox's implementation of the L2 learning switch. If we receive a packet-in message we store a link of the source's datalink address to its originating switch port. If we know the destination already, we create a flow-modification message that matches source and destination bi-directionally accordingly. If we do not know the target yet, we simply flood the inbound message on all but the incoming port. 

This example is instructive since it demonstrates how to filter for (multiple dispatch) and inspect incoming messages, and how to generate complex outbound messages. The available types follow a naming scheme that resembles that of the OpenFlow version 1.0.0 specification. All types and implicitly their type hierarchy and constructors can be found under `incl/oftypes.jl`.

