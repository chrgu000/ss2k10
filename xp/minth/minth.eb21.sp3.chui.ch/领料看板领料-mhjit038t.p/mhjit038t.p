/* mhjit038.p  看板正常领料  for barcode                                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/2007   BY: Softspeed roger xiao  */ /*xp001*/ 
/* REVISION: 1.1      LAST MODIFIED: 10/22/2007   BY: Softspeed roger xiao  */ /*xp002*/ 
/* REVISION: 1.2      LAST MODIFIED: 2008/05/26   BY: Softspeed roger xiao  */ /*xp003*/ 
/* REVISION: 1.3      LAST MODIFIED: 2008/08/22   BY: Softspeed roger xiao  */ /*xp004*/ 
/* REVISION: 1.4      LAST MODIFIED: 2008/09/02   BY: Softspeed roger xiao   ECO:*xp005*  */ 
/* REVISION: 1.4      LAST MODIFIED: 2008/11/19~2008/12/05   BY: Softspeed Julie Huang  */ /*ss-julie huang*/ 
/* ss-081216.1 by jack 根据rogger修改的条码部分更新此程序*/
/* ss-081216.2 by jack  对看板转移部分重新绑定条码 */
/* ss -090510.1 by: jack */
/* ss - 090514.1 by: jack */
/* ss - 090518.1 by: jack */
/* ss - 090529.1 by: jack */
/* ss - 090603.1 by: jack */  /*抓取领料看板生产线控制领料需求数 */
/* ss - 090605.1 by: jack */ /* 固定看板数量时领料看板数量超出领料需求数时提示警告*/  /* 看板与条码一对一时余量初始化领料数量*/
/* ss - 090608.1 by: jack */  /* 换线时改为新生产线提示*/
/* ss - 090612.1 by: jack */ /* 在领料后清空temp-table*/
/* ss - 090613.1 by: jack */  /* 尾数看板的条码做统一失效再生成绑定*/
/* ss - 090717.1 by: jack */  /* 增加对库位的检测*/
/* ss - 090730.1 by: jack */ /* 版本控制*/
/* ss - 090902.1 by: jack */ /* 换线默认yes*/
/* ss - 090907.1 by: jack */ /* 测试改为抓取换线做零件需求控制*/
/* SS - 100505.1  By: Roger Xiao */ /*发放零头时,加提示*/
/*-Revision end------------------------------------------------------------          */
      
define shared variable execname as character .  execname = "mhjit038.p".
define shared variable global_site as char .
define shared variable global_domain like dom_domain.
define shared variable global_userid like usr_userid.
define shared variable mfguser as character.
define shared variable global_part as character.
define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable batchrun like mfc_logical.
define variable dmdesc like dom_name.
define variable WMESSAGE as char format "x(80)" init "".
define variable wtimeout as integer init 99999 .
define variable undo-input like mfc_logical.




define var v_qty like xkb_kb_qty .
define var v_qty_ls like xkb_kb_qty .  /*正常领料单*/
define var v_qty_ly like xkb_kb_qty .  /*异常领料单*/
define var v_qty_oh like ld_qty_oh .
define var v_qty_iss like ld_qty_oh .
define var v_me_qty like xmpt_me_qty .
define var v_raim_qty  like xkb_kb_raim_qty .
define var v_kb_qty  like xkb_kb_raim_qty . /*xp002*/
define var v_firm as logical .
define var v_qty_old  like xkb_kb_raim_qty . /*ss-julie huang 08/11/19*/
define var v_sum  like xkb_kb_raim_qty . /*ss-julie huang 08/11/19*/

define var v_kb_loc  like xkb_loc . /*ss-julie huang 08/11/19*/
define var v_kb_yn  like xkb_print . /*ss-julie huang 08/11/19*/
define var v_kb_min  like xkb_kb_id . /*ss-julie huang 08/12/05*/

define variable i as integer .
define variable j as integer .
define variable n as integer .

define var v_nbr like xdn_next .
define var v_nbr_ly like xdn_next .
define variable p-type like xdn_type.
define variable p-prev like xdn_prev.
define variable p-next like xdn_next.
define variable m2 as char format "x(8)".
define variable k as integer.


define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define var effdate as date .
define var v_yn as logical format "Y/N" initial yes .
define var v_comb like xppt_comb initial no .
define var v_par like xkb_par .
define var v_part like xkb_part .
define var v_loc like ld_loc .
/* define var site like xkb_site . */

define var sn_from as char format "x(40)" .
define var sn_to   as char format "x(40)" .
define var recno_from  as   recid.
define var recno_to    as   recid.
define var site_from like ld_site .
define var site_to   like ld_site .
define var loc_from  like ld_loc .
define var loc_to    like ld_loc .
define var lot_from  like ld_lot .
define var lot_to    like ld_lot .
define var ref_from  like ld_ref .
define var ref_to    like ld_ref .

define variable from_expire like ld_expire.
define variable from_date like ld_date.
define variable from_status like ld_status no-undo.
define variable from_assay like ld_assay no-undo.
define variable from_grade like ld_grade no-undo.
define variable glcost like sct_cst_tot.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
define new shared variable transtype as character format "x(7)" initial "ISS-TR".
define var v_entity  like si_entity .
define var v_module  as char initial "IC" .
define var v_result  as integer initial 0.
define var v_msg_nbr as integer initial 0.
{gldydef.i new}
{gldynrm.i new}



define buffer xkbhhist for xkbh_hist.

define temp-table tmpkb 
    field tmp_id   like xkb_kb_id
    field tmp_type like xkb_type
    field tmp_part like xkb_part
    field tmp_par  like xkb_par 
    field tmp_site like xkb_site
    field tmp_loc  like xkb_loc
    field tmp_lot  like xkb_lot
    field tmp_ref  like xkb_ref 
    field tmp_qty_ly  like xkb_kb_qty
    field tmp_qty_ls  like xkb_kb_qty.

define temp-table pkb 
    field pkb_id   like xkb_kb_id
    field pkb_type like xkb_type
    field pkb_part like xkb_part
    field pkb_site like xkb_site
    field pkb_loc  like xkb_loc
    field pkb_lot  like xkb_lot
    field pkb_ref  like xkb_ref 
    field pkb_qty  like xkb_kb_qty
    field pkb_nbr  like xkb_kb_id.
/* ss -090510.1 -b */
define var v_prod_line like xkb_prod_line .
/* ss -090510.1 -e */

/* ss-081216.1 -b */
define var i1 as int . /* jack001 记录是否查找到资料 */
define var v_qty_sn3 like ld_qty_oh . /* jack001 记录所需领料总量 */

define var v_need as logical .  /*xp005*/  
define var v_num  as integer .   /*xp005*/ 
define var v_qty_sn like tr_qty_loc .  /*xp005*/ 
define var v_qty_sn2 like tr_qty_loc .  /*xp005*/ 
define var v_sn     as char format "x(30)" .  /*xp005*/
define var v_msg     as char format "x(38)" .  /*xp005*/
define var v_type    like xsn_type . /*xp005*/
define var v_grade   like xsn_grade. /*xp005*/
define var v_shift   like xsn_shift . /*xp005*/
define var v_crt_date like xsn_crt_date . /*xp005*/
define var v_id       like xsn_id . /*xp005*/
define var part       like pt_part .  /*xp005*/
define temp-table temp1  /*xp005*/  
    field t1_type     like xsn_type 
    field t1_crt_date like xsn_crt_date 
    field t1_part     like xsn_part 
    field t1_id       like xsn_id 
    field t1_grade    like xsn_grade 
    field t1_shift    like xsn_shift
    field t1_qty_rct  like xsn_qty_rct   /* 发料数 */
    /* ss - 090514.1 -b */
    FIELD t1_kb       LIKE xsn_kb 
    FIELD t1_type1     AS  LOGICAL
    /* ss - 090514.1 -e */
  .
/* ss -090510.1 -b */
    define var v_line like ro_wkctr .
    define var v_line1 like ln_line .
    define var v_mch like ro_mch .
    define var v_change as logical initial yes .
   
    define buffer xkbmstr for xkb_mstr .
    define variable v_number as int .
    
    define variable v_par1 like pt_part .
    define var v_go as logical .
  
/* ss -090510.1 -e */
define var v_barcode as logical initial no . /* 是否需要按条码控制 */ 

define temp-table temp2 
    field t2_kb_id   like xkb_kb_id
    field t2_type like xkb_type
    field t2_part like xkb_part
    field t2_site like xkb_site
    field t2_loc  like xkb_loc
    field t2_lot  like xkb_lot
    field t2_ref  like xkb_ref 
    field t2_kb_qty  like xkb_kb_qty
    /* ss - 090514.1 -b */
    FIELD t2_kb    LIKE xsn_kb 
    FIELD t2_TYPE1 AS LOGICAL
    /* ss - 090514.1 -e */
    .
/* ss-081216.1 -e */

/* ss - 090514.1 -b */
DEFINE VAR v_kb LIKE xsn_kb .
DEFINE VAR v_qty_end LIKE xkb_kb_raim_qty.  /* 用于尾数看板处理 */
/* ss - 090514.1 -e */


find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
/* ss - 090730.1 -b
dmdesc = "[看板刷读领料]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).
ss - 090730.1 -e */
/* ss - 090730.1 -b */
dmdesc = "[看板刷读领料090907.1]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).

/* ss - 090730.1 -e */

    V1000L:
    REPEAT:
        
        hide all no-pause.
        define variable V1000           as date no-undo .
        define variable L10001          as char format "x(40)".
        define variable L10002          as char format "x(40)".
        define variable L10003          as char format "x(40)".
        define variable L10004          as char format "x(40)".
        define variable L10005          as char format "x(40)".
        define variable L10006          as char format "x(40)".
        
        display dmdesc format "x(40)" skip with fram F1000 no-box.
        
        v_nbr = "" .
        v_nbr_ly = "" .
        v1000 = ? .

        L10001 = "" .
        display L10001          skip with fram F1000 no-box.
        L10002 = "" . 
        display L10002          format "x(40)" skip with fram F1000 no-box.
        L10003 = "" . 
        display L10003          format "x(40)" skip with fram F1000 no-box.
        L10004 = "" . 
        display L10004          format "x(40)" skip with fram F1000 no-box.
        L10005 = "" . 
        display L10005          format "x(40)" skip with fram F1000 no-box.
        L10006 = "生效日期 ? " . 
        display L10006          format "x(40)" skip with fram F1000 no-box.

        V1000 = today.
        
        Update V1000   WITH  fram F1000 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if lastkey = 404 then  Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1000.
           
           APPLY LASTKEY.
        END.
    
        if V1000 = ? then V1000 = today.

        display  skip WMESSAGE NO-LABEL with fram F1000.

        if v1000 < today  then do:
            display "日期不得小于今天,请重新输入." @ WMESSAGE NO-LABEL with fram F1000.
            pause 0  .
            undo ,retry .
        end.

        effdate = v1000 .

        
        find icc_ctrl where icc_domain = global_domain no-lock no-error.
        site_from = if avail icc_ctrl then icc_site else global_site .


	/* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
	find si_mstr where si_domain = global_domain and si_site   = site_from no-lock no-error .
	v_entity = if avail si_mstr then si_entity else "" .
	v_module = "IC" .
	v_result = 0.
	v_msg_nbr = 0 .
	{gprun.i ""gpglef1.p""
	   "( input v_module ,
	     input  v_entity,
	     input  effdate,
	     output v_result,
	     output v_msg_nbr)" }
	if v_result > 0 then do:

	   /* INVALID PERIOD */
	   if v_result = 1 then do:
	      run xxmsg01.p (input 0 , input  "无效会计期间/年份" ,input yes )  .
	   end.
	   /* PERIOD CLOSED FOR ENTITY */
	   else if v_result = 2 then do:
	      run xxmsg01.p (input 0 , input "会计单位" + v_entity + "的期间已结" ,input yes )  .
	   end.
	   /* DEFAULT CASE - SHOULDN'T HAPPEN */
	   else do:
	      run xxmsg01.p (input v_msg_nbr , input "" ,input yes )  .
	   end.

	   undo,retry .
	end.


    
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site_from) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                disp  "看板模块没有开启" @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
            end.
        end.
    
        /* v_nbr */
        /*xp003*/ 
        /*----------------start:get nbr---------------------------*/
        v_nbr  = "" .
        p-type = "LK" .
        p-prev = "" .
        p-next = "" .
        m2 = "".
        k  = 0 .


 /*mage add 08/08/07*******************************************************************************/
     find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type no-lock no-error.
        if available xdn_ctrl then do:
            p-prev = xdn_prev.
            p-next = xdn_next.

            do transaction on error undo, retry:
               find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type exclusive-lock no-error.
               if available xdn_ctrl then do:
                   k = integer(p-next) .
                   m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                   v_nbr = trim(p-prev) + trim(m2).
                   k = integer(p-next) + 1.
                   m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                   xdn_next = m2.
               end.
              if recid(xdn_ctrl) = ? then .
              release xdn_ctrl.
            end. /*do transaction*/

        end. 
        else do:
             find first rpc_ctrl  where rpc_ctrl.rpc_domain = global_domain no-lock no-error .
             if available rpc_ctrl then do:
                 p-prev = rpc_nbr_pre.
                 p-next = string(rpc_nbr,"999999").
             end. 
             else do:
                     disp  "错误:无领料单号控制档"  @ WMESSAGE NO-LABEL with fram F1000.
                     pause 0.
                     undo, retry  .
             end.
           
             do transaction on error undo, retry:
                 find first rpc_ctrl where rpc_ctrl.rpc_domain = global_domain exclusive-lock no-error.
                 if available rpc_ctrl then do:
                     k = integer(p-next) .
                     m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                     v_nbr = trim(p-prev) + trim(m2).
                     k = integer(p-next) + 1.
                     m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                     rpc_nbr = integer(m2).
                 end.
                 if recid(rpc_ctrl) = ? then .
                 release rpc_ctrl.
             end. /*do transaction*/    
          

        end. /*else do: ****/

        
/*mage add 08/08/07*******************************************************************************/

/*mage del 08/08/07*******************************************************************************

        find first rpc_ctrl  where rpc_ctrl.rpc_domain = global_domain no-lock no-error .
        if available rpc_ctrl then do:
            p-prev = rpc_nbr_pre.
            p-next = string(rpc_nbr,"999999").
        end. 
        else do:
                disp  "错误:无领料单号控制档"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.

        do transaction on error undo, retry:
            find first rpc_ctrl where rpc_ctrl.rpc_domain = global_domain exclusive-lock no-error.
            if available rpc_ctrl then do:
                k = integer(p-next) .
                m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                v_nbr = trim(p-prev) + trim(m2).
                k = integer(p-next) + 1.
                m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                rpc_nbr = integer(m2).
            end.
            if recid(rpc_ctrl) = ? then .
            release rpc_ctrl.
        end. /*do transaction*/
*mage del 08/08/07*******************************************************************************/

        /*----------------end:get nbr---------------------------*/

        /*xp003*/ 
        /*----------------start:get nbr---------------------------*/
        v_nbr_ly  = "" .
        p-type = "LY" .
        p-prev = "" .
        p-next = "" .
        m2 = "".
        k  = 0 .
	n  = 0 .



        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type no-lock no-error.
        if available xdn_ctrl then do:
            p-prev = xdn_prev.
            p-next = xdn_next.
        end. 
        else do:
                disp  "错误:无异常领料单号控制档"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.

        do transaction on error undo, retry:
            find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type exclusive-lock no-error.
            if available xdn_ctrl then do:
                k = integer(p-next) .
                m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                v_nbr_ly = trim(p-prev) + trim(m2).
                k = integer(p-next) + 1.
                m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                xdn_next = m2.
            end.
            if recid(xdn_ctrl) = ? then .
            release xdn_ctrl.
        end. /*do transaction*/
        /*----------------end:get nbr---------------------------*/
    
        
        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        display  "" @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        leave V1000L.
    END.  /* END 1000    */

v_loc = "" .

MAINLOOP:
REPEAT: 
if v_result > 0 then leave  .

/* ss-081216.2 -b */
  for each temp2 :
  delete temp2 .
  end .
  /* ss-081216.2 -e */

  /* ss - 090612.1 -b */
   for each temp1 :
   delete temp1 .
   end .
  /* ss - 090612.1 -e */

    for each tmpkb:
        delete tmpkb .
    end.

    for each pkb:
        delete pkb .
    end.

   
    
    v_part = "". 
    j = 0 .
    i = 0.

    hide all no-pause.
    define var v13001          as char format "x(1)" .
    define var v13002          as char format "x(18)" .
    define var v13003          as char format "x(3)" .
    
     V1300L:
     REPEAT:

       
        hide all no-pause.
        define variable V1300           as char format "x(40)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".
    
        display dmdesc format "x(40)" skip with fram F1300 no-box.
    
        L13001 = "领料单号: " + v_nbr  .
        display L13001          skip with fram F1300 no-box.
        L13002 = "生效日期:" + string(effdate)  .  
        display L13002          format "x(40)" skip with fram F1300 no-box.
        L13003 = "张数: " + string(j) .
        display L13003          format "x(40)" skip with fram F1300 no-box.
        L13004 = "" . 
        display L13004          format "x(40)" skip with fram F1300 no-box.
        L13005 = "" .  
        display L13005          format "x(40)" skip with fram F1300 no-box.

        find first tmpkb no-lock no-error .
        L13006 = if avail tmpkb then "请继续刷读领料看板." else "请刷读领料看板." . 
        display L13006          format "x(40)" skip with fram F1300 no-box.
        
        v1300 = "" .
    
        Update V1300   WITH  fram F1300 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if LASTKEY = 404 Then Do: /* DISABLE F4 */
              pause 0 before-hide.
              undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1300.
           
           APPLY LASTKEY.
        END.
    
        display  skip WMESSAGE NO-LABEL with fram F1300.
    

        if v1300 <> "" then do:
            if v1300 = "e" then leave mainloop.
    
              v13001 = substring(v1300,1,1) .  /* xkb_type*/
              v13002 = substring(v1300,2,length(v1300) - 4 ) .  /* xkb_part*/
              v13003 = substring(v1300,length(v1300) - 2 ,3) .    /* xkb_kb_id */
              v_par = "".
    
              if v13001 <> "L" then do:
                    disp "错误:非领料看板,请重新刷读." @ WMESSAGE NO-LABEL with fram F1300. 
                    pause 0.
                    undo, retry.
              end.

              find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                            and ( /*xkb_status = "U"  or*/ xkb_status = "A" ) no-lock no-error .
              if not avail xkb_mstr then do:
                  disp "错误:无看板记录,或非有效状态." @ WMESSAGE NO-LABEL with fram F1300. 
                  pause 0.
                  undo, retry.
              end.
              else do:  /* 检查限制 */
                  /* ss -090510.1 -b */
                    v_prod_line = xkb_prod_line .
                    v_par1 = xkb_par .
                  /* ss -090510.1 -e */
                   

                    find first tmpkb  no-lock no-error .
                    if not avail tmpkb then do:  /*first record */
                        v_part = xkb_part .

                        /*检查 v_me_qty & v_comb */
/************************************************************************************************************************  */
                        v_comb = no .
                        v_me_qty = 0 .
                        find first xmpt_mstr where xmpt_domain  = global_domain and xmpt_site = xkb_site and xmpt_part = v_part no-lock no-error .
                        if avail xmpt_mstr and xmpt_me_qty <> 0 then do:
                            v_me_qty = xmpt_me_qty .
                        end.
                        else do:
                            find first xppt_mstr where xppt_domain  = global_domain and xppt_site = xkb_site and xppt_part = v_part no-lock no-error .
                            if avail xppt_mstr and xppt_me_qty <> 0 then do:
                                v_me_qty = xppt_me_qty .
                            end.
                            else do:
                                disp "错误:无领料看板大小设定." @ WMESSAGE NO-LABEL with fram F1300.
                                pause 0.
                                undo, retry.
                            end.
                        end.
                        v_comb = if avail xmpt_mstr then xmpt_comb else (if avail xppt_mstr then xppt_comb else no ) .
                        /* ss -090510.1 -b */
                          /* ss-090309.1 -b */
		    do on error undo,retry :
                    hide all no-pause .
		    /* ss-090417.1 -b */
		     v_line1 = "" .
		     
		     /* ss-090417.1 -e */
		      /* ss - 090907.1 -b */
                    v_line1 = xkb_prod_line .
                    /* ss - 090907.1 -e */
                      form 
			v_change label "是否换线" skip 
			/* ss - 090608.1 -b
			v_line1  label "新工作中心库位" skip
			   ss - 090608.1 -e */
			   /* ss - 090608.1 -b */
			   v_line1  label "新生产线" skip
			   /* ss - 090608.1 -e */
			v_msg no-label 
		      with frame snsn3 side-labels overlay row 3 width 40 no-attr-space.
			/* ss-090417.1 -b
			view frame snsn3 .
			 ss-090417.1 -e */
			
                        /* ss-090417.1 -b */
			/* ss - 090907.1 -b
			display v_line1 with frame snsn3 .
                           ss - 090907.1 -e */

			display "" @ v_msg with frame snsn3 .
		     /* ss-090417.1 -e */
			update v_change with frame snsn3 .
			
			if v_change = yes then do :
			/* ss - 090907.1 -b */
			v_line1 = "" .
			display v_line1 with frame snsn3 .
			/* ss - 090907.1 -e */
			update v_line1 with frame snsn3 .
			/* ss-090427.1 -b */
			v_prod_Line = v_line1 .
			/* ss-090427.1 -e */
			end .
			hide frame snsn3 no-pause .
		    end.

		       /* ss-090416.1 -b */
			      find first ro_det where ro_domain = global_domain and  ro_routing = xkb_par  
                             and ro_start <= effdate and (ro_end >= effdate or ro_end = ? ) no-lock no-error.
                             if available ro_det then do :
			       if v_change = no then do:
			        v_line = ro_wkctr .
			       end .
			       else do :
			       find first ln_mstr where ln_domain = global_domain and ln_line = v_Line1 no-lock no-error .
			       if available ln_mstr then do :
				assign v_Line = ln__chr03  v_mch = ln__chr04  . /* 存储新工作中心，机器*/
			       end .
			      end .
			     end .
			    /* ss-090416.1 -e */

			      /* ss - 090717.1 -b */
			    find first loc_mstr where loc_domain = global_domain and loc_loc = v_Line no-lock no-error .
			    if not available loc_mstr then do :
			       disp "库位不存在." @ WMESSAGE NO-LABEL with fram F1300.
                                pause 2.
                                undo, retry.
			    end .
			    else do:
			       if loc_loc = "" then do:
			          disp "库位不能为空." @ WMESSAGE NO-LABEL with fram F1300.
				  pause 2.
				  undo, retry.
			       
			       end .
			    end .
			    /* ss - 090717.1 -e */
                     
		     do on error undo ,retry :
		      hide all no-pause .
		      
		     form 
			v_number     label "领料看板数量" skip
			v_msg no-label 
		    with frame snsn1 side-labels overlay row 3 width 40 no-attr-space.
		   /* ss-090417.1 -b */
		    display "" @ v_msg with frame snsn1 .
		    /* ss-090417.1 -e */
		    
                     update v_number with frame snsn1 .
		      
		      if v_number <= 0 then do :
			    display "领料看板不能小于0" @ v_msg no-label with frame snsn1 .
			    /* ss-090417.1 -b */
			    pause 2 .
			    /* ss-090417.1 -e */
			    undo ,retry .
		      end .
		      
		       i =  0 .
		       /* ss-090417.1 -b
		       for each xkbmstr where xkbmstr.xkb_domain = global_domain and xkbmstr.xkb_type = v13001 and xkbmstr.xkb_kb_id > inte(v13003) and xkbmstr.xkb_part = v13002 
                            and xkbmstr.xkb_status = "A"  no-lock :
			 ss-090417.1 -e */
		       /* ss-090417.1 -b */
		        
               /* ss - 090514.1 -b
			 for each xkbmstr where xkbmstr.xkb_domain = global_domain and xkbmstr.xkb_type = v13001  and xkbmstr.xkb_part = v13002 
                            and xkbmstr.xkb_status = "A" and xkbmstr.xkb_par = v_par1 no-lock :
			  ss - 090514.1 -e */
               /* ss - 090514.1 -b */
               for each xkbmstr where xkbmstr.xkb_domain = global_domain and xkbmstr.xkb_type = v13001  and xkbmstr.xkb_part = v13002 
                          and xkbmstr.xkb_status = "A"  no-lock :

               /* ss - 090514.1 -e */
		       /* ss-090417.1 -e */
		         
			
			/* ss-090428.1 -b */
                        i = i + 1 .
			/* ss-090428.1 -e */
		        end .
			/* ss-090417.1 -b
		        if i < v_number - 1 then do :
			   ss-090417.1 -e */
			 /* ss-090417.1 -b */
			  if i < v_number  then do :
			 /* ss-090417.1 -e */
			    display "领料看板下达数太大" @ v_msg no-label with frame snsn1 .
			    /* ss-090417.1 -b */
			    pause 2 .
			    /* ss-090417.1 -e */
			    undo ,retry .
		        end .
			/* ss-090425.1 -b */
	             if v_comb = no then do :
                     /* ss - 090603.1 -b
		     find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = v_line
		     and xkbl_part = xkb_part and xkbl_par = xkb_par  exclusive-lock no-error .
		     end .
		     else do :
		      find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = v_line
				and xkbl_part = xkb_part and xkbl_par = ""  exclusive-lock no-error .
		     end .
               ss - 090603.1 -e */
                     /*  ss - 090603.1 -b */
                     /* ss - 090907.1 -b
                       find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = xkb_prod_line
		     and xkbl_part = xkb_part and xkbl_par = xkb_par  exclusive-lock no-error .
		     end .
		     else do :
		      find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = xkb_prod_line
				and xkbl_part = xkb_part and xkbl_par = ""  exclusive-lock no-error .
		     end .
                     ss - 090907.1 -e */
                     /* ss - 090907.1 -b */
                     find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = v_line1
                    and xkbl_part = xkb_part and xkbl_par = xkb_par  exclusive-lock no-error .
                    end .
                    else do :
                     find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = v_line1
                       and xkbl_part = xkb_part and xkbl_par = ""  exclusive-lock no-error .
                    end .

                     /* ss - 090907.1 -e */

                     /* ss - 090603.1 -e */
                      if available xkbl_det then do :
		         if xkbl_req_num < v_number then do :
			 hide all no-pause .
			   form 
			    v_go     label "是否超领料" skip

			    with frame snsn5 side-labels overlay row 3 width 40 no-attr-space.
			    update v_go with frame snsn5 .
			    if v_go = no then do :
			      undo , retry .
			    end .
			 end .
		      end .
			/* ss-090425.1 -e */
		      hide frame snsn1 no-pause .	   
		     end .
		    /* ss-090309.1 -e */
                        /* ss -090510.1 -e */
                    end.  /*first record */
                    
                    if v_part <> xkb_part then do:
                        disp "错误:限相同零件,请重新刷读." @ WMESSAGE NO-LABEL with fram F1300. 
                        pause 0.
                        undo, retry.
                    end.

                    

                    find first tmpkb where tmp_site = xkb_site and tmp_type = xkb_type 
                                     and tmp_part = xkb_part and tmp_id = xkb_kb_id no-lock no-error .
                    if avail tmpkb then do:
                         display  "此看板已经刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1300.
                         pause 0 .
                         undo v1300l, retry v1300l.
                    end.
                    else do:   /*only once */

                        find first ro_det where ro_domain = global_domain and  ro_routing = xkb_par  
                             and ro_start <= effdate and (ro_end >= effdate or ro_end = ? ) no-lock no-error.
                        if not avail ro_det then do:
                              disp "看板父件无有效工艺设定" @ WMESSAGE NO-LABEL with fram F1300. 
                              pause 0.
                              undo, retry.
                        end.
                        else do:    /*v_par*/
                          
                            /* ss -090510.1 -b
                            find first tmpkb where  tmp_loc <> ro_wkctr no-lock no-error .
                            if avail tmpkb then do:
                                 display  "仅限同库位:" + string(tmp_loc) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1300.
                                 pause 0 .
                                 undo v1300l, retry v1300l.                        
                            end.

                            if v_loc <> "" and v_loc <> ro_wkctr then do:
                                disp "仅限同库位:" + string(v_loc) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1300. 
                                pause 0.
                                undo, retry.
                            end.
                            ss -090510.1 -e */ 
                            /* ss -090510.1 -b */
                              if v_change = no then do:
			     v_line = ro_wkctr .
			     end .
			     else do :
			       find first ln_mstr where ln_domain = global_domain and ln_line = v_Line1 no-lock no-error .
			       if available ln_mstr then do :
			        assign v_Line = ln__chr03  v_mch = ln__chr04  . /* 存储新工作中心，机器*/
			       end .
			     end .

			     find first tmpkb where  tmp_loc <> v_line no-lock no-error .
                            if avail tmpkb then do:
                                 display  "仅限同库位:" + string(tmp_loc) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1300.
                                 pause 0 .
                                 undo v1300l, retry v1300l.                        
                            end.

                            if v_loc <> "" and v_loc <> v_line then do:
                                disp "仅限同库位:" + string(v_loc) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1300. 
                                pause 0.
                                undo, retry.
                            end.
                            /* ss -090510.1 -e */
/* ****************************************************************************************************** */
/*                         v_qty_ls = v_me_qty .           */
/*                         v_qty_ly = 0 .                  */
/*                         create tmpkb .                  */
/*                         assign  tmp_id = xkb_kb_id      */
/*                                 tmp_part  = xkb_part    */
/*                                 tmp_type  = "L"         */
/*                                 tmp_par  = xkb_par      */
/*                                 tmp_site  = xkb_site    */
/*                                 tmp_loc   = ro_wkctr    */
/*                                 tmp_qty_ls = v_qty_ls   */
/*                                 tmp_qty_ly = v_qty_ly . */
/*                         j = j + 1 .                     */  
/*                                                         */
/*                                                         */
/* ****************************************************************************************************** */

                            if v_comb = no then do:    /* 非合并领料 */
                                /* ss -090510.1 -b
                                    find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = ro_wkctr
                                                        and xkbl_part = xkb_part and xkbl_par = xkb_par  exclusive-lock no-error .
                                    ss -090510.1 -e */
                                /* ss -090510.1 -b */
                                /* ss - 090603.1 -b
                                 find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = v_line
                                                        and xkbl_part = xkb_part and xkbl_par = xkb_par  exclusive-lock no-error .
                                     ss  - 090603.1 -e */
                                /* ss - 090603.1 -b */
                                /* ss - 090907.1 -b
                                  find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = xkb_prod_line
                                                        and xkbl_part = xkb_part and xkbl_par = xkb_par  exclusive-lock no-error .
                                ss - 090907.1 -e */
                                /* ss - 090907.1 - b */
				
                                find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = v_line1
                                                    and xkbl_part = xkb_part and xkbl_par = xkb_par  exclusive-lock no-error .
                             /* ss - 090907.1 -e */

                                /* ss - 090603.1 -e */
                                /* ss -090510.1 -e */
                                    if not avail xkbl_det then do:
                                          disp "领料看板无可领料张数设定" @ WMESSAGE NO-LABEL with fram F1300.
                                          pause 0.
                                          undo, retry.
                                    end. /* if not avail xkbl_det */
                                    else do:

                                            if xkbl_req_num >= 1 then do: /* not 超领 */
                                                v_qty_ls = v_me_qty .
                                                v_qty_ly = 0 .
                                                xkbl_req_num = xkbl_req_num - 1 .
                                                xkbl_mod_date = today .

                                            end.  /* not 超领 */
                                            else do:
                                                xkbl_mod_date = today .
                                                v_qty_ls = 0 .
                                                v_qty_ly = v_me_qty .
                                                xkbl_req_num = 0 .

                                                disp "超领单号:" +  v_nbr_ly   @ WMESSAGE NO-LABEL with fram F1300.
                                                pause 1 no-message before-hide .
                                            end.  /*  超领 */


                                    end.  /* if  avail xkbl_det*/

                                    create tmpkb .
                                    assign  tmp_id = xkb_kb_id
                                            tmp_part  = xkb_part
                                            tmp_type  = "L"
                                            tmp_par  = xkb_par
                                            tmp_site  = xkb_site
                                          /* ss -090510.1 -b 
                                            tmp_loc   = ro_wkctr
                                            ss -090510.1 -e */
                                        /* ss -090510.1 -b */
                                        tmp_loc   = v_line
                                        /* ss -090510.1 -e */
                                            tmp_qty_ls = v_qty_ls
                                            tmp_qty_ly = v_qty_ly .
                                    j = j + 1 .

                                    if v_loc = ""  then v_loc = tmp_loc .
                                    /* ss -090510.1 -b */
                                      /* ss-090309.1 -b */
				     v_number = v_number - 1 .
				     /* ss-090417.1 -b */
				      if v_number >= 1 then do :
				        for each xkbmstr where xkbmstr.xkb_domain = global_domain and xkbmstr.xkb_type = v13001 and xkbmstr.xkb_kb_id <> inte(v13003) and xkbmstr.xkb_part = v13002
					       and xkbmstr.xkb_status = "a" and xkbmstr.xkb_par = v_par1 no-lock :
                            /* ss - 090603.1 -b
					    find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkbmstr.xkb_site and xkbl_line = v_line
		                			and xkbl_part = xkbmstr.xkb_part and xkbl_par = xkbmstr.xkb_par  exclusive-lock no-error .
                                 ss - 090603.1 -e */
                            /* ss - 090603.1 -b */
                            /* ss - 090907.1 -b
                                 find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkbmstr.xkb_site and xkbl_line = xkb_prod_line
		                			and xkbl_part = xkbmstr.xkb_part and xkbl_par = xkbmstr.xkb_par  exclusive-lock no-error .
                            ss - 090907.1 -e */
                            /* ss - 090907.1 -b */
                            find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkbmstr.xkb_site and xkbl_line = v_line1
                                   and xkbl_part = xkbmstr.xkb_part and xkbl_par = xkbmstr.xkb_par  exclusive-lock no-error .
                          /* ss - 090907.1 -e */

                            /* ss - 090603.1 -e */
                          
					    /* ss-090309.1 -e */
					    if  avail xkbl_det then do:
						     if xkbl_req_num >= 1 then do: /* not 超领 */
							v_qty_ls = v_me_qty .
							v_qty_ly = 0 .
							xkbl_req_num = xkbl_req_num - 1 .
							xkbl_mod_date = today .

						    end.  /* not 超领 */
						    else do:
							xkbl_mod_date = today .
							v_qty_ls = 0 .
							v_qty_ly = v_me_qty .
							xkbl_req_num = 0 .

							disp "超领单号:" +  v_nbr_ly   @ WMESSAGE NO-LABEL with fram F1300.
							pause 1 no-message before-hide .
						    end.  /*  超领 */
                                               end .

					    create tmpkb .
					    assign  tmp_id = xkbmstr.xkb_kb_id
						    tmp_part  = xkbmstr.xkb_part
						    tmp_type  = "L"
						    tmp_par  = xkbmstr.xkb_par
						    tmp_site  = xkbmstr.xkb_site
						    /* ss-090309.1 -b */
						    /* tmp_loc   = ro_wkctr */
						    tmp_loc   = v_line
						    /* ss-090309.1 -e */
						    tmp_qty_ls = v_qty_ls
						    tmp_qty_ly = v_qty_ly .
					    j = j + 1 .
					    if v_loc = ""  then v_loc = tmp_loc .
					     v_number = v_number - 1 .
					    if v_number < 1 then leave . 
					    
					end .
				       end . /* v_number >= 1 */
				      /* ss-090417.1 -e */
				    				     
				    /* ss-090309.1 -e */
                                    /* ss -090510.1 -e */


                            end.  /* 非合并领料 */
                            else do : /* 合并领料 */
                                /* ss -090510.1 -b
                                    find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = ro_wkctr
                                                        and xkbl_part = xkb_part and xkbl_par = ""  exclusive-lock no-error .
                                   ss -090510.1 -e */
                                /* ss -090510.1 -b */
				                /* ss - 090603.1 -b
                                 find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = v_line
                                                        and xkbl_part = xkb_part and xkbl_par = ""  exclusive-lock no-error .
                                ss - 090603.1 -e */
                                /* ss - 090603.1 -b */
                                /* ss - 090907.1 -b
                                find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = xkb_prod_line
                                                       and xkbl_part = xkb_part and xkbl_par = ""  exclusive-lock no-error .
                                ss - 090907.1 -e */
                                /* ss - 090907.1 -b */
                                find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkb_site and xkbl_line = v_line1
                                                       and xkbl_part = xkb_part and xkbl_par = ""  exclusive-lock no-error .
                                /* ss - 090907.1 -e */

                                /* ss - 090603.1 -e */
                                /* ss -090510.1 -e */
                                    if not avail xkbl_det then do:
                                          disp "领料看板无可领料张数设定" @ WMESSAGE NO-LABEL with fram F1300.
                                          pause 0.
                                          undo, retry.
                                    end. /* if not avail xkbl_det */
                                    else do:

                                            if xkbl_req_num >= 1 then do: /* not 超领 */
                                                v_qty_ls = v_me_qty .
                                                v_qty_ly = 0 .
                                                xkbl_req_num = xkbl_req_num - 1 .
                                                xkbl_mod_date = today .

                                            end.  /* not 超领 */
                                            else do:
                                                xkbl_mod_date = today .
                                                v_qty_ls = 0 .
                                                v_qty_ly = v_me_qty .
                                                xkbl_req_num = 0 .

                                                disp "超领单号:" +  v_nbr_ly   @ WMESSAGE NO-LABEL with fram F1300.
                                                pause 1 before-hide no-message .
                                            end.  /*  超领 */


                                    end.  /* if  avail xkbl_det*/

                                    create tmpkb .
                                    assign  tmp_id = xkb_kb_id
                                            tmp_part  = xkb_part
                                            tmp_type  = "L"
                                            tmp_par  = xkb_par
                                            tmp_site  = xkb_site
                                        /* ss -090510.1 -b
                                            tmp_loc   = ro_wkctr
                                           ss -090510.1 -e */
                                        /* ss -090510.1 -b */
                                        tmp_loc  = v_line
                                        /* ss -090510.1 -e */
                                            tmp_qty_ls = v_qty_ls
                                            tmp_qty_ly = v_qty_ly .
                                            j = j + 1 .
				   if v_loc = ""  then v_loc = tmp_loc .
                       /* ss -090510.1 -b */
                         /* ss-090309.1 -b */
				     v_number = v_number - 1 .
                                      /* ss-090417.1 -b */
				       if v_number >= 1 then do :
				      for each xkbmstr where xkbmstr.xkb_domain = global_domain and xkbmstr.xkb_type = v13001 and xkbmstr.xkb_kb_id <> inte(v13003) and xkbmstr.xkb_part = v13002
				               and xkbmstr.xkb_status = "a" and xkbmstr.xkb_par = v_par1 no-lock :
                          /* ss - 090603.1 -b 
					     find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkbmstr.xkb_site and xkbl_line = v_line
								and xkbl_part = xkbmstr.xkb_part and xkbl_par = ""  exclusive-lock no-error .
                                ss - 090603.1 -e */
                          /* ss - 090603.1 -b */
                          /* ss - 090907.1 -b
                           find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkbmstr.xkb_site and xkbl_line = xkb_prod_line
								and xkbl_part = xkbmstr.xkb_part and xkbl_par = ""  exclusive-lock no-error .
                          ss - 090907.1 -e */
                          /* ss - 090907.1 -b */
                          find first xkbl_det where xkbl_domain= global_domain and xkbl_site = xkbmstr.xkb_site and xkbl_line = v_line1
                               and xkbl_part = xkbmstr.xkb_part and xkbl_par = ""  exclusive-lock no-error .
                         /* ss - 090907.1 -e */

                          /* ss - 090603.1 -e */
					   
						   /* ss-090414.1 -e */
					    /* ss-090309.1 -e */
					    if  avail xkbl_det then do:
						    if xkbl_req_num >= 1 then do: /* not 超领 */
							v_qty_ls = v_me_qty .
							v_qty_ly = 0 .
							xkbl_req_num = xkbl_req_num - 1 .
							xkbl_mod_date = today .

						    end.  /* not 超领 */
						    else do:
							xkbl_mod_date = today .
							v_qty_ls = 0 .
							v_qty_ly = v_me_qty .
							xkbl_req_num = 0 .

							disp "超领单号:" +  v_nbr_ly   @ WMESSAGE NO-LABEL with fram F1300.
							pause 1 no-message before-hide .
						    end.  /*  超领 */

                                               end .
					      create tmpkb .
					    assign  tmp_id = xkbmstr.xkb_kb_id
						    tmp_part  = xkbmstr.xkb_part
						    tmp_type  = "L"
						    tmp_par  = xkbmstr.xkb_par
						    tmp_site  = xkbmstr.xkb_site
						    /* ss-090309.1 -b */
						    /* tmp_loc   = ro_wkctr */
						    tmp_loc   = v_line
						    /* ss-090309.1 -e */
						    tmp_qty_ls = v_qty_ls
						    tmp_qty_ly = v_qty_ly .
					    j = j + 1 .
					    if v_loc = ""  then v_loc = tmp_loc .
					     v_number = v_number - 1 .
					     if v_number < 1 then leave .
				      end . 
				      end . /* v_number >= 1 */
				      /* ss-090417.1 -e */
				    /* ss-090309.1 -e */

                       /* ss -090510.1 -e */

                            end. /* 合并领料 */
    
                        end.   /*v_par*/
                    end. /*only once */
              end. /* 检查限制 */
    
        end. /*  if v1300 <> "" */
        else do:  /*转出看板loop*/
         n = j .
            find first tmpkb no-lock no-error .
            if not avail tmpkb then do:
                disp "请先刷读看板才可执行"   @ WMESSAGE NO-LABEL with fram F1300. 
                pause 0 .
                undo ,retry .
            end.


            /* message "料号:" v_part view-as alert-box . */

            v_qty = 0 .    /*领料总数*/
            v_qty_iss = 0 .     /*发料总数*/
	    v_qty_old = 0.
	   
            for each tmpkb no-lock :
                v_qty = v_qty  + tmp_qty_ly + tmp_qty_ls  .
            end.


             V1100L:
             REPEAT:

                 /* ss-081216.1 -b */
		 v_barcode = no .
		 /* ss-081216.1 -e */
                hide all no-pause .
                define variable V1100           as char format "x(40)" .
                define variable L11001          as char format "x(40)".
                define variable L11002          as char format "x(40)".
                define variable L11003          as char format "x(40)".
                define variable L11004          as char format "x(40)".
                define variable L11005          as char format "x(40)".
                define variable L11006          as char format "x(40)".
        
        
                display dmdesc format "x(40)" skip with fram F1100 no-box.

                   find first tmpkb where tmp_qty_ls > 0 no-lock no-error .
                   L11001 = if avail tmpkb then "领料单号: " + v_nbr else "" .
                display L11001          skip with fram F1100 no-box.
                   find first tmpkb where tmp_qty_ly > 0 no-lock no-error .
                   L11002 = if avail tmpkb then ("超领单号: " + v_nbr_ly) else ""  . 
                display L11002          format "x(40)" skip with fram F1100 no-box.
                L11003 = "生效日期: " + string(effdate) . 
                display L11003          format "x(40)" skip with fram F1100 no-box.
                L11004 = "领料总数: " + string(v_qty) . 
                display L11004          format "x(40)" skip with fram F1100 no-box.
                L11005 = "累计可发料数: " + string(v_qty_iss) . 
                display L11005          format "x(40)" skip with fram F1100 no-box.
                find first pkb no-lock no-error .
                L11006 = if avail pkb then "继续刷读或直接确认执行." else "请刷读采购或生产看板." . 
                display L11006          format "x(40)" skip with fram F1100 no-box.
                
        	    V1100 = "" .
        
            	Update V1100     WITH  fram F1100 NO-LABEL
                /* ROLL BAR START */
                EDITING:
                   readkey pause wtimeout.
                   if lastkey = -1 then quit.
                   if LASTKEY = 404 Then Do: /* DISABLE F4 */
                      pause 0 before-hide.
                      undo, retry.
                   end.
                   display skip "^" @ WMESSAGE NO-LABEL with fram F1100.
                   
                   APPLY LASTKEY.
                END.
        
                display  skip WMESSAGE NO-LABEL with fram F1100.
        
                if v1100 <> ""  then do:
                    if v1100 = "e" then leave mainloop.
                    
                    v13001 = substring(v1100,1,1) .  /* xkb_type*/
                    v13002 = substring(v1100,2,length(v1100) - 4 ) .  /* xkb_part*/
                    v13003 = substring(v1100,length(v1100) - 2 ,3) .    /* xkb_kb_id */
                    
                    if (v13001 <> "M" and v13001 <> "P" ) then do:
                        disp "错误:仅限生产看板或采购看板." @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0.
                        undo, retry.
                    end.
            
                    if v13002 <> v_part then do:
                        disp "错误:仅限与领料看板同零件的看板." @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0.
                        undo, retry.            
                    end.

		    /* ss-081216.1 -b */
		     v_need = no .  /*xp005*/ 
                    find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error . /*xp005*/ 
                    if avail pt_mstr then do: /*xp005*/ 
                        if pt__chr08 = "Y" then v_need = yes .  /*xp005*/ 
                    end. /*xp005*/ 
		     /* ss-081216.1 -e */
            
                    find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                                   and (xkb_status = "U" and xkb_kb_raim_qty > 0) no-lock no-error .
                    if not avail xkb_mstr then do:
                        disp "错误:无看板记录,或不在使用状态." @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0.
                        undo, retry.
                    end.
                    else do:  /*if avail xkb_mstr */
		    /*****************************ss-julie huang 08/12/05 add****************************************/
		    find first pkb no-lock no-error.
                     if not available pkb then v_kb_min = integer(substring(v1100,length(v1100) - 2 ,3)).
		     if available pkb and ( v_kb_min > integer(substring(v1100,length(v1100) - 2 ,3)) or v_kb_min = 0 ) then
		     v_kb_min = integer(V13003).
		    /*****************************ss-julie huang 08/12/05 add****************************************/

                        if xkb_type = "M" then do:
                            find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                            v_firm = if avail xmpt_mstr then xmpt_qty_firm else no .
                        end.
                        if xkb_type = "P" then do:
                            find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                            v_firm = if avail xppt_mstr then xppt_qty_firm else no .
                        end.

                        find first pkb where ( pkb_loc <> xkb_loc or pkb_lot <> xkb_lot or pkb_ref <> xkb_ref ) no-lock no-error .
                        if avail pkb then do:
                             display  "限同库位/批序,请重新输入" @ WMESSAGE NO-LABEL with fram F1100.
                             pause 0 .
                             undo v1100l, retry v1100l.
                        end.
    
                        find first pkb where pkb_site = xkb_site and pkb_type = xkb_type 
                                         and pkb_part = xkb_part and pkb_id = xkb_kb_id no-lock no-error .
                        if avail pkb then do:
                             display  "此看板已经刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1100.
                             pause 0 .
                             undo v1100l, retry v1100l.
                        end.

			/* ss-081216.1 -b */
			 /*xp005***begin*/ 
                         if v_need = yes then do:
                            find first xsn_mstr 
                                where xsn_domain = global_domain 
                                and xsn_kb       = v1100 
                                and xsn_stat     = "U"
                            no-lock no-error .
                            if avail xsn_mstr then do:
                                v_num = 0 .
                                v_qty_sn = 0 .
                                /* ss -090510.1 -b
                                for each xsn_mstr 
                                    where xsn_domain = global_domain 
                                    and xsn_kb       = v1100 
                                    and xsn_stat     = "U"
                                no-lock :
                                ss -090510.1 -e */
                                /* ss -090510.1 -b */
                                 for each xsn_mstr 
                                    where xsn_domain = global_domain 
                                    and xsn_kb       = v1100 
                                    and xsn_stat     = "U" and ( xsn_expire = ? or (xsn_expire <> ? and xsn_expire >= today) )
                                no-lock :
				
                                /* ss -090510.1 e */
                                    if xsn_site <> xkb_site 
                                    or xsn_loc <> xkb_loc 
                                    or xsn_lot <> xkb_lot
                                    or xsn_ref <> xkb_ref 
                                    then do:
                                        disp "错误:条码与看板不同库位批序" @ WMESSAGE NO-LABEL with fram F1100.
                                        undo,retry .
                                    end.

                                    v_num = v_num + 1 .
                                    v_qty_sn  = v_qty_sn + xsn_qty_end .
                                end.
				   if v_qty_sn <> xkb_kb_raim_qty then do:
                                    disp "错误:条码与看板余量有差异"   @ WMESSAGE NO-LABEL with fram F1100.
                                    undo,retry .
                                end.

                                v_qty_sn = 0 .
                                if v_num = 1 then do: /*条码看板1:1*/
                                   find first xsn_mstr where xsn_domain = global_domain and xsn_kb = v1100  and xsn_stat = "U" no-lock no-error .
                                   
                                    if avail xsn_mstr then do:
                                        if xsn_expire <> ? and xsn_expire < today then do:
                                            disp "条码过期日:" xsn_expire @ WMESSAGE NO-LABEL with fram F1100.
                                            undo,retry .
                                        end.
                                    
                                        create temp1 .
                                        assign 
                                            t1_type      = xsn_type 
                                            t1_crt_date  = xsn_crt_date
                                            t1_part      = xsn_part
                                            t1_shift     = xsn_shift 
                                            t1_grade     = xsn_grade 
                                            t1_id        = xsn_id
                                            /* ss - 090514.1 -b */
                                            t1_kb       = v1100
                                            /* ss - 090514.1 -e */
                                            .
					    /* ss-081216.1 -b */
					    v_barcode = yes .
					    /* ss-081216.1 -e */
                                      
                                            do on error undo,retry :
                                                hide all no-pause .
                                                form 
                                                    v_qty_sn label "发料数量" skip 
                                                    v_msg no-label 
                                                with frame snsn2 side-labels overlay row 3 width 40 no-attr-space.
                                                view frame snsn2 .
						/* ss - 090609.1 -b
                        /* ss - 090605.1 -b */
						v_qty_sn = xsn_qty_end .
						/* ss - 090605.1 -e */
                        ss - 090609.1 -e */
                                                /* ss - 090609.1 -b */
                                                v_qty_sn = v_qty .
                                                /* ss - 090609.1 -e */

                                                update v_qty_sn with frame snsn2 .

                                                if v_qty_sn = 0 then leave mainloop .

                                                if v_qty_sn <0 or  v_qty_sn > xsn_qty_end then do:
                                                    disp "超过条码余量" @ v_msg with frame snsn2 .
                                                    undo,retry .
                                                end.
                                          
                                                /* ss - 090609.1 -b*/
                                                IF v_qty_sn  <> v_qty THEN DO:
                                                    DISP "发料数量与领料数量需一致" @ v_msg WITH FRAME snsn2 .
                                                    UNDO,RETRY .
                                                END.
                                                /* ss - 090609.1 -e */
                                             

                                                hide frame snsn2 no-pause .
                                            end.


                                            t1_qty_rct   = v_qty_sn .
                                    end.

                                end. /*条码看板1:1*/
                                else do:  /*条码看板N:1*/
                                    hide all no-pause .
                                    form 
                                        v_sn     label "条码" skip
                                        v_qty_sn label "发料数量" skip 
                                        v_msg no-label 
                                    with frame snsn side-labels overlay row 3 width 40 no-attr-space.

                                    view frame snsn .
                                    repeat :
                                        v_sn = "" .
                                        v_qty_sn = 0 . 
                                        
                                        disp v_qty_sn v_sn with frame snsn .
                                        update v_sn with frame snsn .

                                        if v_sn = "e" then leave mainloop .
                                        if length(v_sn) < 13 then do:
                                            display "错误:无效条码" @ v_msg with frame snsn.
                                            pause 0.
                                            undo,retry .
                                        end.

                                        v_type = substring(v_sn,1,1) .
                                        v_crt_date = date(inte(substring(v_sn,4,2)) ,inte(substring(v_sn,6,2)),inte("20" + substring(v_sn,2,2))) .
                                        v_grade = substring(v_sn,length(v_sn),1) .
                                        v_shift = substring(v_sn,length(v_sn) - 1,1) . /*列印之后才有班次,不是关键字段*/
                                        v_id    = inte(substring(v_sn,length(v_sn) - 4 ,3)).
                                        part    = substring(v_sn,8,length(v_sn) - 12) .

                                        find first temp1 
                                            where t1_type   = v_type 
                                            and t1_crt_date = v_crt_Date 
                                            and t1_part     = part 
                                            and t1_id       = v_id 
                                            /*and t1_grade    = v_grade 
                                            and t1_shift    = v_shift */
                                        no-lock no-error .
                                        if avail temp1 then do:
                                            disp "不可重复刷读条码" @  v_msg with frame snsn.
                                            undo,retry .
                                        end.

                                        find first xsn_mstr 
                                            where xsn_domain = global_domain 
                                            and xsn_type = v_type 
                                            and xsn_crt_date = v_crt_Date 
                                            and xsn_part  = part 
                                            and xsn_id    = v_id 
                                            /*and xsn_grade = v_grade 
                                            and xsn_shift = v_shift */
                                        no-lock no-error .
                                        if not avail xsn_mstr then do:
                                                disp "错误:无对应条码主档记录"  @  v_msg with frame snsn.
                                                undo,retry.            
                                        end.   /*找到了才继续执行,且字段可直接使用 */

                                        if xsn_stat <> "U" then do:
                                            disp "错误:条码非有效状态"  @  v_msg with frame snsn.
                                            undo,retry.
                                        end.  

                                        if xsn_kb <> v1100 then do:
                                            disp "错误:非此看板绑定条码"  @  v_msg with frame snsn.
                                            undo,retry.
                                        end.

                                        if xsn_qty_end <= 0  then do:
                                            disp "错误:条码库存已消耗尽"  @  v_msg with frame snsn.
                                            undo,retry.
                                        end. 

                                        if xsn_expire <> ? and xsn_expire < today then do:
                                            disp "条码过期日:" + string( xsn_expire ) @ WMESSAGE NO-LABEL with fram F1100.
                                            undo,retry .
                                        end.

					/* jack001 begins 判断是否之前还有条码 */
                                          i1 = 0 .
					  v_qty_sn3 = 0 .
					   for each xsn_mstr no-lock where xsn_domain = global_domain and xsn_type = v_type 
					   and xsn_part = part and xsn_kb = v1100 and (xsn_expire = ? or (xsn_expire <> ? and xsn_expire >= today )) 
					   and xsn_qty_end > 0 and xsn_stat = "U" and  ( xsn_site = xkb_site and xsn_loc = xkb_loc 
                                            and xsn_lot = xkb_lot and xsn_ref = xkb_ref )  by xsn_expire by xsn_rct_date by xsn_id  :
					   
					    find first temp1 where t1_type   = v_type  and t1_crt_date = xsn_crt_Date 
                                               and t1_part     = xsn_part  and t1_id = xsn_id   no-lock no-error .
			                      if  available temp1 then next .
					      
                                           find ld_det where ld_domain = global_domain and ld_part = xsn_part and ld_site = xkb_site
                                            and ld_loc = xkb_loc and ld_lot = xkb_lot and ld_ref = xkb_ref  no-lock no-error.
			                      /* 无此批/序库存*/
                                             if not available ld_det then  next . 

					     /* 将条码剩余量做为最大领料量 */
                                             v_qty_sn3 = xsn_qty_end .
			                     /* 统计总共需要领料量 */
                                             for each temp1 :
                                              v_qty_sn3 = v_qty_sn3 + t1_qty_rct .
                                              end.
                         
			                      /* 库存不足总领料量 */
                                              if ld_qty_oh < v_qty_sn3 then  next .
                                              
			                      i1 =  1 .
			                      if i1 = 1 then do :
					        display "系统建议先出本条码:" + xsn_type + string(xsn_crt_date,"999999" ) + xsn_part + string(xsn_id,"999") + xsn_shift + xsn_grade  @ v_msg with frame snsn .
			                       pause 5 .
					       /*    message "系统建议先出本条码:" xsn_type + string(xsn_crt_date,"999999" ) + xsn_part + string(xsn_id,"999") + xsn_shift + xsn_grade view-as alert-box . */
			                      leave . 
                                              end .  
			  		   end .
			                 /* jack001 end */

					 /* jack001 begins */
					  find first xsn_mstr 
                                            where xsn_domain = global_domain 
                                            and xsn_type = v_type 
                                            and xsn_crt_date = v_crt_Date 
                                            and xsn_part  = part 
                                            and xsn_id    = v_id 
                                            /*and xsn_grade = v_grade 
                                            and xsn_shift = v_shift */
                                        no-lock no-error .
					/* jack001 end */
                                        
                                        update v_qty_sn with frame snsn .
                                        if v_qty_sn <= 0 or v_qty_sn > xsn_qty_end then do:
                                                disp "错误:数量无效"  @  v_msg with frame snsn.
                                                undo,retry.            
                                        end.

                                        v_qty_sn2 = 0 .
                                        for each temp1 :
                                            v_qty_sn2 = v_qty_sn2 + t1_qty_rct .
                                            
                                        end.

                                        if  v_qty_sn + v_qty_sn2 > v_qty then do: /****保证按照整张条码的余量发料,避免再后面的调整逻辑*****/
                                            disp "错误:条码发料数超过领料数"  @  v_msg with frame snsn.
                                            undo,retry.
                                        end.  

                                        
                                        create temp1.
                                        assign 
                                            t1_type      = xsn_type 
                                            t1_crt_date  = xsn_crt_date
                                            t1_part      = xsn_part
                                            t1_shift     = xsn_shift 
                                            t1_grade     = xsn_grade 
                                            t1_id        = xsn_id
                                            t1_qty_rct   = v_qty_sn
                                            /* ss - 090514.1 -b */
                                            t1_kb        = v1100
                                            /* ss - 090514.1 -e */
                                            
                                            .   
                                            /* ss-081216.1 -b */
					    v_barcode = yes .
					    /* ss-081216.1 -e */

                                            if v_qty_sn + v_qty_sn2 = v_qty then leave .
                                        
                                    end.
                                    hide frame snsn no-pause.
                                    
                                end. /*条码看板N:1*/
                            end.
                            else do:
                                disp "警告:条码零件无条码主档" @ WMESSAGE NO-LABEL with fram F1100.
				/* ss-081216.2 -b */
			         v_barcode = no .
			        /* ss-081216.2 -e */
                            end.
                         end.  
                        
			/* ss-081216.2 -b */
		      
		      /* v_qty_sn = 0 .
                        for each temp1 :
                            v_qty_sn = v_qty_sn + t1_qty_rct .
                        end. */
			if v_barcode = yes then do :
                        v_qty_sn = 0 .
                        for each temp1 :
                            v_qty_sn = v_qty_sn + t1_qty_rct .
                        end.
			end .
			/* ss-081216.2 -e */

                         /*xp005***end*/ 
			/* ss-081216.1 -e */

                        for each ld_det where ld_domain = global_domain and ld_site = xkb_site and ld_part = xkb_part 
                                        and ld_loc = xkb_loc and ld_lot = xkb_lot and ld_ref = xkb_ref and ld_qty_oh > 0 no-lock:
                            v_qty_oh = v_qty_oh + ld_qty_oh .
                        end.
                        
			/* ss-081216.2 -b */
			  if v_barcode  = yes then do :
                          /* if v_qty_oh < xkb_kb_raim_qty then do: */
		           /*if v_qty_oh < xkb_kb_raim_qty then do:   *xp005*/  
                              if v_qty_oh < v_qty_sn then do:   /*xp005*/
			    /* ss-081216.1 -e */
                               disp "有效库存(" + string(v_qty_oh) + ")小于看板余量" @ WMESSAGE NO-LABEL with fram F1100.
                              pause 0.
                               undo, retry.
                             end.
			   end . 
			  else do :
			             if v_qty_oh < xkb_kb_raim_qty then do:		       
			
                            disp "有效库存(" + string(v_qty_oh) + ")小于看板余量" @ WMESSAGE NO-LABEL with fram F1100.
                            pause 0.
                            undo, retry.
                             end.
			  end .
			  /* ss-081216.2 -e */

		              if v_qty_iss >= v_qty and not v_firm then do:
			           disp "累计可发料数量已大于等于领料总数" @ WMESSAGE NO-LABEL with fram F1100.
                            pause 0.
                            undo, retry.
                        end.
			/* ss - 09605.1-
                        if  i >= j  and v_firm then do:
                           disp "累计可发料张数已大于等于领料张数" @ WMESSAGE NO-LABEL with fram F1100.
                            pause 0.
                            undo, retry.
                        end.
			ss - 090605.1 -e */
			/* ss - 090605.1 -b */
			 if  i >= j  and v_firm then do:
                           disp "累计可发料张数已大于等于领料张数" @ WMESSAGE NO-LABEL with fram F1100.
                            pause 5.
                         end.

  
			/* ss - 090605.1 -e */

              IF v_qty_oh >= xkb_kb_raim_qty THEN do: /*if v_qty_oh >= xkb_kb_raim_qty */
			    /* ss-081216.2 -b */
			    if v_barcode = yes then do :
                             create pkb .
                             assign pkb_id = xkb_kb_id 
                                pkb_part  = xkb_part 
                                pkb_type  = xkb_type
                                pkb_site  = xkb_site 
                                pkb_loc   = xkb_loc   
                                pkb_lot   = xkb_lot
                                pkb_ref   = xkb_ref 
                                pkb_qty   = /*xkb_kb_raim_qty *xp005*/ v_qty_sn    /* ss-081216.1 */
				pkb_nbr   = i + 1 .
                                v_qty_iss = v_qty_iss + /*xkb_kb_raim_qty *xp005*/ v_qty_sn. /* ss-081216.1 */

								v_kb_qty  = xkb_kb_qty . /*xp002*/
                                site_from = xkb_site .
                                loc_from = xkb_loc .
                                lot_from = xkb_lot .
                                ref_from = xkb_ref .
			     end .
			     else do :
			       create pkb .
                             assign pkb_id = xkb_kb_id 
                                pkb_part  = xkb_part 
                                pkb_type  = xkb_type
                                pkb_site  = xkb_site 
                                pkb_loc   = xkb_loc   
                                pkb_lot   = xkb_lot
                                pkb_ref   = xkb_ref 
                                pkb_qty   = xkb_kb_raim_qty  
				pkb_nbr   = i + 1 .
                                v_qty_iss = v_qty_iss + xkb_kb_raim_qty .

				v_kb_qty  = xkb_kb_qty . /*xp002*/
                                site_from = xkb_site .
                                loc_from = xkb_loc .
                                lot_from = xkb_lot .
                                ref_from = xkb_ref .
			     end .
			     /* ss-081216.2 -e */

                            
                        end. /*if v_qty_oh >= xkb_kb_raim_qty */
                    end.  /*if avail xkb_mstr */                    
                end.  /*if v1100 <> ""  then */
                else do :   /*if v1100 = ""  then */
                      
		      /* ss-081216.2 -b */  /* 看板绑定了条码才需要控制 */
		     if v_barcode  = yes then do :
		    /* ss-081216.1 -b */
		    /*xp005*********begin*/
                    v_qty_sn = 0 .
                    for each temp1 :
                        v_qty_sn = v_qty_sn + t1_qty_rct .
                    end.
                    if v_qty < v_qty_sn then do:
                        disp "条码刷读量超过领料量!" @ WMESSAGE NO-LABEL with fram F1100.
                        undo ,retry .
                    end.
		    end . 
		    /* ss-081216.2 -e */
                    /*xp005***********end*/ 
		    /* ss-081216.1 -e */
                       
		    

                    if v_qty > v_qty_iss then do:
                        disp "累计发料数不足:" + string(v_qty_iss)  @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0 .

                        if not v_firm then do:
                            run xxmsg02.p (input 0 , input  "按累计可发料数发料?" ,output v_firm )  .
                            if v_firm = no then do:
                                run xxmsg01.p (input 0 , input  "领料失败:看板余量不足" ,input yes )  .
                                undo ,retry .
                            end.
                        end.
                        else do :
                                run xxmsg01.p (input 0 , input  "失败:欠料且看板容量固定" ,input yes )  .
                                undo ,retry .
                        end.
                       
                        
                        for each tmpkb exclusive-lock:
                            if v_qty_iss < 0 then assign tmp_qty_ly = 0  tmp_qty_ls = 0 .
    
                            if tmp_qty_ls <> 0 then do :
                                        assign tmp_qty_ls = min(tmp_qty_ls,v_qty_iss) .
                                        v_qty_iss = v_qty_iss - tmp_qty_ls .
					
                            end.
                            if tmp_qty_ly <> 0 then do :
                                        assign tmp_qty_ly = min(tmp_qty_ly,v_qty_iss) .
                                        v_qty_iss = v_qty_iss - tmp_qty_ly .
                            end.
                        end.
                    end. /* if v_qty > v_qty_iss */
                    else if v_qty < v_qty_iss then do:  /* if v_qty < v_qty_iss */
                        /*v_qty_iss = v_qty .*/  /*xp002*/

						
						if v_kb_qty <> v_me_qty then do :
                        /****************xp004*/
                        /*xp004****************看板余量超过领料需求: 看板容量> (2*领料看板大小)时,优先发看板余量零头量*/
                            if v_kb_qty >= 2 * v_me_qty and ( v_qty_iss mod v_me_qty <> 0 ) then do:
                                for last tmpkb exclusive-lock:
                                    if tmp_qty_ls <> 0 then do :
                                                assign tmp_qty_ls = v_qty_iss mod v_me_qty .
						                                               
                                    end.
                                    if tmp_qty_ly <> 0 then do :
                                                assign tmp_qty_ly = v_qty_iss mod v_me_qty .
                                    end.
                                end.	
                                /* SS - 100505.1 - B */
                                run xxmsg01.p (input 0 , input  "实发零头数量:" + string(v_qty_iss mod v_me_qty) ,input yes )  .
                                /* SS - 100505.1 - E */                                
                            end.
                        /*xp004****************/
						end. /*xp002*/
						else do: /*xp002*/
                            /*xp002****************看板余量超过领料需求: 看板容量=领料看板大小时,照看板余量全发完*/
							for last tmpkb exclusive-lock:
								if tmp_qty_ls <> 0 then do :
											assign tmp_qty_ls = tmp_qty_ls + v_qty_iss - v_qty .
										   
								end.
								if tmp_qty_ly <> 0 then do :
											assign tmp_qty_ly = tmp_qty_ly + v_qty_iss - v_qty .
								end.
							end.								
						end. /*xp002*/
						
					end. /* if v_qty < v_qty_iss */
					else do:  /* if v_qty = v_qty_iss */
					end.


 
                        
                        V1500L:
                        REPEAT:
                                                                                                               
                            define buffer tmpkb2 for tmpkb .

                            hide all no-pause .
                            define variable V1500           as logical .
                            define variable L15001          as char format "x(40)".
                            define variable L15002          as char format "x(40)".
                            define variable L15003          as char format "x(40)".
                            define variable L15004          as char format "x(40)".
                            define variable L15005          as char format "x(40)".
                            define variable L15006          as char format "x(40)".
            
                            display dmdesc format "x(40)" skip with fram F1500 no-box.
            
                            L15001 = "" .
                            display L15001          skip with fram F1500 no-box.
                            L15002 = ""  .
                            display L15002          format "x(40)" skip with fram F1500 no-box.
                            L15003 = ""  .
                            display L15003          format "x(40)" skip with fram F1500 no-box.
                            L15004 = "" .
                            display L15004          format "x(40)" skip with fram F1500 no-box.
                            L15005 = "" .
                            display L15005          format "x(40)" skip with fram F1500 no-box.
                            L15006 = "执行领料 ? " .
                            display L15006          format "x(40)" skip with fram F1500 no-box.
            
                            v1500 = yes .
            
                            Update V1500   WITH  fram F1500 no-label EDITING:
                                readkey pause wtimeout.
                                if lastkey = -1 then quit.
                                if LASTKEY = 404 Then Do: /* DISABLE F4 */
                                    pause 0 before-hide.
                                    undo, retry.
                                end.
                                display skip "^" @ WMESSAGE NO-LABEL with fram F1500.
                                APPLY LASTKEY.
                            END.
                            display  skip WMESSAGE NO-LABEL with fram F1500.
            
                            if v1500 then do:
                                for each tmpkb where tmp_qty_ls > 0 or tmp_qty_ly > 0 no-lock 
                                    break by tmp_site by tmp_loc by tmp_par by tmp_lot by tmp_ref :

                                    if first-of(tmp_ref) then do:
                                        assign site_to = tmp_site 
                                               loc_to = tmp_loc 
                                               v_par = tmp_par 
                                               lot_to = lot_from 
                                               ref_to = ref_from .
                                               v_qty_ls = 0 .
                                               v_qty_ly = 0 .
                                    end.

                                   v_qty_ls = v_qty_ls +  tmp_qty_ls .
                                   v_qty_ly = v_qty_ly +  tmp_qty_ly .

                                   if last-of(tmp_ref) then do:

                                          /*产生正常领料库存交易记录*/
                                          if v_qty_ls > 0 then do:
                                                for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
                                                          delete sr_wkfl.
                                                end.
                
                                                create  sr_wkfl. sr_wkfl.sr_domain = global_domain.
                                                assign  sr_userid = mfguser
                                                        sr_lineid = string(1) + "::" + v_part
                                                        sr_site = site_from
                                                        sr_loc = loc_from
                                                        sr_lotser = string(string(lot_from,"x(18)") + string(lot_to,"x(18)") )
                                                        sr_qty = v_qty_ls
                                                        sr_ref = ref_from
                                                        sr_user1 = v_nbr
                                                        sr_rev = loc_to
                                                        sr_user2 = v_part.
                                                if recid(sr_wkfl) = -1 then .
            
            
                                                from_expire = ?.
                                                from_date = ?.
                                                from_assay = 0.
                                                from_grade = "".
                                                global_part = v_part .
            
                                                find ld_det where ld_det.ld_domain = global_domain and  ld_part = v_part
                                                            and ld_site = site_from and ld_loc = loc_from and ld_lot = lot_from and ld_ref = ref_from  no-lock no-error.
                                                if available ld_det then do:
                                                assign
                                                    from_status = ld_status
                                                    from_expire = ld_expire
                                                    from_date = ld_date
                                                    from_assay = ld_assay 
                                                    from_grade = ld_grade.
                                                end.
                                                
                                                find ld_det exclusive-lock where ld_det.ld_domain = global_domain and  ld_part = v_part
                                                            and ld_site = site_to and ld_loc = loc_to and ld_lot = lot_to and ld_ref = ref_to no-error.
                                                if not available ld_det then do:
                                                    create ld_det. ld_det.ld_domain = global_domain.
                                                    assign
                                                    ld_site = site_to
                                                    ld_loc = loc_to
                                                    ld_part = v_part
                                                    ld_lot = lot_to
                                                    ld_ref = ref_to .
                                                    if recid(ld_det) = -1 then .
                                                
                                                    find loc_mstr no-lock  where loc_mstr.loc_domain = global_domain and loc_site = ld_site  and loc_loc = ld_loc no-error.
                                                    if available loc_mstr then ld_status = loc_status.
                                                    else do:
                                                        find si_mstr no-lock  where si_mstr.si_domain = global_domain and si_site = ld_site no-error.
                                                        if available si_mstr then ld_status = si_status.
                                                    end.
                                                end. /* not available ld_det */
                                                
                                                if from_expire <> ? then ld_expire = from_expire.
                                                if from_date <> ? then ld_date = from_date.
                                                ld_assay = from_assay.
                                                ld_grade = from_grade.

                                              j = 1 .
                                              find pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
                                              {gprun.i ""icedit.p""
                                                       "(""RCT-TR"",
                                                         site_to,
                                                         loc_to,
                                                         pt_part,
                                                         lot_to,
                                                         ref_to,
                                                         v_qty_ls,
                                                         pt_um,
                                                         v_nbr,
                                                         j,
                                                         output undo-input)"}
                                              if undo-input then undo , retry.
                                              j = 2 .
                                              {gprun.i ""icedit.p""
                                                       "(""ISS-TR"",
                                                         site_from,
                                                         loc_from,
                                                         pt_part,
                                                         lot_from,
                                                         ref_from,
                                                         v_qty_ls,
                                                         pt_um,
                                                         v_nbr,
                                                         j,
                                                         output undo-input)"}
                                              if undo-input then undo , retry.

                                              {gprun.i ""icxfer.p""
                                                 "("""",
                                                   sr_lotser,
                                                   ref_from,
                                                   ref_to,
                                                   sr_qty,
                                                   v_nbr,
                                                   """",
                                                   """",
                                                   """",
                                                   effdate,
                                                   site_from,
                                                   loc_from,
                                                   site_to,
                                                   loc_to,
                                                   no,
                                                   """",
                                                   ?,
                                                   """",
                                                   0,
                                                   """",
                                                   output glcost,
                                                   output iss_trnbr,
                                                   output rct_trnbr,
                                                   input-output from_assay,
                                                   input-output from_grade,
                                                   input-output from_expire)"
                                                 }
                                              
                                                   /*disp  string(iss_trnbr) + " " + string(rct_trnbr)  @ l21003 with frame f2100 no-box .  pause . */
            
                                              find tr_hist where tr_domain = global_domain and tr_trnbr = rct_trnbr exclusive-lock no-error .
                                              if avail tr_hist then  assign tr_addr = loc_to tr_rmks = v_par .
                                              find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                              if avail tr_hist then  assign tr_addr = loc_to tr_rmks = v_par  .
                                          end.
                                         /*产生正常领料库存交易记录*/
        
                                          /*产生超领料库存交易记录*/ 
                                          if v_qty_ly > 0 then do:
                                                for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
                                                          delete sr_wkfl.
                                                end.
                
                                                create  sr_wkfl. sr_wkfl.sr_domain = global_domain.
                                                assign  sr_userid = mfguser
                                                        sr_lineid = string(1) + "::" + v_part
                                                        sr_site = site_from
                                                        sr_loc = loc_from
                                                        sr_lotser = lot_from
                                                        sr_qty = v_qty_ly
                                                        sr_ref = ref_from
                                                        sr_user1 = v_nbr_ly.
                                                        sr_rev = loc_to.
                                                        sr_user2 = v_part.
                                                if recid(sr_wkfl) = -1 then .
                
                                                /* disp sr_lineid @ l21002 with frame f2100 no-box .  pause . */
                
                
                                                    from_expire = ?.
                                                    from_date = ?.
                                                    from_assay = 0.
                                                    from_grade = "".
                                                    global_part = v_part .
                
                                                    find ld_det where ld_det.ld_domain = global_domain and  ld_part = v_part
                                                                and ld_site = site_from and ld_loc = loc_from and ld_lot = lot_from and ld_ref = ref_from  no-lock no-error.
                                                    if available ld_det then do:
                                                    assign
                                                        from_status = ld_status
                                                        from_expire = ld_expire
                                                        from_date = ld_date
                                                        from_assay = ld_assay 
                                                        from_grade = ld_grade.
                                                    end.
                                                    
                                                    find ld_det exclusive-lock where ld_det.ld_domain = global_domain and  ld_part = v_part
                                                                and ld_site = site_to and ld_loc = loc_to and ld_lot = lot_to and ld_ref = ref_to no-error.
                                                    if not available ld_det then do:
                                                        create ld_det. ld_det.ld_domain = global_domain.
                                                        assign
                                                        ld_site = site_to
                                                        ld_loc = loc_to
                                                        ld_part = v_part
                                                        ld_lot = lot_to
                                                        ld_ref = ref_to .
                                                        if recid(ld_det) = -1 then .
                                                    
                                                        find loc_mstr no-lock  where loc_mstr.loc_domain = global_domain and loc_site = ld_site  and loc_loc = ld_loc no-error.
                                                        if available loc_mstr then ld_status = loc_status.
                                                        else do:
                                                            find si_mstr no-lock  where si_mstr.si_domain = global_domain and si_site = ld_site no-error.
                                                            if available si_mstr then ld_status = si_status.
                                                        end.
                                                    end. /* not available ld_det */
                                                    
                                                    if from_expire <> ? then ld_expire = from_expire.
                                                    if from_date <> ? then ld_date = from_date.
                                                    ld_assay = from_assay.
                                                    ld_grade = from_grade.
                
                                                  j = 1 .
                                                  find pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
                                                  {gprun.i ""icedit.p""
                                                           "(""RCT-TR"",
                                                             site_to,
                                                             loc_to,
                                                             pt_part,
                                                             lot_to,
                                                             ref_to,
                                                             v_qty_ly,
                                                             pt_um,
                                                             v_nbr_ly,
                                                             j,
                                                             output undo-input)"}
                                                  if undo-input then undo , retry.

        
                                                  j = 2 .
                                                  {gprun.i ""icedit.p""
                                                           "(""ISS-TR"",
                                                             site_from,
                                                             loc_from,
                                                             pt_part,
                                                             lot_from,
                                                             ref_from,
                                                             v_qty_ly,
                                                             pt_um,
                                                             v_nbr_ly,
                                                             j,
                                                             output undo-input)"}
                                                  if undo-input then undo , retry.
                                                    
                                                    
                                                    {gprun.i ""icxfer.p""
                                                     "("""",
                                                       sr_lotser,
                                                       ref_from,
                                                       ref_to,
                                                       sr_qty,
                                                       v_nbr_ly,
                                                       """",
                                                       """",
                                                       """",
                                                       effdate,
                                                       site_from,
                                                       loc_from,
                                                       site_to,
                                                       loc_to,
                                                       no,
                                                       """",
                                                       ?,
                                                       """",
                                                       0,
                                                       """",
                                                       output glcost,
                                                       output iss_trnbr,
                                                       output rct_trnbr,
                                                       input-output from_assay,
                                                       input-output from_grade,
                                                       input-output from_expire)"
                                                     }
                                                  
                                                  /*disp  string(iss_trnbr) + " " + string(rct_trnbr)  @ l21003 with frame f2100 no-box .  pause . */       
                                                  find tr_hist where tr_domain = global_domain and tr_trnbr = rct_trnbr exclusive-lock no-error .
                                                  if avail tr_hist then  assign tr_addr = loc_to  tr_rmks = v_par .
                                                  find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                                  if avail tr_hist then  assign tr_addr = loc_to  tr_rmks = v_par .
                                          end.  /*产生超领料库存交易记录*/

                                           /*领料 */
                                          for each tmpkb2 where tmpkb2.tmp_id = tmpkb.tmp_id and tmpkb2.tmp_site =tmpkb.tmp_site 
                                              and tmpkb2.tmp_loc = tmpkb.tmp_loc and tmpkb2.tmp_lot =tmpkb.tmp_lot and tmpkb2.tmp_ref = tmpkb.tmp_ref no-lock :
                                                   
                                                    find xkb_mstr where xkb_domain = global_domain and xkb_site =  tmpkb2.tmp_site and xkb_part =  tmpkb2.tmp_part 
                                                                  and xkb_type = "L" and xkb_kb_id =  tmpkb2.tmp_id exclusive-lock no-error.
                                                    if avail xkb_mstr then do : 
                                                        assign  xkb_upt_date = today    xkb_loc = loc_to  xkb_lot = lot_to  xkb_ref = ref_to  .
                                                        
                                                        v_trnbr = rct_trnbr .
                                                        {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="xkb_status"       &c_status="xkb_status"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                                                    end.
                                          end.

                                            /*发料 */

                                            v_qty = v_qty_ls + v_qty_ly .
					    
					    define buffer tmpxkb for xkb_mstr .
					    define buffer tmpxkb2 for xkb_mstr .
                                            for each pkb where pkb_qty > 0 exclusive-lock :
                                                    if v_qty <= 0 then next .
                                                    find first xkb_mstr where xkb_domain = global_domain and xkb_site = pkb_site 
                                                         and xkb_type = pkb_type and xkb_part = pkb_part and xkb_kb_id = pkb_id  exclusive-lock no-error .
                             /********************************************ss-julie huang 08/11/19 add ***********************************************/   
                                                    if avail xkb_mstr then do: /* 临时表存在*/
                                                     /* message xkb_kb_raim_qty v_qty view-as alert-box . */
						                             v_raim_qty = xkb_kb_raim_qty .
						       
						       
                             /*********************************************ss-julie huang 08/11/19 add***********************************************/   
                             /*********************************************ss-julie huang 08/11/19 del***********************************************   
                                                        xkb_kb_raim_qty =  if v_qty > xkb_kb_raim_qty  then 0 else xkb_kb_raim_qty - v_qty  .
                                                        xkb_upt_date = today .
                                                        v_qty = v_qty - v_raim_qty  . 
                                                        pkb_qty = xkb_kb_raim_qty .
                                                        
            
                                                        v_trnbr = rct_trnbr .
                                                        {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="xkb_status"       &c_status="xkb_status"
                                                                    &rain_qty="xkb_kb_raim_qty"}
            
                                                        if xkb_kb_raim_qty = 0 then do:
							     xkb_status = "A" .
                                                             {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"       &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr=v_trnbr
                                                                    &b_status="'U'"       &c_status="'A'"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                             *********************************************ss-julie huang 08/11/19 del***********************************************/   
/*******************************************************************ss-julie huang 08/11/19 add *******************************************************************************/
			                             
						      if v_qty >= v_raim_qty then do: /*发料数量大于看板余量*/
                                                        xkb_kb_raim_qty =  0 .
						        xkb_upt_date = today .
                                                        v_qty = max(v_qty - v_raim_qty,0).
                                                        v_trnbr = rct_trnbr .
							v_kb_loc = xkb_loc.
                                                        xkb_status = "A" .
                                                             {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"       &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr=v_trnbr
                                                                    &b_status="'U'"       &c_status="'A'"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                                                        end. 
							else do: /*发料数量小于看板余量*/
                                                        if pkb_id = 0 then do:
							       
							       xkb_kb_raim_qty =  xkb_kb_raim_qty - v_qty .
							       xkb_upt_date = today .
                                                               v_trnbr = rct_trnbr .

							     

							       if v_raim_qty = 0 and xkb_kb_raim_qty <> 0 then do:
							       xkb_status = "U".
                                                               {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="'A'"       &c_status="xkb_status"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                                                               message "尾数看板余量已更新为" + string(xkb_kb_raim_qty) . pause.
							       end.
							       if v_raim_qty <> 0 and xkb_kb_raim_qty <> 0 then do:
							       {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="xkb_status"       &c_status="xkb_status"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                                                               message "尾数看板余量已更新为" + string(xkb_kb_raim_qty) . pause.
							       end.
							       if v_raim_qty <> 0 and xkb_kb_raim_qty = 0 then do:
							       {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="'U'"       &c_status="xkb_status"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                                                               message "尾数看板余量已更新为" + string(xkb_kb_raim_qty) . pause.
							       end.
							end. /*if xkb_kb_id = 0 then do: */
							if pkb_id <> 0 then do:                                                        
 							xkb_kb_raim_qty =  0 .
						        xkb_upt_date = today .
							v_qty_old = v_raim_qty - v_qty .
                                                        v_trnbr = rct_trnbr .
							v_kb_loc = xkb_loc.
                                                        xkb_status = "A" .
                                                             {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"       &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr=v_trnbr
                                                                    &b_status="'U'"       &c_status="'A'"
                                                                    &rain_qty="xkb_kb_raim_qty"} 
								    
								  
                             /* ss - 090514.1 -b */
                                find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .  
                                    if avail pt_mstr then  /*xp005*/ 
                                        if pt__chr08 = "Y" then v_need = yes .
                               IF v_need = YES THEN DO:
                               v_qty_end  = 0 .
                               v_kb = xkb_type + xkb_part + STRING(xkb_kb_id,"999") .
                               FOR EACH temp1 WHERE t1_kb = v_kb :
                                   v_qty_end = v_qty_end + t1_qty_rct .
                                   t1_type1 = YES .
				    /* ss - 090610.1 -b */
				       find first xsn_mstr 
                                        where xsn_domain = global_domain 
                                        and xsn_type     = t1_type
                                        and xsn_crt_date = t1_crt_date
                                        and xsn_part     = t1_part
                                        and xsn_id       = t1_id 
                                        no-error .
					assign xsn_qty_end = t1_qty_rct .  /* 本看板当做全部转完*/
					

				       /* ss - 090610.1 -e */
                                   IF v_qty_end >= v_qty   THEN DO:
				   
                                       t1_qty_rct = v_qty - (v_qty_end - t1_qty_rct) .
				       xsn_qty_end = t1_qty_rct .
				      
                                      LEAVE . 
                                   END.
                                 
                               END.

			      
                                
                               /* ss更新需转移的条码 */
                               FOR EACH temp1 WHERE t1_kb = v_kb AND t1_type1 = NO :
                                    for each xsn_mstr 
                                        where xsn_domain = global_domain 
                                        and xsn_type     = t1_type
                                        and xsn_crt_date = t1_crt_date
                                        and xsn_part     = t1_part
                                        and xsn_id       = t1_id 
                                        :
                                        xsn_mod_date  = today .
                                        xsn_qty_end   = 0 .   
                                        xsn_stat      = "R".
					
                                    end.
				   

                                    DELETE temp1 . /* 删除条码中转移部分*/
                               END.
                             END.
                             /* ss - 090514.1 -e */                                    

							find first tmpxkb where tmpxkb.xkb_domain = global_domain and tmpxkb.xkb_site = pkb_site 
                                                        and tmpxkb.xkb_type = pkb_type and tmpxkb.xkb_part = pkb_part and tmpxkb.xkb_kb_id = 0 exclusive-lock no-error .
							if avail tmpxkb then do: /*尾数看板存在*/
							    if (v_qty_old + tmpxkb.xkb_kb_raim_qty) >= v_kb_qty then do: /*尾数看板余量+ 看板余量>= 看板包装量*/
							       v_raim_qty = tmpxkb.xkb_kb_raim_qty .
							       tmpxkb.xkb_kb_raim_qty = (v_qty_old + tmpxkb.xkb_kb_raim_qty) - v_kb_qty .
							       tmpxkb.xkb_upt_date = today .
                                                               v_trnbr = rct_trnbr .
							       if v_raim_qty = 0 and tmpxkb.xkb_kb_raim_qty <> 0 then do:
							       xkb_status = "U".
                                                               {xxkbhist.i   &type="tmpxkb.xkb_type"      &part="tmpxkb.xkb_part"      &site="tmpxkb.xkb_site"
                                                                    &kb_id="tmpxkb.xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="tmpxkb.xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="'A'"       &c_status="tmpxkb.xkb_status"
                                                                    &rain_qty="tmpxkb.xkb_kb_raim_qty"}
                                                               message "尾数看板余量已更新为" + string(tmpxkb.xkb_kb_raim_qty) . pause.
							       end.
							       if v_raim_qty <> 0 and tmpxkb.xkb_kb_raim_qty <> 0 then do:
							       {xxkbhist.i   &type="tmpxkb.xkb_type"      &part="tmpxkb.xkb_part"      &site="tmpxkb.xkb_site"
                                                                    &kb_id="tmpxkb.xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="tmpxkb.xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="tmpxkb.xkb_status"       &c_status="tmpxkb.xkb_status"
                                                                    &rain_qty="tmpxkb.xkb_kb_raim_qty"}
                                                               message "尾数看板余量已更新为" + string(tmpxkb.xkb_kb_raim_qty) . pause.
							       end.
							       if v_raim_qty <> 0 and xkb_kb_raim_qty = 0 then do:
							       {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="'U'"       &c_status="xkb_status"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                                                               message "尾数看板余量已更新为" + string(tmpxkb.xkb_kb_raim_qty) . pause.
							       end.
                                    /*更新尾数看板的条码资料 */ 
                                   /* ss - 090514.1 -b */
                                 IF v_need = YES THEN DO:
                                  v_kb = tmpxkb.xkb_type + tmpxkb.xkb_part + string(tmpxkb.xkb_kb_id,"999").
				  /* ss - 090518.1 -b 
                                   FIND FIRST xsn_mstr WHERE xsn_domain = GLOBAL_domain AND xsn_type = tmpxkb.xkb_type
                                         AND xsn_kb = v_kb AND xsn_status = "u" AND xsn_id = 999 NO-LOCK NO-ERROR.
			             ss - 090518.1 -e */
				     /* ss - 090518.1 -b */
				  /* ss - 090613.1 -b
				      FIND FIRST xsn_mstr WHERE xsn_domain = GLOBAL_domain AND xsn_type = tmpxkb.xkb_type
                                         AND xsn_kb = v_kb AND xsn_status = "u" AND xsn_id = 0  NO-ERROR.
				     /* ss - 090518.1 -e */
                                   IF AVAILABLE xsn_mstr  THEN DO:
                                       ASSIGN xsn_qty_end = tmpxkb.xkb_kb_raim_qty .
                                   
                                   END.
                                   ELSE DO:
				  ss - 090613.1 -e */
				   /* ss -090613.1 -b */
				   /* 原来尾数看板条码统一失效*/
				   for each  xsn_mstr WHERE xsn_domain = GLOBAL_domain AND xsn_type = tmpxkb.xkb_type
                                         AND xsn_kb = v_kb AND xsn_status = "u" AND xsn_id = 0 : 
			            assign
				        xsn_status = "a"
					xsn_qty_end = 0 
					xsn_mod_date = today 
					.
				    end .
				   /* ss - 090613.1 -e */
                                        
					/* ss - 090612.1 -b */
				    FIND FIRST xsn_mstr WHERE xsn_domain = GLOBAL_domain AND xsn_type = tmpxkb.xkb_type
                                         AND xsn_crt_date = today  AND xsn_id = 0 and xsn_part = tmpxkb.xkb_part NO-ERROR.
			              if available xsn_mstr then do :
				          assign xsn_qty_end = tmpxkb.xkb_kb_raim_qty
					         xsn_status = "u"
						 xsn_mod_date = today 
						 .
				      end .
				      else do :
				   /* ss - 090612.1 -e */
                                       create xsn_mstr .
                              assign xsn_domain = global_domain 
                                     xsn_site  = tmpxkb.xkb_site
                                     xsn_type = tmpxkb.xkb_type
                                     xsn_crt_date = TODAY
                                                             /* ss - 090518.1 -b 
    							     xsn_id = 999
							     ss - 090518.1 -e */
							     /* ss - 090518.1 -b */
							     xsn_id = 0
 							     /* ss - 090518.1 -e */
    							     xsn_part = tmpxkb.xkb_part 
    							     xsn_qty_end = tmpxkb.xkb_kb_raim_qty
    							     xsn_qty_rct = tmpxkb.xkb_kb_raim_qty
    							     xsn_status =  "u"
    							     xsn_loc = tmpxkb.xkb_loc
    							     xsn_lot = tmpxkb.xkb_lot
    							     xsn_ref = tmpxkb.xkb_ref 
    							     xsn_kb = tmpxkb.xkb_type + tmpxkb.xkb_part + string(tmpxkb.xkb_kb_id, "999")
    							     xsn_pr_date = today
    							     xsn_mod_date = today 
    							      .
                                    
                                        end .
                                  
				  /* ss - 090613.1 -b
				  end .
				   ss - 090613.1 -e */
                                  
                                END.
                                   /* ss - 090514.1 -e */
							       find first tmpxkb2 where tmpxkb2.xkb_domain = global_domain and tmpxkb2.xkb_site = pkb_site 
                                                               and tmpxkb2.xkb_type = pkb_type and tmpxkb2.xkb_part = pkb_part and tmpxkb2.xkb_kb_id = min( pkb_id , v_kb_min) 
							       and tmpxkb2.xkb_status = "A"  exclusive-lock no-error.
                                                               if avail tmpxkb2  then do: /*存在空的有效看板*/
							         v_raim_qty = tmpxkb2.xkb_kb_raim_qty.
								 tmpxkb2.xkb_status = "U".
								 tmpxkb2.xkb_kb_raim_qty = v_kb_qty.
								 tmpxkb2.xkb_upt_date = today .
								 tmpxkb2.xkb_loc = v_kb_loc .
                                                                 v_trnbr = rct_trnbr .

								 /* ss-081216.2 -b */  /* 存储看板转移后需要绑定条码的看板*/
                                  IF v_need = YES THEN DO:
                                  
								  find first xsn_mstr where xsn_domain = global_domain and xsn_kb = pkb_type + pkb_part + string(tmpxkb2.xkb_kb_id,"999") no-lock no-error .
								  if available xsn_mstr then do :
                                  				 find first temp2 where  t2_site = pkb_site and t2_type = pkb_type and 
								 t2_part = pkb_part and t2_kb_id = tmpxkb2.xkb_kb_id no-error .
								  if not available temp2 then do :
								  create temp2 .
								  assign  t2_type = pkb_type
								         t2_site = pkb_site 
									 t2_part = pkb_part 
                                                                          t2_kb_id = tmpxkb2.xkb_kb_id
									  t2_kb_qty = tmpxkb2.xkb_kb_raim_qty  .
									 
								    end .
								   end .
                                  END.
								 /* ss-081216.2 -e */
								 
                                                                 {xxkbhist.i   &type="tmpxkb2.xkb_type"      &part="tmpxkb2.xkb_part"      &site="tmpxkb2.xkb_site"
                                                                    &kb_id="tmpxkb2.xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="tmpxkb2.xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="'A'"       &c_status="'U'"
                                                                    &rain_qty="tmpxkb2.xkb_kb_raim_qty"}
            
                                                                 message "采购看板" + string(tmpxkb2.xkb_kb_id,"999") + "号已被重新绑定库存，状态改为U。" . pause .
								
								end. /*end for 存在空的有效看板*/
							    end. /* end for 尾数看板余量+ 看板余量> 看板包装量*/
							    else do: /*尾数看板余量+ 看板余量 < 看板包装量*/
							    
							       v_raim_qty = tmpxkb.xkb_kb_raim_qty .
							       tmpxkb.xkb_kb_raim_qty = v_qty_old + tmpxkb.xkb_kb_raim_qty.
							       tmpxkb.xkb_upt_date = today .
                                                               v_trnbr = rct_trnbr .
							       

                                                               if v_raim_qty = 0 and tmpxkb.xkb_kb_raim_qty <> 0 then do:
							       tmpxkb.xkb_status = "U".
                                                               {xxkbhist.i   &type="tmpxkb.xkb_type"      &part="tmpxkb.xkb_part"      &site="tmpxkb.xkb_site"
                                                                    &kb_id="tmpxkb.xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="tmpxkb.xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="'A'"       &c_status="tmpxkb.xkb_status"
                                                                    &rain_qty="tmpxkb.xkb_kb_raim_qty"}
                                                               message "尾数看板余量已更新为" + string(tmpxkb.xkb_kb_raim_qty) . pause .
							       end.
							       if v_raim_qty <> 0 and tmpxkb.xkb_kb_raim_qty <> 0 then do:
							       {xxkbhist.i   &type="tmpxkb.xkb_type"      &part="tmpxkb.xkb_part"      &site="tmpxkb.xkb_site"
                                                                    &kb_id="tmpxkb.xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                                    &qty="tmpxkb.xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="tmpxkb.xkb_status"       &c_status="tmpxkb.xkb_status"
                                                                    &rain_qty="tmpxkb.xkb_kb_raim_qty"}
                                                               message "尾数看板余量已更新为" + string(tmpxkb.xkb_kb_raim_qty) . pause .

							       end.

                                    /*更新尾数看板的条码资料 */ 
                                   /* ss - 090514.1 -b */
                                 IF v_need = YES THEN DO:
                                  v_kb = tmpxkb.xkb_type + tmpxkb.xkb_part + string(tmpxkb.xkb_kb_id,"999") .
				  /* ss - 090518.1 -b
                                   FIND FIRST xsn_mstr WHERE xsn_domain = GLOBAL_domain AND xsn_type = tmpxkb.xkb_type
                                         AND xsn_kb = v_kb AND xsn_status = "u" AND xsn_id = 999 NO-LOCK NO-ERROR.
				    ss - 090518.1 -e */
				    /* ss - 090518.1 -b */
				    /* ss - 090613.1 -b
				    FIND FIRST xsn_mstr WHERE xsn_domain = GLOBAL_domain AND xsn_type = tmpxkb.xkb_type
                                         AND xsn_kb = v_kb AND xsn_status = "u" AND xsn_id = 0 NO-ERROR.
				    /* ss - 090518.1 -e */
                                   IF AVAILABLE xsn_mstr  THEN DO:
                                       ASSIGN xsn_qty_end = tmpxkb.xkb_kb_raim_qty .

				        
                                       
                                   END.
				   ELSE DO:
				   ss - 090613.1 -e */
				     /* ss -090613.1 -b */
				   /* 原来尾数看板条码统一失效*/
				   for each  xsn_mstr WHERE xsn_domain = GLOBAL_domain AND xsn_type = tmpxkb.xkb_type
                                         AND xsn_kb = v_kb AND xsn_status = "u" AND xsn_id = 0 :
			            assign
				        xsn_status = "a"
					xsn_qty_end = 0 
					xsn_mod_date = today 
					.
				    end .
				   /* ss - 090613.1 -e */
				   /* ss - 090612.1 -b */
				    FIND FIRST xsn_mstr WHERE xsn_domain = GLOBAL_domain AND xsn_type = tmpxkb.xkb_type
                                         AND xsn_crt_date = today  AND xsn_id = 0 and xsn_part = tmpxkb.xkb_part NO-ERROR.
			              if available xsn_mstr then do :
				          assign xsn_qty_end = tmpxkb.xkb_kb_raim_qty
					         xsn_status = "u"
						 xsn_mod_date = today 
						 .
				      end .
				      else do :
				   /* ss - 090612.1 -e */
                                       create xsn_mstr .
                              assign xsn_domain = global_domain 
                                     xsn_site  = tmpxkb.xkb_site
                                     xsn_type = tmpxkb.xkb_type
                                     xsn_crt_date = TODAY
    							    /* ss - 090518.1 -b
							     xsn_id = 999
							     ss - 090518.1 -e */
							     /* ss - 090518.1 -b */
							     xsn_id = 0
							     /* ss - 090518.1 -e */
    							     xsn_part = tmpxkb.xkb_part 
    							     xsn_qty_end = tmpxkb.xkb_kb_raim_qty
    							     xsn_qty_rct = tmpxkb.xkb_kb_raim_qty
    							     xsn_status =  "u"
    							     xsn_loc = tmpxkb.xkb_loc
    							     xsn_lot = tmpxkb.xkb_lot
    							     xsn_ref = tmpxkb.xkb_ref 
    							     xsn_kb = tmpxkb.xkb_type + tmpxkb.xkb_part + string(tmpxkb.xkb_kb_id, "999")
    							     xsn_pr_date = today
    							     xsn_mod_date = today 
    							      .

							       
			              end .
                                     
                                  /* ss -090613.1 -b
                                   END.
				   ss - 090613.1 -e */
                                END.
                                   /* ss - 090514.1 -e */
							      
							    end. /* end for 尾数看板余量+ 看板余量 < 看板包装量*/
							    

							end. /*end for 尾数看板存在*/
							else do: /*尾数看板不存在*/
							
							xkb_mstr.xkb_kb_raim_qty = v_raim_qty - v_qty.
						        xkb_mstr.xkb_upt_date = today .
                                                        v_qty = max(v_qty - v_raim_qty,0)  . 
                                                        pkb_qty = xkb_mstr.xkb_kb_raim_qty .
                                                        v_trnbr = rct_trnbr .
							xkb_mstr.xkb_status .

                              /* ss - 090514.1 -b 
                                                          /* ss-081216.2 -b */  /* 存储看板转移后需要绑定条码的看板*/
								  find first xsn_mstr where xsn_domain = global_domain and xsn_kb = xkb_mstr.xkb_type + xkb_mstr.xkb_part + string(xkb_mstr.xkb_kb_id,"999") no-lock no-error .
								  if available xsn_mstr then do :
                                  				 find first temp2 where  t2_site = xkb_mstr.xkb_site and t2_type = xkb_mstr.xkb_type and 
								 t2_part = xkb_mstr.xkb_part and t2_kb_id = xkb_mstr.xkb_kb_id no-error .
								  if not available temp2 then do :
								  create temp2 .
								  assign  t2_type = xkb_mstr.xkb_type
								         t2_site = xkb_mstr.xkb_site
									 t2_part = xkb_mstr.xkb_part 
                                                                          t2_kb_id = xkb_mstr.xkb_kb_id
									  t2_kb_qty = xkb_mstr.xkb_kb_raim_qty  .
								    end .
								   end .
								 /* ss-081216.2 -e */
                             ss - 090514.1 -e */

                                    {xxkbhist.i   &type="xkb_mstr.xkb_type"      &part="xkb_mstr.xkb_part"      &site="xkb_mstr.xkb_site"
                                                &kb_id="xkb_mstr.xkb_kb_id"    &effdate="effdate"        &program="'mhjit038.p'"
                                                &qty="xkb_mstr.xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                &b_status="xkb_mstr.xkb_status"       &c_status="xkb_mstr.xkb_status"
                                                &rain_qty="xkb_mstr.xkb_kb_raim_qty"}
    
                                    message "尾数看板不存在，本看板余量已更新为" + string(xkb_mstr.xkb_kb_raim_qty) . pause .
                                  end. /*end for 尾数看板不存在*/
						       end.
			                 end. /* end for 发料数量小于看板余量*/
						     
                          end.  /* end for 临时表存在*/

/*******************************************************************julie huang add 08/11/19 add *******************************************************************************/
                    end.  /* for each pkb */
                                       
                  end. /* if last-of(tmp_ref) then */  

                end.  /*  for each tmpkb */

				/* ss-081216.1 -b */
				 /*xp005*********begin*/
                                for each temp1 where t1_part <> "" :
                                    /****** use xsn_mstr**********/
                                    for each xsn_mstr 
                                        where xsn_domain = global_domain 
                                        and xsn_type     = t1_type
                                        and xsn_crt_date = t1_crt_date
                                        and xsn_part     = t1_part
                                        and xsn_id       = t1_id 
                                        /*and xsn_shift    = t1_shift
                                        and xsn_grade    = t1_grade */
                                        :

					 
                                        xsn_mod_date  = today .
                                        xsn_qty_end   = xsn_qty_end - t1_qty_rct .   /*?*/
                                        xsn_stat      = if xsn_qty_end <= 0 then "R" else "U".
                                    /* ss -090510.1 -b */
                                     xsn_ls_line = v_prod_line .
				                     xsn_ls_date = today .

						    
						     
                                    /* ss -090510.1 -e */
                                       
                                    end.
                                end.

                                /******create xsnd_det**********/
                                v_qty_ls = 0 .  v_qty_ly = 0 .
                                for each tmpkb :
                                v_qty_ls = v_qty_ls + tmp_qty_ls .
                                v_qty_ly = v_qty_ly + tmp_qty_ly.
                                end.
				/* ss - 090518.1 */
                              
			      
                                if v_qty_ls > 0 then do:
                                    for each temp1 where t1_part <> "" :
				  

                                        if v_qty_ls <= 0 then leave .
                                        v_qty = min(v_qty_ls,t1_qty_rct) .
                                        t1_qty_rct = t1_qty_rct - v_qty .
                                        v_qty_ls   = v_qty_ls - v_qty .
                                      
				       /* ss - 090529.1 -b */
				       find first xsn_mstr 
                                        where xsn_domain = global_domain 
                                        and xsn_type     = t1_type
                                        and xsn_crt_date = t1_crt_date
                                        and xsn_part     = t1_part
                                        and xsn_id       = t1_id no-lock no-error .
				       /* ss - 090529.1 -e */
                                        
                                        find last xsnd_det 
                                            where xsnd_domain  = global_domain 
                                            and xsnd_type      = t1_type 
                                            and xsnd_crt_date  = t1_crt_date
                                            and xsnd_part      = t1_part
                                            and xsnd_id        = t1_id 
                                            /*and xsnd_shift    = t1_shift
                                            and xsnd_grade    = t1_grade */
                                            and xsnd_date      = today
                                        no-error .
                                        if avail xsnd_det then do:
                                            v_id = xsnd_line + 1 .
                                        end.
                                        else v_id = 1 .
                                     
				 
                                        create xsnd_Det .
                                        assign 
                                            xsnd_domain    = global_domain 
                                            xsnd_type      = t1_type 
                                            xsnd_crt_date  = t1_crt_date
                                            xsnd_part      = t1_part
                                            xsnd_id        = t1_id 
                                            xsnd_date      = today
                                            xsnd_line      = v_id 
                                            xsnd_shift     = t1_shift
                                            xsnd_grade     = t1_grade
                                            xsnd_site      = site_to
                                            xsnd_loc       = loc_to
                                            xsnd_lot       = xsn_lot
                                            xsnd_ref       = xsn_ref
                                            xsnd_qty_rct   = v_qty
                                            xsnd_qty_end   = v_qty
                                            xsnd_tr_nbr    = v_nbr 
                                            xsnd_lot2      = xsn_lot2
                                            xsnd_expire    = xsn_expire
                                            /* ss -090510.1 -b */
                                            xsnd_desc01   = v_prod_line
                                            /* ss -090510.1 -e */
                                            .
					   
                                    end.
                                end. /*if v_qty_ls > 0*/
				
				
                                if v_qty_ly > 0 then do:
                                    for each temp1 where t1_part <> "" :
                                        if v_qty_ly <= 0 then leave .
                                        v_qty = min(v_qty_ly,t1_qty_rct) .
                                        t1_qty_rct = t1_qty_rct - v_qty .
                                        v_qty_ly   = v_qty_ly - v_qty .

                                        /* ss - 090529.1 -b */
				       find first xsn_mstr 
                                        where xsn_domain = global_domain 
                                        and xsn_type     = t1_type
                                        and xsn_crt_date = t1_crt_date
                                        and xsn_part     = t1_part
                                        and xsn_id       = t1_id no-lock no-error .
				       /* ss - 090529.1 -e */

                                        find last xsnd_det 
                                            where xsnd_domain  = global_domain 
                                            and xsnd_type      = t1_type 
                                            and xsnd_crt_date  = t1_crt_date
                                            and xsnd_part      = t1_part
                                            and xsnd_id        = t1_id 
                                            /*and xsnd_shift    = t1_shift
                                            and xsnd_grade    = t1_grade */
                                            and xsnd_date      = today
                                        no-error .
                                        if avail xsnd_det then do:
                                            v_id = xsnd_line + 1 .
                                        end.
                                        else v_id = 1 .

                                        create xsnd_Det .
                                        assign 
                                            xsnd_domain    = global_domain 
                                            xsnd_type      = t1_type 
                                            xsnd_crt_date  = t1_crt_date
                                            xsnd_part      = t1_part
                                            xsnd_id        = t1_id 
                                            xsnd_date      = today
                                            xsnd_line      = v_id 
                                            xsnd_shift     = t1_shift
                                            xsnd_grade     = t1_grade
                                            xsnd_site      = site_to
                                            xsnd_loc       = loc_to
                                            xsnd_lot       = xsn_lot
                                            xsnd_ref       = xsn_ref
                                            xsnd_qty_rct   = v_qty
                                            xsnd_qty_end   = v_qty
                                            xsnd_tr_nbr    = v_nbr_ly
                                            xsnd_lot2      = xsn_lot2
                                            xsnd_expire    = xsn_expire
                                            /* ss -090510.1 -b */
                                            xsnd_desc01   = v_prod_line
                                            /* ss -090510.1 -e */
                                            .
                                    end.
                                end. /*if v_qty_ly > 0*/
                                /*xp005***********end*/ 
				/* ss-081216.1 -e */


                                for each tmpkb :
                                    delete tmpkb .
                                end.
                                for each pkb :
                                    delete pkb .
                                end.
                                j = 0.
				/* ss-081216.2 -b */  /* 先查找条码中现在有效的条码，然后找本看板的最后一个已经失效条码 */
				for each temp2 where t2_part <> "" :
				
									
				 find first xkb_mstr  where xkb_mstr.xkb_domain = global_domain and xkb_mstr.xkb_site = t2_site and 
				            xkb_mstr.xkb_part = t2_part and xkb_mstr.xkb_type = t2_type and xkb_mstr.xkb_kb_id = t2_kb_id no-lock no-error .
			       if available xkb_mstr then do :
				     find first xsn_mstr  where xsn_domain = global_domain and xsn_type = t2_type 
					   and xsn_part = t2_part and xsn_kb = t2_type + t2_part + string(t2_kb_id,"999") and (xsn_expire = ? or (xsn_expire <> ? and xsn_expire >= today )) 
					   and xsn_qty_end > 0 and xsn_stat = "U" and  ( xsn_site = t2_site and xsn_loc = xkb_mstr.xkb_loc 
                                            and xsn_lot = xkb_mstr.xkb_lot and xsn_ref = xkb_mstr.xkb_ref )   no-error .
				      if available xsn_mstr then do :
				     
					     ASSIGN xsn_qty_end = xsn_qty_end + t2_kb_qty 
                             xsn_ls_line = v_prod_line .
				             xsn_ls_date = today .
                           
					 end .
					 else do :
					 
					  find last xsn_mstr where xsn_domain = global_domain and xsn_site = t2_site and  xsn_type = t2_type and 
					    xsn_part = t2_part and xsn_kb = t2_type + t2_part + string(t2_kb_id,"999") and (xsn_stat = "a" or xsn_stat = "r") no-error .
					    if available xsn_mstr then do :

					     
					    assign xsn_status = "u"
					           xsn_qty_end = t2_kb_qty
						   xsn_expire = ?
						   xsn_loc = xkb_mstr.xkb_loc
						   xsn_lot = xkb_mstr.xkb_lot
						   xsn_ref = xkb_mstr.xkb_ref 
                            /* ss -090510.1 -b */
                            xsn_ls_line = v_prod_line .
				            xsn_ls_date = today 
                            /* ss -090510.1 -e */ .
                           
					    end .
					 end .
				     
				 end .  /* avail xkb_mstr */
				 end . /* each temp2 */
				/* ss-081216.2 -e */

				/* ss - 090612.1 -b */
				/* ss-081216.2 -b */
				  for each temp2 :
				  delete temp2 .
				  end .
				  
				  for each temp1 :
				   delete temp1 .
				   end .
				  
				    for each tmpkb:
					delete tmpkb .
				    end.

				    for each pkb:
					delete pkb .
				    end.
				/* ss - 090612.1 -e */

				/* ss-081216.1 -b */
				/*xp005*********begin*/
                                hide all no-pause .
                                v_yn = yes .
                                form  
                                    v_yn label "已完成,继续?"                
                                with frame snsn4 side-labels overlay row 3 width 30 no-attr-space  .
                                view frame snsn4 .
                                update v_yn with frame snsn4. 
                                hide frame snsn4 no-pause .
                                if not v_yn then leave mainloop . 
                                /*xp005***********end*/ 
				/* ss-081216.1 -e */


                            end.  /*if v1500 then do: */
                            else do :
                                run xxmsg01.p (input 0 , input  "请重新刷读所有看板.." ,input yes )  .
                                undo mainloop,retry mainloop .
                            end.

                            display "...处理...  " @ WMESSAGE NO-LABEL with fram F1500.
                            pause 0.
            
                            display  "" @ WMESSAGE NO-LABEL with fram F1500.
                            pause 0.
                            leave V1100L.
                        END.  /* END 1500    */
    

                end.  /*if v1100 = ""  then */
        
                display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
                pause 0.
        
                display  "" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0.
                
             END.   /* END 1100 */  
        end.  /*转出看板loop*/


        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
    
        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        
     end.  /* END 1300   */



/*      leave mainloop . */
end. /**MAINLOOP**/




