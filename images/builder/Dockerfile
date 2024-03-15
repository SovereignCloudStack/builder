# This is the Dockerfile for the Builder Image that is used by the CI
# pipelines.

# Install Lychee
FROM docker.io/lycheeverse/lychee:0.14.3 as lychee

# Install Golang CI Lint
FROM docker.io/library/alpine:3.19.1@sha256:6457d53fb065d6f250e1504b9bc42d5b6c65941d57532c072d929dd0628977d0 as golangci
# update: datasource=github-tags depName=golangci/golangci-lint versioning=semver
ENV GOLANGCI_VERSION="v1.56.2"
WORKDIR /
# hadolint ignore=DL3018,DL4006
RUN apk add --no-cache curl && \
    curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s ${GOLANGCI_VERSION}

# Install Hadolint
FROM docker.io/hadolint/hadolint:v2.12.0-alpine@sha256:7dba9a9f1a0350f6d021fb2f6f88900998a4fb0aaf8e4330aa8c38544f04db42 as hadolint

# Install Trivy
FROM docker.io/aquasec/trivy:0.49.0@sha256:c71420cd77f136e8e900f71d272fb89075f6011019bdcb4b5f7c8e4212f9025e as trivy

############################
# csctl Build Image Base #
############################
FROM docker.io/library/golang:1.21.8-bullseye

# update: datasource=github-tags depName=adrienverge/yamllint versioning=semver
ENV YAMLLINT_VERSION="v1.35.1"

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -qy --no-install-recommends \
    gnupg python3 python3-pip \
    file zip unzip jq gettext \
    protobuf-compiler libprotobuf-dev \
    libsystemd-dev jq && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    pip install --no-cache-dir \
    yamllint==${YAMLLINT_VERSION}

COPY --from=lychee /usr/local/bin/lychee /usr/bin/lychee
COPY --from=golangci /bin/golangci-lint /usr/local/bin
COPY --from=hadolint /bin/hadolint /usr/bin/hadolint
COPY --from=trivy /usr/local/bin/trivy /usr/bin/trivy

ENV GOCACHE=/go/cache

COPY build.sh /
RUN chmod +x /build.sh
ENTRYPOINT ["/build.sh"]
