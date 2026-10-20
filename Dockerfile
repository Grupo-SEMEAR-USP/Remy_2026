FROM ros:humble
ARG USERNAME=remy
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Instalação de dependências do sistema e do ROS 2
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
        python3-pip \
        python3-serial \
        python3-dev \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-vcstool \
        portaudio19-dev \
        build-essential \
        git \
        wget \
        curl \
        lsb-release \
        nano \
        # ROS 2 tools
        ros-humble-moveit \
        ros-humble-topic-tools \
        ros-humble-tf2-tools \
        ros-humble-rviz2 \
        ros-humble-plotjuggler-ros \
        ros-humble-xacro \
        ros-humble-robot-state-publisher \
        ros-humble-joint-state-publisher \
        ros-humble-joint-state-publisher-gui \
        ros-humble-ros-gz \
        ros-humble-ign-ros2-control \
        ros-humble-gz-ros2-control \
        ros-humble-ros-gz-bridge \
        ros-humble-ros-gz-sim \
        ros-humble-gazebo-ros-pkgs \
        ros-humble-gazebo-ros2-control \
        ros-humble-ros2-control \
        ros-humble-ros2-controllers \
        ros-humble-controller-manager \
        # Drivers do Joystick
        ros-humble-joy \
        ros-humble-joy-teleop \
        ros-humble-teleop-tools \
        # Navigation e SLAM
        ros-humble-slam-toolbox \
        ros-humble-navigation2 \
        ros-humble-nav2-bringup \
        ros-humble-rqt-robot-steering \
        ros-humble-rqt-common-plugins \
        ros-humble-diff-drive-controller \
        ros-humble-joint-state-broadcaster \
        ros-humble-tf2-ros \
        ros-humble-tf2-geometry-msgs \
        ros-humble-robot-localization \
        ros-humble-tf-transformations \
        # Câmera RealSense
        ros-humble-realsense2-camera \
        libpcl-dev \
        ros-humble-pcl-ros \
        ros-humble-pcl-conversions \
        ros-humble-image-geometry \
        ros-humble-rqt-image-view \
        usbutils \
        python3-transforms3d \
    && rm -rf /var/lib/apt/lists/*

# Instalação das bibliotecas Python para IA, Áudio e Visão
RUN pip3 install \
    SpeechRecognition \
    gTTS \
    pygame \
    google-generativeai \
    pyaudio \
    faster-whisper \
    piper-tts \
    ollama 

# Inicializa o rosdep e compila a interface Python do MoveIt 2
RUN if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then rosdep init; fi \
    && rosdep update \
    && apt-get update \
    && mkdir -p /opt/ros2_deps/src \
    && git clone https://github.com/AndrejOrsula/pymoveit2.git /opt/ros2_deps/src/pymoveit2 \
    && . /opt/ros/humble/setup.sh \
    && cd /opt/ros2_deps \
    && rosdep install --from-paths src --ignore-src --rosdistro humble -y \
    && colcon build --symlink-install \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /remy_ws
RUN mkdir -p /remy_ws/src && chown -R $USERNAME:$USERNAME /remy_ws

RUN echo "source /opt/ros/humble/setup.bash" >> /etc/bash.bashrc
RUN echo "source /opt/ros2_deps/install/setup.bash" >> /etc/bash.bashrc

# Set the default user
USER $USERNAME

RUN echo "alias cb='colcon build'" >> /home/$USERNAME/.bashrc \
    && echo "alias sb='source install/setup.bash'" >> /home/$USERNAME/.bashrc \
    && echo "alias rc='nano ~/.bashrc'" >> /home/$USERNAME/.bashrc \
    && echo "alias rcsave='source ~/.bashrc'" >> /home/$USERNAME/.bashrc \
    && echo "if [ -f /remy_ws/install/setup.bash ]; then source /remy_ws/install/setup.bash; fi" >> /home/$USERNAME/.bashrc 

CMD ["/bin/bash"]

