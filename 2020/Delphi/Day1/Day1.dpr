program Day1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes;

var
  LStrLst: TStringList;
  LTryStrToInt1: Integer;
  LTryStrToInt2: Integer;
  LTryStrToInt3: Integer;
  i: Integer;
  j: Integer;
  k: Integer;
begin
{$REGION 'Part1'}
  try
    LStrLst := TStringList.Create;
    try
      LStrLst.LoadFromFile('input.txt');

      for i := 0 to Pred(LStrLst.Count) do
      begin
        LTryStrToInt1 := -1;
        LTryStrToInt2 := -1;
        for j := i + 1 to Pred(LStrLst.Count) do
        begin
          if TryStrToInt(LStrLst[i], LTryStrToInt1) and
            TryStrToInt(LStrLst[j], LTryStrToInt2) and
            ((LTryStrToInt1 + LTryStrToInt2) = 2020)
          then
            Writeln(LTryStrToInt1 * LTryStrToInt2);
        end;
      end;
    finally
      FreeAndNil(LStrLst);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDREGION}

{$REGION 'Part2'}
  try
    LStrLst := TStringList.Create;
    try
      LStrLst.LoadFromFile('input.txt');

      for i := 0 to Pred(LStrLst.Count) do
      begin
        LTryStrToInt1 := -1;
        LTryStrToInt2 := -1;
        for j := i + 1 to Pred(LStrLst.Count) do
        begin
          for k := j + 1 to Pred(LStrLst.Count) do
          begin
            if TryStrToInt(LStrLst[i], LTryStrToInt1) and
              TryStrToInt(LStrLst[j], LTryStrToInt2) and
              TryStrToInt(LStrLst[k], LTryStrToInt3) and
              ((LTryStrToInt1 + LTryStrToInt2 + LTryStrToInt3) = 2020)
            then
              Writeln(LTryStrToInt1 * LTryStrToInt2 * LTryStrToInt3);
          end;
        end;
      end;
    finally
      FreeAndNil(LStrLst);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDREGION}
  ReadLn;
end.
