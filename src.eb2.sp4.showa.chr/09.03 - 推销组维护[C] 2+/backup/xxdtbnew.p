/* 根据 buyer  */
/* 区分 SA和PS */

{ParseParam.i}

DEF VAR str_st AS CHAR FORMAT "X(15)".
DEF VAR st_date AS DATE.
DEF VAR str_ed AS CHAR FORMAT "X(15)".
DEF VAR ed_date AS DATE.
DEF VAR yy1 AS INT.
DEF VAR mm1 AS INT.
DEF VAR dd1 AS INT.
DEF VAR yy2 AS INT.
DEF VAR mm2 AS INT.
DEF VAR dd2 AS INT.
DEF VAR jz AS CHAR.
DEF VAR pkg AS INT.
DEF VAR file_out as character FORMAT "x(30)" .
DEF VAR cust AS CHAR.
DEF VAR cust1 AS CHAR.
DEF VAR choice AS INT.
DEF VAR buyer AS CHAR.
DEF VAR bb AS CHAR.

DEF TEMP-TABLE tsod
    FIELD tsod_part label "图号" LIKE pt_part
    FIELD tsod_date1 AS DATE LABEL "日期"
    FIELD tsod_time1 AS CHAR LABEL "时段"
    FIELD tsod_date AS DATE LABEL "传票日期"
    FIELD tsod_time AS CHAR LABEL "传票时段"
    FIELD tsod_qty LIKE ld_qty_oh  label "数量"
    FIELD tsod_cust AS CHAR  label "客户"
    FIELD tsod_pkg  LIKE ld_qty_oh label "包装"
    FIELD tsod_jz  AS CHAR LABEL "机种"
    FIELD tsod_inv  AS CHAR label "传票"
    FIELD tsod_buyer LIKE pt_buyer label "区分"
    FIELD tsod_memo AS CHAR FORMAT 'x(30)' LABEL "备注".

DEF TEMP-TABLE dtb1
    FIELD dtb_date AS DATE label "日期"
    FIELD dtb_time AS CHAR LABEL "时段"
    FIELD dtb_old AS CHAR FORMAT "x(15)" LABEL "传票日期"
    FIELD dtb_qty AS INT LABEL "数量"
    FIELD dtb_car AS INT LABEL  "台车"
    FIELD dtb_memo AS CHAR FORMAT "x(20)" LABEL "版本"
    FIELD dtb_pcs AS INT LABEL "传票数量"
    FIELD dtb_black AS CHAR LABEL "空白"                                                                                                   
    FIELD dtb_sp LIKE ld_qty_oh LABEL "SP"
    FIELD dtb_a1 LIKE ld_qty_oh LABEL "PS-TB0"
    FIELD dtb_a2 LIKE ld_qty_oh LABEL "PS-TB1"
    FIELD dtb_a3 LIKE ld_qty_oh LABEL "PS-LK"
    FIELD dtb_a4 LIKE ld_qty_oh LABEL "PS-2ST"
    /*FIELD dtb_a5 LIKE ld_qty_oh LABEL "PS-ZU"*/
    FIELD dtb_a6 LIKE ld_qty_oh LABEL "ECU-LKMT"
    FIELD dtb_a7 LIKE ld_qty_oh LABEL "ECU-LKAT"
    /*FIELD dtb_a8 LIKE ld_qty_oh LABEL "ECU-ZUMT"
    FIELD dtb_a9 LIKE ld_qty_oh LABEL "ECU-ZUCVT"*/
    FIELD dtb_a10 LIKE ld_qty_oh LABEL "ECU-2STMT"
    FIELD dtb_a11 LIKE ld_qty_oh LABEL "ECU-2STAT"
    FIELD dtb_a12 LIKE ld_qty_oh LABEL "OS-SFJR"
    FIELD dtb_a13 LIKE ld_qty_oh LABEL "OS-SFJL"
    /*FIELD dtb_a14 LIKE ld_qty_oh LABEL "OS-ZUR"
    FIELD dtb_a15 LIKE ld_qty_oh LABEL "OS-ZUL"*/
    FIELD dtb_a16 LIKE ld_qty_oh LABEL "SA-20MTR"
    FIELD dtb_a17 LIKE ld_qty_oh LABEL "SA-20MTL"
    FIELD dtb_a18 LIKE ld_qty_oh LABEL "SA-20ATR"
    FIELD dtb_a19 LIKE ld_qty_oh LABEL "SA-20ATL"
    FIELD dtb_a20 LIKE ld_qty_oh LABEL "SA-20R"
    FIELD dtb_a21 LIKE ld_qty_oh LABEL "SA-20L"
    FIELD dtb_a22 LIKE ld_qty_oh LABEL "SA-24FR"
    FIELD dtb_a23 LIKE ld_qty_oh LABEL "SA-24FL"
    FIELD dtb_a24 LIKE ld_qty_oh LABEL "SA-24RR"
    FIELD dtb_a25 LIKE ld_qty_oh LABEL "SA-24RL"
    FIELD dtb_a26 LIKE ld_qty_oh LABEL "SA-35FR"
    FIELD dtb_a27 LIKE ld_qty_oh LABEL "SA-35FL"
    FIELD dtb_a28 LIKE ld_qty_oh LABEL "SA-35RR"
    FIELD dtb_a29 LIKE ld_qty_oh LABEL "SA-35RL"
    FIELD dtb_a30 LIKE ld_qty_oh LABEL "SA-LKMTR"
    FIELD dtb_a31 LIKE ld_qty_oh LABEL "SA-LKMTL"
    FIELD dtb_a32 LIKE ld_qty_oh LABEL "SA-LKCVTR"
    FIELD dtb_a33 LIKE ld_qty_oh LABEL "SA-LKCVTL"
    FIELD dtb_a34 LIKE ld_qty_oh LABEL "SA-LKR"
    FIELD dtb_a35 LIKE ld_qty_oh LABEL "SA-2STMTR"
    FIELD dtb_a36 LIKE ld_qty_oh LABEL "SA-2STMTL"
    FIELD dtb_a37 LIKE ld_qty_oh LABEL "SA-2STCVTR"
    FIELD dtb_a38 LIKE ld_qty_oh LABEL "SA-2STCVTL"
    FIELD dtb_a39 LIKE ld_qty_oh LABEL "SA-2STCVT"
    FIELD dtb_a40 LIKE ld_qty_oh LABEL "SA-GZFR"
    FIELD dtb_a41 LIKE ld_qty_oh LABEL "SA-GZFL"
    FIELD dtb_a42 LIKE ld_qty_oh LABEL "SA-GZRR"
    FIELD dtb_a43 LIKE ld_qty_oh LABEL "SA-GZRL".

DEF TEMP-TABLE dtb2
    /*FIELD dtb_a44 LIKE ld_qty_oh LABEL "SA-ZUMTR"
    FIELD dtb_a45 LIKE ld_qty_oh LABEL "SA-ZUMTL"
    FIELD dtb_a46 LIKE ld_qty_oh LABEL "SA-ZUCVTR"
    FIELD dtb_a47 LIKE ld_qty_oh LABEL "SA-ZUCVTL"
    FIELD dtb_a48 LIKE ld_qty_oh LABEL "SA-ZU"*/
    FIELD dtb_a49 LIKE ld_qty_oh LABEL "B-R40"
    FIELD dtb_a50 LIKE ld_qty_oh LABEL "B-R60"
    FIELD dtb_a51 LIKE ld_qty_oh LABEL "B-R70"
    FIELD dtb_a52 LIKE ld_qty_oh LABEL "B-REF"
    FIELD dtb_a53 LIKE ld_qty_oh LABEL "Z-SAA"
    FIELD dtb_a54 LIKE ld_qty_oh LABEL "ECU-Q021"
    FIELD dtb_a55 LIKE ld_qty_oh LABEL "ECU-Q120"
    FIELD dtb_a56 LIKE ld_qty_oh LABEL "ECU-Q220"
    FIELD dtb_a57 LIKE ld_qty_oh LABEL "ECU-R021"
    FIELD dtb_a58 LIKE ld_qty_oh LABEL "ECU-R120"
    FIELD dtb_a59 LIKE ld_qty_oh LABEL "ECU-R220"
    FIELD dtb_a60 LIKE ld_qty_oh LABEL "ECU-R320"
    FIELD dtb_a61 LIKE ld_qty_oh LABEL "PS-E620"
    FIELD dtb_a62 LIKE ld_qty_oh LABEL "PS-E630"
    FIELD dtb_a63 LIKE ld_qty_oh LABEL "PS-E720"
    FIELD dtb_a64 LIKE ld_qty_oh LABEL "PS-E730"
    FIELD dtb_a65 LIKE ld_qty_oh LABEL "PS-P620"
    FIELD dtb_a66 LIKE ld_qty_oh LABEL "PS-P630"
    FIELD dtb_a67 LIKE ld_qty_oh LABEL "PS-P720"
    FIELD dtb_a68 LIKE ld_qty_oh LABEL "PS-P730"
    FIELD dtb_a69 LIKE ld_qty_oh LABEL "OS-ZBZUR"
    FIELD dtb_a70 LIKE ld_qty_oh LABEL "OS-ZBZUL"
    FIELD dtb_a71 LIKE ld_qty_oh LABEL "PS-2AP"
    FIELD dtb_a72 LIKE ld_qty_oh LABEL "ECU-2APH01"
    FIELD dtb_a73 LIKE ld_qty_oh LABEL "ECU-2APH11"
    FIELD dtb_a74 LIKE ld_qty_oh LABEL "ECU-2APH31"
    FIELD dtb_a75 LIKE ld_qty_oh LABEL "ECU-2APH41"
    FIELD dtb_a76 LIKE ld_qty_oh LABEL "2AP-C02FR"
    FIELD dtb_a77 LIKE ld_qty_oh LABEL "2AP-C02FL"
    FIELD dtb_a78 LIKE ld_qty_oh LABEL "2AP-C12FR"
    FIELD dtb_a79 LIKE ld_qty_oh LABEL "2AP-C12FL"
    FIELD dtb_a80 LIKE ld_qty_oh LABEL "2AP-C32FR"
    FIELD dtb_a81 LIKE ld_qty_oh LABEL "2AP-C32FL"
    FIELD dtb_a82 LIKE ld_qty_oh LABEL "2AP-C22FR"
    FIELD dtb_a83 LIKE ld_qty_oh LABEL "2AP-C22FL"
    FIELD dtb_a84 LIKE ld_qty_oh LABEL "2AP-C42FR"
    FIELD dtb_a85 LIKE ld_qty_oh LABEL "2AP-C42FL"
    FIELD dtb_a86 LIKE ld_qty_oh LABEL "2AP-C020RR"
    FIELD dtb_a87 LIKE ld_qty_oh LABEL "2AP-C110RR"
    FIELD dtb_a88 LIKE ld_qty_oh LABEL "2AP-ZDXJ".


/*SET st_date ed_date choice.*/
st_date = date(GetParam("st_date")).
ed_date = date(GetParam("ed_date")).
choice = int(GetParam("choice")).
buyer = GetParam("buyer").
file_out = "C:\qadguicli\bicallprogress\dtb.txt".

/* 
4H0001 gb广本一厂
4h0003 DF东本一厂
4h0004 CH中本
4h1001 GE广本二厂
4h1003 DE东本二厂
*/
CASE choice:
    WHEN 1 THEN
        DO:
            cust = "4h0001".
            cust1 = "4h0003".
        END.
    WHEN 2 THEN
        DO:
            cust = "4h1001".
            cust1 = "4h1003".
        END.
    OTHERWISE
        DO:
            cust = "4h0004".
            cust1 = "4H0004".
        END.
END CASE.

/*日期为字符型，要考虑yyyy-mm-dd和yyyy-m-d格式 */
/* xxsod_due_date1 修改后日期                  */
/* xxsod_due_time1 修改后时间                  */


FOR EACH tsod.
    DELETE tsod.
END.

yy1 = YEAR(st_date).
mm1 =  MONTH(st_date).
dd1 = DAY(st_date).
str_st = STRING(yy1) + "-" + STRING(mm1) + "-" + STRING(dd1).

yy2 = YEAR(ed_date).
mm2 =  MONTH(ed_date).
dd2 = DAY(ed_date).
str_ed = STRING(yy2) + "-" + STRING(mm2) + "-" + STRING(dd2).

FOR EACH xxsod_det WHERE xxsod_due_date1 >= str_st AND xxsod_due_date <= str_ed 
         AND ( xxsod_cust = cust OR xxsod_cust = cust1 OR xxsod_cust = UPPER(cust) OR xxsod_cust = UPPER(cust1)) NO-LOCK USE-INDEX cust_invnbr.
    FIND FIRST cp_mstr WHERE cp_cust_part = xxsod_part NO-LOCK.
    IF AVAILABLE cp_mstr THEN
      DO:
        FIND FIRST pt_mstr WHERE pt_part = cp_part NO-LOCK.
        IF AVAILABLE pt_mstr THEN
          DO:
            IF pt_dsgn_grp <> "" THEN jz = pt_dsgn_grp. ELSE jz = "SP".
            IF pt_ord_mult <> 0 THEN pkg = pt_ord_mult. ELSE pkg = 1.
	    IF pt_buyer <> "" THEN bb = pt_buyer. ELSE bb = "XX".
          END.
        ELSE DO:
            jz = "SP".
            pkg = 1.
        END.
      END.
    ELSE DO:
            jz = "SP".
            pkg = 1.
         END.
    CREATE tsod.
    ASSIGN
        tsod_cust = UPPER(xxsod_cust)
        tsod_date = DATE(xxsod_due_date)
        tsod_date1 = DATE(xxsod_due_date1)
        tsod_time = xxsod_due_time
        tsod_time1 = xxsod_due_time1
        tsod_part = xxsod_part
        tsod_qty = int(xxsod_qty)
        tsod_inv = xxsod_invnbr
        tsod_jz = jz
        tsod_pkg = pkg
	tsod_buyer = UPPER(bb).
        tsod_memo = xxsod_rmks1.
END.


/* 查找是否包含 例如：2008-04-02 格式日期 */
IF mm1 < 10 THEN 
    DO:
        IF dd1 > 10 THEN str_st = STRING(yy1) + "-0" + STRING(mm1) + "-" + STRING(dd1).
        ELSE   str_st = STRING(yy1) + "-0" + STRING(mm1) + "-0" + STRING(dd1).
    END.
ELSE str_st = STRING(yy1) + "-0" + STRING(mm1) + "-0" + STRING(dd1).

IF mm2 < 10 THEN 
    DO:
        IF dd2 > 10 THEN str_ed = STRING(yy2) + "-0" + STRING(mm2) + "-" + STRING(dd2).
        ELSE   str_ed = STRING(yy2) + "-0" + STRING(mm2) + "-0" + STRING(dd2).
    END.
ELSE str_ed = STRING(yy2) + "-0" + STRING(mm2) + "-0" + STRING(dd2).

FOR EACH xxsod_det WHERE xxsod_due_date1 >= str_st AND xxsod_due_date1 <= str_ed
         AND ( xxsod_cust = cust OR xxsod_cust = cust1 OR xxsod_cust = UPPER(cust) OR xxsod_cust = UPPER(cust1)) NO-LOCK USE-INDEX cust_invnbr.
    FIND FIRST cp_mstr WHERE cp_cust_part = xxsod_part NO-LOCK.
    IF AVAILABLE cp_mstr THEN
      DO:
        FIND FIRST pt_mstr WHERE pt_part = cp_part NO-LOCK.
        IF AVAILABLE pt_mstr THEN
          DO:
            IF pt_dsgn_grp <> "" THEN jz = pt_dsgn_grp. ELSE jz = "SP".
            IF pt_ord_mult <> 0 THEN pkg = pt_ord_mult. ELSE pkg = 1.
	    IF pt_buyer <> "" THEN bb = pt_buyer. ELSE bb = "XX".
          END.
        ELSE DO:
            jz = "SP".
            pkg = 1.
        END.
      END.
    ELSE DO:
            jz = "SP".
            pkg = 1.
         END.
    CREATE tsod.
    ASSIGN
        tsod_cust = xxsod_addr
        tsod_date = DATE(xxsod_due_date)
        tsod_date1 = DATE(xxsod_due_date1)
        tsod_time = xxsod_due_time
        tsod_time1 = xxsod_due_time1
        tsod_part = xxsod_part
        tsod_qty = int(xxsod_qty)
        tsod_inv = xxsod_invnbr
        tsod_jz = jz
        tsod_pkg = pkg
	tsod_buyer = UPPER(bb).
        tsod_memo = xxsod_rmks1.
END.


/*
FOR EACH tsod.
    DISP tsod.
END.
*/
if buyer = "all" then
do:
FOR EACH tsod where tsod_buyer <> "" BREAK BY tsod_date1 BY tsod_time1.
    FIND FIRST dtb1 WHERE  dtb_time = tsod_time1 AND dtb_date = tsod_date1 AND dtb_old = STRING(MONTH(tsod_date)) + "-" +  STRING(DAY(tsod_date)) + " " + tsod_time NO-ERROR.
        IF NOT AVAILABLE dtb1 then
        DO:
            CREATE dtb1.
            ASSIGN
                dtb_date = tsod_date1
                dtb_time = tsod_time1
                dtb_old = STRING(MONTH(tsod_date)) + "-" +  STRING(DAY(tsod_date)) + " " + tsod_time
                dtb_qty = tsod_qty
                dtb_car = INT(tsod_qty / tsod_pkg + 0.9999)
                dtb_memo = tsod_memo
		dtb_black = ""
                dtb_pcs = 1.
            IF tsod_jz = "SP" THEN ASSIGN dtb_sp = dtb_sp + tsod_qty.
	    IF tsod_jz = "PAC84XXX" THEN ASSIGN dtb_a1 = tsod_qty.
            IF tsod_jz = "PAC86XXX" THEN ASSIGN dtb_a2 = tsod_qty.
            IF tsod_jz = "PCIT0XXX" THEN ASSIGN dtb_a3 = tsod_qty.
            IF tsod_jz = "PCITGXXX" THEN ASSIGN dtb_a4 = tsod_qty.
            /*IF tsod_jz = "PFIT0XXX" THEN ASSIGN dtb_a5 = tsod_qty.*/
            IF tsod_jz = "ECIT0XXM" THEN ASSIGN dtb_a6 = tsod_qty.
            IF tsod_jz = "ECIT0XXC" THEN ASSIGN dtb_a7 = tsod_qty.
            /*IF tsod_jz = "EFIT0XXM" THEN ASSIGN dtb_a8 = tsod_qty.
            IF tsod_jz = "EFIT0XXC" THEN ASSIGN dtb_a9 = tsod_qty.*/
            IF tsod_jz = "ECITGXXM" THEN ASSIGN dtb_a10 = tsod_qty.
            IF tsod_jz = "ECITGXXC" THEN ASSIGN dtb_a11 = tsod_qty.
            IF tsod_jz = "CODY0RRX" THEN ASSIGN dtb_a12 = tsod_qty.
            IF tsod_jz = "CODY0RLX" THEN ASSIGN dtb_a13 = tsod_qty.
            /*IF tsod_jz = "CFIT0RRX" THEN ASSIGN dtb_a14 = tsod_qty.
            IF tsod_jz = "CFIT0RLX" THEN ASSIGN dtb_a15 = tsod_qty.*/
            IF tsod_jz = "SAC8MFRM" THEN ASSIGN dtb_a16 = tsod_qty.
            IF tsod_jz = "SAC8MFLM" THEN ASSIGN dtb_a17 = tsod_qty.
            IF tsod_jz = "SAC8MFRA" THEN ASSIGN dtb_a18 = tsod_qty.
            IF tsod_jz = "SAC8MFLA" THEN ASSIGN dtb_a19 = tsod_qty.
            IF tsod_jz = "SAC8MRRX" THEN ASSIGN dtb_a20 = tsod_qty.
            IF tsod_jz = "SAC8MRLX" THEN ASSIGN dtb_a21 = tsod_qty.
            IF tsod_jz = "SAC8QFRA" THEN ASSIGN dtb_a22 = tsod_qty.
            IF tsod_jz = "SAC8QFLA" THEN ASSIGN dtb_a23 = tsod_qty.
            IF tsod_jz = "SAC8QRRX" THEN ASSIGN dtb_a24 = tsod_qty.
            IF tsod_jz = "SAC8QRLX" THEN ASSIGN dtb_a25 = tsod_qty.
            IF tsod_jz = "SAC8ZFRA" THEN ASSIGN dtb_a26 = tsod_qty.
            IF tsod_jz = "SAC8ZFLA" THEN ASSIGN dtb_a27 = tsod_qty.
            IF tsod_jz = "SAC8ZRRX" THEN ASSIGN dtb_a28 = tsod_qty.
            IF tsod_jz = "SAC8ZRLX" THEN ASSIGN dtb_a29 = tsod_qty.
            IF tsod_jz = "SCIT0FRM" THEN ASSIGN dtb_a30 = tsod_qty.
            IF tsod_jz = "SCIT0FLM" THEN ASSIGN dtb_a31 = tsod_qty.
            IF tsod_jz = "SCIT0FRC" THEN ASSIGN dtb_a32 = tsod_qty.
            IF tsod_jz = "SCIT0FLC" THEN ASSIGN dtb_a33 = tsod_qty.
            IF tsod_jz = "SCIT0RXX" THEN ASSIGN dtb_a34 = tsod_qty.
            IF tsod_jz = "SCITGFRM" THEN ASSIGN dtb_a35 = tsod_qty.
            IF tsod_jz = "SCITGFLM" THEN ASSIGN dtb_a36 = tsod_qty.
            IF tsod_jz = "SCITGFRC" THEN ASSIGN dtb_a37 = tsod_qty.
            IF tsod_jz = "SCITGFLC" THEN ASSIGN dtb_a38 = tsod_qty.
            IF tsod_jz = "SCITGRXX" THEN ASSIGN dtb_a39 = tsod_qty.
            IF tsod_jz = "SODY0FRX" THEN ASSIGN dtb_a40 = tsod_qty.
            IF tsod_jz = "SODY0FLX" THEN ASSIGN dtb_a41 = tsod_qty.
            IF tsod_jz = "SODY0RRX" THEN ASSIGN dtb_a42 = tsod_qty.
            IF tsod_jz = "SODY0RLX" THEN ASSIGN dtb_a43 = tsod_qty.
           
	   end.

           IF NOT AVAILABLE dtb2 then
	   do:
	    CREATE dtb2.
            /*IF tsod_jz = "SFIT0FRM" THEN ASSIGN dtb_a44 = tsod_qty.
            IF tsod_jz = "SFIT0FLM" THEN ASSIGN dtb_a45 = tsod_qty.
            IF tsod_jz = "SFIT0FRC" THEN ASSIGN dtb_a46 = tsod_qty.
            IF tsod_jz = "SFIT0FLC" THEN ASSIGN dtb_a47 = tsod_qty.
            IF tsod_jz = "SFIT0RXX" THEN ASSIGN dtb_a48 = tsod_qty.*/
            IF tsod_jz = "BAC8QXXX" THEN ASSIGN dtb_a49 = tsod_qty.
            IF tsod_jz = "BAC8MXXX" THEN ASSIGN dtb_a50 = tsod_qty.
            IF tsod_jz = "BAC8ZXXX" THEN ASSIGN dtb_a51 = tsod_qty.
            IF tsod_jz = "BODY0XXX" THEN ASSIGN dtb_a52 = tsod_qty.
            IF tsod_jz = "ZXXX0XXX" THEN ASSIGN dtb_a53 = tsod_qty.
            IF tsod_jz = "EFITQ021" THEN ASSIGN dtb_a54 = tsod_qty.
            IF tsod_jz = "EFITQ120" THEN ASSIGN dtb_a55 = tsod_qty.
            IF tsod_jz = "EFITQ220" THEN ASSIGN dtb_a56 = tsod_qty.
            IF tsod_jz = "EFITR021" THEN ASSIGN dtb_a57 = tsod_qty.
            IF tsod_jz = "EFITR120" THEN ASSIGN dtb_a58 = tsod_qty.
            IF tsod_jz = "EFITR220" THEN ASSIGN dtb_a59 = tsod_qty.
            IF tsod_jz = "EFITR320" THEN ASSIGN dtb_a60 = tsod_qty.
            IF tsod_jz = "PFITE620" THEN ASSIGN dtb_a61 = tsod_qty.
            IF tsod_jz = "PFITE630" THEN ASSIGN dtb_a62 = tsod_qty.
            IF tsod_jz = "PFITE720" THEN ASSIGN dtb_a63 = tsod_qty.
            IF tsod_jz = "PFITE730" THEN ASSIGN dtb_a64 = tsod_qty.
            IF tsod_jz = "PFITP620" THEN ASSIGN dtb_a65 = tsod_qty.
            IF tsod_jz = "PFITP630" THEN ASSIGN dtb_a66 = tsod_qty.
            IF tsod_jz = "PFITP720" THEN ASSIGN dtb_a67 = tsod_qty.
            IF tsod_jz = "PFITP730" THEN ASSIGN dtb_a68 = tsod_qty.
            IF tsod_jz = "CFIT0FRZ" THEN ASSIGN dtb_a69 = tsod_qty.
            IF tsod_jz = "CFIT0FLZ" THEN ASSIGN dtb_a70 = tsod_qty.
	    IF tsod_jz = "P2AP0XXX" THEN ASSIGN dtb_a71 = tsod_qty.
	    IF tsod_jz = "E2APEXXM" THEN ASSIGN dtb_a72 = tsod_qty.
	    IF tsod_jz = "E2APGXXM" THEN ASSIGN dtb_a73 = tsod_qty.
	    IF tsod_jz = "E2APEXXA" THEN ASSIGN dtb_a74 = tsod_qty.
            IF tsod_jz = "E2APGXXA" THEN ASSIGN dtb_a75 = tsod_qty.
	    IF tsod_jz = "S2APEFRM" THEN ASSIGN dtb_a76 = tsod_qty.
	    IF tsod_jz = "S2APEFLM" THEN ASSIGN dtb_a77 = tsod_qty.
	    IF tsod_jz = "S2APEFRA" THEN ASSIGN dtb_a78 = tsod_qty.
	    IF tsod_jz = "S2APEFLA" THEN ASSIGN dtb_a79 = tsod_qty.
	    IF tsod_jz = "S2APGFRM" THEN ASSIGN dtb_a80 = tsod_qty.
	    IF tsod_jz = "S2APGFLM" THEN ASSIGN dtb_a81 = tsod_qty.
	    IF tsod_jz = "S2APGFRA" THEN ASSIGN dtb_a82 = tsod_qty.
	    IF tsod_jz = "S2APGFLA" THEN ASSIGN dtb_a83 = tsod_qty.
	    IF tsod_jz = "S2APGFRX" THEN ASSIGN dtb_a84 = tsod_qty.
	    IF tsod_jz = "S2APGFLX" THEN ASSIGN dtb_a85 = tsod_qty.
	    IF tsod_jz = "S2AP0RXX" THEN ASSIGN dtb_a86 = tsod_qty.
	    IF tsod_jz = "S2APGRXX" THEN ASSIGN dtb_a87 = tsod_qty.
	    IF tsod_jz = "Z2AP0XXX" THEN ASSIGN dtb_a88 = tsod_qty.
	END.
    ELSE DO:
            dtb_qty = dtb_qty + tsod_qty.
            dtb_car = dtb_car + INT(tsod_qty / tsod_pkg + 0.9999).
            dtb_pcs = dtb_pcs + 1.
            IF tsod_jz = "SP" THEN ASSIGN dtb_sp = dtb_sp + tsod_qty.
	    IF tsod_jz = "PAC84XXX" THEN ASSIGN dtb_a1 = tsod_qty.
            IF tsod_jz = "PAC86XXX" THEN ASSIGN dtb_a2 = tsod_qty.
            IF tsod_jz = "PCIT0XXX" THEN ASSIGN dtb_a3 = tsod_qty.
            IF tsod_jz = "PCITGXXX" THEN ASSIGN dtb1.dtb_a4 = tsod_qty.

            /*IF tsod_jz = "PFIT0XXX" THEN ASSIGN dtb_a5 = tsod_qty.*/
            IF tsod_jz = "ECIT0XXM" THEN ASSIGN dtb1.dtb_a6 = tsod_qty.
            IF tsod_jz = "ECIT0XXC" THEN ASSIGN dtb1.dtb_a7 = tsod_qty.
            /*IF tsod_jz = "EFIT0XXM" THEN ASSIGN dtb_a8 = tsod_qty.
            IF tsod_jz = "EFIT0XXC" THEN ASSIGN dtb_a9 = tsod_qty.*/
            IF tsod_jz = "ECITGXXM" THEN ASSIGN dtb1.dtb_a10 = tsod_qty.
            IF tsod_jz = "ECITGXXC" THEN ASSIGN dtb1.dtb_a11 = tsod_qty.
            IF tsod_jz = "CODY0RRX" THEN ASSIGN dtb1.dtb_a12 = tsod_qty.
            IF tsod_jz = "CODY0RLX" THEN ASSIGN dtb1.dtb_a13 = tsod_qty.
            /*IF tsod_jz = "CFIT0RRX" THEN ASSIGN dtb_a14 = tsod_qty.
            IF tsod_jz = "CFIT0RLX" THEN ASSIGN dtb_a15 = tsod_qty.*/
            IF tsod_jz = "SAC8MFRM" THEN ASSIGN dtb1.dtb_a16 = tsod_qty.
            IF tsod_jz = "SAC8MFLM" THEN ASSIGN dtb1.dtb_a17 = tsod_qty.
            IF tsod_jz = "SAC8MFRA" THEN ASSIGN dtb1.dtb_a18 = tsod_qty.
            IF tsod_jz = "SAC8MFLA" THEN ASSIGN dtb1.dtb_a19 = tsod_qty.
            IF tsod_jz = "SAC8MRRX" THEN ASSIGN dtb1.dtb_a20 = tsod_qty.
            IF tsod_jz = "SAC8MRLX" THEN ASSIGN dtb1.dtb_a21 = tsod_qty.
            IF tsod_jz = "SAC8QFRA" THEN ASSIGN dtb1.dtb_a22 = tsod_qty.
            IF tsod_jz = "SAC8QFLA" THEN ASSIGN dtb1.dtb_a23 = tsod_qty.
            IF tsod_jz = "SAC8QRRX" THEN ASSIGN dtb1.dtb_a24 = tsod_qty.
            IF tsod_jz = "SAC8QRLX" THEN ASSIGN dtb1.dtb_a25 = tsod_qty.
            IF tsod_jz = "SAC8ZFRA" THEN ASSIGN dtb1.dtb_a26 = tsod_qty.
            IF tsod_jz = "SAC8ZFLA" THEN ASSIGN dtb1.dtb_a27 = tsod_qty.
            IF tsod_jz = "SAC8ZRRX" THEN ASSIGN dtb1.dtb_a28 = tsod_qty.
            IF tsod_jz = "SAC8ZRLX" THEN ASSIGN dtb1.dtb_a29 = tsod_qty.
            IF tsod_jz = "SCIT0FRM" THEN ASSIGN dtb1.dtb_a30 = tsod_qty.
            IF tsod_jz = "SCIT0FLM" THEN ASSIGN dtb1.dtb_a31 = tsod_qty.
            IF tsod_jz = "SCIT0FRC" THEN ASSIGN dtb1.dtb_a32 = tsod_qty.
            IF tsod_jz = "SCIT0FLC" THEN ASSIGN dtb1.dtb_a33 = tsod_qty.
            IF tsod_jz = "SCIT0RXX" THEN ASSIGN dtb1.dtb_a34 = tsod_qty.
            IF tsod_jz = "SCITGFRM" THEN ASSIGN dtb1.dtb_a35 = tsod_qty.
            IF tsod_jz = "SCITGFLM" THEN ASSIGN dtb1.dtb_a36 = tsod_qty.
            IF tsod_jz = "SCITGFRC" THEN ASSIGN dtb1.dtb_a37 = tsod_qty.
            IF tsod_jz = "SCITGFLC" THEN ASSIGN dtb1.dtb_a38 = tsod_qty.
            IF tsod_jz = "SCITGRXX" THEN ASSIGN dtb1.dtb_a39 = tsod_qty.
            IF tsod_jz = "SODY0FRX" THEN ASSIGN dtb1.dtb_a40 = tsod_qty.
            IF tsod_jz = "SODY0FLX" THEN ASSIGN dtb1.dtb_a41 = tsod_qty.
            IF tsod_jz = "SODY0RRX" THEN ASSIGN dtb1.dtb_a42 = tsod_qty.
            IF tsod_jz = "SODY0RLX" THEN ASSIGN dtb1.dtb_a43 = tsod_qty.
	    
	 
            /*IF tsod_jz = "SFIT0FRM" THEN ASSIGN dtb_a44 = tsod_qty.
            IF tsod_jz = "SFIT0FLM" THEN ASSIGN dtb_a45 = tsod_qty.
            IF tsod_jz = "SFIT0FRC" THEN ASSIGN dtb_a46 = tsod_qty.
            IF tsod_jz = "SFIT0FLC" THEN ASSIGN dtb_a47 = tsod_qty.
            IF tsod_jz = "SFIT0RXX" THEN ASSIGN dtb_a48 = tsod_qty.*/
            IF tsod_jz = "BAC8QXXX" THEN ASSIGN dtb2.dtb_a49 = tsod_qty.
            IF tsod_jz = "BAC8MXXX" THEN ASSIGN dtb2.dtb_a50 = tsod_qty.
            IF tsod_jz = "BAC8ZXXX" THEN ASSIGN dtb2.dtb_a51 = tsod_qty.
            IF tsod_jz = "BODY0XXX" THEN ASSIGN dtb2.dtb_a52 = tsod_qty.
            IF tsod_jz = "ZXXX0XXX" THEN ASSIGN dtb2.dtb_a53 = tsod_qty.
            IF tsod_jz = "EFITQ021" THEN ASSIGN dtb2.dtb_a54 = tsod_qty.
            IF tsod_jz = "EFITQ120" THEN ASSIGN dtb2.dtb_a55 = tsod_qty.
            IF tsod_jz = "EFITQ220" THEN ASSIGN dtb2.dtb_a56 = tsod_qty.
            IF tsod_jz = "EFITR021" THEN ASSIGN dtb2.dtb_a57 = tsod_qty.
            IF tsod_jz = "EFITR120" THEN ASSIGN dtb2.dtb_a58 = tsod_qty.
            IF tsod_jz = "EFITR220" THEN ASSIGN dtb2.dtb_a59 = tsod_qty.
            IF tsod_jz = "EFITR320" THEN ASSIGN dtb2.dtb_a60 = tsod_qty.
            IF tsod_jz = "PFITE620" THEN ASSIGN dtb2.dtb_a61 = tsod_qty.
            IF tsod_jz = "PFITE630" THEN ASSIGN dtb2.dtb_a62 = tsod_qty.
            IF tsod_jz = "PFITE720" THEN ASSIGN dtb2.dtb_a63 = tsod_qty.
            IF tsod_jz = "PFITE730" THEN ASSIGN dtb2.dtb_a64 = tsod_qty.
            IF tsod_jz = "PFITP620" THEN ASSIGN dtb2.dtb_a65 = tsod_qty.
            IF tsod_jz = "PFITP630" THEN ASSIGN dtb2.dtb_a66 = tsod_qty.
            IF tsod_jz = "PFITP720" THEN ASSIGN dtb2.dtb_a67 = tsod_qty.
            IF tsod_jz = "PFITP730" THEN ASSIGN dtb2.dtb_a68 = tsod_qty.
            IF tsod_jz = "CFIT0FRZ" THEN ASSIGN dtb2.dtb_a69 = tsod_qty.
            IF tsod_jz = "CFIT0FLZ" THEN ASSIGN dtb2.dtb_a70 = tsod_qty.
	    IF tsod_jz = "P2AP0XXX" THEN ASSIGN dtb2.dtb_a71 = tsod_qty.
	    IF tsod_jz = "E2APEXXM" THEN ASSIGN dtb2.dtb_a72 = tsod_qty.
	    IF tsod_jz = "E2APGXXM" THEN ASSIGN dtb2.dtb_a73 = tsod_qty.
	    IF tsod_jz = "E2APEXXA" THEN ASSIGN dtb2.dtb_a74 = tsod_qty.
            IF tsod_jz = "E2APGXXA" THEN ASSIGN dtb2.dtb_a75 = tsod_qty.
	    IF tsod_jz = "S2APEFRM" THEN ASSIGN dtb2.dtb_a76 = tsod_qty.
	    IF tsod_jz = "S2APEFLM" THEN ASSIGN dtb2.dtb_a77 = tsod_qty.
	    IF tsod_jz = "S2APEFRA" THEN ASSIGN dtb2.dtb_a78 = tsod_qty.
	    IF tsod_jz = "S2APEFLA" THEN ASSIGN dtb2.dtb_a79 = tsod_qty.
	    IF tsod_jz = "S2APGFRM" THEN ASSIGN dtb2.dtb_a80 = tsod_qty.
	    IF tsod_jz = "S2APGFLM" THEN ASSIGN dtb2.dtb_a81 = tsod_qty.
	    IF tsod_jz = "S2APGFRA" THEN ASSIGN dtb2.dtb_a82 = tsod_qty.
	    IF tsod_jz = "S2APGFLA" THEN ASSIGN dtb2.dtb_a83 = tsod_qty.
	    IF tsod_jz = "S2APGFRX" THEN ASSIGN dtb2.dtb_a84 = tsod_qty.
	    IF tsod_jz = "S2APGFLX" THEN ASSIGN dtb2.dtb_a85 = tsod_qty.
	    IF tsod_jz = "S2AP0RXX" THEN ASSIGN dtb2.dtb_a86 = tsod_qty.
	    IF tsod_jz = "S2APGRXX" THEN ASSIGN dtb2.dtb_a87 = tsod_qty.
	    IF tsod_jz = "Z2AP0XXX" THEN ASSIGN dtb2.dtb_a88 = tsod_qty.
    END.
END.
end. /* if buyer=4rsa */
/* else
do:
FOR EACH tsod where tsod_buyer <> "4RSA" BREAK BY tsod_date1 BY tsod_time1.
    FIND FIRST dtb WHERE  dtb_time = tsod_time1 AND dtb_date = tsod_date1 AND dtb_old = STRING(MONTH(tsod_date)) + "-" +  STRING(DAY(tsod_date)) + " " + tsod_time NO-ERROR.
    IF NOT AVAILABLE dtb THEN
        DO:
            CREATE dtb.
            ASSIGN
                dtb_date = tsod_date1
                dtb_time = tsod_time1
                dtb_old = STRING(MONTH(tsod_date)) + "-" +  STRING(DAY(tsod_date)) + " " + tsod_time
                dtb_qty = tsod_qty
                dtb_car = INT(tsod_qty / tsod_pkg + 0.9999)
                dtb_memo = tsod_memo
		dtb_black = ""
                dtb_pcs = 1.
            IF tsod_jz = "SP" THEN ASSIGN dtb_sp = dtb_sp + tsod_qty.
	    IF tsod_jz = "PAC84XXX" THEN ASSIGN dtb_a1 = tsod_qty.
            IF tsod_jz = "PAC86XXX" THEN ASSIGN dtb_a2 = tsod_qty.
            IF tsod_jz = "PCIT0XXX" THEN ASSIGN dtb_a3 = tsod_qty.
            IF tsod_jz = "PCITGXXX" THEN ASSIGN dtb_a4 = tsod_qty.
            IF tsod_jz = "PFIT0XXX" THEN ASSIGN dtb_a5 = tsod_qty.
            IF tsod_jz = "ECIT0XXM" THEN ASSIGN dtb_a6 = tsod_qty.
            IF tsod_jz = "ECIT0XXC" THEN ASSIGN dtb_a7 = tsod_qty.
            IF tsod_jz = "EFIT0XXM" THEN ASSIGN dtb_a8 = tsod_qty.
            IF tsod_jz = "EFIT0XXC" THEN ASSIGN dtb_a9 = tsod_qty.
            IF tsod_jz = "ECITGXXM" THEN ASSIGN dtb_a10 = tsod_qty.
            IF tsod_jz = "ECITGXXC" THEN ASSIGN dtb_a11 = tsod_qty.
            IF tsod_jz = "CODY0RRX" THEN ASSIGN dtb_a12 = tsod_qty.
            IF tsod_jz = "CODY0RLX" THEN ASSIGN dtb_a13 = tsod_qty.
            IF tsod_jz = "CFIT0RRX" THEN ASSIGN dtb_a14 = tsod_qty.
            IF tsod_jz = "CFIT0RLX" THEN ASSIGN dtb_a15 = tsod_qty.
            IF tsod_jz = "SAC8MFRM" THEN ASSIGN dtb_a16 = tsod_qty.
            IF tsod_jz = "SAC8MFLM" THEN ASSIGN dtb_a17 = tsod_qty.
            IF tsod_jz = "SAC8MFRA" THEN ASSIGN dtb_a18 = tsod_qty.
            IF tsod_jz = "SAC8MFLA" THEN ASSIGN dtb_a19 = tsod_qty.
            IF tsod_jz = "SAC8MRRX" THEN ASSIGN dtb_a20 = tsod_qty.
            IF tsod_jz = "SAC8MRLX" THEN ASSIGN dtb_a21 = tsod_qty.
            IF tsod_jz = "SAC8QFRA" THEN ASSIGN dtb_a22 = tsod_qty.
            IF tsod_jz = "SAC8QFLA" THEN ASSIGN dtb_a23 = tsod_qty.
            IF tsod_jz = "SAC8QRRX" THEN ASSIGN dtb_a24 = tsod_qty.
            IF tsod_jz = "SAC8QRLX" THEN ASSIGN dtb_a25 = tsod_qty.
            IF tsod_jz = "SAC8ZFRA" THEN ASSIGN dtb_a26 = tsod_qty.
            IF tsod_jz = "SAC8ZFLA" THEN ASSIGN dtb_a27 = tsod_qty.
            IF tsod_jz = "SAC8ZRRX" THEN ASSIGN dtb_a28 = tsod_qty.
            IF tsod_jz = "SAC8ZRLX" THEN ASSIGN dtb_a29 = tsod_qty.
            IF tsod_jz = "SCIT0FRM" THEN ASSIGN dtb_a30 = tsod_qty.
            IF tsod_jz = "SCIT0FLM" THEN ASSIGN dtb_a31 = tsod_qty.
            IF tsod_jz = "SCIT0FRC" THEN ASSIGN dtb_a32 = tsod_qty.
            IF tsod_jz = "SCIT0FLC" THEN ASSIGN dtb_a33 = tsod_qty.
            IF tsod_jz = "SCIT0RXX" THEN ASSIGN dtb_a34 = tsod_qty.
            IF tsod_jz = "SCITGFRM" THEN ASSIGN dtb_a35 = tsod_qty.
            IF tsod_jz = "SCITGFLM" THEN ASSIGN dtb_a36 = tsod_qty.
            IF tsod_jz = "SCITGFRC" THEN ASSIGN dtb_a37 = tsod_qty.
            IF tsod_jz = "SCITGFLC" THEN ASSIGN dtb_a38 = tsod_qty.
            IF tsod_jz = "SCITGRXX" THEN ASSIGN dtb_a39 = tsod_qty.
            IF tsod_jz = "SODY0FRX" THEN ASSIGN dtb_a40 = tsod_qty.
            IF tsod_jz = "SODY0FLX" THEN ASSIGN dtb_a41 = tsod_qty.
            IF tsod_jz = "SODY0RRX" THEN ASSIGN dtb_a42 = tsod_qty.
            IF tsod_jz = "SODY0RLX" THEN ASSIGN dtb_a43 = tsod_qty.
            IF tsod_jz = "SFIT0FRM" THEN ASSIGN dtb_a44 = tsod_qty.
            IF tsod_jz = "SFIT0FLM" THEN ASSIGN dtb_a45 = tsod_qty.
            IF tsod_jz = "SFIT0FRC" THEN ASSIGN dtb_a46 = tsod_qty.
            IF tsod_jz = "SFIT0FLC" THEN ASSIGN dtb_a47 = tsod_qty.
            IF tsod_jz = "SFIT0RXX" THEN ASSIGN dtb_a48 = tsod_qty.
            IF tsod_jz = "BAC8QXXX" THEN ASSIGN dtb_a49 = tsod_qty.
            IF tsod_jz = "BAC8MXXX" THEN ASSIGN dtb_a50 = tsod_qty.
            IF tsod_jz = "BAC8ZXXX" THEN ASSIGN dtb_a51 = tsod_qty.
            IF tsod_jz = "BODY0XXX" THEN ASSIGN dtb_a52 = tsod_qty.
            IF tsod_jz = "ZXXX0XXX" THEN ASSIGN dtb_a53 = tsod_qty.
            IF tsod_jz = "EFITQ021" THEN ASSIGN dtb_a54 = tsod_qty.
            IF tsod_jz = "EFITQ120" THEN ASSIGN dtb_a55 = tsod_qty.
            IF tsod_jz = "EFITQ220" THEN ASSIGN dtb_a56 = tsod_qty.
            IF tsod_jz = "EFITR021" THEN ASSIGN dtb_a57 = tsod_qty.
            IF tsod_jz = "EFITR120" THEN ASSIGN dtb_a58 = tsod_qty.
            IF tsod_jz = "EFITR220" THEN ASSIGN dtb_a59 = tsod_qty.
            IF tsod_jz = "EFITR320" THEN ASSIGN dtb_a60 = tsod_qty.
            IF tsod_jz = "PFITE620" THEN ASSIGN dtb_a61 = tsod_qty.
            IF tsod_jz = "PFITE630" THEN ASSIGN dtb_a62 = tsod_qty.
            IF tsod_jz = "PFITE720" THEN ASSIGN dtb_a63 = tsod_qty.
            IF tsod_jz = "PFITE730" THEN ASSIGN dtb_a64 = tsod_qty.
            IF tsod_jz = "PFITP620" THEN ASSIGN dtb_a65 = tsod_qty.
            IF tsod_jz = "PFITP630" THEN ASSIGN dtb_a66 = tsod_qty.
            IF tsod_jz = "PFITP720" THEN ASSIGN dtb_a67 = tsod_qty.
            IF tsod_jz = "PFITP730" THEN ASSIGN dtb_a68 = tsod_qty.
            IF tsod_jz = "CFIT0FRZ" THEN ASSIGN dtb_a69 = tsod_qty.
            IF tsod_jz = "CFIT0FLZ" THEN ASSIGN dtb_a70 = tsod_qty.
        END.
    ELSE DO:
            dtb_qty = dtb_qty + tsod_qty.
            dtb_car = dtb_car + INT(tsod_qty / tsod_pkg + 0.9999).
            dtb_pcs = dtb_pcs + 1.
            IF tsod_jz = "SP" THEN ASSIGN dtb_sp = dtb_sp + tsod_qty.
	    IF tsod_jz = "PAC84XXX" THEN ASSIGN dtb_a1 = tsod_qty.
            IF tsod_jz = "PAC86XXX" THEN ASSIGN dtb_a2 = tsod_qty.
            IF tsod_jz = "PCIT0XXX" THEN ASSIGN dtb_a3 = tsod_qty.
            IF tsod_jz = "PCITGXXX" THEN ASSIGN dtb_a4 = tsod_qty.
            IF tsod_jz = "PFIT0XXX" THEN ASSIGN dtb_a5 = tsod_qty.
            IF tsod_jz = "ECIT0XXM" THEN ASSIGN dtb_a6 = tsod_qty.
            IF tsod_jz = "ECIT0XXC" THEN ASSIGN dtb_a7 = tsod_qty.
            IF tsod_jz = "EFIT0XXM" THEN ASSIGN dtb_a8 = tsod_qty.
            IF tsod_jz = "EFIT0XXC" THEN ASSIGN dtb_a9 = tsod_qty.
            IF tsod_jz = "ECITGXXM" THEN ASSIGN dtb_a10 = tsod_qty.
            IF tsod_jz = "ECITGXXC" THEN ASSIGN dtb_a11 = tsod_qty.
            IF tsod_jz = "CODY0RRX" THEN ASSIGN dtb_a12 = tsod_qty.
            IF tsod_jz = "CODY0RLX" THEN ASSIGN dtb_a13 = tsod_qty.
            IF tsod_jz = "CFIT0RRX" THEN ASSIGN dtb_a14 = tsod_qty.
            IF tsod_jz = "CFIT0RLX" THEN ASSIGN dtb_a15 = tsod_qty.
            IF tsod_jz = "SAC8MFRM" THEN ASSIGN dtb_a16 = tsod_qty.
            IF tsod_jz = "SAC8MFLM" THEN ASSIGN dtb_a17 = tsod_qty.
            IF tsod_jz = "SAC8MFRA" THEN ASSIGN dtb_a18 = tsod_qty.
            IF tsod_jz = "SAC8MFLA" THEN ASSIGN dtb_a19 = tsod_qty.
            IF tsod_jz = "SAC8MRRX" THEN ASSIGN dtb_a20 = tsod_qty.
            IF tsod_jz = "SAC8MRLX" THEN ASSIGN dtb_a21 = tsod_qty.
            IF tsod_jz = "SAC8QFRA" THEN ASSIGN dtb_a22 = tsod_qty.
            IF tsod_jz = "SAC8QFLA" THEN ASSIGN dtb_a23 = tsod_qty.
            IF tsod_jz = "SAC8QRRX" THEN ASSIGN dtb_a24 = tsod_qty.
            IF tsod_jz = "SAC8QRLX" THEN ASSIGN dtb_a25 = tsod_qty.
            IF tsod_jz = "SAC8ZFRA" THEN ASSIGN dtb_a26 = tsod_qty.
            IF tsod_jz = "SAC8ZFLA" THEN ASSIGN dtb_a27 = tsod_qty.
            IF tsod_jz = "SAC8ZRRX" THEN ASSIGN dtb_a28 = tsod_qty.
            IF tsod_jz = "SAC8ZRLX" THEN ASSIGN dtb_a29 = tsod_qty.
            IF tsod_jz = "SCIT0FRM" THEN ASSIGN dtb_a30 = tsod_qty.
            IF tsod_jz = "SCIT0FLM" THEN ASSIGN dtb_a31 = tsod_qty.
            IF tsod_jz = "SCIT0FRC" THEN ASSIGN dtb_a32 = tsod_qty.
            IF tsod_jz = "SCIT0FLC" THEN ASSIGN dtb_a33 = tsod_qty.
            IF tsod_jz = "SCIT0RXX" THEN ASSIGN dtb_a34 = tsod_qty.
            IF tsod_jz = "SCITGFRM" THEN ASSIGN dtb_a35 = tsod_qty.
            IF tsod_jz = "SCITGFLM" THEN ASSIGN dtb_a36 = tsod_qty.
            IF tsod_jz = "SCITGFRC" THEN ASSIGN dtb_a37 = tsod_qty.
            IF tsod_jz = "SCITGFLC" THEN ASSIGN dtb_a38 = tsod_qty.
            IF tsod_jz = "SCITGRXX" THEN ASSIGN dtb_a39 = tsod_qty.
            IF tsod_jz = "SODY0FRX" THEN ASSIGN dtb_a40 = tsod_qty.
            IF tsod_jz = "SODY0FLX" THEN ASSIGN dtb_a41 = tsod_qty.
            IF tsod_jz = "SODY0RRX" THEN ASSIGN dtb_a42 = tsod_qty.
            IF tsod_jz = "SODY0RLX" THEN ASSIGN dtb_a43 = tsod_qty.
            IF tsod_jz = "SFIT0FRM" THEN ASSIGN dtb_a44 = tsod_qty.
            IF tsod_jz = "SFIT0FLM" THEN ASSIGN dtb_a45 = tsod_qty.
            IF tsod_jz = "SFIT0FRC" THEN ASSIGN dtb_a46 = tsod_qty.
            IF tsod_jz = "SFIT0FLC" THEN ASSIGN dtb_a47 = tsod_qty.
            IF tsod_jz = "SFIT0RXX" THEN ASSIGN dtb_a48 = tsod_qty.
            IF tsod_jz = "BAC8QXXX" THEN ASSIGN dtb_a49 = tsod_qty.
            IF tsod_jz = "BAC8MXXX" THEN ASSIGN dtb_a50 = tsod_qty.
            IF tsod_jz = "BAC8ZXXX" THEN ASSIGN dtb_a51 = tsod_qty.
            IF tsod_jz = "BODY0XXX" THEN ASSIGN dtb_a52 = tsod_qty.
            IF tsod_jz = "ZXXX0XXX" THEN ASSIGN dtb_a53 = tsod_qty.
            IF tsod_jz = "EFITQ021" THEN ASSIGN dtb_a54 = tsod_qty.
            IF tsod_jz = "EFITQ120" THEN ASSIGN dtb_a55 = tsod_qty.
            IF tsod_jz = "EFITQ220" THEN ASSIGN dtb_a56 = tsod_qty.
            IF tsod_jz = "EFITR021" THEN ASSIGN dtb_a57 = tsod_qty.
            IF tsod_jz = "EFITR120" THEN ASSIGN dtb_a58 = tsod_qty.
            IF tsod_jz = "EFITR220" THEN ASSIGN dtb_a59 = tsod_qty.
            IF tsod_jz = "EFITR320" THEN ASSIGN dtb_a60 = tsod_qty.
            IF tsod_jz = "PFITE620" THEN ASSIGN dtb_a61 = tsod_qty.
            IF tsod_jz = "PFITE630" THEN ASSIGN dtb_a62 = tsod_qty.
            IF tsod_jz = "PFITE720" THEN ASSIGN dtb_a63 = tsod_qty.
            IF tsod_jz = "PFITE730" THEN ASSIGN dtb_a64 = tsod_qty.
            IF tsod_jz = "PFITP620" THEN ASSIGN dtb_a65 = tsod_qty.
            IF tsod_jz = "PFITP630" THEN ASSIGN dtb_a66 = tsod_qty.
            IF tsod_jz = "PFITP720" THEN ASSIGN dtb_a67 = tsod_qty.
            IF tsod_jz = "PFITP730" THEN ASSIGN dtb_a68 = tsod_qty.
            IF tsod_jz = "CFIT0FRZ" THEN ASSIGN dtb_a69 = tsod_qty.
            IF tsod_jz = "CFIT0FLZ" THEN ASSIGN dtb_a70 = tsod_qty.
    END.
END. 
end. */

OUTPUT TO value(file_out).

PUT  "日期" "~t"
     "时段" "~t"
     "传票日期" "~t"
     "数量" "~t"
     "台车" "~t"
     "版本" "~t"
     "传票数量" "~t"
     "空白" "~t"
     "SP" "~t"
     "PS-TB0" "~t"
     "PS-TB1" "~t"
     "PS-LK" "~t"
     "PS-2ST" "~t"
     /*"PS-ZU" "~t"*/
     "ECU-LKMT" "~t"
     "ECU-LKAT" "~t"
     /*"ECU-ZUMT" "~t"
     "ECU-ZUCVT" "~t"*/
     "ECU-2STMT" "~t"
     "ECU-2STAT" "~t"
     "OS-SFJR" "~t"
     "OS-SFJL" "~t"
     /*"OS-ZUR" "~t"
     "OS-ZUL" "~t"*/
     "SA-20MTR" "~t"
     "SA-20MTL" "~t"
     "SA-20ATR" "~t"
     "SA-20ATL" "~t"
     "SA-20R" "~t"
     "SA-20L" "~t"
     "SA-24FR" "~t"
     "SA-24FL" "~t"
     "SA-24RR" "~t"
     "SA-24RL" "~t"
     "SA-35FR" "~t"
     "SA-35FL" "~t"
     "SA-35RR" "~t"
     "SA-35RL" "~t"
     "SA-LKMTR" "~t"
     "SA-LKMTL" "~t"
     "SA-LKCVTR" "~t"
     "SA-LKCVTL" "~t"
     "SA-LKR" "~t"
     "SA-2STMTR" "~t"
     "SA-2STMTL" "~t"
     "SA-2STCVTR" "~t"
     "SA-2STCVTL" "~t"
     "SA-2STCVT" "~t"
     "SA-GZFR" "~t"
     "SA-GZFL" "~t"
     "SA-GZRR" "~t"
     "SA-GZRL" "~t"
     /*"SA-ZUMTR" "~t"
     "SA-ZUMTL" "~t"
     "SA-ZUCVTR" "~t"
     "SA-ZUCVTL" "~t"
     "SA-ZU" "~t"*/
     "B-R40" "~t"
     "B-R60" "~t"
     "B-R70" "~t"
     "B-REF" "~t"
     "Z-SAA" "~t"
     "ECU-Q021" "~t"
     "ECU-Q120" "~t"
     "ECU-Q220" "~t"
     "ECU-R021" "~t"
     "ECU-R120" "~t"
     "ECU-R220" "~t"
     "ECU-R320" "~t"
     "PS-E620" "~t"
     "PS-E630" "~t"
     "PS-E720" "~t"
     "PS-E730" "~t"
     "PS-P620" "~t"
     "PS-P630" "~t"
     "PS-P720" "~t"
     "PS-P730" "~t"
     "OS-ZBZUR" "~t"
     "OS-ZBZUL" "~t"
     "PS-2AP" "~t"
     "ECU-2AP1.3MT" "~t"
     "ECU-2AP1.3AT" "~t"
     "ECU-2AP1.5MT" "~t"
     "ECU-2AP1.5AT" "~t"
     "SA-2AP1.3MT前右" "~t"
     "SA-2AP1.3MT前左" "~t"
     "SA-2AP1.3AT前右" "~t"
     "SA-2AP1.3AT前左" "~t"
     "SA-2AP1.5MT前右" "~t"
     "SA-2AP1.5MT前左" "~t"
     "SA-2AP1.5AT前右" "~t"
     "SA-2AP1.5AT前左" "~t"
     "SA-2AP1.5前右" "~t"
     "SA-2AP1.5前左" "~t"
     "SA-2APC010/020后" "~t"
     "SA-2AP1.5后" "~t"
     "Z-ZDXJ".

     PUT SKIP.

FOR EACH dtb1 , each dtb2:
   PUT   dtb1.dtb_date "~t"
         dtb1.dtb_time "~t"
         dtb1.dtb_old "~t"
         dtb1.dtb_qty "~t"
         dtb1.dtb_car "~t"
         dtb1.dtb_memo "~t"
         dtb1.dtb_pcs "~t"
	 dtb1.dtb_black "~t"
         dtb1.dtb_sp "~t"
	 dtb1.dtb_a1 "~t"
         dtb1.dtb_a2 "~t"
         dtb1.dtb_a3 "~t"
         dtb1.dtb_a4 "~t"
         /*dtb_a5 "~t"*/
         dtb1.dtb_a6 "~t"
         dtb1.dtb_a7 "~t"
         /*dtb_a8 "~t"
         dtb_a9 "~t"*/
         dtb1.dtb_a10 "~t"
         dtb1.dtb_a11 "~t"
         dtb1.dtb_a12 "~t"
         dtb1.dtb_a13 "~t"
         /*dtb_a14 "~t"
         dtb_a15 "~t"*/
         dtb1.dtb_a16 "~t"
         dtb1.dtb_a17 "~t"
         dtb1.dtb_a18 "~t"
         dtb1.dtb_a19 "~t"
         dtb1.dtb_a20 "~t"
         dtb1.dtb_a21 "~t"
         dtb1.dtb_a22 "~t"
         dtb1.dtb_a23 "~t"
         dtb1.dtb_a24 "~t"
         dtb1.dtb_a25 "~t"
         dtb1.dtb_a26 "~t"
         dtb1.dtb_a27 "~t"
         dtb1.dtb_a28 "~t"
         dtb1.dtb_a29 "~t"
         dtb1.dtb_a30 "~t"
         dtb1.dtb_a31 "~t"
         dtb1.dtb_a32 "~t"
         dtb1.dtb_a33 "~t"
         dtb1.dtb_a34 "~t"
         dtb1.dtb_a35 "~t"
         dtb1.dtb_a36 "~t"
         dtb1.dtb_a37 "~t"
         dtb1.dtb_a38 "~t"
         dtb1.dtb_a39 "~t"
         dtb1.dtb_a40 "~t"
         dtb1.dtb_a41 "~t"
         dtb1.dtb_a42 "~t"
         dtb1.dtb_a43 "~t"
 /*dtb_a44 "~t"
         dtb_a45 "~t"
         dtb_a46 "~t"
         dtb_a47 "~t"
         dtb_a48 "~t"*/
         dtb2.dtb_a49 "~t"
         dtb2.dtb_a50 "~t"
         dtb2.dtb_a51 "~t"
         dtb2.dtb_a52 "~t"
         dtb2.dtb_a53 "~t"
         dtb2.dtb_a54 "~t"
         dtb2.dtb_a55 "~t"
         dtb2.dtb_a56 "~t"
         dtb2.dtb_a57 "~t"
         dtb2.dtb_a58 "~t"
         dtb2.dtb_a59 "~t"
         dtb2.dtb_a60 "~t"
         dtb2.dtb_a61 "~t"
         dtb2.dtb_a62 "~t"
         dtb2.dtb_a63 "~t"
         dtb2.dtb_a64 "~t"
         dtb2.dtb_a65 "~t"
         dtb2.dtb_a66 "~t"
         dtb2.dtb_a67 "~t"
         dtb2.dtb_a68 "~t"
         dtb2.dtb_a69 "~t"
         dtb2.dtb_a70 "~t"
         dtb2.dtb_a71 "~t"
	 dtb2.dtb_a72 "~t"
	 dtb2.dtb_a73 "~t"
	 dtb2.dtb_a74 "~t"
	 dtb2.dtb_a75 "~t"
	 dtb2.dtb_a76 "~t"
         dtb2.dtb_a77 "~t"
	 dtb2.dtb_a78 "~t"
	 dtb2.dtb_a79 "~t"
	 dtb2.dtb_a80 "~t"
	 dtb2.dtb_a81 "~t"
	 dtb2.dtb_a82 "~t"
	 dtb2.dtb_a83 "~t"
	 dtb2.dtb_a84 "~t"
	 dtb2.dtb_a85 "~t"
	 dtb2.dtb_a86 "~t"
	 dtb2.dtb_a87 "~t"
         dtb2.dtb_a88

         SKIP.
END.

output close.
