program Hash_Study;

uses crt, sysutils;

type
  TCpf = string[11];
  TPointer = ^TNode;
  TNode = record
    cpf: TCpf;
    next: TPointer;
  end;

var
  cpf: TCpf;
  hash: array[00..99] of TPointer;
  option: integer;

procedure ReadCpf();
begin
  write('Write the CPF (just numbers): ');
  read(cpf);
end;

function VerifyCpf(cpf: TCpf): integer;
var sum, digit, mult, turn: integer;
  cpfEndDigit: string;
begin
  cpfEndDigit := '';
  sum := 0;
  mult := 10;
  
  for turn := 0 to 1 do
  begin
    sum := 0;
    mult := 10 + turn;
    
    for digit := 1 to (9 + turn) do
    begin
      sum := sum + (StrToInt(cpf[digit]) * mult);

      mult := mult - 1;
    end;
    
    sum := sum mod 11;
    if sum < 2 then sum := 0
    else sum := 11 - sum;

    cpfEndDigit := cpfEndDigit + IntToStr(sum);
  end;

  if Copy(cpf, 10, 2) <> cpfEndDigit then
    cpfEndDigit := '100';
  
  VerifyCpf := StrToInt(cpfEndDigit);
end;

function FindNodeBefore(cpf: TCpf): TPointer;
var current: TPointer;
  index: integer;
begin
  index := VerifyCpf(cpf);

  if index <> 100 then
  begin
    current := hash[index];

    while (current <> nil) and
      (current^.next <> nil) and
      (current^.next^.cpf <> cpf) and
      (current^.next^.cpf < cpf) do
    begin
      current := current^.next;
    end;
  end else
  begin
    current := nil;
  end;

  FindNodeBefore := current;
end;

function FindCpf(cpf: TCpf): TPointer;
var current: TPointer;
  index: integer;
begin
  index := VerifyCpf(cpf);

  if index <> 100 then
  begin
    current := hash[index];

    while (current <> nil) and (current^.cpf <> cpf) do
      current := current^.next;

  end else
    current := nil;

  FindCpf := current;
end;

procedure InsertCpf(cpf: TCpf);
var endDigit: integer;
  aux, position: TPointer;
begin
  endDigit := VerifyCpf(cpf);

  if endDigit = 100 then
  begin
    writeln('Invalid CPF!');
    readkey;
  end else
  begin
    position := nil;
    
    if FindCpf(cpf) <> nil then
    begin
      writeln('CPF already registered!');
      readkey;
      
    end else
    begin
      new(aux);
    
      if aux = nil then
      begin
        writeln('Memory full!');
        readkey; 
      end else
      begin
        clrscr;
        writeln('Valid CPF!');
        
        aux^.cpf := cpf;
    
        position := FindNodeBefore(cpf);
        if (position = nil) or (position^.cpf > cpf) then
        begin
          aux^.next := hash[endDigit];
          hash[endDigit] := aux;
        end else
        begin
          aux^.next := position^.next;
        
          position^.next := aux;
        end;
        
        writeln('CPF inserted successfully!');
        writeln;
      end;
    end;
  end;
end;

procedure DeleteCpf(cpf: TCpf);
var deletion, previous: TPointer;
  endDigit: integer;
begin
  endDigit := VerifyCpf(cpf);
  
  if endDigit <> 100 then
  begin
    previous := FindNodeBefore(cpf);

    if previous = nil then
      writeln('CPF not found!')
    else if previous^.cpf = cpf then
    begin
      hash[endDigit] := previous^.next;
      
      dispose(previous);
      writeln('CPF deleted successfully!');
    end
    else if (previous^.next <> nil) and (previous^.next^.cpf = cpf) then
    begin
      deletion := previous^.next;
      
      previous^.next := deletion^.next;
      
      dispose(deletion);
      writeln('CPF deleted successfully!');
    end
    else
      writeln('CPF not found!');
  end else
  begin
    writeln('Invalid CPF!');
    readkey;
  end;
end;

procedure ConsultCpf(cpf: TCpf);
var result: TPointer;
  index: integer;
begin
  result := FindCpf(cpf);
  index := VerifyCpf(cpf);
  
  if result <> nil then
    Writeln(result^.cpf, 'on index: ', index)
  else
    Writeln('CPF not found!');
end;

procedure WriteAll(hashArray: array of TPointer);
var i: integer;
  aux: TPointer;
begin
  clrscr;
  for i := 00 to 99 do
  begin
    aux := hashArray[i];
    
    writeln('Index: ', i);
    
    while aux <> nil do
    begin
      writeln;
      Writeln(aux^.cpf);
      aux := aux^.next;
    end;
  end;
end;

begin
  option := -1;

  while option <> 0 do
  begin
    Writeln('Choose your action:');
    Writeln('1 - Insert a CPF');
    Writeln('2 - Search a CPF');
    Writeln('3 - Delete a CPF');
    Writeln('4 - Show all CPFs');
    Writeln('0 - Exit');
    ReadLn(option);

    case option of
      1: begin
        ReadCpf();
        InsertCpf(cpf);
      end;

      2: begin
        ReadCpf();
        ConsultCpf(cpf);
      end;

      3: begin
        ReadCpf();
        DeleteCpf(cpf);
      end;

      4: WriteAll(hash);
    end;
  end;
end.
