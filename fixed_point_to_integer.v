`timescale 1ns / 1ps

module fixed_point_to_integer(
	input clock,
	input [31:0] fixed_point_value
);

reg _sign = 1'h0;
reg [14:0] _integer_part = 15'h0000;
reg [15:0] _fractional_part = 16'h0000;

always @ (posedge clock)
begin
	_sign = fixed_point_value[31];
	
	_integer_part = fixed_point_value[30:16];
	
	_fractional_part = 16'h0000;
	if (fixed_point_value[15])
		_fractional_part = _fractional_part + 16'h1388; // 5000
	if (fixed_point_value[14])
		_fractional_part = _fractional_part + 16'h09C4; // 2500
	if (fixed_point_value[13])
		_fractional_part = _fractional_part + 16'h04E2; // 1250
	if (fixed_point_value[12])
		_fractional_part = _fractional_part + 16'h0271; // 0625
	if (fixed_point_value[11])
		_fractional_part = _fractional_part + 16'h0138; // 0312
	if (fixed_point_value[10])
		_fractional_part = _fractional_part + 16'h009C; // 0156
	if (fixed_point_value[9])
		_fractional_part = _fractional_part + 16'h004E; // 0078
	if (fixed_point_value[8])
		_fractional_part = _fractional_part + 16'h0027; // 0039
	if (fixed_point_value[7])
		_fractional_part = _fractional_part + 16'h0013; // 0019
	if (fixed_point_value[6])
		_fractional_part = _fractional_part + 16'h0009; // 0009
	if (fixed_point_value[5])
		_fractional_part = _fractional_part + 16'h0005; // 0005
	if (fixed_point_value[4])
		_fractional_part = _fractional_part + 16'h0002; // 0002
	if (fixed_point_value[3])
		_fractional_part = _fractional_part + 16'h0001; // 0001
	if (fixed_point_value[2])
		_fractional_part = _fractional_part + 16'h0000; // 0000
	if (fixed_point_value[1])
		_fractional_part = _fractional_part + 16'h0000; // 0000
	if (fixed_point_value[0])
		_fractional_part = _fractional_part + 16'h0000; // 0000
end

endmodule
