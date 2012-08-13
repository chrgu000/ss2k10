/* GUI CONVERTED from bmpsmc.p (converter v1.69) Sat Mar 30 01:05:41 1996 */
/* bmpsmc.p - PRODUCT STRUCTURE COMPONENT MULTIPLE ADD/REPLACE/DELETE   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 5.0         LAST EDIT: 06/11/90     MODIFIED BY: SMM *C197*    */
/* REVISION: 5.0         LAST EDIT: 11/26/90     MODIFIED BY: SXL *B831*    */
/* REVISION: 6.0         LAST EDIT: 12/11/90     MODIFIED BY: SXL *D249*    */
/* REVISION: 6.0         LAST EDIT: 03/05/91     MODIFIED BY: emb *D397*    */
/* REVISION: 7.0         LAST EDIT: 03/24/92     MODIFIED BY: pma *F089*    */
/* REVISION: 7.0         LAST EDIT: 03/24/92     MODIFIED BY: pma *F089*    */
/* REVISION: 7.0         LAST EDIT: 04/02/92     MODIFIED BY: emb *F346*    */
/* REVISION: 7.3         LAST EDIT: 07/29/93     MODIFIED BY: emb *GD82*    */
/* REVISION: 7.4         LAST EDIT: 10/12/93     MODIFIED BY: pma *H013*(rev) */
/* REVISION: 7.4         LAST EDIT: 01/26/94     MODIFIED BY: ais *FL64*    */
/* REVISION: 7.4         LAST EDIT: 03/16/94     MODIFIED BY: pxd *FL60*    */
/* REVISION: 7.4         LAST EDIT: 08/01/94     MODIFIED BY: jxz *FP79*    */
/* REVISION: 8.5         LAST EDIT: 12/18/94     MODIFIED BY: dzs *J011*    */
/* REVISION: 7.4         LAST EDIT: 05/03/95     MODIFIED BY: qzl *H0D3*    */
/* REVISION: 7.4         LAST EDIT: 12/15/95     MODIFIED BY: rwl *F0WR*      */
/* REVISION: 7.4         LAST EDIT: 01/24/96     MODIFIED BY: bcm *G1KV*      */
/* REVISION: 8.5         LAST EDIT: 12/21/03     MODIFIED BY: Kevin    */
/*Kevin(NOTES): Added a new function, change 'part1" must be a item
         to can be just a bom code****************************/
         
	 /*********************************************************/
	 /* NOTES:   1. Patch FL60 sets in_level to a value       */
	 /*             of 999999 when in_mstr is created or      */
	 /*             when any structure or network changes are */
	 /*             made that affect the low level codes.     */
	 /*          2. The in_levels are recalculated when MRP   */
	 /*             is run or can be resolved by running the  */
	 /*             mrllup.p utility program.                 */
	 /*********************************************************/

	 {mfdtitle.i "99 "} /*H013*/

/*H0D3*/ /* this patch puts correct ECO number in line 15         */
/*D249*/ define variable part     like pt_part label "已存在零件".
/*D249*/ define variable part1    like pt_part label "新零件".
/*F346*/ define variable effdate  like ps_start label "生效日期".
	 define variable ptum     like pt_um.
	 define variable ptum2    like pt_um.
	 define variable ptdesc1  like pt_desc1.
	 define variable ptdesc2  like pt_desc2.
	 define variable continue like mfc_logical.
	 define buffer psmstr  for ps_mstr.
/*B831   define buffer psmstr1 for ps_mstr.*/
	 define new shared variable ps_recno as recid.
	 define new shared variable parent like ps_par.
	 define new shared variable comp like ps_comp.
/*B831*/ define variable action as character format "!(1)".
/*B831*/ define variable ad_rep_title as character format "x(60)".
	 define variable unknown_char as character initial ?.
/*F089*/ define variable ptstatus like pt_status.
/*F346*/ define variable conflicts like mfc_logical.
         def var part_yn like mfc_logical.             /*kevin,means whether input part is a item*/
	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*F346*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{t018.i} /* For all effective structures where compnt item exists */
/*H013*/    /*modified t018.i)*/
	    skip(1)
/*F346*/    effdate colon 23
	    part colon 23 ptdesc1 at 45 no-label
	    ptum colon 23 ptdesc2 at 45 no-label
	    skip(1)
	    action colon 23 label "采取措施"
	    "A - 加入新的子零件" at 30
	    "D - 删除已存在的子零件" at 30
	    "R - 用新的子零件替代已存在的零件" at 30
			"新的子零件" at 42
	  SKIP(.4)  /*GUI*/
with frame a width 80 side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



	 FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part1 colon 23 ptdesc1 at 45 no-label
	    ptum2 colon 23 ptdesc2 at 45 no-label
	  SKIP(.4)  /*GUI*/
with frame b width 80 side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


	 FORM /*GUI*/  psmstr with frame copy THREE-D /*GUI*/.


/*F346*/ effdate = today.

	 view frame a.
	 view frame b.

	 repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

           
	    update
/*F346*/    effdate
	    part
	    action validate (index("ARD",action) > 0,
	    "错误: 要求采取的措施必须是 (A)加入, (D)删除或 (R)替代"
	    + "  " + "请重新输入。")
	    with frame a editing:

	       if frame-field = "part" then do:

		  {mfnp.i ps_mstr part ps_comp part ps_comp ps_comp}

		  if recno <> ? then do with frame a:
		     find pt_mstr no-lock where pt_part = ps_comp no-error.
		     if available pt_mstr
		     then display pt_part @ part
			pt_desc1 @ ptdesc1
			pt_desc2 @ ptdesc2
			pt_um @  ptum.
		     else display
/*F346*/             ps_comp @ part
		     " " @ ptdesc1 " " @ ptdesc2 " " @ ptum.
		  end.
/*F346*/          recno = ?.

	       end. /* Editing */
	       else do:
		  readkey.
		  apply lastkey.
	       end.
	    end.
            
          part_yn = yes.                         /*kevin*/
          
	    find pt_mstr no-lock where pt_part = part no-error.
	    if available pt_mstr then do with frame a:
	       display pt_desc1 @ ptdesc1 pt_desc2 @ ptdesc2 pt_um @ ptum.
	    end.
	    else do with frame a:
	       display " " @ ptdesc1 " " @ ptdesc2 " " @ ptum.
	       
	      part_yn = no.                     /*kevin*/ 
	       
	       {mfmsg.i 16 2}
	    end.

	    if not can-find (first ps_mstr where ps_comp = part) then do:
	       {mfmsg.i 100 3}
	       undo, retry.
	    end.

	    if action = "A" or action = "R" then do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               
	       set part1 validate (part1 <> part,
	       "错误: 零件号必须不相重, 请重新输入。")
	       with frame b editing:

		  {mfnp.i pt_mstr part1 pt_part part1 pt_part pt_part}

		  if recno <> ? then do with frame b:
		     display pt_part @ part1
			     pt_desc1 @ ptdesc1
			     pt_desc2 @ ptdesc2
			     pt_um @  ptum2.
		  end.

	       end. /* EDITING */

	       if part = part1 then undo, retry.

	       find pt_mstr no-lock where pt_part = part1 no-error.
	       if available pt_mstr then do with frame b:

/*F089*/          ptstatus = pt_status.
/*F089*/          substring(ptstatus,9,1) = "#".
/*F089*/          if can-find(isd_det where isd_status = ptstatus
/*F089*/          and isd_tr_type = "ADD-PS") then do:
/*F089*/              {mfmsg02.i 358 3 pt_status}
/*F089*/              undo, retry.
/*F089*/          end.

		  part1 = pt_part.
		  display pt_desc1 @ ptdesc1 pt_desc2 @ ptdesc2 pt_um @ ptum2.
	       end.
	       else do with frame b:

/*marked by kevin		
		  display " " @ ptdesc1 " " @ ptdesc2 " " @ ptum2.
		  {mfmsg.i 16 3}
		  undo, retry.
end marked by kevin*/
/*added by kevin*/
                if part_yn then do:
		        display " " @ ptdesc1 " " @ ptdesc2 " " @ ptum2.
		        {mfmsg.i 16 3}
		        undo, retry. 
		  end.
		  else do:
		        find bom_mstr where bom_parent = part1 no-lock no-error.
		        if not available bom_mstr then do:
		            message "零件号、或产品结构代码都不存在" view-as alert-box error.
		            undo,retry.
		        end.
		        else do:
		            disp bom_desc @ ptdesc2 bom_batch_um @ ptum2.
		        end.
		  end. /*if not part_yn*/
/*end added by kevin*/
		  
	       end.
	    end.
	    else do:
	       part1 = "".
	       clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
	       hide frame b.
	    end.

	    continue = no.
	    {mfmsg01.i 12 1 continue}
	    if continue = no then undo, retry.

	    copy: do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

	       if can-find (first ps_mstr where ps_comp = part) then do:
		  if (action = "R" or action = "D") 
		  then do:
		     {inmrp.i &part=part   &site=unknown_char}
		  end.
		  if action = "A" then do:
		     {inmrp.i &part=part1  &site=unknown_char}
		  end.
	       end.

	       for each ps_mstr where ps_comp = part
/*F346*/          and (effdate = ?
/*F346*/          or ((ps_start <= effdate or ps_start = ?)
/*F346*/          and (ps_end >= effdate or ps_end = ?)))
/*J011*/          and ps_ps_code <> "J":
/*GUI*/ if global-beam-me-up then undo, leave.


		  if action = "A" or action = "R" then do:
		     find psmstr where psmstr.ps_par = ps_mstr.ps_par
		     and psmstr.ps_comp = part1
		     and psmstr.ps_ref = ps_mstr.ps_ref
/*F346*/             and psmstr.ps_start = ps_mstr.ps_start
/*J011*/             and psmstr.ps_ps_code <> "J"
		     no-error.
		     if not available psmstr then do:

/*F346*/                conflicts = false.
/*F346*/                for each psmstr no-lock
/*F346*/                where psmstr.ps_par = ps_mstr.ps_par
/*F346*/                and psmstr.ps_comp = part1
/*F346*/                and psmstr.ps_ref = ps_mstr.ps_ref
/*J011*/                and psmstr.ps_ps_code <> "J"
/*F346*/                and (
/*F346*/                   (psmstr.ps_end = ? and ps_mstr.ps_end = ?)
/*F346*/                or (psmstr.ps_start = ? and ps_mstr.ps_start = ?)
/*F346*/                or (psmstr.ps_start = ? and psmstr.ps_end = ?)
/*F346*/                or (ps_mstr.ps_start = ? and ps_mstr.ps_end = ?)
/*F346*/                or ((ps_mstr.ps_start >= psmstr.ps_start
/*F346*/                   or psmstr.ps_start = ?)
/*F346*/                   and ps_mstr.ps_start <= psmstr.ps_end)
/*F346*/                or (ps_mstr.ps_start <= psmstr.ps_end
/*F346*/                   and ps_mstr.ps_end >= psmstr.ps_start) ):
/*F346*/                   conflicts = true.
/*F346*/                   leave.
/*F346*/                end.

/*F346*/                if conflicts then do:
/*F346*/                   {mfmsg.i 122 3}
/*F346*/                   undo copy, leave copy.
/*F346*/                end.

			if action = "A" then do:
			   find psmstr where psmstr.ps_par = ps_mstr.ps_par
			   and psmstr.ps_comp = part
			   and psmstr.ps_ref = ps_mstr.ps_ref
/*F346*/                   and psmstr.ps_start = ps_mstr.ps_start
/*J011*/                   and psmstr.ps_ps_code <> "J"
			   no-error.
			   if opsys = "unix"       then output to "/dev/null".
/*F0WR*/                   else if opsys = "msdos" or opsys = "win32" then
/*F0WR*/                      output to "nul".
			   else if opsys = "vms"   then output to "nl:".
			   else if opsys = "btos" then output to "[nul]".
			   display psmstr with frame copy.
			   display part1 @ psmstr.ps_comp with frame copy.
			   output close.
			   create psmstr.
			   assign psmstr.
			   ps_recno = recid(psmstr).
/*FL64*/                   ps_mstr.ps_mod_date = today.
/*FL64*/                   ps_mstr.ps_userid = global_userid.
			end.
			if action = "R" then do:
			   ps_mstr.ps_comp = part1.
/*FL64*/                   ps_mstr.ps_mod_date = today.
/*FL64*/                   ps_mstr.ps_userid = global_userid.
			   ps_recno = recid(ps_mstr).
			end.

			/* CYCLIC PRODUCT STRUCTURE CHECK */
			{gprun.i ""bmpsmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


			if ps_recno = 0 then do:
			   {mfmsg.i 206 3}
			   /* CYCLIC PRODUCT STRUCTURE NOT ALLOWED. */
			   undo copy, leave copy.
			end.

/*FP79  /*FL60*/    for each in_mstr exclusive where in_part = ps_comp */
/*FP79*/    for each in_mstr exclusive-lock where in_part = ps_mstr.ps_comp
/*FL60*/    and not can-find (ptp_det where ptp_part = in_part
/*FL60*/    and ptp_site = in_site):
/*FL60*/      if available in_mstr then in_level = 99999.
/*FL60*/    end.
/*FP79  /*FL60*/    for each ptp_det where ptp_part = ps_comp: */
/*FP79*/    for each ptp_det where ptp_part = ps_mstr.ps_comp:
/*FL60*/      find in_mstr where in_part = ptp_part and in_site =  ptp_site
/*G1KV*/      exclusive-lock
/*FL60*/      no-error.
/*FL60*/      if available in_mstr then in_level = 99999.
/*FL60*/    end.

/*FL60                  /* LOW LEVEL CODE UPDATE */  */
/*FL60                  {gprun.i ""bmpsmtb.p""}      */

		     end. /*Available*/
		     else do:
			{mfmsg.i 260 3} /* Product structure already exists */
			undo copy, leave copy.
		     end.
		  end. /*if action = A or R */

		  {inmrp.i &part=ps_mstr.ps_par  &site=unknown_char}

		  if action = "D" then do:
		     delete ps_mstr.
		  end.

	       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*For Each*/

	    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*Transaction*/

	 end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* REPEAT LOOP */
