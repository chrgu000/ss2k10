/* mfsec.p - Perform security checking for mfmenu.p, mgbatch.p, apphelp.p    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Maintenance                                                 */
/* Revision: 7.3        Last modified: 08/17/95         By: str   *G0V7*     */
/*                                                                           */

	  {mfdeclre.i}
	  {mf1.i}

	  define input parameter mndnbr as character no-undo.
	  define input parameter mndselect as integer no-undo.
	  define output parameter can_do_menu as logical no-undo.

	  define shared variable menu as character.

	  define variable user_excluded as logical no-undo.
	  define variable tmp_canrun as character no-undo.
	  define variable group_indx as integer no-undo.
	  define variable passlist as character no-undo.
	  define variable passnbr  as character no-undo.

	  define buffer mnddet for mnd_det.

DEFINE shared VARIABLE v-userid     LIKE usr_userid.
DEFINE shared VARIABLE v-userpd     LIKE usr_passwd.
DEFINE shared VARIABLE v-usergp     LIKE usr_group.

	  passlist = "".
	  can_do_menu = yes.

	  do for mnddet:

	     find first mnddet where mnddet.mnd_nbr = mndnbr and
	     mnddet.mnd_select = mndselect no-lock no-error.

	     repeat while available mnddet and mnddet.mnd_nbr <> "":

		{xxut010a.i "mnddet"}

		if can_do_menu = false then do:
		   if passlist = "" then do:
/***		      {mfmsg.i 23 3} /* PASSWORD DOES NOT ALLOW ACCESS */   ***/
		      return.
		   end.
		   else do:
		      find mnddet where recid(mnddet) =
			 integer(entry(1,passlist)) no-lock.
		      passlist =
			 substring(passlist,index(passlist,",") + 1).
		      next.
		   end.
		end.

		if mnddet.mnd_nbr = menu then return.
		passnbr = mnddet.mnd_nbr.

		for each mnddet no-lock where mnddet.mnd_exec = passnbr:
		   passlist = string(recid(mnddet)) + "," + passlist.
		end.
		if passlist <> "" then do:
		   find mnddet where recid(mnddet) =
		      integer(entry(1,passlist)) no-lock no-error.
		   passlist =
		      substring(passlist,index(passlist,",") + 1).
		end.

	     end. /* REPEAT */

	  end. /* DO */
