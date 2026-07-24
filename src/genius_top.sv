// ============================================================================
// MÓDULO PRINCIPAL (TOP-LEVEL) 
// ============================================================================
module genius_top (
    input  logic clk_50mhz,       
    
    // Chaves de Controle
    input  logic sw_liga_desliga,  // SW[17]
    input  logic sw_reset_geral,   // SW[16]
    input  logic sw_inicio_jogo,   // SW[15]
    
    // Botões de Cores 
    input  logic key_verde,        // KEY[3]
    input  logic key_vermelho,     // KEY[2]
    input  logic key_azul,         // KEY[1]
    input  logic key_amarelo,      // KEY[0]
    
    // Saídas para os LEDs 
    output logic led_verde,        // LEDR[3]
    output logic led_vermelho,     // LEDR[2]
    output logic led_azul,         // LEDR[1]
    output logic led_amarelo,      // LEDR[0]
    
    output logic [6:0] hex0, hex1, hex2, hex3,
    output logic [6:0] hex4, hex5, hex6, hex7,
    
    output logic buzzer
);

    logic key_verde_db, key_vermelho_db, key_azul_db, key_amarelo_db;
    logic sw_inicio_jogo_db;

    debounce db_verde (.clk(clk_50mhz), .button_in(key_verde), .button_out(key_verde_db));
    debounce db_verm  (.clk(clk_50mhz), .button_in(key_vermelho), .button_out(key_vermelho_db));
    debounce db_azul  (.clk(clk_50mhz), .button_in(key_azul), .button_out(key_azul_db));
    debounce db_amar  (.clk(clk_50mhz), .button_in(key_amarelo), .button_out(key_amarelo_db));
    
    debounce db_start (.clk(clk_50mhz), .button_in(sw_inicio_jogo), .button_out(sw_inicio_jogo_db));

    logic [3:0] botoes_fsm;
    assign botoes_fsm[3] = key_verde_db;
    assign botoes_fsm[2] = key_vermelho_db;
    assign botoes_fsm[1] = key_azul_db;
    assign botoes_fsm[0] = key_amarelo_db;

    logic [1:0] cor_rand, cor_saida;
    logic [4:0] tamanho, end_leitura;
    logic limpa, grava, inc_pt, rst_pt, bipe, hino;
    logic [3:0] leds_fsm;

    gerador_aleatorio lfsr_inst (
        .clk(clk_50mhz), .reset(sw_reset_geral), .cor(cor_rand)
    );

    memoria_sequencia mem_inst (
        .clk(clk_50mhz), .reset(sw_reset_geral), .limpa_mem(limpa), 
        .grava_cor(grava), .cor_in(cor_rand), .end_leitura(end_leitura), 
        .cor_out(cor_saida), .tamanho(tamanho)
    );

    controlador_audio audio_inst (
        .clk(clk_50mhz), .toca_bipe(bipe), .toca_hino(hino), .saida_buzzer(buzzer)
    );

    genius_fsm fsm_inst (
        .clk(clk_50mhz), .reset(sw_reset_geral), .liga_desliga(sw_liga_desliga), 
        .start(sw_inicio_jogo_db), .botoes(botoes_fsm), .cor_mem(cor_saida), .tam_seq(tamanho),
        .limpa_mem(limpa), .grava_cor(grava), .end_leitura(end_leitura),
        .inc_ponto_n(inc_pt), .rst_ponto_n(rst_pt),
        .leds(leds_fsm), .toca_bipe(bipe), .toca_hino(hino)
    );

    assign led_verde    = leds_fsm[3];
    assign led_vermelho = leds_fsm[2];
    assign led_azul     = leds_fsm[1];
    assign led_amarelo  = leds_fsm[0];
     
    // Instanciação da pontuação externa
    pontuacao pt_inst (
        .clk(clk_50mhz), 
        .sw_liga_desliga(sw_liga_desliga), 
        .sw_reset_atual(rst_pt),           
        .key_inc(inc_pt),                  
        
        .hex0(hex0), .hex1(hex1), .hex2(hex2), .hex3(hex3),
        .hex4(hex4), .hex5(hex5), .hex6(hex6), .hex7(hex7)
    );

endmodule


// ============================================================================
// SUBMÓDULO: GERADOR ALEATÓRIO (LFSR)
// ============================================================================
module gerador_aleatorio (
    input  logic clk,
    input  logic reset,
    output logic [1:0] cor
);
    logic [3:0] lfsr;
    wire feedback = ~(lfsr[3] ^ lfsr[2]);

    always_ff @(posedge clk) begin
        if (reset) lfsr <= 4'b0001;
        else       lfsr <= {lfsr[2:0], feedback};
    end
    assign cor = lfsr[1:0];
endmodule


// ============================================================================
// SUBMÓDULO: MEMÓRIA DA SEQUÊNCIA
// ============================================================================
module memoria_sequencia (
    input  logic       clk,
    input  logic       reset,
    input  logic       limpa_mem,
    input  logic       grava_cor,
    input  logic [1:0] cor_in,
    input  logic [4:0] end_leitura,
    output logic [1:0] cor_out,
    output logic [4:0] tamanho
);
    logic [1:0] mem [0:31];
    logic [4:0] ptr;

    always_ff @(posedge clk) begin
        if (reset || limpa_mem) begin
            ptr <= 0;
        end else if (grava_cor && ptr < 31) begin
            mem[ptr] <= cor_in;
            ptr <= ptr + 1;
        end
    end
    assign cor_out = mem[end_leitura];
    assign tamanho = ptr;
endmodule


// ============================================================================
// SUBMÓDULO: CONTROLADOR DE ÁUDIO (Bipe)
// ============================================================================
module controlador_audio (
    input  logic clk,
    input  logic toca_bipe,
    input  logic toca_hino,
    output logic saida_buzzer
);
    logic [16:0] div_atual;
    logic [16:0] contador_freq;
    logic [24:0] contador_tempo_nota;
    logic [3:0]  indice_nota;
    logic onda;

    localparam FREQ_BIPE = 17'd56818; // 440Hz
    localparam G4 = 17'd63775, E4 = 17'd75987, C4 = 17'd95785, D4 = 17'd85324;
    
    logic [16:0] hino_notas [0:7];
    initial begin
        hino_notas[0] = G4; hino_notas[1] = E4; hino_notas[2] = C4; hino_notas[3] = C4;
        hino_notas[4] = D4; hino_notas[5] = E4; hino_notas[6] = G4; hino_notas[7] = G4;
    end

    always_ff @(posedge clk) begin
        if (toca_hino) begin
            div_atual <= hino_notas[indice_nota];
            if (contador_tempo_nota >= 12_500_000) begin
                contador_tempo_nota <= 0;
                indice_nota <= (indice_nota < 7) ? indice_nota + 1 : 0;
            end else begin
                contador_tempo_nota <= contador_tempo_nota + 1;
            end
        end else begin
            div_atual <= FREQ_BIPE;
            indice_nota <= 0;
            contador_tempo_nota <= 0;
        end
    end

    always_ff @(posedge clk) begin
        if (toca_bipe || toca_hino) begin
            if (contador_freq >= div_atual) begin
                contador_freq <= 0;
                onda <= ~onda;
            end else begin
                contador_freq <= contador_freq + 1;
            end
        end else begin
            contador_freq <= 0;
            onda <= 0;
        end
    end

    assign saida_buzzer = onda;
endmodule


// ============================================================================
// SUBMÓDULO: MÁQUINA DE ESTADOS (FSM)
// ============================================================================
module genius_fsm (
    input  logic       clk,
    input  logic       reset,
    input  logic       liga_desliga,
    input  logic       start,
    input  logic [3:0] botoes,
    input  logic [1:0] cor_mem,
    input  logic [4:0] tam_seq,
    
    output logic       limpa_mem,
    output logic       grava_cor,
    output logic [4:0] end_leitura,
    output logic       inc_ponto_n,
    output logic       rst_ponto_n,
    output logic [3:0] leds,
    output logic       toca_bipe,
    output logic       toca_hino
);
    typedef enum logic [2:0] { IDLE, GERA, MOSTRA, ESPERA, VERIFICA, ESPERA_SOLTAR, DERROTA, PREPARA_PROX } estado_t;
    estado_t estado, proximo;

    logic [27:0] timer; 
    logic [4:0]  passo;
    logic [1:0]  jogada;
    
    wire apertou = (botoes != 4'b1111); 
    wire pausado = (!start && estado != IDLE && estado != DERROTA);

    always_comb begin
        jogada = 2'b00;
        if (!botoes[3])      jogada = 2'b11; 
        else if (!botoes[2]) jogada = 2'b10; 
        else if (!botoes[1]) jogada = 2'b01; 
        else if (!botoes[0]) jogada = 2'b00; 
    end

    always_ff @(posedge clk) begin
        if (reset || !liga_desliga) begin
            estado <= IDLE;
            timer  <= 0;
            passo  <= 0;
        end else if (pausado) begin
            timer <= 0; 
        end else begin
            estado <= proximo;
            
            if (estado == GERA) begin
                passo <= 0;
            end
            else if (estado == MOSTRA) begin
                if (timer >= 25_000_000) begin 
                    if (passo < tam_seq) passo <= passo + 1;
                end
                if (proximo == ESPERA) passo <= 0; 
            end
            else if (estado == ESPERA_SOLTAR && proximo == ESPERA) begin
                passo <= passo + 1;
            end

            if (estado != proximo) begin
                timer <= 0; 
            end else begin
                if (estado == MOSTRA) begin
                    if (timer >= 25_000_000) timer <= 0; 
                    else timer <= timer + 1;
                end 
                else if (estado == IDLE) begin
                    if (timer < 28'd70_000_000) timer <= timer + 1;
                end
                else begin
                    timer <= timer + 1; 
                end
            end
        end
    end

    always_comb begin
        proximo = estado;
        case (estado)
            IDLE:    if (liga_desliga && start) proximo = GERA;
            GERA:    proximo = MOSTRA;
            MOSTRA:  if (passo == tam_seq) proximo = ESPERA; 
            ESPERA: begin
                if (apertou) proximo = VERIFICA;
                else if (timer >= 28'd250_000_000) proximo = DERROTA; 
            end
            VERIFICA: begin
                if (jogada != cor_mem) proximo = DERROTA;
                else                   proximo = ESPERA_SOLTAR;
            end
            ESPERA_SOLTAR: begin
                if (!apertou) begin
                    if (passo == tam_seq - 1) proximo = PREPARA_PROX; 
                    else                      proximo = ESPERA;
                end
            end
            PREPARA_PROX: begin
                if (timer >= 28'd50_000_000) proximo = GERA; 
            end
            DERROTA: if (!start) proximo = IDLE;
        endcase
    end

    always_comb begin
        limpa_mem = 0; 
        grava_cor = 0;
        inc_ponto_n = 1; 
        rst_ponto_n = 1; 
        toca_bipe = 0; 
        toca_hino = 0; 
        leds = 4'b0000;
        end_leitura = passo;

        case (estado)
            IDLE: begin 
                limpa_mem = 1; 
                rst_ponto_n = 0; 
                
                if (!reset) begin
                    if      (timer < 28'd10_000_000) leds = 4'b0001; 
                    else if (timer < 28'd20_000_000) leds = 4'b0010; 
                    else if (timer < 28'd30_000_000) leds = 4'b0100; 
                    else if (timer < 28'd40_000_000) leds = 4'b1000; 
                    else if (timer < 28'd60_000_000) leds = 4'b1111; 
                    else                             leds = 4'b0000; 
                end
            end
            
            GERA: grava_cor = 1;
            
            MOSTRA: begin
                if (passo < tam_seq) begin
                    if (timer < 20_000_000) begin 
                        toca_bipe = 1;
                        if (cor_mem == 2'b11)      leds[3] = 1'b1;
                        else if (cor_mem == 2'b10) leds[2] = 1'b1;
                        else if (cor_mem == 2'b01) leds[1] = 1'b1;
                        else if (cor_mem == 2'b00) leds[0] = 1'b1;
                    end
                end
            end
            
            ESPERA: begin
                end_leitura = passo;
            end
            
            VERIFICA: begin
                if (jogada == cor_mem && passo == tam_seq - 1) inc_ponto_n = 0; 
            end
            
            ESPERA_SOLTAR: begin
                toca_bipe = 1; 
                if (jogada == 2'b11)      leds[3] = 1'b1;
                else if (jogada == 2'b10) leds[2] = 1'b1;
                else if (jogada == 2'b01) leds[1] = 1'b1;
                else if (jogada == 2'b00) leds[0] = 1'b1;
            end
            
            PREPARA_PROX: begin
            end
            
            DERROTA: begin
                toca_hino = 1;
                leds = 4'b1111;  
                rst_ponto_n = 0; 
            end
        endcase

        if (!liga_desliga || reset) begin
            limpa_mem = 1; 
            rst_ponto_n = 0;
            leds = 4'b0000; 
            toca_bipe = 0;
            toca_hino = 0;
        end 
        else if (pausado) begin
            leds = 4'b0000;
            toca_bipe = 0;
            toca_hino = 0;
        end
    end
endmodule

// ============================================================================
// SUBMÓDULO: DEBOUNCE (Filtro Anti-Ruído para os Botões)
// ============================================================================
module debounce (
    input  logic clk,
    input  logic button_in,
    output logic button_out
);
    logic [19:0] counter;
    logic sync_0, sync_1;

    always_ff @(posedge clk) begin
        sync_0 <= button_in;
        sync_1 <= sync_0;
    end

    always_ff @(posedge clk) begin
        if (sync_1 == button_out) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 20'hFFFFF) begin 
                button_out <= sync_1;
                counter <= 0;
            end
        end
    end
endmodule