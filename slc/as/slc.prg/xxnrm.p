/* nrm.p - NUMBER RANGE MANAGEMENT ENGINE                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.3 $                                                       */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 8.6      LAST MODIFIED: 04/30/96   BY: PCD *K002*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* $Revision: 1.7.1.3 $   BY: Jean Miller        DATE: 04/15/02  ECO: *P05H*  */
/* By: Neil Gao Date: 07/12/04 ECO: * ss 20071204 * */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
   DESCRIPTION:
   Number range management allows client programs to define and use
   sequences of numbers. A sequence is an implicit definition of a set
   of numbers. A sequence number is an element in the set.

   Sequences are implemented as compound data structures, together with
   a set of routines which perform the operations which are valid on
   such data. All manipulation of sequences must be done through the
   routines provided in this package.

   For further design information refer to the detailed design document
   for project F008-01 (Number Range Management).

   SYNOPSIS:

   define variable h-nrm as handle.
   run nrm.p persistent set h-nrm.

   <NRM CLIENT CALLS>

   delete program h-nrm.

   SEE ALSO:
   Projects: F008-02 (Daybooks), F007-01 (SIR).

*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ss 20071204 - b */
/*
{nrm.i}
*/
{xxnrm.i}
/* ss 20071204 - e */
