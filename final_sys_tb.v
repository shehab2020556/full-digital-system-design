`timescale 1ns/1ps
module final_sys_tb ();

wire TX_OUT;

reg RX_IN,refclck,UART_clck,rst;

wire UART_TX_clck;



final_sys dut(
    .refclck(refclck),
    .UART_clck(UART_clck),
    .rst(rst),
    .RX_IN(RX_IN),
    .TX_OUT(TX_OUT)
);

parameter REF_CLK_PER = 20 ;
parameter UART_RX_CLK_PER = 100 ;    
parameter UART_TX_CLK_PER = 800 ;


// REF Clock Generator
always #(REF_CLK_PER/2) refclck = ~refclck ;

// UART RX Clock Generator
always #(UART_RX_CLK_PER/2) UART_clck = ~UART_clck ;



ClkDiv #(.RATIO_WD(4)) ClkDiv_TOP_TB(
    .i_ref_clk(UART_clck),
    .i_rst(rst),
    .i_clk_en(1'b1),
    .i_div_ratio(4'b1000),
    .o_div_clk(UART_TX_clck)
);




initial 
begin
    $monitor("txclck=%b  ,TX_OUT=%b ",UART_TX_clck ,TX_OUT );
    refclck=0; rst=1;  UART_clck=0;
    #1 rst=0; RX_IN=1;
    #1 rst=1; RX_IN=1; 

    
    //write 10100100 in reg 1001
    //1010 1010
    #800 RX_IN=0; 

    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //0000 1001
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=1;
   
    //1010 0100
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=0;
    #800 RX_IN=1;

    //read 0111
    //1011 1011
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //0000 1001
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=1;
    


    
    //alu 130*4
    //1100 1100
    #800 RX_IN=0; 

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=1;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //130d 1000 0010
    #800 RX_IN=0; 

    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //4d 0000 0100
    #800 RX_IN=0; 

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=1;

    //0000 0010
    #800 RX_IN=0; 

    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=1;


    //alu 160/4
    //1100 1100
    #800 RX_IN=0; 

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=1;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //160d 1010 0000
    #800 RX_IN=0; 

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //4d 0000 0100
    #800 RX_IN=0; 

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=1;

    //0000 0011
    #800 RX_IN=0; 

    #800 RX_IN=1;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //IDLE
    #7200

    //read 1001
    //1011 1011
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //0000 1001
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //read 1001
    //1011 1011
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=1;
    #800 RX_IN=1;

    //0000 1001
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=1;

    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;
    #800 RX_IN=0;

    #800 RX_IN=1;
    #800 RX_IN=1;

    
    
    #10000
    #12800 $finish;
end

endmodule