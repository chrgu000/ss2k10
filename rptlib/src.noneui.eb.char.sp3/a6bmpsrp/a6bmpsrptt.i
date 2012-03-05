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
            DEFINE {1} SHARED TEMP-TABLE tta6bmpsrp
                FIELD tta6bmpsrp_par LIKE ps_par
                FIELD tta6bmpsrp_lvl as character format "x(10)"
                FIELD tta6bmpsrp_level as integer
                FIELD tta6bmpsrp_comp LIKE ps_comp
                FIELD tta6bmpsrp_ref LIKE ps_ref
                FIELD tta6bmpsrp_desc1 LIKE pt_desc1
                FIELD tta6bmpsrp_desc2 LIKE pt_desc2
                FIELD tta6bmpsrp_qty_per LIKE ps_qty_per
                FIELD tta6bmpsrp_um LIKE pt_um
                FIELD tta6bmpsrp_op LIKE ps_op
                FIELD tta6bmpsrp_phantom LIKE mfc_logical
                FIELD tta6bmpsrp_ps_code LIKE ps_ps_code
                FIELD tta6bmpsrp_iss_pol LIKE pt_iss_pol
                FIELD tta6bmpsrp_start LIKE ps_start
                FIELD tta6bmpsrp_end LIKE ps_end
                FIELD tta6bmpsrp_lt_off LIKE ps_lt_off
                FIELD tta6bmpsrp_scrp_pct LIKE ps_scrp_pct
                FIELD tta6bmpsrp_rev LIKE pt_rev
                FIELD tta6bmpsrp_rmks LIKE ps_rmks
                .
/* SS - 20051017 - E */
