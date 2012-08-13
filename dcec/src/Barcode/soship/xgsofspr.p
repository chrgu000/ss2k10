/* sofspr.p - SO SHIPPER FORM SERVICE - PRINT                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Report                                                      */
/*K1Q4*/ /*V8:WebEnabled=No                                                  */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/15/97   BY: *K08N* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 06/20/97   BY: *H19N* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6      LAST MODIFIED: 07/20/98   BY: *H1MC* Manish K.         */
/* REVISION: 8.6      LAST MODIFIED: 08/05/98   BY: *J2VP* Manish K.         */

         /* Invoke the shipper form service to print a given */
         /* shipper, based on the shipper's document format */

         {mfdeclre.i}

         /* INPUT PARAMETERS */
         define input parameter i_recid         as recid   no-undo.

/*H1MC* **BEGIN DELETE**
 *       define input parameter i_ship_comments as logical no-undo.
 *       define input parameter i_pack_comments as logical no-undo.
 *       define input parameter i_features      as logical no-undo.
 * /*H19N*/ define input parameter i_print_sodet as logical no-undo.
 *H1MC* **END DELETE** */

/*H1MC*/ define input parameter i_ship_comments like mfc_logical no-undo.
/*H1MC*/ define input parameter i_pack_comments like mfc_logical no-undo.
/*H1MC*/ define input parameter i_features      like mfc_logical no-undo.
/*H1MC*/ define input parameter i_print_sodet   like mfc_logical no-undo.
/*J2VP*/ define input parameter i_so_um         like mfc_logical no-undo.
/*Jane*/ define input parameter i_addr          like ad_addr     no-undo.

         /* LOCAL VARIABLES */
         define variable v_svc_used as   logical    no-undo.
         define variable form_code  as   character  no-undo.
         define variable run_file   as   character  no-undo.
         define variable h_form_svc as   handle     no-undo.
/*K08N*/ define variable v_tr_type  like im_tr_type no-undo.
         /* MAIN PROCEDURE BODY */


         /* Get the shipper */
         find abs_mstr no-lock where recid(abs_mstr) eq i_recid no-error.
         if not available abs_mstr then return.
         /***Jane Wang**
/*K04X*/ if abs_format eq "" then return. ****/

         /* Get shipper's transaction type */
/*K08N*/ {gprun.i ""icshtyp.p"" "(i_recid, output v_tr_type)" }

         /* Get shipper's document format */
         find df_mstr no-lock where
/*K04X*/    df_type eq "1" and
            df_format eq abs_format no-error.
         assign
            form_code   = if available df_mstr then df_form_code else "01"
            v_svc_used  = false.

         /* Build run_file from form_code */
         {gprfile.i}

         /* Try to run routine encapsulating shipper form print service */
/*yf         if search
               (global_user_lang_dir + "xx/xxsofmsv" + run_file + ".r") ne ? or
/*K08N*/    search
/*K08N*/       (global_user_lang_dir + "xx/xxsofmsv" + run_file + ".p") ne ?
            then do:
            {gprun.i
               "'xxsofmsv' + run_file + '.p'"
               " "
               "persistent set h_form_svc" }

            if lookup ("xxsh_print",h_form_svc:INTERNAL-ENTRIES) gt 0 then do:

/*H19N**               run sh_print
 *                in h_form_svc
 *                (i_recid, i_ship_comments, i_pack_comments, i_features).
 *H19N**/

/*J2VP*/ /* ADDED INPUT PARAMETER I_SO_UM */
/*H19N*/        run xxsh_print
                in h_form_svc
                (i_recid, i_ship_comments, i_pack_comments, i_features,
                 i_print_sodet, i_so_um ).

               v_svc_used = true.
            end.  /* if lookup */

            delete procedure h_form_svc.

         end.  /* if search */ end*/   
/*Jane Wang marked on 08/19/2005******
         {gprun.i ""xxsofmsv02.p"" "(input i_recid,
                                     INPUT i_ship_comments, 
              INPUT i_pack_comments,
             INPUT i_features, INPUT i_print_sodet,INPUT i_so_um)"}
 ***********************/
	 /* If form service not used, then try standard print routine */
         if not v_svc_used        and
/*K08N*/    v_tr_type eq "ISS-SO" and
            search
               (global_user_lang_dir + "xg/xgrcrp13" + run_file + ".r") ne ? or
/*K08N*/    search
/*K08N*/       (global_user_lang_dir + "xg/xgrcrp13" + run_file + ".p") ne ?
            then do:
           {gprun.i
              "'xgrcrp13' + run_file + '.p'"   
              "(i_recid, i_ship_comments, i_pack_comments, i_features, i_print_sodet, i_so_um, i_addr)" }
                   
         end.  /* if not v_svc_used */


         /* Dummy runs for BOMs, etc. */
         if false then do:
            {gprun.i ""rcrp1301.p""}
            {gprun.i ""xgsofmsv01.p""}
         end.


         /* END OF MAIN PROCEDURE BODY */
