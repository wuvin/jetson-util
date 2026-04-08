FROM ubuntu:22.04

LABEL maintainer="jetson-util"
LABEL description="General CLI utility container for Jetson Orin host"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Core
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Editors
    vim \
    nano \
    # Shell & terminal
    tmux \
    screen \
    bash-completion \
    # Core CLI
    coreutils \
    findutils \
    grep \
    sed \
    gawk \
    less \
    tree \
    file \
    rename \
    bc \
    jq \
    xxd \
    && rm -rf /var/lib/apt/lists/*

# File management & transfer
RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync \
    curl \
    wget \
    openssh-client \
    sshfs \
    fuse3 \
    ncdu \
    duf \
    fd-find \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Networking & diagnostics
RUN apt-get update && apt-get install -y --no-install-recommends \
    network-manager \
    iproute2 \
    iputils-ping \
    traceroute \
    dnsutils \
    net-tools \
    nmap \
    iperf3 \
    ethtool \
    tcpdump \
    socat \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# System monitoring & process management
RUN apt-get update && apt-get install -y --no-install-recommends \
    htop \
    iotop \
    sysstat \
    lsof \
    strace \
    procps \
    psmisc \
    && rm -rf /var/lib/apt/lists/*

# Disk & filesystem utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    parted \
    fdisk \
    e2fsprogs \
    dosfstools \
    ntfs-3g \
    exfat-fuse \
    exfatprogs \
    smartmontools \
    hdparm \
    && rm -rf /var/lib/apt/lists/*

# Archive & compression
RUN apt-get update && apt-get install -y --no-install-recommends \
    p7zip-full \
    p7zip-rar \
    zip \
    unzip \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    zstd \
    lz4 \
    pigz \
    pbzip2 \
    && rm -rf /var/lib/apt/lists/*

# Git & misc development-adjacent tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    gnupg \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# X11 / GUI support (for forwarding GUI apps to host display)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxcb1 \
    libxcb-xinerama0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libfontconfig1 \
    libfreetype6 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libdbus-1-3 \
    x11-utils \
    dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

# Symlinks for tools that install under non-obvious names
RUN ln -sf /usr/bin/fdfind /usr/local/bin/fd

# Shell defaults
WORKDIR /home/num4
RUN { \
    echo 'PURPLE="\[\e[1;35m\]"'; \
    echo 'BLUE="\[\e[1;34m\]"'; \
    echo 'RESET="\[\e[0m\]"'; \
    echo 'export PS1="${PURPLE}\u@\h:${BLUE}\w${RESET}\$ "'; \
} >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]