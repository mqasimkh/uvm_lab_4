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