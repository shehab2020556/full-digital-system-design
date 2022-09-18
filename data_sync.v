module data_sync #(parameter bus_width = 8,parameter num_stages=3) (unsync_bus,bus_en,clck,rst,sync_bus,en_pulse);
input [bus_width-1:0] unsync_bus;
input bus_en,clck,rst;
output reg [bus_width-1:0] sync_bus;
output reg en_pulse;

reg [num_stages-2:0] sync_flops; //multi flip flop sync
reg block_1_out; // multi flip flop out

wire pulse_gen_out;
reg pulse_reg; //pulse generator block

wire [bus_width-1:0]mux_out;

always @(posedge clck or negedge rst) //enable sync
begin
    if (rst==0)
    begin 
        sync_flops<=0;
        block_1_out<=0;
    end
    else 
    begin
        {sync_flops,block_1_out}<={bus_en,sync_flops};
    end
end

always @(posedge clck or negedge rst) //pulse generator
begin
    pulse_reg<=0;
    if (rst==0)
    begin
        pulse_reg<=0;
    end
    else
    begin
        pulse_reg<=block_1_out;
    end
end

assign pulse_gen_out = block_1_out & (~pulse_reg);

assign mux_out= pulse_gen_out? unsync_bus:sync_bus;

always @(posedge clck or negedge rst) 
begin
    if(rst==0)
    begin 
        sync_bus<=0;
    end
    else
    begin
        sync_bus<=mux_out;
    end
end

always @(posedge clck or negedge rst) 
begin
    if(rst==0)
    begin 
        en_pulse<=0;
    end
    else
    begin
        en_pulse<=pulse_gen_out;
    end
end

endmodule

