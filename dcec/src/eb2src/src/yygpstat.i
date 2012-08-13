/* GUI CONVERTED from gpstat.i (converter v1.75) Sun Aug 13 18:35:55 2000 */
/* gpstat.i - -- INCLUDE FILE FOR STATUS LINE MESSAGES                  */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.0     LAST MODIFIED: 03/20/92    BY: RAM *F298*      */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KS* myb          */
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
