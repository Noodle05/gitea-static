FROM --platform=${BUILDPLATFORM} node:lts-bookworm AS builder

ARG GITEA_VERSION=v1.25.0
ARG GITEA_GIT_URL=https://github.com/go-gitea/gitea.git

SHELL ["/bin/bash", "-c"]

RUN curl -fsSL https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash - \
 && source /root/.bashrc \
 && mkdir /work \
 && cd /work \
 && git  -c advice.detachedHead=false clone -b "${GITEA_VERSION}" --single-branch --depth 1 "${GITEA_GIT_URL}" \
 && cd gitea \
 && make frontend

FROM alpine:latest

LABEL maintainer='Wei Gao<wei@gaofamily.org>'

COPY --from=builder /work/gitea/public /gitea/static

VOLUME /gitea-static

CMD [ "cp", "-R", "/gitea/static", "/gitea-static" ]
