/* xsmf002var01.i    BARCODE SFC SYSTEM Global defines                     */
/* REVISION: 1.0         Last Modified: 2008/11/27   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



/*1.shared各变量定义------------------------------------------------------------*/
define {1} shared var v_line           as char format "x(2)"  label "指令" no-undo.
define {1} shared var v_sn1            as char format "x(11)" label "ID+OP条码".
define {1} shared var v_fldname        as char .                 /*SFC指令的通用代码字段,默认='SFC'*/
define {1} shared var v_user           as char no-undo.          /*雇员代码*/
define {1} shared var v_wc             as char .                 /*工作中心代码*/
define {1} shared var v_wonbr          as char .                 /*工单号*/
define {1} shared var v_wolot          as char .                 /*工单标志*/
define {1} shared var v_op             as integer  .             /*工序*/
define {1} shared var v_wrnbr          as integer .              /*SFC工单关联号*/
define {1} shared var execname         as char .                 /*指令的程式名*/           /*用mfdeclre.i,则删除此行*/                               
define {1} shared var global_userid    as char .                 /*global_userid = v_user*/ /*用mfdeclre.i,则删除此行*/ 
define {1} shared var recno            as recid .                /*mfnp*.i需要用到*/        /*用mfdeclre.i,则删除此行*/                                  
define {1} shared var v_msgtxt         as char format "x(50)" no-undo .    /*指令执行后的消息提示*/                                      
/*以上在主界面程式中赋值,任何子程式可直接调用*/
                                      

define {1} shared var v_date           as date     no-undo .    /*指令历史记录的日期*/
define {1} shared var v_time           as integer  no-undo .    /*指令历史记录的时间*/
define {1} shared var v_trnbr          as integer .  /*xxfb_hist,交易流水号*/                                      
define {1} shared var v_recno          as recid .    /*找最后一笔xxfb_hist用到*/

define {1} shared var v_nbrtype        as char    .  /*for xsgetnbr.i */
define {1} shared var v_line_prev      as char format "x(2)" label "指令" extent 60 .  /*根据程式名,找指令代码,*/
define {1} shared var wtimeout         as integer init 99999 .                         /*自动刷新的分钟数*/

/* define {1} shared var global_user_lang_dir   as char initial  "/app/mfgpro/eb2sp7/us/" .*/ /*用mfdeclre.i,则删除此行*/ 
                              
                                 
                                 
                                 
/*2.shared变量赋值------------------------------------------------------------*/
/*2.1 - 仅登陆主界面时赋值*/
if "{1}" = "new" then do:
    /*v_user        = trim ( userid(sdbname('qaddb')) ).*/
    global_userid = v_user .       
    execname      = "xsmf002.p" .  /*这里赋值,for_and_before xstimeout01.i */
    v_fldname     = lc("sfc") .    /*SFC指令,通用代码的字段名,小写字母  , for_and_before : all procedure */
end.


/*2.2 - 每个程式或每次调用都赋值:*/
v_date      = today. 
v_msgtxt    = "" . 
{xslndefine.i}     /*v_line_prev赋值: 根据程式名,找(前一个)指令代码,如果指令变更,重新登陆才会有效*/
{xstimeout01.i}    /*wtimeout赋值:    长时间未操作自动退出(目前是退出netterm,而非程式而已) */

/*3.procedure定义:(一定要放在变量赋值的后面) --------------------------------*/
{xsgetnbr.i}       /*取SFC相关单号的procedure: getnbr*/
