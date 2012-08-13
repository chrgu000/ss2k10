/* xkinqrct.p                 收货单报表                  */

{mfdtitle.i "ao "}

define variable part        like pt_part .
define variable part1       like pt_part .
define variable site        like si_site .
define variable site1       like si_site .
define variable loc         like xkro_loc .
define variable loc1        like xkro_loc .
define variable dsite       like xkro_dsite .
define variable dsite1      like xkro_dsite .
define variable dloc        like xkro_dloc .
define variable dloc1       like xkro_dloc .
define variable supplier    like xkro_supplier .
define variable supplier1   like xkro_supplier .
define variable dat         like xkro_ord_date .
define variable dat1        like xkro_ord_date .
define variable xnbr        like xkro_nbr .
define variable xnbr1       like xkro_nbr .
define variable rnbr        like xkprh_nbr .
define variable rnbr1       like xkprh_nbr .
define variable effdat      like xkprh_eff_date .
define variable effdat1     like xkprh_eff_date .

define variable des         as   character label "描述" format "x(48)" .

form
    xnbr         colon 20  
    xnbr1        colon 45 label {t001.i} 
    rnbr         colon 20  
    rnbr1        colon 45 label {t001.i} 
    dat          colon 20  
    dat1         colon 45 label {t001.i} 
    effdat       colon 20  
    effdat1      colon 45 label {t001.i} 
    part         colon 20  
    part1        colon 45 label {t001.i} 
    site         colon 20
    site1        colon 45 label {t001.i}
    loc          colon 20
    loc1         colon 45 label {t001.i}
    dsite        colon 20
    dsite1       colon 45 label {t001.i}
    dloc         colon 20
    dloc1        colon 45 label {t001.i}  
    supplier     colon 20  
    supplier1    colon 45 label {t001.i} 
    skip(1)

with frame a width 80 side-labels attr-space .


repeat:

   if part1 = hi_char then part1 = "" .
   if site1 = hi_char then site1 = "" .
   if loc1 = hi_char then loc1 = "" .
   if dsite1 = hi_char then dsite1 = "" .
   if dloc1 = hi_char then dloc1 = "" .
   if supplier1 = hi_char then supplier1 = "" .
   if xnbr1 = hi_char then xnbr1 = "" .
   if rnbr1 = hi_char then rnbr1 = "" .
   if dat1 = hi_date then dat1 = ? .
   IF dat = low_date THEN dat = ? .
   if effdat1 = hi_date then effdat1 = ? .
   IF effdat = low_date THEN effdat = ? .
   
   update  xnbr xnbr1 rnbr rnbr1 dat dat1 effdat effdat1 part part1
           site site1 loc loc1 dsite dsite1 dloc dloc1 supplier supplier1
   with frame a .
   
   bcdparm = "".
   
   {mfquoter.i part   }
   {mfquoter.i part1   }
   {mfquoter.i site   }
   {mfquoter.i site1   }
   {mfquoter.i xnbr   }
   {mfquoter.i xnbr1   }
   {mfquoter.i rnbr   }
   {mfquoter.i rnbr1   }
   {mfquoter.i dsite  }
   {mfquoter.i dsite1   }
   {mfquoter.i dloc1   }
   {mfquoter.i dloc  }
   {mfquoter.i dat1   }
   {mfquoter.i dat  }
   {mfquoter.i effdat1   }
   {mfquoter.i effdat  }
   {mfquoter.i supplier   }
   {mfquoter.i supplier1  }
   {mfquoter.i loc1   }
   {mfquoter.i loc  }
   
   
   if part1 = "" then part1 = hi_char .
   if site1 = "" then site1 = hi_char .
   if loc1 = "" then loc1 = hi_char .
   if supplier1 = "" then supplier1 = hi_char .
   IF dloc1 = "" THEN dloc1 = hi_char .
   IF dat1 = ? THEN dat1 = hi_date .
   IF dat = ? THEN dat = low_date .
   IF xnbr1 = "" THEN xnbr1 = hi_char .
   IF dsite1 = "" THEN dsite1 = hi_char .
   IF effdat1 = ? THEN effdat1 = hi_date .
   IF effdat = ? THEN effdat = low_date .
   IF rnbr1 = "" THEN rnbr1 = hi_char .
   
   {mfselbpr.i "printer" 132}
   
   {mfphead.i}
   
   FOR EACH po_mstr WHERE (po_ord_date <= dat1 AND po_ord_date >= dat) 
       AND (po_type <> 'b' )
       AND (po_nbr >= xnbr AND po_nbr <= xnbr1)
       AND (po_site >= dsite AND po_site <= site1)
       AND (po_vend >= supplier AND po_vend <= supplier1)
       AND (po_ship >= dloc AND po_ship <= dloc1)  NO-LOCK :
   
       FOR EACH prh_hist WHERE prh_nbr = po_nbr 
           AND (prh_part >= part AND prh_part <= part1) 
           AND (prh_rcp_date >= effdat AND prh_rcp_date <= effdat1) 
           AND (prh_nbr >= rnbr AND prh_nbr <= rnbr1)NO-LOCK :
           FIND pt_mstr WHERE pt_part = prh_part NO-LOCK NO-ERROR .
           IF AVAILABLE pt_mstr THEN des = pt_desc1 + pt_desc2 .
   
           DISPLAY po_nbr @ xkro_nbr po_vend @ xkro_supplier po_ord_date @ xkro_ord_date  po_site @ xkro_site po_ship @ xkro_dloc
            po_stat @ xkro_status prh_line @ xkprh_line prh_part @ xkprh_part des @ des prh_receiver @ xkprh_nbr prh_rcvd @ xkprh_qty prh_rcp_date @ xkprh_rct_date 
               WITH FRAME d DOWN WIDTH 255 STREAM-IO.
       END.
   END.
   
   FOR EACH xkro_mstr WHERE (xkro_ord_date <= dat1 AND xkro_ord_date >= dat) 
       AND (xkro_nbr >= xnbr AND xkro_nbr <= xnbr1)
       AND (xkro_site >= site AND xkro_site <= site1)
       AND (xkro_loc >= loc AND xkro_loc <= loc1)
       AND (xkro_dsite >= dsite AND xkro_dsite <= dsite1)
       AND (xkro_dloc >= dloc AND xkro_dloc <= dloc1)
       AND (xkro_supplier >= supplier AND xkro_supplier <= supplier1)
       AND (xkro_type <> 'p') NO-LOCK :
   
   
       FOR EACH xkprh_hist WHERE xkprh_po_nbr = xkro_nbr 
           AND (xkprh_part >= part AND xkprh_part <= part1) 
           AND (xkprh_eff_date >= effdat AND xkprh_eff_date <= effdat1) 
           AND (xkprh_nbr >= rnbr AND xkprh_nbr <= rnbr1)NO-LOCK :
           FIND pt_mstr WHERE pt_part = xkprh_part NO-LOCK NO-ERROR .
           IF AVAILABLE pt_mstr THEN des = pt_desc1 + pt_desc2 .
   
           DISPLAY xkro_nbr xkro_supplier xkro_ord_date xkro_user xkro_site xkro_loc
            xkro_dsite xkro_dloc xkro_urgent xkro_status xkprh_line xkprh_part des xkprh_nbr xkprh_qty xkprh_rct_date 
               xkprh_eff_date WITH FRAME e DOWN WIDTH 255 STREAM-IO.
       END.
   
   END.
   
   
   {mfrtrail.i}
   
end .

