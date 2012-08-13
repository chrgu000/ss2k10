/*Cai last modified by 06/15/2004*/
 /*------------------------------------------------------------
  File         xkyhd1.p
  Description  手工选择生成要货单(看板零件), 子程序
  Author       Cai Jing
  Created      ?
  History
      2004-6-20, Yang Enping, 0004
         1. the file base the GUI version: xkyhd1.p
      2005-12-22 Hou 
         Copy for YFK
  -----------------------------------------------------------*/

 {mfdeclre.i}

DEFINE shared VARIABLE yn AS LOGICAL .

FORM 

	usrw_charfld[11]    label "空单"    format "x(8)"
    usrw_intfld[2]      LABEL "行"      FORMAT ">>>9"
	usrw_key2           label "看板号"  format "x(6)"
    usrw_charfld[1]     label "零件号"  FORMAT "x(16)"
    usrw_decfld[2]      label "数量"    format ">>>>9.99"
    usrw_charfld[12]    label "状态"    format "x(1)" 
	usrw_logfld[1]      Label "选择"    format "y/n" 

with centered overlay 20 DOWN frame f-errs width 80 .


clear frame f-errs all.

MainBlock:

    do on error undo,leave on endkey undo,leave:

        HIDE ALL NO-PAUSE .

        { xkut001.i
          &file         = "usrw_wkfl"
          &where        = "where (usrw_key1 = ~'emptykb~' + mfguser)"
          &INDEX        = "use-index usrw_index2"
          &frame        = "f-errs"
          &fieldlist    = "usrw_charfld[11]
                           usrw_intfld[2]
                           usrw_key2
                           usrw_charfld[1]
                           usrw_decfld[2]
                           usrw_charfld[12]
                           usrw_logfld[1]
                          "
          &prompt       = "usrw_charfld[11]"
          &pgupkey      = "ctrl-u"
          &pgdnkey      = "ctrl-d"
          &midchoose    = "color mesages"
          &prechoose    = "~{xkyhda.i~}"
          &updkey       = "M"
          &updcode      = "~{xkyhdb.i~}"

        }              

        hide all NO-PAUSE .
        
        for each usrw_wkfl where usrw_key1 = ("emptykb" + mfguser) 
            and usrw_logfld[1] use-index usrw_index2 NO-LOCK :
            
            display usrw_charfld[11] label "空订单"
                usrw_intfld[2] LABEL "行" 
                usrw_charfld[1] label "零件号" FORMAT "x(18)" 
	            usrw_key2 label "看板号" format "x(8)"
	            usrw_charfld[12] label "状态" format "x(1)"
                usrw_decfld[2] label "数量" with frame d DOWN .
        end.

        yn = YES .
        MESSAGE "确定要为这些空看板生成要货单吗？ " VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
        UPDATE yn .

        if yn = ? then undo mainblock, leave mainblock .
        IF NOT yn THEN UNDO mainblock, RETRY mainblock .

    end. /*MAIN BLOCK */       
    hide message no-pause.	
