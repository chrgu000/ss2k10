/* ppptmta2.i - ITEM MAINTENANCE INCLUDE FILE                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F281*                */
/* REVISION: 7.0      LAST MODIFIED: 05/28/92   BY: pma *F537*                */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: pma *H055*                */
/*           7.3                     09/03/94   BY: bcm *GL93*                */
/* REVISION: 8.5      LAST MODIFIED: 02/01/95   BY: tjm *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 07/22/95   BY: ktn *J05Z*                */
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   BY: tjs *J088*                */
/* REVISION: 8.5      LAST MODIFIED: 03/05/96   BY: jpm *J0DN*                */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *G2TT* Thomas Fernandes   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.14 $    BY: Jean Miller          DATE: 04/16/02  ECO: *P05S*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

   pt_prod_line   colon 15
   pt_part_type   colon 36
   pt_draw        colon 58     /*V8! skip(.1) */
   pt_add         colon 15
   pt_status      colon 36
   pt_rev         colon 58     /*V8! skip(.1) */
   pt_dsgn_grp    colon 15
   pt_group       colon 36
   pt_drwg_loc    colon 58
   pt_drwg_size            label "Size"        /*V8! skip(.1) */
   pt_promo       colon 15 label "Promo Group"
   pt_break_cat   colon 58
   pt__chr01      colon 15 format "x(48)"
   pt__chr09      colon 15 format "x(20)"
   pt__chr10      colon 58 format "x(4)"
   pt__qad18      colon 15 format "->,>>>,>>9.9<"
   pt__dec01      colon 58 format "->,>>>,>>9.9<"
   pt__qad20      colon 15 format "->,>>>,>>9.9<"
   pt__qad19      colon 58 format "->,>>>,>>9.9<"