/* pppimt.p - PRICE LIST MAINTENCANCE                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.23 $                                                         */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 8.5      LAST MODIFIED: 01/13/94   BY: afs *J042*              */
/* REVISION: 8.5      LAST MODIFIED: 02/10/96   BY: DAH *J0D4*              */
/* REVISION: 8.5      LAST MODIFIED: 03/04/96   BY: rxm *G1MD*              */
/* REVISION: 8.5      LAST MODIFIED: 05/03/96   BY: kxn *J0L7*              */
/* REVISION: 8.5      LAST MODIFIED: 05/28/96   BY: ruw *J0P1*              */
/* REVISION: 8.5      LAST MODIFIED: 06/20/96   BY: jpm *J0VJ*              */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0X8* Robert Wachowicz */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*              */
/* REVISION: 8.6      LAST MODIFIED: 08/27/97   BY: *J1ZT* Aruna Patil      */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N1* Jean Miller      */
/* REVISION: 8.6      LAST MODIFIED: 12/11/97   BY: *J27Z* Aruna Patil      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L020* Charles Yen      */
/* REVISION: 8.6E     LAST MODIFIED: 08/12/98   BY: *L05P* Brenda Milton    */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *J2X2* Ajit Deodhar     */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala    */
/* REVISION: 9.0      LAST MODIFIED: 12/21/98   BY: *M03Z* Luke Pokic       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *L13D* Ashwini G.       */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MB* Mudit Mehta      */
/* $Revision: 1.23 $    BY: Anil Sudhakaran   DATE: 04/09/01 ECO: *M0P2*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pppimt_p_1 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppimt_p_7 "Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppimt_p_8 "Project"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppimt_p_9 "Promotion"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define            variable all_token      like an_code
   initial
   "qadall--+--+--+--+--+".
define            variable all_desc       like ac_desc
   .
define            variable amt_type       like pi_amt_type.
define            variable cmmt_yn        like mfc_logical
   label {&pppimt_p_1}.
define new shared variable cmtindx        like cmt_indx.
define            variable comb_type      like pi_comb_type.
define            variable disc_lab       as character format "x(20)".
define            variable pics_code      like pi_cs_code.
define            variable pics_code_desc like ac_desc.
define            variable pics_type      like pi_cs_type
   format "x(25)".
define            variable pics_type_key  like lngd_key1.
define            variable del-yn         like mfc_logical.
define            variable old_amt_type   like pi_amt_type.
define            variable part_code      like pi_part_code.
define            variable part_code_desc like ac_desc.
define            variable part_code_val  as character.
define new shared variable part_frame_row as integer.
define            variable part_type      like pi_part_type
   format "x(25)".
define            variable part_type_key  like lngd_key1.
define            variable pilistid       like pi_list_id.
define new shared variable pirecno        as recid.
define            variable qty_type       like pi_qty_type.
define            variable tmp_type       like cs_type.
define            variable valid_acct     like mfc_logical.
define            variable mc-error-number like msg_nbr no-undo.
define            variable disp-accrual as character no-undo format "x(20)".

/* Variable to handle delete functionality using CIM */
define variable batchdelete as character format "x(1)" no-undo.

assign all_desc = getTermLabel("ALL",24)
   disp-accrual = getTermLabelRt("ACCRUAL",20).

/* DISPLAY SELECTION FORM */
form
   pi_list      colon 27
   pi_cs_code   colon 27  pics_code_desc no-label
   pi_part_code colon 27  part_code_desc no-label
   pi_curr      colon 27
   pi_um        colon 27
   pi_start     colon 27
   pi_expire    colon 27
with frame a width 80 side-labels no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   pi_desc       colon 15
   pi_confg_disc colon 55
   amt_type      colon 15
   pi_manual     colon 55
   qty_type      colon 15
   pi_max_ord    colon 55
   comb_type     colon 15
   pi_disc_seq   colon 55
   pi_print      colon 55
   pi_min_net    colon 15
   pi_promo2     colon 55  format "x(01)"
   pi_max_qty    colon 15
   pi_promo1     colon 55  label {&pppimt_p_9}
   pi_cost_set   colon 55
   pi_break_cat  colon 15
   cmmt_yn       colon 55
with frame b width 80 side-labels no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   disc_lab      to 27 no-label
   pi_disc_acct  colon 27 label {&pppimt_p_7}
   pi_disc_sub   no-label
   pi_disc_cc    no-label format "x(4)"
   pi_disc_proj  colon 27
   skip(1)

   disp-accrual  to 27 no-label
   pi_accr_acct  colon 27  label {&pppimt_p_7}
   pi_accr_sub   no-label
   pi_accr_cc    no-label format "x(4)"
   pi_accr_proj  colon 27  label {&pppimt_p_8}
with frame acct width 80 side-labels no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame acct:handle).

/* Set default types */
/* (Eventually, one or both of these fields might become     */
/* user accessble; for now we only allow customer and item). */

pics_type_key = "9".  /* customer */
find first lngd_det where lngd_dataset = "an_mstr"
   and lngd_field   = "an_type"
   and lngd_lang    = global_user_lang
   and lngd_key1    = pics_type_key
   no-lock.

/* The string in the next line should match the label for an_code */
assign

   tmp_type = lngd_translation + "/" + getTermLabel("ANALYSIS_CODE",13)
   substring(pics_type, 25 - length(tmp_type), length(tmp_type)) =
   tmp_type
   pi_cs_code:label in frame a = trim(pics_type)

   part_type_key = "6".  /* item */

find first lngd_det where lngd_dataset = "an_mstr"
   and lngd_field   = "an_type"
   and lngd_lang    = global_user_lang
   and lngd_key1    = part_type_key
   no-lock.
/* The string in the next line should match the label for an_code */
assign

   tmp_type = lngd_translation + "/" + getTermLabel("ANALYSIS_CODE",13)
   substring(part_type, 25 - length(tmp_type), length(tmp_type)) =
   tmp_type
   pi_part_code:label in frame a = trim(part_type).

mainloop:
repeat:

   find first soc_ctrl no-lock no-error.
   find first pic_ctrl no-lock no-error.

   aloop:
   do transaction with frame a:

      display
         base_curr when (input pi_curr = "") @ pi_curr.
      view frame b.

      /* Initilize batchdelete variable */
      batchdelete = "".

      prompt-for
         pi_list
         pi_cs_code
         pi_part_code
         pi_curr
         pi_um
         pi_start
         /* Prompt-for batchdelete variable only during CIM */
         batchdelete no-label when (batchrun)
         editing:

         if frame-field = "pi_list" then do:  /* scroll full list */
            {mfnp.i pi_mstr pi_list pi_list pi_list pi_list pi_list}
            if recno <> ? then do:
               /* C/S Code */
               if pi_cs_code <> all_token then do:
                  find an_mstr where an_type = pics_type_key
                     and an_code = pi_cs_code
                     no-lock no-error.
                  if not available an_mstr then do:
                     /* Look for customer number   */
                     /* (This assumes type is "9") */
                     find cm_mstr where cm_addr = pi_cs_code
                        no-lock no-error.
                     if available cm_mstr
                        then pics_code_desc = cm_sort.
                  end. /* if not available an_mstr then do: */
                  else
                     pics_code_desc = an_desc.
               end. /* if pi_cs_code <> all_token then do: */
               else
                  pics_code_desc = all_desc.

               /* Item Code */
               if pi_part_code <> all_token then do:
                  find an_mstr where an_type = part_type_key
                     and an_code = pi_part_code
                     no-lock no-error.
                  if not available an_mstr then do:
                     /* Look for item */
                     /* (This assumes type is "6") */
                     find pt_mstr where pt_part = pi_part_code
                        no-lock no-error.
                     if available pt_mstr then
                        part_code_desc = pt_desc1.
                  end. /* if not available an_mstr then do: */
                  else
                     part_code_desc = an_desc.
               end. /* if pi_part_code <> all_token then do: */
               else
                  part_code_desc = all_desc.

               display
                  pi_list
                  pi_cs_code when (pi_cs_code <> all_token)
                  "" when (pi_cs_code = all_token) @ pi_cs_code
                  pics_code_desc
                  pi_part_code when (pi_part_code <> all_token)
                  "" when (pi_part_code = all_token) @ pi_part_code
                  part_code_desc
                  pi_curr
                  pi_um
                  pi_start
                  pi_expire.

               /* Interpret type codes */
               find first lngd_det
                  where lngd_dataset = "pi_mstr"
                  and lngd_field   = "pi_amt_type"
                  and lngd_lang    = global_user_lang
                  and lngd_key1    = pi_amt_type
                  no-lock.
               amt_type = lngd_translation.
               find first lngd_det
                  where lngd_dataset = "pi_mstr"
                  and lngd_field   = "pi_qty_type"
                  and lngd_lang    = global_user_lang
                  and lngd_key1    = pi_qty_type
                  no-lock.
               qty_type = lngd_translation.
               find first lngd_det
                  where lngd_dataset = "pi_mstr"
                  and lngd_field   = "pi_comb_type"
                  and lngd_lang    = global_user_lang
                  and lngd_key1    = pi_comb_type
                  no-lock.
               comb_type = lngd_translation.

               display
                  pi_desc amt_type qty_type comb_type pi_min_net
                  pi_max_qty pi_break_cat
                  pi_promo2 pi_promo1
                  pi_confg_disc pi_manual pi_max_ord
                  pi_disc_seq pi_print
                  pi_cost_set
                  (pi_cmtindx <> 0) @ cmmt_yn
               with frame b.
            end. /* if recno <> ? then do: */
         end. /* if frame-field = "pi_list" then do:  /* scroll full list */ */
         else if frame-field = "pi_cs_code" then do:
            /* Customer ACs */
            {mfnp01.i an_mstr pi_cs_code an_code
               pics_type_key an_type an_type_code }
            if recno <> ? then display an_code @ pi_cs_code
               an_desc @ pics_code_desc.
         end. /* else if frame-field = "pi_cs_code" then do: */
         else if frame-field = "pi_part_code" then do:
            /* Item ACs */
            {mfnp01.i an_mstr pi_part_code an_code
               part_type_key an_type an_type_code }
            if recno <> ? then display an_code @ pi_part_code
               an_desc @ part_code_desc.
         end. /* else if frame-field = "pi_part_code" then do: */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* else do: */
      end.  /* prompt-for pi_list... */

      /* Interpret blanks */
      if input pi_cs_code = "" then pics_code = all_token.
      else pics_code = input pi_cs_code.
      if input pi_part_code = "" then part_code = all_token.
      else part_code = input pi_part_code.
      if input pi_curr = "" then display base_curr @ pi_curr.

      /* ADD/MOD/DELETE */
      find pi_mstr where pi_list      = input pi_list
         and pi_cs_type   = pics_type_key
         and pi_cs_code   = pics_code
         and pi_part_type = part_type_key
         and pi_part_code = part_code
         and pi_curr      = input pi_curr
         and pi_um        = input pi_um
         and pi_start     = input pi_start
         share-lock no-error.

      if available pi_mstr and pi_extrec then do:
         {pxmsg.i &MSGNUM=2192 &ERRORLEVEL=3}
         /*Cannot update externally created pr list*/
         next-prompt pi_list.
         undo, retry.
      end. /* if available pi_mstr and pi_extrec then do: */

      if not available pi_mstr then do:

         /* VALIDATE */

         /* List name */
         if input pi_list = "FACTOR" then do:  /* Do not translate */
            {pxmsg.i &MSGNUM=5310 &ERRORLEVEL=3}  /* Reserved for system use */
            next-prompt pi_list.
            undo, retry.
         end. /* if input pi_list = "FACTOR" then do:  /* Do not translate */ */

         if soc_apm   and

            input pi_list matches pic_promo_pre + "*" then do:
            {pxmsg.i &MSGNUM=2190 &ERRORLEVEL=3}
            /*New price list cannnot start with
            promotions prefix*/
            next-prompt pi_list.
            undo, retry.
         end. /* input pi_list matches pic_promo_pre + "*" then do: */

         /* C/S Code */
         if pics_code <> all_token then do:
            find an_mstr where an_type = pics_type_key
               and an_code = pics_code
               no-lock no-error.
            if not available an_mstr then do:
               /* Look for customer number   */
               /* (This assumes type is "9") */
               find cm_mstr where cm_addr = pics_code no-lock no-error.
               if not available cm_mstr then do:
                  {pxmsg.i &MSGNUM=6901 &ERRORLEVEL=3}  /* AC must exist */
                  next-prompt pi_cs_code.
                  undo, retry.
               end. /* if not available cm_mstr then do: */
               else
                  display cm_sort @ pics_code_desc.
            end. /* if not available an_mstr then do: */
            else do:
               display an_desc @ pics_code_desc.
               if not an_active then do:
                  {pxmsg.i &MSGNUM=6907 &ERRORLEVEL=2}  /* AC is inactive */
               end. /* if not an_active then do: */
            end. /* else do: */
         end. /* if pics_code <> all_token then do: */
         else
            display all_desc @ pics_code_desc.

         /* Item Code */
         if part_code <> all_token then do:
            find an_mstr where an_type = part_type_key
               and an_code = part_code
               no-lock no-error.
            if not available an_mstr then do:
               /* Look for item */
               /* (This assumes type is "6") */
               find pt_mstr where pt_part = part_code no-lock no-error.
               if not available pt_mstr then do:
                  {pxmsg.i &MSGNUM=6901 &ERRORLEVEL=3}  /* AC must exist */
                  next-prompt pi_part_code.
                  undo, retry.
               end. /* if not available pt_mstr then do: */
               else do:
                  display pt_desc1 @ part_code_desc.
                  part_code_val = "part".
               end. /* else do: */
            end. /* if not available an_mstr then do: */
            else do:
               display an_desc @ part_code_desc.
               if not an_active then do:
                  {pxmsg.i &MSGNUM=6907 &ERRORLEVEL=2}  /* AC is inactive */
               end. /* if not an_active then do: */
            end. /* else do: */
         end. /* if part_code <> all_token then do: */
         else do:
            display all_desc @ part_code_desc.
            part_code_val = "all".
         end. /* else do: */

         /* Currency code */
         if input pi_curr <> base_curr then do:

            /* CHANGED input pi_curr TO input (input pi_curr) */
            {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
               "(input (input pi_curr),
                         output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               /* INVALID CURRENCY CODE */
               next-prompt pi_curr.
               undo, retry.
            end. /* if mc-error-number <> 0 then do: */
         end.  /* if input pi_curr <> base_curr */

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}  /* Adding . . . */

         run update-list (input-output pilistid).
         /* Get price list id (for link to pricing detail) */

         create pi_mstr.
         assign pi_list
            pi_cs_type   = pics_type_key
            pi_cs_code   = pics_code
            pi_part_type = part_type_key
            pi_part_code = part_code
            pi_curr
            pi_um
            pi_start
            pi_list_id   = pilistid
            pi_mod_date  = today
            pi_userid    = global_userid
            pi_amt_type  = "2"  /* discount */
            pi_qty_type  = "1"  /* quantity */
            pi_comb_type = "2"  /* combinable */
            .
      end.  /* if not avail pi_mstr */

      /* TO DISPLAY DESCRIPTION OF CUSTOMER CODE AND ITEM CODE */
      /* IF PRICE LIST ALREADY EXISTS             */
      else do:
         if pics_code <> all_token then do:
            find an_mstr where an_type = pics_type_key
               and an_code = pics_code
               no-lock no-error.
            if not available an_mstr then do:
               find cm_mstr where cm_addr = pics_code no-lock no-error.
               if not available cm_mstr then do:
                  /* ANALYSIS CODE MUST EXIST */
                  {pxmsg.i &MSGNUM=6901 &ERRORLEVEL=3}
                  next-prompt pi_cs_code.
                  undo, retry.
               end. /* CUSTOMER NOT AVAILABLE */
               else
                  display cm_sort @ pics_code_desc.
            end. /* IF NOT AVAIL AN_MSTR */
            else do:
               display an_desc @ pics_code_desc.
               if not an_active then do:
                  /* ANALYSIS CODE IS INACTIVE */
                  {pxmsg.i &MSGNUM=6907 &ERRORLEVEL=2}
               end. /* if not an_active then do: */
            end. /* IF AVAIL AN_MSTR  */
         end.  /* IF CUSTOMER CODE NOT EQUAL TO ALL_TOKEN */
         else
            display all_desc @ pics_code_desc.

         /* FOR ITEM CODE */
         if part_code <> all_token then do:
            find an_mstr where an_type = part_type_key
               and an_code = part_code
               no-lock no-error.
            if not available an_mstr then do:
               /* Look for item */

               find pt_mstr where pt_part = part_code no-lock no-error.
               if not available pt_mstr then do:
                  /* ANALYSIS CODE MUST EXIST */
                  {pxmsg.i &MSGNUM=6901 &ERRORLEVEL=3}
                  next-prompt pi_part_code.
                  undo, retry.
               end. /* IF NOT AVAIL PT_MSTR */
               else do:
                  display pt_desc1 @ part_code_desc.
                  part_code_val = "part".
               end. /* IF AVAIL PT_MSTR */
            end.   /* IF NOT AVAIL AN_MSTR */
            else do:
               display an_desc @ part_code_desc.
               if not an_active then do:
                  /* ANALYSIS CODE IS INACTIVE */
                  {pxmsg.i &MSGNUM=6907 &ERRORLEVEL=2}
               end. /* if not an_active then do: */
            end. /* IF AVAIL AN_MSTR */
         end.   /* ITEM CODE NON BLANK */
         else do:
            display all_desc @ part_code_desc.
            part_code_val = "all".
         end.   /* ITEM CODE BLANK  */
      end.     /* IF AVAIL PI_MSTR */

      run find-lngd (recid(pi_mstr)).

      cmmt_yn = ( pi_cmtindx <> 0 ).

      display pi_expire with frame a.
      display
         pi_desc amt_type qty_type comb_type pi_min_net
         pi_max_qty pi_break_cat
         pi_promo2 pi_promo1
         pi_confg_disc pi_manual pi_max_ord
         pi_disc_seq pi_print
         pi_cost_set
         cmmt_yn
      with frame b.

      a_nother_loop:
      do on error undo, retry with frame a:

         ststatus = stline[2].
         status input ststatus.

         update pi_expire
            go-on(F5 CTRL-D).

         /* DELETE */
         /* Execute delete if variable batchdelete is set to "x" */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            or input batchdelete = "x"
            then do:

            /* Warn user if price is in use */
            if can-find(first pih_hist where pih_list_id = pi_list_id)
            then do:
               {pxmsg.i &MSGNUM=6908 &ERRORLEVEL=2}
               /* Price list is used in history */
            end. /* then do: */

            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn then do:

               for each pid_det where pid_list_id = pi_list_id
                     exclusive-lock:
                  delete pid_det.
               end. /* for each pid_det where pid_list_id = pi_list_id */

               delete pi_mstr.

               clear frame b.
               clear frame a.
               next mainloop.

            end.  /* if del-yn */

         end.  /* if lastkey */

         if pi_expire < pi_start then do:
            {pxmsg.i &MSGNUM=123 &ERRORLEVEL=4}
            /* End date cannot be before start date */
            undo, retry.
         end. /* if pi_expire < pi_start then do: */

      end.  /* a_nother_loop */

   end.  /* ALOOP */

   ststatus = stline[1].
   status input ststatus.

   b_loop:
   do transaction on error undo, retry with frame b:

      old_amt_type = pi_amt_type.

      set
         pi_desc amt_type qty_type comb_type pi_min_net
         pi_max_qty pi_break_cat
         pi_confg_disc pi_manual pi_max_ord
         pi_disc_seq pi_print
         cmmt_yn
         editing:

         if frame-field = "amt_type" then do:
            {mfnp05.i lngd_det lngd_trans
               "    lngd_dataset = 'pi_mstr'
                                and lngd_field   = 'pi_amt_type'
                                and lngd_lang    = global_user_lang"
               lngd_translation "input amt_type"}
            if recno <> ? then
            display lngd_translation @
               amt_type.
         end. /* if frame-field = "amt_type" then do: */
         else if frame-field = "qty_type" then do:
            {mfnp05.i lngd_det lngd_trans
               "    lngd_dataset = 'pi_mstr'
                                and lngd_field   = 'pi_qty_type'
                                and lngd_lang    = global_user_lang"
               lngd_translation "input qty_type"}
            if recno <> ? then display lngd_translation @
               qty_type.
         end. /* else if frame-field = "qty_type" then do: */
         else if frame-field = "comb_type" then do:
            {mfnp05.i lngd_det lngd_trans
               "    lngd_dataset = 'pi_mstr'
                                and lngd_field   = 'pi_comb_type'
                                and lngd_lang    = global_user_lang"
               lngd_translation "input comb_type"}
            if recno <> ? then display lngd_translation @
               comb_type.
         end. /* else if frame-field = "comb_type" then do: */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* else do: */

      end.  /* editing frame b input */

      /* VALIDATE */

      /* Amount Type */
      find first lngd_det where lngd_dataset     = "pi_mstr"
         and lngd_field       = "pi_amt_type"
         and lngd_lang        = global_user_lang
         and lngd_translation = input amt_type
         no-lock no-error.
      if not available lngd_det then do:
         {pxmsg.i &MSGNUM=6909 &ERRORLEVEL=3}  /* Invalid Amount Type */
         next-prompt amt_type.
         undo, retry.
      end. /* if not available lngd_det then do: */
      pi_amt_type = lngd_key1.

      /* Quantity Type */
      find first lngd_det where lngd_dataset     = "pi_mstr"
         and lngd_field       = "pi_qty_type"
         and lngd_lang        = global_user_lang
         and lngd_translation = input qty_type
         no-lock no-error.
      if not available lngd_det then do:
         {pxmsg.i &MSGNUM=6910 &ERRORLEVEL=3}  /* Invalid Amount Type */
         next-prompt qty_type.
         undo, retry.
      end. /* if not available lngd_det then do: */
      pi_qty_type = lngd_key1.

      /* Comb Type */
      find first lngd_det where lngd_dataset     = "pi_mstr"
         and lngd_field       = "pi_comb_type"
         and lngd_lang        = global_user_lang
         and lngd_translation = input comb_type
         no-lock no-error.
      if not available lngd_det then do:
         {pxmsg.i &MSGNUM=6911 &ERRORLEVEL=3}  /* Invalid Amount Type */
         next-prompt comb_type.
         undo, retry.
      end. /* if not available lngd_det then do: */
      pi_comb_type = lngd_key1.

      /* Nets and Mark-ups have to be Base or Exclusive */
      if (pi_amt_type = "3" or pi_amt_type = "4")
         and not (pi_comb_type = "1" or pi_comb_type = "4") then do:
         {pxmsg.i &MSGNUM=6912 &ERRORLEVEL=3}
         next-prompt comb_type.
         undo, retry.
      end. /* and not (pi_comb_type = "1" or pi_comb_type = "4") then do: */

      if (pi_amt_type = "1") and not (pi_comb_type = "2") then do:
         /* LIST PRICE LISTS MUST HAVE COMBINABLE COMB TYPE */
         {pxmsg.i &MSGNUM=2002 &ERRORLEVEL=3}
         next-prompt comb_type.
         undo, retry.
      end. /* if (pi_amt_type = "1") and not (pi_comb_type = "2") then do: */

      /* Do not allow amount type change if detail exists */
      /* (Ordinarily I hate offering to let the user      */
      if pi_amt_type <> old_amt_type
         and can-find(first pid_det where pid_list_id = pi_list_id)
      then do:
         {pxmsg.i &MSGNUM=6916 &ERRORLEVEL=3}
         /* Price detail exists - change not allwd */
         next-prompt amt_type.
         undo, retry.
      end. /* then do: */

   end.  /* b_loop */

   b_nother_loop:
   do transaction with frame b:

      /* Set search type for index */
      if pi_amt_type = "1" then pi_srch_type = 1.
      else pi_srch_type = 2.

      /* Update cost set for Mark-up Price lists */
      if pi_amt_type = "3" then do:

         set pi_cost_set.

      end. /* if pi_amt_type = "3" then do: */

      /* Validation */
      /* (Just kidding, we don't actually validate cost sets.) */
      /* (I'm not saying this is a bad idea, but when we       */
      /* decide to make the system work this is where the cost */
      /* set validation will go.)                              */

   end.  /* b_nother_loop */

   /* Update accounting detail (Discounts & Accruals Only) */
   if lookup(pi_amt_type, "2,3,4,8,9") <> 0 then
      acct_loop:
   do transaction with frame acct:

      display disp-accrual with frame acct.
      if pi_amt_type = "8" then

      disc_lab = getTermLabelRt("EXPENSE",20).
      else

      disc_lab = getTermLabelRt("DISCOUNT",20).

      hide frame b.

      display disc_lab.

      update pi_disc_acct pi_disc_sub pi_disc_cc pi_disc_proj
         pi_accr_acct pi_accr_sub pi_accr_cc pi_accr_proj.

      /*CHECK TO SEE IF THE ACCR & DISC ACCT'S ARE BOTH TYPE "M"*/
      define buffer ac_mstr_buf for ac_mstr.
      find first ac_mstr no-lock where ac_code = pi_disc_acct
         no-error.
      find first ac_mstr_buf no-lock where
         ac_mstr_buf.ac_code = pi_accr_acct no-error.
      if (available ac_mstr and available ac_mstr_buf) and
         (ac_mstr.ac_type <> ac_mstr_buf.ac_type) and
         (ac_mstr.ac_type = "M" or ac_mstr_buf.ac_type = "M")
      then do:
         {pxmsg.i &MSGNUM=2319 &ERRORLEVEL=3}
         /*ERROR GL ACCTS MUST BE OF THE SAME TYPE*/
         undo, retry acct_loop.
      end. /* then do: */

      /* Validate account/cc if non-blank OR accruals */
      if pi_amt_type = "8"

         or (pi_disc_acct <> "" or pi_disc_sub <> ""
         or pi_disc_cc <> "" or pi_disc_proj <> "") then do:

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* ACCOUNT CODE VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
            "(input  pi_disc_acct,
                              input  pi_disc_sub,
                              input  pi_disc_cc,
                              input  pi_disc_proj,
                              output valid_acct)"}

         if not valid_acct then do:
            next-prompt pi_disc_acct with frame acct.
            undo acct_loop, retry.
         end. /* if not valid_acct then do: */

      end. /* or pi_disc_cc <> "" or pi_disc_proj <> "") then do: */
      if pi_amt_type = "8"

         or (pi_accr_acct <> "" or pi_accr_sub <> ""
         or pi_disc_cc <> "" or pi_disc_proj <> "") then do:

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* ACCOUNT CODE VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
            "(input  pi_accr_acct,
                              input  pi_accr_sub,
                              input  pi_accr_cc,
                              input  pi_accr_proj,
                              output valid_acct)"}

         if not valid_acct then do:
            next-prompt pi_accr_acct with frame acct.
            undo acct_loop, retry.
         end. /* if not valid_acct then do: */

      end. /* or pi_disc_cc <> "" or pi_disc_proj <> "") then do: */

      hide frame acct.

   end. /* do transaction with frame acct: */

   if cmmt_yn then do:
      do transaction:
         hide frame a.
         hide frame b.
         cmtindx = pi_cmtindx.
         global_ref = pi_list.
         {gprun.i ""gpcmmt01.p"" "(input ""pi_mstr"")"}
         pi_cmtindx = cmtindx.
         view frame a.
      end. /* do transaction: */
   end. /* if cmmt_yn then do: */

   /* Update the detail files */
   pirecno = recid(pi_mstr).
   /*V8-*/
   part_frame_row = frame-row(a) + 4.
   /*V8+*/
   /*V8!
   part_frame_row = frame-row(a) + 3. */

   {gprun.i ""pppimta.p""}

end.  /* mainloop */

status input.

PROCEDURE  find-lngd:
   /* Interpret type codes */
   define input parameter pi_rec as recid no-undo.
   find  pi_mstr where recid(pi_mstr) = pi_rec exclusive-lock.
   find first lngd_det where lngd_dataset = "pi_mstr"
      and lngd_field   = "pi_amt_type"
      and lngd_lang    = global_user_lang
      and lngd_key1    = pi_amt_type
      no-lock.
   amt_type = lngd_translation.
   find first lngd_det where lngd_dataset = "pi_mstr"
      and lngd_field   = "pi_qty_type"
      and lngd_lang    = global_user_lang
      and lngd_key1    = pi_qty_type
      no-lock.
   qty_type = lngd_translation.
   find first lngd_det where lngd_dataset = "pi_mstr"
      and lngd_field   = "pi_comb_type"
      and lngd_lang    = global_user_lang
      and lngd_key1    = pi_comb_type
      no-lock.
   comb_type = lngd_translation.
END PROCEDURE.  /* END OF INTERNAL PROCEDURE FIND-LNGD */

PROCEDURE update-list:

   define input-output parameter pilistid as character format "x(10)".

   form
      pilistid with frame listid width 80.

   /* REPLACED THE CALL TO MFNCTRL.I WITH MFNCTRLF.I TO FACILITATE  */
   /* ADDING OVER 100000000 PRICE LISTS                             */

   {mfnctrlf.i pic_ctrl pic_list_id pi_mstr pi_list_id pilistid}

END PROCEDURE. /* update-list */
