unit Main_U;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Filter.Effects,
  FMX.Maps, FMX.Colors, FMX.Edit, FMX.ScrollBox, FMX.Memo, FMX.ListBox,
  IdMultipartFormData,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  FMX.Layouts, StrUtils;

type
  TfrmMain = class(TForm)
    StyleBook1: TStyleBook;
    edtAvatar: TEdit;
    edtName: TEdit;
    memoMessage: TMemo;
    lblAvatar: TLabel;
    lblName: TLabel;
    lblMessage: TLabel;
    cmbChannel: TComboBox;
    btnSend: TButton;
    httpclient1: TIdHTTP;
    lblSuperSayf: TLabel;
    btnAddWebhook: TButton;
    lsbLinks: TListBox;
    procedure btnSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnAddWebhookClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TfrmMain.btnAddWebhookClick(Sender: TObject);
var
  sChannel, sLink: String;
  myFile: TextFile;
  text: string;
begin

  sChannel := InputBox('DWMC', 'Please enter a name for the Webhook', '');

  if length(sChannel) > 1 then
  begin

    if ContainsText(sChannel, '#') then
    begin
      ShowMessage('Please do not use a # in your webhook name');
    end
    else
    begin

      sLink := InputBox('DWMC', 'Please enter the webhook link', '');

      AssignFile(myFile, 'Test.txt');
      ReWrite(myFile);
      WriteLn(myFile, sChannel + '#' + sLink);
      CloseFile(myFile);

    end;

  end
  else
  begin
    ShowMessage('Please enter a name');
  end;

end;

procedure TfrmMain.btnSendClick(Sender: TObject);
var
  sMessage, sUsername, sAvatar, sChannel: String;
  params: TIdMultipartFormDataStream;
  iIndex: Integer;
begin

  sMessage := memoMessage.text;
  sUsername := edtName.text;
  sAvatar := edtAvatar.text;

  if sAvatar = '' then
  begin
    sAvatar :=
      'https://e7.pngegg.com/pngimages/888/805/png-clipart-discord-computer-icons-android-icons-combat-arena-android-game-smiley-thumbnail.png';
  end;

  iIndex := cmbChannel.ItemIndex;
  lsbLinks.Index := iIndex;
  sChannel := lsbLinks.Items[lsbLinks.Index];

  if (cmbChannel.ItemIndex <> -1) then
  begin
    params := TIdMultipartFormDataStream.Create;
    try
      params.AddFormField('content', sMessage);
      params.AddFormField('username', sUsername);
      params.AddFormField('avatar_url', sAvatar);

      httpclient1.Request.UserAgent :=
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36';
      httpclient1.Post(sChannel, params);
    finally
      params.Free;
    end;
    memoMessage.ClearContent;
    memoMessage.SetFocus;
  end
  else
  begin
    ShowMessage('Please choose a channel to send a message');
    cmbChannel.SetFocus;
  end;

end;

procedure TfrmMain.FormActivate(Sender: TObject);
var
  myFile: TextFile;
  text, sChannel, sLink: string;
  iCount, iPos: Integer;
begin
  iCount := 0;

  if FileExists('Data.txt') then
  begin
    AssignFile(myFile, 'Data.txt');
    Reset(myFile);
  end
  else
  begin
    FileCreate('Data.txt');
    AssignFile(myFile, 'Data.txt');
    Reset(myFile);
  end;

  if FileSize(myFile) <> 0 then
  begin
    while not Eof(myFile) do
    begin
      ReadLn(myFile, text);
      iPos := Pos('#', text);
      sChannel := Copy(text, 1, iPos - 1);
      cmbChannel.Items.Add(sChannel);
      Delete(text, 1, iPos);
      lsbLinks.Items.Add(text);
      Inc(iCount);
    end;
  end;

  CloseFile(myFile);

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;

end;

end.
