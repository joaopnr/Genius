# 🎮 Genius - Jogo Simon em FPGA DE2

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-HDL-blue)
![FPGA](https://img.shields.io/badge/FPGA-DE2-orange)
![Status](https://img.shields.io/badge/STATUS-CONCLUÍDO-brightgreen)

O **Genius (Simon)** é uma implementação do clássico jogo da memória desenvolvida em **SystemVerilog** para a placa **FPGA DE2**, como projeto final da disciplina de **Laboratório de Circuitos Lógicos** da **Universidade de Brasília (UnB)**.

O projeto foi desenvolvido com o objetivo de aplicar conceitos de **lógica digital**, **máquinas de estados finitas (FSM)**, **circuitos sequenciais**, **memórias**, **LFSR (Linear Feedback Shift Register)** e controle de periféricos, integrando todos os módulos em um sistema funcional executado diretamente em hardware.

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
- 🎮 Sistema de pausa, reinício e reset do jogo.

---

# 🏗️ Arquitetura

O projeto foi dividido em módulos independentes para facilitar o desenvolvimento e a manutenção:

- **Debounce** — elimina ruídos dos botões mecânicos;
- **Gerador Aleatório (LFSR)** — responsável pelas cores sorteadas;
- **Memória da Sequência** — armazena toda a sequência do jogo;
- **FSM (Finite State Machine)** — controla todos os estados do jogo;
- **Controlador de Áudio** — gera os sons do buzzer;
- **Sistema de Pontuação** — controla a pontuação atual e o recorde utilizando displays de sete segmentos.

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
4. Caso uma cor incorreta seja pressionada ou o tempo limite seja excedido, a partida termina e um som de derrota é reproduzido. 

---

# 📂 Estrutura do Projeto

```text
📦 Genius-FPGA
├── docs/           # Relatório e video de demonstração do projeto
├── quartus/        # Arquivos do projeto Quartus (.qpf e .qsf)
├── src/            # Código-fonte em SystemVerilog
└── README.md
```

---

# ⚙️ Como Executar

## Requisitos

Antes de executar o projeto, é necessário possuir:

- Quartus II 13.0 ou versão compatível;
- ModelSim (opcional, para simulações);
- Placa FPGA Altera DE2;
- Cabo USB-Blaster para gravação da FPGA.

## Passo a passo

1. Clone este repositório:

```bash
git clone https://github.com/SEU-USUARIO/Genius-FPGA.git
```

2. Abra o Quartus II e selecione:

```
File → Open Project...
```

3. Navegue até a pasta `quartus/` e abra o arquivo:

```
jogo.qpf
```

4. Compile o projeto em:

```
Processing → Start Compilation
```

5. Conecte a placa DE2 ao computador utilizando o USB-Blaster e ligue a alimentação da FPGA.

6. Abra o gravador do Quartus:

```
Tools → Programmer
```

7. Adicione o arquivo `.sof` gerado na pasta `output_files/` após a compilação e clique em **Start** para gravar a FPGA.

8. Após a programação da placa, o jogo estará pronto para ser utilizado através dos botões, chaves, LEDs e displays de sete segmentos da DE2.

> **Observação:** Caso deseje apenas analisar ou modificar o código, todos os módulos em SystemVerilog estão disponíveis na pasta `src/`.
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

Projeto desenvolvido para a disciplina **Laboratório de Circuitos Lógicos** — Universidade de Brasília (UnB).
