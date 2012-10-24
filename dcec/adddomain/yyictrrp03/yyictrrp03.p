/* GUI CONVERTED from ictrrp03.p (converter v1.78) Thu Apr 22 21:58:20 2010 */
/* ictrrp03.p - TRANSACTION ACCOUNTING REPORT                                 */
/* Copyright 1986-2010 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 1.0      LAST MODIFIED: 04/15/86   BY: PML                       */
/* REVISION: 4.0      LAST MODIFIED: 02/12/88   BY: FLM *A175*                */
/* REVISION: 4.0      LAST MODIFIED: 11/30/88   BY: MLB *A544*                */
/* REVISION: 5.0      LAST MODIFIED: 11/03/89   BY: MLB *B006*                */
/* REVISION: 5.0      LAST MODIFIED: 01/16/90   BY: MLB *B508*                */
/* REVISION: 6.0      LAST MODIFIED: 09/03/90   BY: pml *D064*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F268*                */
/* REVISION: 7.0      LAST MODIFIED: 07/20/91   BY: pma *F781*                */
/* Revision: 7.3      Last Modified: 08/03/92   By: mpp *G024*                */
/* Revision: 7.3      Last Modified: 10/30/92   By: jcd *G256*                */
/* Revision: 7.3      Last Modified: 03/19/93   By: pma *G848*                */
/* Revision: 7.3      Last Modified: 09/15/93   By: pxd *GF20*                */
/* Revision: 7.3      Last Modified: 09/11/94   By: rmh *GM10*                */
/* Revision: 7.3      Last Modified: 09/18/94   By: qzl *FR49*                */
/* Revision: 7.3      Last Modified: 06/05/95   By: qzl *G0QM*                */
/* Revision: 7.3      Last Modified: 01/29/96   By: jym *G1LG*                */
/* Revision: 8.6      Last Modified: 10/09/97   By: gyk *K0Q1*                */
/* Revision: 8.6      Last Modified: 11/21/97   By: bvm *K1BF*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *J2Y2* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16       BY: Hualin Zhong           DATE: 09/19/01 ECO: *N12H* */
/* Revision: 1.17       BY: Patrick Rowan          DATE: 04/24/01 ECO: *P00G* */
/* Revision: 1.18       BY: Rajiv Ramaiah          DATE: 04/16/01 ECO: *N1GM* */
/* Revision: 1.19       BY: Chris Green            DATE: 11/29/01 ECO: *N16J* */
/* Revision: 1.20       BY: Narathip W.            DATE: 05/03/03 ECO: *P0R5* */
/* Revision: 1.22       BY: Paul Donnelly (SB)     DATE: 06/28/03 ECO: *Q00G* */
/* Revision: 1.23       BY: Pawel Grzybowski       DATE: 08/20/03 ECO: *P109* */
/* Revision: 1.24       BY: Orawan S.              DATE: 10/08/03 ECO: *P13T* */
/* Revision: 1.26       BY: Preeti Sattur          DATE: 09/21/04 ECO: *P2L8* */
/* Revision: 1.27       BY: Shivganesh Hegde       DATE: 06/28/05 ECO: *P3QZ* */
/* Revision: 1.28       BY: Narathip W.            DATE: 07/07/05 ECO: *P3S8* */
/* Revision: 1.28.1.1   BY: Antony LejoS           DATE: 05/27/08 ECO: *P6V2* */
/* Revision: 1.28.1.2   BY: Ruchita Shinde         DATE: 09/18/08 ECO: *Q1T3* */
/* Revision: 1.28.1.4   BY: Laxmikant Bondre       DATE: 05/05/09 ECO: *Q2TR* */
/* Revision: 1.28.1.5   BY: Ruchita Shinde         DATE: 08/06/09 ECO: *Q377* */
/* $Revision: 1.28.1.6 $ BY: Abhijit Gupta DATE: 04/22/10 ECO: *Q416* */
/* ss - 121010.1 by: Steven */ /* Add filter by item number */

/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Report                                                       */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*{mfdtitle.i "1+ "}*/
{mfdtitle.i "121010.1"}


/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{cxcustom.i "ICTRRP03.P"}

/* ********** Begin Translatable Strings Definitions ********* */

{&ICTRRP03-P-TAG1}
&SCOPED-DEFINE ictrrp03_p_1 "Detail by GL Account"
{&ICTRRP03-P-TAG2}
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp03_p_2 "Detail by Transaction"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp03_p_3 "Quantity @ Unit Cost!Item Description"
/* MaxLen: 53 Comment: Two 26-character column headings */

&SCOPED-DEFINE ictrrp03_p_4 "DR Acct!CR Acct"
/* MaxLen: 17 Comment: 8 char abbreviations for Debit Account, Credit Account */

&SCOPED-DEFINE ictrrp03_p_5 "Sub-Acct!Sub-Acct"
/* MaxLen: 17 Comment: 8 char abbreviations for Sub-Account */

&SCOPED-DEFINE ictrrp03_p_6 "CC!CC"
/* MaxLen: 17 Comment: 8 char abbreviations for Cost Center */

&SCOPED-DEFINE ictrrp03_p_7 "DR Amount!CR Amount"
/* MaxLen: 27 Comment: Debit Account and Credit Account (13 characters each) */

&SCOPED-DEFINE ictrrp03_p_8 "Order!Item"
/* MaxLen: 37 Comment: Two 18-character column headings, Order Number and Item Number */

/* ********** End Translatable Strings Definitions ********* */

{&ICTRRP03-P-TAG3}
define variable trdate     like tr_date        no-undo.
define variable trdate1    like tr_date        no-undo.
{&ICTRRP03-P-TAG4}
define variable glref      like trgl_gl_ref    no-undo.
define variable glref1     like trgl_gl_ref    no-undo.
define variable efdate     like tr_effdate     no-undo.
define variable efdate1    like tr_date        no-undo.
define variable trtype     like tr_type        no-undo.
define variable desc1      like pt_desc1       no-undo.
define variable desc2      like pt_desc2
   column-label {&ictrrp03_p_3} format "x(26)" no-undo.
define variable tr_yn      like mfc_logical label {&ictrrp03_p_2}
   initial yes no-undo.
define variable gl_yn      like mfc_logical label {&ictrrp03_p_1}
   initial yes no-undo.
define variable entity     like en_entity      no-undo.
define variable entity1    like en_entity      no-undo.
define variable acct       like glt_acct       no-undo.
define variable acct1      like glt_acct       no-undo.
define variable sub        like glt_sub        no-undo.
define variable sub1       like glt_sub        no-undo.
define variable proj       like glt_project    no-undo.
define variable proj1      like glt_project    no-undo.
define variable cc         like glt_cc         no-undo.
define variable cc1        like glt_cc         no-undo.
define variable l_fo_trnbr as   logical        no-undo.
/* ss - 121010.1 - B */ 
define variable part       like pt_part        no-undo.
define variable part1      like pt_part        no-undo.
/* ss - 121010.1 - E */ 

define buffer trhist for tr_hist.

/* DEFINED TEMP-TABLE TO RECORD AND DISPLAY GL DATA */
define temp-table tt_glt no-undo
   field tt_entity   like gltw_entity
   field tt_acc      like gltw_acct
   field tt_sub      like gltw_sub
   field tt_cc       like gltw_cc
   field tt_ref      like gltw_ref
   field tt_line     like gltw_line
   field tt_desc     like gltw_desc
   field tt_date     like gltw_date
   field tt_effdate  like gltw_effdate
   field tt_amt      like gltw_amt
   field tt_project  like gltw_project
   index tt_idx      tt_ref
                     tt_line.

{&ICTRRP03-P-TAG5}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   efdate         colon 20
   efdate1        label {t001.i} colon 49 skip
/* ss - 121010.1 - B */ 
   part           colon 20
   part1          label {t001.i} colon 49 skip
/* ss - 121010.1 - E */    
   glref          colon 20
   glref1         label {t001.i} colon 49 skip
   entity         colon 20
   entity1        label {t001.i} colon 49 skip
   acct           colon 20
   acct1          label {t001.i} colon 49 skip
   sub            colon 20
   sub1           label {t001.i} colon 49 skip
   cc             colon 20
   cc1            label {t001.i} colon 49 skip
   proj           colon 20
   proj1          label {t001.i} colon 49 skip
   trdate         colon 20
   trdate1        label {t001.i} colon 49 {&ICTRRP03-P-TAG40} skip (1)
   {&ICTRRP03-P-TAG29}
   trtype         colon 35
   tr_yn          colon 35
   gl_yn          colon 35
   {&ICTRRP03-P-TAG30}
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&ICTRRP03-P-TAG6}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&ICTRRP03-P-TAG18}
FORM /*GUI*/ 
   tr_effdate
   tr_trnbr
   trgl_type
   tr_nbr       column-label {&ictrrp03_p_8}
   si_entity    column-label "Ent"
   trgl_gl_ref
   desc2
   trgl_dr_acct column-label {&ictrrp03_p_4}
   trgl_dr_sub  column-label {&ictrrp03_p_5}
   trgl_dr_cc   column-label {&ictrrp03_p_6}
   trgl_gl_amt  column-label {&ictrrp03_p_7}
   format "->>>,>>>,>>>,>>9.99<<<<<<<<"
with STREAM-IO /*GUI*/  frame b down width 132 no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
{&ICTRRP03-P-TAG19}

assign
   efdate  = date((month(today)),1,year(today))
   efdate1 = today
   trdate  = date((month(today)),1,year(today))
   trdate1 = today.

{wbrp01.i}
repeat:
   if trdate = low_date then
      trdate = ?.
   if trdate1 = hi_date then
      trdate1 = ?.
   if efdate = low_date then
      efdate = ?.
   if efdate1 = hi_date then
      efdate1 = ?.
   if glref1 = hi_char then
      glref1 = "".
   if entity1 = hi_char then
      entity1 = "".
   if acct1  = hi_char then
      acct1  = "".
   if sub1   = hi_char then
      sub1   = "".
   if cc1    = hi_char then
      cc1    = "".
   if proj1  = hi_char then
      proj1  = "".
   /* ss - 121010.1 - B */ 
   if part1  = hi_char then
      part1  = "".
   /* ss - 121010.1 - E */ 
   for each tt_glt
   exclusive-lock:
      delete tt_glt.
   end. /* FOR EACH tt_glt */

   {&ICTRRP03-P-TAG7}
   if c-application-mode <> 'web' then
   {&ICTRRP03-P-TAG8}
   update
      efdate
      efdate1
      /* ss - 121010.1 - B */ 
      part
      part1
      /* ss - 121010.1 - E */ 
      glref
      glref1
      entity
      entity1
      acct
      acct1
      sub
      sub1
      cc
      cc1
      proj
      proj1
      trdate
      trdate1
      {&ICTRRP03-P-TAG31}
      trtype
      tr_yn
      gl_yn
      {&ICTRRP03-P-TAG32}
   with frame a.

   {&ICTRRP03-P-TAG33}
   {wbrp06.i &command = update
       &fields = "  efdate efdate1 glref glref1
    entity entity1
        acct acct1 sub sub1 cc cc1 proj proj1 trdate trdate1 trtype
        tr_yn gl_yn" &frm = "a"}

   {&ICTRRP03-P-TAG9}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {&ICTRRP03-P-TAG10}
      {mfquoter.i efdate         }
      {mfquoter.i efdate1        }
      /* ss - 121010.1 - B */ 
      {mfquoter.i part           }
      {mfquoter.i part1          }
      /* ss - 121010.1 - E */ 
      {&ICTRRP03-P-TAG11}
      {mfquoter.i glref          }
      {mfquoter.i glref1         }
      {mfquoter.i entity         }
      {mfquoter.i entity1        }
      {mfquoter.i acct           }
      {mfquoter.i acct1          }
      {mfquoter.i sub            }
      {mfquoter.i sub1           }
      {mfquoter.i cc             }
      {mfquoter.i cc1            }
      {mfquoter.i proj           }
      {mfquoter.i proj1          }
      {&ICTRRP03-P-TAG12}
      {mfquoter.i trdate         }
      {mfquoter.i trdate1        }
      {&ICTRRP03-P-TAG13}
      {mfquoter.i trtype         }
      {mfquoter.i tr_yn          }
      {mfquoter.i gl_yn          }

      {&ICTRRP03-P-TAG14}
      if trdate = ? then
         trdate = low_date.
      if trdate1 = ? then
         trdate1 = hi_date.
      if efdate = ? then
         efdate = low_date.
      if efdate1 = ? then
         efdate1 = hi_date.
      if glref1 = "" then
         glref1 = hi_char.
      if entity1 = "" then
         entity1 = hi_char.
      if acct1  = "" then
         acct1  = hi_char.
      if sub1   = "" then
         sub1   = hi_char.
      if cc1    = "" then
         cc1    = hi_char.
      if proj1  = "" then
         proj1  = hi_char.
      /* ss - 121010.1 - B */ 
      if part1  = "" then
         part1  = hi_char.
      /* ss - 121010.1 - E */    

      {&ICTRRP03-P-TAG15}

   end.
   /* OUTPUT DESTINATION SELECTION */
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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

   {mfphead.i}

   FORM /*GUI*/  header
      skip(1)
   with STREAM-IO /*GUI*/  frame a1 page-top width 132.
   view frame a1.

   {&ICTRRP03-P-TAG16}
   if  trtype <> ""
   then
      for each tr_hist
         fields(tr_date tr_effdate tr_type tr_trnbr tr_nbr tr_site
                tr_part tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std
                tr_ovh_std tr_sub_std tr_rmks)
         where  tr_domain   = global_domain
         and    tr_type     = trtype
         and   (tr_effdate >= efdate
            and tr_effdate <= efdate1
            or  tr_effdate  = ?)
         {&ICTRRP03-P-TAG34}
         and   (tr_date    >= trdate
            and tr_date    <= trdate1
            or  tr_date     = ?)
      /* ss - 121010.1 - B */ 
         and tr_part >= part
         and tr_part <= part1
      /* ss - 121010.1 - E */       
      no-lock
      by tr_domain by tr_effdate by tr_trnbr:
         {ictrrp03.i}
      end. /* FOR EACH tr_hist */
   else
      for each tr_hist
         fields(tr_date tr_effdate tr_type tr_trnbr tr_nbr tr_site
                tr_part tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std
                tr_ovh_std tr_sub_std tr_rmks)
         where  tr_domain   = global_domain
         and   (tr_effdate >= efdate
            and tr_effdate <= efdate1
            or  tr_effdate  = ?)
         {&ICTRRP03-P-TAG34}
         and   (tr_date    >= trdate
            and tr_date    <= trdate1
            or  tr_date     = ?)
         /* ss - 121010.1 - B */ 
         and tr_part >= part
         and tr_part <= part1
      /* ss - 121010.1 - E */    
      no-lock
      by tr_domain by tr_effdate by tr_trnbr:
         {ictrrp03.i}
      end. /* FOR EACH tr_hist */

   /* PRINT GL DISTRIBUTION */
   if gl_yn then do:
      if tr_yn then page.
      {&ICTRRP03-P-TAG37}

      /* PROCEDURE TO DISPLAY TEMP-TABLE DATA */
      run p_tt_glt_display.

      {&ICTRRP03-P-TAG38}
   end.

   /* REPORT TRAILER */

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}

{&ICTRRP03-P-TAG39}

/**************************INTERNAL PROCEDURES**********************/

/* PROCEDURE TO CREATE TEMP-TABLE WITH GL DATA */
PROCEDURE p_tt_glt_create:

   define variable l_line as integer no-undo.

   if can-find(last tt_glt
      where tt_ref = trgl_det.trgl_gl_ref)
   then
      l_line = l_line + 1.
   else
      l_line = 1.

   create tt_glt.
   assign
      tt_acc     = trgl_dr_acct
      tt_sub     = trgl_dr_sub
      tt_cc      = trgl_dr_cc
      tt_project = trgl_dr_proj
      tt_ref     = trgl_gl_ref
      tt_line    = l_line
      tt_date    = tr_hist.tr_date
      tt_effdate = tr_effdate
      tt_desc    = tr_type + " " + string(tr_trnbr) + " " + tr_nbr
      tt_amt     = trgl_gl_amt
      tt_entity  = si_mstr.si_entity.

   for first glt_det
      fields(glt_domain glt_ref glt_line glt_entity)
      where glt_domain = global_domain
      and   glt_ref    = trgl_gl_ref
      and   glt_line   = trgl_dr_line
   no-lock:
      tt_entity = glt_entity.
   end. /* FOR FIRST glt_det */
   if not available glt_det
   then do:
      for first gltr_hist
         fields(gltr_domain gltr_ref gltr_line gltr_entity)
         where gltr_domain = global_domain
         and   gltr_ref    = trgl_gl_ref
         and   gltr_line   = trgl_dr_line
      no-lock:
         tt_entity = gltr_entity.
      end. /* FOR FIRST gltr_hist */
   end. /* IF NOT AVAILABLE glt_det */

   if can-find(last tt_glt
      where tt_ref = trgl_gl_ref)
   then
      l_line = l_line + 1.
   else
      l_line = 1.

   create tt_glt.
   assign
      tt_acc     = trgl_cr_acct
      tt_sub     = trgl_cr_sub
      tt_cc      = trgl_cr_cc
      tt_project = trgl_cr_proj
      tt_ref     = trgl_gl_ref
      tt_line    = l_line
      tt_date    = tr_date
      tt_effdate = tr_effdate
      tt_desc    = tr_type + " " + string(tr_trnbr) + " " + tr_nbr
      tt_amt     = - trgl_gl_amt
      tt_entity  = si_entity.

   for first glt_det
      fields(glt_domain glt_ref glt_line glt_entity)
      where glt_domain = global_domain
      and   glt_ref    = trgl_gl_ref
      and   glt_line   = trgl_cr_line
   no-lock:
      tt_entity = glt_entity.
   end. /* FOR FIRST glt_det */
   if not available glt_det
   then do:
      for first gltr_hist
         fields(gltr_domain gltr_ref gltr_line gltr_entity)
         where gltr_domain = global_domain
         and   gltr_ref    = trgl_gl_ref
         and   gltr_line   = trgl_dr_line
      no-lock:
         tt_entity = gltr_entity.
      end. /* FOR FIRST gltr_hist */
   end. /* IF NOT AVAILABLE glt_det */

END PROCEDURE. /* p_tt_glt_create */

/* PROCEDURE TO DISPLAY THE GL DATA FROM THE TEMP-TABLE */
PROCEDURE p_tt_glt_display:

   define variable l_dr_amt       like glt_amt label "Debit Amount"  no-undo.
   define variable l_cr_amt       like glt_amt label "Credit Amount" no-undo.
   define variable l_nbr_entities as   integer                       no-undo.
   define variable l_tmp_fmt      as   character                     no-undo.

   for first gl_ctrl
      fields(gl_domain gl_rnd_mthd)
      where gl_domain = global_domain
   no-lock:
   end. /* FOR FIRST gl_ctrl */

   FORM /*GUI*/ 
      header
      getTermLabel("GENERAL_LEDGER_DETAIL",34) + " " format "x(35)"
      skip (1)
   with STREAM-IO /*GUI*/  frame jrnl width 132 page-top.

   view frame jrnl.

   l_nbr_entities = 0.

   {&ICTRRP03-P-TAG41}
   FORM /*GUI*/ 
      tt_entity
      tt_acc
      tt_sub
      tt_cc
      tt_project
      tt_date
      tt_effdate
      tt_desc format "x(28)"
      l_dr_amt
      l_cr_amt
   with STREAM-IO /*GUI*/  frame jrnldet width 132 down no-box.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame jrnldet:handle).

   do with frame jrnldet:
      {&ICTRRP03-P-TAG42}

      l_tmp_fmt = l_dr_amt:format.
      {gprun.i ""gpcurfmt.p""
        "(input-output l_tmp_fmt,
          input gl_rnd_mthd)"}
      l_dr_amt:format = l_tmp_fmt.

      l_tmp_fmt = l_cr_amt:format.
      {gprun.i ""gpcurfmt.p""
        "(input-output l_tmp_fmt,
          input gl_rnd_mthd)"}
      l_cr_amt:format = l_tmp_fmt.

      for each tt_glt
         no-lock
         break by tt_entity
               by tt_acc
               by tt_sub
               by tt_cc
               by tt_project
               by tt_effdate
         {&ICTRRP03-P-TAG43}
         with frame jrnldet width 132 down no-box:
         {&ICTRRP03-P-TAG44}

         assign
            l_cr_amt = 0
            l_dr_amt = 0.

         if tt_amt < 0
         then
            l_cr_amt = - tt_amt.
         else
            l_dr_amt = tt_amt.

         {&ICTRRP03-P-TAG45}
         accumulate (l_dr_amt) (total by tt_entity by tt_acc).
         accumulate (l_cr_amt) (total by tt_entity by tt_acc).
         accumulate (l_dr_amt) (total by tt_sub by tt_acc).
         accumulate (l_cr_amt) (total by tt_sub by tt_acc).


         if first-of (tt_entity)
         then
            display tt_entity WITH STREAM-IO /*GUI*/ .

         {&ICTRRP03-P-TAG46}
         if first-of (tt_acc)
         then
            display tt_acc WITH STREAM-IO /*GUI*/ .
         {&ICTRRP03-P-TAG47}

         if first-of (tt_sub)
         then
            display tt_sub WITH STREAM-IO /*GUI*/ .

         if first-of (tt_cc)
         then
            display tt_cc WITH STREAM-IO /*GUI*/ .

         {&ICTRRP03-P-TAG48}
         display
            tt_project
            tt_date
            tt_effdate
            tt_desc WITH STREAM-IO /*GUI*/ .
         {&ICTRRP03-P-TAG49}

         if l_dr_amt <> 0
         then
            display l_dr_amt WITH STREAM-IO /*GUI*/ .

         if l_cr_amt <> 0
         then
            display l_cr_amt WITH STREAM-IO /*GUI*/ .

         down 1.

         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


         if last-of(tt_sub)
         then do:
            underline
               l_dr_amt
               l_cr_amt.
            display
               accum total by tt_sub l_dr_amt @ l_dr_amt
               accum total by tt_sub l_cr_amt @ l_cr_amt WITH STREAM-IO /*GUI*/ .
            down 1.
         end. /* IF LAST-OF(tt_sub) */

         if last-of(tt_acc)
         then do:
            underline
               l_dr_amt
               l_cr_amt.
            display
               accum total by tt_acc l_dr_amt @ l_dr_amt
               accum total by tt_acc l_cr_amt @ l_cr_amt WITH STREAM-IO /*GUI*/ .
            down 1.
         end. /* IF LAST-OF(tt_acc) */

         if last-of(tt_entity)
         then do:
            l_nbr_entities = l_nbr_entities + 1.
            underline
               l_dr_amt
               l_cr_amt.
            display
               accum total by tt_entity l_dr_amt @ l_dr_amt
               accum total by tt_entity l_cr_amt @ l_cr_amt WITH STREAM-IO /*GUI*/ .
            down 1.
         end. /* IF LAST-OF(tt_entity) */

         if last(tt_entity)
            and l_nbr_entities > 1
         then do:
            underline
               l_dr_amt
               l_cr_amt.
            display
               accum total l_dr_amt @ l_dr_amt
               accum total l_cr_amt @ l_cr_amt WITH STREAM-IO /*GUI*/ .
         end. /* IF LAST(tt_entity) .. */
         {&ICTRRP03-P-TAG50}
      end. /* FOR EACH tt_glt */
   end. /* DO WITH FRAME */
END PROCEDURE. /* p_tt_glt_display */
