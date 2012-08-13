/* xxrcunrp.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 03/08/01      BY: Rao Haobin          */
/* V2                 Last MOD: 06/28/05          BY: Judy Liu              */

	  {mfdtitle.i  "B+"} 
	  define variable nbr like tr_nbr.
          define variable duplicate as char.
          define variable pageno as integer.
          define variable i as integer.
          define variable site1 like tr_site initial "DCEC-B".
          define variable site2 like tr_site initial "DCEC-C".
                        
FORM 
   "计划外入库单"      at 33   
skip(1)
     pageno        label "页号:   "       at 48
     duplicate     no-labels        at 48
     tr_so_job      label "合同号:   " at 48
     tr_nbr        label "入库单号:  "     at 48
     tr_effdate    label "收货日期:  "    at 48 
 skip(1) 
   "零件号           零件名称               地点     单位       实收数量             库位         备注" 

    skip "--------------------------------------------------------------------------------------------" 
     with no-box side-labels width 180 frame b.

 

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

	  FORM /*GUI*/ 
	     
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 
 SKIP(.1)  /*GUI*/
nbr           colon 18 skip(.1)
site1 label "从地点"  colon 18 skip(.1)
site2 label "到地点"  colon 18
 skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).

 DEFINE VARIABLE F-a-title AS CHARACTER.
  F-a-title = " 选择条件 ". 
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/
 
/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



 

{wbrp01.i}

	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i nbr   }

	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}

i=1.
pageno=1.

find first tr_hist where tr_nbr = nbr and (tr_type = "RCT-UNP").
 
   if tr__log02 = no then do:
       duplicate ="原本". 
   end.
   if tr__log02 = yes then do:
     duplicate ="副本".  
   end.
   
disp pageno tr_so_job tr_nbr duplicate tr_effdate with frame b.

for each tr_hist where  (tr_nbr = nbr)
                 and    (tr_type = "RCT-UNP")
                 and    (tr_site >= site1 and tr_site <= site2) 
                 break by tr_nbr:
    
    find first pt_mstr where pt_part = tr_part no-lock no-error.
    if available pt_mstr then do:
      display tr_part pt_desc2 tr_site pt_um tr_qty_chg "        " tr_loc with no-box no-labels width 250 frame c DOWN STREAM-IO.          
      display  "----------------------------------------------------------------------------------------" with width 250 no-box frame f. 
      i = i + 1.
    if i>=6 then do:
      i = 1.
      pageno = pageno + 1. 
    DISP "采购员:              质检员:                保管员:              供应商:"  at 1 skip(4) with width 250 no-box frame d.  
  
      disp pageno tr_so_job tr_nbr duplicate tr_effdate with frame b.
    end.
    if last-of(tr_nbr) THEN 
     disp  "采购员:              质检员:                保管员:              供应商:" at 1 with width 250 no-box frame d. 
  
 end.
  
end.

 

	     {mfphead.i}
if dev = "printer" or dev="print-sm" or dev="PRNT88" or dev="PRNT80" then do:
     
  for each tr_hist where (tr_nbr = nbr)
                          and (tr_type = "RCT-UNP"):
                             
      ASSIGN  tr__log02 = yes.
     
  end.
end.

 
 
 {mfgrptrm.i} /*Report-to-Window*/
/*judy 07/07/05*/  {mfreset.i} 
  end procedure.
 
/*GUI*/ {mfguirpb.i &flds=" nbr site1 site2 "} /*Drive the Report*/

/*judy 07/07/05*/  /*{mfreset.i} */
