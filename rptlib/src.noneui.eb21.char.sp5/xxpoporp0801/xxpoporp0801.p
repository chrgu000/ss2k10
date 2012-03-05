/* poporp08.p - PURCHASE ORDER VENDOR SCHEDULE REPORT                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K0NF*/
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0     LAST MODIFIED: 02/05/91    BY: RAM *D432**/
/* REVISION: 7.3    LAST MODIFIED: 10/18/94      BY: jzs *GN91* */
/* REVISION: 8.6    LAST MODIFIED: 10/08/97      BY: GYK *K0NF* */


/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/23/00   BY: *N0T0* Katie Hilbert    */

/* 以下为版本历史 */
/* SS - 090226.1 By: Ellen Xu */
/* SS - 090226.1 - B
禁止显示页眉
/*GN91*/ {mfdtitle.i "b+ "}
SS - 090226.1 - E */

/* SS - 090226.1 - B */
/* 固定 */
{xxmfdtitle.i "1+ "}

/* 临时表 */
{xxpoporp0801.i}

/* 定义输入参数 */
define input parameter i_vendor  like po_vend no-undo.
define input parameter i_vendor1 like po_vend no-undo.
define input parameter i_buyer  like po_buyer no-undo.
define input parameter i_buyer1 like po_buyer no-undo.
define input parameter i_ship  like po_ship no-undo.
define input parameter i_ship1 like po_ship no-undo.
define input parameter i_part  like pt_part no-undo.
define input parameter i_part1 like pt_part no-undo.
define input parameter i_site  like pod_site no-undo.
define input parameter i_site1 like pod_site no-undo.
define input parameter i_sel_inv  like mfc_logical initial yes.
define input parameter i_sel_sub like mfc_logical initial yes.
define input parameter i_sel_mem  like mfc_logical initial no.
define input parameter i_start like ro_start no-undo.
define input parameter i_dwm as character.
define input parameter i_idays as integer.
/* SS - 090226.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp08_p_1 "Memo Items"
/* MaxLen: Comment: */

/*N0T0***BEGIN DELETE
 * &SCOPED-DEFINE poporp08_p_2 "Day/Week/Month"
 * /* MaxLen: Comment: */
 *N0T0***END DELETE*/

&SCOPED-DEFINE poporp08_p_3 "Inventory Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp08_p_4 "Per Column"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp08_p_5 "Subcontracted Items"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable vendor like po_vend.
define new shared variable vendor1 like po_vend.
define new shared variable buyer like po_buyer.
define new shared variable buyer1 like po_buyer.
define new shared variable ship like po_ship.
define new shared variable ship1 like po_ship.
define new shared variable part like pt_part.
define new shared variable part1 like pt_part.
define new shared variable site  like pod_site.
define new shared variable site1 like pod_site.
define new shared variable sel_inv like mfc_logical initial yes
      label {&poporp08_p_3}.
define new shared variable sel_sub like mfc_logical initial yes
      label {&poporp08_p_5}.
define new shared variable sel_mem like mfc_logical initial no
      label {&poporp08_p_1}.
define new shared variable start like ro_start.
/*N0T0* define new shared variable dwm as character format "!"  */
/*N0T0*      label {&poporp08_p_2}.                             */
/*N0T0*/define new shared variable dwm as character format "!(1)"
/*N0T0*/label "D/W/M/P".
define new shared variable idays as integer format ">>>>>9"
      label {&poporp08_p_4}.

define new shared variable sdate as date extent 8.
define            variable interval as integer extent 8 no-undo.
define            variable monthend as integer no-undo.
define new shared variable num_intervals as integer initial 7.
define new shared variable i as integer.

form
   vendor         colon 15
   vendor1        label {t001.i} colon 49 skip
   buyer          colon 15
   buyer1         label {t001.i} colon 49 skip
   ship           colon 15
   ship1          label {t001.i} colon 49 skip
   part           colon 15
   part1          label {t001.i} colon 49 skip
   site           colon 15
   site1          label {t001.i} colon 49 skip(1)
   sel_inv        colon 25
   sel_sub        colon 25
   sel_mem        colon 25 skip(1)
   start          colon 25
   dwm            colon 25
   idays          colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*K0NF*/ {wbrp01.i}
/* SS - 090226.1 - B
禁止循环执行
repeat:
SS - 090226.1 - E */

/* SS - 090226.1 - B */
/* 将输入参数的值传递给本地变量 */
vendor = i_vendor.
vendor1 = i_vendor1.
buyer = i_buyer.
buyer1 = i_buyer.
ship = i_ship.
ship1 = i_ship1.
part = i_part.
part1 = i_part1.
site = i_site.
site1 = i_site1.
sel_inv = i_sel_inv.
sel_sub = i_sel_sub.
sel_mem = i_sel_mem.
start = i_start.
dwm = i_dwm.
idays = i_idays.
/* SS - 090226.1 - E */

/*GN91 do: */
      if start = ? then start = today.
      if dwm = "" then dwm = "W".
      if idays = 0 or idays = ? then idays = 1.
      if vendor1 = hi_char then vendor1 = "".
      if buyer1 = hi_char then buyer1 = "".
      if ship1 = hi_char then ship1 = "".
      if part1 = hi_char then part1 = "".
      if site1 = hi_char then site1 = "".

/* SS - 090226.1 - B
	禁止编辑本地变量
/*K0NF*/ if c-application-mode <> 'web' then
      update
     vendor vendor1
     buyer buyer1
     ship ship1
     part part1
     site site1
     sel_inv
     sel_sub
     sel_mem
     start
     dwm
     idays
      with frame a.

/*K0NF*/ {wbrp06.i &command = update &fields = "  vendor vendor1 buyer buyer1
ship ship1 part part1 site site1 sel_inv sel_sub sel_mem start dwm idays"
&frm = "a"}
SS - 090226.1 - E */

/*K0NF*/ if (c-application-mode <> 'web') or
/*K0NF*/ (c-application-mode = 'web' and
/*K0NF*/ (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i vendor    }
      {mfquoter.i vendor1   }
      {mfquoter.i buyer     }
      {mfquoter.i buyer1    }
      {mfquoter.i ship      }
      {mfquoter.i ship1     }
      {mfquoter.i part      }
      {mfquoter.i part1     }
      {mfquoter.i site      }
      {mfquoter.i site1     }
      {mfquoter.i sel_inv   }
      {mfquoter.i sel_sub   }
      {mfquoter.i sel_mem   }
      {mfquoter.i start     }
      {mfquoter.i dwm       }
      {mfquoter.i idays     }

      if vendor1 = "" then vendor1 = hi_char.
      if buyer1 = "" then buyer1 = hi_char.
      if ship1 = "" then ship1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.

/* Standard DWMP criterion validation */
/*GN91*/ if index("dwmp",dwm) = 0 then do:
/*N0T0*   {mfmsg.i 14 3} /*ERROR:INTERVAL MUST BE (D)ay (W)eek OR (M)onth*/  */
            /* INTERVAL MUST BE (D)ay (W)eek (M)onth OR (P)eriod */
/*N0T0*/    {pxmsg.i &MSGNUM=170 &ERRORLEVEL=3}
/*K0NF*/ if c-application-mode = 'web' then return.
         else next-prompt dwm with frame a.
            undo, retry.
/*GN91*/ end.

/*K0NF*/ end.
	
      /* SS - 090226.1 - B
	禁止显示页脚和循环执行
      {mfselbpr.i "printer" 132}

      {mfphead.i}
       SS - 090226.1 - E */

/*GN91  end. */

   /* COMPUTE START DATES */
   sdate[1] = low_date.
   {mfcsdate.i}
   /*
   {gprun.i ""poporp8a.p""}
   */
   {gprun.i ""xxpoporp0801a.p""}
   /* SS - 090226.1 - B
   禁止显示页脚和循环执行
   {mfrtrail.i}
   hide message no-pause.

   {mfmsg.i 9 1}
end.
 SS - 090226.1 - E */

/*K0NF*/ {wbrp04.i &frame-spec = a}
