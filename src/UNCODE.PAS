UNIT Uncode;{раскодирование}
INTERFACE
Uses Crt;

type
    linkCodetrans = ^Codetrans;
    Codetrans = record
                 a,b : byte;
                 tail : linkcodetrans
                end;

Procedure Resort(Code : string; var thisCodetrans, lastCodetrans,
                   begCodetrans : linkCodetrans);
Procedure Uncoding(Code : string; var thisCodetrans, lastCodetrans,
                   begCodetrans : linkCodetrans; var L: byte;
                   var ErCode : integer);
IMPLEMENTATION
Procedure Resort;
 Begin
 lastCodetrans := thisCodetrans^.tail;
 if lastCodetrans <> nil then
 begin
 thisCodetrans^.tail := nil;
 while lastCodetrans^.tail <> nil do
  begin
  begCodetrans := lastCodetrans^.tail;
  lastCodetrans^.tail := thisCodetrans;
  thisCodetrans := lastCodetrans;
  lastCodetrans := begCodetrans
  end;
  lastCodetrans^.tail := thisCodetrans;
  thisCodetrans := lastCodetrans;
  begCodetrans := thisCodetrans
  end
  else begin end;
 end;{Resort}

{-------------------------------------}
Procedure Uncoding;
var
   bufmist, kbuf, bufi, lengthCode : byte;
   i : integer;
   buf : string;

Procedure ErMess;{сообщение об ошибке}
 Const
    Mes = ' Ошибка в коде : ';
 Var
    i : integer;
 Begin
  Clrscr;
  textColor(Magenta);
  textBackGround(White);
  Write(Mes);
  for i := 1 to bufmist+ErCode - 1 do write(Code[i]);
  textColor(Magenta+Blink);
  write(Code[bufmist+ErCode]);
  textColor(Magenta);
  for i := bufmist+ErCode+1 to lengthCode do write(Code[i]);
 end;{ErMess}
{-------------------------------------}

Begin
    lengthCode := length(Code);
    i := 1;
    bufmist := 0;
    thisCodetrans := nil;
 while i <= lengthCode do
  begin
   lastCodetrans := thisCodetrans;
   new(thisCodetrans);
   
   thisCodetrans^.tail := lastCodeTrans;
   buf := '';
   bufi := 0;
   kbuf := 0;
   while (code[i] <> ',') and (i<=lengthCode) do
    begin
     buf := buf + code[i];
     kbuf := kbuf + 1;
     if code[i] = '(' then bufi := kbuf else begin end;
     i := i + 1
    end;

    if bufi = 0 then
      begin
       Val(buf,thisCodetrans^.b,ErCode);
       if ErCode <> 0 then begin ErMess; exit end
        else  thisCodetrans^.a := 1
       end
     else
       begin
        Val(copy(buf,1,bufi-1),thisCodetrans^.a,ErCode);
        if ErCode <> 0 then begin ErMess; exit end
        else
        begin
         Val(copy(buf,bufi+1,length(buf)-bufi-1),thisCodetrans^.b,ErCode);
         if ErCode <> 0 then begin bufmist := bufmist+bufi;
                             ErMess; exit end
         else begin end
        end
       end;{bufi > 0}
      bufmist := i;
      L := L + thisCodetrans^.a;
      i := i+1
   end;{i <= lengthCode}
   begCodetrans := thisCodetrans;
  end;
 end.