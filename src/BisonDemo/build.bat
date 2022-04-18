@ECHO OFF
SET PATH=%CD%\env\bin;%PATH%
CD /D %~dp0
IF EXIST out (
    RMDIR /s /q out
    MKDIR out
) ELSE (
    MKDIR out
)

REM BUILD
copy *.txt out
copy *.c out
copy *.h out

REM -d 生成.h
REM -v 生成.output
bison -dv -o./out/yacc.c ./index.y

flex -o./out/lex.c ./index.l

pushd out
gcc main.c yacc.c lex.c ast.c -I. -oindex
index.exe
popd
