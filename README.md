# 🤖 Workspace Docker - Remy (ROS 2 Humble)

Este repositório contém a infraestrutura em Docker para o desenvolvimento de software do robô **Remy** (RoboCup@Home). Ele providencia um ambiente ROS 2 Humble conteinerizado, isolado e padronizado, com suporte direto a hardware (LiDAR, micro-ROS via USB) e dispositivos de áudio, além de bibliotecas de IA e navegação (Nav2, RTAB-Map, Whisper, Ollama).

---

## 📂 Estrutura do Projeto

* `prepareRemy.sh`: Script inicial que cria a estrutura de pastas do workspace isolado e clona os repositórios fonte necessários (Rtabmap, Slamtec LiDAR, etc).
* `Dockerfile`: A "receita" do nosso sistema. Instala o ROS 2 Humble, pacotes de simulação/navegação, cria o usuário `remy` e configura as bibliotecas de IA/Áudio em Python.
* `compose.yml`: O orquestrador que une tudo. Inicia o container espelhando os arquivos do seu host para dentro do Docker e concedendo as permissões necessárias (USB, Display X11, PulseAudio).

---

## 🚀 Primeira Instalação (Setup)

Siga estes passos apenas na **primeira vez** que for configurar o projeto na sua máquina:

1. Abra o terminal na raiz deste repositório e dê permissão de execução ao script de preparo:
   ```bash
   chmod +x prepareRemy.sh
   
2. Execute o script para baixar os repositórios (eles serão salvos em ./containers/humble-remy/remy_ws/src):
   ```bash
   ./prepareRemy.sh
3. Construa a imagem do Docker e inicie o container pela primeira vez (isso pode levar alguns minutos):
   ```bash
   docker compose up -d --build
   
## 💻 Fluxo de Trabalho Diário

Com o ambiente instalado, este será o seu guia de comandos para o dia a dia:

1. Ligar o ambiente
   
   Ligou o PC e quer começar a trabalhar? Basta iniciar o container em background:
   ```bash
   docker compose up -d

2. Entrar no terminal do robô

   Para interagir com o ROS 2, compilar códigos ou rodar nós, abra o terminal de dentro do container:
   ```bash
   docker exec -it remy_docker bash

3. Desligar o ambiente

   Precisa liberar memória RAM e processamento para jogar ou usar outros softwares, mas não quer desligar o computador? Pause o container:
   ```bash
   docker compose stop

## ⚡ Atalhos Rápidos (Aliases)

Para agilizar o fluxo, você pode criar atalhos (aliases) no seu terminal host (Ubuntu). Eles permitem ligar, entrar e desligar o container de qualquer lugar, sem precisar navegar até a pasta `~/remy`.

Copie e cole o bloco abaixo no seu terminal para adicionar os atalhos ao seu `~/.bashrc`:

  ```bash
  echo "alias dremy='docker compose -f ~/remy/compose.yml up -d && docker exec -it remy_container bash'" >> ~/.bashrc
  echo "alias stopremy='docker compose -f ~/remy/compose.yml stop'" >> ~/.bashrc
  source ~/.bashrc
  ```

Assim, dremy abrirá o container e stopremy o fechará. Ao invés de usar stopremy, você pode simplesmente desligar o computador.

## 🛠️ Atalhos do Sistema (Dentro do Container)

Para simplificar o desenvolvimento, os seguintes atalhos já vêm configurados por padrão no terminal do robô:

* **`cb`**: Executa `colcon build` (compila o seu workspace).
* **`sb`**: Executa `source install/setup.bash` (carrega os pacotes recém-compilados no terminal atual).
* **`rc`**: Atalho para abrir e editar o arquivo de configurações (`nano ~/.bashrc`).
* **`rcsave`**: Executa `source ~/.bashrc` (recarrega as configurações para aplicar as mudanças salvas).
