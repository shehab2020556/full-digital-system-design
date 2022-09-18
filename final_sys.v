module final_sys(
    input   wire            refclck,UART_clck,
    input   wire            rst,
    input   wire            RX_IN,
    output  wire            TX_OUT
);





wire [7:0] p_data_rx;
wire       data_valid_rx;

wire [7:0] sync_frame;
wire       sync_en1;

wire       fsm2_start;
wire [5:0] current_state_tst;

wire [7:0] fsm_out;
wire       fsm_valid;



wire       RdEn,WrEn;
wire [7:0] WrData;
wire [3:0] Address;

wire       RdData_VLD;
wire [7:0] RdData;
wire [7:0] REG0,REG1,REG2,REG3;  

wire [15:0] ALU_OUT;
wire        OUT_VALID;
wire [3:0]  ALU_FUN;
wire        ALU_EN;
wire        alu_clck_en;

wire UART_TX_clck;
wire [7:0] sync_fsm_out;
wire sync_fsm_valid;
wire busy_tx;


wire sync_rst1,sync_rst2;



wire [2:0]  c2,n2;
wire [5:0]   next_state_tst;



UART_RX UART_RX_TOP(
    .RX_IN(RX_IN),
    .par_en(REG2[0]),
    .par_typ(REG2[1]),
    .clck(UART_clck),
    .rst(sync_rst2),
    .prescale(REG2[7:2]),
    .p_data(p_data_rx),
    .data_valid(data_valid_rx)
);


data_sync #(.bus_width(8),.num_stages(2)) d_sync1 (
    .unsync_bus(p_data_rx),
    .bus_en(data_valid_rx),
    .clck(refclck),
    .rst(sync_rst1),
    .sync_bus(sync_frame),
    .en_pulse(sync_en1)
);


sys_cont_fsm1 fsm1
(
    .clck(refclck),
    .rst(sync_rst1),
    .frame(sync_frame),
    .valid(sync_en1),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .Address(Address),
    .WrData(WrData),
    .ALU_FUN(ALU_FUN),
    .ALU_EN(ALU_EN),
    .alu_clck_en(alu_clck_en),
    .fsm2_start(fsm2_start),
    .current_state_tst(current_state_tst),


    .next_state_tst(next_state_tst)
);


sys_cont_fsm2 fsm2 (
    .clck(refclck),
    .rst(sync_rst1),
    .fsm2_start(fsm2_start),
    .fsm1_state(current_state_tst),
    .valid(sync_en1),
    .RdData(RdData),
    .RdData_VLD(RdData_VLD),
    .ALU_OUT(ALU_OUT),
    .OUT_VALID(OUT_VALID),
    .busy_tx(busy_tx),
    .fsm_out(fsm_out),
    .fsm_valid(fsm_valid),

    .current_state(c2),
    .next_state(n2)
);



RegFile #(.WIDTH(8),.DEPTH(16),.ADDR(4)) RegFile_top
(
    .CLK(refclck),
    .RST(sync_rst1),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .Address(Address),
    .WrData(WrData),
    .RdData(RdData),
    .RdData_VLD(RdData_VLD),
    .REG0(REG0),
    .REG1(REG1),
    .REG2(REG2),
    .REG3(REG3)
);

ALU ALU_top(
    .A(REG0),
    .B(REG1),
    .EN(ALU_EN),
    .ALU_FUN(ALU_FUN),
    .CLK(ALU_CLCK),
    .RST(sync_rst1),
    .ALU_OUT(ALU_OUT),
    .OUT_VALID(OUT_VALID)
);

CLK_GATE ALU_clck_gate(
    .CLK_EN(alu_clck_en),
    .CLK(refclck),
    .GATED_CLK(ALU_CLCK)
);



data_sync #(.bus_width(8),.num_stages(2)) d_sync2 (
    .unsync_bus(fsm_out),
    .bus_en(fsm_valid),
    .clck(UART_TX_clck),
    .rst(sync_rst2),
    .sync_bus(sync_fsm_out),
    .en_pulse(sync_fsm_valid)
);






UART_TX UART_TX_TOP(
    .p_data(sync_fsm_out),
    .data_valid(sync_fsm_valid),
    .par_en(REG2[0]),
    .par_typ(REG2[1]),
    .clck(UART_TX_clck),
    .rst(sync_rst2),
    .TX_OUT(TX_OUT),
    .busy(busy_tx)
);

ClkDiv #(.RATIO_WD(4)) ClkDiv_TOP(
    .i_ref_clk(UART_clck),
    .i_rst(sync_rst2),
    .i_clk_en(1'b1),
    .i_div_ratio(REG3[3:0]),
    .o_div_clk(UART_TX_clck)
);



RST_sync #(.num_stages(2)) sync_rst_u1(
    .rst(rst),
    .clck(refclck),
    .sync_rst(sync_rst1)
);

RST_sync #(.num_stages(2)) sync_rst_u2(
    .rst(rst),
    .clck(UART_clck),
    .sync_rst(sync_rst2)
);

endmodule