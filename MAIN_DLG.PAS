Unit MAIN_DLG;

Interface

Uses
  Classes, Forms, StdCtrls, Buttons, ExtCtrls, ComCtrls, Spin, ColorGrd, BmpList,
  Dialogs;

Type
  TMainDLG = Class (TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Desktop: TPanel;
    Image1: TImage;
    DESKTOPICON: TLabel;
    Button1: TButton;
    Button10: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Procedure Button2OnClick (Sender: TObject);
    Procedure Button10OnClick (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
    Procedure MainDLGOnShow (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

  PROCEDURE REG_VARIABLES;

Var
  MainDLG: TMainDLG;

Const
  QUIET:BYTE=1;



Implementation

USES DEMO_1_DLG,GRAPHICS,DEMO_2_DLG,COLOURCHANGE,GLOBROUT,PMWIN;

PROCEDURE REG_VARIABLES;
BEGIN
  NO_CONTROL_IDS:=23;
  WITH CONTROL_ID[0] DO BEGIN NAME:='CCT_DIALOGBOX';
                              TEXT.COLOR:=0;    TEXT.CLR_EN:=FALSE;  TEXT.FONT:=NIL; TEXT.FONT_EN:=FALSE;  TEXT_EN:=FALSE;
                              BACK.COLOR:=VALUESTORGB(204,204,168);    BACK.TRANS:=FALSE;   BACK_EN:=TRUE;  END;

  WITH CONTROL_ID[1] DO BEGIN NAME:='CCT_STATIC';
                              TEXT.COLOR:=CLYELLOW;    TEXT.CLR_EN:=FALSE;  TEXT.FONT:=NIL; TEXT.FONT_EN:=FALSE;  TEXT_EN:=TRUE;
                              BACK.COLOR:=0;    BACK.TRANS:=FALSE;   BACK_EN:=FALSE;  END;

  WITH CONTROL_ID[4] DO BEGIN NAME:='CCT_PUSHBUTTON';
                              TEXT.COLOR:=CLRED;  TEXT.CLR_EN:=TRUE;  TEXT.FONT:=NIL; TEXT.FONT_EN:=FALSE;  TEXT_EN:=TRUE;
                              BACK.COLOR:=CLGREEN;  BACK.TRANS:=FALSE;  BACK_EN:=FALSE;  END;

  WITH CONTROL_ID[7] DO BEGIN NAME:='CCT_ENTRYFIELD';
                              TEXT.COLOR:=CLRED;  TEXT.CLR_EN:=TRUE;  TEXT.FONT:=NIL; TEXT.FONT_EN:=FALSE;  TEXT_EN:=TRUE;
                              BACK.COLOR:=CLGREEN;  BACK.TRANS:=FALSE;  BACK_EN:=FALSE;  END;

  WITH CONTROL_ID[19] DO BEGIN NAME:='CCT_CONTAINER';
                              TEXT.COLOR:=CLRED;  TEXT.CLR_EN:=TRUE;  TEXT.FONT:=NIL; TEXT.FONT_EN:=FALSE;  TEXT_EN:=TRUE;
                              BACK.COLOR:=CLGREEN;  BACK.TRANS:=FALSE;  BACK_EN:=FALSE;  END;

  WITH CONTROL_ID[21] DO BEGIN NAME:='CCT_DESKTOP';
                              TEXT.COLOR:=CLRED;  TEXT.CLR_EN:=TRUE;  TEXT.FONT:=NIL; TEXT.FONT_EN:=FALSE;  TEXT_EN:=FALSE;
                              BACK.COLOR:=CLBLUE;  BACK.TRANS:=FALSE;  BACK_EN:=TRUE;  END;

  WITH CONTROL_ID[22] DO BEGIN NAME:='CCT_DESKTOPICON';
                              TEXT.COLOR:=CLRED;  TEXT.CLR_EN:=TRUE;  TEXT.FONT:=NIL; TEXT.FONT_EN:=FALSE;  TEXT_EN:=FALSE;
                              BACK.COLOR:=CLLIME;  BACK.TRANS:=FALSE;  BACK_EN:=TRUE;  END;

  WITH CONTROL_ID[23] DO BEGIN NAME:='CCT_FOLDERICON';
                              TEXT.COLOR:=CLRED;  TEXT.CLR_EN:=TRUE;  TEXT.FONT:=NIL; TEXT.FONT_EN:=FALSE;  TEXT_EN:=FALSE;
                              BACK.COLOR:=CLLIME;  BACK.TRANS:=FALSE;  BACK_EN:=TRUE;  END;





END;

Procedure TMainDLG.Button10OnClick (Sender: TObject);
VAR GUNKBYTE1:BYTE;
Begin
  //APPLY SETTINGS TO WINDOWS.

  PREVIEW_APPLYSCHEME(CONTROL_ID[0].BACK.COLOR);

  {FOR GUNKBYTE1:=1 TO NO_CONTROL_IDS DO WITH CONTROL_ID[GUNKBYTE1] DO BEGIN
    IF NAME='CCT_STATIC' THEN BEGIN
      DEMO_1_DLG.STATIC.PENCOLOR:=TEXT.COLOR;
    END;
    IF NAME='CCT_ENTRYFIELD' THEN BEGIN
      DEMO_1_DLG.EDITBOX.PENCOLOR:=TEXT.COLOR;
      DEMO_1_DLG.EDITBOX.COLOR:=BACK.COLOR;
    END;
    IF NAME='CCT_PUSHBUTTON' THEN BEGIN
      DEMO_1_DLG.BUTTON.PENCOLOR:=TEXT.COLOR;
      DEMO_1_DLG.BUTTON.COLOR:=BACK.COLOR;
    END;
    IF NAME='CCT_CONTAINER' THEN BEGIN
      DEMO_2_DLG.COLOR:=BACK.COLOR;
    END;
    IF NAME='CCT_DESKTOP' THEN BEGIN
      DESKTOP.COLOR:=BACK.COLOR;
    END;
    IF NAME='CCT_DESKTOPICON' THEN BEGIN
      DESKTOPICON.COLOR:=BACK.COLOR;
      DESKTOPICON.PENCOLOR:=TEXT.COLOR;
    END;
    IF NAME='CCT_FOLDERICON' THEN BEGIN
      DEMO_2_DLG.LABEL1.PENCOLOR:=TEXT.COLOR;
      DEMO_2_DLG.LABEL1.COLOR:=BACK.COLOR;
    END;
  END;

  WinSendMsg(DEMO_1_DLG.HANDLE,WM_PAINT,0,0);}
End;

Procedure TMainDLG.Button1OnClick (Sender: TObject);
Begin
  HALT;
end;

USES Os2Def,PMWIN;

Procedure TMainDLG.MainDLGOnShow (Sender: TObject);
VAR ICON:TICON;
    GUNKBYTE1:BYTE;
Begin
  REG_VARIABLES;
  ICON.CREATE;ICON.LOADFROMRESOURCEID(100);
  IMAGE1.ICON:=ICON;
  ICON.DESTROY;

  Demo_1_DLG.show;
  Demo_2_DLG.show;

End;

USES BSEDOS;

CONST NAME1='CLRMAN.DLL';

VAR ahab,AHMQ:LONGWORD;

FUNCTION AboutDlgProc (ahwnd:HWND; msg:ULONG; mp1,mp2:MPARAM):MRESULT; CDECL;
BEGIN
  AboutDlgProc:= WinDefDlgProc (ahwnd, msg, mp1, mp2) ;
END;


Procedure TMainDLG.Button2OnClick (Sender: TObject);
VAR GUNKCSTRING:CSTRING;
    RC:INTEGER;
    D_HANDLE,n_HANDLE:LONGWORD;
Begin
     ahab := WinInitialize (0) ;
     ahmq := WinCreateMsgQueue (ahab, 0) ;

     RC:=DOSLOADMODULE(GUNKCSTRING,SIZEOF(GUNKCSTRING),NAME1,D_HANDLE);
     EDIT1.TEXT:=TOSTR(RC);

     TEST_HANDLE:=WinLoadDlg (HWND_DESKTOP, HANDLE, @AboutDlgProc, D_HANDLE, 100, NIL) ;
End;


Initialization
  RegisterClasses ([TMainDLG, TLabel, TButton, TBevel,
    TPanel, TImage
   , TEdit, TMemo]);
End.
