/* txtxtrp.p - TAX TYPE MASTER REPORT                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.6 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 7.3      CREATED:       10/09/92   BY: bcm *G403*                */
/* REVISION: 7.4     MODIFIED:       08/06/93   By: bcm *H058*                */
/*                                   10/14/93   By: bcm *H171*                */
/* REVISION: 8.5     MODIFIED:       05/06/97   By: rxm *J1QQ*                */
/* REVISION: 8.6     MODIFIED:       10/22/97   By: GYK *K155*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.4  BY: Jean Miller DATE: 04/10/02 ECO: *P058* */
/* $Revision: 1.6.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00M* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 100113.1 By: Bill Jiang */

/* SS - 100113.1 - RNB
[100113.1]

无效库位主文件报表

顺序输出了以下字段:
  - 代码
  - 说明

[100113.1]
  
SS - 100113.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "100113.1"}

define variable tax_type    like txed_tax_type  no-undo.
define variable tax_type1   like txed_tax_type  no-undo.
define variable descr       like code_desc      no-undo.
define variable descr1      like code_desc      no-undo.

DEFINE VARIABLE addr_global LIKE GLOBAL_addr.

form
   tax_type    colon 15
   tax_type1   label "To" colon 50 skip
   descr       colon 15
   descr1      label "To" colon 50 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

mainloop:
repeat:

   if tax_type1 = hi_char then tax_type1   = "".
   if descr1 = hi_char then descr1   = "".

   addr_global = GLOBAL_addr.
   GLOBAL_addr = "SoftspeedPC_Porite_loc".

   if c-application-mode <> 'web' then
      update tax_type tax_type1 descr descr1 with frame a.

   {wbrp06.i &command = update &fields = "  tax_type tax_type1 descr
        descr1" &frm = "a"}
   
   GLOBAL_addr = addr_global.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i tax_type   }
      {mfquoter.i tax_type1  }
      {mfquoter.i descr      }
      {mfquoter.i descr1     }

      if tax_type1  = "" then tax_type1  = hi_char.
      if descr1  = "" then descr1  = hi_char.

   end.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   /* SS - 100113.1 - B
   {mfphead2.i}

   /* Display by Description */
   if (tax_type = "" and tax_type1 = hi_char and
      (descr > "" or descr1 < hi_char)) then
   for each code_mstr  where code_mstr.code_domain = global_domain and
            code_fldname = "txt_tax_type" and
           (code_desc >= descr  and code_desc <= descr1)
   no-lock by code_desc
   with frame b down width 132 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      display
         code_desc
         code_value label "Tax Type" format "x(16)".

      {mfrpchk.i}

   end.

   else
   /* Display by type (default) */
   for each code_mstr  where code_mstr.code_domain = global_domain and
            code_fldname = "txt_tax_type" and
           (code_value >= tax_type and code_value <= tax_type1)  and
           (code_desc >= descr  and code_desc <= descr1)
   no-lock by code_value
   with frame c down width 132 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      display
         code_value label "Tax Type" format "x(16)"
         code_desc.

      {mfrpchk.i}

   end.

   {mftrl080.i}
   SS - 100113.1 - E */

   /* SS - 100113.1 - B */
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   /* Display by type (default) */
   EXPORT DELIMITER ";"
      "代码"
      "说明"
      .
   for each code_mstr  
      where code_mstr.code_domain = global_domain and
      code_fldname = "SoftspeedPC_Porite_loc" 
      and (code_value >= tax_type and code_value <= tax_type1)  
      and (code_desc >= descr  and code_desc <= descr1)
      no-lock 
      by code_value
      :
      EXPORT DELIMITER ";"
         code_value 
         code_desc
         .
   end.

   {xxmfrtrail.i}
   /* SS - 100113.1 - E */

end.

{wbrp04.i &frame-spec = a}
