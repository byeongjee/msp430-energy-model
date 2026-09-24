FROM julia:1.11.7-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bzip2 ca-certificates curl unzip libexpat1 libncursesw5 libtinfo5 \
    && rm -rf /var/lib/apt/lists/*

ARG TI_URL=https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH
RUN curl -fsSL "$TI_URL/9.3.1.2/msp430-gcc-9.3.1.11_linux64.tar.bz2" | tar -xj -C /opt \
    && mv /opt/msp430-gcc-9.3.1.11_linux64 /opt/msp430-gcc \
    && curl -fsSLo /tmp/support.zip "$TI_URL/9.3.1.1/msp430-gcc-support-files-1.211.zip" \
    && unzip -q /tmp/support.zip -d /opt \
    && mv /opt/msp430-gcc-support-files /opt/msp430-support \
    && rm /tmp/support.zip

COPY --from=ghcr.io/astral-sh/uv:0.9.18 /uv /uvx /usr/local/bin/

ENV JULIA_DEPOT_PATH=/opt/julia-depot \
    UV_PYTHON_INSTALL_DIR=/opt/uv-python \
    UV_PROJECT_ENVIRONMENT=/opt/venv \
    UV_CACHE_DIR=/opt/uv-cache \
    UV_LINK_MODE=copy \
    UV_FROZEN=1

COPY Project.toml Manifest.toml /opt/pem/
RUN julia --project=/opt/pem -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

COPY pyproject.toml uv.lock .python-version /opt/pem/
RUN cd /opt/pem \
    && touch README.md \
    && for pkg in pipeline measurement benchmarks reports analysis; do \
         mkdir -p scripts/$pkg && touch scripts/$pkg/__init__.py; \
       done \
    && uv sync \
    && rm -rf /opt/pem \
    && chmod -R a+rwX /opt/julia-depot /opt/venv /opt/uv-cache /opt/uv-python

ENV JULIA_DEPOT_PATH=/tmp/julia-depot:/opt/julia-depot: \
    HOME=/tmp \
    JULIA_NUM_THREADS=auto \
    PEM_IN_CONTAINER=1
