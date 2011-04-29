/*########################################################################
    Copyright  ST Kinetics., Singapore.
    All rights reserved worldwide.

      Program ID  : s7unrv.p    (for China plant)
           Author : Niranjan Sangapur
   Service Req. No: mfg/ni/0261
               On : 06-Jun-06
       Description: It is a copy of (s6tmp.p) 6.13.6.23 Receipts Unplanned. 
                    Added Trn. Nbr,Credit-acct,CC,Project & rmks in the report.
##########################################################################*/

 define variable line like pt_prod_line .
 define variable line1 like pt_prod_line.
 def var line2  like pt_prod_line.
 define variable site  like si_site initial "ZERO" .
 define variable pline like pt_prod_line .
 define variable part  like pt_part  .
 define variable part1 like part.
 define variable rcvd_tot as dec.
 def var endt1 like tr_date format "99/99/9999".
 def var stdt1 like endt1.
 def var st as char format "x(10)".
 def var et like st.
 def var rcvd_fg as dec .
 def var rcvd_sf as dec.
 def var rcvd_rm as dec.
 def var rcvd_ex as dec.
 def var sitot as decimal format ">>>,>>>,>>9.99".
 def var srtot like sitot.
 def var iss_fg as dec.
 def var iss_sf as dec.
 def var iss_rm as dec.
 def var iss_ex as dec.

 def var rfg as dec extent 12 format ">>,>>>,>>9.99".
 def var subfg like rfg.
 def var mrfg like rfg.
 def var rsf like rfg.
 def var rrm like rsf.
 def var rex like rrm.
 def var rbb like rex.
 def var ghfg as dec format ">>>,>>>,>>9.99".
 def var ghsf like ghfg.
 def var ghex like ghsf.
 def var ghrm like ghsf.
 def var grbb like ghrm.
 def var mgr like grbb.
 def var ifg like rfg.
 def var isf like ifg.
 def var irm like isf.
 def var iex like irm.
 def var ibb like iex.
 def var miex like mrfg.
 def var srfg as dec format ">>>,>>>,>>9.99".
 def var srsf like srfg.
 def var srex like srsf.
 def var srrm like srex.
 def var srbb like srrm.
 def var rctbb like srrm.
 def var sifg as dec format ">>>,>>>,>>9.99".
 def var sisf like sifg.
 def var siex like sisf.
 def var sirm like siex.
 def var sibb like siex.
 def var issbb like sirm.
 def var i as integer.
 def var desc1 like pl_desc.
 def var desc2 like pl_desc.
 def var desc3 like pl_desc.
 def var desc4 like pl_desc.
 def var desc5 like pl_desc.
 def var desc6 like pl_desc.
 def var retfg like rcvd_fg.
 def var retsf like retfg.
 def var retex like retsf.
 def var retrm like retsf.
 def var retbb like retrm.
 def var tfg like ifg.
 def var tsf like tfg.
 def var tex like tsf.
 def var trm like tsf.
 def var tbb like tsf.
 def var mtex like miex.
 def var sttot like sitot.
 def var stfg like sifg.
 def var stsf like stfg.
 def var stex like stsf.
 def var strm like stex.
 def var stbb like strm.
 define variable stk_tot as dec.
 define variable iss_tot as dec.
 define variable ctr as int .
 define variable rtot like rcvd_tot .
 define variable stot like stk_tot .
 define variable itot like iss_tot .
 define variable rtfg like rcvd_tot .
 def var rctmm as dec. 
 def var rmm as dec format ">>,>>>,>>9.99" extent 12.
 def var grmm like grbb.
 def var srmm like srbb.
 def var dt1 as int format ">>>9".
 def var dt2 like dt1.
 def var its1 as log format "Detail/Summary" Label "Detail/Summary"
 initial yes.
 def var logv as log.
 def var ghbb like ghfg.
 def var flg as log.
 def var loc like ld_loc.
 def var loc1 like ld_loc.
 def var cst1 as dec.
 def var filler1 as char format "x(180)".
 def var filler2 like filler1.
 def var pline1 like pt_prod_line.
 def var qtyall as dec.
 filler1 = fill("-",180).
 filler2 = fill("-",180).
{mfdtitle.i}

form 
    line  colon 15 
    line1 colon 45 label {t001.i} 
    loc  colon 15
    loc1 colon 45  label {t001.i}
    stdt1 colon 15
    endt1 colon 45 label {t001.i}
    site  colon 15
    skip(1)
with frame a width 80 side-label .

repeat :    
    if line1 = hi_char then line1 = "" .
    site = "10000".
    if endt1 = hi_date then endt1 = ?.
    if loc1 = hi_char then loc1 = "".
    if stdt1 = low_date then stdt1 = ?.

    update line line1 loc loc1 stdt1 endt1 site with frame a. 
                              
    bcdparm = "".
    {mfquoter.i line }
    {mfquoter.i line1 }
    {mfquoter.i stdt1 }
    {mfquoter.i endt1 }
    {mfquoter.i site }
    {mfquoter.i loc  }
    {mfquoter.i loc1 }
    {mfselbpr.i "printer" 132 }
    {mfphead2.i }
    if line1 = "" then line1 = hi_char. 
    if endt1 = ? then endt1 = hi_date.
    if loc1 = "" then loc1 = hi_char.
    if stdt1 = ? then stdt1 = low_date.
    i = 1.
    for each pt_mstr no-lock 
             where pt_prod_line >= line and pt_prod_line <= line1,
        each tr_hist no-lock where 
             tr_type = "rct-unp" and 
             tr_effdate >= stdt1 and tr_effdate <= endt1
             and tr_loc >= loc and tr_loc <= loc1
             and tr_site = site and tr_part = pt_part
        break by pt_prod_line by pt_part with frame cc:

       find first trgl_det where trgl_trnbr=tr_trnbr no-lock no-error.
       
       Disp pt_prod_line when first-of(pt_prod_line)
            pt_part  when first-of(pt_part) 
            pt_desc1 when first-of(pt_part) 
            tr_trnbr label "Tr No#"
            tr_qty_chg 
            tr_price label "Unit Cost" SPACE(5)
            trgl_cr_acct when avail trgl_det
            trgl_cr_cc   when avail trgl_det
            trgl_cr_proj when avail trgl_det
            tr_rmks
       with frame cc width 150 .
end.   
{mfrtrail.i}
end.


