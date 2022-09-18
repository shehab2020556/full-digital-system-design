module edge_bit_counter (prescale,enable,clck,rst,bit_cnt,edge_cnt);
input enable,clck,rst;
input [5:0] prescale;
output reg [4:0] bit_cnt;
output reg [5:0]edge_cnt;

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        edge_cnt<=0;
    end
    else if (edge_cnt <prescale)
    begin
        edge_cnt<=edge_cnt+1;
    end
    else
    begin
        edge_cnt<=1;
    end
end

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        bit_cnt<=0;
    end
    else if (enable==0)
    begin
        bit_cnt<=0;
    end
    else if (edge_cnt==(prescale-1) && bit_cnt !=8)
    begin
        bit_cnt<=bit_cnt+1;
    end
    else if (bit_cnt==8 && edge_cnt==(prescale-1))
    begin
        bit_cnt<=1;
    end
    else
    begin
        bit_cnt<=bit_cnt;
    end
end
endmodule
