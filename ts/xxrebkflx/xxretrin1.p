/* retrin1.p - REPETITIVE   TRANSACTION INPUT SUBPROGRAM                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.8 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 8.5      LAST MODIFIED: 05/01/96   BY: jym *G1MN*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.1.6  BY: Narathip W. DATE: 04/19/03 ECO: *P0Q7* */
/* $Revision: 1.5.1.8 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.5.1.8 $ BY: Mage Chen DATE: 06/28/06 ECO: *dak* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "RETRIN1.P"}

{gpglefv.i}

define output parameter undo_stat like mfc_logical no-undo.

{retrform.i}

undo_stat = yes.

find mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and  mfc_field =
"rpc_using_new" no-lock no-error.
if not available mfc_ctrl or mfc_logical = false then do:
   {pxmsg.i &MSGNUM=5119 &ERRORLEVEL=3}
   message.
   message.
   leave.
end.

display emp eff_date shift site with frame a.

seta:
do with frame a on error undo, retry:

   set emp with frame a
   editing:
      {mfnp05.i emp_mstr emp_addr  " emp_mstr.emp_domain = global_domain and
      yes "  emp_addr "input frame a emp"}

      if recno <> ? then do:
         display
            emp_addr @ emp
            emp_fname + " " + emp_lname @ ad_name.
      end.
   end.

   find emp_mstr  where emp_mstr.emp_domain = global_domain and  emp_addr = emp
   no-lock no-error.

   if not available emp_mstr then do:
      {pxmsg.i &MSGNUM=520 &ERRORLEVEL=3}
      undo , retry.
   end.

   if lookup(emp_status,"AC,PT") = 0 then do:
      {pxmsg.i &MSGNUM=4027 &ERRORLEVEL=3}
      undo , retry.
   end.

   display
      emp_addr @ emp
      emp_fname + " " + emp_lname @ ad_name.

   display eff_date shift.
   {&RETRIN1-P-TAG1}
/*dak* add**********************/
site = global_domain.
display site with frame a.
/*dak* add**********************/

   do with frame a on error undo , retry:
      set eff_date shift site with frame a
      editing:
         if frame-field = "site" then do:
            {mfnp05.i si_mstr si_site  " si_mstr.si_domain = global_domain and
            yes "  si_site
               "input frame a site"}

            if recno <> ? then do:
               display si_site @ site.
            end.
         end.
         else do:
            ststatus = stline[3].
            status input ststatus.
            readkey.
            apply lastkey.
         end.
      end.

      find si_mstr  where si_mstr.si_domain = global_domain and  si_site = site
      no-lock no-error.

      if not available si_mstr then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
         next-prompt site.
         undo , retry.
      end.

      {gprun.i ""gpsiver.p"" "(input site,
           input recid(si_mstr),
           output return_int)"
         }
      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         /* USER DOES NOT HAVE ACCESS TO SITE */
         next-prompt site.
         undo, retry.
      end.

      {gpglef1.i &module = ""IC""
         &entity = si_entity
         &date   = eff_date
         &prompt = "eff_date"
         &frame  = "a"
         &loop   = "seta"}

   end.

   undo_stat = no.
end.
