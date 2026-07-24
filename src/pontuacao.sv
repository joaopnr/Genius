module pontuacao (
    input  logic clk,
    input  logic sw_liga_desliga, //ligar e desligar a pontuacao
    input  logic sw_reset_atual, //resetar a pontuacao atual
    input  logic key_inc, //incrementar 10 pontos na pontuacao atual
    
    output logic [6:0] hex0, hex1, hex2, hex3,
    output logic [6:0] hex4, hex5, hex6, hex7
);

    logic [3:0] cur_d1, cur_d2, cur_d3;
    logic [3:0] max_d1, max_d2, max_d3;

    logic key_sync_0, key_sync_1;
    wire inc_pulse = key_sync_0 & ~key_sync_1;

    always_ff @(posedge clk) begin
        key_sync_0 <= ~key_inc;
        key_sync_1 <= key_sync_0;
    end

    logic sw_sync_0, sw_sync_1;
    wire rst_pulse = sw_sync_0 & ~sw_sync_1;

    always_ff @(posedge clk) begin
        sw_sync_0 <= sw_reset_atual;
        sw_sync_1 <= sw_sync_0;
    end

    always_ff @(posedge clk or posedge sw_liga_desliga) begin
        if (sw_liga_desliga) begin
            cur_d1 <= 0; cur_d2 <= 0; cur_d3 <= 0;
            max_d1 <= 0; max_d2 <= 0; max_d3 <= 0;
        end
        else begin
            if (rst_pulse) begin
                cur_d1 <= 0; cur_d2 <= 0; cur_d3 <= 0;
            end
            else if (inc_pulse) begin
                if (cur_d1 == 9) begin
                    cur_d1 <= 0;
                    if (cur_d2 == 9) begin
                        cur_d2 <= 0;
                        if (cur_d3 < 9) cur_d3 <= cur_d3 + 1;
                    end else begin
                        cur_d2 <= cur_d2 + 1;
                    end
                end else begin
                    cur_d1 <= cur_d1 + 1;
                end
            end
            
            if ({cur_d3, cur_d2, cur_d1} > {max_d3, max_d2, max_d1}) begin
                max_d1 <= cur_d1;
                max_d2 <= cur_d2;
                max_d3 <= cur_d3;
            end
        end
    end

    decoder7 dec_cur0 (.bcd(4'd0), .seg(hex0)); 
    decoder7 dec_cur1 (.bcd(cur_d1), .seg(hex1));
    decoder7 dec_cur2 (.bcd(cur_d2), .seg(hex2));
    decoder7 dec_cur3 (.bcd(cur_d3), .seg(hex3));

    decoder7 dec_max0 (.bcd(4'd0), .seg(hex4));
    decoder7 dec_max1 (.bcd(max_d1), .seg(hex5));
    decoder7 dec_max2 (.bcd(max_d2), .seg(hex6));
    decoder7 dec_max3 (.bcd(max_d3), .seg(hex7));

endmodule