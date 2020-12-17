# [[ $str =~ RegExp ]]
if [[ `whereis x86_64-w64-mingw32-gcc.exe` =~ ^.+:\ .+$ ]]; then gcc=x86_64-w64-mingw32-gcc.exe; else gcc=gcc; fi

cd $(dirname $0)
if [ -d ./out ]; then rm -rf ./out; fi
mkdir ./out;

# ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

cp ./*.txt ./out
cp ./*.c ./out
cp ./*.h ./out

bison -dv -o./out/yacc.c ./index.y
flex -o./out/lex.c ./index.l
$gcc ./out/main.c ./out/yacc.c ./out/lex.c -I./out -o./out/index

# ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

cd ./out
./index
