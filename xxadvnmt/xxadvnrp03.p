/* xxadvnrp03.p - VENDOR SHIP_TERMS REPORT                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.6 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 04/05/86   BY: PML                       */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: GYK *K0T5*                */
/* REVISION: 8.6      LAST MODIFIED: 10/29/97   BY: *H1G4* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/16/00   BY: *N0C9* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7.1.6 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* DISPLAY TITLE */
{mfdtitle.i "110908.1"}

define variable code like vd_addr.
define variable code1 like vd_addr.
define variable name like ad_name.
define variable name1 like ad_name. 
define variable codecmmt like code_cmmt.
define variable act as logical no-undo.

form
   code  colon 12
   code1 label {t001.i} colon 46 skip
   name  colon 12
   name1 label {t001.i} colon 46 skip(2)
   act   colon 32
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   if code1 = hi_char then code1 = "".
   if name1 = hi_char then name1 = "". 

   if c-application-mode <> 'web' then
      update code code1 name name1 act with frame a.

   {wbrp06.i &command = update &fields = " code code1 name name1 act"
   					 &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i code    }
      {mfquoter.i code1   }
      {mfquoter.i name    }
      {mfquoter.i name1   } 

      if code1 = "" then code1 = hi_char.
      if name1 = "" then name1 = hi_char. 

   end.
   /* Select printer */
   {mfselbpr.i "printer" 132}
   {mfphead.i}

   for each vd_mstr where (vd_addr >= code and vd_addr <= code1)
         and (vd_sort >= name and vd_sort <= name1) and
          ((act and vd__chr03 <> "") or not act)
         no-lock by vd_sort with frame b width 132 no-attr-space no-box:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      assign codecmmt = "".
      find first code_mstr no-lock where code_fldname = "vd__chr03" 
      			 and code_value = vd__chr03 no-error.
      if available code_mstr then do:
      	 assign codecmmt = code_cmmt.
      end.
 			display vd_addr vd_sort format "x(40)" 
 							vd__chr03 format "x(20)" codecmmt format "x(40)".
      {mfrpexit.i}
   end.

   /* REPORT TRAILER  */

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
