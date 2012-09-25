/* GUI CONVERTED from icshhdr.p (converter v1.77) Mon Dec  1 04:06:27 2003 */
/* icshhdr.p - Multi-Transaction Shipper Additional Header Info Maintenance  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.22 $                                                              */
/*                                                                           */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 03/08/2000 BY: *K25K* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KS* myb                  */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00 BY: *N0W6* Mudit Mehta          */
/* Revision: 1.11      BY: Ellen Borden    DATE: 07/09/01    ECO: *P007*      */
/* Revision: 1.12      BY: Veena Lad       DATE: 12/24/01    ECO: *P03W*      */
/* Revision: 1.13      BY: Rajaneesh S.    DATE: 03/08/02    ECO: *N1CC*      */
/* Revision: 1.18      BY: Samir Bavkar    DATE: 08/15/02    ECO: *P09K*      */
/* $Revision: 1.22 $ BY: Mike Dempsey         DATE: 11/27/03  ECO: *N2GM* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                 */

{mfdeclre.i}
{cxcustom.i "ICSHHDR.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE icshhdr_p_1 "Multi"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshhdr_p_2 "Mode of Transport"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshhdr_p_3 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshhdr_p_4 "Carrier Shipment Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshhdr_p_5 "Vehicle ID"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* PARAMETERS */
define input  parameter i_recid   as recid   no-undo.
define output parameter o_deleted as logical no-undo.

/* SHARED VARIABLES */
define new shared variable cmtindx like cmt_indx.

/* LOCAL VARIABLES */
define variable v_carrier     like absc_carrier                     no-undo.
define variable v_multi       like mfc_logical
                              label {&icshhdr_p_1}                  no-undo.
define variable v_format      like abs_format                       no-undo.
define variable abs_shipvia   like so_shipvia                       no-undo.
define variable v_cons_ship   like sgad_cons_ship format "x(8)"     no-undo.
define variable v_fob         like so_fob                           no-undo.
define variable v_trans_mode  as   character      format "x(20)"
                              label {&icshhdr_p_2}                  no-undo.
define variable v_carr_ref    as   character      format "x(20)"
                              label {&icshhdr_p_4}                  no-undo.
define variable v_veh_ref     as   character      format "x(20)"
                              label {&icshhdr_p_5}                  no-undo.
define variable v_cmmts       like mfc_logical
                              label {&icshhdr_p_3}                  no-undo.
define variable v_old_carrier like absc_carrier                     no-undo.
define variable v_old_formcd  like df_form_code                     no-undo.
define variable v_seq         like absc_seq                         no-undo.
define variable v_dummy       as   character                        no-undo.
define variable v_cont        like mfc_logical                      no-undo.
define variable h_nrm         as   handle                           no-undo.
define variable v_exists      as   logical                          no-undo.
define variable v_discard_ok  as   logical                          no-undo.
define variable v_err         as   logical                          no-undo.
define variable v_errnum      as   integer                          no-undo.
define variable v_msgnum      as   integer                          no-undo.
define variable last_field    as   character                        no-undo.
define variable use-log-acctg as   logical                          no-undo.

/* BUFFERS */
define buffer b_abs_mstr for abs_mstr.

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
   abs_shipvia    colon 25
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



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/*DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED*/
{cclc.i}

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/* MAIN PROCEDURE BODY */

/* READ THE SHIPPER RECORD */
find abs_mstr
   where recid(abs_mstr) = i_recid
   exclusive-lock no-error.
if not available abs_mstr
then
   return.

/* READ ASSOCIATED RECORDS */
for first absc_det
   fields(absc_abs_id absc_carrier absc_seq)
   where absc_abs_id = abs_id
   no-lock:
end. /* FOR FIRST absc_det */

for first df_mstr
   fields(df_format df_form_code df_inv df_type)
   where df_type   = "1"
   and   df_format = abs_format
   no-lock:
end. /* FOR FIRST df_mstr */

/* LOAD DATA, INCLUDING PACKED FIELDS */
assign
   v_old_carrier = if available absc_det
                   then absc_carrier
                   else ""
   v_old_formcd  = if available df_mstr
                   then df_form_code
                   else ""
   v_carrier     = v_old_carrier
   /* CHECK FOR MULTIPLE CARRIER DETAILS */
   v_multi       = available absc_det
                   and (not can-find (absc_det where absc_abs_id = abs_id))
   v_format      = abs_format
   abs_shipvia   = substring(abs__qad01,1,20,"RAW")
   v_fob         = substring(abs__qad01,21,20,"RAW")
   v_carr_ref    = substring(abs__qad01,41,20,"RAW")
   v_trans_mode  = substring(abs__qad01,61,20,"RAW")
   v_veh_ref     = substring(abs__qad01,81,20,"RAW")
   v_cmmts       = abs_cmtindx <> 0.

/* GET MNEMONIC FOR CONSOLIDATION FLAG */
{gplngn2a.i
   &file     = ""sgad_det""
   &field    = ""sgad_cons_ship""
   &code     = abs_cons_ship
   &mnemonic = v_cons_ship
   &label    = v_dummy}

/* DISPLAY SCREEN VALUES */
display
   v_carrier
   v_multi
   v_format
   abs_shipvia
   v_cons_ship
   v_fob
   abs_lang
   v_trans_mode
   v_carr_ref
   v_veh_ref
   v_cmmts
with frame a.

/* GET SHIPPING INFORMATION */
main_blk:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   set
      /* ALLOW UPDATE UNLESS MULTIPLE CARRIER DETAILS EXIST */
      v_carrier when (can-find (absc_det where absc_abs_id = abs_id) or
                      not can-find (first absc_det where absc_abs_id = abs_id))
      v_multi
      abs_shipvia
      v_fob
      v_trans_mode  /*james*/ VALIDATE(CAN-FIND(FIRST CODE_mstr WHERE CODE_fldname = "xx-mot" AND CODE_value = v_trans_mode), "请输入有效的运输方式")
      v_carr_ref
      v_veh_ref
      v_format
      v_cons_ship
      abs_lang
      v_cmmts
      go-on(F5 CTRL-D)
   editing:

      if frame-field <> ""
      then
         last_field = frame-field.

      /* CARRIER ADDRESS FIELD */
      if frame-field = "v_carrier"
      then do:

         {mfnp05.i
            ad_mstr
            ad_addr
            "(ad_type = 'carrier' or
              can-find (ls_mstr where ls_type = 'carrier'
                                and   ls_addr = ad_addr))"
            ad_addr
            "input v_carrier"}

         if recno <> ?
         then
            display ad_addr @ v_carrier.

         if  (using_container_charges or
              using_line_charges)
         and (go-pending or
             (last_field <> frame-field))
         and (lastkey <> keycode("F5") and
              lastkey <> keycode("CTRL-D"))
         then do:
            if can-find(first absd_det
                        where absd_abs_id       = abs_id
                        and   absd_shipfrom     = abs_shipfrom
                        and   absd_abs_fld_name = last_field
                        and   absd_fld_prompt   = yes)
            then do:
               {gprunmo.i
                  &module = "ACL"
                  &program = ""rcswbuf.p""
                  &param = """(input yes,
                               input last_field,
                               input abs_id,
                               input abs_shipfrom)"""}
            end. /* IF CAN-FIND */

         end. /* IF (using_container_charges or ... ) */

      end.  /* IF FRAME-FIELD = "v_carrier" */

      /* DOCUMENT FORMAT FIELD */
      else
         if frame-field = "v_format"
         then do:

            {mfnp05.i
               df_mstr
               df_format
               "(df_type = '1')"
               df_format
               "input v_format" }

            if recno <> ?
            then
               display df_format @ v_format.

            if  (using_container_charges or
                 using_line_charges)
            and (go-pending or
                (last_field <> frame-field))
            and (lastkey <> keycode("F5") and
                 lastkey <> keycode("CTRL-D"))
            then do:
               if can-find(first absd_det
                           where absd_abs_id       = abs_id
                           and   absd_shipfrom     = abs_shipfrom
                           and   absd_abs_fld_name = last_field
                           and   absd_fld_prompt   = yes)
               then do:
                  {gprunmo.i
                     &module = "ACL"
                     &program = ""rcswbuf.p""
                     &param   = """(input yes,
                                    input last_field,
                                    input abs_id,
                                    input abs_shipfrom)"""}
               end. /* IF CAN-FIND */

            end. /* IF (using_container_charges OR ... */

         end.  /* IF FRAME-FIELD = "v_format" */

         /* CONSOLIDATION FLAG FIELD */
         else
            if frame-field = "v_cons_ship"
            then do:

               {mfnp05.i
                  lngd_det
                  lngd_trans
                  "(lngd_dataset = 'sgad_det' and
                    lngd_field   = 'sgad_cons_ship' and
                    lngd_lang    = global_user_lang)"
                    lngd_key2
                    "input v_cons_ship"}

               if recno <> ?
               then
                  display lngd_key2 @ v_cons_ship.

               if  (using_container_charges or
                    using_line_charges)
               and (go-pending or
                   (last_field <> frame-field))
               and (lastkey <> keycode("F5") and
                    lastkey <> keycode("CTRL-D"))
               then do:

                  if can-find(first absd_det
                              where absd_abs_id       = abs_id
                              and   absd_shipfrom     = abs_shipfrom
                              and   absd_abs_fld_name = last_field
                              and   absd_fld_prompt   = yes)
                  then do:
                     {gprunmo.i
                        &module = "ACL"
                        &program = ""rcswbuf.p""
                        &param = """(input yes,
                                     input last_field,
                                     input abs_id,
                                     input abs_shipfrom)"""}
                  end. /* IF CAN-FIND */

               end. /* IF (using_container_charges OR ... */

            end.  /* IF FRAME-FIELD = "v_cons_ship" */

            /* LANGUAGE CODE FIELD */
            else
               if frame-field = "abs_lang"
               then do:

                  {mfnp05.i
                     lng_mstr
                     lng_lang
                     "true"
                     lng_lang
                     "input abs_lang" }

                  if recno <> ?
                  then
                     display lng_lang @ abs_lang.

                  if  (using_container_charges or
                       using_line_charges)
                  and (go-pending or
                      (last_field <> frame-field))
                  and (lastkey <> keycode("F5") and
                       lastkey <> keycode("CTRL-D"))
                  then do:
                     if can-find(first absd_det
                                 where absd_abs_id     = abs_id
                                 and absd_shipfrom     = abs_shipfrom
                                 and absd_abs_fld_name = last_field
                                 and absd_fld_prompt   = yes)
                     then do:
                        {gprunmo.i
                           &module = "ACL"
                           &program = ""rcswbuf.p""
                           &param   = """(input yes,
                                          input last_field,
                                          input abs_id,
                                          input abs_shipfrom)"""}
                     end. /* IF CAN-FIND */

                  end. /* IF (using_container_charges OR ... */

               end.  /* IF FRAME-FIELD = "abs_lang" */

               /* ANY OTHER FIELD */
               else do:

                  ststatus = stline[2].
                  status input ststatus.
                  readkey.
                  apply lastkey.

                  if  (using_container_charges or
                       using_line_charges)
                  and (go-pending or
                      (last_field <> frame-field))
                  and (lastkey <> keycode("F5") and
                       lastkey <> keycode("CTRL-D"))
                  then do:

                     if can-find(first absd_det
                                 where absd_abs_id       = abs_id
                                 and   absd_shipfrom     = abs_shipfrom
                                 and   absd_abs_fld_name = last_field
                                 and   absd_fld_prompt   = yes)
                     then do:
                        {gprunmo.i
                           &module = "ACL"
                           &program = ""rcswbuf.p""
                           &param = """(input yes,
                                        input last_field,
                                        input abs_id,
                                        input abs_shipfrom)"""}
                     end. /* IF CAN-FIND */

                  end. /* IF (using_container_charges OR ... */

               end.  /* ELSE */

   end.  /* EDITING */

   if (using_container_charges or
       using_line_charges)
   and (lastkey <> keycode("F5") and
        lastkey <> keycode("CTRL-D"))
   then do:

      if can-find(first absd_det
                  where absd_abs_id     = abs_id
                  and absd_shipfrom     = abs_shipfrom
                  and absd_abs_fld_name = ""
                  and absd_fld_prompt   = yes)
      then do:
         {gprunmo.i
            &module = "ACL"
            &program = ""rcswbuf.p""
            &param   = """(input no,
                           input "''",
                           input abs_id,
                           input abs_shipfrom)"""}
      end. /* IF CAN-FIND */

   end. /* IF (using_container_charges OR ... */

   if lastkey = keycode("F5")
   or lastkey = keycode("CTRL-D")
   then do:

      /* CHECK WHETHER SHIPPER HAS CHILDREN */
      for first b_abs_mstr
         fields (b_abs_mstr.abs_shipfrom b_abs_mstr.abs_par_id)
         where b_abs_mstr.abs_shipfrom = abs_mstr.abs_shipfrom
         and   b_abs_mstr.abs_par_id   = abs_mstr.abs_id
         no-lock:

         /* CANNOT DELETE. SHIPPER HAS LINES/CONTAINERS */
         {pxmsg.i &MSGNUM=5940 &ERRORLEVEL=3}
         undo main_blk, retry main_blk.

      end.  /* FOR FIRST b_abs_mstr */

      v_discard_ok = true.

      /* START NRM SERVICES */
      {gprun.i
         ""nrm.p""
         " "
         "persistent set h_nrm"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* CHECK WHETHER DISCARD OF SHIPPER NUMBER IS ALLOWED */
      v_msgnum = 5946.

      run nr_exists in h_nrm (abs_nr_id, output v_exists).
      if v_exists
      then do:
         run nr_can_discard in h_nrm (abs_nr_id, output v_discard_ok).
         run nr_check_error in h_nrm (output v_err, output v_errnum).
         if v_err
         then
             v_discard_ok = false.
      end.  /* IF v_exists */

      /* CHECK WHETHER DISCARD OF PRESHIPPER NUMBER IS ALLOWED */
      if v_discard_ok
      then do:

         v_msgnum = 5944.
         run nr_exists in h_nrm (abs_preship_nr_id, output v_exists).

         if v_exists
         then do:
            run nr_can_discard in h_nrm
               (abs_preship_nr_id, output v_discard_ok).
            run nr_check_error in h_nrm
               (output v_err, output v_errnum).
            if v_err
            then
               v_discard_ok = false.
         end.  /* IF v_exists */

      end.  /* IF v_discard_ok */

      /* END NRM SERVICES */
      delete PROCEDURE h_nrm.

      if not v_discard_ok
      then do:
         /* DEL PROHIBITED, GAPS IN (PRE-)SHIPPER SEQ NOT PERMITTED */
         {pxmsg.i &MSGNUM=v_msgnum &ERRORLEVEL=4}
         undo main_blk, retry main_blk.
      end.  /* IF NOT v_discard_ok */

      v_cont = true.
      /* PLEASE CONFIRM DELETE */
      {pxmsg.i &MSGNUM = 11 &ERRORLEVEL = 1 &CONFIRM = v_cont}

      if not v_cont
      then
         undo main_blk, retry main_blk.

      /* DELETE COMMENTS */
      for each cmt_det
         where cmt_indx = abs_cmtindx
         exclusive-lock:
         delete cmt_det.
      end. /* FOR EACH cmt_det */

      /* DELETE TRAILER COMMENTS */
      for each cmt_det
         where cmt_indx = abs_trl_cmtindx
         exclusive-lock:
         delete cmt_det.
      end. /* FOR EACH cmt_det */

      /* DELETE CARRIERS */
      for each absc_det
         where absc_abs_id = abs_id
         exclusive-lock:
         delete absc_det.
      end. /* FOR EACH absc_det */

      /* DELETE ADDITIONAL SHIPPER INFO USING FORM SERVICES */
      {gprun.i  ""sofsde.p""  "(recid(abs_mstr))" }
/*GUI*/ if global-beam-me-up then undo, leave.


      if using_container_charges
      or using_line_charges
      then do:
            /* DELETE SHIPPER USER FIELDS AND LINE CHARGES */
         {gprunmo.i
                  &program = ""rcabsdd.p""
                  &module = "ACL"
                  &param = """(input recid(abs_mstr))"""}
      end. /* IF using_container_charges OR ... */

      /* DELETE THE LOGISTICS ACCOUNTING CHARGE DETAIL RECORD ASSOCIATED  */
      /* WITH THE SHIPPER.    */
      if use-log-acctg then do:
         /* DELETE LOGISTICS ACCTG CHARGE DETAIL */
         {gprunmo.i  &module = "LA" &program = "laosupp.p"
                     &param  = """(input 'DELETE',
                                   input '{&TYPE_SOShipper}',
                                   input substring(abs_mstr.abs_id,2),
                                   input abs_mstr.abs_shipfrom,
                                   input ' ',
                                   input ' ',
                                   input no,
                                   input no)"""}
      end. /* IF USE-LOG-ACCTG */

      /* DELETE THE SHIPPER */
      delete abs_mstr.

      o_deleted = true.

      leave main_blk.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* IF LASTKEY */

   /* VALIDATE CARRIER */
   if (can-find (absc_det where absc_abs_id = abs_id) or
       not can-find (first absc_det where absc_abs_id = abs_id))
   and v_carrier <> ""
   then do:

      if not can-find (ad_mstr where ad_addr = v_carrier)
      then do:
         /* ADDRESS DOES NOT EXIST */
         {pxmsg.i &MSGNUM=980 &ERRORLEVEL=3}
         next-prompt v_carrier.
         undo main_blk, retry main_blk.
      end.  /* IF NOT CAN-FIND */

      if not can-find(ls_mstr where ls_addr = v_carrier
                              and   ls_type = "carrier" )
      then do:
         /* ADDRESS IS NOT OF TYPE "CARRIER" */
         {pxmsg.i &MSGNUM=5905 &ERRORLEVEL=3}
         next-prompt v_carrier.
         undo main_blk, retry main_blk.
      end. /* IF NOT CAN-FIND */

   end.  /* IF CAN-FIND */

   /* VALIDATE SHIPVIA */
   if not ({gpcode.v abs_shipvia abs_shipvia})
   then do:
      /* VALUE MUST EXIST IN GENERALIZED CODES */
      {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
      next-prompt abs_shipvia.
      undo main_blk, retry main_blk.
   end.  /* IF NOT */

   /* VALIDATE FOB */
   if not ({gpcode.v v_fob abs_fob})
   then do:
      /* VALUE MUST EXIST IN GENERALIZED CODES */
      {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
      next-prompt v_fob.
      undo main_blk, retry main_blk.
   end.  /* IF NOT */

   /* VALIDATE DOCUMENT FORMAT */
   if v_format <> ""
   then do:

      /* VALIDATE THAT FORMAT EXISTS */
      for first df_mstr
         fields(df_format df_form_code df_inv df_type)
         where df_type   = "1"
         and   df_format = v_format
         no-lock:
      end. /* FOR FIRST df_mstr */
      if not available df_mstr
      then do:
         /* DOCUMENT FORMAT NOT FOUND */
         {pxmsg.i &MSGNUM=5900 &ERRORLEVEL=3}
         next-prompt v_format.
         undo main_blk, retry main_blk.
      end.  /* IF NOT AVAILABLE */

      /* VALIDATE THAT INVOICE FORMAT CAN BE USED */
      {&ICSHHDR-P-TAG1}
      else
         if   df_inv
         and  abs_type = "s"
         and  length (substring(abs_id,2)) > 8
         and (can-find (im_mstr where im_inv_mov  = abs_inv_mov
                                and   im_tr_type  = "ISS-SO") or
              abs_inv_mov = "")
         then do:
            {&ICSHHDR-P-TAG2}
            /* SHIPPER NUMBER TOO LONG TO USE SHIPPER DOC AS INVOICE */
            {pxmsg.i &MSGNUM=5982 &ERRORLEVEL=3}
            next-prompt v_format.
            undo main_blk, retry main_blk.
         end.  /* IF df_inv */

   end.  /* IF v_format <> "" */

   /* VALIDATE CONSOLIDATION FLAG */
   if global_lngd_raw
   then
      for first lngd_det
         fields (lngd_dataset lngd_field lngd_key1 lngd_key2 lngd_key3
                 lngd_key4 lngd_lang lngd_translation)
         where lngd_dataset = "sgad_det"
         and   lngd_key1    begins v_cons_ship
         and   lngd_key2    <> ""
         and   lngd_key3    = ""
         and   lngd_key4    = ""
         and   lngd_field   = "sgad_cons_ship"
         and   lngd_lang    = global_user_lang
         no-lock:
      end. /* FOR FIRST lngd_det */
   else
      for first lngd_det
         fields (lngd_dataset lngd_field lngd_key1 lngd_key2 lngd_key3
                 lngd_key4 lngd_lang lngd_translation)
         where lngd_dataset = "sgad_det"
         and   lngd_key1    <> ""
         and   lngd_key2    begins v_cons_ship
         and   lngd_key3    = ""
         and   lngd_key4    = ""
         and   lngd_field   = "sgad_cons_ship"
         and   lngd_lang    = global_user_lang
         no-lock.
      end. /* FOR FIRST lngd_det */

   if not available lngd_det
   then do:
      /* INVALID OPTION */
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3}
      next-prompt v_cons_ship.
      undo main_blk, retry main_blk.
   end.  /* IF NOT AVAILABLE lngd_det */

   /* REDISPLAY CONSOLIDATION FLAG */
   else do:
      assign
         v_cons_ship   = lngd_key2
         abs_cons_ship = lngd_key1.
         display v_cons_ship.
   end. /* ELSE */

   for first ad_mstr
      fields(ad_addr ad_lang ad_type)
      where ad_addr = abs_shipto
      no-lock:
   end. /* FOR FIRST ad_mstr */

   if not available ad_mstr
   or abs_lang <> ad_lang
   then do:
      /* VALIDATE LANGUAGE CODE */
      if not can-find (lng_mstr where lng_lang = abs_lang)
      then do:
         /* LANGUAGE MUST EXIST */
         {pxmsg.i &MSGNUM=5050 &ERRORLEVEL=3}
         next-prompt abs_lang.
         undo main_blk, retry main_blk.
      end.  /* IF NOT CAN-FIND */

   end. /* IF NOT AVAILABLE ad_mstr */

   /* WARN ABOUT CHANGING FORMAT... */
   if v_format <> abs_format
   then do:

      /* ... IF SHIPPER ALREADY PRINTED... */
      if substring(abs_status,1,1) = "y"
      then do:
         v_cont = false.
         /* SHIPPER HAS ALREADY BEEN PRINTED.  CONTINUE? */
         {pxmsg.i &MSGNUM=5803 &ERRORLEVEL=2 &MSGBUFFER=v_cont}
         if not v_cont
         then do:
            next-prompt v_format.
            undo main_blk, retry main_blk.
         end.  /* IF NOT v_cont */
      end.  /* IF SUBSTRING */

      /* ... OR IF COMBINED SHIPPER/INVOICE FORMAT SELECTED */
      if  available df_mstr
      and df_inv
      then do:
         v_cont = false.
         /* COMBINED SHIPPER/INVOICE FORMAT SELECTED.  CONTINUE? */
         {pxmsg.i &MSGNUM = 5808 &ERRORLEVEL = 2 &CONFIRM = v_cont}
         if not v_cont
         then do:
            next-prompt v_format.
            undo main_blk, retry main_blk.
         end.  /* IF NOT v_cont */
      end.  /* IF AVAILABLE */

   end.  /* IF v_format */

   /* WARN ABOUT BLANK FORMAT */
   if v_format = ""
   then do:
      /* FORMAT IS BLANK, DOCUMENT WILL NOT BE PRINTED */
      {pxmsg.i &MSGNUM=5817 &ERRORLEVEL=2}
   end.  /* IF v_format */

   /* DELETE FORMAT-SPECIFIC DATA IF FORM CODE OF FORMAT CHANGES */
   if   v_format <> abs_format
   and (not available df_mstr or
        df_form_code <> v_old_formcd)
   then do:
      {gprun.i ""sofsde.p"" "(i_recid)" }
/*GUI*/ if global-beam-me-up then undo, leave.

   end.  /* IF v_format <> abs_format ... */

   /* PACK SCREEN VALUES TO BE SAVED */
   assign
      abs_format = v_format
      substring(abs__qad01, 1,20,"RAW") = string(abs_shipvia ,"x(20)")
      substring(abs__qad01,21,20,"RAW") = string(v_fob       ,"x(20)")
      substring(abs__qad01,41,20,"RAW") = string(v_carr_ref  ,"x(20)")
      substring(abs__qad01,61,20,"RAW") = string(v_trans_mode,"x(20)")
      substring(abs__qad01,81,20,"RAW") = string(v_veh_ref   ,"x(20)").

   /* PROCESS SINGLE CARRIER */
   if v_carrier <> v_old_carrier
   then do:
      find first absc_det
         where absc_abs_id  = abs_id
         and   absc_carrier = v_old_carrier
         exclusive-lock no-error.

      if  available absc_det
      and v_carrier = ""
      then
         delete absc_det.
      else
         if available absc_det
         then
            absc_carrier = v_carrier.
         else
            if v_carrier <> ""
            then do:
               for last absc_det
                  fields(absc_abs_id absc_carrier absc_seq)
                  where absc_abs_id = abs_id
                  no-lock:
               end. /* FOR LAST absc_det */
               v_seq = if available absc_det
                       then absc_seq + 1
                       else 1.

               create absc_det.
               assign
                  absc_abs_id  = abs_id
                  absc_seq     = v_seq
                  absc_carrier = v_carrier.

               if recid(absc_det) = -1
               then .
            end.  /* IF v_carrier <> "" */

   end.  /* IF v_carrier <> v_old_carrier */

   /* MAKE SURE USER HAS A CHANCE TO READ MESSAGES */
   hide message.
   pause 0.

   /* PROCESS AUXILLIARY FRAMES */

   /* PROCESS MULTIPLE CARRIERS */
   if v_multi
   then do:
      {gprun.i ""rcshwcar.p"" "(abs_id, 4)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.  /* IF v_multi */

   /* PROCESS COMMENTS */
   if v_cmmts
   then do:
      assign
         cmtindx     = abs_cmtindx
         global_ref  = abs_format
         global_lang = abs_lang.

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'gpcmmt01,icshhdr,icshmt,rcshmt'
         &FRAME = 'cmmt01,shipper' &CONTEXT = 'HDR'}

      {gprun.i ""gpcmmt01.p"" "('abs_mstr')"}
/*GUI*/ if global-beam-me-up then undo, leave.

      abs_cmtindx = cmtindx.

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'gpcmmt01,icshhdr,icshmt,rcshmt'
         &FRAME = 'cmmt01,shipper'}

   end.  /* IF v_cmmts */

   /* GATHER ADDITIONAL HEADER DATA PER DOCUMENT FORMAT */
   {gprun.i ""sofsgh.p"" "(i_recid)" }
/*GUI*/ if global-beam-me-up then undo, leave.


   leave main_blk.

end.  /* MAIN_BLK */

hide frame a no-pause.
status input.

/* END OF MAIN PROCEDURE BODY */
