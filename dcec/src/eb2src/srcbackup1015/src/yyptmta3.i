/* ppptmta3.i - ITEM MAINTENANCE INCLUDE FILE                                 */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F281*                */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: pma *F782*                */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: tjs *G035*                */
/* REVISION: 7.4      LAST MODIFIED: 08/25/93   BY: dpm *H075*                */
/*           7.3                     09/03/94   BY: bcm *GL93*                */
/* REVISION: 7.5      LAST MODIFIED: 01/05/95   BY: pma *J040*                */
/* REVISION: 8.5      LAST MODIFIED: 03/05/96   BY: jpm *J0DN*                */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9     BY: Jean Miller           DATE: 04/16/02  ECO: *P05S*  */
/* $Revision: 1.10 $    BY: Narathip W.           DATE: 04/10/03  ECO: *P0PS*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "PPPTMTA3.I"}

   {&PPPTMTA3-I-TAG1}
   pt_abc            colon 20
   pt_avg_int        colon 54   /*V8! skip(.1) */
   pt_lot_ser        colon 20
   pt_cyc_int        colon 54   /*V8! skip(.1) */
   pt_site           colon 20
   pt_shelflife      colon 54   /*V8! skip(.1) */
   pt_loc            colon 20
   pt_sngl_lot       colon 54   /*V8! skip(.1) */
   pt_loc_type       colon 20
   pt_critical       colon 54   /*V8! skip(.1) */
   pt_auto_lot       colon 20
   pt_rctpo_status   colon 54
   pt_rctpo_active   colon  74 /*71*/   /*V8! skip(.1) */
   pt_lot_grp        colon 20
   pt_rctwo_status   colon 54
   pt_rctwo_active   colon  74 /*71*/   /*V8! skip(.1) */
   pt_article        colon 20
   {&PPPTMTA3-I-TAG2}
