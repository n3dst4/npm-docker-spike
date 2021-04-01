#! /bin/bash

TIMEFORMAT=%E

function install {
  echo $(npm i --no-progress --silent 2>&1 > /dev/null)
}

function time_install {
  for n in {1..3}; do 
    echo -n "$(pwd), npm $(npm --version), run ${n}... "
    rm -rf node_modules package-lock.json
    time install
  done
}

mkdir /local
cp /mounted/package.json /local

cd /mounted
time_install
cd /local
time_install

echo -n "UPGRADING TO NPM LATEST... "
time npm i -g npm@latest --no-progress --silent 2>&1 >/dev/null

cd /mounted
time_install
cd /local
time_install
