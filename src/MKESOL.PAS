Program MKESol;
Uses Config, LDL, UNCode, PutScr, Crt, SplinUnt,Graph;
Const
      outputarh = 'OutPut.MKE';
      mas = 1;
Var data : text;
    OutArh : file of RealType;
    ClrKey : char;
    i,j,k: integer;
    st : string;
    

{-------------------------------------}
Procedure Getdata; {Задаем матрицу а}
Type Ker = array[1..2,1..2] of RealType;
     TypeKL = array[1..3,1..3] of Ker;
var
i,j,s,t,jcont : integer;
KL : TypeKL;
{-----------------}
Procedure Reindex;
Var l,k,demind : integer;
{------------------------}
Procedure Move(s:integer);
var l,k : integer;
Begin for k := s+1 to s+m do
          begin PutR(k-1,0,0);
                for l := 1 to m+s-k do  PutR(k-1,l,GetR(k,l-1))
          end;
      for l := m downto 0 do
          for k := m-l+s+1 to demind do PutR(k-1,l,GetR(k,l));
      dec(demind)
End;{Move}
Begin {Reindex}
      demind := dem-2*m1;
      for l := 1 to n2 do
          begin k := 1+(m1-2)*(l-1);
                Move(2*k-1);
                Move(2*k-1);
                k := k+m1-2;
                Move(2*k-1);
                Move(2*k-1)
          end
End{Reindex};
{--------------------}

Procedure PutBlock;
Var k : 1..4;
    l, savedi, savedj : integer;
{-----------------------------------}

Procedure PutKL(var KL:TypeKL);{задаем лок. м-цу жестк.}
var


 Nu, alfa, d11, d12, d21, d22, d33, ksi  : RealType;

{-------------------------------------------------}
Procedure PutEL(a1,a2,a3,a4:RealType; var Z : Ker);
Begin
 Z[1,1] := a1*alfa;
 Z[1,2] := a2*alfa;
 Z[2,1] := a3*alfa;
 Z[2,2] := a4*alfa
end;{PutEL}
{--------------}
Begin {PutKL}
 Nu := Grunt[s].Nu;
 ksi := 4*amax*this^.b/(Grunt[s].h*thisGr[s]^.b);
 alfa := Grunt[s].E/(1-Nu*Nu)/2;
 d11 := 1; d12 := Nu;
 d21 := Nu; d22 := 1; d33 := (1-Nu)/2;
 if (k = 1) or (k = 2) then
begin
 PutEL( d33*ksi,            0,
                  0,  d22*ksi,KL[1,1]);

 PutEL(-d33*ksi,-d33,
       -d21, -d22*ksi,KL[1,2]);

 PutEL(0,              d33,
       d21,            0,KL[1,3]);

 PutEL(-d33*ksi, -d12,
       -d33, -d22*ksi,KL[2,1]);

 PutEL(d11/ksi+d33*ksi,  (d12+d33),
      (d21+d33), d22*ksi+d33/ksi,  KL[2,2]);

 PutEL(-d11/ksi, -d33,
       -d21, -d33/ksi,KL[2,3]);

 PutEL(0,              d12,
        d33,            0,KL[3,1]);

 PutEL(-d11/ksi, -d12,
       -d33, -d33/ksi,KL[3,2]);

 PutEL( d11/ksi,            0,
                  0,  d33/ksi,KL[3,3])
end
else
begin

 PutEL(d11/ksi+d33*ksi,  -(d12+d33),
      -(d21+d33), d22*ksi+d33/ksi,  KL[1,1]);

 PutEL(-d33*ksi, d12,
       d33, -d22*ksi,KL[1,2]);

 PutEL(-d11/ksi, d33,
       d21, -d33/ksi,KL[1,3]);

 PutEL(-d33*ksi, d33,
        d21, -d22*ksi,KL[2,1]);

 PutEL( d33*ksi,            0,
                  0,  d22*ksi,KL[2,2]);

 PutEL(0,             -d33,
        -d21,            0,KL[2,3]);

 PutEL(-d11/ksi, d12,
       d33, -d33/ksi,KL[3,1]);

 PutEL(0,             -d12,
        -d33,            0,KL[3,2]);

 PutEL( d11/ksi,            0,
                  0,  d33/ksi,KL[3,3])
end
end;{PutKL}
{--------------------------}
Procedure PutLine;
{-------------------------------------------------------}
Procedure PutKer(s,t:integer;var Kr:Ker);
Begin {PutKer}
      PutR(2*s-1,m-2*(s-t),Kr[1,1]+GetR(2*s-1,m-2*(s-t)));
      if s = t then begin end else PutR(2*s-1,m-2*(s-t)+1,Kr[1,2]+GetR(2*s-1,m-2*(s-t)+1));
      PutR(2*s,m-2*(s-t)-1,Kr[2,1]+GetR(2*s,m-2*(s-t)-1));
      PutR(2*s,m-2*(s-t),Kr[2,2]+GetR(2*s,m-2*(s-t)))
end {PutKer};
{--------------}
Begin {PutLine}

     case k of
          1: begin
                  PutKer(j,j,KL[1,1]);
                  PutKer(i,i,KL[2,2]);
                  PutKer(i+1,i+1,KL[3,3]);
                  PutKer(j,i,KL[1,2]);
                  PutKer(j,i+1,KL[1,3]);
                  PutKer(i+1,i,KL[3,2])
             end;
          2: begin
                  PutKer(i+1,i+1,KL[1,1]);
                  PutKer(j+1,j+1,KL[2,2]);
                  PutKer(j,j,KL[3,3]);
                  PutKer(j+1,i+1,KL[2,1]);
                  PutKer(j+1,j,KL[2,3]);
                  PutKer(j,i+1,KL[3,1])
             end;
          3: begin
                  PutKer(j,j,KL[1,1]);
                  PutKer(i,i,KL[2,2]);
                  PutKer(j+1,j+1,KL[3,3]);
                  PutKer(j,i,KL[1,2]);
                  PutKer(j+1,j  ,KL[3,1]);
                  PutKer(j+1,i,KL[3,2]);
             end;
          4: begin
                  PutKer(i+1,i+1,KL[1,1]);
                  PutKer(j+1,j+1,KL[2,2]);
                  PutKer(i,i,KL[3,3]);
                  PutKer(i+1,i  ,KL[1,3]);
                  PutKer(j+1,i+1,KL[2,1]);
                  PutKer(j+1,i,KL[2,3])
             end;
     end; {case k of }
end{PutLine};
{---------------}
Begin {PutBlock}
  inc(jcont);
  savedi := Lgor+1 + m1*(Jcont-1);
  savedj := savedi + m1;
  if Odd(Jcont) then k := 4 else k := 2;
  this := beg;
  i := savedi;
  j := savedj;
   while this <> nil do
   begin
    for l := 1 to this^.a do
                            begin
                                  if k = 4 then k := 1 else inc(k);
                                  PutKL(KL);
                                  PutLine;
                                  if k = 4 then k := 1 else inc(k);
                                  PutLine;
                                  inc(i);
                                  inc(j)
                            end;
    this := this^.tail
   end;
  if Odd(Jcont) then k := 2 else k := 4;
  this := beg;
  i := savedi-1;
  j := savedj-1;
   while this <> nil do
   begin
    for l := 1 to this^.a do
                            begin
                                  if k = 4 then k := 1 else inc(k);
                                  PutKL(KL);
                                  PutLine;
                                  if k = 4 then k := 1 else inc(k);
                                  PutLine;
                                  dec(i);
                                  dec(j);
                            end;
    this := this^.tail
   end;

end;{PutBlock}
{----------------------------}
Begin {Getdata}
 SizeofReal := Sizeof(RealType);
 for i := 0 to m do GetMem(PtrStr[i],dem*SizeofReal);
 {обнуление}
 for i := 1 to dem do
     for j := 0 to m do PutR(i,j,0);
Jcont := 0;
for s := 1 to LGr do
    begin
         thisGr[s] := begGr[s];
         while thisGr[s] <> nil do
         begin
              for t := 1 to thisGr[s]^.a do Putblock;
              thisGr[s] := thisGr[s]^.tail
         end
    end;
Reindex;
end;{GetData}
{--------------------------------------}
Procedure GetSpline; {Задаем матрицу b}
var
 j : byte;
 i,LeftPoint,RightPoint : integer;
 Ff,ArP : Array[-10..10] of RealType;
{--------------------}
Begin {GetSpline}
 {обнуление}
 for i := 1 to dem do
     for j := 1 to r do bLDL[i,j] := 0;


       Setka(mas);
       PutSpline(N,X,Y,B,C,D);
       LeftPoint := 0;
        Repeat
              LeftPoint := pred(LeftPoint)
        Until VectorX[LeftPoint] <= X[1];
        RightPoint := 0;
        Repeat
              RightPoint := succ(RightPoint)
        Until VectorX[RightPoint] >= X[N];
        for i := LeftPoint to RightPoint do
        begin Ff[i] := 0;
              ArP[i] := Seval(N,midpoint,VectorX[i],X,Y,B,C,D)
        end;
        for i := LeftPoint to pred(RightPoint) do
        begin
             Ff[succ(i)] := 1/4*(ArP[i]+ArP[i+1])*(VectorX[i+1]-VectorX[i]);
             Ff[i] := Ff[i]+Ff[i+1]
        end;
       for i := LeftPoint to RightPoint do bLDL[2*(Lgor+i),r] := Ff[i];
       SetColor(white);
       SetTextJustify(Lefttext,toptext);
       Str(2*m1*m2:4,st);
       OutTextXY(0,15,' dem = '+st);
       Str(2*(m1+1)+1:4,st);
       OutTextXY(0,25,' m   = '+st);
       Repeat
             delay(100)
       Until KeyPressed;
       ClrKey := ReadKey;
       if ord(ClrKey) = 27 then begin closegraph;halt end;
       CloseGraph;
       CursorOff;
       if 2*m1*m2 <> dem then
         begin writeln(' Set dem = ',2*m1*m2:4,' in module LDL.PAS');
               writeln(' Set m = ',2*(m1+1)+1:4,' in module LDL.PAS');
               Repeat delay(100)
               Until KeyPressed;
               ClrKey := ReadKey;
               CursorOn;
               halt
         end;
       if 2*(m1+1)+1 <> m then
         begin writeln(' Set m = ',2*(m1+1)+1:4,' in module LDL.PAS');
               Repeat delay(100)
               Until KeyPressed;
               ClrKey := ReadKey;
               CursorOn;
               halt
         end;
       Writeln('          PROCESSING ...');
 end;{GetSpline}
{--------------------}
Procedure SoundDemo;
Const f : array[1..13] of word =
          (330, 349, 370, 392, 415, 440,
           466, 494, 523, 554, 588, 622, 660);
Var i,j :byte;
Begin for j := 1 to 2 do
          for i := 1 to 13 do
              begin sound(j*f[i]);
                    delay(100);
                    nosound
              end;
       if KeyPressed Then exit;
       for j := 1 to 2 do
          for i := 13 downto 1 do
              begin sound(j*f[i]);
                    delay(100);
                    nosound
              end;
end;
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
      N := 0;
       while not eoln(data) do
       begin N := N+1;
             read(data,X[N])
       end;
       readln(data);
       for j := 1 to N do read(data,Y[j]);
      readln(data);
      readln(data,GorizCode);
      Lgr := 0;
      repeat Lgr := succ(Lgr);
             readln(data,Grunt[Lgr].h,Grunt[Lgr].E,Grunt[Lgr].Nu);
             readln(data,Grunt[Lgr].Code)
      until eof(data);
      {инициализация разбиения}
       Lgor := 0;
       UnCoding(GorizCode,this,last,Beg,Lgor,ErCode);
       if ErCode <> 0 then halt;
       m1 := 2*Lgor+1;
       n1 := m1-2;
       Resort(GorizCode,this,last,Beg);
       n2 := 0;
       for j := 1 to LGr do
       begin Lver[j] := 0;
             UnCoding(Grunt[j].Code,thisGr[j],lastGr[j],BegGr[j],Lver[j],ErCode);
             if ErCode <> 0 then halt;
             n2 := n2+Lver[j];
             Resort(Grunt[j].Code,thisGr[j],lastGr[j],BegGr[j]);
       end;
       m2 := n2+1;
       GetSpline;

assign(OutArh,OutPutArh);
rewrite(OutArh);
{
assign(t,'rat');
rewrite(t);
}
GetData;
{
for j := 1 to dem do
     begin  for k := 0 to m do write(t,GetR(j,k):8:2);
           writeln(t)
     end;
close(t);
}
chobanddet(2*n1*n2,m);
{
for j := 1 to 2*n1*n2 do
     begin  for k := 0 to m do write(t,GetR(j,k):8:2);
           writeln(t)
     end;
close(t);
}
chobandsol(2*n1*n2,m,r,bldl,bldl);
for i := 1 to 2*n1*n2 do write(OutArh,bldl[i,1]);
{
for j := 1 to n2 do
    begin for i := 1 to n1 do
              begin k := i+(j-1)*n1;
                    write(t,bldl[2*k-1,1]:8:3)
              end;
          writeln(t)
    end;
close(t);
}
Close(OutArh);
ClrScr;
Writeln('          DONE');
{Repeat
delay(100);}
  {SoundDemo}
{Until Keypressed;
ClrKey := ReadKey;
CursorOn;}
end.


