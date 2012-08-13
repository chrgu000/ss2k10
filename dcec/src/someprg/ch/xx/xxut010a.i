/* mfsec.i - Perform security checking for mfmenu.p                          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/* Revision: 7.0        Last modified: 06/23/92         By: jcd   *F679*     */
/* Revision: 7.3        Last modified: 07/01/93         By: rwl   *GC91*     */
/*                                                                           */
/*  {1} = buffer containing mnd_canrun                                       */
/*                                                                           */

can_do_menu = no.

if global_sec_opt = "P" then do:
   if can-do ({1}.mnd_canrun + ",!*",v-userpd) then
      can_do_menu = yes.
end.
else do: /* options "U" and "B" */
   if can-do ({1}.mnd_canrun + ",!*",v-userid) then
      can_do_menu = yes.
end.

/*GC91* modify following loop to check for !userid; remove "!group support */
if not can_do_menu and global_sec_opt <> "P" then do:

   /* check to see if userid was specifically excluded in the canrun list. */
   /* user_excluded will be set to yes only if there is a !user in the     */
   /* canrun list.                                                         */
   user_excluded = no.
   do group_indx = 1 to num-entries({1}.mnd_canrun):
      tmp_canrun = entry(group_indx,{1}.mnd_canrun).
      if tmp_canrun = "!*" or can-do(tmp_canrun + ",*", v-userid) then
	 next. /* check next entry */
      else do:
	 /* user was excluded, set flag and leave loop */
	 user_excluded = yes.
	 leave.
      end.
   end.

   if user_excluded = no then do:
      /* if the userid was not excluded, check the user groups.  Build a new */
      /* canrun list which excludes any "!" entries, since we do not support */
      /* !groups.                                                            */
      tmp_canrun = "".
      do group_indx = 1 to num-entries({1}.mnd_canrun):
	 if not entry(group_indx,{1}.mnd_canrun) begins "!" then
	    tmp_canrun = tmp_canrun + "," + entry(group_indx,{1}.mnd_canrun).
      end.
      do group_indx = 1 to num-entries(v-usergp)
      while not can_do_menu:
	 if can-do (tmp_canrun + ",!*", entry(group_indx, v-usergp))
	 then can_do_menu = yes.
      end.
   end.

end.
