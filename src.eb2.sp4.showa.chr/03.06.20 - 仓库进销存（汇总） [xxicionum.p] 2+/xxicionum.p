/* ppptrp11.p - ITEM MASTER DATA REPORT                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K0R8*/
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 06/03/86   BY: PML                 */
/* REVISION: 7.0      LAST MODIFIED: 11/28/91   BY: pml                 */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: pma *H055*          */
/* REVISION: 7.4      LAST MODIFIED: 08/27/94   BY: rxm *GL58*          */
/* REVISION: 7.5      LAST MODIFIED: 02/01/95   BY: tjm *J042*          */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: mzv *K0R8*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *N0GF* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/27/00   BY: *N0TF* Katie Hilbert    */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable site  like  ld_site no-undo.
define variable site1 like  ld_site no-undo.
define variable part like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable loc like   ld_loc no-undo.
define variable loc1 like   ld_loc no-undo.
define variable effdate like  tr_effdate no-undo.
DEFINE VARIABLE effdate1 LIKE tr_effdate NO-UNDO.
DEFINE VARIABLE desc1 LIKE pt_desc1 NO-UNDO.
DEFINE VARIABLE desc2 LIKE pt_desc1 NO-UNDO.
define variable qty_init  like  ld_qty_oh no-undo.
define variable amt_init  like  tr_gl_amt  no-undo.
define variable qty_po  like  ld_qty_oh no-undo.
define variable qty_rs  like  ld_qty_oh no-undo.
define variable amt_po  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "收货额" no-undo.
define variable qty_prv     like  ld_qty_oh no-undo.
define variable qty_rct_so  like  ld_qty_oh no-undo.
define variable amt_prv     like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "退货额" no-undo.
define variable qty_iss_wo  like  ld_qty_oh no-undo.
define variable amt_iss_wo  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "发料额" no-undo.
define variable qty_check  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "仕损检查" no-undo.
define variable qty_out  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "解拆" no-undo.
define variable qty_un_iss  like  ld_qty_oh no-undo.
define variable amt_un_iss  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "计划外入库额" no-undo.
define variable qty_un_rct  like  ld_qty_oh no-undo.
define variable amt_un_rct  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "计划外出库额" no-undo.
define variable qty_tr_rct  like  ld_qty_oh no-undo.
define variable amt_tr_rct  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "转仓入库额" no-undo.
define variable qty_tr_iss  like  ld_qty_oh no-undo.
define variable amt_tr_iss  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "转仓出库额" no-undo.
define variable amt_adj  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "成本调整额" no-undo.
define variable qty_cyc  like  ld_qty_oh no-undo.
define variable amt_cyc  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "盘盈亏额" no-undo.
define variable qty_rct_wo  like  ld_qty_oh no-undo.
define variable amt_rct_wo  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "入库额" no-undo.
define variable qty_iss_so  like  ld_qty_oh no-undo.
define variable amt_iss_so  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "发货额" no-undo.
define variable qty_other  like  ld_qty_oh no-undo.
define variable amt_other  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "其它入库额" no-undo.
define variable qty_end  like  ld_qty_oh no-undo.
define variable amt_end  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "期未额" no-undo.
define variable qty_over  like  ld_qty_oh no-undo.
define variable amt_over  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "期间后额" no-undo.
define variable qty_new  like  ld_qty_oh no-undo.
define variable amt_new  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "当前额" no-undo.
DEFINE VARIABLE SIM LIKE SI_gl_set .

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM 
        site           colon 15
        site1          label "至" colon 49 skip
        loc            COLON 15
        loc1           COLON   49 LABEL "至"
        part           colon 15
        part1          label "至" colon 49 skip
        effdate        colon 15
        effdate1       label "至" colon 49 skip

with frame a side-labels width 80 attr-space .

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).

/* REPORT BLOCK */

/*K0R8*/ {wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if loc1 = hi_char then loc1 = "".
   if site1 = hi_char then site1 = "".
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.
/*K0R8*/ if c-application-mode <> 'web' then

/*K0R8*/ if c-application-mode <> 'web' then
   update site site1 loc  loc1 part part1
effdate effdate1 with frame a.

/*K0R8*/ {wbrp06.i &command = update &fields = "site site1 loc  loc1 part part1
effdate effdate1" &frm = "a"}

/*K0R8*/ if (c-application-mode <> 'web') or
/*K0R8*/ (c-application-mode = 'web' and
/*K0R8*/ (c-web-request begins 'data')) then do:

  bcdparm = "".
   {mfquoter.i site  }
   {mfquoter.i site1  }
   {mfquoter.i  loc }
   {mfquoter.i loc1  }
   {mfquoter.i part   }
   {mfquoter.i part1  }
   {mfquoter.i effdate   }
   {mfquoter.i effdate1  }

   if part1 = "" then part1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if loc1 = "" then loc1 = hi_char.
   if effdate = ? then effdate = low_date.
   if effdate1 = ? then effdate1 = TODAY.

/*K0R8*/ end.

   /* PRINTER SELECTION */
   {mfselbpr.i "printer" 180}
   {mfphead.i}

 

  FOR EACH ld_det WHERE ld_site >= site AND ld_site <= site1
     AND ld_loc >= loc AND  ld_loc <= loc1  
               AND ld_part >= part AND (ld_part <= part1 OR part1 = "") USE-INDEX ld_loc_p_lot NO-LOCK   
			   BREAK  BY ld_site BY ld_loc    BY ld_part :
          ACCUMULATE ld_qty_oh ( TOTAL BY  ld_part).

 FORM HEADER
      "地点:"  at 5  ld_site   "库位:"  at 25  ld_loc   
		 "期始日期:"  at 45 effdate   format "9999/99/99"   "期未日期:"  at 75  effdate1    format "9999/99/99"
        "页码:" TO 140 PAGE-NUMBER FORMAT ">>9" NO-LABEL
         
        "打印日期:" AT 160  STRING(TODAY,"99/99/99") STRING(TIME,"hh:mm:ss")

        WITH  FRAME pfloot PAGE-TOP   WIDTH 200 SIDE-LABEL .
        if first-of(ld_loc) then 
        VIEW FRAME pfloot.
    /***      IF FIRST-OF(ld_site) THEN DO:
              FIND si_mstr WHERE si_site = ld_site NO-LOCK NO-ERROR.
              IF AVAILABLE si_mstr  THEN  IF si_gl_set <> "" THEN sim = si_gl_set.
              ELSE sim = "standard".
                   ELSE sim = "standard".
          END.  ***/
    /*       if first-of(ld_loc) then display ld_site label "地点"  ld_loc label "库位"  
		   effdate label "期始日期"  effdate1 label "期未日期"  with frame cc side-label. */

           IF LAST-OF(ld_part)  THEN DO:
               ASSIGN  qty_init  =  0 
               amt_init  =  0  
               qty_po    =  0 
	       qty_rs    =  0
               amt_po    =  0 
               qty_prv   =  0
	       qty_rct_so =  0
               amt_prv   =  0   
               qty_iss_wo   =  0  
               qty_check    =  0
	       qty_out      =  0
	       amt_iss_wo   =  0 
               qty_un_iss   =  0 
               amt_un_iss   =  0 
               qty_un_rct   =  0 
               amt_un_rct   =  0 
               qty_rct_wo   =  0   
               amt_rct_wo   =  0 
               qty_tr_rct   =  0
               amt_tr_rct   =  0
               qty_tr_iss   =  0 
               amt_tr_iss   =  0 
               qty_iss_so   =  0 
               amt_iss_so   =  0 
               qty_cyc      =  0
               amt_cyc      =  0
               amt_adj      =  0
               qty_other    =  0 
               amt_other    =  0 
               qty_end      =  0 
               amt_end      =  0
	       qty_over     =  0.


  FOR EACH tr_hist WHERE tr_part = ld_part AND tr_effdate >= effdate 
               AND tr_site = ld_site AND tr_loc = ld_loc USE-INDEX tr_part_eff 
                NO-LOCK:
               IF tr_effdate <= effdate1 THEN  
               
               CASE tr_type :
                     WHEN "rct-po" THEN  qty_po = qty_po + tr_qty_loc.
                     WHEN "rct-rs" THEN  qty_rs = qty_rs + tr_qty_loc.
                     WHEN  "iss-prv" THEN    qty_prv = qty_prv - tr_qty_loc.
		     WHEN  "rct-sor" THEN    qty_rct_so = qty_rct_so + tr_qty_loc.
                     WHEN "iss-wo"  THEN    
		                   DO: if tr_rmks = "" then qty_iss_wo  = qty_iss_wo - tr_qty_loc.
		                            else if substring(tr_rmks,1,1) = "Z" then qty_out = qty_out - tr_qty_loc. 
					         else qty_check = qty_check - tr_qty_loc. 
			           END.
                     WHEN "rct-unp" THEN  qty_un_rct = qty_un_rct + tr_qty_loc.
                     WHEN  "iss-unp" THEN     qty_un_iss = qty_un_iss - tr_qty_loc.
                     WHEN "rct-tr" THEN   qty_tr_rct = qty_tr_rct + tr_qty_loc.
                     WHEN  "iss-tr" THEN    qty_tr_iss = qty_tr_iss - tr_qty_loc. 
                     WHEN "iss-so" THEN  qty_iss_so  = qty_iss_so - tr_qty_loc.
                     WHEN "rct-wo" THEN  qty_rct_wo  = qty_rct_wo + tr_qty_loc.

		     WHEN  "TAG-CNT" OR WHEN  "CYC-CNT" OR WHEN "CYC-ERR" OR WHEN "CYC-RCNT"  THEN 
                                         qty_cyc  = qty_cyc + tr_qty_loc.
              /*       WHEN "CST-ADJ"  THEN 
                                DO:  
                                     amt_adj  =  amt_adj + tr_gl_amt.
                                END.         */     


                      OTHERWISE      DO:   qty_other = qty_other + tr_qty_loc.
                                          END.
                      END CASE.
               
               ELSE   DO:   qty_over = qty_over + tr_qty_loc.
                      END.

                 END. 
	    /*  FOR EACH tr_hist */

                  qty_new = ACCUM  TOTAL BY ld_part ld_qty_oh .

            /*    FIND sct_det WHERE sct_site = ld_site AND sct_part = ld_part AND sct_sim = sim  NO-LOCK NO-ERROR.
                 IF AVAILABLE sct_det  THEN amt_new = qty_new * sct_cst_tot. ELSE amt_new = 0. */
                 ASSIGN  qty_end = qty_new - qty_over
            /*    amt_end = amt_new - amt_over */
                         qty_init = qty_new - qty_over - qty_po - qty_rs + qty_prv - qty_rct_so + qty_iss_wo + qty_check + qty_out + qty_un_iss + qty_tr_iss - qty_cyc - qty_un_rct - qty_tr_rct - qty_rct_wo + qty_iss_so .
            /*    amt_init = amt_new - amt_over - amt_po - amt_prv - amt_iss_wo - amt_un_iss - amt_tr_iss - amt_cyc - amt_adj - amt_un_rct  - amt_tr_rct - amt_rct_wo - amt_iss_so  . */
                     
                   FIND pt_mstr WHERE pt_part = ld_part NO-LOCK NO-ERROR.
                   IF AVAILABLE pt_mstr  THEN DO:
                       desc1 = pt_desc1.
                       desc2 = pt_desc2.
                   END.

                  qty_out = qty_out *(-1).
		  DISPLAY 
                        ld_part format "x(18)"  LABEL "零件号"
                        desc1   format "x(20)"  label "名称"
                        qty_init FORMAT  "->>>>,>>9.<<"  LABEL "期初数"
			qty_po FORMAT  "->>>>,>>9.<<"  LABEL "采购收货(+)"
			qty_rs FORMAT  "->>>>,>>9.<<"  LABEL "退还库存(+)"
			qty_prv  FORMAT  "->>>>,>>9.<<"  LABEL "退供应商(-)"
			qty_rct_so  FORMAT  "->>>>,>>9.<<"  LABEL "客户退货(+)"
			qty_iss_wo FORMAT  "->>>>,>>9.<<" LABEL "生产耗用(-)"
			qty_check FORMAT  "->>>>,>>9.<<" LABEL "仕损检查(-)"
			qty_out FORMAT  "->>>>,>>9.<<" LABEL "解拆(+)"
                        qty_tr_iss FORMAT  "->>>>,>>9.<<"  LABEL "转仓出库(-)" 
                        qty_tr_rct  FORMAT  "->>>>,>>9.<<"  LABEL "转仓入库(+)"
			qty_rct_wo  FORMAT  "->>>>,>>9.<<"  LABEL "生产入库(+)"
			qty_iss_so FORMAT  "->>>>,>>9.<<"  LABEL  "销售发货(-)" 
			qty_end    FORMAT  "->>>>,>>9.<<"  LABEL  "期未量"
			qty_cyc FORMAT  "->>>>,>>9.<<"  LABEL  "盘盈亏"
			qty_other FORMAT  "->>>>,>>9.<<"  LABEL  "其它入库(+)"      
			qty_un_iss FORMAT  "->>>>,>>9.<<"  LABEL "计划外出库(-)" 
			qty_un_rct  FORMAT  "->>>>,>>9.<<"  LABEL "计划外入库(+)"
                      WITH   WIDTH 250 STREAM-IO.
          END. 

/*  IF LAST-OF(ld_part) */
    
if last-of(ld_loc) or last-of(ld_site) then page.

/*       {mfrpexit.i}                     */

   end.

   /* REPORT TRAILER */

   {mfrtrail.i}

end.

/*K0R8*/ {wbrp04.i &frame-spec = a}
