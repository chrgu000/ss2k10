/* BY: Micho Yang      DATE: 07/31/06     ECO: *SS - 20060731.1*       */
/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

DEF VAR v_type LIKE xxsod_type.
DEF VAR v_cust LIKE xxsod_cust.
DEF VAR v_cust1 LIKE xxsod_cust.
DEF VAR v_project LIKE xxsod_project .
DEF VAR v_project1 LIKE xxsod_project .
DEF VAR v_vend LIKE xxsod_vend.
DEF VAR v_vend1 LIKE xxsod_vend.
DEF VAR v_addr LIKE xxsod_addr.
DEF VAR v_addr1 LIKE xxsod_addr.
DEF VAR v_part LIKE xxsod_part.
DEF VAR v_part1 LIKE xxsod_part .
DEF VAR v_due_date AS DATE .
DEF VAR v_due_date1 AS DATE .
DEF VAR v_invnbr LIKE xxsod_invnbr .
DEF VAR v_invnbr1 LIKE xxsod_invnbr .
DEF VAR v_week LIKE xxsod_week .
DEF VAR v_week1 LIKE xxsod_week.

         /* DISPLAY TITLE */
         {mfdtitle.i "b+ "} /*L00M*/


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/

    v_type       COLON 15    
    v_cust       COLON 15    v_cust1     label {t001.i} COLON 49 SKIP
    v_project    COLON 15    v_project1  LABEL {t001.i} COLON 49 SKIP
    v_vend       COLON 15    v_vend1     LABEL {t001.i} COLON 49 SKIP
    v_addr       COLON 15    v_addr1     LABEL {t001.i} COLON 49 SKIP
    v_part       COLON 15    v_part1     LABEL {t001.i} COLON 49 SKIP
    v_due_date   COLON 15    v_due_date1 LABEL {t001.i} COLON 49 SKIP
    v_invnbr     COLON 15    v_invnbr1   LABEL {t001.i} COLON 49 SKIP
    v_week       COLON 15    v_week1     LABEL {t001.i} COLON 49 SKIP

          SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

 /* SET EXTERNAL LABELS */
 setFrameLabels(frame a:handle).


         /* REPORT BLOCK */

         {wbrp01.i}

/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

        PROCEDURE p-enable-ui:
            
            IF v_cust1 = hi_char THEN v_cust1 = "".
            IF v_project1 = hi_char THEN v_project1 = "".
            IF v_vend1 = hi_char THEN v_vend1 = "".
            IF v_addr1 = hi_char THEN v_addr1 = "".
            IF v_part1 = hi_char THEN v_part1 = "".
            IF v_due_date = low_date THEN v_due_date = ? .
            IF v_due_date1 = hi_date THEN v_due_date1 = ?.
            IF v_invnbr1 = hi_char THEN v_invnbr1 = "" .

         if c-application-mode <> "WEB" then
         
         run p-action-fields (input "display").
         run p-action-fields (input "enable").
        end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/


        PROCEDURE p-report-quote:
            {wbrp06.i &command = update &fields = " 
                      v_type v_cust v_cust1 v_project v_project1 
                      v_vend v_vend1 v_addr v_addr1 v_part v_part1
                      v_due_date v_due_date1 v_invnbr v_invnbr1 
                      v_week v_week1 
             " &frm = "a"}

            if (c-application-mode <> 'web') or
               (c-application-mode = 'web' and
               (c-web-request begins 'data')) then do:

               bcdparm = "".
               {mfquoter.i v_type  }
               {mfquoter.i v_cust  }
               {mfquoter.i v_cust1  }
               {mfquoter.i v_project  }
               {mfquoter.i v_project1  }
               {mfquoter.i v_vend  }
               {mfquoter.i v_vend1  }
               {mfquoter.i v_addr  }
               {mfquoter.i v_addr1  }
               {mfquoter.i v_part }
               {mfquoter.i v_part1 }
               {mfquoter.i v_due_date }
               {mfquoter.i v_due_date1 }
               {mfquoter.i v_invnbr }
               {mfquoter.i v_invnbr1 }
               {mfquoter.i v_week }
               {mfquoter.i v_week1 }

            IF v_cust1 = "" THEN v_cust1 = hi_char.
            IF v_project1 = "" THEN v_project1 = hi_char.
            IF v_vend1 = "" THEN v_vend1 = hi_char.
            IF v_addr1 = "" THEN v_addr1 = hi_char.
            IF v_part1 = "" THEN v_part1 = hi_char.
            IF v_due_date = ? THEN v_due_date = low_date.
            IF v_due_date1 = ? THEN v_due_date1 = hi_date .
            IF v_invnbr1 = "" THEN v_invnbr1 = hi_char.

/*L03V*/    end.  /* if (c-application-mode <> 'web') ... */

        END PROCEDURE .

            
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

        {mfphead.i}

         /* EXPORT DELIMITER ";" "类型" "客户" "项目"	"顺序号"	"供应商号"	"收货地点"	"零件号"	"零件颜色"	"零件名称"	"计划代码"	"传票日期"	"传票时间"	"订货数量"	"传票号码"  
                                 "版本号" 	"周次"	"分类"	"交货规则"	"备注"	"备注1"  "送货日期" "送货时间" .*/
            
            put unformatted "类型   客户     项目    顺序号  供应商号  收货地点        零件号        零件颜色            零件名称       计划代码  送货日期   送货时间      订货数量            传票号码      版本号    周次      分类       交货规则              备注                 备注1       传票日期  传票时间       传票数量   " SKIP.
            put unformatted "---- -------- -------- ------- --------- --------- -------------------- --------- ------------------------ --------- ---------- --------- ---------------- -------------------- ------ ---------- -------- ---------------- -------------------- -------------------- --------- --------- ----------------" SKIP .
            FOR EACH xxsod_det NO-LOCK WHERE xxsod_cust >= v_cust
                                         AND xxsod_cust <= v_cust1
                                         AND xxsod_project >= v_project
                                         AND xxsod_project <= v_project1
                                         AND xxsod_vend >= v_vend
                                         AND xxsod_vend <= v_vend1
                                         AND xxsod_addr >= v_addr
                                         AND xxsod_addr <= v_addr1
                                         AND xxsod_part >= v_part
                                         AND xxsod_part <= v_part1 
                                         AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= v_due_date
                                         AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= v_due_date1
                                         AND xxsod_invnbr >= v_invnbr 
                                         AND xxsod_invnbr <= v_invnbr1
                                         AND (xxsod_week >= v_week OR v_week = 0)
                                         AND (xxsod_week <= v_week1 OR v_week1 = 0):
                PUT UNFORMATTED xxsod_type AT 1.
                PUT UNFORMATTED xxsod_cust AT 6.
                PUT UNFORMATTED xxsod_project AT 15.
                PUT UNFORMATTED xxsod_item AT 24 .
                PUT UNFORMATTED xxsod_vend AT 32 .
                PUT UNFORMATTED xxsod_addr AT 42 .
                PUT UNFORMATTED xxsod_part AT 52 .
                PUT UNFORMATTED xxsod_color AT 73 .
                PUT UNFORMATTED xxsod_desc AT 83 .
                PUT UNFORMATTED xxsod_plan AT 108 .
                PUT UNFORMATTED xxsod_due_date1 AT 118.
                PUT UNFORMATTED xxsod_due_time1 AT 129.
                PUT UNFORMATTED xxsod_qty_ord TO 154 .
                PUT UNFORMATTED xxsod_invnbr AT 156 .
                PUT UNFORMATTED xxsod_rev AT 177.
                PUT UNFORMATTED xxsod_week TO 193.
                PUT UNFORMATTED xxsod_category AT 195.
                PUT UNFORMATTED xxsod_ship AT 204.
                PUT UNFORMATTED xxsod_rmks AT 221.
                PUT UNFORMATTED xxsod_rmks1 AT 242.
                PUT UNFORMATTED xxsod_due_date AT 263.
                PUT UNFORMATTED xxsod_due_time  AT 273.
                PUT UNFORMATTED xxsod__chr02 TO 298.
                PUT SKIP.

            END.

/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

END.
                 {wbrp04.i &frame-spec = a}

END PROCEDURE.

/*GUI*/ {mfguirpb.i &flds=" v_type v_cust v_cust1 v_project v_project1 
                      v_vend v_vend1 v_addr v_addr1 v_part v_part1
                      v_due_date v_due_date1 v_invnbr v_invnbr1 
                      v_week v_week1 " } 
    
    /* Drive the Report */
