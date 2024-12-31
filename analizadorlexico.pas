unit analizadorLexico;



interface
uses defTipos , archivos, crt;
const
 fArchivo=#0;

procedure SiguienteComponenteLexico(var fuente:archivo; var control:longint; var ComponenteLexico:simbolos; var lexema:string; ts:T_Lista);

implementation

procedure leerCar(var fuente:archivo;var control:longint;var car:char);
    begin
    if control < filesize(fuente) then
     begin
      seek(fuente,control);
      read(fuente,car);
     end
    else
    begin
    car:= fArchivo;
    end;
end;

Function EsId(Var Fuente:Archivo;Var Control:Longint;Var Lexema:String):Boolean;
    Const
      q0=0;
      F=[2];
    Type
      Q=0..3;
      Sigma=(Letra, Digito, Otro);
      TipoDelta=Array[Q,Sigma] of Q;
    Var
      EstadoActual:Q;
      Delta:TipoDelta;
      Aux:Longint;
      Car:char;

       Function CarASimb(Car:Char):Sigma;
    Begin
      Case Car of
        'a'..'z', 'A'..'Z' :CarASimb:=Letra;
        '0'..'9' :CarASimb:=Digito;
      else
       CarASimb:=Otro;
      End;
    End;

    Begin
      Delta[0,Letra]:=1;
      Delta[0,Digito]:=3;
      Delta[0,Otro]:=3;
      Delta[1,Digito]:=1;
      Delta[1,Letra]:=1;
      Delta[1,Otro]:=2;
      EstadoActual:=q0;
    Aux:=Control;
    Lexema:= '';
    While EstadoActual in [0..1] do
    begin
         LeerCar(Fuente,Aux,Car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
         inc(Aux);
         If EstadoActual = 1 then
              Lexema:= Lexema + car;

    end;
         If EstadoActual in F then
              Control:= Aux - 1;
         EsId:= EstadoActual in F
end;

Function EsCteReal(Var Fuente:Archivo;Var Control:Longint;Var Lexema:String):Boolean;
Const
  q0=0;
  F=[5];
Type
  Q=0..5;
  Sigma=(Digito, Punto , Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  Aux: Longint;
  Car: Char;
  EstadoActual:Q;
  Delta:TipoDelta;

   Function CarASimb(Car:Char):Sigma;
  Begin
    Case Car of
         '0'..'9': CarASimb:= Digito;
         '.': CarASimb:= Punto;
    else
     CarASimb:= Otro;
    End;
  End;

  Begin

    Delta[0,Punto]:=2;
    Delta[0,Digito]:=1;
    Delta[0,Otro]:=2;

    Delta[1,Punto]:=3;
    Delta[1,Digito]:=1;
    Delta[1,Otro]:=5;

    Delta[3,Punto]:=2;
    Delta[3,Digito]:=4;
    Delta[3,Otro]:=2;

    Delta[4,Punto]:=2;
    Delta[4,Digito]:=4;
    Delta[4,Otro]:=5;

    EstadoActual:=q0;
  Aux:=Control;
  Lexema:= '';
  While EstadoActual in [0,1,3,4] do
  begin
       LeerCar(Fuente,Aux,Car);
       EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
       inc(Aux);
       If EstadoActual in [0,1,3,4] then
            Lexema:= Lexema + car;
  end;
       If EstadoActual in F then
            Control:= Aux - 1;
       EsCteReal:= EstadoActual in F
end;

Function EsCteCadena(Var Fuente: Archivo ; Var Control: Longint ; Var Lexema: String): Boolean;
    Const
         q0=0;
         F=[3];
    Type
        Q=0..4;
        Sigma=(Letra, Digito, Comilla ,  Otro);
        TipoDelta=Array[Q,Sigma] of Q;
    Var
       EstadoActual:Q;
       Delta:TipoDelta;
       Aux: Longint;
       Car: Char;

       Function CarASimb(car:char):Sigma;
       begin

         Case Car of
           'a'..'z', 'A'..'Z':CarASimb:=Letra;
           '0'..'9':CarASimb:=Digito;
           '"' : CarASimb:= Comilla;
         else
          CarASimb:=Otro;
         end;
         end;
    Begin
        Delta[0,Letra]:=4;
        Delta[0,Digito]:=4;
        Delta[0,Otro]:=4;
        Delta[0,Comilla]:=1;

        Delta[1,Letra]:=1;
        Delta[1,Digito]:=1;
        Delta[1,Comilla]:=2;
        Delta[1,Otro]:=1;

        Delta[2,Letra]:=4;
        Delta[2,Digito]:=4;
        Delta[2,Otro]:=3;
        Delta[2,Comilla]:=4;

    EstadoActual:=q0;
    Aux:=Control;
    Lexema:= '';
    While EstadoActual in [0..2] do
    begin

         LeerCar(Fuente,Aux,Car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
         Inc(Aux);
         If (EstadoActual in [0..2]) and (car <> '"') then
              Lexema:= Lexema + car;

    end;
    If EstadoActual in F then
    begin
         Control:= Aux - 1;
    end;
    EsCteCadena:=EstadoActual in F;

end;

Function EsSimboloEspecial(Var Fuente:archivo;Var Control:Longint; var ComponenteLexico:simbolos; Var Lexema:String):Boolean;
    var
       car:char;
    begin

    LeerCar(fuente,control,car);
    if Car in ['=',',','.','(',')','[',']',';','>','<','+','-','*','/','^',':','{','}'] then
    begin
    EsSimboloEspecial:=true;
    case car of
      ':':begin inc(control);
                leercar(fuente,control,car);
                if car = '=' then
                begin
                     lexema:=':=';
                     ComponenteLexico:= T_asignacion;
                     inc(control);
                end;

          end;

      ';':begin
                inc(control);
                lexema:= car;
                ComponenteLexico:= T_puntoComa;
                end;

      ',': begin
                 ComponenteLexico:= T_coma;
                 lexema:= car;
                 inc(control);
                 end;

      '.':begin
                 inc(control);
                 lexema:= car;
                 ComponenteLexico:= T_punto;
                 end;

      '+': begin
                 ComponenteLexico:= T_mas;
                 lexema:= car;
                 inc(control);
                 end;

      '-': begin
                 ComponenteLexico:= T_menos;
                 lexema:= car;
                 inc(control);
                 end;

      '*': begin
                 ComponenteLexico:= T_multiplicacion;
                 lexema:= car;
                 inc(control);
                 end;

      '/': begin
                 ComponenteLexico:= T_division;
                 lexema:= car;
                 inc(control);
                 end;

      '^': begin
                 ComponenteLexico:= T_potencia;
                 lexema:= car;
                 inc(control);
                 end;

      '(': begin
                 ComponenteLexico:= T_abrirParentesis;
                 lexema:= car;
                 inc(control);
                 end;

      ')': begin
                 ComponenteLexico:= T_cerrarParentesis;
                 lexema:= car;
                 inc(control);
                 end;

      '{': begin
                 ComponenteLexico:= T_abrirLlave;
                 lexema:= car;
                 inc(control);
                 end;

      '}': begin
                 ComponenteLexico:= T_cerrarLlave;
                 lexema:= car;
                 inc(control);
                 end;

      '[': begin
                 ComponenteLexico:= T_abrirCorchete;
                 lexema:= car;
                 inc(control);
                 end;
      ']': begin
                 ComponenteLexico:= T_cerrarCorchete;
                 lexema:= car;
                 inc(control);
                 end;

      '>': begin inc(control);
                leercar(fuente,control,car);
                if car = '=' then
                begin
                     lexema:='>=';
                     ComponenteLexico:= T_opRelacional;
                     inc(control);
                end
                else
                begin
                lexema:= '>';
                ComponenteLexico:= T_opRelacional;
                end;
          end;

       '<': begin inc(control);
                leercar(fuente,control,car);
                if car = '=' then
                begin
                     lexema:='<=';
                     ComponenteLexico:= T_opRelacional;
                     inc(control);
                end
                else  if car = '>' then
                begin
                     lexema:='<>';
                     ComponenteLexico:= T_opRelacional;
                     inc(control);
                end
                else
                begin
                lexema:= '<';
                ComponenteLexico:= T_opRelacional;
                end;
          end;

       '=': begin
            lexema:= car;
            ComponenteLexico:= T_opRelacional;
            inc(control);
       end;


      end;
    end
    else
     essimboloespecial:=false;


end;

procedure SiguienteComponenteLexico(var fuente:archivo; var control:longint; var ComponenteLexico: simbolos; var lexema:string; ts:T_Lista);

    var
    Car:char;

    begin
      leercar(fuente,control,Car);
      while car in [#1..#32] do
      begin
        inc(control);
        leercar(fuente,control,Car);
      end;

    if Car=fArchivo then
      begin
        ComponenteLexico := pesos
      end
      else
      begin
        if esId(fuente,control,lexema) then
        begin
          BuscarEnLista(ts,lexema,ComponenteLexico);
        end
        else
        begin
          if EsCteReal(fuente,control,lexema) then
          begin
            ComponenteLexico:= T_cteReal;
          end
          else
          if esCtecadena(fuente,control,lexema) then
            begin
              ComponenteLexico:= T_cadena;
            end
            else if not EsSimboloEspecial(Fuente,Control,ComponenteLexico,Lexema) then
            begin
                ComponenteLexico:= error;
            end;
        end;
    end;
end;
end.
