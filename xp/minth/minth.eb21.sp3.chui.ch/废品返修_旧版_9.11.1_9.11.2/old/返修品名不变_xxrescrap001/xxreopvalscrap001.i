/* reopval.i - VALIDATE OPERATION FOR ROUTING EXISTS                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.1.4 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3              CREATED: 02/14/96  by: jym  *G1M9*              */
/* REVISION: 8.6        LAST MODIFIED: 05/20/98  by: *K1Q4* Alfred Tan        */
/* REVISION: 9.1        LAST MODIFIED: 08/12/00  by: *N0KP* Mark Brown        */
/* Revision: 1.3.1.2  BY: Jean Miller DATE: 04/09/02 ECO: *P058* */
/* $Revision: 1.3.1.4 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* USE OF ROUTING VALIDATION ROUTING:
* EX: {reopval.i &part = part
*                &routing = routing
*                &op = op
*                &date = eff_date
*                &prompt = op
*                &frame = "a"
*                &leave = ""no""
*                &loop = "mainloop"
*      }
*      &part = part number
*      &routing = routing code
*      &op = operation code
*      &date = effective date of transaction
*      &prompt = the actual field name of the variable for the operation code
*      &frame = the frame in which the operation code is entered
*      &leave = enter "no" if opeartion code is entered in the curent program
*               enter "yes" if operation code is entered in a calling program
*      &loop = loop label where opeartion code is entered
*/

if {&routing} > "" then
find ro_det  where ro_det.ro_domain = global_domain and (
     ro_routing = {&routing} and
     ro_op      = {&op} and
    (ro_start = ? or ro_start  <= {&date}) and
    (ro_end = ? or ro_end    >= {&date})
) no-lock no-error.

else
find ro_det  where ro_det.ro_domain = global_domain and (
     ro_routing = {&part} and
     ro_op      = {&op} and
    (ro_start = ? or ro_start  <= {&date}) and
    (ro_end = ? or ro_end    >= {&date})
) no-lock no-error.

/* PROCESS VALIDATION RESULTS */
if not available ro_det then do:

   if {&routing} > "" then
   find first ro_det  where ro_det.ro_domain = global_domain and (
              ro_routing = {&routing} and
             (ro_start = ? or ro_start  <= {&date}) and
             (ro_end = ? or ro_end    >= {&date})
   ) no-lock no-error.

   else
   find first ro_det  where ro_det.ro_domain = global_domain and (
              ro_routing = {&part} and
             (ro_start = ? or ro_start  <= {&date}) and
             (ro_end = ? or ro_end    >= {&date})
   ) no-lock no-error.

   if not available ro_det then do:
      /* ROUTING DOES NOT EXIST */
      {pxmsg.i &MSGNUM=126 &ERRORLEVEL=3}
   end.

   else do:
      /* OPERATION IS NOT VALID */
      {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3}
   end.

   /* PROCEED TO SPECIFIED FIELD */
   if available ro_det then
/*tx01*  next-prompt {&prompt} with frame {&frame}.  */
/*tx01*/  next-prompt v_part with frame a. 
/*tx01*/  undo, retry.

/*** tx01****
   if {&leave} = "no" then
      undo, retry.
   else
      undo {&loop}, leave {&loop}.
*** tx01****/
end.
