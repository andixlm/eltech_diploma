`timescale 1ns / 1ps

module SNN;

reg clock = 0;
always #1 clock = ~clock;

reg [31:0] current = 32'h00008000;

wire [31:0] v;
wire [31:0] r;

fixed_point_to_integer fpti_c(clock, current);
fixed_point_to_integer fpti_v(clock, v);
fixed_point_to_integer fpti_r(clock, r);
wilson w(clock, current, v, r);

endmodule