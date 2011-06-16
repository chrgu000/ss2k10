/*xxexcel-rp001.p                                                            */
/* revision: 110314.1   created on: 20110314   by: softspeed roger xiao      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*----rev history------------------------------------------------------------*/
/* ss - 110314.1  by: roger xiao                                             */
/*-revision end--------------------------------------------------------------*/
/*ע�⣺cim-showa.xla vba project password:rogercimshowa                     */

{mfdtitle.i "110607.1"}
define var v_prgname like execname no-undo.


def var effdate  like tr_effdate no-undo.
def var effdate1 like tr_effdate no-undo.
def var v_site   as char format "x(1)"  init "1" no-undo.
def var cust1    as char  no-undo.
def var cust2    as char  no-undo.

define var v_part     like cp_part.         /* �Ѻ�ͼ��     */
define var v_qty_case like xxsod_qty_ord.   /* ������ = ��ǩ�� = ��ά����*/
define var v_time_a   like xxsod_due_time1. /* ��Ʊʱ��     */
define var v_time_b   like xxsod_due_time1. /* װ������     */
define var v_time_c   like xxsod_due_time1. /* ����ʱ��     */
define var v_time_d   like xxsod_due_time1. /* ����ʱ��     */
define var v_time_e   like xxsod_due_time1. /* ����ʱ��     */
define var v_time_f   like xxsod_due_time1. /* �������ʱ�� */


/* Attention: xxsod_det ���ȫ���ַ�!!! */

/*���ַ�ʱ��hh:mm�����ָ�ʽ*/
function xtime returns integer (input v_ctime as char):
   define var v_itime as integer initial 0 no-undo.

   if index(v_ctime , ":") = 0 then v_itime = 0 .
   else do:
       v_itime = integer(entry(1,v_ctime,":")) * 60 * 60
               + integer(entry(2,v_ctime,":")) * 60 .
   end.
   return (v_itime).
end function.


/*���ַ����ڵ�����*/
function xdate2d returns date (input v_cdate as char):
   define var v_ddate as date no-undo.
   if index(v_cdate ,"-") = 0 then v_ddate = ?.
   else do:
       v_ddate = date(integer(entry(2,v_cdate,"-")),
                      integer(entry(3,v_cdate,"-")),
                      integer(entry(1,v_cdate,"-"))).
   end.
   return (v_ddate).
end function.


/*�����ڵ��ַ���ʽ,for output to excel*/
function xdate2c returns char (input v_ddate as date):
   define var v_cdate as char no-undo.

   if v_ddate = ?  then v_cdate = "" .
   else do:
       v_cdate = string(year(v_ddate),"9999") + "-"
               + string(month(v_ddate),"99") + "-"
               + string(day(v_ddate),"99").
   end.
   return (v_cdate).
end function.


form
    skip(.2)

   effdate     colon 15
   effdate1    colon 49  label {t001.i}
   v_site      colon 15  label "�ͻ�����"
   "[1] (4H0001:�㱾һ��/4H0003:����һ��)" colon 15
   "[2] (4H1001:�㱾����/4H1003:��������)" colon 15
skip(1)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

effdate = today.

{wbrp01.i}
repeat:

    if effdate  = low_date then effdate = ? .
    if effdate1 = hi_date  then effdate1 = ?.

    cust1 = "4h0001,4h0003".
    cust2 = "4h1001,4h1003".


    update
        effdate
        effdate1
        v_site
    with frame a.

    if effdate  = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date .


    /*excel����ר��,�����ٸĳ�ʽ��*/
    if index(execname,".p") <> 0 then v_prgname = entry(1,execname,".p").
    else do:
        message "����:��Ч��ʽ����ʽ" execname .
        undo,retry.
    end.


   if not (v_site = "1" or v_site = "2" ) then do:
       message "����: ������Ч,��������ȷ�ĳ���" .
       next-prompt v_site with frame a .
       undo,retry.
   end.

    {gpselout.i &printtype = "printer"
                &printwidth = 132
                &pagedflag = "nopage"
                &stream = " "
                &appendtofile = " "
                &streamedoutputtoterminal = " "
                &withbatchoption = "yes"
                &displaystatementtype = 1
                &withcancelmessage = "yes"
                &pagebottommargin = 6
                &withemail = "yes"
                &withwinprint = "yes"
                &definevariables = "yes"}
mainloop:
do on error undo, return error on endkey undo, return error:

export delimiter "~011"
    "�ͻ�����:"  v_site
    "��ʼ����:"  xdate2c(effdate)
    "��������:"  xdate2c(effdate1)
    .

export delimiter "~011"
    "�ͻ�����"
    "��������"
    "��Ʊʱ��"
    "װ������"
    "����ʱ��"
    "����ʱ��"
    "����ʱ��"
    "�������ʱ��"
    "�ͻ�ͼ��"
    "�Ѻ�ͼ��"
    "��Ʒ����"
    "��������"
    "��Ʊ����"
    .

for each xxsod_det
        where (/*�ͻ�ͼ��56100��ͷ��Ϊ�ͱ�,������һ�� */
                  (v_site = "1" and (index(cust1,xxsod_cust) > 0 or
                                    (index(cust2,xxsod_cust) > 0 and
                                     xxsod_part begins "56100" )))
                  or
                  (v_site = "2" and (index(cust2,xxsod_cust) > 0 and
                                     (not xxsod_part begins "56100" )))
              )
        and date(int(entry(2,xxsod_due_date1,"-")),
                 int(entry(3,xxsod_due_date1,"-")),
                 int(entry(1,xxsod_due_date1, "-"))) >= effdate
        and date(int(entry(2,xxsod_due_date1,"-")),
                 int(entry(3,xxsod_due_date1,"-")),
                 int(entry(1,xxsod_due_date1, "-"))) <= effdate1
    no-lock
    break by xxsod_due_date1 by xxsod_due_time1 :


    find first cp_mstr
        use-index cp_cust
        where cp_cust    = xxsod_cust
        and cp_cust_part = xxsod_part
    no-lock no-error.

    assign
    /* �Ѻ�ͼ�� */
    v_part    = if avail cp_mstr then cp_part else "Error"
    /* ��Ʊʱ�� */
    v_time_a  = string(xtime(xxsod_due_time ),"HH:MM")
    /* װ������ */
    v_time_b  = if (xtime(xxsod_due_time1) - 50 * 60) < 0 then
                    xdate2c(xdate2d(xxsod_due_date1) - 1 ) + " "
                  + string((24 * 60 * 60 + (xtime(xxsod_due_time1) - 50 * 60)),
                            "HH:MM")
                else
                    string((xtime(xxsod_due_time1) - 50 * 60),"HH:MM")
    /* ����ʱ�� */
    v_time_c  = if (xtime(xxsod_due_time1) - 40 * 60) < 0 then
                    xdate2c(xdate2d(xxsod_due_date1) - 1 ) + " "
                  + string((24 * 60 * 60 + (xtime(xxsod_due_time1) - 40 * 60)),
                            "HH:MM")
                else
                    string((xtime(xxsod_due_time1) - 40 * 60),"HH:MM")
    /* ����ʱ�� */
    v_time_d  = if (xtime(xxsod_due_time1) - 10 * 60) < 0 then
                    xdate2c(xdate2d(xxsod_due_date1) - 1 ) + " "
                  + string((24 * 60 * 60 + (xtime(xxsod_due_time1) - 10 * 60)),
                            "HH:MM")
                else
                     string((xtime(xxsod_due_time1) - 10 * 60),"HH:MM")
    /* ����ʱ�� */
    v_time_e  = string(xtime(xxsod_due_time1),"HH:MM")
    /* ������� */
    v_time_f  = if xtime(xxsod_due_time1) < 10 * 60 * 60 then ""
              else string(xtime(xxsod_due_time1) - 80 * 60,"HH:MM")
    .
/*                                                                           */
/*  find first xxcased_det no-lock where xxcased_part = xxsod_part no-error. */
/*  if available xxcased_det then do:                                        */
/*     assign v_qty_case = xxcased_qty_per.                                  */
/*  end.                                                                     */
/*  else do:                                                                 */
/*     assign v_qty_case = 0.                                                */
/*  end.                                                                     */
/*
                                                                     */
    /*  �������� = ��Ʒ���� / ̨����װ�� */
    find first pt_mstr no-lock where pt_part = v_part no-error.
    if available pt_mstr and pt_ship_wt <> 0 then do:
       assign v_qty_case = xxsod_qty_ord / pt_ship_wt.
    end.
    else do:
       assign v_qty_case = 0.
    end.

    export delimiter "~011"
        xxsod_cust
        xxsod_due_date1
        v_time_a
        v_time_b
        v_time_c
        v_time_d
        v_time_e
        v_time_f
        xxsod_part
        v_part
        xxsod_qty_ord
        v_qty_case
        xxsod_due_date
        .
end. /*for each xxsod_det*/
put unformatted skip(1) "�������"  skip .
end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
