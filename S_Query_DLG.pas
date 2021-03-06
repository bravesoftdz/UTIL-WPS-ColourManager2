Unit S_Query_DLG;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, Buttons, StdCtrls;

Type
  TS_QueryDLG = Class (TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Edit2: TEdit;
    Procedure Edit2OnChange (Sender: TObject);
    Procedure RadioButton3OnClick (Sender: TObject);
    Procedure RadioButton2OnClick (Sender: TObject);
    Procedure RadioButton1OnClick (Sender: TObject);
    Procedure S_QueryDLGOnShow (Sender: TObject);
    Procedure Button2OnClick (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  S_QueryDLG: TS_QueryDLG;

Implementation

Procedure TS_QueryDLG.Edit2OnChange (Sender: TObject);
Begin
  IF EDIT2.TEXT<>'' THEN BUTTON1.ENABLED:=TRUE ELSE BUTTON1.ENABLED:=FALSE;
End;

Procedure TS_QueryDLG.RadioButton3OnClick (Sender: TObject);
Begin
  if radiobutton3.checked then begin radiobutton2.checked:=false; radiobutton1.checked:=false; edit2.enabled:=false; end;
  button1.enabled:=true;
End;

Procedure TS_QueryDLG.RadioButton2OnClick (Sender: TObject);
Begin
  if radiobutton2.checked then begin radiobutton1.checked:=false; radiobutton3.checked:=false; edit2.enabled:=true; EDIT2.CAPTUREFOCUS; end;
  if edit2.text<>'' then button1.enabled:=true else button1.enabled:=false;
End;

Procedure TS_QueryDLG.RadioButton1OnClick (Sender: TObject);
Begin
  if radiobutton1.checked then begin radiobutton2.checked:=false; radiobutton3.checked:=false; edit2.enabled:=false; end;
  button1.enabled:=true;
End;

Procedure TS_QueryDLG.S_QueryDLGOnShow (Sender: TObject);
Begin
  radiobutton1.checked:=false; radiobutton2.checked:=false; radiobutton3.checked:=false;  BUTTON1.ENABLED:=FALSE;
  edit2.text:='';
End;

Procedure TS_QueryDLG.Button2OnClick (Sender: TObject);
Begin
  Close;
End;

Procedure TS_QueryDLG.Button1OnClick (Sender: TObject);
Begin
  CLOSE;
End;

Initialization
  RegisterClasses ([TS_QueryDLG, TEdit, TButton, TLabel,
    TRadioButton]);
End.
