/* GUI CONVERTED from rspomtb.p (converter v1.78) Fri Feb 17 01:55:46 2012 */
/* rspomtb.p - Release Management Scheduled Order Maintenance Sub Program     */
/* Copyright 1986-2012 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92           BY: WUG *G462*          */
/* REVISION: 7.3    LAST MODIFIED: 05/24/93           BY: WUG *GB29*          */
/* REVISION: 7.3    LAST MODIFIED: 06/01/93           BY: WUG *GB46*          */
/* REVISION: 7.3    LAST MODIFIED: 06/07/93           BY: WUG *GB75*          */
/* REVISION: 7.3    LAST MODIFIED: 06/16/93           BY: WUG *GC34*          */
/* REVISION: 7.3    LAST MODIFIED: 07/07/93           BY: WUG *GD20*          */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD42*          */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD43*          */
/* REVISION: 7.4    LAST MODIFIED: 08/06/94           BY: bcm *H057*          */
/* REVISION: 7.3    LAST MODIFIED: 04/21/94           BY: WUG *GJ48*          */
/* REVISION: 7.3    LAST MODIFIED: 05/16/94           BY: WUG *GJ59*          */
/* REVISION: 7.3    LAST MODIFIED: 09/26/94           BY: ljm *GM77*          */
/* REVISION: 7.3    LAST MODIFIED: 10/24/94           BY: ljm *GN54*          */
/* REVISION: 7.3    LAST MODIFIED: 10/31/94           BY: WUG *GN76*          */
/* REVISION: 7.3    LAST MODIFIED: 11/11/94           BY: dpm *GO13*          */
/* REVISION: 8.5    LAST MODIFIED: 11/21/94           BY: mwd *J034*          */
/* REVISION: 7.3    LAST MODIFIED: 01/17/95           by: srk *G0C1*          */
/* REVISION: 7.3    LAST MODIFIED: 01/31/95           by: srk *H09T*          */
/* REVISION: 7.4    LAST MODIFIED: 02/06/95           BY: rxm *G0DH*          */
/* REVISION: 7.4    LAST MODIFIED: 02/16/95           by: rxm *G0D5*          */
/* REVISION: 7.5    LAST MODIFIED: 02/21/95           BY: dpm *J044*          */
/* REVISION: 7.4    LAST MODIFIED: 02/23/95           by: jzw *H0BM*          */
/* REVISION: 7.4    LAST MODIFIED: 03/02/95           by: rxm *G0G5*          */
/* REVISION: 7.4    LAST MODIFIED: 03/29/95           by: dzn *F0PN*          */
/* REVISION: 7.4    LAST MODIFIED: 03/29/95           by: pmf *G0JR*          */
/* REVISION: 7.4    LAST MODIFIED: 05/15/95           by: vrn *G0MW*          */
/* REVISION: 7.4    LAST MODIFIED: 05/19/95           by: dxk *G0N7*          */
/* REVISION: 7.4    LAST MODIFIED: 05/23/95           by: vrn *G0NC*          */
/* REVISION: 7.4    LAST MODIFIED: 06/07/95           by: dxk *G0PF*          */
/* REVISION: 7.4    LAST MODIFIED: 07/06/95           by: vrn *G0RV*          */
/* REVISION: 7.4    LAST MODIFIED: 08/01/95           by: dxk *G0T5*          */
/* REVISION: 7.4    LAST MODIFIED: 01/08/96           by: kjm *G1JC*          */
/* REVISION: 7.4    LAST MODIFIED: 02/02/96           by: kjm *G1LT*          */
/* REVISION: 8.5    LAST MODIFIED: 02/26/96       BY: *J0CV* Brandy J Ewing   */
/* REVISION: 8.5    LAST MODIFIED: 03/29/96       BY: BHolmes *J0FY*          */
/* REVISION: 8.5    LAST MODIFIED: 04/08/96       by: dxk *G1R3*              */
/* REVISION: 8.5    LAST MODIFIED: 04/23/96       BY: rpw *J0K4*              */
/* REVISION: 8.5    LAST MODIFIED: 04/23/96       BY: rpw *J0K4*              */
/* REVISION: 8.5    LAST MODIFIED: 06/10/96       BY: rxm *G1XN*              */
/* REVISION: 8.5    LAST MODIFIED: 07/08/96       BY: ajw *J0SZ*              */
/* REVISION: 8.5    LAST MODIFIED: 08/20/96       BY: *G2CP* Suresh Nayak     */
/* REVISION: 8.5    LAST MODIFIED: 12/05/96       BY: *H0PP* Ajit Deodhar     */
/* REVISION: 8.5    LAST MODIFIED: 01/09/97       BY: *J1B1* Robin McCarthy   */
/* REVISION: 8.5    LAST MODIFIED: 02/14/97       BY: *G2L2* Jim Williams     */
/* REVISION: 8.5    LAST MODIFIED: 03/03/97       BY: *H0T4* Aruna Patil      */
/* REVISION: 8.5    LAST MODIFIED: 05/08/97       BY: *J1QW* Suresh Nayak     */
/* REVISION: 8.5    LAST MODIFIED: 06/02/97       BY: *H0ZB* Ajit Deodhar     */
/* REVISION: 8.5    LAST MODIFIED: 06/16/97       BY: *J1T5* Suresh Nayak     */
/* REVISION: 8.5    LAST MODIFIED: 07/23/97       BY: *H1CC* Aruna Patil      */
/* REVISION: 8.5    LAST MODIFIED: 09/04/97       BY: *G2PD* Nirav Parikh     */
/* REVISION: 8.5    LAST MODIFIED: 11/26/97       BY: *J271* Aruna Patil      */
/* REVISION: 8.5    LAST MODIFIED: 12/02/97       BY: *J274* Seema Varma      */
/* REVISION: 8.5    LAST MODIFIED: 02/05/98       BY: *J2DN* Seema Varma      */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98       BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E   LAST MODIFIED: 06/11/98       BY: *L040* Charles Yen      */
/* REVISION: 8.6E   LAST MODIFIED: 08/17/98       BY: *L062* Steve Nugent     */
/* REVISION: 8.6E   LAST MODIFIED: 11/12/98       BY: *J30M* Seema Varma      */
/* REVISION: 9.0    LAST MODIFIED: 12/01/98       BY: *K1QY* Suresh Nayak     */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99       BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1    LAST MODIFIED: 10/01/99       BY: *N014* Patti Gaultney   */
/* REVISION: 9.1    LAST MODIFIED: 08/20/99       BY: *J3KX* J. Fernando      */
/* REVISION: 9.1    LAST MODIFIED: 01/19/00       BY: *N077* Vijaya Pakala    */
/* REVISION: 9.1    LAST MODIFIED: 02/02/00       BY: *N07K* Pat Pigatti      */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00       BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00       BY: *N0KP* Mark Brown       */
/* REVISION: 9.1    LAST MODIFIED: 12/21/00       BY: *N0V9* Jyoti Thatte     */
/* Revision: 1.36        BY: Katie Hilbert        DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.37        BY: Niranjan Ranka       DATE: 07/13/01  ECO: *P00L* */
/* Revision: 1.38        BY: Rajaneesh Sarangi    DATE: 12/17/01  ECO: *M1SC* */
/* Revision: 1.39        BY: Jean Miller          DATE: 04/17/02  ECO: *P05L* */
/* Revision: 1.40        BY: Patrick Rowan        DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.41        BY: Tiziana Giustozzi    DATE: 05/24/02  ECO: *P03Z* */
/* Revision: 1.42        BY: Jean Miller          DATE: 06/07/02  ECO: *P080* */
/* Revision: 1.43        BY: Kirti Desai          DATE: 06/11/02  ECO: *N1L2* */
/* Revision: 1.44        BY: R.Satya Narayan      DATE: 06/25/02  ECO: *P086* */
/* Revision: 1.48        BY: Kirti Desai          DATE: 07/05/02  ECO: *N1NC* */
/* Revision: 1.49        BY: Robin McCarthy       DATE: 07/15/02  ECO: *P0BJ* */
/* Revision: 1.50        BY: Tiziana Giustozzi    DATE: 09/11/02  ECO: *P0DR* */
/* Revision: 1.62        BY: Andrea Suchankvoa    DATE: 10/18/02  ECO: *N13P* */
/* Revision: 1.64        BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.65        BY: Rajinder Kamra       DATE: 07/22/03  ECO: *Q013* */
/* Revision: 1.68        BY: Paul Donnelly        DATE: 09/29/03  ECO: *Q03V* */
/* Revision: 1.69        BY: Salil Pradhan        DATE: 11/12/03  ECO: *P197* */
/* Revision: 1.70        BY: Pankaj Goswami       DATE: 12/16/03  ECO: *P1FV* */
/* Revision: 1.72        BY: Gaurav Kerkar        DATE: 04/22/04  ECO: *P1Y5* */
/* Revision: 1.73        BY: Ed van de Gevel      DATE: 05/17/04  ECO: *Q07S* */
/* Revision: 1.75        BY: Shivaraman V.        DATE: 09/21/04  ECO: *P2L5* */
/* Revision: 1.75.4.2    BY: Robin McCarthy       DATE: 08/11/05  ECO: *P2PJ* */
/* Revision: 1.75.4.3    BY: Steve Nugent         DATE: 09/09/05  ECO: *Q0LM* */
/* Revision: 1.75.4.4    BY: Salil Pradhan        DATE: 10/19/05  ECO: *P40M* */
/* Revision: 1.75.4.5    BY: Priya Idnani         DATE: 10/24/05  ECO: *P44H* */
/* Revision: 1.75.4.8    BY: Hitendra PV          DATE: 10/27/05  ECO: *P46G* */
/* Revision: 1.75.4.9    BY: Robin McCarthy       DATE: 03/01/06  ECO: *P4JX* */
/* Revision: 1.75.4.10   BY: Jean Miller          DATE: 03/02/06  ECO: *Q0PD* */
/* Revision: 1.75.4.11   BY: Mochesh Chandran     DATE: 05/30/06  ECO: *P4GG* */
/* Revision: 1.75.4.12   BY: Jayesh Sawant        DATE: 08/12/06  ECO: *P51P* */
/* Revision: 1.75.4.13   BY: Nancy Philip         DATE: 04/13/07  ECO: *P5TB* */
/* Revision: 1.75.4.14   BY: Sandeep Panchal      DATE: 05/18/07  ECO: *P5X1* */
/* Revision: 1.75.4.18   BY: Prajakta Patil       DATE: 10/09/07  ECO: *P695* */
/* Revision: 1.75.4.20   BY: Rajalaxmi Ganji      DATE: 03/28/08  ECO: *P6PC* */
/* $Revision: 1.75.4.21 $  BY: Keny Fernandes       DATE: 02/17/12  ECO: *Q57R* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */
{cxcustom.i "RSPOMTB.P"}
define input parameter po_recid    as recid.
define input parameter consignment as logical.

define shared frame po.
define shared frame po1.
define shared frame pod.
define shared frame pod1.
define shared frame pod2.

define new shared variable global_curr  as   character.
define new shared variable global_order as   character.
define new shared variable new_site     like si_site.
define new shared variable err_stat     as   integer.
define new shared variable so_db        like dc_name.
define new shared variable any_msgs     as   logical.

define shared variable tax_in  like ad_tax_in.
define shared variable cmtindx like cmt_indx.
define shared variable impexp  like mfc_logical no-undo.

define variable line              as   integer        no-undo.
define variable yn                like mfc_logical.
define variable new-pod           like mfc_logical.
define variable erslst            like ers_pr_lst_tp  no-undo.
define variable ers-err           as   integer        no-undo.
define variable ersopt            like ers_opt        no-undo.
define variable del-yn            like mfc_logical.
define variable scx_recid         as   recid          no-undo.
define variable valid_acct        like mfc_logical.
define variable zone_to           like txz_tax_zone   no-undo.
define variable zone_from         like txz_tax_zone   no-undo.
define variable old_pod_site      like pod_site       no-undo.
define variable schedule_found    like mfc_logical.
define variable somrp_found       as   logical        no-undo.
define variable err-flag          as   integer        no-undo.
define variable old_db            like si_db          no-undo.
define variable found_price       like mfc_logical.
define variable save_supp_part    like vp_vend_part   no-undo.
define variable i                 as   integer        no-undo.
define variable counter           as   integer        no-undo.
define variable ptstatus          like pt_status      no-undo.
define variable newline           as   integer        no-undo.
define variable shipper_found     as   integer        no-undo.
define variable save_abs          like abs_par_id     no-undo.
define variable l_continue        like mfc_logical    no-undo.
define variable mc-error-number   like msg_nbr        no-undo.
define variable l_deactivate      like mfc_logical    no-undo.
define variable l_pod_um_conv     like pod_um_conv    no-undo.
define variable imp-okay          like mfc_logical    no-undo.
define variable subtype           as   character format "x(12)"
   label "Subcontract Type" no-undo.
define variable l_adg_module       as   logical   initial false no-undo.
define variable l_blank            as   character initial ""    no-undo.
define variable use-log-acctg      as   logical                 no-undo.
define variable purcost            like pod_pur_cost            no-undo.
define variable unitcost           like pod_pur_cost            no-undo.
define variable result             as character no-undo.
define variable lineOk             as logical    no-undo.
define variable partOk             as logical    no-undo.
define variable ersOk              as logical    no-undo.
define variable oldErs             like pod_ers_opt.
define variable notOk              as logical    no-undo.
define variable part               like scx_part no-undo.
define variable l_old_um           like pod_um   no-undo.
define variable l_vend_avail       like mfc_logical no-undo.
define variable l_part             like pt_part     no-undo.

define variable l_save_suppum      like pod_um          no-undo.
define variable l_save_suppumconv  like pod_um_conv     no-undo.
define variable l_consign          like pod_consignment no-undo.
define variable l_prev_pod_type    like pod_type        no-undo.

define variable l_change_db    like mfc_logical no-undo.
define variable po_db          like dc_name     no-undo.
define variable l_db_undo      like mfc_logical no-undo.
define variable connect_db     like dc_name     no-undo.

/*COMMON API CONSTANTS AND VARIABLES*/
{mfaimfg.i}

/*PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{popoit01.i}

/*Schedule Cross Reference temp table*/
{scxit01.i}
{mfctit01.i}
{gprunpdf.i "gpglvpl" "p"}
{gprunpdf.i "mcpl" "p"}

/* Consignment variables */
{pocnvars.i}
/* Consignment procedures and frames */
{pocnpo.i}
{&RSPOMTB-P-TAG1}

if c-application-mode = "API" then do on error undo, return error:

   /*GET HANDLE OF API CONTROLLER*/
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                           output ApiProgramName,
                           output ApiMethodName,
                           output apiContextString)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   create ttPurchaseOrderDet.
   run getFirstPoToDetLink in ApiMethodHandle
        (buffer ttPurchaseOrderDet).
   result = RETURN-VALUE.

   run getPurchaseOrderDetCmt in ApiMethodHandle
       (output table ttPurchaseOrderDetCmt).

   run getScheduleCrossRef in ApiMethodHandle
       (output table ttScheduleCrossRef).

   run getNextScheduleCrossRef (buffer ttScheduleCrossRef).
end.  /* If c-application-mode = "API" */
{rsordfrm.i}
/* DECLARATIONS FOR gptxcval.i */
{gptxcdec.i}

/* TAX ENVIRONMENT FORM */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
pod_tax_usage     colon 25
   pod_tax_env       colon 25
   pod_tax_in        colon 25
 SKIP(.4)  /*GUI*/
with frame set_tax row 8 overlay centered side-labels attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-set_tax-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame set_tax = F-set_tax-title.
 RECT-FRAME-LABEL:HIDDEN in frame set_tax = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame set_tax =
  FRAME set_tax:HEIGHT-PIXELS - RECT-FRAME:Y in frame set_tax - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME set_tax = FRAME set_tax:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame set_tax:handle).

using_supplier_consignment = consignment.

for first poc_ctrl
   fields( poc_domain poc_ers_proc poc_hcmmts poc_insp_loc poc_lcmmts)
    where poc_ctrl.poc_domain = global_domain no-lock:
end. /* FOR FIRST poc_ctrl */

for first icc_ctrl
   fields( icc_domain icc_cur_cost icc_cur_set icc_gl_set)
    where icc_ctrl.icc_domain = global_domain no-lock:
end. /* FOR FIRST icc_ctrl */

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


pocmmts = poc_hcmmts.

run readpo_mstr(input  po_recid,
                input  "no-lock",
                buffer po_mstr).

run readvd_mstr(input  po_vend,
                buffer vd_mstr).

run readad_mstr (input  po_vend,
                 buffer ad_mstr).

assign
   global_order = po_nbr
   global_addr  = po_vend.

if c-application-mode <> "API" then
do:
   clear frame pod no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame pod = F-pod-title.
   clear frame pod1 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame pod1 = F-pod1-title.
   clear frame pod2 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame pod2 = F-pod2-title.
end.  /* If c-application-mode <> "API" */

{&RSPOMTB-P-TAG2}
detailloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

   if (c-application-mode = "API") and retry then
      undo detailloop, return error.

   if (c-application-mode = "API") and
      (result = {&RECORD-NOT-FOUND}) and
      (not available (ttScheduleCrossRef))then
      leave.

   if c-application-mode <> "API" then
   do:
      hide frame pod1 no-pause.
      hide frame pod2 no-pause.
   end.  /* If c-application-mode <> "API" */

   /* FIND OR CREATE DETAIL RECORD */

   save_supp_part = "".

   do with frame pod:
      /* DO NOT RETRY WHEN PROCESSING API REQUEST */
      if retry and c-application-mode = "API" then
         undo detailloop, return.

      if c-application-mode <> "API" then
      do:
         display po_site @ scx_shipto.
         prompt-for
            scx_part
            scx_shipto
            scx_line
         editing:
            if frame-field = "scx_part"
            then do:

               /* REPLACED "INPUT SCX_PART" TO "INPUT FRAME POD SCX_PART" */
               {mfnp05.i scx_ref scx_po " scx_ref.scx_domain = global_domain
               and scx_type  = 2
               and scx_po = po_nbr"
               scx_part "input frame pod scx_part"}

               if recno <> ?
               then do:
                  run readpt_mstr (input  scx_part,
                                   buffer pt_mstr).
                  run readpod_det (input  po_nbr,
                                   input  scx_line,
                                   buffer pod_det).
                  run readsi_mstr (input  scx_shipto,
                                   buffer si_mstr).
                  global_site = pod_site.

                  display
                     scx_part
                     scx_shipto
                     si_desc
                     pod_vpart
                     scx_line.
                  if pod_vpart = ""
                  then
                     display
                        pt_desc1 @ pod_vpart
                        pt_desc2 @ pt_desc1.
                  else
                     display
                        pt_desc1 @ pt_desc1.
               end. /* IF recno <> ? */
            end. /* IF frame-field = "scx_part" */
            else
               if frame-field = "scx_shipto"
               then do:
                  /* REPLACED "INPUT SCX_PART" TO "INPUT FRAME POD SCX_PART"
                  AND "INPUT SCX_SHIPTO" TO "INPUT FRAME POD SCX_SHIPTO" */
                  {mfnp05.i scx_ref scx_po " scx_ref.scx_domain = global_domain
                  and scx_type  = 2
                     and scx_po = po_nbr and
                     scx_part = input frame pod scx_part"
                     scx_shipto "input frame pod scx_shipto"}

                  if recno <> ?
                  then do:
                     run readpt_mstr (input  scx_part,
                                      buffer pt_mstr).
                     run readpod_det (input  po_nbr,
                                      input  scx_line,
                                      buffer pod_det).
                     run readsi_mstr (input  scx_shipto,
                                      buffer si_mstr).
                     global_site = pod_site.

                     display
                        scx_part
                        scx_shipto
                        si_desc
                        pod_vpart
                        scx_line.
                     if pod_vpart = ""
                     then
                        display
                           pt_desc1 @ pod_vpart
                           pt_desc2 @ pt_desc1.
                     else
                        display
                           pt_desc1 @ pt_desc1.
                  end. /* IF recno <> ? */
               end. /* IF frame-field = "scx_shipto" */
               else
               if frame-field = "scx_line"
               then do:
                     {mfnp05.i scx_ref scx_order " scx_ref.scx_domain =
                     global_domain and scx_type  = 2
                        and scx_order = po_nbr"
                        scx_line "input frame pod scx_line"}

                     if recno <> ?
                     then do:
                        run readpt_mstr (input  scx_part,
                                         buffer pt_mstr).
                        run readpod_det (input  po_nbr,
                                         input  scx_line,
                                         buffer pod_det).
                        run readsi_mstr (input  scx_shipto,
                                         buffer si_mstr).
                        global_site = pod_site.

                        display
                           scx_part
                           scx_shipto
                           si_desc
                           pod_vpart
                           scx_line.
                        if pod_vpart = ""
                        then
                           display
                              pt_desc1 @ pod_vpart
                              pt_desc2 @ pt_desc1.
                        else
                           display
                              pt_desc1 @ pt_desc1.
                  end. /* IF recno <> ? */
               end. /* IF frame-field = "scx_line" */
               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end. /* ELSE DO */
         end. /* EDITING */

         if frame pod scx_line entered
            and input frame pod scx_line = 0
         then do:
         /* INVALID LINE NUMBER */
         run display_message_mfmsg03
            (input 642,
             input 4,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).
            undo, retry.
         end. /* IF FRAME POD SCX_LINE ENTERED... */

         /* REPLACED "scx_part" TO "frame pod scx_part" */
         if frame pod scx_line entered
         and not frame pod scx_part entered
         then do:
            run readpod_det (input  po_nbr,
                             input  input frame pod scx_line,
                             buffer pod_det).

            if available pod_det
            then do:
               global_site = pod_site.

               display
                  pod_part @ scx_part
                  pod_site @ scx_shipto.
            end. /* IF AVAILABLE pod_det */
         end. /* IF FRAME pod scx_line ENTERED */
      end. /* c-application-mode <> "API" */
      else do: /* c-application-mode = "API" */
         if ttScheduleCrossRef.line <> ?  and ttScheduleCrossRef.part = ? then

            for first pod_det  where pod_det.pod_domain = global_domain and
            pod_nbr = po_nbr and
            pod_line = ttScheduleCrossRef.line:
               global_site = pod_site.
            end.
      end. /* c-application-mode = "API" */

      if c-application-mode <> "API" then
      do:
         run readpt_mstr (input  frame pod scx_part,
                          buffer pt_mstr).

         if not available pt_mstr
         then do:
            run replaceSupplierItem (input  input frame pod scx_part,
                                     input  po_vend,
                                     output l_part,
                                     output l_vend_avail,
                                     output l_save_suppum,
                                     output l_save_suppumconv).

            run readpt_mstr (input l_part,
                             buffer pt_mstr).

            if l_vend_avail = no
               and available pt_mstr
            then
               run getVendorItem (input pt_part,
                                  input po_vend,
                                  input input frame pod scx_part,
                                  output save_supp_part).
            else do:
               /* ITEM NUMBER DOES NOT EXIST */
               run display_message_mfmsg03
               (input 16,
                input 3,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank).
               undo, retry.
            end. /* ELSE DO */
         end. /* IF NOT AVAILABLE pt_mstr */
         /* INITIALIZE SUPPLIER ITEM IF AVAILABLE */
         else do:
            /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
            /* FOR AN INVENTORY ITEM                                      */
            if can-find(first vp_mstr
                where vp_mstr.vp_domain = global_domain
                and   vp_part = input frame pod scx_part
                and  ( vp_vend = po_vend
                       or (vp_vend = ""
                           and not can-find(first vp_mstr
                           where vp_domain = global_domain
                           and   vp_part = input frame pod scx_part
                           and   vp_vend = po_vend)) ) )
            then
            /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
            /* FOR AN INVENTORY ITEM                                      */
            for each vp_mstr
               fields(vp_domain vp_part vp_q_date vp_vend vp_vend_part)
               where vp_mstr.vp_domain = global_domain
               and   vp_part = input frame pod scx_part
               and ( vp_vend = po_vend
                      or (vp_vend = ""
                          and not can-find(first vp_mstr
                          where vp_domain = global_domain
                          and   vp_part = input frame pod scx_part
                          and   vp_vend = po_vend)) )
               no-lock
               break by vp_q_date descending:

               if first(vp_q_date)
               then do:
                  save_supp_part = vp_vend_part.
                  leave.
               end. /* IF FIRST VP_Q_DATE */
            end. /* FOR EACH VP_MSTR */
         end. /* ELSE OF IF NOT AVAILABLE PT_MSTR */
      end. /* c-application-mode <> "API" */
      else do:
         run checkPart (buffer po_mstr,
                        buffer scx_ref,
                        output partOk).

         if not(partOk) then
            undo, return error.
      end. /* c-application-mode = "API" */

      /*  CHECK TO SEE WHETHER THE PART IS RESTRICTED FROM THE
          BEING USED IN A PO - CODE COPIED FROM popomte.p. */
      assign
         ptstatus                = pt_status.
         substring(ptstatus,9,1) = "#".

      if can-find(isd_det
          where isd_det.isd_domain = global_domain and  isd_status = ptstatus
         and isd_tr_type = "ADD-PO")
      then do:
         /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE XXX */
         run display_message_mfmsg03
            (input 358,
             input 3,
             input pt_status,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).
         if c-application-mode <> "API" then
            undo, retry.
         else
            undo detailloop, return error.
      end. /* IF CAN-FIND(isd_det */

      if c-application-mode <> "API"  then
         assign part = input frame pod scx_shipto.
      else
         assign part = ttScheduleCrossRef.shipto.

      run checkSiteDetails(buffer si_mstr,
                           input part,
                           output notOk).
      if  notOk then
         if c-application-mode <> "API" then
            undo, retry.
         else
            undo detailloop, return error.

      run getPtpDet(buffer ptp_det,
                    buffer pt_mstr,
                    input si_site).

     if c-application-mode <> "API" then
         run find-scx-ref (buffer scx_ref,
                           buffer po_mstr,
                           input global_domain,
                           input input frame pod scx_shipto,
                           input input frame pod scx_part).

      else
         run find-scx-ref (buffer scx_ref,
                           buffer po_mstr,
                           input global_domain,
                           input ttScheduleCrossRef.shipto,
                           input ttScheduleCrossRef.part).

      if not available scx_ref
      then do:

         /* LOGIC TO WRAP AROUND IF THE LINE# LIMIT IS REACHED AND TO
            SEEK ANY UNUSED LINE NUMBER. CODE COMPLEMENTS THE FUNCTIONALITY
            OF ARCHIVE/DELETE OF SCHEDULE LINE*/
         for last pod_det
            fields( pod_domain pod_acct pod_cc pod_cmtindx pod_consignment
                   pod_cst_up pod_cum_date pod_cum_qty pod_curr_rlse_id
                   pod_end_eff pod_ers_opt pod_fab_days pod_firm_days
                   pod_insp_rqd pod_line pod_loc pod_max_aging_days
                   pod_nbr pod_op pod_ord_mult pod_part pod_pkg_code
                   pod_plan_days pod_plan_mths pod_plan_weeks pod_po_db
                   pod_po_site pod_pr_list pod_pr_lst_tp pod_pst
                   pod_pur_cost pod_raw_days pod_rev pod_sched
                   pod_sched_chgd pod_sd_pat pod_sftylt_days pod_site
                   pod_start_eff pod_sub pod_taxable pod_taxc pod_tax_env
                   pod_tax_in pod_tax_usage pod_translt_days pod_type
                   pod_um pod_um_conv pod_vpart pod_wo_lot pod__qad16)
             where pod_det.pod_domain = global_domain and  pod_nbr = po_nbr
            no-lock:
         end. /* FOR LAST pod_det */

         line = 1.
         run checkLineNo (input po_nbr,
                          input-output line,
                          output lineOk).
         if not(lineOK) then
            if c-application-mode = "API" then
               undo detailloop, return error.
            else
               undo, retry.

         /* ADDING NEW RECORD */
         run display_message_mfmsg03
            (input 1,
             input 1,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).

         create scx_ref.
         if c-application-mode <> "API" then
         do:
            assign
               scx_ref.scx_domain = global_domain
               scx_type     = 2
               scx_shipfrom = po_vend
               scx_shipto   = input frame pod scx_shipto
               scx_part     = input frame pod scx_part
               scx_po       = po_nbr
               scx_order    = po_nbr.

            /* IF USER ENTERED LINE NUMBER IT'S OK IF IT'S UNUSED */
            if frame pod scx_line entered
            and line <> input frame pod scx_line
            then do:

               newline = input frame pod scx_line.

               if not can-find (scx_ref  where scx_ref.scx_domain =
               global_domain and  scx_type = 2 and
                                              scx_order = po_nbr and
                                              scx_line = newline) and
                  not can-find (pod_det  where pod_det.pod_domain =
                  global_domain and  pod_nbr = po_nbr
                                          and pod_line = newline)
               then
                  line = newline.

            end. /* IF FRAME pod scx_line ENTERED */

            display
               line @ scx_line.
         end. /* c-application-mode <> "API" */
         else
            run getScheduleLine(buffer po_mstr,
                                buffer scx_ref,
                                buffer pod_det,
                                input-output line).

         create pod_det.
         assign
            pod_det.pod_domain = global_domain
            scx_line        = line
            new-pod         = yes
            pod_nbr         = po_nbr
            pod_line        = scx_line
            pod_part        = scx_part
            pod_site        = scx_shipto
            pod_sched       = yes
            pod_taxable     = (po_taxable and pt_taxable)
            pod_tax_usage   = po_tax_usage
            pod_tax_in      = tax_in
            pod_taxc        = pt_taxc
            pod_pst         = po_pst
            pod_po_db       = global_db
            pod_um          = pt_um
            pod_um_conv     = 1
            pod_ord_mult    = 1
            pod_acct        = vd_pur_acct
            pod_sub         = vd_pur_sub
            pod_cc          = vd_pur_cc
            pod_rev         = if available ptp_det
                              then
                                 ptp_rev
                              else
                                 pt_rev
            pod_insp_rqd    = if available ptp_det
                              then
                                 ptp_ins_rqd
                              else
                                 pt_insp_rqd
            pod_loc         = if pod_insp_rqd
                              then
                                 poc_insp_loc
                              else
                                 pt_loc
            pod_cum_date[1] = today
            pod_vpart       = save_supp_part
            pod__qad16      = subtype
            pod_pr_list     = vd_pr_list.

         if l_save_suppum <> ""
         then
            assign
               pod_um      = l_save_suppum
               pod_um_conv = l_save_suppumconv.

         if recid(pod_det) = -1 then .

         /* DETERMINE CONSIGNMENT SETTINGS */
         if using_supplier_consignment
         then do:
            {pxrun.i &PROC = 'initializeSuppConsignDetailFields'
                     &PARAM="(input po_vend,
                              input pod_part,
                              input po_consignment,
                              input po_max_aging_days,
                              output pod_consignment,
                              output pod_max_aging_days)"}
         end.  /* IF using_supplier_consignment */

         if c-application-mode = "API" then
         do:
            /* Create External line cross reference */
            {gprun.i ""gpxrcrln.p"" "(input pod_nbr,
                                      input pod_line,
                                      input '',
                                      input ttPurchaseOrderDet.lineExtRef,
                                      input 'po')"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         /* KEEP TAX ENV. BLANK TO INVOKE SUGGESTION OF TAX ENV. */

         run checkSite(buffer si_mstr,
                       buffer pod_det,
                       input po_site).

         pod_cst_up = if icc_cur_cost = "NONE"
                      then
                         no
                      else
                         yes.

         l_change_db = no.
         for first si_mstr
            where si_mstr.si_domain = global_domain and
                          si_site   = pod_site no-lock.
            if si_db <> global_db
            then do:
               l_change_db = true.
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.


         if l_change_db
         then do:
            po_db = global_db.
            {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            assign
               connect_db = po_db
               l_db_undo  = no.

            Run check-db-connect (input connect_db, input-output l_db_undo).

            if l_db_undo then
               undo detailloop, leave detailloop.
         end. /* End do loop */

         {gprun.i ""gpsct05.p"" "(pod_part, pod_site, 2,
             output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

             pod_pur_cost = glxcst.

         if l_change_db
         then do:
            {gprun.i ""gpalias3.p"" "(po_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            assign
               connect_db = po_db
               l_db_undo  = no.

            Run check-db-connect (input connect_db, input-output l_db_undo).

            if l_db_undo then
               undo detailloop, leave detailloop.
         end. /* End do loop */

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         run curr_conv
            (input base_curr,
             input po_curr,
             input po_ex_rate2,
             input po_ex_rate,
             input pod_pur_cost,
             input false, /* DO NOT ROUND */
             output pod_pur_cost,
             output mc-error-number).

         if use-log-acctg
            and po_tot_terms_code <> ""
            and glxcst <> 0 then do:

            if po_curr = base_curr
             and pod_pur_cost = glxcst
            then

               /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
               run log_terms_trade
                  (input pod_um,
                   input glxcst,
                   input po_nbr,
                   input pod_part,
                   input pod_site,
                   output pod_pur_cost).

            else if po_curr <> base_curr
            then
               run notBaseCurrency (buffer po_mstr,
                                    buffer pod_det).
         end. /* IF use-log-acctg */

         run assign-acct (buffer pod_det,
                          buffer vd_mstr,
                          input global_domain,
                          input pt_prod_line).

         yn = yes.
         if c-application-mode <> "API" then

            /* COPY DATA FROM ANOTHER ORDER LINE FOR THIS ITEM? */
            run display_message_mfmsg01
               (input        8231,
                input        1,
                input-output yn).
         else /* c-application-mode = "API" */
            yn = no.

         if yn
         then do:
            {gprun.i ""rspomta.p"" "(input recid(pod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* IF yn */
      end. /* IF NOT available scx_ref */
      else do:
         for first pod_det  where pod_det.pod_domain = global_domain and
         pod_nbr = scx_order
            and pod_line = scx_line exclusive-lock:
         end.
         new-pod = no.
      end. /* ELSE DO */

      assign
         new_site    = pod_site
         global_part = pt_part
         so_db       = global_db.

      {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


      if err_stat > 1
      then do:
         /* ITEM DOES NOT EXIST AT THIS SITE */
         run display_message_mfmsg03
            (input 715,
             input 3,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).
         if c-application-mode <> "API" then
            undo, retry.
         else
            undo detailloop, return error.
      end. /* IF err_stat > 1 */

      if c-application-mode <> "API" then
      do:
         display
            scx_part
            pod_vpart
            scx_line.

         if pod_vpart = "" then
            display
               pt_desc1 @ pod_vpart
               pt_desc2 @ pt_desc1.
            else
               display
                  pt_desc1 @ pt_desc1.
      end. /*if c-application-mode <> "API"*/
   end. /* DO WITH FRAME pod */

   if l_save_suppum <> ""
   then
      pod_pur_cost = pod_pur_cost * l_save_suppumconv.

   l_save_suppum = "".

   subtype = pod__qad16.

   assign
      l_consign       = pod_consignment
      l_prev_pod_type = pod_type.

   loop1:
   do on error undo,retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      if c-application-mode <> "API" then
         /* DETAIL DATA ITEMS FRAME 1 */
         display
            pod_pr_list
            pod_pur_cost
            pod_acct
            pod_sub
            pod_cc
            pod_taxable
            pod_taxc
            pod_type
            pod_cst_up
            pod_loc
            pod_um
            pod_um_conv
            pod_wo_lot
            pod_consignment
            pod_op
            pod_rev
            subtype
         with frame pod1.

      l_old_um = pod_um.

      do with frame pod1 on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         /* DO NOT RETRY WHEN PROCESSING API REQUEST */
         if retry and c-application-mode = "API" then
            undo ,return error.

         ststatus = stline[2].
         status input ststatus.

         assign
            global_part = pod_part
            global_curr = po_curr.
         if c-application-mode <> "API"
         then do:
            set
               pod_pr_list
               pod_pur_cost
               pod_acct
               pod_sub
               pod_cc
               pod_taxable
               pod_taxc
               pod_type
               pod_consignment when (using_supplier_consignment)
               pod_cst_up
               pod_loc
               pod_um
               pod_rev
            go-on("F5" "CTRL-D").

            if l_consign <> pod_consignment
            then do:
               if can-find(first prh_hist
                              where prh_hist.prh_domain = global_domain
                              and   prh_nbr             = pod_nbr
                              and   prh_line            = pod_line)
               then do:

                  /* CANNOT MODIFY CONSIGNMENT STATUS. PO LINE HAS RECEIPT */
                  {pxmsg.i &MSGNUM=6897 &ERRORLEVEL=4}

                  undo loop1.
               end. /* IF CAN-FIND(prh_hist... */
            end. /* IF l_consign <> pod_consignment */
         end. /* IF c-application-mode <> "API" */

         else
            run setPodLineDetailPart (buffer pod_det).

         del-yn = no.
         if c-application-mode <> "API" then
         do:
            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               /* PLEASE CONFIRM DELETE */
               run display_message_mfmsg01
                  (input        11,
                   input        1,
                   input-output del-yn).

            if not del-yn then undo, retry.
            end. /* IF lastkey = keycode("F5") */
         end. /* c-application-mode <> "API" */
         else  /* c-application-mode = "API" */
            del-yn = (ttPurchaseOrderDet.operation = {&REMOVE}).

         if del-yn
         then do:

            shipper_found = 0.

            {gprun.i ""rsschck.p""
               "(input  pod_nbr,
                 input  pod_line,
                 input  scx_part,
                 input  scx_shipto,
                 output schedule_found,
                 output somrp_found,
                 output shipper_found,
                 output save_abs)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if schedule_found
            then do:
               /* SCHEDULE EXISTS, DELETE NOT ALLOWED */
               run display_message_mfmsg03
                  (input 6022,
                   input 3,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank).
               if c-application-mode <> "API" then
                  undo, retry.
               else
                  undo, return error.
            end. /* IF schedule_found */

            if somrp_found
            then do:
               /* USED IN SCHEDULED ORDER MRP % TABLE */
               run display_message_mfmsg03
                  (input 6027,
                   input 4,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank).
               if c-application-mode <> "API" then
                  undo, retry.
               else
                  undo, return error.
            end. /* IF somrp_found */

            if shipper_found >= 1
            then do:

               save_abs = substring(save_abs,2,12).
               /* # SHIPPERS/CONTAINERS EXIST FOR ORDER, INCLUDING #" */
               run display_message_mfmsg03
                  (input 1118,
                   input 2,
                   input shipper_found,
                   input save_abs,
                   input l_blank,
                   input l_blank,
                   input l_blank).

               if c-application-mode <> "API"
               then
                  /* PLEASE CONFIRM DELETE */
                  run display_message_mfmsg01
                     (input        11,
                      input        1,
                      input-output del-yn).
               else
                  del-yn = (ttPurchaseOrderDet.operation = {&REMOVE}).

               if not del-yn then
                  if c-application-mode <> "API" then
                     undo, retry.
                  else
                     undo, return.
            end. /* IF shipper_found >= 1 */

            for first prh_hist
               fields( prh_domain prh_line prh_nbr)
                where prh_hist.prh_domain = global_domain and  prh_nbr = pod_nbr
               and prh_line = pod_line
               no-lock:

            end. /* FOR FIRST prh_hist */

            if available prh_hist
            then do:
               /* DELETE NOT ALLOWED, PO LINE HAS RECEIPTS */
               run display_message_mfmsg03
                  (input 364,
                   input 4,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank).
               if c-application-mode = "API" then
                  undo, retry.
               else
                  undo,return error.
            end. /* IF AVAILABLE prh_hist THEN */

            {gprun.i ""rssddel.p"" "(input recid(pod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.


            {&RSPOMTB-P-TAG11}
            if c-application-mode <> "API" then
            do:
               hide frame pod1.

               clear frame pod no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame pod = F-pod-title.
               if available(po_mstr) then
                  next detailloop.
               else
                  return.
             end. /* c-application-mode <> "API" */
             else
             do:
                if available (po_mstr) then
                do:
                   run getNextPoAndScxRecord(buffer ttScheduleCrossRef,
                                             buffer ttPurchaseOrderDet,
                                             output result).
                   next detailloop.
                end.
                else
                   return.
            end. /* if c-applcation-mode = API then*/

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF del-yn */

         if pod_pr_list <> ""
         then do:

            found_price = no.

            /* Validate that the Price List exists using the current date instead
            of the Scheduled Order Date since these orders can be added to
            over long periods of time.  To use the Scheduled Order Date
            would mean that pricing list Effective Dates would have to be
            backdated to the date the order was originally entered.  This
            is not only impractical but could also lead to other problems.
            NB: Prior to patch G013, no date limitation existed. This patch
            only changes validation.  The actual pricing assignment
            occurs during scheduled shipper confirmation (receipt) and uses
            the Effective Date specified at that time.  */

            {gprun.i ""rcpccal1.p""
               "(input  pod_part,
                 input  pod_pr_list,
                 input  today,
                 input  pod_um,
                 input  po_curr,
                 output found_price)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if found_price = false
            then do:
               if poc_pl_req
               then do:
                  /* REQUIRED DISCOUNT TABLE FOR ITEM # IN UM # NOT FOUND */
                  run display_message_mfmsg03
                     (input 982,
                      input 3,
                      input pod_part,
                      input pod_um,
                      input l_blank,
                      input l_blank,
                      input l_blank).
                  undo, retry.
               end. /* IF poc_pl_req */
               else do:
                  /* REQUIRED DISCOUNT TABLE FOR ITEM # IN UM # NOT FOUND */
                  run display_message_mfmsg03
                     (input 982,
                      input 2,
                      input pod_part,
                      input pod_um,
                      input l_blank,
                      input l_blank,
                      input l_blank).
               end. /* ELSE DO */
            end. /* IF found_price = FALSE */
         end. /* IF pod_pr_list <> "" */
         else do:
            if poc_pl_req
            then do:
               /* REQUIRED DISCOUNT TABLE FOR ITEM # IN UM # NOT FOUND */
               run display_message_mfmsg03
                  (input 982,
                   input 3,
                   input pod_part,
                   input pod_um,
                   input l_blank,
                   input l_blank,
                   input l_blank).
               undo, retry.
            end. /* IF poc_pl_req */
         end. /* ELSE DO */

         run setAccValidation (buffer pod_det).

         if valid_acct = no
         then do:
            if c-application-mode <> "API" then
            do:
               next-prompt pod_acct with frame pod1.
               undo, retry.
            end. /* c-application-mode <> "API" */
            else
               undo, return error.
         end. /* IF valid_acct = no */

         if not (pod_type = ""
         or pod_type = "s")
         then do:
            /* INVALID TYPE CODE */
            run display_message_mfmsg03
               (input 4211,
                input 3,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank).
            if c-application-mode <> "API" then
            do:
              next-prompt pod_type.
              undo, retry.
            end. /* c-application-mode <> "API" */
            else
                undo, return error.
         end. /* IF NOT (pod_type = "" */

         if  c-application-mode <> "API"
            and pod_type        <> l_prev_pod_type
            and not new-pod
            and pod_curr_rlse_id[1] <> ""
         then do:

            /* ACTIVE SCHEDULE EXISTS. PLANNED DATA MAY NOT BE */
            /* CARRIED FORWARD                                 */
            run display_message_mfmsg03
               (input 2360,
                input 2,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank).

            /* DEACTIVATE ACTIVE SCHEDULE? - YES/NO            */
            run display_message_mfmsg01
               (input        2361,
                input        1,
                input-output l_deactivate).

            if l_deactivate
            then do:

               assign
                  l_prev_pod_type     = pod_type
                  pod_curr_rlse_id[1] = "".

               if pod_type = "s"
               then
                  for each mrp_det
                     fields(mrp_domain mrp_dataset
                            mrp_part
                            mrp_nbr
                            mrp_line)
                     where mrp_domain  = global_domain
                     and   mrp_dataset = "ss sch_mstr"
                     and   mrp_part    =  pod_part
                     and   mrp_nbr     =  pod_nbr
                     and   mrp_line    =  string(pod_line)
                  exclusive-lock:

                     delete mrp_det.

                  end. /* FOR EACH mrp_det */

               else if pod_type = ""
               then do:

                  for each rps_mstr
                     fields(rps_domain rps_part
                            rps_site
                            rps_due_date
                            rps_record)
                     where rps_domain = global_domain
                     and   rps_part   = pod_part
                     and   rps_site   = pod_site
                  no-lock:

                     for each mrp_det
                        fields(mrp_domain mrp_dataset
                               mrp_part
                               mrp_nbr
                               mrp_line)
                        where mrp_domain  = rps_domain
                        and   mrp_dataset = "rps_mstr"
                        and   mrp_part    =  rps_part
                        and   mrp_nbr     = (string(year(rps_due_date),"9999")
                                            + string(month(rps_due_date),"99")
                                            + string(day(rps_due_date),  "99")
                                            + rps_site)
                        and   mrp_line    = string(rps_record)
                        exclusive-lock:

                        delete mrp_det.

                     end. /* FOR EACH mrp_det */
                  end. /* FOR EACH rps_mstr   */
               end. /* ELSE IF pod_type = ""  */
            end. /* IF l_deactivate */

            else do:

               assign
                  pod_type = l_prev_pod_type
                  pod_type:screen-value in frame pod1 = l_prev_pod_type.

                  undo, retry.

            end. /* ELSE DO */
         end. /* IF (c-application-mode <> "API"... */

     if     pod_type <> ""
        and pod_type <> "B"
    and pod_consignment
     then do:
        assign
       pod_consignment = no.
        display pod_consignment with frame pod1.
        /* Consignment status set to No. */
        {pxmsg.i &MSGNUM=7968 &ERRORLEVEL=1 &PAUSEAFTER=true}
     end. /* IF pod_type <> "" and pod_type <> "B" and pod_consignment */

         /* VALIDATE TAX CODE */
         {gptxcval.i &code=pod_taxc &frame="pod1"}

         /* GET TAX MANAGEMENT DATA */
         if pod_taxable
         then do:

            taxloop:
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               /* DO NOT RETRY WHEN PROCESSING API REQUEST */
               if retry and c-application-mode = "API" then
                  undo taxloop, return.
               /* SUGGEST TAX ENVIRONMENT */
               run checkTax (buffer pod_det,
                             buffer po_mstr,
                             buffer vd_mstr,
                             buffer ad_mstr,
                             buffer scx_ref,
                             input-output zone_from,
                             input-output zone_to).
               if c-application-mode <> "API" then
                  update
                     pod_tax_usage
                     pod_tax_env
                     pod_tax_in
                  with frame set_tax.
               else
                  run setAPITax (buffer pod_det).

                /* VALIDATE TAX USAGE */
                {pxrun.i  &PROC       = 'validateTaxUsage'
                          &PROGRAM    = 'txenvxr.p'
                          &PARAM      = "(input pod_tax_usage)"
                          &NOAPPERROR = true
                          &CATCHERROR = true}
               if return-value <> {&SUCCESS-RESULT}
               then  do:
                  if c-application-mode <> "API"
                  then do:
                     next-prompt pod_tax_usage with frame set_tax no-validate.
                     undo taxloop, retry .
                  end.
                  else
                     undo, return error.
               end. /*if return-value <> {&SUCCESS-RESULT} */


               /* VALIDATE TAX ENVIRONMENT -- BLANKS NOT ALLOWED */
               if pod_tax_env = ""
               then do:
                  /* BLANK TAX ENVIRONMENT NOT ALLOWED */
                  run display_message_mfmsg03
                     (input 944,
                      input 3,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).
                  if c-application-mode <> "API" then
                  do:
                     next-prompt pod_tax_env with frame set_tax.
                     undo taxloop, retry.
                  end. /* c-application-mode <> "API" */
                  else
                     undo taxloop, return error.
               end.  /* IF pod_tax_env = "" */

               if not {gptxe.v "pod_tax_env" ""no""}
               then do:
                  /* TAX ENVIRONMENT DOES NOT EXIST */
                  run display_message_mfmsg03
                     (input 869,
                      input 3,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).
                  if c-application-mode <> "API" then
                  do:
                     next-prompt pod_tax_env with frame set_tax.
                     undo taxloop, retry.
                  end. /* c-application-mode <> "API" */
                  else
                     undo taxloop, return  error.
               end.  /* IF NOT gptxe.v */
               if c-application-mode <> "API" then
                  hide frame set_tax.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* taxloop */
         end. /* IF pod_taxable */

         {&RSPOMTB-P-TAG12}
         if not pod_taxable and pod_tax_env = ""
         then
            pod_tax_env = po_tax_env.

         l_pod_um_conv = pod_um_conv.

         if l_old_um <> pod_um
         then do:
            if pt_um <> pod_um
            then
               /* CHECK FOR CONVERSION */
               run check_um_mstr (input        pt_um,
                                  input        pod_um,
                                  input        pod_part,
                                  input-output pod_um_conv).
            else
               pod_um_conv = 1.
         end. /* IF l_old_um <> pod_um */

         /*No F5/Delete Available */
         ststatus = stline[3].
         status input ststatus.
         if c-application-mode <> "API" then
            update
               pod_um_conv
               with frame pod1.
         else
            assign
               {mfaiset.i pod_um_conv  ttPurchaseOrderDet.umConv}.

         if l_pod_um_conv  <> pod_um_conv
         then
            run p-conv-cost
               (input-output pod_pur_cost,
                input        l_pod_um_conv,
                input        pod_um_conv).

         if can-find (first ie_mstr
             where ie_mstr.ie_domain = global_domain and  ie_type = "2"
            and ie_nbr =  pod_nbr)
         then do:
            imp-okay = no.
            {gprun.i ""iedetcr.p""
               "(input ""2"",
                 input pod_nbr,
                 input pod_line,
                 input recid(pod_det),
                 input-output imp-okay)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if imp-okay = no then
                  if c-application-mode <> "API" then
                     undo , retry.
                  else
                     undo, return.

         end. /* IF CAN-FIND (FIRST ie_mstr */

         /* DETERMINE RIGHT NOW WHAT THE VALID OPTIONS ARE */
         {gprun.i ""poers.p""
            "(input po_vend,
              input pod_site,
              input pod_part,
              output ersopt,
              output erslst,
              output ers-err)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* DETERMINE PROPER DEFAULT VALUES */
         if new-pod
         then do:
            if po_ers_opt = ""
            then
               assign
                  pod_ers_opt = ersopt
                  pod_pr_lst_tp = (if po_pr_lst_tp = 0
                                   then
                                      erslst
                                   else
                                      po_pr_lst_tp).
            else
               assign
                  pod_ers_opt = integer(po_ers_opt)
                  pod_pr_lst_tp = po_pr_lst_tp.
         end. /* IF NEW-POD */

         /* UPDATE ERS FIELDS ONLY IF ERS IS ENABLED */
         if available poc_ctrl
         and poc_ers_proc
         then do:

            ers-loop:
            do with frame poders on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               /* DO NOT RETRY WHEN PROCESSING API REQUEST */
               if retry and c-application-mode = "API" then
                  undo ers-loop, return  error.

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame poders:handle).
               if c-application-mode <> "API" then
               do:
                  display
                     pod_ers_opt   colon 23 skip
                     pod_pr_lst_tp colon 23 space(1)
                  with frame poders centered side-labels no-attr-space overlay
                     row (frame-row(pod1) + 3).

                  set
                     pod_ers_opt
                     pod_pr_lst_tp
                  with frame poders.
               end. /* c-application-mode <> "API" */
               else
                  run setAPIErs (buffer pod_det).

               /* VALIDATE ERS OPTION ENTERED IS VALID */
               if not({gppoders.v})
               then do:
                  /* INVALID ERS OPTION */
                  run display_message_mfmsg03
                     (input 2303,
                      input 3,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).
                  if c-application-mode <> "API" then
                  do:
                     next-prompt
                     pod_ers_opt.
                     undo, retry ers-loop.
                  end. /* c-application-mode <> "API" */
                  else
                     undo ers-loop,return  error.
               end. /* IF NOT({gppoders.v}) */

               /* VERIFY THAT ENTERED VALUE OF ERS OPTION ISN'T TOO HIGH */
               if (c-application-mode <> "API" and pod_ers_opt entered) or
                  (c-application-mode = "API"  and ttPurchaseOrderDet.ersOpt <> ?)
               then do:
                  assign oldErs = pod_ers_opt.
                  run ersCheck(buffer pod_det,
                               input ersopt,
                               input ers-err,
                               output ersOk).
                  if not(ersOk) then
                  do:
                     if c-application-mode <> "API" then
                     do:
                        if oldErs <> pod_ers_opt then
                           display pod_ers_opt with frame poders.
                        next-prompt pod_ers_opt.
                        undo, retry ers-loop.
                     end.
                     else
                        undo ers-loop, return error.
                  end.
               end. /* IF POD_ERS_OPT ENTERED */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* ERS-LOOP */
            if c-application-mode <> "API" then
               hide frame poders.
         end.   /* IF AVAILABLE POC_CTRL */

         if pod_type <> "x"
         and pod__qad16 = ?
         then
            pod__qad16 = "".

         if pod_type = "s"
         then do:

            run readsi_mstr (input  pod_site,
                             buffer si_mstr).

            old_db = global_db.
            if si_db <> global_db
            then do:
               {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF si_db <> global_db */

            {gprun.i ""rspomtb1.p""
               "(input        pod_site,
                 input        pod_part,
                 input-output pod_wo_lot,
                 input-output pod_op,
                 input-output subtype)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            pod__qad16 = subtype.

            if old_db <> global_db
            then do:
               {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF old_db <> global_db */

            if c-application-mode <> "API" then
               if keyfunction(lastkey) = "END-ERROR" then undo,retry.
         end. /* IF pod_type = "s" */

         else
            /*Only hide frame pod1 if not type "s" since
            rspomtb1.p (for subcontract items) will also
            use pod1.  If we hide it then reuse it, the
            frame will flash. */
            if c-application-mode <> "API" then
               hide frame pod1.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO WITH FRAME pod1 */
   end. /* DO ON ERROR undo,retry - loop1 */

   /* The flag on the control file rsc_ctrl and mfc_ctrl would always
   be maintained in sync. So we test value of mfc_ctrl flag */

   run checkAdgModule  (input-output l_adg_module, buffer pod_det).

   if using_supplier_consignment
      and pod_consignment
      and c-application-mode <> "API"
   then do:
      run assignPOCostPoint (input po_recid,
                             input "exclusive-lock",
                             buffer po_mstr,
                             buffer pod_det).

      if keyfunction(lastkey) = "END-ERROR" then do:
         hide frame aging.
         undo, retry.
      end.

      hide frame aging.
   end. /* IF using_supplier_consignment */

   /* DETAIL DATA ITEMS FRAME 2 */
   podcmmts = (pod_cmtindx <> 0 or (new pod_det and poc_lcmmts)).

   if c-application-mode <> "API" then
      display
         pod_firm_days
         pod_plan_days
         pod_plan_weeks
         pod_plan_mths
         pod_fab_days
         pod_raw_days
         pod_translt_days
         pod_sftylt_days
         pod_vpart
         pod_pkg_code
         pod_sd_pat
         pod_cum_qty[3]
         pod_ord_mult
         pod_cum_date[1]
         podcmmts
         pod_start_eff[1]
         pod_end_eff[1]
      with frame pod2.

   do with frame pod2 on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      /* DO NOT RETRY WHEN PROCESSING API REQUEST */
      if retry and c-application-mode = "API" then
         undo, return error.

      ststatus = stline[3].
      status input ststatus.

      if c-application-mode <> "API" then
         set
            pod_firm_days
            pod_plan_days
            pod_plan_weeks
            pod_plan_mths
            pod_fab_days
            pod_raw_days
            pod_translt_days
            pod_sftylt_days
            pod_vpart
            pod_pkg_code
            pod_sd_pat
            pod_cum_qty[3]
            pod_ord_mult
            pod_cum_date[1]
            podcmmts
            pod_start_eff[1]
            pod_end_eff[1].

      else /* c-application-mode <> "API" */
         run setPodLineDetail (buffer pod_det, input-output podcmmts).

      l_deactivate = no.
      if pod_pkg_code <> ""
      then do:

         run readpt_mstr (input  pod_pkg_code,
                          buffer pt_mstr).

         if not available pt_mstr
         then do:
            /*ITEM NUMBER DOES NOT EXIST*/
            run display_message_mfmsg03
               (input 16,
                input 3,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank).
            if c-application-mode <> "API" then
            do:
               next-prompt pod_pkg_code with frame pod2.
               undo, retry.
            end. /* c-application-mode <> "API" */
            else  /* c-application-mode = "API" */
               undo, return error.
         end. /* IF NOT AVAILABLE pt_mstr */
      end. /* IF pod_pkg_code <> "" */

      if ((c-application-mode <> "API"
         and pod_firm_days entered)
         or (c-application-mode = "API"
         and ttPurchaseOrderDet.firmDays <> ?))
         and pod_curr_rlse_id[1] <> ""
      then do:
         /* ACTIVE SCHEDULE EXISTS. PLANNED DATA MAY NOT BE */
         /* CARRIED FORWARD                                 */
         run display_message_mfmsg03
            (input 2360,
             input 2,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).

         /* DEACTIVATE ACTIVE SCHEDULE? - YES/NO            */
         run display_message_mfmsg01
            (input        2361,
             input        1,
             input-output l_deactivate).

         if l_deactivate
         then
            run delete-mrp-det (buffer pod_det,
                               input  global_domain).
      end.  /* IF pod_firm_days ENTERED */

      if pod_ord_mult = 0
      then do:
         /* ZERO NOT ALLOWED */
         run display_message_mfmsg03
            (input 317,
             input 3,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).
         if c-application-mode <> "API" then
         do:
            next-prompt pod_ord_mult.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else  /* c-application-mode = "API" */
            undo ,return error.
      end. /* IF pod_ord_mult = 0 */

      /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
      /* FOR AN INVENTORY ITEM                                      */
      if pod_vpart <> ""
         and not can-find(vp_mstr
         where vp_mstr.vp_domain = global_domain
         and   vp_vend_part = pod_vpart
         and   vp_part = pod_part
         and   ( vp_vend = po_vend
                 or (vp_vend = ""
                     and not can-find(first vp_mstr
                     where vp_domain = global_domain
                     and   vp_part = pod_part
                     and   vp_vend = po_vend)) ) )
      then do:
         /* SUPPLIER ITEM DOES NOT EXIST */
         run display_message_mfmsg03
            (input 238,
             input 3,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).
         if c-application-mode <> "API" then
         do:
            next-prompt pod_vpart.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else  /* c-application-mode = "API" */
            undo, return error.
      end. /* IF pod_vpart <> "" */

      if not ({gpcode.v pod_sd_pat sch_sd_pat})
      then do:
         /* VALUE MUST EXIST IN GENERALIZED CODES */
         run display_message_mfmsg03
            (input 716,
             input 3,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).
         if c-application-mode <> "API" then
         do:
            next-prompt pod_sd_pat.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else  /* c-application-mode = "API" */
            undo, return error.
      end. /* IF NOT ({gpcode.v pod_sd_pat sch_sd_pat}) */

      /* POP-UP WINDOW TO ALLOW USERS TO SPECIFY CREATION OF A
         SHIPPING SCHEDULE AND USAGE OF AN SDT CODE */
      if l_adg_module
      then do:
         {gprunmo.i &module="ASH" &program="rspomtb4.p"
            &param="""(input recid(pod_det))"""}

         /* ROUTINE TO DO ALL THE VALIDATIONS IF SUPPLIER */
         /* SHIPPING SCHEDULES IS INSTALLED               */
         {gprunmo.i &module="ASH" &program="rspomtb3.p"
            &param="""(input recid(pod_det))"""}

         if return-value = "pod_plan_days"
         then do:
            if c-application-mode <> "API" then
            do:
               next-prompt pod_plan_days with frame pod2.
               undo, retry.
            end. /* c-application-mode <> "API" */
            else  /* c-application-mode = "API" */
               undo, return error.
         end. /* IF return-value = "pod_plan_days" */
         else
         if return-value = "pod_plan_weeks"
         then do:
            if c-application-mode <> "API" then
            do:
               next-prompt pod_plan_weeks with frame pod2.
               undo, retry.
            end. /* c-application-mode <> "API" */
            else  /* c-application-mode = "API" */
               undo, return error.
         end. /* IF return-value = "pod_plan_weeks" */
         else
         if return-value = "pod_plan_mths"
         then do:
            if c-application-mode <> "API" then
            do:
               next-prompt pod_plan_mths with frame pod2.
               undo, retry.
            end. /* c-application-mode <> "API" */
            else /* c-application-mode = "API" */
               undo, return error.
         end. /* IF return-value = "pod_plan_mths" */
      end. /* IF l_adg_module */
      if c-application-mode <> "API" then
         hide frame pod2.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO WITH FRAME pod2 */

   /* DETAIL COMMENTS */

   if podcmmts then do on error undo detailloop, retry:
      run getComments (buffer pod_det).

      if c-application-mode <> "API" then
         view frame po.
   end. /* IF podcmmts */

   {gprun.i ""rsrsdup.p"" "(input recid(pod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.


   pod_sched_chgd = yes.
   release pod_det.

   if recid(scx_ref) = -1 then .
   release scx_ref.

   if c-application-mode = "API" then
      do on error undo, retry:
      run getNextPoAndScxRecord(buffer ttScheduleCrossRef,
                               buffer ttPurchaseOrderDet,
                               output result).

      run getNextScheduleCrossRef (buffer ttScheduleCrossRef).
   end. /* if c-applcation-mode = API then*/

end. /* REPEAT */

{&RSPOMTB-P-TAG15}
PROCEDURE p-conv-cost:

   define input-output parameter l_pod_pur_cost like pod_pur_cost no-undo.
   define input        parameter l_pod_um_conv  like pod_um_conv  no-undo.
   define input        parameter l_pod_um_conv1 like pod_um_conv  no-undo.

   /* UM CHANGED; CONVERT UNIT COST TO ALTERNATE UM? */
   run display_message_mfmsg01
      (input        2783,
       input        1,
       input-output yn).

   if yn
   then
      l_pod_pur_cost = l_pod_pur_cost / l_pod_um_conv * l_pod_um_conv1.

END PROCEDURE. /* p-conv-cost */

PROCEDURE display_message_mfmsg03:

   define input parameter l_msg_nbr   as integer    no-undo.
   define input parameter l_msg_level as integer    no-undo.
   define input parameter l_parm_1    as character  no-undo.
   define input parameter l_parm_2    as character  no-undo.
   define input parameter l_parm_3    as character  no-undo.
   define input parameter l_parm_4    as character  no-undo.
   define input parameter l_parm_5    as character  no-undo.

   {pxmsg.i &MSGNUM=l_msg_nbr &ERRORLEVEL=l_msg_level
            &MSGARG1=l_parm_1
            &MSGARG2=l_parm_2
            &MSGARG3=l_parm_3
            &MSGARG4=l_parm_4
            &MSGARG5=l_parm_5}

END PROCEDURE. /* display_message_mfmsg03 */

PROCEDURE getNextScheduleCrossRef:

   define parameter buffer ttScheduleCrossRef for ttScheduleCrossRef.

   if available (ttPurchaseOrderDet) then
   do:
      for first ttScheduleCrossRef where
                ttScheduleCrossRef.apiExternalKey = ttPurchaseOrderDet.apiExternalKey
                and ttScheduleCrossRef.line = ttPurchaseOrderDet.line:
      end.
   end.
END PROCEDURE.

PROCEDURE getNextPoAndScxRecord:
   define parameter buffer ttScheduleCrossRef for ttScheduleCrossRef.
   define parameter buffer ttPurchaseOrderDet for ttPurchaseOrderDet.
   define output parameter result as character.

   create ttPurchaseOrderDet.
   run getNextPoToDetLink in ApiMethodHandle
        (buffer ttPurchaseOrderDet).
   assign result = RETURN-VALUE.

   run getNextScheduleCrossRef (buffer ttScheduleCrossRef).

END PROCEDURE.

PROCEDURE checkLineNo:
   define input parameter poNbr as character.
   define input-output parameter line as integer.
   define output parameter lineOk as logical.

   assign lineOk = false.

   /* SCREENS & REPORTS DON'T SUPPORT 4 DIGIT LINE NOS. */
   if available pod_det
   then do:

      if pod_line < 999
      then
         line = pod_line + 1.
      else
         if pod_line = 999
         then do:

         /*  MAX LINE# USED, SEARCH FOR NEXT AVAILABLE LINE# */
         run display_message_mfmsg03
            (input 6025,
             input 1,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).
          if c-application-mode <> "API" then
             pause 1 no-message.
          do counter = 1 to 999:
             if c-application-mode <> "API" then
                display
                   counter @ scx_line.
             if not can-find (scx_ref
                 where scx_ref.scx_domain = global_domain and  scx_type = 2
                and scx_order = poNbr
                and scx_line  = counter)
             then do:

                line = counter.
                leave.
              end. /* IF NOT CAN-FIND (scx_ref */
           end. /* DO counter = 1 TO 999 */

           if counter = 1000
           then do:
              /* ALL AVAILABLE LINE# ARE USED */
              run display_message_mfmsg03
                        (input 6026,
                         input 4,
                         input l_blank,
                         input l_blank,
                         input l_blank,
                         input l_blank,
                         input l_blank).
              return.
           end. /* IF counter = 1000 */

         end.  /* IF pod_line = 999  */
   end.  /* IF AVAILABLE pod_det */
   assign lineOk = true.

END PROCEDURE.

PROCEDURE setPodLineDetail:
   define parameter buffer pod_det for pod_det.
   define input-output parameter podcmmts like podcmmts.

   assign
      {mfaiset.i pod_det.pod_firm_days ttPurchaseOrderDet.firmDays}
      {mfaiset.i pod_det.pod_plan_days ttPurchaseOrderDet.planDays}
      {mfaiset.i pod_det.pod_plan_weeks ttPurchaseOrderDet.planWeeks}
      {mfaiset.i pod_det.pod_plan_mths ttPurchaseOrderDet.planMths}
      {mfaiset.i pod_det.pod_fab_days ttPurchaseOrderDet.fabDays}
      {mfaiset.i pod_det.pod_raw_days ttPurchaseOrderDet.rawDays}
      {mfaiset.i pod_det.pod_translt_days ttPurchaseOrderDet.transltDays}
      {mfaiset.i pod_det.pod_sftylt_days ttPurchaseOrderDet.sftyltDays}
      {mfaiset.i pod_det.pod_vpart ttPurchaseOrderDet.vpart}
      {mfaiset.i pod_det.pod_sd_pat ttPurchaseOrderDet.sdPat}
      {mfaiset.i pod_det.pod_cum_qty[3] ttPurchaseOrderDet.cumQty[3]}
      {mfaiset.i pod_det.pod_ord_mult ttPurchaseOrderDet.ordMult}
      {mfaiset.i pod_det.pod_cum_date[1] ttPurchaseOrderDet.cumDate[1]}
      {mfaiset.i pod_det.pod_start_eff[1] ttPurchaseOrderDet.startEff[1]}
      {mfaiset.i pod_det.pod_end_eff[1] ttPurchaseOrderDet.endEff[1]}
      podcmmts = yes.

   if (ttPurchaseOrderDet.stat = " ") or (ttPurchaseOrderDet.stat = "") then
      assign pod_end_eff[1] = ?.
END PROCEDURE.

PROCEDURE setPodLineDetailPart:
   define parameter buffer pod_det for pod_det.
   assign
      {mfaiset.i pod_pr_list  ttPurchaseOrderDet.prList}
      {mfaiset.i pod_pur_cost ttPurchaseOrderDet.purCost}
      {mfaiset.i pod_acct ttPurchaseOrderDet.acct}
      {mfaiset.i pod_cc  ttPurchaseOrderDet.cc}
      {mfaiset.i pod_taxable  ttPurchaseOrderDet.taxable}
      {mfaiset.i pod_type ttPurchaseOrderDet.type}
      {mfaiset.i pod_cst_up  ttPurchaseOrderDet.cstUp}
      {mfaiset.i pod_loc  ttPurchaseOrderDet.loc}
      {mfaiset.i pod_um ttPurchaseOrderDet.um}
      {mfaiset.i pod_taxc  ttPurchaseOrderDet.taxc}.

   if not({gpcode.v pod_um}) then
   do:
      run display_message_mfmsg03
         (input 716,
          input 4,
          input pod_nbr,
          input pod_line,
          input 'pod_um',
          input pod_um,
          input l_blank).
      undo, return error.
   end.
   if not({gpcode.v pod_type}) then
   do:
      run display_message_mfmsg03
         (input 716,
          input 4,
          input pod_nbr,
          input pod_line,
          input 'pod_type',
          input pod_type,
          input l_blank).
      undo, return error.
   end.

END PROCEDURE.

PROCEDURE readpt_mstr:

   /* TO AVOID ACTION SEGMENT ERROR MOVED THE CODE FOR RECORD */
   /* FIND IN INTERNAL PROCEDURE                              */

   define input parameter l_pt_part like pt_part no-undo.

   define parameter buffer pt_mstr for pt_mstr .

   for first pt_mstr
      fields( pt_domain pt_desc1 pt_desc2 pt_insp_rqd pt_loc pt_part
             pt_pm_code pt_prod_line pt_rev pt_status pt_taxable
             pt_taxc pt_um)
       where pt_mstr.pt_domain = global_domain and  pt_part = l_pt_part
      no-lock:
   end. /* FOR FIRST pt_mstr */

END PROCEDURE. /* readpt_mstr */

PROCEDURE readpod_det:

   /* TO AVOID ACTION SEGMENT ERROR MOVED THE CODE FOR RECORD */
   /* FIND IN INTERNAL PROCEDURE                              */

   define input parameter l_pod_nbr  like pod_nbr  no-undo.
   define input parameter l_pod_line like pod_line no-undo.

   define parameter buffer pod_det for pod_det .

   for first pod_det
      fields( pod_domain pod_acct pod_cc pod_cmtindx pod_consignment
             pod_cst_up pod_cum_date pod_cum_qty pod_curr_rlse_id
             pod_end_eff pod_ers_opt pod_fab_days pod_firm_days
             pod_insp_rqd pod_line pod_loc pod_max_aging_days
             pod_nbr pod_op pod_ord_mult pod_part pod_pkg_code
             pod_plan_days pod_plan_mths pod_plan_weeks pod_po_db
             pod_po_site pod_pr_list pod_pr_lst_tp pod_pst
             pod_pur_cost pod_raw_days pod_rev pod_sched
             pod_sched_chgd pod_sd_pat pod_sftylt_days pod_site
             pod_start_eff pod_sub pod_taxable pod_taxc pod_tax_env
             pod_tax_in pod_tax_usage pod_translt_days pod_type
             pod_um pod_um_conv pod_vpart pod_wo_lot pod__qad16)
       where pod_det.pod_domain = global_domain and  pod_nbr  = l_pod_nbr
      and   pod_line = l_pod_line
      no-lock:
   end. /* FOR FIRST pod_det */

END PROCEDURE. /* readpod_det */

PROCEDURE readsi_mstr:

   /* TO AVOID ACTION SEGMENT ERROR MOVED THE CODE FOR RECORD */
   /* FIND IN INTERNAL PROCEDURE                              */

   define input parameter l_si_site like si_site  no-undo.

   define parameter buffer si_mstr for si_mstr .

   for first si_mstr
      fields( si_domain si_db si_desc si_site)
       where si_mstr.si_domain = global_domain and  si_site = l_si_site
      no-lock:
   end. /* FOR FIRST si_mstr */

END PROCEDURE. /* readsi_mstr */

PROCEDURE readad_mstr:

   /* TO AVOID ACTION SEGMENT ERROR MOVED THE CODE FOR RECORD */
   /* FIND IN INTERNAL PROCEDURE                              */

   define input parameter l_ad_addr like ad_addr  no-undo.

   define parameter buffer ad_mstr for ad_mstr .

   for first ad_mstr
      fields( ad_domain ad_addr ad_name ad_tax_zone)
       where ad_mstr.ad_domain = global_domain and  ad_addr = l_ad_addr
      no-lock:
   end. /* FOR FIRST ad_mstr */

END PROCEDURE. /* readad_mstr */

PROCEDURE check_um_mstr:
   define input        parameter l_um_um       like um_um       no-undo.
   define input        parameter l_um_alt_um   like um_alt_um   no-undo.
   define input        parameter l_um_part     like um_part     no-undo.
   define input-output parameter l_pod_um_conv like pod_um_conv no-undo.

   for first um_mstr
      fields(um_domain um_alt_um um_conv um_part um_um)
      where um_domain = global_domain
      and   um_um     = l_um_um
      and   um_alt_um = l_um_alt_um
      and   um_part   = l_um_part
      no-lock:
   end. /* FOR FIRST um_mstr */

   if available um_mstr
   then
      l_pod_um_conv = um_conv.

   if not available um_mstr
   then
      for first um_mstr
         fields(um_domain um_alt_um um_conv um_part um_um)
         where um_domain = global_domain
         and   um_um     = l_um_um
         and   um_alt_um = l_um_alt_um
         and   um_part   = ""
         no-lock:
         l_pod_um_conv = um_conv.
      end. /* FOR FIRST um_mstr */

   if not available um_mstr
   then do:
      /* NO UM CONVERSION EXISTS */
      run display_message_mfmsg03
         (input 33,
          input 2,
          input l_blank,
          input l_blank,
          input l_blank,
          input l_blank,
          input l_blank).
   end. /* IF NOT AVAILABLE um_mstr */

END PROCEDURE. /* check_um_mstr */

PROCEDURE readpo_mstr:

   define input parameter l_po_recid as recid no-undo.
   define input parameter lock-status as character no-undo.
   define parameter buffer po_mstr for po_mstr.

   if lock-status = "no-lock" then
      for first po_mstr
         fields(po_domain po_ap_acct po_ap_cc po_ap_sub po_bill po_buyer po_consignment
                po_contact po_contract po_cr_terms po_curr po_ers_opt po_ex_rate
                po_ex_rate2 po_fob po_max_aging_days po_nbr po_pr_lst_tp po_pst
                po_ship po_shipvia po_site po_taxable po_taxc po_tax_usage
                po_tot_terms_code po_vend)
         where recid(po_mstr) = l_po_recid
      no-lock:
      end. /* FOR FIRST po_mstr */
   else
      for first po_mstr
         where po_domain = global_domain
           and recid(po_mstr) = l_po_recid
      exclusive-lock: end.

END PROCEDURE. /* readpo_mstr */

PROCEDURE readvd_mstr:

   /* TO AVOID ACTION SEGMENT ERROR MOVED THE CODE FOR RECORD */
   /* FIND IN INTERNAL PROCEDURE                              */

   define input parameter l_vd_addr like vd_addr no-undo.

   define parameter buffer vd_mstr for vd_mstr.

   for first vd_mstr
      fields( vd_domain vd_addr vd_pr_list vd_pur_acct vd_pur_cc vd_pur_sub
      vd_type)
       where vd_mstr.vd_domain = global_domain and  vd_addr = l_vd_addr
      no-lock:
   end. /* FOR FIRST vd_mstr */

END PROCEDURE. /* readvd_mstr */

PROCEDURE display_message_mfmsg01:

   define input        parameter l_msg_nbr   as   integer     no-undo.
   define input        parameter l_msg_level as   integer     no-undo.
   define input-output parameter l_confirm   like mfc_logical no-undo.

       {pxmsg.i &MSGNUM=l_msg_nbr &ERRORLEVEL=1 &CONFIRM=l_confirm}

END PROCEDURE. /* display_message_mfmsg01 */

PROCEDURE ersCheck:
   define parameter buffer pod_det for pod_det.
   define input parameter ersopt like ers_opt.
   define input parameter ers-err as integer.
   define output parameter ersOk as logical.

   assign ersOk = false.

   if ers-err = 0
   and pod_ers_opt > ersopt
   then do:

      /*ERS OPTION NOT VALID BASED UPON SUPPLIER/SITE/ITEM*/
      run display_message_mfmsg03
                     (input 2317,
                      input 1,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).

      /* ERS OPTION MUST BE LESS THAN OR EQUAL TO */
      run display_message_mfmsg03
                     (input 2318,
                      input 3,
                      input string(ersopt),
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).
      return.
   end.  /* IF ERS-ERR = 0 */
   else
   if ers-err = 1
   then do:
      /* ERS VALUES MISSING FOR SITE */
      run display_message_mfmsg03
                     (input 2311,
                      input 2,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).
      /* ERS OPTION SET TO 1 */
      run display_message_mfmsg03
                     (input 2346,
                      input 1,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).
      pod_ers_opt = 1.
      return.
   end. /* IF ers-err = 1 */
   else
   if ers-err = 2
   then do:
      /* ERS VALUES MISSING FOR SUPPLIER */
      run display_message_mfmsg03
                     (input 2309,
                      input 2,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).

      /* ERS OPTION SET TO 1 */
      run display_message_mfmsg03
                     (input 2346,
                      input 1,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).

      pod_ers_opt = 1.
      return.
      end. /* IF ers-err = 2 */
   else
   if ers-err = 3
   then do:

      /* ERS VALUES MISSING FOR SUPPLIER AND SITE */
      run display_message_mfmsg03
                     (input 2301,
                      input 2,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).

       /* ERS OPTION SET TO 1 */
       run display_message_mfmsg03
                     (input 2346,
                      input 1,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank,
                      input l_blank).

      pod_ers_opt = 1.
      return.
   end. /* IF ers-err = 3 */
   assign ersOk = true.

END PROCEDURE.

PROCEDURE getComments:
   define parameter buffer pod_det for pod_det.

   if c-application-mode = "API" then
   do:
      {gpttcp.i ttPurchaseOrderDetCmt
                ttTransComment
               "ttPurchaseOrderDetCmt.apiExternalKey
               = ttPurchaseOrderDet.apiExternalKey
               and ttPurchaseOrderDetCmt.line
               = ttPurchaseOrderDet.line"}

      run setTransComment in ApiMethodHandle (input table ttTransComment).
   end.

   assign
      cmtindx    = pod_cmtindx
      global_ref = pod_part.
   {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

   pod_cmtindx = cmtindx.

END PROCEDURE.

PROCEDURE checkPart:

   define parameter buffer po_mstr for po_mstr.
   define parameter buffer scx_ref for scx_ref.
   define output parameter partOK as logical.

   assign partOK = false.

   for first pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   ttScheduleCrossRef.part no-lock:
   end.
   if not available pt_mstr
   then do:

      run replaceSupplierItem (input  ttScheduleCrossRef.part,
                               input  po_vend,
                               output l_part,
                               output l_vend_avail,
                               output l_save_suppum,
                               output l_save_suppumconv).

      run readpt_mstr (input l_part,
                              buffer pt_mstr).

      if l_vend_avail = no
         and available pt_mstr
      then
         run getVendorItem (input pt_part,
                            input po_vend,
                            input ttScheduleCrossRef.part,
                            output save_supp_part).

      else do:
         /* ITEM NUMBER DOES NOT EXIST */
         run display_message_mfmsg03
            (input 16,
             input 3,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank,
             input l_blank).
         return.
      end.
   end. /* IF NOT AVAILABLE PT_MSTR */
   /* INITIALIZE SUPPLIER ITEM IF AVAILABLE */
   else do:
      /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
      /* FOR AN INVENTORY ITEM                                      */
      if can-find(first vp_mstr
         where vp_mstr.vp_domain = global_domain
         and   vp_part = ttScheduleCrossRef.part
         and   ( vp_vend = po_vend
                 or (vp_vend = ""
                     and not can-find(first vp_mstr
                     where vp_domain = global_domain
                     and   vp_part = ttScheduleCrossRef.part
                     and   vp_vend = po_vend)) ) )
      then do:
         /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
         /* FOR AN INVENTORY ITEM                                      */
         for each vp_mstr no-lock
            where vp_mstr.vp_domain = global_domain
            and   vp_part = scx_part
            and   ( vp_vend = po_vend
                    or (vp_vend = ""
                        and not can-find(first vp_mstr
                        where vp_domain = global_domain
                        and   vp_part = scx_part
                        and   vp_vend = po_vend)) )
         break by vp_q_date descending:
            if first(vp_q_date) then do:
               save_supp_part = vp_vend_part.
               leave.
            end. /* IF FIRST VP_Q_DATE */
         end. /* FOR EACH VP_MSTR */
      end. /* IF CAN-FIND FIRST VP_MSTR */
   end. /* ELSE OF IF NOT AVAILABLE PT_MSTR */

   assign partOK = true.
END PROCEDURE.

PROCEDURE getScheduleLine:

   define parameter buffer po_mstr for po_mstr.
   define parameter buffer scx_ref for scx_ref.
   define parameter buffer pod_det for pod_det.
   define input-output parameter line as integer.
   assign
      scx_type     = 2
      scx_shipfrom = po_vend
      {mfaiset.i scx_shipto ttScheduleCrossRef.shipto}
      {mfaiset.i scx_part ttScheduleCrossRef.part}
      scx_po       = po_nbr
      scx_order    = po_nbr.

   if ttScheduleCrossRef.line <> ? and line <> ttScheduleCrossRef.line then
   do:
      assign {mfaiset.i newline ttScheduleCrossRef.line}.
      if not can-find (scx_ref  where scx_ref.scx_domain = global_domain and
      scx_type = 2
                   and scx_order = po_nbr
                   and scx_line = newline) and
         not can-find (pod_det  where pod_det.pod_domain = global_domain and
         pod_nbr = po_nbr
                   and pod_line = newline) then
         assign line = newline.
   end.
END PROCEDURE.

PROCEDURE checkTax:
   define parameter buffer pod_det for pod_det.
   define parameter buffer po_mstr for po_mstr.
   define parameter buffer vd_mstr for vd_mstr.
   define parameter buffer ad_mstr for ad_mstr.
   define parameter buffer scx_ref for scx_ref.
   define input-output parameter zone_from like txz_tax_zone.
   define input-output parameter zone_to like txz_tax_zone.

   if pod_tax_env = ""
   then do:

      /* GET VENDOR SHIP_FROM TAX ZONE FROM ADDRESS */
      run readad_mstr (input  vd_addr,
                       buffer ad_mstr).

      if available ad_mstr
      then
         zone_from = ad_tax_zone.

      /* GET SHIP_TO TAX ZONE FROM SHIP TO ADDRESS */
      run readad_mstr (input  scx_shipto,
                       buffer ad_mstr).

      if available ad_mstr
      then
         zone_to = ad_tax_zone.

      if not available ad_mstr
      then do:
         /* SITE ADDRESS DOES NOT EXIST */
         run display_message_mfmsg03
               (input 864,
                input 2,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank,
                input l_blank).
         zone_to = "".
      end. /* IF NOT  AVAILABLE ad_mstr */

      /* SUGGEST A TAX ENVIRONMENT */
      /* REPLACED pod_taxc WITH po_taxc */
      {gprun.i ""txtxeget.p""
         "(input zone_to,
          input zone_from,
          input po_taxc,
          output pod_tax_env)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* IF pod_tax_env = "" */
END PROCEDURE.

PROCEDURE setAPITax:
   define parameter buffer pod_det for pod_det.

   assign
      {mfaiset.i pod_tax_usage  ttPurchaseOrderDet.taxUsage}
      {mfaiset.i pod_tax_env  ttPurchaseOrderDet.taxEnv}
      {mfaiset.i pod_tax_in ttPurchaseOrderDet.taxIn}.
END PROCEDURE.

PROCEDURE setAPIErs:
   define parameter buffer pod_det for pod_det.

   assign
      {mfaiset.i pod_ers_opt ttPurchaseOrderDet.ersOpt}
      {mfaiset.i pod_pr_lst_tp ttPurchaseOrderDet.prLstTp}.
END PROCEDURE.

PROCEDURE checkAdgModule:
   define input-output parameter l_adg_module like l_adg_module.
   define parameter buffer pod_det for pod_det.

   assign l_adg_module = no.

   if can-find (first mfc_ctrl
       where mfc_ctrl.mfc_domain = global_domain and  mfc_field =
       "enable_shipping_schedules"
      and mfc_seq = 4
      and mfc_module = "ADG"
      and mfc_logical = yes)
   then
      assign l_adg_module = yes.

   if l_adg_module
   then do:

      /* DEFAULT VALUES IN LINE ITEM DATA FIELDS FROM SUPPLIER */
      /* IF VALUES IN SUPPLIER MASTER ARE BLANK THEN DEFAULT   */
      /* FROM SCHEDULE CONTROL FILE                            */
      {gprunmo.i &module="ASH" &program="rspomtb2.p"
         &param="""(input recid(pod_det),
                    input new-pod)"""}

   end. /* IF l_adg_module */
END PROCEDURE.

PROCEDURE getPtpDet:
   define parameter buffer ptp_det for ptp_det.
   define parameter buffer pt_mstr for pt_mstr.
   define input parameter site like si_site.

   for first ptp_det
      fields( ptp_domain ptp_ins_rqd ptp_part ptp_pm_code ptp_site ptp_rev)
       where ptp_det.ptp_domain = global_domain and  ptp_part = pt_part
      and ptp_site = site
      no-lock:
   end. /* FOR FIRST ptp_det */

   if (available ptp_det
   and (ptp_pm_code = "C"
   or ptp_pm_code = "F"))
   then do:
      /* ITEM PUR/MFG CODE IS # */
      run display_message_mfmsg03
         (input 1850,
          input 2,
          input ptp_pm_code,
          input l_blank,
          input l_blank,
          input l_blank,
          input l_blank).
   end. /* IF (AVAILABLE ptp_det */
   else
   if (not available ptp_det
      and (pt_pm_code = "F"
      or pt_pm_code = "C"))
   then do:
      /* ITEM PUR/MFG CODE IS # */
      run display_message_mfmsg03
         (input 1850,
          input 2,
          input pt_pm_code,
          input l_blank,
          input l_blank,
          input l_blank,
          input l_blank).
   end. /* IF (NOT AVAILABLE ptp_det */
END PROCEDURE.

PROCEDURE checkSite:
   define parameter buffer si_mstr for si_mstr.
   define parameter buffer pod_det for pod_det.
   define input parameter po_site like po_site.

   define variable i as integer.

   i = 0.
   for each si_mstr
      fields( si_domain si_db si_desc si_site)
      no-lock
       where si_mstr.si_domain = global_domain and  si_site >= "":
      i = i + 1.
      if i >= 2
      then
         leave.
   end. /* FOR EACH si_mstr */

   if pod_site = po_site
   then
      pod_po_site = po_site.
   else
   if po_site <> ""
   then
      pod_po_site = po_site.
   else
   if not can-find(si_mstr
       where si_mstr.si_domain = global_domain and  si_site = "")
   then
      pod_po_site = pod_site.
   else
   if i >= 2
   then
      pod_po_site = pod_site.

END PROCEDURE.

PROCEDURE checkSiteDetails:

   define parameter buffer si_mstr for si_mstr.
   define input parameter part like scx_shipto no-undo.
   define output parameter isNotOk as logical no-undo initial false.

   global_part = part.

   run readsi_mstr (input  part,
                    buffer si_mstr).

   if not available si_mstr
   then do:
      /* SITE DOES NOT EXIST */
      run display_message_mfmsg03
         (input 708,
          input 3,
          input l_blank,
          input l_blank,
          input l_blank,
          input l_blank,
          input l_blank).
      isNotOk = true.
      return.
   end. /* IF NOT AVAILABLE si_mstr */

   {gprun.i ""gpsiver.p""
      "(input  si_site,
        input  recid(si_mstr),
        output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if return_int = 0
   then do:
      /* USER DOES NOT HAVE ACCESS TO SITE */
      run display_message_mfmsg03
         (input 725,
          input 3,
          input l_blank,
          input l_blank,
          input l_blank,
          input l_blank,
          input l_blank).
      isNotOk = true.
      return.
   end. /* IF return_int = 0 */

END PROCEDURE.

PROCEDURE notBaseCurrency:
   define parameter buffer po_mstr for po_mstr.
   define parameter buffer pod_det for pod_det.

    /* CONVERT FROM BASE TO FOREIGN CURRENCY */
    run curr_conv
       (input  base_curr,
        input  po_curr,
        input  po_ex_rate2,
        input  po_ex_rate,
        input  glxcst,
        input  false, /* DO NOT ROUND */
        output unitcost,
        output mc-error-number).

   if unitcost = pod_pur_cost
   then do:

      /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
      run log_terms_trade
         (input pod_um,
          input glxcst,
          input po_nbr,
          input pod_part,
          input pod_site,
          output purcost).

      /* CONVERT FROM BASE TO FOREIGN CURRENCY */
      run curr_conv
         (input base_curr,
          input po_curr,
          input po_ex_rate2,
          input po_ex_rate,
          input purcost,
          input false, /* DO NOT ROUND */
          output pod_pur_cost,
          output mc-error-number).

   end. /* IF unitcost = pod_pur_cost */

END PROCEDURE.

PROCEDURE setAccValidation:

   define parameter buffer pod_det for pod_det.

   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}

   /* SET PROJECT VERIFICATION TO NO */
   {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

   /* ACCT/SUB/CC VALIDATION */
   {gprunp.i "gpglvpl" "p" "validate_fullcode"
      "(input  pod_acct,
        input  pod_sub,
        input  pod_cc,
        input  """",
        output valid_acct)"}
END PROCEDURE.

PROCEDURE delete-mrp-det:
/*-----------------------------------------------------------------------
   Purpose:      Delete mrp_det records

   Parameters:   1. buffer pod_det
                 2. input i-global-domain like global_domain

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define  parameter buffer pod_det for pod_det.
   define  input  parameter i-global-domain like global_domain no-undo.

   define buffer mrp_det for mrp_det.

   pod_curr_rlse_id[1] = "".

   for each mrp_det exclusive-lock
          where mrp_det.mrp_domain = i-global-domain and  mrp_dataset =
          "ss sch_mstr"
         and mrp_part    = pod_part
         and mrp_nbr     = pod_nbr
         and mrp_line    = string(pod_line):
      delete mrp_det.
   end. /* FOR EACH mrp_det */

END PROCEDURE. /* delete-mrp-det */

PROCEDURE assign-acct:
/*-----------------------------------------------------------------------
   Purpose:      Assign pod_acct/sub/cc

   Parameters:   1. buffer pod_det
                 2. buffer vd_mstr
                 3. input i-global-domain like global_domain
                 4. input i-pline like pt_prod_line

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/
   define   parameter buffer pod_det for pod_det.
   define   parameter buffer vd_mstr for vd_mstr.
   define  input  parameter i-global-domain like global_domain no-undo.
   define  input  parameter i-pline like pt_prod_line          no-undo.

   for first pl_mstr
      fields( pl_domain pl_prod_line)
       where pl_mstr.pl_domain = i-global-domain and  pl_prod_line =
       i-pline
      no-lock:

      {gprun.i ""glactdft.p""
         "(input ""PO_PUR_ACCT"",
           input i-pline,
           input pod_site,
           input if available vd_mstr
                 then
                    vd_type
                 else
                    """",
           input """",
           input no,
           output pod_acct,
           output pod_sub,
           output pod_cc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   end. /* FOR FIRST pl_mstr */

END PROCEDURE. /* assign-acct */

PROCEDURE find-scx-ref:
/*-----------------------------------------------------------------------
   Purpose:      Find scx_ref buffer

   Parameters:   1. buffer scx_ref
                 2. buffer po_mstr
                 3. input i-global-domain like global_domain
                 4. input i-shipto  like scx_shipto
                 5. input i-part    like scx_part

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define   parameter buffer scx_ref  for scx_ref.
   define   parameter buffer po_mstr for po_mstr.
   define  input  parameter i-global-domain like global_domain no-undo.
   define  input  parameter i-shipto like scx_shipto           no-undo.
   define  input  parameter i-part   like scx_part              no-undo.

   for first scx_ref
      fields( scx_domain scx_line scx_order scx_part scx_po scx_shipfrom
      scx_shipto
             scx_type)
       where scx_ref.scx_domain = i-global-domain and  scx_type = 2
      and scx_shipfrom = po_vend
      and scx_shipto = i-shipto
      and scx_part = i-part
      and scx_po = po_nbr
      no-lock:
   end. /* FOR FIRST scx_ref */

END PROCEDURE. /* find-scx-ref */

PROCEDURE replaceSupplierItem:

   define input        parameter pItemId         as character no-undo.
   define input        parameter pSupplierId     as character no-undo.
   define output       parameter pSupplierItemId as character no-undo.
   define output       parameter pVendAvail      as logical   no-undo.
   define output       parameter psupplierItemUm as character no-undo.
   define output       parameter psuppitemumconv as decimal   no-undo.

   /* CHECKING vp_mstr RECORD FOR BLANK OR VALID SUPPLIER */
   for first vp_mstr
      fields(vp_domain vp_part vp_vend_part
             vp_vend   vp_um)
      where vp_domain = global_domain
      and   vp_vend_part = pItemId
      and   (vp_vend    = pSupplierId
      or vp_vend = "")
      no-lock:
   end. /* FOR FIRST vp_mstr */

   if available vp_mstr
   then do:
      pSupplierItemUm  = vp_um.

      for first pt_mstr
         fields(pt_domain pt_part pt_um)
         where pt_domain = global_domain
         and   pt_part = vp_part
         no-lock:
      end. /* FOR FIRST pt_mstr */

      if available pt_mstr
      then do:
         pSupplierItemId = pt_part.
        if pt_um <> psupplieritemum
        then
           run check_um_mstr (input        pt_um,
                              input        psupplieritemum,
                              input        l_part,
                              input-output l_save_suppumconv).
        else
           l_save_suppumconv = 1.
      end. /* IF AVAILABLE pt_mstr */

      psuppitemumconv = l_save_suppumconv.

      /* DATA IN  vp_mstr                                          */
      /* SUPPLIER     INV. ITEM           SUPPLIER-ITEM            */
      /*  S1           I1                 SI1                      */
      /*  <BLANK>      I1                 BI1                      */
      /* ENTERED VALUES: SUPPLIER-ITEM: BI1, SUPPLIER: S1,         */
      /* WE SHOULD NOT REPLACE WITH THE INV. ITEM (I.E. MEMO ITEM) */

      if available pt_mstr
         and not can-find( first vp_mstr
         where vp_domain    = global_domain
         and   vp_part      = pt_part
         and   vp_vend      = pSupplierId
         and   vp_vend_part = pItemId)
         and  can-find(first vp_mstr
                       where vp_domain = global_domain
                       and   vp_part   = pt_part
                       and   vp_vend   = pSupplierId)
      then
         pVendAvail = yes.
      return.
   end. /* IF AVAIL vp_mstr */
   else
      return.

END PROCEDURE. /* replaceSupplierItem */

PROCEDURE getVendorItem:

   define input  parameter p_part      like pt_part no-undo.
   define input  parameter p_vend      like po_vend no-undo.
   define input  parameter p_vend_part like pt_part no-undo.
   define output parameter p_supp_part like pt_part no-undo.

   /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
   /* FOR AN INVENTORY ITEM                                      */
   for each vp_mstr
      fields(vp_domain vp_part vp_q_date vp_vend vp_vend_part)
      where vp_domain = global_domain
      and   vp_vend_part = p_vend_part
      and   ( vp_vend = p_vend
              or (vp_vend = ""
                  and   not can-find(first vp_mstr
                  where vp_domain = global_domain
                  and   vp_part = p_part
                  and   vp_vend = p_vend)) )
      no-lock
      break by vp_q_date descending:

      if first(vp_q_date)
      then do:
         run readpt_mstr (input  vp_part,
                          buffer pt_mstr).
         if available pt_mstr
         then do:
            p_supp_part = input frame pod scx_part.

            if c-application-mode <> "API"
            then
               display pt_part @ scx_part with frame pod.

            /* SUPPLIER ITEM x REPLACED BY ITEM y */
            run display_message_mfmsg03
               (input 371,
                input 1,
                input vp_vend_part,
                input vp_part,
                input l_blank,
                input l_blank,
                input l_blank).
         end. /* IF AVAILABLE pt_mstr */
         else do:
            /* ITEM NUMBER DOES NOT EXIST */
            if c-application-mode <> "API"
            then do:
               run display_message_mfmsg03
                  (input 16,
                   input 3,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank).
               undo, retry.
            end. /* IF c-application-mode <> "API" */
            else do:
               /* ITEM NUMBER DOES NOT EXIST */
               run display_message_mfmsg03
                  (input 16,
                   input 3,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank,
                   input l_blank).
               return.
            end. /* ELSE DO: */
         end. /* ELSE DO */
      end. /* IF FIRST(vp_q_date) */
   end. /* FOR EACH vp_mstr */

END PROCEDURE. /* getVendorItem */

PROCEDURE curr_conv:

   define input  parameter p_base_curr        like po_curr      no-undo.
   define input  parameter p_po_curr          like po_curr      no-undo.
   define input  parameter p_po_ex_rate2      like po_ex_rate2  no-undo.
   define input  parameter p_po_ex_rate       like po_ex_rate   no-undo.
   define input  parameter p_amt              like pod_pur_cost no-undo.
   define input  parameter p_noround          as logical        no-undo.
   define output parameter p_amt1             like pod_pur_cost no-undo.
   define output parameter p_error            as integer        no-undo.

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input p_base_curr,
        input p_po_curr,
        input p_po_ex_rate2,
        input p_po_ex_rate,
        input p_amt,
        input p_noround, /* DO NOT ROUND */
        output p_amt1,
        output p_error)"}

END PROCEDURE.

PROCEDURE log_terms_trade:

   define input  parameter p_pod_um            like pod_um       no-undo.
   define input  parameter p_glxcst            like glxcst       no-undo.
   define input  parameter p_po_nbr            like po_nbr       no-undo.
   define input  parameter p_pod_part          like pod_part     no-undo.
   define input  parameter p_pod_site          like pod_site     no-undo.
   define output parameter p_pod_pur_cost      like pod_pur_cost no-undo.

   /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
   {gprunmo.i &module="LA" &program="lapopr.p"
      &param = """(input p_pod_um,
                   input p_glxcst,
                   input p_po_nbr,
                   input p_pod_part,
                   input p_pod_site,
                   output p_pod_pur_cost)"""}
END PROCEDURE.

PROCEDURE assignPOCostPoint:

   define input parameter l_po_recid as recid no-undo.
   define input parameter lock-status as character no-undo.
   define parameter buffer po_mstr for po_mstr.
   define parameter buffer pod_det for pod_det.

   run readpo_mstr(input  po_recid,
                   input  "exclusive-lock",
                   buffer po_mstr).

   /* DEFAULT LOOKUP FOR PO COST POINT IF PO HEADER IS NOT CONSIGNED */
   if po__qadc01 = "" then  do:
      {pxrun.i &PROC = 'initializeCostPoint'
               &PARAM="(input po_vend,
                        input-output po__qadc01)"}
   end.

   /* COST POINT CANNOT BE UPDATED AT THE LINE LEVEL; */
   /* ONLY AT THE HEADER LEVEL BECAUSE IT IS DEFINED  */
   /* BY SUPPLIER.                                    */
   {pxrun.i &PROC='setAgingDays'
            &PARAM="(input-output pod_max_aging_days,
                     input-output po__qadc01,
                     input no)"}

END PROCEDURE. /* assignPOCostPoint */

PROCEDURE check-db-connect:

   define input parameter p_connect_db like dc_name no-undo.
   define input-output parameter p_db_undo like mfc_logical no-undo.

   if err-flag = 2 or err-flag = 3
   then do:
      {mfmsg03.i 2510 4 "p_connect_db" """" """"}
       /*DB not connected*/
      l_db_undo = yes.
   end.
END PROCEDURE. /* Check-db-connect */
