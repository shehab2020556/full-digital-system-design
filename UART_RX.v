module UART_RX(RX_IN,prescale,par_en,par_typ,clck,rst,p_data,data_valid );
input RX_IN,par_en,par_typ,clck,rst;
input [5:0] prescale;
output reg data_valid;
output reg [7:0] p_data;

wire par_check_en,counter_enable,deserializer_en;
wire par_check_err;
wire stop_err;
wire [4:0]bit_cnt;
wire [5:0]edge_cnt;
wire sampeled_bit;
wire data_valid_fsm;
wire [7:0] p_data_des;
wire start_check;

wire [2:0]current_state,next_state;





always @(posedge clck)
begin
    data_valid<=data_valid_fsm;
    if (data_valid_fsm==1)
    begin
        p_data<=p_data_des;
    end 
end





UART_RX_FSM UART_RX_FSM(start_check,RX_IN,par_en,par_typ,bit_cnt,edge_cnt,prescale,par_check_err,stop_err,clck,rst,data_valid_fsm,par_check_en,counter_enable,deserializer_en );

start_checker start_checker(sampeled_bit,start_check);

stop_checker stop_checker(sampeled_bit,stop_err);

parity_checker parity_checker(clck,p_data_des,par_typ,sampeled_bit,rst,par_check_en,par_check_err);

edge_bit_counter edge_bit_counter(
    .prescale(prescale),
    .enable(counter_enable),
    .clck(clck),
    .rst(rst),
    .bit_cnt(bit_cnt),
    .edge_cnt(edge_cnt)
);

sampler sampler (
    .s_data(RX_IN),
    .edge_cnt(edge_cnt),
    .clck(clck),
    .rst(rst),
    .sampeled_bit(sampeled_bit),
    .prescale(prescale)
);

deserializer deserializer(
    .sampeled_bit(sampeled_bit),
    .deserializer_en(deserializer_en),
    .bit_cnt(bit_cnt),
    .clck(clck),
    .rst(rst),
    .p_data(p_data_des)
);

endmodule

