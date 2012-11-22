/* GUI CONVERTED from chglpst1.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chglpst1.p - GENERAL LEDGER TRANSACTION POST (SECOND PORTION) - CAS       */
/* gltrpst.p - GENERAL LEDGER TRANSACTION POST                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.62.1.5 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 5.0      LAST MODIFIED: 06/27/89   by: jms  *B066*               */
/*                                   07/26/89   by: pml  *B191*               */
/*                                   10/06/89   by: jms  *B330*               */
/*                                   11/13/89   by: jms  *B390*               */
/*                                   01/04/90   by: mlb  *B487*               */
/*                                   01/19/90   by: jms  *B548*               */
/*                                   04/11/90   by: jms  *B657*               */
/* REVISION: 6.0      LAST MODIFIED: 10/15/90   by: jms  *D034*               */
/*                                   10/18/90   by: jms  *D121*               */
/*                                   10/25/90   by: pml  *D140*               */
/*                                   11/06/90   by: jms  *D187*               */
/*                                   02/22/91   by: jms  *D370*               */
/*                                   04/24/91   by: jms  *D584*               */
/*                                   07/23/91   by: jms  *D790*               */
/*                                   08/05/91   by: jms  *D814*               */
/*                                   08/28/91   by: jms  *D838*               */
/*                                   09/27/91   by: jms  *D882*               */
/* REVISION: 7.0      LAST MODIFIED: 01/24/92   by: jms  *F058*               */
/*                                   02/05/92   by: jms  *F166*               */
/*                                   02/11/92   by: jms  *F193*               */
/*                                   02/25/92   by: jms  *F231*               */
/*                                   03/17/92   by: jms  *F286*               */
/*                                   03/17/92   by: jms  *F290*               */
/*                                   03/24/92   by: jms  *F314* (rev only)    */
/*                                   04/14/92   by: jms  *F388*               */
/*                                   04/14/92   by: jms  *F395*               */
/*                                   05/21/92   by: jjs  *F517*               */
/*                                   05/27/92   by: jms  *F538*               */
/*                                   07/20/92   by: jms  *F784*               */
/* REVISION: 7.3      LAST MODIFIED: 08/17/92   by: mpp  *G026*               */
/*                                   12/31/92   by: mpp  *G479*               */
/*                                   02/24/93   by: jms  *G743*               */
/*                                   03/23/93   BY: jms  *G861*               */
/*                                   03/30/93   by: jms  *G883*               */
/*                                   03/30/93   by: jms  *G885*               */
/*                                   06/07/93   by: jms  *GB86*               */
/*                                   06/28/93   by: jms  *GC80*               */
/* REVISION: 7.3      LAST MODIFIED: 07/27/93   by: pcd  *GD75*               */
/*                                   10/12/93   by: jzs  *GG27*               */
/*                                   04/26/94   by: jjs  *FN62*               */
/*                                   05/09/94   by: jjs  *GJ76*               */
/*                                   11/12/94   by: pmf  *FT63*               */
/*                                   03/07/95   by: wjk  *F0LD*               */
/*                                   06/15/95   by: str  *G0N9*               */
/*                                   10/05/95   by: wjk  *G0W3*               */
/* REVISION: 8.5      LAST MODIFIED: 10/18/95   by: ccc  *J053*               */
/*                                   01/04/96   by: mys  *G1J2*               */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh  *K001*               */
/* REVISION: 8.6      LAST MODIFIED: 07/24/96   by: taf  *J115*               */
/* REVISION: 8.6      LAST MODIFIED: 09/16/96   by: pzg  *K00H* Paul Galvin   */
/* REVISION: 8.6      LAST MODIFIED: 09/19/96   by: rxm  *G2F6*               */
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   by: pzg  *K00Q* Paul Galvin   */
/* REVISION: 8.6      LAST MODIFIED: 11/04/96   by: rxm  *H0NS*               */
/* REVISION: 8.6      LAST MODIFIED: 12/04/96   by: ejh  *K01S*               */
/*                                   03/14/97   By: *K07P* E. Hughart         */
/*                                   04/10/97   BY: *K0BF* E. Hughart         */
/*                                   09/24/97   BY: *K0JM* J. Miller          */
/* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *J21F* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *H1HS* Prashanth Narayan  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *L01J* Mansour Kazemi     */
/* REVISION: 8.6E     LAST MODIFIED: 08/03/98   BY: *J2V9* Abbas Hirkani      */
/* REVISION: 8.6E     LAST MODIFIED: 08/03/98   BY: *L05B* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *K1WT* Abbas Hirkani      */
/* REVISION: 8.6E     LAST MODIFIED: 09/09/98   BY: *J2Z4* Abbas Hirkani      */
/* Old ECO marker removed, but no ECO header exists *G1XD*                    */
/* Old ECO marker removed, but no ECO header exists *GN61*                    */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L092* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L09H* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 10/06/98   BY: *L0B7* Brenda Milton      */
/* REVISION: 9.0      LAST MODIFIED: 11/27/98   BY: *J35Q* Santhosh Nair      */
/* REVISION: 9.0      LAST MODIFIED: 01/28/99   BY: *K1Z3* Hemali Desai       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 06/11/99   BY: *J3DN* Abbas Hirkani      */
/* REVISION: 9.1      LAST MODIFIED: 06/15/99   BY: *J3GN* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 07/14/99   BY: *N00D* Adam Harris        */
/* REVISION: 9.1      LAST MODIFIED: 07/29/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *K23T* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DJ* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/05/00   BY: *N0VQ* Mudit Mehta        */
/* REVISION: 9.1CH    LAST MODIFIED: 04/20/01   BY: *XXCH911* Charles Yen    */
/* REVISION: 9.1CH    LAST MODIFIED: 03/20/02   BY: *XXCH912* XinChao Ma     */
/* REVISION: 9.1CH    LAST MODIFIED: 05/20/02   BY: *XXCH913* XinChao Ma     */
/*                    Description for posting rules -                        */
/*                    1) No limitation for type "FX" vouchers; they          */
/*                       will be printed as "account transfer" vouchers      */
/*                    2) For type "JL" vouchers, bank or cash can't be       */
/*                       on the multiple entry side                          */
/*                    3) For other vouchers, bank or cash account can        */
/*                       appear no more than once on each side; multi-       */
/*                       ple appearence of same account will be fine.        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.53     BY: Tony Brooks            DATE: 01/07/02  ECO: *N1B6*  */
/* Revision: 1.54     BY: Ed van de Gevel        DATE: 04/17/02  ECO: *N1GR*  */
/* Revision: 1.57     BY: Deepali Kotavadekar    DATE: 02/03/03  ECO: *N25R*  */
/* Revision: 1.59     BY: Pawel Grzybowski       DATE: 04/01/03  ECO: *P0PN*  */
/* Revision: 1.60     BY: Veena Lad              DATE: 04/15/03  ECO: *N2D0*  */
/* Revision: 1.61     BY: Narathip W.            DATE: 04/23/03  ECO: *P0QD*  */
/* Revision: 1.62     BY: Ed van de Gevel        Date: 05/28/03  ECO: *N252*  */
/* Revision: 1.62.1.1 BY: Dorota Hohol           DATE: 10/17/03  ECO: *P16M*  */
/* Revision: 1.62.1.2 BY: Rajiv Ramaiah          DATE: 10/29/03  ECO: *P17W* */
/* Revision: 1.62.1.3 BY: Ed van de Gevel        DATE: 01/26/04  ECO: *P1F9* */
/* $Revision: 1.62.1.5 $ BY: Deepali Kotavadekar DATE: 05/21/04 ECO: *P200* */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "amy"}
{cxcustom.i "GLTRPST.P"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable al_recno    as recid.
define new shared variable glt_recno   as recid.
define new shared variable totpct      as decimal.
define new shared variable totamt      as decimal.
define new shared variable unb         as logical.
define new shared variable amt         as decimal.
define new shared variable curr_totpct as decimal no-undo.
define new shared variable curr_totamt as decimal no-undo.
define new shared variable curr_amt    as decimal no-undo.

define variable unbmsg             as character format "x(9)".
define variable pl                 like co_pl.
define variable error_msg          like glt_det.glt_error.
define variable v-leave-proc       as logical no-undo.
define variable glname             like en_name.
/*XXCH911* define variable enddt like glt_effdate. */
/*XXCH911* define variable begdt like glt_effdate. */
/*XXCH911*/ def shared var begdt like glt_effdate.
/*XXCH911*/ def shared var enddt like glt_effdate.
define variable peryr              as character.
/*XXCH911* define variable type like glt_tr_type. */
/*XXCH911*/ define shared variable type like glt_tr_type.
define variable linenum            as integer.
define variable post_yn            like mfc_logical initial yes
                                   label "Post Transactions".
define variable zero_line          as logical.
define variable reftot             like glt_amt.
/*XXCH911* define variable entity like en_entity. */
/*XXCH911* define variable entity1 like en_entity. */
/*XXCH911*/ define shared variable entity like en_entity.
/*XXCH911*/ define shared variable entity1 like en_entity.
/*XXCH911*  define variable xamt like glt_amt. */
/*XXCH911*/ define var xamt as decimal format "->,>>>,>>>,>>9.99".
/*XXCH911* define variable desc1 like glt_desc format "x(20)". */
/*XXCH920002* /*XXCH911*/ define variable desc1 like glt_desc format "x(16)". */
/*XXCH920002*/ /*XXCH911*/ define variable desc1 like glt_desc.
/*XXCH911*/ define variable casdesc like glt_desc format "x(20)".
{&GLTRPST-P-TAG17}
/* XXCH911 define variable desc1   like glt_desc format "x(20)". */
{&GLTRPST-P-TAG18}
define variable ent_flag           as logical.
define variable oldentity          like en_entity.
define variable entities_balanced  like co_enty_bal.
/*XXCH920002*  define variable errmsg             like desc1. */
/*XXCH920002*/ define variable errmsg like desc1 format "x(16)".
define variable ref                like glt_ref.
/*XXCH911*/ define shared variable startref like glt_ref.
/*XXCH911*/ define shared variable endref like glt_ref.
/*XXCH911* define variable startref like glt_ref. */
/*XXCH911* define variable endref like glt_ref. */
define variable tr_type            like glt_tr_type.
define variable per                like glcd_per.
define variable yr                 like glcd_year.
define variable maxline            like glt_line.
define variable lineflag           as logical.
define variable pg_number          like co_page_num.
define variable account            as character format "x(22)"
                                   label "Account".
define variable valid_acct         like mfc_logical.
define variable entity_ok          like mfc_logical.
define variable entity_flag        like mfc_logical.
define variable retcode            like co_ret          no-undo.
define variable create_retearn     as logical           no-undo.
define variable gltr_found         like mfc_logical     no-undo.
define variable loop_tot           as integer           no-undo.
define variable oldgltcurr_rndmthd like rnd_rnd_mthd    no-undo.
define variable alloc_flag         like mfc_logical     no-undo.
define variable xamt_old           as character         no-undo.
define variable xamt_base_fmt      as character         no-undo.
define variable xamt_gltc_fmt      as character         no-undo.
define variable gltcurr_rndmthd    like rnd_rnd_mthd    no-undo.
define variable old_gltcurr        like glt_curr        no-undo.
define variable old_acccurr        like ac_curr         no-undo.
define variable gltr_curramt_old   as character         no-undo.
define variable gltr_curramt_fmt   as character         no-undo.
define variable oldsession         as character         no-undo.
define variable mc-error-number    like msg_nbr         no-undo.
define variable second_line        as logical no-undo initial true.
define variable l_lock             like mfc_logical     no-undo.
define variable l_glc_year         like glc_year        no-undo.

/*XXCH911*/ define variable cash_acct_dr as logical.
/*XXCH911*/ define variable cash_acct_cr as logical.
/*XXCH911*/ define variable credits_cnt  as int.
/*XXCH911*/ define variable debits_cnt   as int.
/*XXCH911*/ define variable multi_cr_dr  as logical init no.
/*XXCH911*/ define variable multi_bnc_dr as logical init no.
/*XXCH911*/ define variable multi_bnc_cr as logical init no.
/*XXCH911*/ define variable last_bnc_dr like ac_mstr.ac_code.
/*XXCH911*/ define variable last_bnc_cr like ac_mstr.ac_code.
/*XXCH911*/ define buffer xglh_b for xglh_hist.
/*XXCH911*/ define variable vouch_suffix as int.
/*XXCH911*/ define variable curr_vouch_suffix as int.
/*XXCH911*/ define variable used_vouch as char format "x(11)".
/*XXCH911*/ define variable used_sub_vouch as char format "x(11)".
/*XXCH911*/ define variable used_sub_type as char.
/*XXCH911*/ define variable next_vouch as char format "x(11)".
/*XXCH911*/ define variable next_sub_vouch as char format "x(11)".
/*XXCH911*/ define variable next_sub_type as char.
/*XXCH911*/ define variable casunpost like mfc_logical.
/*XXCH911*/ define variable casunpostmsg as char format "x(9)".
/*XXCH911*/ define variable has_fo as logical.
/*XXCH911*/ define variable has_cb_acct as logical.
/*XXCH911*/ define variable is_coa as logical.
/*XXCH911*/ define variable cb_dr_total as decimal.
/*XXCH911*/ define variable cb_cr_total as decimal.
/*XXCH911*/ define variable use_sub_vchr as logical.
/*XXCH911*/ define variable dr_cr as logical format "Dr/Cr".
/*XXCH911*/ define variable vchr_entity like en_entity.

define temp-table ttacct_val no-undo
   field gl_acct like glt_acct
   field gl_sub like glt_sub
   field gl_cc like glt_cc
   field gl_project like glt_project
   field gl_vail like mfc_logical
index main gl_acct gl_sub gl_cc gl_project.

define new shared temp-table ttglt_det no-undo like glt_det
   index glt_ref glt_domain glt_ref glt_rflag glt_line.
define new shared temp-table ttac_mstr no-undo like ac_mstr.
define new shared temp-table ttal_mstr no-undo like al_mstr.
define new shared workfile w1 like glt_det.

define buffer ttglt_det1 for glt_det.
/*XXCH914*/ define buffer det1 for glt_det.
define buffer det        for glt_det.
define buffer gltdet     for glt_det.
define buffer retearn    for glt_det.
define buffer gltdet1    for glt_det.

/*CF*/ define var cfxamt as decimal format "->,>>>,>>>,>>9.99".
/*CF*/ define var tot_xamt as decimal format "->,>>>,>>>,>>9.99".
/*CF*/ define var cfunpost as logical.
/*CF*/ define variable casacc as char format "x(16)".
/*CF*/ define variable set_ctr like mfc_logical.
/*CF*/ define variable non-cash-bank like mfc_logical.

/* INITIALIZE SETTINGS */
{gprunp.i "gpglvpl" "p" "initialize"}

/* SET CONTROL FOR MESSAGE DISPLAY FROM VALIDATION PROCEDURE */
{gprunp.i "gpglvpl" "p" "set_disp_msgs" "(input false)"}

{&GLTRPST-P-TAG1}

run ip-init
   (output v-leave-proc).

if v-leave-proc then
   leave.

/* Get gl_ctrl.  We know it's avail because ip-init didn't */
/* pass back "v-leave-proc" as TRUE.                       */
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

{&GLTRPST-P-TAG10}

/* FORM */
{&GLTRPST-P-TAG19}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*XXCH911*
   entity  colon 25  entity1  colon 45 label {t001.i}
   begdt   colon 25   enddt   colon 45 label {t001.i}
   type    colon 25
*XXCH911*/
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
dft-daybook colon 25
   post_yn colon 25  skip(1)
with frame a side-labels width 80 attr-space
 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = glname.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&GLTRPST-P-TAG20}
{&GLTRPST-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DEFINE DISPLAY FORM */
{&GLTRPST-P-TAG21}
FORM /*GUI*/ 
   ttglt_det.glt_ref
/*XXCH912*/  space(4)
   ttglt_det.glt_date column-label "Entered!User ID"
   ttglt_det.glt_effdate
   ttglt_det.glt_line format ">>>>9"
/*XXCH911*/             casacc
/*XXCH911*/             casdesc
/* /*CF*/   casacc   */
   account
   ttglt_det.glt_project
   ttglt_det.glt_entity
   desc1
/*XXCH911*/  dr_cr
   {&GLTRPST-P-TAG15}
   xamt
   ttglt_det.glt_curr
   ttglt_det.glt_dy_code
/*XXCH920002*   with down frame b width 132.   */
/*XXCH920002*/  with STREAM-IO /*GUI*/  down frame b width 182.

{&GLTRPST-P-TAG22}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* SET XAMT_BASE_FMT FOR BASE_CURR (WHEN XAMT IS GLT_AMT) ONE TIME. */
/* CAPTURE ORIGINAL FORMAT OF XAMT INTO XAMT_OLD.                   */
assign
   xamt_old      = xamt:format
   xamt_base_fmt = xamt_old.

{gprun.i ""gpcurfmt.p""
   "(input-output xamt_base_fmt,
     input gl_rnd_mthd)"}

for first glc_cal
  fields (glc_start glc_end
          glc_year  glc_per glc_domain)
  where glc_start <= today
  and   glc_end   >= today
  and glc_domain = global_domain
no-lock:
end. /* FOR FIRST glc_cal */

if available glc_cal
then
  l_glc_year = glc_year.

for first glc_cal
   fields (glc_domain glc_start glc_end
          glc_year  glc_per)
   where glc_cal.glc_domain = global_domain
   and   glc_year           = l_glc_year
no-lock:
end. /*FOR FIRST glc_cal */

/*XXCH911*
if available glc_cal
then
  begdt = glc_start.
else
  begdt  = date (1,1,year(today)).

assign
   begdt   = date(1,1,year(today))
   enddt   = today
   entity  = current_entity
   entity1 = current_entity
*XXCH911*/

   /* DETERMINE DEFAULT SESSION FORMAT */
   oldsession    = SESSION:numeric-format.
/*XXCH911*
repeat:

   {&GLTRPST-P-TAG11}

   if entity1 = hi_char then entity1 = "".
*XXCH911*/
   ref = "".
   /* ENTER OPTIONS */
   {&GLTRPST-P-TAG23}
   update
/*XXCH911*
      entity
      entity1
      begdt
      enddt
      type
*XXCH911*/
      dft-daybook when (daybooks-in-use)
      post_yn
   with frame a.
   {&GLTRPST-P-TAG24}

   {&GLTRPST-P-TAG12}

   /* CHECK ENTITY SECURITY */
   bcdparm = "".

   run ip-run-gpquote.

   if entity1 = "" then entity1 = hi_char.
   run ip-glenchk1.
   if not entity_ok then undo, retry.

   if enddt = ? then enddt = today.
   {&GLTRPST-P-TAG25}

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

   run ip-find-page-number.

   /* PRINT HEADERS */
   {glphead1.i}  /* USES CONTINUOUS PAGES */
   {&GLTRPST-P-TAG26}

/*XXCH912*
   assign
      startref = if type = "" then "" else type
      endref   = if type = "" then hi_char else type + hi_char.
*XXCH912*/

/*XXCH912*/ if startref = "" then
/*XXCH912*/        startref = if type = "" then "" else type.
/*XXCH912*/ if endref = hi_char then
/*XXCH912*/        endref   = if type = "" then hi_char else type + hi_char.


   {&GLTRPST-P-TAG3}

   {&GLTRPST-P-TAG45}

   /* Initialize the temp-table */
   run ip-init-tt.

   find det where recid(det) = -1 no-lock no-error.
   repeat:

      find first ttglt_det  where ttglt_det.glt_domain = global_domain and  
      glt_ref > ref no-lock use-index glt_ref no-error .

      if not available(ttglt_det) then leave.

      assign
         l_lock   = no
         loop_tot = 0.

      do transaction:

      /* CYCLE THROUGH TTGLT_DET FILE */
      loopa:
      {&GLTRPST-P-TAG27}
      for each ttglt_det  where ttglt_det.glt_domain = global_domain and  
      glt_ref > ref 
      break by glt_ref  with down frame b
/*XXCH920002*      width 132: */
/*XXCH920002*/     width 182:
      {&GLTRPST-P-TAG28}

         if first-of(glt_ref)
         then do:
            ref = ttglt_det.glt_ref.
            run ip-check-ref-lock (output l_lock).
         end. /* IF FIRST-OF (glt_ref) */

         /* IF A GL REFERENCE IS LOCKED , SKIP ALL LINES */
         /* OF THE REFERENCE                             */
         if l_lock
         then
            next.

         if not first-of(ttglt_det.glt_ref) and entity_flag then next.

         /* IF REVERSING TRANSACTION DETAIL */
         if glt_tr_type = "RV" and glt_rflag then do:

            find first ttglt_det1 where
                       ttglt_det1.glt_ref = ttglt_det.glt_ref and
                   not ttglt_det1.glt_rflag and ttglt_det.glt_domain = global_domain
                               no-lock use-index glt_ref no-error.
            if available ttglt_det1 and (ttglt_det1.glt_effdate > enddt
                                      or ttglt_det1.glt_effdate < begdt)
            then next.

         end.

         if ttglt_det.glt_unb     <> no or
            ttglt_det.glt_error   <> "" or
            ttglt_det.glt_tr_type  = ""
         then
            run ip-upd-flds1.

         if first-of(ttglt_det.glt_ref) then do:

            /* EXCLUDE IF TRANSACTION INCLUDES ENTITIES THAT ARE */
            /* OUTSIDE OF THE ENTITY RANGE                       */
            entity_flag = no.

            find first ttglt_det1 where
                       ttglt_det1.glt_ref = ttglt_det.glt_ref and
                      (ttglt_det1.glt_entity < entity or
                       ttglt_det1.glt_entity > entity1)
                       and ttglt_det1.glt_domain = global_domain                      
            no-lock use-index glt_ref no-error.
            if available ttglt_det1 then do:
               entity_flag = yes.
               next.
            end.

            assign
               reftot    = 0
               unb       = no
               tr_type   = ttglt_det.glt_tr_type
               ent_flag  = no
               oldentity = ttglt_det.glt_entity.

/*CF*/        assign cfunpost = no.

            display
               ttglt_det.glt_ref
               ttglt_det.glt_date
               ttglt_det.glt_dy_code
               {&GLTRPST-P-TAG29}
            with frame b STREAM-IO /*GUI*/ .

            second_line = true.

            /* GET LAST LINE NUMBER */
            do for gltdet:
               find last gltdet
                  where gltdet.glt_ref = ttglt_det.glt_ref
                    and gltdet.glt_rflag = no
                    and gltdet.glt_domain = global_domain
               no-lock use-index glt_ref.
               linenum = gltdet.glt_line.
            end.

         end. /* IF FIRST-OF TTGLT_DET */

         else do:

            if entity_flag then next.

            down 1 with frame b.

            /* DISPLAY THE USER ID ON THE 2ND LINE OF THE           */
            /* TRANSACTION POST. THE USER ID WILL NOT BE DISPLAYED  */
            /* ON SUBSEQUENT LINES.                                 */
            if second_line = true then do:
               display
                  "" @ ttglt_det.glt_ref
                  {&GLTRPST-P-TAG30}
                  ttglt_det.glt_userid @ ttglt_det.glt_date
                  {&GLTRPST-P-TAG31}
               with frame b STREAM-IO /*GUI*/ .
               second_line = false.
            end.

         end. /*ELSE DO OF IF FIRST-OF TTGLT_DET */

         {&GLTRPST-P-TAG32}
         if oldentity <> ttglt_det.glt_entity then
            ent_flag = yes.

         /* MAIN TRANSACTION #1: THIS IS THE FIRST OF TWO MAIN
          * TRANSACTIONS IN THE POST PROGRAM. THIS PERFORMS
          * VALIDATIONS, EXPLODES ALLOCATION CODES, AND
          * ACCUMULATES TOTALS. */
         run ip-validn-checks.

         run ip-explode-verif.
         {&GLTRPST-P-TAG33}

         /* DISPLAY LINE ITEMS FOR STANDARD TRANSACTIONS */
         {&GLTRPST-P-TAG13}

         desc1 = ttglt_det.glt_desc.

         {glacct.i &acc=ttglt_det.glt_acc &sub=ttglt_det.glt_sub
                   &cc=ttglt_det.glt_cc &acct=account}

         if ttglt_det.glt_curr = base_curr then
            assign
               gltcurr_rndmthd =  gl_rnd_mthd
               xamt = ttglt_det.glt_amt
               xamt:format = xamt_base_fmt.

         else do:

            xamt = ttglt_det.glt_curr_amt.

            if ttglt_det.glt_curr <> old_gltcurr
               or (old_gltcurr = "")
            then do:

               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input ttglt_det.glt_curr,
                    output gltcurr_rndmthd,
                    output mc-error-number)"}

               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  pause 0.
                  next.
               end.

               assign
                  old_gltcurr = ttglt_det.glt_curr
                  xamt_gltc_fmt = xamt_old.

               {gprun.i ""gpcurfmt.p""
                  "(input-output xamt_gltc_fmt,
                    input gltcurr_rndmthd)"}

            end.   /* OLD_GLTCURR <>GLT_DET.GLT_CURR */

            xamt:format = xamt_gltc_fmt.

         end.  /* else do */

         if gltcurr_rndmthd <> oldgltcurr_rndmthd then do:

            /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN */
            find rnd_mstr  where rnd_mstr.rnd_domain = global_domain and  
            rnd_rnd_mthd = gltcurr_rndmthd
            no-lock no-error.
            if not available rnd_mstr then do:
               {pxmsg.i &MSGNUM=863 &ERRORLEVEL=3} /* ROUND METHOD NOT FOUND */
               next.
            end.

            assign
               SESSION:numeric-format = if (rnd_dec_pt = ",")
                                        then "European"
                                        else "American"
               oldgltcurr_rndmthd = gltcurr_rndmthd.

         end. /* if gltcurr_rndmtnd <> oldgltcurr_rndmthd */

         /* IF THIS LINE ITEM IS FOR AN ALLOCATION CODE THEN
          * DISPLAY ZERO, SINCE OTHER GLT_DETS WILL BE CREATED
          * TO CONTAIN THE ACTUAL AMOUNTS. */
         if alloc_flag then xamt = 0.
/*XXCH911*/     {chtramt3.i &glamt=xamt
                            &coa=ttglt_det.glt_correction
                            &drcr=dr_cr
                            &dispamt=xamt}
/*XXCH911*/     {chcasacc.i &acc=ttglt_det.glt_acc
                            &sub=ttglt_det.glt_sub
                            &ctr=ttglt_det.glt_cc
                            &casacc=casacc
                            &casdesc=casdesc}

         display
            ttglt_det.glt_effdate
            ttglt_det.glt_line format ">>>>9"
/*XXLY*/    casacc
/*XXLY*/    casdesc
            account
            ttglt_det.glt_project
            ttglt_det.glt_entity
            desc1
/*XXCH911*/ dr_cr
            {&GLTRPST-P-TAG16}
            xamt
            ttglt_det.glt_curr
            ttglt_det.glt_dy_code
         with frame b STREAM-IO /*GUI*/ .

/*CF*/  if casdesc <> "" then do:
/*CF*/     down 1 with frame b.
/*CF*/     display casdesc @ casacc with frame b STREAM-IO /*GUI*/ .
/*CF*/     end.

         /* IF TRANSACTION HAS ONLY 1 LINE WE NEED TO DISPLAY THE  */
         /* THE USER ID ON THE SECOND LINE                         */
         if linenum = 1 then do:
            down 1 with frame b.
            display
               "" @ ttglt_det.glt_ref
               {&GLTRPST-P-TAG34}
               ttglt_det.glt_userid @ ttglt_det.glt_date
               {&GLTRPST-P-TAG35}
            with frame b STREAM-IO /*GUI*/ .
         end.

         if ttglt_det.glt_error <> ""
         then do:
            down 1 with frame b.
            display
               ttglt_det.glt_error @ desc1
            with frame b STREAM-IO /*GUI*/ .

            run ip-upd-error
               (input ttglt_det.glt_error).
         end.

/*CF Add Begin */

         /* DISPLAY CASH FLOW TRANSACTION */

/*XXLY*/    find first xcf_mstr where xcf_ac_code = ttglt_det.glt_acct and ttglt_det.glt_tr_type = "JL"                   
                and ( if xcf_sub <> "*" then ttglt_det.glt_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then ttglt_det.glt_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then ttglt_det.glt_project = xcf_pro else true ) 
                      and xcf_active = yes
                      and xcf_domain = global_domain
                          no-lock no-error.
/*XXLY*/    find first xcf1_mstr where xcf1_mfgc_ac_code =  ttglt_det.glt_acct and 
                     (ttglt_det.glt_ref begins "AP" or ttglt_det.glt_ref begins "AR")
                      and ( if xcf1_mfgc_sub <> "*" then ttglt_det.glt_sub = xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then ttglt_det.glt_cc = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then ttglt_det.glt_project = xcf1_mfgc_pro else true )  
                      and xcf1_active = yes 
                      and xcf1_domain = global_domain
                      no-lock no-error.                          
/*XXLY*/ /* if available xcf_mstr then do:  */
 if ( (available xcf_mstr) or (available xcf1_mstr) ) then do:
    non-cash-bank = no.
    for each gltdet1 where gltdet1.glt_ref = ttglt_det.glt_ref 
    	     and gltdet1.glt_domain = global_domain no-lock:
      find first xcf_mstr where xcf_ac_code = gltdet1.glt_acct and gltdet1.glt_tr_type = "JL"      
/*XXLY*/                and ( if xcf_sub <> "*" then gltdet1.glt_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then gltdet1.glt_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then gltdet1.glt_project = xcf_pro else true )   
                        and xcf_active = yes                   
                      and xcf_domain = global_domain 
                      no-lock no-error.
                      
/*XXLY*/         find first xcf1_mstr where xcf1_mfgc_ac_code =  gltdet1.glt_acct and 
                     (gltdet1.glt_ref begins "AP" or gltdet1.glt_ref begins "AR")
                      and ( if xcf1_mfgc_sub <> "*" then gltdet1.glt_sub = xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then gltdet1.glt_cc = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then gltdet1.glt_project = xcf1_mfgc_pro else true )  
                      and xcf1_active = yes 
                      and xcf1_domain = global_domain
                      no-lock no-error.
                      
/*      if not available xcf_mstr then do:  */
/*XXLY*/      if not ( (available xcf_mstr) or (available xcf1_mstr) ) then do:
         non-cash-bank = yes.
         leave.
      end.
    end.

    if non-cash-bank = yes and not (ttglt_det.glt_ref begins "FX") then do:

        down 1 with frame b.
        display getTermLabel("CASHFLOW", 12) @ casacc WITH STREAM-IO /*GUI*/ .
        down 1 with frame b.
        tot_xamt = 0.
    for each xcft_det where xcft_entity    = ttglt_det.glt_entity
                         and xcft_ref      = ttglt_det.glt_ref
                         and xcft_rflag    = ttglt_det.glt_rflag
                         and xcft_ac_code  = ttglt_det.glt_acct
                         and xcft_sub      = ttglt_det.glt_sub
                         and xcft_cc       = ttglt_det.glt_cc
                         and xcft_pro      = ttglt_det.glt_project
                         and xcft_glt_line = ttglt_det.glt_line
                         and xcft_domain = global_domain
                         no-lock break by xcft_line :
        if ttglt_det.glt_curr = base_curr then
           tot_xamt = tot_xamt + xcft_amt.
        else tot_xamt = tot_xamt + xcft_curr_amt.

        /* GENERATE DR_CR FLAG AND XAMT */
                   {chtramt1.i &glamt=xcft_amt
                               &glcurramt=xcft_curr_amt
                               &coa=ttglt_det.glt_correction
                               &glcurr=ttglt_det.glt_curr
                               &basecurr=base_curr
                               &usecurramt=yes
                               &drcr=dr_cr
                               &dispamt=cfxamt}

        display xcft_line @ ttglt_det.glt_line
                xcft_acct @ casacc
                xcft_desc @ desc1
                ttglt_det.glt_curr
                dr_cr
                cfxamt @ xamt
                with frame b STREAM-IO /*GUI*/ .

        down 1 with frame b.


     end. /* for each xcft_det */

     if ttglt_det.glt_curr = base_curr then
        if ttglt_det.glt_amt <> tot_xamt then cfunpost = yes.
     if ttglt_det.glt_curr <> base_curr then
        if ttglt_det.glt_curr_amt <> tot_xamt then cfunpost = yes.

    end. /*if non-cash-bank = yes then do:*/

 end. /* if available xcf_mstr */

/*CF* Add End */

         /* MAIN TRANSACTION #2: THIS IS THE SECOND OF TWO MAIN
          * TRANSACTIONS IN THE POST PROGRAM. THIS IS PERFORMED
          * WHEN WE'VE LOOKED THROUGH ALL THE LINE ITEMS OF A
          * REFERENCE NUMBER. THIS IS WHERE THE BULK OF THE
          * WORK IS DONE FOR POSTING:
          *
          *    CREATE NEW GLT_DETS FOR ALLOCATED AMOUNTS
          *    ZERO OUT AMOUNTS FOR ORIGINAL ALLOCATION LINES
          *    MORE VALIDATIONS
          *    CREATE GLTR_HIST RECORDS
          *    UPDATE ACD_DET RECORDS
          *    DELETE GLT_DET RECORDS
          */

         if last-of(ttglt_det.glt_ref) then do:
/*XXCH911*/        /* MAINTAIN UNPOSTED VOUCHER EXTENSION */
/*XXCH911*/        {chxgltcr.i &entity=ttglt_det.glt_entity
                               &ref=ttglt_det.glt_ref
                               &rflag=ttglt_det.glt_rflag
                               &trtype=ttglt_det.glt_tr_type
                               &userid=ttglt_det.glt_userid
                               &refresh=no}
/*XXCH914*
/*XXCH911*/        /* DETERMINE VOUCHER AND SUB VOUCHER NUMBER TO BE USED */
/*XXCH911*/        {chvchno.i}
*XXCH914*/


            down 1 with frame b.

            /* PUT ANY ALLOCATIONS IN GLT_DET */
            for each w1  where w1.glt_domain = global_domain and  w1.glt_ref = 
            ref with frame b:

               run ip-create-det.

               if det.glt_tr_type = "RA" then do:
                  create_retearn = no.
                  run ip-create-retearn.
               end.

               /* DISPLAY ALLOCATIONS */
               {&GLTRPST-P-TAG36}
               desc1 = det.glt_desc.
               {glacct.i &acc=det.glt_acc &sub=det.glt_sub
                  &cc=det.glt_cc &acct=account}

               if det.glt_curr = base_curr then
               assign
                  xamt = det.glt_amt
                  xamt:format = xamt_base_fmt.

               else do:

                  xamt = det.glt_curr_amt.

                  if det.glt_curr <> old_gltcurr
                     or (old_gltcurr = "")
                  then do:

                     /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                     {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                        "(input det.glt_curr,
                          output gltcurr_rndmthd,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        pause.
                        next.
                     end.

                     /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN */
                     find rnd_mstr  where rnd_mstr.rnd_domain = global_domain 
                     and  rnd_rnd_mthd = gltcurr_rndmthd
                     no-lock no-error.
                     if not available rnd_mstr then do:
                        /* ROUND METHOD RECORD NOT FOUND */
                        {pxmsg.i &MSGNUM=863 &ERRORLEVEL=3}
                        next.
                     end.

                     assign
                        SESSION:numeric-format = if (rnd_dec_pt = ",")
                                                 then "European"
                                                 else "American"
                        old_gltcurr = det.glt_curr
                        xamt_gltc_fmt = xamt_old.

                     {gprun.i ""gpcurfmt.p""
                        "(input-output xamt_gltc_fmt,
                          input gltcurr_rndmthd)"}

                  end.   /* OLD_GLTCURR <> DET.GLT_CURR */

                  xamt:format = xamt_gltc_fmt.

               end.  /* else do */

               run ip-display
                  (input det.glt_effdate,
                   input det.glt_line,
                   input det.glt_project,
                   input det.glt_entity,
                   input det.glt_curr,
                   input det.glt_dy_code,
                   input det.glt_error).

               if det.glt_tr_type = "RA"
                  and create_retearn
                  and available retearn
               then do:

                  {&GLTRPST-P-TAG37}
                  assign
                     desc1 = retearn.glt_desc
                     account = retearn.glt_acc.

                  run ip-display
                      (input retearn.glt_effdate,
                       input retearn.glt_line,
                       input retearn.glt_project,
                       input retearn.glt_entity,
                       input retearn.glt_curr,
                       input retearn.glt_dy_code,
                       input retearn.glt_error).

               end.

            end.  /* for each w1 */

/*XXCH911*/     /* CHECK IF IT IS AN ILLEGAL CAS VOUCHER */
/*XXCH911*/     {chckvchr.i &ref=ref}

            /* CHECK FOR UNBALANCED CONDITION */
            assign
               unbmsg = ""
               errmsg = "".

            if reftot <> 0
            then
               unb = yes.

/*XXCH911*/     if multi_cr_dr then assign unb = yes.

/*XXCH911*/     /* GET CAS RELATED UNPOSTABLE VOUCHER MESSAGES */
/*XXCH911*/     {chvchrms.i &casunpost =casunpost &casunpostmsg=casunpostmsg}
/*XXCH911*/     if casunpost = yes then unb = yes.
/*CF*/          if cfunpost = yes then unb = yes.

/*P2QX* DELETE BEGIN*
            if unb = yes then do:
               unbmsg = getTermLabel("UNPOSTED",9).
/*XXCH911*/        if casunpost then unbmsg = casunpostmsg.
               for each det where det.glt_ref = ref and det.glt_domain = global_domain use-index det.glt_ref:
                  det.glt_unb = yes.
                  if reftot <> 0 and det.glt_error = "" then
                     assign
                        errmsg = getTermLabel("UNBALANCED",16)
                        det.glt_error = getTermLabel("UNBALANCED",16).
               end.
            end.
**P2QX* DELETE END */

            if entities_balanced and ent_flag then do:

               for each det where det.glt_ref = ref and det.glt_domain = global_domain
               no-lock use-index glt_ref break by det.glt_entity:

                  find ttac_mstr where ac_code = det.glt_acc and ac_domain = global_domain
                  no-lock use-index ac_code no-error.

                  if not available ttac_mstr then do:
                     if not can-find(ttal_mstr where al_code = det.glt_acc)
                     then
                        accumulate det.glt_amt (total by det.glt_entity).
                  end. /* IF NOT AVAILABLE ttac_mstr */

                  else
                  if ac_type <> "M" and ac_type <> "S" and
                     not det.glt_rflag
                  then
                     accumulate det.glt_amt (total by det.glt_entity).

                  if last-of(det.glt_entity) then do:
                     if (accum total by det.glt_entity det.glt_amt) <> 0
                     then
                        unb = yes.
                  end.  /* if last-of(det.glt_entity) */

               end.  /* for each det */

               if unb then
               for each det where det.glt_domain = global_domain and  
               det.glt_ref = ref use-index glt_ref:

                  det.glt_unb = yes.

                  if det.glt_error = "" then
                     det.glt_error = getTermLabel("UNB_ENTITIES",16).

                  errmsg = getTermLabel("UNB_ENTITIES",16).

               end.

            end.  /* if entities_balanced and ent_flag */

            unbmsg = "".
            if unb then
               unbmsg = getTermLabel("UNPOSTED",9).
/*XXCH911*/     if casunpost then unbmsg = casunpostmsg.
/*CF*/     if cfunpost then unbmsg = getTermLabel("CASHFLOW_UNBALANCED", 9).

            /* CHECK POSTED TRANSACTIONS FOR SAME REFERENCE */
            assign gltr_found = can-find(first gltr_hist  where 
            gltr_hist.gltr_domain = global_domain and 
                                               gltr_ref = ref).
            if gltr_found then do:
               /* REFERENCE ALREADY IN USE BY A POSTED TRANSACTION */
               {pxmsg.i &MSGNUM=3066 &ERRORLEVEL=4 &MSGARG1=ref}
               unbmsg = getTermLabel("UNPOSTED",9).
            end.

            if unb
            then do:
               unbmsg = getTermLabel("UNPOSTED",9).
               for each det where det.glt_domain = global_domain
                  and   det.glt_ref    = ref use-index glt_ref:
                  det.glt_unb = yes.
                  if reftot <> 0
                     and det.glt_error = ""
                  then
                     assign
                        errmsg        = getTermLabel("UNBALANCED",16)
                        det.glt_error = getTermLabel("UNBALANCED",16).
               end. /* FOR EACH det */
            end. /* IF unb */

/*            if not unb
            then do:
*/
               /* POST TRANSACTIONS IF REQUESTED */
               for each det where det.glt_ref = ref and det.glt_domain = global_domain
                exclusive-lock use-index glt_ref
/*XXCH911*/     break by det.glt_ref:

                  /* IF ACCT IS AN ALLOCATION CODE THEN SET
                   * AMOUNT FIELDS TO ZERO SINCE ALLOCATION
                   * HAS ALREADY BEEN EXPLODED TO CORRECT
                   * ACCOUNTS (EVEN IF POST=NO) */
                  if can-find(ttal_mstr where al_code = det.glt_acc and al_domain = global_domain)
                  then
                  assign
                        det.glt_amt      = 0
                        det.glt_curr_amt = 0
                        det.glt_ecur_amt = 0.

                  /* IF THIS IS A REAL POSTING (POST=YES) AND      */
                  /* NOT DUPLICATE REFERENCE IN GLTR_HIST AND      */
                  /* TRANSACTION IS BALANCED THEN DO:              */
                  /* 1) CREATE GLTR_HIST (POSTED TRANNSACTION)     */
                  /* 2) CREATE ACD_DETS  (ACCT BALANCE INFO)       */
                  /* 3) DELETE GLT_DETS  (UNPOSTED TRANSACTION)    */
                  if post_yn
                  and not gltr_found
                  and not unb
                  then do:

                     {&GLTRPST-P-TAG4}

/*XXCH914*/        /* DETERMINE VOUCHER AND SUB VOUCHER NUMBER TO BE USED */
/*XXCH914*/    if first-of(det.glt_ref) then do:
/*XXCH914*/        {chvchno.i}
/*XXCH914*/    end.

                     run ip-create-hist.

                     /* Get Period/Year */
                     {glper1.i det.glt_effdate peryr}

                     find acd_det where
                          acd_acc = det.glt_acc and
                          acd_sub = det.glt_sub and
                          acd_cc = det.glt_cc and
                          acd_entity = det.glt_entity and
                          acd_project = det.glt_project and
                          acd_year = glc_year and acd_per = glc_per
                          and acd_domain = global_domain
                     exclusive-lock use-index acd_index no-error.

                     /* POST TO PERIOD TOTALS */
                     if not available acd_det then
                        run ip-post-period-totals.

                     run ip-accum-acd.

                     run ip-update-acd-curr.

                     acd_ecur_amt = acd_ecur_amt + det.glt_ecur_amt.

                     /* CREATE ACCT/SUB/CC COMBINATION IF NECESSARY */
                     {&GLTRPST-P-TAG49}
                     run ip-create-combo.
                     {&GLTRPST-P-TAG50}

                     /* DELETE GLT_DET RECORD */
                     {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input det.glt_exru_seq)"}
                     {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input det.glt_en_exru_seq)"}

/*XXCH911*/           /* DELETE UNPOSTED VOUCHER EXTENSION */
/*XXCH911*/           {chxgltde.i &ref=det.glt_ref &rflag=det.glt_rflag}

                     delete det.
                     assign loop_tot = loop_tot + 1.

                  end. /* IF POST = "YES" */
               end. /* FOR EACH DET */
/*            end. /* IF NOT unb */  */

            /* PRINT TOTAL LINE */
            underline xamt.

            xamt:format = xamt_base_fmt.

            display
               errmsg @ desc1
               reftot @ xamt
               base_curr @ ttglt_det.glt_curr
               unbmsg    @ ttglt_det.glt_dy_code
            with frame b STREAM-IO /*GUI*/ .

            down 2 with frame b.

         end. /* IF LAST-OF  */

         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         if loop_tot > 1000 then leave.

      end. /* LOOPA: FOR EACH tt_glt_det */

      end. /* do transaction */
   end. /* repeat */

   {&GLTRPST-P-TAG5}

   /* DELETE WORKFILE */
   run ip-delete-workfile.

   run ip-update-page.

   /*  REPORT TRAILER  */
   {mfrtrail.i}

/*XXCH911* end. */
/*XXCH911*/ hide frame a.

/* RESTORE CURRENCY DEPENDENT ROUNDING SESSION VARIABLE */
SESSION:numeric-format = oldsession.
{&GLTRPST-P-TAG6}

/*-----------------------------------------------------------------*/
PROCEDURE ip-accum-acd:

   if (det.glt_amt > 0 and det.glt_correction = no)
   or (det.glt_amt < 0 and det.glt_correction = yes)
   then
      assign
         acd_det.acd_amt = acd_amt + det.glt_amt
         acd_dr_amt = acd_dr_amt + det.glt_amt.
   else if (det.glt_amt < 0 and det.glt_correction = no)
        or (det.glt_amt > 0 and det.glt_correction = yes)
   then
      assign
         acd_amt = acd_amt + det.glt_amt
         acd_cr_amt= acd_cr_amt + det.glt_amt.

END PROCEDURE. /* ip-accum-acd */

/*-----------------------------------------------------------------*/
PROCEDURE ip-accum-acd-curr:

   acd_det.acd_curr_amt = acd_curr_amt + det.glt_curr_amt.

   if (det.glt_amt > 0 and det.glt_correction = no) or
      (det.glt_amt < 0 and det.glt_correction = yes)
   then
      assign
         acd_dr_curr_amt = acd_dr_curr_amt +
         det.glt_curr_amt.

   else if (det.glt_amt < 0 and det.glt_correction = no) or
           (det.glt_amt > 0 and det.glt_correction = yes)
   then
      assign
         acd_cr_curr_amt = acd_cr_curr_amt + det.glt_curr_amt.

END PROCEDURE. /* ip-accum-acd-curr */

/*-----------------------------------------------------------------*/
PROCEDURE ip-create-hist:

   {&GLTRPST-P-TAG7}

   create gltr_hist. gltr_hist.gltr_domain = global_domain.
   assign
      gltr_entity      = det.glt_entity
      gltr_ref         = det.glt_ref
      gltr_rflag       = det.glt_rflag
      gltr_line        = det.glt_line
      gltr_tr_type     = det.glt_tr_type
      gltr_acc         = det.glt_acct
      gltr_sub         = det.glt_sub
      gltr_ctr         = det.glt_cc
      gltr_project     = det.glt_project
      gltr_eff_dt      = det.glt_effdate
      gltr_ent_dt      = det.glt_date
      gltr_amt         = det.glt_amt
      gltr_desc        = det.glt_desc
      gltr_user        = det.glt_userid
      gltr_unb         = no
      gltr_error       = det.glt_error
      gltr_batch       = det.glt_batch
      gltr_curramt     = det.glt_curr_amt
      gltr_ex_rate     = det.glt_ex_rate
      gltr_ex_rate2    = det.glt_ex_rate2
      gltr_ex_ratetype = det.glt_ex_ratetype
      gltr_addr        = det.glt_addr
      gltr_doc         = det.glt_doc
      gltr_doc_typ     = det.glt_doc_type
      gltr_user1       = det.glt_user1
      gltr_user2       = det.glt_user2
      {&GLTRPST-P-TAG14}
      gltr__qadc01     = det.glt__qadc01
      gltr_curr        = det.glt_curr
      gltr_correction  = det.glt_correction
      gltr_dy_code     = det.glt_dy_code
      gltr_dy_num      = det.glt_dy_num
      gltr_ecur_amt    = det.glt_ecur_amt
      gltr_en_exrate   = det.glt_en_exrate
      gltr_en_exrate2  = det.glt_en_exrate2.

/*XXCH911*/  /* CREATE CAS POSTED VOUCHER EXTENSION */
/*XXCH*
/*XXCH913*/     /* EXCLUDE RV and RA VOUCHER */
/*XXCH913*/     if det.glt_rflag = no then do:
*XXCH*/
/*XXCH911*/  {chxglhcr.i &entity=det.glt_entity
                         &ref=det.glt_ref
                         &rflag=det.glt_rflag
                         &year=string(year(gltr_eff_dt),""9999"")
                         &period=string(month(gltr_eff_dt),""99"")
                         &vouch=next_vouch
                         &subtype=next_sub_type
                         &subvouch=next_sub_vouch}
/*XXCH*
 /*XXCH913*/    end.
*XXCH*/
/*CF*/      /* CREATE POSTED CASH FLOW TRANSACTION */
 
 {chcftrcr.i &entity=det.glt_entity
             &ref=det.glt_ref
             &rflag=det.glt_rflag
             &acc=det.glt_acct
             &sub=det.glt_sub
             &cc=det.glt_cc
             &project=det.glt_project
             &line=det.glt_line
             &currency=det.glt_curr}

   {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
      "(input det.glt_exru_seq,
        output gltr_exru_seq)"}

   if det.glt_exru_seq = det.glt_en_exru_seq then
      gltr_en_exru_seq = gltr_exru_seq.
   else do:
      {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
         "(input det.glt_en_exru_seq,
           output gltr_en_exru_seq)"}
   end.

   {&GLTRPST-P-TAG38}
   find ttac_mstr  where ttac_mstr.ac_domain = global_domain and  ac_code = 
   gltr_acc
   no-lock no-error.

   if available ttac_mstr then do:

      {&GLTRPST-P-TAG8}

      gltr_fx_ind = ac_fx_index.

      /* THE TRANSACTION WAS DONE IN BASE CURRENCY  */
      /* TO A FOREIGN CURRENCY ACCOUNT              */
      if gltr_ex_rate = 1
         and gltr_ex_rate2 = 1
         and gltr_curr = base_curr
         and gltr_tr_type <> "FX"
         and ac_curr <> base_curr
      then do:

         /* GET EXCHANGE RATE */
         {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
            "(input ac_curr,
              input base_curr,
              input gltr_ex_ratetype,
              input gltr_eff_dt,
              output gltr_ex_rate,
              output gltr_ex_rate2,
              output gltr_exru_seq,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input gltr_curr,
              input gltr_ex_rate2,
              input gltr_ex_rate,
              input gltr_amt,
              input true, /* ROUND */
              output gltr_curramt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         if ac_curr <> old_acccurr
            or (old_acccurr = "")
         then
            old_acccurr = ac_curr.

         /* INSURE THAT THE CURRENCY AMOUNT */
         /* WILL BE STORED IN THE ACD_DET.  */
         det.glt_curr_amt = gltr_curramt.

      end.

   end.

   release gltr_hist.

END PROCEDURE. /* ip-create-hist */

/*-----------------------------------------------------------------*/
PROCEDURE ip-run-gpquote:
   /* WHEN DAYBOOKS ARE IN USE, NUMBER OF ACTIVE INPUT PARAMETERS */
   /* ARE 7 AND DFT-DAYBOOK IS PASSED AS EIGTH PARAMETER.         */
   /* WHEN DAYBOOKS ARE NOT IN USE, NUMBER OF ACTIVE INPUT        */
   /* PARAMETERS ARE 6 AND DFT-DAYBOOK IS NOT PASSED.             */

   if daybooks-in-use
   then do:
      {&GLTRPST-P-TAG39}
      {gprun.i ""gpquote.p""
         "(input-output bcdparm,
           7,
           entity,
           entity1,
           string(begdt),
           string(enddt),
           type,
           dft-daybook,
           string(post_yn),
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char)"}
      {&GLTRPST-P-TAG40}
   end. /* IF DAYBOOKS-IN-USE */

   else do:
      {&GLTRPST-P-TAG41}
      {gprun.i ""gpquote.p""
         "(input-output bcdparm,
           6,
           entity,
           entity1,
           string(begdt),
           string(enddt),
           type,
           string(post_yn),
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char,
           null_char)"}
      {&GLTRPST-P-TAG42}
   end. /* ELSE DO */

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-update-page:

   /* UPDATE PAGE NUMBER TO LAST PAGE NUMBER OF REPORT */
   do transaction:

      find first co_ctrl where co_ctrl.co_domain = global_domain .

      if co_cont_page and post_yn then do:
         if co_enty_bal and entity = entity1 then do:
            find en_mstr  where en_mstr.en_domain = global_domain and  
            en_entity = entity.
            if available en_mstr then
               en_page_num = pg_number + page-number.
            release en_mstr.
         end.
         else
            co_page_num = pg_number + page-number.
      end.

      release co_ctrl.

   end.

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-delete-workfile:

   for each w1  where w1.glt_domain = global_domain exclusive-lock:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input w1.glt_exru_seq)"}
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input w1.glt_en_exru_seq)"}
      delete w1.
   end.

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-find-page-number:

   /* FIND PAGE NUMBER THAT LAST REPORT ENDED WITH */
   pg_number = 0.

   find first co_ctrl where co_domain = global_domain no-lock.

   if co_cont_page then do:
      if co_enty_bal and entity = entity1 then do:
         find en_mstr where en_entity = entity and en_domain = global_domain no-lock no-error.
         if available en_mstr then pg_number = en_page_num.
         release en_mstr.
      end.
      else
         pg_number = co_page_num.
   end.

   release en_mstr.

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-init:
   define output parameter v-leave-proc as logical no-undo.

   v-leave-proc = no.

   /* GET ENTITIES BALANCED OPTION */
   find first co_ctrl where co_domain = global_domain  no-lock no-error.

   if not available co_ctrl then do:
      /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT */
      {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
      if not batchrun then pause.
      v-leave-proc = yes.
      return.
   end. /* if not avail co_ctrl */

   assign
      entities_balanced = co_enty_bal
      retcode           = co_ret
      pl                = co_pl.

   release co_ctrl.

   /* GET NAME OF PRIMARY ENTITY */
   find en_mstr where en_entity = current_entity and en_domain = global_domain 
            no-lock no-error.
   if not available en_mstr then do:
      {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
      pause.
      v-leave-proc = yes.
      return.
   end. /* if not avail en_mstr */

   glname = en_name.
   release en_mstr.

END PROCEDURE. /* procedure ip-init */

/*-----------------------------------------------------------------*/
PROCEDURE ip-glenchk1:

   {glenchk1.i &entity=entity &entity1=entity1 &entity_ok=entity_ok}

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-create-det:

   create det. det.glt_domain = global_domain.
   assign
      det.glt_entity      = w1.glt_entity
      det.glt_ref         = w1.glt_ref
      det.glt_tr_type     = w1.glt_tr_type
      det.glt_acc         = w1.glt_acct
      det.glt_sub         = w1.glt_sub
      det.glt_cc          = w1.glt_cc
      det.glt_project     = w1.glt_project
      det.glt_effdate     = w1.glt_effdate
      det.glt_date        = w1.glt_date
      det.glt_amt         = w1.glt_amt
      det.glt_desc        = w1.glt_desc
      det.glt_userid      = w1.glt_userid
      det.glt_unb         = w1.glt_unb
      det.glt_error       = w1.glt_error
      det.glt_batch       = w1.glt_batch
      det.glt_curr_amt    = w1.glt_curr_amt
      det.glt_ex_rate     = w1.glt_ex_rate
      det.glt_ex_rate2    = w1.glt_ex_rate2
      det.glt_ex_ratetype = w1.glt_ex_ratetype
      det.glt_addr        = w1.glt_addr
      det.glt_doc_type    = w1.glt_doc_type
      det.glt_doc         = w1.glt_doc
      det.glt_user1       = w1.glt_user1
      det.glt_user2       = w1.glt_user2
      det.glt__qadc01     = w1.glt__qadc01
      det.glt_rflag       = w1.glt_rflag
      det.glt_correction  = w1.glt_correction
      det.glt_dy_code     = w1.glt_dy_code
      det.glt_dy_num      = w1.glt_dy_num
      det.glt_curr        = w1.glt_curr.

   {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
      "(input w1.glt_exru_seq,
        output det.glt_exru_seq)"}

   assign
      linenum = linenum + 1
      det.glt_line = linenum.

   create ttglt_det. ttglt_det.glt_domain = global_domain.
   buffer-copy det to ttglt_det.
   ttglt_det.glt_domain = global_domain.

   if not det.glt_rflag then reftot = reftot + det.glt_amt.

END PROCEDURE. /* ip-create-det */

/*-----------------------------------------------------------------*/
PROCEDURE ip-display:

   define input parameter p-effdate like glt_det.glt_effdate no-undo.
   define input parameter p-line    like glt_det.glt_line    no-undo.
   define input parameter p-project like glt_det.glt_project no-undo.
   define input parameter p-entity  like glt_det.glt_entity  no-undo.
   define input parameter p-curr    like glt_det.glt_curr    no-undo.
   define input parameter p-dycode  like glt_det.glt_dy_code no-undo.
   define input parameter p-error   like glt_det.glt_error   no-undo.

   display
      p-effdate @ ttglt_det.glt_effdate
      p-line    @ ttglt_det.glt_line format ">>>>9"
      account
      p-project @ ttglt_det.glt_project
      p-entity  @ ttglt_det.glt_entity
      desc1
      xamt
      p-curr    @ ttglt_det.glt_curr
      p-dycode  @ ttglt_det.glt_dy_code
   with frame b STREAM-IO /*GUI*/ .

   if p-error <> "" then do:
      down 1 with frame b.
      display p-error @ desc1 with frame b STREAM-IO /*GUI*/ .
   end.

   down 1 with frame b.

END PROCEDURE. /* ip-display */

/*-----------------------------------------------------------------*/
PROCEDURE ip-create-retearn:
   /* CREATE RETAINED EARNINGS OFFSET FOR ACCTS CREATED BY EXPLODING
      ALLOCATION CODE */
   find ttac_mstr  where ttac_mstr.ac_domain = global_domain and  ac_code = 
   det.glt_acc no-lock no-error.

   if available ttac_mstr and ac_type <> "I" and ac_type <> "E" then
      return.

   else do:

      create_retearn = yes.

      /* GET DATE OF LAST DAY OF FISCAL YEAR */
      if substring(peryr,2,1) = "/" then
         find last glc_cal
            where glc_year = integer(substring(peryr,3,4))
            and glc_domain = global_domain
         no-lock.
      else
         find last glc_cal
            where glc_year = integer(substring(peryr,4,4))
            and glc_domain = global_domain
         no-lock.

      create retearn. retearn.glt_domain = global_domain.
      assign
         retearn.glt_desc        = getTermLabel("RETROACTIVE_ADJUSTMENT",24)
         retearn.glt_entity      = det.glt_entity
         retearn.glt_ref         = det.glt_ref
         retearn.glt_tr_type     = det.glt_tr_type
         retearn.glt_date        = det.glt_date
         retearn.glt_effdate     = glc_end
         retearn.glt_line        = det.glt_line
         retearn.glt_rflag       = true
         retearn.glt_userid      = det.glt_userid
         retearn.glt_acc         = retcode
         retearn.glt_amt         = det.glt_amt
         retearn.glt_curr        = det.glt_curr
         retearn.glt_curr_amt    = det.glt_curr_amt
         retearn.glt_ex_rate     = det.glt_ex_rate
         retearn.glt_ex_rate2    = det.glt_ex_rate2
         retearn.glt_ex_ratetype = det.glt_ex_ratetype
         retearn.glt_unb         = no
         retearn.glt_batch       = det.glt_batch
         retearn.glt_doc         = ""
         retearn.glt_doc_type    = det.glt_doc_type
         retearn.glt_addr        = det.glt_addr
         retearn.glt_user1       = det.glt_user1
         retearn.glt_user2       = det.glt_user2
         retearn.glt__qadc01     = det.glt__qadc01.

      {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
         "(input det.glt_exru_seq,
           output retearn.glt_exru_seq)"}

      create ttglt_det. ttglt_det.glt_domain = global_domain.
      buffer-copy retearn to ttglt_det.
      ttglt_det.glt_domain = global_domain.

   end.

END PROCEDURE. /* ip-create-retearn */

/*-----------------------------------------------------------------*/
PROCEDURE ip-validn-checks:

   /* CHECK FOR VALID PERIOD */
   {glper.i ttglt_det.glt_effdate peryr ttglt_det.glt_entity}

   if peryr = "" then
      assign
         ttglt_det.glt_error = getTermLabel("INVALID_PERIOD",16)
         unb = yes.

   else do:

      {&GLTRPST-P-TAG46}
      if (glcd_yr_clsd and ttglt_det.glt_tr_type <> "RA") or
         (glcd_gl_clsd and ttglt_det.glt_tr_type <> "RA") or
         (glcd_closed and
         lookup(ttglt_det.glt_tr_type, "JL,RV,RA,FX,XX,XY,YA") = 0)
      {&GLTRPST-P-TAG52}
      then
         assign
            ttglt_det.glt_error = getTermLabel("CLOSED_PERIOD",16)
            unb = yes.

      assign
         yr = glcd_year
         per = glcd_per.

   end.

   /* CHECK FOR VALID ENTITY */
   if not can-find(en_mstr where en_entity = ttglt_det.glt_entity
                  and en_domain = global_domain)
   then
      assign
         ttglt_det.glt_error = getTermLabel("INVALID_ENTITY",16)
         unb = yes.

   /* CHECK FOR VALID DAYBOOK ENTRY NUMBER */
   if daybooks-in-use and ttglt_det.glt_dy_code > "" and
      (ttglt_det.glt_dy_num = "" or ttglt_det.glt_dy_num = ?)
   then
      assign
         ttglt_det.glt_error = getTermLabel("INVALID_DAYBOOK",16)
         unb = yes.

END PROCEDURE. /* ip-validn-checks */

/*-----------------------------------------------------------------*/
PROCEDURE ip-create-combo:
   {&GLTRPST-P-TAG47}
   /* CREATE ACCT/SUB/CC COMBINATION IF NECESSARY */
   find ttac_mstr where ac_code = det.glt_acc and ac_domain = global_domain
   no-lock no-error.

   if available ttac_mstr then do:

      find asc_mstr where asc_acc = det.glt_acc and
                          asc_sub = det.glt_sub and
                          asc_cc  = det.glt_cc
                          and asc_domain = global_domain
      no-lock use-index asc_index no-error.

      if not available asc_mstr then do:

         create asc_mstr. asc_mstr.asc_domain = global_domain.
         assign
            asc_acc  = det.glt_acc
            asc_sub  = det.glt_sub
            asc_cc   = det.glt_cc
            asc_fpos = ac_fpos.

      end.

   end.
   {&GLTRPST-P-TAG48}
END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-post-period-totals:

   create acd_det. acd_det.acd_domain = global_domain.
   assign
      acd_acc = det.glt_acc
      acd_sub = det.glt_sub
      acd_cc = det.glt_cc
      acd_entity = det.glt_entity
      acd_project = det.glt_project
      acd_year = glc_cal.glc_year
      acd_per = glc_cal.glc_per.

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-explode-verif:

   /* EXPLODE ALLOCATION CODE AMOUNTS IF NECESSARY */
   alloc_flag = false.

   find ttal_mstr where al_code = ttglt_det.glt_acc 
          and al_domain = global_domain no-lock no-error.

   if available ttal_mstr then do:

      assign
         alloc_flag = true
         ttglt_det.glt_error = "".

      if ttglt_det.glt_amt <> 0 then do:

         assign
            totpct      = 0
            totamt      = 0
            al_recno    = recid(ttal_mstr)
            glt_recno   = recid(ttglt_det)
            amt         = ttglt_det.glt_amt
            curr_totpct = 0
            curr_totamt = 0
            curr_amt    = ttglt_det.glt_curr_amt.

         {gprun.i ""gltrpsta.p""}

         ttglt_det.glt_error = "".

      end. /* if ttglt_det.glt_amt <> 0 */

   end. /* if available ttal_mstr */

   /* VERIFY ACCOUNT INFORMATION */
   else do:

      if ttglt_det.glt_error = "" then do:
         run ip-gltrpstb
            (output error_msg).
         ttglt_det.glt_error = error_msg.
      end. /* IF GLT_ERRR = "" */

      /* VALIDATE CURRENCY AMOUNT FOR "?" */
      if ttglt_det.glt_curr_amt  = ?
         and ttglt_det.glt_error = ""
      then do:
         assign
            ttglt_det.glt_error = getTermLabel("INVALID_CURR_AMT",16) + " (?)"
            unb                 = yes.
      end. /* IF glt_curr_amt = ? ... */

      if unb then
         reftot = reftot + ttglt_det.glt_amt.
      else do:
         find ttac_mstr  where ttac_mstr.ac_domain = global_domain and  ac_code 
         = ttglt_det.glt_acc
         no-lock no-error.
         if ac_type <> "S" and ac_type <> "M" and
            not ttglt_det.glt_rflag
         then
            reftot = reftot + ttglt_det.glt_amt.
      end.
   end. /* VERIFY ACCOUNT INFORMATION (ELSE DO) */

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-update-acd-curr:

   for first en_mstr
   fields (en_entity en_curr)
   where en_entity = det.glt_entity
         and en_domain  = global_domain
   no-lock: end.

   if available ttac_mstr and
      (ttac_mstr.ac_curr <> base_curr or
       en_curr <> base_curr or
       det.glt_tr_type = "XX")
   then
      run ip-accum-acd-curr.

   release en_mstr.

END PROCEDURE. /* ip-update-acd-curr */

{&GLTRPST-P-TAG9}

/*-----------------------------------------------------------------*/
PROCEDURE ip-init-tt:
   /* Clear temp tables                    */
   empty temp-table ttglt_det no-error.
   empty temp-table ttac_mstr no-error.
   empty temp-table ttal_mstr no-error.

   {&GLTRPST-P-TAG43}
   for each glt_det where
            glt_det.glt_entity >= entity  and
            glt_det.glt_entity <= entity1 and
            glt_det.glt_effdate >= begdt  and
            (glt_det.glt_effdate <= enddt or
             (glt_det.glt_tr_type = "RV"  and
              glt_det.glt_rflag = yes))   and
            glt_det.glt_ref >= startref   and
            glt_det.glt_ref <= endref     and
           (glt_det.glt_dy_code = dft-daybook or dft-daybook = "")
           and glt_det.glt_domain = global_domain
   no-lock use-index glt_ref:
      {&GLTRPST-P-TAG44}
      create ttglt_det. ttglt_det.glt_domain = global_domain.
      buffer-copy glt_det to ttglt_det.
      ttglt_det.glt_domain = global_domain.
   end.

   for each ac_mstr where ac_mstr.ac_domain = global_domain no-lock:
      create ttac_mstr. ttac_mstr.ac_domain = global_domain.
      buffer-copy ac_mstr to ttac_mstr.
      ttac_mstr.ac_domain = global_domain.
   end.

   for each al_mstr  where al_mstr.al_domain = global_domain no-lock:
      create ttal_mstr. ttal_mstr.al_domain = global_domain.
      buffer-copy al_mstr to ttal_mstr.
      ttal_mstr.al_domain = global_domain.
   end.

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-upd-flds1:

   /* NOW WE LOCK THE RECORD ALREADY FOUND */
   find glt_det  where glt_det.glt_domain = global_domain and  glt_det.glt_ref 
   = ttglt_det.glt_ref
                  and glt_det.glt_line = ttglt_det.glt_line
                  and glt_det.glt_rflag = ttglt_det.glt_rflag
   exclusive-lock use-index glt_ref no-error.

   if not available glt_det then next.

   assign
      glt_det.glt_unb = no
      glt_det.glt_error = "".

   if glt_det.glt_tr_type = "" then
      glt_det.glt_tr_type = substring(glt_det.glt_ref, 1, 2).

   assign
      ttglt_det.glt_unb     = glt_det.glt_unb
      ttglt_det.glt_error   = glt_det.glt_error
      ttglt_det.glt_tr_type = glt_det.glt_tr_type.

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-upd-error:

   define input parameter p-error as character no-undo.

   find glt_det where glt_det.glt_ref = ttglt_det.glt_ref
                  and glt_det.glt_line = ttglt_det.glt_line
                  and glt_det.glt_rflag = ttglt_det.glt_rflag
                  and glt_det.glt_domain = global_domain
   exclusive-lock use-index glt_ref no-error.

   if available(glt_det) then
      assign
         glt_det.glt_error = p-error
         ttglt_det.glt_error = p-error.

END PROCEDURE.

/*-----------------------------------------------------------------*/
PROCEDURE ip-gltrpstb:

   define output parameter p-error-msg like glt_det.glt_error no-undo.

   /* CHECK FOR VALID ACCOUNT */
   find ttac_mstr  where ttac_mstr.ac_domain = global_domain and  ac_code = 
   ttglt_det.glt_acct no-lock no-error.

   if not available ttac_mstr or ttglt_det.glt_acct = pl then
      assign
         p-error-msg = getTermLabel("INVALID_ACCOUNT",16)
         unb = yes.

   /* CHECK FOR ACTIVE ACCOUNT */
   else
   if ac_active = no then
      assign
         p-error-msg = getTermLabel("INACTIVE_ACCOUNT",16)
         unb = yes.

   /* CHECK FOR VALID SUBACCOUNT */
   if p-error-msg =  ""
   then do:

      find sb_mstr  where sb_mstr.sb_domain = global_domain and  sb_sub = 
      ttglt_det.glt_sub no-lock no-error.
      if not available sb_mstr then
         assign
            p-error-msg = getTermLabel("INVALID_SUB-ACCT",16)
            unb = yes.

      /* CHECK FOR ACTIVE SUBACCOUNT */
      else
      if sb_active = no then
         assign
            p-error-msg = getTermLabel("INACTIVE_SUB-ACCT",16)
            unb = yes.

   end. /* IF p-error-msg = "" */

   /* CHECK FOR VALID COST CENTER */
   if p-error-msg = ""
   then do:

      find cc_mstr  where cc_mstr.cc_domain = global_domain and  cc_ctr = 
      ttglt_det.glt_cc no-lock no-error.
      if not available cc_mstr then
         assign
            p-error-msg = getTermLabel("INVALID_COST_CTR",16)
            unb = yes.

      /* CHECK FOR ACTIVE COST CENTER */
      else
      if cc_active = no then
         assign
            p-error-msg = getTermLabel("INACTIVE_COST_CTR",16)
            unb = yes.

   end. /* IF p-error-msg = "" */

   /* CHECK FOR VALID PROJECT */
   /* VALIDATE PROJECT CODE IRRESPECTIVE OF THE FLAG SETTING        */
   if ttglt_det.glt_project <> "" and
      p-error-msg    = ""
   then do:
      find pj_mstr  where pj_mstr.pj_domain = global_domain and  pj_project = 
      ttglt_det.glt_project
      no-lock no-error.
      if not available pj_mstr then
         assign
            p-error-msg = getTermLabel("INVALID_PROJECT",16)
            unb = yes.
      else if pj_active = no then
         assign
            p-error-msg = getTermLabel("INACTIVE_PROJECT",16)
            unb        = yes.
   end. /* IF glt_project <> "" and p-error-msg = "" */

   /* CHECK FOR VALID DAYBOOK */
   if daybooks-in-use
      and p-error-msg = ""
   then do:

      find dy_mstr  where dy_mstr.dy_domain = global_domain and  dy_dy_code = 
      ttglt_det.glt_dy_code
      no-lock no-error.
      if not available dy_mstr then
         assign
            p-error-msg = getTermLabel("INVALID_DAYBOOK",16)
            unb = yes.

   end. /* if daybooks-in-use and glt_dy_code <> "" and p-error-msg = "" */

   /* CHECK FOR VALID COMBINATION */
   if p-error-msg = ""
   then do:

      find first ttacct_val where gl_acct = ttglt_det.glt_acct
                              and gl_sub = ttglt_det.glt_sub
                              and gl_cc = ttglt_det.glt_cc
                              and gl_project = ttglt_det.glt_project
      no-lock no-error.

      if not available(ttacct_val) then do:

         /* ACCT, SUBACCT, COST CENTER, PROJECT VALIDATION OF COMBO ONLY */
         {gprunp.i "gpglvpl" "p" "validate_combo"
            "(input ttglt_det.glt_acc,
              input ttglt_det.glt_sub,
              input ttglt_det.glt_cc,
              input ttglt_det.glt_project,
              output valid_acct)"}

         create ttacct_val.
         assign
            gl_acct    = ttglt_det.glt_acct
            gl_sub     = ttglt_det.glt_sub
            gl_cc      = ttglt_det.glt_cc
            gl_project = ttglt_det.glt_project
            gl_vail    = valid_acct.

      end.

      if not gl_vail then
         assign
            p-error-msg = getTermLabel("INVALID_CODE",16)
            unb = yes.
      {&GLTRPST-P-TAG51}
   end. /* IF p-error-msg = "" */

END PROCEDURE.

PROCEDURE ip-period-curr-total:
   /* UPDATE THE CURRENCY PERIOD TOTALS WHICH ARE USED  */
   /* FOR THE REVALUATING OF CONSOLIDATION TRANSACTIONS */

   define buffer buf_glc for gl_ctrl.

   if can-find(ac_mstr where ac_domain = global_domain
                         and ac_code   = det.glt_acc
                         and ac_fx_ind = "1")               and
      can-find(en_mstr where en_domain = global_domain
                         and en_entity = det.glt_entity
                         and en_consolidation)
   then do:
      for first glec_det
       fields(glec_domain glec_cons_ref glec_cons_rflag glec_cons_line
              glec_sub_domain)
       where glec_domain     = global_domain
         and glec_cons_ref   = det.glt_ref
         and glec_cons_rflag = det.glt_rflag
         and glec_cons_line  = det.glt_line
      no-lock:
         for first buf_glc
          fields(gl_domain gl_base_curr)
          where gl_domain = glec_sub_domain
         no-lock:
         end.
         if available buf_glc and buf_glc.gl_base_curr <> base_curr then do:
            for first glct_det
             where glct_domain      = global_domain
               and glct_entity      = det.glt_entity
               and glct_source_curr = buf_glc.gl_base_curr
               and glct_acc         = det.glt_acc
               and glct_sub         = det.glt_sub
               and glct_cc          = det.glt_cc
               and glct_year        = glc_cal.glc_year
               and glct_per         = glc_cal.glc_per
            exclusive-lock:
            end.
            if not available glct_det then do:
               create glct_det.
               assign glct_domain      = global_domain
                      glct_entity      = det.glt_entity
                      glct_source_curr = buf_glc.gl_base_curr
                      glct_acc         = det.glt_acc
                      glct_sub         = det.glt_sub
                      glct_cc          = det.glt_cc
                      glct_year        = glc_year
                      glct_per         = glc_per.
            end.
            assign glct_base_amt = glct_base_amt + det.glt_amt
                   glct_curr_amt = glct_curr_amt + det.glt_curr_amt.
       end.
    end.
   end.
END PROCEDURE.
PROCEDURE ip-check-ref-lock:

   define output parameter p_lock  as logical initial no no-undo.

   reftot = 0.

   for each det
      where det.glt_ref    = ref and det.glt_domain = global_domain
            no-lock use-index glt_ref:

      find first glt_det
         where recid(glt_det) = recid(det)
                 exclusive-lock no-wait no-error.

      if not available glt_det
      then do:
         if locked glt_det
         then
            p_lock = yes.
         return.
      end. /* IF NOT AVAILABLE glt_det */

      if can-find(first ac_mstr
         where ac_code  = glt_det.glt_acct
         and   ac_type <> "S"
         and   ac_type <> "M"
         and   not glt_det.glt_rflag
         and ac_domain = global_domain)
      then
         reftot = reftot + glt_det.glt_amt.

   end. /* FOR EACH det */
END PROCEDURE. /* ip-check-ref-lock */
