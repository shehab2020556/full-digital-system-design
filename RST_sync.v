module RST_sync#(parameter num_stages=3) (rst,clck,sync_rst);
input rst,clck;
output reg sync_rst;

reg [num_stages-2:0] sync_flops;

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        sync_flops<=0;
        sync_rst<=0;
    end
    else 
    begin
        {sync_flops,sync_rst}<={1'b1,sync_flops};
    end
end
endmodule