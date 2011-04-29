/* ppptmta3.i - ITEM MAINTENANCE INCLUDE FILE                           */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F281*          */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: pma *F782*          */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: tjs *G035*          */
/* REVISION: 7.4      LAST MODIFIED: 08/25/93   BY: dpm *H075*          */
/*           7.3                     09/03/94   BY: bcm *GL93*          */
/* REVISION: 7.5      LAST MODIFIED: 01/05/95   BY: pma *J040*          */
/* REVISION: 8.5      LAST MODIFIED: 03/05/96   BY: jpm *J0DN*          */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb          */
/* REVISION: EB       LAST MODIFIED: 01/20/03   BY: *EAS003* Leemy Lee  */

/*F782*/    /*ANY CHANGES TO THIS FORM SHOULD ALSO BE APPLIED TO*/
/*F782*/    /*PPPSMTA3.I*/

/*J040  ******************REDESIGNED THE FOLLOWING FORM*******************
    *    pt_abc         colon 20
/*H075* *    pt_fr_class    colon 40  */
    *    pt_avg_int     colon 58
    *    pt_lot_ser     colon 20
    *    pt_cyc_int     colon 58
    *    pt_site        colon 20
    *    pt_shelflife   colon 58
    *    pt_loc         colon 20
    *    pt_sngl_lot    colon 58
    *    pt_loc_type    colon 20
    *    pt_critical    colon 58
    *    pt_auto_lot    colon 20
/*H075* *    pt_net_wt      colon 58 pt_net_wt_um   no-label   */
    *    pt_article     colon 20
/*H075* *    pt_size        colon 58 pt_size_um     no-label   */
/*F782*/*    rcpt_stat      colon 20
/*H075***    pt_ship_wt     colon 58 pt_ship_wt_um  no-label   */
/*GL93**  with frame b title color normal " ITEM INVENTORY DATA "
 **       side-labels width 80 attr-space. **/
**J040 ******************REDESIGNED THE ABOVE FORM**********************/

/*J040 ******************REDESIGN FOLLOWS*******************************/
        pt_abc            colon 20
/*J0DN*/    pt_avg_int        colon 54   /*V8! skip(.1) */
        pt_lot_ser        colon 20
/*J0DN*/    pt_cyc_int        colon 54   /*V8! skip(.1) */
        pt_site           colon 20
/*J0DN*/    pt_shelflife      colon 54   /*V8! skip(.1) */
        pt_loc            colon 20
/*J0DN*/    pt_sngl_lot       colon 54   /*V8! skip(.1) */
        pt_loc_type       colon 20
/*EAS021*  /*J0DN*/    pt_critical       colon 54   /*V8! skip(.1) */*/
/*EAS021*/     pt_critical     /*V8! skip(.1) */
/*EAS021*/  pt_article     COLON 54
        pt_auto_lot       colon 20
        pt_rctpo_status   colon 54
/*J0DN*/    pt_rctpo_active   colon 71   /*V8! skip(.1) */
        pt_lot_grp        colon 20
        pt_rctwo_status   colon 54
/*J0DN*/    pt_rctwo_active   colon 71   /*V8! skip(.1) */
/*EAS021*          pt_article        colon 20*/
