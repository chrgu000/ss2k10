/* xxptstld.p - ppptmt.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{xxptld.i}
define variable txt as character.
empty temp-table xxtmppt no-error.
input from value(flhload).
repeat:
    import unformat txt.
    find first xxtmppt exclusive-lock where xxpt_part = trim(entry(1,txt,",")) no-error.
    if not available xxtmppt then do:
       create xxtmppt.
       assign xxpt_part = trim(entry(1,txt,",")) no-error.
    end.
    assign xxpt_stat  = trim(entry(2,txt,",")) no-error.
    assign xxpt_site = "-".
    assign xxpt_loc =  "-".
    assign xxpt_abc =  "-".
end.
input close.

for each xxtmppt exclusive-lock :
      if xxpt_part <= "" or xxpt_part >= "ZZZZZZZZ" then do:
         delete xxtmppt.
      end.
      else do:
         assign xxpt_chk = "".
      end.
end.

/* check data */
for each xxtmppt exclusive-lock:
    find first pt_mstr no-lock where pt_part = xxpt_part no-error.
    if available pt_mstr then do:
       assign xxpt_ostat = pt_status.
    end.
    else do:
          assign xxpt_chk = getMsg(17).
    end.
    if xxpt_stat <> "-" then do:
       find first qad_wkfl no-lock where qad_key1 = "pt_status"
              and qad_key2 = xxpt_stat no-error.
       if not available qad_wkfl then do:
          assign xxpt_chk = getMsg(362).
       end.
    end.
end.
