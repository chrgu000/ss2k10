/* retrin3.p - REPETITIVE                                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.1.7 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 11/07/95   BY: jym *G1CH*                */
/* REVISION: 7.3      LAST MODIFIED: 01/22/96   BY: jym *G1G6*                */
/* REVISION: 7.3      LAST MODIFIED: 08/13/96   BY: *G29X* Julie Milligan     */
/* REVISION: 7.3      LAST MODIFIED: 01/07/97   BY: *G2JV* Julie Milligan     */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.3.1.5  BY: Sandeep Parab DATE: 04/04/02 ECO: *N1G1* */
/* $Revision: 1.3.1.7 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* DEFINE INPUT OUTPUT PARAMETER */
define output parameter undo_stat like mfc_logical no-undo.

/*tx01* {retrform.i} */
{xxretrforscrap001.i}

define variable msg_type       as   integer     no-undo.
define variable ok             like mfc_logical no-undo.
define variable prompt-routing like mfc_logical no-undo.

assign
   undo_stat   = yes
   global_part = part
   global_site = site.

for first pt_mstr
   fields( pt_domain pt_bom_code pt_routing)
    where pt_mstr.pt_domain = global_domain and  pt_part = part
   no-lock:
end. /* FOR FIRST pt_mstr */

/*GET THE DEFAULT BOM-CODE AND ROUTING CODE */
for first ptp_det
   fields( ptp_domain ptp_bom_code ptp_routing)
    where ptp_det.ptp_domain = global_domain and  ptp_part = part
   and   ptp_site = site
   no-lock:
   assign bom_code = ptp_bom_code
          routing  = ptp_routing.
end. /* FOR FIRST ptp_det */

if not available ptp_det
then
   assign
      bom_code = pt_bom_code
      routing  = pt_routing.

/* IF A REPETITIVE PRODUCTION SCHEDULE RECORD EXISTS AND */
/* AND THE BOM CODE OR ROUTING CODE IS NOT BLANK, THEN   */
/* USE THE NON BLANK CODES TO GET THE ROUTING & BOM CODE */
for first rps_mstr
   fields( rps_domain rps_routing rps_bom_code)
    where rps_mstr.rps_domain = global_domain and  rps_part     = part
   and   rps_site     = site
   and   rps_line     = line
   and   rps_due_date = eff_date
   no-lock:

   if rps_routing > ""
   then
      routing = rps_routing.
   if rps_bom_code > ""
   then
      bom_code = rps_bom_code.
end. /* FOR FIRST rps_mstr */

/*tx01*
display
   bom_code
   routing
with frame a.
do with frame a on error undo, retry on endkey undo, leave:

   set
      routing
      bom_code
   with frame a
   editing:

      global_loc = input frame a routing.

      if frame-field = "bom_code"
      then do:

         {mfnp05.i ptr_det ptr_part
            " ptr_det.ptr_domain = global_domain and ptr_part  = part and
            ptr_site = site
            and ptr_routing = input routing"
            ptr_bom_code "input bom_code"}

         if recno <> ?
         then do:
            display
               ptr_bom_code @ bom_code.
            recno = ?.
         end. /* IF recno <> ? */

      end. /* IF FRAME-FIELD = "bom_code" */

      else if frame-field = "routing"
      then do:

         {mfnp05.i ptr_det ptr_part
            " ptr_det.ptr_domain = global_domain and ptr_part  = part and
            ptr_site = site"
            ptr_routing "input routing"}

         if recno <> ?
         then do:
            display
               ptr_routing @ routing.
            recno = ?.
         end. /* IF recno <> ? */

      end. /* ELSE IF FRAME-FIELD = "routing" */

      else do:
         status input.
         readkey.
         apply lastkey.
      end. /* ELSE DO */

   end. /* EDITING */

   {gprun.i ""wortbmv.p""
      "(input  part,
        input  site,
        input  routing,
        input  bom_code,
        input  3,
        output ok,
        output prompt-routing)"}

   if  not ok
   and prompt-routing
   then
      next-prompt routing.
   else if not ok
   then
      next-prompt bom_code.

   if not ok
   then
      undo, retry.

   if  routing = ""
   and not can-find (first ro_det
                         where ro_det.ro_domain = global_domain and  ro_routing
                         = part)
   then do:
      next-prompt routing.
      /* ROUTING DOES NOT EXISTS */
      {pxmsg.i &MSGNUM=126
               &ERRORLEVEL=3}
      undo, retry.
   end. /* IF routing = "" */
tx01**/

   assign
      routing   = (if routing = ""
                   then part
                   else routing)
      bom_code  = (if bom_code = ""
                   then part
                   else bom_code)
/*tx01*
      undo_stat = no.

   display
      routing
      bom_code.

end. /* DO */
tx01***/