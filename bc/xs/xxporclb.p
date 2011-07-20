/* Revision: eb2sp4      BY: Ching Ye     DATE: 11/26/07  ECO: *SS - 20071126.1* */

{mfdtitle.i "2+ "}
   
    /*
&SCOPED-DEFINE PP_FRAME_NAME A
      */
def var site like si_site init "gsa01".
def var site1 like   si_site init "gsa01".
def var vend like  po_vend  .
def var vend1 like    po_vend  .
def var shipno like xx_ship_no  .
def var shipno1 like xx_ship_no  .
def var shipline like xx_ship_line init 0.
def var shipline1 like xx_ship_line init 9999.

def var rcvddate like tr_effdate init today.
def var rcvddate1 like tr_effdate init today.

def var tmpdev like prd_dev.
def var tmpstr as char.
define variable usection as char format "x(16)".
def var tmpmonth as char.
def var j as integer.
def var i as integer.
def var datestr as char.
def var glbasecurr like gl_base_curr.
DEF VAR v_flag AS LOGICAL.
def buffer poms for po_mstr.
def var tstr as char.
def var tstr1 as char.
Define variable LabelsPath as character format "x(100)" init "  /app/bc/labels/"  .
define variable wsection as char format "x(16)".
Define variable ts9160 AS CHARACTER FORMAT "x(100)".
Define variable av9160 AS CHARACTER FORMAT "x(100)".
def var V9160 as char.
DEF TEMP-TABLE pott 
    FIELD pott_shipno LIKE xx_ship_no
    FIELD pott_shipnbr LIKE xx_ship_no
    FIELD pott_site LIKE xx_ship_site
    FIELD pott_vend LIKE xx_inv_vend
    FIELD pott_case like xx_ship_case
    FIELD pott_part_vend LIKE xx_ship_part
    FIELD pott_pkg LIKE xx_ship_pkg
    FIELD pott_qty_unit like xx_ship_qty_unit
    FIELD pott_qty like xx_ship_qty
    FIELD pott_status like xx_ship_status
    FIELD pott_price like xx_ship_price
    FIELD pott_value like xx_ship_value
    FIELD pott_curr like xx_ship_curr
    FIELD pott_duedate like tr_effdate
    FIELD pott_etadate like tr_effdate
    FIELD pott_line like xx_ship_line
    FIELD pott_part_zh like xx_ship_part
    field pott_loc like pt_loc
    field pott_lot like tr_serial
    field pott_ponbr like po_nbr
    FIELD pott_poline like xx_ship_line
    field pott_fix_rate as char
    field pott_qty_open like pod_qty_ord
    field pott_flag as char
    field pott_CIMQTY like pod_qty_ord
    field pott_add_CIMQTY like pod_qty_ord
    field pott_addpo like pod_nbr
    field pott_order_type as char
    field pott_rate like xx_ship_rate
    field pott_cost like xx_ship_price
    .
 

DEF TEMP-TABLE  tt1
    field   tt1_nbr like po_nbr
    field   tt1_curr like po_curr
    field   tt1_line like pod_line
    field   tt1_vend like po_vend
    field   tt1_fix_rate  as char
    field   tt1_openqty like pod_qty_ord
    field   tt1_part like pod_part
    field   tt1_site like pod_site
    field   tt1_lot like tr_serial
    field   tt1_loc like pt_loc
    field   tt1_flag as char
    field   tt1_shipno like xx_ship_no
     
.

DEF TEMP-TABLE  tt2
    field   tt2_nbr like po_nbr.

DEF TEMP-TABLE tte 
    FIELD tte_type1 AS CHAR
    FIELD tte_type AS CHAR
    FIELD tte_vend LIKE po_vend
    FIELD tte_part LIKE pt_part
    FIELD tte_desc AS CHAR FORMAT "x(120)"
    .

FUNCTION por039160l RETURNS CHARACTER  (INPUT vv1100 AS CHARACTER , INPUT vv1104 AS CHARACTER,INPUT vv1200 AS CHARACTER,INPUT vv1300 AS CHARACTER,INPUT vv1500 AS CHARACTER,INPUT vv9015 AS CHARACTER).


 DEF VARIABLE WOSOJOB LIKE wo_so_job.
     WOSOJOB = "".
        /* Define Labels Path  Start */
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
	
        /* Define Labels Path  END */
      INPUT FROM VALUE(LabelsPath + "por03").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9160.
       find first pt_mstr where pt_part = vV1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = pt_um.
       IF INDEX(ts9160,"$U") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$U") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$U") + length("$U"), LENGTH(ts9160) - ( index(ts9160 ,"$U" ) + length("$U") - 1 ) ).
       END.
       find first pt_mstr where pt_part = vV1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc1).
       IF INDEX(ts9160,"$F") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$F") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$F") + length("$F"), LENGTH(ts9160) - ( index(ts9160 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first pt_mstr where pt_part = vV1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc2).
       IF INDEX(ts9160,"$E") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$E") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$E") + length("$E"), LENGTH(ts9160) - ( index(ts9160 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9160 = if length( trim ( vV1500 ) ) >= 8 then substring ( trim ( vV1500 ),7,2) else "00".
       IF INDEX(ts9160,"&M") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&M") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&M") + length("&M"), LENGTH(ts9160) - ( index(ts9160 ,"&M" ) + length("&M") - 1 ) ).
       END.
        av9160 = vV1100.
       IF INDEX(ts9160,"$O") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$O") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$O") + length("$O"), LENGTH(ts9160) - ( index(ts9160 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9160 = vV1300.
       IF INDEX(ts9160,"$P") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$P") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$P") + length("$P"), LENGTH(ts9160) - ( index(ts9160 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9160 = string(today).
       IF INDEX(ts9160,"$D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$D") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$D") + length("$D"), LENGTH(ts9160) - ( index(ts9160 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_part = vV1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9160,"&D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&D") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&D") + length("&D"), LENGTH(ts9160) - ( index(ts9160 ,"&D" ) + length("&D") - 1 ) ).
       END.
        av9160 = trim(vV1300) + "@" + trim(vV1500).
       IF INDEX(ts9160,"&B") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&B") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&B") + length("&B"), LENGTH(ts9160) - ( index(ts9160 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9160 = vV9015.
       IF INDEX(ts9160,"$Q") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$Q") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$Q") + length("$Q"), LENGTH(ts9160) - ( index(ts9160 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       find first pt_mstr where pt_part = vV1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = if pt_drwg_loc <> "" then "ENV DIR:" + trim (pt_drwg_loc) else "".
       IF INDEX(ts9160,"&E") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&E") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&E") + length("&E"), LENGTH(ts9160) - ( index(ts9160 ,"&E" ) + length("&E") - 1 ) ).
       END.
        av9160 = vV1500.
       IF INDEX(ts9160,"$L") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$L") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$L") + length("$L"), LENGTH(ts9160) - ( index(ts9160 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9160 = vV1200.
       IF INDEX(ts9160,"$G") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$G") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$G") + length("$G"), LENGTH(ts9160) - ( index(ts9160 ,"$G" ) + length("$G") - 1 ) ).
       END.
        av9160 = if substring( vV1104 ,1,1) = "C" then "受检章" else "检验OK".
       IF INDEX(ts9160,"&R") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&R") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&R") + length("&R"), LENGTH(ts9160) - ( index(ts9160 ,"&R" ) + length("&R") - 1 ) ).
       END.
       put unformatted ts9160 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l"). 
     return  WOSOJOB.
     END FUNCTION.
FORM
    /*
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    */

    SKIP(1)
    site  COLON 20    LABEL "地点" site1 colon 50 label   {t001.i}      
    vend  COLON 20    LABEL "供应商" vend1 colon 50 label   {t001.i}  
    shipno  COLON 20    LABEL "发票号" shipno1 colon 50 label   {t001.i}  
    shipline  COLON 20    LABEL "项次" shipline1 colon 50 label   {t001.i} 
    rcvddate colon 20 label "收货日期" rcvddate1 colon 50 label   {t001.i} 
/*    rcvddate COLON 20  LABEL "收货日期" */
    /* tmpdev COLON 20    LABEL "打印机"  */
    SKIP(1)
    with frame a side-labels width 80 ATTR-SPACE
    /* /* gui */ NO-BOX THREE-D /* gui */  */ .

/*
 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = ("导入客户订单的相关资料").
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

 /*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
 */

/* Main Repeat */
mainloop:
repeat :
    hide all no-pause .
    view frame dtitle .
  view frame a .

  IF site1 = hi_char THEN site1 = "".
  IF vend1 = hi_char THEN vend1 = "".
  IF shipno1 = hi_char THEN shipno1 = "".
  if rcvddate1 = hi_date then rcvddate1 = ?.
  if rcvddate  = low_date then rcvddate = ?.

  update 
      site
      site1
      vend
      vend1
      shipno
      shipno1
      shipline
      shipline1
      rcvddate
      rcvddate1
      /* rcvddate */
      /* tmpdev */
      
      with frame a.
  
  IF site1 = "" THEN site1 = hi_char.
  IF vend1 = "" THEN vend1 = hi_char.
  IF shipno1 = "" THEN shipno1 = hi_char.
   if rcvddate = ? then rcvddate = low_date.
   if rcvddate1 = ? then rcvddate1 = hi_date.
  /* 文件的命名规则:SOyyyymmdd99 */
  /* aa i = 101.
  REPEAT :
      fn_i = "SO" + STRING(YEAR(TODAY))            + 
             SUBSTRING(STRING(100 + MONTH(TODAY)),2,2) + 
             SUBSTRING(STRING(100 + DAY(TODAY)),2,2)   + 
             SUBSTRING(STRING(i),2,2).
      IF SEARCH(fn_i + ".inp") = ? THEN DO:
          LEAVE.
      END.
      i = i + 1.
  END.
  aa */

     {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

  FOR EACH pott:
      DELETE pott.
  END.
  FOR EACH tte:
      DELETE tte.
  END.
  FOR EACH tt1:
      DELETE tt1.
  END.

  j=0.
  /* "1,取符合条件的数据,请等待......" 按供应商，图号汇总. B*/

 
      for each xx_inv_mstr where xx_inv_no >= shipno 
                             and xx_inv_no <= shipno1 
                             and xx_inv_vend >= vend 
                             and xx_inv_vend <= vend1
			                 AND xx_inv_site >= site 
                             and xx_inv_site <= site1 no-lock,
      each xx_ship_det no-lock where xx_inv_no=xx_ship_no 
                            /*and xx_ship_site >= site and xx_ship_site <= site1*/
                            /*and xx_ship_vend >= vend and xx_ship_vend <= vend1*/ 
			    /* and xx_ship_no >= shipno and xx_ship_no <= shipno1   */
			    and xx_ship_line >= shipline and xx_ship_line <= shipline1  
			    and xx_ship_rcvd_date>=rcvddate and xx_ship_rcvd_date<=rcvddate1
                AND xx_ship_rcvd_qty <> 0 
			    /* and xx_ship_status="open"  and xx_ship_rcvd_qty< xx_ship_qty */
			    break by xx_inv_site by xx_inv_vend  by xx_ship_part :         

			    ACCUMULATE xx_ship_qty ( TOTAL by xx_inv_site by xx_inv_vend by  xx_ship_part ) .

       
          CREATE pott.
          ASSIGN
             pott_shipno = xx_ship_no
/*	     pott_shipnbr = xx_ship_nbr */
	     pott_site = xx_ship_site
	     pott_vend = xx_inv_vend
	     pott_case = xx_ship_case
	     pott_part_vend = xx_ship_part
	     pott_pkg = xx_ship_pkg
	     pott_qty_unit = xx_ship_qty_unit
	     pott_qty =   xx_ship_rcvd_qty  
	     pott_status = xx_ship_status
	     pott_price = xx_ship_price
	     pott_value = xx_ship_value
	     pott_curr = xx_ship_curr
	     pott_duedate = ?
	     pott_etadate = ?
	     pott_line = xx_ship_line
             pott_order_type = ''  /*P量产，R新机种*/
	     pott_rate = xx_ship_rate
	    
              .
 /* get lot*/
            if xx_ship_rcvd_date<>? then do:
		    if month(xx_ship_rcvd_date)>9 then assign datestr=substring(string(year(xx_ship_rcvd_date)),3)  + string(month(xx_ship_rcvd_date)).
		    else assign datestr=string(year(xx_ship_rcvd_date))  + "0" + string(month(xx_ship_rcvd_date)).
		    if day(xx_ship_rcvd_date)>9 then assign datestr= datestr + string(day(xx_ship_rcvd_date)).
		    else assign datestr= datestr + "0" + string(day(xx_ship_rcvd_date)).
	    end.

            assign pott_lot = datestr + xx_inv_no .


	     find first vd_mstr where vd_addr=xx_inv_vend no-lock no-error.
	     if avail vd_mstr then do:
	         if xx_ship_curr<> vd_curr then assign pott_cost=xx_ship_price * xx_ship_rate.
		 else pott_cost=xx_ship_price .
	     end.
	     else pott_cost=xx_ship_price .
         
  end. /* for each xx_ship_det */
 /* "1,取符合条件的数据,请等待......" 按供应商，图号汇总. E*/
  
/* "2,判断供应商图号与ZH图号对应是否存在" . B */
     

 
for each pott:

	 disp pott_shipno  /* 订单 */
	/* pott_shipnbr  */
	 pott_vend /*   订单项   */
	 pott_part_vend /* 供应商 */
	 pott_pkg /*   未决量   */
	 pott_qty_unit 	/* 图号 */			    
	 pott_qty /* 地点 */	
	 pott_lot
	 with frame ab2c width 200 down.
 end.
  



   /* REPORT TRAILER */
   {mfrtrail.i}

def var abcd   AS LOGICAL.
abcd=no.
 message "Print Label?/打印标签?" update abcd.
 if abcd=yes then do:
   def var v1100 as char.
   def var v1104 as char.
   def var v1200 as char.
   def var v1300 as char.
   def var v1500 as char.
   def var v9015 as char.
   def var ab1 as char.
     for each pott:
           find first vd_mstr where vd_addr=pott_vend no-lock no-error.
	    if avail vd_mstr then assign V1104=substring(vd_sort,1,4).
            
	    /*if month(xx_ship_rcvd_date)>9 then assign datestr=string(year(xx_ship_rcvd_date))  + string(month(xx_ship_rcvd_date)).
	    else assign datestr=string(year(xx_ship_rcvd_date))  + "0" + string(month(xx_ship_rcvd_date)).
	    if day(xx_ship_rcvd_date)>9 then assign datestr= datestr + string(day(xx_ship_rcvd_date)).
	    else assign datestr= datestr + "0" + string(day(xx_ship_rcvd_date)).*/

	     v1100=pott_site.
	     
	     v1200=pott_shipno .
	      
	     v1500=pott_lot.
	     
	     v9015=string(pott_qty). 
	     


	     FIND FIRST vp_mstr WHERE pott_vend = vp_vend AND pott_part_vend = vp_vend_part NO-LOCK NO-ERROR.
              IF   AVAIL vp_mstr THEN                     
              ASSIGN 
               v1300 = vp_part 



	 
	    ab1= por039160l(v1100,v1104,v1200,v1300,v1500,v9015 ).
	   
	       find first PRD_DET where PRD_DEV = dev no-lock no-error.
	       IF AVAILABLE PRD_DET then do:
		 unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
		 unix silent value ( "clear").
	       end.
     
     end. /* for each pott: */


   end. /*  if abcd=yes then do: */

 
      UNDO mainloop, RETRY mainloop. 
end. /* Main Repeat */


     



/*
CREATE xx_ship_det.
ASSIGN    xx_ship_no="1234"
	      xx_ship_nbr=2
	      xx_ship_site ='gsa01'
	      xx_ship_vend='C01A002'
	      xx_ship_case =1
	      xx_ship_part='M07402-471-0B'
	      xx_ship_pkg=3
	      xx_ship_qty_unit=200
	      xx_ship_qty=100 
	      xx_ship_status='open'
	      xx_ship_price=20
	      xx_ship_value=20
	      xx_ship_curr='cny'
	      xx_ship_duedate=today
	      xx_ship_etadate=today
	      xx_ship_line=1
	      xx_ship_rate=1.


	      */
