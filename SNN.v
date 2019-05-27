`timescale 1ns / 1ps

module SNN;

reg clock = 0;
always #1 clock = ~clock;

reg [31:0] current = 32'h00008000;

wire [31:0] v;
wire [31:0] r;
reg [31:0] v_prev = 32'h8000CCCD;
reg [31:0] r_prev = 32'h00000000;

fixed_point_to_integer fpti_c(clock, current);
fixed_point_to_integer fpti_v(clock, v_prev);
fixed_point_to_integer fpti_r(clock, r_prev);
wilson w(clock, current, v_prev, r_prev, v, r);

reg up = 1;

always @ (posedge clock)
begin
	v_prev[31:0] = v[31:0];
	r_prev[31:0] = r[31:0];
end

endmodule