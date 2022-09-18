module deserializer (sampeled_bit,deserializer_en,bit_cnt,clck,rst,p_data);
input sampeled_bit,deserializer_en,clck,rst;
input [4:0] bit_cnt;
output reg [7:0] p_data;

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        p_data<=0;
    end
    else if (deserializer_en==1)
    begin
        p_data[bit_cnt-1]<=sampeled_bit;
    end
    else
    begin
        p_data<=p_data;
    end
end
endmodule

