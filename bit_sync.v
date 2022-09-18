module bit_sync #(parameter bus_width = 1,parameter num_stages=3)
(async,rst,clck,sync);

input [bus_width-1:0] async;
input rst,clck;
output reg [bus_width-1:0] sync;

reg [num_stages-2:0] sync_flops [bus_width-1:0];

integer i;

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin 
        for (i=0;i<(bus_width);i=i+1)
        begin
            sync_flops[i]<=0;
            sync[i]<=0;
        end
    end
    else 
    begin
        for (i=0;i<(bus_width);i=i+1)
        {sync_flops[i],sync[i]}<={async[i],sync_flops[i]};
    end
end

endmodule