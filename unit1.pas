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
  RecalcTrackbarPos(1);
  RecalcSpinEditPos(1);
end;

procedure TForm1.FloatSpinEdit1Change(Sender: TObject);
begin
  RecalcSpinEditPos(3);
end;

end.

