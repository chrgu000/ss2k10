/* xxinvld.p - �չ���Ʊ���룬������ʾ���󣬶��벢�������                    */
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
          assign verr = "��Ӧ��δ�ҵ�".
       end.
       if tiv_tax = "Y" then do:
          assign vtax = "P".
       end.
       else do:
          assign vtax = "M".
       end.
       if not can-find(first pt_mstr where pt_part begins vtax and
                             pt_draw = tiv_draw) then do:
          assign verr = "�Ϻ�/ͼ��δά��".
       end.
    end.
    if verr <> "" then assign tiv_chk = verr.
end.