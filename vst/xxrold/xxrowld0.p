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
define variable v_new like ro_wkctr.
define variable v_old like ro_wkctr.
define temp-table xxtr
			 fields xxtr_routing like ro_routing
			 fields xxtr_op			 like ro_op
			 fields xxtr_wkctrn  like ro_wkctr label "new"
			 fields xxtr_wkctro  like ro_wkctr label "old".
empty temp-table xxro no-error.
empty temp-table xxtr no-error.
assign i = 0.
input from value(flhload).
repeat:
    assign v_routing = ""
           v_op = 0.
    import unformat txt.
    if i <> 0 then do:
   		 assign v_routing = trim(entry(1,txt,",")) no-error.
       assign v_op = integer(trim(entry(2,txt,","))) no-error.
       assign v_new = trim(entry(3,txt,",")) no-error.
       assign v_old = trim(entry(4,txt,",")) no-error.
       if v_routing <> "" and v_op <> 0 and v_new <> v_old then do:
       		create xxtr.
       		assign xxtr_routing = v_routing
       					 xxtr_op = v_op
       					 xxtr_wkctrn = v_new
       					 xxtr_wkctro = v_old.
       end.
    end.
    i = i + 1.
end.
input close.

for each xxtr no-lock where xxtr_routing > "" and xxtr_routing <= "ZZZZZZZZZZ":
		for each ro_det no-lock where ro_routing = xxtr_routing and
						 ro_op = xxtr_op and (ro_start <= today or ro_start = ?) 
		    break by ro_routing by ro_op by ro_start:
		    if last-of(ro_op) then do:
		    	 /* 失效旧的 */
  	       create xxro.
           assign xxro_routing = ro_routing no-error.
           assign xxro_op = ro_op no-error.
           assign xxro_start = ro_start no-error.
           assign xxro_end = today - 1.
           assign xxro_wkctr = ro_wkctr no-error.
           assign xxro_mch  = ro_mch no-error.
           assign xxro_desc  = ro_desc no-error.
           assign xxro_run  = ro_run no-error.
           /* 生效新的 */
           create xxro.
           assign xxro_routing = ro_routing no-error.
           assign xxro_op = ro_op no-error.
           assign xxro_start = today no-error.
           assign xxro_wkctr = xxtr_wkctrn no-error.
           assign xxro_mch  = ro_mch no-error.
           assign xxro_desc  = ro_desc no-error.
           assign xxro_run  = ro_run no-error.
		    end.
		end.
end.

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
