/* SS - 090314.1 By: Bill Jiang */

/* SS - 050929.1 - B */

/* SS - 080505.1 */

/* 存货期末余额 */            
/* 存货期末余额 - 初始化临时表 */            

FOR EACH ttssppptrp0601:
    DELETE ttssppptrp0601.
END.

/* 存货期末余额 - 创建临时表 */  

{gprun.i ""ssppptrp0601.p"" "(
    INPUT part,
    INPUT part1,
    INPUT LINE,
    INPUT line1,
    INPUT vend,
    INPUT vend1,
    INPUT abc,
    INPUT abc1,
    INPUT site,
    INPUT site1,
    INPUT part_group,
    INPUT part_group1,
    INPUT part_type,
    INPUT part_type1,

    INPUT AS_of_date,
    INPUT neg_qty,
    INPUT net_qty,
    INPUT inc_zero_qty,
    INPUT zero_cost,
    INPUT customer_consign,
    INPUT supplier_consign
    )"}

/* 存货期末余额 - 写入临时表 */            
FOR EACH ttssppptrp0601:
    FIND FIRST tt1
        WHERE tt1_site = ttssppptrp0601_in_site
        AND tt1_pl = ttssppptrp0601_pl
        AND tt1_desc = ttssppptrp0601_pt_part
        AND tt1_type = "1"
        NO-LOCK
        NO-ERROR
        .
    IF NOT AVAILABLE tt1 THEN DO:
        CREATE tt1.
        ASSIGN
            tt1_site = ttssppptrp0601_in_site
            tt1_pl = ttssppptrp0601_pl
            tt1_type = "1"
            tt1_desc = ttssppptrp0601_pt_part
            .
    END.
    /* SS - 051012.1 - B */
/*apple    IF ttssppptrp0601_pl < "A" THEN DO:*/
       ASSIGN 
           tt1_ext = tt1_ext + ttssppptrp0601_ext
           tt1_qty_ext = tt1_qty_ext + ttssppptrp0601_total_qty_oh
           .
/*apple    END.*/
    /* SS - 051012.1 - E */
END.



/* 存货发生额 - 库存事务 */            
/* 存货发生额 - 库存事务 - 初始化临时表 */            
FOR EACH ttssictrrp0301:
    DELETE ttssictrrp0301.
END.
/* 存货发生额 - 库存事务 - 创建临时表 */ 
  {gprun.i ""ssictrrp0301.p"" "(
       INPUT part,
       INPUT part1,
       INPUT nbr,
       INPUT nbr1,
       INPUT so_job,
       INPUT so_job1,
       INPUT lot,
       INPUT lot1,
       INPUT loc,
       INPUT loc1,
        INPUT (AS_of_date - DAY(AS_of_date) + 1),
        INPUT AS_of_date,
        INPUT glref,
        INPUT glref1,
        INPUT entity,
        INPUT entity1,
        INPUT acct,
        INPUT acct1,
        INPUT sub,
        INPUT sub1,
        INPUT cc,
        INPUT cc1,
        INPUT proj,
        INPUT proj1,
        INPUT trdate,
        INPUT trdate1,
        INPUT trtype
    )"}


/*
{gprun.i ""a6ictrrp03.p"" "(
    INPUT (AS_of_date - DAY(AS_of_date) + 1),
    INPUT AS_of_date,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT "12110100",
    INPUT "12110100",
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dd,
    INPUT dd,
    INPUT dc
)"}




{gprun.i ""ssictrrp0301.p"" "(
    INPUT (AS_of_date - DAY(AS_of_date) + 1),
    INPUT AS_of_date,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT "12410000",
    INPUT "12410000",
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dd,
    INPUT dd,
    INPUT dc
)"}

{gprun.i ""a6ictrrp03.p"" "(
    INPUT (AS_of_date - DAY(AS_of_date) + 1),
    INPUT AS_of_date,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT "12430000",
    INPUT "12430000",
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dc,
    INPUT dd,
    INPUT dd,
    INPUT dc
)"}
*/


      
/* 存货发生额 - 库存事务 - 写入临时表 */            

FOR EACH ttssictrrp0301 NO-LOCK
   BREAK BY ttssictrrp0301_tr_trnbr 
   :
   FIND FIRST tt1
       /* SS - 080505.1
        WHERE tt1_site = ttssictrrp0301_site
        AND tt1_pl = ttssictrrp0301_pl
      */
        
        WHERE tt1_site = ttssictrrp0301_tr_site
        AND tt1_pl = ttssictrrp0301_tr_prod_line

        AND tt1_desc = ttssictrrp0301_tr_part
        AND tt1_type = "1"
        
        NO-LOCK
        NO-ERROR
        .
        
    IF NOT AVAILABLE tt1 THEN DO:
        CREATE tt1.
        ASSIGN
            tt1_site = ttssictrrp0301_tr_site
            tt1_pl = ttssictrrp0301_tr_prod_line
            tt1_type = "1"
            tt1_desc = ttssictrrp0301_tr_part
            .
    END.

   /* SS - 090314.1 - B
   /* SS - 051012.1 - B */
   /* SS - 080505.1
   IF ttssictrrp0301_pl < "A" THEN DO:
   */
   ASSIGN
      tt1_amt_dr = tt1_amt_dr + ttssictrrp0301_trgl_dr_amt
      tt1_amt_cr = tt1_amt_cr + ttssictrrp0301_trgl_dr_amt
      tt1_qty_dr = tt1_qty_dr + ttssictrrp0301_tr_qty_loc
      tt1_qty_cr = tt1_qty_cr + ttssictrrp0301_tr_qty_loc
      .
   /* SS - 080505.1 - E */
   /* SS - 051012.1 - E */
   SS - 090314.1 - E */
   
   /* SS - 090314.1 - B */
   IF ttssictrrp0301_tr_qty_loc >= 0 THEN DO:
      ASSIGN
         tt1_amt_dr = tt1_amt_dr + ttssictrrp0301_trgl_dr_amt
         .
   END.
   ELSE IF ttssictrrp0301_tr_qty_loc < 0 THEN DO:
      ASSIGN
         tt1_amt_cr = tt1_amt_cr + ttssictrrp0301_trgl_cr_amt
         .
   END.

   IF LAST-OF(ttssictrrp0301_tr_trnbr) THEN DO:
      IF ttssictrrp0301_tr_qty_loc >= 0 THEN DO:
         ASSIGN
            tt1_qty_dr = tt1_qty_dr + ttssictrrp0301_tr_qty_loc
            .
      END.
      ELSE IF ttssictrrp0301_tr_qty_loc < 0 THEN DO:
         ASSIGN
            tt1_qty_cr = tt1_qty_cr + ttssictrrp0301_tr_qty_loc
            .
      END.
   END.
   /* SS - 090314.1 - E */
END.

/* SS - 050929.1 - E */
