/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 8.6E           CREATED: 08/18/98   BY: *K1DR* Suresh Nayak      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 10/17/05   BY: *SS - 100811.1* Bill Jiang               */




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


/* SS - 100811.1 - B */                                                                              
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
            DEFINE {1} SHARED TEMP-TABLE ttxxbmpsrp0002
                FIELD ttxxbmpsrp0002_par LIKE ps_par
                FIELD ttxxbmpsrp0002_lvl as character format "x(10)"
                FIELD ttxxbmpsrp0002_level as integer
                FIELD ttxxbmpsrp0002_comp LIKE ps_comp
                FIELD ttxxbmpsrp0002_ref LIKE ps_ref
                FIELD ttxxbmpsrp0002_desc1 LIKE pt_desc1
                FIELD ttxxbmpsrp0002_desc2 LIKE pt_desc2
                FIELD ttxxbmpsrp0002_qty_per LIKE ps_qty_per
                FIELD ttxxbmpsrp0002_um LIKE pt_um
                FIELD ttxxbmpsrp0002_op LIKE ps_op
                FIELD ttxxbmpsrp0002_phantom LIKE mfc_logical
                FIELD ttxxbmpsrp0002_ps_code LIKE ps_ps_code
                FIELD ttxxbmpsrp0002_iss_pol LIKE pt_iss_pol
                FIELD ttxxbmpsrp0002_start LIKE ps_start
                FIELD ttxxbmpsrp0002_end LIKE ps_end
                FIELD ttxxbmpsrp0002_lt_off LIKE ps_lt_off
                FIELD ttxxbmpsrp0002_scrp_pct LIKE ps_scrp_pct
                FIELD ttxxbmpsrp0002_rev LIKE pt_rev
                FIELD ttxxbmpsrp0002_rmks LIKE ps_rmks
               INDEX index1 ttxxbmpsrp0002_par ttxxbmpsrp0002_comp
               INDEX index2 ttxxbmpsrp0002_comp
                .
/* SS - 100811.1 - E */
