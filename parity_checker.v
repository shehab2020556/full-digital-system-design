module parity_checker (clck,p_data,par_typ,par_bit_rx,rst,par_check_en,par_check_err);
input [7:0] p_data;
input par_bit_rx,par_typ,par_check_en,rst,clck;
output reg par_check_err;

reg par_bit;

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        par_bit<=0;
    end
    else if (par_check_en==1)
    begin
        if (par_typ==1)
        begin
           par_bit<=~(^p_data);
        end
        else if (par_typ==0)
        begin
           par_bit<=^p_data;
        end
    end
    else
    begin
        par_bit<=par_bit;
    end
end

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        par_check_err<=1;
    end
    else if (par_check_en==1)
    begin
        if (par_bit==par_bit_rx)
        begin
            par_check_err<=0;
        end
        else
        begin
            par_check_err<=1;
        end
    end
    else
    begin
        par_check_err<=par_check_err;
    end
end

endmodule
