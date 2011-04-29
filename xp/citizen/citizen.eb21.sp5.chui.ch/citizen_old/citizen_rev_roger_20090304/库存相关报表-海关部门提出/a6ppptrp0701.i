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

 /* SS - 20061103 - B */
                                                                                    
DEFINE {1} SHARED TEMP-TABLE tta6ppptrp0701
   field tta6ppptrp0701_site like in_site
   field tta6ppptrp0701_loc like ld_loc
   field tta6ppptrp0701_part like ld_part
   field tta6ppptrp0701_desc like pt_desc1
   field tta6ppptrp0701_abc like pt_abc
   field tta6ppptrp0701_qty like in_qty_oh
   field tta6ppptrp0701_um like pt_um
   field tta6ppptrp0701_sct AS DECIMAL
   field tta6ppptrp0701_ext AS DECIMAL
   field tta6ppptrp0701_qty_non_consign  like in_qty_oh
   field tta6ppptrp0701_qty_supp_consign like in_qty_oh
   field tta6ppptrp0701_qty_cust_consign like in_qty_oh
   index index1 tta6ppptrp0701_part .
/* SS - 20061103 - E */
