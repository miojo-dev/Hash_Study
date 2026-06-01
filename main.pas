program Hash_Study;

// consulta https://www.calculadorafacil.com.br/computacao/validar-cpf

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

  VerifyCpf := StrToInt(cpfEndDigit);
end;

procedure InsertCpf(cpf: TCpf);
var endDigit: string;
begin
  endDigit := VerifyCpf(cpf);

  if endDigit <> '100' then
  begin
    writeln('Valid CPF!');

    new(hash[StrToInt(cpf[1] + cpf[2])]);
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