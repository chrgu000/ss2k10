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
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 02/25/06   ECO: *SS - 20060225*      */
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 03/13/06   ECO: *SS - 20060313*      */
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 03/24/06   ECO: *SS - 20060324*      */
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 04/01/06   ECO: *SS - 20060401*      */
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 04/06/06   ECO: *SS - 20060406*      */
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 05/24/06   ECO: *SS - 20060524.1*      */
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 05/24/06   ECO: *SS - 20060524.2*      */
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 05/24/06   ECO: *SS - 20060524.3*      */
/* $Revision: 1.45 $     BY: Bill Jiang  DATE: 06/08/06   ECO: *SS - 20060608.1*      */
/* By: Neil Gao Date: 09/11/07 ECO: 20070911 */
/* SS - 091019.1 By: Neil Gao */
/* REVISION: eb2sp4     Update By: Micho Yang        ECO: NAD - 20100104.1    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* NAD - 20100104.1 - B */
/*
修改了sod_qty_inv 的计算方法
*/
/* NAD - 20100104.1 - E */

/* SS 091019.1 - B */
/*
清空销往字段
*/
/* SS 091019.1 - E */

/* ss 20070911 - B */
/*
增加事务撤销
 */
/* ss 20070911 - e */

/* SS - 20060608.1 - B */
/*
1. 验证了申请的有效性
*/
/* SS - 20060608.1 - E */

/* SS - 20060524.3 - B */
/*
1. 更新了折扣的问题
2. 执行列表:
   sssoivp1.p
   sssoivp11.p
   sssoivtrl2.p
   sssoivtrld.p,sssoivtrlc.p
   sssoivtrl2.i
*/
/* SS - 20060524.3 - E */

/* SS - 20060524.2 - B */
/*
1. 不删除已结的SO和SOD
2. 执行列表:
   sssoivp1.p
   sssoivp11.p
   sssoivp1a.p
*/
/* SS - 20060524.2 - E */

/* SS - 20060524.1 - B */
/*
1. 删除已结的SO和SOD
2. 执行列表:
   sssoivp1.p
   sssoivp11.p
   sssoivp1a.p
*/
/* SS - 20060524.1 - E */

/* SS - 20060406 - B */
/*
1. 发票不允许为空
*/
/* SS - 20060406 - E */

/* SS - 20060401 - B */
/*
1. 更新了税额的重新计算
2. 更新了计量单位的处理
*/
define variable trans_conv like sod_um_conv no-undo.

{txcalvar.i}
/* 	121216 {sssoivp1.i "new"} */
/* SS - 20060401 - E */

/* SS - 20060313 - B */
/*
1. 根据申请过账
2. 更新了以下表:XXRQM,ABS
*/
/* SS - 20060313 - E */

/*ss - 121213.1
  可以按照出货单按项次
*/

{mfdtitle.i "121218.0"}
{cxcustom.i "SOIVPST.P"}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivpst_p_1 "GL Consolidated or Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivpst_p_2 "GL Effective Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

{soivpst.i "new shared"} /* variable definition moved include file */
{fsdeclr.i new}

{etvar.i &new="new"}
{etdcrvar.i "new"}
{etrpvar.i &new="new"}

define new shared variable prog_name as character
   initial "soivpst.p" no-undo.

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

/* SS - 20060225 - B */
DEFINE VARIABLE nbr LIKE xxrqm_nbr.
define variable inv_date like so_inv_date initial today.
define variable inv_nbr              like so_inv_nbr label "Invoice".
/* SS - 20060225 - E */

post = yes.

{&SOIVPST-P-TAG1}
{&SOIVPST-P-TAG9}
form
   /* SS - 20060225 - B */
   /*
   inv                  colon 15
   inv1                 label {t001.i} colon 49 skip
   cust                 colon 15
   cust1                label {t001.i} colon 49 skip
   bill                 colon 15
   bill1                label {t001.i} colon 49 skip(1)
   */
   nbr COLON 33
   /* SS - 20060313 - B */
   cust COLON 33
   /* SS - 20060313 - E */
   inv_date COLON 33
   inv_nbr COLON 33
   /* SS - 20060225 - E */

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

   /* SS - 20060225 - B */
   if inv_date = ? then inv_date = today.
   /* SS - 20060225 - E */

   if eff_date = ? then eff_date = today.
   if inv1 = hi_char then inv1 = "".
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".
   {&SOIVPST-P-TAG11}

   if not lgData then do:
      /* SS - 20080222.1 - B */
      {&SOIVPST-P-TAG3}
      UPDATE
         nbr
      with frame a.
      {&SOIVPST-P-TAG4}
      /* SS - 20080222.1 - B */
   end.
   else do:
      /* Get the invoice number from Logistics */
      {gprun.i ""lgsetinv.p"" "(output inv)"}
      inv1 = inv.
   end.

   /* SS - 20080222.1 - B */
   FOR FIRST xxrqm_mstr WHERE xxrqm_nbr = nbr NO-LOCK :
/* SS 091019.1 - B */
/*
       cust = xxrqm_cust.
*/
/* SS 091019.1 - E */
       inv_date = xxrqm_req_date.
       eff_date = xxrqm_req_date.
   END.

   UPDATE
     cust
     inv_date
     inv_nbr
     eff_date gl_sum print_lotserials
   with frame a.
   /* SS - 20080222.1 - B */

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

   /* SS - 20060225 - B */
   if inv_date = ? then do:
      {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3} /* INVALID DATE */
      next-prompt inv_date with frame a.
      undo, retry.
   end.

   FIND FIRST ih_hist WHERE ih_inv_nbr = inv_nbr NO-LOCK NO-ERROR.
   /* SS - 20060406 - B */
   /*
   if AVAILABLE(ih_hist) then do:
   */
   if AVAILABLE(ih_hist) OR inv_nbr = "" then do:
   /* SS - 20060406 - E */
      {pxmsg.i &MSGNUM=3511 &ERRORLEVEL=3} /* INVALID INVOICE REFERENCE NUMBER */
      next-prompt inv_nbr with frame a.
      undo, retry.
   end.
   /* SS - 20060225 - E */

   /* SS - 20060324 - B */
   IF nbr = "" THEN DO:
      {pxmsg.i &MSGNUM=9902 &ERRORLEVEL=3} /* 必须指定申请 */
      next-prompt nbr with frame a.
      undo, retry.
   END.
   /* SS - 20060324 - E */

   /* SS - 20060608.1 - B */
   FIND FIRST xxrqm_mstr WHERE (xxrqm_nbr = nbr) USE-INDEX xxrqm_nbr NO-LOCK NO-ERROR.
   IF NOT AVAILABLE xxrqm_mstr THEN DO:
      {pxmsg.i &MSGNUM=5011 &ERRORLEVEL=3} /* 记录不存在 */
      next-prompt nbr with frame a.
      undo, retry.
   END.
   ELSE DO:
      IF xxrqm_invoiced = YES THEN DO:
         {pxmsg.i &MSGNUM=5365 &ERRORLEVEL=3} /* 项已经被创建和过帐 */
         next-prompt nbr with frame a.
         undo, retry.
      END.
   END.
   /* SS - 20060608.1 - E */

   /* SS - 20060313 - B */
   /* TODO:还要加上地点*/
   IF nbr = "" AND cust = "" THEN DO:
      {pxmsg.i &MSGNUM=9901 &ERRORLEVEL=3} /* 必须指定申请或客户 */
      next-prompt nbr with frame a.
      undo, retry.
   END.
   /* SS - 20060313 - E */

   bcdparm = "".
   /* SS - 20060225 - B */
   {mfquoter.i nbr      }
   {mfquoter.i inv_date      }
   {mfquoter.i inv_nbr      }
   /* SS - 20060225 - E */
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

   /* SS - 20060313 - B */
/* ss 20070911 - b */
/*
   DO TRANSACTION:
*/
   trans1:
   DO transaction on error undo,retry:
/* ss 20070911 - e */
      FOR EACH xxrqm_mstr EXCLUSIVE-LOCK
         /* SS - 20060324 - B */
         /*
         WHERE (xxrqm_nbr = nbr OR nbr = "")
         */
         WHERE (xxrqm_nbr = nbr)
         /* SS - 20060324 - E */
         AND (xxrqm_cust = cust OR cust = "")
         AND xxrqm_invoiced = NO
         USE-INDEX xxrqm_nbr
         :

         /* 更新XXRQM */
         ASSIGN
            xxrqm_inv_date = inv_date
            xxrqm_inv_nbr = inv_nbr
            xxrqm_effdate = eff_date
            xxrqm_invoiced = YES
            .

         FOR EACH xxabs_mstr NO-LOCK
            WHERE xxabs_nbr = xxrqm_nbr
            BREAK BY xxabs_order
            BY xxabs_line
            :
            /* 更新SO */
            IF LAST-OF(xxabs_order) THEN DO:
               FIND FIRST so_mstr WHERE so_nbr = xxabs_order EXCLUSIVE-LOCK NO-ERROR.
               IF AVAILABLE so_mstr THEN DO:
                  ASSIGN
                     so_inv_nbr = inv_nbr
                     so_to_inv = NO
                     so_invoiced = YES
                     so_inv_date = inv_date
                     .
                  RELEASE so_mstr.
               END.
            END. /* IF LAST-OF(xxabs_order) THEN DO: */

            /* 更新SOD */
            ACCUMULATE xxabs_ship_qty (TOTAL BY xxabs_order BY xxabs_line).
            IF LAST-OF(xxabs_line) THEN DO:
               FIND FIRST sod_det WHERE sod_nbr = xxabs_order AND sod_line = integer(xxabs_line) EXCLUSIVE-LOCK NO-ERROR.
               IF AVAILABLE sod_det THEN DO:
                  /* SS - 20060401 - B */
                  FIND FIRST ABS_mstr WHERE ABS_shipfrom = xxabs_shipfrom AND ABS_id = xxabs_id NO-LOCK NO-ERROR.
                  IF AVAILABLE ABS_mstr AND ABS__qad02 <> sod_um THEN DO:
                     {gprun.i ""gpumcnv.p""
                        "(input  sod_um,
                        input  abs__qad02,
                        input  abs_item,
                        output trans_conv)"}

                     ASSIGN
                        /* NAD - 20100104.1 - B */
                        /*
                        sod_qty_inv = sod_qty_inv + (ACCUMULATE TOTAL BY xxabs_line xxabs_ship_qty) / TRANS_conv
                        */
                        sod_qty_inv = (ACCUMULATE TOTAL BY xxabs_line xxabs_ship_qty) / TRANS_conv
                        /* NAD - 20100104.1 - E */
                        .
                  END.
                  ELSE DO:
                     ASSIGN
                        /* NAD - 20100104.1 - B */
                        /*
                        sod_qty_inv = sod_qty_inv + (ACCUMULATE TOTAL BY xxabs_line xxabs_ship_qty)
                        */
                        sod_qty_inv = (ACCUMULATE TOTAL BY xxabs_line xxabs_ship_qty)
                        /* NAD - 20100104.1 - E */
                        .
                  END.
                  /* SS - 20060401 - E */
               END.
            END.

/* 更新TX2D */
/*121213.1*/  if first-of(xxabs_order) then do:
/*121213.1*/    for each tx2d_det exclusive-lock where tx2d_ref = xxabs_order:
/*121213.1*/       delete tx2d_det.
/*121213.1*/    end.
/*121213.1*/  end.
/*121213.1            IF LAST-OF(xxabs_order) THEN DO:    */
               FIND FIRST so_mstr WHERE so_nbr = xxabs_order NO-LOCK NO-ERROR.
               IF AVAILABLE so_mstr THEN DO:
                  {gprun.i ""txcalc.p""  "(input  "13",
                    input  xxabs_order,
                    input  '',
                    input  integer(xxabs_line), /* ALL LINES */
                    input  no,
                    output result-status)"}

                  /* CREATES TAX RECORDS WITH TRANSACTION TYPE "11" */
                  /* FOR THE QUANTITY BACKORDER DURING PENDING      */
                  /* INVOICE MAINTENANCE                            */
                  if not so_sched
                  then do:

                     {gprun.i ""txcalc.p""
                        "(input  "11",
                          input  xxabs_order,
                          input  '',
                          input  integer(xxabs_line),
                          input  no,
                          output result-status)"}

                  end. /* IF NOT so_sched */
/*121213.1             END.  */
            END.

            /* 更新ABS */
            FIND FIRST ABS_mstr WHERE ABS_shipfrom = xxabs_shipfrom AND ABS_id = xxabs_id EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE ABS_mstr THEN DO:
               ASSIGN
                  /* SS - 20060324 - B */
                  /*
                  ABS__dec01 = ABS__dec01 + xxabs_ship_qty
                  */
                  ABS__dec04 = ABS__dec04 + xxabs_ship_qty
                  /* SS - 20060324 - E */
                  ABS__chr02 = xxabs__chr01
                  .
               IF xxabs_canceled = YES THEN DO:
                  ASSIGN
                     ABS__chr01 = "C"
                     .
               END.
               RELEASE ABS_mstr.
            END.

         END. /* FOR EACH xxabs_mstr NO-LOCK */
      END. /* FOR EACH xxrqm_mstr EXCLUSIVE-LOCK */
/* ss 20070911 - b */
/*
   END. /* DO TRANSACTION: */
*/
/* ss 20070911 - e */

   ASSIGN
      inv = inv_nbr
      inv1 = inv_nbr
      .
   /* SS - 20060313 - E */

   l_increment = no.

   so_mstr-loop:
   for each so_mstr no-lock
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
         no-lock
         :
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
/* ss 20070911 - b */
/*
   do on error undo, leave:
*/
   do on error undo trans1, leave trans1:
/* ss 20070911 - e */

      {mfphead.i}
      {&SOIVPST-P-TAG17}

         /* SS - 20060524.3 - B */
         /* SS - 20060524.2 - B */
         /* SS - 20060524.1 - B */
         /*
      {gprun.i ""soivpst1.p"" "(input ?)"}
         */
/*121213.1*/ {gprun.i ""sssoivp11.p"" "(input ?,input nbr)"}
         /* SS - 20060524.1 - E */
         /* SS - 20060524.2 - E */
         /* SS - 20060524.3 - E */

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

/* ss 20070911 - b */
  end. /* do transaction on error */
/* ss 20070911 - e */

   if lgData then leave.
end.
