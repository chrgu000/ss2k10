/* mfnp01.i - INCLUDE FILE FOR NEXT/PREV LOGIC WITH =                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/*            (parm 4 = parm 5)                                         */
/* REVISION: 1.0      LAST MODIFIED: 07/15/86   BY: EMB                 */
/* REVISION: 2.0      LAST MODIFIED: 03/10/87   BY: EMB *A41*           */
/* REVISION: 7.3      LAST MODIFIED: 05/23/95   BY: STR *G0N9*          */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* Revision: 1.7     BY: Katie Hilbert  DATE: 03/22/01 ECO: *P008*      */
/* $Revision: 1.8 $   BY: John Pison     DATE: 10/24/02   ECO: *N1Y4*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/************************************************************************/

/*!
Search through file {1} where field {5} = value {4}, starting
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
/************************************************************************/

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
   if recno = ? THEN DO:
      MESSAGE "1. " + {3} + " " + {2} + " " + {5} + " " + {4} + " " +
         INPUT prh_vend + " " + INPUT prh_part + " " + 
         INPUT prh_ps_nbr VIEW-AS ALERT-BOX.
   
      find first {1} where {3} > input {2}
      and {5} = {4}
      
      AND prh_vend = INPUT prh_vend
      AND prh_part = INPUT prh_part
      AND (prh_rcp_date >= rcp_date AND 
           prh_rcp_date <= rcp_date1 ) 
      AND (prh_ps_nbr = INPUT prh_ps_nbr OR INPUT prh_ps_nbr = "")

      use-index {6} no-lock no-error.
   END.
   ELSE DO:
       MESSAGE "2. " + {5} + " " + {4} + " " +
         INPUT prh_vend + " " + INPUT prh_part + " " + 
         INPUT prh_ps_nbr VIEW-AS ALERT-BOX.
   
      find next {1} where {5} = {4}
      
      AND prh_vend = INPUT prh_vend
      AND prh_part = INPUT prh_part
      AND (prh_rcp_date >= rcp_date AND 
           prh_rcp_date <= rcp_date1 ) 
      AND (prh_ps_nbr = INPUT prh_ps_nbr OR INPUT prh_ps_nbr = "")

      use-index {6} no-lock no-error.
   END.

   if not available {1} then do:
      {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2} /* End of file*/

      if recno <> ? then
         find {1} where recid({1}) = recno
         no-lock no-error.
      else DO:
         MESSAGE "3. " + {5} + " " + {4} + " " +
         INPUT prh_vend + " " + INPUT prh_part + " " + 
         INPUT prh_ps_nbr VIEW-AS ALERT-BOX.
      
         find last {1} where {5} = {4} 
            
            AND prh_vend = INPUT prh_vend
            AND prh_part = INPUT prh_part
            AND (prh_rcp_date >= rcp_date AND 
                 prh_rcp_date <= rcp_date1 ) 
            AND (prh_ps_nbr = INPUT prh_ps_nbr OR INPUT prh_ps_nbr = "")
      
            use-index {6}
         no-lock no-error.
      END.

      input clear.
   end.
   recno = recid({1}).
end.

/* FIND PREVIOUS RECORD  */
else
if lastkey = keycode("F9")
   or keyfunction(lastkey) = "CURSOR-UP"
then do:
   if recno = ? THEN DO:
      MESSAGE "4. " + {3} + " " + {2} + " " + {5} + " " + {4} + " " +
         INPUT prh_vend + " " + INPUT prh_part + " " + 
         INPUT prh_ps_nbr VIEW-AS ALERT-BOX.

      find last {1} where {3} < input {2}
      and {5} = {4}

      AND prh_vend = INPUT prh_vend
      AND prh_part = INPUT prh_part
      AND (prh_rcp_date >= rcp_date AND 
           prh_rcp_date <= rcp_date1 ) 
      AND (prh_ps_nbr = INPUT prh_ps_nbr OR INPUT prh_ps_nbr = "")

      use-index {6} no-lock no-error.
   END.
   else DO:
         MESSAGE "5. " + {5} + " " + {4} + " " +
         INPUT prh_vend + " " + INPUT prh_part + " " + 
         INPUT prh_ps_nbr VIEW-AS ALERT-BOX.

      find prev {1} where {5} = {4}

      AND prh_vend = INPUT prh_vend
      AND prh_part = INPUT prh_part
      AND (prh_rcp_date >= rcp_date AND 
           prh_rcp_date <= rcp_date1 ) 
      AND (prh_ps_nbr = INPUT prh_ps_nbr OR INPUT prh_ps_nbr = "")

      use-index {6} no-lock no-error.
   END.
   if not available {1} then do:
      {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2} /* Beginning of file */

      if recno <> ? then
         find {1} where recid({1}) = recno
         no-lock no-error.
      else DO:
         MESSAGE "6. " + {5} + " " + {4} + " " +
         INPUT prh_vend + " " + INPUT prh_part + " " + 
         INPUT prh_ps_nbr VIEW-AS ALERT-BOX.
      
         find first {1} where {5} = {4} 
            
            AND prh_vend = INPUT prh_vend
            AND prh_part = INPUT prh_part
            AND (prh_rcp_date >= rcp_date AND 
                 prh_rcp_date <= rcp_date1 ) 
            AND (prh_ps_nbr = INPUT prh_ps_nbr OR INPUT prh_ps_nbr = "")
      
            use-index {6}
         no-lock no-error.
      END.

      input clear.
   end.
   recno = recid({1}).
end.

/* INPUT PROMPT FIELD */
else do:
   /* Don't reset recno for Desktop HELP triggers - only exception
    * is when the recno is already set but no record is available */
   if not ({gpiswrap.i} and keyfunction(lastkey) = "HELP") or
      (recno <> ? and not available({1})) then
      recno = ?.
   if keyfunction(lastkey) = "end-error" then do:
      ststatus = stline[3].
      status input ststatus.
   end.
   apply lastkey.
end.
