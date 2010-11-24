/* xxcmarmt.p - dcsdata Mantence                                              */

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}
{cxcustom.i "xxcmarmt.p"}

define variable del-yn  like mfc_logical initial no.
define variable dptdesc like dpt_desc.
define variable csdesc  like ad_sort label "¿Í»§Ãû³Æ".
/* DISPLAY SELECTION FORM */
form
   xxar_sysnbr   colon 24 skip
   xxar_ivnbr    colon 25
   xxar_rcnbr    colon 60
   xxar_rc_amt   colon 24
   xxar_slsid    colon 60
   xxar_dept     colon 24 dptdesc no-label
   xxar_date     colon 24
   xxar_bdate    colon 60
   xxar_close_cs colon 24 csdesc no-label
   xxar_bill     colon 24
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:
   prompt-for xxar_sysnbr editing:
      {mfnp.i xxar_hst xxar_sysnbr xxar_sysnbr
              xxar_sysnbr xxar_sysnbr xxar_sysnbr}
     if recno <> ? then do:
         find first dpt_mstr no-lock where dpt_dept = xxar_dept no-error.
         if avail dpt_mstr then do:
            assign dptdesc = dpt_desc.
         end.
         else do:
            assign dptdesc = "".
         end.
         find first cm_mstr no-lock where
                    cm_addr = xxar_close_cs no-error.
         if avail cm_mstr then do:
            assign csdesc = cm_sort.
         end.
         else do:
            assign csdesc = "".
         end.
         display xxar_sysnbr xxar_ivnbr xxar_rcnbr xxar_rc_amt xxar_slsid
                 xxar_dept dptdesc xxar_date xxar_bdate xxar_close_cs
                 csdesc xxar_bill.
     end.
   end.

   /* ADD/MOD/DELETE  */
   find xxar_hst using xxar_sysnbr where
        xxar_sysnbr = input xxar_sysnbr no-error.
   if not available xxar_hst then do:
      {mfmsg.i 1 1}
      create xxar_hst.
      assign xxar_sysnbr.
   end.
   assign xxar_ivnbr xxar_rcnbr xxar_rc_amt xxar_slsid xxar_dept xxar_date
          xxar_bdate xxar_close_cs xxar_bill.
   recno = recid(xxar_hst).
   find first dpt_mstr no-lock where dpt_dept = xxar_dept no-error.
   if avail dpt_mstr then do:
      assign dptdesc = dpt_desc.
   end.
   else do:
      assign dptdesc = "".
   end.
   find first cm_mstr no-lock where
              cm_addr = xxar_close_cs no-error.
   if avail cm_mstr then do:
      assign csdesc = cm_sort.
   end.
   else do:
      assign csdesc = "".
   end.
   display xxar_sysnbr xxar_ivnbr xxar_rcnbr xxar_rc_amt xxar_slsid
           xxar_dept dptdesc xxar_date xxar_bdate xxar_close_cs
           csdesc xxar_bill.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
      set xxar_ivnbr xxar_rcnbr xxar_rc_amt xxar_slsid xxar_dept xxar_date
          xxar_bdate xxar_close_cs xxar_bill go-on("F5" "CTRL-D" ).
       find first dpt_mstr no-lock where dpt_dept = xxar_dept no-error.
       if avail dpt_mstr then do:
          assign dptdesc = dpt_desc.
       end.
       else do:
          assign dptdesc = "".
       end.
       find first cm_mstr no-lock where
                  cm_addr = xxar_close_cs no-error.
       if avail cm_mstr then do:
          assign csdesc = cm_sort.
       end.
       else do:
          assign csdesc = "".
       end.
       display xxar_sysnbr xxar_ivnbr xxar_rcnbr xxar_rc_amt xxar_slsid
               xxar_dept dptdesc xxar_date xxar_bdate xxar_close_cs
               csdesc xxar_bill.
      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete xxar_hst.
         clear frame a.
         del-yn = no.
      end.
   end.
end.
status input.
