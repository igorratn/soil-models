UNIT Sigma;
INTERFACE
USES  PutScr, UnCode, Config;
Const demen = 35;
Type
      RealPoint = ^TypeRecord;
      TypeRecord = Record
                          U, V,
                          SigmaX,
                          SigmaZ,
                          Tau      : RealType;
                    end;

var
      SizeofType,m1,m2 : integer;
      PtrStr : array[1..demen] of pointer;
{-----------------------------------------}

Function AddrR(i,j:integer):RealPoint;

Procedure PutSigma;
IMPLEMENTATION
{-----------------------------------------}

Function AddrR(i,j:integer):RealPoint;
Begin
     AddrR := ptr(seg(PtrStr[i]^),ofs(PtrStr[i]^)+j*SizeofType)

End;
{---------------------------------}
Procedure PutSigma;
Var
    i,s,t : integer;
{----------------------}
Procedure SigmaBlock;
Var j,k,l : integer;
{----------------------}
Procedure SigmaLine;
Var     KSigma, d33, Nu, h1, h2, u12, v12, u23, v23, u13, v13,
        SigmaX, SigmaZ, Tau : RealType;

Begin
      Nu := Grunt[s].Nu;
      d33 := (1-Nu)/2;
      h1 := 4*amax*this^.b*0.01;
      h2 := Grunt[s].h*thisGr[s]^.b*0.01;
      Ksigma := -Grunt[s].E/(1-Nu*Nu);

      if k = 4 then k := 1 else inc(k);

      case k of
           1: begin u12 := AddrR(i+1,j  )^.U - AddrR(i  ,j  )^.U;
                    u23 := AddrR(i  ,j  )^.U - AddrR(i  ,j+1)^.U;
                    v12 := AddrR(i+1,j  )^.V - AddrR(i  ,j  )^.V;
                    v23 := AddrR(i  ,j  )^.V - AddrR(i  ,j+1)^.V;

                    SigmaX := Ksigma*(-   u23/h1 + Nu*v12/h2);
                    SigmaZ := Ksigma*(-Nu*u23/h1 +    v12/h2);
                    Tau    := Ksigma*d33*(u12/h2 -    v23/h1);

                    AddrR(i  ,j  )^.SigmaX := AddrR(i  ,j  )^.SigmaX + 1/4*SigmaX;
                    AddrR(i  ,j+1)^.SigmaX := AddrR(i  ,j+1)^.SigmaX + 1/8*SigmaX;
                    AddrR(i+1,j  )^.SigmaX := AddrR(i+1,j  )^.SigmaX + 1/8*SigmaX;

                    AddrR(i  ,j  )^.SigmaZ := AddrR(i  ,j  )^.SigmaZ + 1/4*SigmaZ;
                    AddrR(i  ,j+1)^.SigmaZ := AddrR(i  ,j+1)^.SigmaZ + 1/8*SigmaZ;
                    AddrR(i+1,j  )^.SigmaZ := AddrR(i+1,j  )^.SigmaZ + 1/8*SigmaZ;

                    AddrR(i  ,j  )^.Tau := AddrR(i  ,j  )^.Tau + 1/4*Tau;
                    AddrR(i  ,j+1)^.Tau := AddrR(i  ,j+1)^.Tau + 1/8*Tau;
                    AddrR(i+1,j  )^.Tau := AddrR(i+1,j  )^.Tau + 1/8*Tau
           end;

           2: begin u12 := AddrR(i  ,j+1)^.U - AddrR(i+1,j+1)^.U;
                    u23 := AddrR(i+1,j+1)^.U - AddrR(i+1,j  )^.U;
                    v12 := AddrR(i  ,j+1)^.V - AddrR(i+1,j+1)^.V;
                    v23 := AddrR(i+1,j+1)^.V - AddrR(i+1,j  )^.V;

                    SigmaX := Ksigma*(    u23/h1 - Nu*v12/h2);
                    SigmaZ := Ksigma*( Nu*u23/h1 -    v12/h2);
                    Tau    := Ksigma*d33*(-u12/h2 +    v23/h1);

                    AddrR(i  ,j+1)^.SigmaX := AddrR(i  ,j+1)^.SigmaX + 1/8*SigmaX;
                    AddrR(i+1,j  )^.SigmaX := AddrR(i+1,j  )^.SigmaX + 1/8*SigmaX;
                    AddrR(i+1,j+1)^.SigmaX := AddrR(i+1,j+1)^.SigmaX + 1/4*SigmaX;

                    AddrR(i  ,j+1)^.SigmaZ := AddrR(i  ,j+1)^.SigmaZ + 1/8*SigmaZ;
                    AddrR(i+1,j  )^.SigmaZ := AddrR(i+1,j  )^.SigmaZ + 1/8*SigmaZ;
                    AddrR(i+1,j+1)^.SigmaZ := AddrR(i+1,j+1)^.SigmaZ + 1/4*SigmaZ;

                    AddrR(i  ,j+1)^.Tau := AddrR(i  ,j+1)^.Tau + 1/8*Tau;
                    AddrR(i+1,j  )^.Tau := AddrR(i+1,j  )^.Tau + 1/8*Tau;
                    AddrR(i+1,j+1)^.Tau := AddrR(i+1,j+1)^.Tau + 1/4*Tau
           end;

           3: begin u12 := AddrR(i+1,j  )^.U - AddrR(i  ,j  )^.U;
                    u13 := AddrR(i+1,j  )^.U - AddrR(i+1,j+1)^.U;
                    v12 := AddrR(i+1,j  )^.V - AddrR(i  ,j  )^.V;
                    v13 := AddrR(i+1,j  )^.V - AddrR(i+1,j+1)^.V;

                    SigmaX := Ksigma*(   -u13/h1 + Nu*v12/h2);
                    SigmaZ := Ksigma*(-Nu*u13/h1 +    v12/h2);
                    Tau    := Ksigma*d33*( u12/h2 -    v13/h1);

                    AddrR(i  ,j  )^.SigmaX := AddrR(i  ,j  )^.SigmaX + 1/8*SigmaX;
                    AddrR(i+1,j  )^.SigmaX := AddrR(i+1,j  )^.SigmaX + 1/4*SigmaX;
                    AddrR(i+1,j+1)^.SigmaX := AddrR(i+1,j+1)^.SigmaX + 1/8*SigmaX;

                    AddrR(i  ,j  )^.SigmaZ := AddrR(i  ,j  )^.SigmaZ + 1/8*SigmaZ;
                    AddrR(i+1,j  )^.SigmaZ := AddrR(i+1,j  )^.SigmaZ + 1/4*SigmaZ;
                    AddrR(i+1,j+1)^.SigmaZ := AddrR(i+1,j+1)^.SigmaZ + 1/8*SigmaZ;

                    AddrR(i  ,j  )^.Tau := AddrR(i  ,j  )^.Tau + 1/8*Tau;
                    AddrR(i+1,j  )^.Tau := AddrR(i+1,j  )^.Tau + 1/4*Tau;
                    AddrR(i+1,j+1)^.Tau := AddrR(i+1,j+1)^.Tau + 1/8*Tau
           end;

           4: begin u12 := AddrR(i  ,j+1)^.U - AddrR(i+1,j+1)^.U;
                    u13 := AddrR(i  ,j+1)^.U - AddrR(i  ,j  )^.U;
                    v12 := AddrR(i  ,j+1)^.V - AddrR(i+1,j+1)^.V;
                    v13 := AddrR(i  ,j+1)^.V - AddrR(i  ,j  )^.V;

                    SigmaX := Ksigma*(    u13/h1 - Nu*v12/h2);
                    SigmaZ := Ksigma*( Nu*u13/h1 -    v12/h2);
                    Tau    := Ksigma*d33*(-u12/h2 +    v13/h1);

                    AddrR(i  ,j  )^.SigmaX := AddrR(i  ,j  )^.SigmaX + 1/8*SigmaX;
                    AddrR(i  ,j+1)^.SigmaX := AddrR(i  ,j+1)^.SigmaX + 1/4*SigmaX;
                    AddrR(i+1,j+1)^.SigmaX := AddrR(i+1,j+1)^.SigmaX + 1/8*SigmaX;

                    AddrR(i  ,j  )^.SigmaZ := AddrR(i  ,j  )^.SigmaZ + 1/8*SigmaZ;
                    AddrR(i  ,j+1)^.SigmaZ := AddrR(i  ,j+1)^.SigmaZ + 1/4*SigmaZ;
                    AddrR(i+1,j+1)^.SigmaZ := AddrR(i+1,j+1)^.SigmaZ + 1/8*SigmaZ;

                    AddrR(i  ,j  )^.Tau := AddrR(i  ,j  )^.Tau + 1/8*Tau;
                    AddrR(i  ,j+1)^.Tau := AddrR(i  ,j+1)^.Tau + 1/4*Tau;
                    AddrR(i+1,j+1)^.Tau := AddrR(i+1,j+1)^.Tau + 1/8*Tau;
           end
      end;{Case k of}
end;{SigmaLine}
{----------------------}

Begin {SigmaBlock}
      inc(i);
      j := lgor+1;
      if odd(i) then k := 4 else k := 2;
      this := beg;
      while this <> nil do
            begin for l := 1 to this^.a do
                  begin SigmaLine;
                        SigmaLine;
                        inc(j)
                  end;
                  this := this^.tail
            end;
      if odd(i) then k := 2 else k := 4;
      this := beg;
      j := lgor;
      while this <> nil do
            begin for l := 1 to this^.a do
                  begin SigmaLine;
                        SigmaLine;
                        dec(j)
                  end;
                  this := this^.tail
            end;

end;{SigmaBlock}

Begin {PutSigma}
      i := 0;
      for s := 1 to LGr do
          begin thisGr[s] := begGr[s];
                while thisGr[s] <> nil do
                      begin for t := 1 to thisGr[s]^.a do Sigmablock;
                            thisGr[s] := thisGr[s]^.tail
                      end
          end;
      for i := 1 to m2 do
          begin s := 1;
                AddrR(i  ,s  )^.SigmaX := 0;
                AddrR(i  ,s  )^.SigmaZ := 0;
                AddrR(i  ,s  )^.Tau    := 0;
                s := m1;
                AddrR(i  ,s  )^.SigmaX := 0;
                AddrR(i  ,s  )^.SigmaZ := 0;
                AddrR(i  ,s  )^.Tau    := 0
          end;
      for s := 2 to m1-1 do
          begin
                AddrR(i  ,s  )^.SigmaX := 0;
                AddrR(i  ,s  )^.SigmaZ := 0;
                AddrR(i  ,s  )^.Tau    := 0
          end
end; {PutSigma}
END.