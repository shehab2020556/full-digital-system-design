module UART_TX (p_data,data_valid,par_en,par_typ,clck,rst,TX_OUT,busy );
input [7:0] p_data;
input data_valid,par_en,par_typ,clck,rst;
output reg TX_OUT,busy;

wire [7:0] p_data_tmp;
wire [1:0] mux_sel;
wire ser_done,ser_en,busy_fsm,ser_data;
wire par_bit;

localparam start_bit=1'b0 ,stop_bit=1'b1;

always @(busy_fsm) busy=busy_fsm;

UART_TX_FSM FSM(
    .rst(rst),
    .p_data(p_data),
    .data_valid(data_valid),
    .par_en(par_en),
    .ser_done(ser_done),
    .clck(clck),
    .ser_en(ser_en),
    .p_data_tmp(p_data_tmp),
    .busy(busy_fsm),
    .mux_sel(mux_sel)
);

serializer Serializer(
    .rst(rst),
    .p_data(p_data_tmp),
    .ser_en(ser_en),
    .clck(clck),
    .ser_done(ser_done),
    .ser_data(ser_data)
);

parity_calc Parity_calc(
    .clck(clck),
    .rst(rst),
    .p_data(p_data_tmp),
    .data_valid(data_valid),
    .par_typ(par_typ),
    .par_bit(par_bit)
);

always @(*)
begin
    case (mux_sel)
    2'b00: TX_OUT=1'b0;
    2'b01: TX_OUT=stop_bit;
    2'b10: TX_OUT=ser_data;
    2'b11: TX_OUT=par_bit;
    endcase
end
endmodule

