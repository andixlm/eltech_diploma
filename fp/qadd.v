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
	if(a[N-1] == b[N-1]) // both negative or both positive
	begin //	Since they have the same sign, absolute magnitude increases
		res[N-2:0] = a[N-2:0] + b[N-2:0];		//	So we just add the two numbers
		res[N-1] = a[N-1];	//	and set the sign appropriately...  Doesn't matter which one we use, 
											 //	they both have the same sign
											 //	Do the sign last, on the off-chance there was an overflow...  
	end
	//	one of them is negative...
	else if(a[N-1] == 0 && b[N-1] == 1) //	subtract a-b
	begin
		if(a[N-2:0] > b[N-2:0]) //	if a is greater than b,
		begin
			res[N-2:0] = a[N-2:0] - b[N-2:0];	//	then just subtract b from a
			res[N-1] = 0;	//		and manually set the sign to positive
			end
		else //	if a is less than b,
		begin
			res[N-2:0] = b[N-2:0] - a[N-2:0];	//	we'll actually subtract a from b to avoid a 2's complement answer
			if (res[N-2:0] == 0)
				res[N-1] = 0;	//	I don't like negative zero....
			else
				res[N-1] = 1;	//	and manually set the sign to negative
			end
		end
	else //	subtract b-a (a negative, b positive)
	begin
		if(a[N-2:0] > b[N-2:0]) //	if a is greater than b,
		begin
			res[N-2:0] = a[N-2:0] - b[N-2:0];	//	we'll actually subtract b from a to avoid a 2's complement answer
			if (res[N-2:0] == 0)
				res[N-1] = 0;	//	I don't like negative zero....
			else
				res[N-1] = 1;	//	and manually set the sign to negative
			end
		else //	if a is less than b,
		begin
			res[N-2:0] = b[N-2:0] - a[N-2:0];	//		then just subtract a from b
			res[N-1] = 0;	//		and manually set the sign to positive
			end
		end
	end
endmodule
