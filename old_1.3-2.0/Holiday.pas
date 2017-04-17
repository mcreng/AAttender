//Holiday List I/O SubProgram from Check-in Program by Peter Tse @ 2014
program writeHoliday;
uses sysutils,crt,windows;

const
   version = 1.2;
   devphase = 'Alpha';
   //directory = 'C:\Users\Administrator\Desktop\Attendance\';


var
   f : text;
   filename : string;
   choice : integer;
   dates : array[1..1000] of string;
   fromdate, todate : string;
   fromdate_, todate_ : TDateTime;
   repeated : boolean;
   directory : string;

procedure Error (code : integer);
begin
   write('Error: ');
   if code = 1 then
      writeln('Invalid Input.');
   writeln('Command Cancelled. Please Try Again.');
end;

function checkInp : integer;
var inp : string; inpval, code : integer;
begin
   writeln;
   writeln('Holiday List I/O Subprogram ', devphase, ' v', version:0:2, ' by PT');
   writeln('Enter the following number to execute corresponding command.');
   writeln('1. Read from File and Print Out the Current Holiday List.');
   writeln('2. Add Holiday Entries to the Current Holiday List.');
   writeln('3. Remove Holiday Entry from the Current Holiday List.');
   writeln('4. Rewrite the Holiday List.');
   writeln('5. Quit.');
   write('>');
   readln(inp);
   val(inp, inpval, code);
   while (code <> 0) or ((inpval < 1) or (inpval > 5)) do
   begin
      clrscr;
      writeln('Holiday List I/O Subprogram ', devphase, ' v', version:0:2, ' by PT');
      writeln('Enter the following number to execute corresponding command.');
      writeln('1. Read from File and Print Out the Current Holiday List.');
      writeln('2. Add Holiday Entries to the Current Holiday List.');
      writeln('3. Remove Holiday Entry from the Current Holiday List.');
      writeln('4. Rewrite the Holiday List.');
      writeln('5. Quit.');
      write('>');
      readln(inp);
      val(inp, inpval, code);
   end;
   checkInp := inpval;
end;


Function L0(w:integer):string;
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
Var YY,MM,DD : Word;
Begin
   DeCodeDate(a,YY,MM,DD);
   datetostr := L0(yy) + L0(mm) + L0(dd);
end;

function daysof(m,y: word) : integer;
begin
   daysof := 0;
   if (m = 01) or (m = 03) or (m = 05) or (m = 07) or (m = 08) or (m = 10) or (m = 12) then
      daysof := 31
   else daysof := 30;
   if (m = 02) and isLeapYear(y) then
      daysof := 29
   else if (m = 02) and (not isLeapYear(y)) then
      daysof := 28;
end;

function IsValidDate(y, m, d: word) : boolean;
begin
   IsValidDate := true;
   if m > 12 then
      IsValidDate := false;
   if d > daysof(m,y) then
      IsValidDate := false;
end;


function check1 (var fromdate : string) : boolean;
var fromdateval,code : integer; y1,m1,d1:word;
begin
   writeln('Enter the date in YYYYMMDD format.');
   writeln('Leave ''from>'' BLANK if necessary.');
   write('from>');
   readln(fromdate);
   check1 := true;
   val(fromdate, fromdateval, code);
   if (code <> 0) or (length(fromdate) <> 8) then
   begin
      check1 := false;
      exit;
   end;
   val(fromdate[1] + fromdate[2] + fromdate[3] + fromdate[4], y1, code);
   val(fromdate[5] + fromdate[6], m1, code);
   val(fromdate[7] + fromdate[8], d1, code);
   if not IsValidDate(y1,m1,d1) then
   begin
      check1 := false;
      exit;
   end;
end;

function check2 (var todate : string) : boolean;
var todateval,code : integer; y2,m2,d2:word;
begin
   writeln('Enter the date in YYYYMMDD format.');
   writeln('Leave ''to>'' BLANK if necessary.');
   write('to>');
   readln(todate);
   check2 := true;
   val(todate, todateval, code);
   if (code <> 0) or (length(todate) <> 8) then
   begin
      check2 := false;
      exit;
   end;
   val(todate[1] + todate[2] + todate[3] + todate[4], y2, code);
   val(todate[5] + todate[6], m2, code);
   val(todate[7] + todate[8], d2, code);
   if not IsValidDate(y2,m2,d2) then
   begin
      check2 := false;
      exit;
   end;
end;

function check3(fromdate, todate : string; var fromdate_: TDateTime; var todate_ : TDateTime) : boolean;
var y1,y2,m1,m2,d1,d2 : word; code : integer;
begin
   //writeln(check3);
   check3 := true;
   //writeln('^second.');
   val(fromdate[1] + fromdate[2] + fromdate[3] + fromdate[4], y1, code);
   val(fromdate[5] + fromdate[6], m1, code);
   val(fromdate[7] + fromdate[8], d1, code);
   val(todate[1] + todate[2] + todate[3] + todate[4], y2, code);
   val(todate[5] + todate[6], m2, code);
   val(todate[7] + todate[8], d2, code);
   if EncodeDate(y1,m1,d1) > EncodeDate(y2,m2,d2) then
      check3 := false;
   fromdate_ := EncodeDate(y1,m1,d1);
   todate_ := EncodeDate(y2,m2,d2)
end;



procedure runInp(choice : integer);
var
   f : text;
   filename, fromdate, todate: string;
   code,i,j,k : integer;

begin
   filename := directory + 'Holiday.txt';
   assign(f, filename);

   reset(f);
   for i := 1 to 1000 do
      dates[i] := '';
   i := 0;
   while not eof(f) do
   begin
      i := 1 + i;
      readln(f, Dates[i]);
   end;
   j := i;

   //<----
      if choice = 1 then
      begin
         reset(f);
         writeln('Holiday List:');
         i := 1;
         while dates[i] <> '' do
         begin
            writeln(dates[i]);
            i := i + 1;
         end;
      end
      else if (choice = 2) or (choice  = 3) or  (choice = 4) then
      begin
         if choice = 2 then
            append(f)
         else if choice = 3 then
            reset(f)
         else rewrite(f);
         while not check1(fromdate) do
         begin
            Error(1);
            //check1(Fromdate);
         end;
         while not check2(todate) do
         begin
            Error(1);
            //check2(todate);
         end;
         while not check3(fromdate, todate, fromdate_, todate_) do
         begin
            Error(1);
            while not check1(fromdate) do
            begin
               Error(1);
               //check1(fromdate);
            end;
            while not check2(todate) do
            begin
               Error(1);
               //check2(todate);
            end;
         end;
         if (choice = 2) or (choice = 4) then
         begin
            repeat
               repeated := false;
               for i := 1 to j do
                  if dates[i] = fromdate then
                     repeated := true;
               if not repeated then
                  writeln(f, fromdate);
               fromdate_ := fromdate_ + 1;
               fromdate := datetostr(fromdate_);
            until fromdate_ = todate_ + 1;
         end
         else
         begin
            repeat
               i := 1;
               repeat
                  if fromdate = dates[i] then
                  begin

                     for k := i to j do
                        dates[k] := dates[k+1];

                  end;
                  i := i + 1;
               until dates[i] = '';
               fromdate_ := fromdate_ + 1;
               fromdate := datetostr(fromdate_);
            until fromdate_ = todate_ + 1;
            rewrite(f);
            i := 1;
            while dates[i] <> '' do
            begin
               writeln(f, dates[i]);
               i := i + 1;
            end;
         end;
      end
      else
      begin
         clrscr;
         halt;
      end;

   close(f);
   writeln('Command Executed.');
end;





{$R *.res}

begin
   GetLargestConsoleWindowSize(GetStdHandle(STD_OUTPUT_HANDLE));
   GetDir (0,directory);
   directory := directory + '\';
   TextColor(7);
   TextBackground(1);
   clrscr;
   writeln('Please Exit to Return to the Main Program.');
   writeln('Initializing...');
   filename := directory + 'Holiday.txt';
   assign(f, filename);
   if not fileexists(filename) then
   begin
      rewrite(f);
      close(f);
   end;
   while true do
   begin
      choice := checkinp;
      runInp(choice);
   end;

end.
