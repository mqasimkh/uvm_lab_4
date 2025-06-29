# UVM Lab # 4: Integrating Multiple UVCs

In *Lab # 3* we have a created a fully working `YAPP TX UVC`, now in this lab, need to connect and configure `HBU`, `Clock & Reset` & `Channel` UVCs.

## Table of Contents

- [Task_1](#task_1)
  - [1. Creating Sequences](#1-creating-sequences)
    - [yapp_1_seq](#yapp_1_seq)
    - [yapp_012_seq](#yapp_012_seq)


---

## Moving Files 

HBU, Clock and Reset and Channel UVC were provided with manual. So copied them to the lab_4 directory. Also, copied the `YAPP TX` UVC completed in lab 3 to folder named `YAPP` UVC.

Now the file structure is like this:

```
uvm_lab_4/
└── code/
    ├── channel/
    │   ├── sv/
    │   └── tb/
    │
    ├── clock_and_reset/
    │   ├── sv/
    │   └── tb/
    |
    ├── hbus/
    │   ├── sv/
    │   └── tb/
    │
    ├── router_rtl/
    │   └── router_rtl.sv
    |
    ├── yapp/
    │   ├── sv/
    │   └── tb/
    |
    ├── task1_integ/
    │   └── tb/
    │       ├── clkgen.sv
    |       ├── file.f
    |       ├── hw_top.dut.sv
    |       ├── router_tb.sv
    |       ├── router_test_tb.sv
    │       └── tb_top.sv
    │
    └── .README.md

```

## Integrating Channel UVCs

In the `router_tb.sv` which extends from `uvm_env` and where we had previously added `yapp` UVC, created handles for 3 `channel uvcs` and created in `build_phase()` using factory method.

```systemverilog
channel_env c0;
channel_env c1;
channel_env c2;
```

`channel_env` is the class of `channel uvc` environment which extends from `uvm_env`.

Before constructing the the channel uvcs, set their `channel_id` using uvm_config set methods. If it was set after calling factory `type_id` method, then this setting will be overriden.

```systemverilog
uvm_config_int::set(this, "c0", "channel_id", 0);
uvm_config_int::set(this, "c1", "channel_id", 1);
uvm_config_int::set(this, "c2", "channel_id", 2);
```

`uvm_config_int` is `typedef` for `typedef uvm_config_db#(virtual channel_if)` defined in `channel_pkg.sv` file.

Why 3 instances? Because the *Channel UVCs* are to monitor and respond packets at output, so created 3 instances as our DUT has 3 channels and configured their `channel_id` to `0` , `1` and `2` respectively.

## Integrating HBU UVC

Like channel UVC, created a single instannce of `HBU` uvc and created it in ubild phase after setting its `num_masters = 1` and `num_slave = 0`.

```systemverilog
hbus_env hbu;

//in build_phase
uvm_config_int::set(this, "hbu", "num_masters", 1);
uvm_config_int::set(this, "hbu", "num_slaves", 0);

hbu = hbus_env::type_id::create("hbu", this);
```
`HBU` UVC is for configuring the config registers of *YAPP Router`.

## Integrating Clock and Reest UVC

Same way, added `clock_and_reset` uvc. There was no configuration required for this UVC.

Its purpose is to auto control the `reset` control.

```systemverilog
clock_and_reset_env clk_rst;

//in build_phase
clock_and_reset_vif_config::set(null,"uvm_test_top.tb.clk_rst.*", "vif", hw_top.clk_rst);
```

## Adding Channel, HBU, and Clock and Reset  hw_top

After adding all UVCs in `testbench`, added the interface of each individual uvc in `hw_top_dut.sv` (top module).

Created 3 interface for 3 `channels` and connected with them `local` clock & reset signals, not hte onces that comes from `clock and reset UVC`. Same for `HBU Interface`.

Created instance of `clock_and_reset_if` which takes the local clock.

Updated the `yapp router` DUT to take the `clock` and `reset` from `clock_and_reset_if` UVC interface now. 

Next, connected the `DUT` output with `channel` interfaces.

Likewise, connected the `HBU` interface signals to `DUT`.

## Updating file.f

Updated `file.f` to include all `uvc` folders and also explicidly added their `packge` and `interface` paths.

```systemverilog
-timescale 1ns/1ns

-incdir ../../yapp/sv
-incdir ../../channel/sv
-incdir ../../hbus/sv
-incdir ../../clock_and_reset/sv
-incdir ./tb
-incdir ../../router_rtl

../../yapp/sv/yapp_if.sv
../../yapp/sv/yapp_pkg.sv

../../channel/sv/channel_if.sv
../../channel/sv/channel_pkg.sv

../../hbus/sv/hbus_if.sv
../../hbus/sv/hbus_pkg.sv

../../clock_and_reset/sv/clock_and_reset_if.sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv

clkgen.sv
../../router_rtl/yapp_router.sv
hw_top_no_dut.sv
tb_top.sv

// +UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_HIGH
```

## Running Base Test

Ran the `base_test` and all good. The topology printed shows all the `UVCs` instantiated and configured correctly.

### Topology

```
--------------------------------------------------------------------------
Name                           Type                       Size  Value     
--------------------------------------------------------------------------
uvm_test_top                   base_test                  -     @2941     
  tb                           router_tb                  -     @3012     
    c0                         channel_env                -     @3113     
      rx_agent                 channel_rx_agent           -     @3296     
        driver                 channel_rx_driver          -     @4005     
          rsp_port             uvm_analysis_port          -     @4156     
            recording_detail   integral                   32    'd1       
          seq_item_port        uvm_seq_item_pull_port     -     @4107     
            recording_detail   integral                   32    'd1       
          channel_id           integral                   32    'h0       
          recording_detail     integral                   32    'd1       
        monitor                channel_rx_monitor         -     @3287     
          item_collected_port  uvm_analysis_port          -     @3386     
            recording_detail   integral                   32    'd1       
          channel_id           integral                   32    'h0       
          checks_enable        integral                   1     'h1       
          coverage_enable      integral                   1     'h1       
          recording_detail     integral                   32    'd1       
        sequencer              channel_rx_sequencer       -     @3360     
          rsp_export           uvm_analysis_export        -     @3476     
            recording_detail   integral                   32    'd1       
          seq_item_export      uvm_seq_item_pull_imp      -     @4026     
            recording_detail   integral                   32    'd1       
          recording_detail     integral                   32    'd1       
          arbitration_queue    array                      0     -         
          lock_queue           array                      0     -         
          num_last_reqs        integral                   32    'd1       
          num_last_rsps        integral                   32    'd1       
        is_active              uvm_active_passive_enum    1     UVM_ACTIVE
        recording_detail       integral                   32    'd1       
      channel_id               integral                   32    'h0       
      checks_enable            integral                   1     'h1       
      coverage_enable          integral                   1     'h1       
      recording_detail         integral                   32    'd1       
    c1                         channel_env                -     @3089     
      rx_agent                 channel_rx_agent           -     @4210     
        driver                 channel_rx_driver          -     @4899     
          rsp_port             uvm_analysis_port          -     @5044     
            recording_detail   integral                   32    'd1       
          seq_item_port        uvm_seq_item_pull_port     -     @4996     
            recording_detail   integral                   32    'd1       
          channel_id           integral                   32    'h1       
          recording_detail     integral                   32    'd1       
        monitor                channel_rx_monitor         -     @4207     
          item_collected_port  uvm_analysis_port          -     @4294     
            recording_detail   integral                   32    'd1       
          channel_id           integral                   32    'h1       
          checks_enable        integral                   1     'h1       
          coverage_enable      integral                   1     'h1       
          recording_detail     integral                   32    'd1       
        sequencer              channel_rx_sequencer       -     @4274     
          rsp_export           uvm_analysis_export        -     @4379     
            recording_detail   integral                   32    'd1       
          seq_item_export      uvm_seq_item_pull_imp      -     @4919     
            recording_detail   integral                   32    'd1       
          recording_detail     integral                   32    'd1       
          arbitration_queue    array                      0     -         
          lock_queue           array                      0     -         
          num_last_reqs        integral                   32    'd1       
          num_last_rsps        integral                   32    'd1       
        is_active              uvm_active_passive_enum    1     UVM_ACTIVE
        recording_detail       integral                   32    'd1       
      channel_id               integral                   32    'h1       
      checks_enable            integral                   1     'h1       
      coverage_enable          integral                   1     'h1       
      recording_detail         integral                   32    'd1       
    c2                         channel_env                -     @3142     
      rx_agent                 channel_rx_agent           -     @5096     
        driver                 channel_rx_driver          -     @5785     
          rsp_port             uvm_analysis_port          -     @5930     
            recording_detail   integral                   32    'd1       
          seq_item_port        uvm_seq_item_pull_port     -     @5882     
            recording_detail   integral                   32    'd1       
          channel_id           integral                   32    'h2       
          recording_detail     integral                   32    'd1       
        monitor                channel_rx_monitor         -     @5093     
          item_collected_port  uvm_analysis_port          -     @5180     
            recording_detail   integral                   32    'd1       
          channel_id           integral                   32    'h2       
          checks_enable        integral                   1     'h1       
          coverage_enable      integral                   1     'h1       
          recording_detail     integral                   32    'd1       
        sequencer              channel_rx_sequencer       -     @5160     
          rsp_export           uvm_analysis_export        -     @5265     
            recording_detail   integral                   32    'd1       
          seq_item_export      uvm_seq_item_pull_imp      -     @5805     
            recording_detail   integral                   32    'd1       
          recording_detail     integral                   32    'd1       
          arbitration_queue    array                      0     -         
          lock_queue           array                      0     -         
          num_last_reqs        integral                   32    'd1       
          num_last_rsps        integral                   32    'd1       
        is_active              uvm_active_passive_enum    1     UVM_ACTIVE
        recording_detail       integral                   32    'd1       
      channel_id               integral                   32    'h2       
      checks_enable            integral                   1     'h1       
      coverage_enable          integral                   1     'h1       
      recording_detail         integral                   32    'd1       
    clk_rst                    clock_and_reset_env        -     @3202     
      agent                    clock_and_reset_agent      -     @5981     
        driver                 clock_and_reset_driver     -     @6012     
          rsp_port             uvm_analysis_port          -     @6113     
            recording_detail   integral                   32    'd1       
          seq_item_port        uvm_seq_item_pull_port     -     @6062     
            recording_detail   integral                   32    'd1       
          recording_detail     integral                   32    'd1       
        sequencer              clock_and_reset_sequencer  -     @6092     
          rsp_export           uvm_analysis_export        -     @6202     
            recording_detail   integral                   32    'd1       
          seq_item_export      uvm_seq_item_pull_imp      -     @6750     
            recording_detail   integral                   32    'd1       
          recording_detail     integral                   32    'd1       
          arbitration_queue    array                      0     -         
          lock_queue           array                      0     -         
          num_last_reqs        integral                   32    'd1       
          num_last_rsps        integral                   32    'd1       
        recording_detail       integral                   32    'd1       
      recording_detail         integral                   32    'd1       
    hbu                        hbus_env                   -     @3219     
      masters[0]               hbus_master_agent          -     @6886     
        driver                 hbus_master_driver         -     @7505     
          rsp_port             uvm_analysis_port          -     @7656     
            recording_detail   integral                   32    'd1       
          seq_item_port        uvm_seq_item_pull_port     -     @7607     
            recording_detail   integral                   32    'd1       
          random_delay         integral                   1     'h0       
          master_id            integral                   32    'h0       
          recording_detail     integral                   32    'd1       
        sequencer              hbus_master_sequencer      -     @6918     
          rsp_export           uvm_analysis_export        -     @6978     
            recording_detail   integral                   32    'd1       
          seq_item_export      uvm_seq_item_pull_imp      -     @7526     
            recording_detail   integral                   32    'd1       
          recording_detail     integral                   32    'd1       
          arbitration_queue    array                      0     -         
          lock_queue           array                      0     -         
          num_last_reqs        integral                   32    'd1       
          num_last_rsps        integral                   32    'd1       
        monitor                hbus_monitor               -     @6802     
        is_active              uvm_active_passive_enum    1     UVM_ACTIVE
        master_id              integral                   32    'h0       
        recording_detail       integral                   32    'd1       
      monitor                  hbus_monitor               -     @6802     
        item_collected_port    uvm_analysis_port          -     @6852     
          recording_detail     integral                   32    'd1       
        checks_enable          integral                   1     'h1       
        coverage_enable        integral                   1     'h1       
        recording_detail       integral                   32    'd1       
      num_masters              integral                   32    'h1       
      num_slaves               integral                   32    'h0       
      checks_enable            integral                   1     'h1       
      coverage_enable          integral                   1     'h1       
      recording_detail         integral                   32    'd1       
    uvc                        yapp_tx_env                -     @3058     
      agent                    yapp_tx_agent              -     @7708     
        driver                 yapp_tx_driver             -     @8357     
          rsp_port             uvm_analysis_port          -     @8508     
            recording_detail   integral                   32    'd1       
          seq_item_port        uvm_seq_item_pull_port     -     @8459     
            recording_detail   integral                   32    'd1       
          recording_detail     integral                   32    'd1       
        monitor                yapp_tx_monitor            -     @7743     
          recording_detail     integral                   32    'd1       
        sequencer              yapp_tx_sequencer          -     @7738     
          rsp_export           uvm_analysis_export        -     @7828     
            recording_detail   integral                   32    'd1       
          seq_item_export      uvm_seq_item_pull_imp      -     @8378     
            recording_detail   integral                   32    'd1       
          recording_detail     integral                   32    'd1       
          arbitration_queue    array                      0     -         
          lock_queue           array                      0     -         
          num_last_reqs        integral                   32    'd1       
          num_last_rsps        integral                   32    'd1       
        is_active              uvm_active_passive_enum    1     UVM_ACTIVE
        recording_detail       integral                   32    'd1       
      recording_detail         integral                   32    'd1       
--------------------------------------------------------------------------
```

![screenshot-1](/screenshots/1.png)