unit Tipos;

{$mode objfpc}{$H+}

interface
type
  Campo_Comparar = (campo1, campo2, campo3, campo1y2, campo1y3, campo2y3, campo123);
  Comparacion    = (menor, igual, mayor, distinto, error);
  Errores        = (Vacio, LLeno, PosicionInvalida, Otro, OK);
  TipoElemento   = object
    DS: string;
    DN: Longint;
    DR: Real;
    DV: Variant;
    DP: Pointer;
    procedure Inicializar;
    procedure Azar(N: Integer);
    procedure AsignarValores(X: TipoElemento);
    function CompararTE(X2: TipoElemento; Comparar: Campo_Comparar): Comparacion;
  end;

implementation

procedure TipoElemento.Inicializar;
begin
     DS := '';
     DN := 0;
     DR := 0.0;
end;

procedure TipoElemento.Azar(N: Integer);
begin
     DN := Random(N);
end;

procedure TipoElemento.AsignarValores(X: TipoElemento);
begin
     DN := X.DN;
     DS := X.DS;
     DR := X.DR;
     DV := X.DV;
     DP := X.DP;
end;

function TipoElemento.CompararTE(X2: TipoElemento;
  Comparar: Campo_Comparar): Comparacion;
begin
     CompararTE := distinto;
     case Comparar of
                   campo1: if DS = X2.DS then
                              CompararTE := igual
                           else
                               if DS < X2.DS then
	                          CompararTE := menor
                               else
                                  CompararTE := mayor;
                   campo2: if DN = X2.DN then
                              CompararTE := igual
                           else
                               if DN < X2.DN then
                                  CompararTE := menor
                               else
                                  CompararTE := mayor;
                   campo3: if DR = X2.DR then
                              CompararTE := igual
                           else
                               if DR < X2.DR then
                                  CompararTE := menor
                               else
	                           CompararTE := mayor;
	           campo1y2: if (DS = X2.DS) and (DN = X2.DN) then
	                     CompararTE := igual;
	           campo1y3: if (DS = X2.DS) and (DR = X2.DR) then
	                     CompararTE := igual;
	           campo2y3: if (DN = X2.DN) and (DR = X2.DR) then
	                     CompararTE := igual;
	           campo123: if (DS = X2.DS) and (DN = X2.DN) and (DR = X2.DR) then
	                     CompararTE := igual;
                   else
                       CompararTE := error;
     end;
end;

end.

