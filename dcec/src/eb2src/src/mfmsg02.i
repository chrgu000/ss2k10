/* GUI CONVERTED from mfmsg02.i (converter v1.75) Mon Aug 21 12:13:23 2000 */
/* mfmsg02.i - -- INCLUDE FILE FOR CONCATENATED VARIABLES               */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 1.0      LAST MODIFIED: 05/07/86   BY: PML */
/* REVISION: 6.0      LAST MODIFIED: 05/31/90   BY: RAM */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: WUG *D054*/
/* Revision: 7.0      Last Modified: 04/25/92   By: jcd *F402**/
/* Revision: 7.3      Last Modified: 11/25/92   By: rwl *G360**/
/* Revision: 7.3      Last Modified: 03/07/95   By: jzs *G0FB**/
/* Revision: 8.6      Last Modified: 09/19/97   By: das *K0J0**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* Revision: 8.6E     Last Modified: 03/11/98   By: *J2DD* Kawal Batra */
/* Revision: 8.6E     Last Modified: 10/04/98   By: *J314* Alfred Tan   */
/* Revision: 9.0      Last Modified: 11/04/98   By: *M018* D. Belbeck   */
/* Revision: 9.0      Last Modified: 03/13/99   By: *M0BD* Alfred Tan   */
/* Revision: 9.0      Last Modified: 02/01/00   By: *M0JF* Fred Yeadon  */
/* Revision: 9.1      Last Modified: 03/29/00   By: *N092* Murali Ayyagari */
/* Revision: 9.1      Last Modified: 08/17/00   By: *N0LJ* Mark Brown      */
/*************************************************************/
/***************************************************************************
 * NOTE: THIS INCLUDE FILE IS BEING OBSOLETED. IT HAS BEEN REPLACED BY
 * PXMSG.I. REPLACE CALLS AS FOLLOWS:
 *
 * replace:
 *    {mfmsg02.i MsgNum ErrorLevel MsgArg1}
 * with:
 *    {pxmsg.i &MSGNUM=MsgNum &ERRORLEVEL=ErrorLevel &MSGARG1=MsgArg1}
    Last change:  JYM  10 Aug 1999    2:04 pm
 **************************************************************************/
/*!
   {1} msg number
   {2} 1-normal  2-warning  3-error  4-error w/o "Please re-enter"
   {3} variable  to concat
*/
/*************************************************************/

&SCOPED-DEFINE VARSEQ {&SEQUENCE}

do:
   define variable mfmsg02_ia{&VARSEQ} as integer no-undo.
   define variable mfmsg02_ib{&VARSEQ} as integer no-undo.
   define variable mfmsg02_ic{&VARSEQ} as character no-undo.

   assign
      mfmsg02_ia{&VARSEQ} = integer({1})
      mfmsg02_ib{&VARSEQ} = integer({2})
      mfmsg02_ic{&VARSEQ} = string({3}).

   {pxmsg.i
      &MSGNUM=mfmsg02_ia{&VARSEQ}
      &ERRORLEVEL=mfmsg02_ib{&VARSEQ}
      &MSGARG1=mfmsg02_ic{&VARSEQ}
   }
end.
