UNIT AnalLapl;
INTERFACE
USES  Graph, PutScr, Config, FuncLoad,SplinUnt;
Const demen = 50;
Type
 Typek = 0..3;
 ScrPoint = ^TypeScr;
 TypeScr = Record g : RealType;
                  flag : Boolean
           end;
var
 Xscr, Yscr, SizeofScr   : integer;
 topl, topr, botl, botr, center : RealType;
 t : text;
 st : string;
 PtrScr : array[1..demen] of pointer;
Function AdScr(i,j:integer):ScrPoint;
PROCEDURE Linelab(Nf,K:byte); {K - к-во линий уровня}

IMPLEMENTATION
{----------------------------------------}
Function AdScr(i,j:integer):ScrPoint;
Begin
     AdScr := ptr(seg(PtrScr[j]^),ofs(PtrScr[j]^)+(ControlWidth+1+i)*SizeofScr)

End;
{-------------------------------------------------------}
Procedure Analis(k:typek;Cons:RealType; var i,j:integer);
label
     E, A0, A1, A2, A3;

Begin
 case k of
 0: GOTO A0;
 1: GOTO A1;
 2: GOTO A2;
 3: GOTO A3
 end;
A0:    j := j + 1;
      if (j = ControlUpset) or (not AdScr(i,j)^.flag) then GOTO E;
      AdScr(i,j)^.flag := false; {writeln(t,J:3,I:3,' 0 ');}
      botl := AdScr(i,j+1)^.g -Cons;
      botR := AdScr(i+1,j+1)^.g -Cons;
      topl := AdScr(i,j)^.g -Cons;
      topR := AdScr(i+1,j)^.g -Cons;
      if (topl*botl < 0) and (topr*botr > 0) then
       begin
        Xscr := lx + round(VectorX[i]*ratioX);
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topl/(topl-botl))*ratioX);
        LineTo(Xscr,Yscr); GOTO A3
       end;
      if (topl*botl > 0) and (topr*botr < 0) then
       begin
        Xscr := lx + round(VectorX[i+1]*ratioX);;
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topr/(topr-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A1
       end;
      if (topl*botl < 0) and (topr*botr < 0) then
       begin
        Center := (topl+topr+botr+botl)/4-Cons;
       if (topl*center < 0)  then   begin
        Xscr := lx + round(VectorX[i]*ratioX);;
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topl/(topl-botl))*ratioX);
        LineTo(Xscr,Yscr); GOTO A3 end else
        begin
        Xscr := lx + round(VectorX[i+1]*ratioX);;
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topr/(topr-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A1
       end end ;
        if botl*botr < 0 then begin
        Yscr := ly + round(VectorY[j+1]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*botl/(botl-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A0 end;
        GOTO E;
A1:   i := i + 1;
      if (i = ControlWidth) or (not AdScr(i,j)^.flag) then GOTO E;
      AdScr(i,j)^.flag := false;
      topr := AdScr(i+1,j)^.g -Cons; botr := AdScr(i+1,j+1)^.g -Cons;
      topl := AdScr(i,j)^.g -Cons;
      botl := AdScr(i,j+1)^.g -Cons;
      {writeln(t,J:3,I:3,' 1 ',topl:10:5,topr:10:5,botl:10:5,botr:10:5);}
      if (topl*topr > 0) and (botl*botr < 0) then
       begin
        Yscr := ly + round(VectorY[j+1]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*botl/(botl-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A0
       end;
      if (topl*topr < 0) and (botl*botr > 0) then
       begin
        Yscr := ly + round(VectorY[j]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*topl/(topl-topr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A2
       end;
      if (topl*topr < 0) and (botl*botr < 0) then
       begin
        Center := (topl+topr+botr+botl)/4-Cons;
       if (topl*center < 0)  then   begin
        Yscr := ly + round(VectorY[j]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*topl/(topl-topr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A2 end else
        begin
        Yscr := ly + round(VectorY[j+1]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*botl/(botl-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A0 end
       end;
        if topr*botr < 0 then
        begin
        Xscr := lx + round(VectorX[i+1]*ratioX);
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topr/(topr-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A1 end;
        GOTO E;
A2:     j := j-1;
      if (j+1 = 1) or (not AdScr(i,j)^.flag) then GOTO E;
      AdScr(i,j)^.flag := false;{writeln(t,J:3,I:3,' 2 ');}
      topl := AdScr(i,j)^.g -Cons;
      topr := AdScr(i+1,j)^.g -Cons;
      botr := AdScr(i+1,j+1)^.g -Cons;
      botl := AdScr(i,j+1)^.g -Cons;
      if (topl*botl < 0) and (topr*botr > 0) then
       begin
        Xscr := lx + round(VectorX[i]*ratioX);
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topl/(topl-botl))*ratioX);
        LineTo(Xscr,Yscr); GOTO A3
       end;
      if (topl*botl > 0) and (topr*botr < 0) then begin
        Xscr := lx + round(VectorX[i+1]*ratioX);
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topr/(topr-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A1
       end;
      if (topl*botl < 0) and (topr*botr < 0) then
       begin
        Center := (topl+topr+botr+botl)/4-Cons;
       if (botl*center < 0)  then   begin
        Xscr := lx + round(VectorX[i]*ratioX);
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topl/(topl-botl))*ratioX);
        LineTo(Xscr,Yscr); GOTO A3 end else
        begin
        Xscr := lx + round(VectorX[i+1]*ratioX);
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topr/(topr-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A1 end
       end;
        if topl*topr < 0 then
        begin
        Yscr := ly + round(VectorY[j]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*topl/(topl-topr))*ratioX);
        LineTo(Xscr,Yscr); GOTO A2 end;
        GOTO E;
A3:      i := i-1;
      if (i+1 =-ControlWidth) or (not AdScr(i,j)^.flag) then GOTO E;
      AdScr(i,j)^.flag := false; {writeln(t,J:3,I:3,' 3 ');}
      topl := AdScr(i,j)^.g -Cons;
      botl := AdScr(i,j+1)^.g -Cons;
      topr := AdScr(i+1,j)^.g -Cons;
      botr := AdScr(i+1,j+1)^.g -Cons;
      if (topl*topr > 0) and (botl*botr < 0) then
       begin
        Yscr := ly + round(VectorY[j+1]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*botl/(botl-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO  A0
       end;
      if (topl*topr < 0) and (botl*botr > 0) then
       begin
        Yscr := ly + round(VectorY[j]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*topl/(topl-topr))*ratioX);
        LineTo(Xscr,Yscr); GOTO  A2
       end;
      if (topl*topr < 0) and (botl*botr < 0) then
       begin
        Center := (topl+topr+botr+botl)/4-Cons;
       if (topr*center < 0)  then   begin
        Yscr := ly + round(VectorY[j+1]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*topl/(topl-topr))*ratioX);
        LineTo(Xscr,Yscr); GOTO  A2 end else
        begin
        Yscr := ly + round(VectorY[j+1]*ratioX);
        Xscr := lx +
        round((VectorX[i]+(VectorX[i+1]-VectorX[i])*botl/(botl-botr))*ratioX);
        LineTo(Xscr,Yscr); GOTO  A0 end
       end;
        if topl*botl < 0 then
        begin
        Xscr := lx + round(VectorX[i]*ratioX);
        Yscr := ly +
        round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topl/(topl-botl))*ratioX);
        LineTo(Xscr,Yscr); GOTO A3 end;
E:      begin end;
end;{analis}
{-----------------------------------------}
PROCEDURE Linelab; {K - к-во линий уровня}
var
i,j,s, ibuf, jbuf, icik : integer;
XF,YF,Cons,Glmin,Glmax,h:RealType;
f : funC;
X,Y,B,C,D :RealTypeArray;
{-----------------------------------------}
Procedure drow;{указание значения изолинии}
Label B;
var
  st       : string;
  icik,i,j :integer;
Begin
  SetTextJustify(0,0);
  SetColor(Red);
   icik := 0;
   while icik < k do begin
B: icik := Icik + 1;
   Cons := Glmin  + h*icik;
   for j := ControlUpset downto 2   do begin
    for i := -ControlWidth to ControlWidth-1 do begin
      TopL := AdScr(i,j-1)^.g-Cons;
      botR := AdScr(i+1,j)^.g-Cons;
      Botl := AdScr(i,j)^.g-Cons;
       if TopL*BotL < 0 then begin
                 Xscr := lx + round(VectorX[i]*ratioX);
                 Yscr := ly +
                 round((VectorY[j-1]+(VectorY[j]-VectorY[j-1])*topl/(topl-botl))*ratioX);
                 MoveTo(Xscr,Yscr);
                 Str(Cons:4:2,st);
                 OutText(st);
                 GOTO B
                 end;
      if botL*botR < 0 then begin
          Yscr := ly + round(VectorY[j]*ratioX);
          Xscr := lx +
          round((VectorX[i]+(VectorX[i+1]-VectorX[i])*botl/(botl-botr))*ratioX);
          MoveTo(Xscr,Yscr);
          Str(Cons:4:2,st);
          OutText(st);
          GOTO B
       end else begin end

   end; end;
    end;{icik }
SetColor(Green)
end{drow};
{--------Linelab----------}
Begin
  {nul}
  for j := 1 to ControlUpset do
     for i := -ControlWidth to ControlWidth do
     begin AdScr(i,j)^.g := 0;
           AdScr(i,j)^.flag := true
     end;
  Glmin := 1.e+6;
  Glmax := -1.e+6;
  Case Nf of
        0: f := GX;
        1: f := GZ;
        2: f := TetaMax;
       10: f := GXo;
       11: f := GZo;
       12: f := Po;
      {13: f := dat;}
       else halt;
  end;
  for j := ControlUpset downto 1 do begin
  for i := -ControlWidth to ControlWidth do begin
   Xf := VectorX[i];
   Yf := VectorY[j];
   AdScr(i,j)^.g := f(XF,YF);
                                             end
                                    end;
  for j := 1 to ControlUpset do begin
  for i := -ControlWidth to ControlWidth do begin
   {
   write(t,AdScr(i,j)^.g:6:3);
   }
   if AdScr(i,j)^.g  < Glmin  then Glmin := AdScr(i,j)^.g
   else
       if AdScr(i,j)^.g  > Glmax then Glmax := AdScr(i,j)^.g
       else begin end;
                                             end;
                                 {writeln(t);}
                                 end;
   {close(t);}
   h:= (Glmax - Glmin)/k;
   icik := 0;
   while icik < k do begin
   icik := icik + 1;
   Cons := Glmin  + h*icik;
   for j := ControlUpset downto 1 do
   for i := -ControlWidth to ControlWidth do

      AdScr(i,j)^.flag := true;
   j := 1;
   for i := -ControlWidth to ControlWidth-1 do begin
     if AdScr(i,j)^.flag then begin
      TopL := AdScr(i,j)^.g-Cons;
      TopR := AdScr(i+1,j)^.g-Cons;
      if TopL*TopR < 0 then begin
          ibuf := i; jbuf := j;
          Yscr := ly + round(VectorY[j]*ratioX); ;
          Xscr := lx +
          round((VectorX[i]+(VectorX[i+1]-VectorX[i])*topl/(topl-topr))*ratioX);
          MoveTo(Xscr,Yscr); j := J-1;
          Analis(0,Cons,i,j);
          i := ibuf; j := jbuf; {AdScr(i,j)^.flag:= true;}
          {writeln(t,'jbuf=',jbuf:3,' ibuf=',ibuf:3);}
       end else begin end
    end {AdScr(i,j)^.flag} else begin end; end;
    for j := ControlUpset downto 2 do begin
     for i := -ControlWidth to ControlWidth-1 do begin

     if AdScr(i,j)^.flag then begin
      TopL := AdScr(i,j-1)^.g-Cons;
      TopR := AdScr(i+1,j-1)^.g-Cons;
      botR := AdScr(i+1,j)^.g-Cons;
      Botl := AdScr(i,j)^.g-Cons;
       if TopL*BotL < 0 then begin
                 {writeln(t,j:3,i:3,'topL*botL < 0',TopL:10:5,BotL:10:5);}
                 ibuf := i; jbuf := j;
                 Xscr := lx + round(VectorX[i]*ratioX);
                 Yscr := ly +
                 round((VectorY[j-1]+(VectorY[j]-VectorY[j-1])*topl/(topl-botl))*ratioX);
                 MoveTo(Xscr,Yscr);i := i-1; j := j-1;
                 Analis(1,Cons,i,j);
                 i := ibuf; j := jbuf; {AdScr(i,j)^.flag:= true;}
                 {writeln(t,'jbuf=',jbuf:3,' ibuf=',ibuf:3);}
                 end;
      if botL*botR < 0 then begin
     {writeln(t,j:3,i:3,'botL*botR < 0',botL:10:5,botR:10:5);}
          ibuf := i; jbuf := j;
          Yscr := ly + round(VectorY[j]*ratioX);
          Xscr := lx +
          round((VectorX[i]+(VectorX[i+1]-VectorX[i])*botl/(botl-botr))*ratioX);
          MoveTo(Xscr,Yscr);
          Analis(2,Cons,i,j);
          i := ibuf; j := jbuf; {AdScr(i,j)^.flag:= true;}
          {writeln(t,'jbuf=',jbuf:3,' ibuf=',ibuf:3);}
         end else begin end;
     if TopR*botR < 0 then begin
     {writeln(t,j:3,i:3,'TopR*botR < 0',TopR:10:5,botR:10:5);}
          ibuf := i; jbuf := j; i := i+1; j := j-1;
          Xscr := lx + round(VectorX[i]*ratioX);
          Yscr := ly +
          round((VectorY[j]+(VectorY[j+1]-VectorY[j])*topr/(topr-botr))*ratioX);
          MoveTo(Xscr,Yscr);
          Analis(3,Cons,i,j);
          i := ibuf; j := jbuf; {AdScr(i,j)^.flag:= true;}

       end else begin end;
    end {AdScr(i,j)^.flag} else begin end;

   end; end;
    end;{icik }
 drow;
 end;{LineLab}

end.