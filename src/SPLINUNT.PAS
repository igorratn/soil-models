UNIT SplinUNT;
INTERFACE
USES Config;
 type
 RealTypeArray = array[1..7] of Realtype;
 Procedure Spline(N : byte; var X1, Y1, B1, C1, D1);
 Function Seval (N : byte; var midpoint : byte;U: Realtype;var X1, Y1, B1, C1, D1) : Realtype;

{---------------------------------------------------------------}
          IMPLEMENTATION
Procedure Spline;
var
 X : RealtypeArray absolute X1;
 Y : RealtypeArray absolute Y1;
 B : RealtypeArray absolute B1;
 C : RealtypeArray absolute C1;
 D : RealtypeArray absolute D1;
 ib, i : integer;
 T : RealType;
BEGIN
 if N < 2 then halt;
  d[1] := x[2] -x[1];
  c[2] := (y[2]- y[1])/d[1];
  for i := 2 to N-1 do
   begin
    d[i] := x[i+1] - x[i];
    b[i] := 2*(d[i-1] + d[i]);
    c[i+1] := (y[i+1] - y[i])/d[i];
    c[i] := c[i+1] - c[i]
   end;
   b[1] := -d[1];
   b[n] := - d[N-1];
   c[1] := 0;
   c[N] := 0;
   if N = 2 then
    begin
     b[1] := (y[2] - y[1])/(x[2] - x[1]);
     c[1] := 0;
     d[1] := 0;
     b[2] := b[1];
     c[2] := 0;
     d[2] := 0
    end
   else
    begin
     c[1] := c[3]/(x[4] - x[2]) - c[2]/(x[3] - x[1]);
     c[N] := c[N-1]/(x[N] - x[N-2]) - c[N-2]/(x[N-1] - x[N-3]);
     c[1] := c[1]*sqr(d[1])/(x[4] - x[1]);
     c[N] := -c[N]*sqr(d[N-1])/(x[N] - x[N-3]);
    for i := 2 to N do
     begin
      T := d[i-1]/b[i-1];
      B[i] := B[i] - T*D[i-1];
      C[i] := C[i] - T*C[i-1];
     end;
     c[N] := c[N]/b[N];
     for ib := 1 to N-1 do
      c[N-ib] := (c[N - ib] - d[N-ib]*c[N-ib + 1])/b[N-ib];
      B[N] := (Y[N] - Y[N-1])/D[N-1] + D[N-1] * (C[N-1] + 2*C[N]);
      for i := 1 to N-1 do
       begin
        B[i] := (Y[i+1] - Y[i])/D[i] - D[i] * (C[i+1] + 2*C[i]);
        D[i] := (C[I+1]-C[I])/D[i];
        C[i] := 3*C[i]
       END;
      C[N] := 3*C[N];
      D[N] := D[N-1];
     end {N > 2}
     END {Spline};
 {------------------------}
 Function Seval;
var
 X : RealtypeArray absolute X1;
 Y : RealtypeArray absolute Y1;
 B : RealtypeArray absolute B1;
 C : RealtypeArray absolute C1;
 D : RealtypeArray absolute D1;
 DX : RealType;
 lo, hi : integer;
 test : boolean;
 Begin

  {if  U < X[1] then midpoint := 1 else  if U > X[N] then midpoint := N else}
  if  (U < X[1]) or (U > X[N]) then Seval := 0 else
  begin
  if (U < X[midpoint]) or (U > X[midpoint+1]) then
  begin
    lo :=1; hi := N;
    test := false;
    repeat
      midpoint := (hi+lo) div 2;
      if U > X[midpoint] then lo := midpoint+1 else
      if U < X[midpoint] then hi := midpoint-1 else test := true
    until test or (hi < lo);
      if U < X[midpoint] then midpoint := midpoint - 1 else begin end
    {if U < X[midpoint] then
    Repeat
      midpoint := pred(midpoint)
    until U > X[midpoint]
    else
    Repeat
      midpoint := succ(midpoint)
    until U < X[midpoint+1];}
   end;
   DX := U-X[midpoint];
   {writeln(lst,'U =',U:10:4,' midp=',midpoint:3,
   ' X[midpoint] = ',X[midpoint]:10:4,
   ' y[midpoint] = ',y[midpoint]:10:4,
   ' b[midpoint] = ',b[midpoint]:10:4,
   ' c[midpoint] = ',c[midpoint]:10:4,
   ' d[midpoint] = ',d[midpoint]:10:4);}
   Seval := Y[midpoint] + DX*(B[midpoint]+ DX*(C[midpoint]+DX*D[midpoint]))
  end
END {SEVAL};

   END. {UNIT}