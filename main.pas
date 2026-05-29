program Hash_Study;

// consulta https://www.calculadorafacil.com.br/computacao/validar-cpf

uses crt;

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
var cpfEndDigit, i: integer;
begin
  cpfEndDigit := cpf[10..11];


  VerifyCpf := cpfEndDigit;
end;

procedure InsertCpf(cpf: TCpf);
var endDigit: integer;
begin
  endDigit := VerifyCpf(cpf);

  if endDigit <> 100 then
  begin
    
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