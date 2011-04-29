/* mhjit047.p  看板退料 & 退料前差异回冲  for barcode                                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                 */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/*V8:ConvertMode=NoConvert                                                             */
/* REVISION: 1.0      LAST MODIFIED: 10/08/2007   BY: Softspeed roger xiao   ECO:*xp001* */
/* REVISION: 1.1      LAST MODIFIED: 10/26/2007   BY: Softspeed roger xiao   ECO:*xp002* */
/* REVISION: 1.1      LAST MODIFIED: 2008/07/11   BY: Softspeed roger xiao   ECO:*xp003* */ /*按照账面库存数,不按理论库存数,确定退料数*/
/*-Revision end------------------------------------------------------------          */

{mfdeclre.i}    /*V8-*/
{gplabel.i}   /* EXTERNALIZED LABEL INCLUDE */
{gldydef.i new}
{gldynrm.i new}


    execname = "mhjit047.p".



define buffer next_wr_route      for wr_route.
define buffer reject_to_wr_route for wr_route.
define buffer ptmstr             for pt_mstr.


define variable comp                 as character   no-undo.
define variable conv_qty_proc        as decimal     no-undo.
define variable conv_qty_move        as decimal     no-undo.
define variable conv_qty_rjct        as decimal     no-undo.
define variable conv_qty_scrap       as decimal     no-undo.
define variable cumwo_lot            as character   no-undo.
define variable date_change          as integer     no-undo.
define variable ophist_recid         as recid       no-undo.
define variable rejected           like mfc_logical no-undo.
define variable schedwo_lot          as character   no-undo.
define variable undo_stat          like mfc_logical no-undo.
define variable yn                 like mfc_logical no-undo.
define variable i                    as integer     no-undo.
define variable j                    as integer     no-undo.
define variable oplist               as character   no-undo.
define variable lotserials_req       as log         no-undo.
define variable bomcode              as character   no-undo.
define variable routecode            as character   no-undo.
define variable following_op_req_qty as decimal     no-undo.
define variable backflush_qty        as decimal     no-undo.
define variable std_run_hrs          as decimal     no-undo.
define variable msg_ct               as integer     no-undo.
define variable input_que_op_to_ck   as integer     no-undo.
define variable input_que_qty_chg    as decimal     no-undo.
define variable l_reject_to_wkctr  like wc_wkctr    no-undo.
define variable l_reject_to_mch    like wc_mch      no-undo.
define variable elapse               as decimal   format ">>>>>>>>.999" no-undo.
define variable trans_type           as character initial "BACKFLSH"    no-undo.
define var v_entity  like si_entity .
define var v_module  as char initial "IC" .
define var v_result  as integer initial 0.
define var v_msg_nbr as integer initial 0.


define new shared variable rsn_codes          as character   extent 10.
define new shared variable quantities       like wr_qty_comp extent 10.
define new shared variable scrap_rsn_codes    as character   extent 10.
define new shared variable scrap_quantities like wr_qty_comp extent 10.
define new shared variable reject_rsn_codes   as character   extent 10.
define new shared variable reject_quantities
like wr_qty_comp extent 10.
/*mage*/ define new shared variable line1 like ln_line .
/*apple*/ define new shared variable tot-qty like rps_qty_req.

define variable   dont_zero_unissuable             as logical
initial no                                                     no-undo.
define new shared variable wo_recno                as recid.
define new shared variable wr_recno                as recid.
define new shared variable lotserial             like sr_lotser   no-undo.
define            variable inv-issued              as logical     no-undo.
define variable   mfc-recid                        as recid       no-undo.
{&REBKFL-P-TAG1}
define variable   trans-ok                       like mfc_logical no-undo
initial no.
define variable   move_to_wkctr                  like wc_wkctr    no-undo.
define variable   move_to_mch                    like wc_mch      no-undo.
define variable   consider_output_qty            like mfc_logical no-undo.
define new shared variable h_wiplottrace_procs     as handle      no-undo.
define new shared variable h_wiplottrace_funcs     as handle      no-undo.
define variable   result_status                    as character   no-undo.
{&REBKFL-P-TAG4}

{xxmhjit047form.i new}    /* ???  */
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i} /*CONSTANTS DEFINITIONS*/

define var v_start                as date     no-undo.
define var qtycomp                as decimal     no-undo.
define var wocomp                 as character   no-undo.
define variable v_fqty    like xmpt_kb_fqty .
define var v_qty_comp as decimal format "->>>>>>>>9.9<" .
define var v_qty_firm as logical initial no .
define var v_Qty_oh as decimal format "->>>>>>>>9.9<" .
define var v_qty_rst as decimal format "->>>>>>>>9.9<"  label "差异数量" .
define var v_comb  like xppt_comb label "是否合并领料" .
define var sn_from as char format "x(25)" label "领料看板条码" .
define var sn_to as char format "x(25)" label "转入看板条码" . 

define new shared var v_Qty     as decimal format "->>>>>>>>9.9<" label "退料数量" .
define new shared var v_comp    like xkb_part label "子零件" .
define new shared var v_par     like xkb_par label "父零件".
define new shared var loc_from  like xkb_loc label "转出库位".   
define new shared var loc_to    like xkb_loc label "转入库位".
define new shared var lot_to    like xkb_lot label "转入批序号" .
define new shared var ref_to    like xkb_ref label "转入参考号" .
define new shared var lot_from  like xkb_lot .
define new shared var ref_from  like xkb_ref .
define new shared var recno_from  as   recid.
define new shared var recno_to    as   recid.

define new shared var v_nbr     like xdn_next label "退料单号" .
define variable p-type like xdn_type.
define variable p-prev like xdn_prev.
define variable p-next like xdn_next.
define variable m2 as char format "x(8)".
define variable k as integer.




/* ----------------------------------- */

define var v_line as integer .
define var v_me_qty like xmpt_me_qty .
define var v_raim_qty  like xkb_kb_raim_qty .

define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define var v_yn as logical format "Y/N" initial yes .
define variable dmdesc like dom_name.
define variable WMESSAGE as char format "x(80)" init "".
define variable wtimeout as integer init 99999 .
define variable undo-input like mfc_logical.




/* define buffer xkbhhist for xkbh_hist. */

define temp-table tmpkb
    field tmp_comp   like xkb_part
    field tmp_id     like xkb_kb_id 
    field tmp_par    like xkb_par
    field tmp_wo     like wo_lot
    field tmp_site   like ld_site
    field tmp_loc    like ld_loc
    field tmp_lot    like ld_lot
    field tmp_ref    like ld_ref
    field tmp_op     like op
    field tmp_qty    like v_qty_rst .



cumwo_lot = "" .



find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[退料&差异回冲]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).

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
        
        v1000 = ? .

        L10001 = "生效日期 ? " .
        display L10001          skip with fram F1000 no-box.
        L10002 = "" . 
        display L10002          format "x(40)" skip with fram F1000 no-box.
        L10003 = "" . 
        display L10003          format "x(40)" skip with fram F1000 no-box.
        L10004 = "" . 
        display L10004          format "x(40)" skip with fram F1000 no-box.
        L10005 = "" . 
        display L10005          format "x(40)" skip with fram F1000 no-box.
        L10006 = "请输入日期产生退料单号:" . 
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

        eff_date = v1000 .

        
        find icc_ctrl where icc_domain = global_domain no-lock no-error.
        site = if avail icc_ctrl then icc_site else global_site .

        v_entity = site .
        v_module = "IC" .
        v_result = 0.
        v_msg_nbr = 0 .
        {gprun.i ""gpglef1.p""
           "( input v_module ,
             input  v_entity,
             input  eff_date,
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



        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                disp  "看板模块没有开启" @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
            end.
        end.
    
        /* v_nbr */
        /*xp002*/ 
        /*----------------start:get nbr---------------------------*/
        v_nbr  = "" .
        p-type = "RT" .
        p-prev = "" .
        p-next = "" .
        m2 = "".
        k  = 0 .



        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type no-lock no-error.
        if available xdn_ctrl then do:
            p-prev = xdn_prev.
            p-next = xdn_next.
        end. 
        else do:
                disp  "错误:无退料单号控制档"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.

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
        /*----------------end:get nbr---------------------------*/


        if is_wiplottrace_enabled()
        then do:
        
           {gprunmo.i &program=""wlpl.p"" &module="AWT"
              &persistent="""persistent set h_wiplottrace_procs"""}
           {gprunmo.i &program=""wlfl.p"" &module="AWT"
              &persistent="""persistent set h_wiplottrace_funcs"""}
        end. /* IF is_wiplottrace_enabled() */
        
        /* DO NOT RUN PROGRAM UNLESS QAD_WKFL RECORDS HAVE */
        /* BEEN CONVERTED SO THAT QAD_KEY2 HAS NEW FORMAT  */
        if can-find(first qad_wkfl
            where qad_wkfl.qad_domain = global_domain and  qad_key1 = "rpm_mstr")
        then do:
        run xxmsg01.p (input 5126 , input  "" ,input yes) .
        /*    {pxmsg.i &MSGNUM=5126 &ERRORLEVEL=3} */
        /*    message.                             */
        /*    message.                             */
           quit .
        end. /* if can-find(first qad_wkfl... */
        
        /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
        {gpatrdef.i "new shared"}
        
        
        for first gl_ctrl
         where gl_ctrl.gl_domain = global_domain no-lock:
        end. /* FOR FIRST gl_ctrl */
        
        for first clc_ctrl
           fields( clc_domain clc_lotlevel)
         where clc_ctrl.clc_domain = global_domain no-lock:
        end. /* FOR FIRST clc_ctrl */
        
        if not available clc_ctrl
        then do:
        
           {gprun.i ""gpclccrt.p""}
           for first clc_ctrl
              fields( clc_domain clc_lotlevel)
            where clc_ctrl.clc_domain = global_domain no-lock:
           end. /* FOR FIRST clc_ctrl */
        end. /* IF NOT AVAILABLE clc_ctrl */
        
        {gprun.i ""redflt.p""}


        
        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        
        display  "" @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        leave V1000L.
    END.  /* END 1000    */


MAINLOOP:
REPEAT: 


    for each tmpkb:
        delete tmpkb .
    end.

    v_line = 1 .
    qtycomp = 0 .
   

    hide all no-pause .
    define var v13001          as char format "x(1)" .
    define var v13002          as char format "x(18)" .
    define var v13003          as char format "x(3)" .

    V1100L:
    REPEAT:

       hide all no-pause.
       define variable V1100           as char format "x(40)" .
       define variable L11001          as char format "x(40)".
       define variable L11002          as char format "x(40)".
       define variable L11003          as char format "x(40)".
       define variable L11004          as char format "x(40)".
       define variable L11005          as char format "x(40)".
       define variable L11006          as char format "x(40)".


       display dmdesc format "x(40)" skip with fram F1100 no-box.

       L11001 = "退料单号: " + v_nbr .
       display L11001          skip with fram F1100 no-box.
       L11002 = "生效日期: " + string(eff_date)  . 
       display L11002          format "x(40)" skip with fram F1100 no-box.
       L11003 = ""  . 
       display L11003          format "x(40)" skip with fram F1100 no-box.
       L11004 = "" . 
       display L11004          format "x(40)" skip with fram F1100 no-box.
       L11005 = "" . 
       display L11005          format "x(40)" skip with fram F1100 no-box.
       L11006 = "请刷读领料看板:"  . 
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


       if  v1100 <> ""  then do :
           if v1100 = "e" then leave mainloop.
    
           v13001 = substring(v1100,1,1) .  /* xkb_type*/
           v13002 = substring(v1100,2,length(v1100) - 4 ) .  /* xkb_part*/
           v13003 = substring(v1100,length(v1100) - 2 ,3) .    /* xkb_kb_id */
    
           if (v13001 <> "L" ) then do:
               disp "错误:仅限领料看板." @ WMESSAGE NO-LABEL with fram F1100.
               pause 0.
               undo, retry.
           end.
    
           find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                           and ( /*xkb_status = "U" or*/  xkb_status = "A" )  no-lock no-error .
           if not avail xkb_mstr then do:
               disp "错误:无看板记录,或非有效状态." @ WMESSAGE NO-LABEL with fram F1100.
               pause 0.
               undo, retry.
           end.
           else do:  /*if avail xkb_mstr */
                recno_from = recid(xkb_mstr) .
                sn_from = v1100 .
                v_par = xkb_par .
                part  = xkb_par .
                v_comp = xkb_part .
                v_qty_oh = 0 .
                v_qty = 0 .


                find first tmpkb where  tmp_site = xkb_site and tmp_comp = xkb_part and tmp_id = xkb_kb_id no-lock no-error .
                if avail tmpkb then do:
                     display  "此看板已经刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1100.
                     pause 0 .
                     undo v1100l, retry v1100l.
                end.
                
    
               find first ro_det where ro_domain = global_domain and  ro_routing = xkb_par 
                                 and ro_start <= eff_date and (ro_end >= eff_date or ro_end = ? ) no-lock no-error.
               if not avail ro_det then do:
                   disp "看板父件工艺流程无效" @ WMESSAGE NO-LABEL with fram F1100. 
                   pause 0 .
                   undo , retry.
               end.  /*if not avail ro_det */
               else do:  /*if  avail ro_det */
                    line = ro_wkctr .
                    op  = ro_op .

    
                    V1200L:
                    REPEAT:
                        
                        hide all no-pause .
                        define variable V1200           as char format "x(40)".
                        define variable L12001          as char format "x(40)".
                        define variable L12002          as char format "x(40)".
                        define variable L12003          as char format "x(40)".
                        define variable L12004          as char format "x(40)".
                        define variable L12005          as char format "x(40)".
                        define variable L12006          as char format "x(40)".
                        
                        display dmdesc format "x(40)" skip with fram F1200 no-box.
                        
                        L12001 = "退料单号: " + v_nbr.
                        display L12001          skip with fram F1200 no-box.
                        L12002 =  "领料看板" + string(sn_from)  . 
                        display L12002          format "x(40)" skip with fram F1200 no-box.
                        L12003 = "" . 
                        display L12003          format "x(40)" skip with fram F1200 no-box.
                        L12004 = "" . 
                        display L12004          format "x(40)" skip with fram F1200 no-box.
                        L12005 = "" . 
                        display L12005          format "x(40)" skip with fram F1200 no-box.
                        L12006 =  "请确认产线 : "   . 
                        display L12006          format "x(40)" skip with fram F1200 no-box.
                        
                        v1200 = ro_wkctr .
                    
                        Update V1200   WITH  fram F1200 no-label EDITING:
                            readkey pause wtimeout.
                            if lastkey = -1 then quit.
                            if LASTKEY = 404 Then Do: /* DISABLE F4 */
                                pause 0 before-hide.
                                undo, retry.
                            end.
                            display skip "^" @ WMESSAGE NO-LABEL with fram F1200.
                            APPLY LASTKEY.
                        END.

                        if v1200 = "e" then leave mainloop .

                        find ln_mstr  where ln_mstr.ln_domain = global_domain and  ln_site = site and ln_line = v1200 no-lock no-error.
                        if not available ln_mstr then do:
                            display "产线不存在,请重新输入." @ WMESSAGE NO-LABEL with fram F1200 .
                            undo, retry.
                        end.

                        line  = v1200 .

                        V1400L:
                        REPEAT:
                            
                            hide all no-pause .
                            define variable V1400           as integer .
                            define variable L14001          as char format "x(40)".
                            define variable L14002          as char format "x(40)".
                            define variable L14003          as char format "x(40)".
                            define variable L14004          as char format "x(40)".
                            define variable L14005          as char format "x(40)".
                            define variable L14006          as char format "x(40)".
                            
                            display dmdesc format "x(40)" skip with fram F1400 no-box.
                            
                            L14001 = "退料单号: " + v_nbr.
                            display L14001          skip with fram F1400 no-box.
                            L14002 =  "领料看板" + string(sn_from)  . 
                            display L14002          format "x(40)" skip with fram F1400 no-box.
                            L14003 = "产线: " + v1200 . 
                            display L14003          format "x(40)" skip with fram F1400 no-box.
                            L14004 = "" . 
                            display L14004          format "x(40)" skip with fram F1400 no-box.
                            L14005 = "" . 
                            display L14005          format "x(40)" skip with fram F1400 no-box.
                            L14006 = "请确认工序 :" . 
                            display L14006          format "x(40)" skip with fram F1400 no-box.
                            
                            v1400 = op .
                            Update V1400   WITH  fram F1400 no-label EDITING:
                                readkey pause wtimeout.
                                if lastkey = -1 then quit.
                                if LASTKEY = 404 Then Do: /* DISABLE F4 */
                                    pause 0 before-hide.
                                    undo, retry.
                                end.
                                display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
                                APPLY LASTKEY.
                            END.
                        
                            op  = v1400 .

                    
                         find first ro_det where ro_det.ro_domain = global_domain  and ro_routing  = v_par 
                                    and ((ro_start <= eff_date or ro_start = ?) and (ro_end   >= eff_date or ro_end   = ?))
                                    and ro_op = op no-lock no-error .
                         if not avail ro_Det then do:
                             display  "工序无效,请重新输入"  @ WMESSAGE NO-LABEL with fram F1400 .
                             pause 0 .
                             undo ,retry .
                         end.
                    
                        assign emp = line 
                               loc_from = line 
                               op 
                               site
                               part = v_par .
                               global_part = part .
                               global_site = site.
        
                               site = xkb_site .
                               lot_from  = xkb_lot .
                               ref_from  = xkb_ref .   


            
                          /*FIND DEFAULT BOM AND ROUTING CODES*/
                          {gprun.i ""reoptr1b.p""
                             "(input site,
                               input line,
                               input part,
                               input op,
                               input eff_date,
                               output routing,
                               output bom_code,
                               output schedwo_lot)"}
                    
                          if schedwo_lot = "?"
                          then do:
                              run xxmsg01.p (input 325 , input  "" ,input yes )  . 
                             /* Unexploded schedule with consumption period */
                             /*                  {pxmsg.i &MSGNUM=325 &ERRORLEVEL=3} */
                             /*                  next-prompt part.                   */
                             undo, retry.
                          end. /* IF schedwo_lot = "?" */
            
                            /*       /*GET BOM, ROUTING FROM USER*/ */
                            /*       {gprun.i ""retrin3.p""         */
                            /*          "(output undo_stat)"}       */
                            /*       if undo_stat                   */
                            /*       then                           */
                            /*          undo, leave.            xp001    */
            
                           assign routing = part
                                  bom_code = part.
            
            
                          /*FIND CUM ORDER. */
                          {gprun.i ""regetwo.p""
                             "(input site,
                               input part,
                               input eff_date,
                               input line,
                               input routing,
                               input bom_code,
                               output cumwo_lot)"}
                    

                          find ro_det  where ro_det.ro_domain = global_domain
                                         and ( ro_routing = part and ro_op = op
                                         and (ro_start = ? or ro_start  <= eff_date)
                                         and (ro_end = ? or ro_end    >= eff_date)) no-lock no-error.
                          if not available ro_det then do:
    
                               find first ro_det  where ro_det.ro_domain = global_domain
                                         and ( ro_routing = part
                                         and (ro_start = ? or ro_start  <= eff_date)
                                         and (ro_end = ? or ro_end    >= eff_date)) no-lock no-error.
                               if not available ro_det then do:
                                       /* ROUTING DOES NOT EXIST */
                                       /* {pxmsg.i &MSGNUM=126 &ERRORLEVEL=3} */
                                       run xxmsg01.p (input 126 , input ""  ,input yes )  .
                                       undo  v1400L ,retry  v1400L .
                               end.
                               else do :
                                        display  "工序无效,请重新输入"  @ WMESSAGE NO-LABEL with fram F1400 .
                                        pause 2 no-message .
                                        undo v1400L ,retry v1400L .
                               end.
    
                          end.
    
    
    
            
                          /* CREATE IT IF IT DOESN'T EXIST*/
                          if cumwo_lot = ?
                          then do:
                    
                              {gprun.i ""xxrecrtwo.p""
                                "(input site,
                                  input part,
                                  input eff_date,
                                  input line,
                                  input routing,
                                  input bom_code,
                                  output cumwo_lot)"}
                                  if cumwo_lot = ?   then   next v1100l .
                    
                          end. /* IF cumwo_lot = ? */
                          else do:
                                 for first wo_mstr
                                    fields( wo_domain wo_assay wo_due_date wo_expire wo_grade wo_loc wo_lot
                                           wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                                           wo_rctstat_active wo_rel_date wo_routing wo_site)
                                     where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
                                 no-lock:
                                 end. /* FOR FIRST wo_mstr */
                        
                                 if wo_status = "c"
                                 then do:
                        
                                     /*{pxmsg.i &MSGNUM=5101 &ERRORLEVEL=3} */
                                    run xxmsg01.p (input 5101 , input  "" ,input yes )  . 
                                    undo v1100l, retry v1100l.
                                 end. /* IF wo_status = "c" */
                                 v_start = wo_rel_Date .    /* xp001 */ 
                          end. /* ELSE DO :  IF cumwo_lot <> ? */
                  
                          for first wr_route
                                 fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone wr_op wr_part wr_run wr_wkctr)
                                  where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
                                 and wr_op    = op no-lock:
                          end. /* FOR FIRST wr_route */
                    
                          if not available wr_route then do:
                    
                             /* OPERATION DOES NOT EXIST */
                             /* {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3} */
                             run xxmsg01.p (input 106 , input  "" ,input yes )  . 
                              /*next-prompt op with frame a.    /* xp001 */   */
                             undo v1100l , retry v1100l .   /* xp001 */
                          end. /* IF NOT AVAILABLE wr_route */
                    
                          if not wr_milestone then do:
                    
                             if is_wiplottrace_enabled()
                             then do:
                    
                                if prev_milestone_operation(cumwo_lot, op) <> ?
                                   or (prev_milestone_operation(cumwo_lot, op) = ?
                                       and not wr_milestone)
                                   and is_operation_queue_lot_controlled
                                   (cumwo_lot,
                                   prev_milestone_operation(cumwo_lot, op),
                                   OUTPUT_QUEUE)
                                then do:
                    
                                   /*{pxmsg.i &MSGNUM=8465 &ERRORLEVEL=3}*/
                                     run xxmsg01.p (input 8465 , input  "" ,input yes )  .
                                   /*WIP LOT TRACE IS ENABLED AND OPERATION IS A */
                                   /*NON-MILESTONE                               */
                                   undo, retry.
                                end. /* IF pre_milestone_operation(cumwo_lot, .... */
                             end. /* IF is_wiplottrace_enabled() */
                    
                             if not wr_milestone
                                and not is_wiplottrace_enabled()
                             then
                                /* OPERATION NOT A MILESTONE */
                                /* {pxmsg.i &MSGNUM=560 &ERRORLEVEL=2} */
                                run xxmsg01.p (input 560 , input  "" ,input yes)  .
                          end. /* IF NOT wr_milestone */
            




                            
                            display  skip WMESSAGE NO-LABEL with fram F1400.
                            
                            display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
                            pause 0.
                            
                            display  "" @ WMESSAGE NO-LABEL with fram F1400.
                            pause 0.
                            leave V1400L.
                        END.  /* END 1400    */


                        display  skip WMESSAGE NO-LABEL with fram F1200.
                        
                        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1200.
                        pause 0.
                        
                        display  "" @ WMESSAGE NO-LABEL with fram F1200.
                        pause 0.
                        leave V1200L.
                    END.  /* END 1200    */
               end.  /*if  avail ro_det */


            V1500L:
            REPEAT:

               hide all no-pause .
               define variable V1500           like tr_qty_loc  .
               define variable L15001          as char format "x(40)".
               define variable L15002          as char format "x(40)".
               define variable L15003          as char format "x(40)".
               define variable L15004          as char format "x(40)".
               define variable L15005          as char format "x(40)".
               define variable L15006          as char format "x(40)".


               display dmdesc format "x(40)" skip with fram F1500 no-box.

               L15001 = "退料单号: " + v_nbr   .
               display L15001          skip with fram F1500 no-box.
               L15002 = "生效日期:" + string(eff_date)  . 
               display L15002          format "x(40)" skip with fram F1500 no-box.
               L15003 =  "领料看板" + sn_from . 
               display L15003          format "x(40)" skip with fram F1500 no-box.
               L15004 = "产线: " + line + ";工序: " + string(op). 
               display L15004          format "x(40)" skip with fram F1500 no-box.
               L15005 = ""  . 
               display L15005          format "x(40)" skip with fram F1500 no-box.
               L15006 = "退料数量: " . 
               display L15006          format "x(40)" skip with fram F1500 no-box.

               v_comb = no .
               /*****
               find first xmpt_mstr where xmpt_domain = global_domain and xmpt_site = site  and xmpt_part = v_comp no-lock no-error .
               if not avail xmpt_mstr  then do:
                   find first xppt_mstr where xppt_domain = global_domain and xppt_site = site  and xppt_part = v_comp no-lock no-error .
                   if not avail xppt_mstr  then do:
                   end.
                   else do:
                       v_comb = xppt_comb .
                   end.
               end.
               else do:
                   v_comb = xmpt_comb .
               end.
               *****/ /*xp003*/

   /*             hide all no-pause .                                                     */
   /*             disp "合并领料:" + string(v_comb) @ WMESSAGE NO-LABEL with fram F1100 . */
   /*             pause 2 no-message  .                                                   */


                v_qty_oh = 0 .
                v_qty_rst = 0 .
                /*****
                if v_comb then do:
                    for each ld_det where ld_domain = global_domain and ld_site = site  and ld_part = v_comp
                        and ld_loc = line and ld_lot = lot_from and ld_ref = ref_from and ld_qty_oh > 0 no-lock :
                        v_qty_oh = v_qty_oh + ld_qty_oh .
                    end.
                end.  /*if v_comb*/
                else do:   /*if not v_comb*/
                    for each tr_hist where tr_domain = global_domain and tr_site = site and ( tr_type = "RCT-TR" or tr_type = "ISS-TR" ) and tr_effdate >= v_start
                         and tr_part = v_comp  and tr_loc = line and (( tr_rmks = v_par )) and tr_serial = lot_from and tr_ref = ref_from    no-lock:
                         v_qty_oh = v_qty_oh + tr_qty_loc .
                    end.
                    for each tr_hist where tr_domain = global_domain and tr_site = site and tr_type = "ISS-WO" and tr_effdate >= v_start
                         and tr_part = v_comp  and tr_loc = line and (( tr_lot = cumwo_lot)) and tr_serial = lot_from and tr_ref = ref_from    no-lock:
                         v_qty_oh = v_qty_oh + tr_qty_loc .
                    end.
                end.    /*if not v_comb*/     
                
                *****/ /*xp003*/

                for each ld_det where ld_domain = global_domain and ld_site = site  and ld_part = v_comp
                        and ld_loc = line and ld_lot = lot_from and ld_ref = ref_from and ld_qty_oh > 0 no-lock :
                        v_qty_oh = v_qty_oh + ld_qty_oh .
                end. /*xp003*/
               
               V1500 =  v_qty_oh .

               Update V1500     WITH  fram F1500 NO-LABEL
               /* ROLL BAR START */
               EDITING:
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
               if v1500 = 0  then do:
                   display "退料数量不可为零" @ WMESSAGE NO-LABEL with fram F1500.
                   pause 1 no-message .
                   undo v1100l ,retry v1100l .
               end.


                /*待转数量*/ 
                v_qty =  v1500 .

            
                v_qty_rst = ( v_qty_oh - v_qty ) .
                v1500 = v_qty_rst .
                if v_qty_rst > 0 then do:
                    L15004 = "看板余量:" + string(v_qty_oh ) . 
                    display L15004          format "x(40)" skip with fram F1500 no-box.
                    L15004 = "退料数量:" + string(v_qty ) . 
                    display L15004          format "x(40)" skip with fram F1500 no-box.
                    L15006 = "请确认回冲数量 : " . 
                    display L15006          format "x(40)" skip with fram F1500 no-box.
                    qtycomp =   v1500 .
                    update  v1500 with fram f1500.
                    if v1500 > qtycomp or v1500 < 0 then do:
                        
                        display "不可为负,或超过理论差异" @ WMESSAGE NO-LABEL with fram F1500.
                        pause 0 .
                        undo ,retry .
                    end.
                    v_qty_rst = v1500 .
                end.  /* if v_qty_rst > 0 */
                
                v_qty_oh  = 0 .
                for each ld_det where ld_domain = global_domain and ld_site = site and ld_part = v_comp
                    and ld_loc = line and ld_lot = lot_from and ld_ref = ref_from and ld_qty_oh > 0 no-lock :
                    v_qty_oh = v_qty_oh + ld_qty_oh .
                end.
            
                if  v_qty  > (v_qty_oh - v_qty_rst ) then do:
                    disp "回冲后实有库存数仍不足退料数" + string(v_qty_oh - v_qty_rst ) @ WMESSAGE NO-LABEL with fram F1500.
                    pause 0 .
                    undo ,retry .
                end.
            
                disp "差异回冲数:" + string(v_qty_rst) @ WMESSAGE NO-LABEL with fram F1500 .
/*                 L15006 = "差异回冲数:" + string(v_qty_rst)  .                       */
/*                 display L15006          format "x(40)" skip with fram F1500 no-box. */
                pause 2 no-message .
            
                if v_comb then do:
                    run xxmsg01.p (input 0 , input  "合并领料件暂时手工退料" ,input yes )  .
                    undo mainloop ,retry mainloop .
                    v_qty_oh = 0 .
                    for each wo_mstr where wo_domain = global_domain and wo_line = line and wo_type = "c" 
                                     and (wo_rel_date >= date( month(eff_date) , 01, year(eff_date) ) or wo_rel_Date = ? )
                                     /* and (wo_due_date >= eff_date or wo_Due_date = ?) */
                                     no-lock :


						v_qty_comp = 0 . /*累计工单完成数未记录,找tr_hist*/
						for each tr_hist use-index tr_type 
									where tr_domain = global_domain 
									and tr_type = "RCT-WO" 
									and tr_effdate >= wo_rel_date
									and tr_lot = wo_lot 
									no-lock :
							v_qty_comp = v_qty_comp + tr_qty_loc .
						end.

                        find first wod_det where wod_domain = global_domain 
										and wod_lot = wo_lot 
										and wod_part = v_comp 
										and wod_qty_req > 0 no-lock no-error .
                        if avail wod_det then do:
                            find first wr_route where wr_domain = global_domain and wr_lot = wo_lot and wr_op = wod_op no-lock no-error .
                            if avail wr_route then do:
                                 create tmpkb .
                                 assign tmp_comp = v_comp
                                        tmp_id = xkb_kb_id 
                                        tmp_par  = wo_part 
                                        tmp_wo   = wo_lot
                                        tmp_site = site
                                        tmp_loc  = line
                                        tmp_lot  = lot_from
                                        tmp_ref  = ref_from
                                        tmp_op   = wod_op
                                        tmp_qty  = v_qty_comp * (  wod_qty_req / wo_qty_ord ) .
                                 v_qty_oh = v_qty_oh + tmp_qty .
                            end.
                        end.
                    end.   /*for each wo_mstr */

                    if v_qty_oh = 0 then do:
                       run xxmsg01.p (input 0 , input  "错:合并领料件,且无完成数" ,input yes )  .
                       undo mainloop ,retry mainloop .
                    end.

					/*把回冲数按照比例分配到不同累计工单*/
                    for each tmpkb exclusive-lock :  
                         assign tmp_qty = ( tmp_qty / v_qty_oh) * v_qty_rst .
                    end.
            
                end.  /*if v_comb*/
                else do:   /*if not v_comb*/
            
                     create tmpkb .
                     assign tmp_comp = v_comp
                            tmp_id   = xkb_kb_id
                            tmp_par  = v_par 
                            tmp_wo   = cumwo_lot
                            tmp_site = site
                            tmp_loc  = line
                            tmp_lot  = lot_from
                            tmp_ref  = ref_from
                            tmp_op   = op
                            tmp_qty  = v_qty_rst  .
            
                end.    /*if not v_comb*/


/* trans start *********************************************************** */

for each tmpkb no-lock break by tmp_comp :
    assign qtycomp   = tmp_qty 
           v_par     = tmp_par
           v_comp    = tmp_comp 
           cumwo_lot = tmp_wo
           site      = tmp_site 
           loc_from  = tmp_loc
           lot_from  = tmp_lot
           ref_from  = tmp_ref 
           op        = tmp_op  .

    if qtycomp = 0 then do:
		if v_comb and not last-of(tmp_comp) then next . /*累计工单最后才做退料*/
        V1600L:
        REPEAT:
            assign sn_to = ""
               loc_to = ""
               lot_to = ""
               ref_to = ""  .
            hide all no-pause .
            define variable v1600           as char format "x(40)".
            define variable L16001          as char format "x(40)".
            define variable L16002          as char format "x(40)".
            define variable L16003          as char format "x(40)".
            define variable L16004          as char format "x(40)".
            define variable L16005          as char format "x(40)".
            define variable L16006          as char format "x(40)".
            
            display dmdesc format "x(40)" skip with fram F1600 no-box.
            
            L16001 = "退料单号: " + v_nbr .
            display L16001          skip with fram F1600 no-box.
            L16002 = "领料看板: " + sn_from. 
            display L16002          format "x(40)" skip with fram F1600 no-box.
            L16003 = "退料数量 " + string(v_qty). 
            display L16003          format "x(40)" skip with fram F1600 no-box.
            L16004 = "" . 
            display L16004          format "x(40)" skip with fram F1600 no-box.
            L16005 = "差异数为0 ,不做差异回冲" . 
            display L16005          format "x(40)" skip with fram F1600 no-box.
            L16006 = "退料:请刷读生产或采购看板" . 
            display L16006          format "x(40)" skip with fram F1600 no-box.
            
            
            Update v1600   WITH  fram F1600 no-label EDITING:
                readkey pause wtimeout.
                if lastkey = -1 then quit.
                if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                end.
                display skip "^" @ WMESSAGE NO-LABEL with fram F1600.
                APPLY LASTKEY.
            END.

            if  v1600 = "e" then undo mainloop, leave mainloop .

            if substring(v1600,1,1) <> "M" and substring(v1600,1,1) <> "P" then do:
                disp "错误:非制造/采购看板,请重新刷读" @ WMESSAGE NO-LABEL with fram F1600 .
                undo ,retry .
            end.
            if substring(v1600,2,length(v1600) - 4 ) <> substring(sn_from,2,length(sn_from) - 4 ) then do:
                disp   "错误:转出/转入看板的零件需相同." @ WMESSAGE NO-LABEL with fram F1600  .
                undo, retry.
            end.
        
            find xkb_mstr where xkb_domain = global_domain and xkb_site = site and ( xkb_type = "M" or xkb_type = "P")
                 and xkb_kb_id = inte(substring(v1600,length(v1600) - 2 ,3))
                 and xkb_part = substring(v1600,2,length(v1600) - 4 )
                 and ( (xkb_status = "U" and xkb_kb_raim_qty > 0)or  xkb_status = "A" ) no-error .
            if not avail xkb_mstr then do:
                disp  "错误:无看板记录,或不在使用状态." @ WMESSAGE NO-LABEL with fram F1600 .
                undo , retry.
            end.
            else do :  /* avail xkb_mstr */
                recno_to = recid(xkb_mstr) .
                sn_to = v1600 .

        
               if xkb_loc = "" then do:
                    disp "" @ L16005 NO-LABEL with fram F1600. 
                    disp "此看板的库位为空,请输入" @ L16006 NO-LABEL with fram F1600. 
                    pause 0.
                    find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                    v1600 = if avail pt_mstr then pt_loc else "" .
                    update v1600 with frame F1600 .
                    repeat:
                        find first loc_mstr where loc_domain = global_domain and loc_loc =  v1600  no-lock no-error .
                        if not avail loc_mstr  then do:
                               disp "无效库位,请重新输入" @ L16006 NO-LABEL with fram F1600.
                               find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                               v1600 = if avail pt_mstr then pt_loc else "" .
                               update v1600 with frame F1600 .
                        end.
                        else do:
                            if v1600 = line then do:
                                disp  "错误:退料库位与转入库位相同." @ WMESSAGE NO-LABEL with fram F1600 .
                                find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                                v1600 = if avail pt_mstr then pt_loc else "" .
                                update v1600 with frame F1600 .
                            end.
                            else leave .
                        end.
                            
                    end.
                    assign xkb_loc = v1600 .
                end.

                assign loc_to = xkb_loc lot_to = xkb_lot ref_to = xkb_ref   .
                if loc_to = line then do:
                   disp  "错误:退料库位与转入库位相同." @ WMESSAGE NO-LABEL with fram F1600 .
                   undo ,retry .
                end.   

                if xkb_status = "U" then do:
                    if ( xkb_lot <> lot_from or xkb_ref <> ref_from )  then do:
                          v1600 = "Y" .
                          disp "批序号不一致,继续(Y/N)?" @ L16006 NO-LABEL with fram F1600.
                          update v1600 with frame f1600 .
                          repeat:
                              if not ( v1600 = "Y" or v1600 = "N" ) then do:
                                   disp "仅限输入'Y'或者'N'..." @ L16006 NO-LABEL with fram F1600.
                                   pause 0.
                                   disp "批序号不一致,继续(Y/N)?" @ L16006 NO-LABEL with fram F1600.
                                   V1600 = "Y" .
                                   update v1600 with frame f1600 .
                              end.
                              else leave .
                          end.
                          if v1600 = "N" then undo ,retry .
                          if v1600 = "Y" then do:
                              v1600 = "Y" .
                              disp "用转入看板的批序号(Y/N) ?" @ L16006 NO-LABEL with fram F1600.
                              update v1600 with frame f1600 .
                              repeat:
                                  if not ( v1600 = "Y" or v1600 = "N" ) then do:
                                       disp "仅限输入'Y'或者'N'..." @ L16006 NO-LABEL with fram F1600.
                                       pause 0.
                                       V1600 = "Y" .
                                       disp "用转入看板的批序号(Y/N) ?" @ L16006 NO-LABEL with fram F1600.
                                       update v1600 with frame f1600 .
                                  end.
                                  else leave .
                              end.
                              if v1600 = "Y"  then assign  loc_to = xkb_loc  lot_to = xkb_lot  ref_to = xkb_ref .
                              if v1600 = "N"  then assign  loc_to = loc_from lot_to = lot_from ref_to = ref_from .
                          end.  /*if v1600 = "Y" then */                        
                    end.
                end.  /*if xkb_status = "U" */
                else do:
                    
                    find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                    v1600 = if avail pt_mstr then pt_loc else "" .
                    disp "请确认转入库位:"  @ L16006 NO-LABEL with fram F1600.
                    update v1600 with frame F1600 no-box.
                    repeat:
                        find first loc_mstr where loc_domain = global_domain and loc_loc =  v1600  no-lock no-error .
                        if not avail loc_mstr  then do:
                               disp "无效库位,请重新输入" @ L16006 NO-LABEL with fram F1600.
                               find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                               v1600 = if avail pt_mstr then pt_loc else "" .
                               update v1600 with frame F1600 .
                        end.
                        else do:
                            if v1600 = line then do:
                                disp  "错误:退料库位与转入库位相同." @ WMESSAGE NO-LABEL with fram F1600 .
                                find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                                v1600 = if avail pt_mstr then pt_loc else "" .
                                update v1600 with frame F1600 .
                            end.
                            else leave .
                        end.
                    end.
                    assign 
                           loc_to = v1600
                           lot_to = lot_from 
                           ref_to = ref_from .
                end.  /*if xkb_status <>  "U" */
        
        
                if xkb_kb_id <> 000 and xkb_kb_id <> 999 then do:
                        if xkb_type = "M" then do:
                            find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                            v_fqty = if avail xmpt_mstr then xmpt_kb_fqty else 0  .
                            v_qty_firm = if avail xmpt_mstr then xmpt_qty_firm else no .
                        end.
                        if xkb_type = "P" then do:
                            find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                            v_fqty = if avail xppt_mstr then xppt_kb_fqty else 0  .
                            v_qty_firm = if avail xppt_mstr then xppt_qty_firm else no .
                        end.
        
                        if (xkb_kb_raim_qty + v_qty ) > xkb_kb_qty then do:
                            disp "超过看板固定批量" @ WMESSAGE NO-LABEL with fram F1600 .
                            pause 1 no-message .
                            if v_qty_firm then undo , retry.
                        end.                    
                end.
                
                /*产生库存交易记录*/ 
                {gprun.i ""xxmhjit047tr.p""   "( output undo_stat )"}
                if undo_stat then do:
                   undo mainloop ,retry mainloop .
                end.
        
            end.   /* avail xkb_mstr */
            
            display  skip WMESSAGE NO-LABEL with fram F1600.
            
            display "...处理...  " @ WMESSAGE NO-LABEL with fram F1600.
            pause 0.
            
            display  "" @ WMESSAGE NO-LABEL with fram F1600.
            pause 0.
            leave V1600L.
        END.  /* END 1600    */
        
        
       
    end. /*if qtycomp = 0 then 8888888888888888888888888888888888888888888888888 */
    else do:  /*if qtycomp <> 0 then 888888888888888888888888888888888888888888888 */

      for first wr_route
         fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone wr_op wr_part wr_run wr_wkctr)
          where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
         and wr_op    = op
      no-lock:
      end. /* FOR FIRST wr_route */
   
      if not available wr_route
      then do:

         /* OPERATION DOES NOT EXIST */
/*          {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3} */
              run xxmsg01.p (input 106 , input  "" ,input yes )  .
/*          next-prompt op with frame a.    /* xp001 */   */
         undo mainloop , retry mainloop .   /* xp001 */
      end. /* IF NOT AVAILABLE wr_route */

      if not wr_milestone
      then do:

         if is_wiplottrace_enabled()
         then do:

            if prev_milestone_operation(cumwo_lot, op) <> ?
               or (prev_milestone_operation(cumwo_lot, op) = ?
                   and not wr_milestone)
               and is_operation_queue_lot_controlled
               (cumwo_lot,
               prev_milestone_operation(cumwo_lot, op),
               OUTPUT_QUEUE)
            then do:

/*                {pxmsg.i &MSGNUM=8465 &ERRORLEVEL=3} */
                    run xxmsg01.p (input 8465 , input  "" ,input yes )  .
               /*WIP LOT TRACE IS ENABLED AND OPERATION IS A */
               /*NON-MILESTONE                               */
               undo, retry.
            end. /* IF pre_milestone_operation(cumwo_lot, .... */
         end. /* IF is_wiplottrace_enabled() */

         if not wr_milestone
            and not is_wiplottrace_enabled()
         then
            /* OPERATION NOT A MILESTONE */
/*             {pxmsg.i &MSGNUM=560 &ERRORLEVEL=2} */
               run xxmsg01.p (input 560 , input  "" ,input yes )  .

      end. /* IF NOT wr_milestone */

/*       display wr_desc with frame a.      /*xp001*/ */


      assign
         wkctr              = ""
         mch                = ""
         dept               = ""
         qty_proc           = 0
         um                 = ""
         conv               = 1
         qty_rjct           = 0
         rjct_rsn_code      = ""
         rejque_multi_entry = no
         to_op              = op
         qty_scrap          = 0
         scrap_rsn_code     = ""
         outque_multi_entry = no
         mod_issrc          = yes             /*xp001*/
         start_run          = ""
         act_run_hrs        = 0
         stop_run           = ""
         earn_code          = ""
         rsn_codes          = ""
         quantities         = 0
         scrap_rsn_codes    = ""
         scrap_quantities   = 0
         reject_rsn_codes   = ""
         reject_quantities  = 0
         .

      {gprun.i ""resetmno.p""
         "(input cumwo_lot,
           input op,
           output move_next_op)"}


          

      assign
         wkctr = wr_wkctr
         mch   = wr_mch.

      for first wc_mstr
         fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
           and wc_mch   = mch
      no-lock:
      end. /* FOR FIRST wc_mstr */

      dept = wc_dept.
      for first dpt_mstr
         fields( dpt_domain dpt_dept dpt_desc)
          where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
      no-lock:
      end. /* FOR FIRST dpt_mstr */

      for first wo_mstr
         fields( wo_domain wo_assay wo_due_date wo_expire wo_grade wo_loc wo_lot
                wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                wo_rctstat_active wo_rel_date wo_routing wo_site)
          where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
      no-lock: /* FOR FIRST wo_mstr */
      end. /* FOR FIRST wo_mstr */

      for first pt_mstr
         fields( pt_domain pt_desc1 pt_loc pt_lot_ser pt_part pt_rctwo_active
                pt_rctwo_status pt_site pt_um)
          where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
      no-lock:
      end. /* FOR FIRST pt_mstr */

      um = pt_um.

      for first ea_mstr
         fields( ea_domain ea_desc ea_earn ea_type)
          where ea_mstr.ea_domain = global_domain and  ea_type = "1"
      no-lock:
      end. /* FOR FIRST ea_mstr */

      if available ea_mstr
      then
         earn_code = ea_earn.
/*apple add**********************************************************/
        find first rps_mstr where rps_mstr.rps_domain = global_domain
	                      and rps_part = part
			      and rps_site = site
			      and rps_line = line
			      and rps_due_date = eff_date
			      no-lock no-error.
/*     if available rps_mstr then do:            */
/*        qty_proc = rps_qty_req - rps_qty_comp. */
/*        tot-qty  = qty_proc.                   */
/*     end.                                      /*xp001*/      */
/*apple add**********************************************************/

/*       display                                                       */
/*          wkctr                                                      */
/*          mch                                                        */
/*          wc_desc                                                    */
/*          dept                                                       */
/*          dpt_desc          when (available dpt_mstr)                */
/*          ""                when (not available dpt_mstr) @ dpt_desc */
/*          qty_proc                                                   */
/*          um                                                         */
/*          conv                                                       */
/*          qty_rjct                                                   */
/*          rjct_rsn_code                                              */
/*          rejque_multi_entry                                         */
/*          to_op                                                      */
/*          qty_scrap                                                  */
/*          scrap_rsn_code                                             */
/*          outque_multi_entry                                         */
/*          mod_issrc                                                  */
/*          move_next_op                                               */
/*          start_run                                                  */
/*          act_run_hrs                                                */
/*          stop_run                                                   */
/*          earn_code                                                  */
/*          ea_desc           when (available ea_mstr)                 */
/*          ""                when (not available ea_mstr) @ ea_desc   */
/*       with frame bkfl1.                                                   /*xp001*/          */




      if is_wiplottrace_enabled()
      then do:

         run init_bkfl_input_wip_lot_temptable in h_wiplottrace_procs.
         run init_bkfl_output_wip_lot_temptable in h_wiplottrace_procs.
         run init_bkfl_scrap_wip_lot_temptable in h_wiplottrace_procs.
         run init_bkfl_reject_wip_lot_temptable in h_wiplottrace_procs.
      end. /* if is_wiplottrace_enabled() */

      /* LOOPC ADDED TO BRING THE CURSOR CONTROL TO SECOND         */
      /* FRAME DURING UNDO,RETRY                                   */
/*mage*/ line1 = line.

      loopc:
      do with frame bkfl1 on error undo, retry:

         for first wr_route
            fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
            wr_op
                   wr_part wr_run wr_wkctr)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
              and wr_op  = op
         no-lock:
         end. /* FOR FIRST wr_route */

         for each sr_wkfl exclusive-lock
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser:
            delete sr_wkfl.
         end. /* FOR EACH sr_wkfl */

         for each pk_det exclusive-lock
             where pk_det.pk_domain = global_domain and  pk_user = mfguser:
            delete pk_det.
         end. /* FOR EACH pk_det */

         /*DELETE LOTW_WKFL*/
         {gprun.i ""gplotwdl.p""}

/* /*apple         {gprun.i ""rebkfli1.p""*/   */
/* /*apple*/         {gprun.i ""xxrebkfli1.p"" */
/*             "(input cumwo_lot,              */
/*               input op,                     */
/*               output undo_stat)"}          xp001   */
         if undo_stat then run xxmsg01.p (input 0 , input  "errror on : xxrebkfli1.p   leave now " ,input yes )  .
         if undo_stat
         then 
            undo mainloop , retry mainloop .

         assign
            conv_qty_proc  = qty_proc * conv
            conv_qty_rjct  = qty_rjct * conv
            conv_qty_scrap = qty_scrap * conv
            conv_qty_move  = if move_next_op
                             then
                                 conv_qty_proc - conv_qty_rjct - conv_qty_scrap
                             else 0.

         /* IF QUANTITY PROCESSED AT THIS OPERATION IS NEGATIVE AND    */
         /* THE CUMULATIVE MOVE QUANTITY IS ZERO THEN IT IS NOT A VALID*/
         /* BACKFLUSH TRANSACTION. THE USER IS TRYING TO DO A NEGATIVE */
         /* RECEIPT BEFORE DOING ANY POSITIVE RECEIPT AT THIS OPERATION*/
         /* AND THAT IS NOT ALLOWED.                                   */

         /* UNCONDITIONALLY ALLOW REPORTING NEGATIVE QUANTITIES        */

         /*CHECK QUEUES IF WOULD GO NEGATIVE; IF SO ISSUE MESSAGES     */

         msg_ct = 0.

         /*DETERMINE INPUT QUE OP TO CHECK;
         COULD BE PRIOR NONMILESTONES*/
         {gprun.i ""reiqchg.p""
            "(input cumwo_lot,
              input op,
              input conv_qty_proc,
              output input_que_op_to_ck,
              output input_que_qty_chg)"}

         /*CHECK INPUT QUEUE*/
         {gprun.i ""rechkq.p""
            "(input cumwo_lot,
              input input_que_op_to_ck,
              input ""i"",
              input input_que_qty_chg,
              input-output msg_ct)"}

         /*CHECK OUTPUT QUEUE*/
         {gprun.i ""rechkq.p""
            "(input cumwo_lot,
              input op,
              input ""o"",
              input (conv_qty_proc - conv_qty_scrap
                    - conv_qty_rjct - conv_qty_move),
              input-output msg_ct)"}


         /*CHECK REJECT QUEUE*/
         {gprun.i ""rechkq.p""
            "(input cumwo_lot,
              input to_op,
              input ""r"",
              input conv_qty_rjct,
              input-output msg_ct)"}

 /*run xxmsg01.p (input 0 , input string(cumwo_lot) + "11" + string(to_op) + "22" + string(conv_qty_rjct) + "33" + string(msg_ct) ,input yes )  .  xptest*/
         /*CHECK INPUT QUEUE NEXT OP IF MOVE*/
         if move_next_op
         then do:

            for first wr_route
               fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
               wr_op
                      wr_part wr_run wr_wkctr)
                where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
                 and wr_op > op
            no-lock:
            end. /* FOR FIRST wr_route */

            if available wr_route
            then do:

               {gprun.i ""rechkq.p""
                  "(input cumwo_lot,
                    input wr_op,
                    input ""i"",
                    input conv_qty_move,
                    input-output msg_ct)"}
            end. /* IF AVAILABLe wr_route */
         end. /* IF move_next_op */

         /*FORCE A PAUSE IF NECESSARY*/
         {gprun.i ""repause.p"" "(input msg_ct)"}

         /*BUILD DEFAULT COMPONENT PART ISSUE LIST*/

         {gprun.i ""recrtcl.p""
            "(input cumwo_lot,
              input op,
              input yes,
              input conv_qty_proc,
              input eff_date,
              input dont_zero_unissuable,
              input wkctr,
              output rejected,
              output lotserials_req)"
         }

         if lotserials_req
         then do:

            /*{pxmsg.i &MSGNUM=1119 &ERRORLEVEL=1}*/
              run xxmsg01.p (input 1119 , input  "" ,input yes )  .
         end. /* IF lotserials_req */

         if rejected
         then
            mod_issrc = yes.

         /*MODIFY COMPONENT PART ISSUE LIST*/
         if mod_issrc
         then do:

            hide frame bkfl1 no-pause.
            hide frame a no-pause.

/*             display                                                       */
/*                site                                                       */
/*                part   /*父件*/                                            */
/*                op                                                         */
/*                line   /*产线*/                                            */
/*             with frame b side-labels width 80 attr-space.       /*xp001*/ */
/*mage*/ line1 = line.
/*          qtycomp = 0 .  /*xp001*/ */
            {gprun.i ""xxmhjit047ln.p""
               "(input cumwo_lot,
                 input part,   /*父件*/
                 input site, 
                 input eff_date,
                 input wkctr,
                 input conv_qty_proc,
                 input op,
                 input v_comp ,
                 input qtycomp,
                 output undo_stat)"}

            hide frame b no-pause.

            if undo_stat then run xxmsg01.p (input 0 , input  "errror on : xxmhjit047ln.p   leave now " ,input yes )  .
            if undo_stat
            then do:
                 undo mainloop , retry mainloop .

/*                view frame a.     */
/*                view frame bkfl1.  */

/*                /* RESTRICT PROCESS FOR BATCHRUN  */ */
/*                if batchrun                          */
/*                then                                 */
/*                   undo main, leave main.            */
/*                else                                 */
/*                   undo, retry.                       /*xp001*/    */
            end. /* IF undo_stat */
         end. /* IF mod_issrc */

         if is_wiplottrace_enabled() and
            is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
         then do:

/*             view frame a.     */
/*             view frame bkfl1.      /*xp001*/*/

            if is_operation_queue_lot_controlled(cumwo_lot, op, INPUT_QUEUE)
            then do:

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibi,wlpl,rebkfl'
                  &FRAME = 'yn' &CONTEXT = 'INPUT'}

               if {gpisapi.i}
               then
                  pause 0.

               run get_bkfl_input_wip_lots_from_user
                  in h_wiplottrace_procs
                  (input cumwo_lot,
                   input op,
                   input qty_proc,
                   input conv,
                   input um,
                   input site,
                   input wkctr,
                   input mch,
                   output undo_stat).

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibi,wlpl,rebkfl'
                  &FRAME = 'yn'}

               if undo_stat
               then
                  undo, retry.
            end. /* IF is_operation_queue_lot_controlled ... */

            assign
               move_to_wkctr = wkctr
               move_to_mch   = mch.

            if not is_last_operation(cumwo_lot, op)
               and move_next_op
            then do:

               if {gpisapi.i}
               then
                  pause 0.

               run get_destination_wkctr_mch_from_user in h_wiplottrace_procs
                  (input cumwo_lot,
                   input next_milestone_operation(cumwo_lot, op),
                   output move_to_wkctr,
                   output move_to_mch,
                   output undo_stat).

               if undo_stat
               then
                  undo, retry.
            end. /* IF NOT is_last_operation */

            if not (is_last_operation(cumwo_lot, op)
               and move_next_op)
            then do:

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibo,wlpl,rebkfl'
                  &FRAME = 'yn' &CONTEXT = 'RECEIPT'}

               if {gpisapi.i}
               then
                  pause 0.

               run get_bkfl_output_wip_lots_from_user in h_wiplottrace_procs
                  (input cumwo_lot,
                   input op,
                   input qty_proc,
                   input conv,
                   input um,
                   input move_next_op,
                   input site,
                   input wkctr,
                   input mch,
                   output undo_stat).

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibo,wlpl,rebkfl'
                  &FRAME = 'yn'}

               if undo_stat
               then
                  undo, retry.
            end. /* IF NOT (islast_operation .. */

            if qty_rjct <> 0
            then do:

               if not is_operation_queue_lot_controlled(cumwo_lot,
                  to_op,
                  REJECT_QUEUE)
               then do:

/*                   {pxmsg.i &MSGNUM=8426 &ERRORLEVEL=3} */
                       run xxmsg01.p (input 8426 , input  "" ,input yes )  .
                  /*TO OPERATION MUST BE LOT CONTROLLED*/
                  undo, retry.
               end. /* IF NOT is_operation_queue_lot_controlled ... */

               do for reject_to_wr_route:
                  for first reject_to_wr_route
                     fields( wr_domain wr_lot wr_op wr_wkctr wr_mch)
                      where reject_to_wr_route.wr_domain = global_domain and
                      wr_lot = cumwo_lot
                       and wr_op  = to_op
                     no-lock:
                  end. /* FOR FIRST reject_to_wr_route */

                  assign
                     l_reject_to_wkctr = wr_wkctr
                     l_reject_to_mch   = wr_mch.
               end. /* DO FOR reject_to_wr_route */

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibr,wlpl,rebkfl'
                  &FRAME = 'yn' &CONTEXT = 'REJECT'}

               if {gpisapi.i}
               then
                  pause 0.

               run get_bkfl_reject_wip_lots_from_user in h_wiplottrace_procs
                  (input cumwo_lot,
                   input op,
                   input qty_rjct,
                   input conv,
                   input um,
                   input to_op,
                   input site,
                   input l_reject_to_wkctr,
                   input l_reject_to_mch,
                   output undo_stat).

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibr,wlpl,rebkfl'
                  &FRAME = 'yn'}

               if undo_stat
               then
                  undo, retry.
            end. /* IF qty_rjct <> 0 */

            if qty_scrap <> 0
            then do:

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibs,wlpl,rebkfl'
                  &FRAME = 'yn' &CONTEXT = 'SCRAP'}

               if {gpisapi.i}
               then
                  pause 0.

               run get_bkfl_scrap_wip_lots_from_user in h_wiplottrace_procs
                  (input cumwo_lot,
                   input op,
                   input qty_scrap,
                   input conv,
                   input um,
                   input site,
                   input wkctr,
                   input mch,
                   output undo_stat).

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibs,wlpl,rebkfl'
                  &FRAME = 'yn'}

               if undo_stat
               then
                  undo, retry.
            end. /* IF qty_scrap <> 0 */

            if {gpisapi.i}
               then
                  pause 0.

            run bkfl_check_output_scrap_reject in h_wiplottrace_procs
               (input cumwo_lot,
                input op,
                input move_next_op,
                input conv,
                input site,
                input wkctr,
                input mch,
                input move_to_wkctr,
                input move_to_mch,
                output undo_stat).

            if undo_stat
            then
               undo, retry.

            if move_next_op
               and is_last_operation(cumwo_lot, op)
            then do:

               assign
                  mod_issrc = true
                  lotserial = ''.

               run bkfl_create_receive_sr_wkfl in h_wiplottrace_procs
                  (cumwo_lot, conv_qty_move).
            end. /* IF move_next_op */
         end.  /* IF is_wiplottrace_enabled() .. */


         /*FORCE MODIFY FINISHED PART RECEIVE LIST IF ANY COMPONENTS
         L/S CONTROLLED, OR IF FOR SOME REASON THEY ARE NOT ISSUABLE*/
         if move_next_op
            and conv_qty_move <> 0
         then do:

            for first wr_route
               fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
                      wr_op wr_part wr_run wr_wkctr)
                where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
                 and wr_op > op
            no-lock:
            end. /* FOR FIRST wr_route */

            if not available wr_route
            then do:

               for first wo_mstr
                  fields( wo_domain wo_assay wo_due_date wo_expire wo_grade
                  wo_loc wo_lot
                         wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                         wo_rctstat_active wo_rel_date wo_routing wo_site)
                   where wo_mstr.wo_domain = global_domain and  wo_lot =
                   cumwo_lot
               no-lock:
               end. /* FOR FIRST wo_mstr */

               for first pt_mstr
                  fields( pt_domain pt_desc1 pt_loc pt_lot_ser pt_part
                  pt_rctwo_active
                         pt_rctwo_status pt_site pt_um)
                   where pt_mstr.pt_domain = global_domain and  pt_part =
                   wo_part
               no-lock:
               end. /* FOR FIRST pt_mstr */

               rejected = no.
               if index("LS",pt_lot_ser) = 0
               then do:

 /**mage                 /*ADDED BLANKS FOR TRNBR AND TRLINE*/
                  {gprun.i ""icedit2.p""
                     "(input ""RCT-WO"",
                       input if wo_site > """" then wo_site
                             else pt_site,
                       input if wo_loc > """" then wo_loc
                             else pt_loc,
                       input wo_part,
                       input """",
                       input """",
                       input conv_qty_move,
                       input pt_um,
                       input """",
                       input """",
                       output rejected)"}**********/
 
/*mage**********add **********************************************/
if pt_part > "1" and pt_part < "1x"  then
{gprun.i ""icedit2.p""
                     "(input ""RCT-WO"",
                       input if wo_site > """" then wo_site
                             else pt_site,
                       input if wo_loc > """" then wo_loc
                             else line1,
                       input wo_part,
                       input """",
                       input """",
                       input conv_qty_move,
                       input pt_um,
                       input """",
                       input """",
                       output rejected)"}
            	      else  {gprun.i ""icedit2.p""
                     "(input ""RCT-WO"",
                       input if wo_site > """" then wo_site
                             else pt_site,
                       input if wo_loc > """" then wo_loc
                             else pt_loc,
                       input wo_part,
                       input """",
                       input """",
                       input conv_qty_move,
                       input pt_um,
                       input """",
                       input """",
                       output rejected)"}
/*mage**********add **********************************************/

               end. /* IF INDEX("LS,pt_lot_ser) = 0 */                
               if index("LS",pt_lot_ser) > 0
                  or mod_issrc
                  or rejected
               then do:

                  hide frame bkfl1 no-pause.
                  hide frame a no-pause.

/*                   display                                                     */
/*                      site                                                     */
/*                      part                                                     */
/*                      op                                                       */
/*                      line                                                     */
/*                   with frame b side-labels width 80 attr-space.     /*xp001*/ */

                  {&REBKFL-P-TAG6}
                  /*MODIFY FINISHED PART RECEIVE LIST*/
/*mage*/                  {gprun.i ""xxrercvlst.p""
                     "(input cumwo_lot,
                       input conv_qty_move,
                       output undo_stat)"}

                  {&REBKFL-P-TAG7}
                  hide frame b no-pause.

                  if undo_stat
                  then do:

/*                      view frame a.     */
/*                      view frame bkfl1.      /*xp001*/*/
                     if batchrun
                     then
                        undo mainloop, leave mainloop.
                     else
                        undo, retry.
                  end. /* IF undo_stat */
               end. /* IF INDEX("LS,pt_lot_ser) <> 0 ... */

               else do:
                  do transaction:
                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.

                     assign
                        sr_userid = mfguser
                        sr_lineid = "+" + wo_part
                        sr_site   = wo_site
                        sr_loc    = wo_loc
                        sr_qty    = conv_qty_move.

                     if sr_loc = ""
                     then
/*mage                        sr_loc = pt_loc. */
/*mage*/          if pt_part > "1" and pt_part < "1x"  then
	      sr_loc = line1.
	      else  sr_loc = pt_loc.
                     /* MOVED RESTRICTED TRANSACTION VALIDATION FROM */
                     /* icedit FILES TO worcat01.p FOR "RCT-WO"      */
                     /* TRANSACTIONS.WHEN LOT/SERIAL  = "" IN ITEM   */
                     /* MASTER MAINTENANCE,ITEM WILL NOW BE RECEIVED */
                     /* WITH THE RESPECTIVE VALID STATUS             */
                     /* CHANGE ATTRIBUTES.INITIALIZE ATTRIBUTE */
                     /* VARIABLES WITH CURRENT SETTINGS        */
                     assign
                        chg_assay   = wo_assay
                        chg_grade   = wo_grade
                        chg_expire  = wo_expire
                        chg_status  = wo_rctstat
                        assay_actv  = yes
                        grade_actv  = yes
                        expire_actv = yes
                        status_actv = yes.

                     if wo_rctstat_active = no
                     then do:

                        for first in_mstr
                           fields( in_domain in_part in_site
                              in_rctwo_active in_rctwo_status)
                           no-lock  where in_mstr.in_domain = global_domain and
                            in_part = wo_part
                                     and in_site = wo_site:
                        end. /* FOR FIRST in_mstr */
                        if available in_mstr
                           and in_rctwo_active = yes
                        then
                           chg_status = in_rctwo_status.
                        else
                        if available pt_mstr
                           and pt_rctwo_active
                        then
                           chg_status = pt_rctwo_status.
                        else
                           assign
                              chg_status  = ""
                              status_actv = no.
                     end. /* IF wo_rctstat_active = NO */

                     /* TO CHECK WHETHER "RCT-WO" IS RESTRICTED */
                     /* FOR RECEIVING INVENTORY STATUS.ALSO TO  */
                     /* CHECK FOR STATUS CONFLICT MESSAGE       */
                     {gprun.i ""worcat01.p""
                        "(input recid(wo_mstr),
                          input sr_site,
                          input sr_loc,
                          input sr_ref,
                          input sr_lotser,
                          input eff_date,
                          input sr_qty,
                          input-output chg_assay,
                          input-output chg_grade,
                          input-output chg_expire,
                          input-output chg_status,
                          input-output assay_actv,
                          input-output grade_actv,
                          input-output expire_actv,
                          input-output status_actv,
                          output trans-ok)"}

                     if not trans-ok
                     then do:

                        next-prompt qty_proc.
                        undo loopc,retry loopc.
                     end. /* IF NOT trans-ok */

                  end. /* DO TRANSACTION */
               end. /* ELSE DO */
            end. /* IF NOT AVAILABLE wr_route */
         end. /* IF move_next_op AND ... */

         if is_wiplottrace_enabled() and
            is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
         then do:

            if is_last_operation(cumwo_lot, op)
               and move_next_op
            then do:

               /*IN THIS CASE WE DIDN'T GET OUTPUT WIP LOTS        */
               /*FROM THE USER; WE USE THE LOTSER'S ENTERED        */
               /*IN SR_WKFL FOR THE FINISHED MATERIAL INSTEAD.     */
               /*THE BACKFLUSH SUBROUTINE REBKFLA.P WILL BACKFLUSH */
               /*THIS LIST INTO WIP, THEN RECEIVE.P WILL MOVE      */
               /*IN TO FINISHED GOODS INVENTORY.                   */

               run init_bkfl_output_wip_lot_temptable
                  in h_wiplottrace_procs.

               for each sr_wkfl no-lock
                      where sr_wkfl.sr_domain = global_domain and  sr_userid =
                      mfguser and sr_lineid = "+" + part
                     break by sr_lotser by sr_ref:
                  accumulate sr_qty (sub-total by sr_ref).

                  if last-of(sr_ref)
                  then
                     run create_bkfl_output_wip_lot_temptable
                        in h_wiplottrace_procs
                        (input sr_lotser,
                        input sr_ref,
                        (accum sub-total by sr_ref sr_qty) / conv).
               end. /* FOR EACH sr_wkfl */
            end. /* IF is_last_operation */

            /*CHECK FOR COMBINED LOTS - INPUT WIP AND COMPONENTS */
            /*TO A PARTICULAR OUTPUT WIP LOT                     */

            run bkfl_check_for_combined_lots in h_wiplottrace_procs
               (input cumwo_lot,
                input op,
                input conv,
                output result_status).

            if result_status = FAILED_EDIT
            then do:

/*                view frame a.     */
/*                view frame bkfl1.      /*xp001*/*/

               if batchrun
               then
                  undo mainloop, leave mainloop.
               else
                  undo, retry.
            end. /* IF result_status = FAILED_EDIT */

            /*CHECK FOR SPLIT LOTS - OUTPUT WIP AND COMPONENTS */
            /*TO A PARTICULAR INPUT WIP LOT                    */

            consider_output_qty = yes.

            run bkfl_check_for_split_lots in h_wiplottrace_procs
               (input cumwo_lot,
               input op,
               input conv,
               input consider_output_qty,
               output result_status).

            if result_status = FAILED_EDIT
            then do:

/*                view frame a.     */
/*                view frame bkfl1.      /*xp001*/*/

               if batchrun
               then
                  undo mainloop, leave mainloop.
               else
                  undo, retry.
            end. /* IF result_status = FAILED_EDIT */

            /*CHECK FOR MAX LOT SIZE EXCEEDED*/

            run bkfl_max_lotsize_check in h_wiplottrace_procs
               (input cumwo_lot,
                input op,
                input conv).
         end. /* IF is_wiplottrace_enabled() AND ... */

         for first wo_mstr
            fields( wo_domain wo_assay wo_due_date wo_expire wo_grade wo_loc
            wo_lot
                   wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                   wo_rctstat_active wo_rel_date wo_routing wo_site)
             where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
         no-lock:
         end. /* FOR FIRST wo_mstr */

         wo_recno = recid(wo_mstr).

         for first wr_route
            fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
            wr_op
                   wr_part wr_run wr_wkctr)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
              and wr_op  = op
         no-lock:
         end. /* FOR FIRST wr_route */

         wr_recno = recid(wr_route).


/*          /* PATCH N1V0 HAS ENABLED CIM LOAD */                  */
/*          {mpwindow.i                                            */
/*             wo_part                                             */
/*             op                                                  */
/*             "if wo_routing = """" then wr_part else wo_routing" */
/*             eff_date                                            */
/*             }                                                   */

/*          view frame a.     */
/*          view frame bkfl1.     */


         yn = yes.   /*xp001*/ 
/*          {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn} */
/*          message "确认回冲?" update yn .     */
/*          if yn <> yes                        */
/*          then                                */
/*             undo mainloop , retry mainloop . */

         /* TO CHECK THE CUMULATIVE ORDER IS NOT CLOSED */
         /* DURING USER INTERFACE                       */
         if can-find(wo_mstr
             where wo_mstr.wo_domain = global_domain and   wo_lot    = cumwo_lot
            and   wo_status  = "C"
            no-lock)
         then do:

            /* CUM ORDER IS CLOSED */
/*             {pxmsg.i &MSGNUM=5101 &ERRORLEVEL=3} */
                 run xxmsg01.p (input 5101 , input  "" ,input yes)  .
            undo mainloop, retry mainloop.

         end. /*  IF CAN-FIND(wo_mstr ... */

         /* TO CHECK THE CUMULATIVE ORDER IS NOT EXPIRED */
         /* DURING USER INTERFACE                        */
         if not can-find(wo_mstr
             where wo_mstr.wo_domain = global_domain and (  wo_lot   = cumwo_lot
            and  (eff_date >= wo_rel_date or wo_rel_date = ?)
            and  (eff_date <= wo_due_date or wo_due_date = ?)
            ) no-lock)
         then do:

            /* CUM ORDER HAS EXPIRED */
        /*     {pxmsg.i &MSGNUM=5124 &ERRORLEVEL=3}    */
                 run xxmsg01.p (input 5124 , input  "" ,input yes )  .
            undo mainloop, retry mainloop .

         end. /* IF NOT CAN-FIND(wo_mstr) */

         {&REBKFL-P-TAG2}

         /* NOW THAT WE HAVE LAST INPUT FROM USER, RECHECK INVENTORY*/
         {gprun.i ""reoptr1f.p""
            "(input """",
              output inv-issued)"}

         if inv-issued
         then
            undo, retry.
      end. /* DO WITH FRAME bkfl1 */


      /* end loopc:*/


      /*************************************/
      /*  GOT ALL DATA AND VALIDATED IT,   */
      /*  NOW WE CAN DO SOMETHING WITH IT  */
      /*************************************/

      /*NO TRANSACTION SHOULD BE PENDING HERE*/
      {gprun.i ""gpistran.p""
         "(input 1,
           input """")"}

      /*CREATE OP_HIST RECORD*/
      {gprun.i ""reophist.p""
         "(input trans_type,
           input cumwo_lot,
           input op,
           input emp,
           input wkctr,
           input mch,
           input dept,
           input shift,
           input eff_date,
           output ophist_recid)"}
      {&REBKFL-P-TAG9}

      /*ISSUE COMPONENTS*/
      {gprun.i ""rebkflis.p""
         "(input cumwo_lot,
           input eff_date,
           input ophist_recid)"}

      {&REBKFL-P-TAG8}
      /*REGISTER QTY PROCESSED FOR NONMILESTONES*/
      {gprun.i ""rebkflnm.p""
         "(input cumwo_lot,
           input op,
           input eff_date,
           input shift,
           input trans_type,
           input conv_qty_proc)"}

      /* REUPOPST.P IS INCLUDED TO FIND THE ALTERNATE WORK CENTER    */
      /* RUN RATE WHEN THE WORK CENTER OR MACHINE DEFINED DURING     */
      /* BACKFLUSH IS DIFFERENT FROM THE ONE DEFINED IN WORK ORDER   */
      /* ROUTING AND TO POPULATE OP_STD_RUN WITH THE CORRECT VALUE.  */
      /* IF THE RATE SET UP IN WORK CENTER/ROUTING(wcr_rate) IS ZERO,*/
      /* THE STANDARD RUN TIME IN THE OPERATION HISTORY(op_std_run)IS*/
      /* NOT CHANGED EVEN IF ALTERNATE WORK CENTER OR MACHINE IS USED*/
      /* FOR REPORTING.                                              */

      if (input wkctr <> wr_wkctr
         or input mch <> wr_mch) then
      do:
         {gprun.i ""reupopst.p"" "(input ophist_recid)"}
      end. /*END OF IF INPUT(INPUT WKCTR */

      /*LABOR AND BURDEN TRANSACTIONS*/
      std_run_hrs = 0.

      do transaction:
         for first wr_route
            fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
            wr_op
                   wr_part wr_run wr_wkctr)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
              and wr_op  = op
         no-lock:
         end. /* FOR FIRST wr_route */

         if wr_auto_lbr
         then
            std_run_hrs = conv_qty_proc * wr_run.
      end. /* DO TRANSACTION */

/*minth*/      {gprun.i ""xxrelbra.p""
         "(input cumwo_lot,
           input op,
           input wkctr,
           input mch,
           input dept,
           input (act_run_hrs + std_run_hrs),
           input eff_date,
           input earn_code,
           input emp,
           input true,
           input ophist_recid)"}

      do transaction:
         /*REGISTER QTY PROCESSED (REDUCE INQUE, INCREASE OUTQUE)*/
         {gprun.i ""rebkfla.p""
            "(input cumwo_lot,
              input op,
              input ophist_recid,
              input conv_qty_proc)"}

         /*BACKFLUSH LIST OF INPUT WIP LOTS AND OUTPUT WIP LOTS. */
         /*NOTE THAT THIS HAS TO BE DONE IN THE SAME TRANSACTION */
         /*AS REBKFLA.P.                                         */

         if is_wiplottrace_enabled() and
            is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
         then do:

            for first op_hist
               fields( op_domain op_trnbr op_wo_lot op_wo_op)
               where recid(op_hist) = ophist_recid
            no-lock:
            end. /* FOR FIRST op_hist */

            run bkfl_backflush_wip_lots in h_wiplottrace_procs
               (input op_trnbr,
                input wr_lot,
                input wr_op,
                input conv,
                input site,
                input wkctr,
                input mch).
         end. /* IF is_wiplottrace_enabled() AND .. */
      end. /*TRANSACTION*/

      /* ONLY EXECUTE WAREHOUSE INTERFACE CODE IF WAREHOUSING  */
      /* INTERFACE IS ACTIVE                                   */

      if can-find(first whl_mstr  where whl_mstr.whl_domain = global_domain and
       whl_act = true no-lock)
      then do:

         for each sr_wkfl  where sr_wkfl.sr_domain = global_domain and
         sr_userid = mfguser no-lock:

            /* CREATE A TE_MSTR RECORD */

            {gprun.i ""wireoptr.p""
               "(input 'wi-rebkfl',
                 input wkctr,
                 input sr_qty,
                 input sr_site,
                 input sr_loc,
                 input eff_date,
                 input shift,
                 input wo_part,
                 input sr_lotser,
                 input sr_ref,
                 input um,
                 input conv)"}

         end. /* FOR EACH sr_wkfl */

      end. /* IF CAN-FIND ( FIRST whl_mstr ... */

      /*MOVE TO NEXT OP IF WE NEED TO*/
      if move_next_op
      then do:

         for first wr_route
            fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
            wr_op
                   wr_part wr_run wr_wkctr)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
              and wr_op > op
         no-lock:
         end. /* FOR FIRST wr_route */
         if available wr_route
         then do
         transaction:

            {gprun.i ""removea.p""
               "(input cumwo_lot,
                 input op,
                 input eff_date,
                 input ophist_recid,
                 input conv_qty_move)"}

            /*MOVE LIST OF INPUT WIP LOTS AND OUTPUT WIP LOTS*/

            if is_wiplottrace_enabled() and
               is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
            then
               run bkfl_move_wip_lots in h_wiplottrace_procs
                  (input op_wo_lot,
                   input op_wo_op,
                   input conv,
                   input site,
                   input wkctr,
                   input mch,
                   input move_to_wkctr,
                   input move_to_mch).
         end. /* IF is_wiplottrace_enabled() AND .. */
         else do:
            {&REBKFL-P-TAG10}
            /*RECEIVE COMPLETED MATERIAL.                            */
            /*THIS SUBPROGRAM PICKS UP INPUT FROM SR_WKFL            */
            {gprun.i ""receive.p""
               "(input cumwo_lot,
                 input eff_date,
                 input ophist_recid)"}

            {gprun.i ""gplotwdl.p""}

            if clc_lotlevel <> 0
               and pt_lot_ser = "L"
            then
            do transaction:
               find wo_mstr
                   where wo_mstr.wo_domain = global_domain and  wo_lot =
                   cumwo_lot exclusive-lock.
               if available wo_mstr
                  and not wo_lot_rcpt
               then
                  wo_lot_next = "".
            end. /* DO TRANSACTION */
         end. /* ELSE DO */
      end. /* IF move_next_op */

      if is_wiplottrace_enabled() and
         is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
      then do:

         if qty_rjct <> 0
         then
            run bkfl_reject_wip_lots in h_wiplottrace_procs
               (input ophist_recid,
                input conv,
                input to_op,
                input l_reject_to_wkctr,
                input l_reject_to_mch).

         if qty_scrap <> 0
         then
            run bkfl_scrap_wip_lots in h_wiplottrace_procs
               (input ophist_recid,
                input conv).
      end. /* IF is_wiplottrace_enabled() AND .. */
      else do:
         /*PROCESS SCRAP QUANTITIES*/
         if outque_multi_entry
         then do:

            do i = 1 to 10:
               if scrap_quantities[i] <> 0
               then do:

                  conv_qty_scrap = scrap_quantities[i] * conv.

                  {gprun.i ""reophist.p""
                     "(input trans_type,
                       input cumwo_lot,
                       input op,
                       input emp,
                       input wkctr,
                       input mch,
                       input dept,
                       input shift,
                       input eff_date,
                       output ophist_recid)"}
                  {&REBKFL-P-TAG11}

/*mage*/                  {gprun.i ""xxrescrapa.p""
                     "(input cumwo_lot,
                       input op,
                       input conv_qty_scrap,
                       input scrap_rsn_codes[i],
                       input yes,
                       input emp,
                       input ophist_recid)"}
               end. /* IF scrap_quantities[i] <> 0 */
            end. /* DO i = 1 TO 10: */
         end. /* IF outque_multi_entry */
         else
         if conv_qty_scrap <> 0
         then do:

/*mage*/            {gprun.i ""xxrescrapa.p""
               "(input cumwo_lot,
                 input op,
                 input conv_qty_scrap,
                 input scrap_rsn_code,
                 input yes,
                 input emp,
                 input ophist_recid)"}
         end. /* ELSE IF conv_qty_scrap */

         /*PROCESS REJECT QUANTITIES*/
         {gprun.i ""rejectb.p""
            "(input cumwo_lot,
              input op,
              input to_op,
              input emp,
              input shift,
              input eff_date,
              input conv_qty_rjct,
              input trans_type)"}

         if rejque_multi_entry
         then do:

            do i = 1 to 10:
               if reject_quantities[i] <> 0
               then do:

                  conv_qty_rjct = reject_quantities[i] * conv.

                  {gprun.i ""reophist.p""
                     "(input trans_type,
                       input cumwo_lot,
                       input to_op,
                       input emp,
                       input wkctr,
                       input mch,
                       input dept,
                       input shift,
                       input eff_date,
                       output ophist_recid)"}
                  {&REBKFL-P-TAG12}
 
                  {gprun.i ""rejecta.p""
                     "(input cumwo_lot,
                       input to_op,
                       input op,
                       input reject_rsn_codes[i],
                       input ophist_recid,
                       input conv_qty_rjct)"}
               end. /* IF reject_quantities[i] <> 0 */
            end. /* DO i = 1 TO 10 */
         end. /* IF rejque_multi_entry */
         else
         if conv_qty_rjct <> 0
         then do:

            {gprun.i ""reophist.p""
               "(input trans_type,
                 input cumwo_lot,
                 input to_op,
                 input emp,
                 input wkctr,
                 input mch,
                 input dept,
                 input shift,
                 input eff_date,
                 output ophist_recid)"}
            {&REBKFL-P-TAG13}
 
            {gprun.i ""rejecta.p""
               "(input cumwo_lot,
                 input to_op,
                 input op,
                 input rjct_rsn_code,
                 input ophist_recid,
                 input conv_qty_rjct)"}
         end. /* ELSE IF conv_qty_rjct <> 0 */
      end. /* ELSE DO */
 
      global_addr = string(ophist_recid).
      {gprun.i ""reintchk.p""
         "(input cumwo_lot)"}

/*         /* 退料 xp001  */                                                                                                                         */
		if v_comb and not last-of(tmp_comp) then next . /*累计工单最后才做退料*/

        V1700L:
        REPEAT:
            assign sn_to = ""
               loc_to = ""
               lot_to = ""
               ref_to = ""  .
            hide all no-pause .
            define variable v1700           as char format "x(40)".
            define variable L17001          as char format "x(40)".
            define variable L17002          as char format "x(40)".
            define variable L17003          as char format "x(40)".
            define variable L17004          as char format "x(40)".
            define variable L17005          as char format "x(40)".
            define variable L17006          as char format "x(40)".
            
            display dmdesc format "x(40)" skip with fram F1700 no-box.
            
            L17001 = "退料单号: " + v_nbr .
            display L17001          skip with fram F1700 no-box.
            L17002 =  "领料看板: " + sn_from . 
            display L17002          format "x(40)" skip with fram F1700 no-box.
            L17003 =  "退料数量 " + string(v_qty) . 
            display L17003          format "x(40)" skip with fram F1700 no-box.
            L17004 = "" . 
            display L17004          format "x(40)" skip with fram F1700 no-box.
            L17005 = "已完成差异回冲," . 
            display L17005          format "x(40)" skip with fram F1700 no-box.
            L17006 = "退料:请刷读生产或采购看板" . 
            display L17006          format "x(40)" skip with fram F1700 no-box.
           
            
            Update v1700   WITH  fram F1700 no-label EDITING:
                readkey pause wtimeout.
                if lastkey = -1 then quit.
                if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                end.
                display skip "^" @ WMESSAGE NO-LABEL with fram F1700.
                APPLY LASTKEY.
            END.

            if  v1700 = "e" then undo mainloop, leave mainloop .
        
            if substring(v1700,1,1) <> "M" and substring(v1700,1,1) <> "P" then do:
                disp "错误:非制造/采购看板,请重新刷读" @ WMESSAGE NO-LABEL with fram F1700 .
                undo ,retry .
            end.
            if substring(v1700,2,length(v1700) - 4 ) <> substring(sn_from,2,length(sn_from) - 4 ) then do:
                disp   "错误:转出/转入看板的零件需相同." @ WMESSAGE NO-LABEL with fram F1700  .
                undo, retry.
            end.
        
            find xkb_mstr where xkb_domain = global_domain and xkb_site = site and ( xkb_type = "M" or xkb_type = "P")
                 and xkb_kb_id = inte(substring(v1700,length(v1700) - 2 ,3))
                 and xkb_part = substring(v1700,2,length(v1700) - 4 )
                 and ( (xkb_status = "U" and xkb_kb_raim_qty > 0) or  xkb_status = "A" )   no-error .
            if not avail xkb_mstr then do:
                disp  "错误:无看板记录,或不在使用状态." @ WMESSAGE NO-LABEL with fram F1700 .
                undo , retry.
            end.
            else do :  /* avail xkb_mstr */
                recno_to = recid(xkb_mstr) .
                sn_to = v1700 .


               if xkb_loc = "" then do:
                    disp "" @ L17005 NO-LABEL with fram F1700. 
                    disp "此看板的库位为空,请输入" @ L17006 NO-LABEL with fram F1700. 
                    pause 0.
                    find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                    v1700 = if avail pt_mstr then pt_loc else "" .
                    update v1700 with frame F1700 .
                    repeat:
                        find first loc_mstr where loc_domain = global_domain and loc_loc =  v1700  no-lock no-error .
                        if not avail loc_mstr  then do:
                               disp "无效库位,请重新输入" @ L17006 NO-LABEL with fram F1700.
                               find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                               v1700 = if avail pt_mstr then pt_loc else "" .
                               update v1700 with frame F1700 .
                        end.
                        else do:
                            if v1700 = line then do:
                                disp  "错误:退料库位与转入库位相同." @ WMESSAGE NO-LABEL with fram F1700 .
                                find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                                v1700 = if avail pt_mstr then pt_loc else "" .
                                update v1700 with frame F1700 .
                            end.
                            else leave .
                        end.
                            
                    end.
                    assign xkb_loc = v1700 .
                end.

                assign loc_to = xkb_loc lot_to = xkb_lot ref_to = xkb_ref   .
                if loc_to = line then do:
                   disp  "错误:退料库位与转入库位相同." @ WMESSAGE NO-LABEL with fram F1700 .
                   undo ,retry .
                end.   

                if xkb_status = "U" then do:
                    if ( xkb_lot <> lot_from or xkb_ref <> ref_from )  then do:
                          v1700 = "Y" .
                          disp "批序号不一致,继续(Y/N)?" @ L17006 NO-LABEL with fram F1700.
                          update v1700 with frame f1700 .
                          repeat:
                              if not ( v1700 = "Y" or v1700 = "N" ) then do:
                                   disp "仅限输入'Y'或者'N'..." @ L17006 NO-LABEL with fram F1700.
                                   pause 0.
                                   disp "批序号不一致,继续(Y/N)?" @ L17006 NO-LABEL with fram F1700.
                                   V1700 = "Y" .
                                   update v1700 with frame f1700 .
                              end.
                              else leave .
                          end.
                          if v1700 = "N" then undo ,retry .
                          if v1700 = "Y" then do:
                              v1700 = "Y" .
                              disp "用转入看板的批序号(Y/N) ?" @ L17006 NO-LABEL with fram F1700.
                              update v1700 with frame f1700 .
                              repeat:
                                  if not ( v1700 = "Y" or v1700 = "N" ) then do:
                                       disp "仅限输入'Y'或者'N'..." @ L17006 NO-LABEL with fram F1700.
                                       pause 0.
                                       V1700 = "Y" .
                                       disp "用转入看板的批序号(Y/N) ?" @ L17006 NO-LABEL with fram F1700.
                                       update v1700 with frame f1700 .
                                  end.
                                  else leave .
                              end.
                              if v1700 = "Y"  then assign  loc_to = xkb_loc  lot_to = xkb_lot  ref_to = xkb_ref .
                              if v1700 = "N"  then assign  loc_to = loc_from lot_to = lot_from ref_to = ref_from .
                          end.  /*if v1700 = "Y" then */                        
                    end.
                end.  /*if xkb_status = "U" */
                else do:
                    
                    find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                    v1700 = if avail pt_mstr then pt_loc else "" .
                    disp "请确认转入库位:"  @ L17006 NO-LABEL with fram F1700.
                    update v1700 with frame F1700 no-box.
                    repeat:
                        find first loc_mstr where loc_domain = global_domain and loc_loc =  v1700  no-lock no-error .
                        if not avail loc_mstr  then do:
                               disp "无效库位,请重新输入" @ L17006 NO-LABEL with fram F1700.
                               find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                               v1700 = if avail pt_mstr then pt_loc else "" .
                               update v1700 with frame F1700 .
                        end.
                        else do:
                            if v1700 = line then do:
                                disp  "错误:退料库位与转入库位相同." @ WMESSAGE NO-LABEL with fram F1700 .
                                find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                                v1700 = if avail pt_mstr then pt_loc else "" .
                                update v1700 with frame F1700 .
                            end.
                            else leave .
                        end.
                    end.
                    assign 
                           loc_to = v1700
                           lot_to = lot_from 
                           ref_to = ref_from .
                end.  /*if xkb_status <>  "U" */
        
                if xkb_kb_id <> 000 and xkb_kb_id <> 999 then do:
                        if xkb_type = "M" then do:
                            find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                            v_fqty = if avail xmpt_mstr then xmpt_kb_fqty else 0  .
                            v_qty_firm = if avail xmpt_mstr then xmpt_qty_firm else no .
                        end.
                        if xkb_type = "P" then do:
                            find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                            v_fqty = if avail xppt_mstr then xppt_kb_fqty else 0  .
                            v_qty_firm = if avail xppt_mstr then xppt_qty_firm else no .
                        end.
        
                        if (xkb_kb_raim_qty + v_qty ) > xkb_kb_qty then do:
                            disp "超过看板固定批量" @ WMESSAGE NO-LABEL with fram F1700 .
                            pause 1 no-message .
                            if v_qty_firm then undo , retry.
                        end.                    
                end.
                
                /*产生库存交易记录*/ 
                {gprun.i ""xxmhjit047tr.p""   "( output undo_stat )"}
                if undo_stat then do:
                   undo mainloop ,retry mainloop .
                end.
        
            end.   /* avail xkb_mstr */
            
            display  skip WMESSAGE NO-LABEL with fram F1700.
            
            display "...处理...  " @ WMESSAGE NO-LABEL with fram F1700.
            pause 0.
            
            display  "" @ WMESSAGE NO-LABEL with fram F1700.
            pause 0.
            leave V1700L.
        END.  /* END 1700    */
        
        

    end.  /*if qtycomp <> 0 then 888888888888888888888888888888888888888888888 */
end.  /*for each tmpkb */

    for each tmpkb exclusive-lock:
        delete tmpkb .
    end.
/* trans end *********************************************************** */

               display "...处理...  " @ WMESSAGE NO-LABEL with fram F1500.
               pause 0.

               display  "" @ WMESSAGE NO-LABEL with fram F1500.
               pause 0.
               leave V1500L.

            END.   /* END 1500 */   
           end.  /*if avail xkb_mstr */
       end.   /*if   v1100 <> ""  then  */
       else do:  /*if   v1100 = ""  then  */
           leave v1100L .

       end.   /*if   v1100 = ""  then  */


       display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
       pause 0.

       display  "" @ WMESSAGE NO-LABEL with fram F1100.
       pause 0.

    END.   /* END 1100 */   

    for each tmpkb exclusive-lock:
        delete tmpkb .
    end.

/*     leave mainloop . */
end. /**MAINLOOP**/

/* do transaction:                                                                                                    */
/*     if v_nbr > "" then do:                                                                                         */
/*         find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "RT" exclusive-lock no-error. */
/*         if avail xdn_ctrl then do:                                                                                 */
/*             find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .               */
/*             if avail tr_hist then do:                                                                              */
/*                 repeat:                                                                                            */
/*                     v_nbr = "RT" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .         */
/*                     find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .        */
/*                     if not avail tr_hist then leave .                                                              */
/*                 end.                                                                                               */
/*             end.                                                                                                   */
/*             xdn_next = substring(v_nbr , 3 , length(v_nbr) - 2 ) .                                                 */
/*         end.                                                                                                       */
/*     end.                                                                                                           */
/* end.                                                                                                               */



if is_wiplottrace_enabled()
then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled()
then
   delete PROCEDURE h_wiplottrace_funcs no-error.

