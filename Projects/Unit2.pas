unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, ZConnection, ZDataset,
  ZDbcCache, ZAbstractRODataset, ZDbcMySQL, ZDbcPostgreSQL, DB, ZSqlUpdate,
  ComCtrls, ZDbcInterbase6, ZSqlMonitor, ZAbstractDataset, ZSequence,
  ZAbstractConnection,   OtlCommon,
  OtlTask,
  OtlTaskControl,
  OtlEventMonitor, OtlComm;

type


  TForm2 = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnExecute: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    dsdomain: TDataSource;
    btnTest: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PropertiesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  strict private
    FMessageDispatch: TOmniEventMonitor;
  private
    FConnection: TZConnection;
    FDataset: TZQuery;
    FUpdateSQL: TZUpdateSQL;
    procedure HandleTaskTerminated(const task: IOmniTaskControl);
    procedure HandleTaskMessage(const task: IOmniTaskControl; const msg: TOmniMessage);
    procedure RunHelloWorld(const task: IOmniTask);
  public
    property Connection: TZConnection read FConnection write FConnection;
    property Dataset: TZQuery read FDataset write FDataset;
    property UpdateSQL: TZUpdateSQL read FUpdateSQL write FUpdateSQL;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}



procedure TForm2.btnExecuteClick(Sender: TObject);
var
  I: Integer;
  FieldDefs: TFieldDefs;
  CalcField: TStringField;
begin
  Dataset.Close;

  Dataset.SQL.Text := 'SELECT * FROM domains WHERE `domain_name` LIKE "%' +Edit1.Text+ '%" LIMIT 100';
  Dataset.Fields.Clear;

  FieldDefs := Dataset.FieldDefs;
  FieldDefs.Update;

  if Dataset.FindField('Calculated') = nil then
  begin
    for I := 0 to FieldDefs.Count - 1 do
      FieldDefs[I].CreateField(Dataset).DataSet := Dataset;

    CalcField := TStringField.Create(nil);
    CalcField.Size := 10;
    CalcField.FieldName := 'Calculated';
    CalcField.FieldKind := fkCalculated;
    CalcField.Visible := True;
    CalcField.DataSet := Dataset;
  end;
 // dataset.SQL.Add('SELECT * FROM domains WHERE `domain_name LIKE` ''%powerseller%'' LIMIT 500');
  Dataset.Open;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Connection.Connect;
  ShowMessage(inttostr(Connection.Port));
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Connection.Disconnect;
end;

procedure TForm2.btnTestClick(Sender: TObject);
begin
  btnTest.Enabled := false;
  FMessageDispatch.Monitor(CreateTask(RunHelloWorld, 'HelloWorld')).Run;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin


  FMessageDispatch := TOmniEventMonitor.Create(Self);
  FMessageDispatch.OnTaskMessage := HandleTaskMessage;
  FMessageDispatch.OnTaskTerminated := HandleTaskTerminated;

  Connection := TZConnection.Create(Self);
  Dataset := TZQuery.Create(Self);
  Dataset.Connection := FConnection;
  //ZSequence.Connection:=Connection;
  //ZSequence.SequenceName:='t1_id_seq';
 //DataSet.sequence:=ZSequence;
  //Dataset.SequenceField:='ID';

//iDirectional := True;
Connection.SQLHourGlass := true;

  dataset.SQL.Add('SELECT * FROM domains LIMIT 500');

  dsDomain.Dataset := Dataset;

  UpdateSQL := TZUpdateSQL.Create(Self);
  UpdateSQL.DeleteSQL.Add('DELETE FROM T1 WHERE id=:OLD_ID');
  UpdateSQL.ModifySQL.Add('UPDATE T1 SET ID=:ID, A=:A, B=:B WHERE id=:OLD_ID');
  UpdateSQL.InsertSQL.Add('INSERT INTO T1 (id,a,b) VALUES (:ID,55, 66)');
  UpdateSQL.RefreshSQL.Add('SELECT * FROM T1 WHERE ID=:OLD_ID');
  //UpdateSQL.Refresh_OLD_ID_SEQ:=true;

  Dataset.UpdateObject:=UpdateSQL;


  PropertiesChange(Self);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  Connection.Free;
end;

procedure TForm2.PropertiesChange(Sender: TObject);
begin
  Connection.Protocol := 'mysql';
  Connection.HostName := '109.74.196.224';
  Connection.Database := 'domains';
  Connection.User := 'christo';
  Connection.Password := ':H7/Ca44dt';
  //Dataset.SQL := memQuery.Lines;
  //Dataset.Fields.Clear;

//  UpdateSQL.InsertSQL := memInsert.Lines;
//  UpdateSQL.ModifySQL := memUpdate.Lines;
//  UpdateSQL.DeleteSQL := memDelete.Lines;
end;

procedure TForm2.HandleTaskTerminated(const task: IOmniTaskControl);
begin
  //lbLog.ItemIndex := lbLog.Items.Add(Format('[%d/%s] Terminated', [task.UniqueID, task.Name]));
  btnTest.Enabled := true;
end; { TfrmTestOTL.HandleTaskTerminated }

procedure TForm2.HandleTaskMessage(const task: IOmniTaskControl; const msg:  TOmniMessage);
begin
   // lbLog.ItemIndex := lbLog.Items.Add(Format('[%d/%s] %d|%s', [task.UniqueID, task.Name, msg.msgID, msg.msgData.AsString]));
end;

procedure TForm2.RunHelloWorld(const task: IOmniTask);
var
  I: Integer;
  FieldDefs: TFieldDefs;
  CalcField: TStringField;
begin
  Dataset.Close;

  Dataset.SQL.Text := 'SELECT * FROM domains WHERE `domain_name` LIKE "%' +Edit1.Text+ '%" LIMIT 5000';
  Dataset.Fields.Clear;

  FieldDefs := Dataset.FieldDefs;
  FieldDefs.Update;

  if Dataset.FindField('Calculated') = nil then
  begin
    for I := 0 to FieldDefs.Count - 1 do
      FieldDefs[I].CreateField(Dataset).DataSet := Dataset;

    CalcField := TStringField.Create(nil);
    CalcField.Size := 10;
    CalcField.FieldName := 'Calculated';
    CalcField.FieldKind := fkCalculated;
    CalcField.Visible := True;
    CalcField.DataSet := Dataset;
  end;
 // dataset.SQL.Add('SELECT * FROM domains WHERE `domain_name LIKE` ''%powerseller%'' LIMIT 500');
  Dataset.Open;
end;

end.
