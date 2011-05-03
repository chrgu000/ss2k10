/* soivpst.p - POST INVOICES TO AR AND GL REPORT                            */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.39 $                                                        */
/*V8:ConvertMode=Report                                                     */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb *                   */
/* REVISION: 6.0      LAST MODIFIED: 07/11/90   BY: wug *D051*              */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: mlb *D055*              */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: wug *D054*              */
/* REVISION: 6.0      LAST MODIFIED: 11/01/90   BY: mlb *D162*              */
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: mlb *D238*              */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: afs *D279*              */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354*              */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*              */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D424*              */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*              */
/* REVISION: 6.0      LAST MODIFIED: 03/28/91   BY: afs *D464*              */
/* REVISION: 6.0      LAST MODIFIED: 04/04/91   BY: afs *D478*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 04/29/91   BY: afs *D586*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 05/08/91   BY: afs *D628*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 08/12/91   BY: afs *D824*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: mlv *D825*              */
/* REVISION: 6.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*              */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: mlv *F029*              */
/* REVISION: 6.0      LAST MODIFIED: 11/26/91   BY: wug *D953*              */
/* REVISION: 7.0      LAST MODIFIED: 11/30/91   BY: sas *F017*              */
/* REVISION: 7.0      LAST MODIFIED: 02/19/92   BY: tjs *F213*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: tjs *F247*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/22/92   BY: tmd *F263*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: dld *F297*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: afs *F356*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: tjs *F504*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   BY: sas *F656*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/29/92   BY: afs *F715*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 07/20/92   BY: tjs *F739*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 08/13/92   BY: sas *F850*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 08/24/92   BY: tjs *G033*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047*              */
/* REVISION: 7.3      LAST MODIFIED: 10/23/92   BY: afs *G230*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: afs *G163*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 11/06/92   BY: afs *G290*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 12/04/92   BY: afs *G394*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 01/05/93   BY: mpp *G484*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 12/06/92   BY: sas *G435*              */
/* REVISION: 7.3      LAST MODIFIED: 01/24/93   BY: sas *G585*              */
/* REVISION: 7.3      LAST MODIFIED: 01/27/93   BY: sas *G613*              */
/* REVISION: 7.3      LAST MODIFIED: 04/08/93   BY: afs *G905*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: bcm *G942*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: tjs *G948*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 05/26/93   BY: kgs *GB38*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 06/07/93   BY: tjs *GA64*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 06/09/93   BY: dpm *GB71*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 06/16/93   BY: tjs *GA65*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 07/30/93   BY: jjs *H050*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*              */
/* REVISION: 7.4      LAST MODIFIED: 10/01/93   BY: tjs *H070*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 10/18/93   BY: tjs *H182*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 11/15/93   BY: tjs *H196*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 11/16/93   BY: bcm *H226*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 11/23/93   BY: afs *H239*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 05/09/94   BY: dpm *H367*              */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: dpm *GJ95*              */
/* REVISION: 7.4      LAST MODIFIED: 06/07/94   BY: dpm *FO66*              */
/* REVISION: 7.4      LAST MODIFIED: 06/22/95   BY: rvw *H0F0*              */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*              */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: *J04C* Sue Poland       */
/* REVISION: 8.6      LAST MODIFIED: 06/19/96   BY: bjl *K001*              */
/* REVISION: 8.5      LAST MODIFIED: 08/26/96   BY: *G2CR* Ajit Deodhar     */
/* REVISION: 8.6      LAST MODIFIED: 03/19/97   BY: *K082* E. Hughart       */
/* REVISION: 8.6      LAST MODIFIED: 12/08/97   BY: *J27M* Seema Varma      */
/* REVISION: 8.6      LAST MODIFIED: 11/06/97   BY: *K15N* Jim Williams     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 28/04/98   BY: *L00L* Adam Harris      */
/* REVISION: 9.0      LAST MODIFIED: 09/30/98   BY: *J2CZ* Reetu Kapoor     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 08/12/99   BY: *J3KJ* Bengt Johansson  */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen    */
/* REVISION: 9.1      LAST MODIFIED: 11/23/99   BY: *L0LS* Manish K.        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *L0QV* Manish K.        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* REVISION: 9.1      LAST MODIFIED: 11/27/00   BY: *L12B* Santosh Rao      */
/* Revision: 1.28     BY: Falguni Dalal       DATE: 12/12/00   ECO: *L15W*  */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00 BY: *N0W8* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 02/13/01 BY: *N0WV* Sandeep P.         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.30     BY: Steve Nugent    DATE: 07/09/01   ECO: *P007*      */
/* Revision: 1.31     BY: Mercy C.        DATE: 04/02/02   ECO: *N1D2*      */
/* Revision: 1.32     BY: Ed van de Gevel DATE: 05/08/02   ECO: *P069*      */
/* Revision: 1.33     BY: John Corda      DATE: 08/09/02   ECO: *N1QP*      */
/* Revision: 1.38     BY: Narathip W.     DATE: 06/14/03   ECO: *P0VH*      */
/* $Revision: 1.39 $   BY: Marcin Serwata  DATE: 08/25/03   ECO: *P10T*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ss - 090915.1 by: jack */ /* 过账不删除so*/
/* ss - 091009.1 by: jack */  /* 转化bill开发的按收货日期申请的发票过账*/
/* ss -091116.1 by: jack */  /* 发票过账用so__chr01 = yse 标志*/
/* ss - 091120.1 by: jack */ /* 修改删除so逻辑*/
/* ss - 091009.1 -RNB
  修改于以下标准程序:
  - 发票过账 [soivpst.p]

注意:
  - 必须禁用以上标准程序

当前用户对该申请号所包含的销售订单必须具有相应的操作权限

一旦过账,该申请号将不再允许修改和删除

   ss - 091009.1 -END */
/*
{mfdtitle.i "2+ "}
*/
/*
{mfdtitle.i "090915.1 "}
*/
{mfdtitle.i "091120.1 "}

{cxcustom.i "SOIVPST.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivpst_p_1 "GL Consolidated or Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivpst_p_2 "GL Effective Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

 /* ss - 091009.1 -b */
DEFINE VARIABLE nbr_rqm LIKE rqm_mstr.rqm_nbr.
DEFINE VARIABLE inv_date_so LIKE so_inv_date INITIAL TODAY.
DEFINE VARIABLE inv_nbr_so LIKE so_inv_nbr.

DEFINE VARIABLE trans_conv LIKE sod_um_conv NO-UNDO.

DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE inv_nbr_pre AS CHARACTER.
define variable result-status     as integer                no-undo.
/* ss - 091009.1 -e */

{soivpst.i "new shared"} /* variable definition moved include file */
{fsdeclr.i new}

{etvar.i &new="new"}
{etdcrvar.i "new"}
{etrpvar.i &new="new"}

    /* ss - 091120.1 -b
define new shared variable prog_name as character
   initial "soivpst.p" no-undo.
ss - 091120.1 -e */
    /* ss - 091120.1 -b */
    define new shared variable prog_name as character
   initial "xxssirps.p" no-undo.
/* ss - 091120.1 -e */
define variable l_increment   like mfc_logical      no-undo.
define variable l_cur_tax_amt like tx2d_cur_tax_amt no-undo.
{&SOIVPST-P-TAG8}

/* THE TEMP-TABLE WORK_TRNBR STORES THE VALUES OF FIRST AND LAST  */
/* TRANSACTION NUMBER WHICH IS USED WHEN INVOICE IS POSTED VIA    */
/* SHIPPER CONFIRM, FOR ASSIGNING THE TR_RMRKS AND TR_GL_DATE     */
/* FIELDS. PREVIOUSLY, THIS WAS BEING DONE IN RCSOISB1.P PRIOR TO */
/* INVOICE POST. THIS TEMP-TABLE IS HOWEVER NOT USED BY SOIVPST.P */
/* AND HAS BEEN DEFINED HERE SINCE SOIVPSTA.P, WHICH IS SHARED    */
/* BETWEEN RCSOIS.P AND SOIVPST.P USES IT.                        */

define new shared temp-table work_trnbr
   field work_sod_nbr  like sod_nbr
   field work_sod_line like sod_line

   field work_tr_recid  like tr_trnbr
   index work_sod_nbr work_sod_nbr ascending.

/* This flag will indicate that Logistics is running Post */

define new shared variable lgData as logical no-undo initial no.
/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}

post = yes.

{&SOIVPST-P-TAG1}
{&SOIVPST-P-TAG9}
form
    /* SS - 091009.1 -B
   inv                  colon 15
   inv1                 label {t001.i} colon 49 skip
   cust                 colon 15
   cust1                label {t001.i} colon 49 skip
   bill                 colon 15
   bill1                label {t001.i} colon 49 skip(1)
   SS - 091009.1 -E */
    /* ss - 091009.1 -b */
    nbr_rqm colon 33
   cust COLON 33
   inv_date_so COLON 33
    inv_nbr_so COLON 33
   /* ss - 091009.1 -e */
   eff_date             colon 33 label {&soivpst_p_2} skip
   gl_sum               colon 33 label {&soivpst_p_1} skip
   print_lotserials     colon 33

with frame a width 80 side-labels.
{&SOIVPST-P-TAG10}
{&SOIVPST-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* Is Logistics running this program? */
{gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}
do transaction:

   insbase = no.

   for first svc_ctrl
         fields(svc_isb_bom svc_pt_mstr svc_ship_isb)
         no-lock :
   end.

   /* SVC_WARR_SVCODE IS THE WARRANTY SERVICE TYPE FOR RMA'S, */
   /* NOT A DEFAULT WARRANTY TYPE.                            */

   /* WITH THE 8.5 RELEASE, LOADING THE STANDARD BOM CONTENTS */
   /* INTO THE INSTALLED BASE IS NO LONGER AN OPTION.  THIS   */
   /* DECISION WAS MADE TO PREVENT SERIALIZED ITEMS FROM      */
   /* GETTING INTO THE ISB WITHOUT SERIAL NUMBERS, AND ENSURE */
   /* THERE ARE NO ADVERSE IMPACTS TO THE COMPLIANCE SERIAL   */
   /* NUMBERING REQUIREMENTS.                                 */
   if available svc_ctrl then
   assign

      serialsp = "S"       /* ALL SERIALS SHOULD LOAD */
      nsusebom = no
      usebom   = svc_isb_bom
      needitem = svc_pt_mstr

      insbase  = svc_ship_isb.

end.

repeat:

   assign
      expcount = 999
      pageno   = 0.

   /* ss - 091009.1 -b */
   if inv_date_so = ? then inv_date_so = today.
   /* ss - 091009.1 -e */
   if eff_date = ? then eff_date = today.
   if inv1 = hi_char then inv1 = "".
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".
   {&SOIVPST-P-TAG11}
        /* ss - 091009.1 -b */
        /* 增值税专用发票 */
   FIND FIRST mfc_ctrl 
      WHERE /* mfc_domain = GLOBAL_domain 
      AND */ mfc_field = "SoftspeedIR_inv_pre"
      EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      create mfc_ctrl.
      assign
        /*  mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_inv_pre"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_inv_pre"
         mfc_seq     = 100
         mfc_char = "IV"
         .
   END.
   ASSIGN
      inv_nbr_so = STRING(mfc_char)
      inv_nbr_pre = STRING(mfc_char)
      .

   FIND FIRST mfc_ctrl 
      WHERE /* mfc_domain = GLOBAL_domain 
      AND */ mfc_field = "SoftspeedIR_inv"
      EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      create mfc_ctrl.
      assign
       /*  mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_inv"
         mfc_type    = "I"
         mfc_module  = "SoftspeedIR_inv"
         mfc_seq     = 110
         mfc_integer = 1
         .
   END.
   ASSIGN
      inv_nbr_so = inv_nbr_so + STRING(mfc_integer,FILL("9",8 - LENGTH(inv_nbr_so)))
      .
   DISPLAY
      inv_nbr_so
      WITH FRAME a.
  
/* ss - 091009.1 -e */

   if not lgData then do:
      {&SOIVPST-P-TAG3}
      update
          /* ss - 091009.1 -b
         inv inv1
         {&SOIVPST-P-TAG12}
         cust cust1 bill bill1
         ss - 091009.1 -e */
          /* ss - 091009.1 -b */
           nbr_rqm
         cust
         inv_date_so
         inv_nbr_so
          /* ss - 091009.1 -e */
         eff_date gl_sum print_lotserials
      with frame a.
      {&SOIVPST-P-TAG4}
   end.
   else do:
      /* Get the invoice number from Logistics */
      {gprun.i ""lgsetinv.p"" "(output inv)"}
      inv1 = inv.
   end.

   /* VALIDATE OPEN GL PERIOD FOR PRIMARY ENTITY - GIVE
    * A WARNING IF THE PRIMARY ENTITY IS CLOSED. WE DON'T
    * WANT A HARD ERROR BECAUSE WHAT REALLY MATTERS IS
    * THE ENTITY SO_SITE OF EACH SO_SITE (WHICH IS VALIDATED
    * IN SOIVPST1.P. BUT WE AT LEAST WANT A WARNING MESSAGE
    * IN CASE, FOR EXAMPLE, THEY ACCIDENTALLY ENTERED
    * THE WRONG EFFECTIVE DATE */

   /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
   {gprun.i ""gpglef1.p""
      "( input  ""SO"",
                      input  glentity,
                      input  eff_date,
                      output gpglef_result,
                      output gpglef_msg_nbr
                    )" }

   if gpglef_result > 0 then do:
      /* IF PERIOD CLOSED THEN WARNING ONLY */
      if gpglef_result = 2 then do:
         {pxmsg.i &MSGNUM=3005 &ERRORLEVEL=2}
      end.
      /* OTHERWISE REGULAR ERROR MESSAGE */
      else do:
         {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=4}
         next-prompt eff_date with frame a.
         undo, retry.
      end.
   end.

   /* ss - 091009.1 -b */
    /* 增值税专用发票 */
   ASSIGN i1 = INTEGER(SUBSTRING(inv_nbr_so,LENGTH(inv_nbr_pre) + 1)) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN DO:
      /* Invalid entry */
      {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
      next-prompt inv_nbr_so with frame a.
      undo, retry.
   END.

   FIND FIRST mfc_ctrl 
      WHERE /* mfc_domain = GLOBAL_domain 
      AND */ mfc_field = "SoftspeedIR_inv"
      EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, RETURN.
   END.
   ASSIGN
      mfc_integer = i1 + 1
      .

   FIND FIRST ih_hist WHERE /* ih_domain = global_domain AND */ ih_inv_nbr = inv_nbr_so NO-LOCK NO-ERROR.
   if AVAILABLE(ih_hist) OR inv_nbr_so = "" then do:
      {pxmsg.i &MSGNUM=3511 &ERRORLEVEL=3} /* INVALID INVOICE REFERENCE NUMBER */
      next-prompt inv_nbr_so with frame a.
      undo, retry.
   end.

   if inv_date_so = ? then do:
      {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3} /* INVALID DATE */
      next-prompt inv_date_so with frame a.
      undo, retry.
   end.

   IF nbr_rqm = "" THEN DO:
      {pxmsg.i &MSGNUM=9902 &ERRORLEVEL=3} /* 必须指定申请 */
      next-prompt nbr_rqm with frame a.
      undo, retry.
   END.

   FIND FIRST rqm_mstr WHERE /* rqm_domain = global_domain AND */ rqm_nbr = nbr_rqm USE-INDEX rqm_nbr NO-LOCK NO-ERROR.
   IF NOT AVAILABLE rqm_mstr THEN DO:
      {pxmsg.i &MSGNUM=5011 &ERRORLEVEL=3} /* 记录不存在 */
      next-prompt nbr_rqm with frame a.
      undo, retry.
   END.
   ELSE DO:
      IF rqm_open = YES THEN DO:
         {pxmsg.i &MSGNUM=5365 &ERRORLEVEL=3} /* 项已经被创建和过帐 */
         next-prompt nbr_rqm with frame a.
         undo, retry.
      END.
   END.

   IF nbr_rqm = "" AND cust = "" THEN DO:
      {pxmsg.i &MSGNUM=9901 &ERRORLEVEL=3} /* 必须指定申请或客户 */
      next-prompt nbr_rqm with frame a.
      undo, retry.
   END.

   /* ss - 090929.1 -b
   /* KI - B */
   {gprun.i ""xxssirpsa.p"" "(
      INPUT nbr_rqm,
      OUTPUT find-can
      )"}
   IF find-can = NO THEN DO:
      /* Invalid request */
      {pxmsg.i &MSGNUM=2333 &ERRORLEVEL=3} /* 必须指定申请或客户 */
      next-prompt nbr_rqm with frame a.
      undo, retry.
   END.
   /* KI - E */
   /* SS - 090927.1 - E */
   ss - 091009.1 -e */
/* ss - 091009.1 -e */

   bcdparm = "".
   
   /* ss - 091009.1 -b */
    {mfquoter.i nbr_rqm      }
   {mfquoter.i inv_date_so      }
   {mfquoter.i inv_nbr_so      }
 /* ss - 091009.1 -e */
   {mfquoter.i inv      }
   {mfquoter.i inv1     }
   {&SOIVPST-P-TAG13}
   {mfquoter.i cust     }
   {mfquoter.i cust1    }
   {mfquoter.i bill     }
   {mfquoter.i bill1    }
   {&SOIVPST-P-TAG5}
   {mfquoter.i eff_date }
   {&SOIVPST-P-TAG16}
   {mfquoter.i gl_sum   }
   {mfquoter.i print_lotserials}
   {&SOIVPST-P-TAG6}

   if eff_date = ? then eff_date = today.
   if inv1 = "" then inv1 = hi_char.
   if cust1 = "" then cust1 = hi_char.
   if bill1 = "" then bill1 = hi_char.
   {&SOIVPST-P-TAG14}

 

   if not lgData then do:
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
   end.


   /* If we are runing under dos then the second print file for  */

   if insbase then do:
      {gpfildel.i &filename=""ISBPST.prn""}
      output stream prt2  to "ISBPST.prn".
   end.

  /* ss - 091009.1 -b */
   DO TRANSACTION:
  /* ss - 091009.1 -e */
  
   /* ss - 091009.1 -b */
       DO TRANSACTION:
      FOR EACH rqm_mstr EXCLUSIVE-LOCK
         WHERE /* rqm_domain = GLOBAL_domain
         AND */ rqm_nbr = nbr_rqm
         /* 不包括已结的申请 */
         AND rqm_open = NO
         :
         /* ss -090929.1 -b
          find-can = NO.
         ss - 090929.1 -e */

         FOR EACH rqd_det EXCLUSIVE-LOCK
            WHERE /* rqd_domain = GLOBAL_domain
            AND */ rqd_nbr = rqm_nbr
            ,EACH usrw_wkfl EXCLUSIVE-LOCK
            WHERE /* usrw_domain = GLOBAL_domain
            AND */ usrw_key1 = "SoftspeedIR_History"
            AND usrw_key2 = STRING(rqd_cmtindx)
            ,EACH tr_hist NO-LOCK
            WHERE /* tr_domain = GLOBAL_domain
            AND */ tr_trnbr = rqd_cmtindx
            BREAK
            BY tr_nbr
            BY tr_line
            :
            /* 更新SOD - 1 */
            IF FIRST-OF(tr_nbr) THEN DO:
               FOR EACH so_mstr EXCLUSIVE-LOCK
                  WHERE /* so_domain = GLOBAL_domain
                  AND */ so_nbr = tr_nbr
                  :
                  ASSIGN
                     so_inv_nbr = ""
                     so_to_inv = YES
                     so_invoiced = NO
                     so_inv_date = ?
                     .
               END.
               FOR EACH sod_det EXCLUSIVE-LOCK
                  WHERE /* sod_domain = GLOBAL_domain
                  AND */ sod_nbr = tr_nbr
                  :
                  ASSIGN
                     sod_qty_inv = 0
                     .
               END.
            END.
          /* ss - 090929.1 -b
            IF find-can = NO THEN DO:
              NEXT.
            END.
            ss - 090929.1 -e */

            /* 更新SO */
            IF LAST-OF(tr_nbr) THEN DO:
               FIND FIRST so_mstr WHERE /* so_domain = global_domain AND */ so_nbr = tr_nbr EXCLUSIVE-LOCK NO-ERROR.
               IF AVAILABLE so_mstr THEN DO:
                  ASSIGN
                     so_inv_nbr = inv_nbr_so
                     so_to_inv = NO
                     so_invoiced = YES
                     so_inv_date = inv_date_so
                     .
                  /* 
                  RELEASE so_mstr. 
                  */
               END.
            END.

            /* 更新SOD - 2 */
            ACCUMULATE rqd_req_qty (TOTAL BY tr_nbr BY tr_line).
            IF LAST-OF(tr_line) THEN DO:
               FIND FIRST sod_det WHERE /* sod_domain = global_domain AND */ sod_nbr = tr_nbr AND sod_line = tr_line EXCLUSIVE-LOCK NO-ERROR.
               IF AVAILABLE sod_det THEN DO:
                  IF tr_um <> sod_um THEN DO:
                     {gprun.i ""gpumcnv.p""
                        "(input  sod_um,
                        input  tr_um,
                        input  tr_part,
                        output trans_conv)"}

                     ASSIGN
                        sod_qty_inv = sod_qty_inv + (ACCUMULATE TOTAL BY tr_line rqd_req_qty) / TRANS_conv
                        .
                  END.
                  ELSE DO:
                     ASSIGN
                        sod_qty_inv = sod_qty_inv + (ACCUMULATE TOTAL BY tr_line rqd_req_qty)
                        .
                  END.
               END.
            END.

            /* 更新TX2D */
            IF LAST-OF(tr_nbr) THEN DO:
               FIND FIRST so_mstr WHERE /* so_domain = global_domain AND */ so_nbr = tr_nbr EXCLUSIVE-LOCK NO-ERROR.
               IF AVAILABLE so_mstr THEN DO:
                  {gprun.i ""txcalc.p""  "(input  "13",
                    input  tr_nbr,
                    input  '',
                    input  0, /* ALL LINES */
                    input  no,
                    output result-status)"}

                  /* CREATES TAX RECORDS WITH TRANSACTION TYPE "11" */
                  /* FOR THE QUANTITY BACKORDER DURING PENDING      */
                  /* INVOICE MAINTENANCE                            */
                  if not so_sched
                  then do:

                     {gprun.i ""txcalc.p""
                        "(input  "11",
                          input  tr_nbr,
                          input  '',
                          input  0,
                          input  no,
                          output result-status)"}

                  end. /* IF NOT so_sched */
               END.
            END.
         END. /* FOR EACH rqd_det EXCLUSIVE-LOCK */

         ASSIGN
            rqm_open = YES
            .
      END. /* FOR EACH rqm_mstr EXCLUSIVE-LOCK */
   END. /* DO TRANSACTION: */
   
   ASSIGN
      inv = inv_nbr_so
      inv1 = inv_nbr_so
  /* ss - 091009.1 -e */

   l_increment = no.
   
  
   so_mstr-loop:
   for each so_mstr  /* ss - 091009.1 -b no-lock  ss - 091009.1 -e */
       /* ss  - 091009.1 -b */
       EXCLUSIVE-LOCK
       /* ss - 091009.1 -e */
      where (so_inv_nbr >= inv
      and    so_inv_nbr <= inv1)
      {&SOIVPST-P-TAG15}
      and   (so_invoiced = yes)
      and   (so_cust >= cust
      and    so_cust <= cust1)
      and   (so_bill >= bill
      and    so_bill <= bill1)
      and   (so_to_inv = no)
      use-index so_invoice:

      for each sod_det
         fields(sod_list_pr sod_nbr sod_price
                sod_qty_inv sod_disc_pct sod_ln_ref)
         where sod_nbr = so_nbr no-lock:

         if (sod_price * sod_qty_inv) <> 0
            or sod_disc_pct           <> 0
         then do:
            l_increment = yes .
            leave so_mstr-loop.
         end. /* THEN DO */

      end. /* FOR EACH sod_det */

      /* TO ACCUMULATE TAX AMOUNTS OF SHIPPED SO ONLY ('13'/'14'type) */
      for each tx2d_det
         fields(tx2d_cur_tax_amt tx2d_ref tx2d_tr_type)
         where tx2d_ref         = so_nbr
         and   (tx2d_tr_type    = '13'
                or tx2d_tr_type = '14')
         no-lock:
         l_cur_tax_amt = l_cur_tax_amt + absolute(tx2d_cur_tax_amt).
      end. /* FOR EACH tx2d_det */

      if (absolute(so_trl1_amt) + absolute(so_trl2_amt) +
          absolute(so_trl3_amt) + l_cur_tax_amt) <> 0
      then do:
         l_increment = yes.
         leave so_mstr-loop.
      end. /* IF ABSOLUTE(so_trl1_amt) + ... */

   end. /* FOR EACH SO_MSTR */

   if l_increment then
   do transaction on error undo, retry:
      /* Create Journal Reference */

      {gprun.i ""sonsogl.p"" "(input eff_date)"}
   end.

   mainloop:
   do on error undo, leave:

      {mfphead.i}
      {&SOIVPST-P-TAG17}

      /* ss - 090915.1 -b
      {gprun.i ""soivpst1.p"" "(input ?)"}
        ss - 090915.1 -e */
	/* ss - 090915.1 -b */
         
          {gprun.i ""xxsoivpst2.p"" "(input ?)"}
	/* ss - 090915.1 -e */
      do transaction:
         find ba_mstr where ba_batch = batch and ba_module = "SO"
            exclusive-lock no-error.
         if available ba_mstr then do:
            ba_total  = ba_total + batch_tot.
            ba_ctrl   = ba_total.
            ba_userid = global_userid.
            ba_date   = today.
            batch_tot = 0.
            ba_status = " ". /*balanced*/
         end.
      end.

      /* Reset second print file */
      if insbase then do:
         put stream prt2 " ".
         output stream prt2 close.
      end.

      /* REPORT TRAILER */
      {mfrtrail.i}
      {&SOIVPST-P-TAG7}
   end. /* mainloop */
      /* ss - 091009.1 -b */
   END.
      /* ss - 091009.1 -e */

   if lgData then leave.
end.
