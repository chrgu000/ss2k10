/* GUI CONVERTED from wowsrp.p (converter v1.71) Tue Oct  6 14:59:18 1998 */
/* wowsrp.p - WORK ORDER COMPONENT SHORTAGE BY ORDER REPORT             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert wowsrp.p (converter v1.00) Fri Oct 10 13:57:25 1997 */
/* web tag in wowsrp.p (converter v1.00) Mon Oct 06 14:17:53 1997 */
/*F0PN*/ /*K0YQ*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 4.0    LAST MODIFIED: 04/26/89    BY: emb *A722**/
/* REVISION: 6.0    LAST MODIFIED: 04/16/91    BY: RAM *D530**/
/* REVISION: 8.5    LAST MODIFIED: 11/21/96    BY: *J196*  Russ Witt       */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97    BY: ays *K0YQ* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowsrp_p_1 "子零件"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define variable nbr   like wod_nbr.
         define variable nbr1  like wod_nbr.
         define variable lot   like wod_lot.
         define variable lot1   like wod_lot.
         define variable part  like wod_part .
         define variable part1 like wod_part.
         define variable BUYER  like PT_BUYER .
         define variable BUYER1 like PT_BUYER.
         define variable rel_date like wo_rel_date.
         define variable rel_date1 like wo_rel_date.
         define variable due_date like wo_due_date.
         define variable due_date1 like wo_due_date.
         define variable ord_okay like wod_lot.
         define variable ord_ignore like wod_lot.
         define variable old_lot like wod_lot.
         define variable open_ref like wod_qty_req format ">>>,>>9.999" LABEL "短缺量".
         define variable desc1 AS CHARACTER FORMAT "X(48)" LABEL "描述".
         define variable WKCTR like RO_WKCTR label "工作中心".
         define variable WKCTR1 like RO_WKCTR.
         define variable OP AS CHARACTER FORMAT "X(60)" LABEL "工艺流程".
         define variable OPA AS  CHARACTER FORMAT "xxxxxxxx".
         define variable OP1 AS  CHARACTER FORMAT "xxxx".
         define variable OP2 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP3 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP4 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP5 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP6 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP7 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP8 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP9 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP10 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP11 AS  CHARACTER FORMAT "xxxxxx".
         define variable OPD AS  CHARACTER FORMAT "xxxxxx".
         define variable OPb AS  CHARACTER FORMAT "xx" label "交库类型".
         define variable OPC AS  CHARACTER FORMAT "xx".
        define variable XZ AS  CHARACTER FORMAT "x" label "显示小工序明细（Y/N）：".

   xz = "N".     

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
           
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
           nbr      colon 20 nbr1      label {t001.i} colon 49 skip
           lot      colon 20 lot1      label {t001.i} colon 49 skip
           rel_date colon 20 rel_date1 label {t001.i} colon 49 skip
           due_date colon 20 due_date1 label {t001.i} colon 49 skip
           part     colon 20 part1     label {t001.i} colon 49 skip
           wkctr    colon 20 wkctr1    label {t001.i} colon 49 skip
           BUYER    colon 20 BUYER1    label {t001.i} colon 49 skip
           opb      colon 20 SKIP
      /*     xz colon 20            */
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
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



/*J196*/ FORM /*GUI*/  WO_NBR WO_LOT wo_status op opa wo_part desc1 PT_BUYER wo_qty_ord wo_qty_comp 
/*J196*/       open_ref
/*J196*/ with STREAM-IO /*GUI*/  down frame b width 210 no-attr-space.


/*K0YQ*/ {wbrp01.i}
        
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


            if nbr1  = hi_char then  nbr1 = "".
            if lot1  = hi_char then  lot1 = "".
            if part1 = hi_char then part1 = "".
            if wkctr1 = hi_char then wkctr1 = "".
            if BUYER1 = hi_char then BUYER1 = "".
           if rel_date1 = hi_date then rel_date1 = ?.
/*IFP*/     if due_date1 = hi_date then due_date1 = ?.
/*IFP*/     if rel_date = low_date then rel_date = ?.
/*IFP*/     if due_date = low_date then due_date = ?.


/*K0YQ*/ if c-application-mode <> 'web':u then
        
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0YQ*/ {wbrp06.i &command = update &fields = "  nbr nbr1 lot lot1 rel_date rel_date1 due_date due_date1 part part1 wkctr wkctr1 BUYER BUYER1 opb" &frm = "a"}

/*K0YQ*/ if (c-application-mode <> 'web':u) or
/*K0YQ*/ (c-application-mode = 'web':u and
/*K0YQ*/ (c-web-request begins 'data':u)) then do:


/*A175      CREATE BATCH INPUT STRING */
/*A175*/    bcdparm = "".
/*A175*/    {mfquoter.i nbr    }
/*A175*/    {mfquoter.i nbr1   }
/*A175*/    {mfquoter.i part   }
/*A175*/    {mfquoter.i part1  }
            {mfquoter.i wkctr   }
/*A175*/    {mfquoter.i wkctr1  }
            {mfquoter.i BUYER   }
/*A175*/    {mfquoter.i BUYER1  }
            {mfquoter.i rel_date}
/*A175*/    {mfquoter.i rel_date1  }
            {mfquoter.i due_date   }
/*A175*/    {mfquoter.i due_date1  }
/*A175*/    {mfquoter.i lot    }
/*A175*/    {mfquoter.i lot1    }
            if nbr1  = "" then nbr1  = hi_char.
/*IFP*/     if lot1 = "" then lot1 = hi_char.
            if part1 = "" then part1 = hi_char.
            if wkctr1 = "" then wkctr1 = hi_char.
            if BUYER1 = "" then BUYER1 = hi_char.
            if  rel_date1 = ? then rel_date1 = hi_date.
/*IFP*/     if  due_date1 = ? then due_date1 = hi_date.
/*IFP*/     if  rel_date = ? then rel_date = low_date.
/*IFP*/     if  due_date = ? then due_date = low_date.


/*K0YQ*/ end.

            /* SELECT PRINTER  */
/*A175*/    
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

define buffer wod_det1 for wod_det.


            {mfphead.i}

           
            desc1 = "".
          
            /* FIND AND DISPLAY */
        for each wo_mstr where (wo_part >= part and wo_part <= part1) 
            and (wo_nbr >= nbr and wo_nbr <= nbr1)
            and (wo_lot >= lot and wo_lot <= lot1)
            and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
            and (wo_due_date >= due_date and wo_due_date <= due_date1)
            and (wo_qty_ord > wo_qty_comp + WO_QTY_RJCT)
            and (wo_status = "R") 
            no-lock by wo_rel_date by wo_due_date by wo_part by wo_nbr by wo_lot 
            with frame b width 270:
    find first WR_ROUTE where (WR_PART = wo_part AND WR_LOT = WO_LOT ) and (WR_wkctr >= wkctr and WR_wkctr <= wkctr1)
          no-lock no-error.
                           
  OP1 = "".
  OP2 = "".
  OP3 = "".
  OP4 = "".
  OP5 = "".
  OP6 = "".
  OP7 = "".
  OP8 = "".
  OP9 = "". 
  OP10 = "".
  OP11 = "". 
          
    IF AVAILABLE WR_ROUTE  then do:      
     
         FIND FIRST WR_ROUTE WHERE (WR_PART = WO_PART  AND WR_LOT = WO_LOT ) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
        no-lock no-error.
        
        IF AVAILABLE WR_ROUTE  and xz = "n" THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP = "备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP = "计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP = "铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP = "铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP = "锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP = "结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP = "传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP = "液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP = "桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP = "热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP = "电镀".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" THEN OP = "装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP = "工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP = "机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP = "外协".                       
        IF WR_QTY_COMP >= WR_QTY_ORD THEN OP = "(" + TRIM(OP) + ")".
           IF WR_QTY_COMP < WR_QTY_ORD AND WR_QTY_COMP <> 0 THEN OP =  TRIM(OP) + "(" + STRING(WR_QTY_COMP) + ")".
           
             DO WHILE  available WR_ROUTE :
             
FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP2 = "备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP2 = "计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP2 = "铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP2 = "铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP2 = "锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP2 = "结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP2 = "传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP2 = "液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP2 = "桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP2 = "热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP2 = "电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP2 = "装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP2 = "装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP2 = "工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP2 = "机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP2 = "外协".                       
         IF WR_QTY_COMP >= WR_QTY_ORD THEN OP2 = "(" + OP2 + ")".
           IF WR_QTY_COMP < WR_QTY_ORD AND WR_QTY_COMP <> 0 THEN OP2 =  OP2 + "(" + STRING(WR_QTY_COMP) + ")".
            op = TRIM(op) + "→" + op2.

  

           END.
           END.
           END.
           IF OPB = "95" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "95") 
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "95".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.
              
            IF OPB = "96" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "96") 
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "96".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.

           
           
           IF OPB = "99" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "99") 
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "99".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.

                    IF OPB = "98" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "98") 
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "98".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.
           IF OPB = "97" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "97") 
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "97".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.
    FIND LAST WR_ROUTE WHERE WR_PART = WO_PART AND WR_LOT = WO_LOT NO-LOCK NO-ERROR.
               opa = substring(WR_wkctr,5,2).  

               
               
/**************
   if xz = "Y" then do:
 
           FIND FIRST wr_route WHERE wr_part = WO_PART and wr_lot = wo_lot NO-LOCK NO-ERROR.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP1 = "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP <  WR_QTY_ORD THEN OP1 = SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).    
                
        FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
        if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP1 = "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP <  WR_QTY_ORD THEN OP1 = SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).   
               
                 
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP2 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
     IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP2 = "→" + SUBSTRING(WR_WKCTR,1,3) .
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
     find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
              IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP2 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP2 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP3 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP3 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP3 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP3 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP4 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP4 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).     
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP4 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP4 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).

.
           
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP5 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP5 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).     
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error. 
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP5 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP5 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).

            
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP6 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP6 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).     
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.  
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP6 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP6 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).

         
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP7 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP7 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.  
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP7 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP7 = "→" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).

    
                    
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP8 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP8 = "→" + SUBSTRING(WR_WKCTR,1,3) . 
                 IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.    
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP8 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP8 = "→" + SUBSTRING(WR_WKCTR,1,3) . 
                 IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).        
                       
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP9 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP9 = "→" + SUBSTRING(WR_WKCTR,1,3) . 
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3). 
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP9 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP9 = "→" + SUBSTRING(WR_WKCTR,1,3) . 
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP10 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP10 = "→" + SUBSTRING(WR_WKCTR,1,3) .                                 
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).  
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.  
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP10 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP10 = "→" + SUBSTRING(WR_WKCTR,1,3) .                                 
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP11 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP11 = "→" + SUBSTRING(WR_WKCTR,1,3) .                
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP11 = "→" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP11 = "→" + SUBSTRING(WR_WKCTR,1,3) .                
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
                  end. /*end for xz = "y"*/   
  
      /*     OP = op1 + op2 + OP3 + OP4 + OP5 + OP6 + OP7 + OP8 + OP9 + op10 + op11.*/
  ******************/ 
    find pt_mstr where pt_part = wo_part AND (PT_BUYER >= BUYER AND PT_BUYER <= BUYER1) no-lock no-error.
    if available pt_mstr then desc1 = trim(pt_desc1) + trim(pt_desc2).
   

               
         if page-size - line-counter < 2 and available pt_mstr
           then page.
             open_ref = max(wo_qty_ORD - (max(wo_qty_COMP,0) + max(wo_qty_RJCT,0)),0).
             
               if ((opb <> "" and opb = opc) or opb = "")  and (open_ref > 0 AND AVAILABLE PT_MSTR) then
               display wo_rel_date
               wo_due_date
               WO_NBR 
               WO_LOT
               wo_status 
               op
               opa label "交库类型"
               wo_part  
               desc1 
               PT_BUYER
               wo_qty_ord 
               wo_qty_comp
               open_ref
               with frame b STREAM-IO /*GUI*/ .
/*J196*/       if ((opb <> "" and opb = opC) OR OPB = "" ) and available pt_mstr then down 1.

               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
       
               end . /*end for variable ro_det*/
            end.   /* END FOR EACH WOD_DET...   */


            /* REPORT TRAILER  */
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end.  /* END REPEAT LOOP   */

/*K0YQ*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 lot lot1 rel_date rel_date1 due_date due_Date1 part part1 wkctr wkctr1 buyer buyer1 opb "} /*Drive the Report*/
