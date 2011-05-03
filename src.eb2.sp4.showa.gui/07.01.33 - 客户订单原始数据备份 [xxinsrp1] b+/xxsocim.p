/* Revision: eb2sp4      BY: Micho Yang     DATE: 07/26/06  ECO: *SS - 20060726.1* */

{mfdtitle.i "2+ "}
   
    /*
&SCOPED-DEFINE PP_FRAME_NAME A
      */

DEF VAR v_type1 LIKE xxsod_type.
DEF VAR v_cust LIKE xxsod_cust.
DEF VAR v_cust1 LIKE xxsod_cust.
DEF VAR v_week LIKE xxsod_week.
DEF VAR v_week1 LIKE xxsod_week .
DEF VAR fn_me AS CHAR FORMAT "x(30)" INIT "c:\so_err.txt" .
DEF VAR fn_ok AS CHAR FORMAT "x(30)" INIT "c:\so_ok.txt" .
DEF VAR fn_i AS CHAR .
DEF VAR i AS INTEGER .
DEF VAR j AS INTEGER .
DEF VAR v_tax LIKE pt_taxable .

DEF VAR v_flag AS LOGICAL.
DEF VAR v_type LIKE xxsod_type.
DEF VAR v_sort AS CHAR .
DEF VAR v_year AS CHAR.
DEF VAR v_month AS CHAR.
DEF VAR v_nbr AS CHAR.
DEF VAR v_flag_nbr AS CHAR.

DEF TEMP-TABLE tt 
    FIELD tt_type LIKE xxsod_type
    FIELD tt_cust LIKE xxsod_cust
    FIELD tt_project LIKE xxsod_project
    FIELD tt_week LIKE xxsod_week
    FIELD tt_ord_date AS CHAR
    FIELD tt_due_date LIKE xxsod_due_date1
    FIELD tt_part LIKE xxsod_part 
    FIELD tt_qty AS DECIMAL
    .
DEF TEMP-TABLE tte 
    FIELD tte_type1 AS CHAR
    FIELD tte_type AS CHAR
    FIELD tte_cust LIKE xxsod_cust
    FIELD tte_part LIKE xxsod_part
    FIELD tte_desc AS CHAR FORMAT "x(120)"
    .
DEF TEMP-TABLE tto
    FIELD tto_nbr LIKE so_nbr 
    .

FORM
    /*
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    */

    SKIP(1)
    v_type1  COLON 20    LABEL "类型"       
    v_cust  COLON 20    LABEL "客户"         v_cust1 colon 50 label {t001.i}
    v_week  colon 20    label "周次"         v_week1 colon 50 label {t001.i}
    fn_me   COLON 20    LABEL "导入出错的信息文件"
    fn_ok   COLON 20    LABEL "导入成功的信息文件"
    SKIP(1)
    with frame a side-labels width 80 ATTR-SPACE
    /* /* gui */ NO-BOX THREE-D /* gui */  */ .

/*
 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = ("导入客户订单的相关资料").
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

 /*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
 */

/* Main Repeat */
mainloop:
repeat :
  view frame a .

  IF v_cust1 = hi_char THEN v_cust1 = "".
  update 
      v_type1
      v_cust
      v_cust1
      v_week
      v_week1
      fn_me
      fn_ok
      with frame a.
  
  IF v_cust1 = "" THEN v_cust1 = hi_char.

  /* 文件的命名规则:SOyyyymmdd99 */
  i = 101.
  REPEAT :
      fn_i = "SO" + STRING(YEAR(TODAY))            + 
             SUBSTRING(STRING(100 + MONTH(TODAY)),2,2) + 
             SUBSTRING(STRING(100 + DAY(TODAY)),2,2)   + 
             SUBSTRING(STRING(i),2,2).
      IF SEARCH(fn_i + ".inp") = ? THEN DO:
          LEAVE.
      END.
      i = i + 1.
  END.
  
  FOR EACH tt:
      DELETE tt.
  END.
  FOR EACH tte:
      DELETE tte.
  END.

  for each xxsod_det no-lock WHERE (xxsod_type = v_type1 OR v_type1 = "" )
                               AND xxsod_cust >= v_cust 
                               AND xxsod_cust <= v_cust1 
                               AND (xxsod_week >= v_week OR v_week = 0)
                               AND (xxsod_week <= v_week1 OR v_week1 = 0)
                               AND xxsod__chr01 = "NO"
                             break by xxsod_type by xxsod_cust by xxsod_project
                                   BY xxsod_week BY substring(xxsod_rmks, index(xxsod_rmks, " " ) + 1)
                                   BY xxsod_due_date1 BY xxsod_part :
      ACCUMULATE xxsod_qty_ord ( TOTAL by xxsod_type by xxsod_cust by xxsod_project
                                    BY xxsod_week BY substring(xxsod_rmks, index(xxsod_rmks, " " ) + 1)
                                    BY xxsod_due_date1 BY xxsod_part ) .
      IF LAST-OF(xxsod_part) THEN DO:
          CREATE tt.
          ASSIGN
              tt_type = xxsod_type
              tt_cust = xxsod_cust
              tt_project = xxsod_project 
              tt_week = xxsod_week
              tt_ord_date = substring(xxsod_rmks, index(xxsod_rmks, " " ) + 1)
              tt_due_date = xxsod_due_date1
              tt_part = xxsod_part
              tt_qty = (ACCUMULATE TOTAL BY xxsod_part xxsod_qty_ord) 
              .
      END.     
  end. /* for each xxsod_det */

  v_flag = YES.
  FOR EACH tt NO-LOCK :
      FIND FIRST cp_mstr WHERE tt_cust = cp_cust AND tt_part = cp_cust_part NO-LOCK NO-ERROR.
      IF NOT AVAIL cp_mstr THEN DO:
          CREATE tte.
          ASSIGN
              tte_type1 = "零件"
              tte_type = "错误" 
              tte_cust = tt_cust
              tte_part = tt_part
              tte_desc = "客户零件对应未维护，请到(1.16)菜单进行维护。"
              .
          v_flag = NO.
      END.
      ELSE DO:
          ASSIGN 
              tt_part = cp_part 
              .
      END.

      FIND FIRST pi_mstr WHERE pi_cs_code = tt_cust AND pi_part_code = tt_part NO-LOCK NO-ERROR.
      IF NOT AVAIL pi_mstr THEN DO:
          CREATE tte .
          ASSIGN 
              tte_type1 = "零件" 
              tte_type = "警告" 
              tte_cust = tt_cust
              tte_part = tt_part
              tte_desc = "客户零件未找到报价信息，请在(1.10.1.1)菜单进行维护。"
              .
      END.
  END. /* for each tt no-lock */

  j = 0.
  FOR EACH tt NO-LOCK BREAK BY tt_type by tt_cust by tt_project BY tt_ord_date
                            BY tt_week :
      IF FIRST-OF(tt_week) THEN DO:
          FIND FIRST cm_mstr WHERE cm_addr = tt_cust NO-LOCK NO-ERROR.
          IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort,1,2) .

          v_year = SUBSTRING(tt_ord_date,4,1).
          IF SUBSTRING(tt_ord_date,5,2) = "01" 
             OR SUBSTRING(tt_ord_date,5,2) = "02"
             OR SUBSTRING(tt_ord_date,5,2) = "03"
             OR SUBSTRING(tt_ord_date,5,2) = "04"
             OR SUBSTRING(tt_ord_date,5,2) = "05"
             OR SUBSTRING(tt_ord_date,5,2) = "06"
             OR SUBSTRING(tt_ord_date,5,2) = "07"
             OR SUBSTRING(tt_ord_date,5,2) = "08"
             OR SUBSTRING(tt_ord_date,5,2) = "09" THEN v_month = SUBSTRING(tt_ord_date,6,1) .
          ELSE IF SUBSTRING(tt_ord_date,5,2) = "10" THEN v_month = "A".
          ELSE IF SUBSTRING(tt_ord_date,5,2) = "11" THEN v_month = "B".
          ELSE v_month = "C" .

          v_type = SUBSTRING(tt_project,1,1) .

          v_nbr = UPPER(v_sort + tt_type + v_year + v_month + v_type + string(tt_week)) .

          IF length(v_nbr, 'raw') > 8 THEN DO:
             CREATE tte.
             ASSIGN
                tte_type1 = "订单" 
                tte_type  = "错误"
                tte_cust = ""
                tte_part = v_nbr 
                tte_desc = "订单号超出长度"
                .
             v_flag = NO.
          END.

          v_flag_nbr = v_sort + v_year + v_month + v_type + string(tt_week) .

          FIND FIRST pj_mstr WHERE pj_project = tt_project NO-LOCK NO-ERROR.
          IF NOT AVAIL pj_mstr THEN DO:
              CREATE tte.
              ASSIGN
                  tte_type1 = "项目"
                  tte_type = "错误" 
                  tte_cust = tt_cust
                  tte_part = tt_project
                  tte_desc = "此项目在系统中不存在，请先到(25.3.11)维护项目代码。"
                  .
              v_flag = NO.
          END.

          FIND FIRST cm_mstr WHERE cm_addr = tt_cust NO-LOCK NO-ERROR.
          IF NOT AVAIL cm_mstr THEN DO:
              CREATE tte.
              ASSIGN
                  tte_type1 = "客户"
                  tte_type = "错误" 
                  tte_cust = tt_cust
                  tte_part = ""
                  tte_desc = "此客户代码在系统中不存在，请先到(2.1.1)维护项目代码。"
                  .
              v_flag = NO.
          END.

          FIND FIRST so_mstr WHERE so_nbr = v_nbr NO-LOCK NO-ERROR.
          IF AVAIL so_mstr THEN DO:
              CREATE tte.
              ASSIGN
                  tte_type1 = "订单"
                  tte_type = "错误" 
                  tte_cust = tt_cust
                  tte_part = so_nbr
                  tte_desc = "此订单已经存在于系统中。如果要重新导入此订单，请先到(7.1.1)中删除此订单，然后再执行订单导入程序。"
                  .
              v_flag = NO.
          END.
          ELSE DO:
              IF tt_type = "W" THEN DO:
                  FIND FIRST so_mstr WHERE SUBSTRING(so_nbr,1,2) + SUBSTRING(so_nbr,4,5) = v_flag_nbr NO-LOCK NO-ERROR.
                  IF AVAIL so_mstr THEN DO:
                      CREATE tte.
                      ASSIGN 
                          tte_type1 = "订单"
                          tte_type = "错误" 
                          tte_cust = tt_cust
                          tte_part = so_nbr
                          tte_desc = "此订单的月计划已经导入到系统中了。如果要导入此订单的周计划，请先到(7.1.1)中删除此订单，然后在执行订单导入程序。"
                          .
                      v_flag = NO.
                  END.
              END. /* if tt_type = "W" */
              ELSE IF tt_type = "M" THEN DO:
                  FIND FIRST so_mstr WHERE SUBSTRING(so_nbr,1,2) + SUBSTRING(so_nbr,4,5) = v_flag_nbr NO-LOCK NO-ERROR.
                  IF AVAIL so_mstr THEN DO:
                      CREATE tte.
                      ASSIGN 
                          tte_type1 = "订单"
                          tte_type = "错误" 
                          tte_cust = tt_cust
                          tte_part = so_nbr
                          tte_desc = "此订单的周计划已经导入到系统中了。如果要导入此订单的月计划，请先到(7.1.1)中删除此订单，然后在执行订单导入程序。"
                          .
                      v_flag = NO.
                  END.
              END.
          END. /* else do: */

         /* MESSAGE "aaa" + "---" + v_nbr  VIEW-AS ALERT-BOX. */
          OUTPUT TO VALUE(fn_i + ".inp") .
      END. /* IF FIRST-OF(xxsod_week) THEN DO: */

      /*
      FIND FIRST pt_mstr WHERE pt_part = tt_part NO-LOCK NO-ERROR.
      IF AVAIL pt_mstr THEN v_tax = pt_taxable .
        */
      find first ad_mstr where ad_addr = tt_cust no-lock no-error.
      if avail ad_mstr then v_tax = ad_taxable .

      IF v_flag = YES THEN DO:
          IF FIRST-OF(tt_week) THEN DO:
            /*  MESSAGE "bbb" + "---" + v_nbr VIEW-AS ALERT-BOX. */
 
              PUT             """" + trim(v_nbr) + """"      FORMAT "x(11)"    
                              SKIP
                              """" + TRIM(tt_cust) + """"    FORMAT "x(11)"
                              SKIP
                              " - " 
                              SKIP
                              " - "
                              SKIP
                              SUBSTRING(tt_ord_date,3,6)    FORMAT "x(11)" .    
    
              DO i = 1 TO 11 :
                  PUT " - " .
              END.
              PUT """" + TRIM(tt_project) + """" FORMAT "x(11)"  .
              DO i = 1 TO 9:
                  PUT " - " .
              END.
              PUT SKIP.
                             
              DO i = 1 TO 5 :
                  PUT " - ".
              END.
              PUT SKIP.
    
              DO i = 1 TO 13 :
                  PUT " - ".
              END.
              PUT SKIP.
          END. /*  IF FIRST-OF(xxsod_week) THEN DO: */

          PUT " - " 
              SKIP
              """" + TRIM(tt_part) + """"  FORMAT "x(23)"           /* part */
              SKIP
              " - "   /* 地点 */
              SKIP
              """" + TRIM(string(tt_qty)) + """"  FORMAT "x(14)"  /* 数量 */
              " - "                                /* 单位 */
              SKIP
              " - "                                /* 价格单 */
              SKIP
              " - "                                
              " - "  /* 折扣 */
              SKIP 
              " - "  /* 净价 */
              SKIP
              .

          DO i = 1 TO 14 :
              PUT " - " .
          END.
          PUT """" + substring(entry(1,tt_due_date,"-"),3,2) + string(int(entry(2,tt_due_date,"-" )),"99") + string(int(entry(3,tt_due_date,"-")),"99") + """" FORMAT "x(11)" .
          DO i = 1 TO 11:
              PUT " - " .
          END.
          PUT SKIP .

          IF v_tax = YES THEN DO:
              DO i = 1 TO 5 :
                  PUT " - " .
              END.
              PUT SKIP.
          END.

          IF LAST-OF(tt_week) THEN DO:
           /*   MESSAGE "last" + "---" + v_nbr VIEW-AS ALERT-BOX. */
             PUT "." 
                 "."
                 .
             DO i = 1 TO 8:
                 PUT " - " .
             END.
             PUT SKIP.

             DO i = 1 TO 17:
                 PUT " - " .
             END.
             PUT SKIP.
             PUT "." SKIP.

             OUTPUT CLOSE .
          END. /* IF LAST-OF(xxsod_week) THEN DO: */
      END. /* if v_flag = yes then do: */
      ELSE DO:
           IF LAST-OF(tt_week) THEN DO:
               OUTPUT CLOSE .
           END.
      END.

      IF LAST-OF(tt_week) AND v_flag = YES THEN DO:
         INPUT FROM VALUE( fn_i + ".inp") .
         OUTPUT TO VALUE(fn_i + ".cim") .
         batchrun = YES.
         {gprun.i ""sosomt.p""}
         batchrun = NO.
         INPUT CLOSE .
         OUTPUT CLOSE .

         j = j + 1.
         CREATE tto.
         ASSIGN 
             tto_nbr = v_nbr 
             .
      END.  /* if v_flag = yes */

      unix silent value("rm -rf " + trim(fn_i)  + ".inp").
      unix silent value("rm -rf " + trim(fn_i)  + ".cim").

  END. /* for each tt */

      OUTPUT TO VALUE (fn_me) .
      EXPORT DELIMITER ";" "类型" "错误类型" "客户代码" "订单/零件号" 
                           "错误描述" .
      FOR EACH tte :
          EXPORT DELIMITER ";" tte .
      END.
      OUTPUT CLOSE .

      OUTPUT TO VALUE(fn_ok) .
      EXPORT DELIMITER ";" "订单号" .
      FOR EACH tto :
          EXPORT DELIMITER ";" tto.
      END.
      OUTPUT CLOSE .

      MESSAGE "本次共导入" + string(j) + "条数据,请检查导出的信息文件以确认数据是否完整正确的导入到系统!" VIEW-AS ALERT-BOX.
      UNDO mainloop, RETRY mainloop. 
end. /* Main Repeat */
