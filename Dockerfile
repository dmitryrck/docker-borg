from ubuntu

env DEBIAN_FRONTEND noninteractive

run apt-get update && \
  apt-get install -y borgbackup && \
  rm -rf /var/lib/apt/lists/*
