/* xxrcunrp.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 05/09/01      BY: Kang Jian          */
/* Rev: eb2+ sp7      Last Modified: 05/07/07      BY: judy Liu         */
	  
      {mfdtitle.i} 
	  define variable cur_nbr like tr_nbr.
	  define variable nbr like tr_nbr.
	  define variable part like tr_part.
	  define variable eff_date like tr_effdate.
	  define variable so_job like tr_so_job.
	  define variable nbr1 like tr_nbr.
	  define variable part1 like tr_part.
	  define variable eff_date1 like tr_effdate.
	  define variable so_job1 like tr_so_job. 
	  define variable so_rmks1 like tr_rmks.
	  define variable so_rmks like tr_rmks.
	  define variable site1 like tr_site initial "DCEC-B". /*Jch*/
	  define variable site2 like tr_site initial "DCEC-C". /*Jch*/
          define variable duplicate as char.
          define variable pageno as integer.
          define variable page_start as integer.
          define variable page_end as integer.
          define variable i as integer.
          define variable issue as integer.
page_start=1.
page_end=99999999.
issue=0.                       
form "�ƻ�����ⵥ"    at 33  
skip(1)
    duplicate     no-labels        at 10
    pageno        label "ҳ�ţ�   "       at 48
     tr_nbr        label "��ⵥ�ţ�    "  at 48
     tr_effdate    label "������ڣ�    "    at 48 
   
     skip(1) 
     "�����           �������               �ص�       ��λ         �������        ��λ       ����/����  ��ע  "
     skip "---------------------------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame b.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A


	  FORM /*GUI*/ 
	     
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr       colon 18 label "�Ӷ�����"
NBR1      label "��������" COLON  48  skip 
part      label "�������"    colon 18
PART1   label "�������"  COLON 48  skip
eff_date  label "����Ч����"     colon 18
EFF_DATE1  LABEL "����Ч����"  COLON 48 SKIP
so_job    LABEL "������/����"    colon 18
SO_JOB1  LABEL "������/����" COLON 48  skip
site1    label "�ӵص�" colon 18
site2    label "���ص�" colon 48 skip
so_rmks label "�ӱ�ע"  colon 18
so_rmks1 label "����ע" colon 48 skip
page_start label "��ҳ��" colon 18
page_end label "��ҳ��" colon 48 skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " ѡ������ ".
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

	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

/*j034*/ if nbr1  = hi_char then nbr1  = "".
/*J034*/ if part1 = hi_char then part1 = "".
/*J034*/ if eff_date1 = hi_date then eff_date1 = ?.
/*J034*/ if so_job1  = hi_char then so_job1 = "".
/*J034*/ if eff_date = low_date then eff_date = ?.
/*J034*/ if so_rmks = hi_char then so_rmks = "".
/*J034*/ if so_rmks1 = hi_char then so_rmks1 = "".


	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i nbr}
    	     {mfquoter.i nbr1}
	     {mfquoter.i part}
	     {mfquoter.i part1}
	     {mfquoter.i eff_date}
	     {mfquoter.i eff_date1}
	     {mfquoter.i so_job}
	     {mfquoter.i so_job1}
	     {mfquoter.i site1}
	     {mfquoter.i site2}
	     {mfquoter.i so_rmks}
	     {mfquoter.i so_rmks1}
	     {mfquoter.i page_start}
	     {mfquoter.i page_end}
	     




/*J0VG *** MOVED TO BELOW QUOTER CALLS - CAUSED PROBLEMS HERE ***************/
/*J034* ** MOVED HI_ VALUES SETTINGS + SITE RANGE CHECK ABOVE QUOTER CALLS */

/*J034*/ if nbr1  = "" then nbr1  = hi_char.
/*J034*/ if part1 = "" then part1 = hi_char.
/*J034*/ if eff_date1 = ? then eff_date1 = hi_date.
/*J034*/ if so_job1  = "" then so_job1 = hi_char.
/*J034*/ /*if nbr  = "" then nbr  = low_char.*/
/*J034*/ /*if part = "" then part = low_char.*/
/*J034*/ if eff_date = ? then eff_date = low_date.
/*J034*/ /*if so_job  = "" then so_job = low_char.*/
/*j034*/ if so_rmks1=""  then so_rmks1=hi_char.
/*         if so_rmks=""  then so_rmks=low_char.*/


/* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "window" 132} 
/*{MFSELPRT.I "terminal" 80} */

i = 1.
pageno=page_start.

for each  tr_hist where  (tr_nbr >= nbr) and (tr_nbr <= nbr1)
                 and    (tr_part >= part) and (tr_part <= part1)
                 and    (tr_effdate >= eff_date)  and  (tr_effdate <= eff_date1)
                 and    (tr_so_job >= so_job) and (tr_so_job <= so_job1)
                 and    (tr_type = "RCT-UNP")
                 and    (tr_site >= site1 and tr_site <= site2)
                 and    (tr_rmks>=so_rmks) and (tr_rmks<=so_rmks1)
                 and  (pageno<=page_end)
            use-index tr_nbr 
            break by tr_nbr: 
   if i=1 then  
   disp pageno tr_nbr duplicate tr_effdate with frame b.

  /* find first tr_hist where tr_nbr = cur_nbr*/
 
     find first pt_mstr where pt_part = tr_part no-lock no-error.
     if available pt_mstr then do:
       issue = 0 - tr_qty_chg.
       display tr_part pt_desc2 tr_site pt_um tr_qty_chg "        " tr_loc tr_so_job tr_rmks with no-box no-labels width 250 frame c down.          
       i = i + 1.
     end.
     if i>=50 then do:
       i = 1.      
       display  "---------------------------------------------------------------------------------------------" with width 241 no-box frame f.       
       disp  "�ƻ�Ա:              �ʼ�Ա:                ����Ա:              ������:" at 1 skip(4) with width 241 no-box frame d. 
       pageno = pageno + 1. 
/*       disp pageno tr_so_job tr_nbr duplicate tr_effdate with frame b.*/
       if pageno>page_end then leave.
     end.
     if last-of(tr_nbr) then do:
          disp  "�ƻ�Ա:              �ʼ�Ա:                ����Ա:              ������:" at 1 with width 241 no-box frame d.
          pageno = pageno + 1. 
          i=1.
     end.
end.

/* /*GUI*/ {mfguitrl.i}  */
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

	     {mfphead.i}
/*judy 06/27/05*/ {mfreset.i}
end procedure.



/*GUI*/ {mfguirpb.i &flds="nbr  nbr1 part part1 eff_date eff_date1 so_job so_job1 site1 site2 so_rmks so_rmks1 page_start page_end"} /*Drive the Report*/

 
