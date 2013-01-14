/* $Revision: 1.8.1.22 $   BY: Jordan Lin       DATE: 06/25/12 ECO: *SS - 20120625.1* 
   转为excelreport输出 */
/* $Revision: eb21sp7 $   BY: Cosesa Yang       DATE: 01/04/13 ECO: *SS - 20130104.1* */

/* SS - 051002.1 - B */
DEFINE SHARED TEMP-TABLE tt1
    field tt1_site like IN_site
    field tt1_pl like ac_code
    field tt1_desc AS CHARACTER
    FIELD tt1_type AS CHARACTER
    field tt1_ext AS DECIMAL
    FIELD tt1_amt_dr LIKE gltr_amt
    FIELD tt1_amt_cr LIKE gltr_amt
    /* SS - 051011.1 - B */
    field tt1_qty_ext AS DECIMAL
    FIELD tt1_qty_dr LIKE gltr_amt
    FIELD tt1_qty_cr LIKE gltr_amt
    /* SS - 051011.1 - E */
    /* SS - 20121231.1 - B */
    field tt1_price_ext AS DECIMAL
    field tt1_price_dr  like gltr_amt
    field tt1_price_cr  like gltr_amt
    /* SS - 20121231.1 - E */
    /* SS - 20130104.1 - B */
    field tt1_price_ext-dr-cr as decimal
    /* SS - 20130104.1 - E */
    INDEX index1  IS UNIQUE
        tt1_site
        tt1_pl
        tt1_desc
        tt1_type
    .

{mfdeclre.i}

DEFINE VARIABLE v_comp AS CHARACTER.
DEFINE VARIABLE v_age_date AS CHARACTER.

define  SHARED variable as_of_date   like tr_effdate .
 /* SS - 20121231.1 - B */
define  SHARED variable as_of_date1   like tr_effdate .
 /* SS - 20121231.1 - E */
   
   FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = "~~reports" NO-LOCK NO-ERROR.
   IF AVAILABLE ad_mstr THEN DO:
       v_comp ="单位名称:" + ad_name.
   END.
   ELSE DO:
       v_comp = "".
   END.
   /* SS - 20121231.1 - B */
    /*    
   v_age_date = "(截止:" + STRING(YEAR(AS_of_date)) + "年" + STRING(MONTH(AS_of_date))+ "月" + STRING(DAY(AS_of_date)) + "日" + ")".
    */
   v_age_date = "(起始:" + string(year(AS_of_date1)) + "年" + STRING(MONTH(AS_of_date1))+ "月" + STRING(DAY(AS_of_date1)) + "日   " 
  
                + "截止:" + STRING(YEAR(AS_of_date)) + "年" + STRING(MONTH(AS_of_date))+ "月" + STRING(DAY(AS_of_date)) + "日" + ")".
  /* SS - 20121231.1 - E */

 /* *SS - 20120625.1* -B  */
	 PUT UNFORMATTED v_comp ";" v_age_date  SKIP.
 /* *SS - 20120625.1* -E  */

FOR EACH tt1
    NO-LOCK
    ,EACH pl_mstr
    WHERE pl_prod_line = tt1_pl AND pl_domain = GLOBAL_domain
    NO-LOCK
    BY tt1_site
    BY tt1_type
    BY tt1_pl
    :
    /* SS - 051011.1 - B */
    FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = tt1_desc NO-LOCK NO-ERROR.
    
    /* SS - 20130104.1 - B */
    /*
    IF AVAIL pt_mstr THEN
    EXPORT DELIMITER ";"  /* *SS - 20120625.1*  v_comp v_age_date  */ tt1_site  pl_desc tt1_desc (pt_desc1 + pt_desc2) (tt1_qty_ext - tt1_qty_dr - tt1_qty_cr) (tt1_ext - tt1_amt_dr - tt1_amt_cr) tt1_qty_dr tt1_amt_dr tt1_qty_cr tt1_amt_cr tt1_qty_ext tt1_ext.
    */
    IF AVAIL pt_mstr THEN do:
    if (tt1_qty_ext - tt1_qty_dr - tt1_qty_cr) <> 0 then 
    tt1_price_ext-dr-cr = absolute( (tt1_ext - tt1_amt_dr - tt1_amt_cr) / (tt1_qty_ext - tt1_qty_dr - tt1_qty_cr) ).

    EXPORT DELIMITER ";"  tt1_site  pl_desc tt1_desc (pt_desc1 + pt_desc2) 
    (tt1_qty_ext - tt1_qty_dr - tt1_qty_cr) tt1_price_ext-dr-cr (tt1_ext - tt1_amt_dr - tt1_amt_cr) 
    tt1_qty_dr tt1_price_dr tt1_amt_dr 
    /* SS - 130110.1 - B */
   /* tt1_qty_cr tt1_price_cr tt1_amt_cr */
    (tt1_qty_cr * ( -1 )) tt1_price_cr (tt1_amt_cr * ( -1 ))
    /* SS - 130110.1 - E */
    tt1_qty_ext tt1_price_ext tt1_ext.
    end.
    /* SS - 20130104.1 - E */

    /* SS - 051011.1 - E */
/* *SS - 20120625.1* -B  */
   ACCUMULATE  tt1_ext - tt1_amt_dr - tt1_amt_cr (TOTAL).
   ACCUMULATE  tt1_amt_dr (TOTAL).
   ACCUMULATE  tt1_amt_cr   (TOTAL).
   ACCUMULATE  tt1_ext  (TOTAL).
/* *SS - 20120625.1* -E  */
END.
/* SS - 051002.1 - E */
/* *SS - 20120625.1* -B  */
         /* SS - 20121231.1 -B */
	 /*
	 PUT UNFORMATTED "; ; ;合计:;;"  (ACCUM TOTAL tt1_ext - tt1_amt_dr - tt1_amt_cr) "; ;"
	                                 (ACCUM TOTAL tt1_amt_dr) "; ;" 
					 (ACCUM TOTAL tt1_amt_cr) "; ;" 
					 (ACCUM TOTAL tt1_ext)  SKIP.
        */
	 PUT UNFORMATTED "; ; ;合计:;;;"  (ACCUM TOTAL tt1_ext - tt1_amt_dr - tt1_amt_cr) "; ; ;"
	                                 (ACCUM TOTAL tt1_amt_dr) "; ; ;" 
					 /* SS - 130110.1 - B */
					 /* (ACCUM TOTAL tt1_amt_cr) ) "; ; ;"  */
					( -1 * (ACCUM TOTAL tt1_amt_cr) ) "; ; ;" 
					/* SS - 130110.1 - E */
					 (ACCUM TOTAL tt1_ext)  SKIP.
	/* SS - 20121231.1 -E */
	  /* *SS - 20120625.1* -E  */                                