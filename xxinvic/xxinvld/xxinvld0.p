/* xxinvld.p - 日供发票导入，可以提示错误，读入并检查资料                    */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

{xxinvld.i}
define variable vtax as character.
define variable verr as character.
empty temp-table tmpinv no-error.
input from value(flhload).
repeat:
  create tmpinv.
  import tmpinv no-error.
end.
input close.

for each tmpinv exclusive-lock:
    if tiv_vend = "" then do:
       delete tmpinv.
    end.
end.

for each tmpinv exclusive-lock break by tiv_vend by tiv_draw:
    if first-of(tiv_draw) then do:
       assign verr = "".
       if not can-find(first vd_mstr no-lock where vd_addr = tiv_vend) then do:
          assign verr = "供应商未找到".
       end.
       if tiv_tax = yes then do:
          assign vtax = "P".
       end.
       else do:
          assign vtax = "M".
       end.
       find first vp_mstr 
                use-index vp_vend_part
                where vp_vend = tiv_vend 
                and   vp_vend_part = tiv_draw 
                and  (( vp_part begins "M" and tiv_tax = no )
                      or
                      ( vp_part begins "P" and tiv_tax = yes ))
            no-lock no-error.
            if not available vp_mstr then do:
                assign verr = "错误:零件图号不正确."  . 
            end.
    end.
    if verr <> "" then assign tiv_chk = verr.
end.