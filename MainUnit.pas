unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Clipbrd, Menus, StdCtrls, ComCtrls, ImgList, RusClipboard, Help;

const
  VK_ALT = 18;

type
  TMainForm = class(TForm)
    Timer: TTimer;
    MainMenu: TMainMenu;
    mniChange: TMenuItem;
    mniHelp: TMenuItem;
    mniColorForm: TMenuItem;
    mniTransparencyForm: TMenuItem;
    mniAbout: TMenuItem;
    lblNum1: TLabel;
    lblNum2: TLabel;
    lblNum3: TLabel;
    lblNum4: TLabel;
    lblNum5: TLabel;
    mniColorActive: TMenuItem;
    mniColorNotActive: TMenuItem;
    dlgColorForm: TColorDialog;
    lblBuff1: TLabel;
    lblBuff2: TLabel;
    lblBuff3: TLabel;
    lblBuff4: TLabel;
    lblBuff5: TLabel;
    dlgFontActive: TFontDialog;
    dlgFontNotActive: TFontDialog;
    grpSetTransp: TGroupBox;
    trckbrbar: TTrackBar;
    ButtonButtCloseTransp: TButton;
    mniClearBuff: TMenuItem;
    mniClearAllBuff: TMenuItem;
    mniCloseForm: TMenuItem;
    ImageList: TImageList;
    mniN1: TMenuItem;
    mniN2: TMenuItem;
    mniN3: TMenuItem;
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniColorFormClick(Sender: TObject);
    procedure mniColorActiveClick(Sender: TObject);
    procedure mniColorNotActiveClick(Sender: TObject);
    procedure grpSetTranspMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grpSetTranspMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grpSetTranspMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonButtCloseTranspClick(Sender: TObject);
    procedure mniTransparencyFormClick(Sender: TObject);
    procedure trckbrbarChange(Sender: TObject);
    procedure mniClearBuffClick(Sender: TObject);
    procedure mniClearAllBuffClick(Sender: TObject);
    procedure mniCloseFormClick(Sender: TObject);
    procedure mniAboutClick(Sender: TObject);
    procedure lblNum5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  CurrVar: Integer = 1;
  MoveFlag: Boolean = false;
  cX, cY: Integer;

implementation

{$R *.dfm}

// Задать шрифт всем буферам
procedure ChangeFontBuff();
begin
  with MainForm do
  begin
    lblNum1.Font := dlgFontNotActive.Font;
    lblBuff1.Font := dlgFontNotActive.Font;
    lblNum2.Font := dlgFontNotActive.Font;
    lblBuff2.Font := dlgFontNotActive.Font;
    lblNum3.Font := dlgFontNotActive.Font;
    lblBuff3.Font := dlgFontNotActive.Font;
    lblNum4.Font := dlgFontNotActive.Font;
    lblBuff4.Font := dlgFontNotActive.Font;
    lblNum5.Font := dlgFontNotActive.Font;
    lblBuff5.Font := dlgFontNotActive.Font;
  end;
end;

// Изменяет шрифт не активных буферов и активного буфера  
procedure ChangeFont();
begin
  ChangeFontBuff();
  with MainForm do
    case CurrVar of
      1:
        begin
          lblNum1.Font := dlgFontActive.Font;
          lblBuff1.Font := dlgFontActive.Font;
        end;
      2:
        begin
          lblNum2.Font := dlgFontActive.Font;
          lblBuff2.Font := dlgFontActive.Font;
        end;
      3:
        begin
          lblNum3.Font := dlgFontActive.Font;
          lblBuff3.Font := dlgFontActive.Font;
        end;
      4:
        begin
          lblNum4.Font := dlgFontActive.Font;
          lblBuff4.Font := dlgFontActive.Font;
        end;
      5:
        begin
          lblNum5.Font := dlgFontActive.Font;
          lblBuff5.Font := dlgFontActive.Font;
        end;
    end;
end;

// Записать в буфер, если не удача - повторить рекурсивным вызовом!
procedure WriteToClipboard();
begin
  // Попытка
  try
    with MainForm do
      case CurrVar of
        1: lblBuff1.Caption := Clipboard.AsText;
        2: lblBuff2.Caption := Clipboard.AsText;
        3: lblBuff3.Caption := Clipboard.AsText;
        4: lblBuff4.Caption := Clipboard.AsText;
        5: lblBuff5.Caption := Clipboard.AsText;
      end;
  except
    // Если ошибка, повторить
    WriteToClipboard();
  end;
end;

// Изменить отступы, расстояние 2 от 1 (по высоте), 3 от 2, 4 от 3 и 5 от 4
procedure AlignElement();
begin
  with MainForm do
  begin
    lblNum2.Top := lblBuff1.Height;
    lblBuff2.Top := lblBuff1.Height;
    lblNum3.Top := lblBuff2.Top + lblBuff2.Height;
    lblBuff3.Top := lblBuff2.Top + lblBuff2.Height;
    lblNum4.Top := lblBuff3.Top + lblBuff3.Height;
    lblBuff4.Top := lblBuff3.Top + lblBuff3.Height;
    lblNum5.Top := lblBuff4.Top + lblBuff4.Height;
    lblBuff5.Top := lblBuff4.Top + lblBuff4.Height;
  end;
end;

// Отлавливаем нажатия клавиш и проверяем их
procedure TMainForm.TimerTimer(Sender: TObject);
begin
   // Если нажата кнопка ALT и одна из цифр [1..5] - переключение буфера
   try
     if GetKeyState(VK_ALT) and $8000 and GetKeyState(49) <> 0  then
     begin
      ChangeFontBuff();
      Clipboard.AsText := lblBuff1.Caption;
      lblNum1.Font := dlgFontActive.Font;
      lblBuff1.Font := dlgFontActive.Font;
      CurrVar := 1;
     end;
     if GetKeyState(VK_ALT) and $8000 and GetKeyState(50) <> 0  then
     begin
      ChangeFontBuff();
      Clipboard.AsText := lblBuff2.Caption;
      lblNum2.Font := dlgFontActive.Font;
      lblBuff2.Font := dlgFontActive.Font;
      CurrVar := 2;
     end;
     if GetKeyState(VK_ALT) and $8000 and GetKeyState(51) <> 0  then
     begin
      ChangeFontBuff();
      Clipboard.AsText := lblBuff3.Caption;
      lblNum3.Font := dlgFontActive.Font;
      lblBuff3.Font := dlgFontActive.Font;
      CurrVar := 3;
     end;
     if GetKeyState(VK_ALT) and $8000 and GetKeyState(52) <> 0  then
     begin
      ChangeFontBuff();
      Clipboard.AsText := lblBuff4.Caption;
      lblNum4.Font := dlgFontActive.Font;
      lblBuff4.Font := dlgFontActive.Font;
      CurrVar := 4;
     end;
     if GetKeyState(VK_ALT) and $8000 and GetKeyState(53) <> 0  then
     begin
      ChangeFontBuff();
      Clipboard.AsText := lblBuff5.Caption;
      lblNum5.Font := dlgFontActive.Font;
      lblBuff5.Font := dlgFontActive.Font;
      CurrVar := 5;
     end;
   except
   end;
   // Место где мы вырезаем или копируем строку
   if (GetKeyState(VK_CONTROL) and $8000 and GetKeyState(67) <> 0) or
      (GetKeyState(VK_CONTROL) and $8000 and GetKeyState(88) <> 0)
   then
   begin
    // Вызов записи в буфер, вынесено в функции т.к. возможна ошибка записи => надо повторить попытку
    WriteToClipboard();
    // И после того как скопируем наши строки в буфер и в наши label, скоректируем расстояние между label-ами
    AlignElement();
   end;
   // Скрыть программу (ALT + CRTL)
   if GetKeyState(VK_ALT) and $8000 and GetKeyState(VK_CONTROL) <> 0 then
      MainForm.AlphaBlendValue := 0;
   // Показать программу (SHIFT + CTRL)
   if GetKeyState(VK_SHIFT) and $8000 and GetKeyState(VK_CONTROL) <> 0 then
      MainForm.AlphaBlendValue := 255;
end;

// Инициализация при запуске формы
procedure TMainForm.FormShow(Sender: TObject);
begin
  // Функция WinApi, для вывода нашей формы поверх других приложений и форм
  SetWindowPos(MainForm.Handle,HWND_TOPMOST,Screen.Width - 442,0,450,175,
                                                                SWP_SHOWWINDOW);
  // Создать одну единственную форму (О программе)
  Application.CreateForm(TAbout, About);
  // Установить шрифт
  lblNum1.Font := dlgFontActive.Font;
  lblBuff1.Font := dlgFontActive.Font;
  // Установить прозрачность
  MainForm.AlphaBlend := True;
  MainForm.AlphaBlendValue := 255;
end;

// Вызывать редактор цвета для формы
procedure TMainForm.mniColorFormClick(Sender: TObject);
begin
  dlgColorForm.Execute;
  MainForm.Color := dlgColorForm.Color;
end;

// Вызывать редактор шрифта для активного буфера
procedure TMainForm.mniColorActiveClick(Sender: TObject);
begin
  dlgFontActive.Execute;
  ChangeFont();
end;

// Вызывать редактор шрифта для не активных буферов
procedure TMainForm.mniColorNotActiveClick(Sender: TObject);
begin
  dlgFontNotActive.Execute;
  ChangeFont();
end;

// Выставаить флаг сдвига в true, этот флаг ответчает за перемещение окна
// прозрачности, после того как мы отпустим кнопку, флаг = false => он перестанет передвигаться
procedure TMainForm.grpSetTranspMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MoveFlag := true;
  cX := X;
  cY := Y;
end;

// Передвижение окна прозрачности, если флаг = true
procedure TMainForm.grpSetTranspMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (MoveFlag) then
  begin
    grpSetTransp.Left := X - cX + grpSetTransp.Left;
    grpSetTransp.Top := Y - cY + grpSetTransp.Top;
  end;
end;

// Отпустили кнопку мыши и флаг = false
procedure TMainForm.grpSetTranspMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MoveFlag := false;
end;

// Кнопка закрыть окно прозрачности
procedure TMainForm.ButtonButtCloseTranspClick(Sender: TObject);
begin
  grpSetTransp.Visible := false;
end;

// Показать окно прозрачности, и поставить в верхний левый угол
procedure TMainForm.mniTransparencyFormClick(Sender: TObject);
begin
  grpSetTransp.Visible := true;
  grpSetTransp.Left := 0;
  grpSetTransp.Top := 0;
end;

// Изменение прозрачности фона формы
procedure TMainForm.trckbrbarChange(Sender: TObject);
begin
    MainForm.AlphaBlendValue := trckbrbar.Position;
end;

// Очистить текущий буфер
procedure TMainForm.mniClearBuffClick(Sender: TObject);
begin
    case CurrVar of
      1: lblBuff1.Caption := '';
      2: lblBuff2.Caption := '';
      3: lblBuff3.Caption := '';
      4: lblBuff4.Caption := '';
      5: lblBuff5.Caption := '';
    end;
    AlignElement();
end;

// Очистить буферы
procedure TMainForm.mniClearAllBuffClick(Sender: TObject);
begin
    lblBuff1.Caption := '';
    lblBuff2.Caption := '';
    lblBuff3.Caption := '';
    lblBuff4.Caption := '';
    lblBuff5.Caption := '';
    AlignElement();
end;

// Закрыть форму (можно нажать ESC, если форма под фокусом в данный момент)
procedure TMainForm.mniCloseFormClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.mniAboutClick(Sender: TObject);
begin
  About.Show;
end;

// Изменить буфер нажатием
procedure TMainForm.lblNum5Click(Sender: TObject);
begin
  try
    ChangeFontBuff();
    case (Sender as TLabel).HelpContext of
      1:
        begin
          Clipboard.AsText := lblBuff1.Caption;
          lblNum1.Font := dlgFontActive.Font;
          lblBuff1.Font := dlgFontActive.Font;
          CurrVar := 1;
        end;
      2:
        begin
          Clipboard.AsText := lblBuff2.Caption;
          lblNum2.Font := dlgFontActive.Font;
          lblBuff2.Font := dlgFontActive.Font;
          CurrVar := 2;
        end;
      3:
        begin
          Clipboard.AsText := lblBuff3.Caption;
          lblNum3.Font := dlgFontActive.Font;
          lblBuff3.Font := dlgFontActive.Font;
          CurrVar := 3;
        end;
      4:
        begin
          Clipboard.AsText := lblBuff4.Caption;
          lblNum4.Font := dlgFontActive.Font;
          lblBuff4.Font := dlgFontActive.Font;
          CurrVar := 4;
        end;
      5:
        begin
          Clipboard.AsText := lblBuff5.Caption;
          lblNum5.Font := dlgFontActive.Font;
          lblBuff5.Font := dlgFontActive.Font;
          CurrVar := 5;
        end;
    end;
  except
    lblNum5Click(Sender);
  end;
end;

end.
