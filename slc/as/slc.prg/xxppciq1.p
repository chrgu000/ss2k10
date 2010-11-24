/* pppciq.p - PRICE LIST INQUIRY                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12 $                                                     */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355**/
/* REVISION: 7.3      LAST MODIFIED: 11/04/92   BY: afs *G244**/
/* REVISION: 7.3      LAST MODIFIED: 11/19/92   By: jcd *G339**/
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: afs *H502**/
/* REVISION: 7.4      LAST MODIFIED: 10/17/94   BY: afs *FS51**/
/* REVISION: 8.6      LAST MODIFIED: 11/10/99   BY: bvm *K19B**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11     BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00K*     */
/* $Revision: 1.12 $    BY: Katie Hilbert       DATE: 10/17/03  ECO: *Q04B*   */
/*By: Neil Gao 08/05/23 ECO: *SS 20080523* */
/*By: Neil Gao 08/06/23 ECO: *SS 20080623* */
/*By: Neil Gao 08/11/26 ECO: *SS 20081126* */

/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE          */
{mfdtitle.i "090622.1"}

define variable prod_line  like pt_prod_line no-undo.
define variable vend     like xxpc_list      no-undo.
define variable vend1    like xxpc_list.
define variable xxpcnbr like xxpc_nbr.
define variable xxpcnbr1 like xxpc_nbr.
define variable effdate    as date.
define variable effdate1   as date.
define variable part       like pt_part      no-undo.
define variable part2      like pt_part.
define variable i          as integer        no-undo.
define variable curr       like xxpc_curr      no-undo.
define variable type       like xxpc_amt_type  no-undo.
define variable start_dt   like xxpc_start     no-undo.
define variable end_dt     like xxpc_expire    no-undo.
define variable xxdesc2 like pt_desc2.
define variable xxcmmt as char.
define variable xxii    as int.
define variable ifdisp as logical init yes.

/*
part = global_part.
*/

form
   vend 	colon 15 
   vend1 	colon 45 label "至"
   xxpcnbr colon 15 label "协议号"
   xxpcnbr1 colon 45 label "至"
   part   	colon 15
   part2  	colon 45 label "至"
   effdate  colon 15
   effdate1  colon 45
   ifdisp  colon 15 label "显示最新价格"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

    if vend1 = hi_char then vend = "".
    if part2 = hi_char then part2 = "".
    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.
    if xxpcnbr1 = hi_char then xxpcnbr1 = "".
    
    update
      vend vend1
      xxpcnbr xxpcnbr1
      part part2
      effdate
      effdate1
      ifdisp
    with frame a.
		
		if vend1 = "" then vend1 = hi_char.
		if part2 = "" then part2 = hi_char.
		if effdate = ? then effdate = low_date.
		if effdate1 = ? then effdate1 = hi_date.
		if xxpcnbr1 = "" then xxpcnbr1 = hi_char.

   /* OUTPUT DESTINATION SELECTION */
  	{mfselprt.i "printer" 250}

		put	";;价格查询;" skip.						
		put "供应商;"	"供应商名称;"	"物料号;"	"物料名称;"	
				"描述;"	"老机型;"	"协议编码;"	"开始日期;"	"价格;"	"比例;" skip.

      for each xxpc_mstr
         where xxpc_domain = global_domain
          and xxpc_list >= vend and xxpc_list <= vend1
          and xxpc_nbr >= xxpcnbr and xxpc_nbr <= xxpcnbr1
          and xxpc_part >= part and xxpc_part <= part2
          and xxpc_start >= effdate and xxpc_start <= effdate1
          and xxpc_approve_userid <> ""
          no-lock,
        each ad_mstr where ad_domain = global_domain and ad_addr = xxpc_list no-lock
      	break by xxpc_list by xxpc_part by xxpc_start	:
        
        if ifdisp and not last-of(xxpc_part) then next.
         
				find first vp_mstr where vp_domain = global_domain and vp_vend = xxpc_list and vp_part = xxpc_part no-lock no-error.
				find first pt_mstr where pt_domain = global_domain and pt_part = xxpc_part no-lock no-error.
				if not avail pt_mstr then next.
         put unformat 
         		xxpc_list ";"
            ad_name   ";"
            xxpc_part	";"
            pt_desc1 	";".
        
        xxcmmt = "".
				find first cd_det where cd_domain = global_domain and cd_ref = xxpc_part and cd_type = "SC" and cd_lang = "CH" no-lock no-error.
				if avail cd_det then do:
					repeat xxii = 1 to 15 :
						xxcmmt = xxcmmt + cd_cmmt[xxii].
					end.
					xxcmmt = replace(xxcmmt,";"," ").
				end.
				put unformat xxcmmt ";".
        
        xxdesc2 = pt_desc2.
        find first pt_mstr where pt_domain = global_domain and pt_part = substring(xxdesc2,1,4) no-lock no-error.
				if avail pt_mstr then put pt_desc1.
				put ";".
				
        put unformat xxpc_nbr ";"
            xxpc_start ";"
            xxpc_amt[1] ";".
        if avail vp_mstr then put vp_tp_pct.
        put ";" skip.
      end.
 

   	{mfreset.i}
		{mfgrptrm.i}
end.
global_part = part.

{wbrp04.i &frame-spec = a}
