/* GUI CONVERTED from icshhdr.p (converter v1.71) Sun Mar 26 22:58:00 2000 */
/* icshhdr.p - Multi-Transaction Shipper Additional Header Info Maintenance  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Maintenance                                                 */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 03/08/2000 BY: *K25K* Kedar Deherkar    */
         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE icshhdr_p_1 "多个"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshhdr_p_2 "运输方式"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshhdr_p_3 "说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshhdr_p_4 "承运人发货参考"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshhdr_p_5 "车辆标志"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         /* PARAMETERS */
         define input  parameter i_recid   as recid   no-undo.
         define output parameter o_deleted as logical no-undo.

         /* SHARED VARIABLES */
         define new shared variable cmtindx like cmt_indx.

         /* LOCAL VARIABLES */
         define variable v_carrier     like absc_carrier                no-undo.
         define variable v_multi       like mfc_logical
                                       label {&icshhdr_p_1}                    no-undo.
         define variable v_format      like abs_format                  no-undo.
         define variable v_shipvia     like so_shipvia                  no-undo.
         define variable v_cons_ship   like sgad_cons_ship format "x(8)"
                                                                        no-undo.
         define variable v_fob         like so_fob                      no-undo.
         define variable v_trans_mode  as   character      format "x(20)"
                                       label {&icshhdr_p_2}        no-undo.
         define variable v_carr_ref    as   character      format "x(20)"
                                       label {&icshhdr_p_4}     no-undo.
         define variable v_veh_ref     as   character      format "x(20)"
                                       label {&icshhdr_p_5}               no-undo.
         define variable v_cmmts       like mfc_logical
                                       label {&icshhdr_p_3}                 no-undo.
         define variable v_old_carrier like absc_carrier                no-undo.
         define variable v_old_formcd  like df_form_code                no-undo.
         define variable v_seq         like absc_seq                    no-undo.
         define variable v_dummy       as   character                   no-undo.
         define variable v_cont        like mfc_logical                 no-undo.
/*K08N*/ define variable h_nrm         as   handle                      no-undo.
/*K08N*/ define variable v_exists      as   logical                     no-undo.
/*K08N*/ define variable v_discard_ok  as   logical                     no-undo.
/*K08N*/ define variable v_err         as   logical                     no-undo.
/*K08N*/ define variable v_errnum      as   integer                     no-undo.
/*K08N*/ define variable v_msgnum      as   integer                     no-undo.
  DEFINE VAR xxid LIKE ABS_mstr.ABS_id.
         /* BUFFERS */
/*K08N*/ define buffer b_abs_mstr for abs_mstr.

         /* FRAMES */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
v_carrier      colon 25
            v_multi        colon 42
            v_format       colon 68
            v_shipvia      colon 25
            v_cons_ship    colon 68 format "x(8)"
            v_fob          colon 25
            abs_lang       colon 68
            v_trans_mode   colon 25
            v_carr_ref     colon 25
            v_veh_ref      colon 25
            v_cmmts        colon 68
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




         /* MAIN PROCEDURE BODY */


         /* Read the shipper record */
         find abs_mstr exclusive-lock where recid(abs_mstr) eq i_recid no-error.
         if not available abs_mstr then return.
                 ELSE DO:
                     xxid = ABS_mstr.ABS_id.
                     FIND FIRST abs_mstr WHERE abs_mstr.ABS_par_id = xxid NO-LOCK NO-ERROR.
        IF abs_mstr.ABS_loc = '8888'  THEN DO:
            MESSAGE "该货运单已发运!" VIEW-AS ALERT-BOX BUTTON OK. 
          
          LEAVE.
       
            END.
                     
                     
                     END.
                      /* Read the shipper record */
         find abs_mstr exclusive-lock where recid(abs_mstr) eq i_recid no-error.

         /* Read associated records */
         find first absc_det no-lock where absc_abs_id eq abs_id no-error.
         find df_mstr no-lock where
            df_type   eq "1" and
            df_format eq abs_format
            no-error.

         /* Load data, including packed fields */
         assign
            v_old_carrier = if available absc_det then absc_carrier else ""
            v_old_formcd  = if available df_mstr then df_form_code else ""
            v_carrier     = v_old_carrier
            v_multi       =
               /* Check for multiple carrier details */
               available absc_det and
               not can-find (absc_det where absc_abs_id eq abs_id)
            v_format      = abs_format
            v_shipvia     = substring(abs__qad01,1,20)
            v_fob         = substring(abs__qad01,21,20)
            v_carr_ref    = substring(abs__qad01,41,20)
            v_trans_mode  = substring(abs__qad01,61,20)
            v_veh_ref     = substring(abs__qad01,81,20)
            v_cmmts       = abs_cmtindx ne 0.

         /* Get mnemonic for consolidation flag */
         {gplngn2a.i
            &file     = ""sgad_det""
            &field    = ""sgad_cons_ship""
            &code     = abs_cons_ship
            &mnemonic = v_cons_ship
            &label    = v_dummy }

         /* Display screen values */
         display
            v_carrier
            v_multi
            v_format
            v_shipvia
            v_cons_ship
            v_fob
            abs_lang
            v_trans_mode
            v_carr_ref
            v_veh_ref
            v_cmmts
         with frame a.

         /* Get shipping information */
         main_blk:
         repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


            set
               v_carrier when
                  (can-find (absc_det where absc_abs_id eq abs_id) or
                  not can-find (first absc_det where absc_abs_id eq abs_id))
                  /* Allow update unless multiple carrier details exist */
               v_multi
               v_shipvia
               v_fob
               v_trans_mode
               v_carr_ref
               v_veh_ref
               v_format
               v_cons_ship
               abs_lang
               v_cmmts
/*K08N*/       go-on(F5 CTRL-D)
            editing:

               /* Carrier address field */
               if frame-field eq "v_carrier" then do:
                  {mfnp05.i
                     ad_mstr
                     ad_addr
                     "(ad_type eq 'carrier' or
                       can-find
                          (ls_mstr where
                             ls_type eq 'carrier' and ls_addr eq ad_addr))"
                     ad_addr
                     "input v_carrier" }
                  if recno ne ? then display ad_addr @ v_carrier.
               end.  /* if frame-field eq "v_carrier" */

               /* Document format field */
               else if frame-field eq "v_format" then do:
                  {mfnp05.i
                     df_mstr
                     df_format
                     "(df_type eq '1')"
                     df_format
                     "input v_format" }
                  if recno ne ? then display df_format @ v_format.
               end.  /* else if frame-field eq "v_format" */

               /* Consolidation flag field */
               else if frame-field eq "v_cons_ship" then do:
                  {mfnp05.i
                     lngd_det
                     lngd_trans
                     "(lngd_dataset eq 'sgad_det' and
                       lngd_field   eq 'sgad_cons_ship' and
                       lngd_lang    eq global_user_lang)"
                     lngd_key2
                     "input v_cons_ship" }
                  if recno ne ? then display lngd_key2 @ v_cons_ship.
               end.  /* else if frame-field eq "v_cons_ship" */

               /* Language code field */
               else if frame-field eq "abs_lang" then do:
                  {mfnp05.i
                     lng_mstr
                     lng_lang
                     "true"
                     lng_lang
                     "input abs_lang" }
                  if recno ne ? then display lng_lang @ abs_lang.
               end.  /* else if frame-field eq "abs_lang" */

               /* Any other field */
               else do:
/*K08N*           ststatus = stline[3].  *K08N*/
/*K08N*/          ststatus = stline[2].
                  status input ststatus.
                  readkey.
                  apply lastkey.
               end.  /* else */

            end.  /* editing */

/*K08N*/    if lastkey eq keycode("F5") or lastkey eq keycode("CTRL-D") then do:

/*K08N*/       /* Check whether shipper has children */
/*K08N*/       for first b_abs_mstr no-lock where
/*K08N*/          abs_shipfrom eq abs_mstr.abs_shipfrom and
/*K08N*/          abs_par_id   eq abs_mstr.abs_id:
/*K08N*/          {mfmsg.i 5940 3}
/*K08N*/          /* Cannot delete. Shipper has lines/containers */
/*K08N*/          undo main_blk, retry main_blk.
/*K08N*/       end.  /* for first b_abs_mstr */

/*K08N*/       v_discard_ok = true.

/*K08N*/       /* Start NRM services */
/*K08N*/       {gprun.i ""nrm.p"" " " "persistent set h_nrm"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*K08N*/       /* Check whether discard of shipper number is allowed */
/*K08N*/       v_msgnum = 5946.
/*K08N*/       run nr_exists in h_nrm (abs_nr_id, output v_exists).
/*K08N*/       if v_exists then do:
/*K08N*/          run nr_can_discard in h_nrm (abs_nr_id, output v_discard_ok).
/*K08N*/          run nr_check_error in h_nrm (output v_err, output v_errnum).
/*K08N*/          if v_err then v_discard_ok = false.
/*K08N*/       end.  /* if v_exists */

/*K08N*/       /* Check whether discard of preshipper number is allowed */
/*K08N*/       if v_discard_ok then do:
/*K08N*/          v_msgnum = 5944.
/*K08N*/          run nr_exists in h_nrm (abs_preship_nr_id, output v_exists).
/*K08N*/          if v_exists then do:
/*K08N*/             run nr_can_discard in h_nrm
/*K08N*/                (abs_preship_nr_id, output v_discard_ok).
/*K08N*/             run nr_check_error in h_nrm
/*K08N*/                (output v_err, output v_errnum).
/*K08N*/             if v_err then v_discard_ok = false.
/*K08N*/          end.  /* if v_exists */
/*K08N*/       end.  /* if v_discard_ok */

/*K08N*/       /* End NRM services */
/*K08N*/       delete procedure h_nrm.

/*K08N*/       if not v_discard_ok then do:
/*K08N*/          {mfmsg.i v_msgnum 4}
/*K08N*/          /* Del prohibited, gaps in (pre-)shipper seq not permitted */
/*K08N*/          undo main_blk, retry main_blk.
/*K08N*/       end.  /* if not v_discard_ok */

/*K08N*/       v_cont = true.
/*K08N*/       {mfmsg01.i 11 1 v_cont}  /* Please confirm delete */

/*K08N*/       if not v_cont then undo main_blk, retry main_blk.

/*K08N*/       /* Delete comments */
/*K08N*/       for each cmt_det exclusive-lock where cmt_indx eq abs_cmtindx:
/*K08N*/          delete cmt_det.
/*K08N*/       end.  /* for each cmt_det */

/*K08N*/       /* Delete trailer comments */
/*K08N*/       for each cmt_det exclusive-lock where
/*K08N*/          cmt_indx eq abs_trl_cmtindx:
/*K08N*/          delete cmt_det.
/*K08N*/       end.  /* for each cmt_det */

/*K08N*/       /* Delete carriers */
/*K08N*/       for each absc_det exclusive-lock where absc_abs_id eq abs_id:
/*K08N*/          delete absc_det.
/*K08N*/       end.  /* for first abs_mstr */

/*K08N*/       /* Delete additional shipper info using form services */
/*K08N*/       {gprun.i  ""sofsde.p""  "(recid(abs_mstr))" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*K08N*/       /* Delete the shipper */
/*K08N*/       delete abs_mstr.

/*K08N*/       o_deleted = true.

/*K08N*/       leave main_blk.

/*K08N*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* if lastkey */

            /* Validate carrier */
            if (can-find (absc_det where absc_abs_id eq abs_id) or
                not can-find (first absc_det where absc_abs_id eq abs_id)) and
               v_carrier ne ""
               then do:

               if not can-find (ad_mstr where ad_addr eq v_carrier) then do:
                  {mfmsg.i 980 3}
                  /* Address does not exist */
                  next-prompt v_carrier.
                  undo main_blk, retry main_blk.
               end.  /* if not can-find */

               if not can-find
                  (ls_mstr where
                     ls_addr eq v_carrier and
                     ls_type eq "carrier" )
                  then do:
                  {mfmsg.i 5905 3}
                  /* Address is not of type "carrier" */
                  next-prompt v_carrier.
                  undo main_blk, retry main_blk.
               end. /* if not can-find */

            end.  /* if can-find */

            /* Validate shipvia */
            if not ({gpcode.v v_shipvia abs_shipvia}) then do:
               {mfmsg.i 716 3}
               /* Value must exist in generalized codes */
               next-prompt v_shipvia.
               undo main_blk, retry main_blk.
            end.  /* if not */

            /* Validate FOB */
            if not ({gpcode.v v_fob abs_fob}) then do:
               {mfmsg.i 716 3}
               /* Value must exist in generalized codes */
               next-prompt v_fob.
               undo main_blk, retry main_blk.
            end.  /* if not */

            /* Validate document format */
            if v_format ne "" then do:

               /* Validate that format exists */
               find df_mstr no-lock where
                  df_type   eq "1" and
                  df_format eq v_format
                  no-error.
               if not available df_mstr then do:
                  {mfmsg.i 5900 3}
                  /* Document format not found */
                  next-prompt v_format.
                  undo main_blk, retry main_blk.
               end.  /* if not available */

/*K08N*/       /* Validate that invoice format can be used */
/*K08N*/       else if df_inv and abs_type eq "s"   and
/*K08N*/          length (substring(abs_id,2)) gt 8 and
/*K08N*/          (can-find
/*K08N*/             (im_mstr where
/*K08N*/                im_inv_mov eq abs_inv_mov and
/*K08N*/                im_tr_type eq "ISS-SO") or
/*K08N*/           abs_inv_mov eq "") then do:
/*K08N*/          {mfmsg.i 5982 3}
/*K08N*/          /* Shipper number too long to use shipper doc as invoice */
/*K08N*/          next-prompt v_format.
/*K08N*/          undo main_blk, retry main_blk.
/*K08N*/       end.  /* else if df_inv */

            end.  /* if v_format */

            /* Validate consolidation flag */
            if global_lngd_raw then
               find first lngd_det no-lock where
                  lngd_dataset eq "sgad_det"       and
                  lngd_key1    begins v_cons_ship  and
                  lngd_key2    ne ""               and
                  lngd_key3    eq ""               and
                  lngd_key4    eq ""               and
                  lngd_field   eq "sgad_cons_ship" and
                  lngd_lang    eq global_user_lang
                  no-error.
            else
               find first lngd_det no-lock where
                  lngd_dataset eq "sgad_det"       and
                  lngd_key1    ne ""               and
                  lngd_key2    begins v_cons_ship  and
                  lngd_key3    eq ""               and
                  lngd_key4    eq ""               and
                  lngd_field   eq "sgad_cons_ship" and
                  lngd_lang    eq global_user_lang
                  no-error.
            if not available lngd_det then do:
               {mfmsg.i 712 3}
               /* Invalid option */
               next-prompt v_cons_ship.
               undo main_blk, retry main_blk.
            end.  /* if not available */

            /* Redisplay consolidation flag */
            else do:
               assign
                  v_cons_ship   = lngd_key2
                  abs_cons_ship = lngd_key1.
               display v_cons_ship.
            end.  /* else */

/*K25K*/    for first ad_mstr
/*K25K*/       fields(ad_addr ad_lang ad_type)
/*K25K*/       where ad_addr = abs_shipto no-lock:
/*K25K*/    end. /* FOR FIRST AD_MSTR */

/*K25K*/    if not available ad_mstr or
/*K25K*/       abs_lang <> ad_lang then
/*K25K*/    do:
               /* Validate language code */
               if not can-find (lng_mstr where lng_lang eq abs_lang) then do:
                  {mfmsg.i 5050 3}  /* Language must exist */
                  next-prompt abs_lang.
                  undo main_blk, retry main_blk.
               end.  /* if not can-find */
/*K25K*/    end. /* IF NOT AVAIL AD_MSTR */

            /* Warn about changing format... */
            if v_format ne abs_format then do:

               /* ... if shipper already printed... */
               if substring(abs_status,1,1) eq "y" then do:
                  v_cont = false.
                  {mfmsg01.i 5803 2 v_cont}
                  /* Shipper has already been printed.  Continue? */
                  if not v_cont then do:
                     next-prompt v_format.
                     undo main_blk, retry main_blk.
                  end.  /* if not v_cont */
               end.  /* if substring */

               /* ... or if combined shipper/invoice format selected */
               if available df_mstr and df_inv then do:
                  v_cont = false.
                  {mfmsg01.i 5808 2 v_cont}
                  /* Combined shipper/invoice format selected.  Continue? */
                  if not v_cont then do:
                     next-prompt v_format.
                     undo main_blk, retry main_blk.
                  end.  /* if not v_cont */
               end.  /* if available */

            end.  /* if v_format */

/*K08N*/    /* Warn about blank format */
/*K08N*/    if v_format eq "" then do:
/*K08N*/       {mfmsg.i 5817 2}
/*K08N*/       /* Format is blank, document will not be printed */
/*K08N*/    end.  /* if v_format */

            /* Delete format-specific data if form code of format changes */
            if v_format ne abs_format and
               (not available df_mstr or
                df_form_code ne v_old_formcd) then do:
               {gprun.i ""sofsde.p"" "(i_recid)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end.  /* if v_format */

            /* Pack screen values to be saved */
            assign
               abs_format = v_format
               substring(abs__qad01, 1,20) = string(v_shipvia   ,"x(20)")
               substring(abs__qad01,21,20) = string(v_fob       ,"x(20)")
               substring(abs__qad01,41,20) = string(v_carr_ref  ,"x(20)")
               substring(abs__qad01,61,20) = string(v_trans_mode,"x(20)")
               substring(abs__qad01,81,20) = string(v_veh_ref   ,"x(20)").

            /* Process single carrier */
            if v_carrier ne v_old_carrier then do:
               find first absc_det exclusive-lock where
                  absc_abs_id  eq abs_id and
                  absc_carrier eq v_old_carrier
                  no-error.
               if available absc_det and v_carrier eq "" then delete absc_det.
               else if available absc_det then absc_carrier = v_carrier.
               else if v_carrier ne "" then do:
                  find last absc_det no-lock where
                     absc_abs_id eq abs_id
                     no-error.
                  v_seq = if available absc_det then absc_seq + 1 else 1.
                  create absc_det.
                  assign
                     absc_abs_id  = abs_id
                     absc_seq     = v_seq
                     absc_carrier = v_carrier.
                  if recid(absc_det) eq -1 then .
               end.  /* else if v_carrier */
            end.  /* if v_carrier */

            /* Make sure user has a chance to read messages */
            hide message.
            pause 0.

            /* Process auxilliary frames */

            /* Process multiple carriers */
            if v_multi then do:
               {gprun.i ""rcshwcar.p"" "(abs_id, 4)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.  /* if v_multi */

            /* Process comments */
            if v_cmmts then do:
               assign
                  cmtindx     = abs_cmtindx
                  global_ref  = abs_format
                  global_lang = abs_lang.
               {gprun.i ""gpcmmt01.p"" "('abs_mstr')"}
/*GUI*/ if global-beam-me-up then undo, leave.

               abs_cmtindx = cmtindx.
            end.  /* if v_cmmts */

            /* Gather additional header data per document format */
            {gprun.i ""sofsgh.p"" "(i_recid)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            leave main_blk.

         end.  /* main_blk */

         hide frame a no-pause.
         status input.


         /* END OF MAIN PROCEDURE BODY */
