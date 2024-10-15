Program MKEDROW;
Uses Config, UNCode, PutScr, Crt, Sigma, Anal, Graph;
Const
      inputarh = 'OutPut.MKE';
      mas = 1;
Var data : text;
    Arh: file of REALType ;
    ClrKey : char;
    i,j,Nf: integer;
    Po : RealType;
{--------------------------------------------}
Procedure Getdata; {Задаем матрицу перемещений}
var
 i,j : integer;
{--------------------}
Begin {Getdata}
 SizeofType := Sizeof(TypeRecord);
 for i := 1 to m2 do GetMem(PtrStr[i],m1*SizeofType);
 {обнуление}
 for i := 1 to m2 do
     for j := 1 to m1 do begin
                            with AddrR(i,j)^ do
                                               begin
                                                    U := 0;
                                                    V := 0;
                                                    SigmaX := 0;
                                                    SigmaZ := 0;
                                                    Tau := 0;
                                               end
                            end;

for i := 1 to m2-1 do
     FOR j := 2 to m1-1 do
      Read(arh,AddrR(i,j)^.U,AddrR(i,j)^.V);

end;{GetData}
{----------------------------------}
Procedure GetSpline; {Строим сплайн}
Var
   j : byte;
   st : string;
Begin {GetSpline}

       N := 0;
       while not eoln(data) do
       begin N := N+1;
             read(data,X[N])
       end;
       readln(data);
       for j := 1 to N do read(data,Y[j]);
       readln(data);
 end;{GetSpline}

{--------------------}
Begin
       assign(data,paramstr(1));
       {$I-}
       reset(data);
       {$I+}
       if IOResult <> 0 then
       begin write(' Not founded file '+paramstr(1));
             halt
       end;
       assign(arh,inputarh);
      {$I-}
      reset(arh);
      {$I+}
      if IOResult <> 0 then
      begin write(' Not founded file '+ inputarh);
            halt
      end;
      OpenGraph;
      GetSpline;
      readln(data,GorizCode);
      Lgr := 0;
      repeat Lgr := succ(Lgr);
             readln(data,Grunt[Lgr].h,Grunt[Lgr].E,Grunt[Lgr].Nu,
             Grunt[Lgr].C,Grunt[Lgr].Fi);
             readln(data,Grunt[Lgr].Code)
      until eof(data);
      {инициализация разбиения}
       Lgor := 0;
       UnCoding(GorizCode,this,last,Beg,Lgor,ErCode);
       m1 := 2*lgor+1;
       if ErCode <> 0 then halt;
       Resort(GorizCode,this,last,Beg);
       m2 := 1;
       for j := 1 to LGr do
       begin Lver[j] := 0;
             UnCoding(Grunt[j].Code,thisGr[j],lastGr[j],BegGr[j],Lver[j],ErCode);
             if ErCode <> 0 then halt;
             m2 := m2+lver[j];
             Resort(Grunt[j].Code,thisGr[j],lastGr[j],BegGr[j]);
       end;
       Setka(mas);
       PutSpline(N,X,Y,B,C,D);
       SetColor(White);
       SetTextJustify(Lefttext,toptext);
       OutTextXY(0,15, ' ' + paramstr(1));
       {Str(Qmean:5:3,st);
       OutTextXY(0,40,' qcp = '+st+' kg/cm');}
       {Repeat
             delay(100)
       Until KeyPressed;
       ClrKey := ReadKey;
       if ord(ClrKey) = 27 then begin closegraph;halt end;}
 close(data);
 SizeofScr := Sizeof(TypeScr);
 for i := 1 to m2-1 do GetMem(PtrScr[i],(2*ControlWidth+1)*SizeofScr);
GetData;
{
assign(t,'ratmove');
rewrite(t);
for i := 1 to m2 do
     begin
          FOR j := 1 to m1 do
          Write(t,AddrR(i,j)^.U:6:2);
          writeln(t)
     end;
close(t);
}
PutSigma;
{
assign(t,'rat');
rewrite(t);
for i := 1 to m2 do
                    BEGIN
                              FOR j := 1 to m1 do
                                  Write(t,AddrR(i,j)^.SigmaZ:6:3);
                                  writeln(t)
                    end;
close(t);
 }
{ начальные значения для решения задачи теплопроводности
assign(outArh,outPutArh);
rewrite(outArh);
for i := 1 to m2 do
    FOR j := 1 to m1 do
        begin Po := (abs(AddrR(i,j)^.SigmaX) + abs(AddrR(i,j)^.SigmaZ))/2;
              Write(outArh,Po)
        end;
close(outArh);
}
 SizeofScr := Sizeof(TypeScr);
 for i := 1 to m2-1 do GetMem(PtrScr[i],(2*ControlWidth+1)*SizeofScr);

{
 ----------------Таблица кодировки---------------
       Nf                  function
 ------------------------------------------------
    a) Метод конечных элементов
       0                  SigmaX
       1                  SigmaZ
       2                  Tau
       3                  SigmaXo
       4                  SigmaZo
       5                  Po
       6                  V - вертик. перемещения
       7                  arcsin(teta) - макс. угол отклонения в-ра напряжений
    b) Аналитическое решение в изотропной среде
      10                  SigmaXo
      11                  SigmaZo
      12                  Po
 --------------------------------------------------
}
setlinestyle(0,0,NormWidth);
setwritemode(0);
{SETcolor(Green);
Linelab(11,15);}
SETcolor(Red);
Linelab(4,20);
Repeat
       delay(100)
until KeyPressed;
ClrKey := ReadKey;
close(Arh);
CloseGraph;
end.


