module serializer (rst,p_data,ser_en,clck,ser_done,ser_data  );
input [7:0] p_data;
input rst,ser_en,clck;

output reg ser_done,ser_data;
reg [2:0] i;
reg tmp;

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        ser_data<=0;
        ser_done<=0;
        i<=0;
        tmp<=0;
    end
    else if (ser_en==1 )
    begin
        i<=0;
        tmp<=1;
        ser_done<=0;
        ser_data<=p_data[0];
    end
    else if (tmp==1)
    begin
        ser_data<=p_data[i+1];
        if (i==6)
        begin
            ser_done<=1;
            tmp<=0;
        end
        else 
        begin
            i<=i+1;
        end
    end 
    else
    begin 
        ser_data<=0;
        ser_done<=0;
        tmp<=0;
    end
end
endmodule


    


