UNIT LDL;
INTERFACE
USES Config;
Const R = 1;
      dem = 1116;
        m = 65;
Type
      typeb = array[1..dem,1..R] of realtype;
      RealPoint = ^RealType;
var
      bldl : typeb;
      SizeofReal,m1,m2,n1,n2 : integer;
      PtrStr : array[0..m] of pointer;
Function AddrR(i,j:integer):RealPoint;
Function GetR(i,j:integer):RealType;
Procedure PutR(i,j:integer; x:RealType);
Procedure Chobanddet(n,m:integer);
Procedure chobandsol(n,m,r :integer; var b,x:typeb);

{----------------------------------}
IMPLEMENTATION

Function AddrR(i,j:integer):RealPoint;
Begin {Addr}
     AddrR := ptr(seg(PtrStr[j]^),ofs(PtrStr[j]^) + (i-1)*SizeofReal)
End; {AddrR}
{--------------------------------------------}
Function GetR;
Begin
     GetR := AddrR(i,j)^
End;
{--------------------------------------------}
Procedure PutR;
Begin
     AddrR(i,j)^ := x
End;
{--------------------------------------------}
Procedure Chobanddet;
Var
    i,j,k,p,q,r,s :integer;
    y : realtype;
{---------------------------}
Begin
      for i := 1 to n do
      begin if i > m then p := 0 else p := m-i+1;
            r := i-m+p;
            for j := p to m do
            begin
                  s := j-1;
                  q := m-j+p;
                  y := GetR(i,j);
                  for k := p to s do
		  begin
                        y := y-GetR(i,k)*GetR(r,q);
                        q := q+1
		   end;
	    if j = m then
	    begin  if y = 0 then exit;
          	   if y < 0 then exit;
		   PutR(i,j,1/sqrt(y))
	    end {j=m}
	    else
	    PutR(i,j, y*GetR(r,m));
            r := r+1
	    end {j}
      end {i}
end;{chobanddet}
{-----------------------}
Procedure chobandsol;
var
    i,j,k,p,q,s : integer;
    y : realtype;
begin
      s := m-1;
      for j := 1 to r do
      begin {LY = B}
            for i := 1 to n do
            begin if i > m then p := 0 else p := m-i+1;
                  q := i;
                  y := b[i,j];
                  for k := s downto p do
                  begin q := q-1;
                        y := y-GetR(i,k)*x[q,j];
                  end;
                  x[i,j] := y*GetR(i,m);
             end;
            {UX=Y}
            for i := n downto 1 do
            begin if n-i > m then p := 0 else p := m-n+i;
                  y := x[i,j];
                  q := i;
                  for k := s downto p do
                  begin q := q+1;
                        y := y-GetR(q,k)*x[q,j]
                  end;
                  x[i,j] := y*GetR(i,m)
            end
      end{j}
end;{chobandsol}
{----------------------}
End.
