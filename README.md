# Quick'n'dirty FuseSoC+cocotb example

Presented without much context. Plan to put some flesh on the bones on this example mañana. The DUT begins to put out a string with the content defined by the parameter MSG_STR and the length defined by MSG_LEN on an AXI Stream interface, whenever the input signal i_valid is asserted at the same time as o_ready is asserted. Default data width is 8 bits, as set in the core description file. Haven't really tested other widths.

## Quick instructions

```
# Install FuseSoC. At least version 2.4 is required
pip install fusesoc

# Create and enter an empty throw-away workspace directory
mkdir sandbox && cd sandbox

# Add this repo as a new FuseSoC library
fusesoc library add https://github.com/olofk/fusesocotb

# Add the FuseSoC base library (needed because of the dependency on vlog_tb_utils)
fusesoc library add https://github.com/fusesoc/fusesoc-cores

# Run the testbench with VCD dumping enabled (VCD will end up in build/axis_send_packet_0/default/testlog.vcd)
fusesoc run axis_send_packet --vcd

# Run again with a custom message defined on the command-line
fusesoc run axis_send_packet --MSG_LEN=11 --MSG_STR=hello_world

#Run again with a different simulator. At the time of writing this has been tested with icarus, vcs and verilator
fusesoc run axis_send_packet --tool=verilator

# Get all available compile-time and run-time options
fusesoc run axis_send_packet --help

```

##  How it works

FuseSoC copies the python testbench into the working root using the copyto statement. Since the `cocotb_module` is defined in the target section of the core description file, Edalize (the library that handles interaction with EDA tools) understands that the user wants to run with cocotb and automatically ensures all the right options are passed to the simulator.

We can set some parameters on the command-line, which will be passed to the model. The cocotb testbench will then pick up these parameters so that model and testbench is in sync.

We also load the handy testbench utility core vlog_tb_utils as an extra top-level. This gives us VCD support (and some other features like timeout and heartbeat) without having to add a cumbersome ifdef or otherwise modify the RTL.

That's pretty much it.