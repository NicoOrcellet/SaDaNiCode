unit archivos;

interface
uses
  Classes, SysUtils;

Const
   Ruta = 'D:\Escritorio\ArchivoEjemplo.txt';

Type
  archivo=file of char;

Procedure abrirArchivo(var arch: archivo);
Procedure cerrarArchivo(var arch: archivo);

implementation

Procedure abrirArchivo(var arch: archivo);
  Begin
    Assign(arch,Ruta);
    reset(arch);
  End;


Procedure cerrarArchivo(var arch: archivo);
  Begin
    close(arch);
  End;

end.
