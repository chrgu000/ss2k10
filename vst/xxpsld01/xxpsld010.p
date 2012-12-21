/* xxptld.p - ppptmt.p cim load                                                */
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
    assign xxpt_site = trim(entry(2,txt,",")) no-error.
    assign xxpt_loc = trim(entry(3,txt,","))  no-error.
    assign xxpt_abc = trim(entry(4,txt,","))  no-error.
    assign xxpt_stat  = trim(entry(5,txt,",")) no-error.
end.
input close.

for each xxtmppt exclusive-lock :
			if xxpt_site = "" or xxpt_site = "-" then assign xxpt_site = "vst2".
      if xxpt_part <= "" or xxpt_part >= "ZZZZZZZZ" then do:
         delete xxtmppt.
      end.
      else do:
         assign xxpt_chk = "".
      end.
end.

/* check data */
for each xxtmppt exclusive-lock:
    find first in_mstr no-lock where in_part = xxpt_part 
    		and in_site = xxpt_site no-error.
    if available in_mstr then do:
       assign xxpt_osite = in_site
              xxpt_oabc = in_abc
              .
       if xxpt_site = "-" then xxpt_site = in_site.
       if xxpt_abc = "-" then xxpt_abc = in_abc.
       find first pt_mstr no-lock where pt_part = xxpt_part no-error.
       if available pt_mstr then do:
     			assign xxpt_oloc = pt_loc
                 xxpt_ostat = pt_status.
          if xxpt_loc = "-" then xxpt_loc = pt_loc.
          if xxpt_stat = "-" then xxpt_stat = pt_status.
       end.
       else do:
       		assign xxpt_chk = getMsg(17).
       end.
    end.
    else do:
          assign xxpt_chk = getMsg(17).
    end.
    if xxpt_site <> "-" then do:
       find first si_mstr no-lock where si_site = xxpt_site no-error.
       if not available si_mstr then do:
          assign xxpt_chk = getMsg(2797).
       end.
       else do:
            if xxpt_loc <> "-" then do:
               find first loc_mstr no-lock where loc_site = xxpt_site and
                          loc_loc = xxpt_loc no-error.
               if not available loc_mstr then do:
                  assign xxpt_chk = getMsg(229).
               end.
            end.
       end.
    end.
    if xxpt_abc <> "-" then do:
       find first code_mstr no-lock where code_fldname = "pt_abc"
              and code_value = xxpt_abc no-error.
       if not available code_mstr then do:
          assign xxpt_chk = "ABC" + getMsg(716).
       end.
    end.
    if xxpt_stat <> "-" then do:
       find first qad_wkfl no-lock where qad_key1 = "pt_status"
              and qad_key2 = xxpt_stat no-error.
       if not available qad_wkfl then do:
          assign xxpt_chk = getMsg(362).
       end.
    end.
end.
