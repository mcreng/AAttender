unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { Tform_about }

  Tform_about = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  form_about: Tform_about;

implementation
uses unit1;
{$R *.lfm}

{ Tform_about }

procedure Tform_about.Button1Click(Sender: TObject);
begin
   close;
end;

end.

