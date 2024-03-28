@ECHO OFF
TASM cmp.asm
TLINK cmp
echo Testing...
echo.>test.res
echo === test1 ===>>test.res
%1 >>test.res

fc /b test.res v1test.ok
