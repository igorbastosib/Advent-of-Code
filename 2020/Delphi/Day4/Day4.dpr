program Day4;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  System.StrUtils,
  System.Classes;

function CountOfStringOccurrences(const SubStr, s: string): integer;
var
  offset: integer;
begin
  result := 0;
  offset := PosEx(SubStr, s, 1);
  while offset <> 0 do
  begin
    inc(result);
    offset := PosEx(SubStr, s, offset + length(SubStr));
  end;
end;

{
  byr (Birth Year) - four digits; at least 1920 and at most 2002.
  iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  pid (Passport ID) - a nine-digit number, including leading zeroes.
  hgt (Height) - a number followed by either cm or in:
  If cm, the number must be at least 150 and at most 193.
  If in, the number must be at least 59 and at most 76.
}
{
  hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
}

function IsHcl(const AValue: string): Boolean;
var
  LTryStrToInt: integer;
  LValue: string;
  LCharAry: TCharArray;
  i: integer;
begin
  result := (AValue.length = 7) and (AValue.StartsWith('#'));
  if result then
  begin
    LValue := Copy(AValue, 2, AValue.length);
    LCharAry := LValue.ToCharArray;

    for i := 0 to Pred(length(LCharAry)) do
    begin
      case AnsiIndexStr(LCharAry[i], [
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'a', 'b', 'c', 'd', 'e', 'f'
        ]) of
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15:
          result := True;
      else
        result := False;
        Break;
      end;
    end;
  end;
end;

function IsHgt(const AValue: string): Boolean;
var
  LTryStrToInt: integer;
  LUnit: string;
begin
  result := False;
  LUnit := Copy(AValue, AValue.length - 1, 2);
  if TryStrToInt(Copy(AValue, 0, AValue.length - 2), LTryStrToInt) then
    case AnsiIndexStr(LUnit, ['cm', 'in']) of
      0:
        result := (LTryStrToInt >= 150) and (LTryStrToInt <= 193);
      1:
        result := (LTryStrToInt >= 59) and (LTryStrToInt <= 76);
    end;
end;

function IsPid(const AValue: string): Boolean;
var
  LTryStrToInt: integer;
begin
  result := (AValue.length = 9) and TryStrToInt(AValue, LTryStrToInt);
end;

function IsEcl(const AValue: string): Boolean;
begin
  result := False;
  case AnsiIndexStr(AValue, ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']) of
    0, 1, 2, 3, 4, 5, 6:
      result := True;
  end;
end;

function IsEyr(const AValue: string): Boolean;
var
  LTryStrToInt: integer;
begin
  result := (AValue.length = 4) and TryStrToInt(AValue, LTryStrToInt) and (LTryStrToInt >= 2020) and (LTryStrToInt <= 2030);
end;

function IsByr(const AValue: string): Boolean;
var
  LTryStrToInt: integer;
begin
  result := (AValue.length = 4) and TryStrToInt(AValue, LTryStrToInt) and (LTryStrToInt >= 1920) and (LTryStrToInt <= 2002);
end;

function IsIyr(const AValue: string): Boolean;
var
  LTryStrToInt: integer;
begin
  result := (AValue.length = 4) and TryStrToInt(AValue, LTryStrToInt) and (LTryStrToInt >= 2010) and (LTryStrToInt <= 2020);
end;

function IsPassaportValid(const APassport: string): Boolean;
var
  LStrLst: TStringList;
  LIndex: integer;
begin
  result := False;
  if APassport.Trim.IsEmpty then
    Exit;
  result :=
    (CountOfStringOccurrences(' byr:', APassport) = 1) and
    (CountOfStringOccurrences(' iyr:', APassport) = 1) and
    (CountOfStringOccurrences(' eyr:', APassport) = 1) and
    (CountOfStringOccurrences(' hgt:', APassport) = 1) and
    (CountOfStringOccurrences(' hcl:', APassport) = 1) and
    (CountOfStringOccurrences(' ecl:', APassport) = 1) and
    (CountOfStringOccurrences(' pid:', APassport) = 1)
    ;

  if result then
  begin
{$REGION 'Part2'}
    LStrLst := TStringList.Create;
    try
      LStrLst.Clear;
      LStrLst.Delimiter := ' ';
      // LStrLst.QuoteChar := '"';
      LStrLst.StrictDelimiter := True;
      LStrLst.DelimitedText := APassport.Trim;
      LStrLst.NameValueSeparator := ':';

      LIndex := LStrLst.IndexOfName('byr');
      result :=
        IsByr(LStrLst.ValueFromIndex[LStrLst.IndexOfName('byr')]) and
        IsIyr(LStrLst.ValueFromIndex[LStrLst.IndexOfName('iyr')]) and
        IsEyr(LStrLst.ValueFromIndex[LStrLst.IndexOfName('eyr')]) and
        IsEcl(LStrLst.ValueFromIndex[LStrLst.IndexOfName('ecl')]) and
        IsPid(LStrLst.ValueFromIndex[LStrLst.IndexOfName('pid')]) and
        IsHgt(LStrLst.ValueFromIndex[LStrLst.IndexOfName('hgt')]) and
        IsHcl(LStrLst.ValueFromIndex[LStrLst.IndexOfName('hcl')])
        ;
    finally
      FreeAndNil(LStrLst);
    end;
{$ENDREGION}
  end;
end;

var
  LStrLst: TStringList;
  LQtd: integer;
  i: integer;
  LPassport: string;

begin
  LQtd := 0;
  LPassport := EmptyStr;
  LStrLst := TStringList.Create;
  try
    LStrLst.LoadFromFile('input.txt');
    if (LStrLst.Count > 0) and not(LStrLst[LStrLst.Count - 1].Trim.IsEmpty) then
      LStrLst.Add('');

    for i := 0 to Pred(LStrLst.Count) do
    begin
      if LStrLst[i].Contains('pid:455361219') then
        StrToInt('1');

      if not LStrLst[i].IsEmpty then
        LPassport := LPassport + ' ' + LStrLst[i]
      else
      begin
        if IsPassaportValid(LPassport) then
        begin
          inc(LQtd, 1);
        end;
        LPassport := EmptyStr;
      end;
    end;
  finally
    FreeAndNil(LStrLst);
  end;
  Writeln(LQtd);
  ReadLn;
end.
