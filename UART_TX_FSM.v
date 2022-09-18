module UART_TX_FSM (rst,p_data,data_valid,par_en,ser_done,clck,ser_en,p_data_tmp,busy,mux_sel);
input [7:0] p_data;
input rst,data_valid,par_en,ser_done,clck;
output reg [7:0] p_data_tmp;
output reg [1:0] mux_sel;
output reg ser_en,busy;
//output reg []current_state

localparam IDLE=3'b000 ,start=3'b001 ,data=3'b010 ,parity=3'b011 ,stop=3'b100;

reg [2:0] current_state,next_state;
reg [7:0] p_data_tmp_2;

always @(posedge clck or negedge rst)
begin
    if(rst==0)
   begin
    current_state <= IDLE ;
   end
  else
   begin
    current_state <= next_state ;
   end
 end

 always @(*)
 begin
    case (current_state)
    IDLE : begin
        if (data_valid==1)
        begin
            next_state=start;
        end
        else
        begin
            next_state=IDLE;
        end
    end

    start : begin
        next_state=data;
    end

    data : begin
        if (ser_done==1 && par_en==1)
        begin
            next_state=parity;
        end
        else if (ser_done==1 && par_en==0)
        begin
            next_state=stop;
        end
        else
        begin
            next_state=data;
        end
    end

    parity : begin
        next_state=stop;
    end

    stop : begin
        if (data_valid==1)
        begin
            next_state=start;
        end
        else
        begin
            next_state=IDLE;
        end
    end

    default : next_state=IDLE;
    endcase
 end

always @(*)
 begin
    case (current_state)
    IDLE : begin
        mux_sel=2'b01;
        ser_en=0;
        p_data_tmp=8'b00000000;
        busy=0;
    end

    start : begin
        mux_sel=2'b00;
        ser_en=1;
        p_data_tmp=p_data;
        busy=1;
    end

    data : begin
        mux_sel=2'b10;
        ser_en=0;
        p_data_tmp=p_data_tmp_2;
        busy=1;
    end

    parity : begin
        mux_sel=2'b11;
        ser_en=0;
        p_data_tmp=p_data_tmp_2;
        busy=1;
    end

    stop : begin
        mux_sel=2'b01;
        ser_en=0;
        p_data_tmp=p_data_tmp_2;
        busy=1;
    end

    default : begin
        mux_sel=2'b01;
        ser_en=0;
        p_data_tmp=p_data_tmp_2;
        busy=0;
    end
    
    endcase
 end


 always @(posedge clck or negedge rst)
 begin
    if (rst==0)
    begin
        p_data_tmp_2<=8'b00000000;
    end
    else if (current_state==start)
    begin
        p_data_tmp_2<=p_data;
    end
    else
    begin
        p_data_tmp_2<=p_data_tmp_2;
    end
 end

 endmodule


