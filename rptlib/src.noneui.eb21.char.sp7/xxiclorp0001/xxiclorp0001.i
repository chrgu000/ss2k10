/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.3.1.4 $                                                         */
/*V8:ConvertModelikeReportAndMaintenance                                        */
/* REVISION: 8.6E           CREATED: 08/18/98   BY: *K1DR* Suresh Nayak      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* $Revision: 1.3.1.4 $    BY: Katie Hilbert         DATE: 04/15/02  ECO: *P03J*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 091109.1 By: Bill Jiang */

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

                                                                                     /* SS - 091109.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttxxiclorp0001
   field ttxxiclorp0001_ld_site like ld_site
   field ttxxiclorp0001_ld_loc like ld_loc
   field ttxxiclorp0001_ld_part like ld_part
   field ttxxiclorp0001_ld_lot like ld_lot
   field ttxxiclorp0001_ld_ref like ld_ref
   field ttxxiclorp0001_pt_um like pt_um
   field ttxxiclorp0001_ld_qty_oh like ld_qty_oh
   field ttxxiclorp0001_ld_date like ld_date
   field ttxxiclorp0001_ld_expire like ld_expire
   field ttxxiclorp0001_ld_assay like ld_assay
   field ttxxiclorp0001_ld_grade like ld_grade
   field ttxxiclorp0001_ld_status like ld_status
   field ttxxiclorp0001_is_avail like is_avail
   field ttxxiclorp0001_is_nettable like is_nettable
   field ttxxiclorp0001_is_overissue like is_overissue
   INDEX index1 
   ttxxiclorp0001_ld_site
   ttxxiclorp0001_ld_loc
   ttxxiclorp0001_ld_part
   ttxxiclorp0001_ld_lot
   ttxxiclorp0001_ld_ref
   .
/* SS - 091109.1 - E */
