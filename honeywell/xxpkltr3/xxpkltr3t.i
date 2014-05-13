      assign i = 0.
      for each tt1 exclusive-lock where tt1_sel = "*" and tt1_qty1 > 0:
          i = i + 1.
          assign fn = "TMP_" + execname + pklnbr + "." + string(i,"99999999").
          output stream bf to value(fn + ".bpi").
          put stream bf unformat '"' tt1_part '"' skip.
          put stream bf unformat trim(string(tt1_qty1)) ' - - "' tt1_site '" "' tt1_loc_from '" "' tt1_lot '" "' tt1_ref '"' skip.
          put stream bf unformat '"' tt1_pkl '" - "' rknbr '"'  skip.
          put stream bf unformat 'y' skip.
          put stream bf unformat '.' skip.
          output stream bf close.
          pause 0 before-hide.
          batchrun = yes.
          input from value(fn + ".bpi").
          output to value(fn + ".bpo") keep-messages.
          hide message no-pause.
          assign trrecid = current-value(tr_sq01).

          {gprun.i ""icunis.p""}
              yn = no.
              FIND FIRST tr_hist NO-LOCK WHERE tr_trnbr > integer(trrecid)
                  AND tr_nbr = tt1_pkl AND tr_part = tt1_part
                  AND tr_type = "ISS-UNP" AND tr_site = tt1_site
                  AND tr_loc = tt1_loc_from AND tr_serial = tt1_lot
                  and tr_ref = tt1_ref and tr_so_job = rknbr
                  AND tr_qty_loc = - tt1_qty1 NO-ERROR.
               IF AVAILABLE tr_hist THEN DO:
                   ASSIGN tt1_chk = "ok". /* "ISS-TR:[" + trim(string(tr_trnbr,">>>>>>>>>>>>>9")) + "]" */
                   assign yn = yes.
                   os-delete value(fn + ".bpi").
                   os-delete value(fn + ".bpo").
               END.

          if yn then tt1_chk = "ok". else tt1_chk = "err".
          hide message no-pause.
          output close.
          input close.
          batchrun = no.
          pause before-hide.
      end. /* for each tt1 */
