program Hash_Study;

uses crt, sysutils;

type
  TCpf = string[11];
  TNode = record
    cpf: TCpf;
    next: ^TNode;
end;

var 
  cpf: TCpf;
  hash: array[00..99] of ^TNode;
  option: integer;

function SearchCpf(cpf: TCpf): TNode;
var current: ^TNode;
begin
  current := hash[VerifyCpf(cpf)];

  while current <> nil and current^.next^.cpf <> cpf do
  begin
    if cpf > current^.cpf then
    begin
      current := current^.next;
    end
  end;

  SearchCpf := current;
end;

function VerifyCpf(cpf: TCpf): integer;
var sum, digit, mult, turn: integer;
  cpfEndDigit: string[2];
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
    if sum = 10 then sum := 0;

    sum := (sum * 10) mod 11;

    cpfEndDigit := cpfEndDigit + IntToStr(sum);
  end;

  if (cpf[10] + cpf[11]) <> cpfEndDigit then
    cpfEndDigit := '100'

  VerifyCpf := StrToInt(cpfEndDigit);
end;

procedure InsertCpf(cpf: TCpf);
var endDigit: integer;
  aux, position: ^TNode;
begin
  writeln('Write the CPF (just numbers): ');
  read(cpf);

  endDigit := VerifyCpf(cpf);

  new(aux);

  if aux = nil then
  begin
    writeln('Memory full!');
    readkey;
  end
  else if endDigit <> 100 then
  begin
    writeln('Valid CPF!');

    position := SearchCpf(cpf);

    aux^.cpf := cpf;
    
    if position^.next = nil then
    begin
      aux^.next := nil;
    end
    else
    begin
      aux^.next := position^.next;
    end;

    position^.next := aux;
  end
  else
  begin
    writeln('Invalid CPF!');
    readkey;
  end;

  dispose(aux^.next);
  dispose(aux);
end;

begin
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
      1: InsertCpf(cpf);
      2: begin
        Writeln('Write the CPF (just numbers): ');
        ReadLn(cpf);
        SearchCpf(cpf);
      end;
      3: begin
        Writeln('Write the CPF (just numbers): ');
        ReadLn(cpf);
        DeleteCpf(cpf);
      end;
      4: WriteAllCpfs();
    end;
  end;
end.