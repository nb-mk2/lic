unit TAD_cursores;

interface

uses
  Tipos, FileUtil, LResources,
  ExtCtrls, Process,Controls,StdCtrls,Graphics, SysUtils ;

Const
MIN = 1;
MAX = 10;
Nulo= 0;

Type
Posicion_Lista = LongInt;
Nodo_Lista = Record
Datos: TipoElemento;
Ante,Prox: Posicion_Lista;
End;

Lista = Object
Cursor: Array[MIN..MAX] Of Nodo_Lista;
Inicio, Final, Libre: Posicion_Lista;
Q_Item: LongInt;
  Procedure CrearVacia();
  Function EsVacia():Boolean;
  Function EsLlena():Boolean;
  Function ValidarPosicion(P:Posicion_Lista):Boolean;
  Function Agregar(X:TipoElemento):Errores;
  Function Insertar(X:TipoElemento; P:Posicion_Lista):Errores;
  Function Eliminar(P:Posicion_Lista):Errores;
  Function Buscar(X:TipoElemento; Comparar:Campo_Comparar):Posicion_Lista;
  Function Siguiente(P:Posicion_Lista):Posicion_Lista;
  Function Anterior(P:Posicion_Lista):Posicion_Lista;
  Function Recuperar(P:Posicion_Lista; Var X: TipoElemento):Errores;
  Function Actualizar(X:TipoElemento; P:Posicion_Lista):Errores;
  procedure graficar(lugar_grafico:TImage);
  End;

implementation

Procedure Lista.CrearVacia();
Var Q: Posicion_Lista;
Begin
  For Q:= MIN To (MAX-1) Do
  Begin
    Cursor[Q].Datos.Inicializar;
    Cursor[Q].Prox := Q + 1;
  End;
  Cursor[MAX].Prox := Nulo;
  Libre := MIN;
  Inicio := Nulo;
  Final := Nulo;
  Q_Item := 0;
End;

Function Lista.EsVacia(): boolean;
Begin
EsVacia := (Inicio = Nulo);
End;

Function Lista.EsLlena(): Boolean;
Begin
EsLlena := (Libre = Nulo);
End;

Function Lista.Agregar(X:TipoElemento):Errores;
Var Q: Posicion_Lista;
Begin
  If EsLlena Then
     Agregar := LLeno
  Else
  Begin
    Q:= Libre;
    Libre:= Cursor[Libre].Prox;
    Cursor[Q].Prox := Nulo;
    Cursor[Q].Ante := Final;
      If EsVacia Then
      Inicio := Q
      Else
      Cursor[Final].Prox := Q;
    Final := Q;
    Cursor[Final].Datos.AsignarValores(X);
    Q_Item:= Q_Item +1;
    Agregar:= OK;
  End;
End;


function Lista.Insertar(x: TipoElemento; p: Posicion_lista): Errores;
var
  q: Posicion_Lista;
begin
  If Esllena then
     Insertar:= LLeno
  else
     If Not Validarposicion(p) then
        Insertar:= PosicionInvalida
     else
         begin
           If Esvacia then
              Insertar:=Agregar(x)
           else
              begin
                q:=libre;
                Libre:= Cursor[Libre].Prox;
                cursor[q].prox:= p;
                cursor[q].Ante:= cursor[p].ante;
                if p=Inicio then
                   Inicio:= q
                else
                    cursor[cursor[p].ante].prox:=q;
                cursor[p].ante:=q;
                cursor[q].Datos.AsignarValores(x);
                Inc(q_item);
                Insertar:= Ok;
              end;
         end;
end;

function Lista.Eliminar(p: Posicion_lista): Errores;
  begin
    If Esvacia then
       Eliminar:= Vacio
    else
       If Not Validarposicion(p) then
          Eliminar:= PosicionInvalida
       else
          begin
            If ((Inicio=p) and (p=Final)) then
               Crearvacia
            else
                begin
                  if  (p= Inicio) then
                     begin
                       Inicio:= cursor[p].prox;
                       cursor[Inicio].ante:=Nulo;
                     end
                  else
                      if (p=final) then
                         begin
                           Final:= cursor[p].ante;
                           cursor[Final].prox:= Nulo;
                         end
                      else
                          begin
                            cursor[cursor[p].ante].prox:= cursor[p].prox;
                            cursor[cursor[p].prox].ante:=cursor[p].ante;
                          end;
                  Dec(q_item);
                end;
            cursor[p].prox:=libre;
            libre:=p;
            Eliminar:= Ok;
          end;
  end;



Function Lista.Buscar(X:TipoElemento; Comparar:Campo_Comparar):Posicion_Lista;
Var Q:Posicion_Lista;
Encontre:Boolean;
Begin
  Buscar := Nulo;
  Q := Inicio;
  Encontre := False;
    While (Q <> Nulo) And Not(Encontre) Do
      If X.CompararTE(Cursor[Q].Datos, Comparar) <> igual Then
      Q:= Siguiente(Q)
      Else
      Encontre := True;
      If Encontre Then
      Buscar := Q;
End;

Function Lista.Actualizar(X:TipoElemento; P:Posicion_Lista):Errores;
Begin
     If Not ValidarPosicion(P) Then
        Actualizar := PosicionInvalida
        Else
          Begin
               Cursor[P].Datos.AsignarValores(X);
               Actualizar := OK;
          End;
End;

Function Lista.ValidarPosicion(P:Posicion_Lista):Boolean;
Var Q: Posicion_Lista;
Begin
     ValidarPosicion := False;
      If Not(EsVacia) And (P <> Nulo) Then
      Begin
        Q:= Inicio;
        While (Q <> Nulo) And (Q <> P) Do
              Q := Cursor[Q].Prox ;
              If (Q = P) and (Q <> Nulo) Then
              ValidarPosicion := True;
      End;
End;

function Lista.Siguiente(p: Posicion_lista): Posicion_lista;
  begin
       Siguiente:= Cursor[p].prox;
  end;

  function Lista.Anterior(p: Posicion_lista): Posicion_lista;
  begin
       Anterior:= Cursor[p].ante;
  end;

  function Lista.Recuperar(p: Posicion_lista; var x : TipoElemento): Errores;
  begin
    If Not Validarposicion(p) then
       Recuperar:= PosicionInvalida
    else
       begin
            x.AsignarValores(Cursor[p].Datos);
            Recuperar:= Ok;
       end;
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

