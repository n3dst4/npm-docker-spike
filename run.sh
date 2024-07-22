#! /bin/bash

rel_dir=$(dirname $0)
directory=$(realpath $rel_dir)
tmp=tmp
src=src

cd $directory
rm -rf ${tmp}
cp -a $src $tmp
docker run -it --volume=${directory}/${tmp}:/mounted node:18 /mounted/run_tests.sh
