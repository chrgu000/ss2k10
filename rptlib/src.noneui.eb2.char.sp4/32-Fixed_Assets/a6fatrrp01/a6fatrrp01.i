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
/* $Revision: 1.3.1.4 $    BY: Micho Yang            DATE: 04/26/06  ECO: *SS - Micho - 20060426*  */
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

/****************************** Add by SS - Micho - 20060427 B ******************************/ 
DEFINE {1} SHARED TEMP-TABLE tta6fatrrp01
    FIELD tta6fatrrp01_fabd_faloc_id LIKE fabd_faloc_id 
    FIELD tta6fatrrp01_perdate       LIKE fabd_yrper    
    FIELD tta6fatrrp01_fabd_fa_id    LIKE fabd_fa_id    
    FIELD tta6fatrrp01_fa_desc1      LIKE fa_desc1      
    FIELD tta6fatrrp01_fabd_facls_id LIKE fabd_facls_id 
    FIELD tta6fatrrp01_fabd_entity   LIKE fabd_entity   
    FIELD tta6fatrrp01_costamt       LIKE fabd_peramt   
    FIELD tta6fatrrp01_fabd_trn_loc  LIKE fabd_trn_loc  
    INDEX index1 tta6fatrrp01_perdate tta6fatrrp01_fabd_fa_id 
                 tta6fatrrp01_fabd_trn_loc tta6fatrrp01_fabd_faloc_id 
    .
/****************************** Add by SS - Micho - 20060427 E ******************************/ 
