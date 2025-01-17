(defun c:1DE() (if (= lfn22 1)	(c:cim1DE)(progn (load "W001.LSP" "")(c:cim1DE))));외여닫이 문 그리기
(defun c:1DT() (if (= lfn23 1)	(c:cim1DT)(progn (load "W002.LSP" "")(c:cim1DT))));채광창 + 외여닫이 문 그리기
(defun c:1GD() (if (= lfn24 1)	(c:cim1GD)(progn (load "W003.LSP" "")(c:cim1GD))));외여닫이 강화유리문 그리기
(defun c:2DE() (if (= lfn35 1)	(c:cim2DE)(progn (load "W008.LSP" "")(c:cim2DE))));쌍여닫이 문 그리기
(defun c:2DT() (if (= lfn36 1)	(c:cim2DT)(progn (load "W009.LSP" "")(c:cim2DT))));채광창 + 쌍여닫이 문 그리기
(defun c:2GD() (if (= lfn37 1)	(c:cim2GD)(progn (load "W010.LSP" "")(c:cim2GD))));쌍여닫이 강화유리문 그리기
(defun c:AHA() (if (= lfn09 1)	(c:cimAHA)(progn (load "AREA.LSP" "")(c:cimAHA))));면적을 알고 싶을 때 사용
(defun c:AL() (if (= lfn01 1)	(c:cimAL)(progn (load "UTIL1.LSP" "")(c:cimAL))));호의 길이를 보여준다
(defun c:AN() (if (= lfn09 1)	(c:cimAN)(progn (load "AREA.LSP" "")(c:cimAN))));대지구적표
(defun c:AP() (if (= lfn01 1)	(c:cimAP)(progn (load "UTIL1.LSP" "")(c:cimAP))));알파벳을 주어진 거리에 맞추어서 입력
(defun c:AS() (if (= lfn01 1)	(c:cimAS)(progn (load "UTIL1.LSP" "")(c:cimAS))));계단 숫자 쓰기
(defun c:AT() (if (= lfn01 1)	(c:cimAT)(progn (load "UTIL1.LSP" "")(c:cimAT))));연속되는 숫자를 기입
(defun c:BB() (if (= lfn03 1)	(c:cimBB)(progn (load "UTIL3.LSP" "")(c:cimBB))));사각형 그린 후,각도 입력
(defun c:BEAM() (if (= lfn40 1) (c:cimBEAM) (progn (load "beam.LSP" "")(c:cimBEAM))));보일람표
(defun c:BH1() (if (= lfn10 1)	(c:cimBH1)(progn (load "BATH1.LSP" "")(c:cimBH1))));화장실 그리기
(defun c:BL() (if (= lfn07 1)	(c:cimBL)(progn (load "SYM2.LSP" "")(c:cimBL))));잘라낸 부분 표시
(defun c:BO() (if (= lfn03 1)	(c:cimBO)(progn (load "UTIL3.LSP" "")(c:cimBO))));3점을 이용한 사각형 그리기
(defun c:BX() (if (= lfn03 1)	(c:cimBX) (progn (load "UTIL3.LSP" "")(c:cimBX))));사각형과 그 안에 X를 그리는 명령
(defun c:CCL() (if (= lfn02 1)	(c:cimCCL)(progn (load "UTIL2.LSP" "")(c:cimCCL))));"ㄱ" 모양 벽체 정리
(defun c:CN() (if (= lfn03 1)	(c:cimCEN)(progn (load "UTIL3.LSP" "")(c:cimCEN))));중심선을 그리는 명령
(defun c:CHA() (if (= lfn02 1)	(c:cimCHA)(progn (load "UTIL2.LSP" "")(c:cimCHA))));오브젝트에 각도를 주어 회전
(defun c:CHAL() (if (= lfn45 1) (c:cimchal)(progn (load "W032.LSP" "")(c:cimchal))));물체를 선택함으써 color,line type,layer등을 변경하는 명령
(defun c:CHB() (if (= lfn02 1)	(c:cimCHB)(progn (load "UTIL2.LSP" "")(c:cimCHB))));기존에 있는 블록을 새로운 블록으로 변경
(defun c:CHS() (if (= lfn05 1)	(c:cimCHS)(progn (load "TEXT.LSP" "")(c:cimCHS))));문자열 내용을 변경
(defun c:CHT() (if (= lfn05 1)	(c:cimCHT)(progn (load "TEXT.LSP" "")(c:cimCHT))));문자열 전체속성을 변경
(defun c:CHX() (if (= lfn05 1)	(c:cimCHX)(progn (load "TEXT.LSP" "")(c:cimCHX))));선택한 문자열 전체를 교체
(defun c:CLA() (if (= lfn03 1)	(c:cimCHLA)(progn (load "UTIL3.LSP" "")(c:cimCHLA))));객체의 레이어를 변경합니다.
(defun c:CLD() (if (= lfn03 1)	(c:cimCHLD)(progn (load "UTIL3.LSP" "")(c:cimCHLD))));객체의 레이어를 대화상자를 통해 변경합니다.
(defun c:CLIST() (if (= lfn41 1) (c:cimCLIST) (progn (load "clist.LSP" "")(c:cimCLIST))));기둥 일람표
(defun c:CLT() (if (= lfn46 1) (c:cimclt)(progn (load "W033.LSP" "")(c:cimclt))));물체를 선택함으써 color,line type등을 변경하는 령
(defun c:CM() (if (= lfn07 1)	(c:cimCM)(progn (load "SYM2.LSP" "")(c:cimCM))));숫자에 콤마(,)를 삽입 또는 제거
(defun c:CNT() (if (= lfn01 1)	(c:cimCNT)(progn (load "UTIL1.LSP" "")(c:cimCNT))));숫자의 사칙 연산
(defun c:CO() (if (= lfn03 1)	(c:cimCHCO)(progn (load "UTIL3.LSP" "")(c:cimCHCO))));객체의 색을 변경합니다.
(defun c:COL() (if (= lfn16 1)	(c:cimCOL)(progn (load "STRU.LSP" "")(c:cimCOL))));기둥그리기 (RC / SC / SRC)
(defun c:CONC() (if (= lfn08 1)	(c:cimCONC)(progn (load "WALLH.LSP" "")(c:cimCONC))));콘크리트 해치하기
(defun c:CST() (if (= lfn17 1)	(c:cimCTS)(progn (load "SYM3.LSP" "")(c:cimCTS))));기둥 심볼 태그 넣기
(defun c:CT() (if (= lfn02 1)	(c:cimCT)(progn (load "UTIL2.LSP" "")(c:cimCT))));객체를 box 형태로 잘라낸다.
(defun c:CTX() (if (= lfn05 1)	(c:cimCTX)(progn (load "TEXT.LSP" "")(c:cimCTX))));선택한 문자열중 일부분을 변경 하는 명령
(defun c:CWE() (if (= lfn34 1)	(c:cimCWE)(progn (load "LTCWE.LSP" "")(c:cimCWE))));커튼월 입면 그리기
(defun c:DCI() (if (= lfn01 1)	(c:cimDCI)(progn (load "UTIL1.LSP" "")(c:cimDCI))));치수에 콤마 넣기
(defun c:DCR() (if (= lfn01 1)	(c:cimDCR)(progn (load "UTIL1.LSP" "")(c:cimDCR))));치수에 콤마 제거
(defun c:DED() (if (= lfn02 1)	(c:cimCDEDIT)(progn (load "UTIL2.LSP" "")(c:cimCDEDIT))));치수값 수정하기
(defun c:DLIST() (if (= lfn38 1) (c:cimDLIST) (progn (load "dwglist.LSP" "")(c:cimDLIST))));도면 일람표 작성
(defun c:DM() (if (= lfn12 1)	(c:cimDM)(progn (load "W074.LSP" "")(c:cimDM))));자동 치수 기입
(defun c:DR() (if (= lfn18 1)	(c:cimDOOR)(progn (load "ltdoor.LSP" "")(c:cimDOOR))));문을 그리는 명령어
(defun c:DRE() (if (= lfn02 1)	(c:cimCDNEW)(progn (load "UTIL2.LSP" "")(c:cimCDNEW))));변경된 치수값 복구하기
(defun c:DTL() (if (= lfn19 1)	(c:cimDTL)(progn (load "W075.LSP" "")(c:cimDTL))));타이틀 그리는 명령어
(defun c:ELM() (if (= lfn07 1)	(c:cimELMARK)(progn (load "SYM2.LSP" "")(c:cimELMARK))));입면도 높이를 표시
(defun c:ESS() (if (= lfn07 1)	(c:cimESS)(progn (load "SYM2.LSP" "")(c:cimESS))));전개도 표시 기호
(defun c:FIXU() (if (= lfn10 1)	(c:cimfixu)(progn (load "BATH1.LSP" "")(c:cimfixu))));소변기 평면 그리기
(defun c:FIXUE() (if (= lfn10 1)(c:cimfixue)(progn (load "BATH1.LSP" "")(c:cimfixue))));소변기 입면 그리기
(defun c:FIXW() (if (= lfn10 1)	(c:cimfixw)(progn (load "BATH1.LSP" "")(c:cimfixw))));세면기 평면 그리기
(defun c:FIXWE() (if (= lfn10 1)(c:cimfixwe)(progn (load "BATH1.LSP" "")(c:cimfixwe))));세면기 입면 그리기
(defun c:FLIST() (if (= lfn39 1) (c:cimFLIST) (progn (load "finlist.LSP" "")(c:cimFLIST))));실내 재료 마감표
(defun c:FSE() (if (= lfn33 1)	(c:cimFSE)(progn (load "LTFSE.LSP" "")(c:cimFSE))));입면 창문 그리기
(defun c:FST() (if (= lfn17 1)	(c:cimFST)(progn (load "SYM3.LSP" "")(c:cimFST))));기초 심볼 태그 넣기
(defun c:GST() (if (= lfn17 1)	(c:cimGST)(progn (load "SYM3.LSP" "")(c:cimGST))));보 심볼 태그 넣기
(defun c:HB() (if (= lfn06 1)	(c:cimHB) (progn (load "SYM1.LSP" "")(c:cimHB))));BOX 형태로 해치
(defun c:INS() (if (= lfn06 1)	(c:cimINSUL)(progn (load "SYM1.LSP" "")(c:cimINSUL))));단열재 표시
(defun c:IPL() (if (= lfn27 1)	(c:cimIPL)(progn (load "W091.LSP" "")(c:cimIPL))));최초 도면 설정
(defun c:KICI() (if (= lfn13 1)	(c:cimKICI) (progn (load "KITC.LSP" "")(c:cimKICI))));I형 주방(싱크) 그리기
(defun c:KICL() (if (= lfn13 1)	(c:cimKICL) (progn (load "KITC.LSP" "")(c:cimKICL))));L형 주방(싱크) 그리기
(defun c:KK() (if (= lfn03 1)	(c:cimKK)(progn (load "UTIL3.LSP" "")(c:cimKK))));열림 기호 K 표시
(defun c:LD() (if (= lfn21 1)	(c:cimLEADER)(progn (load "ltleader.LSP" "")(c:cimLEADER))));지시선에 의한 재료 표기
(defun c:LEM() (if (= lfn07 1)	(c:cimLEMARK)(progn (load "SYM2.LSP" "")(c:cimLEMARK))));높 낮이를 표시한다.
(defun c:LFR() (if (= lfn04 1)	(c:cimSEOF) (progn (load "LAYER.LSP" "")(c:cimSEOF))));개체가 속해 있는 도면층을 얼림(Freeze)
(defun c:LIFT() (if (= lfn43 1)	(c:cimLIFT)(progn (load "TRANS.LSP" "")(c:cimLIFT))));화물용 승강기 그리기
(defun c:LOF() (if (= lfn04 1)	(c:cimSELF) (progn (load "LAYER.LSP" "")(c:cimSELF))));개체가 속해 있는 도면층을 끔(Off)
(defun c:M2() (if (= lfn01 1)	(c:cimM2)(progn (load "UTIL1.LSP" "")(c:cimM2))));평을 m2로 변경
(defun c:MC() (if (= lfn02 1)   (c:cimMC)(progn (load "UTIL2.LSP" "")(c:cimMC))));다중 복사 (Multi Copy)
(defun c:MCD() (if (= lfn42 1)	(c:cimMCD)(progn (load "MCD.LSP" "")(c:cimMCD))));안목치수 기입
(defun c:ME() (if (= lfn02 1)	(c:cimME)(progn (load "UTIL2.LSP" "")(c:cimME))));다중 연장 (multi extend )
(defun c:MF() (if (= lfn02 1)   (c:cimMF)(progn (load "UTIL2.LSP" "")(c:cimMF))));다중 모깎기 (Multi Fillet)
(defun c:MFF() (if (= lfn02 1)	(c:cimMFF)(progn (load "UTIL2.LSP" "")(c:cimMFF))));불연속 간격 띄우기
(defun c:MOF() (if (= lfn02 1)	(c:cimMOF)(progn (load "UTIL2.LSP" "")(c:cimMOF))));다중 간격 띄우기
(defun c:MT() (if (= lfn02 1)	(c:cimMTRIM)(progn (load "UTIL2.LSP" "")(c:cimMTRIM))));다중 잘라내기 (multi trim )
(defun c:MV() (if (= lfn02 1)	(c:cimMOVER)(progn (load "UTIL2.LSP" "")(c:cimMOVER))));move,copy,rotate등을 연속으로 실행
(defun c:OFC() (if (= lfn02 1)	(c:cimOFC)(progn (load "UTIL2.LSP" "")(c:cimOFC))));현재 도면층으로 offset하기
(defun c:OFE() (if (= lfn02 1)	(c:cimOFE)(progn (load "UTIL2.LSP" "")(c:cimOFE))));offset 후 erase
(defun c:PA() (if (= lfn06 1)	(c:cimPA)(progn (load "SYM1.LSP" "")(c:cimPA))));특정한 공간을 해치
(defun c:PK() (if (= lfn06 1)	(c:cimPK)(progn (load "SYM1.LSP" "")(c:cimPK))));주차장 그리기
(defun c:PPB() (if (= lfn07 1)	(c:cimPPB)(progn (load "SYM2.LSP" "")(c:cimPPB))));확대 영역 표시
(defun c:PPL() (if (= lfn02 1)	(c:cimPPL)(progn (load "UTIL2.LSP" "")(c:cimPPL))));도면의 일부를 별도의 dwg으로 저장
(defun c:PWE() (if (= lfn32 1)	(c:cimPWE)(progn (load "LTPWE.LSP" "")(c:cimPWE))));입면 창문 그리기
(defun c:PY() (if (= lfn01 1)	(c:cimPY)(progn (load "UTIL1.LSP" "")(c:cimPY))));m2를 평으로 변환
(defun c:RC() (if (= lfn02 1)   (c:cimRC)(progn (load "UTIL2.LSP" "")(c:cimRC))));회전 복사 (Rotate Copy)
(defun c:RD() (if (= lfn06 1)	(c:cimRD)(progn (load "SYM1.LSP" "")(c:cimRD))));루프 드레인 그리기
(defun c:REP() (if (= lfn02 1)	(c:cimREP)(progn (load "UTIL2.LSP" "")(c:cimREP))));CAP 명령을 사용하여 만든 블록을 도면에 입력
(defun c:RM() (if (= lfn25 1)	(c:cimRM)(progn (load "RM.LSP" "")(c:cimRM))));거실명 작성
(defun c:RUB() (if (= lfn06 1)	(c:cimRUB)(progn (load "SYM1.LSP" "")(c:cimRUB))));잡석 그리기
(defun c:SC() (if (= lfn07 1)	(c:cimSC)(progn (load "SYM2.LSP" "")(c:cimSC))));절단면 기호(단선)를 기입
(defun c:SCD() (if (= lfn07 1)	(c:cimSCD)(progn (load "SYM2.LSP" "")(c:cimSCD))));절단면 기호(복선)를 기입
(defun c:SECL() (if (= lfn47 1) (c:cimsecl) (progn (load "W181.LSP" "")(c:cimsecl))));현재로 바꿀 색상과 Layer의 물체를 선택하는 명령
(defun c:SFE() (if (= lfn31 1)	(c:cimSFE)(progn (load "LTSFE.LSP" "")(c:cimSFE))));입면 창문 그리기
(defun c:SL() (if (= lfn04 1)	(c:cimSL) (progn (load "LAYER.LSP" "")(c:cimSL))));현재 레이어 변경
(defun c:SLB() (if (= lfn44 1)	(c:cimSLB)(progn (load "LTSLB.LSP" "")(c:cimSLB))));슬라브 일람표 작성
(defun c:SLF() (if (= lfn04 1)	(c:cimSLF) (progn (load "LAYER.LSP" "")(c:cimSLF))));선택객체를 제외한 얼림
(defun c:SLN() (if (= lfn04 1)	(c:cimSLN) (progn (load "LAYER.LSP" "")(c:cimSLN))));모든 레이어를 보여준다.
(defun c:SLO() (if (= lfn04 1)	(c:cimSLO) (progn (load "LAYER.LSP" "")(c:cimSLO))));선택된 layer만 보이게 한다.
(defun c:SNGP() (if (= lfn02 1)	(c:cimSNGP)(progn (load "UTIL2.LSP" "")(c:cimSNGP))));작업축(커서) 원 위치
(defun c:SSL() (if (= lfn07 1)	(c:cimSSL)(progn (load "SYM2.LSP" "")(c:cimSSL))));단면 표기를 기입하는 명령
(defun c:SSNG() (if (= lfn02 1)	(c:cimSSNG)(progn (load "UTIL2.LSP" "")(c:cimSSNG))));작업축(커서) 변경
(defun c:SST() (if (= lfn17 1)	(c:cimSST)(progn (load "SYM3.LSP" "")(c:cimSST))));슬라브 심볼 태그 넣기
(defun c:START() (if (= lfn15 1)(c:cimSTART)(progn (load "START.LSP" "")(c:cimSTART))));도면 환경 설정
(defun c:STC() (if (= lfn14 1)	(c:cimSTC)(progn (load "STAIR.LSP" "")(c:cimSTC))));계단 입단면을 작성
(defun c:STLG() (if (= lfn16 1)	(c:cimSTLG)(progn (load "STRU.LSP" "")(c:cimSTLG))));철재보 평면 그리기
(defun c:STN() (if (= lfn04 1)	(c:cimSTN) (progn (load "LAYER.LSP" "")(c:cimSTN))));전체 얼림 복구
(defun c:STP() (if (= lfn14 1)	(c:cimSTP)(progn (load "STAIR.LSP" "")(c:cimSTP))));계단 평면도를 작성
(defun c:SWE() (if (= lfn30 1)	(c:cimSWE)(progn (load "LTSWE.LSP" "")(c:cimSWE))));입면 창문 그리기
(defun c:TJ() (if (= lfn05 1)	(c:cimTJ)(progn (load "TEXT.LSP" "")(c:cimTJ))));문자정렬 변경
(defun c:TS() (if (= lfn05 1)	(c:cimTS)(progn (load "TEXT.LSP" "")(c:cimTS))));문자의 스타일 변경
(defun c:TT1() (if (= lfn11 1)	(c:cimtt1)(progn (load "BATH2.LSP" "")(c:cimtt1))));변기와 한쪽 파티션벽 그리기
(defun c:TT2() (if (= lfn11 1)	(c:cimtt2)(progn (load "BATH2.LSP" "")(c:cimtt2))));변기와 파티션벽 그리기
(defun c:TW() (if (= lfn05 1)	(c:cimTW)(progn (load "TEXT.LSP" "")(c:cimTW))));문자의 폭을 변경
(defun c:TZ() (if (= lfn05 1)	(c:cimTZ)(progn (load "TEXT.LSP" "")(c:cimTZ))));문자크기를 변경
(defun c:VD() (if (= lfn43 1)	(c:cimVD)(progn (load "TRANS.LSP" "")(c:cimVD))));엘리베이터 그리기
(defun c:VV() (if (= lfn03 1)	(c:cimVV)(progn (load "UTIL3.LSP" "")(c:cimVV))));열림 기호 V 표시
(defun c:WAT() (if (= lfn07 1)	(c:cimWAT)(progn (load "SYM2.LSP" "")(c:cimWAT))));오수배관 그리기
(defun c:WDS() (if (= lfn26 1)	(c:cimWDS)(progn (load "W165.LSP" "")(c:cimWDS))));창호 심볼 태그 넣기
(defun c:WL() (if (= lfn28 1)	(c:cimWALL)(progn (load "ltwall.LSP" "")(c:cimWALL))));벽 평면 그리기
(defun c:WLB() (if (= lfn08 1)	(c:cimWLB)(progn (load "WALLH.LSP" "")(c:cimWLB))));블록(BLOCK) 해치
(defun c:WLH() (if (= lfn08 1)	(c:cimWLH)(progn (load "WALLH.LSP" "")(c:cimWLH))));벽돌(BRICK) 해치
(defun c:WN() (if (= lfn29 1)	(c:cimWIN)(progn (load "ltwin.LSP" "")(c:cimWIN))));창문 평면 그리기
(defun c:WR() (if (= lfn20 1)	(c:cimWR)(progn (load "W175.LSP" "")(c:cimWR))));끊어진 벽체를 복구
(defun c:WSH() (if (= lfn10 1)	(c:cimWSH)(progn (load "BATH1.LSP" "")(c:cimWSH))));조합형 세면기 평면 그리기
(defun c:WST() (if (= lfn17 1)	(c:cimWST)(progn (load "SYM3.LSP" "")(c:cimWST))));벽 심볼 태그 넣기
(defun c:XT() (if (= lfn02 1)	(c:cimXT)(progn (load "UTIL2.LSP" "")(c:cimXT))));" +" 모양 벽체 정리
(defun c:XX() (if (= lfn03 1)	(c:cimXX) (progn (load "UTIL3.LSP" "")(c:cimXX))));void를 그리는 명령
(defun c:Z1() (if (= lfn02 1)	(c:CIMZ1)(progn (load "UTIL2.LSP" "")(c:CIMZ1))));중심확대 1
(defun c:Z2() (if (= lfn02 1)	(c:CIMZ2)(progn (load "UTIL2.LSP" "")(c:CIMZ2))));중심확대 2
(defun c:Z3() (if (= lfn02 1)	(c:CIMZ3)(progn (load "UTIL2.LSP" "")(c:CIMZ3))));중심확대 3
(defun c:Z4() (if (= lfn02 1)	(c:CIMZ4)(progn (load "UTIL2.LSP" "")(c:CIMZ4))));중심확대 4
(defun c:Z4() (if (= lfn02 1)	(c:CIMZ4)(progn (load "UTIL2.LSP" "")(c:CIMZ4))));중심확대 4
(defun c:ellipsecen() (command "_ellipse""_c")(princ))
;;(defun c:IMGATTACHONE() (setvar "cmdecho" 0) (command "_image" "_r" "xx")(command "IMGATTACH")(setvar "cmdecho" 1)(princ))
(defun c:ZA() (command "_zoom""_a")(princ));zoom all
(defun c:ZC() (command "_zoom""_c")(princ));zoom center
(defun c:ZD() (command "_zoom""_d")(princ));zoom dynamic
(defun c:ZE() (command "_zoom""_e")(princ));zoom expand
(defun c:ZP() (command "_zoom""_p")(princ));zoom prvious
(defun c:ZW() (command "_zoom""_w")(princ));zoom Window
(defun c:ZZ() (command "_zoom""_p")(princ));zoom prvious
(princ)