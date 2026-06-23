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

function SearchCpf(cpf: TCpf): TPointer;
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

  SearchCpf := current;
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

      position := SearchCpf(cpf);
      if position = nil then
      begin
        hash[endDigit] := aux;
        aux^.next := nil;
      end else
      begin
        aux^.next := position^.next^.next;

        position^.next := aux;
      end;

      writeln('CPF inserted successfully!');
      writeln;
    end;
  end;
end;

procedure DeleteCpf(cpf: TCpf);
var deletion, previous: TPointer;
begin
  if VerifyCpf(cpf) <> 100 then
  begin
    previous := SearchCpf(cpf);

    if previous <> nil then
    begin
      deletion := previous^.next;

      previous^.next := deletion^.next;

      dispose(deletion);
    end;
  end else
  begin
    writeln('Invalid CPF!');
    readkey;
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
        write('Write the CPF (just numbers): ');
        read(cpf);
        InsertCpf(cpf);
      end;

      2: begin
        Write('Write the CPF (just numbers): ');
        Read(cpf);
        Writeln(SearchCpf(cpf)^.cpf);
      end;

      3: begin
        Write('Write the CPF (just numbers): ');
        Read(cpf);
        DeleteCpf(cpf);
      end;

      //4: WriteAllCpfs();
    end;
  end;
end.