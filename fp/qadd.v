`timescale 1ns / 1ps

module qadd #(parameter Q = 16, parameter N = 32)(
	input [N-1:0] a,
	input [N-1:0] b,
	output [N-1:0] c
);

reg [N-1:0] res;

assign c = res;

always @(a,b) 
begin
	// Both negative or both positive.
	if(a[N-1] == b[N-1])
	begin
		// Since they have the same sign, absolute magnitude increases.
		// So we just add the two numbers
		res[N-2:0] = a[N-2:0] + b[N-2:0];
		// and set the sign appropriately.
		res[N-1] = a[N-1];
		// Doesn't matter which one we use, they both have the same sign.
	end
	// One of them is negative.
	else if(a[N-1] == 0 && b[N-1] == 1)
	begin
		// Subtract a-b
		if(a[N-2:0] > b[N-2:0])
		begin
			// If a is greater than b,
			// then just subtract b from a
			res[N-2:0] = a[N-2:0] - b[N-2:0];
			// and manually set the sign to positive
			res[N-1] = 0;
			end
		// If a is less than b
		else
		begin
			// We'll actually subtract a from b to avoid a 2's complement answer
			res[N-2:0] = b[N-2:0] - a[N-2:0];
			if (res[N-2:0] == 0)
				// Avoid negative zero.
				res[N-1] = 0;
			else
				// And manually set the sign to negative.
				res[N-1] = 1;
			end
		end
	// Subtract b-a (a negative, b positive)
	else
	begin
		// If a is greater than b,
		if(a[N-2:0] > b[N-2:0])
		begin
			// We'll actually subtract b from a to avoid a 2's complement answer.
			res[N-2:0] = a[N-2:0] - b[N-2:0];
			if (res[N-2:0] == 0)
				// Avoid negative zero.
				res[N-1] = 0;
			else
				// And manually set the sign to negative.
				res[N-1] = 1;
			end
		// If a is less than b
		else
		begin
			// then just subtract a from b
			res[N-2:0] = b[N-2:0] - a[N-2:0];
			// and manually set the sign to positive.
			res[N-1] = 0;
			end
		end
	end
endmodule
