Program LAPLAS;{определение начальных напряжений в однородной среде}
Uses Config, UNCode, PutScr, Crt, AnalLapl, Graph, FuncLoad;
Const
      mas = 1;
Var data : text;
    ClrKey : char;
    i,j,Nf,m1,m2: integer;
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
      OpenGraph;
      GetSpline;
      readln(data,GorizCode);
      Lgr := 0;
      repeat Lgr := succ(Lgr);
             readln(data,Grunt[Lgr].h,Grunt[Lgr].E,Grunt[Lgr].Nu,
             Grunt[Lgr].C,Grunt[Lgr].Fi);
             readln(data,Grunt[Lgr].Code);
             Grunt[Lgr].Fi := Grunt[Lgr].Fi*pi/180
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
       SetColor(Yellow);
       SetTextJustify(Lefttext,toptext);
       Str(Qmean:5:3,st);
       {OutTextXY(0,40,' q  = '+st+' kg/cm^2');}
       Repeat
             delay(100)
       Until KeyPressed;
       ClrKey := ReadKey;
       if ord(ClrKey) = 27 then begin closegraph;halt end;
close(data);
 SizeofScr := Sizeof(TypeScr);
 for i := 1 to m2-1 do GetMem(PtrScr[i],(2*ControlWidth+1)*SizeofScr);

{
 ----------------Таблица кодировки---------------
       Nf                  function
 ------------------------------------------------
     Аналитическое решение в изотропной среде
       0                  SigmaX
       1                  SigmaZ
       2                  TetaMax
      10                  SigmaXo
      11                  SigmaZo
      12                  Po
      13                  datchik
 --------------------------------------------------
}
setlinestyle(0,0,NormWidth);
setwritemode(0);
SETcolor(Green);
Linelab(1,20);
Repeat
       delay(100)
until KeyPressed;
ClrKey := ReadKey;
CloseGraph;
end.
