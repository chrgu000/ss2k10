/*########################################################################
    Copyright  ST Kinetics., Singapore.
    All rights reserved worldwide.

      Program ID  : s7nsar.p (developed for China Plant)
           Author : Niranjan Sangapur
   Service Req. No: mfg/ni/0255
               On : 24-May-06
       Description: It is (copy of s6nsar.p 6.13.5.12 Monthly Stock 
                    Aging Summary) 
                    changed to report for single site, removed line counters 
                    & sl. no.
##########################################################################*/
{mfdtitle.i "1.0"}

DEF var pline LIKE pt_prod_line.
DEF var pline1 LIKE pt_prod_line.
DEF var d AS intege.
DEF var dd1 LIKE d.
DEF var dd2 LIKE d.
DEF var dd3 LIKE d.
DEF var dd5 LIKE d.
DEF var qty1 AS DEC.
DEF var qty2 AS DEC.
DEF var qty3 AS DEC.
DEF var qty4 AS DEC.
DEF var val1 AS dec FORMAT ">>>,>>>,>>9.99".
DEF var val2 LIKE val1.
DEF var val3 LIKE val1.
DEF var val4 LIKE val1.
DEF var totq as dec format ">,>>>,>>>,>>9.99".
DEF var totv as dec format ">,>>>,>>>,>>9.99".
DEF var filler AS char FORMAT "x(100)".
def var cod as date label "Cut-Off Date".

filler = FILL("-",100).
assign filler = fill("-",100)
       d   = 270
       dd1 = 90
       dd2 = 360
       dd3 = 360 
       cod = today.
FORM
  pline  COLON 30
  pline1 COLON 50 LABEL {t001.i} SKIP(1)
  d COLON 15   label "Column Days[1]"
  dd1 label "[2]"
  dd2 label "[3]"
  dd3 label "[4]"
  SKIP
  WITH FRAME a side-labels width 80.

repeat :
  if pline = "0000" then
     pline = "".
  if pline1 = hi_char then pline1 = "".
  ASSIGN
    qty1 = 0.0
    qty2 = 0.0
    qty3 = 0.0
    qty4 = 0.0
    val1 = 0.0
    val2 = 0.0
    val3 = 0.0
    val4 = 0.0
    totq = 0.0
    totv = 0.0.
  UPDATE pline pline1 d dd1 dd2 dd3 WITH FRAME a width 80.

  bcdparm = "".
  {mfquoter.i pline}
  {mfquoter.i pline1}
  {mfquoter.i d }
  {mfquoter.i dd1}
  {mfquoter.i dd2}
  {mfquoter.i dd3} 

  IF pline = " " THEN pline = "0000".
  IF pline1 = " " THEN pline1 = hi_char.

  {mfselbpr.i "printer" 132}
  {mfphead.i}

 FORM HEADER
   space(50)         "Stock Ageing Report as of" cod space(2) SKIP
   "Prod"       SPACE(40)              
   "<" + string(d)    SPACE(18)
   string(dd1)  SPACE(18)
   string(dd2)  SPACE(16)
   ">Beyond"     SPACE(28)
  "Total"       SKIP
  "Line Desc                            Qty           Val.        Qty"
  + "           Val.        Qty           Val.        Qty           Val."
  + "              Qty             Val."
  WITH FRAME ccc NO-LABELS width 250 page-top.
  
  VIEW FRAME ccc.
  for each pt_mstr no-lock use-index pt_prod_part
     where pt_prod_line >= pline
       and pt_prod_line <= pline1
    , each in_mstr no-lock
     where in_part = pt_part
    , each ld_det no-lock use-index ld_part_loc
     where ld_part = in_part
       and ld_site = in_site
       break by pt_prod_line:

    {gpsct03.i &cost=sct_cst_tot }

      IF ld_date > (cod - d) AND ld_date <= cod THEN
        assign 
        qty1 = qty1 + ld_qty_oh
        val1 = val1 + (ld_qty_oh * glxcst).
      ELSE IF ld_date > (cod - (dd1 + d)) AND ld_date <= (cod - d) THEN
      ASSIGN
        qty2 = qty2 + ld_qty_oh
        val2 = val2 + (ld_qty_oh * glxcst).  
      ELSE IF ld_date > (cod - (dd2 + dd1 + d)) AND 
              ld_date <= (cod - (dd1 + d)) THEN
        ASSIGN 
        qty3 = qty3 + ld_qty_oh
        val3 = val3 + (ld_qty_oh * glxcst).
      ELSE IF ld_date <= (cod - (dd2 + dd1 + d)) THEN
        ASSIGN
        qty4 = qty4 + ld_qty_oh
        val4 = val4 + (ld_qty_oh * glxcst).

      IF LAST-OF (pt_prod_line) THEN
      DO:
         find pl_mstr where pl_prod_line = pt_prod_line no-lock.
           totq = qty1 + qty2 + qty3 + qty4.
           totv = val1 + val2 + val3 + val4.
           
         if (totq <> 0.0 or totv <> 0.0) then 
         DISP 
              pt_prod_line 
              pl_desc format "x(24)"
              qty1 
              val1  
              qty2 
              val2 
              qty3 
              val3 
              qty4 
              val4
              totq 
              totv
         WITH width 200 NO-LABELS.
        
         accumulate qty1 (total).
         accumulate qty2 (total).
         accumulate qty3 (total).
         accumulate qty4 (total).
         accumulate totq (total).
         accumulate val1 (total).
         accumulate val2 (total).
         accumulate val3 (total).
         accumulate val4 (total).
         accumulate totv (total).
        
         ASSIGN
           qty1 = 0.0
           qty2 = 0.0
           qty3 = 0.0
           qty4 = 0.0
           val1 = 0.0
           val2 = 0.0
           val3 = 0.0
           val4 = 0.0
           totq = 0.0
           totv = 0.0.
      END.
   
    /*Disp grand (report) total*/
    if last(pt_prod_line) then
    do:
      underline qty1 qty2 qty3 qty4 totq
                       val1 val2 val3 val4 totv.
      DISP "REPORT TOTAL "   @ pl_desc
           accum total val1 @ val1 
           accum total val2 @ val2
           accum total val3 @ val3
           accum total val4 @ val4
           accum total totv @ totv
           accum total qty1 @ qty1 
           accum total qty2 @ qty2
           accum total qty3 @ qty3
           accum total qty4 @ qty4
           accum total totq @ totq           
          WITH width 200 NO-LABELS.
      underline qty1 qty2 qty3 qty4 totq
                      val1 val2 val3 val4 totv.
    end. /*if last(pt_prod_line) */
END.  /* for each ld_det */
{mfrtrail.i}
end. /*repeat */
