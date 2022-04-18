
- [docs](jison_docs.html)

### 环境准备

```bash
# 安装Jison
npm init -y
npm -D i jison

# 根据规则生成JS文件
npx jison index.jison -o index.js

# 测试
node ./out/index.js ./input.txt
```
