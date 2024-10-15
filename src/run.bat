@echo off
::echo Compiling LAPLAS.PAS
::call TURBOC.BAT LAPLAS.PAS
::echo Compiling MKESOL.PAS
::call TURBOC.BAT MKESOL.PAS
::echo Compiling MKEDROW.PAS
::call TURBOC.BAT MKEDROW.PAS

@echo off
rem LAPLAS.EXE tires\28-1-26.WIN
rem LAPLAS.EXE tires\33L-32FI34.WIN
rem LAPLAS.EXE tires\33L-32FI34M.WIN
LAPLAS.EXE tires\71x47-25.WIN
rem LAPLAS.EXE tires\79x59-26.WIN
rem LAPLAS.EXE tires\SER.WIN
rem LAPLAS.EXE tires\VED.WIN

echo Running MODEL.BAT with tires/71x47-25.WIN
call MODEL.BAT tires/71x47-25.WIN
