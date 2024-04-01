TASM cmp.asm
TLINK cmp
TASM v1.asm
TLINK v1
echo Testing...
echo.>test.res
echo === test1 ===>>test.res
%1 aa < V1TEST1.IN >>test.res

fc /b test.res v1test.ok
