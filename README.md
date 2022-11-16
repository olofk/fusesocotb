# Quick'n'dirty FuseSoC+cocotb example

Presented without much context. Plan to put some flesh on the bones on this example mañana. The DUT begins to put out a string with the content defined by the parameter MSG_STR and the length defined by MSG_LEN on an AXI Stream interface, whenever the input signal i_valid is asserted at the same time as o_ready is asserted. Default data width is 8 bits, as set in the core description file. Haven't really tested other widths. The whole thing works reasonably well, but tighter integration is on the horizon which will save the users some typing to manually pass env vars and locate VPI libraries. More about that, when the time comes.

## Quick instructions

```
# Create and enter an empty throw-away workspace directory
mkdir sandbox && cd sandbox

# Add this repo as a new FuseSoC library
fusesoc library add fusesocotb https://github.com/olofk/fusesocotb

# Add the FuseSoC base library (needed because of the dependency on vlog_tb_utils)
fusesoc library add fusesoc_cores https://github.com/fusesoc/fusesoc-cores

# Run the testbench with VCD dumping enabled (VCD will end up in build/axis_send_packet_0/default-icarus/testlog.vcd)
MODULE=test_axis_send_packet fusesoc run axis_send_packet --vcd

# Run again with a custom message defined on the command-line
MODULE=test_axis_send_packet fusesoc run axis_send_packet --MSG_LEN=11 --MSG_STR=hello_world

# Get all available compile-time and run-time options
fusesoc run axis_send_packet --help

```

##  How it works

FuseSoC copies the python testbench into the working root using the copyto statement. For now, we also need to manually pass the environment variable MODULE when running FuseSoC.

When Icarus is launched it will load the correct cocotb VPI library from the directory defined by `cocotb-config --lib-dir`. For now, a similar line would need to be added for any other simulator to be used instead of Icarus.

We can set some parameters on the command-line, which will be passed to the model. The cocotbo testbench will then pick up these parameters so that model and testbench is in sync.

We also load the handy testbench utlity core vlog_tb_utils as an extra top-level. This gives us VCD support (and some other features like timeout and heartbeat) without having to add a cumbersome ifdef or otherwise the RTL.

That's pretty much it.