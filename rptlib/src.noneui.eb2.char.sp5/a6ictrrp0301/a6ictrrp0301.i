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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 08/27/05  ECO: *SS - 20051203*  */
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

                                                                                     /* SS - 20051203 - B */
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
DEFINE {1} SHARED TEMP-TABLE tta6ictrrp0301
    FIELD tta6ictrrp0301_tr_effdate LIKE tr_effdate
    FIELD tta6ictrrp0301_tr_trnbr LIKE tr_trnbr
    FIELD tta6ictrrp0301_trgl_type LIKE trgl_type
    FIELD tta6ictrrp0301_tr_nbr LIKE tr_nbr
    FIELD tta6ictrrp0301_si_entity LIKE si_entity
    FIELD tta6ictrrp0301_trgl_gl_ref LIKE trgl_gl_ref
    FIELD tta6ictrrp0301_desc2 LIKE pt_desc2
    FIELD tta6ictrrp0301_trgl_dr_acct LIKE trgl_dr_acct
    FIELD tta6ictrrp0301_trgl_dr_sub LIKE trgl_dr_sub
    FIELD tta6ictrrp0301_trgl_dr_cc LIKE trgl_dr_cc
    FIELD tta6ictrrp0301_trgl_dr_gl_amt LIKE trgl_gl_amt
    FIELD tta6ictrrp0301_tr_part LIKE tr_part
    FIELD tta6ictrrp0301_desc1 LIKE pt_desc1
    FIELD tta6ictrrp0301_trgl_cr_acct LIKE trgl_cr_acct
    FIELD tta6ictrrp0301_trgl_cr_sub LIKE trgl_cr_sub
    FIELD tta6ictrrp0301_trgl_cr_cc LIKE trgl_cr_cc
    FIELD tta6ictrrp0301_trgl_cr_gl_amt LIKE trgl_gl_amt
    .
/* SS - 20051203 - E */
