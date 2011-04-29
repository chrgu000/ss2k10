
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 091125.1  By: Roger Xiao */ /*根据mage原18.21.7xxrescrp92.p修改,之前安装产线汇总,现改为按原因代码汇总*/
/*-Revision end---------------------------------------------------------------*/


/* SCRAP ANALYSIS REPORT */

{mfdtitle.i "091125.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rescrp01_p_1 "Scrap!Percent"
/* MaxLen: Comment: */

&SCOPED-DEFINE rescrp01_p_2 "Scrapped Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE rescrp01_p_3 "Reason"
/* MaxLen: Comment: */

&SCOPED-DEFINE rescrp01_p_4 "Processed Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE rescrp01_p_5 "Effective"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*N04H** {rewrsdef.i}                                                         */

/*G1S7*/ {revars.i}
     define buffer ophist for op_hist.
     define variable dept like wc_dept.
     define variable dept1 like wc_dept label {t001.i}.
     define variable effdate as date label {&rescrp01_p_5}.
     define variable effdate1 as date label {t001.i}.
     define variable emp like op_emp.
     define variable emp1 like op_emp label {t001.i}.
     define variable line like wo_line.
     define variable line1 like wo_line label {t001.i}.
     define variable lot like wo_lot.
     define variable lot1 like wo_lot label {t001.i}.
     define variable mch like wc_mch.
     define variable mch1 like wc_mch label {t001.i}.
     define variable part like wo_part.
     define variable part1 like wo_part label {t001.i}.
     define variable reason like op_rsn.
     define variable reason1 like op_rsn label {t001.i}.
     define variable shift like op_shift.
     define variable shift1 like op_shift label {t001.i}.
     define variable site like wo_site.
     define variable site1 like wo_site label {t001.i}.
     define variable wkctr like wc_wkctr.
     define variable wkctr1 like wc_wkctr label {t001.i}.
     define variable qty_cumproc like wr_qty_cumproc
       column-label {&rescrp01_p_4}.
     define variable qty_cumscrap like wr_qty_cumoscrap
       column-label {&rescrp01_p_2}.
     define variable wrdesc like wr_desc.
     define variable ptdesc like pt_desc1.
     define variable percent_scrap as dec decimals 2 format "->,>>9.99%"
        column-label {&rescrp01_p_1}.
     define variable first_display as logical.

     define var   v_rsn_desc   as char format "x(24)" .
     form
        lot                  colon 20
        lot1                 colon 45
        part                 colon 20
        part1                colon 45
        site                 colon 20
        site1                colon 45
        line                 colon 20
        line1                colon 45
        reason               colon 20
        reason1              colon 45
        wkctr                colon 20
        wkctr1               colon 45
        mch                  colon 20
        mch1                 colon 45
        dept                 colon 20
        dept1                colon 45
        shift                colon 20
        shift1               colon 45
        emp                  colon 20
        emp1                 colon 45
        effdate              colon 20
        effdate1             colon 45
     with frame a side-labels width 80 attr-space.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).

/*G1FT*       {mfdtitle.i "2+ "} */

     find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

/*K0SF*/ {wbrp01.i}

repeat:
        if lot1 = hi_char then lot1 = "".
        if part1 = hi_char then part1 = "".
        if site1 = hi_char then site1 = "".
        if line1 = hi_char then line1 = "".
        if reason1 = hi_char then reason1 = "".
        if wkctr1 = hi_char then wkctr1 = "".
        if mch1 = hi_char then mch1 = "".
        if dept1 = hi_char then dept1 = "".
        if shift1 = hi_char then shift1 = "".
        if emp1 = hi_char then emp1 = "".
        if effdate = low_date then effdate = ?.
        if effdate1 = hi_date then effdate1 = ?.


        if c-application-mode <> 'web':u then
        update
            lot
            lot1
            part
            part1
            site
            site1
            line
            line1
            reason
            reason1
            wkctr
            wkctr1
            mch
            mch1
            dept
            dept1
            shift
            shift1
            emp
            emp1
            effdate
            effdate1
        with frame a.

        {wbrp06.i &command = update 
            &fields = "  lot lot1 part part1 site site1 line line1 reason reason1 wkctr wkctr1 mch mch1 dept dept1 shift shift1 emp emp1 effdate effdate1" 
            &frm = "a"
        }

        if (c-application-mode <> 'web':u) or
            (c-application-mode = 'web':u and
            (c-web-request begins 'data':u)) then 
        do:



            bcdparm = "".
            {mfquoter.i lot}
            {mfquoter.i lot1}
            {mfquoter.i part}
            {mfquoter.i part1}
            {mfquoter.i site}
            {mfquoter.i site1}
            {mfquoter.i line}
            {mfquoter.i line1}
            {mfquoter.i reason}
            {mfquoter.i reason1}
            {mfquoter.i wkctr}
            {mfquoter.i wkctr1}
            {mfquoter.i mch}
            {mfquoter.i mch1}
            {mfquoter.i dept}
            {mfquoter.i dept1}
            {mfquoter.i shift}
            {mfquoter.i shift1}
            {mfquoter.i emp}
            {mfquoter.i emp1}
            {mfquoter.i effdate}
            {mfquoter.i effdate1}

            if lot1 = "" then lot1 = hi_char.
            if part1 = "" then part1 = hi_char.
            if site1 = "" then site1 = hi_char.
            if line1 = "" then line1 = hi_char.
            if reason1 = "" then reason1 = hi_char.
            if wkctr1 = "" then wkctr1 = hi_char.
            if mch1 = "" then mch1 = hi_char.
            if dept1 = "" then dept1 = hi_char.
            if shift1 = "" then shift1 = hi_char.
            if emp1 = "" then emp1 = hi_char.
            if effdate = ? then effdate = low_date.
            if effdate1 = ? then effdate1 = hi_date.

        end.

{mfselbpr.i "printer" 132}
{mfphead.i}

form  with frame detail width 200 no-box down.


for each op_hist no-lock
    where op_hist.op_domain = global_domain 
    and op_wo_lot >= lot and op_wo_lot <= lot1
    and op_part >= part and op_part <= part1
    and op_site >= site and op_site <= site1
    and op_line >= line and op_line <= line1
    and op_rsn >= reason and op_rsn <= reason1
    and op_wkctr >= wkctr and op_wkctr <= wkctr1
    and op_mch >= mch and op_mch <= mch1
    and op_dept >= dept and op_dept <= dept1
    and op_shift >= shift and op_shift <= shift1
    and op_emp >= emp and op_emp <= emp1
    and op_date >= effdate and op_date <= effdate1
use-index op_date
break by op_site by op_line  by op_part by op_rsn
with width 132 no-box:

            qty_cumscrap = op__dec01.
            accumulate qty_cumscrap (total by op_site by op_line by op_part by op_rsn).
            accumulate op_qty_comp (total by op_site by op_line by op_part  by op_rsn).       
            

           if last-of(op_rsn)
               and (accum total by op_rsn   op_qty_comp) <> 0
           then do:

                percent_scrap = ((accum total by op_rsn qty_cumscrap) * 100) / (accum total by op_rsn op_qty_comp).

                find ln_mstr  where ln_mstr.ln_domain = global_domain and  ln_line  = op_line no-lock no-error.
                find pt_mstr where pt_domain = global_domain and pt_part = op_part no-lock no-error.
                find first rsn_ref where rsn_domain = global_domain and rsn_type = "scrap" and rsn_code = op_rsn no-lock no-error .
                v_rsn_desc = if avail rsn_ref then rsn_desc else "" .

                display
                    op_site                                 COLUMN-label "地点" 
                    op_line                                 COLUMN-label "生产线"    
                    ln_desc   when (available ln_mstr )     COLUMN-LABEL "生产线名"  
                    op_part                                 COLUMN-LABEL "零件号"  
                    pt_desc1  when (available pt_mstr )     COLUMN-LABEL "说明1"
                    pt_desc2  when (available pt_mstr )     COLUMN-LABEL "说明2"
                    op_rsn                                  COLUMN-LABEL "报废代码"
                    v_rsn_desc                              COLUMN-LABEL "报废说明"
                    (accum total by op_rsn  op_qty_comp) @ qty_cumproc    COLUMN-LABEL "已处理量"      
                    (accum total by op_rsn qty_cumscrap) @ qty_cumscrap   COLUMN-LABEL "废品数量"    
                    percent_scrap                                          COLUMN-LABEL "百分比"      
                with frame detail.                    
                down 1 with frame detail.
           end. /*if last-of(op_rsn)*/

           if last-of(op_line)
              and (accum total by op_line  op_qty_comp) <> 0
           then do:

                  percent_scrap = ((accum total by op_line qty_cumscrap) * 100) / (accum total by op_line op_qty_comp).
        
                  find ln_mstr  where ln_mstr.ln_domain = global_domain and  ln_line  = op_line  no-lock no-error.
                  display
                        op_site                                         COLUMN-label "地点" 
                        op_line                                         COLUMN-label "生产线"    
                        ln_desc   when (available ln_mstr )             COLUMN-LABEL "生产线名"  
                        "产线合计:"     @ op_part                       COLUMN-LABEL "零件号"  
                        (accum total by op_line op_qty_comp)  @ qty_cumproc    COLUMN-LABEL "已处理量"      
                        (accum total by op_line qty_cumscrap) @ qty_cumscrap   COLUMN-LABEL "废品数量"    
                        percent_scrap                                          COLUMN-LABEL "百分比"      
                  with frame detail.  
        
                  down 1 with frame detail.
           end. /*if last-of(op_line)*/

           if last-of(op_site)
              and (accum total by op_site  op_qty_comp) <> 0
           then do:

                 percent_scrap = ((accum total by op_site qty_cumscrap) * 100) / (accum total by op_site op_qty_comp).
        
                 display
                    op_site                                              COLUMN-label "地点" 
                    "地点总计:"  @ op_part                               COLUMN-LABEL "零件号"   
                    (accum total by op_site op_qty_comp)  @ qty_cumproc  COLUMN-LABEL "已处理量"      
                    (accum total by op_site qty_cumscrap) @ qty_cumscrap COLUMN-LABEL "废品数量"    
                     percent_scrap                                       COLUMN-LABEL "百分比"      
                 with frame detail.                    
        
                down 1 with frame detail.
           end. /*if last-of(op_site)*/
{mfrpchk.i}
end. /*for each op_hist*/

{mfrtrail.i}
end. /*repeat:*/
{wbrp04.i &frame-spec = a}
