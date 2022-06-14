FROM ghcr.io/tudelft-cda-lab/flexfringe:main

USER root
RUN set -ex && \
    apk add --no-cache jq

# TODO

USER flexfringe
WORKDIR /home/flexfringe
COPY steps.sh .
ENTRYPOINT ["/home/flexfringe/steps.sh"]
