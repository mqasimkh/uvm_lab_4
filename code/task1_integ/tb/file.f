-timescale 1ns/1ns

-incdir ../../yapp/sv
-incdir ./tb
-incdir ../../router_rtl

../../yapp/sv/yapp_if.sv
../../yapp/sv/yapp_pkg.sv
./tb/clkgen.sv
../../router_rtl/yapp_router.sv
./tb/hw_top_no_dut.sv
./tb/tb_top.sv

// +UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_HIGH