//Check-in Program by Peter Tse @ 2014
program Attendance;
uses sysutils, crt, dos;
type
   MemberType = record
                   Name : string;
                   ID   : string;
                   //role : string;
                   dow  : string;
                   StatusMorn, StatusLunch, StatusAS : string;
                   ShiftOriginal, {ShiftDay,} ShiftSlot, ShiftFinal: string;
                   shiftDateM, shiftDateL, shiftDateAS : string;
                   ShiftMorn, ShiftLunch, ShiftAS: boolean;
                   LateCount, ABSCount, WarnCount : integer;
                end;
const
   version = 1.2;
   devphase = 'Alpha';
   directory = 'C:\Users\Administrator\Desktop\Attendance\';
var
   f : text;
   dates : array[1..1000] of string;
   Member : array[1..100] of MemberType;
   num, numh : integer;
   cmd,user : string;
   adminmode : boolean;

procedure Error (code : integer);
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
      writeln('Component Not Found. Please Contact the Current Program Source Holder.');
   writeln('Command Cancelled. Please Try Again.');
end;


function getDOW(a : integer) : string;
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
var
  Hour,Min,Sec,HSec : word;

begin
  GetTime(Hour,Min,Sec,HSec);
  time_ := L0(Hour) + ':' + L0(Min);
end;

function datetostr(a:TDateTime) : string;
Var YY,MM,DD : Word;
Begin
   DeCodeDate(a,YY,MM,DD);
   datetostr := L0(yy) + L0(mm) + L0(dd);
end;

function calcDate(oriD: TDateTime; addDay: integer) : TDateTime;
//var Y, M, D: word;
begin
   if addDay > 0 then
      calcDate := orid + addDay
   else
   begin
      addDay := abs(addDay);
      calcDate := orid - addDay;
   end
   {DecodeDate(orid,Y,M,D);
   writeln(y,' ',m,' ',d); }
end;

procedure InitializeMember(var count : integer);
var filename : string;  i : integer;
begin
   for i := 1 to 50 do
   begin
      member[i].name := '';
      //member[i].role := '';
      member[i].id   := '';
      member[i].dow  := '';
      member[i].statusMorn := '';
      member[i].statusLunch := '';
      member[i].statusAS := '';
      member[i].shiftoriginal := '';
      //member[i].shiftday := '';
      member[i].shiftslot := '';
      member[i].shiftFinal := '';
      member[i].shiftMorn := false;
      member[i].shiftLunch := false;
      member[i].shiftAS := false;
      member[i].lateCount := 0;
      member[i].ABSCount := 0;
      member[i].WarnCount := 0;
      member[i].shiftDateM := '';
      member[i].shiftDateL := '';
      member[i].shiftDateAS := '';
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
         //readln(f, role);
         readln(f, id);
         readln(f, dow);
         //writeln(name, ' ', role, ' ', id, ' ',dow);
      end;
   end;
   close(f);
end;
end;

procedure SaveRecord(Count : integer);
var
   i  : integer; f,g,h : text;
begin
   assign(f,directory + 'log\' + datetostr(date) + '.txt');
   rewrite(f);
   for i := 1 to count do
   begin
      if( member[i].statusMorn <> '') or (member[i].statusLunch <> '') or (member[i].statusAS <> '') then
      begin
         if member[i].shiftDateM = '' then
            member[i].shiftDateM := '/';
         if member[i].shiftDateL = '' then
            member[i].shiftDateL := '/';
         if member[i].shiftDateAS = '' then
            member[i].shiftDateAS := '/';

         if member[i].shiftoriginal = datetostr(date) then
            writeln(f, member[i].name + ' (Shift to ' + member[i].shiftDateM, ' ', member[i].shiftDateL, ' ', member[i].shiftDateAS, ')')
         else if member[i].shiftoriginal <> '' then
            writeln(f, member[i].name + ' (Shifted from ' + member[i].shiftDateM, ' ', member[i].shiftDateL, ' ', member[i].shiftDateAS,  ')')
         else writeln(f, member[i].name);
         writeln(f, member[i].statusMorn + ' ' + member[i].statusLunch + ' ' + member[i].statusAS);
         if member[i].shiftDateM = '/' then
            member[i].shiftDateM := '';
         if member[i].shiftDateL = '/' then
            member[i].shiftDateL := '';
         if member[i].shiftDateAS = '/' then
            member[i].shiftDateAS := '';
      end
   end;
   close(f);

   assign(g,directory + 'Shift.txt');
   rewrite(g);
   for i := 1 to count do
   begin
     if (member[i].shiftmorn = true) or (member[i].shiftLunch = true) or (member[i].shiftAS = true)  then
     begin
         writeln(g, member[i].name);
         writeln(g, member[i].shiftoriginal);
         //writeln(g, member[i].shiftday);
         //writeln(g, member[i].shiftslot);
         if member[i].shiftMorn = true then
            write(g, 'Morning ');
         if member[i].shiftLunch = true then
            write(g, 'Lunch ');
         if member[i].shiftAS = true then
            write(g, 'AS');
         writeln(g);
         //writeln(g, member[i].shiftFinal);
         if member[i].shiftDateM = '' then
            write(g, '/ ')
         else write(g, member[i].shiftDateM + ' ');
         if member[i].shiftDateL = '' then
            write(g, '/ ')
         else write(g, member[i].shiftDateL + ' ');
         if member[i].shiftDateAS = '' then
            write(g, '/')
         else write(g, member[i].shiftDateAS);
         writeln(g);
     end
   end;
   close(g);

   assign(h,directory + 'Warn.txt');
   rewrite(h);
   for i := 1 to count  do
      if (member[i].warnCount <> 0) then
         writeln(h, member[i].id, ' ', member[i].warncount);
   close(h);
   assign(h,directory + 'Late.txt');
   rewrite(h);
   for i := 1 to count  do
      if (member[i].lateCount <> 0) then
         writeln(h, member[i].id, ' ', member[i].latecount);
   close(h);
   assign(h,directory + 'ABS.txt');
   rewrite(h);
   writeln(h, datetostr(date));
   for i := 1 to count  do
      if (member[i].ABSCount <> 0) then
         writeln(h, member[i].id, ' ', member[i].ABScount);
   close(h);
end;

function period : string;
var
  Hour,Min,Sec,HSec : word;
begin
  GetTime(Hour,Min,Sec,HSec);
  period := '0';
  if (hour = 7) and (min <= 30) then
     period := '1a';
  if (hour = 7) and (min > 30) then
     period := '1b';
  if ((hour = 12) and (min >= 45)) or ((hour = 13) and (min <= 30)) then
     period := '2a';
  if (hour = 13) and (min > 30) then
     period := '2b';
  if (hour = 15) and (min <= 30) then
     period := '3a';
  if ((hour = 15) and (min > 30)) or (hour > 15) then
     period := '3b';
end;

procedure InitializeShift(count : integer);
var filename,a,o,s,fi : string;  i : integer;  g : text;
begin
   i := 0;
   filename := directory + 'Shift.txt';
   assign(f, filename);
   if not fileexists(filename) then
      rewrite(f)
   else
   begin
   reset(f);
   while not eof(f) do
   begin

      //inc(i);
      //with Member[count] do
      begin
         readln(f, a);
         //writeln(a);
         readln(f, O);
         //writeln(O);
         //readln(f, D);
         readln(f, S);
         //writeln(S);
         readln(f, Fi);
         //writeln(Fi);
         repeat
            i := i + 1;
         until (i = num+1) or (member[i].name = a);
         member[i].shiftoriginal := o;
         //member[i].shiftday := d;
         //member[i].shiftslot := s;
         if pos('Morning', S) <> 0 then
            member[i].shiftMorn := true;
         if pos('Lunch', S) <> 0 then
            member[i].shiftLunch := true;
         if pos('AS', S) <> 0 then
            member[i].shiftAS := true;
         if fi[1] = '/' then
            delete(fi,1,2)
         else
         begin
            member[i].shiftDateM := fi[1] + fi[2] + fi[3] + fi[4] + fi[5] + fi[6] + fi[7] + fi[8];
            delete(fi,1,9);
         end;
         if fi[1] = '/' then
            delete(fi,1,2)
         else
         begin
            member[i].shiftDateL := fi[1] + fi[2] + fi[3] + fi[4] + fi[5] + fi[6] + fi[7] + fi[8];
            delete(fi,1,9);
         end;
         if not (fi[1] = '/') then
            member[i].shiftDateAS := fi[1] + fi[2] + fi[3] + fi[4] + fi[5] + fi[6] + fi[7] + fi[8];
         //member[i].shiftfinal := fi;
      end;
   end;
   end;
   close(f);
   i := 1;
   while i < num + 1 do
   begin
      if member[i].shiftfinal = datetostr(calcDate(date, -1)) then
      begin
         member[i].shiftoriginal := '';
         //member[i].shiftday := '';
         //member[i].shiftslot := '';
         member[i].shiftMorn := false;
         member[i].shiftLunch := false;
         member[i].shiftAS := false;
         member[i].shiftDateM := '';
         member[i].shiftDateL := '';
         member[i].shiftDateAS := '';
      end;
      i := i +1;
   end;
   assign(g,directory + 'Shift.txt');
   rewrite(g);
   for i := 1 to count do
   begin
     if (member[i].shiftmorn = true) or (member[i].shiftLunch = true) or (member[i].shiftAS = true) then
     begin
         writeln(g, member[i].name);
         writeln(g, member[i].shiftoriginal);
         //writeln(g, member[i].shiftday);
         //writeln(g, member[i].shiftslot);

         if member[i].shiftMorn = true then
            write(g, 'Morning ');
         if member[i].shiftLunch = true then
            write(g, 'Lunch ');
         if member[i].shiftAS = true then
            write(g, 'AS');
         //writeln(g, member[i].shiftFinal);
         writeln(g);
         if member[i].shiftDateM = '' then
            write(g, '/ ')
         else write(g, member[i].shiftDateM + ' ');
         if member[i].shiftDateL = '' then
            write(g, '/ ')
         else write(g, member[i].shiftDateL + ' ');
         if member[i].shiftDateAS = '' then
            write(g, '/')
         else write(g, member[i].shiftDateAS);
         writeln(g);

     end;
   end;
   close(g);
end;

procedure initializeHoliday(var i : integer);
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
end;

procedure initializeLate;
var i,idval,code : integer; filename,st,idstr : string; f : text;
begin
   filename := directory + 'Late.txt';
   assign(f, filename);
   if not fileexists(filename) then
      rewrite(f)
   else
   begin
      reset(f);
      while not eof(f) do
      begin
        readln(f, st);
        idstr := st[1] + st[2];
        delete(st, 1, 3);
        i := 1;
        while member[i].id <> idstr do
        begin
           i := i + 1;
        end;
        val(st, member[i].latecount, code);
      end;
   end;
   close(f);
end;

procedure initializeABS;
var i,idval,code,j,s1,s2 : integer; filename,st,idstr,date_,n,a : string; f : text;
begin
   filename := directory + 'ABS.txt';
   assign(f, filename);
   if not fileexists(filename) then
      rewrite(f)
   else
   begin
      reset(f);
      readln(f, date_);
      while not eof(f) do
      begin
        readln(f, st);
        idstr := st[1] + st[2];
        delete(st, 1, 3);
        i := 1;
        while member[i].id <> idstr do
        begin
           i := i + 1;
        end;
        val(st, member[i].abscount, code);
      end;
   end;
   close(f);
   if (date_ <> datetostr(date)) and fileexists(directory + 'log\' + datetostr(date - 1) + '.txt') then
   begin
      assign(f,directory + 'log\' + datetostr(date - 1) + '.txt');
      reset(f);
      while not eof(f) do
      begin
         readln(f, n);
         readln(f, a);
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
         if copy(a, 1, s1-1) = 'ABS' then
            inc(member[i].abscount);
         if copy(a, s1+1, s2- 1 - s1) = 'ABS' then
            inc(member[i].abscount);
         if copy(a, s2+1, length(a) - s2) = 'ABS' then
            inc(member[i].abscount);
      end;
   close(f);
   end;
end;

procedure initializeWarn;
var i,code : integer; filename,st,idstr : string; f : text;
begin
   filename := directory + 'Warn.txt';
   assign(f, filename);
   if not fileexists(filename) then
      rewrite(f)
   else
   begin
      reset(f);
      while not eof(f) do
      begin
        readln(f, st);
        idstr := st[1] + st[2];
        delete(st, 1, 3);
        i := 1;
        while member[i].id <> idstr do
        begin
           i := i + 1;
        end;
        val(st, member[i].warncount, code);
      end;
   end;
   close(f);
end;

procedure genabs(num : integer);
var f : text; i : integer;
begin
   //writeln('herer');
   assign(f,directory + 'log\' + datetostr(date) + '.txt');
   rewrite(f);
   //writeln(num);
   for i := 1 to num do
   begin
   //writeln('here');
   //writeln(getDOWid(member[i].dow));
      if getDOWid(member[i].dow) = dayofWeek(Date) then
      begin
         //writeln(member[i].name);
         member[i].statusMorn := 'ABS';
         member[i].statusLunch := 'ABS';
         member[i].statusAS := 'ABS';
         writeln(f, member[i].name);
         writeln(f, member[i].statusMorn + ' ' + member[i].statusLunch + ' ' + member[i].statusAS);
      end
   end;
   close(f);
end;

procedure readstatus();
var i,s1,s2,j : integer; f : text; a,n: string;
begin
   assign(f,directory + 'log\' + datetostr(date) + '.txt');
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
      member[i].statusMorn := copy(a, 1, s1-1);
      member[i].statusLunch := copy(a, s1+1, s2- 1 - s1);
      member[i].statusAS := copy(a, s2+1, length(a) - s2);
   end;
   close(f);
end;

procedure checkin(a : string);
var i : integer; val1,val2 : integer; YN : char; shiftcheck: boolean;
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
   shiftcheck := false;
   if (period = '1a') or (period = '1b') then
      if member[i].shiftMorn then
         shiftcheck := true;
   if (period = '2a') or (period = '2b') then
      if member[i].shiftLunch then
         shiftcheck := true;
   if (period = '3a') or (period = '3b') then
      if member[i].shiftAS then
         shiftcheck := true;



   if (member[i].dow <> getDOW(dayofweek(Date))) and ((member[i].shiftDateM <> datetostr(date)) and (member[i].shiftDateL <> datetostr(date)) and (member[i].shiftDateAS <> datetostr(date))) then
   begin
      Error(2);
      exit;
   end;
   if (member[i].dow <> getDOW(dayofweek(Date))) and (not shiftcheck) then
   begin
      Error(2);
      exit;
   end;

   if period = '0' then
   begin
      Error(3);
      exit;
   end
   else
   begin

      writeln('You are about to check-in as ', member[i].name, '.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
      begin
      if period = '1a' then
          member[i].statusMorn := 'Present(' + time_ + ')'
      else if period = '1b' then
      begin
         member[i].statusMorn := 'Late(' + time_ + ')';
         inc(member[i].LateCount);
      end
      else if period = '2a' then
         member[i].statusLunch := 'Present(' + time_ + ')'
      else if period = '2b' then
      begin
         inc(member[i].LateCount);
         member[i].statusLunch := 'Late(' + time_ + ')';
      end
      else if period = '3a' then
         member[i].statusAS := 'Present(' + time_ + ')'
      else if period = '3b' then
      begin
         inc(member[i].LateCount);
         member[i].statusAS := 'Late(' + time_ + ')';
      end;
      if member[i].statusMorn = '' then
         member[i].statusMorn := '/';
      if member[i].statusLunch = '' then
         member[i].statusLunch := '/';
      if member[i].statusAS = '' then
         member[i].statusAS := '/';
      if (period = '1a') or (period = '1b') then
      begin
         member[i].shiftMorn := false;
         member[i].shiftDateM := '';
      end
      else if (period = '2a') or (period = '2b') then
      begin
         member[i].shiftLunch := false;
         member[i].shiftDateL := '';
      end
      else
      begin
         member[i].shiftAS := false;
         member[i].shiftDateAS := '';
      end;
      if (member[i].shiftMorn) and (member[i].shiftLunch) and (member[i].shiftAS) then
         member[i].shiftoriginal := '';


      saverecord(num);


      writeln('Command Executed.');
      end
      else writeln('Command Cancelled.');
         YN := ' ';
   end;
end;

procedure admin;
var 
  n: string;
begin 
  if user = 'user' then
  begin
     Write('*>');
     TextColor(black);
     ReadLn(n);
     if n = 'gilbert1415' then
     begin
        user := 'admin';
        adminmode := true;
        TextColor(7);
     end
     else
     begin
        TextColor(7);
        Error(4);
        admin;
     end;
  end
  else writeln('You are already in Admin account.');
end;


procedure del(a : string);
var cmd,i,val1,val2,code : integer; yn:char; cmdstr : string;
begin
   i := 0;
   repeat
      i := i + 1;
      val(member[i].id, val1);
      val(a, val2);
   until (val1 = val2) or (i = num+1);
  // writeln(member[i].statusMorn);
   if (member[i].id = '') or (member[i].statusMorn = '') then
   begin
      Error(1);
      exit;
   end;
   writeln;
   writeln('Enter the following number for corresponding action:');
   writeln('1. Reset Morning''s Record of Today');
   writeln('2. Reset Lunch''s Record of Today');
   writeln('3. Reset After''s School Record of Today');
   writeln('4. Reset Whole Day''s Record of Today');
   writeln('For any other deletion, please do them by editing the file(s).');
   write(user, '>');
   readln(cmdstr);
   val(cmdstr, cmd, code);
   while code <> 0 do
   begin
      Error(5);
      exit;
   end;



   if cmd = 1 then
   begin
      writeln('You are about to delete ', member[i].name, '''s morning record.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].statusMorn := 'ABS';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else if cmd = 2 then
   begin
      writeln('You are about to delete ', member[i].name, '''s lunch record.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].statusLunch := 'ABS';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else if cmd = 3 then
   begin
      writeln('You are about to delete ', member[i].name, '''s after school record.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].statusAS := 'ABS';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else if cmd = 4 then
   begin
      writeln('You are about to delete ', member[i].name, '''s whole day records.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].statusMorn := 'ABS';
            member[i].statusLunch := 'ABS';
            member[i].statusAS := 'ABS';
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
      Error(5);
      exit;
   end;
   saverecord(num);
end;

procedure rl(a : string);
var cmd,i,val1,val2,code : integer; yn:char;  cmdstr: string;
begin
   i := 0;
   repeat
      i := i + 1;
      val(member[i].id, val1);
      val(a, val2);
   until (val1 = val2) or (i = num+1);
   if (member[i].id = '') or (member[i].statusMorn = '') then
   begin
      Error(1);
      exit;
   end;
   writeln;
   writeln('Enter the following number for corresponding action:');
   writeln('1. Change Morning Record''s of Today to ''N/A''');
   writeln('2. Change Lunch Record''s of Today to ''N/A''');
   writeln('3. Change After School''s Record of Today to ''N/A''');
   writeln('4. Change Whole Day''s Record of Today to ''N/A''');
   write(user, '>');
   readln(cmdstr);
   val(cmdstr, cmd, code);
   while code <> 0 do
   begin
      Error(5);
      exit;
   end;

   if cmd = 2 then
   begin
      writeln('You are about to change ', member[i].name, '''s lunch record to ''N/A''.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].statusLunch := 'N/A';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else if cmd = 3 then
   begin
      writeln('You are about to change ', member[i].name, '''s after school record to ''N/A''.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].statusAS := 'N/A';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else if cmd = 4 then
   begin
      writeln('You are about to change ', member[i].name, '''s whole day records to ''N/A''.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].statusMorn := 'N/A';
            member[i].statusLunch := 'N/A';
            member[i].statusAS := 'N/A';
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else
   if cmd = 1 then
   begin
      writeln('You are about to change ', member[i].name, '''s morning record to ''N/A''');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].statusMorn := 'N/A';
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
      Error(5);
      exit;
   end;
   saverecord(num);
end;

function getFinalDate(shiftto, weekvar : integer) : string;
var YY,MM,DD : Word; temp : TDateTime;
begin
   if weekvar = 2 then
      temp := calcDate( calcDate(date, 7), 0 - dayofweek(Date) + 1 + shiftto)
   else temp := calcDate(date, shiftto - (dayofweek(Date) - 1));
   DecodeDate(temp, YY, MM, DD);
   getFinalDate := L0(yy) + L0(mm) + L0(dd);
end;

function getNextDutyDate(i : integer) : string;
begin
   //writeln(datetostr(date));
   if member[i].shiftOriginal = '' then
   begin
      if getDOWID(member[i].dow) >= DayOfWeek(Date) then
         getNextDutyDate := datetostr(date + getDOWID(member[i].dow) - dayofweek(date) )
      else getNextDutyDate := datetostr(date + 7 + getDOWID(member[i].dow) - dayofweek(date));
   end
   else
      getNextDutyDate := member[i].shiftOriginal;
end;

procedure shift(a : string);
var cmd,i,val1,val2,input1,input2,j,code : integer; yn:char; input1str,input2str,cmdstr : string;
begin
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
   writeln('Enter the following number to change duty to the corresponding day:');
   writeln('1. Monday');
   writeln('2. Tuesday');
   writeln('3. Wednesday');
   writeln('4. Thursday');
   writeln('5. Friday');
   write(user, '>');
   readln(input1str);
   val(input1str, input1, code);
   while code <> 0 do
   begin
      Error(5);
      exit;
   end;

   input2 := 2;
  // writeln((getDOW(input1 + 1) < member[i].dow));
   if getDOW(input1 + 1) = member[i].dow then
   begin
      Error(6);
      exit;
   end
   else if {(input1 + 1 < getDOWID(member[i].dow)) and} (dayofweek(Date) <= input1 + 1) then
   begin
      writeln('Enter the following number to execute corresponding command:');
      writeln('1. Change Duty to This Week.');
      writeln('2. Change Duty to Next Week.');
      write(user, '>');
      readln(input2str);
      val(input2str, input2, code);
      while code <> 0 do
      begin
         Error(5);
         exit;
      end;

      if (input2 <> 1) and (input2 <> 2) then
      begin
         Error(5);
         exit;
      end;
      j := 1;
      while dates[j] <> '' do
      begin
         if getfinaldate(input1, input2) = dates[j] then
         begin
            Error(7);
            exit;
         end;
         j := j + 1;
      end;
   end;

   writeln;
   writeln('Enter the following number for corresponding action:');
   writeln('1. Swap Lunch''s Duty');
   writeln('2. Swap After School''s Duty');
   writeln('3. Swap Whole Day''s Duty');
   write(user, '>');
   readln(cmdstr);
   val(cmdstr, cmd, code);
   while code <> 0 do
   begin
      Error(5);
      exit;
   end;

   if cmd = 1 then
   begin
      writeln('You are about to shift ', member[i].name, '''s lunch duty from ', member[i].dow,' to ', getDOW(input1 + 1), '.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].shiftOriginal := getNextDutyDate(i);
            //member[i].shiftDay := getDOW(input1 + 1);
            //member[i].shiftslot := 'Lunch';
            member[i].shiftLunch := true;
            member[i].statusLunch := 'N/A';
            //member[i].shiftFinal := getfinaldate(input1, input2);
            member[i].shiftDateL := getfinaldate(input1, input2);
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else if cmd = 2 then
   begin
      writeln('You are about to shift ', member[i].name, '''s after school duty from ', member[i].dow,' to ', getDOW(input1 + 1), '.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].shiftOriginal := getNextDutyDate(i);
            //member[i].shiftDay := getDOW(input1 + 1);
            //member[i].shiftslot := 'Afterschool';
            member[i].shiftAS := true;
            member[i].statusAS := 'N/A';
           // member[i].shiftFinal := getfinaldate(input1, input2);
            member[i].shiftDateAS := getfinaldate(input1, input2);
            writeln('Command Executed.');
         end
         else
         begin
            writeln('Command Cancelled.');
            exit;
         end;
   end
   else if cmd = 3 then
   begin
      writeln('You are about to shift ', member[i].name, '''s whole day duty from ', member[i].dow,' to ', getDOW(input1 + 1), '.');
      writeln('Confirm? [Y/N]');
      YN := readkey;
      if (YN = 'Y') or (YN = 'y') then
         begin
            member[i].shiftOriginal := getNextDutyDate(i);
            //member[i].shiftDay := getDOW(input1 + 1);


            member[i].shiftslot := 'All';
            member[i].shiftMorn := true;
            member[i].statusMorn := 'N/A';
            member[i].shiftLunch := true;
            member[i].statusLunch := 'N/A';
            member[i].shiftAS := true;
            member[i].statusAS := 'N/A';
            //member[i].shiftFinal := getfinaldate(input1, input2);
            member[i].shiftDateM := getfinaldate(input1, input2);
            member[i].shiftDateL := getfinaldate(input1, input2);
            member[i].shiftDateAS := getfinaldate(input1, input2);
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
      Error(5);
      exit;
   end;
   saverecord(num);
end;

procedure help(a : string);
begin
   if a = '' then
   begin
      //if not adminmode then
      begin
         writeln('Here are the commands available:');
         writeln('ABOUT');
         writeln('CHECKIN');
         writeln('CLS');
         writeln('DEL');
         writeln('EDIT');
         writeln('EXIT');
         writeln('GEN');
         writeln('HELP');
         writeln('LIST');
         writeln('LISTALL');
         writeln('RELOAD');
         writeln('RL');
         writeln('SHIFT');
         writeln('WARN');
         writeln('UNWARN');
         writeln('Type help <command> to get the usage of the specific command.');
      end{;
      else
      begin
         writeln('Here are the commands available:');
         writeln('ABOUT');
         writeln('CHECKIN');
         writeln('CLS');
         writeln('EXIT');
         writeln('HELP');
         writeln('LIST');
         writeln('Type help <command> to get the usage of the specific command.');
      end;}
   end
   else
   if upcase(a) = 'CHECKIN' then
   begin
      writeln('checkin');
      writeln('Log the Duty Record.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>checkin <id>');
      writeln('   id - The ID of the specific member.');
   end
   else
   if (upcase(a) = 'RELOAD'){ and (adminmode)} then
   begin
      writeln('reload');
      writeln('Reload the stored data.');
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
   if (upcase(a) = 'RL') {and (adminmode)} then
   begin
      writeln('rl');
      writeln('Mark any duty status of today as ''N/A''');
      writeln;
      writeln('USAGE:');
      writeln(user,'>rl <id>');
      writeln('   id - The ID of the specific member.');
      writeln('And follow the instructions afterwards.');
   end
   else
   if (upcase(a) = 'DEL') {and (adminmode)} then
   begin
      writeln('del');
      writeln('Mark any duty status of today as ''ABS''.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>del <id>');
      writeln('   id - The ID of the specific member.');
      writeln('And follow the instructions afterwards.');
   end
   else
   if (upcase(a) = 'SHIFT') {and (adminmode)} then
   begin
      writeln('shift');
      writeln('Shift any duty');
      writeln;
      writeln('USAGE:');
      writeln(user,'>shift <id>');
      writeln('   id - The ID of the specific member.');
      writeln('And follow the instructions afterwards.');
   end
   else
   if upcase(a) = 'LIST' then
   begin
      writeln('list');
      writeln('List out all members on duty today.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>list');
   end
   else
   if (upcase(a) = 'LISTALL') {and (adminmode)} then
   begin
      writeln('listall');
      writeln('List out all members in record.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>listall');
   end
   else
   if upcase(a) = 'ABOUT' then
   begin
      writeln('about');
      writeln('Print out the information about this program.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>about');
   end
   else
   if upcase(a) = 'HELP' then
   begin
      writeln('help');
      writeln('Provide help on commands in this program.');
      writeln;
      writeln('USAGE:');
      writeln(user,'>help <command>');
      writeln('   command - command in this program');
   end
   else
   if upcase(a) = 'EXIT' then
   begin
      writeln('exit');
      writeln('Exit the program.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>exit');
   end
   else if (upcase(a) = 'EDIT') {and (adminmode)} then
   begin
      writeln('edit');
      writeln('Edit Specific Records by Using I/O SubProgram Designed.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>edit <record_name>');
      writeln('   record_name - record name you want to edit');
   end
   else if (upcase(a) = 'GEN') {and (adminmode)} then
   begin
      writeln('gen');
      writeln('Generate List of Specific Record');
      writeln;
      writeln('USAGE:');
      writeln(user, '>gen <record_name>');
      writeln('   record_name - record name you want to edit');
   end
   else if (upcase(a) = 'WARN') {and (adminmode)} then
   begin
      writeln('warn');
      writeln('Warn Specific Member.');
      writeln;
      writeln('USAGE:');
      writeln(user, '>warn <id>');
      writeln('   id - The ID of the specific member.');
   end
   else if (upcase(a) = 'UNWARN') {and (adminmode)} then
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
   adminmode := false;
   //user := 'user';
   user := '';
   //writeln('Check-In Program ',devphase,' v', version:0:2, ' by PT');
  // writeln('Please Enter the Password:');
   //admin;
   //clrscr;
   If Not DirectoryExists(directory + 'log') then
      createdir(directory + 'log');
   writeln('Check-In Program ',devphase,' v', version:0:2, ' by PT');
   initializemember(num);
   initializeshift(num);
   initializeholiday(numh);
   initializeLate;
   initializeABS;
   initializeWarn;
   //writeln(fileexists(directory + 'log\' + datetostr(date) + '.txt'));
   if not fileexists(directory + 'log\' + datetostr(date) + '.txt') then
      genabs(num)
   else readstatus();
   saverecord(num);
   writeln('Enter your command.');
end;

procedure editFile(st : string);
begin
   delete(st, 1, 5);
   if upcase(st) = 'MEMBER' then
   begin
      If FileExists(directory + 'member.exe') then
      begin
         writeln('Please Exit to Return to the Main Program.');
         exec(directory + 'Member.exe', '');
      end
      else
      begin
        error(11);
        exit;
      end;
   end
   else if upcase(st) = 'HOLIDAY' then
   begin
      If FileExists(directory + 'holiday.exe') then
      begin
         writeln('Please Exit to Return to the Main Program.');
         exec(directory + 'holiday.exe', '');
      end
      else
      begin
        error(11);
        exit;
      end;
   end
   else Error(9);
end;

procedure warn(st: string; mode: integer);
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
   if (mode = -1) and (member[i].warnCount = 0) then
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
         inc(member[i].warncount)
      else if mode = -1 then
         dec(member[i].warncount);
       writeln('Command Executed.')
   end
   else writeln('Command Cancelled.');
   YN := ' ';
   saverecord(num);
end;

procedure gen(st : string);
var i : integer;
begin
   delete(st, 1, 4);
   if (upcase(st) <> 'LATE') and (upcase(st) <> 'ABS') and (upcase(st) <> 'WARN') then
   begin
      error(1);
      exit;
   end;
   writeln('ID':30, '   ', 'COUNT');
   for i := 1 to num do
   begin
      if (upcase(st) = 'LATE') and (member[i].latecount <> 0) then
      begin
         write(member[i].id:30,'   ');
         writeln(member[i].latecount);
      end
      else if (upcase(st) = 'ABS') and (member[i].abscount <> 0) then
      begin
         write(member[i].id:30,'   ');
         writeln(member[i].ABScount)
      end
      else if (upcase(st) = 'WARN') and (member[i].WarnCount <> 0) then
      begin
         write(member[i].id:30,'   ');
         writeln(member[i].WarnCount);
      end;
   end;
end;

procedure readcmd(st : string);
var cmd: string; i : integer;
begin
   if (copy(st, 1, 7) = 'checkin') and (st[8] = ' ') then
         checkin(copy(st, 9, 2))
   else if copy(st, 1, 6) = 'reload' {and (adminmode = true)} then
   begin
      writeln('Reloading...');
      start;
   end
  { else if copy(st, 1, 5) = 'admin' then
      admin  }
   else if (copy(st, 1, 3) = 'cls') and (length(st) = 3) then
   begin
      ClrScr;
      writeln('Check-In Program ',devphase,' v', version:0:2, ' by PT');
      writeln('Enter your command.');
   end
   else if (copy(st, 1, 2) = 'rl')  {and (adminmode = true)} then
      rl(copy(st, 4, 2))
   else if (copy(st, 1, 3) = 'del')  {and (adminmode = true)} then
      del(copy(st, 5, 2))
   {else if (copy(st, 1, 6) = 'logout') and (adminmode = true) then
   begin
      adminmode := false;
      user := 'user';
      clrscr;
   end}
   else if (copy(st, 1, 5) = 'shift')  {and (adminmode = true)}then
      shift(copy(st, 7, 2))
   else if (copy(st, 1, 7) = 'listall') and (length(st) = 7) then
   begin
      writeln('Name':30, '   ', 'ID', '   ', 'Day On Duty');
      for i := 1 to num do
          writeln(member[i].name:30 ,'   ',member[i].id,'   ', member[i].dow);
   end
   else if (copy(st, 1, 4) = 'list') and (length(st) = 4) then
   begin
      writeln('Name':30, '   ', 'ID');
      for i := 1 to num do
      begin
         if (getDOWid(member[i].dow) = dayofweek(date)) or (member[i].shiftFinal = datetostr(date)) then
            writeln(member[i].name:30, '   ', member[i].id);
      end
   end
   else if (copy(st, 1, 4) = 'help') and ((length(st) = 4) or (st[5] = ' ')) then
      help(copy(st, 6, length(st)))
   else if (copy(st, 1, 5) = 'about') and (length(st) = 5) {and (adminmode)}  then
   begin
      writeln;
      writeln('This program is created by Tse Ho Nam in 2014,');
      writeln('with current version ', devphase, ' v', version:0:2,'.');
      writeln('This program is designed for SFXC LST, and');
      writeln('do not work fine in any other circumstances.');
      writeln('Please inform the current program source holder for any bug,');
      writeln('or for the source if necessary.');
      writeln('                                                    PT, 2014');
      writeln;
   end
   else if (copy(st, 1, 4) = 'exit') and (length(st) = 4) then
      halt
   else if (copy(st, 1, 4) = 'edit') {and (adminmode)} then
   begin
      editfile(st);
      writeln('Reloading...');
      start;
   end
   else if (copy(st, 1, 4) = 'warn') {and (adminmode)} then
      warn(st, 1)
   else if (copy(st, 1, 6) = 'unwarn') {and (adminmode)} then
      warn(st, -1)
   else if (copy(st, 1, 3) = 'gen') {and (adminmode)} then
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
   writeln('Initializing...');
   start;
  {for i := 1 to num do
   begin
      writeln(member[i].name);
      writeln(member[i].id);
   end;}
   while true do
   begin
      write(user,'>');
      readln(cmd);
      readcmd(cmd);
   end;
end.
