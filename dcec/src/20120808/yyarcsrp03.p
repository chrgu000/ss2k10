/* GUI CONVERTED from arcsrp03.p (converter v1.76) Tue May 27 23:51:58 2003 */
/* arcsrp03.p - AR CUSTOMER STATEMENTS                                        */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11.1.11 $                                                      */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 07/16/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 09/20/90   BY: afs *D059*                */
/* REVISION: 6.0      LAST MODIFIED: 10/12/90   BY: afs *D099*                */
/* REVISION: 6.0      LAST MODIFIED: 03/29/91   BY: bjb *D470*                */
/* REVISION: 6.0      LAST MODIFIED: 10/10/91   BY: pml *F018*                */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   by: jms *F237*                */
/* REVISION: 7.3      LAST MODIFIED: 09/03/92   BY: afs *G045*                */
/*                                   09/15/93   BY: jjs *GF27*                */
/*                                   12/08/93   by: jms *GH79*                */
/*                                   12/09/93   by: jms *GH82*                */
/*                                   10/11/94   by: str *FS29*                */
/*                                   12/06/94   by: cdt *GO70*                */
/* REVISION: 8.5      LAST MODIFIED: 12/08/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*                */
/* REVISION: 8.5      LAST MODIFIED: 09/03/97   BY: *J209* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0PL*                */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J295* Irine D'mello      */
/* REVISION: 8.6                     02/02/98   by: *H1JC* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 01/13/00   BY: *M0HS* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 02/10/00   BY: *N07W* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/12/00   BY: *N07D* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0VV* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11.1.10    BY: Jean Miller        DATE: 12/14/01  ECO: *P03Q*  */
/* $Revision: 1.11.1.11 $  BY: Kedar Deherkar     DATE: 05/27/03  ECO: *N2G0*  */
/*cj*new*version*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
{cxcustom.i "ARCSRP03.P"}

define variable oldsession as character.
define variable oldcurr like ar_curr no-undo.
define variable rndmthd like rnd_rnd_mthd no-undo.
define variable curr_amt_fmt as character no-undo.
define variable curr_amt_old as character no-undo.
define variable cust  like ar_bill no-undo.
define variable cust1 like ar_bill no-undo.

define variable start_date   like oa_fr_date no-undo.
define variable type         as character format "x(8)" label "Type" no-undo.
define variable age_days     as integer extent 5 label "Column Days" no-undo.
define variable age_range    as character extent 5 format "x(16)" no-undo.
define variable i            as integer no-undo.
define variable age_amt      like ar_amt extent 5 no-undo.
define variable age_period   as integer no-undo.
define variable stmt_cyc     like cm_stmt_cyc no-undo.
define variable comp_addr    like soc_company no-undo.
define variable msg          like msg_desc format "x(60)" no-undo.
define variable pages        as integer no-undo.
define variable current_bal  like ar_amt no-undo.
define variable unapplied    like ar_amt no-undo.
define variable disc         like ard_disc no-undo.
define variable bal_out      like mfc_logical
   label "Outstanding Balance Only" no-undo.
define variable company      as character format "x(40)" extent 6 no-undo.
define variable billto       as character format "x(40)" extent 6 no-undo.
define variable base_amt     like ar_amt no-undo.
define variable base_applied like ar_applied no-undo.
define variable base_open    like ar_amt no-undo.
define variable base_disc    like ard_disc no-undo.
define variable due-date     like ar_due_date no-undo.
define variable amt-to-apply like ar_amt no-undo.
define variable amt-due      like ar_amt no-undo.
define variable amt-open     like ar_amt no-undo.
define variable j            as integer no-undo.
define variable open_ref     like ar_amt extent 3 no-undo.
define variable mgot         like mfc_logical no-undo.
define variable contested    as character format "x(1)" no-undo.
define variable contest_amt  like ar_amt
   label "Contested Amount" no-undo.
define new shared variable addr as character format "x(38)" extent 6.
define variable contest_tot  like ar_amt no-undo.
define variable total-amt    like ar_amt no-undo.

define variable mc-error-number like msg_nbr no-undo.
{&ARCSRP03-P-TAG1}
define variable l_msgdesc       like msg_desc no-undo.

/*cj*/
DEF VAR efdt LIKE ar_effdate .
DEF VAR efdt1 LIKE ar_effdate .
DEF VAR startamt LIKE ar_base_amt .
DEF VAR endamt LIKE ar_base_amt .
DEF VAR amt0 LIKE ar_base_amt .
DEF VAR nbr0 AS CHAR FORMAT "x(8)" .
DEF VAR amtrmb LIKE ar_base_amt.

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
 cust           colon 25 cust1  label {t001.i} colon 49 skip (1)
 efdt          COLON 25 efdt1 LABEL {t001.i} COLON 49 skip (1)
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first gl_ctrl no-lock.


{wbrp01.i}
repeat:

    IF cust1 = hi_char THEN cust1 = "" .
    IF efdt = low_date THEN efdt = ? .
    IF efdt1 = hi_date THEN efdt1 = ? .

    UPDATE cust cust1 efdt efdt1 WITH FRAME a .

    IF cust1 = "" THEN cust1 = hi_char .
    IF efdt = ? THEN efdt = low_date .
    IF efdt1 = ? THEN efdt1 = hi_date .

   {mfselprt.i "printer" 132}  

   for each cm_mstr where
      cm_addr >= cust and cm_addr <= cust1 
   no-lock:

      for each ar_mstr where
         ar_bill = cm_addr and
         ar_effdate >= efdt AND ar_effdate <= efdt1 AND
         ar_type <> "A" and
         (not ar_type = "D" or ar_draft = true)
      no-lock break by ar_bill by ar_curr
      by ar_effdate DESCENDING :

         if ar_type = "M" then type = getTermLabel("MEMO",8).
         else if ar_type = "I" then type = getTermLabel("INVOICE",8).
         else if ar_type = "F" then type = getTermLabel("FIN_CHG",8).
         else if ar_type = "P" then type = getTermLabel("PAYMENT",8).
         else if ar_type = "D" then type = getTermLabel("DRAFT",8).

         if first-of(ar_bill) then do:
            find ad_mstr where ad_addr = ar_bill no-lock no-error.
            {gprun.i ""yyarcs1.p"" "(input ar_bill,
                INPUT-OUTPUT efdt,
                INPUT-OUTPUT efdt1,
                OUTPUT startamt,
                OUTPUT endamt)"
             }   
       
            PUT "客户"AT 2 "客户名称" AT 12 "开始日期" AT 42 "结束日期" AT 52 "期初金额" TO 82 "期末金额" TO 102 SKIP .

            PUT ar_bill AT 2 ad_name AT 12 efdt AT 42 efdt1 AT 52 startamt TO 82 endamt TO 102 SKIP .     

            PUT "生效日期" AT 2 "发票/支票" AT 12 "类型" AT 22 "货币金额" TO 50 "货币" AT 52 "人民币金额" TO 75 "余额" TO 95 SKIP .

            amt0 = endamt .
         end.

         base_amt = ar_amt.

         /*NOTE: USED FOR EACH BECAUSE WITH VAT MAY HAVE MORE THAN 1 BLANK REF*/
         if ar_type = "P" and
            can-find(first ard_det where ard_nbr = ar_nbr and
            ard_ref = "")
         then do:
            for each ard_det where
                  ard_nbr = ar_nbr and
                  ard_ref = ""
            no-lock:
               if ard_type = "N" then do:
                  base_amt = base_amt + ard_amt.
               end.
            end.
         end.

         IF ar_type = "D" THEN base_amt = - base_amt .

         if ar_type = "P" and
            can-find(first ard_det where ard_nbr = ar_nbr and
            ard_type = "d")
         then do:
            for each ard_det where
                  ard_nbr = ar_nbr and
                  ard_type = "d"
            no-lock:
                  base_amt = base_amt + ard_amt.
            end.
         end.

         IF ar_type = "p" THEN nbr0 = SUBSTRING(ar_nbr,9) .
         ELSE nbr0 = ar_nbr .

         IF ar_curr <> gl_base_curr THEN DO :
             IF base_amt <> ar_amt THEN amtrmb = base_amt / ar_ex_rate .
             ELSE amtrmb = ar_base_amt .
         END.
         ELSE amtrmb = base_amt .

         IF base_amt <> 0 THEN PUT ar_effdate AT 2 nbr0 AT 12 TYPE AT 22 base_amt TO 50 ar_curr AT 52 amtrmb TO 75 amt0 TO 95 SKIP .

         amt0 = amt0 - amtrmb .
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


      end. /* for each ar_mstr */

   end. /* for each cm_mstr */

   
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
{mfreset.i}

end. /* repeat */

SESSION:numeric-format = oldsession.

{wbrp04.i &frame-spec = a}
