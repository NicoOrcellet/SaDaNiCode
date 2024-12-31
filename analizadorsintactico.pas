unit analizadorSintactico;



interface

uses
  analizadorLexico, defTipos, crt;

const
  Ruta2 = 'D:\Escritorio\ArchivoEjemplo2.txt';

procedure AnalizSintactico(var A:T_Arbol; var Fuente:Archivo; var correcto: boolean);

implementation

procedure cargarTAS(var Tabla:TAS);
var
 i, j: simbolos;
 begin
  for i := V_program to V_CondNot do
       begin
       for j := T_begin to pesos do
            begin
            Tabla[i,j] := nil;
            end;
       end;

  //<Program> ::= <Variable> <SigVariable>
  new(Tabla[V_program,T_id]);
  Tabla[V_program,T_id]^.elem[1] := V_Variable;
  Tabla[V_program,T_id]^.elem[2] := V_SigVariable;
  Tabla[V_program,T_id]^.cant := 2;

  //<SigVariable> ::= <Program>
  new(Tabla[V_SigVariable,T_id]);
  Tabla[V_SigVariable,T_id]^.elem[1] := V_Program;
  Tabla[V_SigVariable,T_id]^.cant := 1;

  //<SigVariable> ::= “begin” <Cuerpo> “end” “.”
  new(Tabla[V_SigVariable,T_begin]);
  Tabla[V_SigVariable,T_begin]^.elem[1] := T_begin;
  Tabla[V_SigVariable,T_begin]^.elem[2] := V_Cuerpo;
  Tabla[V_SigVariable,T_begin]^.elem[3] := T_end;
  Tabla[V_SigVariable,T_begin]^.elem[4] := T_punto;
  Tabla[V_SigVariable,T_begin]^.cant := 4;

  //<Cuerpo> ::= <Sentencia> <SigSentencia>
  new(Tabla[V_Cuerpo,T_id]);
  Tabla[V_Cuerpo,T_id]^.elem[1] := V_Sentencia;
  Tabla[V_Cuerpo,T_id]^.elem[2] := V_SigSentencia;
  Tabla[V_Cuerpo,T_id]^.cant := 2;

  new(Tabla[V_Cuerpo,T_read]);
  Tabla[V_Cuerpo,T_read]^.elem[1] := V_Sentencia;
  Tabla[V_Cuerpo,T_read]^.elem[2] := V_SigSentencia;
  Tabla[V_Cuerpo,T_read]^.cant := 2;

  new(Tabla[V_Cuerpo,T_write]);
  Tabla[V_Cuerpo,T_write]^.elem[1] := V_Sentencia;
  Tabla[V_Cuerpo,T_write]^.elem[2] := V_SigSentencia;
  Tabla[V_Cuerpo,T_write]^.cant := 2;

  new(Tabla[V_Cuerpo,T_if]);
  Tabla[V_Cuerpo,T_if]^.elem[1] := V_Sentencia;
  Tabla[V_Cuerpo,T_if]^.elem[2] := V_SigSentencia;
  Tabla[V_Cuerpo,T_if]^.cant := 2;

  new(Tabla[V_Cuerpo,T_while]);
  Tabla[V_Cuerpo,T_while]^.elem[1] := V_Sentencia;
  Tabla[V_Cuerpo,T_while]^.elem[2] := V_SigSentencia;
  Tabla[V_Cuerpo,T_while]^.cant := 2;

  new(Tabla[V_Cuerpo,T_for]);
  Tabla[V_Cuerpo,T_for]^.elem[1] := V_Sentencia;
  Tabla[V_Cuerpo,T_for]^.elem[2] := V_SigSentencia;
  Tabla[V_Cuerpo,T_for]^.cant := 2;

  new(Tabla[V_Cuerpo,T_write]);
  Tabla[V_Cuerpo,T_write]^.elem[1] := V_Sentencia;
  Tabla[V_Cuerpo,T_write]^.elem[2] := V_SigSentencia;
  Tabla[V_Cuerpo,T_write]^.cant := 2;

  //<SigSentencia> ::= <Cuerpo>
  new(Tabla[V_SigSentencia,T_id]);
  Tabla[V_SigSentencia,T_id]^.elem[1] := V_Cuerpo;
  Tabla[V_SigSentencia,T_id]^.cant := 1;

  new(Tabla[V_SigSentencia,T_read]);
  Tabla[V_SigSentencia,T_read]^.elem[1] := V_Cuerpo;
  Tabla[V_SigSentencia,T_read]^.cant := 1;

  new(Tabla[V_SigSentencia,T_write]);
  Tabla[V_SigSentencia,T_write]^.elem[1] := V_Cuerpo;
  Tabla[V_SigSentencia,T_write]^.cant := 1;

  new(Tabla[V_SigSentencia,T_if]);
  Tabla[V_SigSentencia,T_if]^.elem[1] := V_Cuerpo;
  Tabla[V_SigSentencia,T_if]^.cant := 1;

  new(Tabla[V_SigSentencia,T_while]);
  Tabla[V_SigSentencia,T_while]^.elem[1] := V_Cuerpo;
  Tabla[V_SigSentencia,T_while]^.cant := 1;

  new(Tabla[V_SigSentencia,T_for]);
  Tabla[V_SigSentencia,T_for]^.elem[1] := V_Cuerpo;
  Tabla[V_SigSentencia,T_for]^.cant := 1;

  //<SigSentencia> ::= e
  new(Tabla[V_SigSentencia,T_end]);
  Tabla[V_SigSentencia,T_end]^.cant := 0;

  //<Variable> ::= “id” “:=” <Tipo>
  new(Tabla[V_Variable,T_id]);
  Tabla[V_Variable,T_id]^.elem[1] := T_id;
  Tabla[V_Variable,T_id]^.elem[2] := T_Asignacion;
  Tabla[V_Variable,T_id]^.elem[3] := V_Tipo;
  Tabla[V_Variable,T_id]^.cant := 3;

  //<Tipo> ::= “real”
  new(Tabla[V_Tipo,T_real]);
  Tabla[V_Tipo,T_real]^.elem[1] := T_real;
  Tabla[V_Tipo,T_real]^.cant := 1;

  //<Tipo> ::= “array” “{” <Arreglo> ”}”
  new(Tabla[V_Tipo,T_array]);
  Tabla[V_Tipo,T_array]^.elem[1] := T_array;
  Tabla[V_Tipo,T_array]^.elem[2] := T_abrirLlave;      //Agregar llaves
  Tabla[V_Tipo,T_array]^.elem[3] := T_cteReal;
  Tabla[V_Tipo,T_array]^.elem[4] := T_cerrarLlave;
  Tabla[V_Tipo,T_array]^.cant := 4;

  //<Arreglo> ::= “cteReal” <SigcteReal>
  new(Tabla[V_Arreglo,T_cteReal]);
  Tabla[V_Arreglo,T_cteReal]^.elem[1] := T_cteReal;
  Tabla[V_Arreglo,T_cteReal]^.elem[2] := V_SigCteReal;
  Tabla[V_Arreglo,T_cteReal]^.cant := 2;

  //<SigcteReal> ::= “,” <Arreglo>
  new(Tabla[V_SigcteReal,T_coma]);
  Tabla[V_SigcteReal,T_coma]^.elem[1] := T_coma;
  Tabla[V_SigcteReal,T_coma]^.elem[2] := V_Arreglo;
  Tabla[V_SigcteReal,T_coma]^.cant := 2;

  //<SigcteReal> ::= e
  new(Tabla[V_SigcteReal,T_cerrarLlave]);
  Tabla[V_SigcteReal,T_cerrarLlave]^.cant := 0;

  //<Sentencia> ::= <Asignacion>
  new(Tabla[V_Sentencia,T_id]);
  Tabla[V_Sentencia,T_id]^.elem[1] := V_Asignacion;
  Tabla[V_Sentencia,T_id]^.cant := 1;

  //<Sentencia> ::= <Lectura>
  new(Tabla[V_Sentencia,T_read]);
  Tabla[V_Sentencia,T_read]^.elem[1] := V_Lectura;
  Tabla[V_Sentencia,T_read]^.cant := 1;

  //<Sentencia> ::= <Escritura>
  new(Tabla[V_Sentencia,T_write]);
  Tabla[V_Sentencia,T_write]^.elem[1] := V_Escritura;
  Tabla[V_Sentencia,T_write]^.cant := 1;

  //<Sentencia> ::= <Condicional>
  new(Tabla[V_Sentencia,T_if]);
  Tabla[V_Sentencia,T_if]^.elem[1] := V_Condicional;
  Tabla[V_Sentencia,T_if]^.cant := 1;

  //<Sentencia> ::= <CicloW>
  new(Tabla[V_Sentencia,T_While]);
  Tabla[V_Sentencia,T_While]^.elem[1] := V_CicloW;
  Tabla[V_Sentencia,T_While]^.cant := 1;

  //<Sentencia> ::= <CicloF>
  new(Tabla[V_Sentencia,T_for]);
  Tabla[V_Sentencia,T_for]^.elem[1] := V_CicloF;
  Tabla[V_Sentencia,T_for]^.cant := 1;

  //<Asignacion> ::= “id” <Indice> “:=” <Suma>
  new(Tabla[V_Asignacion,T_id]);
  Tabla[V_Asignacion,T_id]^.elem[1] := T_id;
  Tabla[V_Asignacion,T_id]^.elem[2] := V_Indice;
  Tabla[V_Asignacion,T_id]^.elem[3] := T_asignacion;
  Tabla[V_Asignacion,T_id]^.elem[4] := V_Suma;
  Tabla[V_Asignacion,T_id]^.cant := 4;

  //<Suma> ::= <Producto> <SigOpSuma>
  new(Tabla[V_Suma,T_id]);
  Tabla[V_Suma,T_id]^.elem[1] := V_Producto;
  Tabla[V_Suma,T_id]^.elem[2] := V_SigOpSuma;
  Tabla[V_Suma,T_id]^.cant := 2;

  new(Tabla[V_Suma,T_cteReal]);
  Tabla[V_Suma,T_cteReal]^.elem[1] := V_Producto;
  Tabla[V_Suma,T_cteReal]^.elem[2] := V_SigOpSuma;
  Tabla[V_Suma,T_cteReal]^.cant := 2;

  new(Tabla[V_Suma,T_abrirLlave]);
  Tabla[V_Suma,T_abrirLlave]^.elem[1] := V_Producto;
  Tabla[V_Suma,T_abrirLlave]^.elem[2] := V_SigOpSuma;
  Tabla[V_Suma,T_abrirLlave]^.cant := 2;

  new(Tabla[V_Suma,T_abrirParentesis]);
  Tabla[V_Suma,T_abrirParentesis]^.elem[1] := V_Producto;
  Tabla[V_Suma,T_abrirParentesis]^.elem[2] := V_SigOpSuma;
  Tabla[V_Suma,T_abrirParentesis]^.cant := 2;

  //<SigOpSuma> ::= “+” <Producto> <SigOpSuma>
  new(Tabla[V_SigOpSuma,T_mas]);
  Tabla[V_SigOpSuma,T_mas]^.elem[1] := T_mas;
  Tabla[V_SigOpSuma,T_mas]^.elem[2] := V_Suma;
  Tabla[V_SigOpSuma,T_mas]^.cant := 2;

  //<SigOpSuma> ::= “-” <Producto> <SigOpSuma>
  new(Tabla[V_SigOpSuma,T_menos]);
  Tabla[V_SigOpSuma,T_menos]^.elem[1] := T_menos;
  Tabla[V_SigOpSuma,T_menos]^.elem[2] := V_Suma;
  Tabla[V_SigOpSuma,T_menos]^.cant := 2;

  //<SigOpSuma> ::= e
  new(Tabla[V_SigOpSuma,T_id]);
  Tabla[V_SigOpSuma,T_id]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_read]);
  Tabla[V_SigOpSuma,T_read]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_write]);
  Tabla[V_SigOpSuma,T_write]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_if]);
  Tabla[V_SigOpSuma,T_if]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_while]);
  Tabla[V_SigOpSuma,T_while]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_for]);
  Tabla[V_SigOpSuma,T_for]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_end]);
  Tabla[V_SigOpSuma,T_end]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_cerrarCorchete]);
  Tabla[V_SigOpSuma,T_cerrarCorchete]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_cerrarParentesis]);
  Tabla[V_SigOpSuma,T_cerrarParentesis]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_opRelacional]);
  Tabla[V_SigOpSuma,T_opRelacional]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_and]);
  Tabla[V_SigOpSuma,T_and]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_or]);
  Tabla[V_SigOpSuma,T_or]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_then]);
  Tabla[V_SigOpSuma,T_then]^.cant := 0;

  new(Tabla[V_SigOpSuma,T_do]);
  Tabla[V_SigOpSuma,T_do]^.cant := 0;

  //<Producto> ::= <Potencia> <SigOpProducto>
  new(Tabla[V_Producto,T_id]);
  Tabla[V_Producto,T_id]^.elem[1] := V_Potencia;
  Tabla[V_Producto,T_id]^.elem[2] := V_SigOpProducto;
  Tabla[V_Producto,T_id]^.cant := 2;

  new(Tabla[V_Producto,T_cteReal]);
  Tabla[V_Producto,T_cteReal]^.elem[1] := V_Potencia;
  Tabla[V_Producto,T_cteReal]^.elem[2] := V_SigOpProducto;
  Tabla[V_Producto,T_cteReal]^.cant := 2;

  new(Tabla[V_Producto,T_abrirLlave]);
  Tabla[V_Producto,T_abrirLlave]^.elem[1] := V_Potencia;
  Tabla[V_Producto,T_abrirLlave]^.elem[2] := V_SigOpProducto;
  Tabla[V_Producto,T_abrirLlave]^.cant := 2;

  new(Tabla[V_Producto,T_abrirParentesis]);
  Tabla[V_Producto,T_abrirParentesis]^.elem[1] := V_Potencia;
  Tabla[V_Producto,T_abrirParentesis]^.elem[2] := V_SigOpProducto;
  Tabla[V_Producto,T_abrirParentesis]^.cant := 2;

  //<SigOpProducto>::= “*” <Producto>
  new(Tabla[V_SigOpProducto,T_multiplicacion]);
  Tabla[V_SigOpProducto,T_multiplicacion]^.elem[1] := T_multiplicacion;
  Tabla[V_SigOpProducto,T_multiplicacion]^.elem[2] := V_Producto;
  Tabla[V_SigOpProducto,T_multiplicacion]^.cant := 2;

  //<SigOpProducto>::= “/” <Producto>
  new(Tabla[V_SigOpProducto,T_division]);
  Tabla[V_SigOpProducto,T_division]^.elem[1] := T_division;
  Tabla[V_SigOpProducto,T_division]^.elem[2] := V_Producto;
  Tabla[V_SigOpProducto,T_division]^.cant := 2;

  //<SigOpProducto>::= e
  new(Tabla[V_SigOpProducto,T_id]);
  Tabla[V_SigOpProducto,T_id]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_read]);
  Tabla[V_SigOpProducto,T_read]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_write]);
  Tabla[V_SigOpProducto,T_write]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_if]);
  Tabla[V_SigOpProducto,T_if]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_while]);
  Tabla[V_SigOpProducto,T_while]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_for]);
  Tabla[V_SigOpProducto,T_for]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_end]);
  Tabla[V_SigOpProducto,T_end]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_cerrarCorchete]);
  Tabla[V_SigOpProducto,T_cerrarCorchete]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_cerrarParentesis]);
  Tabla[V_SigOpProducto,T_cerrarParentesis]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_mas]);
  Tabla[V_SigOpProducto,T_mas]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_menos]);
  Tabla[V_SigOpProducto,T_menos]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_opRelacional]);
  Tabla[V_SigOpProducto,T_opRelacional]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_and]);
  Tabla[V_SigOpProducto,T_and]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_or]);
  Tabla[V_SigOpProducto,T_or]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_then]);
  Tabla[V_SigOpProducto,T_then]^.cant:= 0;

  new(Tabla[V_SigOpProducto,T_do]);
  Tabla[V_SigOpProducto,T_do]^.cant:= 0;

  //<Potencia> ::= “(“ <Suma> ”)”  <SigPotencia>
  new(Tabla[V_Potencia,T_abrirParentesis]);
  Tabla[V_Potencia,T_abrirParentesis]^.elem[1] := T_abrirParentesis;
  Tabla[V_Potencia,T_abrirParentesis]^.elem[2] := V_Suma;
  Tabla[V_Potencia,T_abrirParentesis]^.elem[3] := T_cerrarParentesis;
  Tabla[V_Potencia,T_abrirParentesis]^.elem[4] := V_SigPotencia;
  Tabla[V_Potencia,T_abrirParentesis]^.cant := 4;

  //<Potencia> ::= <Numero>
  new(Tabla[V_Potencia,T_id]);
  Tabla[V_Potencia,T_id]^.elem[1] := V_Numero;
  Tabla[V_Potencia,T_id]^.cant := 1;

  new(Tabla[V_Potencia,T_cteReal]);
  Tabla[V_Potencia,T_cteReal]^.elem[1] := V_Numero;
  Tabla[V_Potencia,T_cteReal]^.cant := 1;

  new(Tabla[V_Potencia,T_abrirLlave]);
  Tabla[V_Potencia,T_abrirLlave]^.elem[1] := V_Numero;
  Tabla[V_Potencia,T_abrirLlave]^.cant := 1;

  //<SigPotencia> ::= “^” “(“ <Numero> ”)”
  new(Tabla[V_SigPotencia,T_potencia]);
  Tabla[V_SigPotencia,T_potencia]^.elem[1] := T_Potencia;
  Tabla[V_SigPotencia,T_potencia]^.elem[2] := T_abrirParentesis;
  Tabla[V_SigPotencia,T_potencia]^.elem[3] := V_Numero;
  Tabla[V_SigPotencia,T_potencia]^.elem[4] := T_cerrarParentesis;
  Tabla[V_SigPotencia,T_potencia]^.cant := 4;

  //<SigPotencia> ::= “root” “(“ <Numero> ”)”
  new(Tabla[V_SigPotencia,T_root]);
  Tabla[V_SigPotencia,T_root]^.elem[1] := T_root;
  Tabla[V_SigPotencia,T_root]^.elem[2] := T_abrirParentesis;
  Tabla[V_SigPotencia,T_root]^.elem[3] := V_Numero;
  Tabla[V_SigPotencia,T_root]^.elem[4] := T_cerrarParentesis;
  Tabla[V_SigPotencia,T_root]^.cant := 4;

  //<SigPotencia> ::= e
  new(Tabla[V_SigPotencia,T_id]);
  Tabla[V_SigPotencia,T_id]^.cant := 0;

  new(Tabla[V_SigPotencia,T_read]);
  Tabla[V_SigPotencia,T_read]^.cant := 0;

  new(Tabla[V_SigPotencia,T_write]);
  Tabla[V_SigPotencia,T_write]^.cant := 0;

  new(Tabla[V_SigPotencia,T_if]);
  Tabla[V_SigPotencia,T_if]^.cant := 0;

  new(Tabla[V_SigPotencia,T_while]);
  Tabla[V_SigPotencia,T_while]^.cant := 0;

  new(Tabla[V_SigPotencia,T_for]);
  Tabla[V_SigPotencia,T_for]^.cant := 0;

  new(Tabla[V_SigPotencia,T_end]);
  Tabla[V_SigPotencia,T_end]^.cant := 0;

  new(Tabla[V_SigPotencia,T_cerrarCorchete]);
  Tabla[V_SigPotencia,T_cerrarCorchete]^.cant := 0;

  new(Tabla[V_SigPotencia,T_cerrarParentesis]);
  Tabla[V_SigPotencia,T_cerrarParentesis]^.cant := 0;

  new(Tabla[V_SigPotencia,T_mas]);
  Tabla[V_SigPotencia,T_mas]^.cant := 0;

  new(Tabla[V_SigPotencia,T_menos]);
  Tabla[V_SigPotencia,T_menos]^.cant := 0;

  new(Tabla[V_SigPotencia,T_multiplicacion]);
  Tabla[V_SigPotencia,T_multiplicacion]^.cant := 0;

  new(Tabla[V_SigPotencia,T_division]);
  Tabla[V_SigPotencia,T_division]^.cant := 0;

  new(Tabla[V_SigPotencia,T_opRelacional]);
  Tabla[V_SigPotencia,T_opRelacional]^.cant := 0;

  new(Tabla[V_SigPotencia,T_and]);
  Tabla[V_SigPotencia,T_and]^.cant := 0;

  new(Tabla[V_SigPotencia,T_or]);
  Tabla[V_SigPotencia,T_or]^.cant := 0;

  new(Tabla[V_SigPotencia,T_then]);
  Tabla[V_SigPotencia,T_then]^.cant := 0;

  new(Tabla[V_SigPotencia,T_do]);
  Tabla[V_SigPotencia,T_do]^.cant := 0;

  //<Numero> ::= “cteReal”
  new(Tabla[V_Numero,T_cteReal]);
  Tabla[V_Numero,T_cteReal]^.elem[1] := T_cteReal;
  Tabla[V_Numero,T_cteReal]^.cant := 1;

  //<Numero> ::= “{“ <Arreglo> ”}”
  new(Tabla[V_Numero,T_abrirLlave]);
  Tabla[V_Numero,T_abrirLlave]^.elem[1] := T_abrirLlave;
  Tabla[V_Numero,T_abrirLlave]^.elem[2] := V_Arreglo;
  Tabla[V_Numero,T_abrirLlave]^.elem[3] := T_cerrarLlave;
  Tabla[V_Numero,T_abrirLlave]^.cant := 3;

  //<Numero> ::= “id” <Indice>
  new(Tabla[V_Numero,T_id]);
  Tabla[V_Numero,T_id]^.elem[1] := T_id;
  Tabla[V_Numero,T_id]^.elem[2] := V_Indice;
  Tabla[V_Numero,T_id]^.cant := 2;

  //<Indice> ::= “[” <Suma> “]”
  new(Tabla[V_Indice,T_abrirCorchete]);
  Tabla[V_Indice,T_abrirCorchete]^.elem[1]:= T_abrirCorchete;
  Tabla[V_Indice,T_abrirCorchete]^.elem[2]:= V_Suma;
  Tabla[V_Indice,T_abrirCorchete]^.elem[3]:= T_cerrarCorchete;
  Tabla[V_Indice,T_abrirCorchete]^.cant := 3;

  //<Indice> ::= e
  new(Tabla[V_Indice,T_id]);
  Tabla[V_Indice,T_id]^.cant := 0;

  new(Tabla[V_Indice,T_read]);
  Tabla[V_Indice,T_read]^.cant := 0;

  new(Tabla[V_Indice,T_write]);
  Tabla[V_Indice,T_write]^.cant := 0;

  new(Tabla[V_Indice,T_if]);
  Tabla[V_Indice,T_if]^.cant := 0;

  new(Tabla[V_Indice,T_while]);
  Tabla[V_Indice,T_while]^.cant := 0;

  new(Tabla[V_Indice,T_for]);
  Tabla[V_Indice,T_for]^.cant := 0;

  new(Tabla[V_Indice,T_end]);
  Tabla[V_Indice,T_end]^.cant := 0;

  new(Tabla[V_Indice,T_cerrarCorchete]);
  Tabla[V_Indice,T_cerrarCorchete]^.cant := 0;

  new(Tabla[V_Indice,T_cerrarParentesis]);
  Tabla[V_Indice,T_cerrarParentesis]^.cant := 0;

  new(Tabla[V_Indice,T_mas]);
  Tabla[V_Indice,T_mas]^.cant := 0;

  new(Tabla[V_Indice,T_menos]);
  Tabla[V_Indice,T_menos]^.cant := 0;

  new(Tabla[V_Indice,T_multiplicacion]);
  Tabla[V_Indice,T_multiplicacion]^.cant := 0;

  new(Tabla[V_Indice,T_division]);
  Tabla[V_Indice,T_division]^.cant := 0;

  new(Tabla[V_Indice,T_opRelacional]);
  Tabla[V_Indice,T_opRelacional]^.cant := 0;

  new(Tabla[V_Indice,T_and]);
  Tabla[V_Indice,T_and]^.cant := 0;

  new(Tabla[V_Indice,T_or]);
  Tabla[V_Indice,T_or]^.cant := 0;

  new(Tabla[V_Indice,T_then]);
  Tabla[V_Indice,T_then]^.cant := 0;

  new(Tabla[V_Indice,T_do]);
  Tabla[V_Indice,T_do]^.cant := 0;

  new(Tabla[V_Indice,T_to]);
  Tabla[V_Indice,T_to]^.cant := 0;

  new(Tabla[V_Indice,T_asignacion]);
  Tabla[V_Indice,T_asignacion]^.cant := 0;

  //<Lectura> ::= ”Read” “(“ “cteCadena” “id” “)”
  new(Tabla[V_Lectura,T_read]);
  Tabla[V_Lectura,T_read]^.elem[1] := T_read;
  Tabla[V_Lectura,T_read]^.elem[2] := T_abrirParentesis;
  Tabla[V_Lectura,T_read]^.elem[3] := T_Cadena;
  Tabla[V_Lectura,T_read]^.elem[4] := T_id;
  Tabla[V_Lectura,T_read]^.elem[5] := T_cerrarParentesis;
  Tabla[V_Lectura,T_read]^.cant := 5;

  //<Escritura> ::= “Write” “(“ SigEscritura
  new(Tabla[V_Escritura,T_write]);
  Tabla[V_Escritura,T_write]^.elem[1] := T_write;
  Tabla[V_Escritura,T_write]^.elem[2] := T_abrirParentesis;
  Tabla[V_Escritura,T_write]^.elem[3] := V_SigEscritura;
  Tabla[V_Escritura,T_write]^.cant := 3;

  //<SigEscritura> ::= “cteCadena” “)”
  new(Tabla[V_SigEscritura,T_cadena]);
  Tabla[V_SigEscritura,T_cadena]^.elem[1] := T_cadena;
  Tabla[V_SigEscritura,T_cadena]^.elem[2] := T_cerrarParentesis;
  Tabla[V_SigEscritura,T_cadena]^.cant := 2;

  //<SigEscritura> ::= <Suma> “)”
  new(Tabla[V_SigEscritura,T_id]);
  Tabla[V_SigEscritura,T_id]^.elem[1] := V_Suma;
  Tabla[V_SigEscritura,T_id]^.elem[2] := T_cerrarParentesis;
  Tabla[V_SigEscritura,T_id]^.cant := 2;

  new(Tabla[V_SigEscritura,T_cteReal]);
  Tabla[V_SigEscritura,T_cteReal]^.elem[1] := V_Suma;
  Tabla[V_SigEscritura,T_cteReal]^.elem[2] := T_cerrarParentesis;
  Tabla[V_SigEscritura,T_cteReal]^.cant := 2;

  new(Tabla[V_SigEscritura,T_abrirLlave]);
  Tabla[V_SigEscritura,T_abrirLlave]^.elem[1] := V_Suma;
  Tabla[V_SigEscritura,T_abrirLlave]^.elem[2] := T_cerrarParentesis;
  Tabla[V_SigEscritura,T_abrirLlave]^.cant := 2;

  new(Tabla[V_SigEscritura,T_abrirParentesis]);
  Tabla[V_SigEscritura,T_abrirParentesis]^.elem[1] := V_Suma;
  Tabla[V_SigEscritura,T_abrirParentesis]^.elem[2] := T_cerrarParentesis;
  Tabla[V_SigEscritura,T_abrirParentesis]^.cant := 2;

  //<CicloW> ::= “While”  <Cond>  “do” “begin” <Cuerpo> “end” “;”
  new(Tabla[V_CicloW,T_while]);
  Tabla[V_CicloW,T_while]^.elem[1] := T_while;
  Tabla[V_CicloW,T_while]^.elem[2] := V_Cond;
  Tabla[V_CicloW,T_while]^.elem[3] := T_do;
  Tabla[V_CicloW,T_while]^.elem[4] := T_begin;
  Tabla[V_CicloW,T_while]^.elem[5] := V_Cuerpo;
  Tabla[V_CicloW,T_while]^.elem[6] := T_end;
  Tabla[V_CicloW,T_while]^.elem[7] := T_puntoComa;
  Tabla[V_CicloW,T_while]^.cant := 7;

  //<CicloF> ::= “For” “[“ “id” “:=” <SigCiclo>
  new(Tabla[V_CicloF,T_for]);
  Tabla[V_CicloF,T_for]^.elem[1] := T_for;
  Tabla[V_CicloF,T_for]^.elem[2] := T_abrirCorchete;
  Tabla[V_CicloF,T_for]^.elem[3] := T_id;
  Tabla[V_CicloF,T_for]^.elem[4] := T_asignacion;
  Tabla[V_CicloF,T_for]^.elem[5] := V_SigCiclo;
  Tabla[V_CicloF,T_for]^.cant := 5;

  //<SigCiclo> ::= “cteReal” “to” <SigCiclocteReal>
  new(Tabla[V_SigCiclo,T_cteReal]);
  Tabla[V_SigCiclo,T_cteReal]^.elem[1] := T_cteReal;
  Tabla[V_SigCiclo,T_cteReal]^.elem[2] := T_to;
  Tabla[V_SigCiclo,T_cteReal]^.elem[3] := V_FinalCiclo;
  Tabla[V_SigCiclo,T_cteReal]^.cant := 3;

  //<SigCiclo> ::= “id” <Indice> “to” <SigCicloid>
  new(Tabla[V_SigCiclo,T_id]);
  Tabla[V_SigCiclo,T_id]^.elem[1] := T_id;
  Tabla[V_SigCiclo,T_id]^.elem[2] := V_Indice;
  Tabla[V_SigCiclo,T_id]^.elem[3] := T_to;
  Tabla[V_SigCiclo,T_id]^.elem[4] := V_FinalCiclo;
  Tabla[V_SigCiclo,T_id]^.cant := 4;

  //<FinalCiclo> ::=  “cteReal” “]” “begin” <Cuerpo> “end” “;”
  new(Tabla[V_FinalCiclo,T_cteReal]);
  Tabla[V_FinalCiclo,T_cteReal]^.elem[1] := T_cteReal;
  Tabla[V_FinalCiclo,T_cteReal]^.elem[2] := T_cerrarCorchete;
  Tabla[V_FinalCiclo,T_cteReal]^.elem[3] := T_begin;
  Tabla[V_FinalCiclo,T_cteReal]^.elem[4] := V_Cuerpo;
  Tabla[V_FinalCiclo,T_cteReal]^.elem[5] := T_end;
  Tabla[V_FinalCiclo,T_cteReal]^.elem[6] := T_puntoComa;
  Tabla[V_FinalCiclo,T_cteReal]^.cant := 6;

  //<FinalCiclo> ::=  “id” <Indice> “]” “begin” <Cuerpo> “end” “;”
  new(Tabla[V_FinalCiclo,T_id]);
  Tabla[V_FinalCiclo,T_id]^.elem[1] := T_id;
  Tabla[V_FinalCiclo,T_id]^.elem[2] := V_Indice;
  Tabla[V_FinalCiclo,T_id]^.elem[3] := T_cerrarCorchete;
  Tabla[V_FinalCiclo,T_id]^.elem[4] := T_begin;
  Tabla[V_FinalCiclo,T_id]^.elem[5] := V_Cuerpo;
  Tabla[V_FinalCiclo,T_id]^.elem[6] := T_end;
  Tabla[V_FinalCiclo,T_id]^.elem[7] := T_puntoComa;
  Tabla[V_FinalCiclo,T_id]^.cant := 7;


  //<Condicional> ::= “If” <Cond> “then” “begin” <Cuerpo> “end” “;”
  new(Tabla[V_Condicional,T_if]);
  Tabla[V_Condicional,T_if]^.elem[1] := T_if;
  Tabla[V_Condicional,T_if]^.elem[2] := V_Cond;
  Tabla[V_Condicional,T_if]^.elem[3] := T_then;
  Tabla[V_Condicional,T_if]^.elem[4] := T_begin;
  Tabla[V_Condicional,T_if]^.elem[5] := V_Cuerpo;
  Tabla[V_Condicional,T_if]^.elem[6] := T_end;
  Tabla[V_Condicional,T_if]^.elem[7] := T_puntoComa;
  Tabla[V_Condicional,T_if]^.cant := 7;

  //<CondRel> ::= <Suma> “opRel” <Suma>
  new(Tabla[V_CondRel,T_id]);
  Tabla[V_CondRel,T_id]^.elem[1] := V_Suma;
  Tabla[V_CondRel,T_id]^.elem[2] := T_opRelacional;
  Tabla[V_CondRel,T_id]^.elem[3] := V_Suma;
  Tabla[V_CondRel,T_id]^.cant := 3;

  new(Tabla[V_CondRel,T_abrirLlave]);
  Tabla[V_CondRel,T_abrirLlave]^.elem[1] := V_Suma;
  Tabla[V_CondRel,T_abrirLlave]^.elem[2] := T_opRelacional;
  Tabla[V_CondRel,T_abrirLlave]^.elem[3] := V_Suma;
  Tabla[V_CondRel,T_abrirLlave]^.cant := 3;

  new(Tabla[V_CondRel,T_cteReal]);
  Tabla[V_CondRel,T_cteReal]^.elem[1] := V_Suma;
  Tabla[V_CondRel,T_cteReal]^.elem[2] := T_opRelacional;
  Tabla[V_CondRel,T_cteReal]^.elem[3] := V_Suma;
  Tabla[V_CondRel,T_cteReal]^.cant := 3;

  new(Tabla[V_CondRel,T_abrirParentesis]);
  Tabla[V_CondRel,T_abrirParentesis]^.elem[1] := V_Suma;
  Tabla[V_CondRel,T_abrirParentesis]^.elem[2] := T_opRelacional;
  Tabla[V_CondRel,T_abrirParentesis]^.elem[3] := V_Suma;
  Tabla[V_CondRel,T_abrirParentesis]^.cant := 3;

  //<Cond> ::= <CondAnd> <SigCond>
  new(Tabla[V_Cond,T_id]);
  Tabla[V_Cond,T_id]^.elem[1] := V_CondAnd;
  Tabla[V_Cond,T_id]^.elem[2] := V_SigCond;
  Tabla[V_Cond,T_id]^.cant := 2;

  new(Tabla[V_Cond,T_cteReal]);
  Tabla[V_Cond,T_cteReal]^.elem[1] := V_CondAnd;
  Tabla[V_Cond,T_cteReal]^.elem[2] := V_SigCond;
  Tabla[V_Cond,T_cteReal]^.cant := 2;

  new(Tabla[V_Cond,T_abrirLlave]);
  Tabla[V_Cond,T_abrirLlave]^.elem[1] := V_CondAnd;
  Tabla[V_Cond,T_abrirLlave]^.elem[2] := V_SigCond;
  Tabla[V_Cond,T_abrirLlave]^.cant := 2;

  new(Tabla[V_Cond,T_abrirCorchete]);
  Tabla[V_Cond,T_abrirCorchete]^.elem[1] := V_CondAnd;
  Tabla[V_Cond,T_abrirCorchete]^.elem[2] := V_SigCond;
  Tabla[V_Cond,T_abrirCorchete]^.cant := 2;

  new(Tabla[V_Cond,T_abrirParentesis]);
  Tabla[V_Cond,T_abrirParentesis]^.elem[1] := V_CondAnd;
  Tabla[V_Cond,T_abrirParentesis]^.elem[2] := V_SigCond;
  Tabla[V_Cond,T_abrirParentesis]^.cant := 2;

  new(Tabla[V_Cond,T_not]);
  Tabla[V_Cond,T_not]^.elem[1] := V_CondAnd;
  Tabla[V_Cond,T_not]^.elem[2] := V_SigCond;
  Tabla[V_Cond,T_not]^.cant := 2;

  //<SigCond> ::= “or” <Cond>
  new(Tabla[V_SigCond,T_or]);
  Tabla[V_SigCond,T_or]^.elem[1] := T_or;
  Tabla[V_SigCond,T_or]^.elem[2] := V_Cond;
  Tabla[V_SigCond,T_or]^.cant := 2;

  //<SigCond> ::= e
  new(Tabla[V_SigCond,T_cerrarCorchete]);
  Tabla[V_SigCond,T_cerrarCorchete]^.cant := 0;

  new(Tabla[V_SigCond,T_then]);
  Tabla[V_SigCond,T_then]^.cant := 0;

  new(Tabla[V_SigCond,T_do]);
  Tabla[V_SigCond,T_do]^.cant := 0;

  //<CondAnd> ::= <CondNot> <SigCondAnd>
  new(Tabla[V_CondAnd,T_id]);
  Tabla[V_CondAnd,T_id]^.elem[1] := V_CondNot;
  Tabla[V_CondAnd,T_id]^.elem[2] := V_SigCondAnd;
  Tabla[V_CondAnd,T_id]^.cant := 2;

  new(Tabla[V_CondAnd,T_cteReal]);
  Tabla[V_CondAnd,T_cteReal]^.elem[1] := V_CondNot;
  Tabla[V_CondAnd,T_cteReal]^.elem[2] := V_SigCondAnd;
  Tabla[V_CondAnd,T_cteReal]^.cant := 2;

  new(Tabla[V_CondAnd,T_abrirLlave]);
  Tabla[V_CondAnd,T_abrirLlave]^.elem[1] := V_CondNot;
  Tabla[V_CondAnd,T_abrirLlave]^.elem[2] := V_SigCondAnd;
  Tabla[V_CondAnd,T_abrirLlave]^.cant := 2;

  new(Tabla[V_CondAnd,T_abrirCorchete]);
  Tabla[V_CondAnd,T_abrirCorchete]^.elem[1] := V_CondNot;
  Tabla[V_CondAnd,T_abrirCorchete]^.elem[2] := V_SigCondAnd;
  Tabla[V_CondAnd,T_abrirCorchete]^.cant := 2;

  new(Tabla[V_CondAnd,T_abrirParentesis]);
  Tabla[V_CondAnd,T_abrirParentesis]^.elem[1] := V_CondNot;
  Tabla[V_CondAnd,T_abrirParentesis]^.elem[2] := V_SigCondAnd;
  Tabla[V_CondAnd,T_abrirParentesis]^.cant := 2;

  new(Tabla[V_CondAnd,T_not]);
  Tabla[V_CondAnd,T_not]^.elem[1] := V_CondNot;
  Tabla[V_CondAnd,T_not]^.elem[2] := V_SigCondAnd;
  Tabla[V_CondAnd,T_not]^.cant := 2;

  //<SigCondAnd> ::= “and” <CondNot> <SigCondAnd>
  new(Tabla[V_SigCondAnd,T_and]);
  Tabla[V_SigCondAnd,T_and]^.elem[1] := T_and;
  Tabla[V_SigCondAnd,T_and]^.elem[2] := V_CondAnd;
  Tabla[V_SigCondAnd,T_and]^.cant := 2;

  //<SigCondAnd> ::= e
  new(Tabla[V_SigCondAnd,T_cerrarCorchete]);
  Tabla[V_SigCondAnd,T_cerrarCorchete]^.cant := 0;

  new(Tabla[V_SigCondAnd,T_or]);
  Tabla[V_SigCondAnd,T_or]^.cant := 0;

  new(Tabla[V_SigCondAnd,T_then]);
  Tabla[V_SigCondAnd,T_then]^.cant := 0;

  new(Tabla[V_SigCondAnd,T_do]);
  Tabla[V_SigCondAnd,T_do]^.cant := 0;

  //<CondNot> ::= “not” <CondNot>
  new(Tabla[V_CondNot,T_not]);
  Tabla[V_CondNot,T_not]^.elem[1] := T_not;
  Tabla[V_CondNot,T_not]^.elem[2] := V_CondNot;
  Tabla[V_CondNot,T_not]^.cant := 2;

  //<CondNot> ::= “[” <Cond> “]”
  new(Tabla[V_CondNot,T_abrirCorchete]);
  Tabla[V_CondNot,T_abrirCorchete]^.elem[1] := T_abrirCorchete;
  Tabla[V_CondNot,T_abrirCorchete]^.elem[2] := V_Cond;
  Tabla[V_CondNot,T_abrirCorchete]^.elem[3] := T_cerrarCorchete;
  Tabla[V_CondNot,T_abrirCorchete]^.cant := 3;

  //<CondNot> ::= <CondRel>
  new(Tabla[V_CondNot,T_id]);
  Tabla[V_CondNot,T_id]^.elem[1] := V_CondRel;
  Tabla[V_CondNot,T_id]^.cant := 1;

  new(Tabla[V_CondNot,T_cteReal]);
  Tabla[V_CondNot,T_cteReal]^.elem[1] := V_CondRel;
  Tabla[V_CondNot,T_cteReal]^.cant := 1;

  new(Tabla[V_CondNot,T_abrirLlave]);
  Tabla[V_CondNot,T_abrirLlave]^.elem[1] := V_CondRel;
  Tabla[V_CondNot,T_abrirLlave]^.cant := 1;

  new(Tabla[V_CondNot,T_abrirParentesis]);
  Tabla[V_CondNot,T_abrirParentesis]^.elem[1] := V_CondRel;
  Tabla[V_CondNot,T_abrirParentesis]^.cant := 1;

 end;

procedure AnalizSintactico(var A:T_Arbol; var Fuente:Archivo; var correcto: boolean);
 type
  estado = (enProceso,exito,errorLexico,errorSintactico);
 var
  Tabla:TAS;
  P:T_pila;
  ComponenteLexico:simbolos;
  Control:longint;
  Lexema:string;
  listaSimbolos:T_Lista;
  Est:estado;
  datoPila:T_dato_P;
  i,j:integer;
  Hijo:T_Arbol;
  Simbolo:simbolos;
  Aux1,Aux2:T_Arbol;

begin
 CargarSimbolosEnLista(listaSimbolos);
 CargarTAS(Tabla);
 CrearPila(P);
 datoPila.simb:=pesos;
 datoPila.arbol:=nil;
 Apilar(P,datoPila);
 datoPila.simb:=V_Program;
 CrearArbol(A,V_Program);
 datoPila.arbol:=A;
 Apilar(P,datoPila);
 control:=0;
 Est := enProceso;
 SiguienteComponenteLexico(Fuente,control,ComponenteLexico,lexema,listaSimbolos);
 while Est = enProceso do
      begin
      Desapilar(P,datoPila);
      if datoPila.simb in [T_begin..T_to] then
      begin
           if datoPila.simb = ComponenteLexico then
           begin
            datoPila.arbol^.lexema:=lexema;
            SiguienteComponenteLexico(Fuente,control,ComponenteLexico,lexema,listaSimbolos);
           end
      else
      begin
           Est:=errorSintactico;
           correcto := false;
           writeln('Error Sintactico, se esperaba ',datoPila.simb,', pero se obtuvo ',ComponenteLexico);
           readkey();
      end;
      end
      else
      if datoPila.simb in [V_program..V_CondNot] then
      begin
      if Tabla[datoPila.simb,ComponenteLexico] = nil then
      begin
           Est:= errorSintactico;
           writeln('Fila: ',datoPila.simb,', Columna: ',ComponenteLexico);
           writeln('Error Sintactico, no es posible llegar desde ',datoPila.simb,' a ',ComponenteLexico);
           correcto := false;
           readkey();
      end
      else
      begin
      for i := 1 to Tabla[datoPila.simb,ComponenteLexico]^.cant do
      begin
           Simbolo := Tabla[datoPila.simb,ComponenteLexico]^.elem[i];
           CrearArbol(Hijo,Simbolo);
           AgregarHijo(datoPila.arbol,Hijo);
      end;
      aux1:=datoPila.arbol;
      for j:= aux1^.cant downto 1 do
           begin
           aux2:=aux1^.hijos[j];
           datoPila.simb:=aux2^.simbolo;
           datoPila.arbol:=aux2;
           Apilar(P,datoPila);
           end;
      end;
      end
      else
      if (datoPila.simb = pesos) and (datoPila.simb = ComponenteLexico) then
      begin
       Est := exito;
       correcto := true;
      end
      else
      if (datoPila.simb = error) then
      begin
       writeln('Error Lexico');
       Est := errorLexico;
       correcto := false;
       readkey();
      end;
      end;
 end;

end.

