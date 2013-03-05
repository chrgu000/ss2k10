/* xxrold.p - rwromt.p cim load                                              */
/*V8:ConvertMode=Report                                                      */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxloaddata.i}
{xxroscld.i}
define variable txt as character.
define variable v_routing like ro_routing.
define variable v_op like ro_op.
define variable v_sub_cost like ro_sub_cost.
empty temp-table xxros no-error.
empty temp-table xxro no-error.
assign i = 0.
input from value(flhload).
repeat:
    assign v_routing = ""
           v_op = 0.
    import unformat txt.
    if i <> 0 then do:
       assign v_routing = trim(entry(1,txt,",")) no-error.
       assign v_sub_cost = Decimal(trim(entry(2,txt,","))) no-error.
       if v_routing <> "" and v_sub_cost <> 0 then do:
         create xxros.
         assign xxros_part = v_routing
                xxros_sub_cost = v_sub_cost.
          for each ro_det no-lock where ro_routing = v_routing
               and ro_op = 10 and ro_start <= today - 1
          break by ro_routing by ro_start:
               if last-of(ro_routing)
                     and (ro_end > today - 1 or ro_end = ?) then do:
                  create xxro.
                  assign xxro_routing = ro_routing no-error.
                  assign xxro_op = ro_op no-error.
                  assign xxro_wkctr = ro_wkctr no-error.
                  assign xxro_start = ro_start no-error.
                  assign xxro_sub_cost  = v_sub_cost no-error.
               end.
          end.
       end.
    end.
    i = i + 1.
end.
input close.

assign i = 1.
for each xxro exclusive-lock:
    if xxro_routing <= "" or xxro_routing >= "ZZZZZZZZ" then do:
       delete xxro.
    end.
    else do:
       assign xxro_sn = i.
    end.
    i = i + 1.
end.
/* check data
for each xxro exclusive-lock:
    if not can-find(first wc_mstr no-lock where wc_wkctr = xxro_wkctr) then do:
          assign xxro_chk = getMsg(739).
          next.
    end.
    find first wc_mstr no-lock where wc_wkctr = xxro_wkctr
           and wc_mch = xxro_mch no-error.
    if not available wc_mstr then do:
         assign xxro_chk = getMsg(528).
                next.
    end.
end.
*/