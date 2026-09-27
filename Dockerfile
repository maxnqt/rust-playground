# Rust dev environment for rust-playground.
# The official image already ships cargo, rustc, git, make, and a C toolchain.
FROM rust:1-bookworm

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

# Extra toolchain components used by the example Makefiles
RUN rustup component add rustfmt clippy

# Shell niceties: tab completion, a less pager, and the Starship prompt
RUN apt-get update \
 && apt-get install -y --no-install-recommends bash-completion less \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL https://starship.rs/install.sh | sh -s -- -y \
 && rustup completions bash cargo  > /usr/share/bash-completion/completions/cargo \
 && rustup completions bash rustup > /usr/share/bash-completion/completions/rustup \
 && git config --system --add safe.directory /workspace

# Non-root user matching your host UID/GID, so files created in the
# bind-mounted repo are owned by you (matters most on Linux).
# -o allows reusing IDs that already exist in the image (e.g. macOS GID 20).
RUN groupadd -o --gid "$USER_GID" "$USERNAME" \
 && useradd -o --uid "$USER_UID" --gid "$USER_GID" -m -s /bin/bash "$USERNAME" \
 && mkdir -p "/home/$USERNAME/.config" "/home/$USERNAME/.history" \
 && chown -R "$USER_UID:$USER_GID" /usr/local/cargo "/home/$USERNAME"

# Prompt config and shell setup
COPY --chown=$USER_UID:$USER_GID docker/starship.toml /home/$USERNAME/.config/starship.toml
COPY docker/.bashrc /tmp/bashrc.append
RUN cat /tmp/bashrc.append >> "/home/$USERNAME/.bashrc" && rm /tmp/bashrc.append

USER $USERNAME
WORKDIR /workspace
