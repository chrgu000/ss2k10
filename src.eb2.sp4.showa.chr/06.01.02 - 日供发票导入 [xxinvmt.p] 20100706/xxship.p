/* 程序说明： 发票号导入程序                                            */
/* 自定义表名称：xx_inv_mstr                                                  */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "C+ "}

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

/* ********** End Translatable Strings Definitions ********* */


/* define input parameter ppform as character no-undo. */
DEFINE INPUT PARAMETER str1 as char NO-UNDO.
define  variable str3 as char format "x(26)" no-undo.

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
define variable str2 as int format "999".

define variable flag as char .
define variable ifdel as logical .
define variable del-yn like mfc_logical initial no.

/* PRINTABLE VERSION OF FRAME a */
FORM /*GUI*/ 
   {ppptmta1.i}
   /* pt_site colon 19 */
with /* STREAM-IO /*GUI*/ */ frame a0 side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a0:handle).

/*GUI preprocessor  Frame a 定义*/
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /* GUI */ 
/*   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/ */
    str2        	   label "项次"                   colon 10
    str3                   label "零件图号"               colon 35
    /* xx_ship_part        label "零件图号"               colon 30 */
    /* xx_ship_duedate	   label "出船日期"               colon 10 */
    /* xx_ship_etadate	   label "预计到达日"             colon 35 */
    xx_ship_qty  	   label "数量"                   colon 10
    xx_ship_price          label "单价"                   colon 35
    xx_ship_curr           label "货币类型"               colon 65
    xx_ship_rate           label "汇率"                   colon 10
    xx_ship_value          label "价格"                   colon 35
    xx_ship_site           label "收货地点"               colon 10
    xx_ship_case           label "托号"                   colon 35
    xx_ship_pkg            label "箱数"                   colon 65
    xx_ship_qty_unit       label "每箱数量"               colon 10
    xx_ship_status         label "状态"                   colon 35
    xx_ship_rcvd_date      label "收货时间"               colon 65
    xx_ship_type           label " 区分"                  colon 10
    "（量产P/新机种R）"                         colon 35
with frame a side-labels width 80 attr-space . /* NO-BOX THREE-D /*GUI*/.

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

{wbrp02.i}

mainloop:
repeat:

view frame a.

str2 = 1.

if c-application-mode <> 'web' then
   update str2
   with no-validate frame a

   editing:

          /* {pxmsg.i &MSGNUM=11 &ERRORLEVEL=2}  修改*/

          /*  上下箭头键查找 NEXT/PREVIOUS 记录 */
	  {xxmfnp11.i xx_ship_det str2 xx_ship_line str2 xx_ship_line xx_ship_no}
          
          if recno <> ?  then do:   /* 3 */
  	     str2 = xx_ship_line.
             find xx_ship_det where xx_ship_line = str2 and xx_ship_no = str1 no-error.
             if available xx_ship_det then do:   /* 4 */
	          display
		       str2
	               xx_ship_part    @ str3       label "零件图号"
		       xx_ship_qty         
                       /* xx_ship_duedate */	     
	               /* xx_ship_etadate */	   
		       xx_ship_curr           
                       xx_ship_rate                
	               xx_ship_price                  
	               xx_ship_value        
		       xx_ship_site                       
                       xx_ship_case                            
                       xx_ship_pkg                           
                       xx_ship_qty_unit                  
                       xx_ship_status                  
                       xx_ship_rcvd_date                
                       xx_ship_type                   
                   with frame a.
                 end.   /* 4end */
	     end. /* 3end */ 
   

         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            then do:  /* 6 */
               del-yn = yes.
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if not del-yn then undo, retry.
               if del-yn
                  then do:  /* 7 */
                       for each xx_ship_det where xx_ship_line = str2 and xx_ship_no = str1.
                       delete xx_ship_det.
                       end.  /* 7end */
         /*      RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.  GUI */
               del-yn = no.
	       next mainloop.
               end. /* 6end */
	 else
             display
	        /*  "" @ xx_ship_part ***********************/
		  "" @ str3
                  "" @ xx_ship_qty    
                  /* "" @ xx_ship_duedate */
                  /* "" @ xx_ship_etadate */
                  "" @ xx_ship_cur
                  "" @ xx_ship_rate 
                  "" @ xx_ship_price
		  "" @ xx_ship_value
		  "" @ xx_ship_site                          
                  "" @ xx_ship_case                   
                  "" @ xx_ship_pkg                       
                  "" @ xx_ship_qty_unit                 
                  "" @ xx_ship_status                  
                  "" @ xx_ship_rcvd_date         
                  "" @ xx_ship_type
	       with frame a.
	 
	       end.

    end. /* EDITING */

    {wbrp06.i &command = prompt-for &frm = "a"}

    if (c-application-mode <> 'web') or (c-application-mode = 'web' and(c-web-request begins 'data')) 
       then do:
            if input str2 = 0 
               then do:
               {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}  /*BLANK NOT ALLOWED*/
               if c-application-mode = 'web' then return.
               else undo, retry.
                end. /*INPUT BLANK*/
           end.

 find xx_ship_det where xx_ship_line = str2 and xx_ship_no = str1 no-error.
    if available xx_ship_det then do:
       display
		       str2
	               xx_ship_part    @ str3       label "零件图号"
		       xx_ship_qty         
		       xx_ship_curr           
                       xx_ship_rate                
	               xx_ship_price                  
	               xx_ship_value        
		       xx_ship_site                       
                       xx_ship_case                            
                       xx_ship_pkg                           
                       xx_ship_qty_unit                  
                       xx_ship_status                  
                       xx_ship_rcvd_date                
                       xx_ship_type                   
                   with frame a. 
       update str3 with frame a.
      AA:
        REPEAT:
	      find vp_mstr where vp_vend_part = str3 no-error.
	      if available vp_mstr 
	         then do:
	         xx_ship_part = vp_vend_part.
                        display
		       str2
	               xx_ship_part    @ str3       label "零件图号"
		       xx_ship_qty         
		       xx_ship_curr           
                       xx_ship_rate                
	               xx_ship_price                  
	               xx_ship_value        
		       xx_ship_site                       
                       xx_ship_case                            
                       xx_ship_pkg                           
                       xx_ship_qty_unit                  
                       xx_ship_status                  
                       xx_ship_rcvd_date                
                       xx_ship_type                   
                   with frame a. 

		 set
                  /*  xx_ship_part */
                 xx_ship_qty
                 /* xx_ship_duedate */
                 /* xx_ship_etadate */
                 xx_ship_curr 
                 xx_ship_rate
                 xx_ship_price
                 xx_ship_value
		 xx_ship_site                       
                 xx_ship_case                          
                 xx_ship_pkg                 
                 xx_ship_qty_unit                   
                 xx_ship_status              
                 xx_ship_rcvd_date                 
                 xx_ship_type
                 with frame a.
		 leave AA.
		 end.
	     else do:
	         message "零件图号不正确,请重新输入."    view-as alert-box error buttons OK. 
		 update str3 with frame a.
		 end.
        END. /*end AA*/
     end.
    else do:
        
        create xx_ship_det.
        assign xx_ship_line = str2
	       xx_ship_no = str1.
	display
	         /* "" @ xx_ship_part  */
		  "" @ str3
                  "" @ xx_ship_qty    
                  /* "" @ xx_ship_duedate  */
                  /* "" @ xx_ship_etadate */
                  "" @ xx_ship_cur
                  "" @ xx_ship_rate 
                  "" @ xx_ship_price
		  "" @ xx_ship_value
		  "" @ xx_ship_site                          
                  "" @ xx_ship_case                   
                  "" @ xx_ship_pkg                       
                  "" @ xx_ship_qty_unit                 
                  "" @ xx_ship_status                  
                  "" @ xx_ship_rcvd_date         
                  "" @ xx_ship_type
	       with frame a.
	update str3 with frame a.
      AA:
        REPEAT:
	      find vp_mstr where vp_vend_part = str3 no-error .
	      if available vp_mstr 
	         then do:
	         xx_ship_part = vp_vend_part.
                        display
		       str2
	               xx_ship_part    @ str3       label "零件图号"
		       xx_ship_qty         
		       xx_ship_curr           
                       xx_ship_rate                
	               xx_ship_price                  
	               xx_ship_value        
		       xx_ship_site                       
                       xx_ship_case                            
                       xx_ship_pkg                           
                       xx_ship_qty_unit                  
                       xx_ship_status                  
                       xx_ship_rcvd_date                
                       xx_ship_type                   
                   with frame a. 

		 set
                  /*  xx_ship_part */
                 xx_ship_qty
                 /* xx_ship_duedate */
                 /* xx_ship_etadate */
                 xx_ship_curr 
                 xx_ship_rate
                 xx_ship_price
                 xx_ship_value
		 xx_ship_site                       
                 xx_ship_case                          
                 xx_ship_pkg                 
                 xx_ship_qty_unit                   
                 xx_ship_status              
                 xx_ship_rcvd_date                 
                 xx_ship_type
                 with frame a.
		 leave AA.
		 end.
	     else do:
	         message "零件图号不正确,请重新输入."    view-as alert-box error buttons OK. 
		 update str3 with frame a.
		 end.
        END. /*end AA*/
/*	set
        xx_ship_part
	xx_ship_qty        
        /* xx_ship_duedate */
	/* xx_ship_etadate */
	xx_ship_curr 
        xx_ship_rate
	xx_ship_price
	xx_ship_value
        with frame a.
*/
    end.
 
     
end. /* MAINLOOP */
hide frame a.
/*{wbrp04.i &frame-spec = a} */
