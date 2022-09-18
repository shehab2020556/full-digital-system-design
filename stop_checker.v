module stop_checker(sampeled_bit,stop_err);
input sampeled_bit;
output stop_err;
assign stop_err=~sampeled_bit;
endmodule