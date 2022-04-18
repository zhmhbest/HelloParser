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
flex -o./out/index.c ./index.l
gcc ./out/index.c -o./out/index

REM RUN
.\out\index.exe