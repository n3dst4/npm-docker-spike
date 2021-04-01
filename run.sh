#! /bin/bash

rm -rf tmpmnt
cp -a src tmpmnt
docker run -it --volume=/home/ndc/git/trade-ui-build-spike/tmpmnt:/root tradespike
