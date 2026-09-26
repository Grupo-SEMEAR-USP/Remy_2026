#!/bin/bash

CONTAINER_ALIAS='humble-remy'
CONTAINER_HOME=$(pwd)/containers/$CONTAINER_ALIAS
WS_SRC_FOLDER=$CONTAINER_HOME/remy_ws/src

mkdir -p $WS_SRC_FOLDER

echo "Baixando repositorios necessarios em $WS_SRC_FOLDER..."

# Installing rtabmap and rtabmap_ros from source
git clone https://github.com/introlab/rtabmap.git $WS_SRC_FOLDER/rtabmap
git clone --branch ros2 https://github.com/introlab/rtabmap_ros.git $WS_SRC_FOLDER/rtabmap_ros

# sllidar ros2
git clone https://github.com/Slamtec/sllidar_ros2.git $WS_SRC_FOLDER/sllidar_ros2

# Inicialização e Navegação Remy
git clone git@github.com:Grupo-SEMEAR-USP/Remy_nav.git $WS_SRC_FOLDER/remy_main

# Interação Remy
git clone git@github.com:Grupo-SEMEAR-USP/Remy_interacao.git $WS_SRC_FOLDER/remy_interaction

# Manipulador Remy
git clone git@github.com:Grupo-SEMEAR-USP/Remy_manipulador.git $WS_SRC_FOLDER/remy_manipulator

# Baixando o setup do micro-ROS (Branch Humble)
git clone -b humble https://github.com/micro-ROS/micro_ros_setup.git $WS_SRC_FOLDER/micro_ros_setup

#point_lio_ros2
#git clone https://github.com/dfloreaa/point_lio_ros2 $WS_SRC_FOLDER/point_lio_ros2

#fast lio
#git clone https://github.com/Ericsii/FAST_LIO.git $WS_SRC_FOLDER/fast_lio --recursive

echo "Pronto! Construa e inicie o container rodando: docker compose up -d --build"
