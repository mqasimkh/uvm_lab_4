class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)

    //yapp uvc
    yapp_tx_env uvc;

    //channel uvc
    channel_env c0;
    channel_env c1;
    channel_env c2;

    //hbu uvc
    hbus_env hbu;

    //clock and reset uvc
    clock_and_reset_env clk_rst;

    function new (string name = "router_tb", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("UVM_ENV", "Build phase of env is being executed", UVM_HIGH);

        uvc = yapp_tx_env::type_id::create("uvc", this);

        //setting channel id of each channel before they are created.
        uvm_config_int::set(this, "c0", "channel_id", 0);
        uvm_config_int::set(this, "c1", "channel_id", 1);
        uvm_config_int::set(this, "c2", "channel_id", 2);

        //creating channel using factory method.
        c0 = channel_env::type_id::create("c0", this);
        c1 = channel_env::type_id::create("c1", this);
        c2 = channel_env::type_id::create("c2", this);

        //setting master and slave nums for hbu uvc
        uvm_config_int::set(this, "hbu", "num_masters", 1);
        uvm_config_int::set(this, "hbu", "num_slaves", 0);

        //creating hbu using factory method.
        hbu = hbus_env::type_id::create("hbu", this);

         //creating clock and reset uvc using factory method.
        clk_rst = clock_and_reset_env::type_id::create("clk_rst", this);
        
    endfunction: build_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Running Simulation ...", UVM_HIGH);
    endfunction: start_of_simulation_phase

endclass: router_tb