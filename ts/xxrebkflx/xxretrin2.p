/* retrin2.p - REPETITIVE                                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 03/13/95   BY: PCD *G0H4*                */
/* REVISION: 7.3      LAST MODIFIED: 12/31/96   BY: *G2JT* Murli Shastri      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6      LAST MODIFIED: 09/15/99   BY: *K22X* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.9 $ BY: Mage Chen  DATE: 06/28/06 ECO: *dak* */
/*-Revision end---------------------------------------------------------------*/


/* TRANSACTION INPUT SUBPROGRAM                                               */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define output param undo_stat like mfc_logical no-undo.

/*N04H** {rewrsdef.i}                                                         */

 {retrform.i}

/*dak*/ define variable dakdesc1 like pt_desc1 .
define variable msg_type as integer.


undo_stat = yes.
/*dak add***************/
line = substring(emp, 1, 4).
op = 10.
display line op with frame a.
/*dak add*******************/
display part line with frame a.

main:
do with frame a on error undo, retry on endkey undo, leave:
   set part op line with frame a editing:
      if frame-field = "part" then do:
/*dak     {mfnp05.i pt_mstr pt_part  " pt_mstr.pt_domain = global_domain and yes "
     pt_part "input frame a part"} */
/*dak*/     {mfnp05.i lnd_det lnd_linepart  " lnd_det.lnd_domain = global_domain and lnd_det.lnd_line = line "
     lnd_part "input frame a part"}  
     if recno <> ? then do:
     
/*dak*/   display lnd_part @ part . 
          part = lnd_part.
           find first pt_mstr no-lock where pt_domain = global_domain and  pt_part = part no-error.
/*dak*/   if available pt_mstr then do:  dakdesc1 = pt_desc1 + pt_desc2 .
 /*dak*/       display pt_part @ part  dakdesc1 @ pt_desc1.

        find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
        ptp_part = pt_part
        and ptp_site = site no-error.

        if available ptp_det then do:

           if ptp_routing > ""
           then routing = ptp_routing.
           else routing = "".

           if ptp_bom_code > ""
           then bom_code = ptp_bom_code.
           else bom_code = "".
        end.
        else do:
           routing = if pt_routing > ""
           then pt_routing else "".

           if pt_bom_code > ""
           then bom_code = pt_bom_code.
           else bom_code = "".
        end.

        display routing bom_code.
     end.
/*dak*/     end. /*if available pt_mstr then do:*/

      end.

      else
      if frame-field = "op"
      and can-find(pt_mstr  where pt_mstr.pt_domain = global_domain and
      pt_part = input frame a part)
      then do:
     find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = input
     frame a part no-lock no-error.

     find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
     pt_part and ptp_site = site
     no-lock no-error.

     if available ptp_det then do:
        if ptp_routing > ""
        then routing = ptp_routing.
        else routing = ptp_part.
     end.
     else
     routing = if pt_routing > "" then pt_routing else pt_part.

/*K22X*/ /* ADDED SELECTION CRITERIA OF START DATE AND END DATE TO    */
/*K22X*/ /* THE THIRD PARAMETER SO THAT NON-EFFECTIVE OPRATIONS WILL  */
/*K22X*/ /* NOT BE DISPLAYED WHILE SCROLLING IN OPERATION FIELD       */

         {mfnp05.i ro_det ro_routing " ro_det.ro_domain = global_domain and
         ro_routing  = routing
                                      and
                                      ((ro_start <= eff_date or ro_start = ?)
                                       and
                                       (ro_end   >= eff_date or ro_end   = ?))"
          ro_op "input frame a op"}

     if recno <> ? then do:
        display ro_op @ op ro_desc @ wr_desc.
        display "" @ line "" @ ln_desc.
     end.
      end.

      else
      if frame-field = "line" then do:
     {mfnp05.i ln_mstr ln_line  " ln_mstr.ln_domain = global_domain and yes "
     ln_line "input frame a line"}

     if recno <> ? then do:
        display ln_line @ line ln_desc.
     end.
      end.

      else do:
     status input.
     readkey.
     apply lastkey.
      end.
   end.

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = part
   no-lock no-error.

   if not available pt_mstr then do:
      {mfmsg.i 16 3}
      undo, retry.
   end.

   display
   pt_desc1
   "" @ ln_desc.

   um = pt_um.
   conv = 1.

/*G0H4*/ /* Begin */

/*G2JT*/ find first ln_mstr  where ln_mstr.ln_domain = global_domain and
ln_site = site no-lock no-error.

/*G2JT*  BEGIN DELETE SECTION *
.         find ln_mstr where ln_site = site and ln_line = line
.     no-lock no-error.
.
.         find first lnd_det
.         where lnd_line = line
.         and lnd_site = site
.         and lnd_part = part
.         and (lnd_start <= today or lnd_start = ?)
.         no-lock no-error.
**G2JT*  END DELETE SECTION */

/*G2JT*  if line <> "" then do: */
/*G2JT*/ if available ln_mstr or line <> "" then do:

/*G2JT*/    find ln_mstr  where ln_mstr.ln_domain = global_domain and  ln_site
= site and ln_line = line
/*G2JT*/    no-lock no-error.

            if not available ln_mstr then do:
           {mfmsg.i 8526 3}
           next-prompt line.
           undo, retry.
            end.

/*G2JT*/    find  first lnd_det
/*G2JT*/     where lnd_det.lnd_domain = global_domain and (  lnd_line = line
/*G2JT*/    and   lnd_site = site
/*G2JT*/    and   lnd_part = part
/*G2JT*/    and   (lnd_start <= today or lnd_start = ?)
    ) no-lock no-error.

            if not available lnd_det then do:
           {mfmsg.i 8527 3}
           next-prompt line.
           undo , retry.
            end.

            display ln_desc.
         end.
/*G2JT*  BEGIN DELETE SECTION *
.         else if not (available ln_mstr and available lnd_det) then do:
.            find first lnd_det where lnd_site = site and lnd_part = part
.            no-lock no-error.
.
.            if available lnd_det then do:
.          {mfmsg.i 5107 3}
.          next-prompt line.
.          undo, retry.
.            end.
.         end.
**G2JT*  END DELETE SECTION */
/*G2JT*/ else display "" @ ln_desc.
/*G0H4*/ /* End */


/*G0H4*
 *
 *   if line <> "" then do:
 *      find ln_mstr where ln_site = site and ln_line = line no-lock no-error.
 *
 *      if not available ln_mstr then do:
 *   {mfmsg.i 8526 3}
 *   next-prompt line.
 *   undo, retry.
 *      end.
 *
 *      find first lnd_det
 *      where lnd_line = line
 *      and lnd_site = site
 *      and lnd_part = part
 *      and (lnd_start <= today or lnd_start = ?)
 *      no-lock no-error.
 *
 *      if not available lnd_det then do:
 *   {mfmsg.i 8527 3}
 *   next-prompt line.
 *   undo , retry.
 *      end.
 *
 *      display ln_desc.
 *   end.
 *   else do:
 *      find first lnd_det where lnd_site = site and lnd_part = part
 *      no-lock no-error.
 *
 *      if available lnd_det then do:
 *   {mfmsg.i 5107 3}
 *   next-prompt line.
 *   undo, retry.
 *      end.
 *   end.
 *
 *G0H4*/


   routing = "".
   bom_code = "".
   undo_stat = no.
   global_part = part.
end.
