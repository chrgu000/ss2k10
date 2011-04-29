/* icunis.p - UNPLANNED ISSUE W/SERIAL NUMBERS                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 2.1     LAST MODIFIED: 10/01/87    BY: WUG       */
/* REVISION: 6.0     LAST MODIFIED: 08/01/91    BY: emb *D800*/
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*                */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99    BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9     BY: Jean Miller           DATE: 04/06/02  ECO: *P056*    */
/* Revision: 1.12    BY: Manjusha Inglay       DATE: 08/16/02  ECO: *N1QP*    */
/* $Revision: 1.13 $   BY: Dorota Hohol      DATE: 08/25/03 ECO: *P112* */
/*By: Neil Gao 09/03/17 ECO: *SS 20090317* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ICUNIS.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{&ICUNIS-P-TAG1}

define new shared variable transtype as character format "x(7)".

{gldydef.i new}
{gldynrm.i new}

transtype = "ISS-UNP".
/*SS 20090317 - B*/
/*
{gprun.i ""icintr.p""}
*/
{gprun.i ""xxicintr.p""}
/*SS 20090317 - E*/