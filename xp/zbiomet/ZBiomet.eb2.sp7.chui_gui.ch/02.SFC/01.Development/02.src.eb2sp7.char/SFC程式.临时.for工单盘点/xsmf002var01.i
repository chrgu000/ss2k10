/* xsmf002var01.i    BARCODE SFC SYSTEM Global defines                     */
/* REVISION: 1.0         Last Modified: 2008/11/27   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



/*1.shared����������------------------------------------------------------------*/
define {1} shared var v_fldname        as char label "SFCͨ�ô����ֶ���".
define {1} shared var v_user           as char label "����Ա" no-undo.
define {1} shared var v_user2          as char label "����Ա" no-undo.

define {1} shared var v_wc             as char label "����".
define {1} shared var v_line           as char format "x(2)" label "ָ��" no-undo.
define {1} shared var v_sn1            as char format "x(11)" label "ID+OP����".
define {1} shared var v_wonbr          as char . 
define {1} shared var v_wolot          as char . 
define {1} shared var v_op             as integer  .
                                      
define {1} shared var wtimeout         as integer init 99999 .   /*�Զ��˳��ķ�����*/
                                      
define {1} shared var v_nbrtype        as char .  /*for xsgetnbr.i */
define {1} shared var v_wrnbr          as integer .  /*SFC����������*/
define {1} shared var v_trnbr          as integer .  /*xxfb_hist,������ˮ��*/
                                      
define {1} shared var v_recno          as recid .  /*�����һ��xxfb_hist*/
define {1} shared var v_line_prev      as char format "x(2)" label "ָ��" extent 30 .  /*���ݳ�ʽ��,��ָ�����,*/
                                      
                                      
define {1} shared var v_date           as date                no-undo .    /*ָ����ʷ��¼������*/
define {1} shared var v_time           as integer             no-undo .    /*ָ����ʷ��¼��ʱ��*/
define {1} shared var v_msgtxt         as char format "x(50)" no-undo .    /*ָ��ִ�к����Ϣ��ʾ*/
                                 
/*for mfdeclre.i*/ define {1} shared var global_userid     as char .  
/*for mfdeclre.i*/ define {1} shared var execname          as char .                                  
/*for mfdeclre.i*/ define {1} shared var recno             as recid .                                  
/*for mfdeclre.i*/ /* define {1} shared var global_user_lang_dir   as char initial  "/app/mfgpro/eb2sp7/us/" .*/
                              
                                 
                                 
                                 
/*2.shared������ֵ------------------------------------------------------------*/
/*2.1 - ����½������ʱ��ֵ*/
if "{1}" = "new" then do:
    /*v_user        = trim ( userid(sdbname('qaddb')) ).*/
    global_userid = v_user .       
    execname      = "xsmf002.p" .  /*���︳ֵ,for_and_before xstimeout01.i */
    v_fldname     = lc("sfc") .    /*SFCָ��,ͨ�ô�����ֶ���,Сд��ĸ  , for_and_before : all procedure */
end.


/*2.2 - ÿ����ʽ��ÿ�ε��ö���ֵ:*/
v_date      = today. 
v_msgtxt    = "" . 
{xslndefine.i}     /*v_line_prev��ֵ: ���ݳ�ʽ��,��(ǰһ��)ָ�����,���ָ����,���µ�½�Ż���Ч*/
{xstimeout01.i}    /*wtimeout��ֵ:    ��ʱ��δ�����Զ��˳�(Ŀǰ���˳�netterm,���ǳ�ʽ����) */

/*3.procedure����:(һ��Ҫ���ڱ�����ֵ�ĺ���) --------------------------------*/
{xsgetnbr.i}       /*ȡSFC��ص��ŵ�procedure: getnbr*/
