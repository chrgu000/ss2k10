/* $Revision: eb21sp3     BY: Micho Yang     DATE: 03/09/07   ECO: *SS - Micho - 20070309*      */
/* SS - 20080827.1 By: Bill Jiang */
/* SS - 20081010.1 By: Bill Jiang */
/* SS - 090901.1 By: Bill Jiang */
/* SS - 091014.1 By: Bill Jiang */
/* SS - 091020.1 By: Bill Jiang */
/* SS - 100114.1  By: Roger Xiao */
/* SS - 100401.1  By: Roger Xiao */  /*附件张数取数改至xglt_add.xglt_attached*/

/* SS - 091020.1 - RNB
[091020.1]

更正了页码计算的BUG

[091020.1]

SS - 091020.1 - RNE */

/* SS - 091014.1 - RNB
[091014.1]

此前,对于"SO"类型的事务,不会输出客户

[091014.1]

SS - 091014.1 - RNE */

/* SS - 090901.1 - RNB
[090901.1]

解决了因为文档号错误而导致的打印错误

增加了排序选项:
  1 - 按文档号排序
  2(或其他) - 按参考号排序

增加了批处理和文档号的输出(打印在"摘要"栏,同时修改了BI模板文件)

取消了合计的绝对值计算
  
[090901.1]

SS - 090901.1 - RNE */


/* SS - 100114.1 - RNB
加栏位 输入人和输入日期
SS - 100114.1 - RNE */


/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "100401.1"}

/* SS - 090901.1 - B */
DEFINE VARIABLE LINE_gltr LIKE gltr_line.
DEFINE VARIABLE LINE2_gltr LIKE gltr_line.
/* SS - 090901.1 - E */

DEF VAR entity                  LIKE gltr_entity .
DEF VAR entity1                 LIKE gltr_entity .
DEF VAR v_ref                   LIKE glt_ref .
DEF VAR v_ref1                  LIKE glt_ref .
DEF VAR effdt                   LIKE glt_effdate .
DEF VAR effdt1                  LIKE glt_effdate .
DEF VAR v_enddt                 LIKE glt_effdate  .
DEF VAR v_enddt1                LIKE glt_effdate  .
DEF VAR v_acc                   LIKE glt_acc .
DEF VAR v_acc1                  LIKE glt_acc .
DEF VAR v_sub                   LIKE glt_sub .
DEF VAR v_sub1                  LIKE glt_sub .
DEF VAR v_cc                    LIKE glt_cc .
DEF VAR v_cc1                   LIKE glt_cc .
DEF VAR v_amt                   LIKE glt_amt FORMAT "->>,>>>,>>>,>>9.99".
DEF VAR v_amt1                  LIKE glt_amt FORMAT "->>,>>>,>>>,>>9.99".
DEF VAR v_domain_name           AS   CHAR .
DEF VAR v_tot_dr_amt            AS DECIMAL.
DEF VAR v_tot_cr_amt            AS DECIMAL.
DEF VAR v_curr                  LIKE ac_curr.
DEF VAR v_desc                  LIKE ac_desc .
DEF VAR v_desc111               LIKE ac_desc .
DEF VAR v_asc                   AS CHAR.
DEF VAR v_dr_amt                AS DECIMAL.
DEF VAR v_cr_amt                AS DECIMAL.
DEF VAR v_get_amt               AS CHAR.
DEF VAR v_line                  AS CHAR.
DEF VAR v_line1                 AS CHAR.
DEF VAR v_username              AS CHAR.
DEF VAR v_username1             AS CHAR.
DEF VAR v_post AS LOGICAL INIT YES .
/* SS - 090901.1 - B */
DEFINE VARIABLE ssvorp01_sort_by AS CHARACTER INITIAL "1".
/* SS - 090901.1 - E */

DEF BUFFER gltrhist FOR gltr_hist.
DEF BUFFER gltdet   FOR glt_det .

/* SS - 20081010.1 - B */
/*
DEFINE VARIABLE ref_glt LIKE glt_ref.
DEFINE VARIABLE ref_glt1 LIKE glt_ref.
*/
DEFINE VARIABLE user1_glt LIKE glt_user1
   /* SS - 20081010.1 - B */
   FORMAT "x(14)"
   /* SS - 20081010.1 - E */
   .
DEFINE VARIABLE user1_glt1 LIKE glt_user1
   /* SS - 20081010.1 - B */
   FORMAT "x(14)"
   /* SS - 20081010.1 - E */
   .
/* SS - 20081010.1 - E */


DEF TEMP-TABLE tt 
   FIELD tt_ref  LIKE gltr_ref 
   FIELD tt_line LIKE gltr_line
   FIELD tt_desc LIKE gltr_desc
/* SS - 100114.1 - B */
   field tt_ent_date like gltr_ent_dt
   field tt_user     like gltr_user
/* SS - 100114.1 - E */
   FIELD tt_asc  AS CHAR          /* 科目编号 */
   FIELD tt_asc_desc AS CHAR      /* 科目名称 */
   FIELD tt_asc_desc111 AS CHAR   /* 供应商客户名称 */
   FIELD tt_ex_rate AS DECIMA      /* 兑换率 */
   FIELD tt_curr AS CHAR          /* 币种 */
   FIELD tt_domain AS CHAR        /* 单位名称 */
   FIELD tt_effdate AS CHAR       /* 日期 */
   FIELD tt_dr_amt AS DECIMAL     /* 借方金额 */
   FIELD tt_cr_amt AS DECIMAL     /* 贷方金额 */
   FIELD tt_amt AS DECIMAL        /* 凭证的合计金额 */
   FIELD tt_curramt AS DECIMAL    /* 原币金额 */
   FIELD TT_flag_amt AS DECIMAL
   FIELD tt_page AS CHAR          /* 页码 */
   /* SS - 090901.1 - B */
   FIELD tt_user1 AS CHARACTER /* 文档号 */
   FIELD tt_sort AS CHARACTER /* 排序字段 */
   /* SS - 090901.1 - E */
   INDEX ref_line 
   /* SS - 090901.1 - B */
   tt_sort 
   /* SS - 090901.1 - E */
   tt_ref tt_line
   .                           
DEF BUFFER ttb FOR tt .
DEF BUFFER ttc FOR tt .

/* 得到页码 */
FUNCTION xxgetpage RETURNS CHARACTER ( INPUT j AS INTEGER ) .
if j < 4 then do:
   RETURN string(truncate(  j / 4 , 0 ) + 1) .
end.
else if ( j mod 4 ) = 0 then do:
          RETURN string(j / 4) .
     end.
     else do:
          RETURN string(truncate( j / 4,0) + 1) .
     end.
END FUNCTION .


/* 小写金额转换为大写金额 */
Function xxGetAmtCap returns character (input num1 as decimal).
        define variable strMoneyMod as character extent 10 initial ["零","壹","贰","叁","肆","伍","陆","柒","捌","玖"].
        define variable strMod as character extent 16 initial ["整","分","角","","元","拾","佰","仟","万","拾","佰","仟","亿","拾","佰","仟"].
        define variable numChar as character.                /* 原小写金额*/
        define variable strMoney as character.                /* 产生的大写金额*/
        define variable item as character.                /* 截取的单个数字*/
        define variable i as integer initial 1.                /* 循环指标        */
        define variable n as integer.                /* 万位为零时需向前判断的起始位        */
        DEFINE variable m as integer.                /* 万位为零时需向前判断的位数        */

        numChar = Trim (String (num1,">>>>>>>>>>>>.99")).        
        if Length (numChar) > 15 or num1 * 100 = 0 then return ("").
        else do:
                repeat while i <= Length (numChar):        /* 小数位为 0 时，如果个位也为 0，加 "元整"，否则加 "元" */
                        if i = 1 and Integer (Substring (numChar, Index (numChar, ".") + 1)) = 0 then do:
                                if Substring (numChar, Index (numChar, ".") - 1, 1) = "0" then
                                        strMoney = "元整".
                                else
                                        strMoney = "整".
                                i = 3.
                        end.                        
                        if i <> 3 then do:

                                /* message "1. item:" + item + "---" + "i:" + string(i) view-as alert-box. */

                                if not (Substring (numChar, Length (numChar) - i + 1, 1) = "0" and item = "0") or i = 8 or i = 12 then do:
                                        item = Substring (numChar, Length (numChar) - i + 1, 1).
                                        /* message "2. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                        if item = "0" and i <> 1 then do:        /* 当截取的单位数字为 0 时的处理，分位为 0 时除外 */
                                                /* message "3. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                                case i:
                                                        when 8 then do: /* 万位数为 0 时，需判断其左三位是否为 0，如不是则直接加 "万" 字  */
                                                                case Length (numChar) - (i + 2):        /* 如万位左边不足三位，则有几位取几位，再判断是否为 0 */
                                                                        when -1 then do:
                                                                                n = 1.
                                                                                m = 1.
                                                                        end.
                                                                        when 0 then do:
                                                                                n = 1.
                                                                                m = 2.
                                                                        end.
                                                                        otherwise do:
                                                                                n = Length (numChar) - (i + 2).
                                                                                m = 3.
                                                                        end.
                                                                end case.
                                                                if Integer (Substring (numChar, n, m)) > 0 then 
                                                                        strMoney = "万" + strMoney.
                                                        end.
                                                        when 12 then strMoney = "亿" + strMoney.        /* 亿位数为 0 时直接加 "亿" 字 */
                                                        when 4 then                        /* 个位数为 0 时，如果不是整数则加一个 "元" 字 */

                                                                /******************** SS - 20060914.1 - B ********************/
                                                                  /*
                                                                if Index (strMoney, "整") = 0 then 
                                                                        strMoney = strMoneyMod [Integer(item) + 1] + "元".
                                                                    */    
                                                                
                                                                if Index (strMoney, "整") = 0 then DO:
                                                                   IF INTEGER(ITEM) = 0 THEN strMoney = "元" + strMoney .
                                                                   ELSE strMoney = strMoneyMod [Integer(item) + 1] + "元" + strMoney.
                                                                END.
                                                                /******************** SS - 20060914.1 - B ********************/
                                                        otherwise        /* 其它位为 0 时，如果它的右边一位不是零，则加一个 "零" 字 */
                                                                if Substring (numChar, Length (numChar) - i + 2, 1) <> "0" then 
                                                                        strMoney = "零" + strMoney.
                                                end case.
                                                /* message "1. " + strMoney view-as alert-box. */
                                        end.
                                        else do:        /* 不为零的位直接取数字大写及单位大写 */
                                                /* message "4. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                                strMoney = strMod[i + 1] + strMoney.
                                                strMoney = strMoneyMod [Integer(item) + 1] + strMoney.
                                                /* message "2. " + strMoney view-as alert-box. */
                                        end.
                                        
                                end.
                        end.
                        i = i + 1.
                end.
                return (strMoney).
        end.
End Function.

/* SELECT FORM */
form
   entity   colon 25    entity1 colon 50 label {t001.i}
   v_ref    colon 25 LABEL "凭证号"   
   v_ref1   colon 50 label {t001.i}
   effdt    colon 25    effdt1  colon 50 label {t001.i}
   v_enddt  colon 25 LABEL "输入日期"   
   v_enddt1 colon 50 label {t001.i}
   v_acc    colon 25 LABEL "帐户"   
   v_acc1   COLON 50 LABEL {t001.i}
   v_sub    colon 25 LABEL "分帐户"   
   v_sub1   COLON 50 LABEL {t001.i}
   v_cc     colon 25 LABEL "成本中心"   
   v_cc1    COLON 50 LABEL {t001.i}
   v_amt    colon 25 LABEL "金额范围"   
   v_amt1   COLON 50 LABEL {t001.i}
   /* SS - 20081010.1 - B */
   /*
   ref_glt        colon 25 ref_glt1    colon 50 label {t001.i}
   */
   user1_glt        colon 25 user1_glt1    colon 50 label {t001.i}
   /* SS - 20081010.1 - E */
   v_post   COLON 25 LABEL "是否已过帐"
   /* SS - 090901.1 - B */
   ssvorp01_sort_by COLON 25
   /* SS - 090901.1 - E */
   SKIP(1)
with frame a side-labels attr-space width 80 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}

REPEAT:
	
   /* SS - 091020.1 - B */
   HIDE ALL NO-PAUSE.
   VIEW FRAME dtitle.
   /* SS - 091020.1 - E */

    IF entity1 = hi_char  THEN entity1 = "" .
    IF v_ref1  = hi_char  THEN v_ref1  = "" .
    IF effdt   = low_date THEN effdt   = ? .
    IF effdt1  = hi_date  THEN effdt1  = ? .
    IF v_enddt   = low_date THEN v_enddt   = ? .
    IF v_enddt1  = hi_date  THEN v_enddt1  = ? .
    IF v_acc1  = hi_char  THEN v_acc1  = "" .
    IF v_sub1  = hi_char  THEN v_sub1  = "" .
    IF v_cc1   = hi_char  THEN v_cc1   = "" .
   /* SS - 20081010.1 - B */
   /*
   if ref_glt1 = hi_char then ref_glt1 = "".
   */
   if user1_glt1 = hi_char then user1_glt1 = "".
   /* SS - 20081010.1 - E */

    if c-application-mode <> 'web' then
      update
         entity entity1
         v_ref  v_ref1
         effdt  effdt1
         v_enddt  v_enddt1
         v_acc  v_acc1
         v_sub  v_sub1
         v_cc   v_cc1
         v_amt  v_amt1
       /* SS - 20081010.1 - B */
        /*
       ref_glt
       ref_glt1
       */
       user1_glt
       user1_glt1
       /* SS - 20081010.1 - E */
         v_post
       /* SS - 090901.1 - B */
       ssvorp01_sort_by
       /* SS - 090901.1 - E */
      with frame a.

    {wbrp06.i &command = update &fields = " entity entity1 v_ref v_ref1
         effdt effdt1 v_enddt v_enddt1 v_acc v_acc1 v_sub v_sub1 
         v_cc  v_cc1  v_amt v_amt1 v_post 
       /* SS - 090901.1 - B */
       ssvorp01_sort_by
       /* SS - 090901.1 - E */
      /* SS - 20080827.1 - B */
       /*
      ref_glt
      ref_glt1
      */
      user1_glt
      user1_glt1
      /* SS - 20080827.1 - E */
       " &frm = "a"}

    {&GLUTRRP-P-TAG19}
    if (c-application-mode <> 'web') or
       (c-application-mode = 'web' and
       (c-web-request begins 'data'))
    then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {&GLUTRRP-P-TAG20}
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
      {mfquoter.i v_ref   }
      {mfquoter.i v_ref1  }
      {mfquoter.i effdt   }
      {mfquoter.i effdt1  }
      {mfquoter.i v_enddt   }
      {mfquoter.i v_enddt1  }
      {mfquoter.i v_acc   }
      {mfquoter.i v_acc1  }
      {mfquoter.i v_sub   }
      {mfquoter.i v_sub1  }
      {mfquoter.i v_cc    }
      {mfquoter.i v_cc1   }
      {mfquoter.i v_amt   }
      {mfquoter.i v_amt1  }
      {mfquoter.i v_post  }
      /* SS - 090901.1 - B */
      {mfquoter.i ssvorp01_sort_by  }
      /* SS - 090901.1 - E */
       /* SS - 20080827.1 - B */
         /*
       {mfquoter.i ref_glt       }
       {mfquoter.i ref_glt1      }
       */
       {mfquoter.i user1_glt       }
       {mfquoter.i user1_glt1      }
       /* SS - 20080827.1 - E */

      if entity1 = "" then entity1 = hi_char.
      if v_ref1  = "" then v_ref1  = hi_char.
      if effdt   = ?  then effdt   = low_date.
      if effdt1  = ?  then effdt1  = hi_date.      
      if v_enddt   = ?  then v_enddt   = low_date.
      if v_enddt1  = ?  then v_enddt1  = hi_date.
      IF v_acc1  = "" THEN v_acc1  = hi_char.
      IF v_sub1  = "" THEN v_sub1  = hi_char.
      IF v_cc1   = "" THEN v_cc1   = hi_char.
        /* SS - 20080827.1 - B */
      /*
        if ref_glt1 = "" then ref_glt1 = hi_char.
        */
        if user1_glt1 = "" then user1_glt1 = hi_char.
        /* SS - 20080827.1 - E */

    end.

    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
               
    {xxmfphead1.i}  

    /* 初始化清空 */
    FOR EACH tt :
        DELETE tt .
    END.

    IF v_post = YES THEN DO:
            v_tot_dr_amt = 0 .
            v_tot_cr_amt = 0 .
            v_curr       = "" .
            v_desc       = "" .
            v_asc        = "" .
            v_desc111    = "" .
        
            /* SS - 091020.1 - B */
            line2_gltr = 0.
            /* SS - 091020.1 - E */
            FOR EACH gltr_hist NO-LOCK WHERE gltr_domain  = GLOBAL_domain
                                         AND gltr_entity >= entity
                                         AND gltr_entity <= entity1
                                         AND gltr_ref    >= v_ref
                                         AND gltr_ref    <= v_ref1
                                         AND gltr_eff_dt >= effdt
                                         AND gltr_eff_dt <= effdt1
                                         AND gltr_ent_dt >= v_enddt
                                         AND gltr_ent_dt <= v_enddt1
                                         AND gltr_acc    >= v_acc
                                         AND gltr_acc    <= v_acc1
                                         AND gltr_sub    >= v_sub
                                         AND gltr_sub    <= v_sub1
                                         AND gltr_ctr    >= v_cc
                                         AND gltr_ctr    <= v_cc1 
       /* SS - 20080827.1 - B */
               /*
       AND gltr_ref >= ref_glt
       AND gltr_ref <= ref_glt1
       */
       AND gltr_user1 >= user1_glt
       AND gltr_user1 <= user1_glt1
       /* SS - 20080827.1 - E */
                                         BREAK BY gltr_ref :
               /* SS - 091020.1 - B */
               IF FIRST-OF(gltr_ref) THEN DO:
                  line2_gltr = 0.
               END.
               line2_gltr = line2_gltr + 1.
               /* SS - 091020.1 - E */

                /* SS - 091020.1 - B
                FIND LAST gltrhist WHERE gltrhist.gltr_domain = global_domain 
                                      AND gltrhist.gltr_ref = gltr_hist.gltr_ref NO-LOCK NO-ERROR.
                IF AVAIL gltrhist THEN v_line = xxgetpage(gltrhist.gltr_line) .
                SS - 091020.1 - E */
                /* SS - 091020.1 - B */
                LINE_gltr = 0.
                FOR EACH gltrhist NO-LOCK
                   WHERE gltrhist.gltr_domain = global_domain 
                   AND gltrhist.gltr_ref = gltr_hist.gltr_ref 
                   :
                   LINE_gltr = LINE_gltr + 1.
                END.
                IF LINE_gltr <> 0 THEN DO:
                   v_line = xxgetpage(line_gltr).
                END.
                /* SS - 091020.1 - E */
        
                FIND FIRST ac_mstr WHERE ac_domain = GLOBAL_domain 
                                     AND ac_code = gltr_hist.gltr_acc NO-LOCK NO-ERROR.
                IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
                    v_curr = ac_curr .
                    v_desc = ac_desc .
                    v_asc  = gltr_hist.gltr_acc .
                END.
                FIND FIRST sb_mstr WHERE sb_domain = global_domain 
                                     AND sb_sub = gltr_hist.gltr_sub NO-LOCK NO-ERROR.
                IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                    v_desc = v_desc + "-" + sb_desc .
                    v_asc  = v_asc + "-" + gltr_hist.gltr_sub .
                END.
                ELSE DO:
                    v_desc = v_desc .
                    v_asc  = v_asc .
                END.
                FIND FIRST cc_mstr WHERE cc_domain = global_domain 
                                     AND cc_ctr = gltr_hist.gltr_ctr NO-LOCK NO-ERROR.
                IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
                    v_desc = v_desc + "-" + cc_desc .
                    v_asc  = v_asc + "-" + cc_ctr .
                END.
                ELSE DO:
                    v_desc = v_desc .
                    v_asc = v_asc .
                END.
                FIND FIRST pj_mstr WHERE pj_domain = global_domain 
                                     AND pj_project = gltr_hist.gltr_project NO-LOCK NO-ERROR.
                IF AVAIL pj_mstr AND pj_project <> "" THEN DO:
                    v_desc = v_desc + "-" + pj_desc .
                    v_asc = v_asc + "-" + pj_project .
                END.
                ELSE DO:
                    v_desc = v_desc .
                    v_asc = v_asc .
                END.
        
                IF gltr_hist.gltr_tr_type = 'AP' 
                   OR gltr_hist.gltr_tr_type = "AR" 
                   /* SS - 091014.1 - B */
                   OR gltr_hist.gltr_tr_type = "SO" 
                   /* SS - 091014.1 - E */
                   THEN DO:
                   FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain 
                                        AND ad_addr = gltr_hist.gltr_addr NO-LOCK NO-ERROR.
                   IF AVAIL ad_mstr THEN DO:
                       v_desc111 = ad_addr + " - " + ad_name .
                   END.
                   ELSE v_desc111 = gltr_hist.gltr_addr .
                END.
        
                v_dr_amt = 0.
                v_cr_amt = 0.
                if (gltr_hist.gltr_amt >= 0 AND gltr_hist.gltr_correction = false) or
                   (gltr_hist.gltr_amt <  0 AND gltr_hist.gltr_correction = true)
                then
                     assign v_dr_amt = gltr_hist.gltr_amt
                            v_cr_amt = 0.
                else
                     assign v_cr_amt = - gltr_hist.gltr_amt
                            v_dr_amt = 0.        
        
                     /* SS - 091020.1 - B
                v_line1 = xxgetpage(gltr_hist.gltr_line) .
                     SS - 091020.1 - E */
                     /* SS - 091020.1 - B */
                     v_line1 = xxgetpage(line2_gltr).
                     /* SS - 091020.1 - E */
        
                CREATE tt .
                ASSIGN

                   /* SS - 20080827.1 - B */
                   /*
                    tt_ref = gltr_hist.gltr_ref
                    */
                   tt_ref = gltr_hist.gltr_ref + " - " + gltr_hist.gltr_user1
                   /* SS - 20080827.1 - E */
                   /* SS - 090901.1 - B */
                   tt_user1 = gltr_hist.gltr_user1
                   /* SS - 090901.1 - E */
                   /* SS - 091020.1 - B
                    tt_line = gltr_hist.gltr_line
                   SS - 091020.1 - E */
                   /* SS - 091020.1 - B */
                    tt_line = line2_gltr
                   /* SS - 091020.1 - E */
                    tt_effdate = STRING(YEAR(gltr_hist.gltr_eff_dt)) + "." +  STRING(MONTH(gltr_hist.gltr_eff_dt)) + "." +  string(DAY(gltr_hist.gltr_eff_dt))
                    tt_desc = gltr_hist.gltr_desc 
                    tt_asc  = v_asc 
                    tt_asc_desc = v_desc 
                    tt_asc_desc111 = v_desc111
                    tt_dr_amt = v_dr_amt
                    tt_cr_amt = v_cr_amt
                    tt_flag_amt = gltr_hist.gltr_amt 
                    tt_page  = v_line1 + "/" + v_line
                   /* SS - 090901.1 - B */
                   tt_domain = gltr_hist.gltr_batch + " - " + gltr_hist.gltr_doc
                   /* SS - 090901.1 - E */
                    /* SS - 100114.1 - B */
                    tt_ent_date = STRING(YEAR(gltr_hist.gltr_ent_dt)) + "." +  STRING(MONTH(gltr_hist.gltr_ent_dt)) + "." +  string(DAY(gltr_hist.gltr_ent_dt))
                    tt_user     = gltr_hist.gltr_user
                    /* SS - 100114.1 - E */
                    .
       
                IF UPPER(v_curr) <> "CNY" THEN DO:
                   tt_curr = v_curr .
                   tt_curramt = ABS(gltr_hist.gltr_curramt) .
                   tt_ex_rate = round(gltr_hist.gltr_ex_rate2 / gltr_hist.gltr_ex_rate,4) .
                END.
                ELSE DO:
                    tt_curr = "CNY" .
                    IF v_cr_amt = 0 THEN tt_curramt = ABS(v_dr_amt) .
                                    ELSE tt_curramt = ABS(v_cr_amt) .
                    tt_ex_rate = 1 .
                END.
        
                v_tot_dr_amt = v_tot_dr_amt + v_dr_amt .
                v_tot_cr_amt = v_tot_cr_amt + v_cr_amt .
                IF LAST-OF(gltr_hist.gltr_ref) THEN DO:
                    v_get_amt = xxgetamtcap(ABS(v_tot_dr_amt)) .
                    FIND FIRST usr_mstr WHERE usr_userid = gltr_hist.gltr_user NO-LOCK NO-ERROR.
                    IF AVAIL usr_mstr THEN DO:
                        v_username1 = "会计主管:                         记帐: " + usr_name + "              复核:                         制单:                              " .
                    END.
        
                    /*
                    FIND FIRST usr_mstr WHERE usr_userid = GLOBAL_userid NO-LOCK NO-ERROR.
                    IF AVAIL usr_mstr THEN DO:
                        v_username = "由 " + usr_name + " 打印 " + 
                                     "(日期: " + string(year(today)) + "." + 
                                     string(month(today)) + "." + 
                                     string(day(today)) + ", " + "时间: " +
                                     STRING(TIME,"HH:MM:SS") + ")" .
                    END.
                    */

/* SS - 100401.1 - B 
                    v_username = gltr_hist.gltr_user2 .
   SS - 100401.1 - E */
/* SS - 100401.1 - B */
find first xglt_add where xglt_domain = global_domain and xglt_ref = gltr_hist.gltr_ref no-lock no-error .
v_username = if avail xglt_add then string(xglt_attached) else  "" .
/* SS - 100401.1 - E */

        
                    FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain 
                                         AND ad_addr = GLOBAL_domain NO-LOCK NO-ERROR .
                    IF AVAIL ad_mstr THEN DO:
                         v_domain_name = ad_name .
                    END.
                    ELSE v_domain_name = ad_addr .
        
                    CREATE tt .
                    ASSIGN
                       /* SS - 20080827.1 - B */
                       /*
                        tt_ref      = gltr_hist.gltr_ref 
                        */
                       tt_ref      = gltr_hist.gltr_ref + " - " + gltr_hist.gltr_user1
                       /* SS - 20080827.1 - E */
                       /* SS - 090901.1 - B */
                       tt_user1 = gltr_hist.gltr_user1
                       /* SS - 090901.1 - E */
                        tt_desc     = v_get_amt
                        tt_asc      = v_username1
                        tt_asc_desc = v_username 
                       /* SS - 090901.1 - B
                        tt_amt      = ABS(v_tot_dr_amt)
                       SS - 090901.1 - E */
                       /* SS - 090901.1 - B */
                        tt_amt      = v_tot_dr_amt
                       /* SS - 090901.1 - E */
                        tt_effdate  = STRING(YEAR(gltr_hist.gltr_eff_dt)) + "." +  STRING(MONTH(gltr_hist.gltr_eff_dt)) + "." +  string(DAY(gltr_hist.gltr_eff_dt))
                        tt_domain   = v_domain_name
                        /* SS - 100114.1 - B */
                        tt_ent_date = STRING(YEAR(gltr_hist.gltr_ent_dt)) + "." +  STRING(MONTH(gltr_hist.gltr_ent_dt)) + "." +  string(DAY(gltr_hist.gltr_ent_dt))
                        tt_user     = gltr_hist.gltr_user
                        /* SS - 100114.1 - E */

                        .

                    v_tot_dr_amt = 0.
                    v_tot_cr_amt = 0.
                END.
        
                v_curr = "" .
                v_desc = "" .
                v_asc = "" .
                v_desc111 = "" .
            END. /* for each gltr_hist */
    END.
    ELSE DO:
            v_tot_dr_amt = 0 .
            v_tot_cr_amt = 0 .
            v_curr       = "" .
            v_desc       = "" .
            v_asc        = "" .
            v_desc111    = "" .
        
            /* SS - 091020.1 - B */
            line2_gltr = 0.
            /* SS - 091020.1 - E */
            FOR EACH glt_det NO-LOCK WHERE glt_domain  = GLOBAL_domain
                                         AND glt_entity >= entity
                                         AND glt_entity <= entity1
                                         AND glt_ref    >= v_ref
                                         AND glt_ref    <= v_ref1
                                         AND glt_effdate >= effdt
                                         AND glt_effdate <= effdt1
                                         AND glt_date >= v_enddt
                                         AND glt_date <= v_enddt1
                                         AND glt_acc    >= v_acc
                                         AND glt_acc    <= v_acc1
                                         AND glt_sub    >= v_sub
                                         AND glt_sub    <= v_sub1
                                         AND glt_cc    >= v_cc
                                         AND glt_cc    <= v_cc1 
       /* SS - 20080827.1 - B */
               /*
       AND glt_ref >= ref_glt
       AND glt_ref <= ref_glt1
       */
       AND glt_user1 >= user1_glt
       AND glt_user1 <= user1_glt1
       /* SS - 20080827.1 - E */
                                         BREAK BY glt_ref :
               /* SS - 091020.1 - B */
               IF FIRST-OF(glt_ref) THEN DO:
                  line2_gltr = 0.
               END.
               line2_gltr = line2_gltr + 1.
               /* SS - 091020.1 - E */
                /* SS - 091020.1 - B
                FIND LAST gltdet WHERE gltdet.glt_domain = global_domain 
                                      AND gltdet.glt_ref = glt_det.glt_ref NO-LOCK NO-ERROR.
                IF AVAIL gltdet THEN v_line = xxgetpage(gltdet.glt_line) .
                SS - 091020.1 - E */
                /* SS - 091020.1 - B */
                LINE_gltr = 0.
                FOR EACH gltdet NO-LOCK
                   WHERE gltdet.glt_domain = global_domain 
                   AND gltdet.glt_ref = glt_det.glt_ref 
                   :
                   LINE_gltr = LINE_gltr + 1.
                END.
                IF LINE_gltr <> 0 THEN DO:
                   v_line = xxgetpage(line_gltr).
                END.
                /* SS - 091020.1 - E */
        
                FIND FIRST ac_mstr WHERE ac_domain = GLOBAL_domain 
                                     AND ac_code = glt_det.glt_acc NO-LOCK NO-ERROR.
                IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
                    v_curr = ac_curr .
                    v_desc = ac_desc .
                    v_asc  = glt_det.glt_acc .
                END.
                FIND FIRST sb_mstr WHERE sb_domain = global_domain 
                                     AND sb_sub = glt_det.glt_sub NO-LOCK NO-ERROR.
                IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                    v_desc = v_desc + "-" + sb_desc .
                    v_asc  = v_asc + "-" + glt_det.glt_sub .
                END.
                ELSE DO:
                    v_desc = v_desc .
                    v_asc  = v_asc .
                END.
                FIND FIRST cc_mstr WHERE cc_domain = global_domain 
                                     AND cc_ctr = glt_det.glt_cc NO-LOCK NO-ERROR.
                IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
                    v_desc = v_desc + "-" + cc_desc .
                    v_asc  = v_asc + "-" + cc_ctr .
                END.
                ELSE DO:
                    v_desc = v_desc .
                    v_asc = v_asc .
                END.
                FIND FIRST pj_mstr WHERE pj_domain = global_domain 
                                     AND pj_project = glt_det.glt_project NO-LOCK NO-ERROR.
                IF AVAIL pj_mstr AND pj_project <> "" THEN DO:
                    v_desc = v_desc + "-" + pj_desc .
                    v_asc = v_asc + "-" + pj_project .
                END.
                ELSE DO:
                    v_desc = v_desc .
                    v_asc = v_asc .
                END.
        
                IF glt_det.glt_tr_type = 'AP' 
                   OR glt_det.glt_tr_type = "AR" 
                   /* SS - 091014.1 - B */
                   OR glt_det.glt_tr_type = "SO" 
                   /* SS - 091014.1 - E */
                   THEN DO:
                   FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain 
                                        AND ad_addr = glt_det.glt_addr NO-LOCK NO-ERROR.
                   IF AVAIL ad_mstr THEN DO:
                       v_desc111 = ad_addr + " - " + ad_name .
                   END.
                   ELSE v_desc111 = glt_det.glt_addr .
                END.
        
                v_dr_amt = 0.
                v_cr_amt = 0.
                if (glt_det.glt_amt >= 0 AND glt_det.glt_correction = false) or
                   (glt_det.glt_amt <  0 AND glt_det.glt_correction = true)
                then
                     assign v_dr_amt = glt_det.glt_amt
                            v_cr_amt = 0.
                else
                     assign v_cr_amt = - glt_det.glt_amt
                            v_dr_amt = 0.        
        
                     /* SS - 091020.1 - B
                v_line1 = xxgetpage(glt_det.glt_line) .
                SS - 091020.1 - E */
                     /* SS - 091020.1 - B */
                     v_line1 = xxgetpage(line2_gltr) .
                     /* SS - 091020.1 - E */
        
                CREATE tt .
                ASSIGN
                   /* SS - 20080827.1 - B */
                   /*
                    tt_ref = glt_det.glt_ref
                    */
                   tt_ref = glt_det.glt_ref + " - " + glt_det.glt_user1
                   /* SS - 20080827.1 - E */
                   /* SS - 090901.1 - B */
                   tt_user1 = glt_det.glt_user1
                   /* SS - 090901.1 - E */
                   /* SS - 091020.1 - B
                    tt_line = glt_det.glt_line
                   SS - 091020.1 - E */
                   /* SS - 091020.1 - B */
                    tt_line = line2_gltr
                   /* SS - 091020.1 - E */
                    tt_effdate = STRING(YEAR(glt_det.glt_effdate)) + "." +  STRING(MONTH(glt_det.glt_effdate)) + "." +  string(DAY(glt_det.glt_effdate))
                    tt_desc = glt_det.glt_desc 
                    tt_asc  = v_asc 
                    tt_asc_desc = v_desc 
                    tt_asc_desc111 = v_desc111
                    tt_dr_amt = v_dr_amt
                    tt_cr_amt = v_cr_amt
                    tt_flag_amt = glt_det.glt_amt 
                    tt_page  = v_line1 + "/" + v_line
                   /* SS - 090901.1 - B */
                   tt_domain = glt_det.glt_batch + " - " + glt_det.glt_doc
                   /* SS - 090901.1 - E */
                    /* SS - 100114.1 - B */
                    tt_ent_date = STRING(YEAR(glt_det.glt_date)) + "." +  STRING(MONTH(glt_det.glt_date)) + "." +  string(DAY(glt_det.glt_date))
                    tt_user     = glt_det.glt_userid
                    /* SS - 100114.1 - E */
                    .
        
                IF UPPER(v_curr) <> "CNY" THEN DO:
                   tt_curr = v_curr .
                   tt_curramt = ABS(glt_det.glt_curr_amt) .
                   tt_ex_rate = round(glt_det.glt_ex_rate2 / glt_det.glt_ex_rate,4) .
                END.
                ELSE DO:
                    tt_curr = "CNY" .
                    IF v_cr_amt = 0 THEN tt_curramt = ABS(v_dr_amt) .
                                    ELSE tt_curramt = ABS(v_cr_amt) .
                    tt_ex_rate = 1 .
                END.
        
                v_tot_dr_amt = v_tot_dr_amt + v_dr_amt .
                v_tot_cr_amt = v_tot_cr_amt + v_cr_amt .
                IF LAST-OF(glt_det.glt_ref) THEN DO:
                    v_get_amt = xxgetamtcap(ABS(v_tot_dr_amt)) .
                    FIND FIRST usr_mstr WHERE usr_userid = glt_det.glt_userid NO-LOCK NO-ERROR.
                    IF AVAIL usr_mstr THEN DO:
                        v_username1 = "会计主管:                         记帐: " + usr_name + "              复核:                         制单:                              " .
                    END.
        
                    /*
                    FIND FIRST usr_mstr WHERE usr_userid = GLOBAL_userid NO-LOCK NO-ERROR.
                    IF AVAIL usr_mstr THEN DO:
                        v_username = "由 " + usr_name + " 打印 " + 
                                     "(日期: " + string(year(today)) + "." + 
                                     string(month(today)) + "." + 
                                     string(day(today)) + ", " + "时间: " +
                                     STRING(TIME,"HH:MM:SS") + ")" .
                    END.
                      */

/* SS - 100401.1 - B 
                    v_username = glt_det.glt_user2 .
   SS - 100401.1 - E */
/* SS - 100401.1 - B */
find first xglt_add where xglt_domain = global_domain and xglt_ref = glt_det.glt_ref no-lock no-error .
v_username = if avail xglt_add then string(xglt_attached) else  "" .
/* SS - 100401.1 - E */  

                    FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain 
                                         AND ad_addr = GLOBAL_domain NO-LOCK NO-ERROR .
                    IF AVAIL ad_mstr THEN DO:
                         v_domain_name = ad_name .
                    END.
                    ELSE v_domain_name = ad_addr .
        
                    CREATE tt .
                    ASSIGN
                       /* SS - 20080827.1 - B */
                       /*
                        tt_ref      = glt_det.glt_ref 
                        */
                       tt_ref      = glt_det.glt_ref  + " - " + glt_det.glt_user1
                       /* SS - 20080827.1 - E */
                       /* SS - 090901.1 - B */
                       tt_user1 = glt_det.glt_user1
                       /* SS - 090901.1 - E */
                        tt_desc     = v_get_amt
                        tt_asc      = v_username1
                        tt_asc_desc = v_username 
                       /* SS - 090901.1 - B
                        tt_amt      = ABS(v_tot_dr_amt)
                       SS - 090901.1 - E */
                       /* SS - 090901.1 - B */
                        tt_amt      = v_tot_dr_amt
                       /* SS - 090901.1 - E */
                        tt_effdate  = STRING(YEAR(glt_det.glt_effdate)) + "." +  STRING(MONTH(glt_det.glt_effdate)) + "." +  string(DAY(glt_det.glt_effdate))
                        tt_domain   = v_domain_name
                        /* SS - 100114.1 - B */
                        tt_ent_date = STRING(YEAR(glt_det.glt_date)) + "." +  STRING(MONTH(glt_det.glt_date)) + "." +  string(DAY(glt_det.glt_date))
                        tt_user     = glt_det.glt_userid
                        /* SS - 100114.1 - E */
                        .
                    v_tot_dr_amt = 0.
                    v_tot_cr_amt = 0.
                END.
        
                v_curr = "" .
                v_desc = "" .
                v_asc = "" .
                v_desc111 = "" .
            END. /* for each gltr_hist */
    END.


    /*
    PUT UNFORMATTED "凭证编号" ";" "项次" ";" "摘要" ";" "科目编号" ";"
                    "科目名称" ";" "兑换率" ";" "币种" ";" "单位名称" ";" 
                    "日期" ";" "借方金额" ";" "贷方金额" ";" "凭证合计金额" ";" 
                    "原币" ";" "页码" ";" "供应商客户名称"  SKIP.
                    */
    
    PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxvorp013" SKIP.
	PUT UNFORMATTED "#def :end" SKIP.

   /* SS - 090901.1 - B */
   IF ssvorp01_sort_by = "1" THEN DO:
      FOR EACH tt:
         ASSIGN tt_sort = tt_user1.
      END.
   END.
   ELSE IF ssvorp01_sort_by = "2" THEN DO:
      FOR EACH tt:
         ASSIGN tt_sort = tt_ref.
      END.
   END.
   ELSE DO:
      FOR EACH tt:
         ASSIGN tt_sort = tt_ref.
      END.
   END.
   /* SS - 090901.1 - E */

   IF v_amt <> 0 OR v_amt1 <> 0 THEN DO:
      FOR EACH ttb 
         BREAK 
         /* SS - 090901.1 - B
         BY ttb.tt_ref 
         SS - 090901.1 - E */
         /* SS - 090901.1 - B */
         BY ttb.tt_sort
         BY SUBSTRING(ttb.tt_ref,1,14)
         BY ttb.tt_line
         /* SS - 090901.1 - B */
         :
         /* SS - 090901.1 - B
         IF FIRST-OF(ttb.tt_ref) THEN DO:
         SS - 090901.1 - E */
         /* SS - 090901.1 - B */
         IF FIRST-OF(SUBSTRING(ttb.tt_ref,1,14)) THEN DO:
            /* SS - 090901.1 - E */
            FIND FIRST ttc WHERE ttc.tt_ref = ttb.tt_ref 
               AND (ttc.tt_flag_amt >= v_amt OR v_amt = 0)
               AND (ttc.tt_flag_amt <= v_amt1 OR v_amt1 = 0) NO-LOCK NO-ERROR.
            IF AVAIL ttc THEN DO:
               FOR EACH tt WHERE 
                  /* SS - 090901.1 - B
                  tt.tt_ref = ttb.tt_ref  
                  SS - 090901.1 - E */
                  /* SS - 090901.1 - B */
                  SUBSTRING(tt.tt_ref,1,14) = SUBSTRING(ttb.tt_ref,1,14)
                  BY tt.tt_line
                  /* SS - 090901.1 - E */
                  :
                  PUT UNFORMATTED 
                     tt.tt_ref ";"      tt.tt_line ";"    tt.tt_desc ";"    tt.tt_asc ";" 
                     tt.tt_asc_desc ";" tt.tt_ex_rate ";" tt.tt_curr ";" 
                     tt.tt_domain ";"   tt.tt_effdate ";" tt.tt_dr_amt ";" 
                     tt.tt_cr_amt ";"   tt.tt_amt ";"     tt.tt_curramt ";"
                     tt.tt_page ";"     tt.tt_asc_desc111 
/* SS - 100114.1 - B */
";" 
tt_ent_date ";"
tt_user
/* SS - 100114.1 - E */
                     SKIP.
               END. /* FOR EACH tt WHERE */
            END. /* IF AVAIL ttc THEN DO: */
         END. /* IF FIRST-OF(SUBSTRING(ttb.tt_ref,1,14)) THEN DO: */
      END. /* FOR EACH ttb  */
   END. /* IF v_amt <> 0 OR v_amt1 <> 0 THEN DO: */
   ELSE DO:
      FOR EACH tt 
         /* SS - 090901.1 - B */
         BY tt_sort
         BY SUBSTRING(tt_ref,1,14)
         BY tt_line
         /* SS - 090901.1 - E */
         :
         PUT UNFORMATTED 
            tt_ref 
            ";" tt_line 
            ";" tt_desc 
            ";" tt_asc 
            ";" tt_asc_desc 
            ";" tt_ex_rate 
            ";" tt_curr 
            ";" tt_domain 
            ";" tt_effdate 
            ";" tt_dr_amt 
            ";" tt_cr_amt 
            ";" tt_amt 
            ";" tt_curramt 
            ";" tt_page 
            ";" tt_asc_desc111 
/* SS - 100114.1 - B */
";" 
tt_ent_date ";"
tt_user
/* SS - 100114.1 - E */
            SKIP.
      END. /* FOR EACH tt  */
   END. /* ELSE DO: */
   
   /* REPORT TRAILER  */
   {a6mfrtrail.i}

END. /* repeat */

{wbrp04.i &frame-spec = a}
