FROM --platform=${BUILDPLATFORM} node:lts-alpine AS builder

ARG GITEA_VERSION=v1.16.6
ARG GITEA_GIT_URL=https://github.com/go-gitea/gitea.git

RUN apk --no-cache add git make

RUN mkdir /work \
 && cd /work \
 && git  -c advice.detachedHead=false clone -b "${GITEA_VERSION}" --single-branch --depth 1 "${GITEA_GIT_URL}" \
 && cd gitea \
 && make frontend

FROM alpine:latest

LABEL maintainer='Wei Gao<wei@gaofamily.org>'

COPY --from=builder /work/gitea/public /gitea/static

VOLUME /gitea-static

CMD [ "cp", "-R", "/gitea/static", "/gitea-static" ]
