unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons;

type

  { TForm2 }

  TForm2 = class(TForm)
    SaveImage: TImage;
    button: TSpeedButton;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }



procedure TForm2.FormCreate(Sender: TObject);
begin
  try
  if Paramcount=2 then
  begin
    if ParamStr(2)<>'0' then Form2.Visible:=true;
  end
  except
    Form2.Visible:=false;
  end;
end;



end.

