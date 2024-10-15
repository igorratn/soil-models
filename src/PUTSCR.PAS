UNIT PutScr;{ построение экрана}
INTERFACE
Uses GRAPH, UnCode, SplinUnt, DOS, Config;

Const
     qmax = 1.0;
     amax = 75.0;
     Nmax = 3; {максимальное к-во слоев}
     NSplMax = 5; {макс. max к-во узлов интерполяции, N>1, N <> 3}
     midpoint :byte = 2;
     EqealFlag :boolean = false;
     UnEqealFlag : boolean = true;
Type

     plast = record
              h, E, Nu, C, Fi : RealType;
              code : string
             end;

Var
     N : byte;
     X,Y,B,C,D : RealTypeArray;
     Waria :RealType;
     thisGr,lastGr,BegGr : array[1..Nmax] of linkCodetrans;
     this,last,Beg :  linkCodetrans;
     Lgr, Lgor : byte;
     Lver : array[1..Nmax] of byte;
     lx,ly,ControlUpset, ControlWidth,ErCode,MaxY : integer;
     ratioX,ratioY,Qmean : RealType;
     VectorX : array[-30..30] of RealType;
     VectorY : array[0..35] of RealType;
     GorizCode : string ;
     Grunt : array[1..Nmax] of plast;
Procedure Setka(mas:byte);   {построение координатной сетки}
Procedure PutSpline(N:byte; var X,Y,B,C,D : RealTypeArray);{построение сплайна}
Procedure OpenGraph;
Procedure CursorOn;
Procedure CursorOff;
IMPLEMENTATION
Const
     delX = 10;
     delY = 10;
     TitleX = 'cm';
     TitleH = 'cm';
     TitleY = 'kg/cm^2';
     Scrip  = 'Ratner,92';
     EqealColor = Cyan;
     UnEqealColor = Cyan;
var r : registers;
    dx,dy : integer;
    st : string;
Procedure CursorOn;
begin
 with r do
  begin
   AH := 1;
   CH := 6;
   CL := 7
  end;
  Intr($10,r)
END;
{-----------------------}
Procedure CursorOff;
begin
 with r do
  begin
   AH := 1;
   CH := $20;
  end;
  Intr($10,r)
END;
Procedure OpenGraph;
var Driver, Regim, Error : integer;
begin
   driver := Detect;
   InitGraph(Driver, Regim, '');
   Error := Graphresult;
   if error <> grOK then
   begin writeln(GrapherrorMsg(Error));
         halt
   end
end;
Function Simpson(As,Bs:RealType):RealType;
Const
  Ns = 5;
var
  H, I, xvar : RealType;
  k : integer;
Begin
  H := ((Bs-As)/Ns)/2;
  I:= Seval(N,midpoint,As, X, Y, B, C, D);
  for k:= 1 to 2*Ns-1 do
   begin
   xvar := As+k*H; {writeln('xvar=',xvar:10:5);readln;}
   if odd(k) then
    I := I + 4*Seval(N,midpoint,xvar, X, Y, B, C, D)
   else
    I := I + 2*Seval(N,midpoint,xvar, X, Y, B, C, D)
   end;
  Simpson := (I + Seval(N,midpoint,Bs, X, Y, B, C, D))*H/3
end;
Procedure Setka; {построение координатной сетки}

Var
     a,h,curs : RealType;
     k,j,i,NX,M,DXF:integer;
     Test : boolean;

Begin

   {--------------------}
      lx := GetmaxX div 2;
      ly := GetmaxY div 7;
      ratioY := ly*0.9/qmax;
      ratioX := lx*0.98/mas/amax;
      dx := round(amax/delX*ratioX);
      dy := round(qmax/delY*ratioY);
      DXF := round(amax*ratioX/5);
      NX := trunc(lx/DXF);
      M := trunc((GetmaxY - ly)/DXF);
      Cleardevice;
      setwritemode(0);
      setbkColor(Black);

      if EqealFlag then begin
       {Р а в н о м е р н а я   с е т к а}
       SetColor(EqealColor);
       {вертикальная сетка в нижней полуплоскости}
       for i := -NX to NX do
        begin
        Moveto(lx+DXF*i,ly);
        lineREL(0,GetMaxY)
       end;
       {горизонтальная сетка в нижней полуплоскости}
       for i := 1 to M do
        begin
        Moveto(0,ly+DXF*i);
        lineREL(GetMaxX,0)
       end;
      end else begin end;
      {н е р а в н о м е р н а я    с е т к а}
       SetColor(UnEqealColor);
    curs := 0;
    k := 0;
    for j := 1 to LGr do
    begin
         h := 0.01*Grunt[j].h;
         thisGr[j] := BegGr[j];
      while (thisGr[j] <> nil) do
       begin
         Test := (curs + h*thisGr[j]^.a*thisGr[j]^.b) < (GetMaxY-ly)/ratioX;
        if Test then
         begin
          for i := 1 to thisGr[j]^.a do
           begin
            curs := curs + h*thisGr[j]^.b;
            k := k+1;
            VectorY[k] := curs;
            if UnEqealFlag then begin
            Moveto(0,ly+round(curs*ratioX));
            lineREL(GetMaxX,0); end
            else begin end;
           end;
          ControlUpset := k;
          thisGr[j] := thisGr[j]^.tail
         end
         else
         begin
         curs := curs + h*thisGr[j]^.b;
         Test := curs < (GetMaxY-ly)/ratioX;
         while Test do
          begin
            k := k+1;
            VectorY[k] := curs;
            if UnEqealFlag then begin
            Moveto(0,ly+round(curs*ratioX));
            lineREL(GetMaxX,0); end
            else begin end;
            curs := curs + h*thisGr[j]^.b;
            Test := curs < (GetMaxY-ly)/ratioX;
           end;
           k := k+1;
           VectorY[k] := (GetMaxY-ly)/ratioX;
           ControlUpset := k;
           VectorY[k+1] := curs;
           thisGr[j] := nil
          end
        end;{thisGr[j] <> nil}
   end;
       MaxY := round(VectorY[k]*ratioX)+ly;
       curs := 0;
       k := 0;
       VectorX[k] := curs;
       if UnEqealFlag then begin
       Moveto(lx,ly);
       lineREL(0,MaxY-ly); end
       else begin end;
       Waria := 2*amax;
       h := 0.01*Waria;
       this := beg;
      while (this <> nil) do
       begin
         Test := (curs + h*this^.a*this^.b) < lx/ratioX;
        if Test then
         begin
          for i := 1 to this^.a do
           begin
            curs := curs + h*this^.b;
            k := k-1;
            VectorX[k] := -curs;
            if UnEqealFlag then begin
            Moveto(lx-round(curs*ratioX),ly);
            lineREL(0,MaxY-ly);   end
            else begin end;
           end;
          this := this^.tail
         end
         else
         begin
         curs := curs + h*this^.b;
         Test := curs < lx/ratioX;
         while Test do
          begin
            k := k-1;
            VectorX[k] := -curs;
            if UnEqealFlag then begin
            Moveto(lx-round(curs*ratioX),ly);
            lineREL(0,MaxY-ly);    end
            else begin end;
            curs := curs + h*this^.b;
            Test := curs < lx/ratioX;
           end;

           this := nil
          end
        end;{this <> nil}
        k := k-1;
        VectorX[k] := -lx/ratioX;
        VectorX[k-1] := -curs;
      curs := 0;
      k := 0;
     this := beg;
      while (this <> nil) do
       begin
         Test := (curs + h*this^.a*this^.b) < lx/ratioX;
        if Test then
         begin
          for i := 1 to this^.a do
           begin
            curs := curs + h*this^.b;
            k := k+1;
            VectorX[k] := curs;
            if UnEqealFlag then begin
            Moveto(lx+round(curs*ratioX),ly);
            lineREL(0,MaxY-ly);   end
            else begin end;
           end;
          this := this^.tail
         end
         else
         begin
         curs := curs + h*this^.b;
         Test := curs < lx/ratioX;
         while Test do
          begin
            k := k+1;
            VectorX[k] := curs;
            if UnEqealFlag then begin
            Moveto(lx+round(curs*ratioX),ly);
            lineREL(0,MaxY-ly); end
            else begin end;
            curs := curs + h*this^.b;
            Test := curs < lx/ratioX;
           end;

           this := nil
          end
        end;{this <> nil}
        k := k+1;
        VectorX[k] := lx/ratioX;
        ControlWidth := k;
        VectorX[k+1] := curs;

   {разметка}
      SetColor(white);
      SetLinestyle(0,0,1);
      Rectangle(0,ly,GetMaxX,GetMaxY);
      line(0,ly,GetmaxX,ly);
      SetTextJustify(Righttext,TopText);
      OutTextXY(GetMaxX,ly+10,TitleX);

      SetTextJustify(Lefttext,Toptext);
      MoveTo(lx-NX*dxf,ly+2);
        a:= dxf*(-Nx)/ratioX;
        Str(a:3:0,st);
      SetTextJustify(Lefttext,Toptext);
        OutText(st);
      MoveTo(lx-(NX-1)*dxf,ly+2);
      SetTextJustify(Centertext,Toptext);
      for i := -NX+1 to NX-1 do
      begin
        a:= dxf*i/ratioX;
        Str(a:3:0,st);
        OutText(st);
        MoveRel(dxf,0);
       end;
        a:= dxf*Nx/ratioX;
        Str(a:3:0,st);
       SetTextJustify(Righttext,Toptext);
        OutText(st);
      SetTextJustify(Righttext,Centertext);
      MoveTo(GetmaxX,ly);
      for i := 1 to M do
      begin
        MoveRel(0,dxf);
        a:= dxf/ratioX*i;
        Str(a:3:0,st);
        OutText(st);
       end;
      MoveTo(GetmaxX,GetmaxY);
      SetTextJustify(Righttext,Bottomtext);
      OutText(TitleH);

      MoveTo(0,0);
      Setcolor(Magenta);
      SetTextJustify(Lefttext,toptext);
      OutText(Scrip)
end;{Setka}
{--------------------------------------}
Procedure PutSpline;{построение сплайна}
Const
      L = 10;{к-во точек между узлами интерполяции}
Var
 i,j : integer;
 U,q : RealType;
begin
       {построение сетки}

       SetColor(Brown);
       Moveto(lx+dx*delX,ly);
       for i := 1 to 2*delX-1 do
         begin
          MoveTo(lx+dx*(delx-i),ly);
          LineRel(0,-dely*dy);
         end;
        Moveto(lx-dx*delX,ly);
       for i := 1 to delY-1 do
         begin
          MoveTo(lx-dx*delx,ly-i*dy);
          LineRel(2*dx*delx,0);
         end;
        MoveTo(lx-dx*delX,ly-dy*delY);
      line(lx-dx*delX,ly,lx-dx*delX,ly-dy*delY);
      lineRel(2*dx*delX,0);
      LineRel(0,delY*dy);
      SetColor(White);
      SetTextJustify(Righttext,Toptext);
      OutTextXY(lx+dx*delx,0,TitleY);
      SetTextJustify(Righttext,Centertext);
      MoveTo(lx+dx*delx,ly);
      j := 0;
      for i := 1 to dely-1 do
      begin
        j := j + 1;
        MoveRel(0,-dy);
        if j < 2 then begin end
        else
        begin
        q:= qmax/dely*i;
        Str(q:3:1,st);
        OutText(st);
        j := 0
       end;
      end;
  Spline(N, X, Y, B, C, D);
  SetLinestyle(0,0,1);
  setColor(Yellow);
  U := X[1];
  moveto(lx+round(U*ratioX),
  ly-round(Seval(N,midpoint,U, X, Y, B, C, D)*ratioY));
  for i := 1   to N-1 do
   begin
    for j := 1 to L do
    begin
    U := X[i] + (X[i+1]-x[i])/L*j;
    Lineto(lx+round(U*ratioX),
    ly-round(Seval(N,midpoint,U, X, Y, B, C, D)*ratioY))
    end;
   end;
   {построение средней линии}
   SetLinestyle(3,0,1);
   Qmean := Simpson(X[1],X[N])/(X[N]-X[1]);
   Line(lx+round(X[1]*ratioX),ly-round(Qmean*ratioY),
   lx+round(X[N]*ratioX),ly-round(Qmean*ratioY));
   SetLinestyle(1,0,1);
end;{PutSpline}
end.
