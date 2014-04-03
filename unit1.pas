unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  CheckLst, StdCtrls, Grids, Spin, Math, AppSettings, IniFiles;

type
  TArray4IntValues = array [0..3] of integer;
  TDynArray4IntValues = array of TArray4IntValues;
  TArray7IntValues = array [0..7] of integer;
  TDynArray7IntValues = array of TArray7IntValues;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    CheckListBox3: TCheckListBox;
    FloatSpinEdit1: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    SpinEdit7: TSpinEdit;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckTask(Source: integer);
    procedure CheckData(Source: integer);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox2ClickCheck(Sender: TObject);
    procedure CheckListBox3ClickCheck(Sender: TObject);
    procedure FileSave(Source: integer);
    procedure LoadResources(Source: integer);
    procedure SaveResources(Source: integer);
    procedure UpdateStatusBar(Source: integer);
    procedure ShowMatrix(const r1count: integer; const r1: TDynArray7IntValues; const prc1, prc2, prc3: integer; const ShowPercent, ShowPercentOnly: boolean; var mp1: integer);
    function ResolveTask(Source: integer; var r1count: integer; var r1: TDynArray7IntValues): integer;
    function FindSolution2(const x1, x2, x3, s1, c1, s1diff: integer; var r2: TDynArray4IntValues; var r2count: integer): boolean;
    procedure FloatSpinEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RecalcTrackbarPos(Source: integer);
    procedure RecalcSpinEditPos(Source: integer);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure SpinEdit5Change(Sender: TObject);
    procedure SpinEdit6Change(Sender: TObject);
    procedure SpinEdit7Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
  private
    { private declarations }
    RecalcInProgress: boolean;
    ResultFound: boolean;
  public
    { public declarations }
  end;

const
  SectionResources = 'Resources';
  IdentCheckListBox = 'CheckListBox';
  ResourcesCheckListBox = 'CheckListBox.resource.ini';
var
  Form1: TForm1;
  x1, x2, x3: integer; // x1 + x2 + x3 = 100;
  s1, c1: integer; // s1 / c1 = a1;
  a1: float;
  q1, q2, q3: integer; // q1, q2, q3 > 0;
  r1matrix: TDynArray7IntValues;
  r1size, r1matches: integer;
  diff1, diff2: integer;
  diff1show: boolean;
  filename1: string;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.RecalcTrackbarPos(Source: integer);
var
  delta1, pos1, pos2, max1, max2 , max3, prc1, prc2, prc3: integer;
begin
  if RecalcInProgress then exit;
  RecalcInProgress := true;
  diff1show := CheckBox1.Checked;
  diff1 := SpinEdit6.Value;
  case Source of
    1, 2, 3: begin
      pos1 := TrackBar1.Position;
      max1 := TrackBar1.Max;
    end;
    4, 5, 6: begin
      pos1 := SpinEdit1.Value;
      max1 := SpinEdit1.MaxValue;
    end;
    else
      pos1 := TrackBar1.Position;
      max1 := TrackBar1.Max;
  end;
  prc1 := abs(round(100 * pos1 / max1));
  x1 := prc1;
  max1 := TrackBar1.Max;
  TrackBar1.Position := round(prc1 * max1 / 100);
  max1 := SpinEdit1.MaxValue;
  SpinEdit1.Value := round(prc1 * max1 / 100);;
  delta1 := abs(100 - prc1);
  case Source of
    1, 2: begin
      pos2 := TrackBar2.Position;
      max2 := TrackBar2.Max;
    end;
    3: begin
      pos2 := TrackBar3.Position;
      max2 := TrackBar3.Max;
    end;
    4, 5: begin
      pos2 := SpinEdit2.Value;
      max2 := SpinEdit2.MaxValue;
    end;
    6: begin
      pos2 := SpinEdit3.Value;
      max2 := SpinEdit3.MaxValue;
    end;
    else
      pos2 := TrackBar2.Position;
      max2 := TrackBar2.Max;
  end;
  prc2 := min(abs(round(pos2 / max2 * 100)), delta1);
  case Source of
    1, 2, 4, 5: begin
      max2 := TrackBar2.Max;
      TrackBar2.Position := round(prc2 * max2 / 100);
      max2 := SpinEdit2.MaxValue;
      SpinEdit2.Value := round(prc2 * max2 / 100);;
      x2 := prc2;
    end;
    3, 6: begin
      max3 := TrackBar3.Max;
      TrackBar3.Position := round(prc2 * max2 / 100);
      max2 := SpinEdit3.MaxValue;
      SpinEdit3.Value := round(prc2 * max2 / 100);;
      x3 := prc2;
    end;
    else
      max2 := TrackBar2.Max;
      TrackBar2.Position := round(prc2 * max2 / 100);
      max2 := SpinEdit2.MaxValue;
      SpinEdit2.Value := round(prc2 * max2 / 100);;
      x2 := prc2;
  end;
  // pos3 := TrackBar3.Position;
  prc3 := abs (100 - prc1 - prc2);
  case Source of
    1, 2, 4, 5: begin
      max3 := TrackBar3.Max;
      TrackBar3.Position := round(prc3 * max3 / 100);
      max3 := SpinEdit3.MaxValue;
      SpinEdit3.Value := round(prc3 * max3 / 100);;
      x3 := prc3;
    end;
    3, 6: begin
      max3 := TrackBar2.Max;
      TrackBar2.Position := round(prc3 * max3 / 100);
      max3 := SpinEdit2.MaxValue;
      SpinEdit2.Value := round(prc3 * max3 / 100);;
      x2 := prc3;
    end;
    else
      max3 := TrackBar3.Max;
      TrackBar3.Position := round(prc3 * max3 / 100);
      max3 := SpinEdit3.MaxValue;
      SpinEdit3.Value := round(prc3 * max3 / 100);;
      x3 := prc3;
  end;
  ShowMatrix(r1size, r1matrix, x1, x2, x3, true, diff1show, r1matches);
  StatusBar1.SimpleText := 'Process: Done.' + Format(' [%d, %d, %d]. Count = %d, Matches = %d', [q1, q2, q3, r1size, r1matches]);
  RecalcInProgress := false;
end;

procedure TForm1.RecalcSpinEditPos(Source: integer);
var
  sum1, count1: integer;
  avg1: double;
begin
  if RecalcInProgress then exit;
  RecalcInProgress := true;
  case Source of
    1, 2: begin
      sum1 := SpinEdit4.Value;
      count1 := SpinEdit5.Value;
      avg1 := sum1 / count1;
      FloatSpinEdit1.Value := avg1;
    end;
    3: begin
      avg1 := FloatSpinEdit1.Value;
      count1 := SpinEdit5.Value;
      sum1 := round(avg1 * count1);
      SpinEdit4.Value := sum1;
    end;
    else
      sum1 := SpinEdit4.Value;
      count1 := SpinEdit5.Value;
      avg1 := sum1 / count1;
      FloatSpinEdit1.Value := avg1;
  end;
  s1 := sum1;
  c1 := count1;
  a1 := avg1;
  RecalcInProgress := false;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  RecalcTrackbarPos(4);
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  RecalcTrackbarPos(5);
end;

procedure TForm1.SpinEdit3Change(Sender: TObject);
begin
  RecalcTrackbarPos(6);
end;

procedure TForm1.SpinEdit4Change(Sender: TObject);
begin
  RecalcSpinEditPos(1);
end;

procedure TForm1.SpinEdit5Change(Sender: TObject);
begin
  RecalcSpinEditPos(2);
end;

procedure TForm1.SpinEdit6Change(Sender: TObject);
begin
  RecalcTrackbarPos(8);
end;

procedure TForm1.SpinEdit7Change(Sender: TObject);
begin
  CheckTask(4);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  RecalcTrackbarPos(1);
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  RecalcTrackbarPos(2);
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
  RecalcTrackbarPos(3);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RecalcInProgress := false;
  ResultFound := false;
  SetLength(r1matrix, 0);
  r1size := 0;
  r1matches := 0;
  diff1 := 5;
  diff1show := false;
  diff2 := 0;
  filename1 := '';
  RecalcTrackbarPos(1);
  RecalcSpinEditPos(1);
  UpdateStatusBar(1);
  LoadResources(1);
end;

procedure TForm1.FloatSpinEdit1Change(Sender: TObject);
begin
  RecalcSpinEditPos(3);
end;

procedure TForm1.ShowMatrix(const r1count: integer; const r1: TDynArray7IntValues; const prc1, prc2, prc3: integer; const ShowPercent, ShowPercentOnly: boolean; var mp1: integer);
var
  i, r1index: integer;
  str1: string;
  found1, found2, found3: boolean;
begin
  if not ResultFound then exit;
  found1 := false;
  found2 := false;
  found3 := false;
  StringGrid1.Clear;
  StringGrid1.ColCount := 8;
  StringGrid1.RowCount := 1;
  StringGrid1.Rows[0].Clear;
  StringGrid1.Rows[0].Add('#');
  StringGrid1.Rows[0].Add('x1');
  StringGrid1.Rows[0].Add('y1');
  StringGrid1.Rows[0].Add('x2');
  StringGrid1.Rows[0].Add('y2');
  StringGrid1.Rows[0].Add('x3');
  StringGrid1.Rows[0].Add('y3');
  StringGrid1.Rows[0].Add('mod');
  if not ShowPercentOnly then
    StringGrid1.RowCount := r1count + 1;
  mp1 := 0;
  r1index := 0;
  for i := 0 to (r1count - 1) do
  begin
    str1 := IntToStr(i);
    if ShowPercent then
    begin
      found1 := false;
      found2 := false;
      found3 := false;
      if (r1[i, 1] > 0) then
      begin
        if (abs(round(r1[i, 1] / c1 * 100) - prc1) <= diff1) then
        found1 := true;
      end
      else
      begin
        if (prc1 <= diff1) then
        found1 := true;
      end;
      if (r1[i, 3] > 0) then
      begin
        if (abs(round(r1[i, 3] / c1 * 100) - prc2) <= diff1) then
        found2 := true;
      end
      else
      begin
        if (prc2 <= diff1) then
        found2 := true;
      end;
      if (r1[i, 5] > 0) then
      begin
        if (abs(round(r1[i, 5] / c1 * 100) - prc3) <= diff1) then
        found3 := true;
      end
      else
      begin
        if (prc3 <= diff1) then
        found3 := true;
      end;
      if (found1 and found2 and found3) then
      begin
        str1 := str1 + ' ***';
        Inc(mp1);
      end;
    end;
    if (not ShowPercentOnly) or (ShowPercentOnly and found1 and found2 and found3) then
    begin
      Inc(r1index);
      if ShowPercentOnly then
        StringGrid1.RowCount := r1index + 1;
      StringGrid1.Rows[r1index].Clear;
      StringGrid1.Rows[r1index].Add(str1);
      StringGrid1.Rows[r1index].Add(IntToStr(r1[i, 0]));
      StringGrid1.Rows[r1index].Add(IntToStr(r1[i, 1]));
      StringGrid1.Rows[r1index].Add(IntToStr(r1[i, 2]));
      StringGrid1.Rows[r1index].Add(IntToStr(r1[i, 3]));
      StringGrid1.Rows[r1index].Add(IntToStr(r1[i, 4]));
      StringGrid1.Rows[r1index].Add(IntToStr(r1[i, 5]));
      StringGrid1.Rows[r1index].Add(IntToStr(r1[i, 6]));
    end;
  end;
end;

function TForm1.ResolveTask(Source: integer; var r1count: integer; var r1: TDynArray7IntValues): integer;
var
  s: string;
  i, n1, n2, n3, index1, index2, index3, x1, x2, x3, r2count: integer;
  // y1, y2, y3: integer;
  m1, m2, m3: array of integer;
  r2: TDynArray4IntValues;
  progress1: integer;
begin
  Result := 0;
  ResultFound := false;
  if RecalcInProgress then exit;
  if (c1 <= 0) or (c1 > s1) or (s1 <= 0) then
  begin
    StatusBar1.SimpleText := 'Error: Can not find solution' + Format(' [%d, %d, %d]', [q1, q2, q3]);
    exit;
  end;
  RecalcInProgress := true;
  SetLength(m1, max(q1, 1));
  SetLength(m2, max(q2, 1));
  SetLength(m3, max(q3, 1));
  n1 := 0;
  n2 := 0;
  n3 := 0;
  for i := 0 to (CheckListBox1.Count - 1) do
  begin
    if CheckListBox1.Checked[i] then
    begin
      try
        s := CheckListBox1.Items[i];
        m1[n1] := StrToInt(s);
      except
        m1[n1] := 0;
      end;
      Inc(n1);
    end;
  end;
  // ShowMessageFmt('count(m1) = %d, m1[last] = %d', [n1, m1[n1 - 1]]);
  for i := 0 to (CheckListBox2.Count - 1) do
  begin
    if CheckListBox2.Checked[i] then
    begin
      try
        s := CheckListBox2.Items[i];
        m2[n2] := StrToInt(s);
      except
        m2[n2] := 0;
      end;
      Inc(n2);
    end;
  end;
  // ShowMessageFmt('count(m2) = %d, m2[last] = %d', [n2, m2[n2 - 1]]);
  for i := 0 to (CheckListBox3.Count - 1) do
  begin
    if CheckListBox3.Checked[i] then
    begin
      try
        s := CheckListBox3.Items[i];
        m3[n3] := StrToInt(s);
      except
        m3[n3] := 0;
      end;
      Inc(n3);
    end;
  end;
  // ShowMessageFmt('count(m3) = %d, m3[last] = %d', [n3, m3[n3 - 1]]);
  r1count := 0;
  progress1 := 0;
  ProgressBar1.Position := progress1;
  ProgressBar1.Min := 0;
  ProgressBar1.Max := 100;
  SetLength(r1, 0);
  for index1 := 0 to (n1 - 1) do
  begin
    x1 := m1[index1];
    for index2 := 0 to (n2 - 1) do
    begin
      x2 := m2[index2];
      for index3 := 0 to (n3 - 1) do
      begin
        x3 := m3[index3];
        // y1 := 0;
        // y2 := 0;
        // y3 := 0;
        SetLength(r2, 0);
        r2count := 0;
        progress1 := round((index1 * n3 * n2 + index2 * n3 + index3 ) / (n1 * n2 * n3) * 100);
        if (progress1 mod 1 = 0) then
        begin
          ProgressBar1.Position := progress1;
        end;
        if FindSolution2(x1, x2, x3, s1, c1, diff2, r2, r2count) then
        begin
          for i := 0 to (r2count - 1) do
          begin
            SetLength(r1, r1count + 1);
            r1[r1count, 0] := x1;
            r1[r1count, 1] := r2[i, 0];
            r1[r1count, 2] := x2;
            r1[r1count, 3] := r2[i, 1];
            r1[r1count, 4] := x3;
            r1[r1count, 5] := r2[i, 2];
            r1[r1count, 6] := r2[i, 3];
            Inc(r1count);
          end;
        end;
      end;
    end;
  end;
  ResultFound := true;
  Result := r1count;
  // ShowMessageFmt('count(r1) = %d, r1[last, 0] = %d, r1[last, 1] = %d', [i, r1[i - 1, 0], r1[i - 1, 1]]);
  RecalcInProgress := false;
end;

function TForm1.FindSolution2(const x1, x2, x3, s1, c1, s1diff: integer; var r2: TDynArray4IntValues; var r2count: integer): boolean;
var
  x1index, x2index, x3index, x1min, x2min, x3min, x1max, x2max, x3max, sum1, sum2, sum3: integer;
begin
  Result := false;
  // y1 := 0;
  // y2 := 0;
  // y3 := 0;
  x1min := 0;
  x2min := 0;
  x3min := 0;
  x1max := max(0, s1 div x1 + 1);
  x2max := 0;
  x3max := 0;
  sum1 := 0;
  sum2 := 0;
  sum3 := 0;
  SetLength(r2, 0);
  r2count := 0;
  for x1index := x1min to x1max do
  begin
    sum1 := x1index * x1;
    x2max := max(0, (s1 - sum1) div x2 + 1);
    for x2index := x2min to x2max do
    begin
      sum2 := x2index * x2;
      x3min := max(0, (s1 - sum1 - sum2) div x3 - 1);
      x3max := max(0, (s1 - sum1 - sum2) div x3 + 1);
      for x3index := x3min to x3max do
      begin
        sum3 := x3index * x3;
        if (s1 - (sum1 + sum2 + sum3) = - s1diff) and (s1 - (sum1 + sum2 + sum3) <= 0) and (c1 = x1index + x2index + x3index) then
        begin
          SetLength(r2, r2count + 1);
          r2[r2count, 0] := x1index;
          r2[r2count, 1] := x2index;
          r2[r2count, 2] := x3index;
          r2[r2count, 3] := s1 - (sum1 + sum2 + sum3);
          Inc(r2count);
          // Result := true;
          // if Result then break;
        end;
      end;
      // if Result then break;
    end;
    // if Result then break;
  end;
  if r2count > 0 then
    Result := true;
end;

procedure TForm1.CheckTask(Source: integer);
begin
  if (not RecalcInProgress) then
  begin
    CheckData(1);
    if (q1 > 0) and (q2 > 0) and (q3 > 0) then
    begin
      Button1.Enabled := false;
      CheckListBox1.Enabled := false;
      CheckListBox2.Enabled := false;
      CheckListBox3.Enabled := false;
      StatusBar1.SimpleText := 'Process: Calculating...' + Format(' [%d, %d, %d]', [q1, q2, q3]);
      ResolveTask(1, r1size, r1matrix);
      ShowMatrix(r1size, r1matrix, x1, x2, x3, true, diff1show, r1matches);
      StatusBar1.SimpleText := 'Process: Done.' + Format(' [%d, %d, %d]. Count = %d, Matches = %d', [q1, q2, q3, r1size, r1matches]);
      CheckListBox1.Enabled := true;
      CheckListBox2.Enabled := true;
      CheckListBox3.Enabled := true;
      Button1.Enabled := true;
    end
    else
    begin
      StatusBar1.SimpleText := 'Error: Not enough data to process calculation' + Format(' [%d, %d, %d]', [q1, q2, q3]);
    end;
  end
  else
  begin
    StatusBar1.SimpleText := StatusBar1.SimpleText + ' #';
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  CheckTask(3);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  FileSave(1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  FileSave(2);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  vConfigurations.ReadFromFile(nil);
  vConfigurations.Save(nil);
  LoadResources(2);
  SaveResources(2);
  UpdateStatusBar(2);
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  RecalcTrackbarPos(7);
end;

procedure TForm1.CheckData(Source: integer);
var
  i: integer;
begin
  q1 := 0;
  q2 := 0;
  q3 := 0;
  for i := 0 to (CheckListBox1.Count - 1) do
  begin
    if CheckListBox1.Checked[i] then
      Inc(q1);
  end;
  for i := 0 to (CheckListBox2.Count - 1) do
  begin
    if CheckListBox2.Checked[i] then
      Inc(q2);
  end;
  for i := 0 to (CheckListBox3.Count - 1) do
  begin
    if CheckListBox3.Checked[i] then
      Inc(q3);
  end;
  if (q1 > 0) then
    Label1.Color := clNone
  else
    Label1.Color := clRed;
  if (q2 > 0) then
    Label2.Color := clNone
  else
    Label2.Color := clRed;
  if (q3 > 0) then
    Label3.Color := clNone
  else
    Label3.Color := clRed;
  diff2 := SpinEdit7.Value;
end;

procedure TForm1.CheckListBox1ClickCheck(Sender: TObject);
begin
  CheckTask(1);
end;

procedure TForm1.CheckListBox2ClickCheck(Sender: TObject);
begin
  CheckTask(2);
end;

procedure TForm1.CheckListBox3ClickCheck(Sender: TObject);
begin
  CheckTask(3);
end;

procedure TForm1.FileSave(Source: integer);
var
  i: integer;
  f1: THandle;
  termchar1: Char;
  fmt1, s1, s2, termline1: string;
  buf1: PChar;
begin
  if (Length(filename1) = 0) or (Source = 2) then
  begin
    if (Length(filename1) = 0) then
      filename1 := 'result1.csv';
    SaveDialog1.FileName := filename1;
    if SaveDialog1.Execute then
      filename1 := SaveDialog1.FileName;
  end;
  f1 := 0;
  if (Length(filename1) > 0) and (StringGrid1.RowCount > 1) then
  begin
    if FileExists(filename1) then
    begin
      // f1 := FileOpen(filename1, fmOpenReadWrite + fmShareDenyWrite);
      ShowMessageFmt('Error: File already exists - [ %s ]', [filename1]);
      exit;
    end
    else
    begin
      f1 := FileCreate(filename1);
    end;
    if (LongInt(f1) = -1) then
    begin
      ShowMessageFmt('Error: Can not save to file - [ %s ]', [filename1]);
      exit;
    end
    else
    begin
      termchar1 := ';'; // ;
      // termchar1 := Char(#9); // Tab
      termline1 := Char(#13) + Char(#10); // CRLF
      // fmt1 := '%s' + termchar1 + '%s' + termchar1 + '%s' + termchar1 + '%s' + termchar1 + '%s' + termchar1 + '%s' + termchar1 + '%s' + termline1;
      fmt1 := '%s' + termchar1 + termline1;
      s1 := '';
      try
        FileSeek(f1, 0, fsFromBeginning);
        for i := 0 to (StringGrid1.RowCount - 1) do
        begin
          StringGrid1.Rows[i].Delimiter := termchar1;
          StringGrid1.Rows[i].QuoteChar := '"';
          s1 := StringGrid1.Rows[i].DelimitedText;
          s2 := Format(fmt1, [s1]);
          // ShowMessageFmt('StringGrid1.Rows[%d].Text - [ %s ]', [i, s2]);
          buf1 := PChar(s2);
          if not (FileWrite(f1, buf1^, Length(buf1)) = Length(buf1)) then
            StatusBar1.SimpleText := Format('Error: StringGrid1.Rows[%d].Text - [ %s ]', [i, s2]);
        end;
      finally
        FileClose(f1);
      end;
    end;
  end
  else
    ShowMessageFmt('Error: No results to save to file - [ %s ]', [filename1]);
end;

procedure TForm1.LoadResources(Source: integer);
var
  MyFile: TIniFile;
  MyFileName, ident1, str1: string;
begin
  MyFileName := vConfigurations.ResourcesPath + ResourcesCheckListBox;
  MyFile := TIniFile.Create(MyFileName);
  try
    // Here you can read other information from the config file
    ident1 := IdentCheckListBox + '1';
    str1 := MyFile.ReadString(SectionResources, ident1, CheckListBox1.Items.CommaText);
    CheckListBox1.Items.CommaText := str1;
    ident1 := IdentCheckListBox + '2';
    str1 := MyFile.ReadString(SectionResources, ident1, CheckListBox2.Items.CommaText);
    CheckListBox2.Items.CommaText := str1;
    ident1 := IdentCheckListBox + '3';
    str1 := MyFile.ReadString(SectionResources, ident1, CheckListBox3.Items.CommaText);
    CheckListBox3.Items.CommaText := str1;
  finally
    MyFile.Free;
  end;
end;

procedure TForm1.SaveResources(Source: integer);
var
  MyFile: TIniFile;
  MyFileName, ident1: string;
begin
  MyFileName := vConfigurations.ResourcesPath + ResourcesCheckListBox;
  try
    if not DirectoryExists(vConfigurations.ResourcesPath) then
      if not CreateDir(vConfigurations.ResourcesPath) then exit;
  except
    // CreateDir problem
    exit;
  end;
  MyFile := TIniFile.Create(MyFileName);
  try
    ident1 := IdentCheckListBox + '1';
    MyFile.WriteString(SectionResources, ident1, CheckListBox1.Items.CommaText);
    ident1 := IdentCheckListBox + '2';
    MyFile.WriteString(SectionResources, ident1, CheckListBox2.Items.CommaText);
    ident1 := IdentCheckListBox + '3';
    MyFile.WriteString(SectionResources, ident1, CheckListBox3.Items.CommaText);
  finally
    MyFile.Free;
  end;
end;

procedure TForm1.UpdateStatusBar(Source: integer);
begin
  StatusBar1.SimpleText := Format('Info: ConfigFilePath = [ %s ], ResourcesPath = [ %s ]', [vConfigurations.ConfigFilePath, vConfigurations.ResourcesPath]);
end;

end.

