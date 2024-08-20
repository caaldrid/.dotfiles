FROM ubuntu:noble

# Install basic pkgs
RUN apt update && apt install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt update && apt install -y curl iputils-ping sudo git build-essential

# Set build arguments for the username and password
ARG USERNAME
ARG USER_PASSWORD_HASH

# Add a new user with the specified username and create a home directory
RUN useradd -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME}:${USER_PASSWORD_HASH}" | chpasswd -e

# Add the user to the sudo group
RUN usermod -aG sudo ${USERNAME}

# Switch to the new user
USER ${USERNAME}

# Set the working directory to the user's home
WORKDIR /home/${USERNAME}

# Default command to run in the container
CMD ["bash"]

