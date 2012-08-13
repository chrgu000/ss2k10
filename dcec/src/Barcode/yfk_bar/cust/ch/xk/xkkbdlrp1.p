/*-------------------------------------------------------------------
  File         xkkbdlrp1.p
  Description  create P.L., this program bases xkkbdlrp.p
  Author       Yang Enping
  Notes
  History
         2004-6-16, Yang Enping, 0002
	     Add line field, work center field.

	 2004-6-17, Yang Enping, 0003
	     1.  Add window time, use filed:
	         Window date: ttWindowDate  ==>  usrw_datefld[2]
		 Window time: ttWindowTime  ==>  usrw_intfld[3]
             2.  Below invloved files should be reviewed and modify
	         xkkbdltt.i
		 xkkbdlrp.p
		 xkkbdlrd.p
		 xkplpre.p

 -------------------------------------------------------------------*/

{mfdeclre.i}

{pxmaint.i}

/* Define Handles for the programs. */
{pxphdef.i kbtranxr}
{pxphdef.i gplngxr}
{pxphdef.i gputlxr}

/* End Define Handles for the programs. */

/* KANBAN CONSTANTS */
{kbconst.i}


/*GLOBAL DEFINES */
{kbdlglb.i}

define variable part1            like usrw_charfld[1]                 no-undo.
define variable suppSource1      like knbs_ref1                 no-undo.
define variable supermarket1     like knbsm_supermarket_id      no-undo.
define variable buyer            like pt_buyer                  no-undo.
define variable buyer1           like pt_buyer                  no-undo.
define variable site1            like si_site                   no-undo.
define variable authDate        like knbd_authorize_date           no-undo.
define variable authDate1       like knbd_authorize_date           no-undo.
define variable authTime        as character format "99:99:99" no-undo
   initial "000000".
define variable authTime1       as character format "99:99:99" no-undo
   initial "999999".

define variable outputMode       like lngd_mnemonic             no-undo.
define variable createFax        like mfc_logical   initial no  no-undo.
define variable faxOutput        as character    format "x(8)"  no-undo.
define variable createEmail      like mfc_logical   initial no  no-undo.
define variable update_yn        like mfc_logical   initial YES  no-undo.
define variable releasePOs       like mfc_logical   initial no  no-undo.
define variable copyEditedTax    like mfc_logical   initial yes  no-undo.

define variable authTimeSec       as decimal                   no-undo.
define variable authTime1Sec      as decimal                   no-undo.
define variable sourceType         as character                 no-undo.
define variable DispatchListPOLine like pod_line                no-undo.
define variable POReleaseQty       like pod_rel_qty             no-undo.
define variable POReleased         like mfc_logical             no-undo.
define variable DLComment          as character                 no-undo.
define variable buyerValue         like pt_buyer                no-undo.

/* VARIABLES FOR SORT LIST */
define variable valid-sorts          as character no-undo.
define variable sort-options        as integer no-undo.
define variable sort-data           as character format "x(30)" no-undo.
/* SORT-SELECTION '1' = SOURCE BY ITEM is default */
define variable sort-selection      as integer initial 1 format "9" no-undo.
/*define input parameter k as logical .*/

define query q-kb-card for knbd_det,
                           knbl_det,
                           knb_mstr,
                           knbi_mstr,
                           knbs_det,
                           knbsm_mstr.

define query q-kb-card-part for knbi_mstr,
                                knb_mstr,
                                knbsm_mstr,
                                knbs_det,
                                knbl_det,
                                knbd_det.

define query q-kb-card-site for knbsm_mstr,
                                knb_mstr,
                                knbi_mstr,
                                knbs_det,
                                knbl_det,
                                knbd_det. 

DEFINE TEMP-TABLE ord
    FIELD nbr AS CHARACTER .

/* DEFINE DISPATCH LIST TEMP-TABLE TO BE USED  */
{xkkbdltt.i "new"}




  RUN buildCardTempTable.



      /* PO RELEASE PROCESSING */


/*0003*----
      {gprun.i ""xkkbdlrd.p""
               "(input        copyEditedTax,
                 input-output table ttDispList)"}.
----*0003*/
/*0003*----*/
      {gprun.i ""xkkbdlrd.p""
               "(input        copyEditedTax)"}.
/*----*0003*/


   /* UPDATE DISPATCH LIST PRINT DATE IF UPDATE = YES */

      for each ttDispList:

         for first knbd_det fields (knbd_print_dispatch)
         exclusive-lock where
            knbd_id = ttID:
            knbd_print_dispatch = no.
	    

            for last kbtr_hist
               fields (kbtr_disp_list_date)
               where
                  kbtr_id  = ttID
               exclusive-lock:
                  kbtr_disp_list_date = today.
            end. /* for last kbtr_hist */
         end.  /* for first knbd_det */

      end.  /* for each ttDispList */

   /* ************************************************************************** */
/* ****************** I N T E R N A L   P R O C E D U R E S ***************** */
/* ************************************************************************** */

PROCEDURE buildCardTempTable:

FOR EACH usrw_wkfl WHERE usrw_key1 = ("emptykb" + mfguser) AND usrw_logfld[1] :





      /* PERFORM BUYER/PLANNER SELECTION  */
      buyerValue = "".

      for first pt_mstr
      fields (pt_part
              pt_um
              pt_group
              pt_buyer
              pt_desc1)
      where pt_part = usrw_charfld[1]
      no-lock:
         assign
            buyerValue = pt_buyer.
      end.

      for first ptp_det
      fields (ptp_site
              ptp_part
              ptp_buyer)
      where ptp_part = usrw_charfld[1]
      and   ptp_site = usrw_charfld[2]
      no-lock:
         buyerValue = ptp_buyer.
      end.


      /* CREATE RECORD IN TEMP TABLE NOW  */
      create ttDispList.
      assign
         ttPart               = usrw_charfld[1]
         ttStep               = usrw_intfld[1]
         ttSiteSupermarket    = usrw_charfld[2]
         ttSupermarket_id     = usrw_charfld[3]
/*0002*/ ttLine               = usrw_intfld[2]
/*0002*/ ttwkctr              = usrw_charfld[13]
         ttSourceType         = usrw_charfld[4]
         ttSourceRef1         = usrw_charfld[5]
         ttSourceRef2         = usrw_charfld[6]
         ttSourceRef3         = usrw_charfld[7]
         ttSourceRef4         = usrw_charfld[8]
         ttSourceRef5         = usrw_charfld[9]
         ttID                 = INTEGER(usrw_key2)
         ttCardType           = usrw_charfld[10]
         ttAuthDate           = usrw_datefld[1]
         ttAuthTime           = usrw_decfld[1]
         ttKanbanQuantity     = usrw_decfld[2]
         ttBlanketPO          = usrw_charfld[11] 
         tturgent             = usrw_logfld[2]
	 /*0003*----*/
         ttWindowDate         = usrw_datefld[2]             
         ttWindowTime         = usrw_intfld[3]   .
         /*----*0003*/

      if available pt_mstr then
         ttUM = pt_um.

END.
END PROCEDURE.  /* buildCardTempTable */
