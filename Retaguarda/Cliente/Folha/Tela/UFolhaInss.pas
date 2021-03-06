{ *******************************************************************************
Title: T2Ti ERP
Description: Janela de Reten��o do INSS para a Folha de Pagamento

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
t2ti.com@gmail.com</p>

@author Albert Eije (alberteije@gmail.com)
@version 2.0
******************************************************************************* }
unit UFolhaInss;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO, FolhaInssVO,
  FolhaInssController;

  type

  { TFFolhaInss }

  TFFolhaInss = class(TFTelaCadastro)
    CDSFolhaInssRetencao: TBufDataset;
    DSFolhaInssRetencao: TDataSource;
    PanelMestre: TPanel;
    PageControlItens: TPageControl;
    tsItens: TTabSheet;
    PanelItens: TPanel;
    GridDetalhe: TRxDbGrid;
    EditCompetencia: TLabeledMaskEdit;
    CDSFolhaInssRetencaoID: TIntegerField;
    CDSFolhaInssRetencaoID_FOLHA_INSS: TIntegerField;
    CDSFolhaInssRetencaoID_FOLHA_INSS_SERVICO: TIntegerField;
    CDSFolhaInssRetencaoVALOR_MENSAL: TFMTBCDField;
    CDSFolhaInssRetencaoVALOR_13: TFMTBCDField;
    procedure FormCreate(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridDetalheKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure BotaoConsultarClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure LimparCampos; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;

    procedure ConfigurarLayoutTela;
  end;

var
  FFolhaInss: TFFolhaInss;

implementation

uses FolhaInssServicoVO, FolhaInssServicoController, FolhaInssRetencaoVO;
{$R *.lfm}

{$REGION 'Controles Infra'}
procedure TFFolhaInss.BotaoConsultarClick(Sender: TObject);
var
  RetornoConsulta: TZQuery;
  ListaCampos: TStringList;
  i: integer;
begin
  inherited;

  if Sessao.Camadas = 2 then
  begin
    Filtro := MontaFiltro;

    CDSGrid.Close;
    CDSGrid.Open;
    ConfiguraGridFromVO(Grid, ClasseObjetoGridVO);

    ListaCampos  := TStringList.Create;
    RetornoConsulta := TFolhaInssController.Consulta(Filtro, IntToStr(Pagina));
    RetornoConsulta.Active := True;

    RetornoConsulta.GetFieldNames(ListaCampos);

    RetornoConsulta.First;
    while not RetornoConsulta.EOF do begin
      CDSGrid.Append;
      for i := 0 to ListaCampos.Count - 1 do
      begin
        CDSGrid.FieldByName(ListaCampos[i]).Value := RetornoConsulta.FieldByName(ListaCampos[i]).Value;
      end;
      CDSGrid.Post;
      RetornoConsulta.Next;
    end;
  end;
end;

procedure TFFolhaInss.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFFolhaInss.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TFolhaInssVO;
  ObjetoController := TFolhaInssController.Create;

  inherited;
  BotaoImprimir.Visible := False;
  MenuImprimir.Visible := False;
end;

procedure TFFolhaInss.LimparCampos;
begin
  inherited;
  CDSFolhaInssRetencao.Close;
  CDSFolhaInssRetencao.Open;
end;

procedure TFFolhaInss.ConfigurarLayoutTela;
begin
  PanelEdits.Enabled := True;

  if StatusTela = stNavegandoEdits then
  begin
    PanelMestre.Enabled := False;
    PanelItens.Enabled := False;
  end
  else
  begin
    PanelMestre.Enabled := True;
    PanelItens.Enabled := True;
  end;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFFolhaInss.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  ConfigurarLayoutTela;
  if Result then
  begin
    EditCompetencia.SetFocus;
  end;
end;

function TFFolhaInss.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  ConfigurarLayoutTela;
  if Result then
  begin
    EditCompetencia.SetFocus;
  end;
end;

function TFFolhaInss.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TFolhaInssController.Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    BotaoConsultar.Click;
end;

function TFFolhaInss.DoSalvar: Boolean;
var
  FolhaInssRetencao: TFolhaInssRetencaoVO;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TFolhaInssVO.Create;

      TFolhaInssVO(ObjetoVO).IdEmpresa := Sessao.Empresa.Id;
      TFolhaInssVO(ObjetoVO).Competencia := EditCompetencia.Text;

      // Reten��es
      CDSFolhaInssRetencao.DisableControls;
      CDSFolhaInssRetencao.First;
      while not CDSFolhaInssRetencao.Eof do
      begin
        FolhaInssRetencao := TFolhaInssRetencaoVO.Create;
        FolhaInssRetencao.Id := CDSFolhaInssRetencao.FieldByName('ID').AsInteger;
        FolhaInssRetencao.IdFolhaInss := TFolhaInssVO(ObjetoVO).Id;
        FolhaInssRetencao.IdFolhaInssServico := CDSFolhaInssRetencao.FieldByName('ID_FOLHA_INSS_SERVICO').AsInteger;
        FolhaInssRetencao.ValorMensal := CDSFolhaInssRetencao.FieldByName('VALOR_MENSAL').AsFloat;
        FolhaInssRetencao.Valor13 := CDSFolhaInssRetencao.FieldByName('VALOR_13').AsFloat;
        TFolhaInssVO(ObjetoVO).ListaFolhaInssRetencaoVO.Add(FolhaInssRetencao);
        CDSFolhaInssRetencao.Next;
      end;
      CDSFolhaInssRetencao.EnableControls;

      if StatusTela = stInserindo then
      begin
        TFolhaInssController.Insere(TFolhaInssVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        /// EXERCICIO: Verifique se tem como serializar as listas junto com o objeto para realizar a compara��o
        //if TFolhaInssVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        //begin
          TFolhaInssController.Altera(TFolhaInssVO(ObjetoVO));
        //end
        //else
        //Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFFolhaInss.GridDblClick(Sender: TObject);
begin
  inherited;
  ConfigurarLayoutTela;
end;

procedure TFFolhaInss.GridDetalheKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  {
  if Key = VK_F1 then
  begin
    try
     if Assigned(ViewPessoaColaboradorVO) then
      begin
        CDSFolhaInssRetencao.Append;
        CDSFolhaInssRetencao.FieldByName('ID_FOLHA_INSS_SERVICO').AsInteger := CDSTransiente.FieldByName('ID').AsInteger;
        CDSFolhaInssRetencao.Post;
      end;
    finally
    end;
  end;
  If Key = VK_RETURN then
    EditCompetencia.SetFocus;
    }
end;

procedure TFFolhaInss.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TFolhaInssController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditCompetencia.Text := TFolhaInssVO(ObjetoVO).Competencia;

    /// EXERCICIO: Carregue os dados da lista TFolhaInssVO(ObjetoVO).ListaFolhaInssRetencaoVO

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;

  ConfigurarLayoutTela;
end;
{$ENDREGION}

end.

