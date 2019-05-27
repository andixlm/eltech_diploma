`timescale 1ns / 1ps

module wilson(
	input clock,
	input [31:0] current,
	input [31:0] v_in,
	input [31:0] r_in,
	output [31:0] v_out,
	output [31:0] r_out
);

// dv/dt
reg [31:0] c_inverse = 32'h00016710; // 0.8^-1 = 1.25

reg [31:0] a = 32'h8028C99A; // -40.7875
reg [31:0] b = 32'h80253454; // -37.2044
reg [31:0] c = 32'h80208000; // -32.5
reg [31:0] d = 32'h000A89C1; // 10.5381
reg [31:0] e = 32'h801DE666; // -29.9
reg [31:0] f = 32'h000C3E91; // 12.2444

wire [31:0] c_inverse_m_current;
wire [31:0] v_square;
wire [31:0] v_cube;
wire [31:0] a_m_v_cube;
wire [31:0] b_m_v_square;
wire [31:0] c_m_r;
wire [31:0] c_m_r_m_v;
wire [31:0] d_m_v;
wire [31:0] e_m_r;

qmult mfp_c_inverse_m_current(c_inverse, current, c_inverse_m_current);
qmult mfp_v_square(v_in, v_in, v_square);
qmult mfp_v_cube(v_in, v_square, v_cube);
qmult	mfp_a_m_v_cube(a, v_cube, a_m_v_cube);
qmult	mfp_b_m_v_square(b, v_square, b_m_v_square);
qmult	mfp_c_m_r(c, r_in, c_m_r);
qmult	mfp_c_m_r_m_v(c_m_r, v_in, c_m_r_m_v);
qmult	mfp_d_m_v(d, v_in, d_m_v);
qmult	mfp_f_m_r(e, r_in, e_m_r);			

wire [31:0] v_sum_0;
wire [31:0] v_sum_1;
wire [31:0] v_sum_2;
wire [31:0] v_sum_3;
wire [31:0] v_sum_4;
wire [31:0] v_sum;

qadd afp_v_0(c_inverse_m_current, a_m_v_cube, v_sum_0);
qadd afp_v_1(v_sum_0, b_m_v_square, v_sum_1);
qadd afp_v_2(v_sum_1, c_m_r_m_v, v_sum_2);
qadd afp_v_3(v_sum_2, d_m_v, v_sum_3);
qadd afp_v_4(v_sum_3, e_m_r, v_sum_4);
qadd afp_v(v_sum_4, f, v_sum);

// dr/dt
reg [31:0] g = 32'h0000B5E5; // 0.710526
reg [31:0] h = 32'h800086BC; // -0.526313
reg [31:0] j = 32'h00008A7C; // 0.542105

wire [31:0] g_m_v;
wire [31:0] h_m_r;

qmult mfp_g_m_v(g, v_in, g_m_v);
qmult mfp_h_m_r(h, r_in, h_m_r);

wire [31:0] r_sum_0;
wire [31:0] r_sum;

qadd afp_r_0(g_m_v, h_m_r, r_sum_0);
qadd afp_r(r_sum_0, j, r_sum);

// common
reg [31:0] diff = 32'h00000042; // 0.001

wire [31:0] v_sum_m_diff;
wire [31:0] r_sum_m_diff;

qmult mfp_v_sum_m_diff(v_sum, diff, v_sum_m_diff);
qmult mfp_r_sum_m_diff(r_sum, diff, r_sum_m_diff);

// result
qadd afp_res_v(v_in, v_sum_m_diff, v_out);
qadd afp_res_r(r_in, r_sum_m_diff, r_out);

endmodule