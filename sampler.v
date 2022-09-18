module sampler (s_data,edge_cnt,clck,rst,sampeled_bit,prescale   );
input s_data,clck,rst;
input [5:0]edge_cnt;
input [5:0] prescale;
output reg sampeled_bit;

reg sample_1,sample_2,sample_3;

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        sample_1<=1;
        sample_2<=1;
        sample_3<=1;
    end
    else if (edge_cnt==((prescale/2)-2))
    begin
        sample_1<=s_data;

        sample_2<=sample_2;
        sample_3<=sample_3;
    end
    else if (edge_cnt==((prescale/2)-1))
    begin
        sample_2<=s_data;

        sample_1<=sample_1;
        sample_3<=sample_3;
    end
    else if (edge_cnt==((prescale/2)))
    begin
        sample_3<=s_data;

        sample_2<=sample_2;
        sample_1<=sample_1;
    end
    else
    begin
        sample_1<=sample_1;
        sample_2<=sample_2;
        sample_3<=sample_3;
    end
end

always @(posedge clck or negedge rst)
begin
    if (rst==0)
    begin
        sampeled_bit<=1;
    end

    else if (edge_cnt==prescale-1)
    begin

    if (sample_1 ==1 &sample_2==1 &&sample_3==1)
    begin
        sampeled_bit<=1;
    end
    else if (sample_1 ==1 &sample_2==1 &&sample_3==0)
    begin
        sampeled_bit<=1;
    end
    else if (sample_1 ==1 &sample_2==0 &&sample_3==1)
    begin
        sampeled_bit<=1;
    end
    else if (sample_1 ==0 &sample_2==1 &&sample_3==1)
    begin
        sampeled_bit<=1;
    end


    else if (sample_1 == 0 &sample_2==0 &&sample_3==0)
    begin
        sampeled_bit<=0;
    end
    else if (sample_1 == 1 &sample_2==0 &&sample_3==0)
    begin
        sampeled_bit<=0;
    end
    else if (sample_1 == 0 &sample_2==1 &&sample_3==0)
    begin
        sampeled_bit<=0;
    end
    else if (sample_1 == 0 &sample_2==0 &&sample_3==1)
    begin
        sampeled_bit<=0;
    end
    end
    else 
    begin
        sampeled_bit<=sampeled_bit;
    end
end

endmodule
