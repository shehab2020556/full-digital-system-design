module sys_cont_fsm1  #(parameter WIDTH = 8, ADDR = 4 )
( 
    input                         clck,
    input                         rst,
    input     wire  [7:0]         frame,
    input     wire                valid,
    /*
    input     wire  [WIDTH-1:0]   RdData,
    input     wire                RD_data_valid,
    */
    output    reg                 WrEn,
    output    reg                 RdEn,
    output    reg   [ADDR-1:0]    Address,
    output    reg   [WIDTH-1:0]   WrData,
    output    reg   [3:0]         ALU_FUN,
    output    reg                 ALU_EN,
    output    reg                 alu_clck_en,
    output    reg                 fsm2_start,


    output   [5:0 ]   current_state_tst,next_state_tst
);



reg [5:0 ] current_state,next_state;
reg [3:0]  Address_tmp;

assign current_state_tst=current_state;
assign next_state_tst=next_state;

localparam config1 = 6'b000_001 ,config2=6'b000_010 ,IDLE=6'b000_000 ,write0=6'b000_011 ,write1=6'b000_100 ;
localparam read0=6'b000_101 ;
localparam ALU0=6'b000_111 ,ALU1=6'b001_000 ,ALU2=6'b001_001 ,ALU3=6'b001_010;

always @(posedge clck or negedge rst) 
begin
    if (rst==0)
    begin
        current_state<=config1;
    end
    else
    begin
        current_state<=next_state;
    end
end

always @(*)
begin
    case (current_state)
    config1:begin
        next_state<=config2;
    end
    config2:begin
        next_state<=IDLE;
    end

    IDLE:begin
        if (frame==8'b1010_1010 && valid==1)
        begin
            next_state<=write0;
        end
        else if (frame==8'b1011_1011 && valid==1)
        begin
            next_state<=read0;
        end
        else if (frame==8'b1101_1101 && valid==1)
        begin
            next_state<=ALU0;
        end
        else if (frame==8'b1100_1100 && valid==1)
        begin
            next_state<=ALU1;
        end
        else
        begin
            next_state<=IDLE;
        end
    end
    
    write0:begin
        if (valid==1)
        begin
            next_state<=write1;
        end
        else
        begin
            next_state<=write0;
        end
    end

    write1:begin
        if (valid==1)
        begin
            next_state<=IDLE;
        end
        else
        begin
            next_state<=write1;
        end
    end

    read0:begin
        if (valid==1)
        begin
            next_state<=IDLE;
        end
        else
        begin
            next_state<=read0;
        end
    end
    
    ALU0:begin
        if (valid==1)
        begin
            next_state<=IDLE;
        end
        else
        begin
            next_state<=ALU0;
        end
    end

    ALU1:begin
        if (valid==1)
        begin
            next_state<=ALU2;
        end
        else
        begin
            next_state<=ALU1;
        end
    end
     ALU2:begin
        if (valid==1)
        begin
            next_state<=ALU3;
        end
        else
        begin
            next_state<=ALU2;
        end
    end

    ALU3:begin
        if (valid==1)
        begin
            next_state<=IDLE;
        end
        else
        begin
            next_state<=ALU3;
        end
    end

    default:begin
        next_state<=IDLE;
    end
    

    endcase
end

always @(*)
begin
    case(current_state)
    config1:begin
        WrEn <=1;
        RdEn<=0;
        WrData <=8'b001_00011;
        Address<=4'b0010;
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        alu_clck_en<=0;
        fsm2_start<=0;
    end
    config2:begin
        WrEn <=1;
        RdEn<=0;
        WrData <=8'b0000_1000;
        Address<=4'b0011;
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        alu_clck_en<=0;
        fsm2_start<=0;
    end



    IDLE:begin
        WrEn <=0;
        RdEn<=0;
        WrData <=8'b0000_0000;
        Address<=4'b0000;
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        if (next_state==IDLE)
        begin
            alu_clck_en<=1;
        end
        else
        begin
            alu_clck_en<=0;
        end
        fsm2_start<=0;
    end



    write0:begin
        WrEn <=0;
        RdEn<=0;
        WrData <=8'b0000_0000;
        Address<=frame[3:0];
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        alu_clck_en<=0;
        fsm2_start<=0;
    end

    write1:begin
        WrEn <=1;
        RdEn<=0;
        WrData <=frame;
        Address<=Address_tmp;
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        alu_clck_en<=0;
        fsm2_start<=0;
    end

    read0:begin
        WrEn <=0;
        if (valid==1)
        begin
            RdEn<=1;
        end
        WrData <=8'b0000_0000;
        Address<=frame[3:0];
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        alu_clck_en<=0;
        fsm2_start<=1;
    end


    ALU0:begin
        WrEn <=0;
        RdEn<=0;
        WrData <=8'b00000000;
        Address<=4'b0000;
        ALU_FUN<=frame[3:0];
        if (valid==1)
        begin
            ALU_EN<=1;
        end
        else
        begin
            ALU_EN<=0;
        end
        alu_clck_en<=1;
        fsm2_start<=1;
    end

    ALU1:begin
        WrEn <=1;
        RdEn<=0;
        WrData <=frame;
        Address<=4'b0000;
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        alu_clck_en<=0;
        fsm2_start<=0;
    end

    ALU2:begin
        WrEn <=1;
        RdEn<=0;
        WrData <=frame;
        Address<=4'b0001;
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        alu_clck_en<=1;
        fsm2_start<=0;
    end

    ALU3:begin
        WrEn <=0;
        RdEn<=0;
        WrData <=8'b0000_0000;
        Address<=4'b0000;
        ALU_FUN<=frame[3:0];
        if (valid==1)
        begin
            ALU_EN<=1;
        end
        else
        begin
            ALU_EN<=0;
        end
        alu_clck_en<=1;
        fsm2_start<=1;
    end

    default :begin
        WrEn <=0;
        RdEn<=0;
        WrData <=8'b0000_0000;
        Address<=4'b0000;
        ALU_FUN<=4'b0000;
        ALU_EN<=0;
        if (next_state==IDLE)
        begin
            alu_clck_en<=1;
        end
        else
        begin
            alu_clck_en<=0;
        end
        fsm2_start<=0;
    end

    endcase
end




always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        Address_tmp<=0;
    end
    else if(current_state==write0)
    begin
        Address_tmp<=frame[3:0];
    end
    else
    begin
        Address_tmp<=Address_tmp;
    end
end


endmodule