/* 程序说明： 发票号导入程序                                            */
/* 自定义表名称：xx_inv_mstr                                                  */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "20100706 "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptiqb_p_1 "This Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_2 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_3 "A/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_5 "Pri"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_6 "Category"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_8 "Lower Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptiqb_p_17 "Element"
/* MaxLen: Comment: */

define input parameter ppform as character no-undo.

define new shared variable in_recno as recid.
define new shared variable si_recno as recid.
define new shared variable csset as character.
define new shared variable global_costsim like sc_sim.
define new shared variable global_category like sc_category.


define variable s_mtl like sct_mtl_tl no-undo.
define variable s_lbr like sct_lbr_tl no-undo.
define variable s_bdn like sct_bdn_tl no-undo.
define variable s_ovh like sct_ovh_tl no-undo.
define variable s_sub like sct_sub_tl no-undo.
define variable yn like mfc_logical no-undo.
define variable cfg like pt_cfg_type format "x(3)" no-undo.
define variable cfglabel as character format "x(24)" label ""
   no-undo.
define variable frtitle as character format "x(24)" no-undo.
define variable cfgcode as character format "x(1)" no-undo.

define variable btb-type like pt_btb_type format "x(8)" no-undo.
define variable btb-type-desc like glt_desc no-undo.
define variable atp-enforcement      like pt_atp_enforcement format "x(8)"
   no-undo.
define variable atp-enforce-desc like glt_desc no-undo.
define variable l_comm_code like com_comm_code no-undo.
define variable str1 as char format "x(18)".
define variable flag as char .
define variable ifdel as logical .
define variable del-yn like mfc_logical initial no.
define variable vend_desc as char format "x(30)".

/* PRINTABLE VERSION OF FRAME a */
FORM /*GUI*/ 
   {ppptmta1.i}
   /* pt_site colon 19 */
with STREAM-IO /*GUI*/  frame a0 side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a0:handle).

/*GUI preprocessor  Frame a 定义*/
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /* GUI */ 
/*   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    SKIP(.1)   */
    str1	label "合同号"   colon 10
    xx_inv_con  label "发票号"   colon 10
    vend_desc   label "供应商"   colon 40
/*    SKIP(.1)
    SKIP(.1)   */
with frame a side-labels width 80 attr-space  . /* NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
*/



/*GUI preprocessor Frame A undefine */
/*&UNDEFINE PP_FRAME_NAME*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


/*GUI preprocessor  Frame a1 定义*/
&SCOPED-DEFINE PP_FRAME_NAME A1

FORM /*GUI*/ 
/*   RECT-FRAME       AT ROW 1 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1 
         SKIP(.1)  /*GUI*/   */
        xx_inv_site	label "地  点"   colon 10
        xx_inv_con     label "发票号"   colon 10
        xx_inv_vend    label "供应商"   colon 40
        
               xx_refer	label "参考号"   colon 10
        xx_section	label "Section"  colon 40
         xx_inv_date	label "发票日期"     colon 10
        xx_inv_duedate	label "出船日期"     colon 40
        xx_inv_plandate  label "计划日期"   colon 10
        xx_inv_vandate   label "捆包日期"   colon 40
        xx_inv_pkg     label "合同托数"     colon 10
         xx_inv_curr	label "货币类型"     colon 10
        xx_inv_value	label "合同总价"     colon 40
  with frame a1 side-labels width 80 attr-space  . /* NO-BOX THREE-D.

 DEFINE VARIABLE F-a1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 = F-a1-title.
 RECT-FRAME-LABEL:HIDDEN in frame a1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a1 =
  FRAME a1:HEIGHT-PIXELS - RECT-FRAME:Y in frame a1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a1 = FRAME a1:WIDTH-CHARS - .5.  /*GUI*/
*/
/*GUI preprocessor Frame A1 undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

{wbrp02.i}

mainloop:
repeat:

   /* hide frame a1.*/
   view frame a.
   view frame a1.

   str1 = "".
   

if c-application-mode <> 'web' then
   prompt-for str1
   with no-validate frame a 
/*   update str1
   with no-validate frame a */

   editing:

/*   {pxmsg.i &MSGNUM=11 &ERRORLEVEL=2}  提示信息*/

      /*  上下箭头键查找 NEXT/PREVIOUS 记录 */
      {xxmfnp.i xx_inv_mstr str1 xx_inv_no str1 xx_inv_no xx_inv_no}
          
      if recno <> ? then do:
        str1 = xx_inv_no.
        FIND FIRST ad_mstr WHERE ad_addr = xx_inv_vend NO-ERROR.
         IF AVAILABLE ad_mstr THEN vend_desc = ad_name + ad_line3.
           ELSE vend_desc = "".
        display str1 vend_desc xx_inv_con with frame a.
         
        find xx_inv_mstr where xx_inv_no = str1 no-error.
         if available xx_inv_mstr then do:
         	display
                  xx_inv_site  
	         xx_inv_con 
	         xx_inv_vend
                  xx_refer  
                  xx_section 
                  xx_inv_date
	         xx_inv_duedate
	         xx_inv_pkg
                  xx_inv_curr 
                  xx_inv_value
                  with frame a1.
               end.
        end.
     else    

     /* if lastkey = keycode("F5")
 then do:
     message "是否删除这条记录 ？"  update ifdel  .
          if ifdel  then do:
        for each xx_inv_mstr where xx_inv_no = str1.
         delete xx_inv_mstr.
      end.
  end. */
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if not del-yn then undo, retry.
               if del-yn then do:
                  for each xx_inv_mstr where xx_inv_no = str1.
                  delete xx_inv_mstr.
                  end.
  
       /*        RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.  */
               del-yn = no.
               next mainloop.
            end.
         
         /*   apply lastkey.    */
	else
              display
                 "" @ xx_inv_site 
	         "" @ xx_inv_con
	         "" @ xx_inv_vend
                  "" @ xx_refer   
                  "" @ xx_section
                  "" @ xx_inv_duedate
                  "" @ xx_inv_date
                  "" @ xx_inv_plandate
	         "" @ xx_inv_vandate
	         "" @ xx_inv_pkg
                  "" @ xx_inv_curr
                  "" @ xx_inv_value
              with frame a1.
        
              end.
         
      end. /* EDITING */
   
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      if input str1 = "" then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}  /*BLANK NOT ALLOWED*/
         if c-application-mode = 'web' then return.
         else undo, retry.
      end. /*INPUT BLANK*/


/*    global_part = xx_inv_no.
 *
 *   display {xxppptmta1.i}  with frame a.
 *    /* find xx_inv_no use xx_inv_no no-error.*/
 *    find xx_inv_mstr where xx_inv_no = str1 no-error.
 *    if not available xx_inv_mstr then do:
 *        {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /* ITEM NUMBER DOES NOT EXIST */
 *        if c-application-mode = 'web' then return.
 *        else  undo, retry.
 *     end. /* IF NOT AVAILABLE pt_mstr */ 
 */
   end.
       
find xx_inv_mstr where xx_inv_no = str1 no-error.
if available xx_inv_mstr then do:
       set  
        xx_inv_site 
	xx_inv_con
	xx_inv_vend    
        xx_refer   
        xx_section
        xx_inv_duedate
        xx_inv_date
	xx_inv_plandate
	xx_inv_vandate
	xx_inv_pkg
        xx_inv_curr
        xx_inv_value
       with frame a1.

      end.
   
   else do:
      create xx_inv_mstr.
      assign xx_inv_no = str1.
       set  
        xx_inv_site  
	xx_inv_con
	xx_inv_vend    
        xx_refer   
        xx_section
        xx_inv_duedate
        xx_inv_date
	xx_inv_plandate
	xx_inv_vandate
	xx_inv_pkg
        xx_inv_curr
        xx_inv_value
       with frame a1.
      
     end. 

hide fram a1.

{gprun.i ""xxship.p"" "(input str1)"}


end. /* MAINLOOP */

/*{wbrp04.i &frame-spec = a} */
