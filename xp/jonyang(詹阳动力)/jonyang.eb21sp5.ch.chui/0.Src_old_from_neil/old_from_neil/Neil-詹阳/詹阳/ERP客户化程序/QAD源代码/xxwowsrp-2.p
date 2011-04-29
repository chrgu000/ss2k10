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
/*By: Neil Gao 09/02/06 ECO: *SS 20090206* */
/* SS - 090924.1 By: Neil Gao */
/* SS - 090925.1 By: Neil Gao */

         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/* SS 090924.1 - B */
         {mfdtitle.i "090925.1"}
/* SS 090924.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowsrp_p_1 "�����"
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
         define variable open_ref like wod_qty_req format ">>>,>>9.999" LABEL "��ȱ��".
         define variable desc1 AS CHARACTER FORMAT "X(48)" LABEL "����".
         define variable WKCTR like RO_WKCTR label "��������".
         define variable WKCTR1 like RO_WKCTR.
         define variable OP AS CHARACTER FORMAT "X(60)" LABEL "��������".
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
         define variable OPb AS  CHARACTER FORMAT "xx" label "��������".
         define variable OPC AS  CHARACTER FORMAT "xx".
        define variable XZ AS  CHARACTER FORMAT "x" label "��ʾС������ϸ��Y/N����".

   xz = "N".     

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
           
           nbr      colon 20 nbr1      label {t001.i} colon 49 skip
           lot      colon 20 lot1      label {t001.i} colon 49 skip
           rel_date colon 20 rel_date1 label {t001.i} colon 49 skip
           due_date colon 20 due_date1 label {t001.i} colon 49 skip
           part     colon 20 part1     label {t001.i} colon 49 skip
           wkctr    colon 20 wkctr1    label {t001.i} colon 49 skip
           BUYER    colon 20 BUYER1    label {t001.i} colon 49 skip
           opb      colon 20 SKIP
      /*     xz colon 20            */
         
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

&UNDEFINE PP_FRAME_NAME



/*J196*/ FORM /*GUI*/  WO_NBR WO_LOT wo_status op opa wo_part desc1 PT_BUYER wo_qty_ord wo_qty_comp 
/*J196*/       open_ref
/*J196*/ with STREAM-IO /*GUI*/  down frame b width 210 no-attr-space.

setFrameLabels(frame b:handle).


/*K0YQ*/ {wbrp01.i}

repeat:
/*SS 20090206 - E*/

            if nbr1  = hi_char then  nbr1 = "".
            if lot1  = hi_char then  lot1 = "".
            if part1 = hi_char then part1 = "".
            if wkctr1 = hi_char then wkctr1 = "".
            if BUYER1 = hi_char then BUYER1 = "".
           if rel_date1 = hi_date then rel_date1 = ?.
/*IFP*/     if due_date1 = hi_date then due_date1 = ?.
/*IFP*/     if rel_date = low_date then rel_date = ?.
/*IFP*/     if due_date = low_date then due_date = ?.


						update nbr nbr1 lot lot1 rel_date rel_date1 due_date due_date1 part part1 wkctr wkctr1 with frame a.


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

/*GUI*/   {mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

define buffer wod_det1 for wod_det.


            {mfphead1.i}

           
            desc1 = "".
          
            /* FIND AND DISPLAY */
        for each wo_mstr where (wo_part >= part and wo_part <= part1) 
/* SS 090925.1 - B */	
						and wo_domain = global_domain
/* SS 090925.1 - E */
            and (wo_nbr >= nbr and wo_nbr <= nbr1)
            and (wo_lot >= lot and wo_lot <= lot1)
            and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
            and (wo_due_date >= due_date and wo_due_date <= due_date1)
            and (wo_qty_ord > wo_qty_comp + WO_QTY_RJCT)
            and (wo_status = "R") 
            no-lock by wo_rel_date by wo_due_date by wo_part by wo_nbr by wo_lot 
            with frame b width 270:
    find first WR_ROUTE where (WR_PART = wo_part AND WR_LOT = WO_LOT ) and (WR_wkctr >= wkctr and WR_wkctr <= wkctr1)
/* SS 090925.1 - B */
						and wr_domain = global_domain
/* SS 090925.1 - E */
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
/* SS 090925.1 - B */
					and wr_domain = global_domain 
/* SS 090925.1 - E */
        no-lock no-error.
        
        IF AVAILABLE WR_ROUTE  and xz = "n" THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP = "����".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP = "�ƻ�".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP = "�ṹ".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP = "Һѹ".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP = "����".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP = "�ȵ�".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP = "���".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" THEN OP = "װ��".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP = "���޶���".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP = "��Э".                       
        IF WR_QTY_COMP >= WR_QTY_ORD THEN OP = "(" + TRIM(OP) + ")".
           IF WR_QTY_COMP < WR_QTY_ORD AND WR_QTY_COMP <> 0 THEN OP =  TRIM(OP) + "(" + STRING(WR_QTY_COMP) + ")".
           
             DO WHILE  available WR_ROUTE :
             
FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/* SS 090925.1 - B */
						and wr_domain = global_domain
/* SS 090925.1 - E */
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP2 = "����".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP2 = "�ƻ�".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP2 = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP2 = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP2 = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP2 = "�ṹ".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP2 = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP2 = "Һѹ".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP2 = "����".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP2 = "�ȵ�".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP2 = "���".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP2 = "װ������".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP2 = "װ��".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP2 = "����".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP2 = "���޶���".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP2 = "��Э".                       
         IF WR_QTY_COMP >= WR_QTY_ORD THEN OP2 = "(" + OP2 + ")".
           IF WR_QTY_COMP < WR_QTY_ORD AND WR_QTY_COMP <> 0 THEN OP2 =  OP2 + "(" + STRING(WR_QTY_COMP) + ")".
            op = TRIM(op) + "��" + op2.

  

           END.
           END.
           END.
           IF OPB = "95" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "95") 
/* SS 090925.1 - B */
									and wr_domain = global_domain
/* SS 090925.1 - E */
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "95".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.
              
            IF OPB = "96" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "96") 
/* SS 090925.1 - B */
									and wr_domain = global_domain
/* SS 090925.1 - E */
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "96".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.

           
           
           IF OPB = "99" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "99") 
/* SS 090925.1 - B */
									and wr_domain = global_domain
/* SS 090925.1 - E */
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "99".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.

                    IF OPB = "98" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "98") 
/* SS 090925.1 - B */
									and wr_domain = global_domain
/* SS 090925.1 - E */
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "98".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.
           IF OPB = "97" THEN DO:
             FIND LAST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND (SUBSTRING(WR_WKCTR,5,2) = "97") 
/* SS 090925.1 - B */
									and wr_domain = global_domain
/* SS 090925.1 - E */
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "97".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.
    FIND LAST WR_ROUTE WHERE WR_PART = WO_PART AND WR_LOT = WO_LOT 
/* SS 090925.1 - B */
							and wr_domain = global_domain
/* SS 090925.1 - E */    
    NO-LOCK NO-ERROR.
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
     IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP2 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
     IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP2 = "��" + SUBSTRING(WR_WKCTR,1,3) .
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
     find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
              IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP2 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP2 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP3 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP3 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP3 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP3 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP4 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP4 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).     
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP4 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP4 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).

.
           
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP5 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP5 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).     
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error. 
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP5 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP5 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).

            
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP6 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP6 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).     
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.  
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP6 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP6 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).

         
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP7 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP7 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.  
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP7 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP7 = "��" + SUBSTRING(WR_WKCTR,1,3) .
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).

    
                    
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP8 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP8 = "��" + SUBSTRING(WR_WKCTR,1,3) . 
                 IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.    
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP8 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP8 = "��" + SUBSTRING(WR_WKCTR,1,3) . 
                 IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).        
                       
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP9 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP9 = "��" + SUBSTRING(WR_WKCTR,1,3) . 
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3). 
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP9 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")".
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP9 = "��" + SUBSTRING(WR_WKCTR,1,3) . 
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP10 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP10 = "��" + SUBSTRING(WR_WKCTR,1,3) .                                 
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).  
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.  
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP10 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP10 = "��" + SUBSTRING(WR_WKCTR,1,3) .                                 
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP11 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP11 = "��" + SUBSTRING(WR_WKCTR,1,3) .                
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
     FIND NEXT  wr_route WHERE (wr_part = WO_PART and wr_lot = wo_lot) AND SUBSTRING(WR_WKCTR,1,3) <> OPD NO-LOCK NO-ERROR.       
     if available wr_route then
        find prev wr_route where (wr_part = WO_PART and wr_lot = wo_lot) no-lock no-error.
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP11 = "��" + "(" + SUBSTRING(WR_WKCTR,1,3) + ")" .
                IF AVAILABLE WR_ROUTE AND WR_QTY_COMP < WR_QTY_ORD THEN OP11 = "��" + SUBSTRING(WR_WKCTR,1,3) .                
                IF AVAILABLE WR_ROUTE THEN OPD = SUBSTRING(WR_WKCTR,1,3).
                
                  end. /*end for xz = "y"*/   
  
      /*     OP = op1 + op2 + OP3 + OP4 + OP5 + OP6 + OP7 + OP8 + OP9 + op10 + op11.*/
  ******************/ 
    find pt_mstr where pt_part = wo_part AND (PT_BUYER >= BUYER AND PT_BUYER <= BUYER1) 
/* SS 090925.1 - B */
			and pt_domain = global_domain
/* SS 090925.1 - E */    
    no-lock no-error.
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
               opa label "��������"
               wo_part  
               desc1 
               PT_BUYER
               wo_qty_ord 
               wo_qty_comp
               open_ref
               with frame b STREAM-IO /*GUI*/ .
/*J196*/       if ((opb <> "" and opb = opC) OR OPB = "" ) and available pt_mstr then down 1.

       
               end . /*end for variable ro_det*/
            end.   /* END FOR EACH WOD_DET...   */


            /* REPORT TRAILER  */
/* SS 090924.1 - B */
/*            
/*GUI*/ {mfrtrail.i}

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
*/
		{mfreset.i}
		{mfgrptrm.i}
/* SS 090924.1 - E */

         end.  /* END REPEAT LOOP   */


/*GUI*/ end. /*p-report*/
