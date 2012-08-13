/* GUI CONVERTED from pppsmta4.i (converter v1.78) Fri Oct 29 14:37:38 2004 */
/* pppsmta4.i - ITEM MAINTENANCE INCLUDE FILE                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */

/* $Revision: 1.10 $                                                */

/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: pma *F782*          */
/*           7.3                     09/03/94   BY: bcm *GL93*          */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit  */
/* REVISION: 8.6      LAST MODIFIED: 05/22/97   BY: *K0D8* Arul Victoria*/
/* REVISION: 8.6      LAST MODIFIED: 06/23/97   BY: *K0DH* Arul Victoria*/
/* REVISION: 9.1      LAST MODIFIED: 06/07/99   BY: *N005* David Morris */
/* REVISION: 9.1      LAST MODIFIED: 06/17/99   BY: *N00J* Russ Witt    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Old ECO marker removed, but no ECO header exists *K003*               */
/* $Revision: 1.10 $    BY: Russ Witt     DATE: 09/21/01 ECO: *P01H*      */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*ANY CHANGES TO THIS FORM SHOULD ALSO BE APPLIED TO*/
/*PPPTMTA4.I*/

   ptp_ms          colon 14
   ptp_buyer       colon 40
   ptp_phantom     colon 65

   ptp_plan_ord    colon 14
   ptp_vend        colon 40
   ptp_ord_min     colon 65

   ptp_timefnce    colon 14
   ptp_po_site     colon 40
   ptp_ord_max     colon 65

   in_mrp          colon 14
   ptp_pm_code     colon 40
   ptp_ord_mult    colon 65

   ptp_ord_pol     colon 14
   cfg             colon 40
   ptp_op_yield    colon 65

   ptp_ord_qty     colon 14
   ptp_ins_rqd     colon 35
   ptp_yld_pct     colon 65

   ptp_batch       colon 14
   ptp_ins_lead    colon 35
   ptp_cum_lead    colon 48
   ptp_run         colon 65

   ptp_ord_per     colon 14
   ptp_mfg_lead    colon 35
   ptp_pur_lead    colon 48
   ptp_setup       colon 65

   ptp_sfty_stk    colon 14
   btb-type        colon 65

   ptp_sfty_tme    colon 14
   atp-enforcement colon 35
   emt-auto        colon 65

   ptp_rop         colon 14
   ptp_atp_family  colon 35
   ptp_network     colon 58

   ptp_rev         colon 14
   ptp_run_seq1    colon 35
   ptp_routing     colon 58

   ptp_iss_pol     colon 14
   ptp_run_seq2    colon 35
   ptp_bom_code    colon 58
