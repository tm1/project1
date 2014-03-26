unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  CheckLst, StdCtrls, Grids, Spin, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    CheckListBox3: TCheckListBox;
    FloatSpinEdit1: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure CheckData(Source: integer);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox2ClickCheck(Sender: TObject);
    procedure CheckListBox3ClickCheck(Sender: TObject);
    procedure ResolveTask(Source: integer);
    function FindSolution1(const x1, x2, x3, s1, c1: integer; var y1, y2, y3: integer): boolean;
    procedure FloatSpinEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RecalcTrackbarPos(Source: integer);
    procedure RecalcSpinEditPos(Source: integer);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure SpinEdit5Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
  private
    { private declarations }
    RecalcInProgress: boolean;
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  x1, x2, x3: integer; // x1 + x2 + x3 = 100;
  s1, c1: integer; // s1 / c1 = a1;
  a1: float;
  q1, q2, q3: integer; // q1, q2, q3 > 0;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.RecalcTrackbarPos(Source: integer);
var
  delta1, pos1, pos2, max1, max2 , max3, prc1, prc2, prc3: integer;
begin
  if RecalcInProgress then exit;
  RecalcInProgress := true;
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
      pos1 := 100;
      max1 := 100;
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
      pos2 := 0;
      max2 := 100;
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
  RecalcTrackbarPos(1);
  RecalcSpinEditPos(1);
end;

procedure TForm1.FloatSpinEdit1Change(Sender: TObject);
begin
  RecalcSpinEditPos(3);
end;

procedure TForm1.ResolveTask(Source: integer);
type
  TArray6IntValues = array [0..6] of integer;
var
  s: string;
  i, n1, n2, n3, index1, index2, index3, x1, x2, x3, y1, y2, y3: integer;
  m1, m2, m3: array of integer;
  r1: array of TArray6IntValues;
begin
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
  i := 0;
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
        if FindSolution1(x1, x2, x3, s1, c1, y1, y2, y3) then
        begin
          SetLength(r1, i + 1);
          r1[i, 0] := x1;
          r1[i, 1] := y1;
          r1[i, 2] := x2;
          r1[i, 3] := y2;
          r1[i, 4] := x3;
          r1[i, 5] := y3;
          Inc(i);
        end;
      end;
    end;
  end;
  // ShowMessageFmt('count(r1) = %d, r1[last, 0] = %d, r1[last, 1] = %d', [i, r1[i - 1, 0], r1[i - 1, 1]]);
  RecalcInProgress := false;
end;

function TForm1.FindSolution1(const x1, x2, x3, s1, c1: integer; var y1, y2, y3: integer): boolean;
begin
  // Stub
  y1 := 1;
  y2 := 2;
  y3 := 3;
  Result := true;
end;

procedure TForm1.Button1Click(Sender: TObject);
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
      ResolveTask(1);
      StatusBar1.SimpleText := 'Process: Done.' + Format(' [%d, %d, %d]', [q1, q2, q3]);
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
end;

procedure TForm1.CheckListBox1ClickCheck(Sender: TObject);
begin
  CheckData(1);
end;

procedure TForm1.CheckListBox2ClickCheck(Sender: TObject);
begin
  CheckData(2);
end;

procedure TForm1.CheckListBox3ClickCheck(Sender: TObject);
begin
  CheckData(3);
end;

end.

