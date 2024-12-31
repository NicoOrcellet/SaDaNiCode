unit Inicial;
{$codepage UTF8}

interface

uses defTipos, analizadorSintactico, evaluador, crt;

Const
   //Ruta = 'D:\Escritorio\ArchivoEjemplo.txt';
   //Ruta = 'D:\Escritorio\ArchivoEjemplo2.txt';
   //Ruta = 'D:\Escritorio\ArchivoEjemplo3.txt';

Type
  archivo=file of char;

Var
  fuente: archivo;
  A: T_Arbol;
  Estado: T_estado;
  correcto: boolean;

procedure iniciar();

implementation
procedure iniciar();
begin
  Assign(fuente,Ruta);
  reset(fuente);
  AnalizSintactico(A,Fuente, correcto);
  if correcto then
  begin
  InicializarEstado(estado);
  EvaluarProgram(A,estado);
  readkey();
  end;
  close(fuente);
end;

end.

