unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ComCtrls, LCLIntf, LCLType, ActnList, Menus, Math, Types, unit2 ;

type


  { TMyMandelbrotThread }

  TMyMandelbrotThread = class(TThread)
      {custom procedures}
    procedure DoMandelBrot(ParamThreadNumber: integer);

  private
    fCPU:integer;
    fix, fiy, fcolor: int64;
    fThreadNumber:integer;
    fmyixmin, fmyixmax, fmyiymin, fmyiymax: int64;
    MyImage: TBitmap;
    fFcxmin: extended;
    fFcxmax: extended;
    fFcymin: extended;
    fFcymax: extended;
    fFixmax:int64;
    fFiymax:int64;
    fSaveZoom: integer;
    fForceTerminate: boolean;
    fPallette: integer;
    procedure CopyImage;
    procedure ShowStatusY;

  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean; ParamThreadNumber:integer);
    procedure InitTerminate;
    property CPU:           integer  read fCPU            write fCPU;
    property ix:            int64    read fix             write fix;
    property iy:            int64    read fiy             write fiy;
    property myixmin:       int64    read fmyixmin        write fmyixmin;
    property myixmax:       int64    read fmyixmax        write fmyixmax;
    property myiymin:       int64    read fmyiymin        write fmyiymin;
    property myiymax:       int64    read fmyiymax        write fmyiymax;
    property color:         int64    read fcolor          write fcolor;
    property ThreadNumber:  integer  read fThreadNumber   write fThreadNumber;
    property Fcxmin:        extended read fFcxmin         write fFcxmin;
    property Fcxmax:        extended read fFcxmax         write fFcxmax;
    property Fcymin:        extended read fFcymin         write fFcymin;
    property Fcymax:        extended read fFcymax         write fFcymax;
    property Fixmax:        int64    read fFixmax         write fFixmax;
    property Fiymax:        int64    read fFiymax         write fFiymax;
    property SaveZoom:      integer  read fSaveZoom       write fSaveZoom;
    property ForceTerminate:boolean  read fForceTerminate write fForceTerminate;
    property Pallette: integer       read fPallette       write fPallette;
end;

{ TMyJuliaThread }

  TMyJuliaThread = class(TThread)
      {custom procedures}
    procedure DoJulia(ParamThreadNumber: integer);

  private
    fCPU:integer;
    fix, fiy, fcolor: int64;
    fjcx, fjcy: extended;
    fzoom, fMoveX, fMoveY : extended;
    fThreadNumber:integer;
    fmyixmin, fmyixmax, fmyiymin, fmyiymax: int64;
    MyImage: TBitmap;
    fFixmax:int64;
    fFiymax:int64;
    fjmaxiterations:integer;
    fSaveZoom: integer;
    fForceTerminate: boolean;
    fPallette: integer;

    procedure CopyImage;
    procedure ShowStatusX;

  protected
    procedure Execute; override;

  public
    constructor Create(CreateSuspended: boolean; ParamThreadNumber:integer);
    procedure InitTerminate;
    property CPU:           integer  read fCPU            write fCPU;
    property ix:            int64    read fix             write fix;
    property iy:            int64    read fiy             write fiy;
    property jcx:           extended read fjcx            write fjcx;
    property jcy:           extended read fjcy            write fjcy;
    property zoom:          extended read fzoom           write fzoom;
    property MoveX:         extended read fMoveX          write fMoveX;
    property MoveY:         extended read fMoveY          write fMoveY;
    property myixmin:       int64    read fmyixmin        write fmyixmin;
    property myixmax:       int64    read fmyixmax        write fmyixmax;
    property myiymin:       int64    read fmyiymin        write fmyiymin;
    property myiymax:       int64    read fmyiymax        write fmyiymax;
    property color:         int64    read fcolor          write fcolor;
    property ThreadNumber:  integer  read fThreadNumber   write fThreadNumber;
    property Fixmax:        int64    read fFixmax         write fFixmax;
    property Fiymax:        int64    read fFiymax         write fFiymax;
    property jmaxiterations:integer  read fjmaxiterations write fjmaxiterations;
    property SaveZoom:      integer  read fSaveZoom       write fSaveZoom;
    property ForceTerminate:boolean  read fForceTerminate write fForceTerminate;
    property Pallette: integer       read fPallette       write fPallette;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ColorDialog1: TColorDialog;
    Edit1: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    Shape1: TShape;
    Timer1: TTimer;
    UpDown1: TUpDown;
    procedure Action1Execute(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Resize(Sender: TObject);
    procedure Image1SizeConstraintsChange(Sender: TObject);

    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2Resize(Sender: TObject);
    procedure Label32Click(Sender: TObject);
    procedure RadioGroup1SelectionChanged(Sender: TObject);
    procedure RadioGroup2SelectionChanged(Sender: TObject);
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: SmallInt; Direction: TUpDownDirection);



  private
  CPU: integer;
  MouseDownFromMandelbrot, MandelbrotDrawed: boolean;
  ThreadLock: TCriticalSection;
  Saving: boolean;
  ASaveZoom:integer;
  ThreadsDone:boolean;
  //Mandelbrot
  x1,x2,y1,y2:integer;
  cxmin, cxmax, cymin, cymax : extended;
  acxmin: extended;
  acxmax: extended;
  acymin: extended;
  acymax: extended;
  cxminabs, cxmaxabs, cyminabs, cymaxabs : extended;
  ixmax, iymax: int64;
  MandelProgress: array of TProgressbar;
  MThreads : array of TMyMandelbrotThread;
  Mzoom: extended;
  StartTime, StopTime: TDateTime;
  TimerSet: (J,M);
  //Julia
  zoom, moveX, moveY: extended;
  jcx, jcy: extended;
  jx1, jx2, jy1, jy2:integer;
  JuliaProgress: array of TProgressbar;
  JuliaSync: boolean;
  JThreads : array of TMyJuliaThread;
  //var
  re_left, im_top: extended;
  re_right, im_bottom: extended;
  zoom_x, zoom_y: extended;
  Pallette: integer;
  procedure UpdateInfo();
  procedure UpdateInfoNonCommitted(acx1,acx2,acy1,acy2:extended);
  procedure UpdateDefaultParameters();
  procedure UpdateMandelbrotImage(ABitmap:TBitmap; Amyixmin, Amyixmax, Amyiymax: integer);
  procedure UpdateJuliaImage(ABitmap:TBitmap; Amyixmin, Amyixmax, Amyiymax: integer);
  procedure DisableAllControls;
  procedure EnableAllControls;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TMyMandelbrotThread }

constructor TMyMandelbrotThread.Create(CreateSuspended: boolean; ParamThreadNumber:integer);
begin
  Self.ThreadNumber:=ParamThreadNumber;
  Self.ForceTerminate:=false;;
  inherited Create(CreateSuspended);
end;

procedure TMyMandelbrotThread.Execute;
begin
  Self.CPU:=Form1.CPU;
  Self.Fcxmin:=Form1.cxmin;
  Self.Fcxmax:=Form1.cxmax;
  Self.Fcymin:=Form1.cymin;
  Self.Fcymax:=Form1.cymax;
  Self.SaveZoom:=Form1.ASaveZoom;
  if Form1.Saving then
  begin
   Self.Fixmax:=Form2.SaveImage.Width;
   Self.Fiymax:=Form2.SaveImage.Height;
  end
  else
  begin
   Self.Fixmax:=Form1.ixmax;
   Self.Fiymax:=Form1.iymax;
  end;
  Self.Pallette:=Form1.Pallette;
  Self.FreeOnTerminate:=true;
  Self.DoMandelBrot(Self.ThreadNumber);
  Self.Terminate;
  Self.Free;
end;
procedure TMyMandelbrotThread.InitTerminate;
begin
  Self.ForceTerminate:=true;
end;

procedure TMyMandelbrotThread.CopyImage;
// this method is only called by Synchronize(@ShowStatus)
begin
  Form1.UpdateMandelbrotImage(MyImage, myixmin, myixmax, myiymax);
end;

procedure TMyMandelbrotThread.ShowStatusY;
// this method is only called by Synchronize(@ShowStatus) and therefore
// executed by the main thread
// The main thread can access GUI elements, for example Form1.Caption.
var pos: int64;
begin
  pos:=100*iy div Self.myiymax;
  Form1.MandelProgress[Self.ThreadNumber].Position:=pos;
  Form1.MandelProgress[Self.ThreadNumber].Hint:='Thread #'+IntToStr(Self.ThreadNumber)+ ' progress: '+pos.ToString+'%';
end;

procedure TMyMandelbrotThread.DoMandelBrot(ParamThreadNumber: integer);
const
   escaperadius = 2;
var
   localix, localiy       : int64;
   cx, cy                 : extended;
   pixelwidth             : extended;
   pixelheight            : extended;
   zx, zy                 : extended;
   zx2, zy2               : extended;
   iteration              : integer;
   er2                    : extended = (escaperadius * escaperadius);
   maxiteration           : integer;

begin
        //Mandelbrot
      //computing the bitmap region each thread will handle
      //slicing will be done by X axis
      Self.ThreadNumber:=ParamThreadNumber;
      Self.myiymax:=Self.Fiymax;
      Self.myixmin:=Self.Fixmax div CPU * Self.ThreadNumber;
      Self.myixmax:=Self.Fixmax div CPU + Self.myixmin+Self.CPU;
      Self.MyImage:=TBitmap.Create;
      Self.MyImage.Width:=Self.myixmax-Self.myixmin;
      Self.MyImage.Height:=Self.myiymax;
      pixelwidth   := (Self.Fcxmax - Self.Fcxmin) / Self.Fixmax;
      pixelheight  := (Self.Fcymax - Self.Fcymin) / Self.Fiymax;
      maxiteration:=StrToInt(Form1.Edit1.Text);
      for localiy := 1 to myiymax do
      begin
         //BitBtn2.Font.Color:=$FFFFFF div iymax - iy;
         //BitBtn2.Repaint;
         cy := Self.Fcymin + (iy - 1)*pixelheight;
         if abs(cy) < pixelheight / 2 then cy := 0.0;
         for localix := Self.myixmin to Self.myixmax do
         begin
            //check if one must terminate early
            if Self.ForceTerminate then
            begin
              MyImage.Destroy;
              Self.Terminate;
              Exit;
            end;
            cx := Self.Fcxmin + (ix - 1)*pixelwidth;
            zx := 0;
            zy := 0;
            zx2 := zx*zx;
            zy2 := zy*zy;
            iteration := 0;
            while (iteration < maxiteration) and (zx2 + zy2 < er2) do
            begin
               zy := 2*zx*zy + cy;
               zx := zx2 - zy2 + cx;
               zx2 := zx*zx;
               zy2 := zy*zy;
               iteration := iteration + 1;
            end;
            //Image1.Canvas.Pixels[ix,iy]:=$FFFFFF div maxiteration*iteration;
            ix:=localix;
            iy:=localiy;
            color:=$FFFFFF div maxiteration*iteration;
//            instead of synchronizing every pixel, draw the whole bitmap and sync it at the end
            MyImage.Canvas.Pixels[ix-Self.myixmin,iy]:=$FFFFFF div (maxiteration*Self.Pallette)*iteration;
            //MyImage.Canvas.Pixels[ix-myixmin,iy]:=$FFFFFF - iteration*1000;
         end;
         Self.Synchronize(@ShowStatusY);
      end;
      Self.Synchronize(@CopyImage);
      MyImage.Destroy;
end;

{ TMyJuliaThread }

constructor TMyJuliaThread.Create(CreateSuspended: boolean; ParamThreadNumber:integer);
begin
     Self.ThreadNumber:=ParamThreadNumber;
     Self.ForceTerminate:=false;
     inherited Create(CreateSuspended);

end;

procedure TMyJuliaThread.Execute;
begin
  Self.CPU:=Form1.CPU;
  Self.SaveZoom:=Form1.ASaveZoom;
  if Form1.Saving then
  begin
   Self.Fixmax:=Form2.SaveImage.Width;
   Self.Fiymax:=Form2.SaveImage.Height;
  end
  else
  begin
   Self.Fixmax:=Form1.ixmax;
   Self.Fiymax:=Form1.iymax;
  end;
  Self.jcx:=Form1.jcx;
  Self.jcy:=Form1.jcy;
  Self.zoom:=Form1.zoom;
  Self.SaveZoom:=Form1.ASaveZoom;
  Self.MoveX:=Form1.moveX;
  Self.MoveY:=Form1.moveY;
  Self.jmaxiterations:=StrToInt(Form1.Edit1.Text);
  Self.Pallette:=Form1.Pallette;
  Self.FreeOnTerminate:=true;
  Self.DoJulia(Self.ThreadNumber);
  Self.Terminate;
  Self.Free;
end;
procedure TMyJuliaThread.InitTerminate;
begin
  Self.ForceTerminate:=true;
end;
procedure TMyJuliaThread.CopyImage;
// this method is only called by Synchronize(@ShowStatus) and therefore
// executed by the main thread
// The main thread can access GUI elements, for example Form1.Caption.
begin
  Form1.UpdateJuliaImage(MyImage, myixmin, myixmax, myiymax);
end;

procedure TMyJuliaThread.ShowStatusX;
// this method is only called by Synchronize(@ShowStatus) and therefore
// executed by the main thread
// The main thread can access GUI elements, for example Form1.Caption.
var pos: int64;
begin
  pos:=100*ix div myixmax;
  Form1.JuliaProgress[Self.ThreadNumber].Position:=pos;
  Form1.JuliaProgress[Self.ThreadNumber].Hint:='Thread #'+IntToStr(Self.ThreadNumber)+ ' progress: '+pos.ToString+'%';
end;

procedure TMyJuliaThread.DoJulia(ParamThreadNumber: integer);
var
  jzx, jzy, tmp: extended;
  x, y: Integer;
  Colors  : array of TColor;
  i: Integer;

begin
  //Julia

  //computing the bitmap region each thread will handle
  //slicing will be done by X axis
  Self.myiymax:=Self.fFiymax;
  Self.myixmin:=Self.fFixmax div Self.fCPU * ParamThreadNumber;
  Self.myixmax:=Self.fFixmax div Self.fCPU + Self.fmyixmin+Self.fCPU;
  Self.MyImage:=TBitmap.Create;
  Self.MyImage.Width:=Self.fmyixmax-Self.fmyixmin;
  Self.MyImage.Height:=Self.fmyiymax;
  //SetLength(Colors,jmaxiterations);
  // for i := 0 to Length(Colors) do
  //      Colors[i] := RGB((i shr 5) * 36, ((i shr 3) and 7) * 36, (i and 3) * 85);
   //Form1.UpdateInfo();
   for x := Self.fmyixmin to Self.fmyixmax do
   begin
     for y := 0 to Self.fmyiymax  do
     begin
       // Check if the thread must forcibly terminate
       if Self.ForceTerminate then
       begin
         MyImage.Destroy;
         Self.Terminate;
         Exit;
       end;
       jzx := 2.0 * (x - Self.fFixmax / 2) / (0.5 * Self.fzoom * Self.fFixmax) + Self.fmoveX;
       jzy := 2.0 * (y - Self.fFiymax / 2) / (0.5 * Self.fzoom * Self.fFiymax) + Self.fmoveY;
       i := Self.fjmaxiterations;
       while (jzx * jzx + jzy * jzy < 4) and (i > 1) do
       begin
         tmp := jzx * jzx - jzy * jzy + fjcx;
         jzy := 2.0 * jzx * jzy + fjcy;
         jzx := tmp;
         i := i - 1;
       end;
       Self.ix:=x;
       Self.iy:=y;
       //MyImage.Canvas.Pixels[ix-myixmin,iy] := colors[i];
       Self.MyImage.Canvas.Pixels[Self.ix-Self.myixmin,Self.iy]:=$FFFFFF div (Self.fjmaxiterations*Self.Pallette)*i;
     end;
     Self.Synchronize(@ShowStatusX);
   end;
   Self.Synchronize(@CopyImage);
   MyImage.Destroy;
end;

{ TForm1 }
procedure TForm1.UpdateMandelbrotImage(ABitmap:TBitmap; Amyixmin, Amyixmax, Amyiymax: integer);
begin
  InitializeCriticalSection(ThreadLock);
  try
        if not saving then
           Image1.Canvas.CopyRect(Rect(Amyixmin,1,Amyixmax,Amyiymax),ABitmap.Canvas,Rect(1,1,Amyixmax-Amyixmin,Amyiymax))
        else
           Form2.SaveImage.Canvas.CopyRect(Rect(Amyixmin,1,Amyixmax,Amyiymax),ABitmap.Canvas,Rect(1,1,Amyixmax-Amyixmin,Amyiymax));
        ProgressBar2.Position:=ProgressBar2.Position+1;
        Form1.StopTime:=now;
        Label31.Font.Color:=clWhite - ColorToRGB(Image1.canvas.Pixels[10,10]);
        Label31.Caption:='Rendering Mandelbrot set: '+FloatToStrF(ProgressBar2.Position*100/ProgressBar2.Max,ffNumber,3,2)+'%; Time: '+ FormatDateTime('h"h "n"m "s"s"', Form1.StopTime-Form1.StartTime);
        ProgressBar2.Hint:=Label31.Caption;
        if ProgressBar2.Position=ProgressBar2.Max then
        begin
                EnableAllControls;
                JuliaSync:=False;
                ThreadsDone:=true;
        end;
  finally
        DeleteCriticalSection(ThreadLock);
  end;
end;

procedure TForm1.UpdateJuliaImage(ABitmap:TBitmap; Amyixmin, Amyixmax, Amyiymax: integer);
begin
  InitializeCriticalSection(ThreadLock);
  try
        if not saving then
          Image2.Canvas.CopyRect(Rect(Amyixmin,1,Amyixmax,Amyiymax),ABitmap.Canvas,Rect(1,1,Amyixmax-Amyixmin,Amyiymax))
        else
          Form2.SaveImage.Canvas.CopyRect(Rect(Amyixmin,1,Amyixmax,Amyiymax),ABitmap.Canvas,Rect(1,1,Amyixmax-Amyixmin,Amyiymax));
          ProgressBar1.Position:=ProgressBar1.Position+1;
          Form1.StopTime:=now;
          Label31.Font.Color:=clWhite - ColorToRGB(Image2.canvas.Pixels[10,10]);
          Label31.Caption:='Rendering Julia set: '+FloatToStrF(ProgressBar1.Position*100/ProgressBar1.Max,ffNumber,3,2)+'%; Time: '+ FormatDateTime('h"h "n"m "s"s"', Form1.StopTime-Form1.StartTime);
          ProgressBar1.Hint:=Label31.Caption;
          if ProgressBar1.Position=ProgressBar1.Max then
                begin
                        EnableAllControls;
                        //Form1.JuliaSync:=False;
                        ThreadsDone:=true;
                end;
  finally
        DeleteCriticalSection(ThreadLock);
  end;
end;
procedure TForm1.EnableAllControls;
begin
   Form1.BorderIcons:=[biMaximize, biMinimize, biSystemMenu];
   RadioGroup1.Enabled:=true;
   Edit1.Enabled:=true;
   UpDown1.Enabled:=true;
   BitBtn2.Enabled:=true;
   BitBtn3.Enabled:=true;
   Timer1.Enabled:=false;
end;
procedure TForm1.DisableAllControls;
begin
  Form1.BorderIcons:=[biSystemMenu];
  RadioGroup1.Enabled:=false;
  Edit1.Enabled:=false;
  UpDown1.Enabled:=false;
  BitBtn2.Enabled:=false;
  BitBtn3.Enabled:=false;
  Timer1.Enabled:=true;
end;
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  if GetCPUCount() > 2 then
     CPU:=GetCPUCount() -2
  else
     CPU:=GetCPUCount();
  try
  if Paramcount<>0 then
  begin
    if (StrToInt(paramstr(1)) <= 4*CPU) and
       (StrToInt(paramstr(1)) <> 0) then
           CPU:=StrToInt(paramstr(1));
  end;
  except

  end;
  Caption := 'Fractals on '+IntToStr(CPU)+' threads';
  SetLength(MandelProgress,CPU);
  ProgressBar2.Max:=CPU;
  SetLength(JuliaProgress,CPU);
  ProgressBar1.Max:=CPU;
  SetLength(MThreads,CPU);
  SetLength(JThreads,CPU);
  Image2.Picture.Bitmap.PixelFormat:=pf24bit;
  Image1.Picture.Bitmap.PixelFormat:=pf24bit;
  Image2.Align:=alClient;
  Image1.Align:=alClient;
  //SaveImage:=TImage.Create(nil);
  //SaveImage.Visible:=false;
  ASaveZoom:=StrToInt(Label32.Caption);
  ThreadsDone:=True;
  Image2.Hide;
  JuliaSync:=False;
  for i:=0 to CPU-1 do
  begin
    Mandelprogress[i]:=TProgressBar.Create(nil);
    MandelProgress[i].Parent:=Form1.Panel5;
    MandelProgress[i].Left:=Panel5.Width div CPU*i+5;
    MandelProgress[i].Width:=Panel5.Width div CPU-1;
    MandelProgress[i].Height:=18;
    MandelProgress[i].Top:=ProgressBar2.Top-22;
    MandelProgress[i].Enabled:=True;
    MandelProgress[i].Visible:=True;
    MandelProgress[i].Style:=pbstNormal;
    MandelProgress[i].Smooth:=False;
    MandelProgress[i].Hint:='Thread #'+IntToStr(i+1)+ ' progress';
    MandelProgress[i].ShowHint:=True;
    MandelProgress[i].BorderWidth:=1;
    MandelProgress[i].Orientation:=pbVertical;
  end;
    for i:=0 to CPU-1 do
  begin
    JuliaProgress[i]:=TProgressBar.Create(nil);
    JuliaProgress[i].Parent:=Form1.Panel7;
    JuliaProgress[i].Left:=Panel7.Width div CPU*i+5;
    JuliaProgress[i].Width:=Panel7.Width div CPU-1;
    JuliaProgress[i].Height:=18;
    JuliaProgress[i].Top:=ProgressBar1.Top-22;
    JuliaProgress[i].Enabled:=True;
    JuliaProgress[i].Visible:=True;
    JuliaProgress[i].Style:=pbstNormal;
    JuliaProgress[i].Smooth:=False;
    JuliaProgress[i].Hint:='Thread #'+IntToStr(i+1)+ ' progress';
    JuliaProgress[i].ShowHint:=True;
    JuliaProgress[i].BorderWidth:=1;
    JuliaProgress[i].Orientation:=pbVertical;
  end;

  Image1.Canvas.Brush.Color:=clWhite;
  Image1.Canvas.AutoRedraw:=True;
  Image2.Canvas.Brush.Color:=clWhite;
  Image2.Canvas.AutoRedraw:=True;
  UpdateDefaultParameters();
  UpdateInfo();
  x1:=1;
  x2:=1;
  y1:=1;
  y2:=1;
  MandelbrotDrawed:=False;
  Pallette:=1;
end;

procedure TForm1.UpdateInfo();
begin
  //Mandelbrot
  Label13.Caption :='cx1='+FloatToStrF(cxminabs,ffnumber,2,6);
  Label15.Caption :='cx2='+FloatToStrF(cxmaxabs,ffnumber,2,6);
  Label14.Caption :='cy1='+FloatToStrF(cyminabs,ffnumber,2,6);
  Label16.Caption :='cy2='+FloatToStrF(cymaxabs,ffnumber,2,6);
  Label13.Hint :='cx1='+FloatToStrF(cxminabs,ffnumber,2,22);
  Label15.Hint :='cx2='+FloatToStrF(cxmaxabs,ffnumber,2,22);
  Label14.Hint :='cy1='+FloatToStrF(cyminabs,ffnumber,2,22);
  Label16.Hint :='cy2='+FloatToStrF(cymaxabs,ffnumber,2,22);
  Label9.Caption  :='cx1='+FloatToStrF(cxmin,ffnumber,2,4);
  Label11.Caption :='cx2='+FloatToStrF(cxmax,ffnumber,2,4);
  Label10.Caption :='cy1='+FloatToStrF(cymin,ffnumber,2,4);
  Label12.Caption :='cy2='+FloatToStrF(cymax,ffnumber,2,4);
  Label9.Hint  :='cx1='+FloatToStrF(cxmin,ffnumber,2,22);
  Label11.Hint :='cx2='+FloatToStrF(cxmax,ffnumber,2,22);
  Label10.Hint :='cy1='+FloatToStrF(cymin,ffnumber,2,22);
  Label12.Hint :='cy2='+FloatToStrF(cymax,ffnumber,2,22);
  Label5.Caption  :='Top Left: ('+IntToStr(x1)+', '+IntToStr(y1)+')';
  Label6.Caption  :='Current:  ('+IntToStr(x2)+', '+IntToStr(y2)+')';
  Label17.Caption :='Resolution: '+IntToStr(ixmax)+' x '+IntToStr(iymax)+ ' pixels';
  Label33.Caption :='Zoom='+FloatToStrF(MZoom,ffnumber,2,2);
  //Julia
  Label21.Caption :='cx='+FloatToStrF(jcx,ffnumber,2,22);
  Label27.Caption :='cy='+FloatToStrF(jcy,ffnumber,2,22);
  Label29.Caption :='Top Left: ('+IntToStr(jx1)+', '+IntToStr(jy1)+')';
  Label30.Caption :='Current:  ('+IntToStr(jx2)+', '+IntToStr(jy2)+')';
  Label22.Caption :='Zoom='+FloatToStrF(Zoom,ffnumber,2,2);
  Label23.Caption :='Pan X='+FloatToStrF(MoveX,ffnumber,2,2);
  Label24.Caption :='Pan Y='+FloatToStrF(MoveY,ffnumber,2,2);
  Label23.Hint :='Pan X='+FloatToStrF(MoveX,ffnumber,2,22);
  Label24.Hint :='Pan Y='+FloatToStrF(MoveY,ffnumber,2,22);

  if JuliaSync then
  begin
    Label28.Caption:='Drawing Corresponding Julia Set With:';
    RadioGroup1.Items[1]:='Corresponding Julia Set';
    Panel8.Font.Color:=clRed;
    Panel7.BevelColor:=clRed;
    Panel8.BevelColor:=clRed;
    Panel13.BevelColor:=clRed;
    Panel14.BevelColor:=clRed;
    Label7.Font.Color:=clRed;
    Label20.Font.Color:=clRed;
    Label28.Font.Color:=clRed;
  end
  else
  begin
    Label28.Caption:='Drawing Default Julia Set With:';
    RadioGroup1.Items[1]:='Default Julia Set';
    Panel8.Font.Color:=clGreen;
    Panel7.BevelColor:=clGreen;
    Panel8.BevelColor:=clGreen;
    Panel13.BevelColor:=clGreen;
    Panel14.BevelColor:=clGreen;
    Label7.Font.Color:=clGreen;
    Label20.Font.Color:=clGreen;
    Label28.Font.Color:=clGreen;
  end;
end;

procedure TForm1.UpdateInfoNonCommitted(acx1,acx2,acy1,acy2:extended);
begin
  //Mandelbrot
  Label9.Caption  :='cx1='+FloatToStrF(acx1,ffnumber,2,4);
  Label11.Caption :='cx2='+FloatToStrF(acx2,ffnumber,2,4);
  Label10.Caption :='cy1='+FloatToStrF(acy1,ffnumber,2,4);
  Label12.Caption :='cy2='+FloatToStrF(acy2,ffnumber,2,4);
  Label9.Hint  :='cx1='+FloatToStrF(acx1,ffnumber,2,22);
  Label11.Hint :='cx2='+FloatToStrF(acx2,ffnumber,2,22);
  Label10.Hint :='cy1='+FloatToStrF(acy1,ffnumber,2,22);
  Label12.Hint :='cy2='+FloatToStrF(acy2,ffnumber,2,22);

  //if JuliaSync then
  //begin
  //  Label28.Caption:='Drawing Corresponding Julia Set With:';
  //  RadioGroup1.Items[1]:='Corresponding Julia Set';
  //  Panel8.Font.Color:=clRed;
  //end
  //else
  //begin
  //  Label28.Caption:='Drawing Default Julia Set With:';
  //  RadioGroup1.Items[1]:='Default Julia Set';
  //  Panel8.Font.Color:=clGreen;
  //end;
end;
procedure TForm1.UpdateDefaultParameters();
begin
//Julia
    jcx := -0.7;
    jcy :=  0.27015;
    zoom:=1;
    moveX:=0;
    moveY:=0;

//Mandelbrot
    cxmin := -2.01;
    cxmax :=  2.01;
    cymin := -2.01;
    cymax :=  2.01;
    cxminabs := -2.01;
    cxmaxabs :=  2.01;
    cyminabs := -2.01;
    cymaxabs :=  2.01;
    MZoom:=1;
end;




procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if saving then exit;
case Button of
  mbleft:
    begin
      if Shift=[ssShift, ssLeft] then
      begin
          //Mandelbrot
          x1 := X;
          y1 := Y;
          if (x2=x1) then inc(x2);
          if (y2=y1) then inc(y2);
          Shape1.Height:=0;
          Shape1.Width:=0;
          Shape1.Left:=x1;
          Shape1.Top:=y1;
          Shape1.Show;
          if cxmaxabs=cxminabs then
          begin
            MessageBox(0,PChar('Max zoom reached.'),PChar('The end'),MB_ICONWARNING);
            Shape1.Hide;
            Exit;
          end
          else
          begin
            cxmin := x1/(Image1.Width/(cxmaxabs-cxminabs))-cxmaxabs;
            cxmax := x2/(Image1.Width/(cxmaxabs-cxminabs))-cxmaxabs;
            cymin := - (y1/(Image1.Height/(cymaxabs-cyminabs)) - cymaxabs);
            cymax := - (y2/(Image1.Height/(cymaxabs-cyminabs)) - cymaxabs);
            UpdateInfo();
          end;
          Shape1.Canvas.CopyRect(Rect(0,0,Shape1.Width,Shape1.Height),Image1.Canvas,Rect(x1,y1,x2,y2));
       end;
    end;
  mbRight:
    begin
      //Mandelbrot
      //set values for the related Julia set
      jcx:=acxmax;
      jcy:=acymax;
      zoom:=1;
      MoveX:=0;
      MoveY:=0;
      JuliaSync:=True;
      RadioGroup1.ItemIndex:=1;
      UpdateInfo();
      sleep(1000);
      //weird happening: mouse down on Image1 triggers Mouse up on Image2
      //Setting the above tells the system the mouse was pressed on Mandelbrot.
      Form1.MouseDownFromMandelbrot:=True;
    end;
  end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  divergence: string;

begin
  //Mandelbrot
  if saving then exit;
    if (cxmaxabs-cxminabs=0) or
       (cymaxabs-cyminabs=0) then
       begin
         exit;
       end
    else
       begin
         divergence:=(Self.Image1.Canvas.Pixels[X,Y]*StrToInt(Edit1.Text) div $FFFFFF).ToString;
         if divergence.ToInteger()/StrToInt(Edit1.Text)> 0.9999 then divergence:='none';
         Label26.Caption:='Divergence: '+divergence;

         x2 := X;
         y2 := Y;
         if (x2>ixmax) then x2:=ixmax;
         if (y2>iymax) then y2:=iymax;
         if (x2=x1) then inc(x2);
         if (y2=y1) then inc(y2);
         if (x2=0) then x2:=1
         else if (y2=0) then y2:=1
         else
         if Shift = [ssShift, ssLeft] then
         begin
            cxmin := x1/(Image1.Width/(cxmaxabs-cxminabs))-cxmaxabs;
            cxmax := x2/(Image1.Width/(cxmaxabs-cxminabs))-cxmaxabs;
            cymin := - (y1/(Image1.Height/(cymaxabs-cyminabs)) - cymaxabs);
            cymax := - (y2/(Image1.Height/(cymaxabs-cyminabs)) - cymaxabs);
            UpdateInfo();
            //Shape1.Canvas.Unlock;
            Shape1.Left:=x1;
            Shape1.Top:=y1;
            Shape1.Width:=x2-x1;
            Shape1.Height:=y2-y1;
            //Shape1.Canvas.CopyRect(Rect(0,0,Shape1.Width,Shape1.Height),Image1.Canvas,Rect(x1,y1,x2,y2));
            //Shape1.Canvas.Lock;
         end
       else
       begin
          acxmin := x1/(Image1.Width/(cxmaxabs-cxminabs))-cxmaxabs;
          acxmax := x2/(Image1.Width/(cxmaxabs-cxminabs))-cxmaxabs;
          acymin := - (y1/(Image1.Height/(cymaxabs-cyminabs)) - cymaxabs);
          acymax := - (y2/(Image1.Height/(cymaxabs-cyminabs)) - cymaxabs);
          UpdateInfo();
          UpdateInfoNonCommitted(acxmin,acxmax,acymin,acymax);
       end;


       end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if saving then exit;
  if (Button = mbLeft) and (Shift=[ssShift]) then
  begin
      //Mandelbrot
          cxminabs := - cxmax; //nush de ce sunt cu minus si inversate
          cxmaxabs := - cxmin;
          cyminabs := cymax; //inversate din cauza axei y
          cymaxabs := cymin;
          Shape1.Hide;
          if (cxmaxabs-cxminabs=0) or
          (cymaxabs-cyminabs=0) then
          begin
            MessageBox(0,PChar('Max zoom reached.'),PChar('The end'),MB_ICONWARNING);
            Exit;
          end;
          if ((x2<>x1) and (y2<>y1) and MandelbrotDrawed) then BitBtn2Click(Nil);
          MZoom:=MZoom*Min((ixmax)/(x2-x1),(iymax)/(y2-y1))*0.95;
  end;
end;

procedure TForm1.Image1Resize(Sender: TObject);
begin
  ixmax:=Image1.Width;
  iymax:=Image1.Height;
  Image1.Picture.Bitmap.SetSize(ixmax, iymax);

end;

procedure TForm1.Image1SizeConstraintsChange(Sender: TObject);
begin

end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//Julia
  if saving then exit;
  case Button of
  mbleft:
    begin
      if Shift=[SSShift, ssLeft] then
      begin
        jx1 := X;
        jy1 := Y;
        Shape1.Height:=0;
        Shape1.Width:=0;
        Shape1.Left:=jx1;
        Shape1.Top:=jy1;
        Shape1.Show;
        UpdateInfo();
      end;
    end;
  mbright: Form1.MouseDownFromMandelbrot:=False;
  end;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  divergence:String;
begin
  //Julia
    if saving then exit;
    jx2 := X;
    jy2 := Y;
    if (jx2>ixmax) then jx2:=ixmax;
    if (jy2>iymax) then jy2:=iymax;
    if (jx2=x1) then inc(jx2);
    if (jy2=y1) then inc(jy2);
    if (jx2=0) then jx2:=1
    else
    if (jy2=0) then
       jy2:=1;
    divergence:=(Self.Image2.Canvas.Pixels[X,Y]*StrToInt(Edit1.Text) div $FFFFFF).ToString;
    if divergence.ToInteger()/StrToInt(Edit1.Text)> 0.9999 then divergence:='none';
    Label34.Caption:='Divergence: '+divergence;
    UpdateInfo();
    Shape1.Left:=jx1;
    Shape1.Top:=jy1;
    Shape1.Width:=jx2-jx1;
    Shape1.Height:=jy2-jy1;
end;

procedure TForm1.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin
  if saving then exit;
  case Button of
  mbleft:
  begin
      if Shift=[ssShift] then
      begin
       //Julia
       //zoom computation will take into account the lowest between X and Y:
         if ((jx2-jx1>10) and (jy2-jy1>10)) then
         begin

            //3rd iteration (first two iterations were wrong)
            //1. We can find the complex coordinates for the top-left and bottom-right corners of the drawn rectangle:
            re_left:=   MoveX+2*(jx1-ixmax/2)/(0.5*ixmax*zoom);
            im_top:=    MoveY+2*(jy1-iymax/2)/(0.5*iymax*zoom);
            re_right:=  MoveX+2*(jx2-ixmax/2)/(0.5*ixmax*zoom);
            im_bottom:= MoveY+2*(jy2-iymax/2)/(0.5*iymax*zoom);
             //2. Calculate the new center (newMoveX, newMoveY)
             MoveX:=(re_left+re_right)/2;
             MoveY:=(im_top+im_bottom)/2;
             //3. Calculate the new zoom (newZoom)
             //   The new zoom is determined by how much the new viewport's width and height have shrunk compared to
             //   the old one. To maintain the aspect ratio of the display, you should use the larger of the two scaling factors.
             zoom_x:=zoom*ixmax/(jx2-jx1);
             zoom_y:=zoom*iymax/(jy2-jy1);
             zoom:=min(zoom_x, zoom_y)*0.95; //0.95 just to make it a little bit smaller AND FIT THE VIEWPORT BETTER
           UpdateInfo();
           BitBtn2Click(Nil);
         end;
         Shape1.Hide;
      end;
    end;
   mbRight:
   begin
    //this only happens when middle button is clicked on Image1 but MouseUp event happens on Image2
     //actually it happens also on right click on Image2 but it has no effect, just a redraw
    if Form1.MouseDownFromMandelbrot then //Julia Draw with Mandelbrot correspondent
       BitBtn2Click(Nil)
    else
    begin   //switch back to Draw Mandelbrot
       RadioGroup1.ItemIndex:=0;
       //UpdateDefaultParameters;  only if we wish a full redraw of Mandelbrot when coming back from Julia
       BitBtn2Click(Nil);
    end;
   end;
  end;
end;



procedure TForm1.Image2Resize(Sender: TObject);
begin
  ixmax:=Image2.Width;
  iymax:=Image2.Height;
  Image2.Picture.Bitmap.SetSize(ixmax, iymax);
end;

procedure TForm1.Label32Click(Sender: TObject);
begin

end;

procedure TForm1.RadioGroup1SelectionChanged(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    1:
    begin
      Image1.Hide;
      Image2.Show;
    end;
    0:
    begin
      Image1.Show;
      Image2.Hide;
    end;
  end;
end;

procedure TForm1.RadioGroup2SelectionChanged(Sender: TObject);
begin
  case RadioGroup2.ItemIndex of
    0: Form1.Pallette:=1;
    1: Form1.Pallette:=25;
    2: Form1.Pallette:=50;
    3: Form1.Pallette:=100;
  end;
end;

procedure TForm1.SaveDialog1TypeChange(Sender: TObject);
var
  sa: TStringArray;
  index: Integer;
begin
  sa := SaveDialog1.Filter.Split('|');
  index := (SaveDialog1.FilterIndex - 1) * 2;
  SaveDialog1.DefaultExt := sa[index];
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  case Timerset of
    J:
    begin
      StopTime:=now;
      Label31.Font.Color:=clWhite - ColorToRGB(Image2.canvas.Pixels[10,10]);
      Label31.Caption:='Rendering Julia set: '+FloatToStrF(ProgressBar1.Position*100/ProgressBar1.Max,ffNumber,3,2)+'%; Time: '+ FormatDateTime('h"h "n"m "s"s"', Form1.StopTime-Form1.StartTime);
      ProgressBar1.Hint:=Label31.Caption;
    end;
    M:
    begin
      StopTime:=now;
      Label31.Font.Color:=clWhite - ColorToRGB(Image1.canvas.Pixels[10,10]);
      Label31.Caption:='Rendering Mandelbrot set: '+FloatToStrF(ProgressBar2.Position*100/ProgressBar2.Max,ffNumber,3,2)+'%; Time: '+ FormatDateTime('h"h "n"m "s"s"', Form1.StopTime-Form1.StartTime);
      ProgressBar2.Hint:=Label31.Caption;
    end;
  end;
end;



procedure TForm1.UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: SmallInt; Direction: TUpDownDirection);
const
  clOrange: TColor = $00A5FF ;
var
  i:integer;
begin
  i:=StrToInt(Label32.Caption);

  case Direction of
       updUp:
             inc(i);
       updDown:
               dec(i);
  end;
  if (i<1)  then i:=1;
  if (i>35) then i:=35;
  ASaveZoom:=i;
  Label32.Caption:=i.ToString;
  case i of
  1..5:
       begin
         Label32.Font.Color:=clGreen;
         Label35.Font.Color:=clGreen;
       end;
  6..10:
       begin
         Label32.Font.Color:=clOrange;
         Label35.Font.Color:=clOrange;
       end;
  11..99:
       begin
         Label32.Font.Color:=clRed;
         Label35.Font.Color:=clRed;
       end;
  end;
end;



procedure TForm1.BitBtn2Click(Sender: TObject);
var
  i:integer;
begin
  StartTime:=now;
  DisableAllControls;
  ThreadsDone:=False;
  if (Sender<>Nil) then
  begin
    if not JuliaSync then
       UpdateDefaultParameters()
    else
    begin
      zoom:=1;
      moveX:=0;
      moveY:=0;
    end;
    UpdateInfo();
  end;
  case RadioGroup1.ItemIndex of
    1:
    begin
      Label31.Caption:='Rendering Julia set: 0%';
      Form1.ProgressBar1.Position:=0;
      for i:=0 to CPU-1 do
      begin
          Juliaprogress[i].Position:=0;
      end;
      TimerSet:=J;
      for i:=Low(JThreads) to High(JThreads)  do
      begin
         JThreads[i]:=TMyJuliaThread.Create(False, i);
         JThreads[i].Start;
      end;
    end;
    0:
    begin
      //if Sender=nil then JuliaSync :=true;
      MandelbrotDrawed:=true;
      Label31.Caption:='Rendering Mandelbrot set: 0%';
      Form1.ProgressBar2.Position:=0;
      for i:=0 to CPU-1 do
      begin
          Mandelprogress[i].Position:=0;
      end;
      TimerSet:=M;
      for i:=Low(MThreads) to High(MThreads)  do
      begin
         MThreads[i]:=TMyMandelbrotThread.Create(False, i);
         MThreads[i].Start;
      end;
    end;
  end;

end;

procedure TForm1.Action1Execute(Sender: TObject);
begin

end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  Jpg: TJPEGImage;
  oldixmax, oldiymax: integer;
begin
  DisableAllControls;
  Form1.BorderIcons:=[];
  Jpg := TJPEGImage.Create;
  Saving:=true;
  if Image1.Visible=True then
  begin
     SaveDialog1.FileName:='Mandelbrot Set with ' +
     Edit1.Text +
     ' iterations, at viewport [( ' +
     FloatToStrF(cxminabs,ffnumber,2,2) +
     ' , ' +
     FloatToStrF(cyminabs,ffnumber,2,2) +
     ' ) , ( ' +
     FloatToStrF(cxmaxabs,ffnumber,2,2) +
     ' , ' +
     FloatToStrF(cymaxabs,ffnumber,2,2) +
     ' )] ';
     Label31.Caption:='Rendering Mandelbrot set: 0%';
  end
  else
  begin
     SaveDialog1.FileName:='Julia Set with ' +
     Edit1.Text +
     ' iterations, c =  [( ' +
     FloatToStrF(jcx,ffnumber,2,2) +
     ' , ' +
     FloatToStrF(jcy,ffnumber,2,2) +
     ' ) , Pan ( ' +
     FloatToStrF(MoveX,ffnumber,2,2) +
     ' , ' +
     FloatToStrF(MoveY,ffnumber,2,2) +
     ' )], Zoom = ' +
     FloatToStrF(zoom,ffnumber,2,2);
     Label31.Caption:='Rendering Julia set: 0%';
  end;
  if ASaveZoom<>1 then
  begin
     SaveDialog1.Title:='Save zoomed x'+ASaveZoom.ToString+' ('+(Image1.Width*ASaveZoom).ToString()+'x'+(Image1.Height*ASaveZoom).ToString()+') image';
     SaveDialog1.FileName:=SaveDialog1.FileName + ' zoomed x' + ASaveZoom.ToString;
  end
  else
      SaveDialog1.Title:='Save original ('+Image1.Width.ToString()+'x'+Image1.Height.ToString()+') image';
  if SaveDialog1.Execute then
  begin
    case SaveDialog1.FilterIndex of
      1:   //bitmap file
      begin
        if ASaveZoom<>1 then
        begin
             oldixmax:=ixmax;
             oldiymax:=iymax;
             Form2.Width:=Image1.Width*ASaveZoom+Form2.BorderWidth*2;
             Form2.height:=Image1.Height*ASaveZoom+Form2.BorderWidth*2;
             Form2.SaveImage.Width:=Image1.Width*ASaveZoom;
             Form2.SaveImage.height:=Image1.Height*ASaveZoom;
             Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width,Form2.Height);
             Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width, Form2.Height);
             Form2.button.Left:=Form2.Width+1;
             Form2.button.Top:=Form2.Height+1;
             ThreadsDone:=false;
             BitBtn2click(nil);
             repeat Application.ProcessMessages until ThreadsDone;
             ixmax:=oldixmax;
             iymax:=oldiymax;
             Form2.SaveImage.Picture.Bitmap.SaveToFile(SaveDialog1.FileName);
             Form2.Width:=800;
             Form2.height:=600;
             Form2.SaveImage.Width:=Image1.Width*ASaveZoom;
             Form2.SaveImage.height:=Image1.Height*ASaveZoom;
             Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width,Form2.Height);
             Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width, Form2.Height);
             Form2.button.Left:=Form2.Width+1;
             Form2.button.Top:=Form2.Height+1;
        end
        else
        begin
          if Image1.Visible then
             Image1.Picture.Bitmap.SaveToFile(SaveDialog1.FileName)
          else
             Image2.Picture.Bitmap.SaveToFile(SaveDialog1.FileName);

        end;
      end;
      2:   //jpg file
      begin
        if ASaveZoom<>1 then
        begin
          oldixmax:=ixmax;
          oldiymax:=iymax;
          Form2.Width:=Image1.Width*ASaveZoom+Form2.BorderWidth*2;
          Form2.height:=Image1.Height*ASaveZoom+Form2.BorderWidth*2;
          Form2.SaveImage.Width:=Image1.Width*ASaveZoom;
          Form2.SaveImage.height:=Image1.Height*ASaveZoom;
          Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width,Form2.Height);
          Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width, Form2.Height);
          Form2.button.Left:=Form2.Width+1;
          Form2.button.Top:=Form2.Height+1;
          ThreadsDone:=false;
          BitBtn2click(nil);
          repeat Application.ProcessMessages until ThreadsDone;
          ixmax:=oldixmax;
          iymax:=oldiymax;
          Jpg := TJPEGImage.Create;
          Jpg.Assign(Form2.SaveImage.Picture.Graphic);
          Jpg.CompressionQuality := 100;
          Jpg.SaveToFile(SaveDialog1.FileName);
          Form2.Width:=800;
          Form2.height:=600;
          Form2.SaveImage.Width:=Image1.Width*ASaveZoom;
          Form2.SaveImage.height:=Image1.Height*ASaveZoom;
          Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width,Form2.Height);
          Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width, Form2.Height);
          Form2.button.Left:=Form2.Width+1;
          Form2.button.Top:=Form2.Height+1;
        end
        else
        begin
           Jpg := TJPEGImage.Create;
          if Image1.Visible then
             Jpg.Assign(Image1.Picture.Graphic)
          else
             Jpg.Assign(Image2.Picture.Graphic);
          Jpg.CompressionQuality := 100;
          Jpg.SaveToFile(SaveDialog1.FileName);
        end;
      end;
    end;
    Messagebox(0,PChar('The file '+SaveDialog1.FileName+' was created.'), PChar('Image saved'), MB_ICONINFORMATION);
  end;
  Jpg.Free;
  Saving:=false;
  EnableAllControls;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  If StrToInt(Edit1.Text) > 10000000 then Edit1.Text:='10000000';
  case StrToInt(Edit1.Text) of
  0..5000: Edit1.Font.Color:=clGreen;
  5001..10000:Edit1.Font.Color:=clTeal;
  10001..20000:Edit1.Font.Color:=clMaroon;
  20001..100000000:Edit1.Font.Color:=clRed;
  end;
  if Edit1.Text='' then Edit1.Text:='1';
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i:integer;
begin
     //send forceful termination flag
     for i:=Low(JThreads) to High(JThreads)  do
     begin
       if Assigned(JThreads[i]) then
          JThreads[i].InitTerminate;
       if Assigned(MThreads[i]) then
          MThreads[i].InitTerminate;
       Application.ProcessMessages;
       JThreads[i]:=nil;
       MThreads[i]:=nil;
     end;
     // Check all threads are terminated, if they exist

     for i:=Low(JThreads) to High(JThreads)  do
     begin
       if Assigned(JThreads[i]) then JThreads[i].WaitFor;
       if Assigned(MThreads[i]) then MThreads[i].WaitFor;
     end;

     //Tell the form it may close now
     CanClose:=true;
 end;





end.

