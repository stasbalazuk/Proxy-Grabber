unit Unit1;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdHTTP, Buttons, RegExpr,
  httpsend, syncobjs,
  urlmon, wininet,
  Registry, IniFiles,
  XPMan,
  ExtCtrls, jpeg, IdBaseComponent,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TForm1 = class(TForm)
    IdAntiFreeze1: TIdAntiFreeze;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    dublikat: TButton;
    memo1: TMemo;
    chek: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    btn1: TButton;
    btn2: TButton;
    cb: TCheckBox;
    procedure Image4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure sMemo2Change(Sender: TObject);
    procedure dublikatClick(Sender: TObject);
    procedure chekClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure memo1Click(Sender: TObject);
    procedure cbClick(Sender: TObject);
    procedure SelLine(Index: integer);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//Поток
type
 TPotok=class(TThread)
  private
   html:WideString;
      procedure reg;
  protected
   procedure Execute;override;
end;

//Чекер
type th = class(TThread)
  private
    ip, port: string;
    rez: integer;
  public
    curproxy: integer;
    http: thttpsend;
    procedure sync;
  protected
    procedure Execute; Override;
end;

const
  INTERNET_OPTION_PER_CONNECTION_OPTION = 75;
  INTERNET_PER_CONN_FLAGS                        = 1;
  INTERNET_PER_CONN_PROXY_SERVER                 = 2;
  INTERNET_PER_CONN_PROXY_BYPASS                 = 3;
  INTERNET_PER_CONN_AUTOCONFIG_URL               = 4;
  INTERNET_PER_CONN_AUTODISCOVERY_FLAGS          = 5;
  INTERNET_PER_CONN_AUTOCONFIG_SECONDARY_URL     = 6;
  INTERNET_PER_CONN_AUTOCONFIG_RELOAD_DELAY_MINS = 7;
  INTERNET_PER_CONN_AUTOCONFIG_LAST_DETECT_TIME  = 8;
  INTERNET_PER_CONN_AUTOCONFIG_LAST_DETECT_URL   = 9;
  PROXY_TYPE_DIRECT              =                $00000001;  // direct to net
  PROXY_TYPE_PROXY               =                $00000002;  // via named proxy
  PROXY_TYPE_AUTO_PROXY_URL      =                $00000004;  // autoproxy URL
  PROXY_TYPE_AUTO_DETECT         =                $00000008;  // use autoproxy detection
 type
  PINTERNET_PER_CONN_OPTION = ^INTERNET_PER_CONN_OPTION;
  INTERNET_PER_CONN_OPTION = record
  dwOption : DWORD;            // option to be queried or set
  case Byte of
       0: (dwValue: DWORD);        // dword value for the option
       1: (pszValue: LPSTR);       // pointer to string value for the option
       2: (ftValue: FILETIME);        // file-time value for the option
  end;

  INTERNET_PER_CONN_OPTION_LIST = record
  dwSize: DWORD;             // size of the INTERNET_PER_CONN_OPTION_LIST struct
  pszConnection: LPSTR;      // connection name to set/query options
  dwOptionCount: DWORD;      // number of options to set/query
  dwOptionError: DWORD;      // on error, which option failed
  pOptions: PINTERNET_PER_CONN_OPTION; // array of options to set/query
end;

var
  Form1: TForm1;
  Potok:TPotok;
  HTTP:TIdHTTP;
  TMPSite: TStringList;
  sip,sport: string;
  site, html,s:string;
  rege:tregexpr;
  i:integer;
  //Чекер
  proxys: tstringlist;
  proxy, thread: integer;
  work,stat: boolean;
  cs: tcriticalsection;
  good: textfile;
  urls,masks: string;

implementation

uses Unit2;

{$R *.dfm}

procedure TPotok.reg;
begin
 Form1.memo1.Lines.Add(rege.Match[0]);
 Form1.Label1.Caption:=IntToStr(Form1.memo1.Lines.Count);
 Form1.memo1.Lines.SaveToFile('Proxy0');
end;

procedure TPotok.Execute;
begin
  for i:=0 to TMPSite.Count-1 do
  begin
    try
      site:=TMPSite.Strings[i];
      html:=HTTP.Get(site);
    except
    end;
    if rege.Exec(html) then
     repeat Synchronize(reg);
     until (not rege.ExecNext) or Potok.Terminated;
    if Potok.Terminated then begin
       break;
    end;
  end;
  HTTP.Free;
  Rege.Free;
  Form1.dublikat.Click;
end;

procedure th.Execute;
begin
  while work do begin
    CS.Enter;
    Inc(Proxy);
    if Proxy<Proxys.Count then CurProxy:=Proxy else Work:=False;
    Cs.Leave;
    if work then begin
      http:=thttpsend.Create;
      if Form1.RadioButton1.Checked=true then begin
        ip:=Copy(Proxys[CurProxy],1,Pos(':', Proxys[CurProxy])-1);
        port:=Copy(Proxys[CurProxy], Pos(':', Proxys[CurProxy])+1, Length(Proxys[CurProxy]));
        http.ProxyHost:=ip;
        http.ProxyPort:=port;
        urls:=ip;
      end;
      if Form1.RadioButton2.Checked=true then begin
        ip:=Copy(Proxys[CurProxy],1,Pos(':', Proxys[CurProxy])-1);
        port:=Copy(Proxys[CurProxy], Pos(':', Proxys[CurProxy])+1, Length(Proxys[CurProxy]));
        http.Sock.SocksIP:=ip;
        http.Sock.SocksPort:=port;
        urls:=ip;
      end;
      http.Document.Clear;
      http.Headers.Clear;
      http.Timeout:=2000;
      http.Protocol:='1.1';
      if http.HTTPMethod('GET', urls) then begin
         rez:=1;
      end else
         rez:=-1;
      http.Free;
      Synchronize(Sync);
    end
  end;
end;

procedure th.sync;
begin
  case rez of
    1:begin
      Form1.Memo1.Lines.Add(ip+':'+port);
    end;
    -1:begin
      Form1.Memo1.Lines.Add(ip+'-ERROR')
    end;
  end;
  Form1.Label1.Caption:=IntToStr(Form1.memo1.Lines.Count);
end;

function SetProxyGlobal( const AProxyHost: string; AProxyPort: Word ): Boolean;
var
 lList:  INTERNET_PER_CONN_OPTION_LIST;
 lOption: array[0..1] of INTERNET_PER_CONN_OPTION;
 lProxy: string;
 lResetProxy: Boolean;
begin
 lResetProxy := (AProxyHost = '') or (AProxyPort = 0);
 lProxy := AProxyHost + ':' + IntToStr( AProxyPort );
 lOption[0].dwOption := INTERNET_PER_CONN_FLAGS;
 if lResetProxy then
    lOption[0].dwValue := PROXY_TYPE_DIRECT
 else
    lOption[0].dwValue := PROXY_TYPE_PROXY;
    lOption[1].dwOption := INTERNET_PER_CONN_PROXY_SERVER;
    lOption[1].pszValue := PChar( lProxy );
    lList.dwSize := SizeOf(INTERNET_PER_CONN_OPTION_LIST);
    lList.pszConnection := nil;
 if lResetProxy then
    lList.dwOptionCount := 1
 else
    lList.dwOptionCount := 2;
    lList.dwOptionError := 0;
    lList.pOptions := @lOption[0];
    Result := InternetSetOption( nil, INTERNET_OPTION_PER_CONNECTION_OPTION, @lList, SizeOf(INTERNET_PER_CONN_OPTION_LIST) );
 if Result then
    InternetSetOption(nil, INTERNET_OPTION_REFRESH, nil, 0);
end;

//--------------- Процедура установки подключения к прокси-серверу -----------//
procedure IE_Reread_Registry_Settings;
var
  HInet: HINTERNET;
begin
  hInet := InternetOpen(PChar('YourAppName'), INTERNET_OPEN_TYPE_DIRECT,
  nil, nil, INTERNET_FLAG_OFFLINE);
  try
  if hInet <> nil then
     InternetSetOption(hInet, INTERNET_OPTION_SETTINGS_CHANGED, nil, 0);
  finally
     InternetCloseHandle(hInet);
  end;
end;

Procedure ShowControlApplet(ctr : PChar);
var
 si: TStartupInfo;
 pi: TProcessInformation;
 s: string;
Begin
 s:= 'control.exe '+ ctr + #0;
 ZeroMemory(@si,sizeof(TSTARTUPINFO));
 si.cb := sizeof(TSTARTUPINFO);
 CreateProcess(nil,@s[1], nil, nil,FALSE, NORMAL_PRIORITY_CLASS, nil, nil, si, pi);
End;

procedure TForm1.SelLine(Index: integer);
begin
  with Memo1 do
    begin
      SelStart := Perform(EM_LINEINDEX, Index, 0);
      SelLength := Length(Lines[Index]);
      SetFocus;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
label vx;
var
 y,z: Integer;
 s: string;
begin
  if memo1.Lines.Count <= 0 then memo1.Lines.LoadFromFile('Proxy0');
  vx:
  for z:=0 to memo1.Lines.Count-1 do begin
      s:=memo1.Lines.Strings[z];
      y:=Pos('ERROR',s);
      if y > 0 then begin
         Label1.Caption:=IntToStr(Form1.memo1.Lines.Count);
         memo1.Lines.Delete(z);
         stat:=True;
      end;
  end;
  if stat then goto vx
  else begin
  stat:=False;
  memo1.Lines.SaveToFile('Proxy0');
  memo1.clear;
  memo1.Lines.LoadFromFile('Proxy0');
  Label1.Caption:=IntToStr(Form1.memo1.Lines.Count);  
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   if memo1.Lines.Count > 1 then
      memo1.Lines.SaveToFile('good_ip');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
if not Assigned(Potok) then
    ShowMessage('Программа не запущена')
else begin
    Potok.Terminate;
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 HTTP:=TIdHTTP.Create(nil);  // экземпляр tidhttp
 rege:=TRegExpr.Create;
 rege.Expression:='\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}';
 Potok:=TPotok.Create(true); //т.к запускаем через Resume
 Potok.Priority:=tpLower;
 Potok.FreeOnTerminate:=True;
 Potok.Resume;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 Potok.suspend;
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
 memo1.clear;
end;

procedure TForm1.sMemo2Change(Sender: TObject);
begin
 Label1.Caption:=IntToStr(memo1.lines.count);
end;

procedure TForm1.dublikatClick(Sender: TObject);
var
 i,j:integer;
begin
if not FileExists('Proxy0') then Exit;
memo1.Lines.LoadFromFile('Proxy0');
for i:=memo1.Lines.Count-1 downto 0 do
 for j:=i-1 downto 0 do
  if memo1.Lines[i]=memo1.Lines[j] then memo1.Lines.Delete(i);
  Form1.Label1.Caption:=IntToStr(Form1.memo1.Lines.Count);
  if not stat then chek.Click;
end;

procedure TForm1.chekClick(Sender: TObject);
label vx;
begin
  memo1.Clear;
  Proxys.Clear;
  stat:=False;
  Proxys.LoadFromFile('Proxy0');
  Label1.Caption:=inttostr(proxys.Count);
if proxys.Count<>0 then begin
   Proxy:=-1;
   Work:=True;
  for Thread:=0 to 50 do
  begin
    th.Create(false);
  end;
end else ShowMessage('Необходимо выбрать файл с прокси!');
Button1.Click;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
  s: string;
begin
stat:=False;
masks:='10.*.*';
TMPSite:=TStringList.Create;
Proxys:=tstringlist.Create;
cs:=tcriticalsection.Create;
TMPSite.Add('http://2freeproxy.com/elite-proxy.html');
TMPSite.Add('http://2freeproxy.com/anonymous-proxy.html');
TMPSite.Add('http://2freeproxy.com/socks-proxy.html');
TMPSite.Add('http://2freeproxy.com/socks4.html');
TMPSite.Add('http://2freeproxy.com/socks5.html');
TMPSite.Add('http://2freeproxy.com/https-proxy.html');
TMPSite.Add('http://2freeproxy.com/us-proxy.html');
TMPSite.Add('http://2freeproxy.com/canada-proxy.html');
TMPSite.Add('http://2freeproxy.com/france-proxy.html');
TMPSite.Add('http://2freeproxy.com/uk-proxy.html');
TMPSite.Add('http://www.freeproxylists.net/ru/');
TMPSite.Add('http://fineproxy.org/freshproxy');
TMPSite.Add('http://nntime.com/');
TMPSite.Add('http://premproxy.com/list/');
TMPSite.Add('http://cool-proxy.ru/');
TMPSite.Add('http://spys.one/aproxy/');
TMPSite.Add('http://spys.one/socks/');
TMPSite.Add('http://spys.one/');
TMPSite.Add('http://xseo.in/freeproxy');
TMPSite.Add('http://awmproxy.com/');
TMPSite.Add('http://webanet.ucoz.ru/publ/24');
TMPSite.Add('http://www.cool-tests.com/anon-elite-proxy.php');
TMPSite.Add('http://www.socks-proxy.net/');
Ini := TIniFile.Create(GetCurrentDir+'\proxy.ini');
s:=Ini.ReadString('proxy','ActivProxy','');// записываем в Ini файл строку
if s = '0' then cb.Checked:=False;
if s = '1' then cb.Checked:=True;
Ini.Free;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
if (sip <> '') and (sport <> '') then begin
 SetProxyGlobal(sip,StrToInt(sport));
 IE_Reread_Registry_Settings;
 Caption:='Прокси '+sip+':'+sport+' - установлен!';
end;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  ShowControlApplet('inetcpl.cpl,,4');
end;

procedure TForm1.memo1Click(Sender: TObject);
var
  r:TStringList;
  LineNum: longint;
  str,y: Integer;
begin
if memo1.Lines.Count > 1 then begin
  LineNum := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, Memo1.SelStart,0);{посылка сообщения, возвращающая номер строки}
  str:= LineNum;
  SelLine(str);
  y:=Pos('ERROR',memo1.Lines.Strings[str]);
  if y = 0 then begin
  R:=TStringList.Create;
  ExtractStrings([':'],[' '],PChar(memo1.Lines.Strings[str]),R);
  sip:=R[0];
  sport:=R[1];
  R.Free;
  Caption:='Прокси '+sip+':'+sport;
  end;
end;
end;

procedure TForm1.cbClick(Sender: TObject);
var
  Reg: TRegistry;
  Ini : TIniFile;
begin
  if cb.Checked then
   begin
   { создаём объект TRegistry }
   Reg := TRegistry.Create;
   { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
   Reg.RootKey := HKEY_CURRENT_USER;
   { открываем и создаём ключ }
   Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings',true);
   { записываем значение }
   Reg.WriteInteger('ProxyEnable',1);
   Reg.WriteString('ProxyOverride',masks+';<local>');
   { закрываем и освобождаем ключ }
   Reg.CloseKey;
   Reg.Free;
   Ini := TIniFile.Create(GetCurrentDir+'\proxy.ini');
   Ini.WriteString('proxy','ActivProxy','1');// записываем в Ini файл строку
   Ini.Free;
   end else
   begin
   { создаём объект TRegistry }
   Reg := TRegistry.Create;
   { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
   Reg.RootKey := HKEY_CURRENT_USER;
   { открываем и создаём ключ }
   Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings',true);
   { записываем значение }
   Reg.WriteInteger('ProxyEnable',0);
   Reg.WriteString('ProxyOverride',masks);
   { закрываем и освобождаем ключ }
   Reg.CloseKey;
   Reg.Free;
   Ini := TIniFile.Create(GetCurrentDir+'\proxy.ini');
   Ini.WriteString('proxy','ActivProxy','0');// записываем в Ini файл строку
   Ini.Free;
   end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   TMPSite.Free;
end;

end.
