`timescale 1ns / 1ps

// Explicit Middle Point Solver of Wilson Neuron Model
module wilson(
	input clock,
	input [31:0] current,
	output [31:0] v_out
);

// ----------------------------------------------------------------------------

reg [31:0] diff = 32'h00000042; // 0.001
reg [31:0] half_diff = 32'h00000021; // 0.0005

// storage
reg [31:0] v_in = 32'h8000CCCD;
reg [31:0] r_in = 32'h00000000;

wire [31:0] r_out;

// dv/dt multipliers
reg [31:0] c_inverse = 32'h00016710; // 1/0.8 = 1.25
reg [31:0] a = 32'h8028C99A; // -40.7875
reg [31:0] b = 32'h80253454; // -37.2044
reg [31:0] c = 32'h80208000; // -32.5
reg [31:0] d = 32'h000A89C1; // 10.5381
reg [31:0] e = 32'h801DE666; // -29.9
reg [31:0] f = 32'h000C3E91; // 12.2444

// dr/dt multipliers
reg [31:0] g = 32'h0000B5E5; // 0.710526
reg [31:0] h = 32'h800086BC; // -0.526313
reg [31:0] j = 32'h00008A7C; // 0.542105

// ----------------------------------------------------------------------------

// half of dv/dt
wire [31:0] c_inverse_m_current_half;
wire [31:0] v_square_half;
wire [31:0] v_cube_half;
wire [31:0] a_m_v_cube_half;
wire [31:0] b_m_v_square_half;
wire [31:0] c_m_r_half;
wire [31:0] c_m_r_m_v_half;
wire [31:0] d_m_v_half;
wire [31:0] e_m_r_half;

qmult mfp_c_inverse_m_current_half(c_inverse, current, c_inverse_m_current_half);
qmult mfp_v_square_half(v_in, v_in, v_square_half);
qmult mfp_v_cube_half(v_in, v_square_half, v_cube_half);
qmult mfp_a_m_v_cube_half(a, v_cube_half, a_m_v_cube_half);
qmult mfp_b_m_v_square_half(b, v_square_half, b_m_v_square_half);
qmult mfp_c_m_r_half(c, r_in, c_m_r_half);
qmult mfp_c_m_r_m_v_half(c_m_r_half, v_in, c_m_r_m_v_half);
qmult mfp_d_m_v_half(d, v_in, d_m_v_half);
qmult mfp_e_m_r_half(e, r_in, e_m_r_half);

wire [31:0] v_sum_0_half;
wire [31:0] v_sum_1_half;
wire [31:0] v_sum_2_half;
wire [31:0] v_sum_3_half;
wire [31:0] v_sum_4_half;
wire [31:0] v_sum_half;

qadd afp_v_0(c_inverse_m_current_half, a_m_v_cube_half, v_sum_0_half);
qadd afp_v_1(v_sum_0_half, b_m_v_square_half, v_sum_1_half);
qadd afp_v_2(v_sum_1_half, c_m_r_m_v_half, v_sum_2_half);
qadd afp_v_3(v_sum_2_half, d_m_v_half, v_sum_3_half);
qadd afp_v_4(v_sum_3_half, e_m_r_half, v_sum_4_half);
qadd afp_v(v_sum_4_half, f, v_sum_half);

// ------------------------------------

// half of dr/dt
wire [31:0] g_m_v_half;
wire [31:0] h_m_r_half;

qmult mfp_g_m_v(g, v_in, g_m_v_half);
qmult mfp_h_m_r(h, r_in, h_m_r_half);

wire [31:0] r_sum_0_half;
wire [31:0] r_sum_half;

qadd afp_r_0(g_m_v_half, h_m_r_half, r_sum_0_half);
qadd afp_r(r_sum_0_half, j, r_sum_half);

// ------------------------------------

// common
wire [31:0] v_sum_m_diff_half;
wire [31:0] r_sum_m_diff_half;

qmult mfp_v_sum_m_diff(v_sum_half, half_diff, v_sum_m_diff_half);
qmult mfp_r_sum_m_diff(r_sum_half, half_diff, r_sum_m_diff_half);

// half result
wire [31:0] v_out_half;
wire [31:0] r_out_half;

qadd afp_res_v(v_in, v_sum_m_diff_half, v_out_half);
qadd afp_res_r(r_in, r_sum_m_diff_half, r_out_half);

// ----------------------------------------------------------------------------

// full of dv/dt
wire [31:0] c_inverse_m_current_full;
wire [31:0] v_square_full;
wire [31:0] v_cube_full;
wire [31:0] a_m_v_cube_full;
wire [31:0] b_m_v_square_full;
wire [31:0] c_m_r_full;
wire [31:0] c_m_r_m_v_full;
wire [31:0] d_m_v_full;
wire [31:0] e_m_r_full;

qmult mfp_c_inverse_m_current_full(c_inverse, current, c_inverse_m_current_full);
qmult mfp_v_square_full(v_out_half, v_out_half, v_square_full);
qmult mfp_v_cube_full(v_out_half, v_square_full, v_cube_full);
qmult mfp_a_m_v_cube_full(a, v_cube_full, a_m_v_cube_full);
qmult mfp_b_m_v_square_full(b, v_square_full, b_m_v_square_full);
qmult mfp_c_m_r_full(c, r_out_half, c_m_r_full);
qmult mfp_c_m_r_m_v_full(c_m_r_full, v_out_half, c_m_r_m_v_full);
qmult mfp_d_m_v_full(d, v_out_half, d_m_v_full);
qmult mfp_e_m_r_full(e, r_out_half, e_m_r_full);

wire [31:0] v_sum_0_full;
wire [31:0] v_sum_1_full;
wire [31:0] v_sum_2_full;
wire [31:0] v_sum_3_full;
wire [31:0] v_sum_4_full;
wire [31:0] v_sum_full;

qadd afp_v_0_full(c_inverse_m_current_full, a_m_v_cube_full, v_sum_0_full);
qadd afp_v_1_full(v_sum_0_full, b_m_v_square_full, v_sum_1_full);
qadd afp_v_2_full(v_sum_1_full, c_m_r_m_v_full, v_sum_2_full);
qadd afp_v_3_full(v_sum_2_full, d_m_v_full, v_sum_3_full);
qadd afp_v_4_full(v_sum_3_full, e_m_r_full, v_sum_4_full);
qadd afp_v_full(v_sum_4_full, f, v_sum_full);

// ------------------------------------

// full of dr/dt
wire [31:0] g_m_v_full;
wire [31:0] h_m_r_full;

qmult mfp_g_m_v_full(g, v_out_half, g_m_v_full);
qmult mfp_h_m_r_full(h, r_out_half, h_m_r_full);

wire [31:0] r_sum_0_full;
wire [31:0] r_sum_full;

qadd afp_r_0_full(g_m_v_full, h_m_r_full, r_sum_0_full);
qadd afp_r_full(r_sum_0_full, j, r_sum_full);

// ------------------------------------

wire [31:0] v_sum_m_diff_full;
wire [31:0] r_sum_m_diff_full;

qmult mfp_v_sum_m_diff_full(v_sum_full, diff, v_sum_m_diff_full);
qmult mfp_r_sum_m_diff_full(r_sum_full, diff, r_sum_m_diff_full);

// full result
qadd afp_res_v_full(v_in, v_sum_m_diff_full, v_out);
qadd afp_res_r_full(r_in, r_sum_m_diff_full, r_out);

always @ (posedge clock)
begin
  v_in = v_out;
  r_in = r_out;
end

endmodule