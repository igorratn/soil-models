UNIT FuncLoad;
INTERFACE
USES  Graph, CRT, PutScr, SplinUnt, Config;
Type
     FunType =  Function(var X:RealType;XF,YF:RealType):RealType;
     FunC =  Function(XF,YF:RealType):RealType;
Function GX(XF,YF:RealType):RealType;
Function GZ(XF,YF:RealType):RealType;
Function GXo(XF,YF:RealType):RealType;
Function GZo(XF,YF:RealType):RealType;
Function Tauo(XF,YF:RealType):RealType;
Function Po(XF,YF:RealType):RealType;
{Function Dat(XF,YF:RealType):RealType;}
Function TetaMax(XF,YF:RealType):RealType;
{---------------------------------------------------------}
IMPLEMENTATION
Function ArcSin(X:RealType):RealType;
Var SinX : RealType;
Begin SinX := Sin(X);
      ArcSin := ArcTan(sqrt(sinx*sinx/(1-sinx*sinx)))
End; {ArcSin}
{---------------------------------------------------------}
Function Simpson(FUN:FunType;XF,YF,As,Bs:RealType):RealType;
Const
  N = 5;
var
  H, I, xvar : RealType;
  k : integer;
Begin
  H := ((Bs-As)/N)/2;
  I:= Fun(As,XF,YF);
  for k:= 1 to 2*N-1 do
   begin
   xvar := As+k*H; {writeln('xvar=',xvar:10:5);readln;}
   if odd(k) then
    I := I + 4*Fun(xvar,XF,YF)
   else
    I := I + 2*Fun(xvar,XF,YF);
   end;
  Simpson := (I + FUN(Bs,XF,YF))*H/3
end;

{$F+}
Function G(var ksi:RealType;XF,YF:RealType): RealType; {подынтегральное выражение для напряжений}
var
   q : RealType;
begin
  q := Seval(N,midpoint,ksi,X,Y,B,C,D);
  G := q*((XF-ksi)*(XF-ksi) - YF*YF)/sqr((XF-ksi)*(XF-ksi) + 1.e-10+YF*YF)
end;{G}
Function GTau(var ksi:RealType;XF,YF:RealType): RealType; {подынтегральное выражение для Tau}
var
   q : RealType;
begin
  q := Seval(N,midpoint,ksi,X,Y,B,C,D);
  GTau := q*(XF-ksi)*2*YF/sqr((XF-ksi)*(XF-ksi) + 1.e-10+YF*YF)
end;{GTau}

Function PG(var ksi:RealType;XF,YF:RealType): RealType; {подынтегральное выражение для напоров}
var
   q: RealType;
begin
  q := Seval(N,midpoint,ksi,X,Y,B,C,D);
  {writeln(t,'N=',N:3,' ksi=',ksi:10:5,'q= ',q:10:5);
  writeln('X[1]=',X[1]:10:5,'X[N]=',X[N]:10:5);readln;}
  PG := q*YF/((XF-ksi)*(XF-ksi) + 1.e-10+YF*YF)
end;{PG}

Function GXo(XF,YF:RealType): RealType;

BEGIN {GXo}

 GXo := YF/pi*Simpson(G,XF,YF,X[1],X[N]);
end;{GXo}

Function GZo(XF,YF:RealType): RealType;

BEGIN {GZo}

 GZo := -GXo(XF,YF);
end;{GZo}

Function Po(XF,YF:RealType):RealType;

BEGIN {Po}

 Po := 1/pi*Simpson(PG,XF,YF,X[1],X[N]);
end;{Po}
Function Tauo(XF,YF:RealType): RealType;

BEGIN {Tauo}

 Tauo := 1./pi*Simpson(G,XF,YF,X[1],X[N]);
end;{Tauo}

Function GX(XF,YF:RealType):RealType;

BEGIN {GX}

 GX := Po(XF,YF)+GXo(XF,YF)
end;{GX}

Function GZ(XF,YF:RealType):RealType;

BEGIN {GX}

 GZ := Po(XF,YF)+GZo(XF,YF)
end;{GZ}
(*
Function Dat(XF,YF:RealType):RealType;

BEGIN {Dat}

 Dat := (Po(XF,YF)*Grunt[1].eps + GZo(XF,YF))/(1+Grunt[1].eps)
end;{Dat}
*)
Function TetaMax(XF,YF:RealType):RealType;
Var sq:realtype;
BEGIN {TetaMax}
 sq := sqrt((GXo(XF,YF)-GZo(XF,YF))*(GXo(XF,YF)-GZo(XF,YF)) +
 4*Tauo(XF,YF)*Tauo(XF,YF));
 TetaMax := arcsin(sq)/
 (GXo(XF,YF)+GZo(XF,YF)+2*Grunt[1].c/Sin(Grunt[1].Fi)*Cos(Grunt[1].Fi))*180/pi

end;{TetaMax}

{$F-}

 end.
