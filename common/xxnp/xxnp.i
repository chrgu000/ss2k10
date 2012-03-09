/* mfnp.i - -- INCLUDE FILE FOR NEXT/PREV LOGIC                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.21 $                                              */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 07/15/86   BY: pml */
/* REVISION: 6.0      LAST MODIFIED: 04/09/90   BY: ram *D020**/
/* REVISION: 7.3      LAST MODIFIED: 03/17/95   BY: str *G0FB**/
/* REVISION: 7.4      LAST MODIFIED: 01/09/97   BY: *H0RJ* Cynthia Terry */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CF* Santosh Rao   */
/* REVISION: 9.1      LAST MODIFIED: 08/01/00   BY: *N0HF* Katie Hilbert */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb           */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.17     BY: Katie Hilbert  DATE: 03/22/01 ECO: *P008*      */
/* Revision: 1.18    BY: John Pison     DATE: 10/24/02   ECO: *N1Y4*     */
/* Revision: 1.20   BY: Paul Donnelly  DATE: 03/28/03  ECO: *Q005*  */
/* $Revision: 1.21 $ BY: Ed van de Gevel DATE: 10/05/04 ECO: *Q0DF* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*************************************************************************/
/*!
Search through file {1} where field {5} >= value {4}, starting
with field {3} value {2} using index {6}.
*/
/*!
Input Parameters:
{1} file
{2} input var #1
{3} field #1
{4} input var #2
{5} field #2
{6} index
*/
/*
Input Parameters:
{1} input date
{2} low_date
{3} hi_date
*/
/**************************************************************/

ststatus = stline[1].
status input ststatus.
readkey.

/* Don't hide message for Desktop HELP triggers */
if not ({gpiswrap.i} and keyfunction(lastkey) = "HELP") then
   hide message no-pause.

/* FIND NEXT RECORD */
if lastkey = keycode("F10")
   or keyfunction(lastkey) = "CURSOR-DOWN"
then do:
	 if {1} >= {3} or {3} <> ? then do:
	 		{pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}  /* End of file */
	 		{1} = {3}
	 end.
	 else do:
		  {1} = {1} + 1.
	 end.
 	 
/*   if recno = ? then                                                     */
/*      find first {1} where {3} >  input {2}                              */
/*      and {5} >= input {4} use-index {6}                                 */
/*      no-lock no-error.                                                  */
/*   else find next {1}                                                    */
/*      where {3} >= input {2}                                             */
/*      use-index {6} no-lock no-error.                                    */
/*                                                                         */
/*   if not available {1} then do:                                         */
/*      {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}  /* End of file */              */
/*      if recno = ? then                                                  */
/*         find last {1} where {3} < input {2}                             */
/*         and {5} <= input {4} use-index {6}                              */
/*         no-lock no-error.                                               */
/*                                                                         */
/*      else                                                               */
/*      if recno <> ? then                                                 */
/*         find {1} where recno = recid({1}) no-lock no-error.             */
/*      input clear.                                                       */
/*   end.                                                                  */
/*   recno = recid({1}).                                                   */
    
end.

/* FIND PREVIOUS RECORD  */
else
if lastkey = keycode("F9")
   or keyfunction(lastkey) = "CURSOR-UP"
then do:
	 if {1} <= {2} then do:
	 		{pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}
	 		assign {1} = {2}.
	 end.
	 else do:
	 	  {1} = {1} - 1.
	 end.
/*   if recno = ? then                                                     */
/*      find last {1} where {3} < input {2}                                */
/*      and {5} <= input {4}                                               */
/*      use-index {6} no-lock no-error.                                    */
/*   else find prev {1}                                                    */
/*       where {3} <= input {2}                                            */
/*       use-index {6} no-lock no-error.                                   */
/*                                                                         */
/*   if not available {1} then do:                                         */
/*      {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}  /* Beginning of file */        */
/*      if recno = ? then                                                  */
/*         find first {1} where {3} > input {2}                            */
/*         and {5} >= input {4} use-index {6}                              */
/*         no-lock no-error.                                               */
/*                                                                         */
/*      else                                                               */
/*      if recno <> ? then                                                 */
/*         find {1} where recno = recid({1}) no-lock no-error.             */
/*      input clear.                                                       */
/*   end.                                                                  */
/*   recno = recid({1}).                                                   */
end.

/* INPUT PROMPT FIELD */
else do:
   /* Don't reset recno for Desktop HELP triggers - only exception
    * is when the recno is already set but no record is available */
/*   if not ({gpiswrap.i} and keyfunction(lastkey) = "HELP") or  */
/*      (recno <> ? and not available({1})) then                 */
/*      recno = ?.                                               */
   if keyfunction(lastkey) = "end-error" then do:
      ststatus = stline[3].
      status input ststatus.
   end.
   apply lastkey.
end.
