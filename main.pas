program Hash_Study;

// consulta https://www.calculadorafacil.com.br/computacao/validar-cpf

uses crt, sysutils;

type
  TCpf = string[11];
  TNode = record
    ant: ^TNode;
    cpf: TCpf;
    next: ^TNode;
end;

var 
  cpf: TCpf;
  hash: array[00..99] of ^TNode;

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
  aux, current: ^TNode;
begin
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

    current := hash[endDigit];

    aux^.cpf := cpf;
    aux^.next := nil;
    hash[endDigit] := aux;
  end
  else
  begin
    writeln('Invalid CPF!');
    readkey;
  end;
end;

begin
  Write('Digite o CPF: ');
  ReadLn(cpf);
  InsertCpf(cpf);
end.