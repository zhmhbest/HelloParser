# [[ $str =~ RegExp ]]
if [[ `whereis x86_64-w64-mingw32-gcc.exe` =~ ^.+:\ .+$ ]]; then gcc=x86_64-w64-mingw32-gcc.exe; else gcc=gcc; fi

cd $(dirname $0)
if [ -d ./out ]; then rm -rf ./out; fi
mkdir ./out;

# ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

cp ./*.txt ./out
flex -o./out/index.c ./index.l
$gcc ./out/index.c -o./out/index

# ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

cd ./out
./index
