unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, Menus, DbCtrls, EditBtn, Spin, Buttons, fpspreadsheet,
  fpsallformats, fpspreadsheetctrls, DCPsha512, types, eventlog, Windows,
  INIFiles, DateUtils, LCLType;

type
    Configtype = record
       adminenabled : boolean;
       adminstartup : boolean;
       adminPW : string;
       cifreq : integer;
       citime1start : TDateTime;
       citime2start : TDateTime;
       citime3start : TDateTime;
       citime1late : TDateTime;
       citime2late : TDateTime;
       citime3late : TDateTime;
       citime1end : TDateTime;
       citime2end : TDateTime;
       citime3end : TDateTime;
       configini : TINIFile;
    end;

    membertype = record
       Name : string;
       ID : string;
       Mon1, Mon2, Mon3 : boolean;
       Tue1, Tue2, Tue3 : boolean;
       Wed1, Wed2, Wed3 : boolean;
       Thu1, Thu2, Thu3 : boolean;
       Fri1, Fri2, Fri3 : boolean;
       Sat1, Sat2, Sat3 : boolean;
       Sun1, Sun2, Sun3 : boolean;
       Status1, Status2, Status3 : string;
       DCount1, DCount2, DCount3 : integer;      //On Duty Counter
       ACount1, ACount2, ACount3 : integer;      //Absent Counter
       SCount1, SCount2, SCount3 : integer;      //Shift Counter
       LCount1, LCount2, LCount3 : integer;      //Late Counter
       TCount1, TCount2, TCount3 : integer;      //Total Duty Counter
    end;


  { TForm_main }

  TForm_main = class(TForm)
    btn_checkin: TSpeedButton;
    btn_shift: TButton;
    btn_debugmode: TButton;
    btn_compile: TButton;
    btn_applysettings: TButton;
    btn_defaultsettings: TButton;
    btn_chgpw: TButton;
    btn_unshift: TButton;
    cbox_id: TComboBox;
    cbox_slot: TComboBox;
    cbox_list: TComboBox;
    cbox_sortby: TComboBox;
    cbox_time1endhr: TComboBox;
    cbox_time1endmin: TComboBox;
    cbox_time1latehr: TComboBox;
    cbox_time1latemin: TComboBox;
    cbox_time1starthr: TComboBox;
    cbox_time1startmin: TComboBox;
    cbox_time2endmin: TComboBox;
    cbox_time3endmin: TComboBox;
    cbox_time2latehr: TComboBox;
    cbox_time3latehr: TComboBox;
    cbox_time2starthr: TComboBox;
    cbox_time2endhr: TComboBox;
    cbox_time3starthr: TComboBox;
    cbox_time3endhr: TComboBox;
    cbox_time2startmin: TComboBox;
    cbox_time2latemin: TComboBox;
    cbox_time3startmin: TComboBox;
    cbox_time3latemin: TComboBox;
    chk_adminstartup: TCheckBox;
    cbox_cifreq: TComboBox;
    DCP_sha512_1: TDCP_sha512;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lb_debug: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MainMenu1: TMainMenu;
    logscradmin: TMemo;
    item_data: TMenuItem;
    item_log: TMenuItem;
    item_helpabout: TMenuItem;
    item_opendir: TMenuItem;
    item_editmember: TMenuItem;
    item_reload: TMenuItem;
    item_clrlog: TMenuItem;
    item_save: TMenuItem;
    item_about: TMenuItem;
    item_devlog: TMenuItem;
    SaveDialog1: TSaveDialog;
    tb_input: TEdit;
    logscr: TMemo;
    PgCtrl: TPageControl;
    Tab_Checkin: TTabSheet;
    Tab_Admin: TTabSheet;
    Tab_Settings: TTabSheet;
    //totalno : integer;
    procedure btn_compileClick(Sender: TObject);
    procedure btn_unshiftClick(Sender: TObject);
    procedure cbox_cifreqChange(Sender: TObject);
    procedure item_aboutClick(Sender: TObject);
    procedure item_opendirClick(Sender: TObject);
    procedure SaveRecord;
    procedure btn_applysettingsClick(Sender: TObject);
    procedure btn_chgpwClick(Sender: TObject);
    procedure btn_debugmodeClick(Sender: TObject);
    procedure btn_defaultsettingsClick(Sender: TObject);
    procedure btn_checkinClick(Sender: TObject);
    procedure btn_shiftClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure item_clrlogClick(Sender: TObject);
    procedure item_devlogClick(Sender: TObject);
    procedure item_editmemberClick(Sender: TObject);
    procedure item_reloadClick(Sender: TObject);
    procedure item_saveClick(Sender: TObject);
    procedure logscradminChange(Sender: TObject);
    procedure logscrChange(Sender: TObject);
    procedure PgCtrlChange(Sender: TObject);
    procedure sSpreadsheetInspector1Click(Sender: TObject);
    procedure tb_inputKeyPress(Sender: TObject; var Key: char);
    function ToHash(s : string) : string;

  private
    { private declarations }


  public
    totalno : integer;
    member : array of membertype;

    { public declarations }
  end;
const
  Directory = 'C:\AAttender\8544-ef81-85e3-9be4-1a81-4317-1ae3-0eab';
var
  Form_main: TForm_main;
  configini : TINIFile;
  config : configtype;
  date_ : TDateTime;
  //directory : PChar;
  //totalno : integer;
  DataDB : TsWorkBook;
  DataDB_ : TsWorkSheet;
  debugmode : boolean;
implementation
Uses unit2, unit3;
{$R *.lfm}

{ TForm_main }
function Tform_main.ToHash(s : string) : string;
var
   digest : array[0..63] of byte;
   i : integer;
   str : string;
begin
   DCP_sha512_1 := TDCP_sha512.Create(self);
   DCP_sha512_1.Init;
   DCP_sha512_1.UpdateStr(s);
   DCP_sha512_1.final(digest);
   DCP_sha512_1.Free;
   for i:= 0 to 63 do
      str := str + IntToHex(Digest[i],2);
   ToHash := str;
end;

function L0(w:word):string;
//Add 0 bewtween 1-digit Integer which Turns to String
var
  s : string;
begin
  Str(w,s);
  if w<10 then
   L0:='0'+s
  else
   L0:=s;
end;

function datetostr(a:TDateTime) : string;
//Gene rate Specific Date in String
Var YY,MM,DD : Word;
Begin
   DeCodeDate(a,YY,MM,DD);
   datetostr := L0(yy) + L0(mm) + L0(dd);
end;

procedure TForm_main.SaveRecord;
var i : integer; DateDB : TsWorkBook; DateDB_ : TsWorkSheet;
begin
   //Save Status
   DateDB := TsWorkBook.create;
   DateDB_ := DateDB.AddWorkSheet('Status');
   DateDB_.WriteUTF8Text(0,0, 'ID');
   DateDB_.WriteUTF8Text(0,1, 'Name');
   DateDB_.WriteUTF8Text(0,2, 'Time 1');
   DateDB_.WriteUTF8Text(0,3, 'Time 2');
   DateDB_.WriteUTF8Text(0,4, 'Time 3');
   for i := 1 to form_main.totalno do
   begin
      DateDB_.WriteUTF8Text(i, 0, member[i-1].ID);
      DateDB_.WriteUTF8Text(i, 1, member[i-1].Name);
      DateDB_.WriteUTF8Text(i, 2, member[i-1].Status1);
      DateDB_.WriteUTF8Text(i, 3, member[i-1].Status2);
      DateDB_.WriteUTF8Text(i, 4, member[i-1].Status3);
   end;
   DateDB.WriteToFile(Directory + '\log\' + datetostr(date) + '.xlsx', sfOOXML, true);
   DateDB.Free;

   //Save Data
   DataDB := TsWorkBook.Create;
   DataDB_ := DataDB.AddWorkSheet('Data');
   DataDB_.WriteUTF8Text(0,0, 'ID');
   DataDB_.WriteUTF8Text(0,1, 'Name');
   DataDB_.WriteUTF8Text(0,2, 'OnDuty 1');
   DataDB_.WriteUTF8Text(0,3, 'OnDuty 2');
   DataDB_.WriteUTF8Text(0,4, 'OnDuty 3');
   DataDB_.WriteUTF8Text(0,5, 'Abs 1');
   DataDB_.WriteUTF8Text(0,6, 'Abs 2');
   DataDB_.WriteUTF8Text(0,7, 'Abs 3');
   DataDB_.WriteUTF8Text(0,8, 'Shift 1');
   DataDB_.WriteUTF8Text(0,9, 'Shift 2');
   DataDB_.WriteUTF8Text(0,10, 'Shift 3');
   DataDB_.WriteUTF8Text(0,11, 'Late 1');
   DataDB_.WriteUTF8Text(0,12, 'Late 2');
   DataDB_.WriteUTF8Text(0,13, 'Late 3');
   DataDB_.WriteUTF8Text(0,14, 'Total 1');
   DataDB_.WriteUTF8Text(0,15, 'Total 2');
   DataDB_.WriteUTF8Text(0,16, 'Total 3');
   for i := 1 to form_main.totalno do
   begin
      DataDB_.WriteUTF8Text(i, 0, member[i-1].ID);
      DataDB_.WriteUTF8Text(i, 1, member[i-1].Name);
      DataDB_.WriteNumber(i, 2, member[i-1].DCount1);
      DataDB_.WriteNumber(i, 3, member[i-1].DCount2);
      DataDB_.WriteNumber(i, 4, member[i-1].DCount3);
      DataDB_.WriteNumber(i, 5, member[i-1].ACount1);
      DataDB_.WriteNumber(i, 6, member[i-1].ACount2);
      DataDB_.WriteNumber(i, 7, member[i-1].ACount3);
      DataDB_.WriteNumber(i, 8, member[i-1].SCount1);
      DataDB_.WriteNumber(i, 9, member[i-1].SCount2);
      DataDB_.WriteNumber(i, 10, member[i-1].SCount3);
      DataDB_.WriteNumber(i, 11, member[i-1].LCount1);
      DataDB_.WriteNumber(i, 12, member[i-1].LCount2);
      DataDB_.WriteNumber(i, 13, member[i-1].LCount3);
      DataDB_.WriteNumber(i, 14, member[i-1].TCount1);
      DataDB_.WriteNumber(i, 15, member[i-1].TCount2);
      DataDB_.WriteNumber(i, 16, member[i-1].TCount3);
   end;
   DataDB.WriteToFile(Directory + '\Data.xlsx', sfOOXML, true);
   DataDB.Free;
end;

procedure TForm_main.item_opendirClick(Sender: TObject);
begin
  if not (ToHash(passwordbox('Authenication', 'Enter administrator password to open the directory:')) = config.adminpw) then
      begin
         Application.MessageBox('Wrong password', 'Error',MB_ICONWARNING);
         exit;
      end
  else ShellExecute(Handle,'open', PChar(directory), nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm_main.btn_unshiftClick(Sender: TObject);
var i : integer; bool1, bool2, bool3 : boolean; f : text;
begin
   if date <> date_ then form_main.activate;
   if (cbox_id.ItemIndex < 0) or (cbox_slot.itemindex < 0) then
   begin
      logscr.lines.append('Error: Please Select the Items');
      exit;
   end;
   i := cbox_id.itemindex;
   if cbox_slot.itemindex = 0 then
   begin
      if member[i].SCount1 = 0 then
      begin
         logscr.lines.append('Error: No Existing Shifted Time Slot Left.');
         exit;
      end
   end
   else if cbox_slot.itemindex = 1 then
   begin
      if member[i].SCount2 = 0 then
      begin
         logscr.lines.append('Error: No Existing Shift Time Slot Left.');
         exit;
      end
   end
   else if cbox_slot.itemindex = 2 then
   begin
      if member[i].SCount3 = 0 then
      begin
         logscr.lines.append('Error: No Existing Shift Time Slot Left.');
         exit;
      end
   end;
   if not (ToHash(passwordbox('Authenication', 'Enter administrator password:')) = config.adminpw) then
   begin
      logscr.lines.append('Wrong Password. Please Try Again.');
      exit;
   end
   else logscr.lines.append('Shift Function Access Granted.');

   case dayofweek(date) of
   1 : begin
          bool1 := member[i].Sun1;
          bool2 := member[i].Sun2;
          bool3 := member[i].Sun3;
       end;
   2 : begin
          bool1 := member[i].Mon1;
          bool2 := member[i].Mon2;
          bool3 := member[i].Mon3;
       end;
   3 : begin
          bool1 := member[i].Tue1;
          bool2 := member[i].Tue2;
          bool3 := member[i].Tue3;
       end;
   4 : begin
          bool1 := member[i].Wed1;
          bool2 := member[i].Wed2;
          bool3 := member[i].Wed3;
       end;
   5 : begin
          bool1 := member[i].Thu1;
          bool2 := member[i].Thu2;
          bool3 := member[i].Thu3;
       end;
   6 : begin
          bool1 := member[i].Fri1;
          bool2 := member[i].Fri2;
          bool3 := member[i].Fri3;
       end;
   7 : begin
          bool1 := member[i].Sat1;
          bool2 := member[i].Sat2;
          bool3 := member[i].Sat3;
       end;
   end;

   if cbox_slot.itemindex = 0 then    //Slot 1
   begin
      if Application.MessageBox(PChar('You are about to reset ' + member[i].Name + '''s slot 1 shifted record.' + sLineBreak + 'Confirm?'), 'Confirmation',MB_ICONINFORMATION + MB_YESNO) = IDYES then
      begin
         if (bool1) and (member[i].Status1 = 'ntdabs') then
            member[i].Status1 := 'absent';
         dec(member[i].SCount1);
         if debugmode then logscr.lines.append(member[i].name + ' SCount1 - 1');
         if member[i].SCount1 < 0 then
         begin
            logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount1.');
            assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount1.log');
            rewrite(f);
            closeFile(f);
         end;
         logscr.lines.append(member[i].name + '''s Slot 1 Shifted Duty Reset.');
      end
      else logscr.lines.append('Undo Shift Duty Command Cancelled.');
   end
   else if cbox_slot.itemindex = 1 then  //Slot 2
   begin
      if Application.MessageBox(PChar('You are about to reset ' + form_main.member[i].name + '''s slot 2 shifted record.' + sLineBreak + 'Confirm?'), 'Confirmation',MB_ICONINFORMATION + MB_YESNO) = IDYES then
      begin
         if (bool2) and (member[i].Status2 = 'ntdabs') then
            member[i].Status2 := 'absent';
         dec(member[i].SCount2);
         if debugmode then logscr.lines.append(member[i].name + ' SCount2 - 1');
         if member[i].SCount2 < 0 then
         begin
            logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount2.');
            assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount2.log');
            rewrite(f);
            closeFile(f);
         end;
         logscr.lines.append(member[i].name + '''s Slot 2 Shifted Duty Reset.');
      end
      else logscr.lines.append('Undo Shift Duty Command Cancelled.');
   end
   else if cbox_slot.itemindex = 2 then  //Slot 3
   begin
      if Application.MessageBox(PChar('You are about to Reset ' + form_main.member[i].name + '''s Slot 3 Shifted Record.' + sLineBreak + 'Confirm?'), 'Confirmation',MB_ICONINFORMATION + MB_YESNO) = IDYES then
      begin
         if (bool3) and (member[i].Status3 = 'ntdabs') then
            member[i].Status3 := 'absent';
         dec(member[i].SCount3);
         if debugmode then logscr.lines.append(member[i].name + ' SCount3 - 1');
         if member[i].SCount3 < 0 then
         begin
            logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount3.');
            assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount3.log');
            rewrite(f);
            closeFile(f);
         end;
         logscr.lines.append(member[i].name + '''s Slot 3 Shifted Duty Reset.');
      end
      else logscr.lines.append('Undo Shift Duty Command Cancelled.');
   end;
   form_main.saverecord;
end;

procedure TForm_main.btn_compileClick(Sender: TObject);
var  tmp: TStringList;  i : integer; bool1, bool2, bool3 : boolean;
begin
   if date <> date_ then form_main.activate;
   if (cbox_list.ItemIndex < 0) or (cbox_sortby.ItemIndex < 0) then
   begin
      logscr.lines.append('Error: Please Select the Items');
      exit;
   end;
   logscr.lines.append('');
   tmp := TStringList.Create;
   tmp.Clear;
   if cbox_list.ItemIndex = 0 then //Duty Count
   begin

      if cbox_sortby.ItemIndex = 0 then     //by ID
      begin
         logscr.lines.append('ID, Name, Duty Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + inttostr(form_main.member[i].DCount1+form_main.member[i].DCount2+form_main.member[i].DCount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 1 then //by NAME
      begin
         logscr.lines.append('Name, ID, Duty Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + inttostr(form_main.member[i].DCount1+form_main.member[i].DCount2+form_main.member[i].DCount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 2 then
      begin
         logscr.lines.append('Duty Count, ID, Name');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(inttostr(form_main.member[i].DCount1+form_main.member[i].DCount2+form_main.member[i].DCount3) + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
         end;
      end
   end
   else if cbox_list.ItemIndex = 1 then //Late Count
   begin
      if cbox_sortby.ItemIndex = 0 then     //by ID
      begin
         logscr.lines.append('ID, Name, Late Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + inttostr(form_main.member[i].LCount1+form_main.member[i].LCount2+form_main.member[i].LCount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 1 then //by NAME
      begin
         logscr.lines.append('Name, ID, Late Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + inttostr(form_main.member[i].LCount1+form_main.member[i].LCount2+form_main.member[i].LCount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 2 then
      begin
         logscr.lines.append('Late Count, ID, Name');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(inttostr(form_main.member[i].LCount1+form_main.member[i].LCount2+form_main.member[i].LCount3) + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
         end;
      end
   end
   else if cbox_list.ItemIndex = 2 then //ABS Count
   begin
      if cbox_sortby.ItemIndex = 0 then     //by ID
      begin
         logscr.lines.append('ID, Name, Absent Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + inttostr(form_main.member[i].ACount1+form_main.member[i].ACount2+form_main.member[i].ACount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 1 then //by NAME
      begin
         logscr.lines.append('Name, ID, Absent Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + inttostr(form_main.member[i].ACount1+form_main.member[i].ACount2+form_main.member[i].ACount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 2 then
      begin
         logscr.lines.append('Absent Count, ID, Name');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(inttostr(form_main.member[i].ACount1+form_main.member[i].ACount2+form_main.member[i].ACount3) + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
         end;
      end
   end
   else if cbox_list.ItemIndex = 3 then //Shift Count
   begin
      if cbox_sortby.ItemIndex = 0 then     //by ID
      begin
         logscr.lines.append('ID, Name, Shift Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + inttostr(form_main.member[i].SCount1+form_main.member[i].SCount2+form_main.member[i].SCount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 1 then //by NAME
      begin
         logscr.lines.append('Name, ID, Shift Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + inttostr(form_main.member[i].SCount1+form_main.member[i].SCount2+form_main.member[i].SCount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 2 then
      begin
         logscr.lines.append('Shift Count, ID, Name');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(inttostr(form_main.member[i].SCount1+form_main.member[i].SCount2+form_main.member[i].SCount3) + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
         end;
      end
   end
   else if cbox_list.ItemIndex = 4 then //Total Count
   begin
      if cbox_sortby.ItemIndex = 0 then     //by ID
      begin
         logscr.lines.append('ID, Name, Total Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + inttostr(form_main.member[i].TCount1+form_main.member[i].TCount2+form_main.member[i].TCount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 1 then //by NAME
      begin
         logscr.lines.append('Name, ID, Total Count');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + inttostr(form_main.member[i].TCount1+form_main.member[i].TCount2+form_main.member[i].TCount3));
         end;
      end
      else if cbox_sortby.ItemIndex = 2 then
      begin
         logscr.lines.append('Total Count, ID, Name');
         for i := 0 to totalno - 1 do
         begin
             tmp.AddText(inttostr(form_main.member[i].TCount1+form_main.member[i].TCount2+form_main.member[i].TCount3) + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
         end;
      end
   end
   else //Present List, Late List, Absent List, ALL List
   begin
       if cbox_sortby.itemindex = 0 then //by ID
          logscr.lines.append('ID, Name, Status')
       else if cbox_sortby.itemindex = 1 then //by Name
          logscr.lines.append('Name, ID, Status')
       else if cbox_sortby.itemindex = 2 then //by Status
          logscr.lines.append('Status, ID, Name');

       if time < config.citime2start then //Time Slot 1
       begin
          for i := 0 to totalno - 1 do
          begin
              case dayofweek(date) of
                 1 : begin
                        bool1 := member[i].Sun1;
                        bool2 := member[i].Sun2;
                        bool3 := member[i].Sun3;
                     end;
                 2 : begin
                        bool1 := member[i].Mon1;
                        bool2 := member[i].Mon2;
                        bool3 := member[i].Mon3;
                     end;
                 3 : begin
                        bool1 := member[i].Tue1;
                        bool2 := member[i].Tue2;
                        bool3 := member[i].Tue3;
                     end;
                 4 : begin
                        bool1 := member[i].Wed1;
                        bool2 := member[i].Wed2;
                        bool3 := member[i].Wed3;
                     end;
                 5 : begin
                        bool1 := member[i].Thu1;
                        bool2 := member[i].Thu2;
                        bool3 := member[i].Thu3;
                     end;
                 6 : begin
                        bool1 := member[i].Fri1;
                        bool2 := member[i].Fri2;
                        bool3 := member[i].Fri3;
                     end;
                 7 : begin
                        bool1 := member[i].Sat1;
                        bool2 := member[i].Sat2;
                        bool3 := member[i].Sat3;
                     end;
              end;
              if cbox_list.ItemIndex = 5 then   //Present List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].Status1 = 'present') or (form_main.member[i].Status1 = 'onduty') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].Status1 = 'present') or (form_main.member[i].Status1 = 'onduty') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].Status1 = 'present') or (form_main.member[i].Status1 = 'onduty') then
                       tmp.AddText(form_main.member[i].Status1 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end
              else if cbox_list.ItemIndex = 6 then   //Late List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].Status1 = 'late') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].Status1 = 'late') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].Status1 = 'late') then
                       tmp.AddText(form_main.member[i].Status1 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 7 then   //Absent (On Duty) List
              begin
                 if cbox_sortby.ItemIndex = 0 then //by ID
                 begin
                    if bool1 and ((form_main.member[i].Status1 = 'absent') or (form_main.member[i].Status1 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if bool1 and ((form_main.member[i].Status1 = 'absent') or (form_main.member[i].Status1 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if bool1 and ((form_main.member[i].Status1 = 'absent') or (form_main.member[i].Status1 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].Status1 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 8 then   //Absent (ALL) List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].Status1 = 'absent') or (form_main.member[i].Status1 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].Status1 = 'absent') or (form_main.member[i].Status1 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].Status1 = 'absent') or (form_main.member[i].Status1 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].Status1 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 9 then   //All List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Status1);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].Status1 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end;
         end;
      end else if time < config.citime3start then //Time Slot 2
       begin
          for i := 0 to totalno - 1 do
          begin
              case dayofweek(date) of
                 1 : begin
                        bool1 := member[i].Sun1;
                        bool2 := member[i].Sun2;
                        bool3 := member[i].Sun3;
                     end;
                 2 : begin
                        bool1 := member[i].Mon1;
                        bool2 := member[i].Mon2;
                        bool3 := member[i].Mon3;
                     end;
                 3 : begin
                        bool1 := member[i].Tue1;
                        bool2 := member[i].Tue2;
                        bool3 := member[i].Tue3;
                     end;
                 4 : begin
                        bool1 := member[i].Wed1;
                        bool2 := member[i].Wed2;
                        bool3 := member[i].Wed3;
                     end;
                 5 : begin
                        bool1 := member[i].Thu1;
                        bool2 := member[i].Thu2;
                        bool3 := member[i].Thu3;
                     end;
                 6 : begin
                        bool1 := member[i].Fri1;
                        bool2 := member[i].Fri2;
                        bool3 := member[i].Fri3;
                     end;
                 7 : begin
                        bool1 := member[i].Sat1;
                        bool2 := member[i].Sat2;
                        bool3 := member[i].Sat3;
                     end;
              end;
              if cbox_list.ItemIndex = 5 then   //Present List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].status2 = 'present') or (form_main.member[i].status2 = 'onduty') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].status2 = 'present') or (form_main.member[i].status2 = 'onduty') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].status2 = 'present') or (form_main.member[i].status2 = 'onduty') then
                       tmp.AddText(form_main.member[i].status2 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end
              else if cbox_list.ItemIndex = 6 then   //Late List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].status2 = 'late') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].status2 = 'late') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].status2 = 'late') then
                       tmp.AddText(form_main.member[i].status2 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 7 then   //Absent (On Duty) List
              begin
                 if cbox_sortby.ItemIndex = 0 then //by ID
                 begin
                    if bool1 and ((form_main.member[i].status2 = 'absent') or (form_main.member[i].status2 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if bool1 and ((form_main.member[i].status2 = 'absent') or (form_main.member[i].status2 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if bool1 and ((form_main.member[i].status2 = 'absent') or (form_main.member[i].status2 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].status2 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 8 then   //Absent (ALL) List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].status2 = 'absent') or (form_main.member[i].status2 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].status2 = 'absent') or (form_main.member[i].status2 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].status2 = 'absent') or (form_main.member[i].status2 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].status2 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 9 then   //All List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status2);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].status2 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end;
         end;
      end else if time >= config.citime3start then //Time Slot 3
       begin
          for i := 0 to totalno - 1 do
          begin
              case dayofweek(date) of
                 1 : begin
                        bool1 := member[i].Sun1;
                        bool2 := member[i].Sun2;
                        bool3 := member[i].Sun3;
                     end;
                 2 : begin
                        bool1 := member[i].Mon1;
                        bool2 := member[i].Mon2;
                        bool3 := member[i].Mon3;
                     end;
                 3 : begin
                        bool1 := member[i].Tue1;
                        bool2 := member[i].Tue2;
                        bool3 := member[i].Tue3;
                     end;
                 4 : begin
                        bool1 := member[i].Wed1;
                        bool2 := member[i].Wed2;
                        bool3 := member[i].Wed3;
                     end;
                 5 : begin
                        bool1 := member[i].Thu1;
                        bool2 := member[i].Thu2;
                        bool3 := member[i].Thu3;
                     end;
                 6 : begin
                        bool1 := member[i].Fri1;
                        bool2 := member[i].Fri2;
                        bool3 := member[i].Fri3;
                     end;
                 7 : begin
                        bool1 := member[i].Sat1;
                        bool2 := member[i].Sat2;
                        bool3 := member[i].Sat3;
                     end;
              end;
              if cbox_list.ItemIndex = 5 then   //Present List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].status3 = 'present') or (form_main.member[i].status3 = 'onduty') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].status3 = 'present') or (form_main.member[i].status3 = 'onduty') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].status3 = 'present') or (form_main.member[i].status3 = 'onduty') then
                       tmp.AddText(form_main.member[i].status3 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end
              else if cbox_list.ItemIndex = 6 then   //Late List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].status3 = 'late') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].status3 = 'late') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].status3 = 'late') then
                       tmp.AddText(form_main.member[i].status3 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 7 then   //Absent (On Duty) List
              begin
                 if cbox_sortby.ItemIndex = 0 then //by ID
                 begin
                    if bool1 and ((form_main.member[i].status3 = 'absent') or (form_main.member[i].status3 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if bool1 and ((form_main.member[i].status3 = 'absent') or (form_main.member[i].status3 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if bool1 and ((form_main.member[i].status3 = 'absent') or (form_main.member[i].status3 = 'ntdabs')) then
                       tmp.AddText(form_main.member[i].status3 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 8 then   //Absent (ALL) List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if (form_main.member[i].status3 = 'absent') or (form_main.member[i].status3 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if (form_main.member[i].status3 = 'absent') or (form_main.member[i].status3 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if (form_main.member[i].status3 = 'absent') or (form_main.member[i].status3 = 'ntdabs') then
                       tmp.AddText(form_main.member[i].status3 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end
              end else if cbox_list.ItemIndex = 9 then   //All List
              begin
                 if cbox_sortby.ItemIndex = 0 then       //by ID
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].ID + ', ' + form_main.member[i].Name + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 1 then   //by NAME
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].Name + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].status3);
                 end
                 else if cbox_sortby.ItemIndex = 2 then //by Status
                 begin
                    if true then
                       tmp.AddText(form_main.member[i].status3 + ', ' + form_main.member[i].ID + ', ' + form_main.member[i].Name);
                 end;
              end;
         end;
      end;

   end;
   tmp.Sort;
   logscr.lines.AddStrings(tmp);
   logscr.lines.append('');
   tmp.Destroy;
end;
procedure TForm_main.cbox_cifreqChange(Sender: TObject);
begin
  groupbox4.Enabled := true;
  if cbox_cifreq.ItemIndex = 0 then
  begin
     groupbox5.Enabled := false;
     groupbox6.Enabled := false;
  end
  else
  if cbox_cifreq.ItemIndex = 1 then
  begin
     groupbox5.Enabled := true;
     groupbox6.Enabled := false;
  end
  else
  if cbox_cifreq.ItemIndex = 2 then
  begin
     groupbox5.Enabled := true;
     groupbox6.Enabled := true;
  end;
end;


procedure TForm_main.item_aboutClick(Sender: TObject);
begin
   form_about.showmodal;
end;

procedure genabs;
var  i : integer; DateDB : TsWorkBook; DateDB_ : TsWorkSheet; bool1, bool2, bool3 : boolean;
begin
   //GenABS
   DateDB := TsWorkBook.create;
   DateDB_ := DateDB.AddWorkSheet('Status');
   DateDB_.WriteUTF8Text(0,0, 'ID');
   DateDB_.WriteUTF8Text(0,1, 'Name');
   DateDB_.WriteUTF8Text(0,2, 'Time 1');
   DateDB_.WriteUTF8Text(0,3, 'Time 2');
   DateDB_.WriteUTF8Text(0,4, 'Time 3');
   for i := 1 to form_main.totalno do
   begin
      DateDB_.WriteUTF8Text(i, 0, form_main.member[i-1].ID);
      DateDB_.WriteUTF8Text(i, 1, form_main.member[i-1].Name);
      form_main.member[i-1].status1 := 'absent';
      form_main.member[i-1].status2 := 'absent';
      form_main.member[i-1].status3 := 'absent';
      DateDB_.WriteUTF8Text(i, 2, form_main.member[i-1].Status1);
      DateDB_.WriteUTF8Text(i, 3, form_main.member[i-1].Status2);
      DateDB_.WriteUTF8Text(i, 4, form_main.member[i-1].Status3);
   end;
   DateDB.WriteToFile(Directory + '\log\' + datetostr(date) + '.xlsx', sfOOXML, true);
   DateDB.Free;

   //Calc TCount
   for i := 0 to form_main.totalno - 1 do
   begin
      case dayofweek(date) of
      1 : begin
             bool1 := form_main.member[i].Sun1;
             bool2 := form_main.member[i].Sun2;
             bool3 := form_main.member[i].Sun3;
          end;
      2 : begin
             bool1 := form_main.member[i].Mon1;
             bool2 := form_main.member[i].Mon2;
             bool3 := form_main.member[i].Mon3;
          end;
      3 : begin
             bool1 := form_main.member[i].Tue1;
             bool2 := form_main.member[i].Tue2;
             bool3 := form_main.member[i].Tue3;
          end;
      4 : begin
             bool1 := form_main.member[i].Wed1;
             bool2 := form_main.member[i].Wed2;
             bool3 := form_main.member[i].Wed3;
          end;
      5 : begin
             bool1 := form_main.member[i].Thu1;
             bool2 := form_main.member[i].Thu2;
             bool3 := form_main.member[i].Thu3;
          end;
      6 : begin
             bool1 := form_main.member[i].Fri1;
             bool2 := form_main.member[i].Fri2;
             bool3 := form_main.member[i].Fri3;
          end;
      7 : begin
             bool1 := form_main.member[i].Sat1;
             bool2 := form_main.member[i].Sat2;
             bool3 := form_main.member[i].Sat3;
          end;
      end;
      if bool1 then
      begin
         inc(form_main.member[i].ACount1);
         inc(form_main.member[i].TCount1);
      end;
      if bool2 then
      begin
         inc(form_main.member[i].ACount2);
         inc(form_main.member[i].TCount2);
      end;
      if bool3 then
      begin
         inc(form_main.member[i].ACount3);
         inc(form_main.member[i].TCount3);
      end;
   end;
   form_main.saverecord;
end;
procedure initStatus;
var i : integer;  DateDB : TsWorkBook; DateDB_ : TsWorkSheet;
begin
   DateDB := TsWorkBook.Create;
   DateDB.ReadFromFile(directory + '\log\' + datetostr(date) + '.xlsx', sfOOXML);
   DateDB_ := DateDB.GetFirstWorkSheet;
   for i := 1 to form_main.totalno do
   begin
      form_main.member[i-1].status1 := DateDB_.ReadAsUTF8Text(i, 2);
      form_main.member[i-1].status2 := DateDB_.ReadAsUTF8Text(i, 3);
      form_main.member[i-1].status3 := DateDB_.ReadAsUTF8Text(i, 4);
   end;
   DateDB.Free;
end;

procedure TForm_main.FormActivate(Sender: TObject);     //Initiation
var f : textFile;  new : boolean;  i : integer; str1: string;
begin
   date_ := date;
   //directory := PChar(GetCurrentDir);
   PgCtrl.ActivePageIndex := 0;       //Predefined Page
   if not DirectoryExists(directory) then
      createDir(directory);           //Predefined Dir
   FileSetAttr('C:/AAttender',  faSysFile or faReadOnly or faHidden);
   FileSetAttr(directory,  faSysFile or faReadOnly or faHidden);
   if not DirectoryExists(directory + '\log') then
      createDir(directory + '\log');
   if not DirectoryExists(directory + '\log\dev') then
      createDir(directory + '\log\dev');
   logscr.text := 'Welcome to the AAttender.';
   //form_main.item_devlogClick(Form_main);
   //Start: Config
   if not fileexists(directory + '\config.ini') then
   begin
      assignFile(f, directory + '\config.ini');
      rewrite(f);
      writeln(f,'; Configuration Files of Attendance Program');
      writeln(f);
      closeFile(f);
      new := true;

      str1 := passwordbox('Create Password', 'Enter admin password:');
      if str1 = '' then
      begin
         Application.MessageBox('Error: Blank Password Not Allowed', 'Error',MB_ICONWARNING);
         deletefile(directory + '\config.ini');
         halt;
      end;
      if passwordbox('Create Password', 'Repeat password:') = str1 then
      begin
         Application.MessageBox('Admin password saved.', 'Done', MB_ICONINFORMATION);
         config.adminpw := ToHash(str1);
         configini := TINIFile.Create(directory + '\config.ini');
         configini.WriteString('Admin', 'PW', config.adminPW);
         configini.destroy;
         logscr.lines.append('Admin Password is in Effect.');
        end
      else begin
         Application.MessageBox('Error: Wrong Password', 'Error',MB_ICONWARNING);
         deletefile(directory + '\config.ini');
         halt;
      end;

   end
   else new := false;

   configini := TINIFile.Create(directory + '\config.ini');
   config.adminstartup := configini.ReadBool('Admin', 'StartUp', false);
   config.cifreq := configini.ReadInteger('Checkin', 'Freq', 3);
   config.adminPW := configini.ReadString('Admin', 'PW', '');
   config.citime1start := strtotime(configini.ReadString('Checkin', 'Time1_Start', '07:00'));
   config.citime1late := strtotime(configini.ReadString('Checkin', 'Time1_late', '07:35'));
   config.citime1end := strtotime(configini.ReadString('Checkin', 'Time1_end', '08:00'));
   config.citime2start := strtotime(configini.ReadString('Checkin', 'Time2_Start', '12:45'));
   config.citime2late := strtotime(configini.ReadString('Checkin', 'Time2_Late', '13:30'));
   config.citime2end := strtotime(configini.ReadString('Checkin', 'Time2_End', '14:00'));
   config.citime3start := strtotime(configini.ReadString('Checkin', 'Time3_Start', '15:20'));
   config.citime3late := strtotime(configini.ReadString('Checkin', 'Time3_Late', '15:40'));
   config.citime3end := strtotime(configini.ReadString('Checkin', 'Time3_End', '17:00'));
   configini.destroy;

   if new then
   begin
      configini := TINIFile.Create(directory + '\config.ini');
      configini.WriteBool('Admin', 'StartUp',  config.adminstartup);
      configini.WriteInteger('Checkin', 'Freq', config.cifreq);
      configini.WriteString('Checkin', 'Time1_Start', timetostr(config.citime1start));
      configini.WriteString('Checkin', 'Time1_Late', timetostr(config.citime1Late));
      configini.WriteString('Checkin', 'Time1_End', timetostr(config.citime1End));
      configini.WriteString('Checkin', 'Time2_Start', timetostr(config.citime2start));
      configini.WriteString('Checkin', 'Time2_Late', timetostr(config.citime2Late));
      configini.WriteString('Checkin', 'Time2_End', timetostr(config.citime2End));
      configini.WriteString('Checkin', 'Time3_Start', timetostr(config.citime3start));
      configini.WriteString('Checkin', 'Time3_Late', timetostr(config.citime3Late));
      configini.WriteString('Checkin', 'Time3_End', timetostr(config.citime3End));
      configini.destroy;
   end;
   //End: Config
   if config.adminstartup then
   begin
      if not (ToHash(passwordbox('Authenication', 'Enter administrator password to use the program:')) = config.adminpw) then
      begin
        Application.MessageBox('Wrong password', 'Error',MB_ICONWARNING);
        halt;
      end;
   end;

   //Start: MemberDutyList
   if not fileexists(directory + '\members.ini') then
   begin
      assignFile(f, directory + '\members.ini');
      rewrite(f);
      writeln(f,'; Configuration Files of Members List');
      writeln(f);
      writeln(f,'[Main]');
      writeln(f,'Total=0');
      closeFile(f);
   end;

   configini := TINIFile.Create(directory + '\members.ini');
   if configini.ReadInteger('Main', 'Total', 0) = 0 then
      logscr.lines.append('WARNING: MEMEBER LIST IS MISSING')
   else
   begin
      form_main.totalno := configini.ReadInteger('Main', 'Total', 0);
      setlength(member, form_main.totalno);
      for i := 0 to form_main.totalno - 1 do
      begin
         member[i].Name := configini.ReadString(inttostr(i), 'Name', 'MISSING_NAME');
         member[i].ID := configini.ReadString(inttostr(i), 'ID', inttostr(i));
         member[i].Mon1 := configini.ReadBool(inttostr(i), 'Mon1', False);
         member[i].Mon2 := configini.ReadBool(inttostr(i), 'Mon2', False);
         member[i].Mon3 := configini.ReadBool(inttostr(i), 'Mon3', False);
         member[i].Tue1 := configini.ReadBool(inttostr(i), 'Tue1', False);
         member[i].Tue2 := configini.ReadBool(inttostr(i), 'Tue2', False);
         member[i].Tue3 := configini.ReadBool(inttostr(i), 'Tue3', False);
         member[i].Wed1 := configini.ReadBool(inttostr(i), 'Wed1', False);
         member[i].Wed2 := configini.ReadBool(inttostr(i), 'Wed2', False);
         member[i].Wed3 := configini.ReadBool(inttostr(i), 'Wed3', False);
         member[i].Thu1 := configini.ReadBool(inttostr(i), 'Thu1', False);
         member[i].Thu2 := configini.ReadBool(inttostr(i), 'Thu2', False);
         member[i].Thu3 := configini.ReadBool(inttostr(i), 'Thu3', False);
         member[i].Fri1 := configini.ReadBool(inttostr(i), 'Fri1', False);
         member[i].Fri2 := configini.ReadBool(inttostr(i), 'Fri2', False);
         member[i].Fri3 := configini.ReadBool(inttostr(i), 'Fri3', False);
         member[i].Sat1 := configini.ReadBool(inttostr(i), 'Sat1', False);
         member[i].Sat2 := configini.ReadBool(inttostr(i), 'Sat2', False);
         member[i].Sat3 := configini.ReadBool(inttostr(i), 'Sat3', False);
         member[i].Sun1 := configini.ReadBool(inttostr(i), 'Sun1', False);
         member[i].Sun2 := configini.ReadBool(inttostr(i), 'Sun2', False);
         member[i].Sun3 := configini.ReadBool(inttostr(i), 'Sun3', False);
      end;
      configini.destroy;
   end;
   //End: MemberDutyList

   //Start: MemberData
   if not fileexists(directory + '\Data.xlsx') then
   begin
      DataDB := TsWorkBook.Create;
      DataDB_ := DataDB.AddWorkSheet('Data');
      DataDB_.WriteUTF8Text(0,0, 'ID');
      DataDB_.WriteUTF8Text(0,1, 'Name');
      DataDB_.WriteUTF8Text(0,2, 'OnDuty 1');
      DataDB_.WriteUTF8Text(0,3, 'OnDuty 2');
      DataDB_.WriteUTF8Text(0,4, 'OnDuty 3');
      DataDB_.WriteUTF8Text(0,5, 'Abs 1');
      DataDB_.WriteUTF8Text(0,6, 'Abs 2');
      DataDB_.WriteUTF8Text(0,7, 'Abs 3');
      DataDB_.WriteUTF8Text(0,8, 'Shift 1');
      DataDB_.WriteUTF8Text(0,9, 'Shift 2');
      DataDB_.WriteUTF8Text(0,10, 'Shift 3');
      DataDB_.WriteUTF8Text(0,11, 'Late 1');
      DataDB_.WriteUTF8Text(0,12, 'Late 2');
      DataDB_.WriteUTF8Text(0,13, 'Late 3');
      DataDB_.WriteUTF8Text(0,14, 'Total 1');
      DataDB_.WriteUTF8Text(0,15, 'Total 2');
      DataDB_.WriteUTF8Text(0,16, 'Total 3');
      for i := 1 to form_main.totalno do
      begin
         DataDB_.WriteUTF8Text(i, 0, member[i-1].ID);
         DataDB_.WriteUTF8Text(i, 1, member[i-1].Name);
         DataDB_.WriteNumber(i, 2, member[i-1].DCount1);
         DataDB_.WriteNumber(i, 3, member[i-1].DCount2);
         DataDB_.WriteNumber(i, 4, member[i-1].DCount3);
         DataDB_.WriteNumber(i, 5, member[i-1].ACount1);
         DataDB_.WriteNumber(i, 6, member[i-1].ACount2);
         DataDB_.WriteNumber(i, 7, member[i-1].ACount3);
         DataDB_.WriteNumber(i, 8, member[i-1].SCount1);
         DataDB_.WriteNumber(i, 9, member[i-1].SCount2);
         DataDB_.WriteNumber(i, 10, member[i-1].SCount3);
         DataDB_.WriteNumber(i, 11, member[i-1].LCount1);
         DataDB_.WriteNumber(i, 12, member[i-1].LCount2);
         DataDB_.WriteNumber(i, 13, member[i-1].LCount3);
         DataDB_.WriteNumber(i, 14, member[i-1].TCount1);
         DataDB_.WriteNumber(i, 15, member[i-1].TCount2);
         DataDB_.WriteNumber(i, 16, member[i-1].TCount3);
      end;
      DataDB.WriteToFile(Directory + '\Data.xlsx', sfOOXML, true);
      DataDB.Free;
   end else begin
      DataDB := TsWorkBook.Create;
      DataDB.ReadFromFile(directory + '\data.xlsx');
      DataDB_ := DataDB.getfirstworksheet;
      for i := 1 to form_main.totalno do
      begin
         member[i-1].ID := DataDB_.ReadAsUTF8Text(i, 0);
         member[i-1].Name := DataDB_.ReadAsUTF8Text(i, 1);
         member[i-1].DCount1 := trunc(DataDB_.ReadAsNumber(i, 2));
         member[i-1].DCount2 := trunc(DataDB_.ReadAsNumber(i, 3));
         member[i-1].DCount3 := trunc(DataDB_.ReadAsNumber(i, 4));
         member[i-1].ACount1 := trunc(DataDB_.ReadAsNumber(i, 5));
         member[i-1].ACount2 := trunc(DataDB_.ReadAsNumber(i, 6));
         member[i-1].ACount3 := trunc(DataDB_.ReadAsNumber(i, 7));
         member[i-1].SCount1 := trunc(DataDB_.ReadAsNumber(i, 8));
         member[i-1].SCount2 := trunc(DataDB_.ReadAsNumber(i, 9));
         member[i-1].SCount3 := trunc(DataDB_.ReadAsNumber(i, 10));
         member[i-1].LCount1 := trunc(DataDB_.ReadAsNumber(i, 11));
         member[i-1].LCount2 := trunc(DataDB_.ReadAsNumber(i, 12));
         member[i-1].LCount3 := trunc(DataDB_.ReadAsNumber(i, 13));
         member[i-1].TCount1 := trunc(DataDB_.ReadAsNumber(i, 14));
         member[i-1].TCount2 := trunc(DataDB_.ReadAsNumber(i, 15));
         member[i-1].TCount3 := trunc(DataDB_.ReadAsNumber(i, 16));
      end;

      DataDB.Free;

   end;
   //End: MemberData

   if not fileexists(directory + '\log\' + datetostr(date) + '.xlsx') then
      genabs
   else initStatus;
end;
procedure TForm_main.PgCtrlChange(Sender: TObject);
var i : integer;
begin
  if PgCtrl.ActivePage.name = 'Tab_Admin' then
  begin
     if lb_debug.Caption = 'OFF' then
        lb_debug.Font.Color := clRed
     else lb_debug.font.color := clGreen;
     cbox_id.items.Clear;
     for i := 0 to totalno - 1 do
     begin
        cbox_id.Items.AddStrings(member[i].Name);
     end;
     cbox_slot.items.clear;
     cbox_slot.items.AddText('Slot 1');
     cbox_slot.items.AddText('Slot 2');
     cbox_slot.items.AddText('Slot 3');
  end;

  if PgCtrl.ActivePage.name = 'Tab_checkin' then
     logscr.lines := logscradmin.lines;

  if PgCtrl.ActivePage.name = 'Tab_Settings' then
  begin
      chk_adminstartup.checked := config.adminstartup;
      cbox_cifreq.ItemIndex := config.cifreq - 1;
      cbox_time1starthr.ItemIndex := hourof(config.citime1start);
      cbox_time2starthr.ItemIndex := hourof(config.citime2start);
      cbox_time3starthr.ItemIndex := hourof(config.citime3start);
      cbox_time1startmin.ItemIndex := minuteof(config.citime1start);
      cbox_time2startmin.ItemIndex := minuteof(config.citime2start);
      cbox_time3startmin.ItemIndex := minuteof(config.citime3start);
      cbox_time1latehr.ItemIndex := hourof(config.citime1late);
      cbox_time2latehr.ItemIndex := hourof(config.citime2late);
      cbox_time3latehr.ItemIndex := hourof(config.citime3late);
      cbox_time1latemin.ItemIndex := minuteof(config.citime1late);
      cbox_time2latemin.ItemIndex := minuteof(config.citime2late);
      cbox_time3latemin.ItemIndex := minuteof(config.citime3late);
      cbox_time1endhr.ItemIndex := hourof(config.citime1end);
      cbox_time2endhr.ItemIndex := hourof(config.citime2end);
      cbox_time3endhr.ItemIndex := hourof(config.citime3end);
      cbox_time1endmin.ItemIndex := minuteof(config.citime1end);
      cbox_time2endmin.ItemIndex := minuteof(config.citime2end);
      cbox_time3endmin.ItemIndex := minuteof(config.citime3end);

      groupbox4.Enabled := true;
      if config.cifreq = 1 then
      begin
         groupbox5.Enabled := false;
         groupbox6.Enabled := false;
      end
      else
      if config.cifreq = 2 then
      begin
         groupbox5.Enabled := true;
         groupbox6.Enabled := false;
      end
      else
      if config.cifreq > 2 then
      begin
         groupbox5.Enabled := true;
         groupbox6.Enabled := true;
      end;

  end;
end;

procedure TForm_main.sSpreadsheetInspector1Click(Sender: TObject);
begin

end;

procedure TForm_main.tb_inputKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
     btn_checkin.Click;
end;


procedure TForm_main.logscrChange(Sender: TObject);
begin
  SendMessage(logscr.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  logscradmin.Text := logscr.text;
end;

procedure TForm_main.logscradminChange(Sender: TObject);
begin
  SendMessage(logscradmin.Handle, EM_LINESCROLL, 0,logscradmin.Lines.Count);
end;

procedure TForm_main.item_clrlogClick(Sender: TObject);
begin
  logscr.lines.Clear;
  logscr.lines.append('Welcome to the Attendance Program');
end;

procedure TForm_main.item_devlogClick(Sender: TObject);
begin
  PgCtrl.ActivePageIndex := 0;
  logscr.lines.append('Development Log Start');
  logscr.lines.append('- Overnight Job Checkin Not Supported.');
  logscr.lines.append('- Different On Duty Time each day Not Supported.');
  logscr.lines.append('1. Allow user to relocate data directory');
  logscr.lines.append('Development Log End');
end;

procedure TForm_main.item_editmemberClick(Sender: TObject);
begin
  if not (ToHash(passwordbox('Authenication', 'Enter administrator password to edit member list:')) = config.adminpw) then
     begin
        logscr.lines.append('Wrong Password. Please Try Again.');
     end
     else
     begin
        logscr.lines.append('Member List Access Granted.');
        form_memedit.showmodal;
     end;
end;

procedure TForm_main.item_reloadClick(Sender: TObject);
begin
  form_main.Activate;
  logscr.lines.append('Form Reloaded.');
end;

procedure TForm_main.item_saveClick(Sender: TObject);
begin
   if SaveDialog1.execute then
      logscr.Lines.SavetoFile(SaveDialog1.filename);

end;



procedure TForm_main.btn_applysettingsClick(Sender: TObject);
var
  err : boolean;
  time1s, time2s, time3s, time1l, time2l, time3l, time1e, time2e, time3e : TDateTime;
begin
   err := false;
   if not (ToHash(passwordbox('Authenication', 'Enter administrator password to save settings:')) = config.adminpw) then
      begin
         Application.MessageBox('Wrong password.' + sLineBreak + 'Settings were not daved.', 'Error', MB_iconerror);
         exit;
      end
      else
      begin
         time1s := strtotime(inttostr(cbox_time1starthr.ItemIndex) + ':' + inttostr(cbox_time1startmin.ItemIndex));
         time2s := strtotime(inttostr(cbox_time2starthr.ItemIndex) + ':' + inttostr(cbox_time2startmin.ItemIndex));
         time3s := strtotime(inttostr(cbox_time3starthr.ItemIndex) + ':' + inttostr(cbox_time3startmin.ItemIndex));
         time1l := strtotime(inttostr(cbox_time1latehr.ItemIndex) + ':' + inttostr(cbox_time1latemin.ItemIndex));
         time2l := strtotime(inttostr(cbox_time2latehr.ItemIndex) + ':' + inttostr(cbox_time2latemin.ItemIndex));
         time3l := strtotime(inttostr(cbox_time3latehr.ItemIndex) + ':' + inttostr(cbox_time3latemin.ItemIndex));
         time1e := strtotime(inttostr(cbox_time1endhr.ItemIndex) + ':' + inttostr(cbox_time1endmin.ItemIndex));
         time2e := strtotime(inttostr(cbox_time2endhr.ItemIndex) + ':' + inttostr(cbox_time2endmin.ItemIndex));
         time3e := strtotime(inttostr(cbox_time3endhr.ItemIndex) + ':' + inttostr(cbox_time3endmin.ItemIndex));

         if cbox_cifreq.itemindex < 2 then
         begin
            cbox_time3starthr.ItemIndex := cbox_time2starthr.ItemIndex;
            cbox_time3startmin.ItemIndex := cbox_time2startmin.ItemIndex ;
            cbox_time3latehr.ItemIndex := cbox_time2latehr.ItemIndex;
            cbox_time3latemin.ItemIndex := cbox_time2latemin.ItemIndex;
            cbox_time3endhr.ItemIndex := cbox_time2endhr.ItemIndex ;
            cbox_time3endmin.ItemIndex := cbox_time2endmin.ItemIndex;
         end;
         if cbox_cifreq.itemindex < 1 then
         begin
            cbox_time2starthr.ItemIndex := cbox_time1starthr.ItemIndex;
            cbox_time2startmin.ItemIndex := cbox_time1startmin.ItemIndex;
            cbox_time2latehr.ItemIndex :=  cbox_time1latehr.ItemIndex ;
            cbox_time2latemin.ItemIndex := cbox_time1latemin.ItemIndex;
            cbox_time2endhr.ItemIndex := cbox_time1endhr.ItemIndex ;
            cbox_time2endmin.ItemIndex := cbox_time1endmin.ItemIndex;
            cbox_time3starthr.ItemIndex := cbox_time2starthr.ItemIndex;
            cbox_time3startmin.ItemIndex := cbox_time2startmin.ItemIndex ;
            cbox_time3latehr.ItemIndex := cbox_time2latehr.ItemIndex;
            cbox_time3latemin.ItemIndex := cbox_time2latemin.ItemIndex;
            cbox_time3endhr.ItemIndex := cbox_time2endhr.ItemIndex ;
            cbox_time3endmin.ItemIndex := cbox_time2endmin.ItemIndex;
         end;

         err := (time1s > time1l) or (time1l > time1e);
         if cbox_cifreq.itemindex > 0 then
            err := err or (time1e > time2s) or (time2s > time2l) or (time2l > time2e);
         if cbox_cifreq.itemindex > 1 then
            err := err or (time2e > time3s) or (time3s > time3l) or (time3l > time3e);

         {if (time1s > time1l) or (time1l > time1e) or (time1e > time2s) or (time2s > time2l) or (time2l > time2e) or (time2e > time3s) or (time3s > time3l) or (time3l > time3e) then
            err := true;}

         if err then
            Application.MessageBox('Wrong time settings' + sLineBreak + 'Settings were not saved.', 'Error', MB_iconerror)
         else
         begin

            config.adminstartup := chk_adminstartup.checked;
            config.cifreq := cbox_cifreq.ItemIndex + 1;
            config.citime1start := strtotime(inttostr(cbox_time1starthr.ItemIndex) + ':' + inttostr(cbox_time1startmin.ItemIndex));
            config.citime2start := strtotime(inttostr(cbox_time2starthr.ItemIndex) + ':' + inttostr(cbox_time2startmin.ItemIndex));
            config.citime3start := strtotime(inttostr(cbox_time3starthr.ItemIndex) + ':' + inttostr(cbox_time3startmin.ItemIndex));
            config.citime1late := strtotime(inttostr(cbox_time1latehr.ItemIndex) + ':' + inttostr(cbox_time1latemin.ItemIndex));
            config.citime2late := strtotime(inttostr(cbox_time2latehr.ItemIndex) + ':' + inttostr(cbox_time2latemin.ItemIndex));
            config.citime3late := strtotime(inttostr(cbox_time3latehr.ItemIndex) + ':' + inttostr(cbox_time3latemin.ItemIndex));
            config.citime1end := strtotime(inttostr(cbox_time1endhr.ItemIndex) + ':' + inttostr(cbox_time1endmin.ItemIndex));
            config.citime2end := strtotime(inttostr(cbox_time2endhr.ItemIndex) + ':' + inttostr(cbox_time2endmin.ItemIndex));
            config.citime3end := strtotime(inttostr(cbox_time3endhr.ItemIndex) + ':' + inttostr(cbox_time3endmin.ItemIndex));


            configini := TINIFile.Create(directory + '\config.ini');
            configini.WriteBool('Admin', 'StartUp',  config.adminstartup);
            configini.WriteString('Admin', 'PW', config.adminPW);
            configini.WriteInteger('Checkin', 'Freq', config.cifreq);
            configini.WriteString('Checkin', 'Time1_Start', timetostr(config.citime1start));
            configini.WriteString('Checkin', 'Time1_Late', timetostr(config.citime1Late));
            configini.WriteString('Checkin', 'Time1_End', timetostr(config.citime1End));
            configini.WriteString('Checkin', 'Time2_Start', timetostr(config.citime2start));
            configini.WriteString('Checkin', 'Time2_Late', timetostr(config.citime2Late));
            configini.WriteString('Checkin', 'Time2_End', timetostr(config.citime2End));
            configini.WriteString('Checkin', 'Time3_Start', timetostr(config.citime3start));
            configini.WriteString('Checkin', 'Time3_Late', timetostr(config.citime3Late));
            configini.WriteString('Checkin', 'Time3_End', timetostr(config.citime3End));
            configini.destroy;

   Application.MessageBox('Settings saved.', 'Done',MB_ICONINFORMATION);
   logscr.lines.append('Settings Saved.');
         end;
   end;
end;

procedure TForm_main.btn_chgpwClick(Sender: TObject);
var str1 : string;
begin
   if not (ToHash(passwordbox('Authenication', 'Enter administrator password to change password:')) = config.adminpw) then
     begin
        Application.MessageBox('Wrong password.', 'Error', MB_iconerror);
        logscr.lines.append('Wrong password. Please try again.');
        exit;
     end
     else
     begin
        str1 := passwordbox('Authenication', 'Enter new password:');
        if str1 = '' then
        begin
           Application.MessageBox('Error: Blank Password Not Allowed', 'Error',MB_ICONWARNING);
           exit;
        end;
        if passwordbox('Authenication', 'Repeat new password:') = str1 then
        begin
           Application.MessageBox('New password saved.', 'Done', MB_ICONINFORMATION);
           config.adminpw := ToHash(str1);
           configini := TINIFile.Create(directory + '\config.ini');
           configini.WriteString('Admin', 'PW', config.adminPW);
           configini.destroy;
           logscr.lines.append('New Password is in Effect.');
        end
        else
        begin
           logscr.lines.append('Password is not Changed.');
           Application.MessageBox('Password doesn''t match.', 'Error', MB_iconerror);
        end;
     end;
end;


procedure TForm_main.btn_debugmodeClick(Sender: TObject);
begin
   if not (ToHash(passwordbox('Authenication', 'Enter administrator password:')) = config.adminpw) then
   begin
      logscr.lines.append('Wrong Password. Please Try Again.');
      exit;
   end
   else logscr.lines.append('Debug Mode Function Access Granted.');
   if debugmode then
   begin
      debugmode := false;
      btn_debugmode.caption := 'Toggle On';
      lb_debug.Font.Color := clRed;
      lb_debug.caption := 'OFF';
   end
   else
   begin
      debugmode := true;
      btn_debugmode.caption := 'Toggle Off';
      lb_debug.Font.Color := clGreen;
      lb_debug.caption := 'ON';
   end;
end;

procedure TForm_main.btn_defaultsettingsClick(Sender: TObject);
begin
   if not (ToHash(passwordbox('Authenication', 'Enter administrator password to reset settings:')) = config.adminpw) then
     begin
        Application.MessageBox('Wrong password. Settings were not reset.', 'Error', MB_iconerror);
        exit;
     end
     else
     begin

         config.adminstartup := False;
         config.cifreq := 3;
         config.citime1start := strtotime('07:00');
         config.citime1late := strtotime('07:35');
         config.citime1end := strtotime('08:00');
         config.citime2start := strtotime('12:45');
         config.citime2late := strtotime('13:30');
         config.citime2end := strtotime('14:00');
         config.citime3start := strtotime('15:20');
         config.citime3late := strtotime('15:40');
         config.citime3end := strtotime('17:00');
         configini := TINIFile.Create(directory + '\config.ini');
         configini.WriteBool('Admin', 'StartUp',  config.adminstartup);
         configini.WriteInteger('Checkin', 'Freq', config.cifreq);
         configini.WriteString('Checkin', 'Time1_Start', timetostr(config.citime1start));
         configini.WriteString('Checkin', 'Time1_Late', timetostr(config.citime1Late));
         configini.WriteString('Checkin', 'Time1_End', timetostr(config.citime1End));
         configini.WriteString('Checkin', 'Time2_Start', timetostr(config.citime2start));
         configini.WriteString('Checkin', 'Time2_Late', timetostr(config.citime2Late));
         configini.WriteString('Checkin', 'Time2_End', timetostr(config.citime2End));
         configini.WriteString('Checkin', 'Time3_Start', timetostr(config.citime3start));
         configini.WriteString('Checkin', 'Time3_Late', timetostr(config.citime3Late));
         configini.WriteString('Checkin', 'Time3_End', timetostr(config.citime3End));
         configini.destroy;
         GroupBox5.Enabled := True;
         GroupBox6.Enabled := True;
         chk_adminstartup.checked := config.adminstartup;
         cbox_cifreq.itemindex := config.cifreq - 1;
         cbox_time1starthr.ItemIndex := hourof(config.citime1start);
         cbox_time2starthr.ItemIndex := hourof(config.citime2start);
         cbox_time3starthr.ItemIndex := hourof(config.citime3start);
         cbox_time1startmin.ItemIndex := minuteof(config.citime1start);
         cbox_time2startmin.ItemIndex := minuteof(config.citime2start);
         cbox_time3startmin.ItemIndex := minuteof(config.citime3start);
         cbox_time1latehr.ItemIndex := hourof(config.citime1late);
         cbox_time2latehr.ItemIndex := hourof(config.citime2late);
         cbox_time3latehr.ItemIndex := hourof(config.citime3late);
         cbox_time1latemin.ItemIndex := minuteof(config.citime1late);
         cbox_time2latemin.ItemIndex := minuteof(config.citime2late);
         cbox_time3latemin.ItemIndex := minuteof(config.citime3late);
         cbox_time1endhr.ItemIndex := hourof(config.citime1end);
         cbox_time2endhr.ItemIndex := hourof(config.citime2end);
         cbox_time3endhr.ItemIndex := hourof(config.citime3end);
         cbox_time1endmin.ItemIndex := minuteof(config.citime1end);
         cbox_time2endmin.ItemIndex := minuteof(config.citime2end);
         cbox_time3endmin.ItemIndex := minuteof(config.citime3end);

     end;
   Application.MessageBox('Restored default settings, Admin password unchanged.', 'Done',MB_ICONINFORMATION);
   logscr.lines.add('Restored Default Settings, Admin Password Unchanged.');
end;

procedure TForm_main.btn_checkinClick(Sender: TObject);
var
  id : string;
  i : integer;
  found : boolean;
  prev, succ : array[0..1] of string;
  bool1, bool2, bool3 : boolean;
  f : text;
begin
   if date <> date_ then form_main.Activate;
   id := tb_input.Text;
   tb_input.Text := '';

   //Search RECORD (member[i])
   i := 0;
   found := false;
   repeat
      if member[i].ID = id then
         found := true
      else inc(i);
   until (i > form_main.totalno - 1) or (found);
   if i > form_main.totalno - 1 then
     begin
        logscr.lines.append(id + ' not found.');
        exit;
     end;
   if not (Application.MessageBox(PChar('You are about to check in as ' + member[i].Name +'.'+ sLineBreak + 'Confirm?'), 'Confirmation',MB_ICONINFORMATION + MB_YESNO) = IDYES) then
     begin
        logscr.lines.append('Checkin Command Cancelled.');
        exit;
     end;


   //Select DOW
   case dayofweek(date) of
   1 : begin
          bool1 := member[i].Sun1;
          bool2 := member[i].Sun2;
          bool3 := member[i].Sun3;
       end;
   2 : begin
          bool1 := member[i].Mon1;
          bool2 := member[i].Mon2;
          bool3 := member[i].Mon3;
       end;
   3 : begin
          bool1 := member[i].Tue1;
          bool2 := member[i].Tue2;
          bool3 := member[i].Tue3;
       end;
   4 : begin
          bool1 := member[i].Wed1;
          bool2 := member[i].Wed2;
          bool3 := member[i].Wed3;
       end;
   5 : begin
          bool1 := member[i].Thu1;
          bool2 := member[i].Thu2;
          bool3 := member[i].Thu3;
       end;
   6 : begin
          bool1 := member[i].Fri1;
          bool2 := member[i].Fri2;
          bool3 := member[i].Fri3;
       end;
   7 : begin
          bool1 := member[i].Sat1;
          bool2 := member[i].Sat2;
          bool3 := member[i].Sat3;
       end;
   end;

   //Check Time, if Checked in yet, and Set Status
   if time < config.citime1start then
      logscr.lines.append('ERROR: It is NOT the Time to be On Duty.')
   else if time < config.citime1late then
   begin
      //time 1 ontime
      if (member[i].Status1 <> 'absent') and (member[i].Status1 <> 'ntdabs') then
      begin
         logscr.lines.append('ERROR: You have already Checked In.');
         exit;
      end;
      if (not bool1) and (member[i].SCount1 = 0) then
      begin
         member[i].status1 := 'present';
         inc(member[i].DCount1);
         if debugmode then logscr.lines.append(member[i].Name + ' DCount1 + 1');
      end
      else if bool1 or ((not bool1) and (member[i].SCount1 > 0)) then
      begin
         member[i].status1 := 'onduty';
         if (not bool1) and (member[i].Scount1 > 0) then
         begin
            dec(member[i].Scount1);
            if debugmode then logscr.lines.append(member[i].Name + ' SCount1 - 1');
            if member[i].SCount1 < 0 then
            begin
               logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount1.');
               assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount1.log');
               rewrite(f);
               closeFile(f);
            end;
         end;
         dec(member[i].ACount1);
         if debugmode then logscr.lines.append(member[i].Name + ' ACount1 - 1');
         if member[i].ACount1 < 0 then
         begin
            logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative ACount1.');
            assignFile(f, directory + '\log\dev\' + inttostr(i) + '_ACount1.log');
            rewrite(f);
            closeFile(f);
         end;
         inc(member[i].DCount1);
         if debugmode then logscr.lines.append(member[i].Name + ' DCount1 - 1');
      end;
      logscr.lines.append(member[i].Name + ' checked in.');
   end
   else if time < config.citime1end then
   begin
      //time 1 late
      if (member[i].Status1 <> 'absent') and (member[i].Status1 <> 'ntdabs') then
      begin
         logscr.lines.append('ERROR: You have already Checked In.');
         exit;
      end;
      if (not bool1) and (member[i].SCount1 = 0) then
      begin
         member[i].status1 := 'present';
         inc(member[i].DCount1);
         if debugmode then logscr.lines.append(member[i].Name + ' DCount1 + 1');
      end
      else if (bool1) or ((not bool1) and (member[i].SCount1 > 0)) then
      begin
         member[i].status1 := 'late';
         inc(member[i].LCount1);
         if debugmode then logscr.lines.append(member[i].Name + ' LCount1 + 1');
         if ((not bool1) and (member[i].SCount1 > 0)) then
         begin
            dec(member[i].SCount1);
            if debugmode then logscr.lines.append(member[i].Name + ' SCount1 - 1');
            if member[i].SCount1 < 0 then
            begin
               logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount1.');
               assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount1.log');
               rewrite(f);
               closeFile(f);
            end;         end;
         dec(member[i].ACount1);
         if debugmode then logscr.lines.append(member[i].Name + ' ACount1 - 1');
         if member[i].ACount1 < 0 then
         begin
               logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative ACount1.');
               assignFile(f, directory + '\log\dev\' + inttostr(i) + '_ACount1.log');
               rewrite(f);
               closeFile(f);
            end;         inc(member[i].DCount1);
         if debugmode then logscr.lines.append(member[i].Name + ' DCount1 + 1');
      end;
      logscr.lines.append(member[i].Name + ' checked in.');
   end
   else if time < config.citime2start then
      logscr.lines.append('ERROR: It is NOT the Time to be On Duty.')
   else if time < config.citime2late then
   begin
         //time 2 ontime
         if (member[i].Status2 <> 'absent') and (member[i].Status2 <> 'ntdabs') then
         begin
            logscr.lines.append('ERROR: You have already Checked In.');
            exit;
         end;
         if (not bool2) and (member[i].SCount2 = 0) then
         begin
            member[i].status2 := 'present';
            inc(member[i].DCount2);
            if debugmode then logscr.lines.append(member[i].Name + ' DCount2 + 1');
         end
         else if bool2 or ((not bool2) and (member[i].SCount2 > 0)) then
         begin
            member[i].status2 := 'onduty';
            if (not bool2) and (member[i].Scount2 > 0) then
            begin
               dec(member[i].Scount2);
               if debugmode then logscr.lines.append(member[i].Name + ' SCount2 - 1');
               if member[i].SCount2 < 0 then
               begin
                  logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount2.');
                  assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount2.log');
                  rewrite(f);
                  closeFile(f);
               end;
            end;
            dec(member[i].ACount2);
            if member[i].ACount2 < 0 then
            begin
               logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative ACount2.');
               assignFile(f, directory + '\log\dev\' + inttostr(i) + '_ACount2.log');
               rewrite(f);
               closeFile(f);
            end;
            if debugmode then logscr.lines.append(member[i].Name + ' ACount2 - 1');
            inc(member[i].DCount2);
            if debugmode then logscr.lines.append(member[i].Name + ' DCount2 + 1');
         end;
         logscr.lines.append(member[i].Name + ' checked in.');
   end
   else if time < config.citime2end then
   begin
      //time 2 late
      if (member[i].Status2 <> 'absent') and (member[i].Status2 <> 'ntdabs') then
      begin
         logscr.lines.append('ERROR: You have already Checked In.');
         exit;
      end;
      if (not bool2) and (member[i].SCount2 = 0) then
      begin
         member[i].status2 := 'present';
         inc(member[i].DCount2);
         if debugmode then logscr.lines.append(member[i].Name + ' DCount2 + 1');
      end
      else if (bool2) or ((not bool2) and (member[i].SCount2 > 0)) then
      begin
         member[i].status2 := 'late';
         inc(member[i].LCount2);
         if debugmode then logscr.lines.append(member[i].Name + ' LCount2 + 1');
         if ((not bool2) and (member[i].SCount2 > 0)) then
         begin
            dec(member[i].SCount2);
            if debugmode then logscr.lines.append(member[i].Name + ' SCount2 - 1');
            if member[i].SCount2 < 0 then
            begin
               logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount2.');
               assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount2.log');
               rewrite(f);
               closeFile(f);
            end;
         end;
         dec(member[i].ACount2);
         if debugmode then logscr.lines.append(member[i].Name + ' ACount2 - 1');
         if member[i].ACount2 < 0 then
         begin
            logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative ACount2.');
            assignFile(f, directory + '\log\dev\' + inttostr(i) + '_ACount2.log');
            rewrite(f);
            closeFile(f);
         end;
         inc(member[i].DCount2);
         if debugmode then logscr.lines.append(member[i].Name + ' DCount2 + 1');
      end;
      logscr.lines.append(member[i].Name + ' checked in.');
   end
   else if time < config.citime3start then
      logscr.Lines.append('ERROR: It is NOT the Time to be On Duty.')
   else if time < config.citime3late then
      begin
         //time 3 ontime
         if (member[i].Status3 <> 'absent') and (member[i].Status3 <> 'ntdabs') then
         begin
            logscr.lines.append('ERROR: You have already Checked In.');
            exit;
         end;
         if (not bool3) and (member[i].SCount3 = 0) then
         begin
            member[i].status3 := 'present';
            inc(member[i].DCount3);
            if debugmode then logscr.lines.append(member[i].Name + ' DCount3 + 1');
         end
         else if bool3 or ((not bool3) and (member[i].SCount3 > 0)) then
         begin
            member[i].status3 := 'onduty';
            if (not bool3) and (member[i].Scount3 > 0) then
            begin
               dec(member[i].Scount3);
               if debugmode then logscr.lines.append(member[i].Name + ' SCount3 - 1');
               if member[i].SCount3 < 0 then
               begin
                  logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount3.');
                  assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount3.log');
                  rewrite(f);
                  closeFile(f);
               end;
            end;
            dec(member[i].ACount3);
            if debugmode then logscr.lines.append(member[i].Name + ' ACount3 - 1');
            if member[i].ACount3 < 0 then
            begin
                  logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative ACount3.');
                  assignFile(f, directory + '\log\dev\' + inttostr(i) + '_ACount3.log');
                  rewrite(f);
                  closeFile(f);
            end;
            inc(member[i].DCount3);
            if debugmode then logscr.lines.append(member[i].Name + ' DCount3 + 1');
         end;
         logscr.lines.append(member[i].Name + ' checked in.');
   end
   else if time < config.citime3end then
   begin
      //time 3 late
      if (member[i].Status3 <> 'absent') and (member[i].Status3 <> 'ntdabs') then
      begin
         logscr.lines.append('ERROR: You have already Checked In.');
         exit;
      end;
      if (not bool3) and (member[i].SCount3 = 0) then
      begin
         member[i].status3 := 'present';
         inc(member[i].DCount3);
         if debugmode then logscr.lines.append(member[i].Name + ' DCount3 + 1');
      end
      else if (bool3) or ((not bool3) and (member[i].SCount3 > 0)) then
      begin
         member[i].status3 := 'late';
         inc(member[i].LCount3);
         if debugmode then logscr.lines.append(member[i].Name + ' LCount3 + 1');
         if ((not bool3) and (member[i].SCount3 > 0)) then
         begin
            dec(member[i].SCount3);
            if debugmode then logscr.lines.append(member[i].Name + ' SCount3 - 1');
            if member[i].SCount3 < 0 then
            begin
               logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative SCount3.');
               assignFile(f, directory + '\log\dev\' + inttostr(i) + '_SCount3.log');
               rewrite(f);
               closeFile(f);
            end;
         end;
         dec(member[i].ACount3);
         if debugmode then logscr.lines.append(member[i].Name + ' ACount3 - 1');
         if member[i].ACount3 < 0 then
         begin
            logscr.lines.append('BUG DETECTED: ' + member[i].Name + ' has negative ACount3.');
            assignFile(f, directory + '\log\dev\' + inttostr(i) + '_ACount3.log');
            rewrite(f);
            closeFile(f);
         end;
         inc(member[i].DCount3);
         if debugmode then logscr.lines.append(member[i].Name + ' DCount3 + 1');
      end;
      logscr.lines.append(member[i].Name + ' checked in.');
   end
   else logscr.lines.append('ERROR: It is NOT the Time to be On Duty.');

   SaveRecord
end;

procedure TForm_main.btn_shiftClick(Sender: TObject);
var bool1, bool2, bool3 : boolean; i : integer;
begin
   if date <> date_ then form_main.Activate;
   if (cbox_id.ItemIndex < 0) or (cbox_slot.itemindex < 0) then
   begin
      logscr.lines.append('Error: Please Select the Items');
      exit;
   end;
   if not (ToHash(passwordbox('Authenication', 'Enter administrator password:')) = config.adminpw) then
   begin
      logscr.lines.append('Wrong Password. Please Try Again.');
      exit;
   end
   else logscr.lines.append('Shift Function Access Granted.');
   i := cbox_id.itemindex;
   case dayofweek(date) of
   1 : begin
          bool1 := member[i].Sun1;
          bool2 := member[i].Sun2;
          bool3 := member[i].Sun3;
       end;
   2 : begin
          bool1 := member[i].Mon1;
          bool2 := member[i].Mon2;
          bool3 := member[i].Mon3;
       end;
   3 : begin
          bool1 := member[i].Tue1;
          bool2 := member[i].Tue2;
          bool3 := member[i].Tue3;
       end;
   4 : begin
          bool1 := member[i].Wed1;
          bool2 := member[i].Wed2;
          bool3 := member[i].Wed3;
       end;
   5 : begin
          bool1 := member[i].Thu1;
          bool2 := member[i].Thu2;
          bool3 := member[i].Thu3;
       end;
   6 : begin
          bool1 := member[i].Fri1;
          bool2 := member[i].Fri2;
          bool3 := member[i].Fri3;
       end;
   7 : begin
          bool1 := member[i].Sat1;
          bool2 := member[i].Sat2;
          bool3 := member[i].Sat3;
       end;
   end;
   if cbox_slot.itemindex = 0 then    //Slot 1
   begin
      if Application.MessageBox(PChar('You are about to mark ' + member[i].Name + '''s slot 1 record as Noted Abs.' + sLineBreak + 'Confirm?'), 'Confirmation',MB_ICONINFORMATION + MB_YESNO) = IDYES then
      begin
         if (bool1) and (member[i].Status1 = 'absent') then
            member[i].Status1 := 'ntdabs';
         inc(member[i].SCount1);
         if debugmode then logscr.lines.append(member[i].name + ' SCount1 + 1');
         logscr.lines.append(member[i].name + '''s Slot 1 Duty Shifted.');
      end
      else logscr.lines.append('Shift Duty Command Cancelled.');
   end
   else if cbox_slot.itemindex = 1 then  //Slot 2
   begin
      if Application.MessageBox(PChar('You are about to mark ' + form_main.member[i].name + '''s slot 2 record as Noted Abs.' + sLineBreak + 'Confirm?'), 'Confirmation',MB_ICONINFORMATION + MB_YESNO) = IDYES then
      begin
         if (bool2) and (member[i].Status2 = 'absent') then
            member[i].Status2 := 'ntdabs';
         inc(member[i].SCount2);
         if debugmode then logscr.lines.append(member[i].name + ' SCount2 + 1');
         logscr.lines.append(member[i].name + '''s Slot 2 Duty Shifted.');
      end
      else logscr.lines.append('Shift Duty Command Cancelled.');
   end
   else if cbox_slot.itemindex = 2 then  //Slot 3
   begin
      if Application.MessageBox(PChar('You are about to mark ' + form_main.member[i].name + '''s slot 3 record as Noted Abs.' + sLineBreak + 'Confirm?'), 'Confirmation',MB_ICONINFORMATION + MB_YESNO) = IDYES then
      begin
         if (bool3) and (member[i].Status3 = 'absent') then
            member[i].Status3 := 'ntdabs';
         inc(member[i].SCount3);
         if debugmode then logscr.lines.append(member[i].name + ' SCount3 + 1');
         logscr.lines.append(member[i].name + '''s Slot 3 Duty Shifted.');
      end
      else logscr.lines.append('Shift Duty Command Cancelled.');
   end;
   form_main.saverecord;
end;

begin
end.
