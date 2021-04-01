#! /bin/bash

function install {
  npm i 2>&1 >/dev/null
}

function time_install {
  for n in {1..5}; do 
    echo "$(pwd), npm $(npm --version), run ${n}"
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

echo "UPGRADING TO NPM 7"
npm i -g npm@latest 2>&1 >/dev/null

cd /mounted
time_install
cd /local
time_install
