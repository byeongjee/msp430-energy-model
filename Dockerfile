FROM julia:1.11.7-bookworm@sha256:f4d3fac0fa62fb597cc498694fb26973346b837b9d14926dc8d5f6fc17d32c05

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bzip2 ca-certificates curl unzip libexpat1 libncursesw5 libtinfo5 \
    && rm -rf /var/lib/apt/lists/*

ARG TI_URL=https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH
RUN curl -fsSLo /tmp/toolchain.tar.bz2 "$TI_URL/9.3.1.2/msp430-gcc-9.3.1.11_linux64.tar.bz2" \
    && curl -fsSLo /tmp/support.zip "$TI_URL/9.3.1.1/msp430-gcc-support-files-1.211.zip" \
    && printf '%s  %s\n' \
       b60851b61565e3ddd2193298a3fac5120c2402597174106cc5f8482b9e9986e6 /tmp/toolchain.tar.bz2 \
       07589fb72192d47adf3b5f7e25271e8834a82ebc404e26c678044be29c026351 /tmp/support.zip \
       | sha256sum -c - \
    && tar -xjf /tmp/toolchain.tar.bz2 -C /opt \
    && mv /opt/msp430-gcc-9.3.1.11_linux64 /opt/msp430-gcc \
    && unzip -q /tmp/support.zip -d /opt \
    && mv /opt/msp430-gcc-support-files /opt/msp430-support \
    && rm /tmp/toolchain.tar.bz2 /tmp/support.zip

COPY --from=ghcr.io/astral-sh/uv:0.9.18@sha256:1f2af0857cdeac11a70fd1cea66c5b06bcdac804ea4147690816468f5bf9cea2 /uv /uvx /usr/local/bin/

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
