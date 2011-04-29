/* xxfarp017.p �̶��ʲ�ԭֵ--���Ԥ��� */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* REVISION: 1.0      LAST MODIFIED: 2010/04/12   BY: Softspeed Roger Xiao */
/*-Revision end------------------------------------------------------------*/

{mfdtitle.i "100412.1"}

define variable v_rptdate as date.
v_rptdate = date(month(today),01,year(today)) - 1. /*�������һ��*/

define variable yr        like glc_year   no-undo.
define variable yr1       like glc_year   no-undo.
define variable l-yrper   like fabd_yrper no-undo.
define variable l-yrper1  like fabd_yrper no-undo.
define variable l_error   as   integer      no-undo.

define var v_ii   as integer label "���" .
define var v_acct like faba_acct.
define var v_sub  like faba_sub .
define var v_cc   like faba_cc  .
define var v_typename   as char format "x(60)".
define var per-start    like fabd_yrper no-undo.
define var per-disp     like fabd_yrper no-undo.
define var  v_amt_temp      like fab_salvamt no-undo.
define var  v_amt_cost      like fab_salvamt no-undo.


define temp-table temp1 /*��ϸ��:�ȼ�+��������+���*/
    field t1_class     like fa_facls_id  /*�ʲ��ȼ�*/
    field t1_type      as char           /*fa__chr04:����/������/����*/
    field t1_year      as integer        /*���*/
    field t1_amt_beg   like fab_amt   /*�ڳ�*/
    field t1_amt_add1  like fab_amt   /*����-��ͨ*/
    field t1_amt_add2  like fab_amt   /*����-����*/
    field t1_amt_dsp   like fab_amt   /*����-����*/
    field t1_amt_end   like fab_amt   /*��ĩ*/
    .

define temp-table temp2 /*�ܱ�:�ȼ�+��������*/
    field t2_class     like fa_facls_id  /*�ʲ��ȼ�*/
    field t2_type      as char           /*fa__chr04:����/������/����*/
    field t2_acct      like faba_acct
    field t2_sub       like faba_sub
    field t2_cc        like faba_cc
    .


form
    SKIP(.2)
 
   l-yrper        colon 25      
   l-yrper1       colon 42      label {t001.i}

skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{gprunp.i "fapl" "p" "fa-get-per"
  "(input  v_rptdate,
    input  """",
    output l-yrper,
    output l_error)"}
if l_error <> 0 then  l-yrper = string(year(v_rptdate), "9999") + string(month(v_rptdate), "99").

l-yrper1 = l-yrper.

{wbrp01.i}
repeat:

    if l-yrper1  = hi_char then l-yrper1  = "".

    update  
        l-yrper  
        l-yrper1 
    with frame a.

        
    if l-yrper      = ""  
       or length(l-yrper) <> 6 
    then do:
        message "����:��Ч���/�ڼ�,����������" .
        undo,retry .
    end. /** IF l-yrper = "" */

    if l-yrper1      = ""  
       or length(l-yrper1) <> 6 
    then do:
        message "����:��Ч���/�ڼ�,����������" .
        undo,retry .
    end. /** IF l-yrper = "" */
    
    for first fabk_mstr
        fields( fabk_domain fabk_id fabk_post)
         where fabk_mstr.fabk_domain = global_domain and  fabk_post = yes
           and fabk_id > ""
    no-lock: end.
    if not available fabk_mstr then do:
        message "����:δ�趨�̶��ʲ�������Ŀ,�����趨" .
        undo,retry.
    end.

    if l-yrper1  = ""       then l-yrper1  = hi_char.
    if l-yrper1  < l-yrper  then l-yrper1  = l-yrper.

    yr  = integer(substring(l-yrper,1,4)).
    yr1 = integer(substring(l-yrper1,1,4)).

    if yr < year(today) - 1 then do:
        message "Ԥ���ĳ�ʼ���,�������ڵ�ǰ�����:" year(today) .
        undo,retry .
    end.
    if yr1 - yr > 10 then do:
        message "Ԥ���Ŀ�Ȳ��ܳ���10��." .
        undo,retry .
    end.
    /*������ʼ���ʼ��ǰ�����*/
    if yr > year(today) - 1  then yr = year(today) - 1 .




    /* PRINTER SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = "nopage"
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
mainloop: 
do on error undo, return error on endkey undo, return error:                    


    PUT UNFORMATTED "#def REPORTPATH=$/FA/xxfarp017" SKIP.
    PUT UNFORMATTED "#def :end" SKIP.


for each temp1: delete temp1. end.
for each temp2: delete temp2. end.

for each fa_mstr 
        where fa_domain    = global_domain 
          /*and year(fa_startdt) >= yr and year(fa_startdt) <= yr1 
          and (fa_disp_dt = ? or year(fa_disp_dt)>= yr1 ) */
    no-lock
    break  by fa_id :
    /*break by fa_facls_id by fa__chr04  by fa_id :*/
    
    v_acct = "" .
    v_sub  = "" .
    v_cc   = "" .
    /*���ʲ��˻�acctype = "1"*/
    define var l-acct-seq like faba_glseq no-undo .
    l-acct-seq = 0 .
    for last faba_det use-index faba_fa_id where faba_domain = global_domain and  faba_fa_id = fa_id no-lock:
        l-acct-seq = faba_glseq.
    end.  
    find first faba_det 
        where faba_domain  = fa_domain 
        and   faba_fa_id   = fa_id
        and   faba_acctype = "1" 
        and   faba_glseq   = l-acct-seq 
    no-lock no-error .
    if avail faba_det then assign  v_acct = faba_acct v_sub = faba_sub v_cc = faba_cc .


    /*ȷ�����ڹ�����Ŀ��Ӧ���ʲ�fab_det*/    
    find last fab_det 
        where fab_domain  = fa_domain 
        and   fab_fa_id   = fa_id
        and   fab_fabk_id = fabk_id
    no-lock no-error .
    if not avail fab_det then next .

    find first famt_mstr where famt_domain = global_domain and famt_id = fab_famt_id no-lock no-error .
    if (not avail famt_mstr ) or (available famt_mstr and not famt_active) then next .

    /*�ܳɱ�*/
    {gprunp.i "fapl" "p" "fa-get-cost"
         "(input  fa_id,
           input  fabk_id,
           output v_amt_cost)"}

    /*����ʼ�ڼ�,�����ڼ�*/
    per-start = string(year(fa_startdt),"9999") + string(month(fa_startdt),"99").
    per-disp  = if fa_disp_dt = ? then "" 
                else string(year(fa_disp_dt),"9999") + string(month(fa_disp_dt),"99").

    find first temp2 where t2_class = fa_facls_id and t2_type = fa__chr04 no-error .
    if not avail temp2 then do:
        create temp2 .
        assign  t2_class = fa_facls_id  
                t2_type = fa__chr04 
                t2_acct = v_acct   
                t2_sub  = v_sub   
                t2_cc   = v_cc                   
                .
    end. /*if not avail temp2*/

    v_ii = 0 .
    do v_ii = yr to yr1 :
        define var yrEnd as char .
        define var yrBeg as char .
        /*���*/ yrBeg = if v_ii = integer(substring(l-yrper,1,4)) then l-yrper  else string(v_ii) + "01" .
        /*��ĩ*/ yrEnd = if v_ii = yr1 then l-yrper1 else string(v_ii) + "12" .
        find first temp1 where t1_class = fa_facls_id and t1_type = fa__chr04 and t1_year = v_ii no-error .
        if not avail temp1 then do:
            create temp1 .
            assign  t1_class = fa_facls_id  
                    t1_type = fa__chr04 
                    t1_year = v_ii 
                   .
        end.

        /*�����ڳ�*/
        if per-start  < yrBeg 
            and (fa_disp_dt = ? or (per-disp >= yrBeg ))
        then t1_amt_beg = t1_amt_beg + v_amt_cost .
        
        /*��������*/
        if (per-start >= yrBeg and per-start  <= yrEnd)
           and (fa__chr03 =  "" or fa__chr03 = "D21") then t1_amt_add1 = t1_amt_add1 + v_amt_cost . 
        
        /*�������*/
        if (per-start >= yrBeg and per-start  <= yrEnd)
           and fa__chr03 begins "D0" then t1_amt_add2 = t1_amt_add2 + v_amt_cost . 

        /*�������*/
        if (fa_disp_dt <> ? and (per-disp >= yrBeg and per-disp  <= yrEnd)) 
           then t1_amt_dsp = t1_amt_dsp + v_amt_cost . 

        /*������ĩ*/
        if per-start  <= yrEnd 
           and (fa_disp_dt = ? or (per-disp > yrEnd ))
        then t1_amt_end = t1_amt_end + v_amt_cost .

    end. /*do v_ii = yr to yr1*/  
end. /*for each fa_mstr*/


/*��ʾ***********************************************/
{xxfarp017p.i ""�ڳ����"" t1_amt_beg  }
{xxfarp017p.i ""��������"" t1_amt_add1 }
{xxfarp017p.i ""���ڴ���"" t1_amt_add2 }
{xxfarp017p.i ""���ڱ���"" t1_amt_dsp  }
{xxfarp017p.i ""��ĩ���"" t1_amt_end  }


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


