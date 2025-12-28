unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ComCtrls, LCLIntf, LCLType, ActnList, Menus, Math, Types, unit2 {$IFDEF UNIX},initc,ctypes {$ENDIF};

type
  //composite data used to initialize Mandelbrot threads
TMInitParam = record
    CPU:           integer  ;    //thread number. Tied to CPU cores but can be overridden by running parameter
    Fcxmin:        extended ;    //c values to plot
    Fcxmax:        extended ;
    Fcymin:        extended ;
    Fcymax:        extended ;
    Fixmax:        int64    ;    //pixels to plot on X axis
    Fiymax:        int64    ;    //pixels to plot on Y axis
    SaveZoom:      integer  ;    //the zoom used if saving a image
    Pallette:      integer  ;    //color palette. not used yet
    MaxIterations: integer  ;    //Max Iterations for divergence
end;

TJInitParam = record
    CPU:               integer;  //thread number. Tied to CPU cores but can be overridden by running parameter
    SaveZoom:          integer;  //the zoom used if saving a image
    Fixmax:            int64;    //pixels to plot on X axis
    Fiymax:            int64;    //pixels to plot on Y axis
    jcx:               extended; //c value to plot for. Can be synced to Mandelbrot set
    jcy:               extended;
    zoom:              extended; //computed zoom to display a detail
    MoveX:             extended; //computed DX and DY to display a detail
    MoveY:             extended;
    jmaxiterations:    integer;  //Max Iterations for divergence
    Pallette:          integer;  //color palette. not used yet
end;



  { TMyMandelbrotThread }

  TMyMandelbrotThread = class(TThread)
      {custom procedures}
    //main procedure to render an image slice
    procedure DoMandelBrot(ParamThreadNumber: integer);

  private
    fix, fiy, fcolor: int64;
    fThreadNumber:integer;
    fmyixmin, fmyixmax, fmyiymin, fmyiymax: int64;
    MyImage: TBitmap;
    fMInitParam: TMInitParam;
    fForceTerminate: boolean;
    procedure CopyImage;    // procedure that copies the rendered image slice
    procedure ShowStatusY;  // procedure that returns the work status

  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean; ParamThreadNumber:integer; MInitRecord:TMInitParam);
    procedure InitTerminate;
    property CPU:           integer  read fMInitParam.CPU            write fMInitParam.CPU;
    property Fcxmin:        extended read fMInitParam.Fcxmin         write fMInitParam.Fcxmin;
    property Fcxmax:        extended read fMInitParam.Fcxmax         write fMInitParam.Fcxmax;
    property Fcymin:        extended read fMInitParam.Fcymin         write fMInitParam.Fcymin;
    property Fcymax:        extended read fMInitParam.Fcymax         write fMInitParam.Fcymax;
    property Fixmax:        int64    read fMInitParam.Fixmax         write fMInitParam.Fixmax;
    property Fiymax:        int64    read fMInitParam.Fiymax         write fMInitParam.Fiymax;
    property MaxIterations: integer  read fMInitParam.MaxIterations  write fMInitParam.MaxIterations;
    property SaveZoom:      integer  read fMInitParam.SaveZoom       write fMInitParam.SaveZoom;
    property Pallette:      integer  read fMInitParam.Pallette       write fMInitParam.Pallette;
    property ix:            int64    read fix                        write fix;
    property iy:            int64    read fiy                        write fiy;
    property myixmin:       int64    read fmyixmin                   write fmyixmin;
    property myixmax:       int64    read fmyixmax                   write fmyixmax;
    property myiymin:       int64    read fmyiymin                   write fmyiymin;
    property myiymax:       int64    read fmyiymax                   write fmyiymax;
    property color:         int64    read fcolor                     write fcolor;
    property ThreadNumber:  integer  read fThreadNumber              write fThreadNumber;
    property ForceTerminate:boolean  read fForceTerminate            write fForceTerminate;

end;

{ TMyJuliaThread }

  TMyJuliaThread = class(TThread)
      {custom procedures}
    //main procedure to render an image slice
    procedure DoJulia(ParamThreadNumber: integer);

  private
    fJInitParam: TJInitParam;
    fix, fiy, fcolor: int64;
    fThreadNumber:integer;
    fmyixmin, fmyixmax, fmyiymin, fmyiymax: int64;
    MyImage: TBitmap;
    fForceTerminate: boolean;

    procedure CopyImage;
    procedure ShowStatusX;

  protected
    procedure Execute; override;

  public
    constructor Create(CreateSuspended: boolean; ParamThreadNumber:integer; JInitRecord:TJInitParam);
    procedure InitTerminate;
    property CPU:           integer  read fJInitParam.CPU            write fJInitParam.CPU;
    property SaveZoom:      integer  read fJInitParam.SaveZoom       write fJInitParam.SaveZoom;
    property Fixmax:        int64    read fJInitParam.Fixmax         write fJInitParam.Fixmax;
    property Fiymax:        int64    read fJInitParam.Fiymax         write fJInitParam.Fiymax;
    property jcx:           extended read fJInitParam.jcx            write fJInitParam.jcx;
    property jcy:           extended read fJInitParam.jcy            write fJInitParam.jcy;
    property zoom:          extended read fJInitParam.zoom           write fJInitParam.zoom;
    property MoveX:         extended read fJInitParam.MoveX          write fJInitParam.MoveX;
    property MoveY:         extended read fJInitParam.MoveY          write fJInitParam.MoveY;
    property jmaxiterations:integer  read fJInitParam.jmaxiterations write fJInitParam.jmaxiterations;
    property Pallette:      integer  read fJInitParam.Pallette       write fJInitParam.Pallette;
    property ix:            int64    read fix                        write fix;
    property iy:            int64    read fiy                        write fiy;
    property myixmin:       int64    read fmyixmin                   write fmyixmin;
    property myixmax:       int64    read fmyixmax                   write fmyixmax;
    property myiymin:       int64    read fmyiymin                   write fmyiymin;
    property myiymax:       int64    read fmyiymax                   write fmyiymax;
    property color:         int64    read fcolor                     write fcolor;
    property ThreadNumber:  integer  read fThreadNumber              write fThreadNumber;
    property ForceTerminate:boolean  read fForceTerminate            write fForceTerminate;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ColorDialog1: TColorDialog;
    Edit1: TEdit;
    JuliaImage: TImage;
    Label1: TLabel;
    Mcy1curLabel: TLabel;
    Mcx2curLabel: TLabel;
    Mcy2curLabel: TLabel;
    Mcx1minLabel: TLabel;
    Mcy1minLabel: TLabel;
    Mcx2minLabel: TLabel;
    Mcy2minLabel: TLabel;
    MResolutionLabel: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    JcxLabel: TLabel;
    JZoomLabel: TLabel;
    JPanXLabel: TLabel;
    JPanYLabel: TLabel;
    Label25: TLabel;
    MDivergenceLabel: TLabel;
    JcyLabel: TLabel;
    JDrawingLabel: TLabel;
    JX1Label: TLabel;
    Label3: TLabel;
    JX2Label: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    MZoomLabel: TLabel;
    JDivergenceLabel: TLabel;
    Label35: TLabel;
    Label4: TLabel;
    MTopLeftCoordinatesLabel: TLabel;
    MCurrentCoordinatesLabel: TLabel;
    Label7: TLabel;
    Mcx1curLabel: TLabel;
    MandelbrotImage: TImage;
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
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure MandelbrotImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MandelbrotImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure MandelbrotImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MandelbrotImageResize(Sender: TObject);

    procedure JuliaImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JuliaImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure JuliaImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JuliaImageResize(Sender: TObject);
    procedure Label32Click(Sender: TObject);
    procedure RadioGroup1SelectionChanged(Sender: TObject);
    procedure RadioGroup2SelectionChanged(Sender: TObject);
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: SmallInt; Direction: TUpDownDirection);



  private
  CPU: integer; //number of CPUs in the system. Used to compute the threads number
  //The following variable needs a special comment:
  //right clicking the mouse on Mandelbrot image triggers a Mouse up event on Julia image
  //because the code switches to that image.
  //Setting the above when clicking informs the system that the mouse was clicked on Mandelbrot image.
  MouseDownFromMandelbrot: boolean;
  MandelbrotDrawed: boolean;    //Mandelbrot was rendered prior to render Julia
  ThreadLock: TCriticalSection; //section used to avoid copying simultaneously image slices in the big M/J image
  Saving: boolean;              //the software is saving an image
  ASaveZoom:integer;            //zoom used for the saved image
  ThreadsDone:boolean;          //all threads terminated their job
  TimerSet: (J,M);              //needed to properly write the time elapsed for M or J

  //Mandelbrot specific variables
  x1,x2,y1,y2:integer;                       //viewport coordinates
  cxmin, cxmax, cymin, cymax : extended;     //c range to plot
  acxmin: extended;                          //c range to inform about
  acxmax: extended;
  acymin: extended;
  acymax: extended;
  cxminabs, cxmaxabs, cyminabs, cymaxabs : extended; //absolute c coordinates
  ixmax, iymax: int64;                               //max viewport coordinates
  MandelProgress: array of TProgressbar;             //Mandelbrot render progress
  MThreads : array of TMyMandelbrotThread;           //threads used to render Mandelbrot
  Mzoom: extended;                                   //Mandelbrot image zoom
  StartTime, StopTime: TDateTime;                    //time elapsed on rendering

  //Julia                                            //zoom and displacement for Julia detail
  zoom, moveX, moveY: extended;                      //c for which Julia is rendered
  jcx, jcy: extended;                                //Julia viewport coordinates
  jx1, jx2, jy1, jy2:integer;
  JuliaProgress: array of TProgressbar;              //Julia render progress
  JuliaSync: boolean;                                //Julia set is synced with Mandelbrot
  JThreads : array of TMyJuliaThread;                //threads used to render Julia
  re_left, im_top: extended;                         //temp values used to compute viewport coordinates
  re_right, im_bottom: extended;
  zoom_x, zoom_y: extended;
  Pallette: integer;                                 //not used yet
  procedure UpdateInfo();
  procedure UpdateInfoNonCommitted(acx1,acx2,acy1,acy2:extended);
  procedure UpdateDefaultParameters();
  procedure UpdateMandelbrotImage(ABitmap:TBitmap; Amyixmin, Amyixmax, Amyiymax: integer);
  procedure UpdateJuliaImage(ABitmap:TBitmap; Amyixmin, Amyixmax, Amyiymax: integer);
  procedure DisableAllControls;                      //disable controls while rendering/saving
  procedure EnableAllControls;                       //enable controls after rendering/saving

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TMyMandelbrotThread }

constructor TMyMandelbrotThread.Create(CreateSuspended: boolean; ParamThreadNumber:integer; MInitRecord:TMInitParam);
begin
  Self.CPU           := MInitRecord.CPU;
  Self.Fcxmin        := MInitRecord.Fcxmin;
  Self.Fcxmax        := MInitRecord.Fcxmax;
  Self.Fcymin        := MInitRecord.Fcymin;
  Self.Fcymax        := MInitRecord.Fcymax;
  Self.Fixmax        := MInitRecord.Fixmax;
  Self.Fiymax        := MInitRecord.Fiymax;
  Self.Fiymax        := MInitRecord.Fiymax;
  Self.MaxIterations := MInitRecord.MaxIterations;
  Self.Pallette      := MInitRecord.Pallette;
  Self.ThreadNumber  :=ParamThreadNumber;
  Self.ForceTerminate:=false;
  inherited Create(CreateSuspended);
end;

procedure TMyMandelbrotThread.Execute;
begin
  Self.FreeOnTerminate:=true;
  Self.DoMandelBrot(Self.ThreadNumber);
  //Self.Terminate;
  //Self.Free;
end;
procedure TMyMandelbrotThread.InitTerminate;
begin
  //when the main form is closed before
  //the threads terminated their work,
  //each thread is informed that it
  //should terminate. The main working
  //thread is verifying this value on
  //each loop and it exits the loop if the value is true.
  Self.ForceTerminate:=true;
end;

procedure TMyMandelbrotThread.CopyImage;
// this method is only called by Synchronize(@ShowStatus)
// and therefore it is executed by the main thread
// The main thread can access GUI elements.
begin
  Form1.UpdateMandelbrotImage(MyImage, myixmin, myixmax, myiymax);
end;

procedure TMyMandelbrotThread.ShowStatusY;
// this method is only called by Synchronize(@ShowStatus) and therefore
// executed by the main thread
// The main thread can access GUI elements.
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
   localix, localiy       : integer;
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
      Self.myixmin:=Self.Fixmax div Self.CPU * Self.ThreadNumber;
      Self.myixmax:=Self.Fixmax div Self.CPU + Self.myixmin+Self.CPU;
      Self.MyImage:=TBitmap.Create;
      Self.MyImage.Width:=Self.myixmax-Self.myixmin;
      Self.MyImage.Height:=Self.myiymax;
      pixelwidth   := (Self.Fcxmax - Self.Fcxmin) / Self.Fixmax;
      pixelheight  := (Self.Fcymax - Self.Fcymin) / Self.Fiymax;
      maxiteration:=Self.MaxIterations;
      for localiy := 1 to myiymax do
      begin
         //BitBtn2.Font.Color:=$FFFFFF div iymax - iy;
         //BitBtn2.Repaint;
         cy := Self.Fcymin + (iy - 1)*pixelheight;
         if abs(cy) < pixelheight / 2 then cy := 0.0;
         for localix := Self.myixmin to Self.myixmax do
         begin
            //check if the thread must terminate forcibly
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
            //MandelbrotImage.Canvas.Pixels[ix,iy]:=$FFFFFF div maxiteration*iteration;
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

constructor TMyJuliaThread.Create(CreateSuspended: boolean; ParamThreadNumber:integer; JInitRecord:TJInitParam);
begin
     Self.CPU:=JInitRecord.CPU;
     Self.SaveZoom:=JInitRecord.SaveZoom;
     Self.jcx:=JInitRecord.jcx;
     Self.jcy:=JInitRecord.jcy;
     Self.zoom:=JInitRecord.zoom;
     Self.MoveX:=JInitRecord.moveX;
     Self.MoveY:=JInitRecord.moveY;
     Self.jmaxiterations:=JInitRecord.jmaxiterations;
     Self.Pallette:=JInitRecord.Pallette;
     Self.Fixmax:=JInitRecord.Fixmax;
     Self.Fiymax:=JInitRecord.Fiymax;
     Self.ThreadNumber:=ParamThreadNumber;
     Self.ForceTerminate:=false;
     inherited Create(CreateSuspended);

end;

procedure TMyJuliaThread.Execute;
begin
  Self.FreeOnTerminate:=true;
  Self.DoJulia(Self.ThreadNumber);
end;
procedure TMyJuliaThread.InitTerminate;
begin
  Self.ForceTerminate:=true;
end;
procedure TMyJuliaThread.CopyImage;
// this method is only called by Synchronize(@ShowStatus) and therefore
// executed by the main thread
// The main thread can access GUI elements, i.e. Form1.whateverpropertyormethod.
begin
  Form1.UpdateJuliaImage(MyImage, myixmin, myixmax, myiymax);
end;

procedure TMyJuliaThread.ShowStatusX;
// this method is only called by Synchronize(@ShowStatus) and therefore
// executed by the main thread
// The main thread can access GUI elements, i.e. Form1.whateverpropertyormethod.
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
  Self.myiymax:=Self.Fiymax;
  Self.myixmin:=Self.Fixmax div Self.CPU * ParamThreadNumber;
  Self.myixmax:=Self.Fixmax div Self.CPU + Self.myixmin+Self.CPU;
  Self.MyImage:=TBitmap.Create;
  Self.MyImage.Width:=Self.myixmax-Self.myixmin;
  Self.MyImage.Height:=Self.myiymax;
  //SetLength(Colors,jmaxiterations);
  // for i := 0 to Length(Colors) do
  //      Colors[i] := RGB((i shr 5) * 36, ((i shr 3) and 7) * 36, (i and 3) * 85);
   //Form1.UpdateInfo();
   for x := Self.myixmin to Self.myixmax do
   begin
     for y := 0 to Self.myiymax  do
     begin
       // Check if the thread must forcibly terminate
       if Self.ForceTerminate then
       begin
         MyImage.Destroy;
         Self.Terminate;
         Exit;
       end;
       jzx := 2.0 * (x - Self.Fixmax / 2) / (0.5 * Self.zoom * Self.Fixmax) + Self.moveX;
       jzy := 2.0 * (y - Self.Fiymax / 2) / (0.5 * Self.zoom * Self.Fiymax) + Self.moveY;
       i := Self.jmaxiterations;
       while (jzx * jzx + jzy * jzy < 4) and (i > 1) do
       begin
         tmp := jzx * jzx - jzy * jzy + jcx;
         jzy := 2.0 * jzx * jzy + jcy;
         jzx := tmp;
         i := i - 1;
       end;
       Self.ix:=x;
       Self.iy:=y;
       //MyImage.Canvas.Pixels[ix-myixmin,iy] := colors[i];
       Self.MyImage.Canvas.Pixels[Self.ix-Self.myixmin,Self.iy]:=$FFFFFF div (Self.jmaxiterations*Self.Pallette)*i;
     end;
     Self.Synchronize(@ShowStatusX);
   end;
   Self.Synchronize(@CopyImage);
   MyImage.Destroy;
end;

{ TForm1 }
procedure TForm1.UpdateMandelbrotImage(ABitmap:TBitmap; Amyixmin, Amyixmax, Amyiymax: integer);
begin
  //a critical section is needed to avoid multiple
  //threads updating their rendered image slice at the same time
  InitializeCriticalSection(ThreadLock);
  try
        if not saving then
           MandelbrotImage.Canvas.CopyRect(Rect(Amyixmin,1,Amyixmax,Amyiymax),ABitmap.Canvas,Rect(1,1,Amyixmax-Amyixmin,Amyiymax))
        else
           Form2.SaveImage.Canvas.CopyRect(Rect(Amyixmin,1,Amyixmax,Amyiymax),ABitmap.Canvas,Rect(1,1,Amyixmax-Amyixmin,Amyiymax));
        ProgressBar2.Position:=ProgressBar2.Position+1;
        Form1.StopTime:=now;
        Label31.Font.Color:=clWhite - ColorToRGB(MandelbrotImage.canvas.Pixels[10,10]);
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
  //a critical section is needed to avoid multiple
  //threads updating their rendered image slice at the same time
  InitializeCriticalSection(ThreadLock);
  try
        if not saving then
          JuliaImage.Canvas.CopyRect(Rect(Amyixmin,1,Amyixmax,Amyiymax),ABitmap.Canvas,Rect(1,1,Amyixmax-Amyixmin,Amyiymax))
        else
          Form2.SaveImage.Canvas.CopyRect(Rect(Amyixmin,1,Amyixmax,Amyiymax),ABitmap.Canvas,Rect(1,1,Amyixmax-Amyixmin,Amyiymax));
          ProgressBar1.Position:=ProgressBar1.Position+1;
          Form1.StopTime:=now;
          Label31.Font.Color:=clWhite - ColorToRGB(JuliaImage.canvas.Pixels[10,10]);
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
{$IFDEF UNIX}
function sysconf(i:cint):clong;cdecl;external name 'sysconf';
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);

var
  LocalCPU, i:integer;
begin
  LocalCPU:= {$IFDEF WINDOWS} GetCPUCount(); {$ENDIF}
             {$IFDEF UNIX}    sysconf(83);   {$ENDIF}
  if LocalCPU > 2 then
     CPU:=LocalCPU -2
  else
     CPU:=LocalCPU;
  try
    if Paramcount<>0 then
    begin
      if (StrToInt(paramstr(1)) <= 2*(CPU+2)) and
         (StrToInt(paramstr(1)) <> 0) then
             CPU:=StrToInt(paramstr(1));
    end;
  except

  end;



  Caption := 'Fractals on '+IntToStr(CPU)+' threads';
  //set number or threads
  SetLength(MThreads,CPU);
  SetLength(JThreads,CPU);
  //arrange images a little bit
  JuliaImage.Picture.Bitmap.PixelFormat:=pf24bit;
  MandelbrotImage.Picture.Bitmap.PixelFormat:=pf24bit;
  JuliaImage.Align:=alClient;
  MandelbrotImage.Align:=alClient;

  ASaveZoom:=StrToInt(Label32.Caption);
  ThreadsDone:=True;
  JuliaImage.Hide;
  JuliaSync:=False;
  //compute number of progressbars for threads and display them on the form
  SetLength(MandelProgress,CPU);
  ProgressBar2.Max:=CPU;
  SetLength(JuliaProgress,CPU);
  ProgressBar1.Max:=CPU;
  for i:=0 to CPU-1 do
  begin
    Mandelprogress[i]:=TProgressBar.Create(nil);
    MandelProgress[i].Parent:=Form1.Panel5;
    MandelProgress[i].Left:=(Panel5.Width-5) div CPU*i+5;
    MandelProgress[i].Width:=(Panel5.Width-5) div CPU-1;
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
    JuliaProgress[i].Left:=(Panel7.Width-5) div CPU*i+5;
    JuliaProgress[i].Width:=(Panel7.Width-5) div CPU-1;
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

  MandelbrotImage.Canvas.Brush.Color:=clWhite;
  MandelbrotImage.Canvas.AutoRedraw:=True;
  JuliaImage.Canvas.Brush.Color:=clWhite;
  JuliaImage.Canvas.AutoRedraw:=True;
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
  Mcx1minLabel.Caption :='cx1='+FloatToStrF(cxminabs,ffnumber,2,6);
  Mcx2minLabel.Caption :='cx2='+FloatToStrF(cxmaxabs,ffnumber,2,6);
  Mcy1minLabel.Caption :='cy1='+FloatToStrF(cyminabs,ffnumber,2,6);
  Mcy2minLabel.Caption :='cy2='+FloatToStrF(cymaxabs,ffnumber,2,6);
  Mcx1minLabel.Hint :='cx1='+FloatToStrF(cxminabs,ffnumber,2,22);
  Mcx2minLabel.Hint :='cx2='+FloatToStrF(cxmaxabs,ffnumber,2,22);
  Mcy1minLabel.Hint :='cy1='+FloatToStrF(cyminabs,ffnumber,2,22);
  Mcy2minLabel.Hint :='cy2='+FloatToStrF(cymaxabs,ffnumber,2,22);
  Mcx1curLabel.Caption  :='cx1='+FloatToStrF(cxmin,ffnumber,2,4);
  Mcx2curLabel.Caption :='cx2='+FloatToStrF(cxmax,ffnumber,2,4);
  Mcy1curLabel.Caption :='cy1='+FloatToStrF(cymin,ffnumber,2,4);
  Mcy2curLabel.Caption :='cy2='+FloatToStrF(cymax,ffnumber,2,4);
  Mcx1curLabel.Hint  :='cx1='+FloatToStrF(cxmin,ffnumber,2,22);
  Mcx2curLabel.Hint :='cx2='+FloatToStrF(cxmax,ffnumber,2,22);
  Mcy1curLabel.Hint :='cy1='+FloatToStrF(cymin,ffnumber,2,22);
  Mcy2curLabel.Hint :='cy2='+FloatToStrF(cymax,ffnumber,2,22);
  MTopLeftCoordinatesLabel.Caption  :='Top Left: ('+IntToStr(x1)+', '+IntToStr(y1)+')';
  MCurrentCoordinatesLabel.Caption  :='Current:  ('+IntToStr(x2)+', '+IntToStr(y2)+')';
  MResolutionLabel.Caption :='Resolution: '+IntToStr(ixmax)+' x '+IntToStr(iymax)+ ' pixels';
  MZoomLabel.Caption :='Zoom='+FloatToStrF(MZoom,ffnumber,2,2);
  //Julia
  JcxLabel.Caption :='cx='+FloatToStrF(jcx,ffnumber,2,22);
  JcyLabel.Caption :='cy='+FloatToStrF(jcy,ffnumber,2,22);
  JX1Label.Caption :='Top Left: ('+IntToStr(jx1)+', '+IntToStr(jy1)+')';
  JX2Label.Caption :='Current:  ('+IntToStr(jx2)+', '+IntToStr(jy2)+')';
  JZoomLabel.Caption :='Zoom='+FloatToStrF(Zoom,ffnumber,2,2);
  JPanXLabel.Caption :='Pan X='+FloatToStrF(MoveX,ffnumber,2,2);
  JPanYLabel.Caption :='Pan Y='+FloatToStrF(MoveY,ffnumber,2,2);
  JPanXLabel.Hint :='Pan X='+FloatToStrF(MoveX,ffnumber,2,22);
  JPanYLabel.Hint :='Pan Y='+FloatToStrF(MoveY,ffnumber,2,22);

  if JuliaSync then
  begin
    JDrawingLabel.Caption:='Drawing Corresponding Julia Set With:';
    RadioGroup1.Items[1]:='Corresponding Julia Set';
    Panel8.Font.Color:=clRed;
    Panel7.BevelColor:=clRed;
    Panel8.BevelColor:=clRed;
    Panel13.BevelColor:=clRed;
    Panel14.BevelColor:=clRed;
    Label7.Font.Color:=clRed;
    Label20.Font.Color:=clRed;
    JDrawingLabel.Font.Color:=clRed;
  end
  else
  begin
    JDrawingLabel.Caption:='Drawing Default Julia Set With:';
    RadioGroup1.Items[1]:='Default Julia Set';
    Panel8.Font.Color:=clGreen;
    Panel7.BevelColor:=clGreen;
    Panel8.BevelColor:=clGreen;
    Panel13.BevelColor:=clGreen;
    Panel14.BevelColor:=clGreen;
    Label7.Font.Color:=clGreen;
    Label20.Font.Color:=clGreen;
    JDrawingLabel.Font.Color:=clGreen;
  end;
end;

procedure TForm1.UpdateInfoNonCommitted(acx1,acx2,acy1,acy2:extended);
begin
  //Mandelbrot
  Mcx1curLabel.Caption  :='cx1='+FloatToStrF(acx1,ffnumber,2,4);
  Mcx2curLabel.Caption :='cx2='+FloatToStrF(acx2,ffnumber,2,4);
  Mcy1curLabel.Caption :='cy1='+FloatToStrF(acy1,ffnumber,2,4);
  Mcy2curLabel.Caption :='cy2='+FloatToStrF(acy2,ffnumber,2,4);
  Mcx1curLabel.Hint  :='cx1='+FloatToStrF(acx1,ffnumber,2,22);
  Mcx2curLabel.Hint :='cx2='+FloatToStrF(acx2,ffnumber,2,22);
  Mcy1curLabel.Hint :='cy1='+FloatToStrF(acy1,ffnumber,2,22);
  Mcy2curLabel.Hint :='cy2='+FloatToStrF(acy2,ffnumber,2,22);
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


procedure TForm1.MandelbrotImageMouseDown(Sender: TObject; Button: TMouseButton;
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
            cxmin := x1/(MandelbrotImage.Width/(cxmaxabs-cxminabs))-cxmaxabs;
            cxmax := x2/(MandelbrotImage.Width/(cxmaxabs-cxminabs))-cxmaxabs;
            cymin := - (y1/(MandelbrotImage.Height/(cymaxabs-cyminabs)) - cymaxabs);
            cymax := - (y2/(MandelbrotImage.Height/(cymaxabs-cyminabs)) - cymaxabs);
            UpdateInfo();
          end;
          Shape1.Canvas.CopyRect(Rect(0,0,Shape1.Width,Shape1.Height),MandelbrotImage.Canvas,Rect(x1,y1,x2,y2));
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
      //weird happening: mouse down on MandelbrotImage triggers Mouse up on JuliaImage
      //Setting the above tells the system the mouse was pressed on Mandelbrot.
      Form1.MouseDownFromMandelbrot:=True;
    end;
  end;
end;

procedure TForm1.MandelbrotImageMouseMove(Sender: TObject; Shift: TShiftState; X,
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
         divergence:=(Self.MandelbrotImage.Canvas.Pixels[X,Y]*StrToInt(Edit1.Text) div $FFFFFF).ToString;
         if divergence.ToInteger()/StrToInt(Edit1.Text)> 0.9999 then divergence:='none';
         MDivergenceLabel.Caption:='Divergence: '+divergence;

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
            cxmin := x1/(MandelbrotImage.Width/(cxmaxabs-cxminabs))-cxmaxabs;
            cxmax := x2/(MandelbrotImage.Width/(cxmaxabs-cxminabs))-cxmaxabs;
            cymin := - (y1/(MandelbrotImage.Height/(cymaxabs-cyminabs)) - cymaxabs);
            cymax := - (y2/(MandelbrotImage.Height/(cymaxabs-cyminabs)) - cymaxabs);
            UpdateInfo();
            //Shape1.Canvas.Unlock;
            Shape1.Left:=x1;
            Shape1.Top:=y1;
            Shape1.Width:=x2-x1;
            Shape1.Height:=y2-y1;
            //Shape1.Canvas.CopyRect(Rect(0,0,Shape1.Width,Shape1.Height),MandelbrotImage.Canvas,Rect(x1,y1,x2,y2));
            //Shape1.Canvas.Lock;
         end
       else
       begin
          acxmin := x1/(MandelbrotImage.Width/(cxmaxabs-cxminabs))-cxmaxabs;
          acxmax := x2/(MandelbrotImage.Width/(cxmaxabs-cxminabs))-cxmaxabs;
          acymin := - (y1/(MandelbrotImage.Height/(cymaxabs-cyminabs)) - cymaxabs);
          acymax := - (y2/(MandelbrotImage.Height/(cymaxabs-cyminabs)) - cymaxabs);
          UpdateInfo();
          UpdateInfoNonCommitted(acxmin,acxmax,acymin,acymax);
       end;


       end;
end;

procedure TForm1.MandelbrotImageMouseUp(Sender: TObject; Button: TMouseButton;
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

procedure TForm1.MandelbrotImageResize(Sender: TObject);
begin
  ixmax:=MandelbrotImage.Width;
  iymax:=MandelbrotImage.Height;
  MandelbrotImage.Picture.Bitmap.SetSize(ixmax, iymax);

end;


procedure TForm1.JuliaImageMouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TForm1.JuliaImageMouseMove(Sender: TObject; Shift: TShiftState; X,
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
    divergence:=(Self.JuliaImage.Canvas.Pixels[X,Y]*StrToInt(Edit1.Text) div $FFFFFF).ToString;
    if divergence.ToInteger()/StrToInt(Edit1.Text)> 0.9999 then divergence:='none';
    JDivergenceLabel.Caption:='Divergence: '+divergence;
    UpdateInfo();
    Shape1.Left:=jx1;
    Shape1.Top:=jy1;
    Shape1.Width:=jx2-jx1;
    Shape1.Height:=jy2-jy1;
end;

procedure TForm1.JuliaImageMouseUp(Sender: TObject; Button: TMouseButton;
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
    //this only happens when middle button is clicked on MandelbrotImage but MouseUp event happens on JuliaImage
     //actually it happens also on right click on JuliaImage but it has no effect, just a redraw
    if Form1.MouseDownFromMandelbrot then //Julia Draw with Mandelbrot correspondent
       BitBtn2Click(Nil)
    else
    begin   //switch back to Draw Mandelbrot
       RadioGroup1.ItemIndex:=0;
       //UpdateDefaultParameters;  only if we wish a full redraw of Mandelbrot when coming back from Julia
       //BitBtn2Click(Nil);   actually if Mandelbrot is already drawn we could just flip the images :)
       if JuliaSync then
       begin
         JuliaImage.Hide;
         MandelbrotImage.Show;
       end
       else
        BitBtn2Click(Nil);
    end;
   end;
  end;
end;



procedure TForm1.JuliaImageResize(Sender: TObject);
begin
  ixmax:=JuliaImage.Width;
  iymax:=JuliaImage.Height;
  JuliaImage.Picture.Bitmap.SetSize(ixmax, iymax);
end;

procedure TForm1.Label32Click(Sender: TObject);
begin

end;

procedure TForm1.RadioGroup1SelectionChanged(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    1:
    begin
      MandelbrotImage.Hide;
      JuliaImage.Show;
    end;
    0:
    begin
      MandelbrotImage.Show;
      JuliaImage.Hide;
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
      Label31.Font.Color:=clWhite - ColorToRGB(JuliaImage.canvas.Pixels[10,10]);
      Label31.Caption:='Rendering Julia set: '+FloatToStrF(ProgressBar1.Position*100/ProgressBar1.Max,ffNumber,3,2)+'%; Time: '+ FormatDateTime('h"h "n"m "s"s"', Form1.StopTime-Form1.StartTime);
      ProgressBar1.Hint:=Label31.Caption;
    end;
    M:
    begin
      StopTime:=now;
      Label31.Font.Color:=clWhite - ColorToRGB(MandelbrotImage.canvas.Pixels[10,10]);
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
  MP:TMInitParam;
  JP:TJInitParam;
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
      //set initial parameters before creation and execution
      JP.CPU:=Form1.CPU;
      JP.SaveZoom:=Form1.ASaveZoom;
      JP.jcx:=Form1.jcx;
      JP.jcy:=Form1.jcy;
      JP.zoom:=Form1.zoom;
      JP.MoveX:=Form1.moveX;
      JP.MoveY:=Form1.moveY;
      JP.jmaxiterations:=StrToInt(Form1.Edit1.Text);
      JP.Pallette:=Form1.Pallette;
      if Form1.Saving then
      begin
       JP.Fixmax:=Form2.SaveImage.Width;
       JP.Fiymax:=Form2.SaveImage.Height;
      end
      else
      begin
       JP.Fixmax:=Form1.ixmax;
       JP.Fiymax:=Form1.iymax;
      end;

      for i:=Low(JThreads) to High(JThreads)  do
      begin
         JThreads[i]:=TMyJuliaThread.Create(False, i, JP);
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
      //set initial parameters before creation and execution
      MP.CPU           := Form1.CPU;
      MP.Fcxmax        := Form1.cxmax;
      MP.Fcxmin        := Form1.cxmin;
      MP.Fcymax        := Form1.cymax;
      MP.Fcymin        := Form1.cymin;
      MP.MaxIterations := StrToInt(Form1.Edit1.Text);
      MP.SaveZoom      := Form1.ASaveZoom;
      MP.Pallette      := Form1.Pallette;
      if Form1.Saving then
      begin
       MP.Fixmax:=Form2.SaveImage.Width;
       MP.Fiymax:=Form2.SaveImage.Height;
      end
      else
      begin
       MP.Fixmax:=Form1.ixmax;
       MP.Fiymax:=Form1.iymax;
      end;
      for i:=Low(MThreads) to High(MThreads)  do
      begin
         MThreads[i]:=TMyMandelbrotThread.Create(False, i, MP);
         MThreads[i].Start;
      end;
    end;
  end;

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
  if MandelbrotImage.Visible=True then
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
     SaveDialog1.Title:='Save zoomed x'+ASaveZoom.ToString+' ('+(MandelbrotImage.Width*ASaveZoom).ToString()+'x'+(MandelbrotImage.Height*ASaveZoom).ToString()+') image';
     SaveDialog1.FileName:=SaveDialog1.FileName + ' zoomed x' + ASaveZoom.ToString;
  end
  else
      SaveDialog1.Title:='Save original ('+MandelbrotImage.Width.ToString()+'x'+MandelbrotImage.Height.ToString()+') image';
  if SaveDialog1.Execute then
  begin
    case SaveDialog1.FilterIndex of
      1:   //bitmap file
      begin
        if ASaveZoom<>1 then
        begin
             oldixmax:=ixmax;
             oldiymax:=iymax;
             Form2.Width:=MandelbrotImage.Width*ASaveZoom+Form2.BorderWidth*2;
             Form2.height:=MandelbrotImage.Height*ASaveZoom+Form2.BorderWidth*2;
             Form2.SaveImage.Width:=MandelbrotImage.Width*ASaveZoom;
             Form2.SaveImage.height:=MandelbrotImage.Height*ASaveZoom;
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
             Form2.SaveImage.Width:=MandelbrotImage.Width*ASaveZoom;
             Form2.SaveImage.height:=MandelbrotImage.Height*ASaveZoom;
             Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width,Form2.Height);
             Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width, Form2.Height);
             Form2.button.Left:=Form2.Width+1;
             Form2.button.Top:=Form2.Height+1;
        end
        else
        begin
          if MandelbrotImage.Visible then
             MandelbrotImage.Picture.Bitmap.SaveToFile(SaveDialog1.FileName)
          else
             JuliaImage.Picture.Bitmap.SaveToFile(SaveDialog1.FileName);

        end;
      end;
      2:   //jpg file
      begin
        if ASaveZoom<>1 then
        begin
          oldixmax:=ixmax;
          oldiymax:=iymax;
          Form2.Width:=MandelbrotImage.Width*ASaveZoom+Form2.BorderWidth*2;
          Form2.height:=MandelbrotImage.Height*ASaveZoom+Form2.BorderWidth*2;
          Form2.SaveImage.Width:=MandelbrotImage.Width*ASaveZoom;
          Form2.SaveImage.height:=MandelbrotImage.Height*ASaveZoom;
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
          Form2.SaveImage.Width:=MandelbrotImage.Width*ASaveZoom;
          Form2.SaveImage.height:=MandelbrotImage.Height*ASaveZoom;
          Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width,Form2.Height);
          Form2.SaveImage.Picture.Bitmap.SetSize(Form2.Width, Form2.Height);
          Form2.button.Left:=Form2.Width+1;
          Form2.button.Top:=Form2.Height+1;
        end
        else
        begin
           Jpg := TJPEGImage.Create;
          if MandelbrotImage.Visible then
             Jpg.Assign(MandelbrotImage.Picture.Graphic)
          else
             Jpg.Assign(JuliaImage.Picture.Graphic);
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

