/* soivpst.p - POST INVOICES TO AR AND GL REPORT                            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.33.3.10.1.3 $                                        */
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
/* Revision: 1.30      BY: Steve Nugent       DATE: 07/09/01   ECO: *P007*  */
/* Revision: 1.31      BY: Mercy C.           DATE: 04/02/02   ECO: *N1D2*  */
/* Revision: 1.32      BY: Ed van de Gevel    DATE: 05/08/02   ECO: *P069*  */
/* Revision: 1.33.3.1  BY: John Corda         DATE: 08/09/02   ECO: *N1QP*  */
/* Revision: 1.33.3.2  BY: Paul Donnelly (SB) DATE: 06/28/03   ECO: *Q00L*  */
/* Revision: 1.33.3.4  BY: Marcin Serwata     DATE: 08/25/03   ECO: *P10T*  */
/* Revision: 1.33.3.5  BY: Narathip W.        DATE: 09/01/03   ECO: *P0VH*  */
/* Revision: 1.33.3.6  BY: Kirti Desai        DATE: 11/12/03   ECO: *P195*  */
/* Revision: 1.33.3.7  BY: Veena Lad          DATE: 11/20/03   ECO: *P1BB*  */
/* Revision: 1.33.3.8  BY: Salil Pradhan      DATE: 03/09/04   ECO: *P1GM*  */
/* Revision: 1.33.3.9  BY: Manisha Sawant     DATE: 06/29/04   ECO: *P27Z*  */
/* Revision: 1.33.3.10 BY: Bharath Kumar      DATE: 09/20/04   ECO: *P2LB*  */
/* Revision: 1.33.3.10.1.1 BY: Manish Dani    DATE: 04/07/05   ECO: *P3DM*  */
/* Revision: 1.33.3.10.1.2 BY: Shivganesh Hegde DATE: 05/13/05 ECO: *P3LK*  */
/* $Revision: 1.33.3.10.1.3 $ BY: Jignesh Rachh  DATE: 08/02/05   ECO: *P3V0*  */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090707.1 By: Roger Xiao */


/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090707.1 - RNB
详见SPEC:E-Sign Interface_KIV101D.DOC
SS - 090707.1 - RNE */


{mfdtitle.i "090707.1"}

{cxcustom.i "SOIVPST.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivpst_p_1 "GL Consolidated or Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivpst_p_2 "GL Effective Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

/* SS - 090707.1 - B 
{soivpst.i "new shared"} /* variable definition moved include file */
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
{xxsoivpst91.i "new shared"} 
define variable tax_date like so_tax_date.
/* SS - 090707.1 - E */
{fsdeclr.i new}

{etvar.i &new="new"}
{etdcrvar.i "new"}
{etrpvar.i &new="new"}

define new shared variable prog_name as character
/* SS - 090707.1 - B 
   initial "soivpst.p" no-undo.
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
   initial "xxsoivpst91.p" no-undo.
/* SS - 090707.1 - E */

define variable l_increment   like mfc_logical      no-undo.
define variable l_cur_tax_amt like tx2d_cur_tax_amt no-undo.
define variable l_po_schd_nbr like sod_contr_id     no-undo.

/* CUSTOMIZED SECTION FOR VERTEX BEGIN */
define variable l_vtx_message   like mfc_logical initial no no-undo.
define variable l_cont          like mfc_logical initial no no-undo.
define variable l_api_handle      as handle                 no-undo.
define variable l_vq_reg_db_open  as logical     initial no no-undo.
define variable result-status     as integer                no-undo.
/* CUSTOMIZED SECTION FOR VERTEX END */

{&SOIVPST-P-TAG8}

/* THE TEMP-TABLE WORK_TRNBR STORES THE VALUES OF FIRST AND LAST  */
/* TRANSACTION NUMBER WHICH IS USED WHEN INVOICE IS POSTED VIA    */
/* SHIPPER CONFIRM, FOR ASSIGNING THE TR_RMRKS AND TR_GL_DATE     */
/* FIELDS. PREVIOUSLY, THIS WAS BEING DONE IN RCSOISB1.P PRIOR TO */
/* INVOICE POST. THIS TEMP-TABLE IS HOWEVER NOT USED BY SOIVPST.P */
/* AND HAS BEEN DEFINED HERE SINCE SOIVPSTA.P, WHICH IS SHARED    */
/* BETWEEN RCSOIS.P AND SOIVPST.P USES IT.                        */

define new shared temp-table work_trnbr no-undo
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
/* SS - 090707.1 - B 
form
   inv                  colon 15
   inv1                 label {t001.i} colon 49 skip
   cust                 colon 15
   cust1                label {t001.i} colon 49 skip
   bill                 colon 15
   bill1                label {t001.i} colon 49 skip(1)
   eff_date             colon 33 label {&soivpst_p_2} skip
   gl_sum               colon 33 label {&soivpst_p_1} skip
   print_lotserials     colon 33

with frame a width 80 side-labels.
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
        form
            inv                  colon 15
            inv1                 label {t001.i} colon 49 skip
            v_inv_date           colon 15
            v_inv_date1          label {t001.i} colon 49 skip
            cust                 colon 15
            cust1                label {t001.i} colon 49 skip
            bill                 colon 15
            bill1                label {t001.i} colon 49 skip
            v_slspsn             colon 15
            v_slspsn1            label {t001.i} colon 49 skip
            v_group              colon 15
            v_group1             label {t001.i} colon 49 skip(1)

            v_all_ok             colon 33 label "全部批核"
            eff_date             colon 33 label "总帐生效日期" skip
            gl_sum               colon 33 label "C-总帐汇总/D-明细" skip
            print_lotserials     colon 33
        with frame a width 80 side-labels.
/* SS - 090707.1 - E */

{&SOIVPST-P-TAG10}
{&SOIVPST-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* CUSTOMIZED SECTION FOR VERTEX BEGIN */
/* RUN vqregopn.p TO SEE IF VERTEX SUTI API IS RUNNING, */
/* AND THEN OPEN REGISTER DB                            */

/* TRY AND FIND VERTEX TAX API'S PROCEDURE HANDLE. */
{gpfindph.i vqapi l_api_handle}

/* IF THERE IS NO PROCEDURE HANDLE WE ARE DONE. */
if l_api_handle <> ?
then do:

   {gprun.i ""vqregopn.p"" "(output result-status)"}

   if result-status = 0
   then
      l_vq_reg_db_open = yes.

   if  result-status <> 0
   and not batchrun
   then do:

      /* INVOICES WILL POST TO MFG/PRO BUT NOT UPDATE THE VERTEX REGISTER */
      {pxmsg.i &MSGNUM=8880 &ERRORLEVEL=1}

      /* CONTINUE WITH INVOICE POST? */
      {pxmsg.i &MSGNUM=8881 &ERRORLEVEL=1 &CONFIRM=l_cont}
      if  l_cont = no
      then
         undo, return no-apply.

   end. /* IF  result-status <> 0... */

   if result-status <> 0
   then
      l_vtx_message = yes.

end. /* IF l_api_handle */
/* CUSTOMIZED SECTION FOR VERTEX END  */

/* Is Logistics running this program? */
{gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}
do transaction:

   insbase = no.

   for first svc_ctrl
         fields( svc_domain svc_isb_bom svc_pt_mstr svc_ship_isb)
          where svc_ctrl.svc_domain = global_domain no-lock :
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

main:
repeat:

   assign
      expcount = 999
      pageno   = 0.

   if eff_date = ? then eff_date = today.
   if inv1 = hi_char then inv1 = "".
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".
/* SS - 090707.1 - B */
            if v_inv_date  = low_date then v_inv_date  = ? . 
            if v_inv_date1 = hi_date  then v_inv_date1 = ? . 
            if v_slspsn1  = hi_char   then v_slspsn1   = "".
            if v_group1   = hi_char   then v_group1    = "". 
/* SS - 090707.1 - E */
   {&SOIVPST-P-TAG11}

   if not lgData then do:
      {&SOIVPST-P-TAG3}
/* SS - 090707.1 - B 
      update
         inv inv1
     {&SOIVPST-P-TAG12}
         cust cust1 bill bill1
         eff_date gl_sum print_lotserials
      with frame a.
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
            view frame dtitle .
            view frame a .
            update
                inv              
                inv1             
                v_inv_date       
                v_inv_date1      
                cust             
                cust1            
                bill             
                bill1            
                v_slspsn         
                v_slspsn1        
                v_group          
                v_group1         
                                 
                v_all_ok         
                eff_date         
                gl_sum           
                print_lotserials 
            with frame a.
/* SS - 090707.1 - E */

      {&SOIVPST-P-TAG4}
   end.
   else do:
      /* Get the invoice number from Logistics */
      {gprun.i ""lgsetinv.p"" "(output inv)"}
      inv1 = inv.
   end.

   if can-find(sbic_ctl
       where  sbic_domain = global_domain
       and    sbic_active = yes)
   then do:
       if can-find(soc_ctrl
           where  soc_domain = global_domain
           and    soc_ar     = no)
       then do:

          /* CANNOT EXECUTE INVOICE POST */
          {pxmsg.i &MSGNUM=6671 &ERRORLEVEL=4}

          /* SELF BILLING ENABLED. INTEGRATE WITH AR IN SO  */
          /* CTRL MUST BE 'YES'                             */
          {pxmsg.i &MSGNUM=6672 &ERRORLEVEL=1}

          next main.
       end.  /* IF CAN-FIND(soc_ctrl) */
   end.  /* IF CAN-FIND(sbic_ctl) */


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

   bcdparm = "".

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
/* SS - 090707.1 - B */
        {mfquoter.i  v_inv_date    }
        {mfquoter.i  v_inv_date1   }
        {mfquoter.i  v_slspsn      }
        {mfquoter.i  v_slspsn1     }
        {mfquoter.i  v_group       }
        {mfquoter.i  v_group1      }
        {mfquoter.i  v_all_ok      }

        if v_inv_date  = ?  then v_inv_date  = low_date. 
        if v_inv_date1 = ?  then v_inv_date1 = hi_date . 
        if v_slspsn1   = "" then v_slspsn1   = hi_char .
        if v_group1    = "" then v_group1    = hi_char .
/* SS - 090707.1 - E */

   if eff_date = ? then eff_date = today.
   if inv1 = "" then inv1 = hi_char.
   if cust1 = "" then cust1 = hi_char.
   if bill1 = "" then bill1 = hi_char.
   {&SOIVPST-P-TAG14}

/* SS - 090707.1 - B */
for each sls_det : delete sls_det . end.

v_manager = global_userid .
run get-sales-person-list (input v_manager ,input v_slspsn ,input v_slspsn1).
/*for each sls_det:  message sls_user view-as alert-box . end. */
/*
(   (((sod_slspsn[1] > v_slspsn and v_slspsn = "") or (sod_slspsn[1] >= v_slspsn and v_slspsn <> ""))  and sod_slspsn[1] <= v_slspsn1 ) 
 or (((sod_slspsn[2] > v_slspsn and v_slspsn = "") or (sod_slspsn[2] >= v_slspsn and v_slspsn <> ""))  and sod_slspsn[2] <= v_slspsn1 ) 
 or (((sod_slspsn[3] > v_slspsn and v_slspsn = "") or (sod_slspsn[3] >= v_slspsn and v_slspsn <> ""))  and sod_slspsn[3] <= v_slspsn1 ) 
 or (((sod_slspsn[4] > v_slspsn and v_slspsn = "") or (sod_slspsn[4] >= v_slspsn and v_slspsn <> ""))  and sod_slspsn[4] <= v_slspsn1 )
)
*/
find first gl_ctrl where gl_domain = global_domain no-lock.
find first soc_ctrl where soc_domain = global_domain no-lock.

v_ii = 0 .
for each temp1 : delete temp1 . end. 
for each so_mstr
    use-index so_invoice
    where so_domain = global_domain and so_inv_nbr > ""
    and (so_inv_nbr >= inv and so_inv_nbr <= inv1)
    and (so_invoiced = yes) /*invoice has been printed*/
    and (so_to_inv = no)    /*invoice not posted yet */
    and (so_cust >= cust and so_cust <= cust1)
    and (so_bill >= bill and so_bill <= bill1)
    and (so_inv_date >= v_inv_date and so_inv_date <= v_inv_date1)
    and can-find(  /*sod_det*/ first sod_det where sod_domain = global_domain and sod_nbr = so_nbr 
            and can-find(first sls_det where sls_user = sod_slspsn[1] or  sls_user = sod_slspsn[2] or  sls_user = sod_slspsn[3] or  sls_user = sod_slspsn[4] no-lock )
            and can-find(first pt_mstr where pt_domain = global_domain and pt_part = sod_part and pt_group >= v_group and pt_group <= v_group1 no-lock)
            no-lock /*sod_det*/)

no-lock
break by so_inv_nbr :
    find first temp1 where t1_nbr = so_nbr no-lock no-error .
    if not avail temp1 then do:
        find first ad_mstr where ad_domain = global_domain and ad_addr = so_bill no-lock no-error .
        find first sod_det 
            where sod_domain = global_domain and sod_nbr = so_nbr 
            and can-find(first sls_det where sls_user = sod_slspsn[1] or  sls_user = sod_slspsn[2] or  sls_user = sod_slspsn[3] or  sls_user = sod_slspsn[4] no-lock )
            and can-find(first pt_mstr where pt_domain = global_domain and pt_part = sod_part and pt_group >= v_group and pt_group <= v_group1 no-lock)
        no-lock no-error .
        v_ii = v_ii + 1 .
        create temp1.
        assign t1_line    = string(v_ii) 
                t1_inv_nbr = so_inv_nbr
                t1_nbr     = so_nbr
                t1_bill    = so_bill
                t1_curr    = so_curr 
                t1_ok      = v_all_ok
                t1_slspsn  = if sod_slspsn[1] <> "" then sod_slspsn[1] 
                            else if sod_slspsn[2] <> "" then sod_slspsn[2] 
                            else if sod_slspsn[3] <> "" then sod_slspsn[3] 
                            else if sod_slspsn[4] <> "" then sod_slspsn[4] 
                            else ""
                t1_name    = if avail ad_mstr then ad_name else "" 
                .

        ext_price = 0 .  
        for each sod_det where sod_domain = global_domain and sod_nbr = t1_nbr and sod_qty_inv <> 0 no-lock:

            net_price = sod_price.       
            tax_date = if so_tax_date <> ? then so_tax_date else so_ship_date.
            run get-price (input-output net_price , input sod_tax_in , input tax_date , input sod_taxc) .

            ext_price = ext_price + net_price * sod_qty_inv.
                 
        end. /*for each sod_det*/

        t1_amt = ext_price .


    end. /*if not avail temp1*/
end. /*for each so_mstr*/




v_counter = 0 .
for each temp1 :
    v_counter = v_counter + 1 .
end.
if v_counter = 0  then  do:
    message "无符合条件的发票." .
    undo, retry .
end.

hide all no-pause.
view frame zzz1 .
if v_counter >= 20 then message "每次最多显示20行" .
choice = no .

message "请移动光标选择,按回车键查看明细" .
sw_block:
repeat :
        /*带星号的frame - begin*******
        define var v_framesize as integer .
        v_framesize    = 17 .
        define  frame zzz1.
        form
            t1_select      column-label "*"  
            t1_line        column-label "项"
            t1_inv_nbr     column-label "发票号"
            t1_bill        column-label "票据开往"
            t1_name        column-label "名称" format "x(24)"
            t1_amt         column-label "金额"  
            t1_curr        column-label "币"
            t1_slspsn      column-label "推销员"
            t1_ok          column-label "A"
        with frame zzz1 v_framesize down width 80 
        title color normal  "待审核发票清单".  

        for first temp1 no-lock:
        end.        
        {xxsoivpst001.i
            &detfile      = temp1
            &scroll-field = t1_line
            &framename    = "zzz1"
            &framesize    = v_framesize
            &sel_on       = ""*""
            &sel_off      = """"
            &display1     = t1_select
            &display3     = t1_line 
            &display4     = t1_inv_nbr
            &display2     = t1_bill
            &display5     = t1_name
            &display6     = t1_amt
            &display7     = "t1_curr t1_slspsn"
            &display8     = t1_ok
            &exitlabel    = sw_block
            &exit-flag    = first_sw_call
            &record-id    = temp_recno
            
            
        }
        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or lastkey = keycode("ESC")
        then do:
                {mfmsg01.i 36 1 choice} /*是否退出?*/
                if choice = yes then do :
                    for each temp1 exclusive-lock:
                        delete temp1 .
                    end.
                    clear frame zzz1 all no-pause .
                    clear frame b no-pause .
                    choice = no .
                    leave .
                end.

        end.  /*if keyfunction(lastkey)*/  
        
        if keyfunction(lastkey) = "go"
        then do:
            v_yn1 = no . /*v_yn1 = yes 则不可以退出 */
            if v_yn1 = no then do :
                choice = yes .
                {mfmsg01.i 12 1 choice }  /*是否正确?*/
                if choice then     leave .
            end. 

        end.  /*if keyfunction(lastkey)*/  


        for first temp1 where t1_select = "*" exclusive-lock with frame b :
                assign t1_select = "" .
                {gprun.i  ""xxsoivpst001.p"" "(input t1_nbr)"}
                view frame zzz1 .

                message "请输入批核结果Yes/No" .
                update t1_ok with frame zzz1 .
                
            
        end. /*for first temp1*/

        temp_recno = recid(temp1) .

        find next temp1 no-lock no-error.
        if available temp1 then do:
            temp_recno = recid(temp1) .
        end.
      
        ****************带星号的frame - end */

        /*****不带星号的frame - begin********/
        define var vv_recid as recid .
        define var vv_first_recid as recid .
        define var v_framesize as integer .
        vv_recid       = ? .
        vv_first_recid = ? .
        v_framesize    = 17 .

        define frame zzz1.
        form
            t1_line        column-label "项"
            t1_inv_nbr     column-label "发票号"
            t1_bill        column-label "票据开往"
            t1_name        column-label "名称"  format "x(26)"
            t1_amt         column-label "金额"  
            t1_curr        column-label "币"
            t1_slspsn      column-label "推销员"
            t1_ok          column-label "A"
        with frame zzz1 width 80 v_framesize down 
        title color normal  "待审核发票清单".  

        scroll_loop:
        do with frame zzz1:
            {xxsoivpst003.i 
                &domain       = "true and "
                &buffer       = temp1
                &scroll-field = t1_line
                &searchkey    = "true"
                &framename    = "zzz1"
                &framesize    = v_framesize
                &display1     = t1_line
                &display2     = t1_inv_nbr
                &display3     = t1_bill       
                &display4     = t1_name       
                &display5     = t1_amt        
                &display6     = t1_curr       
                &display7     = t1_slspsn     
                &display8     = t1_ok         
                &exitlabel    = scroll_loop
                &exit-flag    = "true"
                &record-id    = vv_recid
                &first-recid  = vv_first_recid
                &logical1     = true 
            }

            /*
            &display9     = "pt__chr01"
            &index-phrase = "use-index pt_part"
            &exec_cursor  = "update pt_pm_code." 
            */
        end. /*scroll_loop*/

        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or lastkey = keycode("ESC")
        then do:
                {mfmsg01.i 36 1 choice} /*是否退出?*/
                if choice = yes then do :
                    for each temp1 exclusive-lock:
                        delete temp1 .
                    end.
                    clear frame zzz1 all no-pause .
                    clear frame b no-pause .
                    choice = no .
                    leave .
                end.
        end.  /*if keyfunction(lastkey)*/  
        
        if keyfunction(lastkey) = "go"
        then do:
            v_yn1 = no . /*v_yn1 = yes 则不可以退出 */
            vv_recid = ? . /*退出前清空vv_recid*/
            if v_yn1 = no then do :
                choice = yes .
                {mfmsg01.i 12 1 choice }  /*是否正确?*/
                if choice then     leave .
            end. 

        end.  /*if keyfunction(lastkey)*/  

        if vv_recid <> ? then do:
            find first temp1 where recid(temp1) = vv_recid no-error .
            if avail temp1 then do:
                {gprun.i  ""xxsoivpst001.p"" "(input t1_nbr)"}
                view frame zzz1 .

                message "请输入批核结果Yes/No" .
                update t1_ok with frame zzz1 .        
            end.
        end.
        /*****不带星号的frame - end********/

end. /*sw_block:*/


find first temp1 where t1_ok = yes no-error.
if not avail temp1 then do:
    message "批核者未作任何批核." .
    choice = no.
end.
else do:
    v_print = No .
    message "是否打印已批核记录?" update v_print .
end .
if choice then do :
    /*{mfmsg01.i 32 1 choice } *是否更新?*/
    if choice then do :

        /*发票过账***************************************************************begin*/

        define temp-table tt field tt_rec as recid .

        for each tt : delete tt . end .
        on create of ih_hist do:
            find first tt where tt_rec = recid(ih_hist) no-lock no-error.
            if not available tt then do:
                create tt. tt_rec = recid(ih_hist).
            end.
        end.

        v_print_file = execname 
                 + '-' + string(year(today),"9999") 
                 + string(month(today),"99") 
                 + string(day(today),"99") 
                 + entry(1,string(time,'hh:mm:ss'),':') 
                 + entry(2,string(time,'hh:mm:ss'),':') 
                 + entry(3,string(time,'hh:mm:ss'),':') 
                 + string(random(1,100),"999")
                 .

        define var v_tmp_file as char .
        v_tmp_file = v_print_file + '-' + mfguser + ".txt".
        
        v_print_file = v_print_file + ".txt". 

        output to value(v_tmp_file) .
            put "**** This is a temporary file for (" execname format "x(24)" "). You can delete it directly . ****" skip skip(5) . 
            do transaction on error undo, retry:
               {gprun.i ""sonsogl.p"" "(input eff_date)"}  /*取参考号*/
            end.   

            {gprun.i ""xxsoivpst191.p""  "(input ?, input l_po_schd_nbr)"} /*实际过账子程式*/

            do transaction:
                find ba_mstr 
                    where ba_domain = global_domain and ba_batch = batch 
                    and ba_module = "SO"
                exclusive-lock no-error.
                if available ba_mstr then do:
                    ba_total  = ba_total + batch_tot.
                    ba_ctrl   = ba_total.
                    ba_userid = global_userid.
                    ba_date   = today.
                    batch_tot = 0.
                    ba_status = " ". 
                end.
            end.
        output close .

        for each tt no-lock:
            find first ih_hist where recid(ih_hist) = tt_rec no-error .
            if avail ih_hist then do:
                find first so_mstr where so_nbr = ih_nbr no-lock no-error.
                if avail so_mstr then do:
                    assign  
                        ih_userid = global_userid
                        ih__dte01 = today
                        ih__chr01 = so__chr01
                        ih__chr02 = so__chr02
                        ih__chr03 = so__chr03
                        ih__chr04 = so__chr04
                        ih__chr05 = so__chr05
                        .
                end.
            end.
        end.
        

        run error-check (input v_tmp_file ,output v_yn2) . /*检查是否有错误或警告v_yn2*/
        if v_yn2 = no then do:
            unix silent value ( "rm -f "  + v_tmp_file).
        end. 
        /*发票过账******************************************************************end  */

        /*清单打印*****************************************************************begin*/
        output to value(v_print_file) .
                {xxsoivpst002.i}
        output close .
        
        if v_print then do:
            hide all no-pause .
            view frame dtitle .
            view frame a .
            {mfselbpr.i "printer" 132}
            {mfphead.i}

            /*
                打印方法1: 再run一遍 xxsoivpst002.i,要换frame
                打印方法2: 打印上面一段的文件即可,
            */
            /*{xxsoivpst002.i}*/
            define var v_aaa as char format "x(132)" .
            if search(v_print_file) <> ? then do:  
                input from value(v_print_file) .
                    repeat :
                        v_aaa = "" .
                        import unformatted v_aaa .
                        put v_aaa skip .        
                    end.
                input close .
            end.
            {mfrtrail.i} /* REPORT TRAILER */
            
        end. /*if v_print*/
        /*清单打印****************************************************************end  */

        for each temp1 exclusive-lock:
            delete temp1.
        end.
        clear frame zzz1 all no-pause .

    end.  /*if choice then*/
    else do:  /*if not choice then*/
        for each temp1 exclusive-lock:
            delete temp1.
        end.
        clear frame zzz1 all no-pause .
        hide frame zzz1 no-pause .

    end. /*if not choice then*/
end.  /*if choice then*/

/* SS - 090707.1 - E */

end. /*repeat*/

procedure get-sales-person-list:
    define input parameter v_user_par  as char .
    define input parameter v_user_from as char .
    define input parameter v_user_to   as char .

    for each code_mstr 
        where code_domain = global_domain and code_fldname = v_user_par 
        no-lock :

        if (code_value >= v_user_from and code_value <= v_user_to ) then do:
            find first sls_det where sls_user = code_value no-lock no-error .
            if not avail sls_det then do:
                find first sp_mstr where sp_domain = global_domain and sp_addr = code_value no-lock no-error .
                if avail sp_mstr then do:
                    create sls_det .
                    assign sls_user = code_value .
                end.
            end .
        end.

        /*这一行一定要放在for each的最后*/
        run get-sales-person-list (input code_value ,input v_user_from ,input v_user_to ).
    end. /*for each code_mstr*/

end procedure . /*get-sales-person-list*/


procedure get-price:
    define input-output parameter vv_price       like idh_price  .
    define input parameter vv_include_tax like idh_tax_in .
    define input parameter vv_tax_date    like ih_tax_date .
    define input parameter vv_tax_class   like idh_taxc  .

    find first gl_ctrl where gl_domain = global_domain no-lock no-error .
    if not avail gl_ctrl then do:
        vv_price = vv_price .
    end.
    else do:                       
        if (gl_can or gl_vat) and vv_include_tax then do:             
            find last vt_mstr 
                where vt_class =  vv_tax_class
                and vt_start <= vv_tax_date
                and vt_end   >= vv_tax_date
            no-lock no-error.
            if not available vt_mstr then
                find last vt_mstr where vt_class = vv_tax_class no-lock no-error.
            if available vt_mstr then do:
                vv_price  = vv_price  * 100 / (100 + vt_tax_pct).
            end.
        end.
    end.
end procedure . /*get-price:*/



procedure error-check. 
    define input  parameter vv_file_input as char .
    define output parameter vv_file_error as logical .
    define variable vv_tmp_input as character .

    vv_file_error = no .

    input from value(vv_file_input) .
        do while true:
            import unformatted vv_tmp_input.

            if      index (vv_tmp_input,"error:")   <> 0 or    
                    index (vv_tmp_input,"错误:")	<> 0 or           
                    index (vv_tmp_input,"warning:") <> 0 or 
                    index (vv_tmp_input,"警告:")    <> 0  
            then do:
                vv_file_error = yes .
            end.
        end. /*do while true*/
    input close.

end procedure. /*error-check*/






/*------------------------------------------the end --------------------------------------------------------------------------------------------*/


/* SS - 090707.1 - B 

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
      {gpfildel.i &filename=global_userid + "".isb""}
      output stream prt2  to value(global_userid + ".isb").
   end.

   l_increment = no.

   so_mstr-loop:
   for each so_mstr no-lock
       where so_mstr.so_domain = global_domain and  (so_inv_nbr >= inv
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
         fields(sod_domain  sod_list_pr  sod_nbr    sod_price
                sod_qty_inv sod_disc_pct sod_ln_ref sod_contr_id
                sod_line    sod_site)
          where sod_det.sod_domain = global_domain and  sod_nbr = so_nbr
          no-lock:

         if so_sched
         then
            l_po_schd_nbr = sod_contr_id.
         else
            l_po_schd_nbr = "".

         if (sod_price * sod_qty_inv) <> 0
            or sod_disc_pct           <> 0
         then do:
            l_increment = yes .
            leave so_mstr-loop.
         end. /* THEN DO */

         if can-find(first absl_det
                        where absl_det.absl_domain  =  global_domain
                        and   absl_order            = sod_nbr
                        and   absl_ord_line         = sod_line
                        and   absl_abs_shipfrom     = sod_site
                        and   absl_confirmed        = yes
                        and   absl_inv_nbr          = so_inv_nbr
                        and   absl_inv_post         = no
                        and   absl_lc_amt           <> 0 )
         then do:
            l_increment = yes.
            leave so_mstr-loop.

         end. /* IF CAN-FIND(FIRST absl_det ... */

         for each sodlc_det
            fields (sodlc_det.sodlc_domain sodlc_order
                    sodlc_ord_line         sodlc_one_time
                    sodlc_times_charged    sodlc_lc_amt)
            where sodlc_det.sodlc_domain = global_domain
            and   sodlc_order            = sod_nbr
            and   sodlc_ord_line         = sod_line
            and   sodlc_lc_amt           <> 0
         no-lock:
            if    (sodlc_one_time      = no
               or (sodlc_one_time      = yes
               and sodlc_times_charged <= 1 ))
               and sod_qty_inv         <> 0
            then do:

               l_increment = yes.
               leave so_mstr-loop.

            end. /* IF (sodlc_one_time = no .... */

         end. /* FOR EACH sodlc_det */

         if can-find(first abscc_det
                        where abscc_det.abscc_domain  =  global_domain
                        and   abscc_order             = sod_nbr
                        and   abscc_ord_line          = sod_line
                        and   abscc_abs_shipfrom      = sod_site
                        and   abscc_confirmed         = yes
                        and   abscc_inv_nbr           = so_inv_nbr
                        and   abscc_inv_post          = no
                        and   abscc_cont_price        <> 0 )
         then do:
            l_increment = yes.
            leave so_mstr-loop.

         end. /* IF CAN-FIND(FIRST abscc_det ... */

      end. /* FOR EACH sod_det */

      /* TO ACCUMULATE TAX AMOUNTS OF SHIPPED SO ONLY ('13'/'14'type) */
      for each tx2d_det
         fields( tx2d_domain tx2d_cur_tax_amt tx2d_ref tx2d_tr_type)
          where tx2d_det.tx2d_domain = global_domain and (  tx2d_ref         =
          so_nbr
         and   (tx2d_tr_type    = '13'
                or tx2d_tr_type = '14')
         ) no-lock:
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
   else do:
      run p_getbatch.
      ref   = "".
   end. /* ELSE DO */

   mainloop:
   do on error undo, leave:

      {mfphead.i}
      {&SOIVPST-P-TAG17}


      {gprun.i ""soivpst1.p""
               "(input ?,
                 input l_po_schd_nbr)"}

      do transaction:
         find ba_mstr  where ba_mstr.ba_domain = global_domain and  ba_batch =
         batch and ba_module = "SO"
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

      /* CUSTOMIZED SECTION FOR VERTEX BEGIN */
      if l_vtx_message
      then do:

         /* DISPLAY A MESSAGE IN THE AUDIT TRAIL */

         /* API FUNCTION FAILURE. VERTEX REGISTER DB DID NOT UPDATE. */
         {pxmsg.i &MSGNUM=8882 &ERRORLEVEL=1}

         /* VERIFY THE DATA IN THE VERTEX REGISTER. */
         {pxmsg.i &MSGNUM=8883 &ERRORLEVEL=1}

      end. /* IF l_vtx_message */
      /*  CUSTOMIZED SECTION FOR VERTEX ENDS */

      /* REPORT TRAILER */
      {mfrtrail.i}
      {&SOIVPST-P-TAG7}
   end. /* mainloop */

   if lgData then leave.
end.

/* CUSTOMIZED SECTION FOR VERTEX BEGIN */
/* CHECK IF VERTEX REGISTER DBF WAS OPENED */
if l_vq_reg_db_open
then do:
   {gprun.i ""vqregcls.p""}
end. /* IF l_vq_reg_db_open */
/*  CUSTOMIZED SECTION FOR VERTEX ENDS */

procedure p_getbatch:
/*--------------------------------------------------------------------
  Purpose: Get next AR batch number
---------------------------------------------------------------------*/

   if can-find(first soc_ctrl
      where soc_domain = global_domain
      and   soc_ar     = yes)
   then do:
      {mfnctrl.i "arc_ctrl.arc_domain = global_domain"
       "arc_ctrl.arc_domain" "ar_mstr.ar_domain = global_domain"
        arc_ctrl arc_batch ar_mstr ar_batch batch}

      if not can-find(first ba_mstr
         where ba_domain = global_domain
         and ba_batch = batch
         and ba_module = "SO")
      then do:
         create ba_mstr.
         assign
            ba_domain = global_domain
            ba_batch = batch
            ba_module = "SO"
            ba_doc_type = "I"
            ba_status = "NU" /*not used*/.
      end. /* IF NOT CAN-FIND(FIRST ba_mstr */
   end. /* IF CAN-FIND(FIRST soc_ctrl.. */
END PROCEDURE. /* p_getbatch */



SS - 090707.1 - E */