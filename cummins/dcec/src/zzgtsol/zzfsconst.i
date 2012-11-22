/* GUI CONVERTED from fsconst.i (converter v1.78) Fri Oct 29 14:36:37 2004 */
/* fsconst.i   Field Service Constants                                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.3.2.2 $                                               */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.5      LAST MODIFIED: 07/01/93   BY: sas    *J04C*/
/* REVISION: 7.5      LAST MODIFIED: 04/05/93   BY: gcs    *J04C*/
/* REVISION: 8.5      LAST MODIFIED: 09/01/95   BY: *J04C* Sue Poland    */
/* REVISION: 8.5      LAST MODIFIED: 01/08/98   BY: *J29J* Surekha Joshi */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder */
/* $Revision: 1.3.2.2 $    BY: Niranjan R.       DATE: 03/09/02  ECO: *P020* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/***********************************************************/
/*                    FSM_TYPE FIELD VALUES                */
/***********************************************************/
/* define variable fsmro_c        as character initial "FSM-RO". */
define variable fsm_c          as character initial "FSM".
define variable rma_c          as character initial "RMA".
define variable rmarct_c       as character initial "RMA-RCT".
define variable rmaiss_c       as character initial "RMA-ISS".
define variable scontract_c    as character initial "SC".
define variable saddcharge_c   as character initial "SC-ADD".
define variable seo_c       as character initial "SEO"     no-undo.
define variable isswo_c        as character initial "ISS-WO".
define variable rctup_c        as character initial "RCT-UNP".

/***********************************************************/
/*                    FILE FIELD VALUES                    */
/***********************************************************/
define variable safile_c       as character initial "sa_mstr".
define variable svfile_c       as character initial "sv_mstr".
define variable isbfile_c      as character initial "isb_mstr".
define variable wodfile_c      as character initial "wod_det".
define variable itmfile_c      as character initial "itm_det".
define variable itmhfile_c     as character initial "itmh_hist".

/***********************************************************/
/*                    SAL_TYPE   VALUES                    */
/***********************************************************/
define variable saltotrec_c    as character initial "T".
define variable saldetrec_c    as character initial "D".

/***********************************************************/
/*                    SV_SVC_TYPES                         */
/***********************************************************/
define variable warrtype_c     as character initial "W".
define variable satype_c       as character initial "S".

/***********************************************************/
/*                    CA_PREFIX VALUES                     */
/***********************************************************/
define variable caprefix_c     as character initial "CA".
define variable euprefix_c     as character initial "EU".
define variable invmstr_c      as character initial "inv".
define variable additems_c     as character initial "ai".

/***********************************************************/
/*                    FPC_LIST_TYPE (PRICE LIST TYPES)     */
/***********************************************************/
define variable expenselst_c   as integer   initial 3.
define variable repairlst_c    as integer   initial 2.
define variable contractlst_c  as integer   initial 1.

/***********************************************************/
/*                OP_HIST TRANSACTION TYPES                */
/***********************************************************/
define variable labortrans_c   as character initial "LABOR".
define variable exptrans_c     as character initial "EXPENSE".

/***********************************************************/
/*                ESCALATION PREFIX VALUES                 */
/***********************************************************/
define variable rces_c         as character initial "R".
define variable rcesdet_c      as character initial "RD".

/***********************************************************/
/*                FCC_TYPE VALUES                          */
/***********************************************************/
define variable revenuefcc_c   as character initial "R".
define variable chargefcc_c    as character initial "C".

/***********************************************************/
/*                WO_STATUS FOR REPAIR WO                  */
/***********************************************************/
/* WOREADY_C INDICATES READY TO INVOICE */
define variable woready_c      as character initial "1".
/* WOCLOSE_C INDICATES INVOICE HAS BEEN POSTED FOR THE REPORT */
define variable woclose_c      as character initial "2".

/***********************************************************/
/*                RETURN SITE VALUES FOR RDF_MSTR          */
/***********************************************************/
define variable rdf_return_c   as character initial "R".
define variable rdf_repair_c   as character initial "RP".
define variable rdf_rts_c      as character initial "T".
define variable rdf_rrts_c     as character initial "TR".
define variable rdf_spare_c    as character initial "S".
define variable rdf_sreturn_c  as character initial "SR".
define variable rdf_scrap_c    as character initial "SC".
define variable rdf_es_c       as character initial "ES".

/***********************************************************/
/*              FCG_INDEX VALUES                           */
/***********************************************************/
define variable warranty_c      as integer  initial  1.
define variable contract_c      as integer  initial  2.
define variable covered_c       as integer  initial  3.
define variable project_c       as integer  initial  4.
define variable giveaway_c      as integer  initial  5.
define variable fixedbill_c     as integer  initial  6.
define variable billable_c      as integer  initial  7.

/***********************************************************/
/*                MISCELANEOUS                             */
/***********************************************************/
define variable mfblank        as character initial "".
define variable zero           as integer   initial 0.
define variable one            as integer   initial 1.
define variable fsdate_c       as character initial "findate".

/***********************************************************/
/*                SAD_LINE_TYPE VALUE.                     */
/***********************************************************/
define variable lineTypeEndUser        as character initial "1".
define variable lineTypeItem           as character initial "2".
define variable lineTypeDetail         as character initial "3".
define variable lineTypeEndUserAddChg  as character initial "4".
define variable lineTypeContractAddChg as character initial "5".
