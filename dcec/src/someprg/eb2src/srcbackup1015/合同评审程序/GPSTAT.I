/* GUI CONVERTED from gpstat.i (converter v1.69) Sat Mar 30 01:14:34 1996 */
/* gpstat.i - -- INCLUDE FILE FOR STATUS LINE MESSAGES                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0     LAST MODIFIED: 03/20/92	BY: RAM	*F298*		*/
/************************************************************************/
/*!
*/
/*!
{&stat} Status message number
{&type} Must be either "default" or "input"
*/
/************************************************************************/

	 find msg_mstr
	 where msg_lang = global_user_lang
	 and msg_nbr = (if {&stat} < 100 then 8800 + {&stat} else {&stat})
	 no-lock no-error.

	 if available msg_mstr then do:
	    ststatus = msg_desc.
	    status {&type} ststatus.
	 end.
