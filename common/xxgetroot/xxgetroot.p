define variable vitem like pt_part.
define buffer ps for ps_mstr.
for each usrw_wkfl exclusive-lock where usrw_key1 = "SORT-ITEM-GROUP-LIST":
    run getroot(input usrw_key2,output vitem).
    assign usrw_key3 = vitem.
end.

procedure getroot.
  define input parameter iitem like pt_part.
  define output parameter oroot like pt_part.

  find first ps_mstr no-lock where ps_mstr.ps_comp = iitem no-error.
  if available ps_mstr then do:
    find first ps no-lock where ps.ps_comp = ps_mstr.ps_par no-error.
    if not available ps then do:
       assign oroot = ps_mstr.ps_par.
       end.
       else do:
            run getroot (input ps_mstr.ps_par,output oroot).
       end.
  end.
  else do:
       assign oroot = iitem.
  end.
end procedure.
