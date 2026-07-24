# 🎮 Genius - Jogo Simon em FPGA DE2

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-HDL-blue)
![FPGA](https://img.shields.io/badge/FPGA-DE2-orange)
![Status](https://img.shields.io/badge/STATUS-CONCLUÍDO-brightgreen)

O **Genius (Simon)** é uma implementação do clássico jogo da memória desenvolvida em **SystemVerilog** para a placa **FPGA DE2**, como projeto final da disciplina de **Laboratório de Circuitos Lógicos** da **Universidade de Brasília (UnB)**.

O projeto teve como objetivo aplicar conceitos de **lógica digital**, **máquinas de estados finitas (FSM)**, **circuitos sequenciais**, **memórias**, **LFSR (Linear Feedback Shift Register)** e controle de periféricos, integrando todos os módulos em um sistema funcional executado diretamente em hardware. :contentReference[oaicite:0]{index=0}

---

# 🚀 Funcionalidades

- 🎲 Geração pseudoaleatória de sequências utilizando **LFSR**;
- 🧠 Armazenamento da sequência em memória interna;
- 🔄 Máquina de Estados Finita (FSM) controlando toda a lógica do jogo;
- 💡 Exibição das cores através de LEDs;
- 🔊 Efeitos sonoros e melodia de derrota utilizando buzzer;
- 📈 Sistema de pontuação em BCD exibido nos displays de sete segmentos;
- 🏆 Registro automático da maior pontuação alcançada;
- ⏱️ Derrota automática caso o jogador exceda o tempo limite de resposta;
- 🎮 Sistema de pausa, reinício e reset do jogo. :contentReference[oaicite:1]{index=1} :contentReference[oaicite:2]{index=2}

---

# 🏗️ Arquitetura

O projeto foi dividido em módulos independentes para facilitar o desenvolvimento e a manutenção:

- **Debounce** — elimina ruídos dos botões mecânicos;
- **Gerador Aleatório (LFSR)** — responsável pelas cores sorteadas;
- **Memória da Sequência** — armazena toda a sequência do jogo;
- **FSM (Finite State Machine)** — controla todos os estados do jogo;
- **Controlador de Áudio** — gera os sons do buzzer;
- **Sistema de Pontuação** — controla a pontuação atual e o recorde utilizando displays de sete segmentos. :contentReference[oaicite:3]{index=3}

---

# 🛠️ Tecnologias Utilizadas

- SystemVerilog
- Quartus II 13.0
- ModelSim
- FPGA Altera DE2

---

# 🎮 Funcionamento

Ao iniciar a partida, uma sequência de cores é exibida ao jogador.

A cada rodada:

1. Uma nova cor é adicionada à sequência.
2. O jogador deve repetir corretamente toda a sequência.
3. Cada acerto aumenta a pontuação.
4. Caso uma cor incorreta seja pressionada ou o tempo limite seja excedido, a partida termina e um som de derrota é reproduzido. :contentReference[oaicite:4]{index=4}

---

# ⚙️ Como Executar

## Requisitos

- Quartus II 13.0
- ModelSim (opcional para simulação)
- Placa FPGA Altera DE2

## Passos

1. Abra o projeto no Quartus II.
2. Compile o projeto.
3. Grave o arquivo `.sof` na FPGA utilizando o **Programmer (JTAG)**.
4. Conecte os LEDs e o buzzer conforme o mapeamento dos pinos.
5. Execute o jogo através das chaves e botões da placa. :contentReference[oaicite:5]{index=5}

---

# 📚 Conceitos Aplicados

- Lógica Digital
- Máquinas de Estados Finitas (FSM)
- Circuitos Sequenciais
- Registradores
- LFSR
- Memória
- Debounce
- Contadores em BCD
- Displays de Sete Segmentos
- Síntese em FPGA

---

# 👨‍💻 Autores

- João Pedro Nunes Rodrigues
- Arthur Oliveira Amorim
- Iuri Costa Cavalcante

Projeto desenvolvido para a disciplina **Laboratório de Circuitos Lógicos** — Universidade de Brasília (UnB). :contentReference[oaicite:6]{index=6}
