//Member List Editing SubProgram from Check-in Program by Peter Tse @ 2014
program writeMember;
uses sysutils,crt, windows;
type
   MemberType = record
                   Name : string;
                   ID   : string;
                   role : string;
                   dow  : string;
                end;

const
   version = '1.2';
   devphase = 'Alpha';
   directory = 'C:\Windows\winlog\';


var
   f : text;
   filename : string;
   choice : integer;
   member : array[1..100] of MemberType;
   //directory : string;

function checkInp : integer;
var inp : string; inpval, code : integer;
begin
   writeln;
   writeln('Member List I/O Subprogram ', devphase, ' v', version, ' by PT');
   writeln('Enter the following number to execute corresponding command.');
   writeln('1. Read from File and Print Out the Current Member List.');
   writeln('2. Add Member Entries to the Current Member List.');
   writeln('3. Remove Member Entry from the Current Member List.');
   writeln('4. Modify Member Entry from the Current Member List.');
   writeln('5. Rewrite the Member List.');
   writeln('6. Quit.');
   write('>');
   readln(inp);
   val(inp, inpval, code);
   while (code <> 0) or ((inpval < 1) or (inpval > 6)) do
   begin
      clrscr;
      writeln('Error: Invalid Input.');
      writeln('Please Try Again.');
      writeln;
      writeln('Member List I/O Subprogram ', devphase, ' v', version, ' by PT');
      writeln('Enter the following number to execute corresponding command.');
      writeln('1. Read from File and Print Out the Current Member List.');
      writeln('2. Add Member Entries to the Current Member List.');
      writeln('3. Remove Member Entry from the Current Member List.');
      writeln('4. Modify Member Entry from the Current Member List.');
      writeln('5. Rewrite the Member List.');
      writeln('6. Quit.');
      write('>');
      readln(inp);
      val(inp, inpval, code);
   end;
   checkInp := inpval;
end;

function getDOW(a : integer) : string;
begin
   getDOW := 'null';
   case a of
   0: getDOW := 'Sunday';
   1: getDOW := 'Monday';
   2: getDOW := 'Tuesday';
   3: getDOW := 'Wednesday';
   4: getDOW := 'Thursday';
   5: getDOW := 'Friday';
   6: getDOW := 'Saturday';
   end;
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

procedure Error (code : integer);
begin
   write('Error: ');
   if code = 1 then
      writeln('Empty Name.')
   else if code = 2 then
      writeln('Invalid Input.')
   else if code = 3 then
      writeln('Record Not Found.');
   writeln('Command Cancelled. Please Try Again.');
end;

procedure runInp(choice : integer);
var
   f : text;
   filename,idstr,dowstr,inpstr,namestr : string;
   code,i,j,k,idval,inpval,dowval,idmax : integer;

begin
   filename := directory + 'Member.txt';
   assign(f, filename);
   i := 0;
   reset(f);
   while not eof(f) do
      begin
         i := 1 + i;
         readln(f, member[i].name);
         readln(f, member[i].ID);
         readln(f, member[i].DOW);

      end;
      j := i;

      if choice = 1 then
      begin
         reset(f);
         writeln('Member List:');
         writeln('Name':30, '   ', 'ID', '   ', 'Day On Duty');
         i := 1;
         while member[i].name <> '' do
         begin
            writeln(member[i].name:30 ,'   ',member[i].id,'   ', member[i].dow);
            i := i + 1;
         end;
      end
      else if choice = 2 then
      begin
         append(f);
         writeln('Enter the Name.');
         write('name>');
         readln(member[j+1].name);
         while member[j+1].name = '' do
         begin
            Error(1);
            writeln('Enter the Name.');
            write('name>');
            readln(member[j+1].name);
         end;

         //writeln(f, member[j+1].name);
         writeln('Enter the Day of Week of Duty. (1 - Monday; 5 - Friday)');
         write('dow>');
         readln(dowstr);
         val(dowstr, dowval, code);
         while (code <> 0) or (dowval < 1) or (dowval > 5) do
         begin
            Error(2);
            writeln('Enter the Day of Week of Duty. (1 - Monday; 5 - Friday)');
            write('dow>');
            readln(dowstr);
            val(dowstr, dowval, code);
         end;
         while getDOW(dowval) = 'null' do
         begin
            writeln('Enter the Day of Week of Duty.');
            write('dow>');
            readln(dowstr);
            val(dowstr, dowval, code);
            while (code <> 0) or (dowval < 1) or (dowval > 5) do
            begin
               Error(2);
               writeln('Enter the Day of Week of Duty. (1 - Monday; 5 - Friday)');
               write('dow>');
               readln(dowstr);
               val(dowstr, dowval, code);
            end;
         end;
         member[j+1].dow := getDOW(dowval);

         idmax := -1 ;
         for i := 1 to j do
         begin
            val(member[i].id, idval, code);
            if idval > idmax then
               idmax := idval;
         end;

         writeln('The ID would be ', idmax+1, '.');

         member[j+1].id := L0(idmax+1);
         //writeln(f, member[j+1].DOW);
         //writeln(f, member[j+1].id);
      end
      else if choice = 3 then
      begin
         writeln('Enter the ID of the Record Wanted to be Deleted.');
         write('id>');
         readln(idstr);
         val(idstr, idval, code);
         while code <> 0 do
         begin
            Error(2);
            writeln('Enter the ID of the Record Wanted to be Deleted.');
            write('id>');
            readln(idstr);
            val(idstr, idval, code);
         end;
         while (member[i].id <> L0(idval)) and (i <= j) do
         begin
            i := i + 1;
            while i > j do
            begin
               Error(3);
               writeln('Enter the ID of the Record Wanted to be Deleted.');
            write('id>');
            readln(idstr);
            val(idstr, idval, code);
            while code <> 0 do
            begin
               Error(2);
               writeln('Enter the ID of the Record Wanted to be Deleted.');
               write('id>');
               readln(idstr);
               val(idstr, idval, code);
            end;
            i := 1;
            while (member[i].id <> L0(idval)) and (i <= j) do
               i := i + 1;
            end;
         end;
         for i := 1 to j do
         begin
            if member[i].id = L0(idval) then
               for k := i to j do
               begin
                  member[k].id := member[k+1].id;
                  member[k].dow := member[k+1].dow;
                  member[k].name := member[k+1].name;
               end;
         end;
      end
      else if choice = 6 then
      begin
         clrscr;
         halt;
      end
      else if choice = 4 then
      begin
         writeln('Enter the ID of the Record Wanted to be Modified.');
         write('id>');
         readln(idstr);
         val(idstr, idval, code);
         while code <> 0 do
         begin
            writeln('Enter the ID of the Record Wanted to be Modified.');
            write('id>');
            readln(idstr);
            val(idstr, idval, code);
         end;
         i := 1;
         while (member[i].id <> L0(idval)) and (i <= j) do
         begin
            i := i + 1;
            while i > j do
            begin
               Error(3);
               writeln('Enter the ID of the Record Wanted to be Modified.');
            write('id>');
            readln(idstr);
            val(idstr, idval, code);
            while code <> 0 do
            begin
               Error(2);
               writeln('Enter the ID of the Record Wanted to be Modified.');
               write('id>');
               readln(idstr);
               val(idstr, idval, code);
            end;
            i := 1;
            while (member[i].id <> L0(idval)) and (i <= j) do
               i := i + 1;
            end;
         end;
         writeln('Enter the Following Number to Modify Corresponding Item.');
         writeln('1. Name');
         writeln('2. Day of Week of Duty');
         write('>');
         readln(inpstr);
         val(inpstr, inpval, code);
         while (code <> 0) or (inpval < 1) or (inpval > 2) do
         begin
            writeln('Enter the Following Number to Modify Corresponding Item.');
            writeln('1. Name');
            writeln('2. Day of Week of Duty');
            write('>');
            readln(inpstr);
            val(inpstr, inpval, code);
         end;
         if inpval = 1 then
         begin
            writeln('Enter the New Name.');
            write('name>');
            readln(member[i].name);
            while member[i].name = '' do
            begin
               Error(1);
               writeln('Enter the New Name.');
               write('name>');
               readln(member[i].name);
            end;
         end
         else
         begin

            writeln('Enter the Day of Week of Duty. (1 - Monday; 5 - Friday)');
            write('dow>');
            readln(dowstr);
            val(dowstr, dowval, code);
            while (code <> 0) or (dowval < 1) or (dowval > 5) do
            begin
               Error(2);
               writeln('Enter the Day of Week of Duty. (1 - Monday; 5 - Friday)');
               write('dow>');
               readln(dowstr);
               val(dowstr, dowval, code);
            end;
            while getDOW(dowval) = 'null' do
            begin
               writeln('Enter the Day of Week of Duty.');
               write('dow>');
               readln(dowstr);
               val(dowstr, dowval, code);
               while (code <> 0) or (dowval < 1) or (dowval > 5) do
               begin
                  Error(2);
                  writeln('Enter the Day of Week of Duty. (1 - Monday; 5 - Friday)');
                  write('dow>');
                  readln(dowstr);
                  val(dowstr, dowval, code);
               end;
            end;

            member[i].dow := getDOW(dowval);

         end;
      end
      else
      begin
         rewrite(f);
         for i := 1 to j do
         begin
            member[i].name := '';
            member[i].dow := '';
            member[i].id := '';
         end;
         writeln('Enter Name with Duty on Monday.');
         writeln('Proceed to Next Section by Entering ''.''');
         write('>');
         readln(namestr);
         i := 1;
         while namestr <> '.' do
         begin
            member[i].name := namestr;
            member[i].DOW := 'Monday';
            member[i].id := L0(i);
            writeln('His ID would be ', member[i].id, '.');
            i := i + 1;
            write('>');
            readln(namestr);
         end;
         writeln('Enter Name with Duty on Tuesday.');
         writeln('Proceed to Next Section by Entering ''.''');
         write('>');
         readln(namestr);
         while namestr <> '.' do
         begin
            member[i].name := namestr;
            member[i].DOW := 'Tuesday';
            member[i].id := L0(i);
            writeln('His ID would be ', member[i].id, '.');
            i := i + 1;
            write('>');
            readln(namestr);
         end;
         writeln('Enter Name with Duty on Wednesday.');
         writeln('Proceed to Next Section by Entering ''.''');
         write('>');
         readln(namestr);
         while namestr <> '.' do
         begin
            member[i].name := namestr;
            member[i].DOW := 'Wednesday';
            member[i].id := L0(i);
            writeln('His ID would be ', member[i].id, '.');
            i := i + 1;
            write('>');
            readln(namestr);
         end;
         writeln('Enter Name with Duty on Thursday.');
         writeln('Proceed to Next Section by Entering ''.''');
         write('>');
         readln(namestr);
         while namestr <> '.' do
         begin
            member[i].name := namestr;
            member[i].DOW := 'Thursday';
            member[i].id := L0(i);
            writeln('His ID would be ', member[i].id, '.');
            i := i + 1;
            write('>');
            readln(namestr);
         end;
         writeln('Enter Name with Duty on Friday.');
         writeln('Proceed to Next Section by Entering ''.''');
         write('>');
         readln(namestr);
         while namestr <> '.' do
         begin
            member[i].name := namestr;
            member[i].DOW := 'Friday';
            member[i].id := L0(i);
            writeln('His ID would be ', member[i].id, '.');
            i := i + 1;
            write('>');
            readln(namestr);
         end;
      end;
      i := 1;
      rewrite(f);
      while member[i].name <> '' do
      begin
         writeln(f, member[i].name);
         writeln(f, member[i].id);
         writeln(f, member[i].dow);
         i := i + 1;
      end;
   close(f);
end;





{$R *.res}

begin
   //GetLargestConsoleWindowSize(GetStdHandle(STD_OUTPUT_HANDLE));
   setconsoletitle('SFXCLST Check-In Program ' + devphase + ' ' + version + ' - MemberEditing SubProgram');
   //GetDir (0,directory);
   //directory := directory + '\';
   TextColor(7);
   TextBackground(1);
   clrscr;
   writeln('Please Exit to Return to the Main Program.');
   writeln('Initializing...');
   filename := directory + 'Member.txt';
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
