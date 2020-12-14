program Day3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes;

function LocateTree(const AColumn, ALine: Integer): Integer; // Columns and Lines to jumb
var
  LStrLst: TStringList;
  LStrLstPrint: TStringList;
  i: Integer;
  LQtd: Integer;
  LLine: Integer;
  LColumn: Integer;
  LTextC: TCharArray;
begin
  try
    Result := 0;
    LQtd := 0;
    LLine := 0;
    LColumn := 0;
    LStrLst := TStringList.Create;
    LStrLstPrint := TStringList.Create;
    try
      LStrLst.LoadFromFile('input.txt');
      LStrLstPrint.Add(LStrLst[0]);
      repeat
        if LLine + ALine > Pred(LStrLst.Count) then
          Break;

        LTextC := LStrLst[LLine + ALine].ToCharArray;

        for i := 1 to AColumn do
        begin
          Inc(LColumn, 1);
          if LColumn > Length(LTextC) - 1 then
            LColumn := 0;
        end;

        if LTextC[LColumn] = '#' then
        begin
          LTextC[LColumn] := 'X';
          Inc(LQtd, 1);
        end
        else
          LTextC[LColumn] := 'O';

        LStrLstPrint.Add(PChar(LTextC));

        SetLength(LTextC, 0);
        Inc(LLine, ALine);
      until LLine > Pred(LStrLst.Count);
    finally
      LStrLstPrint.SaveToFile('output.txt');

      FreeAndNil(LStrLst);
      FreeAndNil(LStrLstPrint);
    end;
    Writeln(LQtd);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Result := LQtd;
end;

var
  LValue: Integer;
begin
  LocateTree(3,1);
  Writeln('');

// Part2
  LValue := 1;
  LValue := LValue * LocateTree(1,1);
  LValue := LValue * LocateTree(3,1);
  LValue := LValue * LocateTree(5,1);
  LValue := LValue * LocateTree(7,1);
  LValue := LValue * LocateTree(1,2);
  ReadLn;
end.
