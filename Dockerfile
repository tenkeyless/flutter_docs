# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04 AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    file \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    python3 \
    python3-pip \
    nodejs \
    npm \
    libstdc++6 \
    && apt-get clean

# Install the latest Node.js (20.x)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Clone the Flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set Flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Switch to the stable channel and upgrade Flutter
RUN flutter channel stable && flutter upgrade

# Enable web capabilities
RUN flutter config --enable-web

# Install pnpm using npm
RUN npm install -g pnpm

# Create the app directory and set as working directory
RUN mkdir /app
WORKDIR /app

# Run the serve command (assumes dependencies are installed during docker-compose execution)
CMD ["./dash_site", "serve"]
