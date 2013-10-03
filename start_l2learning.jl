require("l2learningswitch.jl")
OpenFlow.start_server(L2LearningSwitch.processrequest!, L2LearningSwitch.socketdata,
    L2LearningSwitch.update_socket_data)

