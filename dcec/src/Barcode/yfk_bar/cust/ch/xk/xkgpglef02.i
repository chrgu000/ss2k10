/* GUI CONVERTED from gpglef02.i (converter v1.75) Tue Apr 10 12:01:23 2001 */
/* gpglef02.i -  CHECK EFFECTIVE DATE AGAINST GL CALENDAR                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.1.2 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4                CREATED: 04/20/95   by: wjk     *H0CS*        */
/* REVISION: 8.6          LAST MODIFIED: 05/20/98   by: *K1Q4* Alfred Tan     */
/* REVISION: 9.1          LAST MODIFIED: 08/14/00   by: *N0L1* Mark Brown     */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.3.1.2 $    BY: Katie Hilbert   DATE: 04/04/01 ECO: *P008*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******************************************************************************/

/*!
NAME

gpglef02.i - Verify open GL period for specified entity, effective date,
and module. Also direct calling program based on outcome.
*/

/*!
SYNOPSIS

include: gpglefdf.i

Parameters (all required except "loop"):
&module = Module type for GL calendar check.
&entity = Entity number for GL calendar check.
&date   = Effective date for GL calendar check.
&prompt = Field name for next-prompt statement.
&frame  = Frame name for next-prompt statement.
&loop   = Loop name for undo statement.

DESCRIPTION

Tests whether GL calendar period corresponding to a 'module / entity /
effective date' combination is open. Actual GL calendar test is performed
by the program gpglef.p.

Directs calling program control flow using next-prompt followed
by undo [label], retry. Also displays appripriate error messages.

EXAMPLE:

{gpglef02.i &module ="AP"
            &entity = ap_entity
            &date   = ap_effdate
            &prompt = "ap_entity"
            &frame  = "frame-a"
            &loop   = "loop-a"}

SEE ALSO: gpglefdf.i
          gpglef.p
          gpglef01.i

*/

/******************************************************************************/

/* COMPILE-TIME PARAMETER CHECK */
assign
   gl_trans_type = {&module}
   gl_trans_ent  = {&entity}
   gl_effdt_date = {&date}.

/* PERFORM THE TEST */
{gprun.i ""gpglef.p""
   "( input  gl_trans_type,
      input  gl_trans_ent,
      input  gl_effdt_date,
      input  1,
      output gpglef
    )" }
/*GUI*/ if global-beam-me-up then undo, leave.


/* DIRECT PARENT PROGRAM FLOW BASED ON OUTCOME */
if gpglef > 0 then do:
/*   next-prompt {&prompt} with frame {&frame}.
   undo {&loop}, retry. */
   undo, return. /*lb01*/
end.

/* EOF: gpglef02.i */
