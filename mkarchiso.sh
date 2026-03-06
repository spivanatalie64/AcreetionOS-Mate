export PACMAN_OPTS="--overwrite '*'"
./mkarchiso -L AcreetionOS -v -o ../ISO . -C ./pacman.conf -j $(nproc)
