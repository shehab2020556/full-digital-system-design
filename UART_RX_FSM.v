module UART_RX_FSM(start_check,RX_IN,par_en,par_typ,bit_cnt,edge_cnt,prescale,par_check_err,stop_err,clck,rst,data_valid,par_check_en,counter_enable,deserializer_en);
input start_check,RX_IN,par_en,par_typ,par_check_err,stop_err,clck,rst;
input [5:0] prescale;
input [4:0] bit_cnt;
input [5:0] edge_cnt;
output reg data_valid,par_check_en,counter_enable,deserializer_en;

localparam IDLE=3'b000 ,start=3'b001 ,data=3'b010 ,parity_check=3'b011 ,stop_check=3'b100;

reg [2:0] current_state,next_state;

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
    IDLE :begin
        if (start_check==1 && edge_cnt==prescale)
        begin
            next_state=data;
        end
        else
        begin
            next_state=IDLE;
        end
    end


    data : begin
        if (bit_cnt==8 && par_en==1)
        begin
            next_state=parity_check;
        end
        else if (bit_cnt==8 && par_en==0)
        begin
            next_state=stop_check;
        end
        else
        begin
            next_state=data;
        end
    end

    parity_check : begin
        if (edge_cnt==prescale)
        begin
            next_state= stop_check;
        end
        else
        begin
            next_state=parity_check;
        end
    end

    stop_check : begin
        if (edge_cnt==prescale)
        begin
        next_state=IDLE;
        
        end
        else
        begin
            next_state=stop_check;
        end
    end
     default : next_state=IDLE;
endcase
end

always @(*)
begin
    case (current_state)
    IDLE : begin
        data_valid=0;
        par_check_en=0;
        counter_enable=0;
        deserializer_en=0;
    end

    data : begin
        data_valid=0;
        par_check_en=0;
        counter_enable=1;
        deserializer_en=1;
    end

    parity_check : begin
        data_valid=0;
        par_check_en=1;
        counter_enable=0;
        deserializer_en=0;
    end

    stop_check : begin
        if (edge_cnt==prescale && par_en==1)
        begin
            data_valid=~(stop_err | par_check_err);
        end
        else if (edge_cnt==prescale && par_en==0)
        begin
            data_valid=~stop_err;
        end
        else
        begin
            data_valid=0;
        end
        par_check_en=0;
        counter_enable=0;
        deserializer_en=0;
    end

    default : begin
        data_valid=0;
        par_check_en=0;
        counter_enable=0;
        deserializer_en=0;
    end

endcase

end

endmodule