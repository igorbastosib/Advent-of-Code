program Day2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes;

  procedure GetData(const AText: string; var AFirst, ALast: Integer; var AWord, APassword: string);
  var
    LText: string;
    LValue: string;
  begin
    AFirst := 0;
    ALast := 0;
    AWord := EmptyStr;
    APassword := EmptyStr;

    LText := AText;
    LValue := Copy(LText, 0, Pos('-', LText)-1);
    TryStrToInt(LValue, AFirst);

    LText := Copy(LText, Pos('-', LText)+1, LText.Length);
    LValue := Copy(LText, 0, Pos(' ', LText)-1);
    TryStrToInt(LValue, ALast);

    LText := Copy(LText, Pos(' ', LText)+1, LText.Length);
    LValue := Copy(LText, 0, Pos(':', LText)-1);
    AWord := LValue;

    LText := Copy(LText, Pos(':', LText)+1, LText.Length);
    APassword := LText.Trim;
  end;

  function CountOccurences( const AString, ASubString: string): Integer;
  begin
    if (ASubString = '') OR (AString = '') OR (Pos(ASubString, AString) = 0) then
      Result := 0
    else
      Result := (Length(AString) - Length(StringReplace(AString, ASubString, '', [rfReplaceAll]))) div  Length(ASubString);
  end;

  function ValidatePasswordPart1(const AFirst, ALast: Integer; const AWord, APassword: string): Boolean;
  var
    LOccurences: Integer;
  begin
    Result := False;
    LOccurences := CountOccurences(APassword, AWord);
    Result := (LOccurences >=  AFirst) and (LOccurences <=  ALast);
  end;

  function ValidatePasswordPart2(const AFirst, ALast: Integer; const AWord, APassword: string): Boolean;
  var
    LText1: string;
    LText2: string;
  begin
    Result := False;
    LText1 := Copy(APassword, AFirst, 1);
    LText2 := Copy(APassword, ALast, 1);

    Result := ((LText1.Equals(AWord)) and not(LText2.Equals(AWord))) or
      (not(LText1.Equals(AWord)) and (LText2.Equals(AWord)));

    if Result then
      Writeln(AWord + ' ' + LText1 + ' ' + LText2)
    else

    Writeln(AWord + ' ' + LText1 + ' ' + LText2 + ' -----');
  end;

var
  LStrLst: TStringList;
  i: Integer;
  LFirst: Integer;
  LLast: Integer;
  LWord: string;
  LPassowrd: string;
  LQtd: Integer;
begin
{$REGION 'Part1'}
  try
    LQtd :=0;
    LStrLst := TStringList.Create;
    try
      LStrLst.LoadFromFile('input.txt');

      for i := 0 to Pred(LStrLst.Count) do
      begin
        GetData(LStrLst[i], LFirst, LLast, LWord, LPassowrd);
        if ValidatePasswordPart1(LFirst, LLast, LWord, LPassowrd) then
          Inc(LQtd, 1);
      end;
    finally
      FreeAndNil(LStrLst);
    end;
    Writeln(LQtd);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDREGION}

{$REGION 'Part2'}
  try
    LQtd :=0;
    LStrLst := TStringList.Create;
    try
      LStrLst.LoadFromFile('input.txt');

      for i := 0 to Pred(LStrLst.Count) do
      begin
        GetData(LStrLst[i], LFirst, LLast, LWord, LPassowrd);
        if ValidatePasswordPart2(LFirst, LLast, LWord, LPassowrd) then
          Inc(LQtd, 1);
      end;
    finally
      FreeAndNil(LStrLst);
    end;
    Writeln(LQtd);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDREGION}
  ReadLn;
end.
