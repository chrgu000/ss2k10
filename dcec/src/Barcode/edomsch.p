/* GUI CONVERTED from edomsch.p (converter v1.78) Fri Oct 29 14:32:55 2004 */
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
DEF NEW SHARED VAR isfirst AS LOGICAL INITIAL YES.
DEF NEW SHARED VAR ismerge AS LOGICAL INITIAL NO.
DEF NEW SHARED VAR pre_vend AS CHAR.
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
   s_exp_supp_schedule     colon 30 label {&edomsch_p_2}
   s_exp_planning_schedule colon 30 label {&edomsch_p_3}
   s_exp_shipping_schedule colon 30 label {&edomsch_p_4}
   skip(1)
   s_print_zero       label {&edomsch_p_9} colon 30 skip
   l_print_details    label {&edomsch_p_1} colon 30 skip
   l_fpb_mnemonic           colon 30
   l_PrntFailPassBothDesc colon 41 no-label skip(1)
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

/* CHECK IF ADG MODULE IS TURNED ON */
if can-find (first mfc_ctrl where
   mfc_field = "enable_shipping_schedules"
   and mfc_seq = 4 and mfc_module = "ADG"
   and mfc_logical = yes) then do:
   assign
      s_exp_supp_schedule = no
      s_exp_planning_schedule = yes
      s_exp_shipping_schedule = no
      l_adg_module = true.
end.
else do:
   assign
      s_exp_supp_schedule = yes
      s_exp_planning_schedule = no
      s_exp_shipping_schedule = no
      l_adg_module = false.
end.
display
   s_exp_supp_schedule
   s_exp_planning_schedule
   s_exp_shipping_schedule
with frame a.

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

   /* GET THE ATTRIBUTE MNEMONIC FOR THE CODE */
   {gplngn2a.i &file     = ""ExcepReport""
      &field    = ""l_PrntFailPassBoth""
      &code     = l_PrntFailPassBoth
      &mnemonic = l_fpb_mnemonic
      &label    = l_PrntFailPassBothDesc}

   display
      l_fpb_mnemonic @ l_fpb_mnemonic
      l_PrntFailPassBothDesc @ l_PrntFailPassBothDesc
   with frame a.

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
      s_exp_supp_schedule     when (not l_adg_module) or batchrun
      s_exp_planning_schedule when (l_adg_module) or batchrun
      s_exp_shipping_schedule when (l_adg_module) or batchrun
      s_print_zero
      l_print_details
      l_fpb_mnemonic
      batchno
   with frame a editing:

      readkey.
      if frame-field <> "" then l_frame_field = frame-field.

      apply lastkey.

      if (go-pending or (l_frame_field = "l_fpb_mnemonic" and
         frame-field <> "l_fpb_mnemonic" ))
      then do:

         valid-mnemonic = no.
         {gplngv.i
            &file = ""ExcepReport""
            &field = ""l_PrntFailPassBoth""
            &mnemonic = l_fpb_mnemonic:SCREEN-VALUE
            &isvalid = valid-mnemonic
         }
         if not valid-mnemonic then do:
            {pxmsg.i &MSGNUM=6274 &ERRORLEVEL=3} /* INVALID OPTION */
            if batchrun then
               undo, leave.
            else do:
               display
                  "" @ l_PrntFailPassBothDesc
               with frame a.
               next-prompt l_fpb_mnemonic with frame a.
               next.
            end.
         end.

      end. /* IF (GO-PENDING OR ( FRAME-FIELD = "L_FPB_MNEMONIC" */

   end. /*EDITING */

   /* GET ATTRIBUTE TO STORE FOR THE MNEMONIC */

   {gplnga2n.i &file = ""ExcepReport""
      &field    = ""l_PrntFailPassBoth""
      &mnemonic = l_fpb_mnemonic:SCREEN-VALUE
      &code = l_PrntFailPassBoth
      &label = l_PrntFailPassBothDesc
      }

   display
      l_fpb_mnemonic
      l_PrntFailPassBothDesc
   with frame a.

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
   {mfquoter.i s_exp_supp_schedule    }
   {mfquoter.i s_exp_planning_schedule    }
   {mfquoter.i s_exp_shipping_schedule    }
   {mfquoter.i s_print_zero}
   {mfquoter.i l_print_details}
   {mfquoter.i l_fpb_mnemonic}
   {mfquoter.i batchno}

   /*SET DEFAULT RANGE VALUES IF SCREEN INPUT IS BLANK*/
   if l_po_to        = "" then l_po_to       = hi_char.
   if l_part_to      = "" then l_part_to     = hi_char.
   if l_supplier_to  = "" then l_supplier_to = hi_char.
   if l_shipto_to    = "" then l_shipto_to   = hi_char.
   if l_buyer_to     = "" then l_buyer_to    = hi_char.

   {mfselbpr.i "printer" 132 "page" "stream rptout"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   /* GET THE NEXT BATCH NUMBER */
   if batchno = 0 then
   assign
      batchno     = next-value( edc_sq02 )
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
         break by po_vend by pod_part:

      /*EXPORTING A PLANNING SCHEDULE*/
      if s_exp_planning_schedule then do:
         run processSchedules
            (
            input 5, /*SCHEDULE TYPE*/
            input 2, /*INDEX OF ARRAY pod_curr_rlse_id TO BE CHECKED*/
            input batchno,
            input l_new_batch,
            input recid(pod_det),
            input l_default_doc_name1,
            input l_default_doc_version,
            input l_doc_name_key1,
            input l_doc_version_key1,
            input 4  /*PLANNING SCHEDULE CHECK INDEX(see 35.21.13.10)*/
            ).
      end. /* END OF IF l_exp_planning_schedule  */
      /*EXPORTING A SUPPLIER SCHEDULE*/
      else if s_exp_supp_schedule then do:
         run processSchedules
            (
            input 4, /*SCHEDULE TYPE*/
            input 1, /*INDEX OF ARRAY pod_curr_rlse_id TO BE CHECKED*/
            input batchno,
            input l_new_batch,
            input recid(pod_det),
            input l_default_doc_name1,
            input l_default_doc_version,
            input l_doc_name_key1,
            input l_doc_version_key1,
            input 4 /*PLANNING SCHEDULE CHECK INDEX(see 35.21.13.10)*/
            ).
      end. /* END OF IF s_exp_supp_schedule */

      /*EXPORTING A SHIPPING SCHEDULE*/
      if s_exp_shipping_schedule and pod__qad05 then do:
         run processSchedules
            (
            input 6, /*SCHEDULE TYPE*/
            input 3, /*INDEX OF ARRAY pod_curr_rlse_id TO BE CHECKED*/
            input batchno,
            input l_new_batch,
            input recid(pod_det),
            input l_default_doc_name2,
            input l_default_doc_version,
            input l_doc_name_key2,
            input l_doc_version_key2,
            input 5  /*SHIPPING SCHEDULE CHECK INDEX(see 35.21.13.10)*/
            ).
      end. /* END OF IF s_exp_shipping_schedule... */
   end. /*FOR EACH PO_MSTR*/

   /* CALL PROCESS CONTROL PROGRAM PASSING IN SEQUENCE NUMBER LIST  */
   {gprun.i ""edprctrl.p""
      "( input 100,   /*OUTBOUND GATEWAY*/
        input l_sequence_list,   /*SEQUENCE NUMBER LIST*/
        input-output table tt_exf_status,/*EXCHANGE FILE SEQUENCE
        NUMBERS TABLE*/
        input-output table tt_doc_status,/*MFG/PRO FILE SEQUENCE
        NUMBERS TABLE*/
        output l_processed_sequence_list  )"}   /*PROCESSED SEQUENCE
   NUMBER LIST*/

   /* REMOVE THE LAST COMMA FROM THE PROCESSED SEQUENCE NUMBER LIST */
   l_processed_sequence_list = trim( l_processed_sequence_list,"," ).

   /* PRINT THE REPORTS */
   {gprun.i ""edpsrp01.p""
      "(  INPUT l_processed_sequence_list,
        INPUT no,
        INPUT l_print_details  )"}

   if l_new_batch and l_submitted_for_export then do:
      display batchno with frame a.
   end.
   else if not l_submitted_for_export then do:
      {pxmsg.i &MSGNUM=4760 &ERRORLEVEL=4 &MSGBUFFER=l_err_desc}
      /*NO DOCUMENTS WERE EXPORTED*/
      put stream rptout skip(1) l_err_desc skip.
   end.

   /*REPORT TRAILER*/
   {mfrtrail.i "stream rptout"}

end. /* REPEAT : MAINLOOP: */

/* EOF */

/*===============================================================================================*/

/*===============================================================================================*/
PROCEDURE processSchedules:

/*-----------------------------------------------------------------------------------------------
PURPOSE   : FOR BOTH NEW OR EXISTING ECOMMERCE BATCHS IT SELECTS SCHEDULE MASTER RECORDS
ASSOCIATED WITH THE INPUT PURCHASE ORDER DETAIL RECORD ID AND CREATES A DOCUMENT
STATUS RECORD.
IT ALSO MARKS THE RECORD AS BEING SUBMITTED FOR EXPORT.

PARAMETERS:
i_sch_type          THE SCHEDULE TYPE
i_releaseIndex      INDEX OF THE FIELD ARRAY pod_curr_rlse_id TO BE CHECKED.
i_batchno           THE ECOMMERCE BATCH NUMBER.
i_new_batch         FLAG INDICATING IF THIS IS A NEW BATCH (TRUE) OR
EXISTING BATCH (FALSE)
i_poddet_recid      RECORD ID OF CURRENT PURCHASE ORDER DETAIL RECORD.
i_default_doc_name       PASSED TO PROCEDURE getDocumentName_Version.
i_default_doc_version    PASSED TO PROCEDURE getDocumentName_Version.
i_lookup_name            PASSED TO PROCEDURE getDocumentName_Version.
i_lookup_version         PASSED TO PROCEDURE getDocumentName_Version.
i_export_doc_check_index PASSED TO PROCEDURE getDocumentName_Version.

NOTES:
-------------------------------------------------------------------------------------------------*/
   /*DEFINE INPUT & OUTPUT VARIABLES*/
   define input parameter i_sch_type like sch_type no-undo.
   define input parameter i_releaseIndex as integer no-undo.
   define input parameter i_batchno like batchno no-undo.
   define input parameter i_new_batch as logical no-undo.
   define input parameter i_poddet_recid as recid.
   define input parameter i_default_doc_name like edmfs_mfd_name no-undo.
   define input parameter i_default_doc_version like edmfs_mfd_vers no-undo.
   define input parameter i_lookup_name like edtpparm_char_desc[1] no-undo.
   define input parameter i_lookup_version like edtpparm_int_desc[1] no-undo.
   define input parameter i_export_doc_check_index as integer no-undo.

   /* DEFINE BUFFERS */
   define buffer poddet for pod_det.
   define buffer scxref for scx_ref.

   /*DEFINE LOCAL VARIABLES*/
   define variable l_reference_value like edmfs_mft_idx_val no-undo.
   define variable l_doc_name like edmf_mfd_name no-undo.
   define variable l_doc_version like edmf_mfd_vers no-undo.
   define variable l_successful like mfc_logical no-undo.

   /*MOVE TO CURRENT RECORD IN PURCHASE ORDER DETAIL TABLE*/
   for first poddet
      fields(pod_nbr pod_line pod_curr_rlse_id[i_releaseIndex])
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

         run getDocumentName_Version
            (
            input i_default_doc_name,
            input i_default_doc_version,
            input i_lookup_name,
            input i_lookup_version,
            input scxref.scx_shipto,
            input scxref.scx_shipfrom,
            input scxref.scx_po,
            input i_export_doc_check_index,
            output l_doc_name,
            output l_doc_version,
            output l_successful
            ).

         if l_successful then do:

            l_reference_value = string(sch_type) + "," + sch_nbr + ","
               + string(sch_line) + "," + sch_rlse_id.

            run createDocumentStatusRecord
               (
               input scxref.scx_shipto,
               input scxref.scx_shipfrom,
               input l_doc_name,
               input l_doc_version,
               input l_reference_value,
               output l_successful
               ).

            if l_successful then
               run markAsExported
                  (
                  input recid(sch_mstr),
                  input i_batchno
                  ).

         end. /*if l_successful...*/
      end. /* FOR EACH sch_mstr */
   end. /* if l_new_batch...*/
   else do:
      for each sch_mstr no-lock
            where sch_type = i_sch_type
            and sch_nbr = poddet.pod_nbr
            and sch_line = poddet.pod_line
            and length(sch_ship) >= 16
            and integer(substring(sch_ship,17)) = i_batchno
            break by sch_type:
         run getDocumentName_Version
            (
            input i_default_doc_name,
            input i_default_doc_version,
            input i_lookup_name,
            input i_lookup_version,
            input scxref.scx_shipto,
            input scxref.scx_shipfrom,
            input scxref.scx_po,
            input i_export_doc_check_index,
            output l_doc_name,
            output l_doc_version,
            output l_successful
            ).

         if l_successful then do:

            l_reference_value = string(sch_type) + "," + sch_nbr + ","
               + string(sch_line) + "," + sch_rlse_id.

            run createDocumentStatusRecord
               (
               input scxref.scx_shipto,
               input scxref.scx_shipfrom,
               input l_doc_name,
               input l_doc_version,
               input l_reference_value,
               output l_successful
               ).

            if l_successful then
               run markAsExported
                  (
                  input recid(sch_mstr),
                  input i_batchno
                  ).
         end. /*if l_successful..*/
      end. /* FOR EACH sch_mstr */
   end. /* if l_new_batch...else do*/

END PROCEDURE.

/*===============================================================================================*/
PROCEDURE getDocumentName_Version:

/*---------------------------------------------------------------------------------------
PURPOSE:
OBTAINS DOCUMENT DETAILS (NAME AND VERSION) FROM THE REPOSITORY BY USING
THE TRADING PARTNER DETAILS.

PARAMETERS:
i_default_doc_name          DEFAULT DOCUMENT NAME TO USE IF NONE IS FOUND
i_default_doc_version       DEFAULT DOCUMENT VERSION TO USE IF NONE IS FOUND
i_lookup_name               LOOKUP VALUE USED TO FIND DOCUMENT NAME
i_lookup_version            LOOKUP VALUE USED TO FIND DOCUMENT NAME
i_site                      USED TO FIND THE TRADING PARTNER DETAILS.
i_address                   USED TO FIND THE TRADING PARTNER DETAILS.
i_current_record_number     USED IN THE OUTPUT OF ERROR MESSAGE.
i_export_doc_check_index    INDEX OF FIELD TO CHECK WHETHER THE DOCUMENT CAN BE
EXPORTED VIA ECOMMERCE (SEE MFG/PRO 35.21.13.10)
o_doc_name                  REQUIRED DOCUMENT NAME
o_doc_version               REQUIRED DOCUMENT VERSION
o_successful                INDICATES WHETHER THE PROCEDURE RAN SUCCESSFULLY OR NOT.

NOTES:
----------------------------------------------------------------------------------------*/

   /*DEFINE INPUT & OUTPUT VARIABLES*/
   define input parameter i_default_doc_name        like edmfs_mfd_name no-undo.
   define input parameter i_default_doc_version     like edmfs_mfd_vers no-undo.
   define input parameter i_lookup_name             like edtpparm_char_desc[1] no-undo.
   define input parameter i_lookup_version          like edtpparm_int_desc[1] no-undo.
   define input parameter i_site                    like edtpparm_site no-undo.
   define input parameter i_address                 like edtpparm_addr no-undo.
   define input parameter i_current_record_number   like po_nbr no-undo.
   define input parameter i_export_doc_check_index  as integer no-undo.
   define output parameter o_doc_name               like edmfs_mfd_name no-undo.
   define output parameter o_doc_version            like edmfs_mfd_vers no-undo.
   define output parameter o_successful             as logical initial yes no-undo.

   /*DEFINE LOCAL VARIABLES*/
   define variable l_index                             as integer  no-undo.
   define buffer l_statusMasterBuffer                  for edmfs_mstr.

   /*INITIALISE DOCUMENT NAME AND VERSION*/
   assign
      o_doc_name = i_default_doc_name
      o_doc_version = i_default_doc_version.

   /*GET DOCUMENT NAME AND VERSION FROM REPOSITORY USING TRADING PARTNER DETAILS*/
   find edtpparm_mstr where
      edtpparm_site = i_site and
      edtpparm_addr = i_address no-lock no-error.

   if not available edtpparm_mstr then do:
      if not batchrun then do:
         /* TRADING PARTNER PARAMETERS DO NOT EXIST */
         {pxmsg.i &MSGNUM=4749 &ERRORLEVEL=4 &MSGARG1=i_site
            &MSGARG2=i_address }
         pause 5.
         hide message no-pause.
      end.
      o_successful = no.
      leave.
   end.
   else do:
      /*CHECK IF DOCUMENT CAN BE SENT TO TRADING PARTNER VIA ECOMMERCE (35.21.13.10)*/
      if not edtpparm_log[i_export_doc_check_index] then do:
         o_successful = no.
         leave.
      end.

      /*TAKE DOCUMENT NAME FROM TP ENTRY REFERRED TO IN i_lookup_name*/
      repeat l_index = 1 to extent(edtpparm_char):
         if edtpparm_char_desc[l_index] = i_lookup_name then do:
            assign
               o_doc_name = edtpparm_char[l_index].
         end.
      end.
      /*TAKE DOCUMENT VERSION FROM TP ENTRY REFERRED TO i_lookup_version*/
      repeat l_index = 1 to extent(edtpparm_int):
         if edtpparm_int_desc[l_index] = i_lookup_version then do:
            assign
               o_doc_version = edtpparm_int[l_index].
         end.
      end.
      /* IF WE'RE NOT USING THE DEFAULT DOCUMENT THEN CHECK THE
      DOCUMENT MASTER TABLE USING THE DOC NAME/VERSION VALUES */
      if o_doc_name <> i_default_doc_name then do:
         find edmf_mstr where
            edmf_mfd_name = o_doc_name and
            edmf_mfd_vers = o_doc_version and
            edmf_doc_in   = no  /*OUTBOUND DOC*/
         no-lock no-error.
         if not available edmf_mstr then do:
            if not batchrun then do:
               /* MFG/PRO DOCUMENT NOT DEFINED CORRECTLY */
               {pxmsg.i &MSGNUM=4752 &ERRORLEVEL=4 &MSGARG1=o_doc_name
                  &MSGARG2=string(o_doc_version)}
               pause 5.
               hide message no-pause.
               /* SKIP DOCUMENT */
               {pxmsg.i &MSGNUM=4759 &ERRORLEVEL=4
                  &MSGARG1=i_current_record_number}
               pause 5.
               hide message no-pause.
            end.
            o_successful = no.
            leave.
         end.    /*IF NOT AVAILABLE EDMF_MSTR*/
      end. /*(IF O_DOC_NAME)*/
   end. /*ELSE DO (NOT AVAILABLE EDTPPARM_MSTR)*/

END PROCEDURE.

/*===============================================================================================*/
PROCEDURE createDocumentStatusRecord:

/*---------------------------------------------------------------------------------------
PURPOSE   : CREATES A STATUS RECORD INDICATING THAT DOCUMENT TRANSFER IS AT INTERMEDIATE
STAGE. IT ALSO ADDS THE NEWLY GENERATED SEQUENCE NUMBER TO THE PROGRAM LEVEL
VARIABLE l_sequence_list.

PARAMETERS:
i_site                      DOCUMENT SITE
i_address                   DOCUMENT ADDRESS
i_doc_name                  DOCUMENT NAME
i_doc_version               DOCUMENT VERSION
i_reference_value           REFERENCE TO DOCUMENT DATA.

NOTES:
----------------------------------------------------------------------------------------*/

   define input parameter i_site            like edmfs_mfg_site no-undo.
   define input parameter i_address         like edmfs_mfg_addr no-undo.
   define input parameter i_doc_name        like edmfs_mfd_name no-undo.
   define input parameter i_doc_version     like edmfs_mfd_vers no-undo.
   define input parameter i_reference_value like edmfs_mft_idx_val no-undo.
   define output parameter o_successful     as   logical initial yes no-undo.

   define buffer l_statusMasterBuffer for edmfs_mstr.
   define variable l_sequence_number like edmfs_mstr.edmfs_mfd_seq no-undo.

   if not can-find(first edtmx_ref where
      edtmx_mfd_name = i_doc_name and
      edtmx_mfd_vers = i_doc_version and
      edtmx_doc_in   = no            and
      edtmx_mfg_site = i_site and
      edtmx_mfg_addr = i_address ) then do:

      if not batchrun then do:

         l_error = i_doc_name       + "/" +
            string( i_doc_version ) + "/" +
            string( no ) + "/" +
            i_site       + "/" +
            i_address.

         /* TRADING PARTNER LOCATION CROSS-REF DOES NOT EXIST */
         {pxmsg.i &MSGNUM=4430 &ERRORLEVEL=4
            &MSGARG1=l_error}
         pause 5.
         hide message no-pause.
      end.
      o_successful = no.
      leave.
   end. /* IF NOT CAN-FIND(FIRST EDTMX_REF WHERE */
   else
      /* CHECK TO SEE IF MULTIPLE RECORD EXISTS FOR MFD NAME/
      MFD VERS/DIR/MFG SITE/MFG ADDR. IF YES, THEN CREATE
      MFG/PRO DOCUMENT STATUS RECORD FOR EACH OCCURENCE
      */
      for each edtmx_ref where
         edtmx_mfd_name = i_doc_name and
         edtmx_mfd_vers = i_doc_version and
         edtmx_doc_in   = no            and
         edtmx_mfg_site = i_site and
         edtmx_mfg_addr = i_address and
         edtmx_export   = yes no-lock:

         /* GET NEXT SEQUENCE NUMBER */
         {mfnxtsq1.i edmfs_mstr edmfs_mstr.edmfs_mfd_seq
            edmfs_sq01 l_sequence_number}

         create l_statusMasterBuffer.
         assign
            edmfs_mfd_seq     = l_sequence_number
            edmfs_status      = transfer_intermediate
            edmfs_mfg_site    = edtmx_mfg_site
            edmfs_mfg_addr    = edtmx_mfg_addr
            edmfs_doc_in      = edtmx_doc_in  /* OUTBOUND DOC*/
            edmfs_mft_idx_val = i_reference_value
            edmfs_mfd_name    = edtmx_mfd_name
            edmfs_mfd_vers    = edtmx_mfd_vers
            edmfs_tp_site     = edtmx_tp_site
            edmfs_tp_addr     = edtmx_tp_addr
            edmfs_imp_name    = edtmx_imp_name
            edmfs_imp_vers    = edtmx_imp_vers
            edmfs_tp_id       = edtmx_tp_id
            edmfs_tp_doc      = edtmx_tp_doc.

         if recid(l_statusMasterBuffer) = -1 then.

         /* APPEND SEQUENCE NUMBER TO LIST*/
         l_sequence_list = l_sequence_list + string( edmfs_mfd_seq ) + ",".

      end. /* FOR EACH EDTMX_REF WHERE */

END PROCEDURE. /*PROCEDURE createDocumentStatusRecord*/

/*===============================================================================================*/
PROCEDURE markAsExported:

/*---------------------------------------------------------------------------------------
PURPOSE   : MARK THE SCHEDULE MASTER RECORD IDENTIFIED BY i_recno AS BEING SUBMITTED FOR EXPORT.
IT ALSO UPDATES THE PROGRAM LEVEL VARIABLE l_submitted_for_export.

PARAMETERS:
i_recno                     SCHEDULE MASTER RECID
i_batch_number              ECOMMERCE BATCH NUMBER

NOTES:
----------------------------------------------------------------------------------------*/

   define input parameter i_recno as recid.
   define input parameter i_batch_number    like mfc_integer no-undo.

   define buffer l_schedulemaster for sch_mstr.
   define variable l_timestamp as character.

   /*SET TIME,DATE,BATCH NUMBER STAMP*/
   l_timestamp = string(year(today),"9999")
      + string(month(today),"99")
      + string(day(today),"99")
      + string(time,"HH:MM:SS")
      + string(i_batch_number).

   /* UPDATE RECORD IN SCHEDULE MASTER TABLE */
   for first l_schedulemaster where
      recid(l_schedulemaster) = i_recno exclusive-lock:
   sch_ship = l_timestamp.
   end.

   /*UPDATE THE PROGRAM LEVEL VARIABLE l_submitted_for_export*/
   l_submitted_for_export = yes.

END PROCEDURE. /*PROCEDURE markAsExported*/

/*===============================================================================================*/
