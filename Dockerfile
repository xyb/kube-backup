FROM python:3.13-alpine

RUN apk update && \
  apk add --update \
    bash \
    easy-rsa \
    git \
    openssh-client \
    curl \
    ca-certificates \
    jq \
    libstdc++ \
    gpgme \
    git-crypt \
    && \
  rm -rf /var/cache/apk/*

RUN python -m pip install --no-cache-dir ijson awscli pyyaml
RUN adduser -h /backup -D backup

ENV KUBECTL_VERSION v1.35.0
ENV KUBECTL_URI https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl

RUN curl -fsSL "${KUBECTL_URI}" -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
RUN curl -fsSL "${KUBECTL_URI}.sha256" -o /tmp/kubectl.sha256 && \
  echo "$(cat /tmp/kubectl.sha256)  /usr/local/bin/kubectl" | sha256sum -c - || exit 10

COPY entrypoint.sh /
USER backup
ENTRYPOINT ["/entrypoint.sh"]
