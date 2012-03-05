/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.3.1.4 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/* REVISION: 8.6E           CREATED: 08/18/98   BY: *K1DR* Suresh Nayak      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* $Revision: 1.3.1.4 $    BY: Katie Hilbert         DATE: 04/15/02  ECO: *P03J*  */
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 08/27/05  ECO: *SS - 20050827*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

                                                                                     /* SS - 20050827 - B */
                                                                                     /*/*
define temp-table t_autocr
   field ac_sixrecid as recid
   field ac_sixselect      as logical label "*" format "*/"
   field ac_sopart         like six_sopart
   field ac_authorization  like six_authorization
   field ac_ship_id        like six_ship_id
   field ac_po             like six_po
   field ac_custref        like six_custref
   field ac_modelyr        like six_modelyr
   field ac_salesorder     like six_order
   index ac_partauth
         ac_sopart
         ac_authorization
   index ac_authpart
         ac_authorization
         ac_sopart
   index ac_shippart
         ac_ship_id
         ac_sopart
   index ac_popart
         ac_po
         ac_sopart
   index ac_sixrecid is unique
         ac_sixrecid.
*/
DEFINE {1} SHARED TEMP-TABLE tta6sfacrp01
    FIELD tta6sfacrp01_acct LIKE opgl_dr_acct
    FIELD tta6sfacrp01_sub LIKE opgl_dr_sub
    FIELD tta6sfacrp01_cc LIKE opgl_dr_cc
    FIELD tta6sfacrp01_proj LIKE opgl_dr_proj
    FIELD tta6sfacrp01_dr_amt LIKE opgl_gl_amt
    FIELD tta6sfacrp01_cr_amt LIKE opgl_gl_amt
    FIELD tta6sfacrp01_entity LIKE gltr_entity
    FIELD tta6sfacrp01_gl_ref LIKE opgl_gl_ref
    FIELD tta6sfacrp01_tran_date LIKE op_tran_date
    FIELD tta6sfacrp01_date LIKE op_date
    FIELD tta6sfacrp01_wo_nbr LIKE op_wo_nbr
    FIELD tta6sfacrp01_wo_lot LIKE op_wo_lot
    FIELD tta6sfacrp01_wo_op LIKE op_wo_op
    FIELD tta6sfacrp01_site LIKE op_site
    FIELD tta6sfacrp01_part LIKE op_part
    FIELD tta6sfacrp01_type LIKE op_type
    FIELD tta6sfacrp01_trnbr LIKE op_trnbr
    FIELD tta6sfacrp01_wkctr LIKE op_wkctr
    FIELD tta6sfacrp01_mch LIKE op_mch
    FIELD tta6sfacrp01_dr_qty_wip LIKE op_qty_wip
    FIELD tta6sfacrp01_dr_qty_comp LIKE op_qty_comp
    FIELD tta6sfacrp01_dr_qty_rjct LIKE op_qty_rjct
    FIELD tta6sfacrp01_dr_qty_rwrk LIKE op_qty_rwrk
    FIELD tta6sfacrp01_dr_qty_scrap LIKE op_qty_scrap
    FIELD tta6sfacrp01_dr_qty_adjust LIKE op_qty_adjust
    FIELD tta6sfacrp01_cr_qty_wip LIKE op_qty_wip
    FIELD tta6sfacrp01_cr_qty_comp LIKE op_qty_comp
    FIELD tta6sfacrp01_cr_qty_rjct LIKE op_qty_rjct
    FIELD tta6sfacrp01_cr_qty_rwrk LIKE op_qty_rwrk
    FIELD tta6sfacrp01_cr_qty_scrap LIKE op_qty_scrap
    FIELD tta6sfacrp01_cr_qty_adjust LIKE op_qty_adjust
    .
/* SS - 20050827 - E */
