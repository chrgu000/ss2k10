/* GUI CONVERTED from pirp01.p (converter v1.69) Sat Mar 30 01:17:58 1996 */
/* pirp01.p - PRINT TAGS                                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*/
/* REVISION: 6.0      LAST MODIFIED: 11/14/90   BY: WUG *D210*/
/* REVISION: 6.0      LAST MODIFIED: 07/12/91   BY: WUG *D765*/
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*          */
/* REVISION: 6.0      LAST MODIFIED: 03/05/92   BY: WUG *F254*/
/* REVISION: 6.0      LAST MODIFIED: 04/30/92   BY: WUG *F460*/
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G348* */
/* REVISION: 7.3      LAST MODIFIED: 07/23/93   BY: qzl *GD66*/
/* REVISION: 7.2      LAST MODIFIED: 01/28/94   BY: ais *FL74*/
/*                    Last Modified 06/13/01    BY: Rao Haobin *bn083*   */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	 {mfdtitle.i "f "}   /*GD66*/ /*GUI moved to top.*/
	 def var tag             like tag_nbr init ?.
	 def var tag1            like tag_nbr label {t001.i} init ?.
	 def var reprint_tags    like mfc_logical label "重新打印标签" init no.
	 def var print_barcode   like mfc_logical label "打印条形码"
				 init no.
	 def var forms_across    as int format "9" init 1 label "标签列数/页".
	 def var lines_form      as int format ">9" init 18
				 label "行数/标签".
	 def var form_width      as int format ">>9" init 50
				 label "字符数/标签行".
	 def var max_printwidth  as int format ">>9" init 131
				 label "打印机最大打印宽度".
	 def var site            like si_site.
	 def var loc             like loc_loc.
	 def var part            like pt_part.
	 def var desc1           like pt_desc1.
	 def var desc2           like pt_desc2.
/*bn083*/       def var keeper        like pt_article label "保管员".
/*bn083*/       def var keeper1    	 like pt_article label "保管员".

	 def var lotserial       like tag_serial.
	 def var lotref          like tag_ref.   /*D887*/
	 def var um              like pt_um.
	 def var abc             like pt_abc.
	 def var tagline         as char extent 21.
	 def var printline       as char extent 21.
	 def var forms_built     as int init 0.
	 def var i               as int.
	 def var j               as int.
	 def var tagnumber       like tag_nbr extent 21.
	 def var barctrlcode     as char.
     DEF VAR page1 AS INT INIT 0.
     tagline[01] = "一|          | ".
	 tagline[02] = "一|          | ".
	 tagline[03] = "一|          |          标签号:                        保管员:                         ".
	 tagline[04] = "粘|    装    |                                                                         ".
	 tagline[05] = "一|          |          地点:                                                          ".
	 tagline[06] = "一|          |          库位:                                                          ".
	 tagline[07] = "一|          |          零件号:                        ABC:                            ".
	 tagline[08] = "一|          |          描述:                                                          ".
	 tagline[09] = "贴|    订    |          盘点量:   ___________          重新盘点量: ___________         ".
	 tagline[10] = "一|          |          盘点人:   ___________          重新盘点人: ___________         ".
	 tagline[11] = "一|          |          监点员:   ___________          重盘点日期: ___________         ".
	 tagline[12] = "一|          |          盘点日期: ___________          保管员签字: ___________         ".
     tagline[13] = "一|          |                                                                         ".
     tagline[14] = "线|    线    |          （以下由保管员填写）                                           ".
     tagline[15] = "一|          |          主库位:   ___________ 数量:___________________________         ".
	 tagline[16] = "一|          |          辅助库位: ___________ 数量:___________________________         ".
	 tagline[17] = "一|          |          备注:_______________________________________________页码:      ".
         /*GUI moved mfdeclre/mfdtitle.*/

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
tag                  colon 20
	    tag1                 colon 49
	    skip(1)
	    reprint_tags         colon 40
	    print_barcode        colon 40
	    forms_across         colon 40
	    lines_form           colon 40
	    form_width           colon 40
	    max_printwidth       colon 40
	  SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).



	 
/*GUI*/ {mfguirpa.i true  "printer"  80 nopage }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	   if tag = 0 then tag = ?.
	    if tag1 = 99999999 then tag1 = ?.

	    display reprint_tags print_barcode forms_across lines_form
	       form_width max_printwidth with frame a.

	    
run p-action-fields  (input "display").
run p-action-fields  (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	    if forms_across < 1 then do:
	       {mfmsg.i 705 3}
	       /*GUI NEXT-PROMPT removed */
	       /*GUI UNDO removed */ RETURN ERROR.
	    end.

	    if lines_form < 16 then do:
	       {mfmsg.i 706 3}
	       /*GUI NEXT-PROMPT removed */
	       /*GUI UNDO removed */ RETURN ERROR.
	    end.

	    if form_width < 50 then do:
	       {mfmsg.i 707 3}
	       /*GUI NEXT-PROMPT removed */
	       /*GUI UNDO removed */ RETURN ERROR.
	    end.

/*FL74*/    if forms_across * form_width > max_printwidth then do:
/*FL74*/       /* Line is not wide enough for requested forms per line */
/*FL74*/       {mfmsg.i 719 3}
/*FL74*/       /*GUI NEXT-PROMPT removed */
/*FL74*/       /*GUI UNDO removed */ RETURN ERROR.
/*FL74*/    end.

/*GD66*/    if print_barcode and forms_across <> 1 then do:
/*GD66*/       {mfmsg.i 699 3}
/*GD66*/       /*GUI UNDO removed */ RETURN ERROR.
/*GD66*/    end.

	    bcdparm = "".
	    {mfquoter.i tag}
	    {mfquoter.i tag1}
	    {mfquoter.i reprint_tags}
	    {mfquoter.i print_barcode}
	    {mfquoter.i forms_across}
	    {mfquoter.i lines_form}
	    {mfquoter.i form_width}
	    {mfquoter.i max_printwidth}

	    if  tag = ? then tag = 0.
	    if  tag1 = ? then tag1 = 99999999.

	    /* PRINTER SELECTION */
	    
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer"  80 nopage}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:


 /*D765*/

	    for each tag_mstr exclusive where tag_nbr >= tag and tag_nbr <= tag1 AND tag_serial = ""
	    and (reprint_tags or tag_prt_dt = ?): /*F460*/
	       tag_prt_dt = today.                /*F460*/

	       site      = "________".
	       loc       = "________".
	       part      = "__________________".
	       um        = "".
	       abc       = "".
	       desc1     = "".
	       desc2     = "".
	       lotserial = "__________________".
	       lotref    = "________".

	       if tag_type = "I" then do:
				
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G348*/
		  site = tag_site.
		  loc = tag_loc.
		  part = tag_part.
		  find pt_mstr where pt_part = tag_part no-lock no-error.
		  if available pt_mstr then do:
		     um = pt_um.
/*F003               abc = pt_abc.  */
		     desc1 = pt_desc1.
		     desc2 = pt_desc2.
/*bn083*/	     /*keeper = pt_article.*/ /*delete fm268*/
		  end.
/*F003*/          find in_mstr where in_part = tag_part and in_site = tag_site
/*F003*/          no-lock no-error.
/*F003*/          if available in_mstr then abc = in_abc.

		  lotserial = tag_serial.
		  lotref = tag_ref.
          keeper = IN__qadc01. /*add fm268*/
	       end.

           page1 = page1 + 1.
           substr(tagline[03],32,8)  = substr(string(tag_nbr) + fill(" ",8),1,8). 
           substr(tagline[03],62,10)  = substr(keeper + " ",1,10). 
	       substr(tagline[05],33,8)  = substr(site + fill(" ",8),1,8).
	       substr(tagline[06],33,8)  = substr(loc + fill(" ",8),1,8).
	       substr(tagline[07],32,18) = substr(part + fill(" ",18),1,18).
	       substr(tagline[07],62,1)  = substr(abc + " ",1,1).
	       substr(tagline[08],33,24) = substr(desc2 + fill(" ",24),1,24).
           
           substr(tagline[17],78,5) = substr(STRING(page1) + fill(" ",5),1,5).


	       do i = 1 to 17:
/*FL74*/          if forms_built > 0
/*FL74*/          then printline[i] = printline[i]
/*FL74*/                            + fill(" ",form_width - length(tagline[i]))
/*FL74*/                            + tagline[i].
/*FL74*/          else
		     printline[i] = printline[i] + tagline[i].
	       end.

	       forms_built = forms_built + 1.
	       tagnumber[forms_built] = tag_nbr.

       if forms_built >= forms_across then do:
		  {yypirp01.i}
	       end.
	    end.

       if forms_built >= 1 then do:
	       {yypirp01.i}
	    end.

	    
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

	 end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" tag tag1 reprint_tags print_barcode forms_across lines_form form_width max_printwidth "} /*Drive the Report*/
