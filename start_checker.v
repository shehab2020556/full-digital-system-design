module start_checker (sampeled_bit,start_check);
input sampeled_bit;
output start_check;
assign start_check= ~sampeled_bit;
endmodule
