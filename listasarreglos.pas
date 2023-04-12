unit Listasarreglos;

{$mode objfpc}{$H+}

interface

uses
  Tipos, FileUtil, LResources,
  ExtCtrls, Process,Controls,StdCtrls,Graphics, SysUtils ;

const
  Min=1;
  Max=100;
  Nulo=0;

Type
  Posicion_lista = longint;
  Lista = object
  Elementos: array[Min..Max] of TipoElemento;
  Inicio, Final: Posicion_lista;
  q_item: longint;
  procedure Crearvacia;
  function Esvacia(): Boolean;
  function Esllena(): Boolean;
  function Agregar(x: TipoElemento): Errores;
  function Insertar(x: TipoElemento; p: Posicion_lista): Errores;
  function Eliminar(p: Posicion_lista): Errores;
  function Buscar(x: TipoElemento; Comparar: Campo_Comparar): Posicion_lista;
  function Siguiente(p: Posicion_lista): Posicion_lista;
  function Anterior(p: Posicion_lista): Posicion_lista;
  function Recuperar(p: Posicion_lista; var x : TipoElemento): Errores;
  function Actualizar(x: TipoElemento; p: Posicion_lista): Errores;
  function Validar(p: Posicion_lista): Boolean;
  procedure graficar(lugar_grafico:TImage);
  end;

implementation

  procedure Lista.Crearvacia;
  begin
    Inicio:= Nulo;
    Final:= Nulo;
    q_item:= 0;
  end;

  function Lista.Esvacia(): Boolean;
  begin
    Esvacia:= (Inicio=Nulo);
  end;

  function Lista.Esllena(): Boolean;
  begin
    Esllena:=(Final=Max)
  end;

  function Lista.Agregar(x: TipoElemento): Errores;
  begin
    If Esllena then
       Agregar:= LLeno
    else
        begin
          Inc(Final); //Final:= Final+1;
          Elementos[Final].AsignarValores(x);
          If Esvacia then
             Inicio:= Min;
          Inc(q_item);
          Agregar:= Ok;
        end;
  end;

  function Lista.Insertar(x: TipoElemento; p: Posicion_lista): Errores;
  var
    q: Posicion_Lista;
  begin
    If Esllena then
       Insertar:= LLeno
    else
       If Esvacia then
          Insertar:=Agregar(x)
       else
           If Not Validar(p) then
              Insertar:= PosicionInvalida
           else
               begin
                 For q:= Final Downto p do
                     Elementos[q+1].AsignarValores(Elementos[q]);
                 Elementos[p].AsignarValores(x);
                 Inc(Final);
                 Inc(q_item);
                 Insertar:= Ok;
               end;
  end;

  function Lista.Eliminar(p: Posicion_lista): Errores;
  var
    q: Posicion_Lista;
  begin
    If Esvacia then
       Eliminar:= Vacio
    else
       If Not Validar(p) then
          Eliminar:= PosicionInvalida
       else
          begin
            If (Inicio=Final) then
               Crearvacia
            else
                begin
                  For q:= p to Final-1 do
                      Elementos[q].AsignarValores(Elementos[q+1]);
                  Dec(Final);
                  Dec(q_item);
                end;
            Eliminar:= Ok;
          end;
  end;

  function Lista.Buscar(x: TipoElemento; Comparar: Campo_Comparar): Posicion_lista;
  var
    q: Posicion_Lista; Enc: Boolean;
  begin
    Buscar:= Nulo;
    q:= Inicio;
    Enc:= False;
    While (q<>Nulo) and Not (Enc) do
          begin
               If x.CompararTE(Elementos[q], Comparar)= Igual then
                  begin
                       Buscar:=q;
                       Enc:= True;
                  end;
               q:= Siguiente(q);
          end;
  end;

  function Lista.Siguiente(p: Posicion_lista): Posicion_lista;
  begin
    If p=Final Then
       Siguiente:= Nulo
    else
       Siguiente:= p+1;
  end;

  function Lista.Anterior(p: Posicion_lista): Posicion_lista;
  begin
    If p=Inicio Then
       Anterior:= Nulo
    else
       Anterior:= p-1;
  end;

  function Lista.Recuperar(p: Posicion_lista; var x : TipoElemento): Errores;
  begin
    If Not Validar(p) then
       Recuperar:= PosicionInvalida
    else
       begin
            x.AsignarValores(Elementos[p]);
            Recuperar:= Ok;
       end;
  end;

  function Lista.Actualizar(x: TipoElemento; p: Posicion_lista): Errores;
  begin
    If Not Validar(p) then
       Actualizar:= PosicionInvalida
    else
        begin
             Elementos[p].AsignarValores(x);
             Actualizar:=Ok;
        end;
  end;

  function Lista.Validar(p: Posicion_lista): Boolean;
  begin
    Validar:=(p>=Min) and (p<= Max);
  end;

procedure lista.graficar(lugar_grafico:TImage);
var
   UnProceso: TProcess;
   picture1: TPicture;
   i: integer;
   FileVar: TextFile;
   p: posicion_lista;
   si,ant: string;
   links: string;
   x,y: tipoelemento;
begin
   // Genero el archivo para mostrar la lista desde GraphViz
   AssignFile(FileVar, './Test.txt');
   try
    Rewrite(FileVar);  // creating the file
    Writeln(FileVar,'digraph G{');
    Writeln(FileVar,'  rankdir=LR;');
    Writeln(FileVar,'    node [shape=record];');
    p:= inicio;
    i:=1;
    links:='';
    while (p <> nulo) do
      begin
        str(i,si);
        recuperar(p,x);
        Writeln(FileVar,'    node' +  si + ' [ label ="<f0>' + x.DS + ' | <f1>"];');

        if (i > 1) then
          begin
            str((i-1),ant);
            links:=links + '"node' + ant + '":f1 -> "node' + si + '":f0;' + char(13);
          end;
        p:=siguiente(p);
        i:=i+1;
      end;
    str(i,si);
    str((i-1),ant);
    links:=links + '"node' + ant + '":f1 -> "node' + si + '":f0;';
    Writeln(FileVar,'    node' + si + '[ label ="<f0>' + 'null' + '"];');
        Writeln(FileVar,links);
        Writeln(FileVar,'}');
       except
        Writeln('ERROR! IORESULT: ' + IntToStr(IOResult));
       end;
      CloseFile(FileVar);

       // Ahora creamos UnProceso.
       UnProceso := TProcess.Create(nil);

       // Asignamos a UnProceso la orden que debe ejecutar.
       UnProceso.CommandLine := 'dot -Tpng ./Test.txt -o ./lista.png';
       UnProceso.Options := UnProceso.Options + [poWaitOnExit, poUsePipes];

       // Lanzamos la ejecución ...
       UnProceso.Execute;

       // Nuestro programa se detiene hasta que 'ppc386' finaliza.
       UnProceso.Free;

       // Muestro el resultado del graphviz
       picture1 := TPicture.Create;
       picture1.LoadFromFile('./lista.png');
       lugar_grafico.Picture.Assign(picture1);
    end;


end.

