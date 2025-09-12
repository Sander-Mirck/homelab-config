# Start from the official linuxserver.io qbittorrent base image
FROM lscr.io/linuxserver/qbittorrent:latest

# Switch to the root user to install packages
USER root

# Run the installation command
# - Update the package index
# - Install ffmpeg and gnu-libiconv
# - Clean up the apk cache to keep the image small
RUN apk update && \
    apk add --no-cache \
        ffmpeg \
        gnu-libiconv && \
    rm -rf /var/cache/apk/*

# DO NOT switch the user back. The base image's startup script will handle this.
