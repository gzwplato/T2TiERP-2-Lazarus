{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [CONTABIL_DRE_CABECALHO] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2016 T2Ti.COM                                          
                                                                                
Permission is hereby granted, free of charge, to any person                     
obtaining a copy of this software and associated documentation                  
files (the "Software"), to deal in the Software without                         
restriction, including without limitation the rights to use,                    
copy, modify, merge, publish, distribute, sublicense, and/or sell               
copies of the Software, and to permit persons to whom the                       
Software is furnished to do so, subject to the following                        
conditions:                                                                     
                                                                                
The above copyright notice and this permission notice shall be                  
included in all copies or substantial portions of the Software.                 
                                                                                
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,                 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES                 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                        
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT                     
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,                    
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING                    
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR                   
OTHER DEALINGS IN THE SOFTWARE.                                                 
                                                                                
       The author may be contacted at:                                          
           t2ti.com@gmail.com                                                   
                                                                                
@author Albert Eije (t2ti.com@gmail.com)                    
@version 2.0                                                                    
*******************************************************************************}
unit ContabilDreCabecalhoVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL,
  ContabilDreDetalheVO;

type
  TContabilDreCabecalhoVO = class(TVO)
  private
    FID: Integer;
    FID_EMPRESA: Integer;
    FDESCRICAO: String;
    FPADRAO: String;
    FPERIODO_INICIAL: String;
    FPERIODO_FINAL: String;

    //Transientes
    FListaContabilDreDetalheVO: TListaContabilDreDetalheVO;


  published
    constructor Create; override;
    destructor Destroy; override;

    property Id: Integer  read FID write FID;
    property IdEmpresa: Integer  read FID_EMPRESA write FID_EMPRESA;
    property Descricao: String  read FDESCRICAO write FDESCRICAO;
    property Padrao: String  read FPADRAO write FPADRAO;
    property PeriodoInicial: String  read FPERIODO_INICIAL write FPERIODO_INICIAL;
    property PeriodoFinal: String  read FPERIODO_FINAL write FPERIODO_FINAL;


    //Transientes
    property ListaContabilDreDetalheVO: TListaContabilDreDetalheVO read FListaContabilDreDetalheVO write FListaContabilDreDetalheVO;


  end;

  TListaContabilDreCabecalhoVO = specialize TFPGObjectList<TContabilDreCabecalhoVO>;

implementation

constructor TContabilDreCabecalhoVO.Create;
begin
  inherited;

  FListaContabilDreDetalheVO := TListaContabilDreDetalheVO.Create;
end;

destructor TContabilDreCabecalhoVO.Destroy;
begin
  FreeAndNil(FListaContabilDreDetalheVO);

  inherited;
end;

initialization
  Classes.RegisterClass(TContabilDreCabecalhoVO);

finalization
  Classes.UnRegisterClass(TContabilDreCabecalhoVO);

end.
