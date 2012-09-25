
/* GUI CONVERTED from edomsch.p (converter v1.77) Fri Feb 13 11:11:26 2004 */
/* edomsch.p - ECOMMERCE SCHEDULES PRE-PROCESSING EXPORT PROGRAM              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.22.3.2 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 9.0            CREATED: 06/17/99 BY: *M0CX*  Kieran O Dea       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0KW* Jacolyn Neder       */
/* Revision: 1.18     BY: Nikita Joshi          DATE: 09/26/01  ECO: *M1M5*  */
/* Revision: 1.20     BY: Vinod Kumar           DATE: 06/03/02  ECO: *P07P*  */
/* Revision: 1.21     BY: Anitha Gopal          DATE: 07/27/02  ECO: *N1PW*  */
/* Revision: 1.22   BY: Vandna Rohira         DATE: 13/02/03  ECO: *N26Z*  */
/* $Revision: 1.22.3.2 $    BY: Vinod Kumar           DATE: 07/10/03  ECO: *P0WF*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* NOTE:- THIS PROGRAM WAS COPIED FROM edexsch.p FROM MFG/PRO 9.0  STAGE      */
/*        ENVIRONMENT AND MODIFIED SO THAT IT WORKS WITH THE ECOMMERCE MODULE.*/
/*        IT ACCEPTS SELECTION CRITERIA FROM THE SCREEN AND FOR EACH SCHEDULE
          MATCHING THE CRITERIA AND THAT CAN BE EXPORTED USING ECOMMERCE
          IT CREATES A STATUS RECORD IN THE MFG/PRO REPOSITORY. IT ALSO BUILDS
          A LIST OF SEQUENCE NUMBERS ASOCIATED WITH THE STATUS RECORDS AND
          PASSES THIS TO THE ECOMMERCE CONTROL PROGRAM TO EXTRACT THE DATA
          FROM MFG/PRO AND LOAD IT INTO THE REPOSITORY.
*/

/*INCLUDE SECTION*/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}  /*DISPLAY TITLE BAR*/
{edtmpdef.i}        /*ECOMMERCE TEMPORARY TABLES*/
{edexport.i "new"}  /*GENERIC EXPORT VARIABLES*/
{edecmsg.i}         /*ERROR HANDLING PROCEDURE*/
{edomcon.i}         /*CONSTANT DEFINITIONS*/

/* ************** Begin Translatable Strings Definitions *********** */

&SCOPED-DEFINE edomsch_p_1 "Print Details"
/* MaxLen: 60 Comment: Whether to print report details or not */

&SCOPED-DEFINE edomsch_p_2 "Export Supplier Schedule"
/* Max Len: Comment: */

&SCOPED-DEFINE edomsch_p_3 "Export Planning Schedule"
/* Max Len: Comment: */

&SCOPED-DEFINE edomsch_p_4 "Export Shipping Schedule"
/* Max Len: Comment: */

&SCOPED-DEFINE edomsch_p_9 "Print Zero Schedules"
/* MaxLen: Comment: */

/* **************  End Translatable Strings Definitions  *********** */

/*DEFINE LOCAL VARIABLES*/
define variable l_new_batch                 as logical no-undo.
define variable l_submitted_for_export      as logical no-undo.
define variable l_sequence_list             as character no-undo.
define variable l_processed_sequence_list   as character no-undo.
define variable l_print_details             like mfc_logical no-undo.
define variable l_err_desc            as character format "x(70)"  no-undo.
define variable l_error                     as character no-undo.
define variable l_default_doc_name1 as character no-undo
   initial "MFG830".
define variable l_doc_name_key1 as character no-undo
   initial "Plan Sch Document Name".
define variable l_doc_version_key1 as character no-undo
   initial "Plan Sch Document Ver".
define variable l_default_doc_name2 as character no-undo
   initial "MFG862".
define variable l_doc_name_key2 as character no-undo
   initial "Ship Sch Document Name".
define variable l_doc_version_key2 as character no-undo
   initial "Ship Sch Document Ver".
define variable l_default_doc_version as integer no-undo
   initial 1.
define variable l_supplier_from             like po_vend no-undo.
define variable l_supplier_to               like po_vend no-undo.
define variable l_shipto_from               like po_ship no-undo.
define variable l_shipto_to                 like po_ship no-undo.
define variable l_part_from                 like pod_part no-undo.
define variable l_part_to                   like pod_part no-undo.
define variable l_po_from                   like po_nbr no-undo.
define variable l_po_to                     like po_nbr no-undo.
define variable l_buyer_from                like po_buyer no-undo.
define variable l_buyer_to                  like po_buyer no-undo.
define variable l_adg_module like mfc_logical initial no no-undo.

/*DEFINE SHARED VARIABLES*/
define new shared stream rptout.
define new shared variable s_print_zero like mfc_logical initial yes
   label {&edomsch_p_9}.
define new shared variable s_exp_supp_schedule like mfc_logical no-undo.
define new shared variable s_exp_planning_schedule like mfc_logical no-undo.
define new shared variable s_exp_shipping_schedule like mfc_logical no-undo.
define variable l_frame_field as character no-undo.



DEFINE TEMP-TABLE ttt1 
    FIELDS ttt1_supplier LIKE po_vend
    FIELDS ttt1_name     LIKE ad_name
    FIELDS ttt1_doc_id   AS CHAR LABEL "DOCUMENT ID"
    FIELDS ttt1_doc_dt   AS CHAR LABEL "DOCUMENT DATE"
    .
DEFINE TEMP-TABLE ttt2
    FIELDS ttt2_supplier LIKE po_vend
    FIELDS ttt2_line     LIKE pod_line
    FIELDS ttt2_site     LIKE pod_site
    FIELDS ttt2_part     LIKE pt_part
    FIELDS ttt2_desc     LIKE pt_desc1
    FIELDS ttt2_po       LIKE pod_nbr
    FIELDS ttt2_poln     LIKE pod_line
    FIELDS ttt2_beg_date LIKE sch_eff_start
    FIELDS ttt2_end_date LIKE sch_eff_end
    FIELDS ttt2_due_date LIKE pod_due_date
    FIELDS ttt2_rel_date LIKE schd_date
    FIELDS ttt2_transltd LIKE pod_translt_day
    FIELDS ttt2_qty      LIKE schd_upd_qty
    FIELDS ttt2_pf       LIKE schd_fc_qual.

DEFINE VARIABLE j AS INTEGER NO-UNDO.

/*DEFINE SCREEN LAYOUT*/
/* THE INCLUDE FILE {t001.i} IS USED TO CHANGE THE LABEL ON THE 'TO' FIELDS
*  ON THE SCREEN FROM THE DEFAULT LABEL TO 'TO'.
*/

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   l_po_from          colon 30
   l_po_to            label {t001.i} colon 55 skip
   l_part_from        colon 30
   l_part_to          label {t001.i} colon 55 skip
   l_supplier_from    colon 30
   l_supplier_to      label {t001.i} colon 55 skip
   l_shipto_from      colon 30
   l_shipto_to        label {t001.i} colon 55
   l_buyer_from       colon 30
   l_buyer_to         label {t001.i} colon 55 skip
   skip(1)
   batchno            colon 30 skip
with frame a side-labels no-attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
      s_exp_supp_schedule = yes
      s_exp_planning_schedule = no
      s_exp_shipping_schedule = no
      l_adg_module = false.

MAINLOOP:
repeat:
   /*CLEAR VARIABLES*/
   l_sequence_list="".
   if l_po_to = hi_char then l_po_to = "".
   if l_part_to = hi_char then l_part_to = "".
   if l_supplier_to = hi_char then l_supplier_to = "".
   if l_shipto_to = hi_char then l_shipto_to = "".
   if l_buyer_to = hi_char then l_buyer_to = "".

   assign
      l_submitted_for_export = no
      l_print_details  = no.


   /*ACCEPT SCREEN INPUT*/
   update
      l_po_from
      l_po_to
      l_part_from
      l_part_to
      l_supplier_from
      l_supplier_to
      l_shipto_from
      l_shipto_to
      l_buyer_from
      l_buyer_to
      batchno
   with frame a editing:

      readkey.
      if frame-field <> "" then l_frame_field = frame-field.

      apply lastkey.
   end. /*EDITING */

   /* GET ATTRIBUTE TO STORE FOR THE MNEMONIC */


   /*SETUP BATCH PARAMETERS*/
   bcdparm = "".  /* INITIALISE STANDARD STRING USED BY MFQOUTER.I */
   {mfquoter.i l_po_from     }
   {mfquoter.i l_po_to       }
   {mfquoter.i l_part_from   }
   {mfquoter.i l_part_to     }
   {mfquoter.i l_supplier_from}
   {mfquoter.i l_supplier_to }
   {mfquoter.i l_shipto_from }
   {mfquoter.i l_shipto_to   }
   {mfquoter.i l_buyer_from  }
   {mfquoter.i l_buyer_to    }
   {mfquoter.i batchno}

   /*SET DEFAULT RANGE VALUES IF SCREEN INPUT IS BLANK*/
   if l_po_to        = "" then l_po_to       = hi_char.
   if l_part_to      = "" then l_part_to     = hi_char.
   if l_supplier_to  = "" then l_supplier_to = hi_char.
   if l_shipto_to    = "" then l_shipto_to   = hi_char.
   if l_buyer_to     = "" then l_buyer_to    = hi_char.

   {mfselbpr.i "printer" 132 "page"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   FOR EACH ttt1:
       DELETE ttt1.
   END.
   FOR EACH ttt2:
       DELETE ttt2.
   END.

   /* GET THE NEXT BATCH NUMBER */
   if batchno = 0 then
   ASSIGN /*batchno     = next-value( edc_sq02 )*/
      l_new_batch = yes.
   else l_new_batch = no.

   /*LOOP THROUGH EACH RECORD MATCHING THE SELECTION CRITERIA AND FOR
   EACH SELECTED SCHEDULE
   - GET DOCUMENT NAME & VERSION USING TRADING PARTNER DETAILS
   - PROCESS THE SCHEDULES IN THE SCHEDULE MASTER TABLE
   THE SEQUENCE NUMBER LIST IS ALSO POPULATED DURING THIS LOOP
   */
   for each po_mstr
         fields( po_nbr po_vend po_buyer po_sched)
         where po_nbr >= l_po_from and po_nbr <= l_po_to
         and po_vend >= l_supplier_from and po_vend <= l_supplier_to
         and po_buyer >= l_buyer_from and po_buyer <= l_buyer_to
         and po_sched
      no-lock
         use-index po_vend,
         each pod_det
         fields( pod_nbr pod_sched pod_part pod_site pod__qad05)
         where pod_nbr = po_nbr
         and pod_sched
         and pod_part >= l_part_from and pod_part <= l_part_to
         and pod_site >= l_shipto_from and pod_site <= l_shipto_to
      no-lock
         break by po_vend by /*james* pod_part*/ pod_site by pod_part BY po_nbr:
         IF FIRST-OF(po_vend) THEN DO:
             j = 0.
         END.

         run xxpro-bud-ttt
            (
            input 4, /*SCHEDULE TYPE*/
            input 1, /*INDEX OF ARRAY pod_curr_rlse_id TO BE CHECKED*/
            input batchno,
            input l_new_batch,
            input recid(pod_det)
            ).

     

   END.

   FOR EACH ttt1:
       FIND FIRST ad_mstr WHERE ad_addr = ttt1_supplier NO-LOCK NO-ERROR.
       IF AVAILABLE ad_mstr THEN ttt1_name = ad_name.
       DISP ttt1 WITH 1 COLUMNS WIDTH 132 STREAM-IO.
       FOR EACH ttt2 WHERE ttt2_supplier = ttt1_supplier BY ttt2_line WITH WIDTH 300 DOWN STREAM-IO:
           FIND FIRST pt_mstr WHERE pt_part = ttt2_part NO-LOCK NO-ERROR.
           IF AVAILABLE pt_mstr THEN ttt2_desc = pt_desc2.
           DISP ttt2.
       END.
   END.
   /*REPORT TRAILER*/
   {mfrtrail.i }

end. /* REPEAT : MAINLOOP: */

/* EOF */

/*===============================================================================================*/
PROCEDURE xxpro-bud-ttt:
    /*DEFINE INPUT & OUTPUT VARIABLES*/
    define input parameter i_sch_type like sch_type no-undo.
    define input parameter i_releaseIndex as integer no-undo.
    define input parameter i_batchno like batchno no-undo.
    define input parameter i_new_batch as logical no-undo.
    define input parameter i_poddet_recid as recid.

    /* DEFINE BUFFERS */
    define buffer poddet for pod_det.
    define buffer scxref for scx_ref.
    DEFINE BUFFER bbpo_mstr FOR po_mstr.

    /*MOVE TO CURRENT RECORD IN PURCHASE ORDER DETAIL TABLE*/
    for first poddet
       fields(pod_nbr pod_line pod_part pod_curr_rlse_id[i_releaseIndex])
       where recid(poddet) = i_poddet_recid no-lock:
    end.


    for first scxref
       fields(scx_line scx_po scx_shipfrom scx_shipto scx_type)
       where scxref.scx_type = 2
       and   scxref.scx_po   = poddet.pod_nbr
       and   scxref.scx_line = poddet.pod_line
    no-lock:
    end. /* FOR FIRST scxref */

    if i_new_batch then do:
       for each sch_mstr no-lock
             where sch_type = i_sch_type
             and sch_nbr = poddet.pod_nbr
             and sch_line = poddet.pod_line
             and sch_rlse_id = poddet.pod_curr_rlse_id[i_releaseIndex]
             and length(sch_ship) < 16 /*DOCUMENT NOT ALREADY EXPORTED*/
             break by sch_type:
           FOR EACH schd_det NO-LOCK
               WHERE schd_type     = sch_type
               AND   schd_nbr      = sch_nbr
               AND   schd_line     = sch_line
               AND   schd_rlse_id  = sch_rlse_id
               AND   schd_upd_qty <> 0:
               FIND FIRST ttt1 WHERE ttt1_supplier = scxref.scx_shipfrom NO-LOCK NO-ERROR.
               IF NOT AVAILABLE ttt1 THEN DO:
                   CREATE ttt1.
                   ASSIGN ttt1_supplier = scxref.scx_shipfrom.
               END.
               j = j + 1.
               CREATE ttt2.
               ASSIGN
                   ttt2_supplier  = scxref.scx_shipfrom
                   ttt2_line      = j
                   ttt2_site      = scxref.scx_shipto
                   ttt2_part      = poddet.pod_part
                   ttt2_desc      = ""
                   ttt2_po        = scxref.scx_po
                   ttt2_poln      = scxref.scx_line
                   ttt2_beg_date  = sch_eff_start
                   ttt2_end_date  = sch_eff_end
                   ttt2_due_date  = schd_date
                   ttt2_rel_date  = schd_date - pod_translt_days
                   ttt2_transltd  = pod_translt_days
                   ttt2_qty       = schd_upd_qty
                   ttt2_pf        = schd_fc_qual.
           END.
       END.
    END.
    ELSE DO:
        for each sch_mstr no-lock
              where sch_type = i_sch_type
              and sch_nbr = poddet.pod_nbr
              and sch_line = poddet.pod_line
              and length(sch_ship) >= 16
              and integer(substring(sch_ship,17)) = i_batchno
              break by sch_type:
           FOR EACH schd_det NO-LOCK
               WHERE schd_type     = sch_type
               AND   schd_nbr      = sch_nbr
               AND   schd_line     = sch_line
               AND   schd_rlse_id  = sch_rlse_id
               AND   schd_upd_qty <> 0:
               FIND FIRST ttt1 WHERE ttt1_supplier = scxref.scx_shipfrom NO-LOCK NO-ERROR.
               IF NOT AVAILABLE ttt1 THEN DO:
                   CREATE ttt1.
                   ASSIGN 
                       ttt1_supplier = scxref.scx_shipfrom
                       ttt1_doc_id   = STRING(i_batchno)
                       ttt1_doc_dt = SUBSTRING(sch_ship,1,17).
               END.
               j = j + 1.
               CREATE ttt2.
               ASSIGN
                   ttt2_supplier  = scxref.scx_shipfrom
                   ttt2_line      = j
                   ttt2_site      = scxref.scx_shipto
                   ttt2_part      = poddet.pod_part
                   ttt2_desc      = ""
                   ttt2_po        = scxref.scx_po
                   ttt2_poln      = scxref.scx_line
                   ttt2_beg_date  = sch_eff_start
                   ttt2_end_date  = sch_eff_end
                   ttt2_due_date  = schd_date
                   ttt2_rel_date  = schd_date - pod_translt_days
                   ttt2_transltd  = pod_translt_days
                   ttt2_qty       = schd_upd_qty
                   ttt2_pf        = schd_fc_qual.
           END.
        END.
    END.

END PROCEDURE.


