//Attendance Taking MAIN Program by Peter Tse @ 2014
//The Successors: [FORMAT: <NAME>, <Year>, <Newest Version>]
//i.e. Peter Tse, 2014, 1.3.3
//

program Attendance;
uses sysutils, crt, dos, Windows;
type
   MemberType = record
                   Name : string;
                   ID   : string;
                   dow  : string;
                   StatusM, StatusL, StatusAS : string;
                   DCountM, DCountL, DCountAS : integer;  //On Duty Counter
                   ACountM, ACountL, ACountAS : integer;  //Absent Counter
                   SCountM, SCountL, SCOuntAS : integer;  //Shift Counter
                   LCountM, LCountL, LCountAS : integer;  //Late Counter
                   WCount : integer;                      //Warn Counter
                end;
const
   version = '1.3.3';
   devphase = 'Alpha';
   directory = 'C:\Windows\winlog\';
var
   //dates : array[1..1000] of string;
   member    : array[1..100] of MemberType;
   num{,numh}: integer;
   adminmode : boolean;
   user, cmd : string;
   today: string;
   //directory : string;
  
procedure Error (code : integer);
//Output Related Error Message with Error Code
begin
   write('Error: ');
   if code = 1 then
      writeln('Record Not Found.')
   else if code = 2 then
      writeln('You are NOT On Duty Today or in Current Section.')
   else if code = 3 then
      writeln('It is NOT the Time to be On Duty.')
   else if code = 4 then
      writeln('Wrong Password.')
   else if code = 5 then
      writeln('Invalid Input.')
   else if code = 6 then
      writeln('Meaningless Command.')
   else if code = 7 then
      writeln('The Day Chosen is a Holiday.')
   else if code = 8 then
      writeln('Command NOT Found/Available.')
   else if code = 9 then
      writeln('I/O SubProgram NOT Found.')
   else if code = 10 then
      writeln('Member can NOT be Unwarned.')
   else if code = 11 then
      writeln('Component Not Found. Please Contact the Current Program Source Holder.')
   else if code = 12 then
      writeln('You have Checked-In Already.')
   else if code = 13 then
      writeln('Wrong Password.')
   else if code = 14 then
      writeln('You have Logged In as Admin Already.');
   writeln('Command Cancelled. Please Try Again.');
end;
procedure admin;
var
  n: string;
begin
  if user = 'user' then
  begin
     Write('*>');
     TextColor(1);
     ReadLn(n);
     if n = '#gilbert1415' then     //Don't know much about encryption.. so yeah.
     begin
        user := 'admin';
        adminmode := true;
        TextColor(7);
     end
     else
     begin
       TextColor(7);
       error(13);
     end;
  end
  else error(14);
end;
function getDOW(a : integer) : string;
//Change Date of Week from Integer to String
begin
   getDOW := 'null';
   case a of
   1: getDOW := 'Sunday';
   2: getDOW := 'Monday';
   3: getDOW := 'Tuesday';
   4: getDOW := 'Wednesday';
   5: getDOW := 'Thursday';
   6: getDOW := 'Friday';
   7: getDOW := 'Saturday';
   end;
end;
function getDOWid(a : string) : integer;
//Change Date of Week from String to Integer
begin
   getDOWid := 0;
   if a = 'Sunday' then
      getDOWid := 1;
   if a = 'Monday' then
      getDOWid := 2;
   if a = 'Tuesday' then
      getDOWid := 3;
   if a = 'Wednesday' then
      getDOWid := 4;
   if a = 'Thursday' then
      getDOWid := 5;
   if a = 'Friday' then
      getDOWid := 6;
   if a = 'Saturday' then
      getDOWid := 7;
end;
Function L0(w:word):string;
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
function time_ : string;
//Generate Current Time in String
var
  Hour,Min,Sec,HSec : word;

begin
  GetTime(Hour,Min,Sec,HSec);
  time_ := L0(Hour) + ':' + L0(Min);
end;
function datetostr(a:TDateTime) : string;
//Gene rate Specific Date in String
Var YY,MM,DD : Word;
Begin
   DeCodeDate(a,YY,MM,DD);
   datetostr := L0(yy) + L0(mm) + L0(dd);
end;
procedure initializeMember(var count : integer);
//Initialize MemberType Array and Read Member List from Member.txt
var filename : string;  i : integer;   f: text;
begin
   for i := 1 to 100 do
   begin
      member[i].name := '';
      member[i].id   := '';
      member[i].dow  := '';
      member[i].statusM := '';
      member[i].statusL := '';
      member[i].statusAS := '';
      member[i].ACountM := 0;
      member[i].ACountL := 0;
      member[i].ACountAS := 0;
      member[i].SCountM := 0;
      member[i].SCountL := 0;
      member[i].SCountAS := 0;
      member[i].DCountM := 0;
      member[i].DCountL := 0;
      member[i].DCountAS := 0;
      member[i].LCountM := 0;
      member[i].LCountL := 0;
      member[i].LCountAS := 0;
   end;
   filename := directory + 'Member.txt';
   assign(f, filename);
   if not fileexists(filename) then
   begin
      writeln('Warning: Member List is Empty.');
      writeln('Please Use Member List I/O SubProgram to Input Current Member List.');
      rewrite(f);
   end
   else
   begin
      reset(f);
      count := 0;
      while not eof(f) do
      begin
         inc(count);
         with Member[count] do
         begin
            readln(f, Name);
            readln(f, id);
            readln(f, dow);
         end;
      end;
      close(f);
   end;
end;
function period : string;
//Check whether it's Late, Inappropriate Time or On Time
var
  Hour,Min,Sec,HSec : word;
begin
  GetTime(Hour,Min,Sec,HSec);
  period := '0';
  if (hour = 7) and (min <= 35) then
     period := '1a';
  if (hour = 7) and (min > 35) then
     period := '1b';
  if ((hour = 12) and (min >= 45)) or ((hour = 13) and (min <= 30)) then
     period := '2a';
  if (hour = 13) and (min > 30) then
     period := '2b';
  if (hour = 15) and (min <= 45) then
     period := '3a';
  if ((hour = 15) and (min > 45)) or (hour > 15) then
     period := '3b';
end;
{procedure initializeHoliday(var i : integer);
//Read All Holidays
var filename: string; f: text;
begin
   i := 0;
   filename := directory + 'Holiday.txt';
   assign(f, filename);
   if not fileexists(filename) then
      rewrite(f)
   else
   begin
      reset(f);
      while not eof(f) do
      begin
         i := i + 1;
         readln(f, dates[i]);
      end;
      close(f);
   end;
end;   }
procedure genabs(num : integer);
//Generate a Clean Record at Start of the Day
var f : text; i : integer;
begin
   assign(f,directory + 'log\' + getDOW(DayofWeek(date)) + '\' + datetostr(date) + '.txt');
   rewrite(f);
   for i := 1 to num do
   begin
      member[i].statusM := 'Absent';
      member[i].statusL := 'Absent';
      member[i].statusAS := 'Absent';
      writeln(f, member[i].name);
      writeln(f, member[i].statusM + ' ' + member[i].statusL + ' ' + member[i].statusAS);
   end;
   close(f);
end;
procedure initializeStatus();
//Read in Status
var i,s1,s2,j : integer; f : text; a,n: string;
begin
   assign(f,directory + 'log\' + getDOW(DayofWeek(date)) + '\' + datetostr(date) + '.txt');
   reset(f);
   while not eof(f) do
   begin
      readln(f, n);
      readln(f, a);
      //writeln(n, ' ',a );
      j := 0;
      repeat
         j := j + 1;
         if a[j] = ' ' then
            s1 := j;
      until a[j] = ' ';
      for j := s1+1 to length(a) do
         if a[j] = ' ' then
            s2 := j;
      i := 0;
      repeat
         i := i + 1;
      until (member[i].name = n) or (i = num + 1);
      member[i].statusM := copy(a, 1, s1-1);
      member[i].statusL := copy(a, s1+1, s2- 1 - s1);
      member[i].statusAS := copy(a, s2+1, length(a) - s2);
   end;
   close(f);
end;
procedure initializeACounts;
//Add 1 to ACount if Today is Duty Day
var i : integer;
begin
   for i := 1 to num do
   begin
      if getDOWID(member[i].dow) = dayofweek(date) then
      begin
         inc(member[i].ACountM);
         inc(member[i].ACountL);
         inc(member[i].ACountAS);
      end;
   end;
end;
procedure initializeData;
//Read in DATA
var i,j,val1,val2 : integer; filename,st,idstr : string; f : text;
begin
   filename := directory + 'log\MemberData.txt';
   assign(f, filename);
   if not fileexists(filename) then
      rewrite(f)
   else
   begin
      reset(f);
      readln(f);
      while not eof(f) do
      begin
         readln(f, st);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         idstr := copy(st, 1, j - 1);
         delete(st, 1, j);
         i := 0;
         repeat
            i := i + 1;
            val(member[i].id, val1);
            val(idstr, val2);
         until (val1 = val2) or (i = num+1);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].DCountM);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].DCountL);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].DCountAS);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].SCountM);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].SCountL);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].SCountAS);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].LCountM);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].LCountL);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].LCountAS);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].ACountM);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].ACountL);
         delete(st, 1, j);
         j := 0;
         repeat
            inc(j);
         until st[j] = ' ';
         val(copy(st, 1, j - 1),member[i].ACountAS);
         delete(st, 1, j);
         val(st,member[i].WCount);
         //readln(f, id, DCountM, DCountL, DCountAS, SCountM, SCountL, SCountAS, LCountM, LCountL, LCountAS, ACountM, ACountL, ACountAS, WCount);
      end;
   end;
   close(f);
end;

procedure SaveRecord;
//Save Records
var
   i  : integer; f : text;
begin
   assign(f,directory + 'log\' + getDOW(DayofWeek(date)) + '\' + datetostr(date) + '.txt');
   rewrite(f);
   for i := 1 to num do
   begin
      writeln(f, member[i].name);
      writeln(f, member[i].statusM + ' ' + member[i].statusL + ' ' + member[i].statusAS);
   end;
   close(f);

   assign(f,directory + 'log\MemberData.txt');
   rewrite(f);
   writeln(f, 'ID D D D S S S L L L A A A W');
   for i := 1 to num do
   begin
      write(f, member[i].ID, ' ');
      write(f,member[i].DCountM, ' ', member[i].DCountL, ' ', member[i].DCountAS, ' ');
      write(f,member[i].SCountM, ' ', member[i].SCountL, ' ', member[i].SCountAS, ' ');
      write(f,member[i].LCountM, ' ', member[i].LCountL, ' ', member[i].LCountAS, ' ');
      write(f,member[i].ACountM, ' ', member[i].ACountL, ' ', member[i].ACountAS, ' ');
      writeln(f,member[i].WCount);
   end;
   close(f);
end;
procedure checkin(a : string);
//CheckIn Module
var i : integer; val1,val2 : integer; YN : char;
begin
   i := 0;
   repeat
      i := i + 1;
      val(member[i].id, val1);
      val(a, val2);
   until (val1 = val2) or (i = num + 1);
   if member[i].id = '' then
   begin
      Error(1);
      exit;
   end;
   if period = '0' then
   begin
      Error(3);
      exit;
   end;
   if (period = '1a') or (period = '1b') then
      if (upcase(member[i].StatusM) <> 'ABSENT') and (upcase(member[i].statusM) <> 'NTDABS') then
      begin
         error(12);
         exit;
      end;
   if (period = '2a') or (period = '2b') then
      if (upcase(member[i].StatusL) <> 'ABSENT') and (upcase(member[i].statusL) <> 'NTDABS') then
      begin
         error(12);
         exit;
      end;
   if (period = '3a') or (period = '3b') then
      if (upcase(member[i].StatusAS) <> 'ABSENT') and (upcase(member[i].statusAS) <> 'NTDABS') then
      begin
         error(12);
         exit;
      end;
   begin
      writeln('You are about to check-in as ', member[i].name, '.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
      begin
         if period = '1a' then
         begin
            if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountM = 0) then
            begin
               member[i].statusM := 'Present';
               inc(member[i].DCountM);
            end
            else if (getDOWid(member[i].dow) = dayofweek(Date)) or ((getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountM > 0)) then
            begin
               member[i].statusM := 'OnDuty';
               if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountM > 0) then
                  dec(member[i].SCountM);
               dec(member[i].ACountM);
               inc(member[i].DCountM);
            end;
         end
         else if period = '1b' then
         begin
            if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountM = 0) then
            begin
               member[i].statusM := 'Present';
               inc(member[i].DCountM);
            end
            else if (getDOWid(member[i].dow) = dayofweek(Date)) or ((getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountM > 0)) then
            begin
               member[i].statusM := 'Late';
               inc(member[i].LCountM);
               if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountM > 0) then
                  dec(member[i].SCountM);
               dec(member[i].ACountM);
               inc(member[i].DCountM);
            end;
         end
         else if period = '2a' then
         begin
            if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountL = 0) then
            begin
               member[i].statusL := 'Present';
               inc(member[i].DCountL);
            end
            else if (getDOWid(member[i].dow) = dayofweek(Date)) or ((getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountL > 0)) then
            begin
               member[i].statusL := 'OnDuty';
               if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountL > 0) then
                  dec(member[i].SCOuntL);
               dec(member[i].ACountL);
               inc(member[i].DCountL);
            end;
         end
         else if period = '2b' then
         begin
            if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountL = 0) then
            begin
               member[i].statusL := 'Present';
               inc(member[i].DCountL);
            end
            else if (getDOWid(member[i].dow) = dayofweek(Date)) or ((getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountL > 0)) then
            begin
               member[i].statusL := 'Late';
               inc(member[i].LCountL);
               if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountL > 0) then
                  dec(member[i].SCountL);
               dec(member[i].ACountL);
               inc(member[i].DCountL);
            end;
         end
         else if period = '3a' then
         begin
            if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountAS = 0) then
            begin
               member[i].statusAS := 'Present';
               inc(member[i].DCountAS);
            end
            else if (getDOWid(member[i].dow) = dayofweek(Date)) or ((getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountAS > 0)) then
            begin
               member[i].statusAS := 'OnDuty';
               if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountAS > 0) then
                  dec(member[i].SCountAS);
               dec(member[i].ACountAS);
               inc(member[i].DCountAS);
            end;
         end
         else if period = '3b' then
         begin
            if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountAS = 0) then
            begin
               member[i].statusAS := 'Present';
               inc(member[i].DCountAS);
            end;
            if (getDOWid(member[i].dow) = dayofweek(Date)) or ((getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountAS > 0)) then
            begin
               member[i].statusAS := 'Late';
               inc(member[i].LCountAS);
               if (getDOWid(member[i].dow) <> dayofweek(Date)) and (member[i].SCountAS > 0) then
                  dec(member[i].SCountAS);
               dec(member[i].ACountAS);
               inc(member[i].DCountAS);
            end;
         end;
      saverecord;
      writeln('Command Executed.');
      end
      else writeln('Command Cancelled.');
         YN := ' ';
   end;
end;
procedure resetstatus(st : string);
//Reset Command Module
var i,val1,val2,code,bval : integer; yn:char; a,b : string;
begin
   delete(st, 1, 6);
   a := copy(st, 1, pos(' ',st)-1);
   b := st;
   delete(b, 1, pos(' ',st));
   i := 0;
   repeat
      i := i + 1;
      val(member[i].id, val1);
      val(a, val2);
   until (val1 = val2) or (i = num+1);
   if (member[i].id = '')then
   begin
      Error(1);
      exit;
   end;
   val(b, bval, code);
   if (code <> 0) or (bval > 3) or (bval < 1) then
   begin
      Error(5);
      exit;
   end;
   if bval = 1 then
   begin
      writeln('You are about to Reset ', member[i].name, '''s Morning Record.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            if upcase(member[i].statusM) = 'LATE' then
            begin
               dec(member[i].LCountM);
               inc(member[i].ACountM);
               dec(member[i].DCountM);
            end
            else if upcase(member[i].statusM) = 'ONDUTY' then
            begin
               inc(member[i].ACountM);
               dec(member[i].DCountM);
            end
            else if upcase(member[i].statusM) = 'PRESENT' then
               dec(member[i].DCountM)
            else if upcase(member[i].statusM) = 'NTDABS' then
               dec(member[i].SCountM);
            member[i].statusM := 'Absent';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else
   if bval = 2 then
   begin
      writeln('You are about to Reset ', member[i].name, '''s Lunch Record.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            if upcase(member[i].statusL) = 'LATE' then
            begin
               dec(member[i].LCountL);
               inc(member[i].ACountL);
               dec(member[i].DCountL);
            end
            else if upcase(member[i].statusL) = 'ONDUTY' then
            begin
               inc(member[i].ACountL);
               dec(member[i].DCountL);
            end
            else if upcase(member[i].statusL) = 'PRESENT' then
               dec(member[i].DCountL)
            else if upcase(member[i].statusL) = 'NTDABS' then
               dec(member[i].SCountL);
            member[i].statusL := 'Absent';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else
   begin
      writeln('You are about to Reset ', member[i].name, '''s AfterSchool Record.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            if upcase(member[i].statusAS) = 'LATE' then
            begin
               dec(member[i].LCountAS);
               inc(member[i].ACountAS);
               dec(member[i].DCountAS);
            end
            else if upcase(member[i].statusAS) = 'ONDUTY' then
            begin
               inc(member[i].ACountAS);
               dec(member[i].DCountAS);
            end
            else if upcase(member[i].statusAS) = 'PRESENT' then
               dec(member[i].DCountAS)
            else if upcase(member[i].statusAS) = 'NTDABS' then
               dec(member[i].SCountAS);
            member[i].statusAS := 'Absent';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end;
   saverecord;
end;
procedure NtdAbs(st : string);
//NtdAbs Command Module
var i,val1,val2,bval,code : integer; a,b : string; YN:char;
begin
   delete(st, 1, 6);
   a := copy(st, 1, pos(' ', st)-1);
   b := st;
   delete(b, 1, pos(' ', st));

   i := 0;
   repeat
      i := i + 1;
      val(member[i].id, val1);
      val(a, val2);
   until (val1 = val2) or (i = num+1);
   if member[i].id = '' then
   begin
      Error(1);
      exit;
   end;
   val(b, bval, code);
   if (code <> 0) or (bval > 3) or (bval < 1) then
   begin
      Error(5);
      exit;
   end;
   if bval = 1 then
   begin
      writeln('You are about to Mark ', member[i].name, '''s Morning Record as Noted Abs.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            if getDOWid(member[i].dow) = dayofweek(Date) then
               member[i].statusM := 'NtdAbs';
            inc(member[i].SCountM);
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else if bval = 2 then
   begin
      writeln('You are about to Mark ', member[i].name, '''s Lunch Record as Noted Abs.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            if getDOWid(member[i].dow) = dayofweek(Date) then
               member[i].statusL := 'NtdAbs';
            inc(member[i].SCountL);
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else
   begin
      writeln('You are about to Mark ', member[i].name, '''s AfterSchool Record as Noted Abs.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            if getDOWid(member[i].dow) = dayofweek(Date) then
               member[i].statusAS := 'NtdAbs';
            inc(member[i].SCountAS);
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end;
   saverecord;
end;
procedure warn(st: string; mode: integer);
//Warn Command Module
var i,val1,val2 : integer; YN : char;
begin
   YN := ' ';
   if mode = 1 then
      delete(st, 1, 5)
   else if mode = -1 then
      delete(st, 1, 7);
   i := 0;
   repeat
      i := i + 1;
      val(member[i].id, val1);
      val(st, val2);
   until (val1 = val2) or (i = num + 1);
   if i = num + 1 then
   begin
      error(1);
      exit;
   end;
   if (mode = -1) and (member[i].wCount = 0) then
   begin
      error(10);
      exit;
   end;
   if mode = 1 then
      writeln('You are about to warn ', member[i].name, '.')
   else if mode = -1 then
      writeln('You are about to unwarn ', member[i].name, '.');
   writeln('Confirm? [Y/N]');
   YN := readkey;
   if (YN = 'Y') or (YN = 'y') then
   begin
      if mode = 1 then
         inc(member[i].wcount)
      else if mode = -1 then
         dec(member[i].wcount);
       writeln('Command Executed.')
   end
   else writeln('Command Cancelled.');
   YN := ' ';
   saverecord();
end;
procedure gen(st : string);
var i : integer;
begin
   delete(st, 1, 4);
   if (upcase(st) <> 'LATE') and (upcase(st) <> 'ABS') and (upcase(st) <> 'WARN') and (upcase(st) <> 'TOTAL') and (upcase(st) <> 'SHIFT') and (upcase(st) <> 'HOLIDAY') then
   begin
      error(1);
      exit;
   end;
   writeln('ID':30, '   ', 'COUNT');
   for i := 1 to num do
   begin
      if (upcase(st) = 'LATE') and (member[i].lcountm + member[i].lcountl + member[i].lcountas <> 0) then
      begin
         write(member[i].id:30,'   ');
         writeln(member[i].lcountm + member[i].lcountl + member[i].lcountas);
      end
      else if (upcase(st) = 'ABS') and (member[i].ACountM + member[i].ACountL + member[i].ACountAS > 0) then
      begin
         write(member[i].id:30,'   ');
         writeln(member[i].ACountM + member[i].ACountL + member[i].ACountAS)
      end
      else if (upcase(st) = 'WARN') and (member[i].WCount <> 0) then
      begin
         write(member[i].id:30,'   ');
         writeln(member[i].WCount);
      end
      else if (upcase(st) = 'TOTAL') and (member[i].DCountM + member[i].DCountL + member[i].DCountAS > 0) then
      begin
         write(member[i].id:30,'   ');
         writeln(member[i].DCountM + member[i].DCountL + member[i].DCountAS);
      end
      else if (upcase(st) = 'SHIFT') and (member[i].SCountM + member[i].SCountL + member[i].SCountAS <> 0) then
      begin
         write(member[i].id:30,'   ');
         writeln(member[i].SCountM + member[i].SCountL + member[i].SCountAS);
      end;
      {else if (upcase(st) = 'HOLIDAY') then
      begin
         for j := 1 to numh do
            writeln(dates[j]);
      end;}
   end;
end;
procedure list(st : string);
var i : integer;
begin
   if length(st) > 4 then
   begin
      delete(st, 1, 5);
      if (upcase(st) <> 'LATE') and (upcase(st) <> 'ABSENT') and (upcase(st) <> 'ALL') and (upcase(st) <> 'PRESENT') then
      begin
         error(1);
         exit;
      end;
   end;
   if upcase(st) = 'LIST' then
   begin
      writeln(period[1]);
      writeln('Name':30, '   ', 'ID', '   ', 'Status');
      if (period = '1a') or (period = '1b') then
      begin
         for i := 1 to num do
         begin
            if getDOWid(member[i].dow) = dayofweek(date) then
               writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusM);
         end;
      end
      else
      if (period = '2a') or (period = '2b') then
      begin
         for i := 1 to num do
         begin
            if (getDOWid(member[i].dow) = dayofweek(date)) then
               writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusL);
         end;
      end
      else if (period = '3a') or (period = '3b') then
      begin
         for i := 1 to num do
         begin
            if (getDOWid(member[i].dow) = dayofweek(date))  then
               writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusAS);
         end;
      end
   end
   else
   begin
      writeln(period[1]);
      writeln('Name':30, '   ', 'ID', '   ', 'Status');
      if (period = '1a') or (period = '1b') then
      begin
         if (upcase(st) = 'LATE') then
         begin
            for i := 1 to num do
            begin
               if upcase(member[i].statusM) = 'LATE' then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusM);
            end;
         end
         else if (upcase(st) = 'ABSENT') then
         begin
            for i := 1 to num do
            begin
               if ((upcase(member[i].statusM) = 'ABSENT') or (upcase(member[i].statusM) = 'NTDABS')) and (getDOWID(member[i].dow) = dayofweek(date)) then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusM);
            end;
         end
         else if (upcase(st) = 'PRESENT') then
         begin
            for i := 1 to num do
            begin
               if (upcase(member[i].statusM) = 'PRESENT') or (upcase(member[i].statusM) = 'ONDUTY') then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusM);
            end;
         end
         else if (upcase(st) = 'ALL') then
         begin
            for i := 1 to num do
            begin
               writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusM);
            end;
         end
      end
      else
      if (period = '2a') or (period = '2b') then
      begin
         if (upcase(st) = 'LATE') then
         begin
            for i := 1 to num do
            begin
               if upcase(member[i].statusL) = 'LATE' then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusL);
            end;
         end
         else if (upcase(st) = 'ABSENT') then
         begin
            for i := 1 to num do
            begin
               if (upcase(member[i].statusL) = 'ABSENT') or (upcase(member[i].statusL) = 'NTDABS') then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusL);
            end;
         end
         else if (upcase(st) = 'PRESENT') then
         begin
            for i := 1 to num do
            begin
               if (upcase(member[i].statusL) = 'PRESENT') or (upcase(member[i].statusL) = 'ONDUTY') then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusL);
            end;
         end
         else if (upcase(st) = 'ALL') then
         begin
            for i := 1 to num do
            begin
               writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusL);
            end;
         end
      end
      else if (period = '3a') or (period = '3b') then
      begin
         if (upcase(st) = 'LATE') then
         begin
            for i := 1 to num do
            begin
               if upcase(member[i].statusAS) = 'LATE' then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusAS);
            end;
         end
         else if (upcase(st) = 'ABSENT') then
         begin
            for i := 1 to num do
            begin
               if (upcase(member[i].statusAS) = 'ABSENT') or (upcase(member[i].statusAS) = 'NTDABS') then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusAS);
            end;
         end
         else if (upcase(st) = 'PRESENT') then
         begin
            for i := 1 to num do
            begin
               if (upcase(member[i].statusAS) = 'PRESENT') or (upcase(member[i].statusAS) = 'ONDUTY') then
                  writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusAS);
            end;
         end
         else if (upcase(st) = 'ALL') then
         begin
            for i := 1 to num do
            begin
               writeln(member[i].name:30, '   ', member[i].id, '   ', member[i].statusAS);
            end;
         end;
      end;
   end;
end;
procedure editFile(st : string);
begin
   delete(st, 1, 5);
   if upcase(st) = 'MEMBER' then
   begin
      If FileExists(directory + 'member.exe') then
      begin
         //writeln('Please Exit to Return to the Main Program.');
         exec(directory + 'Member.exe', '');
      end
      else
      begin
        error(11);
        exit;
      end;
   end
   {else if upcase(st) = 'HOLIDAY' then
   begin
      If FileExists(directory + 'holiday.exe') then
      begin
         //writeln('Please Exit to Return to the Main Program.');
         exec(directory + 'holiday.exe', '');
      end
      else
      begin
        error(11);
        exit;
      end;
   end}
   else Error(9);
end;
procedure help(st : string);
var a : string;
begin
   delete(st, 1, 5);
   a := st;
   if a = '' then
   begin
      if adminmode then
      begin
         writeln('Here are the commands available:');
         writeln('ABOUT   -- Print out the Information about this Program');
         writeln('CHECKIN -- Log the Duty Record');
         writeln('CLS     -- Clear Screen');
         writeln('EDIT    -- Edit Specific Records by Using I/O SubProgram Designed');
         writeln('EXIT    -- Exit the program');
         writeln('GEN     -- Generate List of Specific Record');
         writeln('HELP    -- Provide Help on Commands in this Program');
         writeln('LIST    -- List out Information of Today');
         writeln('RELOAD  -- Reload the Stored Data');
         writeln('RESET   -- Reset Any Duty Status of Today');
         writeln('SHIFT   -- Mark Any Duty Status of Today as ''Noted Absent''');
         writeln('WARN    -- Warn Specific Member');
         writeln('UNWARN  -- Unwarn Specific Member');
         writeln('Type help <command> to get the usage of the specific command');
      end
      else
      begin
         writeln('Here are the commands available:');
         writeln('ABOUT   -- Print out the Information about this Program');
         writeln('CHECKIN -- Log the Duty Record');
         writeln('CLS     -- Clear Screen');
         writeln('EXIT    -- Exit the program');
         writeln('HELP    -- Provide Help on Commands in this Program');
         writeln('LIST    -- List out Information of Today');
         writeln('Type help <command> to get the usage of the specific command.');
      end;
   end
   else
   if upcase(a) = 'CHECKIN' then
   begin
      writeln('checkin');
      writeln('Log the Duty Record');
      writeln;
      writeln('USAGE:');
      writeln(user,'>checkin <id>');
      writeln('   id - The ID of the specific member.');
   end
   else
   if (upcase(a) = 'RELOAD') and (adminmode) then
   begin
      writeln('reload');
      writeln('Reload the Stored Data.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>reload');
   end
   else
   if upcase(a) = 'CLS' then
   begin
      writeln('cls');
      writeln('Clear Screen.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>cls');
   end
   else
   if (upcase(a) = 'RESET') and (adminmode) then
   begin
      writeln('reset');
      writeln('Reset any Duty Status of Today.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>reset <id> <code>');
      writeln('   id - The ID of the specific member.');
      writeln('   code - Code of Duty Slot: 1 - Morning; 2 - Lunch; 3 - AfterSchool.');
   end
   else
   if (upcase(a) = 'SHIFT') and (adminmode) then
   begin
      writeln('shift');
      writeln('Mark any Duty Status of Today as ''Noted Absent''.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>shift <id> <code>');
      writeln('   id - The ID of the specific member.');
      writeln('   code - Code of Duty Slot: 1 - Morning; 2 - Lunch; 3 - AfterSchool.');
   end
   else
   if upcase(a) = 'LIST' then
   begin
      writeln('list');
      writeln('   <none>|LATE|ABSENT|PRESENT|ALL');
      writeln('List out Information of Today.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>list <type>');
      writeln('   type - Criteria you Wanted to be Listed Out.');

   end
   else
   if upcase(a) = 'ABOUT' then
   begin
      writeln('about');
      writeln('Print out the Information about this Program.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>about');
   end
   else
   if upcase(a) = 'HELP' then
   begin
      writeln('help');
      writeln('Provide Help on Commands in this Program.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>help <command>');
      writeln('   command - command in this program');
   end
   else
   if upcase(a) = 'EXIT' then
   begin
      writeln('exit');
      writeln('Exit the Program.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>exit');
   end
   else if (upcase(a) = 'EDIT') and (adminmode) then
   begin
      writeln('edit');
      writeln('   MEMBER');
      writeln('Edit Specific Records by Using I/O SubProgram Designed.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>edit <record_name>');
      writeln('   record_name - record name you want to edit');

   end
   else if (upcase(a) = 'GEN') and (adminmode) then
   begin
      writeln('gen');
      writeln('   LATE|ABS|WARN|TOTAL|SHIFT');
      writeln('Generate List of Specific Record');
      writeln;
      writeln('USAGE:');
      writeln(user, '>gen <record_name>');
      writeln('   record_name - record name you want to generate');

   end
   else if (upcase(a) = 'WARN') and (adminmode) then
   begin
      writeln('warn');
      writeln('Warn Specific Member.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>warn <id>');
      writeln('   id - The ID of the specific member.');
   end
   else if (upcase(a) = 'UNWARN') and (adminmode) then
   begin
      writeln('unwarn');
      writeln('Unwarn Specific Member.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>unwarn <id>');
      writeln('   id - The ID of the specific member.');
   end
   else
   begin
      Error(8);
      exit;
   end;
   writeln;
end;

procedure start;
begin
   //adminmode := true;
   //user := 'user';
   //user := '';
   today := datetostr(date);
   If Not DirectoryExists(directory) then
      createdir(directory);
   If Not DirectoryExists(directory + 'log') then
      createdir(directory + 'log');
   If Not DirectoryExists(directory + 'log\Monday') then
      createdir(directory + 'log\Monday');
   If Not DirectoryExists(directory + 'log\Tuesday') then
      createdir(directory + 'log\Tuesday');
   If Not DirectoryExists(directory + 'log\Wednesday') then
      createdir(directory + 'log\Wednesday');
   If Not DirectoryExists(directory + 'log\Thursday') then
      createdir(directory + 'log\Thursday');
   If Not DirectoryExists(directory + 'log\Friday') then
      createdir(directory + 'log\Friday');
   writeln('Check-In Program ',devphase,' v', version, ' by PT');
   initializemember(num);
   //initializeholiday(numh);
   initializedata;
   //writeln(fileexists(directory + 'log\' + datetostr(date) + '.txt'));
   if not fileexists(directory + 'log\' + getDOW(DayofWeek(date)) + '\' + datetostr(date) + '.txt') then
   begin
      initializeACounts;
      genabs(num);
   end
   else initializeStatus();
   saverecord();
   writeln('Enter your command.');
end;
procedure readcmd(st : string);
var cmd: string;
begin
   if (upcase((copy(st, 1, 7))) = 'CHECKIN') and (st[8] = ' ') then
         checkin(copy(st, 9, 2))
   else if (upcase(copy(st, 1, 6)) = 'RELOAD')  and (length(st) = 6) and (adminmode = true) then
   begin
      writeln('Reloading...');
      start;
   end
   else if copy(st, 1, 5) = 'admin' then
      admin
   else if (upcase(copy(st, 1, 3)) = 'CLS') and (length(st) = 3) then
   begin
      ClrScr;
      writeln('Check-In Program ',devphase,' v', version, ' by PT');
      writeln('Enter your command.');
   end
   else if (upcase(copy(st, 1, 5)) = 'RESET') and (st[6] = ' ')  and (adminmode = true) then
      resetstatus(st)
   else if (upcase(copy(st, 1, 6)) = 'LOGOUT') and (length(st)=6) and (adminmode = true) then
   begin
      adminmode := false;
      user := 'user';
      clrscr;
      start;
   end
   else if (upcase(copy(st, 1, 5)) = 'SHIFT') and (st[6] = ' ') and (adminmode = true)then
      ntdabs(st)
   else if (upcase(copy(st, 1, 4)) = 'LIST') and ((length(st) = 4) or (st[5] = ' ')) then
   begin
      list(st)
   end
   else if (upcase(copy(st, 1, 4)) = 'HELP') and ((length(st) = 4) or (st[5] = ' ')) then
      help(st)
   else if (upcase(copy(st, 1, 5)) = 'ABOUT') and (length(st) = 5)  then
   begin
      writeln;
      writeln('This program is created by Tse Ho Nam in 2014,');
      writeln('with current version ', devphase, ' v', version,'.');
      writeln('This program is designed for SFXC LST, and');
      writeln('do not work fine in any other circumstances.');
      writeln('Please inform the current program source holder for any bug,');
      writeln('or for the source if necessary.');
      writeln('I would like to give credit to Miu Ho Yeung for making the icons');
      writeln('for the programs.');
      writeln('                                                    PT, 2014');
      writeln;
   end
   else if (upcase(copy(st, 1, 4)) = 'EXIT') and (length(st) = 4) then
      halt
   else if (upcase(copy(st, 1, 4)) = 'EDIT')  and (st[5] = ' ') and (adminmode) then
   begin
      editfile(st);
      writeln('Reloading...');
      start;
   end
   else if (upcase(copy(st, 1, 4)) = 'WARN') and (st[5] = ' ') and (adminmode) then
      warn(st, 1)
   else if (upcase(copy(st, 1, 6)) = 'UNWARN') and (st[7] = ' ') and (adminmode) then
      warn(st, -1)
   else if (upcase(copy(st, 1, 3)) = 'GEN') and (st[4] = ' ') and (adminmode) then
      gen(st)
   else
   begin
      Error(8);
      write(user,'>');
      readln(cmd);
      readcmd(cmd);
   end;
end;


{$R *.res}

begin
   setconsoletitle('SFXCLST Check-In Program ' + devphase + ' ' + version);
   user := 'user';
   TextColor(7);
   TextBackground(1);
   clrscr;
   //GetDir(0,directory);
   //directory := directory + '\';
   writeln('Initializing...');
   start;
   while true do
   begin
      setconsoletitle('SFXCLST Check-In Program ' + devphase + ' ' + version);
      write(user,'>');
      readln(cmd);
      if datetostr(date) <> today then
      begin
         start;
         clrscr;
      end;
      readcmd(cmd);
   end;
end.

