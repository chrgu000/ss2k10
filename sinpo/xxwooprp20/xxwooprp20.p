/* Copyright 2010 SoftSpeed gz                                               */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 100324.1 By: Kaine Zhang */
/* SS - 100602.1 By: Kaine Zhang */
/* SS - 100605.1 By: Kaine Zhang */
/* SS - 100624.1 By: Kaine Zhang */
/* SS - 100715.1 By: Kaine Zhang */
/* SS - 110221.1 By: Kaine Zhang */

/* SS - 100602.1 - RNB
[110221.1]
���ͻ������������ַ��Ͽͻ�Ҫ��,����δ�޸Ĵ���.
1. ��ϸ��ʾ: ��������ʾ���ܹ�ʱ,�ǰ�op_hist���op__qad02ʵ��ȡ��ֵ�õ���.
2. ������ʾ: ��������ʾ���ܹ�ʱ,�ǰ�op_hist���op__qad02ʵ��ȡ��ֵ�õ���.
��op__qad02��¼��ÿ�η���ʱ��,��ʵ���ܹ�ʱ.
����ÿ�εļ��㷽��������,�ôε��ܹ�ʱ,���Ǽ�¼��op__qad02�е�.
[100715.1]
1. tony. softspeed, collection terms.
2. simon.
2.1. add a column. wr_mch.
2.2. add a column. has issue "*", else "".
[100715.1]
[100624.1]
20100613�������ѵ��,����,��ʦ�����������:
�ڻ��ܷ�ʽ��ӡ��ʱ��:
1. ����"R"״̬����.��ʹ����ĳ����δ����������,Ͷ��,�ȶ���,Ҳ���õ�������ʾ����.
2. ��ʾ�������ĵ�˵��.
    Kaine # ֻ���ɹ����������̵�����ȥȡ.
    2.1. ����Ͷ��,ת��,δ���ù�������/����.
    2.2. ���ڻ���,ĳ������ܴ��ڶ�η���,ʹ�ò�ͬ����.
[100624.1]
[100605.1]
1. ��Ʒ,�������Ϊ��,��Ĭ�ϲ��ҷ�ΧΪ���������.
2. ������ʾ��,�������Ա������,��Ӻ���ʾ����.
[100605.1]
[100602.1]
ref: 20100517.����ϵͳ�Ż����� -1.0.simon.doc
[100602.1]
SS - 100602.1 - RNE */

{mfdtitle.i "120824.1"}

define variable sParent like ps_par no-undo.
define variable sSite like pt_site no-undo.
define variable dteEffect as date no-undo.

define variable dteA as date no-undo.
define variable dteB as date no-undo.

/* SS - 100603.1 - B
define variable decQtyOh as decimal no-undo.
define variable decQtyWIP as decimal no-undo.
SS - 100603.1 - E */

/* SS - 100602.1 - B */
define variable sWoNbrA     like wo_nbr no-undo.
define variable sWoNbrB     like wo_nbr no-undo.
define variable sPartA      like pt_part no-undo.
define variable sPartB      like pt_part no-undo.
define variable bIsSummary   as logical no-undo.
define variable decReady as decimal no-undo.
define variable decRun as decimal no-undo.
define variable decBuCha as decimal no-undo.
define variable decTotal as decimal no-undo.
define variable decCompX as decimal no-undo.
define variable decCompZ as decimal no-undo.
define variable decOutX as decimal no-undo.
define variable decOutZ as decimal no-undo.
define variable usrName as character format "x(12)" no-undo.
define variable empName as character format "x(12)" no-undo.
/* SS - 100602.1 - E */

/* SS - 100605.1 - B */
define variable sWorkerIDList as character no-undo.
define variable sWorkerNameList as character no-undo.
define variable i as integer no-undo.
define variable bIncludeCloseWO as logical no-undo.
/* SS - 100605.1 - E */

/* SS - 100715.1 - B */
define variable sHasIssue as character no-undo.
/* SS - 100715.1 - E */

{xxsummarybomtable.i "new shared"}

form
    sParent     colon 15    label "Parent"
    sSite       colon 15    label "Site"
    dteEffect   colon 15    label "Effect"
    skip(1)
    dteA        colon 15    label "Wo Date"
    dteB        colon 45    label "To"
    /* SS - 100602.1 - B */
    sWoNbrA     colon 15    label "����"
    sWoNbrB     colon 45    label "��"
    sPartA      colon 15    label "���"
    sPartB      colon 45    label "��"
    bIsSummary   colon 15    label "Y����/N��ϸ"
    bIncludeCloseWO colon 15    label "�����ѹع���"
    /* SS - 100602.1 - E */
    skip
with frame a side-labels width 80.
setframelabels(frame a:handle).

dteEffect = today.

/* SS - 100605.1 - B */
for first si_mstr
    no-lock
    where si_domain = global_domain
:
    sSite = si_site.
end.
/* SS - 100605.1 - E */




{wbrp01.i}
repeat with frame a
    on endkey undo, leave:

    if dteA = low_date then dteA = ?.
    if dteB = hi_date then dteB = ?.
    /* SS - 100602.1 - B */
    if sWoNbrB = hi_char then sWoNbrB = "".
    if sPartB = hi_char then sPartB = "".
    /* SS - 100602.1 - E */

    update
        sParent
        sSite
        dteEffect
        dteA
        dteB
        /* SS - 100602.1 - B */
        sWoNbrA
        sWoNbrB
        sPartA
        sPartB
        bIsSummary
        bIncludeCloseWO
        /* SS - 100602.1 - E */
        .


    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i   sParent       }
        {mfquoter.i   sSite         }
        {mfquoter.i   dteEffect     }
        {mfquoter.i   dteA          }
        {mfquoter.i   dteB          }
        {mfquoter.i   sWoNbrA           }
        {mfquoter.i   sWoNbrB           }
        {mfquoter.i   sPartA            }
        {mfquoter.i   sPartB            }
        {mfquoter.i   bIsSummary        }
        {mfquoter.i   bIncludeCloseWO        }
    end.

    if dteA = ? then dteA = low_date.
    if dteB = ? then dteB = hi_date.
    /* SS - 100602.1 - B */
    if sWoNbrB = "" then sWoNbrB = hi_char.
    if sPartB = "" then sPartB = hi_char.
    /* SS - 100602.1 - E */

    find first pt_mstr
        no-lock
        where pt_domain = global_domain
            and pt_part = sParent
        no-error.
    if available(pt_mstr) and sSite = "" then sSite = pt_site.
    display sSite with frame a.

    /* output destination selection */
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = " "
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }


    empty temp-table tsummarybom_tmp.
    /* SS - 100605.1 - B
    {gprun.i
        ""xxexportsummarybom.p""
        "(
            input sParent,
            input sParent,
            input ' ',
            input hi_char,
            input sSite,
            input dteEffect,
            input 99,
            input yes
        )"
    }
    SS - 100605.1 - E */
    /* SS - 100605.1 - B */
    if sParent = "" then do:
        for each pt_mstr
            no-lock
            where pt_domain = global_domain
                and pt_pm_code = "M"
        :
            create tsummarybom_tmp.
            assign
                tsummarybom_par = ""
                tsummarybom_site = pt_site
                tsummarybom_comp = pt_part
                tsummarybom_qty = 1
                .
        end.
    end.
    else do:
        {gprun.i
            ""xxexportsummarybom.p""
            "(
                input sParent,
                input sParent,
                input ' ',
                input hi_char,
                input sSite,
                input dteEffect,
                input 99,
                input yes
            )"
        }
    end.
    /* SS - 100605.1 - E */


    /* SS - 100603.1 - B */
    if bIsSummary then do:
        {xxwooprp2002.i}
    end.
    else do:
        {xxwooprp2001.i}
    end.
    /* SS - 100603.1 - E */

    /*
     *  20100603
     *  move next block code to xxwooprp2001.i. --> for detail
     *  add xxwooprp2002.i --> for summary
     */
    /* SS - 100603.1 - B
    put
        unformatted
        "ExcelFile;wooprp20" at 1
        "SaveFile;"
            + string(today, "99999999")
            + replace(string(time, "HH:MM:SS"), ":", "")
            + "wooprp20" at 1
        "BeginRow;1" at 1
        .

    run putHeader.

    for each tsummarybom_tmp
        ,
    first pt_mstr
        no-lock
        where pt_domain = global_domain
            and pt_part = tsummarybom_comp
            and pt_pm_code = "M"
            /* SS - 100603.1 - B */
            and pt_part >= sPartA
            and pt_part <= sPartB
            /* SS - 100603.1 - E */
        use-index pt_part
        ,
    each wo_mstr
        no-lock
        where wo_domain = global_domain
            and wo_part = tsummarybom_comp
            and wo_site = sSite
            /* SS - 100603.1 - B */
            and wo_nbr >= sWoNbrA
            and wo_nbr <= sWoNbrB
            /* SS - 100603.1 - E */
        use-index wo_part
        ,
    each xop_hist
        no-lock
        where xop_domain = wo_domain
            and xop_wo_lot = wo_lot
            and xop_date >= dteA
            and xop_date <= dteB
        use-index xop_lot_op_seq
        ,
    first wr_route
        no-lock
        where wr_domain = xop_domain
            and wr_lot = xop_wo_lot
            and wr_op = xop_op
        break
        by xop_wo_lot
        by xop_date
        by xop_seq
    :
       assign usrname = ""
              empname = "".
       find first usr_mstr no-lock where usr_userid = xop_employee no-error.
       if available usr_mstr then do:
          assign usrname = usr_name.
       end.
       find first op_hist
                no-lock
                where op_domain = xop_domain
                    and op_trnbr = xop_qad_trnbr
                use-index op_trnbr
                no-error.
        if available op_hist then do:
           find first emp_mstr no-lock where emp_domain = op_domain
                         and emp_addr = op_emp no-error.
           if available emp_mstr then do:
             assign empname = emp_name.
           end.
        end.
        put
            unformatted
            wo_part at 1    ";"
            pt_desc1 + pt_desc2 ";"
            xop_wo_nbr        ";"
            xop_op          ";"
            wr_desc         ";"
            .

        if xop_type = "In" then do:
            put
                unformatted
                xop_qty_in  ";"
                xop_date    ";"
                ";;;;;;;;;;;"
                .
        end.
        else if xop_type = "CompX" or xop_type = "CompZ" then do:
            put
                unformatted
                ";" empname ";"
                usrname ";"
                xop_qty_comp ";"
                xop_date ";"
                .
            if available(op_hist) then do:
                put
                    unformatted
                    op_act_setup       ";"
                    op_act_run         ";"
                    op__qad01          ";"
                    op__qad02          ";"
                    .
            end.
            else do:
                put
                    unformatted
                    ";;;;"
                    .
            end.
            put
                unformatted
                xop_qty_reject  ";"
                xop_qty_rework  ";"
                ";;"
                .
        end.
        else if xop_type = "OutX" or xop_type = "OutZ" then do:
            put
                unformatted
                ";;;;;;;;;;;"
                xop_qty_out     ";"
                xop_date        ";"
                .
        end.
        else do:
            put
                unformatted
                ";;;;;;;;;;;;;"
                .
        end.
        put
            unformatted
            xop_ld_qty_wip    ";"
            xop_ld_qty_zz     ";"
            xop_ld_qty_xc
            .

    end.
    SS - 100603.1 - E */



    {xxmfreset.i}
  {mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}


procedure putHeader:
    put
        unformatted
        /* SS - 100701.1 - B
        "����;��������;������;����;������;Ͷ������;Ͷ������;�ӹ���;�������;�깤����;׼�Ṥʱ;������ʱ;������ʱ;��ʱ�ܶ�;��Ʒ����;��������;ת������;ת������;��������;���ƿ���;�ֳ����" at 1
        SS - 100701.1 - E */
        /* SS - 100715.1 - B
        /* SS - 100701.1 - B */
        "����;��������;������;����;������;����˵��;Ͷ������;Ͷ������;�ӹ���;�������;�깤����;׼�Ṥʱ;������ʱ;������ʱ;��ʱ�ܶ�;��Ʒ����;��������;ת������;ת������;��������;���ƿ���;�ֳ����" at 1
        /* SS - 100701.1 - E */
        SS - 100715.1 - E */
        /* SS - 100715.1 - B */
        "����;����;��������;������;����;������;����;����˵��;Ͷ������;Ͷ������;�ӹ���;Ͷ��ְԱ;�������;�깤����;׼�Ṥʱ;������ʱ;������ʱ;��ʱ�ܶ�;��Ʒ����;��������;ת������;ת������;��������;���ƿ���;�ֳ����" at 1
        /* SS - 100715.1 - E */
        .
end procedure.

procedure putHeadersum:
    put
        unformatted
        /* SS - 100701.1 - B
        "����;��������;������;����;������;Ͷ������;�������;׼�Ṥʱ;������ʱ;������ʱ;��ʱ�ܶ�;��Ʒ����;��������;ת������;��������;���ƿ���;�ֳ����" at 1
        SS - 100701.1 - E */
        /* SS - 100715.1 - B
        /* SS - 100701.1 - B */
        "����;��������;������;����;������;����˵��;Ͷ������;�������;׼�Ṥʱ;������ʱ;������ʱ;��ʱ�ܶ�;��Ʒ����;��������;ת������;��������;���ƿ���;�ֳ����" at 1
        /* SS - 100701.1 - E */
        SS - 100715.1 - E */
        /* SS - 100715.1 - B */
        "����;����;��������;������;����;������;����;����˵��;Ͷ������;�������;׼�Ṥʱ;������ʱ;������ʱ;��ʱ�ܶ�;��Ʒ����;��������;ת������;��������;���ƿ���;�ֳ����" at 1
        /* SS - 100715.1 - E */
        .
end procedure.





