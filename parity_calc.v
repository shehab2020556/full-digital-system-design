module parity_calc (clck,rst,p_data,data_valid,par_typ,par_bit);
input [7:0] p_data;
input clck,rst,data_valid,par_typ;
output reg par_bit;

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        par_bit<=0;
    end
    else if (1)
    begin
        if (par_typ==0)
        begin
            par_bit<=^p_data;
        end
        else if(par_typ==1)
        begin
            par_bit<=~(^p_data);
        end
    end
    else 
    begin
        par_bit<=par_bit;
    end
end
endmodule
