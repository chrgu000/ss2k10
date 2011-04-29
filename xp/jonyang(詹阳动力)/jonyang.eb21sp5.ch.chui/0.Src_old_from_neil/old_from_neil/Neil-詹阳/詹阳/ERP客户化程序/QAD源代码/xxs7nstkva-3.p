/*########################################################################
    Copyright  ST Kinetics., Singapore.
    All rights reserved worldwide.

      Program ID  : s7nstkva.p    (for China plant)
           Author : Niranjan Sangapur
   Service Req. No: mfg/ni/0255
               On : 18-May-06
       Description: s7nstkva.p is a copy of s4nstkva.p 6.13.4.14 Monetary Value 
                    Report.Removed period,site from the program logic. It will 
                    report the entered  date range. Stock value is reported only 
                    if ISS/RCT/CYC-RCNT transactions  exists for for the 
                    entered range of Prod lines.
                    On 20-Jun-06. Added Summary/Detail report option 
##########################################################################*/
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */


{mfdtitle.i "1.1" } /*NTM*/
define variable m_line        like pt_prod_line       NO-UNDO.
define variable m_line1       like pt_prod_line       NO-UNDO.
/*VJ2*/ define variable stdt like tr_effdate        NO-UNDO.
/*VJ2*/ define variable endt like tr_effdate        NO-UNDO.
define variable pline like pt_prod_line             NO-UNDO.
define variable part  like pt_part                  NO-UNDO.
define variable rcvd_tot as dec                     NO-UNDO.
define variable stk_tot as dec                      NO-UNDO.
define variable iss_tot as dec                      NO-UNDO.
define variable ctr as int                          NO-UNDO.
define variable rtot like rcvd_tot                  NO-UNDO.
define variable stot like stk_tot                   NO-UNDO.
define variable itot like iss_tot                   NO-UNDO.
/*VJ1*/ define variable rtfg like rcvd_tot          NO-UNDO.
/*VJ1*/ define variable itfg as dec                     NO-UNDO.
def var m_ctr as int                                NO-UNDO.
/*Et2*/ define variable tmpqoh as dec          NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_i AS INTEGER             NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_monthname AS CHAR        NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_year      AS INTEGER FORMAT "9999" NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_j         AS INTEGER FORMAT "9999" NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_ret_qty   AS DECIMAL               NO-UNDO.
/*NTM*/ DEFINE VARIABLE g_ret_qty   AS DECIMAL               NO-UNDO.
/*Et3*/ DEFINE VARIABLE mm AS int   NO-UNDO.
/*Et3*/ DEFINE VARIABLE mm1 AS int  NO-UNDO.
/*Et3*/ DEFINE VARIABLE yy AS INTEGER FORMAT "9999" NO-UNDO.
/*Et3*/ DEFINE VARIABLE yy1 AS INTEGER FORMAT "9999" NO-UNDO.
def var rcvd_tot1 like rcvd_tot no-undo.
def var iss_tot1 like iss_tot no-undo.                
def var m_ret_qty1 like m_ret_qty no-undo.
def var stk_tot1 like stk_tot no-undo.
def var m_sumdet as log format "Summary/Detail" label "明细/汇总" no-undo.
def var m_opt as char format "x(3)" label "选择事务类型" no-undo.
DEFINE TEMP-TABLE w_file    
   field w_line         like pt_prod_line
   field w_type         as char format "x(1)"
   field w_site         like tr_site
   field w_qty_chg_iss  like tr_qty_chg 
   FIELD w_qty_chg_rct  LIKE tr_qty_chg 
   field w_qoh          like in_qty_oh
   FIELD w_returns      like in_qty_oh 
   field w_trnbr        like tr_trnbr
   field w_nbr                like tr_nbr
   field w_part                like tr_part
   field w_qty                like tr_qty_chg
   field w_efdt                like tr_effdate
   field w_trtype        like tr_type   
   INDEX  w_index1   
          w_line w_type.


form 
    m_line   colon 25  label "生产线"
    m_line1  colon 45 label {t001.i} 
    stdt     colon 25 label "生效日期"
    endt     colon 45 label {t001.i} SKIP(1)
    m_sumdet colon 35 
    m_opt    colon 35 "(RCT,ISS,RET,ALL)"
skip(1)
with frame a width 80 side-label .

setFrameLabels(frame a:handle).

ASSIGN m_line = "0000" m_line1 = "9999" stdt = today endt = today .
MAINLOOP: 
REPEAT: 
    assign rcvd_tot=0
           iss_tot=0        
           m_ret_qty=0
           stk_tot=0
           m_opt = "ALL".
    if m_line1 = hi_char then m_line1 = "" .
    if batchrun= no then
    do:
       update m_line 
                     m_line1 
              stdt 
                      validate (input stdt <> ? , 
                      "ERROR:Start-Date CANNOT BE BLANK. Please re-enter.")
              endt 
                      validate (input endt >= input stdt,
                      "ERROR:End-Date should be >= Start Date. Please re-enter" )
              m_sumdet  SKIP
        with frame a. 
       if m_sumdet=no then
       update m_opt
       validate(INPUT m_opt="RCT" or input m_opt="ISS" or input m_opt="RET" or input m_opt="ALL",
                       "ERROR: Invalid option. Pl Enter 'RCT', 'ISS', 'RET' or 'ALL'")
       with frame a.
    end.
    else 
    do:
       update  
           m_line     
           m_line1    
           stdt       
           endt       
           m_sumdet   
           m_opt
           with frame a.
    end.       
    
    bcdparm = "".
    {mfquoter.i m_line }
    {mfquoter.i m_line1 }
    {mfquoter.i stdt }
    {mfquoter.i endt }
    {mfquoter.i m_sumdet }
    {mfquoter.i m_opt }
    
    {mfselbpr.i "printer" 132}
    if m_line1 = "" then m_line1 = hi_char. 
    if stdt = ? then stdt = low_date.
    if endt = ? then endt = hi_date.        
   ASSIGN m_ctr  = 0.
   for each w_file.
     delete w_file.
   end.

   for each in_mstr
/*SS 20090207 - B*/
				where in_domain = global_domain
/*SS 20090207 - E*/
      ,each pt_mstr WHERE pt_part = in_part
/*SS 20090207 - B*/
									and pt_domain = global_domain
/*SS 20090207 - E*/
                 AND pt_prod_line >= m_line AND pt_prod_line <= m_line1:
      if (in_qty_oh + in_qty_nonet) = 0 then next.
      {gpsct03.i &cost=sct_cst_tot }           
      FIND FIRST w_file where w_type="1" and w_line = pt_prod_line no-error.        
      if not available w_file then 
      do:
         create w_file.
         assign 
                w_type           ="1"
                w_site     = in_site
                w_line     = pt_prod_line
                w_qoh      = 0.
      END. /* if not avail w_file */ 
      w_qoh = w_qoh + ((in_qty_oh + in_qty_nonet) * glxcst).     
   end. /*for each in_mstr*/
    
  FOR EACH tr_hist
        USE-INDEX tr_eff_trnbr
        NO-LOCK WHERE
/*SS 20090207 - B*/
					tr_domain = global_domain and 
/*SS 20090207 - E*/
            (tr_effdate >= stdt         )
        AND (tr_effdate <= endt         )
        AND (tr_trnbr = tr_trnbr        ) 
        AND (tr_type BEGINS "iss" OR tr_type BEGINS "rct" 
               OR tr_type = "CYC-RCNT")
        AND LOOKUP(tr_type,"RCT-CHL,ISS-CHL") = 0:
               
     ASSIGN m_ctr = m_ctr + 1 .
     IF ( m_ctr modulo  5000) = 0 THEN 
        PUT SCREEN ROW 20 " TR-HIST LOOP: " 
                        + " : Counter : " +  string(m_ctr,">>>,>>9").
   
     find first glc_cal no-lock where glc_start <= tr_effdate and 
/*SS 20090207 - B*/
					glc_domain = global_domain and
/*SS 20090207 - E*/
          glc_end >= tr_effdate use-index glc_start no-error.
     if available glc_cal then 
        assign m_i = glc_per
               m_year = glc_year.
   
     FOR FIRST pt_mstr WHERE pt_part = tr_part 
/*SS 20090207 - B*/
				and pt_domain = global_domain
/*SS 20090207 - E*/
     AND pt_prod_line >= m_line AND pt_prod_line <= m_line1 
     NO-LOCK :
     END. /* for first pt_mstr */
     IF NOT AVAILABLE pt_mstr THEN NEXT.
     
     FOR FIRST  w_file where w_type="1" and w_line = pt_prod_line: 
     END. /* for first w_file */
     
     if not available w_file then 
     do:
        create w_file.
        assign w_type         ="1" 
               w_site     = tr_site
               w_line     = pt_prod_line
               w_qoh      = 0.
     END. /* if not avail w_file */ 
     
     find in_mstr where in_part=tr_part and in_site=tr_site 
/*SS 20090207 - B*/
			and in_domain = global_domain
/*SS 20090207 - E*/     
     no-lock no-error.
     if avail in_mstr then
     do:
        {gpsct03.i &cost=sct_cst_tot } 
     end.         
     if tr_type begins "rct" then do:
        assign 
           w_qty_chg_rct  = w_qty_chg_rct  + (tr_qty_chg * tr_price).
     end. 
     else
     if tr_type begins "iss" then 
     do:
        IF (tr_type = "iss-so" and tr_qty_chg > 0 ) OR
           (tr_type = "iss-wo" and tr_qty_chg > 0 ) THEN
        ASSIGN
              w_returns = w_returns  + (tr_qty_chg * glxcst).
        ELSE 
        ASSIGN
              w_qty_chg_iss = w_qty_chg_iss + (tr_qty_chg * glxcst).
     end. /* tr_type begins 'iss' */
     
     if m_sumdet = yes then next.
     
     if m_opt="RCT" and tr_type begins "RCT" then
     do:
             create w_file.
             assign w_type         = "2"
                    w_line         = pt_prod_line
                    w_site         = tr_site
                    w_qty_chg_rct  = (tr_qty_chg * tr_price)
                    w_trnbr        = tr_trnbr
                    w_nbr          = tr_nbr        
                    w_part         = tr_part
                    w_qty          = tr_qty_chg
                    w_efdt         = tr_effdate
                    w_trtyp        = tr_type.
     end. 
     else if m_opt="RET" and 
          ((tr_type = "iss-so" and tr_qty_chg > 0) OR
           (tr_type = "iss-wo" and tr_qty_chg > 0)) THEN
     do:
             create w_file.
             assign w_type         = "2"
                    w_line         = pt_prod_line
                    w_site         = tr_site
                    w_qty_chg_rct  = (tr_qty_chg * glxcst)
                    w_trnbr        = tr_trnbr
                    w_nbr          = tr_nbr        
                    w_part         = tr_part
                    w_qty          = tr_qty_chg
                    w_efdt         = tr_effdate
                    w_trtyp        = tr_type.
     end.
     else if m_opt="ISS" and tr_type begins "ISS" then                         
     do:
        if (tr_type = "iss-so" and tr_qty_chg > 0) OR
           (tr_type = "iss-wo" and tr_qty_chg > 0) THEN
        NEXT.   
             create w_file.
             assign w_type         = "2"
                    w_line         = pt_prod_line
                    w_site         = tr_site
                    w_qty_chg_rct  = (tr_qty_chg * glxcst)
                    w_trnbr        = tr_trnbr
                    w_nbr          = tr_nbr        
                    w_part         = tr_part
                    w_qty          = tr_qty_chg
                    w_efdt         = tr_effdate
                    w_trtyp        = tr_type.
     end.
     else if m_opt="ALL" then
     do:
             create w_file.
             assign w_type         = "2"
                    w_line         = pt_prod_line
                    w_site         = tr_site
                    w_trnbr        = tr_trnbr
                    w_nbr          = tr_nbr        
                    w_part         = tr_part
                    w_qty          = tr_qty_chg
                    w_efdt         = tr_effdate
                    w_trtyp        = tr_type.
            if tr_type begins "RCT" then
                    w_qty_chg_rct  = (tr_qty_chg * tr_price). 
            else  w_qty_chg_rct  = (tr_qty_chg *  glxcst).
     end.
  end. /* for each tr_hist */

PUT "Report Period : From " stdt " To " endt  SKIP.
PUT "RUN Date :" TODAY " TIME : " STRING(TIME,"HH:MM:SS") SKIP.

for each w_file
    break BY w_line by w_type  : 
    if w_type="1" then
    do:        
       find first pl_mstr where pl_prod_line = w_line 
/*SS 20090207 - B*/
				and pl_domain = global_domain
/*SS 20090207 - E*/       
       no-lock no-error.
       Disp
           w_line             column-label "Product Line"
           (IF AVAIL pl_mstr THEN 
                   pl_desc   
                  ELSE "")         format "x(24)"   column-label "Desc"
           w_qty_chg_rct   format "->>>,>>>,>>9.99" Column-label "Receipt Value"
           w_qty_chg_iss   format "->>>,>>>,>>9.99" Column-label "Issue Value"
           w_returns       format "->>>,>>>,>>9.99" Column-label "Returns"
           w_qoh           format "->>>,>>>,>>9.99" 
                           Column-label "Stk Val as on Today"
           with frame fhead width 150 down.
       
       ASSIGN              
           rcvd_tot =rcvd_tot  + w_qty_chg_rct        
           iss_tot  =iss_tot   + w_qty_chg_iss        
           m_ret_qty=m_ret_qty + w_returns    
           stk_tot  =stk_tot   + w_qoh.
    end.
    else 
            DISP SPACE(3)
               w_trnbr                      
               w_nbr                      
               w_part                      
               w_qty                      
               w_efdt                      
               w_trtyp               
               w_qty_chg_rct   format "->>>,>>>,>>9.99" 
                                Column-label "Amount"            
               with frame fdet width 100 down.
end.   /* for each w_file */
 
disp    SKIP(1) with frame xx.
disp   "Report Total"  no-label space(26)
        rcvd_tot  format "->>>,>>>,>>9.99" column-label ""
        iss_tot   format "->>>,>>>,>>9.99" column-label ""
        m_ret_qty format "->>>,>>>,>>9.99" column-label ""
        stk_tot   format "->>>,>>>,>>>,>>9.99" 
            column-label "                   "
        with frame ftail width 200 down.
  {mfreset.i}
end. /* Repeat */
