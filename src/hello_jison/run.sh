cd $(dirname $0)

if [ ! -d ./node_modules/jison ]; then
    npm init -f
    npm -D i jison
fi

if [ -d ./out ]; then rm -rf ./out; fi
mkdir ./out;

# ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

npx jison index.jison -o ./out/index.js
node ./out/index.js ./input.txt
