/* cmcfmmt.p - MISCELLANEOUS CASH FLOW MAINTENANCE                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*V8:RunMode=Character,Windows                                            */
/* REVISION: 7.0      LAST MODIFIED: 01/18/92   BY: tmd *F030*          */
/*                                   03/13/92   BY: tmd *F282*          */
/* REVISION: 7.3      LAST MODIFIED: 09/14/92   BY: mpp *G477*          */
/*                                   05/31/94   by: srk *FO51*          */
/*                                   08/23/94   by: rxm *GL45*          */
/*                                   12/13/95   BY: mys *F0WP*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton */
/* REVISION: 8.6E     LAST MODIFIED: 07/25/98   BY: *L04N* Jim Josey    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn              */
/************************************************************************/

         /* DISPLAY TITLE */
         {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE cmcfmmt_p_1 "By"
/* MaxLen: Comment: */

&SCOPED-DEFINE cmcfmmt_p_2 "Src/Use"
/* MaxLen: Comment: */

/*L04N*/
&SCOPED-DEFINE cmcfmmt_p_3 "Exch Rate"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define variable del-yn       like mfc_logical initial no.
         define variable old_due_date like cf_due_date.
         define variable cftype       like cf_type column-label {&cmcfmmt_p_2}.
         define variable cfentity     like cf_entity.
         define variable cfcurr       like cf_curr.
         define variable cfbank       like cf_bank.
         define variable cfbkdesc     like bk_desc.
/*L04N*  define variable cfent_ex     like cf_ent_ex. */
         define variable cfex_rate    like cf_ex_rate.
/*L00Y*/ define variable cfex_rate2   like cf_ex_rate2.
/*L04N*  define variable tempdate     like exd_eff_date. */
/*L04N*/ define variable tempdate     like exr_end_date.
/*L04N*/ define variable disp_line1   as character format "x(40)"
                                      label {&cmcfmmt_p_3}        no-undo.
/*L04N*/ define variable disp_line2   as character format "x(40)" no-undo.
/*L04N*/ define variable dummy_fixed_rate as logical              no-undo.
/*L04N*/ define variable mc-error-number  like msg_nbr            no-undo.

         /* DISPLAY */

         form
            cf_nbr          colon 15
            cf_type         colon 60
            skip(1)
            cf_ref          colon 15
            cf_expt_amt     colon 60
            cf_desc1        colon 15
            cf_desc2        at 17       no-labels
            skip(1)
            cf_due_date     colon 15
            cf_expt_date    colon 15
            cf_ldue_date    colon 15    skip(1)
            cf_entity       colon 15
            cf_bank         colon 15    space(3)
            cfbkdesc                    no-labels skip(1)
            cf_curr         colon 15
/*L04N*     cf_ent_ex       colon 15 */
/*L04N*/    disp_line1      colon 15
/*L04N*/    skip
/*L04N*/    disp_line2      colon 17    no-label
/*L04N*/    skip
            cf_date         colon 51
            cf_lastedit     colon 51
            cf_userid                   label {&cmcfmmt_p_1}
         with frame a side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         find first gl_ctrl no-lock.
         find first cfc_ctrl no-lock.
         find first apc_ctrl no-lock no-error.

         mainloop:
         repeat:

            loopa:
            do on endkey undo, leave mainloop:

               loopa1:
               do transaction with frame a on error undo, leave loopa:

                  prompt-for cf_mstr.cf_nbr editing:

                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp.i cf_mstr cf_nbr cf_nbr cf_nbr cf_nbr cf_nbr}

                     if recno <> ? then do:

/*L04N*/                /* GET EXCHANGE RATES FROM USAGE RECORD */
/*L04N*/                {gprunp.i "mcui" "p" "mc-ex-rate-output"
                         "(input cf_curr,
                           input gl_base_curr,
                           input cf_ex_rate,
                           input cf_ex_rate2,
                           input cf_exru_seq,
                           output disp_line1,
                           output disp_line2)"}

                        display
                           cf_nbr
                           cf_ref
                           cf_type
                           cf_expt_amt
                           cf_desc1
                           cf_desc2
                           cf_due_date
                           cf_expt_date
                           cf_ldue_date
                           cf_entity
                           cf_bank
                           cf_curr
/*L04N*                    cf_ent_ex */
/*L04N*/                   disp_line1
/*L04N*/                   disp_line2
                           cf_date
                           cf_userid
                           cf_lastedit
                        with frame a.

                        find first bk_mstr where bk_code = cf_bank
                        no-lock no-error.
                        if available bk_mstr then
                           display
                              bk_desc @ cfbkdesc
                           with frame a.
                        else
                           display
                              "" @ cfbkdesc
                           with frame a.
                     end.
                  end.  /* prompt-for */

                  /* ADD/MOD/DELETE  */

                  find cf_mstr where cf_nbr = input cf_nbr
                  no-error.

                  /* CREATE NEW RECORD */
                  if not available cf_mstr then do:

                     /* NEW ITEM */
                     {mfmsg.i 1 1}
                     create cf_mstr.
                     if input cf_nbr = "" then do:
                        {mfnctrl.i cfc_ctrl cfc_cfnbr cf_mstr cf_nbr cf_nbr}
                     end.
                     if input cf_nbr <> "" then
/*N08T*                 assign cf_nbr = caps(input cf_nbr). */
/*N08T*/                assign cf_nbr = input cf_nbr.

/*L04N*/             assign
/*L04N*/                disp_line1  = ""
/*L04N*/                disp_line2  = ""
                        cf_date     = today
                        cf_lastedit = today
                        cf_userid   = global_userid.

                     /* NEW ITEM DEFAULTS */
                     if cfentity = "" then cfentity = gl_entity.
                     if cfcurr   = "" then cfcurr = gl_base_curr.
                     if cfbank = "" then do:
                        if available apc_ctrl then do:
                           cfbank = apc_bank.
                           find first bk_mstr where bk_code = cfbank
                           no-lock no-error.
                           if available bk_mstr then do:
/*L04N*/                      assign
                                 cfcurr   = bk_curr
                                 cfbkdesc = bk_desc.
                           end.
                        end.
                     end.

                     display
                        cf_nbr
                        cf_date
                        cf_lastedit
                        cf_userid
                        cfbkdesc
                        cftype @ cf_type
                        cfentity @ cf_entity
                        cfbank @ cf_bank
                        cfbkdesc
                        cfcurr @ cf_curr
/*L04N*                 cfent_ex @ cf_ent_ex */
/*L04N*/                disp_line1
/*L04N*/                disp_line2
                     with frame a.

                     assign
                        cf_type
                        cf_entity
                        cf_bank
                        cf_curr.
/*L04N*                 cf_ent_ex.*/
                  end.  /* IF NOT AVAILABLE CF_MSTR */
                  else do:
                     find first bk_mstr where bk_code = cf_bank
                     no-lock no-error.
                     if available bk_mstr then cfbkdesc = bk_desc.
                     else cfbkdesc = "".

/*L04N*/             /* GET EXCHANGE RATES FROM USAGE RECORD */
/*L04N*/             {gprunp.i "mcui" "p" "mc-ex-rate-output"
                      "(input cf_curr,
                        input gl_base_curr,
                        input cf_ex_rate,
                        input cf_ex_rate2,
                        input cf_exru_seq,
                        output disp_line1,
                        output disp_line2)"}

                  end.

                  ststatus = stline[2].
                  status input ststatus.

                  loopa2:
                  do on error undo, retry:
                     /* DISPLAY */
                     display
                        cf_nbr
                        cf_date
                        cf_lastedit
                        cf_userid
                        cfbkdesc
                        cf_type
                        cf_ref
                        cf_expt_amt
                        cf_desc1
                        cf_desc2
                        cf_due_date
                        cf_expt_date
                        cf_ldue_date
                        cf_entity
                        cf_bank
                        cf_curr
/*L04N*                 cf_ent_ex */
/*L04N*/                disp_line1
/*L04N*/                disp_line2
                     with frame a.

                     loopa3:
                     do on error undo, retry:

                        display
                           today @ cf_lastedit
                           global_userid @ cf_userid
                        with frame a.
                        old_due_date = cf_due_date.

                        set
                           cf_type
                           cf_ref
                           cf_expt_amt
                           cf_desc1
                           cf_desc2
                           cf_due_date
                           cf_expt_date
                           cf_entity
                           cf_bank
                           cf_curr
                        when (new cf_mstr)
                        go-on(F5 CTRL-D) with frame a.

                        /* DELETE */
                        if lastkey = keycode("F5") or
                        lastkey = keycode("CTRL-D")
                        then do:
                           del-yn = yes.
                           {mfmsg01.i 11 1 del-yn}
                           if del-yn = no then undo loopa3.
                        end.

                        if del-yn then do:

                           /* DELETE CASH FLOW MASTER */

/*L04N*/                   /* DELETE EXCHANGE RATE USAGE RECORD */
/*L04N*/                   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                            "(input cf_exru_seq)"}

                           delete cf_mstr.
                           clear frame a no-pause.
                           del-yn = no.
                           {mfmsg.i 22 1}
                           next.

                        end.

                        /* DO NOT ALLOW BLANK DUE DATE */
                        if cf_due_date = ? then do:
                           {mfmsg.i 27 3}
                           /* INVALID DATE */
                           next-prompt cf_due_date with frame a.
                           undo, retry.
                        end.

                        if input cf_due_date <> old_due_date
                        then
                           display
                              old_due_date @ cf_ldue_date
                           with frame a.
                        assign
                           cf_lastedit
                           cf_userid
                           cf_expt_date
                           cf_ldue_date.

                        display
                           cf_lastedit
                           cf_userid
                           cf_expt_date
                           cf_ldue_date
                        with frame a.

                        /* VERIFY ENTITY */
                        if input cf_entity <> gl_entity then do:
                           find en_mstr where en_entity = input cf_entity
                           no-lock no-error.
                           if not available en_mstr then do:
                              {mfmsg.i 3061 3}
                              /* INVALID ENTITY */
                              next-prompt cf_entity with frame a.
                              undo, retry.
                           end.
                        end.

                        if input cf_bank <> "" then do:
                           find bk_mstr where bk_code = input cf_bank
                           no-lock no-error.
                           if not available bk_mstr then do:
                              {mfmsg.i 1200 3}
                              /* INVALID BANK */
                              display
                                 "" @ cfbkdesc
                              with frame a.
                              next-prompt cf_bank with frame a.
                              undo, retry.
                           end.

                           if input cf_entity <> bk_entity then do:
                              {mfmsg.i 3520 3}
                              /* ENTITY AND BANK ENTITY MUST MATCH */
                              next-prompt cf_bank with frame a.
                              undo, retry.
                           end.

/*L04N*/                   if input cf_curr <> "" then do:
/*L04N*/                      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                               "(input cf_curr,
                                 output mc-error-number)"}
/*L04N*/                      if mc-error-number <> 0 then do:
/*L04N*/                         {mfmsg.i mc-error-number 3}
/*L04N*/                         next-prompt cf_curr with frame a.
/*L04N*/                         undo,retry.
/*L04N*/                      end.
/*L04N*/                   end.

                           if input cf_curr <> bk_curr then do:
                              {mfmsg.i 3515 3}
                              /* INVALID BANK & CURRENCY COMBINATION */
                              next-prompt cf_curr with frame a.
                              undo, retry.
                           end.

                           if cf_curr = "" then cf_curr = bk_curr.
                           display
                              bk_desc @ cfbkdesc
                              cf_curr
                           with frame a.
                        end.  /* END if cfbank <> "" */
                        else
                           display
                              "" @ cfbkdesc
                           with frame a.

                        setc:
                        do on error undo, retry:
                           if new cf_mstr and input cf_curr <> gl_base_curr
                           then do:

                              /* VALIDATE EXCHANGE RATE */
                              /* Use the Expect Date if entered, */
                              /* otherwise Due Date */
                              if cf_expt_date <> ? then
                                 tempdate = cf_mstr.cf_expt_date.
                              else
                                 tempdate = cf_mstr.cf_due_date.

/*L04N*                          {gpgtex5.i &ent_curr = base_curr     */
/*L04N*                                     &curr = cf_mstr.cf_curr   */
/*L04N*                                     &date = tempdate          */
/*L04N*                                     &exch_from = exd_ent_rate */
/*L04N*                                     &exch_to = cf_ent_ex}     */

/*L04N*/                         {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                                  "(input cf_curr,
                                    input gl_base_curr,
                                    input cf_ex_ratetype,
                                    input tempdate,
                                    output cf_ex_rate,
                                    output cf_ex_rate2,
                                    output cf_exru_seq,
                                    output mc-error-number)"}
/*L04N*/                         if mc-error-number <> 0 then do:
/*L04N*/                            {mfmsg.i mc-error-number 3}
/*L04N*/                            next-prompt cf_curr with frame a.
/*L04N*/                            undo, retry.
/*L04N*/                         end.
                           end.

/*L04N*                    update                                            */
/*L04N*                       cf_ent_ex when (input cf_curr <> gl_base_curr) */
/*L04N*                    with frame a.                                     */

/*L04N*                    if cf_ent_ex = 0 then do:             */
/*L04N*                       /* VERIFY ENTERED EXCHANGE RATE */ */
/*L04N*                       {mfmsg.i 317 3}                    */
/*L04N*                       /* ZERO NOT ALLOWED */             */
/*L04N*                       undo, retry.                       */
/*L04N*                    end.                                  */

/*L04N*/                   if cf_curr <> gl_base_curr then do:
/*L04N*/                      pause 0.
/*L04N*/                      {gprunp.i "mcui" "p" "mc-ex-rate-input"
                               "(input cf_curr,
                                 input gl_base_curr,
                                 input tempdate,
                                 input cf_exru_seq,
                                 input false,
                                 /* DO NOT UPDATE FIXED-RATE FIELD */
                                 input frame a:row + 5,
                                 input-output cf_ex_rate,
                                 input-output cf_ex_rate2,
                                 input-output dummy_fixed_rate)"}
/*L04N*/                   end.

/*L04N*                    {gpgtex7.i  &ent_curr = base_curr  */
/*L04N*                                &curr = cf_curr        */
/*L04N*                                &exch_from = cf_ent_ex */
/*L04N*                                &exch_to = cf_ex_rate} */

/*L04N*/                   /* GET EXCHANGE RATES FROM USAGE RECORD */
/*L04N*/                   {gprunp.i "mcui" "p" "mc-ex-rate-output"
                            "(input cf_curr,
                              input gl_base_curr,
                              input cf_ex_rate,
                              input cf_ex_rate2,
                              input cf_exru_seq,
                              output disp_line1,
                              output disp_line2)"}

/*L04N*/                   display
/*L04N*/                      disp_line1
/*L04N*/                      disp_line2
/*L04N*/                   with frame a.

                        end.  /* SETC */

                     end.  /* LOOPA3 */
                     status input.

/*L04N*/             assign
                        cftype   = cf_type
                        cfentity = cf_entity
                        cfcurr   = cf_curr
                        cfbank   = cf_bank.
                     if available bk_mstr then cfbkdesc = bk_desc.
/*L04N*              cfent_ex = cf_ent_ex. */
                  end.  /* END LOOPA2  */

               end.  /* DO TRANSACTION - LOOPA1 */

            end.  /* LOOPA */

            ststatus = stline[3].
            status input ststatus.

         end.
         /* END MAINLOOP */
         status input.
