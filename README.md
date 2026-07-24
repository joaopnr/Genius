# Genius FPGA (SystemVerilog)

Este projeto consiste na implementação do jogo **Genius (Simon)** utilizando **SystemVerilog** na placa **FPGA DE2**, desenvolvido como projeto final da disciplina de Laboratório de Circuitos Lógicos da Universidade de Brasília (UnB).

O jogo apresenta uma sequência de cores que deve ser reproduzida pelo jogador. A cada acerto, uma nova cor é adicionada à sequência, aumentando progressivamente a dificuldade. O sistema foi desenvolvido utilizando uma arquitetura modular, incluindo uma máquina de estados finita (FSM) para controlar toda a lógica do jogo, um gerador pseudoaleatório (LFSR) para criação das sequências, memória para armazenamento das jogadas, sistema de pontuação em displays de sete segmentos, tratamento de debounce para os botões e um controlador de áudio responsável pelos efeitos sonoros e melodia de derrota.

O projeto foi validado por meio de simulações no Quartus II/ModelSim e posteriormente testado em hardware na FPGA DE2, garantindo o correto funcionamento das regras do jogo e de todos os seus módulos.
