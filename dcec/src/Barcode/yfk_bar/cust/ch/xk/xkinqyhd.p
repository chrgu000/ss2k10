
/*-------------------------------------------------------------------
  File         xkinqyhd.p
  Description  pick list print/要货单报表
  Author       Cai Jin
  Notes
  History
         2004-6-17, Yang Enping, 0003
	     Add window time output

 -------------------------------------------------------------------*/

{mfdtitle.i "AO"}

DEFINE VARIABLE part LIKE pt_part .
DEFINE VARIABLE part1 LIKE pt_part .
DEFINE VARIABLE site LIKE si_site .
DEFINE VARIABLE site1 LIKE si_site .
DEFINE VARIABLE loc LIKE xkro_loc .
DEFINE VARIABLE loc1 LIKE xkro_loc .
DEFINE VARIABLE dsite LIKE xkro_dsite .
DEFINE VARIABLE dsite1 LIKE xkro_dsite .
DEFINE VARIABLE dloc LIKE xkro_dloc LABEL "目的超市".
DEFINE VARIABLE dloc1 LIKE xkro_dloc .
DEFINE VARIABLE supplier LIKE xkro_supplier .
DEFINE VARIABLE supplier1 LIKE xkro_supplier .
DEFINE VARIABLE dat LIKE xkro_ord_date .
DEFINE VARIABLE dat1 LIKE xkro_ord_date .
DEFINE VARIABLE xnbr LIKE xkro_nbr .
DEFINE VARIABLE xnbr1 LIKE xkro_nbr .
DEFINE VARIABLE duedate LIKE xkro_due_date.
DEFINE VARIABLE duedate1 LIKE xkro_due_date.
DEFINE VARIABLE vddesc LIKE vd_sort FORMAT "x(10)" LABEL "供应商".
DEFINE VARIABLE potype AS CHAR INITIAL "P" FORMAT "x(1)" LABEL "要货单类型P/T/J".
DEFINE VARIABLE openonly AS LOGICAL LABEL "未结".
DEFINE VARIABLE des AS CHARACTER LABEL "描述" FORMAT "x(48)" .

form
    xnbr        colon 20  
    xnbr1       colon 45 label {t001.i} 
    dat         colon 20  
    dat1        colon 45 label {t001.i} 
    duedate         colon 20  
    duedate1        colon 45 label {t001.i} 
    part        colon 20  
    part1       colon 45 label {t001.i} 
    site        colon 20
    site1       colon 45 label {t001.i}
    loc         colon 20
    loc1        colon 45 label {t001.i}
    dsite       colon 20
    dsite1      colon 45 label {t001.i}
    dloc        colon 20
    dloc1       colon 45 label {t001.i}  
    supplier    colon 20  
    supplier1   colon 45 label {t001.i}
    potype      COLON 20
    openonly    COLON 45
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
   if dat1 = hi_date then dat1 = ? .
   IF dat = low_date THEN dat = ? .
   IF duedate = low_date THEN duedate = ? .
   if duedate1 = hi_date then duedate1 = ? .
   
   update xnbr xnbr1 dat dat1 duedate duedate1 part part1 site site1 loc loc1
          dsite dsite1 dloc dloc1 supplier supplier1 potype openonly
   with frame a .
   
   bcdparm = "".
   
   {mfquoter.i part   }
   {mfquoter.i part1   }
   {mfquoter.i site   }
   {mfquoter.i site1   }
   {mfquoter.i xnbr   }
   {mfquoter.i xnbr1   }
   {mfquoter.i dsite  }
   {mfquoter.i dsite1   }
   {mfquoter.i dloc1   }
   {mfquoter.i dloc  }
   {mfquoter.i dat1   }
   {mfquoter.i dat  }
   {mfquoter.i duedate  }
   {mfquoter.i duedate1   }
   {mfquoter.i supplier   }
   {mfquoter.i supplier1  }
   {mfquoter.i loc1   }
   {mfquoter.i loc  }
   {mfquoter.i potype  }
   
   if part1 = "" then part1 = hi_char .
   if site1 = "" then site1 = hi_char .
   if loc1 = "" then loc1 = hi_char .
   if supplier1 = "" then supplier1 = hi_char .
   IF dloc1 = "" THEN dloc1 = hi_char .
   IF dat1 = ? THEN dat1 = hi_date .
   IF dat = ? THEN dat = low_date .
   IF duedate1 = ? THEN duedate1 = hi_date .
   IF duedate = ? THEN duedate = low_date .
   IF xnbr1 = "" THEN xnbr1 = hi_char .
   IF dsite1 = "" THEN dsite1 = hi_char .
   
   {mfselbpr.i "printer" 132}
   
   {mfphead.i}
   
   FOR EACH xkro_mstr WHERE (xkro_ord_date <= dat1 AND xkro_ord_date >= dat) 
       AND (xkro_due_date >= duedate AND xkro_due_date <= duedate1)
       AND (xkro_nbr >= xnbr AND xkro_nbr <= xnbr1)
       AND (xkro_site >= site AND xkro_site <= site1)
       AND (xkro_loc >= loc AND xkro_loc <= loc1)
       AND (xkro_dsite >= dsite AND xkro_dsite <= dsite1)
       AND (xkro__chr02 >= dloc AND xkro__chr02 <= dloc1)
       AND (xkro_supplier >= supplier AND xkro_supplier <= supplier1) 
       AND xkro_type = potype 
       AND (IF openonly THEN xkro_status = '' ELSE YES) NO-LOCK :
       
       vddesc = ''.
       FOR EACH xkrod_det WHERE xkrod_nbr = xkro_nbr 
           AND (xkrod_part >= part AND xkrod_part <= part1) NO-LOCK
           WITH FRAME d DOWN WIDTH 255 STREAM-IO  :
           FIND pt_mstr WHERE pt_part = xkrod_part NO-LOCK NO-ERROR .
           IF AVAILABLE pt_mstr THEN des = pt_desc1 + pt_desc2 .
           FIND vd_mstr WHERE vd_addr = xkro_supplier NO-LOCK NO-ERROR.
           IF AVAILABLE vd_mstr THEN vddesc = vd_sort.
           IF potype = 'P' THEN DO:
               DISPLAY xkro_nbr vddesc 
       	        xkro_ord_date 
           		/*0003*----*/
           		string(xkro_ord_time,"HH:MM")
           		xkro_due_date
           		string(xkro_due_time,"HH:MM")
           		/*----*0003*/
           		/*xkro_user xkro_site xkro_loc
                       xkro_dsite xkro_dloc */ xkro_urgent xkro_status 
       		
           		xkrod_line xkrod_part des FORMAT "x(18)" xkrod_qty_ord xkrod_rct_date string(xkrod_rcd_time,"HH:MM") 
                           xkrod_qty_rcvd xkrod_status WITH FRAME d .
           END.
           ELSE DO:

            DISPLAY xkro_nbr /*vddesc*/ 
       	        xkro_ord_date 
       		/*0003*----*/
       		string(xkro_ord_time,"HH:MM")
       		xkro_due_date
       		string(xkro_due_time,"HH:MM")
       		/*----*0003*/
       		/*xkro_user xkro_site*/ xkro_loc
                       /*xkro_dsite*/ xkro__chr02 LABEL "超市"  xkro_urgent xkro_status 
       		
       		xkrod_line xkrod_part des FORMAT "x(18)" xkrod_qty_ord xkrod_rct_date string(xkrod_rcd_time,"HH:MM")
                       xkrod_qty_rcvd xkrod_status WITH FRAME e DOWN WIDTH 255 STREAM-IO .
           END.
           
       END.
   
   END.
   
   
   {mfrtrail.i}
   
end .

   

