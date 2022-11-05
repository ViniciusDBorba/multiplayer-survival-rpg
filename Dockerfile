FROM alpine:latest

# Variables
ENV GODOT_VERSION "3.5.1"
ENV GODOT_GAME_NAME "ZombieWaves"

# Updates and installs
RUN apk update
RUN apk add --no-cache bash
RUN apk add --no-cache wget

# Allow this to run Godot
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk
RUN apk add --allow-untrusted glibc-2.31-r0.apk

# Download Godot and export template, version is set from variables
RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux_headless.64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && rm -f Godot_v${GODOT_VERSION}-stable_export_templates.tpz Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip

# Make directory to run the app from
RUN mkdir /godotapp
WORKDIR /godotapp
COPY . .
EXPOSE 44444
EXPOSE 44444/tcp
EXPOSE 44444/udp
RUN godot --path . --export-pack "Linux/X11" ${GODOT_GAME_NAME}.pck --server --port=44444
CMD godot --main-pack ${GODOT_GAME_NAME}.pck --server --port=44444