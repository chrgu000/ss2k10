/* xxporp003.p - 预付款账龄报表                                             */
/* REVISION: 100809.1      Created On: 20100809 ,  BY: Roger Xiao           */
/*----rev history-----------------------------------------------------------*/



{mfdtitle.i "100809.1"}

{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}
{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
{eteuro.i  }

define var xdate      as date .
define var xdate1     as date .
define var vend      like po_vend.
define var vend1     like po_vend.
define var entity    like ap_entity.
define var entity1   like ap_entity.
define var votype    like vo_type label "总账参考号".
define var votype1   like votype.
define var vdtype    like vd_type label "供应商类型".
define var vdtype1   like vdtype.
define var ref       like ap_ref.
define var ref1      like ap_ref.
define var vopo      like po_nbr no-undo.

define var mc-rpt-curr      like base_curr no-undo.
define var base_rpt         like base_curr.
define var et_curr_amt      like ap_amt.
define var et_base_amt      like ap_amt.
define var base_amt         like vo_prepay label "Prepay Amt".
define var used_amt         like vo_prepay .

define var v_vdname   as char format "x(24)" .
define var effdate    like prh_rcp_date format "99/99/99" no-undo.
define var v_dt       as integer extent 7.
v_dt[1] = 30.
v_dt[2] = 60.
v_dt[3] = 90.
v_dt[4] = 120.
v_dt[5] = 150.
v_dt[6] = 180.
v_dt[7] = 360.
effdate  = today .

define var v_key1 as char .
v_key1 = mfguser + "xxporp003" .


define temp-table temp2 
    field t2_vend    like po_vend 
    field t2_amt     like ap_amt extent 8
    field t2_amt_tot like ap_amt
    .


form
    SKIP(.2)
    vend                colon 18 label "供应商"
    vend1               colon 53 label "至"
    vdtype              colon 18
    vdtype1             colon 53 label {t001.i} 
    entity              colon 18
    entity1             colon 53 label {t001.i}
    ref                 colon 18 
    ref1                colon 53 label {t001.i}
    votype              colon 18
    votype1             colon 53 label {t001.i}
    xdate                colon 18 label "预付日期"
    xdate1               colon 53 label "至" 

    skip(1)
    effdate             colon 30
    base_rpt            colon 30
    et_report_curr      colon 30 
    
    skip(1) 
    "栏目天数:"    colon 1 skip
    space(1)
    v_dt[1]    label "[1]"
    v_dt[2]    label "[2]"
    v_dt[3]    label "[3]"
    v_dt[4]    label "[4]"  skip
    space(1)
    v_dt[5]    label "[5]"
    v_dt[6]    label "[6]"
    v_dt[7]    label "[7]"
         
skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    for each temp2 : delete temp2 . end.

    for each usrw_wkfl
        where usrw_key1 = v_key1 :
        delete usrw_wkfl.
    end.


    if xdate    = low_date then xdate  = ? .
    if xdate1   = hi_date  then xdate1 = ? .
    if vend1    = hi_char  then vend1 = "" .
    if entity1  = hi_char  then entity1  = "" .
    if vdtype1  = hi_char  then vdtype1  = "" .
    if ref1     = hi_char  then ref1     = "" .
    if votype1  = hi_char  then votype1  = "" .
    
    update 
        vend           
        vend1            
        vdtype         
        vdtype1        
        entity         
        entity1        
        ref            
        ref1           
        votype         
        votype1        
        xdate           
        xdate1          
        effdate        
        base_rpt       
        et_report_curr 
        v_dt
    with frame a.


    if xdate     = ?  then xdate     =  low_date.
    if xdate1    = ?  then xdate1    =  hi_date .
    if vend1     = "" then vend1     =  hi_char .
    if entity1   = "" then entity1   =  hi_char .
    if vdtype1   = "" then vdtype1   =  hi_char .
    if votype1   = "" then votype1   =  hi_char .
    if ref1      = "" then ref1      =  hi_char .
    

       et_eff_date = effdate .

       run ip-chk-valid-curr
          (input  base_rpt,
           output mc-error-number).

       if mc-error-number <> 0 then do:
          next-prompt base_rpt with frame a.
          undo, retry.
       end.

       /* Validate reporting currency */
       run ip-chk-valid-curr
          (input  et_report_curr,
           output mc-error-number).

       if mc-error-number = 0 then do:

          /* Default currencies if blank */
          mc-rpt-curr = if base_rpt = "" then base_curr else base_rpt.
          if et_report_curr = "" then et_report_curr = mc-rpt-curr.

          /* Prompt for exchange rate and format for output */
          run ip-ex-rate-setup
             (input  et_report_curr,
              input  mc-rpt-curr,
              input  " ",
              input  et_eff_date,
              output et_rate2,
              output et_rate1,
              output mc-exch-line1,
              output mc-exch-line2,
              output mc-error-number).

       end.  /* if mc-error-number = 0 */

       if mc-error-number <> 0 then do:
          next-prompt et_report_curr with frame a.
          undo, retry.
       end.

&SCOPED-DEFINE v_lbl_1 (trim(string(v_dt[1])) + "天内金额")
&SCOPED-DEFINE v_lbl_2 (trim(string(v_dt[2])) + "天内金额")
&SCOPED-DEFINE v_lbl_3 (trim(string(v_dt[3])) + "天内金额")
&SCOPED-DEFINE v_lbl_4 (trim(string(v_dt[4])) + "天内金额")
&SCOPED-DEFINE v_lbl_5 (trim(string(v_dt[5])) + "天内金额")
&SCOPED-DEFINE v_lbl_6 (trim(string(v_dt[6])) + "天内金额")
&SCOPED-DEFINE v_lbl_7 (trim(string(v_dt[7])) + "天内金额")
&SCOPED-DEFINE v_lbl_8 (trim(string(v_dt[7])) + "天外金额")



    /* PRINTER SELECTION */
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
mainloop: 
do on error undo, return error on endkey undo, return error:   
    for each usrw_wkfl
        where usrw_key1 = v_key1 :
        delete usrw_wkfl.
    end.


    for each vd_mstr 
            use-index vd_addr
            where vd_domain = global_domain 
            and (vd_addr >= vend and vd_addr <= vend1)
            and (vd_type >= vdtype and vd_type <= vdtype1)
        no-lock,
        each ap_mstr 
            use-index ap_vend
            where ap_mstr.ap_domain = global_domain 
            and ap_vend  =  vd_addr
            and ap_effdate >= xdate   and ap_effdate <= xdate1
            and (ap_curr = base_rpt  or base_rpt = "")
            and (ap_entity >= entity and ap_entity <= entity1)
            and (ap_ref >= ref       and ap_ref <= ref1)
            and ap_type = "VO"
        no-lock ,
        each vo_mstr 
            where vo_domain = global_domain
            and vo_ref = ap_ref 
            and (vo_type >= votype and vo_type <= votype1)
            and vo_confirmed
            and vo_prepay <> 0  
            and vo_prepay < 0   /*小于零的,是冲PO发票的*/
        no-lock by ap_effdate : 
        
        vopo = "" .
        for each vpo_det 
            where vpo_domain = global_domain 
            and vpo_ref = vo_ref  
            no-lock break by vpo_ref :
            if last-of(vpo_ref) then do:
                vopo = vpo_po .
            end.
        end.

        /*
        find first vpo_det 
            where vpo_domain = global_domain 
            and   vpo_ref    = vo_ref
        no-lock no-error.
        vopo = if available vpo_det then vpo_po else "".
        */
        
        find first usrw_wkfl
            where usrw_key1 = v_key1
            and   usrw_key2 = ap_vend + ";" + vopo
        no-error.
        if not avail usrw_wkfl then do:
            create usrw_wkfl .
            assign usrw_key1 = v_key1 
                   usrw_key2 = ap_vend + ";" + vopo  
                   .
        end.
        usrw_decfld[1] = usrw_decfld[1] + (- vo_prepay) .

        /*disp ap_effdate ap_ref vopo vo_prepay . */
    end. /*for each vd_mstr */




    for each vd_mstr 
            use-index vd_addr
            where vd_domain = global_domain 
            and (vd_addr >= vend and vd_addr <= vend1)
            and (vd_type >= vdtype and vd_type <= vdtype1)
        no-lock,
        each ap_mstr 
            use-index ap_vend
            where ap_mstr.ap_domain = global_domain 
            and ap_vend  =  vd_addr
            and ap_effdate >= xdate   and ap_effdate <= xdate1
            and (ap_curr = base_rpt  or base_rpt = "")
            and (ap_entity >= entity and ap_entity <= entity1)
            and (ap_ref >= ref       and ap_ref <= ref1)
            and ap_type = "VO"
        no-lock ,
        each vo_mstr 
            where vo_domain = global_domain
            and vo_ref = ap_ref 
            and (vo_type >= votype and vo_type <= votype1)
            and vo_confirmed
            and vo_prepay <> 0  
            and vo_prepay > 0   /*小于零的,是冲PO发票的*/
        no-lock by ap_effdate :  

        vopo = "" .
        for each vpo_det 
            where vpo_domain = global_domain 
            and vpo_ref = vo_ref  
            no-lock break by vpo_ref :
            if last-of(vpo_ref) then do:
                vopo = vpo_po .
            end.
        end.

        /*
        find first vpo_det 
            where vpo_domain = global_domain 
            and   vpo_ref    = vo_ref
        no-lock no-error.
        vopo = if available vpo_det then vpo_po else "".
        */


        /*vo_prepay可能是外币也可能是本位币*/
        base_amt = vo_prepay .

        /*扣掉已经冲销的金额*/
        find first usrw_wkfl
            where usrw_key1 = v_key1
            and   usrw_key2 = ap_vend + ";" + vopo
        no-error.
        if avail usrw_wkfl then do:
            if base_amt >= usrw_decfld[1] then  
                 assign base_amt = base_amt - usrw_decfld[1]
                        usrw_decfld[1] = 0 .
            else assign base_amt = 0  
                        usrw_decfld[1] = usrw_decfld[1] - base_amt .
        end.

        /*如果币别base_rpt为空,则外币转换为本位币base_curr*/
        if base_rpt = ""
            and ap_curr <> base_curr
        then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input ap_curr,
                        input base_curr,
                        input ap_ex_rate,
                        input ap_ex_rate2,
                        input base_amt,
                        input true, 
                        output base_amt,
                        output mc-error-number)"}
            if mc-error-number <> 0 then do:
                {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
        end.   

        /*如果报表币别为空,则直接由base_rpt转换为报表币别*/
        if et_report_curr <> mc-rpt-curr then do:

            run ip-curr-conv
                (input  mc-rpt-curr,
                input  et_report_curr,
                input  et_rate1,
                input  et_rate2,
                input  base_amt,
                input  true,  /* ROUND */
                output et_base_amt).

        end.  /* if et_report_curr <> mc-rpt-curr */
        else assign et_base_amt = base_amt.

/*disp ap_effdate ap_ref vopo vo_prepay base_amt et_base_amt .*/

        find first temp2 
            where t2_vend = ap_vend
        no-error.
        if not avail temp2 then do:
            create temp2 .
            assign t2_vend  = ap_vend        
                   .
        end.

        t2_amt_tot = t2_amt_tot + et_base_amt .
        
        if      effdate - ap_effdate <= v_dt[1]  then assign t2_amt[1] = t2_amt[1] + et_base_amt.
        else if effdate - ap_effdate <= v_dt[2]  then assign t2_amt[2] = t2_amt[2] + et_base_amt.
        else if effdate - ap_effdate <= v_dt[3]  then assign t2_amt[3] = t2_amt[3] + et_base_amt.
        else if effdate - ap_effdate <= v_dt[4]  then assign t2_amt[4] = t2_amt[4] + et_base_amt.
        else if effdate - ap_effdate <= v_dt[5]  then assign t2_amt[5] = t2_amt[5] + et_base_amt.
        else if effdate - ap_effdate <= v_dt[6]  then assign t2_amt[6] = t2_amt[6] + et_base_amt.
        else if effdate - ap_effdate <= v_dt[7]  then assign t2_amt[7] = t2_amt[7] + et_base_amt.
        else                                          assign t2_amt[8] = t2_amt[8] + et_base_amt.

    end. /*for each vd_mstr*/

    for each temp2 where t2_amt_tot <> 0 
        break by t2_vend 
        with frame x width 300:

        find first ad_mstr where ad_domain = global_domain and ad_addr = t2_vend no-lock no-error .
        v_vdname = if avail ad_mstr then ad_name else "" . 

        disp 
            t2_vend       column-label "供应商"
            v_vdname      column-label "供应商名称"
            t2_amt[1]     column-label "<=30天"   
            t2_amt[2]     column-label "30--60天"   
            t2_amt[3]     column-label "60--90天"   
            t2_amt[4]     column-label "90--120天"   
            t2_amt[5]     column-label "120--150天"   
            t2_amt[6]     column-label "150--180天"   
            t2_amt[7]     column-label "180--360天"   
            t2_amt[8]     column-label ">360天"   
            t2_amt_tot    column-label "合计金额"   
        with frame x .


/*
column-label {&v_lbl_1}  
column-label {&v_lbl_2}  
column-label {&v_lbl_3}  
column-label {&v_lbl_4}  
column-label {&v_lbl_5}  
column-label {&v_lbl_6}  
column-label {&v_lbl_7}  
column-label {&v_lbl_8}  
*/







        accumulate t2_amt[1]   (total).
        accumulate t2_amt[2]   (total).
        accumulate t2_amt[3]   (total).
        accumulate t2_amt[4]   (total).
        accumulate t2_amt[5]   (total).
        accumulate t2_amt[6]   (total).
        accumulate t2_amt[7]   (total).
        accumulate t2_amt[8]   (total).
        accumulate t2_amt_tot  (total).
        
        if last(t2_vend) then do:
                down 1 with frame x .
                disp 
                    "合计: "               @ t2_vend 
                    accum total t2_amt[1]  @ t2_amt[1]
                    accum total t2_amt[2]  @ t2_amt[2]
                    accum total t2_amt[3]  @ t2_amt[3]
                    accum total t2_amt[4]  @ t2_amt[4]
                    accum total t2_amt[5]  @ t2_amt[5]
                    accum total t2_amt[6]  @ t2_amt[6]
                    accum total t2_amt[7]  @ t2_amt[7]
                    accum total t2_amt[8]  @ t2_amt[8]
                    accum total t2_amt_tot @ t2_amt_tot
                with frame x.
        end.
    end.  /*for each temp2*/



end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */

for each usrw_wkfl
    where usrw_key1 = v_key1 :
    delete usrw_wkfl.
end.


end.  /* REPEAT */
{wbrp04.i &frame-spec = a}






 procedure ip-chk-valid-curr:


    define input  parameter i_curr  as character no-undo.
    define output parameter o_error as integer   no-undo initial 0.


    if i_curr <> "" then do:

       {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
          "(input  i_curr,
            output o_error)" }

       if o_error <> 0 then do:
          {mfmsg.i o_error 3}
       end.

    end.  /* if i_curr */


 end procedure.  /* ip-chk-valid-curr */


 procedure ip-ex-rate-setup:

    define input  parameter i_curr1      as character no-undo.
    define input  parameter i_curr2      as character no-undo.
    define input  parameter i_type       as character no-undo.
    define input  parameter i_date       as date      no-undo.

    define output parameter o_rate       as decimal   no-undo initial 1.
    define output parameter o_rate2      as decimal   no-undo initial 1.
    define output parameter o_disp_line1 as character no-undo
                                                      initial "".
    define output parameter o_disp_line2 as character no-undo
                                                      initial "".
    define output parameter o_error      as integer   no-undo initial 0.

    define variable v_seq                as integer   no-undo.
    define variable v_fix_rate           like mfc_logical no-undo.


    do transaction:

       /* Get exchange rate and create usage records */
       {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
          "(input  i_curr1,
            input  i_curr2,
            input  i_type,
            input  i_date,
            output o_rate,
            output o_rate2,
            output v_seq,
            output o_error)" }

       if o_error = 0 then do:

          /* Prompt user to edit exchange rate */
          {gprunp.i "mcui" "p" "mc-ex-rate-input"
             "(input        i_curr1,
               input        i_curr2,
               input        i_date,
               input        v_seq,
               input        false,
               input        5,
               input-output o_rate,
               input-output o_rate2,
               input-output v_fix_rate)" }

          /* Format exchange rate for output */
          {gprunp.i "mcui" "p" "mc-ex-rate-output"
             "(input  i_curr1,
               input  i_curr2,
               input  o_rate,
               input  o_rate2,
               input  v_seq,
               output o_disp_line1,
               output o_disp_line2)" }

          /* Delete usage records */
          {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
             "(input v_seq)" }

       end.  /* if o_error */

       else do:
          {mfmsg.i o_error 3}
       end.

    end.  /* do transaction */


 end procedure.  /* ip-ex-rate-setup */


procedure ip-curr-conv:


    define input  parameter i_src_curr  as character no-undo.
    define input  parameter i_targ_curr as character no-undo.
    define input  parameter i_src_rate  as decimal   no-undo.
    define input  parameter i_targ_rate as decimal   no-undo.
    define input  parameter i_src_amt   as decimal   no-undo.
    define input  parameter i_round     like mfc_logical   no-undo.
    define output parameter o_targ_amt  as decimal   no-undo.

    define variable mc-error-number as integer no-undo.


    {gprunp.i "mcpl" "p" "mc-curr-conv"
       "(input  i_src_curr,
         input  i_targ_curr,
         input  i_src_rate,
         input  i_targ_rate,
         input  i_src_amt,
         input  i_round,
         output o_targ_amt,
         output mc-error-number)" }

    if mc-error-number <> 0 then do:
       {mfmsg.i mc-error-number 2}
    end.


end procedure.  /* ip-curr-conv */


