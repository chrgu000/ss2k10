/* xxpold1.p - check data                                                    */
{mfdeclre.i}
{xxpold.i}
define variable vfile as character.
define variable vtmp as character.
define variable vpods like mfc_logical no-undo.
define variable vpos like mfc_logical  no-undo.
define stream bf.
for each xxpod9 exclusive-lock where x9_chk = "" break by x9_nbr by x9_line:
    if first-of(x9_nbr) then do:
       assign vpos = no.
    end.
    find first pod_det no-lock where pod_domain = global_domain
          and pod_nbr = x9_nbr and pod_line = x9_line no-error.
    if available pod_det then do:
       assign vpods = yes
              vpos = yes.
    end.
    else do:
       assign vpods = no.
       find first po_mstr no-lock where po_domain = global_domain
              and po_nbr = x9_nbr no-error.
       if available po_mstr then do:
          assign vpos = yes.
       end.
    end.
/*  if first-of(x9_nbr) then do:                                          */
       assign vfile = execname + "-" + x9_nbr + "-" + string(x9_line).
       output stream bf close.
       output stream bf to value(vfile + ".bpi").
       put stream bf unformat '"' x9_nbr '"' skip.
       put stream bf unformat '"' x9_vend '"' skip.
       put stream bf unformat '"' x9_ship '"' skip.
       if vpos then do:
          put stream bf unformat '-' skip.
       end.
       else do:
           put stream bf unformat '- ' x9_due_date ' "' x9_buyer '" - - - - '.
           if x9_rmks = "-" then
               put stream bf unformat '- '.
           else
               put stream bf unformat '"' x9_rmks '" '.
           put stream bf unformat '"' x9_pr_list2 '" '.
           put stream bf unformat '"' x9_pr_list '" - ' x9_site ' - - - - - - - - - - - - N' skip.
       end.
       put stream bf '-' skip. /*tax*/
       find first vd_mstr no-lock where vd_domain = global_domain and vd_addr = x9_vend no-error.
       if available vd_mstr then do:
          find first en_mstr no-lock where en_domain = global_domain no-error.
          if vd_curr <> en_curr then do:
             put stream bf '-' skip. /*非本位币*/
          end.
       end.
       put stream bf unformat '.' skip.
       put stream bf unformat 'S' skip.
/*  end. /* if first-of(x9_nbr) then do: */                                */
    assign x9_fn = vfile.
    /* detail */
    put stream bf unformat x9_line skip.
    put stream bf unformat x9_site skip.
    if not vpods then do:
        put stream bf unformat '-' skip.
        put stream bf unformat '"' x9_part '"' skip.
    end.
    put stream bf unformat x9_qty_ord skip.
    put stream bf unformat '-' skip.  /*成本*/
    put stream bf unformat '-' skip.  /*明细项*/
    put stream bf unformat '-' skip. /*税*/
    put stream bf unformat x9_qty_fc1 ' ' x9_qty_fc2 skip.  /*预测量1 2*/
/*  if last-of(x9_nbr) then do:                                        */
       put stream bf unformat '.' skip.
       put stream bf unformat '.' skip.
       put stream bf unformat '-' skip.
       put stream bf unformat '-' skip.
       put stream bf unformat '.' skip.
       output stream bf close.
      cimrunprogramloop:
       do transaction:
          pause 0 before-hide.
          batchrun = yes.
          input from value(vfile + ".bpi").
          output to value(vfile + ".bpo") keep-messages.
          hide message no-pause.
          {gprun.i ""xxpopomt.p""}
           hide message no-pause.
           output close.
           input close.
           batchrun = no.
           pause before-hide.
           find first pod_det no-lock where pod_domain = global_domain
                  and pod_nbr = x9_nbr and pod_line = x9_line
                  and pod_part = x9_part and pod_qty_ord = x9_qty_ord
                  and pod__dec01 = x9_qty_fc1 and pod__dec02 = x9_qty_fc2 no-error.
           if not available pod_det then do:
              assign vtmp  = x9_fn + ".bpo"
                     vfile = "".
              {gprun.i ""xxgetcimerr.p"" "(input vtmp,output vfile)"}
              assign x9_chk = vfile.
           end.
           else do:
               assign x9_chk = "OK".
               os-delete value(x9_fn + ".bpi").
               os-delete value(x9_fn + ".bpo").
           end.
       end.

/*  end.                                                              */
end.

/************
for each xxpod9 exclusive-lock break by x9_nbr by x9_line descending:
    if first-of(x9_nbr) then assign vfile = "OK".
    find first pod_det no-lock where pod_domain = global_domain
           and pod_nbr = x9_nbr and pod_line = x9_line
           and pod_part = x9_part and pod_qty_ord = x9_qty_ord no-error.
    if not available pod_det then do:
       assign vfile = "Error".
    end.
    if last-of(x9_nbr) then do:
       assign x9_chk = vfile.
    end.
end.

for each xxpod9 exclusive-lock break by x9_nbr by x9_line:
    if first-of(x9_nbr) then do:
       if x9_chk = "error" then do:
          vtmp = x9_fn + ".bpo".
          {gprun.i ""xxgetcimerr.p"" "(input vtmp,output vfile)"}
       end.
       else do:
          vfile = x9_chk.
       end.
    end.
    else do:
       assign x9_chk = vfile.
    end.
    if last-of(x9_nbr) and x9_chk = "OK" then do:
       os-delete value(x9_fn + ".bpi").
       os-delete value(x9_fn + ".bpo").
    end.
end.
***************/