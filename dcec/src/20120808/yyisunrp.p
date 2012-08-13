/* xxrcunrp.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 03/08/01      BY: Rao Haobin          */
/* V2                 Last MOD: 06/28/05      BY: Judy Liu           */
	  
 {mfdtitle.i "b+" } 
	  define variable nbr like tr_nbr.
	  define variable eff_date like tr_effdate.
	  define variable so_job like tr_so_job.
	  define variable part like tr_part.
          define variable duplicate as char.
          define variable pageno as integer.
          define variable i as integer.
          define variable issue as integer.
                        
form "计划外出库单"      at 33  
skip(1)
     pageno        label "页号:   "       at 48
          duplicate     no-labels        at 48
     tr_so_job      label "合同号:   " at 48
     tr_nbr        label "出库单号:  "                 at 48
     tr_effdate    label "出库日期:  "    at 48 
 skip(1) 
     "零件号           零件名称             单位        出库数量             库位         备注"
     skip "---------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame b.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

	  FORM /*GUI*/ 
	     
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr           colon 18 skip
part          colon 18  skip
eff_date      colon 18  skip
so_job        colon 18  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


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

/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).

 {wbrp01.i}

       /* REPORT BLOCK */


 /*GUI*/ {mfguirpa.i true  "printer" 132 }

 /*GUI repeat : */
 /*GUI*/ procedure p-enable-ui:


 run p-action-fields (input "display").
 run p-action-fields (input "enable").
 end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

  
/*GUI repeat : */
/*GUI*/ /*procedure p-enable-ui:*/

	     
/*run p-action-fields (input "display").*/
/*run p-action-fields (input "enable").*/
/*end procedure. */
/* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i nbr}
	     {mfquoter.i part}
{mfquoter.i eff_date}
{mfquoter.i so_job}


	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}

i=1.
pageno=1.

find first tr_hist where tr_nbr = nbr and (tr_type = "ISS-UNP") .
   if tr__log02 = no then do:
        duplicate ="原本".
   end.
   if tr__log02 = yes then do:
        duplicate ="副本".
   end.
   
disp pageno tr_so_job tr_nbr duplicate tr_effdate with frame b.

for each tr_hist where  (tr_nbr = nbr)
                 and    (tr_type = "ISS-UNP")
                 break by tr_nbr:
    find first pt_mstr where pt_part = tr_part no-lock no-error.
    if available pt_mstr then do:
      issue =tr_qty_chg.
      
      DISP  tr_part pt_desc2 pt_um    issue  "　   　"  tr_loc    with no-box no-labels width 250 frame c DOWN .   
   
      display  "----------------------------------------------------------------------------------------" with width 250 no-box frame f.
      i = i + 1.
    if i>=6 then do:
      i = 1.
      pageno = pageno + 1. 
      disp  "计划员:              质检员:                保管员:              接收人:" at 1 skip(4) with width 250 no-box frame d. 
      disp pageno tr_so_job tr_nbr duplicate tr_effdate with frame b.
    end.
    if last-of(tr_nbr) then
     disp  "计划员:              质检员:                保管员:              接收人:" at 1 with width 250 no-box frame d.
    end.
  
end.

/* /*GUI*/ {mfguitrl.i}  */
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

	     {mfphead.i}
if dev = "printer" or dev="print-sm" or dev="PRNT88" or dev="PRNT80" then do:
  for each tr_hist where (tr_nbr = nbr)
                          and (tr_type = "ISS-UNP"):
                             tr__log02 = yes.
  end.
end.

   
/*judy 06/28/05*/    {mfreset.i} 

/*judy 06/28/05*/ /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/ 
 /*K0ZX*/ {wbrp04.i &frame-spec = a} 
 end procedure.



/*GUI*/  {mfguirpb.i &flds="nbr part eff_date so_job"} 

 /*
update
  nbr
  part
  eff_date
  so_job
with frame a*/
 /*Drive the Report*/

/*judy 06/28/05*/ /* {mfreset.i}*/
