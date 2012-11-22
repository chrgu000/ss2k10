/* GUI CONVERTED from redflt.p (converter v1.78) Fri Oct 29 14:37:51 2004 */
/* redflt.p - REPETITIVE                                                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.1.4 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.3.1.4 $   BY: Jean Miller        DATE: 04/16/02  ECO: *P05H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* TRANSACTION SUBPROGRAM - GETS MOST RECENT OP_HIST RECORD CREATED
   and DISPLAYS DATA as initial DEFAULTS */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxretrform.i}

define variable ophist_recid as recid.
define variable i as integer.

do i = 1 to length(global_addr):
   if substring(global_addr,i,1) < "0" or substring(global_addr,i,1) > "9"
      then return.
end.

ophist_recid = integer(global_addr).

find op_hist where recid(op_hist) = ophist_recid no-lock no-error.

if available op_hist then do:

   assign
      emp   = op_emp
      site  = op_site
      shift = op_shift
      part  = op_part
      op    = op_wo_op
      line  = op_line.

   display
      emp
      site
      shift
      part
      op
      line
   with frame a.

end.
