/* xxpoprap1.i - PURCHASE REQUISITION APPROVAL (FIRST LEVEL) INCLUDED FILE */
/* COPYRIGHT karrie.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 8.5G           CREATED: 06/27/06     BY: hkm *060627*         */
/* SSIVAN 07120201 BY:Ivan Yang Date:12/02/07  */

           ststatus = stline[1].
           status input ststatus.
           readkey.
           hide message no-pause.

           /* FIND NEXT RECORD */
           if lastkey = keycode("F10")
           or keyfunction(lastkey) = "CURSOR-DOWN"
           then do:
             if recno = ? then
/*SSIVAN 07120201 rmk*/        /*     find first req_det where req_nbr > input rqnbr	*/
/*SSIVAN 07120201 add*/        find first t_req_det where t_req_nbr > input rqnbr
	     and ({1} = {3} or {2} = {3})
             and ({4} = {6} or {5} = {6})
/*SSIVAN 07120201 rmk*/        /*     and (req_request = request or request = "")      */
/*SSIVAN 07120201 add*/        and (t_req_request = request or request = "")
             and (pmc_grp = ""
               or (pmc_grp <> ""
               and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/           /*    and not (not(req_request begins "ycm" */
/*SSIVAN 07120201 add*/ 	   and not (not(t_req_request begins "ycm"
/*SSIVAN 07120201 rmk*/           /*    or req_request begins "yc3")))	     */
/*SSIVAN 07120201 add*/ 	   or t_req_request begins "yc3")))
               or (not (pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/            /*   and can-find(first usrw_wkfl where usrw_key2 = req_request  */
/*SSIVAN 07120201 add*/ 	       and can-find(first usrw_wkfl where usrw_key2 = t_req_request
               and usrw_key1 = "PMC." + pmc_grp)))))
/*SSIVAN 07120201 rmk*/           /*  use-index req_nbr no-lock no-error. */
/*SSIVAN 07120201 add*/ 	      use-index i_req_nbr no-lock no-error.
             
             else
/*SSIVAN 07120201 rmk*/          /*   find next req_det	   */
/*SSIVAN 07120201 add*/ 	      find next t_req_det
             where ({1} = {3} or {2} = {3})
             and ({4} = {6} or {5} = {6})
/*SSIVAN 07120201 rmk*/           /*  and (req_request = request or request = "")     */
/*SSIVAN 07120201 add*/ 	      and (t_req_request = request or request = "")
             and (pmc_grp = ""
               or (pmc_grp <> ""
               and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/              /* and not (not(req_request begins "ycm"	  */
/*SSIVAN 07120201 add*/ 		and not (not(t_req_request begins "ycm"
/*SSIVAN 07120201 rmk*/              /* or req_request begins "yc3")))	 */
/*SSIVAN 07120201 add*/ 		or t_req_request begins "yc3")))
               or (not (pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/             /*  and can-find(first usrw_wkfl where usrw_key2 = req_request   */
/*SSIVAN 07120201 add*/ 		and can-find(first usrw_wkfl where usrw_key2 = t_req_request
               and usrw_key1 = "PMC." + pmc_grp)))))
/*SSIVAN 07120201 rmk*/           /*  use-index req_nbr no-lock no-error.   */
/*SSIVAN 07120201 add*/ 	      use-index i_req_nbr no-lock no-error.

/*SSIVAN 07120201 rmk*/            /* if not available req_det then do:	     */
/*SSIVAN 07120201 add*/ 	      if not available t_req_det then do:
               {mfmsg.i 20 2} /* End of file*/
               if recno <> ? then
/*SSIVAN 07120201 rmk*/            /*   find req_det where recid(req_det) = recno */
/*SSIVAN 07120201 add*/ 		find t_req_det where recid(t_req_det) = recno
               no-lock no-error.
               else
/*SSIVAN 07120201 rmk*/           /*    find last req_det       */
/*SSIVAN 07120201 add*/ 		find last t_req_det
               where ({1} = {3} or {2} = {3})
               and ({4} = {6} or {5} = {6})
/*SSIVAN 07120201 rmk*/            /*   and (req_request = request or request = "")  */
/*SSIVAN 07120201 add*/ 		and (t_req_request = request or request = "")
               and (pmc_grp = ""
                 or (pmc_grp <> ""
                 and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/            /*     and not (not(req_request begins "ycm"	    */
/*SSIVAN 07120201 add*/ 		  and not (not(t_req_request begins "ycm"
/*SSIVAN 07120201 rmk*/            /*     or req_request begins "yc3")))	   */
/*SSIVAN 07120201 add*/ 		  or t_req_request begins "yc3")))
                 or (not(pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/            /*     and can-find(first usrw_wkfl where usrw_key2 = req_request  */
/*SSIVAN 07120201 add*/ 		  and can-find(first usrw_wkfl where usrw_key2 = t_req_request
                 and usrw_key1 = "PMC." + pmc_grp)))))
/*SSIVAN 07120201 rmk*/            /*   use-index req_nbr no-lock no-error.  */
/*SSIVAN 07120201 add*/ 		use-index i_req_nbr no-lock no-error.
               input clear.
             end.
/*SSIVAN 07120201 rmk*/           /*  recno = recid(req_det).	   */
/*SSIVAN 07120201 add*/ 	      recno = recid(t_req_det).
           end.
           
           /* FIND PREVIOUS RECORD  */
           else
           if lastkey = keycode("F9")
           or keyfunction(lastkey) = "CURSOR-UP"
           then do:
             if recno = ? then
/*SSIVAN 07120201 rmk*/          /*   find last req_det where req_nbr < input rqnbr    */
/*SSIVAN 07120201 add*/ 	      find last t_req_det where t_req_nbr < input rqnbr
	     and ({1} = {3} or {2} = {3})
             and ({4} = {6} or {5} = {6})
/*SSIVAN 07120201 rmk*/          /*   and (req_request = request or request = "")     */
/*SSIVAN 07120201 add*/ 	      and (t_req_request = request or request = "")
             and (pmc_grp = ""
               or (pmc_grp <> ""
               and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/         /*      and not (not(req_request begins "ycm"	  */
/*SSIVAN 07120201 add*/ 		and not (not(t_req_request begins "ycm"
/*SSIVAN 07120201 rmk*/         /*      or req_request begins "yc3")))	       */
/*SSIVAN 07120201 add*/ 		or t_req_request begins "yc3")))
               or (not(pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/          /*     and can-find(first usrw_wkfl where usrw_key2 = req_request  */
/*SSIVAN 07120201 add*/ 		and can-find(first usrw_wkfl where usrw_key2 = t_req_request
               and usrw_key1 = "PMC." + pmc_grp)))))
/*SSIVAN 07120201 rmk*/          /*   use-index req_nbr no-lock no-error.    */
/*SSIVAN 07120201 add*/ 	      use-index i_req_nbr no-lock no-error.
         
             else
/*SSIVAN 07120201 rmk*/          /*   find prev req_det		 */
/*SSIVAN 07120201 add*/ 	      find prev t_req_det
             where ({1} = {3} or {2} = {3})
             and ({4} = {6} or {5} = {6})
/*SSIVAN 07120201 rmk*/          /*   and (req_request = request or request = "")   */
/*SSIVAN 07120201 add*/ 	      and (t_req_request = request or request = "")
             and (pmc_grp = ""
               or (pmc_grp <> ""
               and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/         /*      and not (not(req_request begins "ycm"	  */
/*SSIVAN 07120201 add*/ 		and not (not(t_req_request begins "ycm"
/*SSIVAN 07120201 rmk*/         /*      or req_request begins "yc3")))		  */
/*SSIVAN 07120201 add*/ 		or t_req_request begins "yc3")))	
               or (not (pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/          /*     and can-find(first usrw_wkfl where usrw_key2 = req_request  */
/*SSIVAN 07120201 add*/ 		and can-find(first usrw_wkfl where usrw_key2 = t_req_request
               and usrw_key1 = "PMC." + pmc_grp)))))
/*SSIVAN 07120201 rmk*/         /*    use-index req_nbr no-lock no-error.   */
/*SSIVAN 07120201 add*/ 	      use-index i_req_nbr no-lock no-error.
                                           
/*SSIVAN 07120201 rmk*/         /*    if not available req_det then do:	    */
/*SSIVAN 07120201 add*/ 	      if not available t_req_det then do:
               {mfmsg.i 21 2} /* Beginning of file */
               if recno <> ? then
/*SSIVAN 07120201 rmk*/         /*      find req_det where recid(req_det) = recno   */
/*SSIVAN 07120201 add*/ 		find t_req_det where recid(t_req_det) = recno
               no-lock no-error.
               else
/*SSIVAN 07120201 rmk*/        /*       find first req_det	   */
/*SSIVAN 07120201 add*/ 		find first t_req_det
               where ({1} = {3} or {2} = {3})
               and ({4} = {6} or {5} = {6})
/*SSIVAN 07120201 rmk*/         /*      and (req_request = request or request = "")	*/
/*SSIVAN 07120201 add*/ 		and (t_req_request = request or request = "")
               and (pmc_grp = ""
                 or (pmc_grp <> ""
                 and (((pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/      /*           and not (not(req_request begins "ycm"	   */
/*SSIVAN 07120201 add*/ 		  and not (not(t_req_request begins "ycm"
/*SSIVAN 07120201 rmk*/      /*           or req_request begins "yc3")))      */
/*SSIVAN 07120201 add*/ 		  or t_req_request begins "yc3"))) 
                 or (not (pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*SSIVAN 07120201 rmk*/      /*           and can-find(first usrw_wkfl where usrw_key2 = req_request	*/
/*SSIVAN 07120201 add*/ 		  and can-find(first usrw_wkfl where usrw_key2 = t_req_request
	          and usrw_key1 = "PMC." + pmc_grp)))))		 
/*SSIVAN 07120201 rmk*/        /*       use-index req_nbr no-lock no-error.	   */
/*SSIVAN 07120201 add*/ 		use-index i_req_nbr no-lock no-error.
               input clear.
             end.
/*SSIVAN 07120201 rmk*/        /*     recno = recid(req_det).	    */
/*SSIVAN 07120201 add*/ 	      recno = recid(t_req_det).
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
