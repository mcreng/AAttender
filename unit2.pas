unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ValEdit, PairSplitter, CheckLst, ExtCtrls, Menus, inifiles, ShellApi, LCLType;

  { Tform_memedit }
type
  Tform_memedit = class(TForm)
    btn_trigger: TButton;
    btn_save: TButton;
    btn_prev: TButton;
    btn_succ: TButton;
    lsbox: TListBox;
    MainMenu1: TMainMenu;
    item_add: TMenuItem;
    item_del: TMenuItem;
    btn_openini: TMenuItem;
    Panel1: TPanel;
    tbox_id: TEdit;
    tbox_name: TEdit;
    gbox_pinfo: TGroupBox;
    gbox_dinfo: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    list_disable: TListBox;
    list_enable: TListBox;
    procedure btn_openiniClick(Sender: TObject);
    procedure btn_prevClick(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure btn_succClick(Sender: TObject);
    procedure btn_triggerClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure item_delClick(Sender: TObject);
    procedure list_disableSelectionChange(Sender: TObject; User: boolean);
    procedure list_enableSelectionChange(Sender: TObject; User: boolean);
    procedure item_addClick(Sender: TObject);
    procedure lsboxClick(Sender: TObject);
    procedure lsboxDblClick(Sender: TObject);
    procedure showcontent(no : integer);
    procedure tbox_idKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbox_nameChange(Sender: TObject);
    procedure tbox_nameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
  private
    { private declarations }
  public
    { public declarations }
  end;
const
  Directory = 'C:\AAttender\8544-ef81-85e3-9be4-1a81-4317-1ae3-0eab';
var
  form_memedit: Tform_memedit;
  current : integer;
  configini : TINIFile;

implementation
uses unit1;
{$R *.lfm}

{ Tform_memedit }

procedure Tform_memedit.showcontent(no : integer);
begin
   tbox_id.text := form_main.member[no].id;
   tbox_name.text := form_main.member[no].name;
   if form_main.member[no].mon1 then
      list_enable.items.append('Mon1')
   else list_disable.items.append('Mon1');
   if form_main.member[no].mon2 then
      list_enable.items.append('Mon2')
   else list_disable.items.append('Mon2');
   if form_main.member[no].mon3 then
      list_enable.items.append('Mon3')
   else list_disable.items.append('Mon3');
   if form_main.member[no].tue1 then
      list_enable.items.append('Tue1')
   else list_disable.items.append('Tue1');
   if form_main.member[no].Tue2 then
      list_enable.items.append('Tue2')
   else list_disable.items.append('Tue2');
   if form_main.member[no].Tue3 then
      list_enable.items.append('Tue3')
   else list_disable.items.append('Tue3');
   if form_main.member[no].Wed1 then
      list_enable.items.append('Wed1')
   else list_disable.items.append('Wed1');
   if form_main.member[no].Wed2 then
      list_enable.items.append('Wed2')
   else list_disable.items.append('Wed2');
   if form_main.member[no].Wed3 then
      list_enable.items.append('Wed3')
   else list_disable.items.append('Wed3');
   if form_main.member[no].Thu1 then
      list_enable.items.append('Thu1')
   else list_disable.items.append('Thu1');
   if form_main.member[no].Thu2 then
      list_enable.items.append('Thu2')
   else list_disable.items.append('Thu2');
   if form_main.member[no].Thu3 then
      list_enable.items.append('Thu3')
   else list_disable.items.append('Thu3');
   if form_main.member[no].Fri1 then
      list_enable.items.append('Fri1')
   else list_disable.items.append('Fri1');
   if form_main.member[no].Fri2 then
      list_enable.items.append('Fri2')
   else list_disable.items.append('Fri2');
   if form_main.member[no].Fri3 then
      list_enable.items.append('Fri3')
   else list_disable.items.append('Fri3');
   if form_main.member[no].Sat1 then
      list_enable.items.append('Sat1')
   else list_disable.items.append('Sat1');
   if form_main.member[no].Sat2 then
      list_enable.items.append('Sat2')
   else list_disable.items.append('Sat2');
   if form_main.member[no].Sat3 then
      list_enable.items.append('Sat3')
   else list_disable.items.append('Sat3');
   if form_main.member[no].Sun1 then
      list_enable.items.append('Sun1')
   else list_disable.items.append('Sun1');
   if form_main.member[no].Sun2 then
      list_enable.items.append('Sun2')
   else list_disable.items.append('Sun2');
   if form_main.member[no].Sun3 then
      list_enable.items.append('Sun3')
   else list_disable.items.append('Sun3');
end;



procedure Tform_memedit.tbox_idKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  var
 i : integer;
begin
       configini := TINIFile.Create(directory + '\members.ini');
       lsbox.Clear;
       form_main.member[current].ID := tbox_id.text;
    for i := 0 to form_main.totalno - 1 do
      begin
          configini.writeString(inttostr(i), 'ID', form_main.member[i].ID);
          lsbox.Items.Add(form_main.member[i].Name + ' (' + form_main.member[i].ID + ')');
      end;
      configini.destroy;
end;







procedure Tform_memedit.tbox_nameChange(Sender: TObject);
var i : integer;
begin
      {  configini := TINIFile.Create(directory + '\members.ini');
      lsbox.Clear;
             form_main.member[current].name := tbox_name.text;
    for i := 0 to form_main.totalno - 1 do
      begin
          configini.writeString(inttostr(i), 'Name', form_main.member[i].Name);
          lsbox.Items.Add(form_main.member[i].Name + ' (' + form_main.member[i].ID + ')');
      end;
      configini.destroy; }
end;

procedure Tform_memedit.tbox_nameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i : integer;
begin
        configini := TINIFile.Create(directory + '\members.ini');
      lsbox.Clear;
      form_main.member[current].name := tbox_name.text;
    for i := 0 to form_main.totalno - 1 do
      begin
          configini.writeString(inttostr(i), 'Name', form_main.member[i].Name);
          lsbox.Items.Add(form_main.member[i].Name + ' (' + form_main.member[i].ID + ')');
      end;
      configini.destroy;
end;



procedure Tform_memedit.FormActivate(Sender: TObject);
var i : integer;
begin

      copyfile(directory + '\members.ini', directory + '\members.old');
      configini := TINIFile.Create(directory + '\members.ini');
      form_main.totalno := configini.ReadInteger('Main', 'Total', 0);
      setlength(form_main.member, form_main.totalno);
      lsbox.Clear;
      for i := 0 to form_main.totalno - 1 do
      begin
         form_main.member[i].Name := configini.ReadString(inttostr(i), 'Name', 'MISSING_NAME');
         form_main.member[i].ID := configini.ReadString(inttostr(i), 'ID', inttostr(i));
         form_main.member[i].Mon1 := configini.ReadBool(inttostr(i), 'Mon1', False);
         form_main.member[i].Mon2 := configini.ReadBool(inttostr(i), 'Mon2', False);
         form_main.member[i].Mon3 := configini.ReadBool(inttostr(i), 'Mon3', False);
         form_main.member[i].Tue1 := configini.ReadBool(inttostr(i), 'Tue1', False);
         form_main.member[i].Tue2 := configini.ReadBool(inttostr(i), 'Tue2', False);
         form_main.member[i].Tue3 := configini.ReadBool(inttostr(i), 'Tue3', False);
         form_main.member[i].Wed1 := configini.ReadBool(inttostr(i), 'Wed1', False);
         form_main.member[i].Wed2 := configini.ReadBool(inttostr(i), 'Wed2', False);
         form_main.member[i].Wed3 := configini.ReadBool(inttostr(i), 'Wed3', False);
         form_main.member[i].Thu1 := configini.ReadBool(inttostr(i), 'Thu1', False);
         form_main.member[i].Thu2 := configini.ReadBool(inttostr(i), 'Thu2', False);
         form_main.member[i].Thu3 := configini.ReadBool(inttostr(i), 'Thu3', False);
         form_main.member[i].Fri1 := configini.ReadBool(inttostr(i), 'Fri1', False);
         form_main.member[i].Fri2 := configini.ReadBool(inttostr(i), 'Fri2', False);
         form_main.member[i].Fri3 := configini.ReadBool(inttostr(i), 'Fri3', False);
         form_main.member[i].Sat1 := configini.ReadBool(inttostr(i), 'Sat1', False);
         form_main.member[i].Sat2 := configini.ReadBool(inttostr(i), 'Sat2', False);
         form_main.member[i].Sat3 := configini.ReadBool(inttostr(i), 'Sat3', False);
         form_main.member[i].Sun1 := configini.ReadBool(inttostr(i), 'Sun1', False);
         form_main.member[i].Sun2 := configini.ReadBool(inttostr(i), 'Sun2', False);
         form_main.member[i].Sun3 := configini.ReadBool(inttostr(i), 'Sun3', False);

         lsbox.Items.Add(form_main.member[i].Name + ' (' + form_main.member[i].ID + ')');
      end;
      configini.destroy;

      list_enable.clear;
      list_disable.clear;
      if form_main.totalno <> 0 then
         ShowContent(0);
      if form_main.totalno = 0 then
      begin
         item_del.Enabled := false;
         gbox_pinfo.Enabled := false;
         gbox_dinfo.Enabled := false;
         btn_prev.Enabled := false;
         btn_succ.Enabled := false;
      end;
      current := 0;
      btn_prev.Enabled := false;
      if form_main.totalno <= 1 then
        btn_succ.Enabled := false
      else btn_succ.Enabled := true;
end;

procedure Tform_memedit.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  DeleteFile(directory + '\members.ini');
  CopyFile(directory + '\members.old', directory + '\members.ini');
  DeleteFile(directory + '\members.old');
end;

procedure Tform_memedit.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
   if Application.MessageBox(PChar('Are you sure you want to leave?' + sLineBreak + 'Any unsaved changes may be lost.'), 'Are you sure?', MB_ICONINFORMATION + MB_YESNO) = IDNO then
      canclose := false
   else canclose := true;
end;

procedure Tform_memedit.item_delClick(Sender: TObject);
var reply,i,j : integer;
begin
  Reply := Application.MessageBox(PChar('Do you want to remove ' + form_main.member[current].name + '(' + form_main.member[current].ID + ')?'), 'Are you sure?', MB_ICONINFORMATION + MB_YESNO);
  if reply = IDYES then
  begin
     //form_main.logscr.lines.add(form_main.member[current].name + '(' + form_main.member[current].id +') removed.');
     configini := TINIFile.Create(directory + '\members.ini');
     for i := 0 to form_main.totalno - 1 do
        if configini.readstring(inttostr(i), 'ID', 'NOTFOUND') = form_main.member[current].id then
           break;
     for j := i to form_main.totalno - 2 do
     begin
        form_main.member[j] := form_main.member[j+1];
     end;
     dec(form_main.totalno);
     if form_main.totalno = 0 then
     begin
        gbox_pinfo.enabled := false;
        gbox_dinfo.enabled := false;
        btn_prev.enabled := false;
        btn_succ.enabled := false;
     end;
     SetLength(form_main.member, form_main.totalno);
     configini.WriteInteger('Main', 'Total', form_main.totalno);
     Form_main.SaveRecord;
     lsbox.clear;
     //Move all the section id by one
     for i := 0 to form_main.totalno - 1 do
     begin
        configini.writeinteger('Main', 'Total', form_main.totalno);
        configini.writeString(inttostr(i), 'Name', form_main.member[i].Name);
        configini.writeString(inttostr(i), 'ID', form_main.member[i].ID);
        configini.writeBool(inttostr(i), 'Mon1', form_main.member[i].Mon1);
        configini.writeBool(inttostr(i), 'Mon2', form_main.member[i].Mon2);
        configini.writeBool(inttostr(i), 'Mon3', form_main.member[i].Mon3);
        configini.writeBool(inttostr(i), 'Tue1', form_main.member[i].Tue1);
        configini.writeBool(inttostr(i), 'Tue2', form_main.member[i].Tue2);
        configini.writeBool(inttostr(i), 'Tue3', form_main.member[i].Tue3);
        configini.writeBool(inttostr(i), 'Wed1', form_main.member[i].Wed1);
        configini.writeBool(inttostr(i), 'Wed2', form_main.member[i].Wed2);
        configini.writeBool(inttostr(i), 'Wed3', form_main.member[i].Wed3);
        configini.writeBool(inttostr(i), 'Thu1', form_main.member[i].Thu1);
        configini.writeBool(inttostr(i), 'Thu2', form_main.member[i].Thu2);
        configini.writeBool(inttostr(i), 'Thu3', form_main.member[i].Thu3);
        configini.writeBool(inttostr(i), 'Fri1', form_main.member[i].Fri1);
        configini.writeBool(inttostr(i), 'Fri2', form_main.member[i].Fri2);
        configini.writeBool(inttostr(i), 'Fri3', form_main.member[i].Fri3);
        configini.writeBool(inttostr(i), 'Sat1', form_main.member[i].Sat1);
        configini.writeBool(inttostr(i), 'Sat2', form_main.member[i].Sat2);
        configini.writeBool(inttostr(i), 'Sat3', form_main.member[i].Sat3);
        configini.writeBool(inttostr(i), 'Sun1', form_main.member[i].Sun1);
        configini.writeBool(inttostr(i), 'Sun2', form_main.member[i].Sun2);
        configini.writeBool(inttostr(i), 'Sun3', form_main.member[i].Sun3);
                 lsbox.Items.Add(form_main.member[i].Name + ' (' + form_main.member[i].ID + ')');
     end;
     configini.EraseSection(inttostr(form_main.totalno));

     Application.MessageBox('Done.', 'Done', MB_ICONINFORMATION);
     configini.destroy;

  end;
end;





procedure Tform_memedit.btn_triggerClick(Sender: TObject);
var seldis : boolean; i,j : integer;
begin
  form_main.member[current].name := tbox_name.text;
  form_main.member[current].id := tbox_id.text;
  seldis := false;
  for i := 0 to list_disable.items.Count - 1 do
     if list_disable.selected[i] then
     begin
        if list_disable.Items.Strings[i] = 'Mon1' then
           form_main.member[current].Mon1 := true
        else if list_disable.Items.Strings[i] = 'Mon2' then
           form_main.member[current].Mon2 := true
        else if list_disable.Items.Strings[i] = 'Mon3' then
           form_main.member[current].Mon3 := true
        else if list_disable.Items.Strings[i] = 'Tue1' then
           form_main.member[current].Tue1 := true
        else if list_disable.Items.Strings[i] = 'Tue2' then
           form_main.member[current].Tue2 := true
        else if list_disable.Items.Strings[i] = 'Tue3' then
           form_main.member[current].Tue3 := true
        else if list_disable.Items.Strings[i] = 'Wed1' then
           form_main.member[current].Wed1 := true
        else if list_disable.Items.Strings[i] = 'Wed2' then
        form_main.member[current].Wed2 := true
        else if list_disable.Items.Strings[i] = 'Wed3' then
           form_main.member[current].Wed3 := true
        else if list_disable.Items.Strings[i] = 'Thu1' then
           form_main.member[current].Thu1 := true
        else if list_disable.Items.Strings[i] = 'Thu2' then
           form_main.member[current].Thu2 := true
        else if list_disable.Items.Strings[i] = 'Thu3' then
           form_main.member[current].Thu3 := true
        else if list_disable.Items.Strings[i] = 'Fri1' then
           form_main.member[current].Fri1 := true
        else if list_disable.Items.Strings[i] = 'Fri2' then
           form_main.member[current].Fri2 := true
        else if list_disable.Items.Strings[i] = 'Fri3' then
           form_main.member[current].Fri3 := true
        else if list_disable.Items.Strings[i] = 'Sat1' then
           form_main.member[current].Sat1 := true
        else if list_disable.Items.Strings[i] = 'Sat2' then
           form_main.member[current].Sat2 := true
        else if list_disable.Items.Strings[i] = 'Sat3' then
           form_main.member[current].Sat3 := true
        else if list_disable.Items.Strings[i] = 'Sun1' then
           form_main.member[current].Sun1 := true
        else if list_disable.Items.Strings[i] = 'Sun2' then
           form_main.member[current].Sun2 := true
        else if list_disable.Items.Strings[i] = 'Sun3' then
           form_main.member[current].Sun3 := true
     end;
  for j := 0 to list_enable.items.Count - 1 do
     if list_enable.selected[j] then
     begin
        if list_enable.Items.Strings[j] = 'Mon1' then
           form_main.member[current].Mon1 := false
        else if list_enable.Items.Strings[j] = 'Mon2' then
           form_main.member[current].Mon2 := false
        else if list_enable.Items.Strings[j] = 'Mon3' then
           form_main.member[current].Mon3 := false
        else if list_enable.Items.Strings[j] = 'Tue1' then
           form_main.member[current].Tue1 := false
        else if list_enable.Items.Strings[j] = 'Tue2' then
           form_main.member[current].Tue2 := false
        else if list_enable.Items.Strings[j] = 'Tue3' then
           form_main.member[current].Tue3 := false
        else if list_enable.Items.Strings[j] = 'Wed1' then
           form_main.member[current].Wed1 := false
        else if list_enable.Items.Strings[j] = 'Wed2' then
           form_main.member[current].Wed2 := false
        else if list_enable.Items.Strings[j] = 'Wed3' then
           form_main.member[current].Wed3 := false
        else if list_enable.Items.Strings[j] = 'Thu1' then
           form_main.member[current].Thu1 := false
        else if list_enable.Items.Strings[j] = 'Thu2' then
           form_main.member[current].Thu2 := false
        else if list_enable.Items.Strings[j] = 'Thu3' then
           form_main.member[current].Thu3 := false
        else if list_enable.Items.Strings[j] = 'Fri1' then
           form_main.member[current].Fri1 := false
        else if list_enable.Items.Strings[j] = 'Fri2' then
           form_main.member[current].Fri2 := false
        else if list_enable.Items.Strings[j] = 'Fri3' then
           form_main.member[current].Fri3 := false
        else if list_enable.Items.Strings[j] = 'Sat1' then
           form_main.member[current].Sat1 := false
        else if list_enable.Items.Strings[j] = 'Sat2' then
           form_main.member[current].Sat2 := false
        else if list_enable.Items.Strings[j] = 'Sat3' then
           form_main.member[current].Sat3 := false
        else if list_enable.Items.Strings[j] = 'Sun1' then
           form_main.member[current].Sun1 := false
        else if list_enable.Items.Strings[j] = 'Sun2' then
           form_main.member[current].Sun2 := false
        else if list_enable.Items.Strings[j] = 'Sun3' then
           form_main.member[current].Sun3 := false;
     end;
    list_enable.clear;
    list_disable.clear;
    ShowContent(current);
         configini := TINIFile.Create(directory + '\members.ini');
        lsbox.Clear;
    for i := 0 to form_main.totalno - 1 do
      begin
          configini.writeBool(inttostr(i), 'Mon1', form_main.member[i].Mon1);
          configini.writeBool(inttostr(i), 'Mon2', form_main.member[i].Mon2);
          configini.writeBool(inttostr(i), 'Mon3', form_main.member[i].Mon3);
          configini.writeBool(inttostr(i), 'Tue1', form_main.member[i].Tue1);
          configini.writeBool(inttostr(i), 'Tue2', form_main.member[i].Tue2);
          configini.writeBool(inttostr(i), 'Tue3', form_main.member[i].Tue3);
          configini.writeBool(inttostr(i), 'Wed1', form_main.member[i].Wed1);
          configini.writeBool(inttostr(i), 'Wed2', form_main.member[i].Wed2);
          configini.writeBool(inttostr(i), 'Wed3', form_main.member[i].Wed3);
          configini.writeBool(inttostr(i), 'Thu1', form_main.member[i].Thu1);
          configini.writeBool(inttostr(i), 'Thu2', form_main.member[i].Thu2);
          configini.writeBool(inttostr(i), 'Thu3', form_main.member[i].Thu3);
          configini.writeBool(inttostr(i), 'Fri1', form_main.member[i].Fri1);
          configini.writeBool(inttostr(i), 'Fri2', form_main.member[i].Fri2);
          configini.writeBool(inttostr(i), 'Fri3', form_main.member[i].Fri3);
          configini.writeBool(inttostr(i), 'Sat1', form_main.member[i].Sat1);
          configini.writeBool(inttostr(i), 'Sat2', form_main.member[i].Sat2);
          configini.writeBool(inttostr(i), 'Sat3', form_main.member[i].Sat3);
          configini.writeBool(inttostr(i), 'Sun1', form_main.member[i].Sun1);
          configini.writeBool(inttostr(i), 'Sun2', form_main.member[i].Sun2);
          configini.writeBool(inttostr(i), 'Sun3', form_main.member[i].Sun3);

          lsbox.Items.Add(form_main.member[i].Name + ' (' + form_main.member[i].ID + ')');
      end;
      configini.destroy;

end;

procedure Tform_memedit.btn_saveClick(Sender: TObject);
var i : integer;
begin
  form_main.logscr.lines.add('Member List Saved.');
  Application.MessageBox('Changes saved.', 'Done',MB_ICONINFORMATION);
  if form_main.totalno = 0 then
     exit;
  DeleteFile(directory + '\members.old');
  CopyFile(directory + '\members.ini', directory + '\members.old');
  form_main.member[current].ID := tbox_id.Text;
  form_main.member[current].name := tbox_name.Text;
  for i := 0 to form_main.totalno - 1 do
  begin
      if form_main.member[i].Status1 = '' then
   form_main.member[i].Status1 := 'absent';
      if form_main.member[i].Status2 = '' then
   form_main.member[i].Status2 := 'absent';
      if form_main.member[i].Status3 = '' then
   form_main.member[i].Status3 := 'absent';
      end;
   form_main.saverecord;
   if form_main.totalno <> 0 then
   item_del.enabled := true;
  end;


procedure Tform_memedit.btn_prevClick(Sender: TObject);
begin
  form_main.member[current].ID := tbox_id.Text;
  form_main.member[current].name := tbox_name.Text;
  list_enable.clear;
  list_disable.clear;
  dec(current);
  showcontent(current);
  if current = 0 then
     btn_prev.Enabled := false;
  if current <> form_main.totalno - 1 then
     btn_succ.Enabled := true;
end;

procedure Tform_memedit.btn_openiniClick(Sender: TObject);
begin
  if ShellExecute(0,nil, PChar('notepad'),PChar(directory + '\members.ini'),nil,1) =0 then;
end;

procedure Tform_memedit.btn_succClick(Sender: TObject);
begin
  form_main.member[current].ID := tbox_id.Text;
  form_main.member[current].name := tbox_name.Text;
  list_enable.clear;
  list_disable.clear;
  inc(current);
  showcontent(current);
  if current <> 0 then
     btn_prev.Enabled := true;
  if current = form_main.totalno - 1 then
     btn_succ.Enabled := false;
end;

procedure Tform_memedit.list_disableSelectionChange(Sender: TObject;
  User: boolean);
var i : integer; bool : boolean;
begin
  bool := false;
  for i := 0 to list_disable.items.Count - 1 do
     if list_disable.selected[i] then
        bool := true;
  if bool then
   list_enable.ClearSelection;
end;

procedure Tform_memedit.list_enableSelectionChange(Sender: TObject;
  User: boolean);
var i : integer; bool : boolean;
begin
  bool := false;
  for i := 0 to list_enable.items.Count - 1 do
     if list_enable.selected[i] then
        bool := true;
  if bool then
  list_disable.clearselection;
end;

procedure Tform_memedit.item_addClick(Sender: TObject);
var i : integer;
begin
  if form_main.totalno <> 0 then begin
  form_main.member[current].ID := tbox_id.Text;
  form_main.member[current].name := tbox_name.Text;
  end;
  inc(form_main.totalno);
  setlength(form_main.member, form_main.totalno);
  list_enable.clear;
  list_disable.clear;
  current := form_main.totalno - 1;
  form_main.member[current].name := '';
  form_main.member[current].id := '';
  form_main.member[current].Mon1 := false;
  form_main.member[current].Mon2 := false;
  form_main.member[current].Mon3 := false;
  form_main.member[current].Tue1 := false;
  form_main.member[current].Tue2 := false;
  form_main.member[current].Tue3 := false;
  form_main.member[current].Wed1 := false;
  form_main.member[current].Wed2 := false;
  form_main.member[current].Wed3 := false;
  form_main.member[current].Thu1 := false;
  form_main.member[current].Thu2 := false;
  form_main.member[current].Thu3 := false;
  form_main.member[current].Fri1 := false;
  form_main.member[current].Fri2 := false;
  form_main.member[current].Fri3 := false;
  form_main.member[current].Sat1 := false;
  form_main.member[current].Sat2 := false;
  form_main.member[current].Sat3 := false;
  form_main.member[current].Sun1 := false;
  form_main.member[current].Sun2 := false;
  form_main.member[current].Sun3 := false;
  showcontent(current);
  gbox_pinfo.enabled := true;
  gbox_dinfo.enabled := true;

  if form_main.totalno > 1 then
     btn_prev.Enabled := true;
  btn_succ.Enabled := false;
       configini := TINIFile.Create(directory + '\members.ini');

    for i := 0 to form_main.totalno - 1 do
      begin
          configini.writeinteger('Main', 'Total', form_main.totalno);
          //lsbox.Items.Add(form_main.member[i].Name + ' (' + form_main.member[i].ID + ')');
      end;
      configini.destroy;
end;



procedure Tform_memedit.lsboxClick(Sender: TObject);
var i : integer;
begin
   list_enable.clear;
   list_disable.clear;
   for i := 0 to form_main.totalno - 1 do
   begin
      if lsbox.Selected[i] then
      begin
         current := i;
         showcontent(i);

      if current = 0 then
         btn_prev.enabled := false
      else btn_prev.enabled := true;
      if current = form_main.totalno - 1then
         btn_succ.enabled := false
      else btn_succ.enabled := true;
      exit;
      end;
   end
end;

procedure Tform_memedit.lsboxDblClick(Sender: TObject);
begin

end;

end.

