UNIT FuncLoad;
INTERFACE
USES  Graph, CRT, PutScr, SplinUnt, Config;
Type
     FunType =  Function(var X:RealType;XF,YF:RealType):RealType;
     FunC =  Function(XF,YF:RealType):RealType;
Function GXo(XF,YF:RealType):RealType;
Function GZo(XF,YF:RealType):RealType;
Function Po(XF,YF:RealType):RealType;
{---------------------------------------------------------}
IMPLEMENTATION
Function Simpson(FUN:FunType;XF,YF,A,B:RealType):RealType;
Const
  N = 5;
var
  H, I, xvar : RealType;
  k : integer;
Begin
  H := ((B-A)/N)/2;
  I:= Fun(A,XF,YF);
  for k:= 1 to 2*N-1 do
   begin
   xvar := A+k*H; {writeln('xvar=',xvar:10:5);readln;}
   if odd(k) then
    I := I + 4*Fun(xvar,XF,YF)
   else
    I := I + 2*Fun(xvar,XF,YF);
   end;
  Simpson := (I + FUN(B,XF,YF))*H/3
end;

{$F+}
Function G(var ksi:RealType;XF,YF:RealType): RealType; {подынтегральное выражение для напряжений}
var
   q : RealType;
begin
  q := Seval(N,midpoint,ksi,X,Y,B,C,D);
  G := q*((XF-ksi)*(XF-ksi) - YF*YF)/sqr((XF-ksi)*(XF-ksi) + 1.e-10+YF*YF)
end;{G}

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
{$F-}

 end.
