/* 以下为版本历史 */                                                             
/* SS - 090927.1 By: Bill Jiang */

/*
{mfdeclre.i }
*/
define shared variable global_user_lang_dir like lng_mstr.lng_dir.
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 共享 */
{xxssirm2s.i}

VIEW FRAME w.
VIEW FRAME match_maintenance .

DO:
   {windo1u.i
      tt1 
      "
      tt1_index
      tt1_tr_part
      tt1_tr_effdate
      tt1_qty_open
      "
      "tt1_index"
      "use-index tt1_index" 
      yes
      " "
      " "
      }

   if keyfunction(lastkey) = "GO" then do:
      leave.
      ststatus = stline[2].
      status input ststatus.
   end.
   
   {windo1u1.i tt1_index}
END.
