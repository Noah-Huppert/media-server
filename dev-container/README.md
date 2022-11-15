# Dev Container
A Docker image with all development dependencies installed.

# Table Of Contents
- [Overview](#overview)

# Overview
To use the dev container you must have Docker and Docker Compose installed. 

1. Start the Docker Compose stack:
   ```bash
   docker compose up -d --build
   ```
2. Run a one-off container with a Bash shell:
   ```bash
   docker compose run --rm dev_container
   ```
   This will open a shell with this repository's files.