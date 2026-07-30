FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies including SSH
RUN apt-get update && apt-get install -y \
  curl \
  ca-certificates \
  gnupg \
  openssh-server &&
  rm -rf /var/lib/apt/lists/*

# Install WezTerm
RUN curl -fsSL https://apt.fury.io/wez/gpg.key | gpg --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *" | tee /etc/apt/sources.list.d/wezterm.list
RUN apt-get update && apt-get install -y wezterm

# Create user with NO password
RUN useradd -m -s /bin/bash developer

# Configure SSH to allow empty passwords
RUN mkdir -p /var/run/sshd &&
  echo 'PermitEmptyPasswords yes' >>/etc/ssh/sshd_config &&
  echo 'PasswordAuthentication yes' >>/etc/ssh/sshd_config &&
  echo 'UsePAM no' >>/etc/ssh/sshd_config

USER developer
WORKDIR /home/developer

EXPOSE 22

# Start both services
CMD ["sh", "-c", "wezterm-mux-server --daemonize=false & exec /usr/sbin/sshd -D"]
