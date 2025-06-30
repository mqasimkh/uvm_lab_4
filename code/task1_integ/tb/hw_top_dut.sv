/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  // YAPP Interface to the DUT
  yapp_if in0(clock, reset);

  // CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );

  //channels interfaces. They take local block generated from clkgen, not from clk & rst UVC.
  channel_if c0 (
    .clock(clock), 
    .reset(reset) 
  );

  channel_if c1 (
    .clock(clock), 
    .reset(reset) 
  );

  channel_if c2 (
    .clock(clock), 
    .reset(reset) 
  );

  //hbu interfaces. It also take local block generated from clkgen, not from clk & rst UVC.
  hbus_if hbu (
    .clock(clock), 
    .reset(reset)
  );

  //takes clock from clkgen.
  clock_and_reset_if clk_rst (
    .clock(clock),
    .reset(reset),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );

  //yapp_router now takes clock from clk & rst uvc, not local geneated from clkgen.
  yapp_router dut(
    .reset(clk_rst.reset),
    .clock(clk_rst.clock),
    .error(),

    // YAPP interface
    .in_data(in0.in_data),
    .in_data_vld(in0.in_data_vld),
    .in_suspend(in0.in_suspend),

    // Output Channels
    //Channel 0
    .data_0(c0.data),
    .data_vld_0(c0.data_vld),
    .suspend_0(c0.suspend),
    //Channel 1
    .data_1(c1.data),
    .data_vld_1(c1.data_vld),
    .suspend_1(c1.suspend),
    //Channel 2
    .data_2(c2.data),
    .data_vld_2(c2.data_vld),
    .suspend_2(c2.suspend),

    // HBUS Interface 
    .haddr(hbu.haddr),
    .hdata(hbu.hdata_w),
    .hen(hbu.hen),
    .hwr_rd(hbu.hwr_rd)
    );

endmodule
