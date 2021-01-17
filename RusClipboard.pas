// Модуль который реализует корректный ввод и вывод буфера!
unit RusClipboard;

interface

uses Clipbrd;

type
  TRusClipboard = class(TClipboard)
   private
    procedure SetCodePage(const CodePage: longint);
   public
    procedure Open; override;
    procedure Close; override;
  end;

implementation

uses Windows;

{ TRusClipboard }

procedure TRusClipboard.Close;
begin
  SetCodePage($0419);
  inherited;
end;

procedure TRusClipboard.Open;
begin
  inherited;
  SetCodePage($0419);
end;

procedure TRusClipboard.SetCodePage(const CodePage: longint);
var Data: THandle;
    DataPtr: Pointer;
begin
  Data:= GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, 4);
  try
    DataPtr := GlobalLock(Data);
    try
      Move(CodePage, DataPtr^, 4);
      SetClipboardData(CF_LOCALE, Data);
     finally
      GlobalUnlock(Data);
    end;
   except
    GlobalFree(Data);
  end;
end;

var FClipboard: TClipboard;
    OldClipboard: TClipboard;

initialization
  FClipboard:= TRusClipboard.Create;
  OldClipboard:= SetClipboard(FClipboard);
  if OldClipboard <> nil then
    OldClipboard.Free;

end.