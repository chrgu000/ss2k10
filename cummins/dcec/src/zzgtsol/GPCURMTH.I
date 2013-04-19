/* GUI CONVERTED from gpcurmth.i (converter v1.69) Fri Jul 19 10:51:36 1996 */
/* gpcurmth.i -  DETERMINE CURRENCY ROUNDING METHOD TO USE              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=ReportAndMaintenance                                   */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: taf *J0ZH*          */
/************************************************************************/
/*   {1}  =  the currency to compare / find                             */
/*   {2}  =  Message TYPE for mfmsg.i                                   */
/*   {3}  =  undo, retry, next or leave                                 */
/*   {4}  =  next-prompt statement, if not needed use pause 0. NOTE:    */
/*           it is also possible to use this to return a flag           */
/************************************************************************/

if {1} = gl_base_curr then
   rndmthd = gl_rnd_mthd.
else do:
   find first cu_mstr /*ex_mstr*/ where  cu_curr /*ex_curr*/ = {1} no-lock no-error.
   if not available cu_mstr /*ex_mstr*/ then do:
      /* CURRENCY EXCHANGE MASTER DOES NOT EXIST */
      {mfmsg.i 964 {2} }
    {4}.
    {3}.
   end.
   else
      rndmthd = cu_rnd_mthd /*ex_rnd_mthd*/.
end.
