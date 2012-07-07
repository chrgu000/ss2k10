/* xxwold0.p - wowomt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{xxwold.i}
define variable txt as character.
empty temp-table xxwo no-error.
input from value(flhload).
repeat:
    import unformat txt.
    find first xxwo exclusive-lock where xxwo_lot = trim(entry(1,txt,",")) no-error.
    if not available xxwo then do:
       create xxwo.
       assign xxwo_lot = trim(entry(1,txt,",")) no-error.
    end.
    assign xxwo_rel_date = trim(entry(2,txt,",")) no-error.
    assign xxwo_due_date = trim(entry(3,txt,","))  no-error.
end.
input close.

for each xxwo exclusive-lock :
      if xxpt_part <= "" or xxpt_part >= "ZZZZZZZZ" then do:
         delete xxwo.
      end.
      else do:
         assign xxpt_chk = "".
      end.
end.

/* check data */
for each xxwo exclusive-lock:
    find first wo_mstr no-lock where wo_lot = xxwo_lot no-error.
    if available wo_mstr then do:
      /* PREVENT ACCESS TO PROJECT ACTIVITY RECORDING WORKORDERS */
         if wo_fsm_type = "PRM" then do:
            assign xxpt_chk = getMsg(3426).
            /* CONTROLLED BY PRM MODULE */
         end.
         /* PREVENT ACCESS TO CALL ACTIVITY RECORDING WORK ORDERS */
         if wo_fsm_type = "FSM-RO" then do:
            assign xxpt_chk = getMsg(7492).
            /* FIELD SERVICE CONTROLLED.  */
         end.
         if wo_type = "c" and wo_nbr = "" then do:
            assign xxpt_chk = getMsg(5123).
            /* WORK ORDER TYPE IS CUMULATIVE */
         end.
         assign xxwo_orel_date = wo_rel_date
                xxwo_odue_date = wo_due_date.
    end.
    else do:
          assign xxpt_chk = getMsg(510).
    end.
end.
