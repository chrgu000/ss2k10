/* xxpoprap1.i - PURCHASE REQUISITION APPROVAL (FIRST LEVEL) INCLUDED FILE */
/* COPYRIGHT karrie.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 8.5G           CREATED: 06/27/06     BY: hkm *060627*         */


           ststatus = stline[1].
           status input ststatus.
           readkey.
           hide message no-pause.

           /* FIND NEXT RECORD */
           if lastkey = keycode("F10")
           or keyfunction(lastkey) = "CURSOR-DOWN"
           then do:
             if recno = ? then
             find first req_det where req_nbr > input rqnbr
             and ({1} = {3} or {2} = {3})
             and ({4} = {6} or {5} = {3})
             and (req_request = request or request = "")
             and (pmc_grp = ""
               or (pmc_grp <> ""
               and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
               and not (not(req_request begins "ycm"
               or req_request begins "yc3")))
               or (not (pmc_grp begins "ycm" or pmc_grp begins "yc3")
               and can-find(first usrw_wkfl where usrw_key2 = req_request
               and usrw_key1 = "PMC." + pmc_grp)))))
             use-index req_nbr no-lock no-error.
             
             else
             find next req_det
             where ({1} = {3} or {2} = {3})
             and ({4} = {6} or {5} = {3})
             and (req_request = request or request = "")
             and (pmc_grp = ""
               or (pmc_grp <> ""
               and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
               and not (not(req_request begins "ycm"
               or req_request begins "yc3")))
               or (not (pmc_grp begins "ycm" or pmc_grp begins "yc3")
               and can-find(first usrw_wkfl where usrw_key2 = req_request
               and usrw_key1 = "PMC." + pmc_grp)))))
             use-index req_nbr no-lock no-error.

             if not available req_det then do:
               {mfmsg.i 20 2} /* End of file*/
               if recno <> ? then
               find req_det where recid(req_det) = recno
               no-lock no-error.
               else
               find last req_det
               where ({1} = {3} or {2} = {3})
               and ({4} = {6} or {5} = {3})
               and (req_request = request or request = "")
               and (pmc_grp = ""
                 or (pmc_grp <> ""
                 and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
                 and not (not(req_request begins "ycm"
                 or req_request begins "yc3")))
                 or (not(pmc_grp begins "ycm" or pmc_grp begins "yc3")
                 and can-find(first usrw_wkfl where usrw_key2 = req_request
                 and usrw_key1 = "PMC." + pmc_grp)))))
               use-index req_nbr no-lock no-error.
               input clear.
             end.
             recno = recid(req_det).
           end.
           
           /* FIND PREVIOUS RECORD  */
           else
           if lastkey = keycode("F9")
           or keyfunction(lastkey) = "CURSOR-UP"
           then do:
             if recno = ? then
             find last req_det where req_nbr < input rqnbr
             and ({1} = {3} or {2} = {3})
             and ({4} = {6} or {5} = {3})
             and (req_request = request or request = "")
             and (pmc_grp = ""
               or (pmc_grp <> ""
               and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
               and not (not(req_request begins "ycm"
               or req_request begins "yc3")))
               or (not(pmc_grp begins "ycm" or pmc_grp begins "yc3")
               and can-find(first usrw_wkfl where usrw_key2 = req_request
               and usrw_key1 = "PMC." + pmc_grp)))))
             use-index req_nbr no-lock no-error.
         
             else
             find prev req_det
             where ({1} = {3} or {2} = {3})
             and ({4} = {6} or {5} = {3})
             and (req_request = request or request = "")
             and (pmc_grp = ""
               or (pmc_grp <> ""
               and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
               and not (not(req_request begins "ycm"
               or req_request begins "yc3")))
               or (not (pmc_grp begins "ycm" or pmc_grp begins "yc3")
               and can-find(first usrw_wkfl where usrw_key2 = req_request
               and usrw_key1 = "PMC." + pmc_grp)))))
             use-index req_nbr no-lock no-error.
                                           
             if not available req_det then do:
               {mfmsg.i 21 2} /* Beginning of file */
               if recno <> ? then
               find req_det where recid(req_det) = recno
               no-lock no-error.
               else
               find first req_det
               where ({1} = {3} or {2} = {3})
               and ({4} = {6} or {5} = {3})
               and (req_request = request or request = "")
               and (pmc_grp = ""
                 or (pmc_grp <> ""
                 and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
                 and not (not(req_request begins "ycm"
                 or req_request begins "yc3")))
                 or (not (pmc_grp begins "ycm" or pmc_grp begins "yc3")
                 and can-find(first usrw_wkfl where usrw_key2 = req_request
                 and usrw_key1 = "PMC." + pmc_grp)))))
               use-index req_nbr no-lock no-error.
               input clear.
             end.
             recno = recid(req_det).
           end.
           
           /* INPUT PROMPT FIELD */
           else do:
             recno = ?.
             if keyfunction(lastkey) = "end-error" then do:
               ststatus = stline[3].
               status input ststatus.
             end.
             apply lastkey.
           end.
