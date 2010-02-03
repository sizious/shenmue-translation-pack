unit npcsid;

interface

uses
  ScnfUtil;
  
function GetTextureIndexForSpecialCharID(const CharID: string): Integer;
function IsFaceTexture(TextureName: string): Boolean;
function IsValidCharID(const GameVersion: TGameVersion; const CharID: string): Boolean;

implementation

uses
  SysUtils, PakfUtil;

type
  TSpecialNPC = record
    CharID        : string;
    TextureIndex  : Integer;
  end;

const
  VALID_NPC_WHATS_SHENMUE_AUTOEXTRACTED_COUNT = 68;
  VALID_NPC_WHATS_SHENMUE: array[0..67] of string = (
    'AKSK', 'AOKI', 'ASOU', 'BOB_', 'FKSM', 'FLD1', 'GJBF', 'GJHF', 'HANA',
    'HDEI', 'HIRA', 'HISA', 'HRNO', 'HRSK', 'ITOI', 'KAOR', 'KAYO', 'KENI',
    'KJMA', 'KNJI', 'KOMN', 'KOND', 'KOTA', 'KTRO', 'KUDO', 'KURI', 'KYMA',
    'KYSN', 'MAGO', 'MARK', 'MEGM', 'MISM', 'MRUA', 'MTUK', 'MURA', 'MURI',
    'NITO', 'NOMR', 'NORK', 'PAUR', 'RIKA', 'RYKO', 'SAKI', 'SGRH', 'SIMZ',
    'SIND', 'SKRD', 'SNGA', 'SNKC', 'STAK', 'SUMI', 'SYKU', 'TJMA', 'TKNN',
    'TOM_', 'TTYA', 'TURU', 'UDGW', 'YASU', 'YBBA', 'YJIH', 'YJJI', 'YKDM',
    'YMGC', 'YOHI', 'YOSE', 'YSKT', 'YUKK'
  );
  
  VALID_NPC_SHENMUE_AUTOEXTRACTED_COUNT = 251;
  VALID_NPC_SHENMUE: array[0..254] of string = (
    'AKMI', 'AKSK', 'AKTG', 'AOKI', 'ASDA', 'ASNO', 'ASOU', 'ATSI', 'BOB_',
    'CMAL', 'DJUN', 'DOOR', 'DORG', 'ECHO', 'EDST', 'EIKK', 'ENDO', 'ENKI',
    'ETKO', 'FKSM', 'FLD1', 'FLD2', 'FLD3', 'FLD4', 'FLD5', 'FLD6', 'FLD7',
    'FLD8', 'FLD9', 'FLDA', 'FLDB', 'FLDC', 'FLDD', 'FLDE', 'FLDF', 'FLDG',
    'FUKU', 'GJBF', 'GJBM', 'GJHF', 'GJHM', 'GORO', 'GRKN', 'HANA', 'HARY',
    'HATO', 'HATR', 'HDEI', 'HIDE', 'HIRA', 'HIRI', 'HISA', 'HOND', 'HORS',
    'HREO', 'HRKO', 'HRNO', 'HROT', 'HRSK', 'HTNK', 'HTSI', 'HTSK', 'INE_',
    'IRIE', 'ISDA', 'ISYM', 'ITOH', 'ITOI', 'IZAW', 'IZWA', 'JOE_', 'JOHN',
    'JONZ', 'JUKY', 'KAME', 'KAYO', 'KEBA', 'KEBB', 'KEBC', 'KEBD', 'KEBE',
    'KEBF', 'KEBG', 'KEBH', 'KEBI', 'KEBJ', 'KEBK', 'KEBL', 'KENI', 'KIM_',
    'KISY', 'KJHS', 'KJIY', 'KJMA', 'KKBN', 'KNJI', 'KOGA', 'KOKA', 'KOMN',
    'KOND', 'KOTA', 'KTRO', 'KUDO', 'KUKT', 'KURI', 'KURT', 'KWMT', 'KYAS',
    'KYHN', 'KYKW', 'KYMA', 'KYOH', 'KYSN', 'KYUR', 'KZKI', 'MADA', 'MAGO',
    'MARK', 'MASR', 'MAYM', 'MEGM', 'MEYS', 'MIHO', 'MIKI', 'MIKM', 'MISM',
    'MITA', 'MITI', 'MKII', 'MNKO', 'MNWA', 'MORN', 'MRIG', 'MRSK', 'MRUA',
    'MSTA', 'MSYU', 'MTUK', 'MTUR', 'MURA', 'MURI', 'MWAK', 'MYKN', 'NAKA',
    'NANS', 'NGAI', 'NGSM', 'NITO', 'NMKI', 'NMNO', 'NMTO', 'NOMR', 'NORK',
    'NRSK', 'NSMR', 'OGRA', 'OISI', 'OKYS', 'ONO_', 'ONRR', 'RBRT', 'RIKA',
    'RINS', 'RKKI', 'RYBI', 'RYKO', 'SAGA', 'SAGB', 'SAGC', 'SAGD', 'SAGE',
    'SAJO', 'SAKI', 'SATM', 'SATO', 'SCKO', 'SERA', 'SETA', 'SGRH', 'SIIN',
    'SIMZ', 'SIND', 'SKGK', 'SKMT', 'SKRD', 'SMIK', 'SNDO', 'SNGA', 'SNJI',
    'SNJY', 'SNKC', 'SOBA', 'STAK', 'STP1', 'SUMI', 'SYKU', 'SYZU', 'SZEN',
    'TAEN', 'TAGW', 'TAKE', 'TAKI', 'TATM', 'TDSI', 'TEYI', 'TJMA', 'TKHS',
    'TKNB', 'TKSA', 'TKYM', 'TMHN', 'TMMR', 'TMOS', 'TMRA', 'TOKI', 'TOM_',
    'TOMH', 'TOSK', 'TSUC', 'TTAY', 'TTYA', 'TURU', 'TYHG', 'TYMK', 'UDGW',
    'UNO_', 'X25L', 'X26L', 'YAMA', 'YAMO', 'YASU', 'YAYI', 'YBBA', 'YJIH',
    'YJJI', 'YKDM', 'YKHI', 'YMGC', 'YMST', 'YNHS', 'YOB1', 'YOB2', 'YOHI',
    'YOKO', 'YOPA', 'YOS1', 'YOS2', 'YOSE', 'YOSI', 'YSHY', 'YSKT', 'YUJI',
    'YUKK', 'YUMM', 'YURI'
  );

  // Valid for every Shenmue 2 version
  // Tested on Shenmue 2 (JAP/PAL) (DC) and Shenmue 2X (PAL UK) (Xbox)
  VALID_NPC_SHENMUE2_AUTOEXTRACTED_COUNT = 592;
  VALID_NPC_SHENMUE2: array[0..591] of string = (
    '00A_', '00B_', '00C_', '00D_', '00E_', '00F_', '00G_', '00H_', '01A_',
    '01B_', '01C_', '01D_', '01E_', '01F_', '01G_', '01H_', '02A_', '02B_',
    '02C_', '02D_', '02E_', '02F_', '02G_', '02H_', '03A_', '03B_', '03C_',
    '03D_', '03E_', '03F_', '03G_', '03H_', '04A_', '04B_', '04C_', '04D_',
    '04E_', '04F_', '04G_', '04H_', '05A_', '05B_', '05C_', '05D_', '05E_',
    '05F_', '05G_', '05H_', '06A_', '06B_', '06C_', '06D_', '06E_', '06F_',
    '06G_', '06H_', '07A_', '07B_', '07C_', '07D_', '07E_', '07F_', '07G_',
    '07H_', '08A_', '08B_', '08C_', '08D_', '08E_', '08F_', '08G_', '08H_',
    '09A_', '09B_', '09C_', '09D_', '09E_', '09F_', '09G_', '09H_', '10C_',
    '10D_', '10E_', '10G_', '10H_', '11C_', '11D_', '11E_', '11G_', '11H_',
    '12C_', '12D_', '12E_', '12G_', '12H_', '13C_', '13D_', '13E_', '13G_',
    '13H_', '14C_', '14D_', '14E_', '14G_', '14H_', '15G_', '15H_', '16G_',
    '16H_', '17G_', '17H_', '18G_', '18H_', '19G_', '19H_', 'AA1_', 'AD2_',
    'AGN_', 'AGO_', 'AHE_', 'AM1_', 'AM2_', 'AMY_', 'ANA_', 'ANK_', 'ANN_',
    'ANS_', 'ANT_', 'ARI_', 'AW2_', 'AW4_', 'AW6_', 'BA1_', 'BA2_', 'BA3_',
    'BA4_', 'BA5_', 'BA6_', 'BA7_', 'BA8_', 'BA9_', 'BBA_', 'BBB_', 'BBT_',
    'BF1_', 'BF4_', 'BF6_', 'BF7_', 'BF8_', 'BFA_', 'BIR_', 'BKN_', 'BNC_',
    'BP1_', 'BP2_', 'BP3_', 'BP4_', 'BP5_', 'BP6_', 'BP7_', 'BP8_', 'BP9_',
    'BPA_', 'BRT_', 'BS2_', 'BS3_', 'BS4_', 'BS5_', 'BS6_', 'BSA_', 'C07_',
    'CAK_', 'CEN_', 'CH1_', 'CH2_', 'CH3_', 'CH4_', 'CH5_', 'CH6_', 'CH7_',
    'CH8_', 'CHD_', 'CHJ_', 'CHK_', 'CHL_', 'CHW_', 'CHX_', 'CHY_', 'CKN_',
    'CKT_', 'CKY_', 'CLJ_', 'CLN_', 'CLY_', 'CMY_', 'CN0_', 'CN1_', 'CN2_',
    'CN3_', 'CN4_', 'CN5_', 'CN6_', 'CN7_', 'CNE_', 'CNT_', 'COU_', 'COW_',
    'CRY_', 'CSY_', 'CZN_', 'DEN_', 'DEY_', 'DHO_', 'DM1_', 'DM2_', 'DML_',
    'DN1_', 'DN2_', 'DN3_', 'DN4_', 'DS1_', 'DS2_', 'DS4_', 'DY1_', 'DYU_',
    'EDL_', 'EEI_', 'EIC_', 'EIK_', 'EIN_', 'EKM_', 'EMI_', 'EMN_', 'ENC_',
    'ENF_', 'ENN_', 'ENS_', 'ESN_', 'ETY_', 'EYR_', 'FCJ_', 'FD1_', 'FRS_',
    'FUY_', 'GAI_', 'GAU_', 'GET_', 'GKI_', 'GKS_', 'GKV_', 'GNB_', 'GOI_',
    'GST_', 'GYE_', 'HAC_', 'HAK_', 'HCJ_', 'HCR_', 'HCS_', 'HCY_', 'HGN_',
    'HKJ_', 'HKY_', 'HLN_', 'HNG_', 'HNN_', 'HOI_', 'HTK_', 'HUR_', 'HV7_',
    'HV8_', 'HVA_', 'HXN_', 'IKC_', 'ILN_', 'INC_', 'IRN_', 'JI1_', 'JI2_',
    'JI3_', 'JI4_', 'JI6_', 'JI8_', 'JI9_', 'JJ3_', 'JJ4_', 'JJ5_', 'JJ6_',
    'JJ7_', 'JNT_', 'JNX_', 'JOE_', 'JON_', 'JOP_', 'JUK_', 'JUS_', 'KAC_',
    'KAK_', 'KAN_', 'KAP_', 'KBY_', 'KCH_', 'KD1_', 'KD3_', 'KD4_', 'KD5_',
    'KD8_', 'KEK_', 'KEM_', 'KEN_', 'KIN_', 'KIZ_', 'KJN_', 'KKD_', 'KKI_',
    'KKK_', 'KKY_', 'KLN_', 'KNC_', 'KNH_', 'KNK_', 'KNN_', 'KNT_', 'KOR_',
    'KOY_', 'KR2_', 'KRD_', 'KRN_', 'KRY_', 'KSN_', 'KT4_', 'KT6_', 'KTK_',
    'KTT_', 'KU3_', 'KU4_', 'KUD_', 'KUG_', 'KUK_', 'KUN_', 'KWR_', 'KXY_',
    'KYC_', 'KYG_', 'KYJ_', 'KYO_', 'KYX_', 'KZM_', 'KZN_', 'LCN_', 'LKN_',
    'LKU_', 'LLY_', 'LWI_', 'LYH_', 'LYO_', 'MAK_', 'MAO_', 'MCN_', 'MEJ_',
    'MEY_', 'MFB_', 'MFG_', 'MFM_', 'MFO_', 'MFW_', 'MGN_', 'MII_', 'MIK_',
    'MKD_', 'MKR_', 'MLI_', 'MM1_', 'MM2_', 'MM3_', 'MM4_', 'MM5_', 'MM6_',
    'MM7_', 'MM8_', 'MM9_', 'MMA_', 'MMB_', 'MMC_', 'MMH_', 'MN0_', 'MN1_',
    'MN2_', 'MN3_', 'MN4_', 'MN5_', 'MN6_', 'MOE_', 'MYG_', 'MYH_', 'MYS_',
    'MYU_', 'NIR_', 'NKN_', 'NOL_', 'NOR_', 'OB1_', 'OB2_', 'OB3_', 'OB4_',
    'OB5_', 'OB6_', 'OB8_', 'OB9_', 'OD1_', 'OD5_', 'OHS_', 'OJ1_', 'OJ2_',
    'OJ3_', 'OJ4_', 'OJ6_', 'OJ7_', 'OJ8_', 'OJA_', 'OK2_', 'OK7_', 'OK8_',
    'OK9_', 'OKA_', 'OM2_', 'ONI_', 'ONK_', 'OXK_', 'PG1_', 'PG2_', 'PG3_',
    'PG4_', 'PG5_', 'PG6_', 'PG7_', 'PG8_', 'PG9_', 'PGA_', 'QLN_', 'R01_',
    'RCD_', 'RCN_', 'RE1_', 'REH_', 'REN_', 'RFK_', 'RIN_', 'RKI_', 'RKU_',
    'RNC_', 'RNP_', 'ROO_', 'RRI_', 'RSY_', 'RYC_', 'RYH_', 'RYU_', 'RYW_',
    'SAG_', 'SAI_', 'SAM_', 'SAR_', 'SAY_', 'SCH_', 'SCN_', 'SD1_', 'SD2_',
    'SD4_', 'SDN_', 'SEG_', 'SEH_', 'SF1_', 'SF2_', 'SF7_', 'SF8_', 'SHC_',
    'SHL_', 'SHO_', 'SHR_', 'SHU_', 'SHY_', 'SIC_', 'SIK_', 'SIN_', 'SIS_',
    'SIZ_', 'SKH_', 'SKI_', 'SKK_', 'SKN_', 'SKY_', 'SLI_', 'SMK_', 'SMU_',
    'SNC_', 'SNK_', 'SNN_', 'SNS_', 'SOG_', 'SOK_', 'SOS_', 'SRI_', 'SSA_',
    'SSY_', 'SUU_', 'SXY_', 'SYA_', 'SYB_', 'SYC_', 'SYE_', 'SYG_', 'SYJ_',
    'SYK_', 'SYM_', 'SYN_', 'SYR_', 'SYS_', 'SYT_', 'SYY_', 'SZY_', 'TB1_',
    'TB3_', 'TB4_', 'TB5_', 'TCA_', 'TDY_', 'TEI_', 'TEN_', 'TGI_', 'THJ_',
    'TJN_', 'TKC_', 'TKJ_', 'TKK_', 'TKM_', 'TKR_', 'TKY_', 'TLA_', 'TLB_',
    'TLC_', 'TLD_', 'TMY_', 'TNJ_', 'TNP_', 'TNZ_', 'TSK_', 'TST_', 'TSY_',
    'TYZ_', 'UCH_', 'UGN_', 'UNH_', 'USN_', 'VCN_', 'VNA_', 'VNC_', 'WA1_',
    'WAM_', 'WAN_', 'WD1_', 'WD3_', 'WO1_', 'WO3_', 'WO4_', 'WO5_', 'WO6_',
    'WO7_', 'WO9_', 'WOA_', 'WON_', 'WTA_', 'WTB_', 'WTE_', 'XGH_', 'XHG_',
    'XHK_', 'XHO_', 'XNO_', 'YAN_', 'YHG_', 'YKM_', 'YOG_', 'YOK_', 'YRU_',
    'YRY_', 'YUR_', 'ZKN_', 'ZKS_', 'ZNC_', 'ZOH_', 'ZYC_'
  );

  (*
      These CharIDs are errornous extracted if we don't set properly the right texture
      to extract. Check the SPECIAL_CHARIDS_PAKF_TEXTURE_INDEX array to know the
      texture index to extract from the PAKF.

      Example: In the HDEI PKF package, the Face texture is the N°4. The TextureNumber
      starts at 1 (not 0), so the first texture in the PKF package is 1.
  *)


const
  SPECIAL_NPCS: array [0..20] of TSpecialNPC = (
    (CharID: 'HDEI'; TextureIndex: 4), (CharID: 'KOGA'; TextureIndex: 4),
    (CharID: 'MORN'; TextureIndex: 4), (CharID: 'YMGC'; TextureIndex: 4),
    (CharID: '04B_'; TextureIndex: 7), (CharID: '05B_'; TextureIndex: 5),
    (CharID: '06B_'; TextureIndex: 5), (CharID: '07B_'; TextureIndex: 5),
    (CharID: '08B_'; TextureIndex: 5), (CharID: '09B_'; TextureIndex: 5),
    (CharID: 'C07_'; TextureIndex: 6), (CharID: 'EDL_'; TextureIndex: 7),
    (CharID: 'KJN_'; TextureIndex: 7), (CharID: 'KUD_'; TextureIndex: 4),
    (CharID: 'KUN_'; TextureIndex: 7), (CharID: 'KYG_'; TextureIndex: 4),
    (CharID: 'MEY_'; TextureIndex: 7), (CharID: 'MM5_'; TextureIndex: 2),
    (CharID: 'RNP_'; TextureIndex: 6), (CharID: 'SYM_'; TextureIndex: 5),
    (CharID: 'TSK_'; TextureIndex: 6)
  );

//=============================================================================

// Thanks Marc Collin
// http://www.laboiteaprog.com/article-30-1-delphi_recherche_binaire
// This function is here to search in an array. ONLY IF THE ARRAY IS SORTED!!!
function BinarySearch(A: array of string; ValueToSearch: string): Integer;
var
  Middle, Top, Bottom: Integer;
  Found: Boolean;

begin
  ValueToSearch := UpperCase(ValueToSearch);
  
  Bottom := Low(A);
  Top := High(A);
  Found := False;
  BinarySearch := 1;

  while(Bottom <= Top) and (not Found) do
  begin
    Middle := (Bottom + Top) div 2;
    if A[Middle] = ValueToSearch then begin
      Found := True;
      BinarySearch := Middle;
    end else
      if A[Middle] < ValueToSearch then
        Bottom := Middle + 1
      else
        Top := Middle - 1;
  end; // while

  if not Found then
    Result := -1;
end;

//------------------------------------------------------------------------------

function IsSpecialNPC(SourceArray: array of TSpecialNPC;
  CharID: string; var IndexResult: Integer): Boolean;
var
  i: Integer;

begin
  Result := False;
  i := Low(SourceArray);
  while (not Result) and (i <= High(SourceArray)) do begin
    Result := (Pos(SourceArray[i].CharID, CharID) > 0);
    if not Result then
      Inc(i);
  end;
  if Result then
    IndexResult := i
  else
    IndexResult := -1;
end;

//=============================================================================

function IsValidCharID(const GameVersion: TGameVersion; const CharID: string): Boolean;
begin
  Result := False;

  case GameVersion of
    gvWhatsShenmue:
      Result := BinarySearch(VALID_NPC_WHATS_SHENMUE, CharID) <> -1;
    gvShenmueJ:
      Result := BinarySearch(VALID_NPC_SHENMUE, CharID) <> -1;
    gvShenmue:
      Result := BinarySearch(VALID_NPC_SHENMUE, CharID) <> -1;
    gvShenmue2J:
      Result := BinarySearch(VALID_NPC_SHENMUE2, CharID) <> -1;
    gvShenmue2:
      Result := BinarySearch(VALID_NPC_SHENMUE2, CharID) <> -1;
    gvShenmue2X:
      Result := BinarySearch(VALID_NPC_SHENMUE2, CharID) <> -1;    
  end;
  
end;

//------------------------------------------------------------------------------

function IsFaceTexture(TextureName: string): Boolean;
const
  SM1_FACE_TEXNAME_SIGN: array[0..12] of string = (
    'KAO', 'HED', 'KAA', 'FAC', 'KAF',
    'KAJ', 'MET', 'HIR', 'FCF', 'KAK',
    'RKA', 'NFA', 'KAC'); // 'MUF', 'ALL', 'AAA', 'L'
    
  SM2_FACE_TEXNAME_SIGN: array[0..1] of string = (
    '}Y_1', '}Y¾‡'
  );

var
  i: Integer;
    
begin
  TextureName := UpperCase(TextureName);

  // Shenmue I
  Result := IsValueInArray(SM1_FACE_TEXNAME_SIGN, TextureName, i);

  // Shenmue II
  if not Result then begin
    TextureName[6] := 'Y'; // fix for some Shenmue II PAKF...
    Result := IsValueInArray(SM2_FACE_TEXNAME_SIGN, TextureName, i);
  end;
end;

//------------------------------------------------------------------------------

// Sucks function but who cares???
function GetTextureIndexForSpecialCharID(const CharID: string): Integer;
var
  i: Integer;
  
begin
  // Setting default texture number (By Default, it will search for the texture name)
  Result := -1;

  // Handling special CharID (sucks too much... I know)
  if IsSpecialNPC(SPECIAL_NPCS, CharID, i) then begin
    Result := SPECIAL_NPCS[i].TextureIndex;

{$IFDEF DEBUG}
    WriteLn('  Special CharID: "', CharID, '", TextureNumber: ', Result);
{$ENDIF}
  end;
end;

//=============================================================================

end.
