
{mfdtitle.i "100828.1"}

&SCOPED-DEFINE xxivd_p_1 "xxivd_sonbr"
&SCOPED-DEFINE xxivd_p_2 "xxivd_confim_amt"
&SCOPED-DEFINE xxivd_p_3 "xxivd_plan_amt"
&SCOPED-DEFINE xxivd_p_4 "xxivd_rmks"
/* MaxLen: Comment: */
define variable del-yn like mfc_logical initial no.
define variable vbillname as character format "x(20)".
define variable dptdesc   like dpt_desc format "x(12)".
define variable vsysnbr   like xxiv_sysnbr.
define variable rec-cnt as integer no-undo.
form
  xxiv_sysnbr       colon 12
  xxiv_nbr          colon 36
  xxiv_ref          colon 64
  xxiv_bill         colon 12  vbillname no-labels
  xxiv_rmks         format "x(60)"   colon 12
  xxiv_type         colon 12
  xxiv_dept         colon 32 dptdesc no-labels
  xxiv_slspsn       colon 64
  xxiv_actype       colon 12
  xxiv_date         colon 36
  xxiv_promise_date colon 64
  xxiv_userid       colon 12
  xxiv_audit        colon 36
  xxiv_terms_days   colon 64
with frame a title "发票维护" side-labels width 80 attr-space.
setFrameLabels(frame a:handle).
form
   xxivd_det.xxivd_sonbr      column-label {&xxivd_p_1}
   xxivd_det.xxivd_confim_amt column-label {&xxivd_p_2}
   xxivd_det.xxivd_plan_amt   column-label {&xxivd_p_3}
   xxivd_det.xxivd_rmks       column-label {&xxivd_p_4} format "x(32)"
with frame c 8 down Title "发票明细" width 80. /* title color normal */
setFrameLabels(frame c:handle).

view frame a.
mainloop:
     repeat with frame a:
        prompt-for xxiv_sysnbr editing:
           /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i xxiv_mstr xxiv_sysnbr
                  "xxiv_mstr.xxiv_domain = global_domain and xxiv_sysnbr"
                  xxiv_sysnbr xxiv_sysnbr xxiv_sysnbr}
          if recno <> ? then do:
          hide frame b.
          hide frame c.
          assign vsysnbr = xxiv_sysnbr.
          display xxiv_sysnbr
                xxiv_nbr xxiv_ref xxiv_bill xxiv_rmks xxiv_type xxiv_dept
                xxiv_slspsn xxiv_actype xxiv_date xxiv_promise_date
                xxiv_userid xxiv_audit xxiv_terms_days.
                find first cm_mstr no-lock where cm_domain = global_domain
                       and cm_addr = xxiv_bill no-error.
                if available cm_mstr then do:
                   display cm_sort @ vbillname with frame a.
                end.
                else do:
                   display '' @ vbillname with frame a.
                end.
                find first dpt_mstr no-lock where dpt_domain = global_domain
                       and dpt_dept = xxiv_dept no-error.
                if avail dpt_mstr then do:
                  display dpt_desc @ dptdesc with frame a.
                end.
                else do:
                  display "" @ dptdesc with frame a.
                end.
              end.
              else do:
                   vsysnbr = "".
              end.
        clear frame c all no-pause.
        assign vsysnbr = xxiv_sysnbr:screen-value
               rec-cnt = 0.
        for each xxivd_det no-lock
                where xxivd_det.xxivd_domain = global_domain and
                xxivd_sysnbr = vsysnbr
        by xxivd_sysnbr by xxivd_sonbr:
             display
                xxivd_det.xxivd_sonbr
                xxivd_det.xxivd_confim_amt
                xxivd_plan_amt
                xxivd_det.xxivd_rmks
             with frame c.
             down with frame c.
             rec-cnt = rec-cnt + 1.
             if rec-cnt > 7 then  leave.
        end. /* for each xxivd_det */
/*        next-prompt xxiv_sysnbr with frame a.    */
     end. /* PROMPT-FOR...EDITING */

        /* ADD/MOD/DELETE  */
      if input xxiv_sysnbr = "" then do:
          {pxmsg.i &MSGTEXT=""发票系统号不可以为空"" &ERRORLEVEL=3}
          undo,retry.
          next-prompt xxiv_sysnbr with frame a.
      end.
      find xxiv_mstr exclusive-lock where
           xxiv_sysnbr = input xxiv_sysnbr and xxiv_domain = global_domain
           no-error.
      if not available xxiv_mstr then do:
         {mfmsg.i 1 1}
         create xxiv_mstr.
         assign xxiv_sysnbr
                xxiv_domain = global_domain.
      end.
      else do:
        assign xxiv_nbr xxiv_ref xxiv_bill xxiv_rmks xxiv_type xxiv_dept
              xxiv_slspsn xxiv_actype xxiv_date xxiv_promise_date
              xxiv_userid xxiv_audit xxiv_terms_days.
      end.
      find first cm_mstr no-lock where cm_domain = global_domain and
                 cm_addr = xxiv_bill no-error.
      if available cm_mstr then do:
         display cm_sort @ vbillname with fram a.
      end.
      else do:
         display '' @ vbillname with fram a.
      end.

        /* STORE MODIFY DATE AND USERID */
        display xxiv_nbr xxiv_ref xxiv_bill xxiv_rmks xxiv_type xxiv_dept
                xxiv_slspsn xxiv_actype xxiv_date xxiv_promise_date
                xxiv_userid xxiv_audit xxiv_terms_days.

        ststatus = stline[2].
        status input ststatus.
        del-yn = no.

        setpac: do on error undo, retry:
            set xxiv_nbr xxiv_ref xxiv_bill xxiv_rmks xxiv_type xxiv_dept
                xxiv_slspsn xxiv_actype xxiv_date xxiv_promise_date
                xxiv_userid xxiv_audit xxiv_terms_days go-on("F5" "CTRL-D").

           /* DELETE */
       if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
       then do:
          if can-find (first xxivd_det where xxivd_sysnbr = input xxiv_sysnbr)
          then do:
             {mfmsg.i 196 4}
             /*ERROR: REQUISITION EXISTS WITH THIS APPROVAL CODE*/
             undo, retry.
          end.
          del-yn = no .
          {mfmsg01.i 11 1 del-yn}
          if not del-yn then undo, retry.
              delete xxiv_mstr.
              clear frame a.
              del-yn = no.
          end.
      end. /* ELSE DO (I.E. IF NOT F5 OR CTRL-D) */
      hide frame a.

      clear frame c all no-pause.
      hide frame c.
      view frame c.
      rec-cnt = 0.
      for each xxivd_det no-lock
              where xxivd_det.xxivd_domain = global_domain and
              xxivd_sysnbr = vsysnbr
      by xxivd_sysnbr by xxivd_sonbr:
           display
              xxivd_det.xxivd_sonbr
              xxivd_det.xxivd_confim_amt
              xxivd_det.xxivd_plan_amt
              xxivd_det.xxivd_rmks
           with frame c.
           down with frame c.
           rec-cnt = rec-cnt + 1.
           if rec-cnt > 7 then  leave.
      end. /* for each xxivd_det */

repeat with frame b:
{&ADSTMT-P-TAG1}
form
   skip
   xxivd_sysnbr      colon 14
   xxivd_sonbr       colon 48
   xxivd_act_amt     colon 14
   xxivd_ivtaxamt    colon 48
   xxivd_close_amt   colon 14
   xxivd_cfora_amt   colon 48
   xxivd_open_amt    colon 14
   xxivd_plan_amt    colon 14
   xxivd_confim_amt  colon 48
   xxivd_rmks        colon 14
with frame b title "发票明细维护" side-labels width 80 attr-space.

{&ADSTMT-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
 view frame b.
/*************************************************************/
  display xxiv_sysnbr @ xxivd_sysnbr with frame b.
  prompt-for xxivd_sonbr editing:
           /* FIND NEXT/PREVIOUS RECORD */
     {mfnp01.i xxivd_det xxivd_sonbr
              "xxivd_det.xxivd_domain = global_domain and xxivd_sonbr"
               xxivd_sysnbr xxiv_sysnbr xxivd_sys_so}

    if recno <> ? then
    display xxivd_sysnbr xxivd_sonbr
            xxivd_act_amt xxivd_ivtaxamt xxivd_close_amt
            xxivd_open_amt xxivd_cfora_amt xxivd_rmks
            xxivd_plan_amt xxivd_confim_amt.
  end. /* PROMPT-FOR...EDITING */

        /* ADD/MOD/DELETE  */
   if input xxivd_sonbr = "" then do:
       {pxmsg.i &MSGNUM=715 &ERRORLEVEL=2 }
      /* {pxmsg.i &MSGTEXT=""内部订单号不可以为空"" &ERRORLEVEL=3} */
       undo,retry.
       next-prompt xxivd_sysnbr with frame b.
   end.
   find xxivd_det exclusive-lock where xxivd_domain = global_domain and
        xxivd_sysnbr = input xxiv_sysnbr and
        xxivd_sonbr = input xxivd_sonbr no-error.
      if not available xxivd_det then do:
         {mfmsg.i 1 1}
         create xxivd_det.
         assign xxivd_domain = global_domain
                xxivd_sysnbr = input xxiv_sysnbr
                xxivd_sonbr.
      end.
     else do:
        assign  xxivd_sysnbr xxivd_sonbr xxivd_act_amt xxivd_ivtaxamt
                xxivd_close_amt xxivd_cfora_amt xxivd_open_amt
                xxivd_plan_amt xxivd_confim_amt xxivd_rmks.
     end.

      /* STORE MODIFY DATE AND USERID */
      display xxivd_sysnbr xxivd_sonbr xxivd_act_amt xxivd_ivtaxamt
              xxivd_close_amt xxivd_cfora_amt xxivd_open_amt
              xxivd_plan_amt xxivd_confim_amt xxivd_rmks.

      ststatus = stline[2].
      status input ststatus.
      del-yn = no.

      setpac: do on error undo, retry:
          set xxivd_act_amt xxivd_ivtaxamt xxivd_close_amt xxivd_cfora_amt
              xxivd_open_amt xxivd_plan_amt xxivd_confim_amt xxivd_rmks
              go-on("F5" "CTRL-D").

     /* DELETE */
     if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
     then do:
        del-yn = no .
        {mfmsg01.i 11 1 del-yn}
        if not del-yn then undo, retry.
            delete xxivd_det.
            clear frame b.
            del-yn = no.
        end.
    end. /* ELSE DO (I.E. IF NOT F5 OR CTRL-D) */

      clear frame c all no-pause.
      rec-cnt = 0.
      for each xxivd_det no-lock
              where xxivd_det.xxivd_domain = global_domain and
              xxivd_sysnbr = vsysnbr
      by xxivd_sysnbr by xxivd_sonbr:
           display
              xxivd_det.xxivd_sonbr
              xxivd_det.xxivd_confim_amt
              xxivd_det.xxivd_plan_amt
              xxivd_det.xxivd_rmks
           with frame c.
           down with frame c.
           rec-cnt = rec-cnt + 1.
           if rec-cnt > 7 then  leave.
      end.  /* for each xxivd_det */
end.        /* repeat with frame b:*/
hide frame c.
hide frame b.
end.  /* MAINLOOP: REPEAT with frame a: */
status input.
