/* glcbsrb5.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3            CREATED:  8/13/92   BY: mpp    *G030*             */
/* Revision: 8.5            Created: 03/24/97   By: *J241* Jagdish Suvarna    */
/* REVISION: 8.6E     LAST MODIFIED: APR 22 98  BY: LN/SVA *L00M*RO*          */
/* Revision: 8.6E     LAST MODIFIED: 10/04/98   By: *J314* Alfred Tan         */
/* Revision: 9.1      LAST MODIFIED: 08/14/00   By: *N0L1* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8  BY: Jean Miller DATE: 04/15/02 ECO: *P05H* */
/* $Revision: 1.10 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.9 $ BY: Bill Jiang DATE: 08/15/07 ECO: *SS - 20070815.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
 
/* SS - 20070815.1 - B */
{ssglcbsrp01.i}
/* SS - 20070815.1 - E */

{mfdeclre.i}

{glcbsrp3.i}

define input parameter sum_lev  as integer.
define input parameter sort_type as integer.

for first fm_mstr
fields( fm_domain fm_dr_cr fm_fpos)
   where recid(fm_mstr) = fm_recno
no-lock: end.

/* SS - 20070815.1 - B */
{ssglcbsrp01b.i &idx=asc_fasc
   &break1=asc_acc
   &test_field=asc_acc
   &test_field2=""""
   &comm1="/*"
   &xtype1=""""
   &xtype2=""""
   &xdesc=""""}
/* SS - 20070815.1 - E */