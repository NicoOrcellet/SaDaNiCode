unit Evaluador;



interface

uses
  defTipos, Math, crt;

const
  maxestado = 100;

type
  tipoVariable = (T_cteReal,T_array);

  arreglo = array[1..maxestado] of real;

  T_elemento = record
    nombre: string;
    tamanio: 1..maxestado;
    tipo: tipoVariable;
    valorReal: real;
    valorArray: arreglo;
  end;

  T_Estado = record
    elementos: array [1..maxestado] of T_elemento;
    cant: integer;
  end;

procedure InicializarEstado(var Estado: T_Estado);
procedure EvaluarProgram(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarSigVariable(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarCuerpo(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarSigSentencia(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarVariable(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarTipo(var arbol: T_Arbol; var Tipo: tipoVariable; var Tam:integer);
procedure EvaluarArreglo(var arbol: T_Arbol; var estado: T_Estado; var nuevoArray: arreglo; var pos:integer);
procedure EvaluarSigcteReal(var arbol: T_Arbol; var estado: T_Estado; var nuevoArray: arreglo; var pos:integer);
procedure EvaluarSentencia(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarAsignacion(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarSuma(var arbol: T_Arbol; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
procedure EvaluarSigOpSuma(var arbol: T_Arbol; var estado: T_Estado; operando1 :real; operando2:arreglo ; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; tipo2: tipoVariable; var pos: integer);
procedure EvaluarProducto(var arbol: T_Arbol; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
procedure EvaluarSigOpProducto(var arbol: T_Arbol; var estado: T_Estado; operando1:real; operando2:arreglo ; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var tipo2: tipoVariable; var pos: integer);
procedure EvaluarPotencia(var arbol: T_Arbol; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
procedure EvaluarSigPotencia(var arbol: T_Arbol; var estado: T_Estado; operando1:real; operando2:arreglo ; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var tipo2: tipoVariable; var pos: integer);
procedure EvaluarNumero(var arbol: T_Arbol; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
procedure EvaluarIndice(var arbol: T_Arbol; var nombre_id: string; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
procedure EvaluarLectura(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarEscritura(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarSigEscritura(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarCicloW(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarCicloF(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarSigCiclo(lexema: string; var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarFinalCiclo(var arbol: T_Arbol; var lexema: string; resultado1: real; var estado: T_Estado);
procedure EvaluarCondicional(var arbol: T_Arbol; var estado: T_Estado);
procedure EvaluarCondRel(var arbol: T_Arbol; var estado: T_Estado; var valor:boolean);
procedure EvaluarCond(var arbol: T_Arbol; var estado: T_Estado; var valor:boolean);
procedure EvaluarSigCond(var arbol: T_Arbol; var estado: T_Estado;var aux: boolean; var valor:boolean);
procedure EvaluarCondAnd(var arbol: T_Arbol; var estado: T_Estado; var valor:boolean);
procedure EvaluarSigCondAnd(var arbol: T_Arbol; var estado: T_Estado;var aux: boolean; var valor:boolean);
procedure EvaluarCondNot(var arbol: T_Arbol; var estado: T_Estado; var valor:boolean);

implementation

procedure InicializarEstado(var Estado: T_Estado);
var
  i :integer;
begin
  For i := 1 to 100 do
  begin
    Estado.elementos[i].nombre:= '}';
  end;
  Estado.cant:= 0;
end;

procedure CargarVariable(var nom: string; var estado: T_Estado; var t: tipoVariable; tam: integer);
begin
  inc(Estado.cant);
  Estado.elementos[Estado.cant].nombre := nom;
  Estado.elementos[Estado.cant].tipo := t;
  Estado.elementos[Estado.cant].tamanio := tam;
end;

procedure BuscarId (var estado: T_Estado; var lexema: string;var encontrado:boolean; var tipo: tipoVariable);
var
  i:integer;
begin
  i := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.elementos[i].nombre = lexema then
      begin
        encontrado:= true;
        tipo := estado.elementos[i].tipo;
      end
    else
    inc(i);
  end;
end;

procedure GuardarVariableReal(nombre_id: string;var estado: T_estado; resultado: real);
var
  i:integer;
  encontrado: boolean;
begin
  i := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.elementos[i].nombre = nombre_id then
      begin
        estado.elementos[i].valorReal := resultado;
        encontrado := true;
      end
    else
    inc(i);
  end;
end;


procedure GuardarVariableArreglo(nombre_id: string; var estado: T_estado; resultado: arreglo; pos: integer);
var
  i,j,k:integer;
  encontrado: boolean;
begin
  i := 1;
  j := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.elementos[i].nombre = nombre_id then
      begin
        encontrado := true;
        if pos < estado.elementos[i].tamanio then
        begin
          while j <= pos do
          begin
            estado.elementos[i].valorArray[j] := resultado[j];
            inc(j);
          end;
          while j <= estado.elementos[i].tamanio do
          begin
            estado.elementos[i].valorArray[j] := 0;
            inc(j);
          end;
        end
        else
        begin
          while j <= estado.elementos[i].tamanio do
          begin
            estado.elementos[i].valorArray[j] := resultado[j];
            inc(j);
          end;
        end;
      end
    else
    inc(i);
  end;
end;

procedure ConseguirElementoEnArreglo(estado: T_estado; nombre_id: string; pos: integer;var resultado: real);
var
  i:integer;
  encontrado:boolean;
begin
  i := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.elementos[i].nombre = nombre_id then
      begin
        resultado := estado.elementos[i].valorArray[pos];
        encontrado:= true;
      end
    else
    inc(i);
  end;
end;

procedure ConseguirValorReal(estado: T_estado; nombre_id: string; var resultado: real);
var
  i:integer;
  encontrado:boolean;

begin
  i := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.elementos[i].nombre = nombre_id then
      begin
        resultado := estado.elementos[i].valorReal;
        encontrado:= true;
      end
    else
    inc(i);
  end;
end;

procedure ConseguirArreglo(estado: T_estado; nombre_id: string; var resultado: arreglo; var pos: integer);
var
  i:integer;
  encontrado:boolean;
begin
  i := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.elementos[i].nombre = nombre_id then
      begin
        resultado := estado.elementos[i].valorArray;
        pos := estado.elementos[i].tamanio;
        encontrado:= true;
      end
    else
    inc(i);
  end;
end;

procedure EvaluarTamanio(estado: T_estado; nombre_id: string; var tam: integer);
var
  i:integer;
  encontrado:boolean;
begin
  i := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.elementos[i].nombre = nombre_id then
      begin
        tam := estado.elementos[i].tamanio;
        encontrado := true;
      end
    else inc(i);
  end;
end;

procedure TransformarEnArreglo(cadena : string; var nuevoArray: arreglo; var tam:integer);
var
  i,j,k:integer;
  aux: real;
  final:boolean;
begin
  i := 2;
  j := 1;
  while (i < length(cadena)) do
  begin
    k := i;
    final:= false;
    while (k <= length(cadena)) and (not final) do
    begin
      if cadena[k] <> ',' then
        begin
          if cadena[k] = '}' then
            begin
              final := true;
            end
          else
          begin
            inc(k);
          end;
        end
      else
      begin
        final := true;
      end;
    end;
    val(copy(cadena,i,(k-i)),aux);
    nuevoArray[j] := aux;
    i := k + 1;
    inc(j);
  end;
  while j <= tam do
  begin
    nuevoArray[j] := 0;
    inc(j);
  end;
end;

procedure GuardarElementoEnArreglo(var estado: T_estado; nombre_id: string; valor: real; pos: integer);
var
  i:integer;
  encontrado:boolean;
begin
  i := 1;
  encontrado := false;
  while (i <= estado.cant) and (not encontrado) do
  begin
    if estado.elementos[i].nombre = nombre_id then
      begin
        estado.elementos[i].valorArray[pos] := valor;
        encontrado := true;
      end
    else inc(i);
  end;
end;

//<Program> ::= <Variable> <SigVariable>

procedure EvaluarProgram(var arbol: T_Arbol; var estado: T_Estado);
begin
  EvaluarVariable(arbol^.hijos[1], estado);
  EvaluarSigVariable(arbol^.hijos[2], estado);
end;

//<SigVariable> ::= <Program> |  “begin” <Cuerpo> “end” “.”

procedure EvaluarSigVariable(var arbol: T_Arbol; var estado: T_Estado);
begin
  Case arbol^.hijos[1]^.simbolo of
  V_Program: EvaluarProgram(arbol^.hijos[1], estado);
  T_begin: EvaluarCuerpo(arbol^.hijos[2], estado);
  end;
end;

//<Cuerpo> ::= <Sentencia> <SigSentencia>

procedure EvaluarCuerpo(var arbol: T_Arbol; var estado: T_Estado);
begin
  EvaluarSentencia(arbol^.hijos[1],estado);
  EvaluarSigSentencia(arbol^.hijos[2],estado);
end;

//<SigSentencia> ::= <Cuerpo> | e

procedure EvaluarSigSentencia(var arbol: T_Arbol; var estado: T_Estado);
begin
  if arbol^.cant <> 0 then
    EvaluarCuerpo(arbol^.hijos[1], estado);
end;

//<Variable> ::= “id” “:=” <Tipo>

procedure EvaluarVariable(var arbol: T_Arbol; var estado: T_Estado);
var
  tipo:tipoVariable;
  tam:integer;
begin
  EvaluarTipo(arbol^.hijos[3],tipo,tam);
  CargarVariable(arbol^.hijos[1]^.lexema,estado,tipo,tam);
end;

//<Tipo> ::= “real” | “array” “{” "cteReal" ”}”

procedure EvaluarTipo(var arbol: T_Arbol; var Tipo: tipoVariable; var Tam:integer);
var
  valor: real;
begin
  if arbol^.hijos[1]^.lexema = 'array' then
    begin
      val(arbol^.hijos[3]^.lexema,valor);
      tipo := T_array;
      tam := floor(valor);
    end
  else
  begin
    tam := 1;
    tipo := T_cteReal;
  end;
end;

//<Arreglo> ::= “cteReal” <SigcteReal>

procedure EvaluarArreglo(var arbol: T_Arbol; var estado: T_Estado; var nuevoArray: arreglo; var pos:integer);
var
  valor: real;
begin
  inc(pos);
  val(arbol^.hijos[1]^.lexema,valor);
  nuevoArray[pos] := valor;
  EvaluarSigcteReal(arbol^.hijos[2],estado, nuevoArray, pos);
end;

//<SigcteReal> ::= “,” <Arreglo> | e
procedure EvaluarSigcteReal(var arbol: T_Arbol; var estado: T_Estado; var nuevoArray: arreglo; var pos:integer);
begin
  if arbol^.cant <> 0 then EvaluarArreglo(arbol^.hijos[2],estado, nuevoArray, pos);
end;

//<Sentencia> ::= <Asignacion> | <Lectura> | <Escritura> | <Condicional> | <CicloW> | <CicloF>

procedure EvaluarSentencia(var arbol: T_Arbol; var estado: T_Estado);
begin
  Case arbol^.hijos[1]^.simbolo  of
  V_Asignacion: EvaluarAsignacion(arbol^.hijos[1], estado);
  V_Lectura: EvaluarLectura(arbol^.hijos[1], estado);
  V_Escritura: EvaluarEscritura(arbol^.hijos[1], estado);
  V_Condicional: EvaluarCondicional(arbol^.hijos[1], estado);
  V_CicloW: EvaluarCicloW(arbol^.hijos[1], estado);
  V_CicloF: EvaluarCicloF(arbol^.hijos[1], estado);
  end;
end;

//<Asignacion> ::= “id” <Indice> “:=” <Suma>

procedure EvaluarAsignacion(var arbol: T_Arbol; var estado: T_Estado);
var
  resultado1,resultado3:real;
  resultado2,resultado4:arreglo;
  tipo1,tipo2,tipo3: tipoVariable;
  encontrado: boolean;
  pos: integer;
begin
  BuscarId(estado,arbol^.hijos[1]^.lexema, encontrado, tipo1);
  if encontrado then
    begin
      EvaluarSuma(arbol^.hijos[4], estado, resultado1, resultado2, tipo2, pos);
      EvaluarIndice(arbol^.hijos[2],arbol^.hijos[1]^.lexema,estado, resultado3, resultado4, tipo3, pos);
      if tipo1 = T_cteReal then
        begin
          if tipo1 = tipo2 then
            GuardarVariableReal(arbol^.hijos[1]^.lexema, estado, resultado1);
        end
      else
      begin
        if tipo3 = T_cteReal then
          begin
            if tipo3 = tipo2 then
              begin
                GuardarElementoEnArreglo(estado, arbol^.hijos[1]^.lexema, resultado1, pos);
              end;
          end
        else
        begin
          if arbol^.hijos[2]^.cant = 0 then
            begin
              GuardarVariableArreglo(arbol^.hijos[1]^.lexema, estado, resultado2,pos);
            end;
        end;
      end;
    end;
end;

//<Suma> ::= <Producto> <SigOpSuma>

procedure EvaluarSuma(var arbol: T_Arbol; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
var
  operando1:real;
  operando2:arreglo;
  tipo2: tipoVariable;
begin
  EvaluarProducto(arbol^.hijos[1],estado, operando1, operando2, tipo2, pos);
  EvaluarSigOpSuma(arbol^.hijos[2],estado, operando1, operando2, resultado1, resultado2, tipo, tipo2, pos);
end;

//<SigOpSuma> ::= “+” <Suma>| “-” <Suma>| e

procedure EvaluarSigOpSuma(var arbol: T_Arbol; var estado: T_Estado; operando1 :real; operando2:arreglo ; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; tipo2: tipoVariable; var pos: integer);
var
  operando3:real;
  operando4:arreglo;
  tipo3:tipoVariable;
  i,pos2:integer;
begin
  if arbol^.cant <> 0 then
  begin
  EvaluarSuma(arbol^.hijos[2],estado, operando3, operando4, tipo3, pos2);
  i := 1;
  Case arbol^.hijos[1]^.simbolo of
  T_mas:
    begin
      if tipo2 = T_cteReal then
        begin
          if tipo3 = T_cteReal then
            begin
              resultado1 := operando1 + operando3;
              tipo := T_cteReal;
            end
          else
          begin
            while (i <= pos2) do
            begin
              resultado2[i] := operando1 + (operando4[i]);
              inc(i);
            end;
            tipo := T_array;
          end;
        end
      else
      begin
        if tipo3 = T_cteReal then
            begin
              while (i <= pos) do
              begin
                resultado2[i] := (operando2[i]) + operando3;
                inc(i);
              end;
              tipo := T_array;
            end
          else
          begin
            tipo := T_array;
            if pos2 = pos then
            begin
              while i <= pos2 do
              begin
                resultado2[i] := (operando2[i]) + (operando4[i]);
                inc(i);
              end;
            end
            else
            begin
              if pos2 < pos then
              begin
                while i <= pos2 do
                begin
                  resultado2[i] := (operando2[i]) + (operando4[i]);
                  inc(i);
                end;
                while i <= pos do
                begin
                  resultado2[i] := (operando2[i]);
                  inc(i);
                end;
              end
              else
              begin
                while i <= pos do
                begin
                  resultado2[i] := (operando2[i]) + (operando4[i]);
                  inc(i);
                end;
                while i <= pos2 do
                begin
                  resultado2[i] := (operando4[i]);
                  inc(i);
                end;
              end;
            end;
          end;
      end;
    end;
  T_menos:
    begin
      if tipo2 = T_cteReal then
        begin
          if tipo3 = T_cteReal then
            begin
              resultado1 := operando1 - operando3;
              tipo := T_cteReal;
            end
          else
          begin
            while (i <= pos2) do
            begin
              resultado2[i] := operando1 - (operando4[i]);
              inc(i);
            end;
            tipo := T_array;
          end;
        end
      else
      begin
        if tipo3 = T_cteReal then
            begin
              while (i <= pos) do
              begin
                resultado2[i] := (operando2[i]) - operando3;
                inc(i);
              end;
              tipo := T_array;
            end
          else
          begin
            tipo := T_array;
            if pos2 = pos then
            begin
              while i <= pos2 do
              begin
                resultado2[i] := (operando2[i]) - (operando4[i]);
                inc(i);
              end;
            end
            else
            begin
              if pos2 < pos then
              begin
                while i <= pos do
                begin
                  resultado2[i] := (operando2[i]) - (operando4[i]);
                  inc(i);
                end;
              end
              else
              begin
                while i <= pos2 do
                begin
                  resultado2[i] := (operando2[i]) - (operando4[i]);
                  inc(i);
                end;
              end;
            end;
          end;
      end;
    end;
  end;
  end
  else
    if tipo2 = T_cteReal then
      begin
        resultado1 := operando1;
        tipo := T_cteReal;
      end
    else
    begin
      resultado2 := operando2;
      tipo := T_array;
    end
end;

//<Producto> ::= <Potencia> <SigOpProducto>

procedure EvaluarProducto(var arbol: T_Arbol; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
var
  operando1:real;
  operando2:arreglo;
  tipo2: tipoVariable;
begin
  EvaluarPotencia(arbol^.hijos[1],estado, operando1, operando2, tipo2, pos);
  EvaluarSigOpProducto(arbol^.hijos[2],estado, operando1, operando2, resultado1, resultado2, tipo, tipo2, pos);
end;

//<SigOpProducto>::= “*” <Potencia> <SigOpProducto>| “/” <Potencia> <SigOpProducto>| e

procedure EvaluarSigOpProducto(var arbol: T_Arbol; var estado: T_Estado; operando1:real; operando2:arreglo ; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var tipo2: tipoVariable; var pos: integer);
var
  operando3:real;
  operando4:arreglo;
  tipo3:tipoVariable;
  i, pos2:integer;
begin
  if arbol^.cant <> 0 then
  begin
  EvaluarProducto(arbol^.hijos[2],estado, operando3, operando4, tipo3, pos2);
  i := 1;
  Case arbol^.hijos[1]^.simbolo of
  T_multiplicacion:
    begin
      if tipo2 = T_cteReal then
        begin
          if tipo3 = T_cteReal then
            begin
              resultado1 := operando1 * operando3;
              tipo := T_cteReal;
            end
          else
          begin
            while (i <= pos2) do
            begin
              resultado2[i] := operando1 * (operando4[i]);
              inc(i);
            end;
            tipo := T_array;
          end;
        end
      else
      begin
        if tipo3 = T_cteReal then
            begin
              while (i <= pos) do
              begin
                resultado2[i] := (operando2[i]) * operando3;
                inc(i);
              end;
              tipo := T_array;
            end
          else
          begin
            tipo := T_array;
            if pos2 = pos then
            begin
              while i <= pos2 do
              begin
                resultado2[i] := (operando2[i]) * (operando4[i]);
                inc(i);
              end;
            end
            else
            begin
              if pos2 < pos then
              begin
                while i <= pos do
                begin
                  resultado2[i] := (operando2[i]) * (operando4[i]);
                  inc(i);
                end;
              end
              else
              begin
                while i <= pos2 do
                begin
                  resultado2[i] := (operando2[i]) * (operando4[i]);
                  inc(i);
                end;
              end;
            end;
          end;
      end;
    end;
  T_division:
    begin
      if tipo2 = T_cteReal then
        begin
          if tipo3 = T_cteReal then
            begin
              resultado1 := operando1 / operando3;
              tipo := T_cteReal;
            end
          else
          begin
            while (i <= pos2) do
            begin
              resultado2[i] := operando1 / (operando4[i]);
              inc(i);
            end;
            tipo := T_array;
          end;
        end
      else
      begin
        if tipo3 = T_cteReal then
            begin
              while (i <= pos) do
              begin
                resultado2[i] := (operando2[i]) / operando3;
                inc(i);
              end;
              tipo := T_array;
            end
          else
          begin
            tipo := T_array;
            if pos2 = pos then
            begin
              while i <= pos2 do
              begin
                resultado2[i] := (operando2[i]) / (operando4[i]);
                inc(i);
              end;
            end
            else
            begin
              if pos2 < pos then
              begin
                while i <= pos do
                begin
                  resultado2[i] := (operando2[i]) / (operando4[i]);
                  inc(i);
                end;
              end
              else
              begin
                while i <= pos2 do
                begin
                  resultado2[i] := (operando2[i]) / (operando4[i]);
                  inc(i);
                end;
              end;
            end;
          end;
      end;
    end;
  end;
  end
  else
    if tipo2 = T_cteReal then
      begin
        resultado1 := operando1;
        tipo := T_cteReal;
      end
    else
    begin
      resultado2 := operando2;
      tipo := T_array;
    end
end;

//<Potencia> ::= “(“ <Suma> ”)”  <SigPotencia> | <Numero>

procedure EvaluarPotencia(var arbol: T_Arbol; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
var
  operando1:real;
  operando2:arreglo;
  tipo2: tipoVariable;
begin
  if arbol^.hijos[1]^.Simbolo = T_abrirParentesis then
    begin
    EvaluarSuma(arbol^.hijos[2],estado, operando1, operando2, tipo2,pos);
    EvaluarSigPotencia(arbol^.hijos[4],estado, operando1, operando2, resultado1, resultado2, tipo, tipo2,pos);
    end
  else EvaluarNumero(arbol^.hijos[1],estado, resultado1, resultado2, tipo, pos);
end;

//<SigPotencia> ::= “^” “(“ <Numero> ”)” | “root” “(“ <Numero> ”)” | e

procedure EvaluarSigPotencia(var arbol: T_Arbol; var estado: T_Estado; operando1:real; operando2:arreglo ; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var tipo2: tipoVariable; var pos: integer);
var
  operando3:real;
  operando4:arreglo;
  tipo3:tipoVariable;
  i:integer;
  pos2: integer;
begin
  if arbol^.cant <> 0 then
  begin
  EvaluarNumero(arbol^.hijos[3],estado, operando3, operando4, tipo3, pos2);
  i := 1;
  Case arbol^.hijos[1]^.simbolo of
  T_potencia:
    begin
      if tipo2 = T_cteReal then
        begin
          if tipo3 = T_cteReal then
            begin
              resultado1 := power(operando1,operando3);
              tipo := T_cteReal;
            end
          else
          begin
            while (i <= pos2) do
            begin
              resultado2[i] := power(operando1,operando4[i]);
              inc(i);
            end;
            tipo := T_array;
          end;
        end
      else
      begin
        if tipo3 = T_cteReal then
            begin
              while (i <= pos) do
              begin
                resultado2[i] := power(operando2[i],operando3);
                inc(i);
              end;
              tipo := T_array;
            end
          else
          begin
            tipo := T_array;
            if pos2 = pos then
            begin
              while i <= pos2 do
              begin
                resultado2[i] := power(operando2[i],operando4[i]);
                inc(i);
              end;
            end
            else
            begin
              if pos2 < pos then
              begin
                while i <= pos do
                begin
                  resultado2[i] := power(operando2[i],operando4[i]);
                  inc(i);
                end;
              end
              else
              begin
                while i <= pos2 do
                begin
                  resultado2[i] := power(operando2[i],operando4[i]);
                  inc(i);
                end;
              end;
            end;
          end;
      end;
    end;
  T_root:
    begin
      if tipo2 = T_cteReal then
        begin
          if tipo3 = T_cteReal then
            begin
              resultado1 := Exp((1/operando1) * Ln(operando3));
              tipo := T_cteReal;
            end
          else
          begin
            while (i <= pos2) do
            begin
              resultado2[i] := Exp((1/operando1) * Ln(operando4[i]));
              inc(i);
            end;
            tipo := T_array;
          end;
        end
      else
      begin
        if tipo3 = T_cteReal then
            begin
              while (i <= pos) do
              begin
                resultado2[i] := Exp((1/operando2[i]) * Ln(operando3));
                inc(i);
              end;
              tipo := T_array;
            end
          else
          begin
            tipo := T_array;
            if pos2 = pos then
            begin
              while i <= pos2 do
              begin
                resultado2[i] := Exp((1/operando2[i]) * Ln(operando4[i]));
                inc(i);
              end;
            end
            else
            begin
              if pos2 < pos then
              begin
                while i <= pos do
                begin
                  resultado2[i] := Exp((1/operando2[i]) * Ln(operando4[i]));
                  inc(i);
                end;
              end
              else
              begin
                while i <= pos2 do
                begin
                  resultado2[i] := Exp((1/operando2[i]) * Ln(operando4[i]));
                  inc(i);
                end;
              end;
            end;
          end;
      end;
    end;
  end;
  end
  else
    if tipo2 = T_cteReal then
      begin
        resultado1 := operando1;
        tipo := T_cteReal;
      end
    else
    begin
      resultado2 := operando2;
      tipo := T_array;
    end
end;

//<Numero> ::= “cteReal” | “{“ <Arreglo> ”}” | “id” <Indice>

procedure EvaluarNumero(var arbol: T_Arbol; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
begin
  Case arbol^.hijos[1]^.simbolo of
  T_abrirLlave:
    begin
      pos := 0;
      EvaluarArreglo(arbol^.hijos[2],estado,resultado2,pos);
      tipo := T_array;
    end;
  T_id: EvaluarIndice(arbol^.hijos[2],arbol^.hijos[1]^.lexema,estado,resultado1, resultado2, tipo, pos);
  else
    begin
      val(arbol^.hijos[1]^.lexema, resultado1);
      tipo := T_cteReal;
    end;
  end;
end;

//<Indice> ::= e | “[” <Suma> “]”

procedure EvaluarIndice(var arbol: T_Arbol; var nombre_id: string; var estado: T_Estado; var resultado1: real; var resultado2: arreglo; var tipo: tipoVariable; var pos: integer);
var
  operando1, aux:real;
  operando2:arreglo;
  tipo1, tipo2:tipoVariable;
  encontrado:boolean;
  i,j,tam:integer;
begin
  if arbol^.cant <> 0 then
    begin
    BuscarId(estado,nombre_id, encontrado, tipo1);
    if encontrado then
        begin
          EvaluarSuma(arbol^.hijos[2],estado, operando1, operando2, tipo2, pos);
          if (tipo2 = T_cteReal) and (tipo1 = T_array) then
            begin
              j := floor(operando1);
              EvaluarTamanio(estado, nombre_id, tam);
              if j <= tam then
                begin
                ConseguirElementoEnArreglo(estado, nombre_id, j ,resultado1);
                pos := j;
                tipo := T_cteReal;
                end;
            end
          else
          begin
            for i := 1 to pos do
            begin
              j := floor(operando2[i]);
              EvaluarTamanio(estado, nombre_id, tam);
              if j <= tam then
                begin
                ConseguirElementoEnArreglo(estado, nombre_id, j, aux);
                resultado2[i] := aux;
                end;
            end;
            tipo := T_array;
          end;
        end;
    end
  else
    begin
      BuscarId(estado,nombre_id, encontrado, tipo1);
      if encontrado then
        begin
        if tipo1 = T_cteReal then
          begin
            ConseguirValorReal(estado, nombre_id, resultado1);
            tipo := T_cteReal;
          end
        else
        begin
          ConseguirArreglo(estado,nombre_id, resultado2, pos);
          tipo := T_array;
        end;
        end;
    end;
end;

//<Lectura> ::= ”Read” “(“ “cteCadena” “id” “)”

procedure EvaluarLectura(var arbol: T_Arbol; var estado: T_Estado);
var
  id: string;
  aux: real;
  nuevoArray: arreglo;
  tipo: tipoVariable;
  encontrado: boolean;
  tam:integer;
begin
  write(arbol^.hijos[3]^.lexema);
  readln(id);
  BuscarId(estado,arbol^.hijos[4]^.lexema, encontrado, tipo);
  if encontrado then
    begin
      if tipo = T_cteReal then
      begin
        val(id,aux);
        GuardarVariableReal(arbol^.hijos[4]^.lexema,estado,aux);
      end
      else
      begin
        if (id[1] = '{') and (id[length(id)] = '}') then
          begin
            EvaluarTamanio(estado, arbol^.hijos[4]^.lexema, tam);
            TransformarEnArreglo(id,nuevoArray,tam);
            GuardarVariableArreglo(arbol^.hijos[4]^.lexema, estado, nuevoArray, tam);
          end;
      end;
    end;
end;

//<Escritura> ::= “Write” “(“ <SigEscritura>

procedure EvaluarEscritura(var arbol: T_Arbol; var estado: T_Estado);
begin
  EvaluarSigEscritura(arbol^.hijos[3],estado);
end;

//<SigEscritura> ::= “cteCadena” “)” | <Suma> “)” | “array” “{” <Arreglo> “}”“)”     //lo del array es una pelotudez si en suma se puede escribir

procedure EvaluarSigEscritura(var arbol: T_Arbol; var estado: T_Estado);
var
  resultado1:real;
  resultado2:arreglo;
  tipo: tipoVariable;
  i,pos:integer;
begin
  Case arbol^.hijos[1]^.simbolo of
  T_cadena: writeln(arbol^.hijos[1]^.lexema);
  V_Suma:
    begin
      EvaluarSuma(arbol^.hijos[1], estado, resultado1, resultado2, tipo, pos);
      if tipo = T_cteReal then writeln(resultado1)
      else
        begin
          write('{ ');
          write(resultado2[1]);
          for i := 2 to pos do
          begin
            write(', ');
            write(resultado2[i]);
          end;
          write('}');
          writeln();
        end;
    end;
  else
    begin
      pos := 0;
      EvaluarArreglo(arbol^.hijos[3], estado, resultado2,pos);
      write('{ ');
          write(resultado2[1]);
          for i := 2 to length(resultado2) do
          begin
            write(', ');
            write(resultado2[i]);
          end;
          write('}');
          writeln();
    end;
  end;
end;

//<CicloW> ::= “While”  <Cond>  “do” “begin” <Cuerpo> “end” “;”

procedure EvaluarCicloW(var arbol: T_Arbol; var estado: T_Estado);
var
  valor:boolean;
begin
  EvaluarCond(arbol^.hijos[2],estado,valor);
  While valor do
  begin
    EvaluarCuerpo(arbol^.hijos[5],estado);
    EvaluarCond(arbol^.hijos[2],estado,valor);
  end;
end;

//<CicloF> ::= “For” “[“ “id” “:=” <SigCiclo>

procedure EvaluarCicloF(var arbol: T_Arbol; var estado: T_Estado);
var
  encontrado: boolean;
  tipo: tipoVariable;
begin
  BuscarId(estado,arbol^.hijos[3]^.lexema, encontrado, tipo);
  if (encontrado) and (tipo = T_cteReal) then EvaluarSigCiclo(arbol^.hijos[3]^.lexema,arbol^.hijos[5],estado);
end;

//<SigCiclo> ::= “cteReal” “to” <FinalCiclo> | “id” <Indice> “to” <FinalCiclo>

procedure EvaluarSigCiclo(lexema: string; var arbol: T_Arbol; var estado: T_Estado);
var
  resultado1, valor:real;
  resultado2:arreglo;
  tipo:tipoVariable;
  pos: integer;
begin
  case arbol^.hijos[1]^.simbolo of
  T_id:
    begin
      EvaluarIndice(arbol^.hijos[2], arbol^.hijos[1]^.lexema, estado, resultado1, resultado2, tipo, pos);
      EvaluarFinalCiclo(arbol^.hijos[4], lexema, resultado1, estado);
    end;
  else
      val(arbol^.hijos[1]^.lexema, valor);
      EvaluarFinalCiclo(arbol^.hijos[3], lexema, valor, estado);
  end;
end;

//<FinalCiclo> ::=  “cteReal” “]” “begin” <Cuerpo> “end” “;” | “id” <Indice> “]” “begin” <Cuerpo> “end” “;”

procedure EvaluarFinalCiclo(var arbol: T_Arbol; var lexema: string; resultado1: real; var estado: T_Estado);
var
  valor,resultado3: real;
  resultado2:arreglo;
  tipo:tipoVariable;
  i,pos: integer;
begin
  case arbol^.hijos[1]^.Simbolo of
  T_id:
    begin
      EvaluarIndice(arbol^.hijos[2], arbol^.hijos[1]^.lexema, estado, resultado3, resultado2, tipo, pos);
      for i := floor(resultado1) to floor(resultado3) do
      begin
        GuardarVariableReal(lexema, estado, i);
        EvaluarCuerpo(arbol^.hijos[5],estado);
      end;
    end;
  else
    begin
      val(arbol^.hijos[1]^.lexema,valor);
      for i := floor(resultado1) to floor(valor) do
      begin
        GuardarVariableReal(lexema, estado, i);
        EvaluarCuerpo(arbol^.hijos[4],estado);
      end;
    end;
  end;
end;

//<Condicional> ::= “If” <Cond> “then” “begin” <Cuerpo> “end” “;”

procedure EvaluarCondicional(var arbol: T_Arbol; var estado: T_Estado);
var
  valor:boolean;
begin
  EvaluarCond(arbol^.hijos[2],estado,valor);
  if valor then EvaluarCuerpo(arbol^.hijos[5],estado);
end;

//<CondRel> ::= <Suma> “opRel” <Suma>

procedure EvaluarCondRel(var arbol: T_Arbol; var estado: T_Estado; var valor:boolean);
var
  resultado1, resultado3: real;
  resultado2, resultado4: arreglo;
  tipo1, tipo2: tipoVariable;
  i, pos, pos2:integer;
begin
  i := 1;
  Case arbol^.hijos[2]^.lexema of
    '>':
      begin
        EvaluarSuma(arbol^.hijos[1],estado,resultado1, resultado2, tipo1, pos);
        EvaluarSuma(arbol^.hijos[3],estado,resultado3, resultado4, tipo2, pos2);
        if tipo1 = T_cteReal then
          begin
            if tipo2 = T_cteReal then
              begin
                valor := resultado1 > resultado3;
              end
            else
            begin
              valor := true;
              while (i <= pos2) and (valor) do
              begin
                if not(resultado1 > resultado4[i]) then valor := false;
                inc(i);
              end;
            end;
          end
        else
        if tipo2 = T_cteReal then
          begin
            valor := true;
            while (i <= pos) and (valor) do
            begin
              if not(resultado2[i] > resultado3) then valor := false;
              inc(i);
            end;
          end
        else
        begin
          valor := true;
          while ((i <= pos) and (i <= pos2)) and (valor) do
          begin
            if not(resultado2[i] > resultado4[i]) then valor := false;
            inc(i);
          end;
        end;
      end;

    '<':
      begin
        EvaluarSuma(arbol^.hijos[1],estado,resultado1, resultado2, tipo1, pos);
        EvaluarSuma(arbol^.hijos[3],estado,resultado3, resultado4, tipo2, pos2);
        if tipo1 = T_cteReal then
          begin
            if tipo2 = T_cteReal then
              begin
                valor := resultado1 < resultado3;
              end
            else
            begin
              valor := true;
              while (i <= pos2) and (valor) do
              begin
                if not(resultado1 < resultado4[i]) then valor := false;
                inc(i);
              end;
            end;
          end
        else
        if tipo2 = T_cteReal then
          begin
            valor := true;
            while (i <= pos) and (valor) do
            begin
              if not(resultado2[i] < resultado3) then valor := false;
              inc(i);
            end;
          end
        else
        begin
          valor := true;
          while (i <= pos) and (valor) do
          begin
            if not(resultado2[i] < resultado4[i]) then valor := false;
            inc(i);
          end;
        end;
      end;

    '>=':
      begin
        EvaluarSuma(arbol^.hijos[1],estado,resultado1, resultado2, tipo1, pos);
        EvaluarSuma(arbol^.hijos[3],estado,resultado3, resultado4, tipo2, pos2);
        if tipo1 = T_cteReal then
          begin
            if tipo2 = T_cteReal then
              begin
                valor := resultado1 >= resultado3;
              end
            else
            begin
              valor := true;
              while (i <= pos2) and (valor) do
              begin
                if not(resultado1 >= resultado4[i]) then valor := false;
                inc(i);
              end;
            end;
          end
        else
        if tipo2 = T_cteReal then
          begin
            valor := true;
            while (i <= pos) and (valor) do
            begin
              if not(resultado2[i] >= resultado3) then valor := false;
              inc(i);
            end;
          end
        else
        begin
          valor := true;
          while (i <= pos) and (valor) do
          begin
            if not(resultado2[i] >= resultado4[i]) then valor := false;
            inc(i);
          end;
        end;
      end;

    '<=':
      begin
        EvaluarSuma(arbol^.hijos[1],estado,resultado1, resultado2, tipo1, pos);
        EvaluarSuma(arbol^.hijos[3],estado,resultado3, resultado4, tipo2, pos2);
        if tipo1 = T_cteReal then
          begin
            if tipo2 = T_cteReal then
              begin
                valor := resultado1 <= resultado3;
              end
            else
            begin
              valor := true;
              while (i <= pos2) and (valor) do
              begin
                if not(resultado1 <= resultado4[i]) then valor := false;
                inc(i);
              end;
            end;
          end
        else
        if tipo2 = T_cteReal then
          begin
            valor := true;
            while (i <= pos) and (valor) do
            begin
              if not(resultado2[i] <= resultado3) then valor := false;
              inc(i);
            end;
          end
        else
        begin
          valor := true;
          while (i <= pos) and (valor) do
          begin
            if not(resultado2[i] <= resultado4[i]) then valor := false;
            inc(i);
          end;
        end;
      end;

    '<>':
      begin
        EvaluarSuma(arbol^.hijos[1],estado,resultado1, resultado2, tipo1, pos);
        EvaluarSuma(arbol^.hijos[3],estado,resultado3, resultado4, tipo2, pos2);
        if tipo1 = T_cteReal then
          begin
            if tipo2 = T_cteReal then
              begin
                valor := resultado1 <> resultado3;
              end
            else
            begin
              valor := true;
              while (i <= pos2) and (valor) do
              begin
                if not(resultado1 <> resultado4[i]) then valor := false;
                inc(i);
              end;
            end;
          end
        else
        if tipo2 = T_cteReal then
          begin
            valor := true;
            while (i <= pos) and (valor) do
            begin
              if not(resultado2[i] <> resultado3) then valor := false;
              inc(i);
            end;
          end
        else
        begin
          valor := true;
          while (i <= pos) and (valor) do
          begin
            if not(resultado2[i] <> resultado4[i]) then valor := false;
            inc(i);
          end;
        end;
      end;

    '=':
      begin
        EvaluarSuma(arbol^.hijos[1],estado,resultado1, resultado2, tipo1, pos);
        EvaluarSuma(arbol^.hijos[3],estado,resultado3, resultado4, tipo2, pos2);
        if tipo1 = T_cteReal then
          begin
            if tipo2 = T_cteReal then
              begin
                valor := resultado1 = resultado3;
              end
            else
            begin
              valor := true;
              while (i <= pos2) and (valor) do
              begin
                if not(resultado1 = resultado4[i]) then valor := false;
                inc(i);
              end;
            end;
          end
        else
        if tipo2 = T_cteReal then
          begin
            valor := true;
            while (i <= pos) and (valor) do
            begin
              if not(resultado2[i] = resultado3) then valor := false;
              inc(i);
            end;
          end
        else
        begin
          valor := true;
          while (i <= pos) and (valor) do
          begin
            if not(resultado2[i] = resultado4[i]) then valor := false;
            inc(i);
          end;
        end;
      end;
  end;
end;

//<Cond> ::= <CondAnd> <SigCond>

procedure EvaluarCond(var arbol: T_Arbol; var estado: T_Estado; var valor:boolean);
var
  aux: boolean;
begin
  EvaluarCondAnd(arbol^.hijos[1],estado,aux);
  EvaluarSigCond(arbol^.hijos[2],estado,aux,valor);
end;

//<SigCond> ::= “or” <Cond>| e

procedure EvaluarSigCond(var arbol: T_Arbol; var estado: T_Estado;var aux: boolean; var valor:boolean);
var
  valor2: boolean;
begin
  if arbol^.cant <> 0 then
    begin
      EvaluarCond(arbol^.hijos[2],estado,valor2);
      valor:= aux or valor2;
    end
  else valor:= aux;
end;

//<CondAnd> ::= <CondNot> <SigCondAnd>

procedure EvaluarCondAnd(var arbol: T_Arbol; var estado: T_Estado; var valor:boolean);
var
  aux: boolean;
begin
  EvaluarCondNot(arbol^.hijos[1],estado,aux);
  EvaluarSigCondAnd(arbol^.hijos[2],estado,aux,valor);
end;

//<SigCondAnd> ::= “and” <CondAnd> | e

procedure EvaluarSigCondAnd(var arbol: T_Arbol; var estado: T_Estado;var aux: boolean; var valor:boolean);
var
  valor2: boolean;
begin
  if arbol^.cant <> 0 then
    begin
      EvaluarCondAnd(arbol^.hijos[2],estado,valor2);
      valor:= aux and valor2;
    end
  else valor:= aux;
end;

//<CondNot> ::= “not” <CondNot> | “[” <Cond> “]” | <CondRel>

procedure EvaluarCondNot(var arbol: T_Arbol; var estado: T_Estado; var valor:boolean);
var
  aux: boolean;
begin
  case arbol^.hijos[1]^.simbolo of
    T_not:
      begin
        EvaluarCondNot(arbol^.hijos[2],estado,aux);
        valor:= not(aux);
      end;
    T_abrirCorchete:
      begin
        EvaluarCond(arbol^.hijos[2],estado,valor);
      end;
    else
      begin
        EvaluarCondRel(arbol^.hijos[1],estado,valor);
      end;
  end;
end;


end.
