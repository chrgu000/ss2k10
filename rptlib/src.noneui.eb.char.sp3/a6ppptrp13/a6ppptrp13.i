/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 8.6E           CREATED: 08/18/98   BY: *K1DR* Suresh Nayak      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 10/17/05   BY: *SS - 20051017* Bill Jiang               */




/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */


         /* ********** Begin Translatable Strings Definitions ********* */

         /* ********** End Translatable Strings Definitions ********* */


/* SS - 20051017 - B */                                                                              
/*
         define temp-table t_autocr
            field ac_sixrecid as recid
            field ac_sixselect      as logical label "*"
            field ac_sopart         like six_sopart format "x(16)"
            field ac_authorization  like six_authorization format "x(22)"
            field ac_ship_id        like six_ship_id format "x(18)"
            field ac_po             like six_po format "x(14)"
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
            DEFINE {1} SHARED TEMP-TABLE tta6ppptrp13
                FIELD tta6ppptrp13_site LIKE si_site
                FIELD tta6ppptrp13_part LIKE pt_part
                FIELD tta6ppptrp13_sim LIKE sct_sim
                FIELD tta6ppptrp13_mtl_tl LIKE sct_mtl_tl
                FIELD tta6ppptrp13_lbr_tl LIKE sct_lbr_tl
                FIELD tta6ppptrp13_bdn_tl LIKE sct_bdn_tl
                FIELD tta6ppptrp13_ovh_tl LIKE sct_ovh_tl
                FIELD tta6ppptrp13_sub_tl LIKE sct_sub_tl
                FIELD tta6ppptrp13_cst_tot LIKE sct_cst_tot
                FIELD tta6ppptrp13_cst_date LIKE sct_cst_date
                .
/* SS - 20051017 - E */
