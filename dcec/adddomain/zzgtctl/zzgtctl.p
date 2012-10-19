/* zzgtctl.p  - GOLD-TAX Interface Control File                           */
/* COPYRIGHT CHL     ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK     */
/* LAST MODIFIED 	2004-08-30 10:41BY *LB01*	Long Bo 				  */

/* DISPLAY TITLE */
 {mfdtitle.i "zz "}
define variable v_yn1        like mfc_logical initial no.
define buffer   bbusrwwkfl   for usrw_wkfl.

define var      i            as integer.
define var      j            as integer.

{zzgt002.i new}
{zzgtos01.i}

/* DISPLAY SELECTION FORM */
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
assign v_max_amt = 11000000.
FORM /*GUI*/ 
            
	RECT-FRAME       AT ROW 1 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
	skip(1)
    usrw_key2        colon 15  label "接口代码"    format "x(4)"  skip
    usrw_key4        colon 15  label "公司地址"    format "x(8)"  
    v_adname         colon 38  no-label            format "x(40)" skip
    usrw_charfld[4]  colon 15  label "地点"        format "x(60)" skip
    usrw_charfld[1]  colon 15  label "授权用户"    format "x(60)" skip
    v_p01            colon 15  label "开票人"      format "x(8)" 
    v_p02            colon 38  label "复核人"      format "x(8)"
    v_p03            colon 61  label "收款人"      format "x(8)"  skip
    v_itemkind       colon 15  label "缺省类别"     format "x(8)"  
     
    v_outtaxin       colon 20  label "下载数据金额含税"  skip(1)
    v_name_def[1]    colon 20  label "上载文件缺省名称"  format "x(12)" 
    v_intaxin        colon 20  label "上载数据金额含税"  
    v_infixrd        colon 20  label "上载数据调整差异"  
    v_inpost         colon 20  label "上载数据自动过帐"
    usrw_decfld[1]   colon 20  label "调整及过帐容差"    format ">>9.999"
    v_max_amt        colon 48  label "开票金额限制"     skip(1)
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


form
	skip(1)
	"MFG/PRO系统路径设置:" at 5 skip(1)
    v_box[1] colon 15  label "下载文件路径"    format "x(60)" skip
    v_box[2] colon 15  label "上载文件路径"    format "x(60)" skip
    v_box[3] colon 15  label "备份文件路径"    format "x(60)" skip
    v_box[4] colon 15  label "表报文件路径"    format "x(60)" skip
    v_box[5] colon 15  label "过账结果路径"    format "x(60)" skip(1) /*lb01*/

with frame b row 2 side-labels width 80 three-d.


mainloop:
repeat  with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.
  
  hide frame b no-pause.

  
  prompt-for usrw_key2 editing:
  
    {mfnp01.i usrw_wkfl usrw_key2 usrw_key2 usrw_key1 
    					" usrw_domain = global_domain and """GOLDTAX-CTRL""" " usrw_index1 }
  
    if recno <> ? then do:
      {zzgt003.i}
      find first ad_mstr where ad_domain = global_domain and 
      					ad_addr = usrw_key4
           no-lock no-error.
      if available ad_mstr then v_adname = ad_name.
                           else v_adname = "".

      display
        usrw_key2
        usrw_charfld[4]
        usrw_key4
        v_adname
        usrw_charfld[1]
        v_p01
        v_p02
        v_p03
        v_itemkind
        v_name_def[1]
        v_outtaxin
        v_intaxin
        v_infixrd
        v_inpost  
        usrw_decfld[1] 
        v_max_amt
      with frame a.
    end.
  end. 

  find first usrw_wkfl where usrw_domain = global_domain and 
  					 usrw_key1 = "GOLDTAX-CTRL" and
             usrw_key2 = input usrw_key2
       no-lock no-error.
  if not available usrw_wkfl then do:
  
  
    {mfmsg.i 1 1}
    create usrw_wkfl. usrw_domain = global_domain.
    assign usrw_key1 = "GOLDTAX-CTRL"
           usrw_key2 = input usrw_key2
           usrw_charfld[3] = "YYNN"
           usrw_charfld[4] = ""
           overlay(usrw_charfld[6],1,12) = "invoice.txt"
           overlay(usrw_charfld[6],21,8) =   string(year(today),"9999") 
                                           + string(month(today),"99")
                                           + string(day(today),"99")
           overlay(usrw_charfld[6],31,6) = "000000"
                                           
           overlay(usrw_charfld[7],1,12) = "SO010101.txt"
           overlay(usrw_charfld[7],21,8) =   string(year(today),"9999") 
                                           + string(month(today),"99")
                                           + string(day(today),"99")
           overlay(usrw_charfld[7],31,6) = "000000"
           
           usrw_decfld[1] = 0
           usrw_decfld[2] = 0
           usrw_decfld[3] = v_max_amt.
  end.
/*
  subloopa:
/ *  do transaction: * LB01 MOVE DOWN/
  do on error undo, retry:
 */
    find first usrw_wkfl where usrw_domain = global_domain and 
         usrw_key1 = "GOLDTAX-CTRL" and
         usrw_key2 = input usrw_key2.

    {zzgt003.i}

    find first ad_mstr where ad_domain = global_domain and
          ad_addr = usrw_key4
         no-lock no-error.
    if available ad_mstr then v_adname = ad_name.
                         else v_adname = "".

      display
        usrw_key2
        usrw_charfld[4]
        usrw_key4
        v_adname
        usrw_charfld[1]
        v_p01
        v_p02
        v_p03
        v_itemkind
        v_name_def[1]
        v_outtaxin
        v_intaxin
        v_infixrd
        v_inpost  
        usrw_decfld[1]  
        v_max_amt
      with frame a.

  subloopa:
/*  do transaction: */
  do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

    set  /*update *  LB01*/
        usrw_key4
        usrw_charfld[4]
        usrw_charfld[1]
        v_p01
        v_p02
        v_p03
        v_itemkind
        v_outtaxin         
        v_name_def[1]    validate((v_name_def[1] <> ""),"ERROR:不能为空")
        v_intaxin          
        v_infixrd          
        v_inpost      
        usrw_decfld[1]
        v_max_amt  
    go-on(F5 ctrl-d) with frame a.

     
    /* DELETE */
    if (lastkey = keycode("F5") or lastkey = keycode("CTRL-D")) then do:
      v_yn1 = yes.
      {mfmsg01.i 11 1 v_yn1}
      if v_yn1 = no then undo .
  
      delete usrw_wkfl.
      clear frame a.
      v_yn1 = no.
      hide message no-pause.
      next mainloop.
    end.

    find first ad_mstr where ad_domain = global_domain and
    					 ad_addr = usrw_key4 no-lock no-error.
    if available ad_mstr then v_adname  = ad_name + ad_line1.  
    else do:
      message "错误:公司地址无效,请重新输入".
      next-prompt usrw_key4 with frame a.
      undo subloopa, retry.
    end.

    /* lb01
    find first ad_mstr where ad_domain = global_domain and 
    					 ad_addr = v_itemgtax no-lock no-error.
    if not available ad_mstr then do:
      message "错误:商品标识无效,请重新输入".
      next-prompt v_itemgtax with frame a.
      undo subloopa, retry.
    end.
    */

    if usrw_charfld[4] <> "" then do:
      j = 1.
      do i = 1 to length(usrw_charfld[4]):
        if substring(usrw_charfld[4],i,1) = "," then j = j + 1.      
      end.
      do i = 1 to j:
        if entry(i,usrw_charfld[4], ",") <> "" then do:
          find first si_mstr where si_domain = global_domain and 
          					 si_site = entry(i,usrw_charfld[4], ",") no-lock no-error.
          if not available si_mstr then do:
            message "地点不存在".
            next-prompt usrw_charfld[4] with frame a.
            undo, retry.
          end.
          /*lb01
          if can-find(first bbusrwwkfl where bbusrwwkfl.usrw_domain = global_domain   
             abd bbusrwwkfl.usrw_key1 = "GOLDTAX-CTRL"
             and recid(bbusrwwkfl) <> recid(usrw_wkfl) 
             and lookup(entry(i,usrw_wkfl.usrw_charfld[4], ","),bbusrwwkfl.usrw_charfld[4])<> 0
             no-lock)
          then do:
            message "ERROR:该地点已分配给其他分公司".
            next-prompt usrw_charfld[4] with frame a.
            undo , retry.
          end.
          */
        end.
      end.

    end.

    if usrw_charfld[1] <> "" then do:
      j = 1.
      do i = 1 to length(usrw_charfld[1]):
        if substring(usrw_charfld[1],i,1) = "," then j = j + 1.      
      end.
      do i = 1 to j:
        if entry(i,usrw_charfld[1],",") <> "" then do:
          if can-find(first bbusrwwkfl where bbusrwwkfl.usrw_domain = global_domain 
             and bbusrwwkfl.usrw_key1 = "GOLDTAX-CTRL"
             and recid(bbusrwwkfl) <> recid(usrw_wkfl) 
             and lookup(entry(i,usrw_wkfl.usrw_charfld[1],","),bbusrwwkfl.usrw_charfld[1])<> 0
             no-lock)
          then do:
            message "ERROR:该用户已授权其他分公司".
            next-prompt usrw_charfld[1] with frame a.
            undo , retry.
          end.
        end.
      end.
    end.

    usrw_user1 = global_userid.
    overlay(usrw_charfld[2],1,8) = v_p01.
    overlay(usrw_charfld[2],9,8) = v_p02.
    overlay(usrw_charfld[2],17,8) = v_p03.
    overlay(usrw_charfld[3],1,1) = if v_outtaxin then "Y" else "N" .
    overlay(usrw_charfld[3],2,1) = if v_intaxin then "Y" else "N" .
    overlay(usrw_charfld[3],3,1) = if v_infixrd then "Y" else "N" .
    overlay(usrw_charfld[3],4,1) = if v_inpost then "Y" else "N" .   /* DO NOT USE AUTOMATICAL POST, SO HERE ASSIGN VALUE IS NOT IN USE LB01 */

    overlay(usrw_charfld[6],1,12) = v_name_def[1].
    overlay(usrw_charfld[6],21,8) = string(year(v_name_date[1]),"9999") 
                                           + string(month(v_name_date[1]),"99")
                                           + string(day(v_name_date[1]),"99").
    overlay(usrw_charfld[7],1,12) = v_name_def[2].
    overlay(usrw_charfld[7],21,8) =   string(year(v_name_date[2]),"9999") 
                                           + string(month(v_name_date[2]),"99")
                                           + string(day(v_name_date[2]),"99").
    overlay(usrw_charfld[5],11,8) = v_itemkind.
    
 
    hide frame a no-pause.

    display 
        v_box[1]
        v_box[2]
        v_box[3]
        v_box[4]
        v_box[5]
    with frame b.
/*
    display    
        v_gtax_ip    
        v_gtax_id
        v_gtax_pw
        v_gtax_inbox
        v_gtax_otbox
    with frame c.
*/    
    update 
        v_box[1]
        v_box[2]
        v_box[3]
        v_box[4]
        v_box[5]
    with frame b.
    do i = 1 to 5:  
      v_box[i] = trim(v_box[i]). 
      if v_box[i] <> "" then do:
        if opsys = "unix" then do:
	          if substring(v_box[i],length(v_box[i]),1) <> "/" 
	          then v_box[i] = substr(v_box[i],1,length(v_box[i])) + "/".
	        
	        if can-find(first bbusrwwkfl where bbusrwwkfl.usrw_domain = global_domain
	           and bbusrwwkfl.usrw_key1 = "GOLDTAX-CTRL"
	           and   substring(bbusrwwkfl.usrw_charfld[10],((i - 1) * 60 + 1), 60) = v_box[i]
	           and recid(bbusrwwkfl) <> recid(usrw_wkfl) 
	           no-lock)
	        then do:
	          message "ERROR:路径与其它地点的路径重复".
	          next-prompt v_box[i] with frame b.
	          undo , retry.
	        end.
	    end.
        else if opsys = "win32" then do:
          if substring(v_box[i],length(v_box[i]),1) <> "\" 
          then v_box[i] = substr(v_box[i],1,length(v_box[i])) + "\".
        end.

        /* check directories exist */
        assign l_out = v_box[i] + "TMP" +
                       string(time,"99999") + "." + string(random(0,999),"999").
        {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
        if not l_dir_ok then do:
          message "Warning: UNABLE TO WRITE TO:" + trim(v_box[i]). 
          pause 2.
        end.
      end.
    end.

    overlay(usrw_charfld[10],1,60) = v_box[1].
    overlay(usrw_charfld[10],61,60) = v_box[2].
    overlay(usrw_charfld[10],121,60) = v_box[3].
    overlay(usrw_charfld[10],181,60) = v_box[4].
    overlay(usrw_charfld[10],241,60) = v_box[5].
/*
    update    
        v_gtax_ip    
        v_gtax_id
        v_gtax_pw
        v_gtax_inbox
        v_gtax_otbox
    with frame c.
*/    
    overlay(usrw_charfld[9],1,20) = v_gtax_ip.
    overlay(usrw_charfld[9],21,20) = v_gtax_id.
    overlay(usrw_charfld[9],41,20) = v_gtax_pw.
    overlay(usrw_charfld[9],61,60) = v_gtax_inbox.
    overlay(usrw_charfld[9],121,60) = v_gtax_otbox.
	  usrw_decfld[3]  = v_max_amt.
    hide frame b no-pause.
/*    hide frame c no-pause.
*/
    find first ad_mstr where ad_domain = global_domain and ad_addr = usrw_key4
         no-lock no-error.
    if available ad_mstr then v_adname = ad_name.
                         else v_adname = "".

    display
        usrw_key2
        usrw_charfld[4]
        usrw_key4
        v_adname
        usrw_charfld[1]
        v_p01
        v_p02
        v_p03
        v_name_def[1]
        v_outtaxin
        v_intaxin
        v_infixrd
        v_inpost 
        usrw_decfld[1]  
        v_max_amt
    with frame a.

  end.
  

end.   /* for repeat */
status input.
