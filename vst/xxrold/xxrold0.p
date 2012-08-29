/* xxrold.p - rwromt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxrold.i}
{xxloaddata.i}
define variable txt as character.
define variable v_routing like ro_routing.
define variable v_op like ro_op.
empty temp-table xxro no-error.
assign i = 0.
input from value(flhload).
repeat:
    assign v_routing = ""
           v_op = 0.
    import unformat txt.
    if i <> 0 then do:
       assign v_routing = trim(entry(1,txt,",")) no-error.
       assign v_op = integer(trim(entry(2,txt,","))) no-error.
       if v_routing <> "" and v_op <> 0 then do:
          for each ro_det no-lock where ro_routing = v_routing
               and ro_op = v_op and ro_start <= today - 1
          break by ro_routing by ro_start:
               if last-of(ro_routing)
                     and (ro_end > today - 1 or ro_end = ?) then do:
                  create xxro.
                  assign xxro_routing = ro_routing no-error.
                  assign xxro_op = ro_op no-error.
                  assign xxro_start = ro_start no-error.
                  assign xxro_end = today - 1.
                  assign xxro_wkctr = ro_wkctr no-error.
                  assign xxro_mch  = ro_mch no-error.
                  assign xxro_desc  = ro_desc no-error.
                  assign xxro_run  = ro_run no-error.
               end.
          end.
          create xxro.
          assign xxro_routing = v_routing no-error.
          assign xxro_op = v_op no-error.
          assign xxro_start = today no-error.
          assign xxro_wkctr = trim(entry(4,txt,",")) no-error.
          assign xxro_mch  = trim(entry(5,txt,",")) no-error.
          assign xxro_desc  = trim(entry(3,txt,",")) no-error.
          assign xxro_run  = dec(trim(entry(6,txt,","))) no-error.
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
       assign xxro_sn = i
              xxro_chk = "".
    end.
    i = i + 1.
end.
i = i - 1.
/* check data */
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
