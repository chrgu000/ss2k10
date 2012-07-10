/* xxwold0.p - wowomt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{xxwold.i}
define variable txt as character.
define variable vdte as character.
empty temp-table xxwoload no-error.
input from value(flhload).
repeat:
    import unformat txt.
    find first xxwoload exclusive-lock where xxwo_lot = trim(entry(1,txt,",")) no-error.
    if not available xxwoload then do:
       create xxwoload.
       assign xxwo_lot = trim(entry(1,txt,",")) no-error.
    end.
    find first wo_mstr no-lock where wo_lot = xxwo_lot no-error.
    if available wo_mstr then do:
    	 assign xxwo_orel_date = wo_rel_date
    	 			  xxwo_odue_date = wo_due_date.
    end.
    assign vdte = trim(entry(2,txt,",")).
    if vdte = "" or vdte = "-" then do:
   	   assign xxwo_rel_date = wo_rel_date when available wo_mstr.
    end.
    else if vdte <> ? then do:
       assign xxwo_rel_date = date(integer(substring(vdte,1,2)),
                                   integer(substring(vdte,4,2)),
                            2000 + integer(substring(vdte,7,2))) no-error.
    end.
    assign vdte = trim(entry(3,txt,",")).
    if vdte = "" or vdte = "-" then do:
   	   assign xxwo_due_date = wo_due_date when available wo_mstr.
    end.
    else if vdte <> ? then do:
    assign xxwo_due_date = date(integer(substring(vdte,1,2)),
                                integer(substring(vdte,4,2)),
                         2000 + integer(substring(vdte,7,2))) no-error.
    end.
end.
input close.

for each xxwoload exclusive-lock :
      if xxwo_lot <= "" or xxwo_lot >= "ZZZZZZZZ" then do:
         delete xxwoload.
      end.
      else do:
         assign xxwo_chk = "".
      end.
end.

/* check data */
for each xxwoload exclusive-lock:
    find first wo_mstr no-lock where wo_lot = xxwo_lot no-error.
    if available wo_mstr then do:
      /* PREVENT ACCESS TO PROJECT ACTIVITY RECORDING WORKORDERS */
         if wo_fsm_type = "PRM" then do:
            assign xxwo_chk = getMsg(3426).
            /* CONTROLLED BY PRM MODULE */
         end.
         /* PREVENT ACCESS TO CALL ACTIVITY RECORDING WORK ORDERS */
         if wo_fsm_type = "FSM-RO" then do:
            assign xxwo_chk = getMsg(7492).
            /* FIELD SERVICE CONTROLLED.  */
         end.
         if wo_type = "c" and wo_nbr = "" then do:
            assign xxwo_chk = getMsg(5123).
            /* WORK ORDER TYPE IS CUMULATIVE */
         end.
         if wo_status = "C" or wo_status = "P" then do:
            assign xxwo_chk = getMsg(19).
         end.
         if xxwo_rel_date > xxwo_due_date then do:
         		assign xxwo_chk = getMsg(514).
         end.
    end.
    else do:
          assign xxwo_chk = getMsg(510).
    end.
end.
