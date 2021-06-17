
# gccpy

Scripts to compile with latest gcc on older systems using udocker

## Quick start

To compile your code with gcc 11, if your code is in ```<path to app>```

```sh

git clone https://github.com/yuvalyehudab/gccpy.git
bash gccpy/compile.sh <path to app>

```

For example, thinking of git submodules, you can do it from your repo:

```sh

cd /vol/scratch/`whoami`/projects/hw2

git clone https://github.com/yuvalyehudab/gccpy.git
bash gccpy/compile.sh .

```

Yes, it is that simple... Good Luck!
