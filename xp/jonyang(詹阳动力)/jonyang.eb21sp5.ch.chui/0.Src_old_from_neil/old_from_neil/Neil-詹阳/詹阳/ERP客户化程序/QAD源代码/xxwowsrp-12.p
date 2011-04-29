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
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

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
         define variable nbr2  like wod_nbr.
         define variable lot   like wod_lot.
         define variable lot1   like wod_lot.
         define variable lot2   like wod_lot.
         define variable part  like wod_part label "父零件".
         define variable part1 like wod_part.
         define variable part2 like wod_part.
         define variable ord_okay like wod_lot.
         define variable ord_ignore like wod_lot.
         define variable statu like wo_status.
         define variable open_ref like wod_qty_req format ">>>,>>9.999" LABEL "短缺量".
         
         define variable buyer like pt_buyer label "(父零件)采计:".
         define variable buyer1 like pt_buyer. 
         define variable buyer2 like pt_buyer. 
         define variable due_date like wo_due_date.
         define variable due_date1 like wo_due_date.
         define variable rel_date like wo_rel_date. 
         define variable rel_date1 like wo_rel_date. 
         define variable qty_oh like in_qty_oh. 
         define variable qty_oh1 like in_qty_oh. 
         define variable wkctr like ro_wkctr.
         define variable op AS CHARACTER FORMAT "X(2)" LABEL "工作中心".
         define variable bz AS CHARACTER FORMAT "X(4)" LABEL "子件全部发放".
         define variable bz1 AS CHARACTER FORMAT "X(1)" .  
         define variable bz2 AS CHARACTER FORMAT "X(1)" .
         define variable bz3 AS CHARACTER FORMAT "X(1)" .  
         define variable bz4 AS CHARACTER FORMAT "X(1)" .

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
bz1 = "n".
bz2 = "n".
bz3 = "n".
bz4 = "n".
FORM /*GUI*/ 
           nbr      colon 15 nbr1      label {t001.i} colon 49 skip
           lot      colon 15 lot1      label {t001.i} colon 49 skip
           rel_date colon 15 rel_date1     label {t001.i} colon 49 skip
           due_date colon 15 due_date1     label {t001.i} colon 49 skip
           buyer     colon 15 buyer1     label {t001.i} colon 49 skip
          "只显示父件已全部入库记录（Y/N）:" colon 15 bz1 no-label skip
          "只显示子件未发放记录（Y/N）:    " colon 15 bz2 no-label skip
          "只显示父件未全部入库记录（Y/N）:" colon 15 bz3 no-label skip
          "只显示子件已发放记录（Y/N）:    " colon 15 bz4 no-label skip
         
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space .

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


setFrameLabels(frame a:handle).

/*J196*/ FORM /*GUI*/ wo_part pt_desc1 pt_desc2 pt_um pt_buyer wo_nbr wo_lot wo_status wo_qty_ord wo_qty_comp wo_qty_rjct WO_DUE_DATE POD_nbr bz 
/*J196*/         
/*J196*/ with STREAM-IO /*GUI*/  down frame b width 300 no-attr-space.
					setFrameLabels(frame b:handle).

/*K0YQ*/ {wbrp01.i}

repeat :
            if nbr1  = hi_char then  nbr1 = "".
            if lot1  = hi_char then  lot1 = "".
            if part1 = hi_char then part1 = "".
            if BUYER1 = hi_char then BUYER1 = "".
          /*  if BUYER4 = hi_char then BUYER4 = "".*/
            if rel_date = low_date then rel_date = ?.
            if rel_date1 = hi_date then rel_date1 = ?.
            if due_date = low_date then due_date = ?.
            if due_date1 = hi_date then due_date1 = ?.



				update nbr nbr1 lot lot1 rel_date rel_date1 due_date due_date1 buyer buyer1 bz1 bz2 bz3 bz4
				with frame a.

/*K0YQ*/ if (c-application-mode <> 'web':u) or
/*K0YQ*/ (c-application-mode = 'web':u and
/*K0YQ*/ (c-web-request begins 'data':u)) then do:


/*A175      CREATE BATCH INPUT STRING */
/*A175*/    bcdparm = "".
/*A175*/    {mfquoter.i nbr    }
/*A175*/    {mfquoter.i nbr1   }
/*A175*/    {mfquoter.i part   }
/*A175*/    {mfquoter.i part1  }
            {mfquoter.i buyer  }            
            {mfquoter.i buyer1  }
          /*  {mfquoter.i buyer3  }            
            {mfquoter.i buyer4  }*/
             {mfquoter.i rel_date  }            
            {mfquoter.i rel_date1  }
            {mfquoter.i due_date  }            
            {mfquoter.i due_date1 }

/*A175*/    {mfquoter.i lot    }
/*A175*/    {mfquoter.i lot1    }
            if nbr1  = "" then nbr1  = hi_char.
/*IFP*/     if lot1 = "" then lot1 = hi_char.
            if part1 = "" then part1 = hi_char.
            if BUYER1 = "" then BUYER1 = hi_char.
         /*   if BUYER4 = "" then BUYER4 = hi_char.*/
            if  rel_date = ? then rel_date = low_date.
            if  rel_date1 = ? then rel_date1 = hi_date.
            if  due_date = ? then due_date = low_date.
            if  due_date1 = ? then due_date1 = hi_date.

/*K0YQ*/ end.

            /* SELECT PRINTER  */
					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

define buffer wod_det1 for wod_det.


            {mfphead.i}
          
            /* FIND AND DISPLAY */
        for each wo_mstr where wo_part <> "jh" 
/*SS 20090207 - B*/
						and wo_domain = global_domain
/*SS 20090207 - E*/
            and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1) 
            and (wo_due_date >= due_date and wo_due_date <= due_date1) 
            and (wo_nbr >= nbr and wo_nbr <= nbr1)
            and (wo_lot >= lot and wo_lot <= lot1)
            and ( wo_status = "R")
            and ((bz1 = "y" and (wo_qty_comp + wo_qty_rjct) = wo_qty_ord) 
            or bz1 = "n")
            and ((bz3 = "y" and (wo_qty_comp + wo_qty_rjct) < wo_qty_ord)
            or bz3 = "n") ,
            each pt_mstr where pt_part = wo_part
/*SS 20090207 - B*/
							and pt_domain = global_domain
/*SS 20090207 - E*/
            and (pt_buyer >= buyer and pt_buyer <= buyer1)
           no-lock break by wo_part by wo_due_date
            with frame b width 310:
            bz = "".
            find first 
            wod_det where wod_lot = wo_lot 
            and TRUNCATE((wod_qty_REQ - wod_qty_iss),4) <> 0 no-lock no-error.
            
            if available wod_det then bz = "no".
            if not available wod_det then bz = "yes".
 
    FIND POD_DET WHERE POD_WO_LOT = WO_LOT 
/*SS 20090207 - B*/
			and pod_domain = global_domain
/*SS 20090207 - E*/    
    NO-LOCK NO-ERROR.
    

     if ((bz2 = "y" and bz = "no") or bz2 = "n")
        and ((bz4 = "y" and bz = "yes") or bz4 = "n") then do:
               display
              wo_part 
              pt_desc1
              pt_desc2
              pt_um
              pt_buyer
              wo_nbr 
              wo_lot 
              wo_status 
              wo_qty_ord 
              wo_qty_comp 
              wo_qty_rjct  
              WO_DUE_DATE
              POD_NBR WHEN AVAILABLE POD_DET
              bz
               with frame b STREAM-IO /*GUI*/ .
/*J196*/       down 1.
 end.
                               
            end.   /* END FOR EACH WOD_DET...   */


            /* REPORT TRAILER  */
            

 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .



         end.  /* END REPEAT LOOP   */

/*K0YQ*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end.