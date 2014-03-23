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
    procedure FormCreate(Sender: TObject);
    procedure RecalcTrackbarPos(Source: integer);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
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
  p1, p2, p3: integer; // p1 + p2 + p3 = 100;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.RecalcTrackbarPos(Source: integer);
var
  d1, pos1, pos2, max1, max2 , max3: integer;
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
  p1 := abs(round(100 * pos1 / max1));
  max1 := TrackBar1.Max;
  TrackBar1.Position := round(p1 * max1 / 100);
  max1 := SpinEdit1.MaxValue;
  SpinEdit1.Value := round(p1 * max1 / 100);;
  d1 := abs(100 - p1);
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
  p2 := min(abs(round(pos2 / max2 * 100)), d1);
  case Source of
    1, 2, 4, 5: begin
      max2 := TrackBar2.Max;
      TrackBar2.Position := round(p2 * max2 / 100);
      max2 := SpinEdit2.MaxValue;
      SpinEdit2.Value := round(p2 * max2 / 100);;
    end;
    3, 6: begin
      max3 := TrackBar3.Max;
      TrackBar3.Position := round(p2 * max2 / 100);
      max2 := SpinEdit3.MaxValue;
      SpinEdit3.Value := round(p2 * max2 / 100);;
    end;
    else
      max2 := TrackBar2.Max;
      TrackBar2.Position := round(p2 * max2 / 100);
      max2 := SpinEdit2.MaxValue;
      SpinEdit2.Value := round(p2 * max2 / 100);;
  end;
  // pos3 := TrackBar3.Position;
  p3 := abs (100 - p1 - p2);
  case Source of
    1, 2, 4, 5: begin
      max3 := TrackBar3.Max;
      TrackBar3.Position := round(p3 * max3 / 100);
      max3 := SpinEdit3.MaxValue;
      SpinEdit3.Value := round(p3 * max3 / 100);;
    end;
    3, 6: begin
      max3 := TrackBar2.Max;
      TrackBar2.Position := round(p3 * max3 / 100);
      max3 := SpinEdit2.MaxValue;
      SpinEdit2.Value := round(p3 * max3 / 100);;
    end;
    else
      max3 := TrackBar3.Max;
      TrackBar3.Position := round(p3 * max3 / 100);
      max3 := SpinEdit3.MaxValue;
      SpinEdit3.Value := round(p3 * max3 / 100);;
  end;
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
end;

end.

