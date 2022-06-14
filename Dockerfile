FROM ghcr.io/tudelft-cda-lab/flexfringe:main

# TODO
# copy steps.sh
# WORKDIR /home/flexfringe
ENTRYPOINT ["/home/steps.sh"]
