/* ppptmta4.i - ITEM MAINTENANCE INCLUDE FILE                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12 $                                                */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F281*          */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: pma *F782*          */
/*           7.3                     09/03/94   BY: bcm *GL93*          */
/*           8.6                     10/11/96   BY: flm *K003*          */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit  */
/* REVISION: 8.6      LAST MODIFIED: 05/22/97   BY: *K0D8* Arul Victoria*/
/* REVISION: 8.6      LAST MODIFIED: 06/23/97   BY: *K0DH* Arul Victoria*/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 06/07/99   BY: *N005* David Morris */
/* REVISION: 9.1      LAST MODIFIED: 06/17/99   BY: *N00J* Russ Witt    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb          */
/* Old ECO marker removed, but no ECO header exists *F033*               */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.12 $    BY: Russ Witt    DATE: 09/21/01 ECO: *P01H*    */
/*V8:ConvertMode=Maintenance                                            */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*ANY CHANGES TO THIS FORM SHOULD ALSO BE APPLIED TO*/
/*PPPSMTA4.I*/

   pt_ms          colon 14
   pt_buyer       colon 40

   pt_phantom     colon 65

   pt_plan_ord    colon 14
   pt_vend        colon 40

   pt_ord_min     colon 65

   pt_timefence   colon 14
   pt_po_site     colon 40

   pt_ord_max     colon 65

   pt_mrp         colon 14
   pt_pm_code     colon 40

   pt_ord_mult    colon 65

   pt_ord_pol     colon 14
   cfg            colon 40

   pt_op_yield    colon 65

   pt_ord_qty     colon 14

   pt_insp_rqd    colon 35

   pt_yield_pct   colon 65

   pt_batch       colon 14

   pt_insp_lead   colon 35
   pt_cum_lead    colon 48
   pt_run         colon 65

   pt_ord_per     colon 14

   pt_mfg_lead    colon 35
   pt_pur_lead    colon 48
   pt_setup       colon 65

   pt_sfty_stk    colon 14
      /*roger*/   pt__dec01      label "±¶Êý" colon 35 
   btb-type       colon 65

   pt_sfty_time   colon 14

   atp-enforcement   colon 35

   pt__qad15      colon 65

   pt_rop         colon 14

   pt_atp_family colon 35
   pt_network     colon 58

   pt_rev         colon 14
   pt_run_seq1    colon 35

   pt_routing     colon 58

   pt_iss_pol     colon 14
   pt_run_seq2    colon 35

   pt_bom_code    colon 58

