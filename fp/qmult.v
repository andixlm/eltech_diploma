`timescale 1ns / 1ps

module qmult #(parameter Q = 16, parameter N = 32)(
	input [N-1:0] i_multiplicand,
	input [N-1:0] i_multiplier,
	output [N-1:0] o_result
);

// The underlying assumption, here, is that both fixed-point values are of the same length (N,Q)
// Because of this, the results will be of length N+N = 2N bits.
// This also simplifies the hand-back of results, as the binimal point 
// will always be in the same location.

// Multiplication by 2 values of N bits requires a register that is N+N = 2N deep.
reg [2*N-1:0] r_result;
reg [N-1:0] r_ret_val;

// Only handing back the same number of bits as we received with fixed point in same location.
assign o_result = r_ret_val;

// Do the multiply any time the inputs change
always @(i_multiplicand, i_multiplier)
begin
	// Removing the sign bits from the multiply - that would introduce *big* errors.
	r_result <= i_multiplicand[N-2:0] * i_multiplier[N-2:0];
end

// This always block will throw a warning, as it uses a & b, but only acts on changes in result.
always @(r_result)
begin
	// Any time the result changes, we need to recompute the sign bit,
	// which is the XOR of the input sign bits.
	r_ret_val[N-1] <= i_multiplicand[N-1] ^ i_multiplier[N-1];
	// And we also need to push the proper N bits of result up to the calling entity
	r_ret_val[N-2:0] <= r_result[N-2+Q:Q];
end

endmodule
