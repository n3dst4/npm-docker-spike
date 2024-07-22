#! /bin/bash

TIMEFORMAT=%E

function install {
  echo $(npm i --no-progress --silent 2>&1 > /dev/null)
}

function pnpm_install {
  echo $(pnpm i --no-progress --silent 2>&1 > /dev/null)
}

function time_install {
  for n in {1..3}; do
    echo -n "$(pwd), npm $(npm --version), run ${n}... "
    rm -rf node_modules package-lock.json
    time install
  done
}

function time_install_pnpm {
  for n in {1..3}; do
    echo -n "$(pwd), pnpm $(pnpm --version), run ${n}... "
    rm -rf node_modules pnpm-lock.yaml
    time install
  done
}

mkdir /local
cp /mounted/package.json /local

echo
echo "INSTALLING NPM@6... "
time npm i -g npm@6 --no-progress --silent 2>&1 >/dev/null
echo

cd /mounted
time_install
cd /local
time_install

echo
echo "UPGRADING TO NPM@7... "
time npm i -g npm@7 --no-progress --silent 2>&1 >/dev/null
echo

cd /mounted
time_install
cd /local
time_install

echo
echo "UPGRADING TO NPM@10... "
time npm i -g npm@10 --no-progress --silent 2>&1 >/dev/null
echo

cd /mounted
time_install
cd /local
time_install

echo
echo "INSTALLING PNPM@9... "
time npm i -g pnpm@9 --no-progress --silent 2>&1 >/dev/null
echo

cd /mounted
time_install_pnpm
cd /local
time_install_pnpm

