module sys_cont_fsm2 (
    input wire       clck,rst,
    input wire       fsm2_start,
    input wire [5:0] fsm1_state,
    input wire       valid,

    input wire [7:0] RdData,
    input wire       RdData_VLD,

    input wire [15:0] ALU_OUT,
    input wire        OUT_VALID,
    input wire        busy_tx,

    output reg [7:0] fsm_out,
    output reg       fsm_valid,

    output reg [2:0] current_state,next_state
);

//reg [2:0 ] current_state,next_state;

localparam IDLE=3'b000 ,read_out=3'b001, read_out_hold=3'b010 ;
localparam ALU_out1=3'b011 ,ALU_out_hold=3'b100 ,ALU_out_wait=3'b101  ,ALU_out2=3'b110 ,ALU_out_hold2=3'b111;

reg [15:0] reg_out;
reg [7:0]  read_tmp;


always @(posedge clck or negedge rst) 
begin
    if (rst==0)
    begin
        current_state<=IDLE;
    end
    else
    begin
        current_state<=next_state;
    end
end

always @(*)
begin
    case (current_state)
    IDLE:begin
        if (fsm2_start==1 && fsm1_state==6'b000_101 && valid==1)
        begin
            next_state<=read_out;
        end
        else if (fsm2_start==1 && fsm1_state==6'b000_111 && valid==1)
        begin
            next_state<=ALU_out1;
        end
        else if (fsm2_start==1 && fsm1_state==6'b001_010 && valid==1)
        begin
            next_state<=ALU_out1;
        end
        else 
        begin
            next_state<=IDLE;
        end
    end

    read_out:begin
        next_state<=read_out_hold;
    end

    read_out_hold:begin
        if (busy_tx)
        begin
            next_state<=IDLE;
        end
        else
        begin
            next_state<=read_out_hold;
        end
    end


    ALU_out1:begin
        next_state<=ALU_out_hold;
    end

    ALU_out_hold:begin
        if (busy_tx)
        begin
            next_state<=ALU_out_wait;
        end
        else
        begin
            next_state<=ALU_out_hold;
        end
    end

    ALU_out_wait:begin
        if (busy_tx)
        begin
            next_state<=ALU_out_wait;
        end
        else
        begin
            next_state<=ALU_out2;
        end
    end


    ALU_out2:begin
        next_state<=ALU_out_hold2;
    end

    ALU_out_hold2:begin
        if (busy_tx)
        begin
            next_state<=IDLE;
        end
        else
        begin
            next_state<=ALU_out_hold2;
        end
    end


    default:begin
        next_state<=IDLE;
    end

endcase
end

always @(*)
begin
    case (current_state)
    IDLE:begin
        fsm_out<=0;
        fsm_valid<=0;
        
    end

    read_out:begin
        fsm_out<=RdData;
        fsm_valid<=RdData_VLD;
        
    end

    read_out_hold:begin
        fsm_out<=read_tmp;
        fsm_valid<=1;
        
    end


    ALU_out1:begin
        fsm_out<=ALU_OUT[7:0];
        fsm_valid<=OUT_VALID;
        
    end

    ALU_out_hold:begin
        fsm_out<=reg_out[7:0];
        fsm_valid<=1;
        
    end

    ALU_out_wait:begin
        fsm_out<=0;
        fsm_valid<=0;
        
    end


    ALU_out2:begin
        fsm_out<=reg_out[15:8];
        fsm_valid<=1;
        
    end

     ALU_out_hold2:begin
        fsm_out<=reg_out[15:8];
        fsm_valid<=1;
        
     end

    default :begin
        fsm_out<=0;
        fsm_valid<=0;
        
    end
endcase
end


always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        reg_out<=0;
    end
    else if (current_state ==ALU_out1)
    begin
        reg_out<=ALU_OUT;
    end
    else
    begin
        reg_out<=reg_out;
    end
end

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        read_tmp<=0;
    end
    else if(current_state==read_out)
    begin
        read_tmp<=RdData;
    end
    else
    begin
        read_tmp<=read_tmp;
    end
end
/*
always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        I<=0;
    end
    else if (count_enable==1)
    begin
        I=I+1;
    end
    else
    begin
        I=0;
    end
end
*/


endmodule

