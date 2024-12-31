unit defTipos;



interface

type

 archivo=file of char;

 simbolos=(T_begin, T_end, T_real, T_array, T_root, T_write, T_read, T_if, T_else, T_then,
 T_for, T_while, T_do, T_puntoComa, T_id, T_asignacion, T_punto, T_abrirParentesis, T_cerrarParentesis,
 T_abrirLlave, T_cerrarLlave, T_Cadena, T_coma, T_cteReal, T_menos, T_not, T_or, T_and, T_opRelacional,
 T_abrirCorchete, T_cerrarCorchete, T_mas, T_potencia, T_multiplicacion, T_division ,T_to, pesos, V_Program,
 V_SigVariable, V_Cuerpo, V_SigSentencia, V_Variable, V_Tipo, V_Arreglo, V_SigcteReal, V_Sentencia, V_Asignacion,
 V_Suma, V_SigOpSuma, V_Producto, V_SigOpProducto, V_Potencia, V_SigPotencia, V_Numero, V_Indice, V_Lectura,
 V_Escritura, V_SigEscritura, V_CicloW, V_CicloF, V_SigCiclo, V_FinalCiclo, V_Condicional,
 V_CondRel, V_Cond, V_SigCond, V_CondAnd, V_SigCondAnd, V_CondNot, error);

 Terminales = T_begin..pesos;

 Variables = V_program..V_CondNot;

 L_Simbolos=record
        elem:array[1..20] of simbolos;
        cant:integer;
        end;

 TAS = array [Variables,Terminales] of ^L_Simbolos;

 T_dato_Lista=simbolos;

 T_puntero_Lista=^T_nodo_Lista;

 T_nodo_Lista=record
        lex:string;
        comp:T_dato_Lista;
        sig:T_puntero_Lista;
        end;

 T_Lista= record
          cab:T_Puntero_Lista;
          tam:integer;
         end;

 T_Arbol=^T_nodo_arbol;

 T_nodo_arbol= record
          simbolo:simbolos;
          lexema:string;
          hijos:array[1..20] of T_Arbol;
          cant:integer;
          end;

 T_dato_P = record
        simb:simbolos;
        arbol:T_Arbol;
        end;

 T_puntero_P=^T_nodo_P;

 T_nodo_P= record
        info:T_dato_P;
        sig:T_puntero_P;
       end;

 T_Pila= record
        tope:T_puntero_P;
        tam:longint;
       end;

procedure CrearLista(var l:T_Lista);
procedure AgregarALista(var l:T_Lista; lexema:string; comp:simbolos);
procedure BuscarEnLista(var l:T_Lista; lexema:string;var comp:simbolos);
procedure CargarSimbolosEnLista(var l:T_Lista);
procedure CrearPila(var p:T_Pila);
procedure Apilar(var P:T_Pila; X:T_dato_P);
procedure Desapilar(var P:T_Pila;var X:T_dato_P);
procedure CrearArbol(var Arbol:T_Arbol; Simbolo:simbolos);
procedure AgregarHijo(var Padre:T_Arbol;var Hijo:T_Arbol);

implementation
procedure CrearLista(var l:T_Lista);
begin
 l.cab:=nil;
 l.tam:=0;
end;

procedure BuscarEnLista(var l:T_Lista; lexema:string;var comp:simbolos);
   var
     act:T_puntero_Lista; encontrado:boolean;
  begin
   encontrado:=false;
   act:=l.cab;
    while (act <> nil)and (not encontrado) do
     begin

      if upcase(act^.lex)=upcase(lexema) then
       begin
       comp:=act^.comp;
       encontrado:=true;
       end
      else
       act:=act^.sig;
     end;
    if act=nil then
     comp:=T_id;
  end;

procedure AgregarALista(var l:T_Lista; lexema:string; comp:simbolos);
 var
   aux,ant,act:T_puntero_Lista;

begin
 inc(l.tam);
 new(aux);
 aux^.lex:=lexema;
 aux^.comp:=comp;
  if l.cab=nil  then
   begin
    aux^.sig:=l.cab;
    l.cab:=aux;
   end
  else
   begin
    ant:=l.cab;
    act:=l.cab^.sig;
     while act<>nil  do
      begin
       ant:=act;
       act:=act^.sig;
      end;
    aux^.sig:=act;
    ant^.sig:=aux;
   end;
end;

procedure CargarSimbolosEnLista(var l:T_Lista);
begin
CrearLista(l);
AgregarALista(l,'begin',T_begin);
AgregarALista(l,'end',T_end);
AgregarALista(l,'real',T_real);
AgregarALista(l,'array',T_array);
AgregarALista(l,'root',T_root);
AgregarALista(l,'write',T_write);
AgregarALista(l,'read',T_read);
AgregarALista(l,'if',T_if);
AgregarALista(l,'else',T_else);
AgregarALista(l,'then',T_then);
AgregarALista(l,'for',T_for);
AgregarALista(l,'while',T_while);
AgregarALista(l,'do',T_do);
AgregarALista(l,'or',T_or);
AgregarALista(l,'and',T_and);
AgregarALista(l,'not',T_not);
AgregarALista(l,'to',T_to);
end;

procedure CrearPila(var P:T_Pila);
begin
P.tope:=nil;
P.tam:=0;
end;

procedure Apilar(var P:T_Pila; X:T_dato_P);
var aux:T_puntero_P;
begin
new(aux);
aux^.info:= X;
aux^.sig := P.tope;
P.tope := aux;
inc(P.tam);
end;

procedure Desapilar(var P:T_Pila;var X:T_dato_P);
var aux:T_puntero_P;
begin
  X:=P.tope^.info;
  aux:=P.tope;
  P.tope:=aux^.sig;
  dispose(aux);
  dec(P.tam);
end;

procedure CrearArbol(var Arbol:T_Arbol; Simbolo:simbolos);
begin
  new(Arbol);
  arbol^.simbolo := Simbolo;
  arbol^.lexema := '';
  arbol^.cant := 0;
end;

procedure AgregarHijo(var Padre:T_Arbol;var Hijo:T_Arbol);
begin
  inc(Padre^.cant);
  padre^.hijos[padre^.cant]:= Hijo;
end;

END.
