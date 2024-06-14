//Proxy level to add VCD generation through vlog_tb_utils
module axis_send_packet_wrapper
  #(parameter DW = 8,
    parameter MSG_LEN = 2,
    parameter MSG_STR = "aa")
   (input wire		 i_clk,
    input wire		 i_rst,
    //Control IF
    input wire		 i_valid,
    output wire		 o_ready,
    //Data IF
    output wire [DW-1:0] o_msg_data,
    output wire		 o_msg_last,
    output wire		 o_msg_valid,
    input wire		 i_msg_ready);

`ifndef VERILATOR
   vlog_tb_utils vtu();
`endif

   axis_send_packet
     #(.DW      (DW),
       .MSG_LEN (MSG_LEN),
       .MSG_STR (MSG_STR))
   dut
     (.i_clk (i_clk),
      .i_rst (i_rst),
      //Control IF
      .i_valid (i_valid),
      .o_ready (o_ready),
      //Data IF
      .o_msg_data  (o_msg_data ),
      .o_msg_last  (o_msg_last ),
      .o_msg_valid (o_msg_valid),
      .i_msg_ready (i_msg_ready));

endmodule
