/* SS - 090408.1 By: Neil Gao */
/* SS - 091020.1 By: Neil Gao */
/* SS - 100624.1 By: Kaine Zhang */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 100625.1 - RNB
[100625.1]
1. 某些情况下.已经生成了挂账表,但是供应商未来对账,或者供应商对某几种物料暂不对账.
   此时,需要进行处理.
   在当前的程序中,未处理本需求.
2. 增加一个xxwgzcl.p,将历史未对账的数据,在本期处理.
3. 除mfdtitle.i的日期版本外,不对本程序进行修改了.
[100625.1]
SS - 100625.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "100624.1"}
{cxcustom.i "GLCALMT.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glcalmt_p_1 "!GL"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable glname      like en_name.
define variable del-yn      as logical initial no.
define variable entity      like en_entity.
define variable firstflag   as logical initial no.
define variable entity_ok   like mfc_logical.
define variable gl_was_clsd like mfc_logical.
define variable gl_was_open like mfc_logical.
define variable ap_was_open like mfc_logical.
define variable ar_was_open like mfc_logical.
define variable fa_was_open like mfc_logical.
define variable so_was_open like mfc_logical.
define variable ic_was_open like mfc_logical.
define var ifcl as logical.

define buffer cal for glc_cal.

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{glcabmeg.i}  /* independent-module-close engine include */

form
   glcd_entity
   en_name                                   space(1)
   glcd_ap_clsd                              space(1)
   glcd_ar_clsd                              space(1)
   glcd_fa_clsd                              space(1)
   glcd_ic_clsd                              space(1)
   glcd_so_clsd                              space(1)
   glcd_gl_clsd  column-label {&glcalmt_p_1} space(1)
   glcd_yr_clsd
with frame b down width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* FOR BOOLEAN VALUE IN DOWN FRAME,    */
/* ENSURE TRANSLATION TO USER LANGUAGE */
{gpfrmdis.i &fname = "b"}

/* GET NAME OF CURRENT ENTITY */
find en_mstr  where en_mstr.en_domain = global_domain and  en_entity =
current_entity no-lock no-error.
if not available en_mstr then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
   pause.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

/* DISPLAY SELECTION FORM */
form
   glc_year     colon 25
   glc_per      colon 25
   glc_start    colon 25
   glc_end      colon 25
   skip(1)
   ifcl			    colon 25 label "挂账关闭"
with frame a side-labels width 80 attr-space
   title color normal glname.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   prompt-for glc_year glc_per
      editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i glc_cal glc_year  " glc_cal.glc_domain = global_domain and
      glc_year "  glc_per glc_per glc_index}
      if recno <> ? then
/* SS 091020.1 - B */
			do:
/* SS 091020.1 - E */
      display
         glc_year
         glc_per
         glc_start
         glc_end
      with frame a.
/* SS 091020.1 - B */
				if glc_user1 <> "" then disp yes @ ifcl with frame a.
				else disp no @ ifcl with frame a.
			end.
/* SS 091020.1 - E */      
   end.

   /* ADD/MOD/DELETE  */
   if input glc_per = 0 or input glc_year = 0 then do:
      {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3} /* INVALID PERIOD/YEAR */
      undo mainloop.
   end.

   find first glc_cal  where glc_cal.glc_domain = global_domain and  glc_year =
   input glc_year and
      glc_per = input glc_per no-error.
   if not available glc_cal then do:
     message "期间不存在".
     next.     
   end.
   recno = recid(glc_cal).
   clear frame b all.

   ststatus  =  stline[2].
   status input ststatus.
   del-yn = no.
	 
	 if glc_user1 <> "" then ifcl = yes.
/* SS 091020.1 - B */
		else ifcl = no.
/* SS 091020.1 - E */	 
   display
      glc_start
      glc_end
      ifcl.
   loopa:
   do:
   		if ifcl then do:
   			message "已经关帐,不能修改".
   		end.
/* SS 091020.1 - B */
   		else do on error undo,retry:
   			update ifcl with frame a.
   			if ifcl then glc_user1 = "Y".
   		end.
/* SS 091020.1 - E */
   end. /* loopa */
end. /* mainloop */
status input.
