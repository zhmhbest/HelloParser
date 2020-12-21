cd $(dirname $0)
if [ -d ./out ]; then rm -rf ./out; fi
mkdir ./out;

# ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

npx jison calculator.jison -o ./out/index.js
node ./out/index.js ./input.txt
