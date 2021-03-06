unit uGPFileParser;

interface

uses SysUtils, Classes, Graphics;


type

  TTrackLyricsCount = 0..4;

  TGPFileParser = class;

  TGPFileParserFactory = class(TObject)
    class function ReadStringByte(const FileStream : TFileStream; const ExpectedLength : integer) : AnsiString;
    class function Execute(const Filename : string) : TGPFileParser;
  end;

  TGPTrackLyrics = class(TObject)
    private
      FTrackNumber: Int32;
      FLines : array[TTrackLyricsCount] of string;
      FMeasureNumbers : array[TTrackLyricsCount] of integer;
      procedure SetTrackNumber(const Value: Int32);
      function GetLine(aIndex: integer): string;
      procedure SetLine(aIndex: integer; const Value: string);
      function GetMeasureNumber(aIndex: integer): integer;
      procedure SetMeasureNumber(aIndex: integer; const Value: integer);

    public
      property TrackNumber : Int32 read FTrackNumber write SetTrackNumber;
      property Line[aIndex : integer] : string read GetLine write SetLine;
      property MeasureNumber[aIndex : integer] : integer read GetMeasureNumber write SetMeasureNumber;
  end;

  TChannelBank = (Default, Percussion);

  TGPChannel = class(TObject)
    private
			FInstrument: int32;
  		FVolume : Byte;
  		FBalance : Byte;
  		FChorus :	Byte;
  		FReverb : Byte;
  		FPhaser :  Byte;
  		FTremolo : Byte;
      FBank : TChannelBank;
      FBlank1 : Byte;
      FBlank2 : Byte;

    public
    published
      property Instrument : Int32 read FInstrument;
      property Volume : Byte read FVolume;
      property Balance : Byte read FBalance;
      property Chorus : Byte read FChorus;
      property Reverb : Byte read FReverb;
      property Phaser : Byte read FPhaser;
      property Tremolo  : Byte read FTremolo;
      property Bank  : TChannelBank read FBank;

  end;

  TGPMeasure = class(TCollectionItem)
    private
      FMeasureNumber : Integer;
      FIsDoubleBar : boolean;
      FIsBeginningOfRepeat : boolean;
      FKeySignatureNumerator : Byte;
      FKeySignatureDenominator : Byte;
      FNumberOfRepeats : Byte;
      FNumberOfAlternativeEndings : Byte;
      FMarkersName : string;
      FColour : TColor;
      FTonality : Byte;
    public
      //procedure Assign(ASource: TPersistent); override;
      property MeasureNumber : integer read FMeasureNumber;
      property IsDoubleBar : Boolean read FIsDoubleBar;
      property IsBeginningOfRepeat : boolean read FIsBeginningOfRepeat;
      property KeySignatureNumerator : Byte read FKeySignatureNumerator;
      property KeySignatureDenominator : Byte read FKeySignatureDenominator;
      property NumberOfRepeats : Byte read FNumberOfRepeats;
      property NumberOfAlternativeEndings : Byte read FNumberOfAlternativeEndings;
      property Colour : TColor read FColour;
      property MarkersName : string read FMarkersName;
      property Tonality : byte read FTonality;

  end;

  TGPMeasureArray = class(TOwnedCollection)
  private
    function  GetItem(Index: Integer): TGPMeasure;
    procedure SetItem(Index: Integer; const Value: TGPMeasure);
  public
    constructor Create(AOwner: TPersistent);
    function  Add: TGPMeasure; reintroduce;
    function  Insert(Index: Integer): TGPMeasure; reintroduce;
    property  Items[Index: Integer]: TGPMeasure read GetItem write SetItem; default;
  end;

  TGPTuning = class(TCollectionItem)
  private
    FTuningNumber : Int32;
    FValue : Int32;
    procedure SetTuningNumber(const Number : Int32);
    procedure SetTuningValue(const Value : Int32);

    public
      //procedure Assign(ASource: TPersistent); override;
      property TuningNumber : Int32 read FTuningNumber write SetTuningNumber;
      property Value : Int32 read FValue write SetTuningValue;
  end;

  TGPTuningArray = class(TOwnedCollection)
  private
    function  GetItem(Index: Integer): TGPTuning;
    procedure SetItem(Index: Integer; const Value: TGPTuning);
  public
    constructor Create(AOwner: TPersistent);
    function  Add: TGPTuning; reintroduce;
    function  Insert(Index: Integer): TGPTuning; reintroduce;
    property  Items[Index: Integer]: TGPTuning read GetItem write SetItem; default;
  end;

  TGPTrack = class(TCollectionItem)
  private
    FTrackNumber : Integer;
    FHeader : Byte;
    FName : string;
    FNumberOfStrings : Integer;
    FPort : Integer;
    FChannel : Integer;
    FChannelE : Integer;
    FNumberOfFrets : Integer;
    FHeightOfCapo : Integer;
    FColour : TColor;
    FTuningArray : TGPTuningArray;
    public
      //procedure Assign(ASource: TPersistent); override;
      constructor Create(Collection: TCollection); override;
      destructor Destroy; override;
      property TrackNumber : integer read FTrackNumber;
      property Header : Byte read FHeader;
      property Name : string read FName;
      property NumberOfStrings : integer read FNumberOfStrings;
      property Port : Integer read FPort;
      property Channel : Integer read FChannel;
      property ChannelE : Integer read FChannelE;
      property NumberOfFrets : Integer read FNumberOfFrets;
      property HeightOfCapo : Integer read FHeightOfCapo;
      property Colour : TColor read FColour;
      property Tunings : TGPTuningArray read FTuningArray;
  end;

  TGPTrackArray = class(TOwnedCollection)
  private
    function  GetItem(Index: Integer): TGPTrack;
    procedure SetItem(Index: Integer; const Value: TGPTrack);
  public
    constructor Create(AOwner: TPersistent);
    function  Add: TGPTrack; reintroduce;
    function  Insert(Index: Integer): TGPTrack; reintroduce;
    property  Items[Index: Integer]: TGPTrack read GetItem write SetItem; default;
  end;

  TGPKey = class(TObject)
    private
      FKeyMode : integer;
      FKeyType : integer;
    protected

    public
      constructor Create(const KeyMode, KeyType : integer); overload;
      constructor Create; overload;
      procedure SetValue(const KeyType : integer); overload;
      procedure SetValue(const KeyMode, KeyType : integer); overload;

      class function C_FLAT : TGPKey;
      class function G_FLAT : TGPKey;
      class function D_FLAT : TGPKey;
      class function A_FLAT : TGPKey;
      class function E_FLAT : TGPKey;
      class function B_FLAT : TGPKey;
      class function F : TGPKey;
      class function C : TGPKey;
      class function G : TGPKey;
      class function D : TGPKey;
      class function A : TGPKey;
      class function E : TGPKey;
      class function B : TGPKey;
      class function F_SHARP : TGPKey;
      class function C_SHARP : TGPKey;
      class function A_FLAT_MINOR : TGPKey;
      class function E_FLAT_MINOR : TGPKey;
      class function B_FLAT_MINOR : TGPKey;
      class function F_MINOR : TGPKey;
      class function C_MINOR : TGPKey;
      class function G_MINOR : TGPKey;
      class function D_MINOR : TGPKey;
      class function A_MINOR : TGPKey;
      class function E_MINOR : TGPKey;
      class function B_MINOR : TGPKey;
      class function F_SHARP_MINOR : TGPKey;
      class function C_SHARP_MINOR : TGPKey;
      class function G_SHARP_MINOR : TGPKey;
      class function D_SHARP_MINOR : TGPKey;
      class function A_SHARP_MINOR : TGPKey;

    published
      property KeyMode : integer read FKeyMode;
      property KeyType : integer read FKeyType;
  end;

  TGPFileParser = class abstract(TPersistent)
  private
    FVersionNumber : integer;
    FFile : TFileStream;
    FFilename : string;
    FVersion: string;
    FArtist: string;
    FInterpret: string;
    FInstructional: string;
    FSubTitle: string;
    FTranscriber: string;
    FCopyright: string;
    FAlbum: string;
    FIsTripletFeel: Boolean;
    FTitle: string;
    FNotes : TStringList;
    FTrackLyrics : TGPTrackLyrics;
    FTempo : integer;
    FIsOctave : boolean;
    FKey : TGPKey;
    FChannels : array[0..63] of TGPChannel;
    FNumberOfMeasures : integer;
    FNumberOfTracks : integer;
    FMeasureArray: TGPMeasureArray;
    FTrackArray: TGPTrackArray;

    function ReadStringByte(const ExpectedLength : integer) : AnsiString;
    function ReadStringInt32 : AnsiString;
    function ReadStringInt32PlusOne : AnsiString;
    function ReadStringBytePlusOne : AnsiString; overload;
    function ReadStringBytePlusOne(const ExpectedLength : integer) : AnsiString; overload;
    function ReadBoolean : Boolean;
    function ReadInt32 : Int32;
    function ReadByte : byte;
    function ReadRGB(const SkipWhite : Boolean) : TColor;
    procedure Skip(const count : integer);

    function GetChannel(Index: Integer): TGPChannel;

  protected
    procedure GetVersion; virtual;
    procedure GetTitle; virtual;
    procedure GetSubTitle; virtual;
    procedure GetInterpret; virtual;
    procedure GetAlbum; virtual;
    procedure GetArtist; virtual;
    procedure GetCopyright; virtual;
    procedure GetTranscriber; virtual;
    procedure GetInstructions; virtual;
    procedure GetNotes; virtual;
    procedure GetTripletFeel; virtual;
    procedure GetTablature; virtual;
    procedure GetTempo; virtual;
    procedure GetLyrics; virtual;
    procedure GetKey; virtual;
    procedure GetOctave; virtual;

    procedure GetChannels; virtual;
    procedure GetNumberOfMeasures; virtual;
    procedure GetNumberOfTracks; virtual;
    procedure GetMeasures; virtual;
    procedure GetTracks; virtual;

  public
    constructor Create(const Filename : string);
    destructor Destroy; override;
    procedure Parse; virtual; abstract;
    procedure Execute;

    property Version : string read FVersion;

    property Title : string read FTitle;
    property SubTitle : string read FSubTitle;
    property Interpret : string read FInterpret;
    property Album : string read FAlbum;
    property Artist : string read FArtist;
    property Copyright : string read FCopyright;
    property Transcriber  : string read FTranscriber;
    property Instructional  : string read FInstructional;
    property Notes : TStringList read FNotes;
    property IsTripletFeel : Boolean read FIsTripletFeel;

    property TrackLyrics : TGPTrackLyrics read FTrackLyrics;
    property Tempo : integer read FTempo;
    property Key : TGPKey read FKey;
    property IsOctave : boolean read FIsOctave;

    property Channels[Index: Integer]: TGPChannel read GetChannel;

    property NumberOfMeasures : integer read FNumberOfMeasures;
    property NumberOfTracks : integer read FNumberOfTracks;

    property Measures: TGPMeasureArray read FMeasureArray;
    property Tracks: TGPTrackArray read FTrackArray;

  end;


  TGP1FileParser = class(TGPFileParser)
    public
      procedure GetKey; override;
      procedure Parse; override;
  end;

  TGP2FileParser = class(TGPFileParser)
    public
      procedure Parse; override;
  end;

  TGP3FileParser = class(TGPFileParser)
    public
      procedure Parse; override;
  end;

  TGP4FileParser = class(TGPFileParser)
    public
      procedure Parse; override;
  end;

implementation

uses StrUtils, Windows;

type
  TBitFlag = (FLAG_0 = $01, FLAG_1 = $02, FLAG_2 = $04, FLAG_3 = $08, FLAG_4 = $10, FLAG_5 = $20, FLAG_6 = $40, FLAG_7 = $80);

function IsBitSet(const flag: TBitFlag; const bits: Byte): Boolean;
begin
  Result := (byte(flag) and bits) <> 0;
end;

{ TGPFileParserFactory }

class function TGPFileParserFactory.Execute(const Filename: string): TGPFileParser;
var
  FFile : TFileStream;
  Version : string;
begin
  FFile := TFileStream.Create(Filename, fmOpenRead or fmShareDenyNone);
  try
    FFile.Seek(0, TSeekOrigin.soBeginning);
    Version := TGPFileParserFactory.ReadStringByte(FFile, 30);
    if AnsiMatchStr(Version, ['FICHIER GUITARE PRO v1' ,
                              'FICHIER GUITARE PRO v1.01',
                              'FICHIER GUITARE PRO v1.02',
                              'FICHIER GUITARE PRO v1.03',
                              'FICHIER GUITARE PRO v1.04']) then begin
      Result := TGP1FileParser.Create(Filename);
    end else if AnsiMatchStr(Version, [ 'FICHIER GUITAR PRO v2.20',
                                        'FICHIER GUITAR PRO v2.21']) then begin
      Result := TGP2FileParser.Create(Filename);
    end else if AnsiMatchStr(Version, [ 'FICHIER GUITAR PRO v3.00']) then begin
      Result := TGP3FileParser.Create(Filename);
    end else if AnsiMatchStr(Version, [ 'FICHIER GUITAR PRO v4.00',
                                        'FICHIER GUITAR PRO v4.06',
                                        'FICHIER GUITAR PRO L4.06']) then begin
      Result := TGP4FileParser.Create(Filename);
    end else begin
      raise Exception.Create(Format('No Parser for file version : %s', [Version]));
    end;
  finally
    FFile.Free;
  end;
end;

class function TGPFileParserFactory.ReadStringByte(const FileStream : TFileStream; const ExpectedLength: integer): AnsiString;
var
  RealLength : byte;
begin
  FileStream.ReadBuffer(RealLength, 1);
  SetLength(Result, RealLength);
  FileStream.ReadBuffer(Pointer(Result)^, Length(Result));
  FileStream.Seek(ExpectedLength - RealLength, TSeekOrigin.soCurrent);
end;

{ TGPTrackLyrics }

function TGPTrackLyrics.GetLine(aIndex: integer): string;
begin
  Result := FLines[aIndex]
end;

function TGPTrackLyrics.GetMeasureNumber(aIndex: integer): integer;
begin
  Result := FMeasureNumbers[aIndex];
end;

procedure TGPTrackLyrics.SetLine(aIndex: integer; const Value: string);
begin
  FLines[aIndex] := Value;
end;

procedure TGPTrackLyrics.SetMeasureNumber(aIndex: integer; const Value: integer);
begin
  FMeasureNumbers[aIndex] := Value;
end;

procedure TGPTrackLyrics.SetTrackNumber(const Value: integer);
begin
  fTrackNumber := Value;
end;

{ TGPMeasureArray }

constructor TGPMeasureArray.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TGPMeasure);
end;

function TGPMeasureArray.GetItem(Index: Integer): TGPMeasure;
begin
  Result := TGPMeasure(inherited GetItem(Index));
end;

procedure TGPMeasureArray.SetItem(Index: Integer; const Value: TGPMeasure);
begin
  inherited SetItem(Index, Value);
end;

function TGPMeasureArray.Add: TGPMeasure;
begin
  Result := TGPMeasure(inherited Add);
end;

function TGPMeasureArray.Insert(Index: Integer): TGPMeasure;
begin
  Result := TGPMeasure(inherited Insert(Index));
end;

{ TGPTuning }

procedure TGPTuning.SetTuningNumber(const Number : Int32);
begin
  FTuningNumber := Value;
end;

procedure TGPTuning.SetTuningValue(const Value : Int32);
begin
  FValue := Value;
end;

{ TGPTuningArray }

constructor TGPTuningArray.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TGPTuning);
end;

function TGPTuningArray.GetItem(Index: Integer): TGPTuning;
begin
  Result := TGPTuning(inherited GetItem(Index));
end;

procedure TGPTuningArray.SetItem(Index: Integer; const Value: TGPTuning);
begin
  inherited SetItem(Index, Value);
end;

function TGPTuningArray.Add: TGPTuning;
begin
  Result := TGPTuning(inherited Add);
end;

function TGPTuningArray.Insert(Index: Integer): TGPTuning;
begin
  Result := TGPTuning(inherited Insert(Index));
end;


{ TGPTrack }

constructor TGPTrack.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTuningArray := TGPTuningArray.Create(Self);
end;

destructor TGPTrack.Destroy;
begin
  FTuningArray.Free;
  inherited;
end;

{ TGPTrackArray }

constructor TGPTrackArray.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TGPTrack);
end;

function TGPTrackArray.GetItem(Index: Integer): TGPTrack;
begin
  Result := TGPTrack(inherited GetItem(Index));
end;

procedure TGPTrackArray.SetItem(Index: Integer; const Value: TGPTrack);
begin
  inherited SetItem(Index, Value);
end;

function TGPTrackArray.Add: TGPTrack;
begin
  Result := TGPTrack(inherited Add);
end;

function TGPTrackArray.Insert(Index: Integer): TGPTrack;
begin
  Result := TGPTrack(inherited Insert(Index));
end;

{ TGPFileParser }

constructor TGPFileParser.Create(const Filename: string);
begin
  FNotes := TStringList.Create;
  FTrackLyrics := TGPTrackLyrics.Create;
  FMeasureArray := TGPMeasureArray.Create(Self);
  FTrackArray := TGPTrackArray.Create(Self);
  FKey := TGPKey.Create;
  FFilename := Filename
end;

destructor TGPFileParser.Destroy;
begin
  FTrackArray.Free;
  FMeasureArray.Free;
  FNotes.Free;
  FTrackLyrics.Free;
  FKey.Free;
  inherited;
end;

procedure TGPFileParser.Execute;
begin
  FFile := TFileStream.Create(FFilename, fmOpenRead);
  try
    FFile.Seek(0, TSeekOrigin.soBeginning);
    Parse;
  finally
    FFile.Free;
  end;
end;

function TGPFileParser.ReadRGB(const SkipWhite : Boolean) : TColor;
var
  Red, Green, Blue : byte;
begin
  FFile.ReadBuffer(Red, 1);
  FFile.ReadBuffer(Green, 1);
  FFile.ReadBuffer(Blue, 1);
  if SkipWhite then
    Skip(1);
  Result := RGB(Red, Green, Blue);
end;

function TGPFileParser.ReadBoolean: Boolean;
var
  Value : byte;
begin
  FFile.ReadBuffer(Value, 1);
  Result :=  Value = 1;
end;

function TGPFileParser.ReadByte: byte;
var
  Value : byte;
begin
  FFile.ReadBuffer(Value, 1);
  Result := Value;
end;

function TGPFileParser.ReadInt32: Int32;
var
  Value : Int32;
begin
  FFile.ReadBuffer(Value, 4);
  Result := Value;
end;

function TGPFileParser.ReadStringByte(const ExpectedLength : integer) : AnsiString;
var
  RealLength : byte;
begin
  FFile.ReadBuffer(RealLength, 1);
  SetLength(Result, RealLength);
  FFile.ReadBuffer(Pointer(Result)^, Length(Result));
  Skip(ExpectedLength - RealLength);
end;

function TGPFileParser.ReadStringInt32: AnsiString;
var
  ReadLength : Int32;
begin
  FFile.ReadBuffer(ReadLength, 4);
  SetLength(Result, ReadLength);
  FFile.ReadBuffer(Pointer(Result)^, Length(Result));
end;

function TGPFileParser.ReadStringInt32PlusOne: AnsiString;
var
  LengthPlusOne : Int32;
  RealLength : Int32;
  ByteLength : byte;
begin

  FFile.ReadBuffer(LengthPlusOne, 4); // reads the expected length + 1
  RealLength := LengthPlusOne - 1; // computes the real length
  if (LengthPlusOne > 0) then begin
    // reads the real length (as a byte)
    FFile.ReadBuffer(ByteLength, 1);
    if (RealLength <> ByteLength) then begin
      raise Exception.Create(Format('Wrong string length, should have been %5d', [RealLength]));
    end;

    SetLength(Result, RealLength);
    FFile.ReadBuffer(Pointer(Result)^, Length(Result));
  end else begin
    FFile.ReadBuffer(ByteLength, 1);
    Result := '';
  end;
end;

function TGPFileParser.ReadStringBytePlusOne : AnsiString;
var
  LengthPlusOne : Byte;
  RealLength : Byte;
  ByteLength : byte;
begin
  FFile.ReadBuffer(LengthPlusOne, 1); // reads the expected length + 1
  RealLength := LengthPlusOne - 1; // computes the real length
  SetLength(Result, RealLength);
  FFile.ReadBuffer(Pointer(Result)^, Length(Result));
end;

function TGPFileParser.ReadStringBytePlusOne(const ExpectedLength : integer) : AnsiString;
var
  LengthPlusOne : Byte;
  RealLength : Byte;
  ByteLength : byte;
begin
  FFile.ReadBuffer(LengthPlusOne, 1); // reads the expected length + 1
  RealLength := LengthPlusOne - 1; // computes the real length
  SetLength(Result, RealLength);
  FFile.ReadBuffer(Pointer(Result)^, Length(Result));
  Skip(ExpectedLength - RealLength);
end;

procedure TGPFileParser.Skip(const count : Int32);
begin
  FFile.Seek(count, TSeekOrigin.soCurrent);
end;

function TGPFileParser.GetChannel(Index: Int32): TGPChannel;
begin
  result := FChannels[Index];
end;

procedure TGPFileParser.GetAlbum;
begin
  FAlbum := ReadStringInt32PlusOne;
end;

procedure TGPFileParser.GetArtist;
begin
  FArtist := ReadStringInt32PlusOne;
end;

procedure TGPFileParser.GetCopyright;
begin
  FCopyright := ReadStringInt32PlusOne;
end;

procedure TGPFileParser.GetInstructions;
begin
  FInstructional := ReadStringInt32PlusOne;
end;

procedure TGPFileParser.GetInterpret;
begin
  FInterpret := ReadStringInt32PlusOne;
end;

procedure TGPFileParser.GetKey;
begin
  FKey.SetValue(ReadByte);
end;

procedure TGPFileParser.GetLyrics;
var
  i : Int32;
begin
  FTrackLyrics.SetTrackNumber(ReadInt32);
  for i := Low(TTrackLyricsCount) to High(TTrackLyricsCount) do begin
    FTrackLyrics.SetMeasureNumber(i, ReadInt32);
    FTrackLyrics.SetLine(i, ReadStringInt32);
  end;
end;

procedure TGPFileParser.GetNotes;
var
  NumberOfNotes : Int32;
  i : Int32;
begin
  FNotes.Clear;
  FFile.Read(NumberOfNotes, 4);
  for i := 0 to NumberOfNotes - 1 do begin
    FNotes.Add(ReadStringInt32PlusOne)
  end;
end;

procedure TGPFileParser.GetOctave;
begin
  FIsOctave := ReadInt32 = 8;
end;

procedure TGPFileParser.GetSubTitle;
begin
  FSubTitle := ReadStringInt32PlusOne;
end;

procedure TGPFileParser.GetTablature;
begin
//  FTab
end;

procedure TGPFileParser.GetTempo;
begin
  FTempo := ReadInt32;
end;

procedure TGPFileParser.GetTitle;
begin
  FTitle := ReadStringInt32PlusOne;
end;

procedure TGPFileParser.GetTranscriber;
begin
  FTranscriber := ReadStringInt32PlusOne;
end;

procedure TGPFileParser.GetTripletFeel;
begin
  FIsTripletFeel := ReadBoolean;
end;

procedure TGPFileParser.GetVersion;
begin
  FVersion := ReadStringByte(30);
end;

procedure TGPFileParser.GetChannels;
var
 i : Int32;
 Channel : TGPChannel;
begin
  for i := 0 to 63 do begin
    Channel := TGPChannel.Create;
    Channel.FInstrument := ReadInt32;
    Channel.FVolume := ReadByte;
    Channel.FBalance := ReadByte;
    Channel.FChorus := ReadByte;
    Channel.FReverb := ReadByte;
    Channel.FPhaser := ReadByte;
    Channel.FTremolo := ReadByte;
    Channel.FBlank1 := ReadByte;
    Channel.FBlank2 := ReadByte;
    if (i = 9) then
      Channel.FBank := TChannelBank.Percussion
    else
      Channel.FBank := TChannelBank.Default;
    FChannels[i] := Channel;
  end;
end;

procedure TGPFileParser.GetNumberOfMeasures;
begin
  FNumberOfMeasures := ReadInt32;
end;

procedure TGPFileParser.GetNumberOfTracks;
begin
  FNumberOfTracks := ReadInt32;
end;

procedure TGPFileParser.GetMeasures;
var
  i : Int32;
  header : Byte;
  Measure : TGPMeasure;
begin
  for i := 0 to FNumberOfMeasures - 1 do begin
    header := ReadByte;
    Measure := FMeasureArray.Add;
    Measure.FMeasureNumber := i + 1;

    // Bit 0 - Numerator
    if (IsBitSet(TBitFlag.FLAG_0, header)) then begin
      Measure.FKeySignatureNumerator := ReadByte;
    end;

    // Bit 1 - Denominator
    if (IsBitSet(TBitFlag.FLAG_1, header)) then begin
       Measure.FKeySignatureDenominator := ReadByte;
    end;

    // Bit 2 - Beginning of repeat
    Measure.FIsBeginningOfRepeat := (IsBitSet(TBitFlag.FLAG_2, header));

    // Bit 3 - End of repeat
    if (IsBitSet(TBitFlag.FLAG_3, header)) then begin
       Measure.FNumberOfRepeats := ReadByte;
    end;

    // Bit 4 - Number of alternative endings
    if (IsBitSet(TBitFlag.FLAG_4, header)) then begin
       Measure.FNumberOfAlternativeEndings := ReadByte;
    end;

    // Bit 5 - Presence of a marker
    if (IsBitSet(TBitFlag.FLAG_5, header)) then begin
      Measure.FMarkersName := ReadStringInt32PlusOne;
      Measure.FColour := ReadRGB(True);
    end;

    // Bit 6 - Tonality of the measure
    if (IsBitSet(TBitFlag.FLAG_6, header)) then begin
      Measure.FTonality := ReadByte;
      Skip(1);
    end;

    // Bit 7
    Measure.FIsDoubleBar := (IsBitSet(TBitFlag.FLAG_7, header));

  end;
end;

procedure TGPFileParser.GetTracks;
var
  i, j : Int32;
  header : Byte;
  Track : TGPTrack;
  TuningValue : Int32;
  Position : integer;
  Tuning : TGPTuning;
begin
  for i := 0 to FNumberOfTracks - 1 do begin
    Position := FFile.Position;
    Track := Tracks.Add;
    Track.FTrackNumber := i + 1;
    Track.FHeader := ReadByte;
    Position := FFile.Position;
    Track.FName := ReadStringByte(40);
    Track.FNumberOfStrings := ReadInt32;
    for j := 0 to 6 do begin
      TuningValue := ReadInt32;
      if Track.FNumberOfStrings > j then begin
        Tuning := Track.FTuningArray.Add;
        Tuning.TuningNumber := (j + 1);
        Tuning.Value := TuningValue;
      end;

    end;
    Track.FPort := ReadInt32;
    Track.FChannel := ReadInt32;
    Track.FChannelE := ReadInt32;
    Track.FNumberOfFrets := ReadInt32;
    Track.FHeightOfCapo := ReadInt32;
    Track.FColour := ReadRGB(True);
  end;
end;

{ TGP1FileParser }

procedure TGP1FileParser.GetKey;
begin

end;

procedure TGP1FileParser.Parse;
begin
  // Title
  // Artist of the song
  // Instructions
  // Tempo
  // Triplet Feel
  // Key (usually C)
  // No octave

  GetVersion;
  GetTitle;
  GetInstructions;
  GetTempo;
  GetTripletFeel;
end;

{ TGP2FileParser }

procedure TGP2FileParser.Parse;
begin
  // Title
  // Artist of the song
  // Instructions
  // Tempo
  // Triplet Feel
  // Key (usually C)
  // No octave
end;

{ TGP3FileParser }

procedure TGP3FileParser.Parse;
begin
  GetVersion;
  GetTitle;
  GetSubTitle;
  GetArtist;
  GetAlbum;
  GetInterpret;
  GetCopyright;
  GetTranscriber;
  GetInstructions;
  GetNotes;
  GetTripletFeel;
  GetTempo;
  GetKey;
  Skip(3);
  GetChannels;


end;

{ TGP4FileParser }

procedure TGP4FileParser.Parse;
var
  Position : Int64;
begin
  Position := FFile.Position;
  GetVersion;
  Position := FFile.Position;
  GetTitle;
  Position := FFile.Position;
  GetSubTitle;
  Position := FFile.Position;
  GetInterpret;
  Position := FFile.Position;
  GetAlbum;
  Position := FFile.Position;
  GetArtist;
  Position := FFile.Position;
  GetCopyright;
  Position := FFile.Position;
  GetTranscriber;
  Position := FFile.Position;
  GetInstructions;
  Position := FFile.Position;
  GetNotes;
  Position := FFile.Position;
  GetTripletFeel;
  Position := FFile.Position;
  GetLyrics;
  Position := FFile.Position;
  GetTempo;
  Position := FFile.Position;
  GetKey;
  Position := FFile.Position;
  GetOctave;
  Position := FFile.Position;
  GetChannels;
  Position := FFile.Position;
  GetNumberOfMeasures;
  Position := FFile.Position;
  GetNumberOfTracks;
  Position := FFile.Position;
  GetMeasures;
  Position := FFile.Position;
  GetTracks;
  Position := FFile.Position;
end;

{ TGPKey }

//
// C Flat
//

class function TGPKey.C_FLAT : TGPKey;
begin
Result := TGPKey.Create(0, -7);
end;

//
// G Flat
//
class function TGPKey.G_FLAT : TGPKey;
begin
Result := TGPKey.Create(0, -6);
end;

//
// D Flat
//
class function TGPKey.D_FLAT : TGPKey;
begin
Result := TGPKey.Create(0, -5);
end;

//
// A Flat
//
class function TGPKey.A_FLAT : TGPKey;
begin
Result := TGPKey.Create(0, -4);
end;

//
// E Flat
//
class function TGPKey.E_FLAT : TGPKey;
begin
Result := TGPKey.Create(0, -3);
end;

//
// B Flat
//
class function TGPKey.B_FLAT : TGPKey;
begin
Result := TGPKey.Create(0, -2);
end;

//
// F
//
class function TGPKey.F : TGPKey;
begin
Result := TGPKey.Create(0, -1);
end;

//
// C
//
class function TGPKey.C : TGPKey;
begin
Result := TGPKey.Create(0, 0);
end;

constructor TGPKey.Create;
begin

end;

//
// G
//
class function TGPKey.G : TGPKey;
begin
Result := TGPKey.Create(0, 1);
end;

//
// D
//
class function TGPKey.D : TGPKey;
begin
Result := TGPKey.Create(0, 2);
end;

//
// A
//
class function TGPKey.A : TGPKey;
begin
Result := TGPKey.Create(0, 3);
end;

//
// E
//
class function TGPKey.E : TGPKey;
begin
Result := TGPKey.Create(0, 4);
end;

//
// B
//
class function TGPKey.B : TGPKey;
begin
Result := TGPKey.Create(0, 5);
end;

//
// F sharp
//
class function TGPKey.F_SHARP : TGPKey;
begin
Result := TGPKey.Create(0, 6);
end;

//
// C sharp
//
class function TGPKey.C_SHARP : TGPKey;
begin
Result := TGPKey.Create(0, 7);
end;

//
// A flat minor
//
class function TGPKey.A_FLAT_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, -7);
end;

//
// E flat minor
//
class function TGPKey.E_FLAT_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, -6);
end;

//
// B flat minor
//
class function TGPKey.B_FLAT_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, -5);
end;

//
// F minor
//
class function TGPKey.F_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, -4);
end;

//
// C minor
//
class function TGPKey.C_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, -3);
end;

//
// G minor
//
class function TGPKey.G_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, -2);
end;

//
// D minor
//
class function TGPKey.D_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, -1);
end;

//
// A minor
//
class function TGPKey.A_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, 0);
end;

//
// E minor
//
class function TGPKey.E_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, 1);
end;

//
// B minor
//
class function TGPKey.B_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, 2);
end;

//
// F sharp minor
//
class function TGPKey.F_SHARP_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, 3);
end;

//
// C sharp minor
//
class function TGPKey.C_SHARP_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, 4);
end;

//
// G sharp minor
//
class function TGPKey.G_SHARP_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, 5);
end;

procedure TGPKey.SetValue(const KeyType: Int32);
begin
  SetValue(0, KeyType);
end;

procedure TGPKey.SetValue(const KeyMode, KeyType: Int32);
begin
  FKeyMode := KeyMode;
  FKeyType := KeyType;
end;

//
// D sharp minor
//
class function TGPKey.D_SHARP_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, 6);
end;

//
// A sharp minor
//
class function TGPKey.A_SHARP_MINOR : TGPKey;
begin
Result := TGPKey.Create(1, 7);
end;

constructor TGPKey.Create(const KeyMode, KeyType: Int32);
begin
  FKeyMode := KeyMode;
  FKeyType := KeyType;
end;

end.
