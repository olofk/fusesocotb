module axis_send_packet
  #(parameter DW = 8,
    parameter MSG_LEN = 2,
    parameter MSG_STR = "aa")
   (input wire		 i_clk,
    input wire		 i_rst,
    //Control IF
    input wire		 i_valid,
    output reg		 o_ready,
    //Data IF
    output wire [DW-1:0] o_msg_data,
    output wire		 o_msg_last,
    output wire		 o_msg_valid,
    input wire		 i_msg_ready);

   reg [31:0]		 cnt;

   assign o_msg_data = MSG_STR[(MSG_LEN-cnt-1)*DW+:DW];
   assign o_msg_last = (cnt == MSG_LEN-1);
   assign o_msg_valid = !o_ready;

   always @(posedge i_clk) begin
      if (o_msg_valid & i_msg_ready)
	cnt <= o_msg_last ? 'd0 : cnt + 1;

      if (o_msg_valid & i_msg_ready & o_msg_last)
	o_ready <= 1'b1;
      else if (i_valid)
	o_ready <= 1'b0;

      if (i_rst) begin
	 o_ready <= 1'b1;
	 cnt <= 'd0;
      end
   end

endmodule
