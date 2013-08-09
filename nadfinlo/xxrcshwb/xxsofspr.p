/* sofspr.p - SO SHIPPER FORM SERVICE - PRINT                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.6.2.4 $                                                         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/15/97   BY: *K08N* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 06/20/97   BY: *H19N* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6      LAST MODIFIED: 07/20/98   BY: *H1MC* Manish K.         */
/* REVISION: 8.6      LAST MODIFIED: 08/05/98   BY: *J2VP* Manish K.         */
/* REVISION: 9.1      LAST MODIFIED: 12/28/99   BY: *N05X* Surekha Joshi     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0W8* Mudit Mehta       */
/* $Revision: 1.6.2.4 $    BY: Nikita Joshi          DATE: 09/07/01  ECO: *M1JZ*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 05/03/04   BY: *nad001* Apple Tam        */

         /* Invoke the shipper form service to print a given */
         /* shipper, based on the shipper's document format */

{mfdeclre.i}
{cxcustom.i "SOFSPR.P"}

/* INPUT PARAMETERS */
define input parameter i_recid            as recid         no-undo.
define input parameter i_ship_comments    like mfc_logical no-undo.
define input parameter i_pack_comments    like mfc_logical no-undo.
define input parameter i_features         like mfc_logical no-undo.
define input parameter i_print_sodet      like mfc_logical no-undo.
define input parameter i_so_um            like mfc_logical no-undo.
define input parameter i_comp_addr        like ad_addr     no-undo.
define input parameter i_print_lotserials like mfc_logical no-undo.

/* LOCAL VARIABLES */
define variable v_svc_used as   logical    no-undo.
define variable form_code  as   character  no-undo.
define variable run_file   as   character  no-undo.
define variable h_form_svc as   handle     no-undo.
define variable v_tr_type  like im_tr_type no-undo.

/* MAIN PROCEDURE BODY */

/* Get the shipper */
for first abs_mstr
   fields(abs_format)
   where recid(abs_mstr) = i_recid
no-lock:
end. /* FOR FIRST abs_mstr */
if not available abs_mstr
then
   return.
if abs_format = ""
then
   return.

/* Get shipper's transaction type */
{gprun.i ""icshtyp.p""
   "(i_recid,
     output v_tr_type)" }

/* Get shipper's document format */
for first df_mstr
   fields(df_format df_form_code df_type)
   where df_type   = "1"
     and df_format = abs_format
no-lock:
end.
assign
   form_code   = if available df_mstr
                 then
                    df_form_code else "01"
   v_svc_used  = false.

/* Build run_file from form_code */
{gprfile.i}

/**nad001*************** delete ***********************************
/* Try to run routine encapsulating shipper form print service */
if search
   (global_user_lang_dir
   + "so/sofmsv"
   + run_file + ".r") <> ?
   or
   search
   (global_user_lang_dir
   + "so/sofmsv"
   + run_file + ".p") <> ?
then do:
   {gprun.i
      "'sofmsv' + run_file + '.p'"
      " "
      "persistent set h_form_svc" }

   if lookup ("sh_print",h_form_svc:INTERNAL-ENTRIES) > 0
   then do:
      run sh_print
         in h_form_svc
         (i_recid,
          i_ship_comments,
          i_pack_comments,
          i_features,
          i_print_sodet,
          i_so_um,
          i_comp_addr,
          i_print_lotserials).

      v_svc_used = true.
   end.  /* if lookup */

   delete PROCEDURE h_form_svc.

end.  /* if search */

/* If form service not used, then try standard print routine */
{&SOFSPR-P-TAG1}
if not v_svc_used
   and v_tr_type = "ISS-SO"
   and search
   (global_user_lang_dir + "rc/rcrp13" + run_file + ".r") <> ?
   or search
   (global_user_lang_dir + "rc/rcrp13" + run_file + ".p") <> ?
then do:
   {&SOFSPR-P-TAG2}
   {gprun.i
      "'rcrp13' + run_file + '.p'"
      "(i_recid, i_ship_comments, i_pack_comments, i_features,
        i_print_sodet, i_so_um, i_comp_addr)" }

end.  /* if not v_svc_used */

/* Dummy runs for BOMs, etc. */
if false
then do:
   {gprun.i ""rcrp1301.p""}
   {gprun.i ""sofmsv01.p""}
end.

/* END OF MAIN PROCEDURE BODY */
**nad001*************** delete ***********************************/

/**nad001 add*********************************************************/
/* Try to run routine encapsulating shipper form print service */
if search
   (global_user_lang_dir
   + "xx/xxsofmsv"
   + run_file + ".r") <> ?
   or
   search
   (global_user_lang_dir
   + "xx/xxsofmsv"
   + run_file + ".p") <> ?
then do:
   {gprun.i
      "'xxsofmsv' + run_file + '.p'"
      " "
      "persistent set h_form_svc" }

   if lookup ("sh_print",h_form_svc:INTERNAL-ENTRIES) > 0
   then do:
      run sh_print
         in h_form_svc
         (i_recid,
          i_ship_comments,
          i_pack_comments,
          i_features,
          i_print_sodet,
          i_so_um,
          i_comp_addr,
          i_print_lotserials).

      v_svc_used = true.
   end.  /* if lookup */

   delete PROCEDURE h_form_svc.

end.  /* if search */

/* If form service not used, then try standard print routine */
{&SOFSPR-P-TAG1}
if not v_svc_used
   and v_tr_type = "ISS-SO"
   and search
   (global_user_lang_dir + "xx/xxrcrp13" + run_file + ".r") <> ?
   or search
   (global_user_lang_dir + "xx/xxrcrp13" + run_file + ".p") <> ?
then do:
   {&SOFSPR-P-TAG2}
   {gprun.i
      "'xxrcrp13' + run_file + '.p'"
      "(i_recid, i_ship_comments, i_pack_comments, i_features,
        i_print_sodet, i_so_um, i_comp_addr)" }

end.  /* if not v_svc_used */

/* Dummy runs for BOMs, etc. */
if false
then do:
   {gprun.i ""xxrcrp1301.p""}
   {gprun.i ""xxsofmsv01.p""}
end.
/***********************************************************/