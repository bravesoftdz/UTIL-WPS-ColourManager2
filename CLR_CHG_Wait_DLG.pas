Unit CLR_CHG_Wait_DLG;

Interface

Uses
  Classes, Forms, Graphics, ComCtrls, StdCtrls, Buttons, ExtCtrls;

Type
  TWaitScr_DLG = Class (TForm)
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Procedure WaitScr_DLGOnShow (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  WaitScr_DLG: TWaitScr_DLG;


PROCEDURE UPDATE_PROGRESS(POSITION:BYTE);                                                     //UPDATE THE COVER SCREEN DIALOG

FUNCTION  GLOBAL_UPDATEWINCTRLS(FILENAME:STRING):INTEGER;                                     //APPLY THE WINDOW CONTROLS TO THE MAIN SYSTEM
FUNCTION  PREVIEW_APPLYSCHEME:BYTE;                                                           //APPLY THE CURRENTLY SELECTED SCHEME TO THE PREVIEW WINDOW
FUNCTION  PREVIEW_UPDATEWINCTRLS:BYTE;                                                        //UPDATE THE PREVIEW WINDOW CONTROLS
FUNCTION  GLOBAL_APPLYSCHEME:BYTE;                                                            //APPLY THE SCHEME TO THE WHOLE SYSTEM
FUNCTION PROCESS_COLOR(INDEX:LONGINT;BASECOLOUR,DARK3D,LIGHT3D,EXTRALIGHT3D:LONGINT;CONTROLID:INTEGER):LONGINT;           //USED TO ESTABLISH THE COLOURS FOR THE SYSTEM - FOR THE UNDOCUMENTED API FOR COLOUR CHANGE

Implementation

FUNCTION RESMGR(COMMAND:CHAR;EXE_FILE,ADD_FILE,RES_ID,RES_TYPE:STRING;LOG:BOOLEAN):INTEGER;
         external 'RESMGR' name 'Resource_Manager';

IMPORTS
       FUNCTION DOSREPLACEMODULE(OLDMODNAME,NEWMODNAME,BACKMODNAME: CSTRING): LONGWORD;
       APIENTRY;'DOSCALLS' index 417;
END;

USES PMWIN,GLOBROUT,BSEDOS,SYSUTILS,OS2DEF,PMGPI,MAINWIN_DLG,DOS,PMWP;

//##########################################################################################################################################################

PROCEDURE UPDATE_PROGRESS(POSITION:BYTE);                                                                                 //USED TO UPDATE THE PROGRESS BAR ON THE SCREEN
BEGIN
  IF NOT SILENT THEN WaitScr_DLG.progressbar1.position:=POSITION;
END;

FUNCTION PROCESS_COLOR(INDEX:LONGINT;BASECOLOUR,DARK3D,LIGHT3D,EXTRALIGHT3D:LONGINT;CONTROLID:INTEGER):LONGINT;           //USED TO ESTABLISH THE COLOURS FOR THE SYSTEM - FOR THE UNDOCUMENTED API FOR COLOUR CHANGE
BEGIN
  IF INDEX=CCI_FOREGROUND                 THEN RESULT:=CLBLACK;
  IF INDEX=CCI_FOREGROUNDREADONLY         THEN RESULT:=CLBLACK;
  IF INDEX=CCI_BACKGROUND                 THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_BACKGROUNDDIALOG           THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_DISABLEDFOREGROUND         THEN RESULT:=CLBLACK;
  IF INDEX=CCI_DISABLEDFOREGROUNDREADONLY THEN RESULT:=CLBLACK;
  IF INDEX=CCI_DISABLEDBACKGROUND         THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_DISABLEDBACKGROUNDDIALOG   THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_HIGHLIGHTFOREGROUND        THEN RESULT:=clWHITE;
  IF INDEX=CCI_HIGHLIGHTBACKGROUND        THEN RESULT:=DARK3d;
  IF INDEX=CCI_HIGHLIGHTBACKGROUNDDIALOG  THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_INACTIVEFOREGROUND         THEN RESULT:=light3d;
  IF INDEX=CCI_INACTIVEFOREGROUNDDIALOG   THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_INACTIVEBACKGROUND         THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_INACTIVEBACKGROUNDTEXT     THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_ACTIVEFOREGROUND           THEN RESULT:=light3d;
  IF INDEX=CCI_ACTIVEFOREGROUNDDIALOG     THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_ACTIVEBACKGROUND           THEN RESULT:=DARK3d;
  IF INDEX=CCI_ACTIVEBACKGROUNDTEXT       THEN RESULT:=DARK3d;
  IF INDEX=CCI_PAGEBACKGROUND             THEN RESULT:=CLWHITE;
  IF INDEX=CCI_PAGEFOREGROUND             THEN RESULT:=CLBLACK;
  IF INDEX=CCI_FIELDBACKGROUND            THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_BORDER                     THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_BORDERLIGHT                THEN RESULT:=light3d;
  IF INDEX=CCI_BORDERDARK                 THEN RESULT:=dark3d;
  IF INDEX=CCI_BORDER2                    THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_BORDER2LIGHT               THEN RESULT:=EXTRAlight3d;
  IF INDEX=CCI_BORDER2DARK                THEN RESULT:=CLBLACK;
  IF INDEX=CCI_BORDERDEFAULT              THEN RESULT:=CLBLACK;
  IF INDEX=CCI_BUTTONBACKGROUND           THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_BUTTONFOREGROUND           THEN RESULT:=CLBLACK;//RESULT;
  IF INDEX=CCI_BUTTONBORDERLIGHT          THEN RESULT:=light3d;
  IF INDEX=CCI_BUTTONBORDERDARK           THEN RESULT:=DARK3d;
  IF INDEX=CCI_ARROW                      THEN RESULT:=CLBLACK;
  IF INDEX=CCI_DISABLEDARROW              THEN RESULT:=DARK3d;
  IF INDEX=CCI_ARROWBORDERLIGHT           THEN RESULT:=LIGHT3d;
  IF INDEX=CCI_ARROWBORDERDARK            THEN RESULT:=DARK3d;
  IF INDEX=CCI_CHECKLIGHT                 THEN RESULT:=LIGHT3d;
  IF INDEX=CCI_CHECKMIDDLE                THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_CHECKDARK                  THEN RESULT:=DARK3d;
  IF INDEX=CCI_ICONFOREGROUND             THEN RESULT:=CLBLACK;//RESULT;
  IF INDEX=CCI_ICONBACKGROUND             THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_ICONBACKGROUNDDESKTOP      THEN RESULT:=DARK3d;
  IF INDEX=CCI_ICONHILITEFOREGROUND       THEN RESULT:=LIGHT3D;//RESULT;
  IF INDEX=CCI_ICONHILITEBACKGROUND       THEN RESULT:=DARK3D;//RESULT;
  IF INDEX=CCI_MAJORTABFOREGROUND         THEN RESULT:=CLBLACK;
  IF INDEX=CCI_MAJORTABBACKGROUND         THEN RESULT:=BASECOLOUR;
  IF INDEX=CCI_MINORTABFOREGROUND         THEN RESULT:=CLBLACK;
  IF INDEX=CCI_MINORTABBACKGROUND         THEN RESULT:=BASECOLOUR;
                                                                                                                            //SPECIFIC EXCEPTIONS FOR THE COLOURS

  IF (CONTROLID=CCT_ENTRYFIELD) OR (CONTROLID=CCT_LISTBOX) OR (CONTROLID=CCT_COMBOBOX) OR (CONTROLID=CCT_MLE)  THEN BEGIN
    IF INDEX=CCI_BACKGROUND                 THEN RESULT:=CUR_SCHEME.DATA[10].BACK.COLOR;
    IF INDEX=CCI_FOREGROUND                 THEN RESULT:=CUR_SCHEME.DATA[10].TEXT.COLOR;
  END;

  IF (CONTROLID=CCT_TITLEBAR)  THEN BEGIN
    IF INDEX=CCI_INACTIVEFOREGROUND THEN RESULT:=CUR_SCHEME.DATA[8].TEXT.COLOR;
    IF INDEX=CCI_INACTIVEBACKGROUNDTEXT THEN RESULT:=CUR_SCHEME.DATA[8].BACK.COLOR;
    IF INDEX=CCI_INACTIVEBACKGROUND THEN RESULT:=CUR_SCHEME.DATA[8].BACK.COLOR;
    IF INDEX=CCI_ACTIVEFOREGROUND THEN RESULT:=CUR_SCHEME.DATA[7].TEXT.COLOR;
    IF INDEX=CCI_ACTIVEBACKGROUNDTEXT THEN RESULT:=CUR_SCHEME.DATA[7].BACK.COLOR;
    IF INDEX=CCI_ACTIVEBACKGROUND THEN RESULT:=CUR_SCHEME.DATA[7].BACK.COLOR;
  END;

  IF (CONTROLID=CCT_STATICTEXT) AND (INDEX=CCI_FOREGROUND) THEN RESULT:=CUR_SCHEME.DATA[1].TEXT.COLOR;

  IF (CONTROLID=CCT_PUSHBUTTON) THEN BEGIN
    IF INDEX=CCI_BACKGROUND         THEN RESULT:=CUR_SCHEME.DATA[15].BACK.COLOR;         //BUTTON BACKGROUND
    IF INDEX=CCI_FOREGROUND         THEN RESULT:=CUR_SCHEME.DATA[15].TEXT.COLOR;         //BUTTON TEXT
    IF INDEX=CCI_DISABLEDBACKGROUND THEN RESULT:=CUR_SCHEME.DATA[15].BACK.COLOR;         //DISABLED BUTTON BACKGROUND
    IF INDEX=CCI_DISABLEDFOREGROUND THEN RESULT:=DARK(CUR_SCHEME.DATA[15].BACK.COLOR);   //DISABLED BUTTON FOREGROUND
    IF INDEX=CCI_BORDERDEFAULT      THEN RESULT:=CLBLACK;                                //DEFAULT BUTTON BORDER
    IF INDEX=CCI_BORDERLIGHT        THEN RESULT:=LIGHT(CUR_SCHEME.DATA[15].BACK.COLOR);  //BUTTON 3D LIGHT
    IF INDEX=CCI_BORDERDARK         THEN RESULT:=DARK(CUR_SCHEME.DATA[15].BACK.COLOR);   //BUTTON 3D DARK
  END;

  IF (CONTROLID=CCT_MENU) THEN BEGIN
    IF INDEX=CCI_BACKGROUND                 THEN RESULT:=CUR_SCHEME.DATA[5].BACK.COLOR;
    IF INDEX=CCI_FOREGROUND                 THEN RESULT:=CUR_SCHEME.DATA[5].TEXT.COLOR;
    IF INDEX=CCI_HIGHLIGHTFOREGROUND        THEN RESULT:=CUR_SCHEME.DATA[6].TEXT.COLOR;
    IF INDEX=CCI_HIGHLIGHTBACKGROUND        THEN RESULT:=CUR_SCHEME.DATA[6].BACK.COLOR;
  END;

  IF (CONTROLID=CCT_FRAME) THEN BEGIN
    IF INDEX=CCI_INACTIVEFOREGROUND         THEN RESULT:=BASECOLOUR;
    IF INDEX=CCI_ACTIVEFOREGROUND           THEN RESULT:=BASECOLOUR;
  END;

  IF (CONTROLID=CCT_NOTEBOOK) THEN BEGIN
     IF INDEX=CCI_BORDER2DARK THEN RESULT:=DARK3D;
  END;

END;

//##########################################################################################################################################################
//##########################################################################################################################################################
//##########################################################################################################################################################

FUNCTION GLOBAL_APPLYSCHEME:BYTE;                                                                                          //APPLY THE SCHEME TO THE WHOLE SYSTEM
VAR RC,GUNKINT1,GUNKINT2:INTEGER;
    CTRL_CLR:TCtlColor;
    DESKTOP,CCOUNT:LONGINT;
    R,G,B:BYTE;
    ALTABLE2:ARRAY[0..40] OF LONGINT;
    SETUPSTRING:STRING;
    BASE_DARK3D,BASE_LIGHT3D,BASE_EXTRALIGHT3D:LONGINT;

BEGIN
  IF NOT SILENT THEN BEGIN   //ALL THE THINGS THAT NEED TO BE DONE WHEN APPLYING A SCHEME - BEFORE THE REBOOT ONLY IN THIS SECTION
    WaitScr_DLG.show;

    //UPDATE INI - DEFAULT FOLDER BACKGROUND, DEFAULT ICON FONT, MENU FONT, TITLE FONT
    //SETUP FONTS
    OS2INI('USER','PM_SystemFonts','Menus','WRITE',TOSTR(CUR_SCHEME.DATA[5].TEXT.FONT.SIZE)+'.'+CUR_SCHEME.DATA[5].TEXT.FONT.NAME);
    OS2INI('USER','PM_SystemFonts','WindowTitles','WRITE',TOSTR(CUR_SCHEME.DATA[7].TEXT.FONT.SIZE)+'.'+CUR_SCHEME.DATA[7].TEXT.FONT.NAME);
    OS2INI('USER','PM_SystemFonts','IconText','WRITE',TOSTR(CUR_SCHEME.DATA[3].TEXT.FONT.SIZE)+'.'+CUR_SCHEME.DATA[3].TEXT.FONT.NAME);
    Win32SetSysFont(HWND_DESKTOP,1,TOSTR(CUR_SCHEME.DATA[5].TEXT.FONT.SIZE)+'.'+CUR_SCHEME.DATA[5].TEXT.FONT.NAME);
    Win32SetSysFont(HWND_DESKTOP,2,TOSTR(CUR_SCHEME.DATA[7].TEXT.FONT.SIZE)+'.'+CUR_SCHEME.DATA[7].TEXT.FONT.NAME);
    Win32SetSysFont(HWND_DESKTOP,3,TOSTR(CUR_SCHEME.DATA[3].TEXT.FONT.SIZE)+'.'+CUR_SCHEME.DATA[3].TEXT.FONT.NAME);

    //UPDATE THE INIs FOR THE ICONS
    IF CUR_SCHEME.DATA[3].BACK.TRANS_USED THEN OS2INI('USER','PM_Colors','DesktopIconTextBackground','WRITE','T'+TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B))
    ELSE BEGIN
      RGBTOVALUES(CUR_SCHEME.DATA[3].BACK.COLOR,R,G,B);
      OS2INI('USER','PM_Colors','DesktopIconTextBackground','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));
    END;
    RGBTOVALUES(CUR_SCHEME.DATA[3].TEXT.COLOR,R,G,B);
    OS2INI('USER','PM_Colors','DesktopIconText','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));

    IF CUR_SCHEME.DATA[12].BACK.TRANS_USED THEN OS2INI('USER','PM_Colors','FolderIconTextBackground','WRITE','T'+TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B))
    ELSE BEGIN
      RGBTOVALUES(CUR_SCHEME.DATA[12].BACK.COLOR,R,G,B);
      OS2INI('USER','PM_Colors','FolderIconTextBackground','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));
    END;
    RGBTOVALUES(CUR_SCHEME.DATA[12].TEXT.COLOR,R,G,B);
    OS2INI('USER','PM_Colors','IconText','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));

    IF CUR_SCHEME.DATA[13].BACK.TRANS_USED THEN OS2INI('USER','PM_Colors','Shadow','WRITE','T'+TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B))
    ELSE BEGIN
      RGBTOVALUES(CUR_SCHEME.DATA[13].BACK.COLOR,R,G,B);
      OS2INI('USER','PM_Colors','Shadow','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));
    END;
    RGBTOVALUES(CUR_SCHEME.DATA[13].TEXT.COLOR,R,G,B);
    OS2INI('USER','PM_Colors','ShadowText','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));

    RGBTOVALUES(CUR_SCHEME.DATA[16].BACK.COLOR,R,G,B);
    OS2INI('USER','PM_Colors','HiliteBackground','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));
    RGBTOVALUES(CUR_SCHEME.DATA[16].TEXT.COLOR,R,G,B);
    OS2INI('USER','PM_Colors','HiliteForeground','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));

    RGBTOVALUES(CUR_SCHEME.DATA[16].BACK.COLOR,R,G,B);
    OS2INI('USER','PM_Colors','ShadowHiliteBgnd','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));
    RGBTOVALUES(CUR_SCHEME.DATA[16].TEXT.COLOR,R,G,B);
    OS2INI('USER','PM_Colors','ShadowHiliteFgnd','WRITE',TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));


    UPDATE_PROGRESS(5);

    //SETUP DEFAULT FOLDER BACKGROUNDS
    IF CUR_SCHEME.DATA[11].BACK.BITMAP_USED THEN BEGIN   //BITMAPPED
      IF CUR_SCHEME.DATA[11].BACK.BMP_STYLE=BMP_TILE THEN OS2INI('USER','PM_SystemBackground','DefaultFolderBackground','WRITE',CUR_SCHEME.DATA[11].BACK.BITMAP_PATH+',T,,I,255 255 255');
      IF CUR_SCHEME.DATA[11].BACK.BMP_STYLE=BMP_CENTER THEN OS2INI('USER','PM_SystemBackground','DefaultFolderBackground','WRITE',CUR_SCHEME.DATA[11].BACK.BITMAP_PATH+',N,,I,255 255 255');
      IF CUR_SCHEME.DATA[11].BACK.BMP_STYLE=BMP_STRETCH THEN OS2INI('USER','PM_SystemBackground','DefaultFolderBackground','WRITE',CUR_SCHEME.DATA[11].BACK.BITMAP_PATH+',S,,I,255 255 255');
    END
    ELSE BEGIN                                           //SOLID COLOUR
      RGBTOVALUES(CUR_SCHEME.DATA[11].BACK.COLOR,R,G,B);
      OS2INI('USER','PM_SystemBackground','DefaultFolderBackground','WRITE',',T,1,C,'+TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B));
    END;

    //SETUP DESKTOP FOLDER BACKGROUNDS
    DESKTOP:=WINQUERYOBJECT('<WP_DESKTOP>');
    IF CUR_SCHEME.DATA[2].BACK.BITMAP_USED THEN BEGIN    //BITMAPPED
      IF CUR_SCHEME.DATA[2].BACK.BMP_STYLE=BMP_TILE THEN WINSETOBJECTDATA(DESKTOP,'BACKGROUND='+CUR_SCHEME.DATA[2].BACK.BITMAP_PATH+',T,,I')
      ELSE IF CUR_SCHEME.DATA[2].BACK.BMP_STYLE=BMP_STRETCH THEN WINSETOBJECTDATA(DESKTOP,'BACKGROUND='+CUR_SCHEME.DATA[2].BACK.BITMAP_PATH+',S,,I')
      ELSE WINSETOBJECTDATA(DESKTOP,'BACKGROUND='+CUR_SCHEME.DATA[2].BACK.BITMAP_PATH+',N,,I');
    END
    ELSE begin                                            //SOLID COLOUR
      RGBTOVALUES(CUR_SCHEME.DATA[2].BACK.color,R,G,B);
      WINSETOBJECTDATA(DESKTOP,'BACKGROUND=(NONE),T,1,C,'+TOSTR(R)+' '+TOSTR(G)+' '+TOSTR(B))
    END;

    UPDATE_PROGRESS(10);

    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    //UPDATE STARTUP FOLDER  - PLACE A STARTUP ICON IN THE FOLDER
    SETUPSTRING:='EXENAME='+CURDIR+'\CLRMAN2.EXE;PARAMETERS=-S';
    WINCREATEOBJECT('WPProgram','Dialog Enhancer'+chr(13)+chr(10)+'Colour Manager 2',SETUPSTRING,'<WP_START>',1);

    UPDATE_PROGRESS(15);

    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //BUILD AND UPDATE PMMRGRES.DLL
    RC:=GLOBAL_UPDATEWINCTRLS(CURDIR+'\THEMES\'+MainDLG.ThemeCombo.TEXT+'.DLL');

    UPDATE_PROGRESS(40);

    //HARD-FIX THE CONTROLS ON THE DEMO WINDOW
    WITH MainDLG DO BEGIN
      MainDLG.color:=CUR_SCHEME.DATA[1].BACK.COLOR;
      schemebox.color:=CUR_SCHEME.DATA[10].BACK.COLOR;
      PropertyCombo.color:=CUR_SCHEME.DATA[10].BACK.COLOR;
      ThemeCombo.color:=CUR_SCHEME.DATA[10].BACK.COLOR;
      ComboBox1.color:=CUR_SCHEME.DATA[10].BACK.COLOR;
      MODIFY_BTN.COLOR:=CUR_SCHEME.DATA[15].BACK.COLOR;
      EditFontClr_BTN.COLOR:=CUR_SCHEME.DATA[15].BACK.COLOR;
      SaveAs_BTN.COLOR:=CUR_SCHEME.DATA[15].BACK.COLOR;
      Delete_BTN.COLOR:=CUR_SCHEME.DATA[15].BACK.COLOR;
    END;

    UPDATE_PROGRESS(50);
  END;

  //PROCESS THE COLOUR PARAMETERS TO BE PASSED TO THE COLOUR CHANGE COMMAND
  BASE_DARK3D:=DARK(CUR_SCHEME.DATA[1].BACK.COLOR);
  BASE_LIGHT3D:=LIGHT(CUR_SCHEME.DATA[1].BACK.COLOR);
  BASE_EXTRALIGHT3D:=LIGHT(CUR_SCHEME.DATA[1].BACK.COLOR);

  //############################################################################################################################################
  //CONFIGURES THE STANDARD WINDOW CONTROL COLOURS
  //############################################################################################################################################

  //SELECTION FIELDS
  ALTABLE2[0]:=CUR_SCHEME.DATA[10].BACK.COLOR;            /*SYSCLR_ENTRYFIELD Entry field and list box background color.*/
  ALTABLE2[14]:=BASE_LIGHT3D;                             /*SYSCLR_HILITEFOREGROUND Selection foreground.*/
  ALTABLE2[15]:=BASE_DARK3D;                              /*SYSCLR_HILITEBACKGROUND Selection background.*/

  //MENU CONTROL
  ALTABLE2[26]:=CUR_SCHEME.DATA[5].BACK.COLOR;            /*SYSCLR_MENU Menu background.*/
  ALTABLE2[29]:=CUR_SCHEME.DATA[5].TEXT.COLOR;            /*SYSCLR_MENUTEXT Normal menu item text.*/
  ALTABLE2[1]:=DARK(CUR_SCHEME.DATA[5].BACK.COLOR);       /*SYSCLR_MENUDISABLEDTEXT Disabled MENU choice colour.*/
  ALTABLE2[2]:=CUR_SCHEME.DATA[6].TEXT.COLOR;             /*SYSCLR_MENUHILITE Selected menu item text.*/
  ALTABLE2[3]:=CUR_SCHEME.DATA[6].BACK.COLOR;             /*SYSCLR_MENUHILITEBGND Selected menu item background.*/

  //DIALOG CONTROL
  ALTABLE2[13]:=CUR_SCHEME.DATA[1].BACK.COLOR;            /*SYSCLR_DIALOGBACKGROUND Dialog box background.*/
  ALTABLE2[4]:=CUR_SCHEME.DATA[1].BACK.COLOR;             /*SYSCLR_PAGEBACKGROUND Notebook page background.*/

  //BUTTONS
  ALTABLE2[6]:=LIGHT(CUR_SCHEME.DATA[15].BACK.COLOR);     /*SYSCLR_BUTTONLIGHT Light pushbutton (3D effect).*/
  ALTABLE2[7]:=CUR_SCHEME.DATA[15].BACK.COLOR;            /*SYSCLR_BUTTONMIDDLE Middle pushbutton (3D effect).*/
  ALTABLE2[8]:=DARK(CUR_SCHEME.DATA[15].BACK.COLOR);      /*SYSCLR_BUTTONDARK Dark pushbutton (3D effect).*/
  ALTABLE2[9]:=CUR_SCHEME.DATA[15].TEXT.COLOR;            /*SYSCLR_BUTTONDEFAULT Pushbutton.*/

  //MISC & UNKNOWN/NON-VISIBLE
  ALTABLE2[10]:=BASE_DARK3D;                              /*SYSCLR_TITLEBOTTOM Line drawn under title bar.*/  //WHAT IS THIS?????
  ALTABLE2[11]:=BASE_DARK3D;                              /*SYSCLR_SHADOW Drop shadow for menus and dialogs.*/
  ALTABLE2[12]:=CUR_SCHEME.DATA[3].TEXT.COLOR;            /*SYSCLR_ICONTEXT Text written under icons on the desktop.*/
  ALTABLE2[31]:=CLGREEN;                                  /*SYSCLR_TITLETEXT Text in title bar, size box, scroll bar arrow box.*/      //DOES NOT WORK

  //WINDOW TITLE CONTROL
  ALTABLE2[16]:=CUR_SCHEME.DATA[8].BACK.COLOR;            /*SYSCLR_INACTIVETITLETEXTBKGD Background of inactive title text.*/
  ALTABLE2[17]:=CUR_SCHEME.DATA[7].BACK.COLOR;            /*SYSCLR_ACTIVETITLETEXTBKGD Background of active title text.*/
  ALTABLE2[18]:=CUR_SCHEME.DATA[8].TEXT.COLOR;            /*SYSCLR_INACTIVETITLETEXT Inactive title text.*/
  ALTABLE2[19]:=CUR_SCHEME.DATA[7].TEXT.COLOR;            /*SYSCLR_ACTIVETITLETEXT Active title text.*/
  ALTABLE2[24]:=CUR_SCHEME.DATA[7].BACK.COLOR;            /*SYSCLR_ACTIVETITLE Active window title.*/
  ALTABLE2[25]:=CUR_SCHEME.DATA[8].BACK.COLOR;            /*SYSCLR_INACTIVETITLE Inactive window title.*/

  //DIALOG TEXT
  ALTABLE2[20]:=CUR_SCHEME.DATA[1].TEXT.COLOR;            /*SYSCLR_OUTPUTTEXT Output text.*/
  ALTABLE2[21]:=CUR_SCHEME.DATA[1].TEXT.COLOR;            /*SYSCLR_WINDOWSTATICTEXT Static (nonselectable) text.*/
  ALTABLE2[30]:=CUR_SCHEME.DATA[1].TEXT.COLOR;            /*SYSCLR_WINDOWTEXT Window text.*/

  ALTABLE2[22]:=CUR_SCHEME.DATA[1].BACK.COLOR;            /*SYSCLR_SCROLLBAR Active scroll bar background area.*/
  ALTABLE2[23]:=CUR_SCHEME.DATA[2].BACK.COLOR;            /*SYSCLR_BACKGROUND Desktop background.*/

  //MISC
  ALTABLE2[27]:=CUR_SCHEME.DATA[11].BACK.COLOR;           /*SYSCLR_WINDOW Folder, Window work area background.*/
  ALTABLE2[5]:=CUR_SCHEME.DATA[1].BACK.COLOR;             /*SYSCLR_FIELDBACKGROUND Inactive scroll bar and notebook background color.*/
  ALTABLE2[34]:=CUR_SCHEME.DATA[9].BACK.COLOR;            /*SYSCLR_APPWORKSPACE Background of specific main windows.*/

  //WINDOW FRAME
  ALTABLE2[32]:=CUR_SCHEME.DATA[1].BACK.COLOR;            /*SYSCLR_ACTIVEBORDER Border surround of active window.*/
  ALTABLE2[33]:=CUR_SCHEME.DATA[1].BACK.COLOR;            /*SYSCLR_INACTIVEBORDER Border surround of inactive window.*/
  ALTABLE2[28]:=BASE_DARK3D;                              /*SYSCLR_WINDOWFRAME Window frame (border line). - HORIZONTAL LINE ON TREE VIEW*/

  //HELP
  ALTABLE2[35]:=CUR_SCHEME.DATA[14].BACK.COLOR;           /*SYSCLR_HELPBACKGROUND Background of help panels.*/
  ALTABLE2[36]:=CUR_SCHEME.DATA[14].TEXT.COLOR;           /*SYSCLR_HELPTEXT Help text.*/
  ALTABLE2[37]:=CUR_SCHEME.DATA[17].TEXT.COLOR;           /*SYSCLR_HELPHILITE Highlighted help text.*/

  //SHADOWS - COMMAND DOESN'T SEEM TO DO ANYTHING TO THESE.... ;O(
  //ALTABLE2[38]:=CLRED;//CUR_SCHEME.DATA[1].BACK.COLOR;            /*SYSCLR_SHADOWHILITEBGND Shadows of workplace object background highlight color.*/
  //ALTABLE2[39]:=CLYELLOW;//CUR_SCHEME.DATA[4].TEXT.COLOR;            /*SYSCLR_SHADOWHILITEFGND Shadows of workplace object foreground highlight color.*/
  //ALTABLE2[40]:=CLLIME;//CUR_SCHEME.DATA[4].TEXT.COLOR;            /*SYSCLR_SHADOWTEXT Shadows of workplace object text color.*/

  WINSETSYSCOLORS(HWND_DESKTOP,0,LCOLF_CONSECRGB,-47,38,ALTABLE2[0]);
  //THIS METHOD IS VERY ROUGH AND DOES NOT COVER THE COMPLETE COLOUR RANGE - HOWEVER IT IS HANDY TO USE TO RESET THE MAJORITY OF
  //THE COLOURS READY FOR THE FINER ADJUSTMENT ;O)

  UPDATE_PROGRESS(70);

  //############################################################################################################################################
  //CONFIGURES THE 3D PARTS OF THE COLOUR SCHEME - UNDOCUMENTED API
  //############################################################################################################################################

  FOR GUNKINT1:=1 TO 20 DO BEGIN
    CCOUNT:=WinQueryControlColors(HWND_DESKTOP,GUNKINT1,CCF_COUNTCOLORS,0,NIL);                      //GETS THE NUMBER OF COLOURS AVAILABLE TO THAT SETTING
    WinQueryControlColors(HWND_DESKTOP,GUNKINT1,CCF_GLOBAL|CCF_ALLCOLORS,CCOUNT,CTRL_CLR);           //DUMPS ALL OF THE DATA INTO CTRL_CLR RECORD

    UPDATE_PROGRESS(50+(GUNKINT1*2));
                                                                                                     //GET ALL THE CONTROL COLOURS AND MAKE THE MODIFICATIONS
    FOR GUNKINT2:=1 TO CCOUNT DO WITH CTRL_CLR[GUNKINT2] DO CLRVALUE:=PROCESS_COLOR(clrINDEX,CUR_SCHEME.DATA[1].BACK.COLOR,BASE_DARK3D,BASE_LIGHT3D,BASE_EXTRALIGHT3D,GUNKINT1);
    WinSetControlColors(HWND_DESKTOP,GUNKINT1,CCF_GLOBAL|CCF_ALLCOLORS,CCOUNT,CTRL_CLR);             //APPLIES ALL OF THE NEW COLORS
  END;

  UPDATE_PROGRESS(95);

  IF NOT SILENT THEN WaitScr_DLG.close;

  RESULT:=RC;
END;

//##########################################################################################################################################################

FUNCTION PREVIEW_UPDATEWINCTRLS:BYTE;                                                                            //UPDATE THE PREVIEW WINDOW CONTROLS
VAR TMP_BMP:tbitmap;
    DESTREC,SRCREC:TRECT;
BEGIN
 WITH MAINDLG DO BEGIN
   //APPLY THE WINDOW CONTROLS - CLOSE
   WINCTRL.CLOSE.POSITION:=0;   INACTIVE_CLOSE.BITMAP.LOADFROMSTREAM(WINCTRL.CLOSE);
   WINCTRL.CLOSE.POSITION:=0;   HELP_CLOSE.BITMAP.LOADFROMSTREAM(WINCTRL.CLOSE);
   WINCTRL.CLOSE.POSITION:=0;   FOLDER_CLOSE.BITMAP.LOADFROMSTREAM(WINCTRL.CLOSE);

   //APPLY THE WINDOW CONTROLS - MAX
   WINCTRL.MAX.POSITION:=0;   INACTIVE_MAX.BITMAP.LOADFROMSTREAM(WINCTRL.MAX);
   WINCTRL.MAX.POSITION:=0;   FOLDER_MAX.BITMAP.LOADFROMSTREAM(WINCTRL.MAX);
   WINCTRL.MAX.POSITION:=0;   HELP_MAX.BITMAP.LOADFROMSTREAM(WINCTRL.MAX);

   //APPLY THE WINDOW CONTROLS - MIN
   WINCTRL.MIN.POSITION:=0;   HELP_MIN.BITMAP.LOADFROMSTREAM(WINCTRL.MIN);

   //APPLY THE WINDOW CONTROLS - HIDE
   WINCTRL.HIDE.POSITION:=0;   FOLDER_HIDE.BITMAP.LOADFROMSTREAM(WINCTRL.HIDE);

   //APPLY THE WINDOW CONTROLS - SYS
   WINCTRL.SYS.POSITION:=0;   DIALOG_SYS.BITMAP.LOADFROMSTREAM(WINCTRL.SYS);
   WINCTRL.SYS.POSITION:=0;   INACTIVE_SYS.BITMAP.LOADFROMSTREAM(WINCTRL.SYS);

   //APPLY THE WINDOW CONTROLS - CHK&RAD
   TMP_BMP.CREATE;
   DESTREC.LEFT:=0; DESTREC.RIGHT:=16; DESTREC.BOTTOM:=0; DESTREC.TOP:=16;
   WINCTRL.BOX.POSITION:=0;      TMP_BMP.LOADFROMSTREAM(WINCTRL.BOX);         //WE MUST FIRST INITIALISE THE CONTROLS
   WINCTRL.BOX.POSITION:=0;      CHECK1.BITMAP.LOADFROMSTREAM(WINCTRL.BOX);
   WINCTRL.BOX.POSITION:=0;      RADIO1.BITMAP.LOADFROMSTREAM(WINCTRL.BOX);
   WINCTRL.BOX.POSITION:=0;      RADIO2.BITMAP.LOADFROMSTREAM(WINCTRL.BOX);

   SRCREC.LEFT:=16;  SRCREC.BOTTOM:=32; SRCREC.TOP:=48;   SRCREC.RIGHT:=32;      //WE NOW EXTRACT THE RESOURCES FROM THE RELEVANT LOCATION WITHIN THE BITMAP BLOCK
   TMP_BMP.canvas.BitBlt(check1.bitmap.canvas,DESTREC,SRCREC,CMSRCCOPY,bitfIgnore);
   SRCREC.LEFT:=0;  SRCREC.BOTTOM:=16; SRCREC.TOP:=32;   SRCREC.RIGHT:=16;
   TMP_BMP.canvas.BitBlt(RADIO1.bitmap.canvas,DESTREC,SRCREC,CMSRCCOPY,bitfIgnore);
   SRCREC.LEFT:=16;  SRCREC.BOTTOM:=16; SRCREC.TOP:=32;   SRCREC.RIGHT:=32;
   TMP_BMP.canvas.BitBlt(RADIO2.bitmap.canvas,DESTREC,SRCREC,CMSRCCOPY,bitfIgnore);

   TMP_BMP.DESTROY;

   SCHEMEAPPLIED:=FALSE;MAINDLG.APPLY_BTN.ENABLED:=TRUE; IF CHANGED THEN MAINDLG.SCHEMEBOX.TEXT:='';
 END;
END;

//##########################################################################################################################################################

FUNCTION PREVIEW_APPLYSCHEME:BYTE;                                                                                     //APPLY THE CURRENTLY SELECTED SCHEME TO THE PREVIEW WINDOW
VAR GUNKINT1,GUNKINT2:INTEGER;
    CTRL_CLR:TCtlColor;
    T,CCOUNT:LONGINT;
    DESKTOP_BACK:tbitmap;
    INT_ICON:TICON;
    TEST:POINTL;
    BASE_DARK3D,BASE_LIGHT3D,BASE_EXTRALIGHT3D:LONGINT;
    R,G,B:BYTE;
    RN,GN,BN:INTEGER;

BEGIN
IF NOT startup THEN BEGIN
 INC(UPDATE_TEST);    MAINDLG.LABEL6.CAPTION:=TOSTR(UPDATE_TEST);  //DEBUG LINE! - LOG THE NUMBER OF UPDATES!
 {MAINDLG.folder.visible:=false; MAINDLG.dialog.visible:=false; MAINDLG.INACTIVE.visible:=false;}  MAINDLG.DESKTOP.VISIBLE:=FALSE;

 //PROCESS THE COLOUR PARAMETERS TO BE PASSED TO THE COLOUR CHANGE COMMAND
 BASE_DARK3D:=DARK(CUR_SCHEME.DATA[1].BACK.COLOR);
 BASE_LIGHT3D:=LIGHT(CUR_SCHEME.DATA[1].BACK.COLOR);
 BASE_EXTRALIGHT3D:=LIGHT(CUR_SCHEME.DATA[1].BACK.COLOR);

 FOR GUNKINT1:=1 TO 20 DO WITH MAINDLG DO BEGIN
   CCOUNT:=WinQueryControlColors(HWND_DESKTOP,GUNKINT1,CCF_COUNTCOLORS,0,NIL);        //GETS THE NUMBER OF COLOURS AVAILABLE IN EACH CONTROL
   WinQueryControlColors(HWND_DESKTOP,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR);               //DUMPS ALL OF THE DATA INTO CTRL_CLR RECORD

   FOR GUNKINT2:=1 TO CCOUNT DO WITH CTRL_CLR[GUNKINT2] DO CLRVALUE:=PROCESS_COLOR(clrINDEX,CUR_SCHEME.DATA[1].BACK.COLOR,BASE_DARK3D,BASE_LIGHT3D,BASE_EXTRALIGHT3D,GUNKINT1); //GET ALL THE CONTROL COLOURS AND MAKE THE MODIFICATIONS

   //NOW APPLY THE MODIFICATIONS TO THE INTERNAL DEMO WINDOW
   IF GUNKINT1=CCT_LISTBOX     THEN WinSetControlColors(LISTBOX.HANDLE,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR);
   //FUDGE TO GET THE HANDLE OF THE LISTBOX SCROLLBAR - DODGY CODE!!!!
   IF GUNKINT1=CCT_SCROLLBAR   THEN BEGIN TEST.X:=135;  TEST.Y:=30;  T:=WINWINDOWFROMPOINT(listbox.handle,TEST,FALSE); memo1.lines.add('Listbox Handle : '+TOSTR(T));
                                    WinSetControlColors(listbox.handle+1,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR); WinSetControlColors(T,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR); END;
   IF GUNKINT1=CCT_SCROLLBAR   THEN BEGIN TEST.X:=2;  TEST.Y:=2; T:=WINWINDOWFROMPOINT(folder_back.handle,TEST,FALSE); memo1.lines.add('Folder Handle : '+TOSTR(T));
                                    WinSetControlColors(folder_back.handle+1,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR); WinSetControlColors(T,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR); END;
   IF GUNKINT1=CCT_PUSHBUTTON  THEN WinSetControlColors(SAMP_BUTTON.HANDLE,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR);
   IF GUNKINT1=CCT_ENTRYFIELD  THEN WinSetControlColors(ENTRYFIELD.HANDLE,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR);
   IF GUNKINT1=CCT_MLE         THEN WinSetControlColors(folder_back.handle,GUNKINT1,$0|$20,CCOUNT,CTRL_CLR);
 END;

 WITH MAINDLG DO BEGIN
   //SET DIALOG BOX COLOR
   DIALOG.COLOR:=CUR_SCHEME.DATA[1].BACK.COLOR;   FOLDER.COLOR:=CUR_SCHEME.DATA[1].BACK.COLOR;   INACTIVE.COLOR:=CUR_SCHEME.DATA[1].BACK.COLOR;
   radiobutton1.pencolor:=CUR_SCHEME.DATA[1].text.COLOR;  radiobutton2.pencolor:=CUR_SCHEME.DATA[1].text.COLOR;
   checkbox1.pencolor:=CUR_SCHEME.DATA[1].text.COLOR;

   //SET MENU COLORS
   MENU_1.COLOR:=CUR_SCHEME.DATA[5].BACK.COLOR;         MENU_1_1.PENCOLOR:=CUR_SCHEME.DATA[5].TEXT.COLOR;   MENU_1_2.PENCOLOR:=CUR_SCHEME.DATA[5].TEXT.COLOR;
   MENU_1.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[5].TEXT.FONT.NAME,CUR_SCHEME.DATA[5].TEXT.FONT.SIZE);

   MENU_2.COLOR:=CUR_SCHEME.DATA[5].BACK.COLOR;         MENU_2_2.PENCOLOR:=CUR_SCHEME.DATA[5].TEXT.COLOR;   MENU_2_3.PENCOLOR:=CUR_SCHEME.DATA[5].TEXT.COLOR;
   MENU_2.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[5].TEXT.FONT.NAME,CUR_SCHEME.DATA[5].TEXT.FONT.SIZE);
   MENU_2_4.PENCOLOR:=CUR_SCHEME.DATA[5].TEXT.COLOR;    MENU_2_5.PENCOLOR:=CUR_SCHEME.DATA[5].TEXT.COLOR;
   MENU_2_1.PENCOLOR:=CUR_SCHEME.DATA[6].TEXT.COLOR;    MENU_2_1.COLOR:=CUR_SCHEME.DATA[6].BACK.COLOR;      MENU_2_HIGH.BRUSH.COLOR:=CUR_SCHEME.DATA[6].BACK.COLOR;

   MENU_3.COLOR:=CUR_SCHEME.DATA[5].BACK.COLOR;         MENU_3_1.PENCOLOR:=CUR_SCHEME.DATA[6].TEXT.COLOR;   MENU_3_2.PENCOLOR:=CUR_SCHEME.DATA[6].BACK.COLOR;
   MENU_3.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[5].TEXT.FONT.NAME,CUR_SCHEME.DATA[5].TEXT.FONT.SIZE);
   MENU_3_3.PENCOLOR:=CUR_SCHEME.DATA[5].TEXT.COLOR;    MENU_3_HIGH.BRUSH.COLOR:=CUR_SCHEME.DATA[6].BACK.COLOR;    MENU_3_1.COLOR:=CUR_SCHEME.DATA[6].BACK.COLOR;

   //SET ACTIVE TITLE
   ACTIVE_BAR.COLOR:=CUR_SCHEME.DATA[7].BACK.COLOR;
   ACTIVE_TEXT.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[7].TEXT.FONT.NAME,CUR_SCHEME.DATA[7].TEXT.FONT.SIZE);
   ACTIVE_TEXT.PENCOLOR:=CUR_SCHEME.DATA[7].TEXT.COLOR;

   //SET INACTIVE TITLES
   INACTIVE1_BAR.COLOR:=CUR_SCHEME.DATA[8].BACK.COLOR;  INACTIVE1_TEXT.PENCOLOR:=CUR_SCHEME.DATA[8].TEXT.COLOR;
   INACTIVE1_TEXT.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[8].TEXT.FONT.NAME,CUR_SCHEME.DATA[8].TEXT.FONT.SIZE);
   INACTIVE2_BAR.COLOR:=CUR_SCHEME.DATA[8].BACK.COLOR;  INACTIVE2_TEXT.PENCOLOR:=CUR_SCHEME.DATA[8].TEXT.COLOR;
   INACTIVE2_TEXT.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[8].TEXT.FONT.NAME,CUR_SCHEME.DATA[8].TEXT.FONT.SIZE);
   INACTIVE3_BAR.COLOR:=CUR_SCHEME.DATA[8].BACK.COLOR;  INACTIVE3_TEXT.PENCOLOR:=CUR_SCHEME.DATA[8].TEXT.COLOR;
   INACTIVE3_TEXT.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[8].TEXT.FONT.NAME,CUR_SCHEME.DATA[8].TEXT.FONT.SIZE);

   //APPLICATION WORKSPACE
   APP_WRKSPACE.COLOR:=CUR_SCHEME.DATA[9].BACK.COLOR;

   //ENTRYFIELD LISTBOX
   ENTRYFIELD.COLOR:=CUR_SCHEME.DATA[10].BACK.COLOR;     ListBox.COLOR:=CUR_SCHEME.DATA[10].BACK.COLOR;
   ENTRYFIELD.PENCOLOR:=CUR_SCHEME.DATA[10].TEXT.COLOR;  ListBox.PENCOLOR:=CUR_SCHEME.DATA[10].TEXT.COLOR;

   //HELP PANEL
   HELP.COLOR:=CUR_SCHEME.DATA[14].BACK.COLOR;  HELP_TEXT.PENCOLOR:=CUR_SCHEME.DATA[14].TEXT.COLOR;  LINK_TEXT.PENCOLOR:=CUR_SCHEME.DATA[17].TEXT.COLOR;

   //BUTTON
   SAMP_BUTTON.COLOR:=CUR_SCHEME.DATA[15].BACK.COLOR;   SAMP_BUTTON.PENCOLOR:=CUR_SCHEME.DATA[15].TEXT.COLOR;
 END;

 //UPDATES THE DESKTOP WINDOW VIEW AND THE FOLDER VIEW WITH ICONS AND BITMAPS ACCORDINGLY
 MAINDLG.DESKTOPICON.VISIBLE:=NOT CUR_SCHEME.DATA[2].BACK.BITMAP_USED;
 MAINDLG.Image1.VISIBLE:=NOT CUR_SCHEME.DATA[2].BACK.BITMAP_USED;
 IF (CUR_SCHEME.DATA[2].BACK.BITMAP_USED) AND (NOT FILEEXISTS(CUR_SCHEME.DATA[2].BACK.BITMAP_PATH)) THEN CUR_SCHEME.DATA[2].BACK.BITMAP_USED:=FALSE; //IF THE PATH IS NOT FOUND, THEN DEFAULT BACK TO COLOUR ONLY
 IF CUR_SCHEME.DATA[2].BACK.BITMAP_USED THEN BEGIN
   DESKTOP_BACK.CREATE;
   DESKTOP_BACK.LOADFROMFILE(CUR_SCHEME.DATA[2].BACK.BITMAP_PATH);

   MAINDLG.image2.bitmap.LOADFROMRESOURCEID(102);
   IF CUR_SCHEME.DATA[2].BACK.BMP_STYLE=BMP_TILE THEN TileImage(MAINDLG.image2.bitmap,DESKTOP_BACK,TRUE);
   IF CUR_SCHEME.DATA[2].BACK.BMP_STYLE=BMP_CENTER THEN CenterImage(MAINDLG.image2.bitmap,DESKTOP_BACK,TRUE);
   IF CUR_SCHEME.DATA[2].BACK.BMP_STYLE=BMP_STRETCH THEN StretchImage(MAINDLG.image2.bitmap,DESKTOP_BACK,TRUE);
   DESKTOP_BACK.DESTROY;

   INT_ICON.CREATE;INT_ICON.LOADFROMRESOURCEID(100);   MAINDLG.image2.bitmap.CANVAS.DRAW(45,37,INT_ICON);  INT_ICON.DESTROY;

   MAINDLG.image2.bitmap.CANVAS.BRUSH.COLOR:=CUR_SCHEME.DATA[3].BACK.COLOR;
   IF CUR_SCHEME.DATA[3].BACK.TRANS THEN MAINDLG.image2.bitmap.CANVAS.BRUSH.MODE:=BMTRANSPARENT;     MAINDLG.image2.bitmap.CANVAS.FONT:=MAINDLG.FONT;  MAINDLG.image2.bitmap.CANVAS.pen.color:=CUR_SCHEME.DATA[3].text.color;
   MAINDLG.image2.bitmap.CANVAS.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[3].TEXT.FONT.NAME,CUR_SCHEME.DATA[3].TEXT.FONT.SIZE);
   MAINDLG.image2.bitmap.CANVAS.TEXTOUT(24,15,'Desktop Icon'); MAINDLG.image2.refresh;
   MAINDLG.image2.visible:=true;
 END
 ELSE WITH MAINDLG DO BEGIN
   desktop.color:=CUR_SCHEME.DATA[2].BACK.COLOR;
   IF CUR_SCHEME.DATA[3].BACK.TRANS THEN DESKTOPICON.COLOR:=CUR_SCHEME.DATA[2].BACK.COLOR
   ELSE DESKTOPICON.COLOR:=CUR_SCHEME.DATA[3].BACK.COLOR;
   DESKTOPICON.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[3].TEXT.FONT.NAME,CUR_SCHEME.DATA[3].TEXT.FONT.SIZE);
   DESKTOPICON.PENCOLOR:=CUR_SCHEME.DATA[3].TEXT.COLOR;
   MAINDLG.image2.visible:=false;
 END;


 MAINDLG.ICONTEXT.VISIBLE:=NOT CUR_SCHEME.DATA[11].BACK.BITMAP_USED;
 MAINDLG.Panel2.VISIBLE:=NOT CUR_SCHEME.DATA[11].BACK.BITMAP_USED;
 MAINDLG.Image3.VISIBLE:=CUR_SCHEME.DATA[11].BACK.BITMAP_USED;
 IF (CUR_SCHEME.DATA[11].BACK.BITMAP_USED) AND (NOT FILEEXISTS(CUR_SCHEME.DATA[11].BACK.BITMAP_PATH)) THEN CUR_SCHEME.DATA[11].BACK.BITMAP_USED:=FALSE;  //IF THE PATH IS NOT FOUND, THEN DEFAULT BACK TO COLOUR ONLY
 IF CUR_SCHEME.DATA[11].BACK.BITMAP_USED THEN BEGIN
   DESKTOP_BACK.CREATE;

   DESKTOP_BACK.LOADFROMFILE(CUR_SCHEME.DATA[11].BACK.BITMAP_PATH);
   MAINDLG.image3.bitmap.LOADFROMRESOURCEID(103);
   IF CUR_SCHEME.DATA[11].BACK.BMP_STYLE=BMP_TILE THEN TileImage(MAINDLG.image3.bitmap,DESKTOP_BACK,FALSE);
   IF CUR_SCHEME.DATA[11].BACK.BMP_STYLE=BMP_CENTER THEN CenterImage(MAINDLG.image3.bitmap,DESKTOP_BACK,FALSE);
   IF CUR_SCHEME.DATA[11].BACK.BMP_STYLE=BMP_STRETCH THEN StretchImage(MAINDLG.image3.bitmap,DESKTOP_BACK,FALSE);
   DESKTOP_BACK.DESTROY;

   INT_ICON.CREATE;  INT_ICON.LOADFROMRESOURCEID(101);   MAINDLG.image3.bitmap.CANVAS.DRAW(173,33,INT_ICON);  INT_ICON.DESTROY;

   MAINDLG.image3.bitmap.CANVAS.BRUSH.COLOR:=CUR_SCHEME.DATA[12].BACK.COLOR;
   IF CUR_SCHEME.DATA[12].BACK.TRANS THEN MAINDLG.image3.bitmap.CANVAS.BRUSH.MODE:=BMTRANSPARENT;     MAINDLG.image3.bitmap.CANVAS.FONT:=MAINDLG.FONT;  MAINDLG.image3.bitmap.CANVAS.pen.color:=CUR_SCHEME.DATA[12].text.color;
   MAINDLG.image3.bitmap.CANVAS.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[12].TEXT.FONT.NAME,CUR_SCHEME.DATA[12].TEXT.FONT.SIZE);
   MAINDLG.image3.bitmap.CANVAS.TEXTOUT(160,10,' Icon Text '); MAINDLG.image3.refresh;
 END
 ELSE WITH MAINDLG DO BEGIN
   folder_back.color:=CUR_SCHEME.DATA[11].back.color;
   Panel2.color:=CUR_SCHEME.DATA[11].back.color;
   IF CUR_SCHEME.DATA[12].BACK.TRANS THEN ICONTEXT.COLOR:=CUR_SCHEME.DATA[11].BACK.COLOR
   ELSE ICONTEXT.COLOR:=CUR_SCHEME.DATA[12].back.color;
   ICONTEXT.FONT:=SCREEN.GETFONTFROMPOINTSIZE(CUR_SCHEME.DATA[12].TEXT.FONT.NAME,CUR_SCHEME.DATA[12].TEXT.FONT.SIZE);
   ICONTEXT.PENCOLOR:=CUR_SCHEME.DATA[12].TEXT.color;
 END;

 PREVIEW_UPDATEWINCTRLS;
END;
{MAINDLG.folder.visible:=true; MAINDLG.dialog.visible:=true; MAINDLG.INACTIVE.visible:=true;}  MAINDLG.DESKTOP.VISIBLE:=TRUE;
MAINDLG.LABEL5.CAPTION:=TOSTR(MAINDLG.SCHEMEBOX.ITEMINDEX);
MAINDLG.led1.LEDCONDITION:=CHANGED;
END;

//##########################################################################################################################################################

FUNCTION GLOBAL_UPDATEWINCTRLS(FILENAME:STRING):INTEGER;                                                                       //APPLY THE WINDOW CONTROLS TO THE MAIN SYSTEM
VAR BMP_FILE,TEST_FILE,RC_FILE:TFILESTREAM;
    PBitmapMem,BUFFER:Pointer;
    RC,I,FAILED:BYTE;
    MODULEHANDLE,RC2:LONGWORD;
    LOADERROR:cstring;
    FILEZ:FILEDATAR;
    RET:BOOLEAN;
    WIN_CTRL_FILE,TEST:STRING;
LABEL COMPLETED;

BEGIN
  FAILED:=0;
  MKDIR(CURDIR+'\$$$');                                                                  //CREATE TEMP FOLDER IN CURRENT DIRECTORY
  RC_FILE.Create(CURDIR+'\$$$\BMP.RC',Stream_Create);                                    //START THE .RC FILE BUILD
  RC2:=DOSLOADMODULE(LOADERROR,SIZEOF(LOADERROR),FILENAME,MODULEHANDLE);                 //LOAD THE MODULE FILE
  UPDATE_PROGRESS(20);

  IF RC2<>0 THEN BEGIN FAILED:=1; GOTO COMPLETED; END;
  FOR I:=25 TO 57 DO IF I<>49 THEN BEGIN                                                 //GO THROUGH ALL OF THE REQUIRED RESOURCES
    RC_FILE.WRITELN('BITMAP '+TOSTR(I)+' LOADONCALL MOVEABLE BMP_'+TOSTR(I)+'.bmp');
    RC2:=DOSGETRESOURCE(MODULEHANDLE,2,i,BUFFER);
    IF RC2<>0 THEN BEGIN FAILED:=2; GOTO COMPLETED; END;
    DOSQUERYRESOURCESIZE(MODULEHANDLE,2,I,RES_SIZE);
    TEST_FILE.Create(CURDIR+'\$$$\BMP_'+TOSTR(I)+'.BMP',Stream_Create);
    GETMEM(PBitmapMem,RES_SIZE);
    SYSTEM.MOVE(BUFFER^,PBitmapMem^,RES_SIZE);
    DOSFREERESOURCE(BUFFER);
    RC:=UPDATEBMPPALETTE(PBitmapMem,CUR_SCHEME.DATA[1].BACK.COLOR);
    IF RC=0 THEN TEST_FILE.WRITEBUFFER(PBitmapMem^,RES_SIZE) ELSE BEGIN FAILED:=3; GOTO COMPLETED; END;
    TEST_FILE.DESTROY;
    FREEMEM(PBitmapMem,RES_SIZE);
  END;
  DOSFREEMODULE(MODULEHANDLE);
  RC_FILE.DESTROY;
  UPDATE_PROGRESS(30);
  //WE HAVE NOW RIPPED ALL OF THE REQUIRED FILES FROM THE DLL
  //WE NOW NEED TO BUILD THE .BMP FILES INTO THE SYSTEM DLL FILE

  EXECVIASESSION:=FALSE;ASYNCHEXEC:=FALSE;
  CHDIR(CURDIR+'\$$$');
  GETDIR(0,TEST);

  //NEED TO CHECK TO SEE IF THE FILE PMMRGRES.DLL FILE EXISTS, OTHERWISE USE PMMERGE.DLL
  IF FILEEXISTS(BOOTDRIVE+'\OS2\DLL\PMMRGRES.DLL') THEN WIN_CTRL_FILE:='PMMRGRES.DLL' ELSE WIN_CTRL_FILE:='PMMERGE.DLL';
  MAINDLG.MEMO1.LINES.ADD('Applying changes to '+WIN_CTRL_FILE);

  RET:=COPYFILE(BOOTDRIVE+'\OS2\DLL\'+WIN_CTRL_FILE,CURDIR+'\$$$\'+WIN_CTRL_FILE);         //COPY THE FILE FROM OS2\DLL
  IF NOT RET THEN BEGIN FAILED:=4; GOTO COMPLETED; END;

  IF DOSEXITCODE(EXEC(GETENV('COMSPEC'),'/C RC -R BMP.RC BMP.RES'))>1000 THEN BEGIN FAILED:=5; GOTO COMPLETED; END; //COMPILE RESOURCES IN
  UPDATE_PROGRESS(33);
  RC:=RESMGR('a',WIN_CTRL_FILE,'BMP.RES','*','*',FALSE);
  UPDATE_PROGRESS(37);
  IF RC<>0 THEN BEGIN FAILED:=6; GOTO COMPLETED; END;

  //IF DIALOG ENHANCER IS INSTALLED, THEN PLACE THE FILE IN THE DEPROG\DLL FOLDER INSTEAD
  IF FILEEXISTS(BOOTDRIVE+'\OS2\DEPROG\DLL\'+WIN_CTRL_FILE) THEN BEGIN
    DOSREPLACEMODULE(BOOTDRIVE+'\OS2\DEPROG\DLL\'+WIN_CTRL_FILE,'',NIL);
    COPYFILE(CURDIR+'\$$$\'+WIN_CTRL_FILE,BOOTDRIVE+'\OS2\DEPROG\DLL\'+WIN_CTRL_FILE);
    MAINDLG.MEMO1.LINES.ADD('Dialog Enhancer detected - updating file');
  END;
  DOSREPLACEMODULE(BOOTDRIVE+'\OS2\DLL\'+WIN_CTRL_FILE,'',NIL);
  COPYFILE(CURDIR+'\$$$\'+WIN_CTRL_FILE,BOOTDRIVE+'\OS2\DLL\'+WIN_CTRL_FILE);

  //FINAL CLEARUP OF THE TEMP FOLDERS
  FILEZ:=SYSFILETREE('*.*','F');
  FOR I:=1 TO FILEZ.NOSFOUND DO DELETEFILE(FILEZ.NAME[I]);
  CHDIR(CURDIR);
  RMDIR(CURDIR+'\$$$');

  COMPLETED:
  IF FAILED<>0 THEN MAINDLG.MEMO1.LINES.ADD('Compilation failed : #'+TOSTR(FAILED))
  ELSE MAINDLG.MEMO1.LINES.ADD('Compilation successful!');
  RESULT:=FAILED;
END;

//###############################################################################################################################################################
// MISC WINDOW ROUTINES
//###############################################################################################################################################################

Procedure TWaitScr_DLG.WaitScr_DLGOnShow (Sender: TObject);
Begin
  width:=screen.width;   height:=screen.height+30;  left:=0;  top:=-30;
End;

Initialization
  RegisterClasses ([TWaitScr_DLG, TPanel, TProgressBar, TLabel]);
End.
