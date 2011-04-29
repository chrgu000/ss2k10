/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +  Program ID    : s4nstkval.p "Monetary Value Report"                  +
 +  Menu No       : 3.6.10.14                                            +
 +  Revision      : 1.0e                                                 +
 +  Last Modified : 04/02/03  By: Kunal Malvankar       *ekDm*           +
 +  Remarks       : Ready For Use In eB Character Version Of MFG/PRO     +
 
    Modified By   : TAMIL MARAN
    Date          : 26-AUGUST-03 
    Reason        : To display Site & Month in Seperate columns. 
                    Also to suppress page headers .
    Code          : NTM
    Last Modi     : 26-AUGUST-03 7PM
    
    Last Modi     : Maran on SEPTEMBER-11-2003 11 AM
                    To break by Year & Period 
                    To display one-time header 
                    To export comma delimited file 
                   
                    To include Inventory Returns (WO Returns & Sales
                    Returns) in a Additional Column . (15-SEPTEMBER-03)
                    
                    To display RUN-DATE & RUN-TIME in the Header . 
                    
 Modified on : 02-MARCH-04 to correct the problem of "ARRAY SUBSCRIPT
 OUT OF RANGE" by TAMIL MARAN 3 PM
 Also modified to enter "Effective Date" as mandatory .
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/* s4stkval.p - Month End Monetry Value of Inventory Stock              */
/* COPYRIGHT stcs.  ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */

/* Customised               Dated: 08/04/97             By: rgf *RGF1*  */
/* Customised               Dated: 27/11/97             By: VJ  *VJ1*   */
/* Customised               Dated: 26/01/98             By: VJ  *VJ2*   */
/* Customised               Dated: 09/07/98             By: LW  *LW1*   */
/* Modified on 7/8/01 by Et to print for range of input site.           */
/* Modified by Et1 : To accept for 10 input sites & add in the tot line */
/*             item with qoh  15/05/02                                  */
/* Modified by Et3 : 19/03/04 : to take care of new financial period. */
/*By: Neil Gao 09/03/16 ECO: *SS 20090316* */

/*-----------------------------------------------------------------------
  Last Modified By: Niranjan Sangapur      /*NIR2206*/
                On: 22-Jun-05
           Changes:
                1) Changed to sort and total by pt Groups (BLR,ARO,SRO). 

                    Since ordn & ordn1 sites are being merged. After merger                    
                    user wants to track the items under BLR,SRO etc., 
                    For this purpose "pt_promo" is updated to indicate 
                    which group the item  belongs to.
 -------------------------------------------------------------------------*/

define variable m_line        like pt_prod_line       NO-UNDO.
define variable m_line1       like pt_prod_line       NO-UNDO.
/*VJ2*/ define variable stdt like tr_effdate        NO-UNDO.
/*VJ2*/ define variable endt like tr_effdate        NO-UNDO.
define variable pline like pt_prod_line             NO-UNDO.
define variable part  like pt_part                  NO-UNDO.
define variable rcvd_tot as dec                     NO-UNDO.
define variable stk_tot as dec                      NO-UNDO.
define variable iss_tot as dec                      NO-UNDO.
define variable ctr as int                          NO-UNDO.
define variable rtot like rcvd_tot                  NO-UNDO.
define variable stot like stk_tot                   NO-UNDO.
define variable itot like iss_tot                   NO-UNDO.
/*VJ1*/ define variable rtfg like rcvd_tot          NO-UNDO.
/*VJ1*/ define variable itfg as dec 	            NO-UNDO.
def var m_ctr as int                                NO-UNDO.
/*Et2*/ define variable tmpqoh as dec          NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_i AS INTEGER             NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_monthname AS CHAR        NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_year      AS INTEGER FORMAT "9999" NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_j         AS INTEGER FORMAT "9999" NO-UNDO.
/*NTM*/ DEFINE VARIABLE m_ret_qty   AS DECIMAL               NO-UNDO.
/*NTM*/ DEFINE VARIABLE g_ret_qty   AS DECIMAL               NO-UNDO.
/*Et3*/ DEFINE VARIABLE mm AS int   NO-UNDO.
/*Et3*/ DEFINE VARIABLE mm1 AS int  NO-UNDO.
/*Et3*/ DEFINE VARIABLE yy AS INTEGER FORMAT "9999" NO-UNDO.
/*Et3*/ DEFINE VARIABLE yy1 AS INTEGER FORMAT "9999" NO-UNDO.
def var rcvd_tot1 like rcvd_tot no-undo.
def var iss_tot1 like iss_tot no-undo.	        
def var m_ret_qty1 like m_ret_qty no-undo.
def var stk_tot1 like stk_tot no-undo.

DEFINE TEMP-TABLE w_file     
   field w_site         like tr_site
   field w_line         like pt_prod_line
   field w_qty_chg_iss  like tr_qty_chg 
   FIELD w_qty_chg_rct  LIKE tr_qty_chg 
   field w_qoh          like in_qty_oh
   FIELD w_returns      like in_qty_oh 
   INDEX  w_index1  IS UNIQUE
          w_line.

{mfdtitle.i "1.1E" } /*NTM*/

form 
   m_line    colon 15 
   m_line1   colon 35 label {t001.i} 
    stdt     colon 15
    endt     colon 35 label {t001.i}
skip(1)
with frame a width 80 side-label .

/*SS 20090316 - B*/
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
/*SS 20090316 - E*/

ASSIGN m_line = "0000" m_line1 = "0999" stdt = today endt = today .
MAINLOOP: 
REPEAT: 
    assign rcvd_tot=0
	   iss_tot=0        
	   m_ret_qty=0
	   stk_tot=0.
    if m_line1 = hi_char then m_line1 = "" .
    update m_line m_line1 
    stdt 
    validate (input stdt <> ? , 
    "ERROR:Start-Date CANNOT BE BLANK. Please re-enter.")
    endt 
    validate (input endt >= input stdt,
    "ERROR:End-Date should be >= Start Date. Please re-enter" )
     with frame a. 
    
    bcdparm = "".
    {mfquoter.i m_line }
    {mfquoter.i m_line1 }
    {mfquoter.i stdt }
    {mfquoter.i endt }
    
    {mfselbpr.i "printer" 132}
    if m_line1 = "" then m_line1 = hi_char. 
    if stdt = ? then stdt = low_date.
    if endt = ? then endt = hi_date.	
   ASSIGN m_ctr  = 0.
   for each w_file.
     delete w_file.
   end.

  FOR EACH tr_hist
      FIELDS(tr_part tr_effdate tr_type tr_site tr_qty_chg tr_prod_line)
        USE-INDEX tr_eff_trnbr
        NO-LOCK WHERE
			tr_domain = global_domain and	/*---Add by davild 20090205.1*/
            (tr_effdate >= stdt         )
        AND (tr_effdate <= endt         )
        AND (tr_trnbr = tr_trnbr        ) 
        AND (tr_type BEGINS "iss" OR tr_type BEGINS "rct" 
               OR tr_type = "CYC-RCNT")
        AND LOOKUP(tr_type,"RCT-CHL,RCT-TR,ISS-CHL,ISS-TR") = 0:

    ASSIGN m_ctr = m_ctr + 1 .
    IF ( m_ctr modulo  5000) = 0 THEN 
       PUT SCREEN ROW 20 " TR-HIST LOOP: " 
                       + " : Counter : " +  string(m_ctr,">>>,>>9").

    find first glc_cal no-lock where 
		glc_domain = global_domain and	/*---Add by davild 20090205.1*/
		glc_start <= tr_effdate and 
         glc_end >= tr_effdate use-index glc_start no-error.
    if available glc_cal then 
       assign m_i = glc_per
              m_year = glc_year.

    FOR FIRST pt_mstr WHERE 
	pt_domain = global_domain and /*---Add by davild 20090205.1*/
	pt_part = tr_part 
    AND pt_prod_line >= m_line AND pt_prod_line <= m_line1 
    NO-LOCK :
    END. /* for first pt_mstr */
    IF NOT AVAILABLE pt_mstr THEN NEXT.
    
    FOR FIRST  w_file where w_line = pt_prod_line: 
    END. /* for first w_file */
    
    if not available w_file then 
    do:
       create w_file.
       assign 
              w_site     = tr_site
              w_line     = pt_prod_line
              w_qoh      = 0.
    END. /* if not avail w_file */ 
     
    find first in_mstr use-index in_part where 
		in_domain = global_domain and	/*---Add by davild 20090205.1*/
		in_part=tr_part
    		and in_site=tr_site no-lock no-error.        
    if available in_mstr then 
    do:
       {gpsct03.i &cost=sct_cst_tot }   
    end.       
    
    if tr_type begins "rct" and pt_part_type <> "FG" then do:
       assign 
          w_qty_chg_rct  = w_qty_chg_rct  + (tr_qty_chg * glxcst).
    end.
    else
    if tr_type begins "iss" then 
    do:
       IF (tr_type = "iss-so" and tr_qty_chg > 0 ) OR
          (tr_type = "iss-wo" and tr_qty_chg > 0 ) THEN
       ASSIGN
       	  w_returns = w_returns  + (tr_qty_chg * glxcst).
       ELSE IF pt_part_type <> "FG" THEN
       ASSIGN
       	  w_qty_chg_iss = w_qty_chg_iss + (tr_qty_chg * glxcst).
    end. /* tr_type begins 'iss' */
    
    if glxcst <> 0 then
    for each in_mstr use-index in_part 
    		where 
			in_domain = global_domain and	/*---Add by davild 20090205.1*/
			in_part = tr_part
    		  and in_site = tr_site    		
    		  and in_qty_oh <> 0:
        w_qoh = w_qoh + (in_qty_oh * glxcst).     
    end.    	
   end. /* for each tr_hist */

PUT "Report Period : From " stdt " To " endt  SKIP.
PUT "RUN Date :" TODAY " TIME : " STRING(TIME,"HH:MM:SS") SKIP.

for each w_file
    break BY w_line : 

    find first pl_mstr where 
	pl_domain = global_domain and /*---Add by davild 20090205.1*/
	pl_prod_line = w_line no-lock no-error.
    Disp
        w_line 					 column-label "Product Line"
        (IF AVAIL pl_mstr THEN 
        	pl_desc   
       	ELSE "") 	format "x(24)" 		 column-label "Desc"
        w_qty_chg_rct   format "->>>,>>>,>>9.99" Column-label "Receipt Value"
        w_qty_chg_iss   format "->>>,>>>,>>9.99" Column-label "Issue Value"
        w_returns   	format "->>>,>>>,>>9.99" Column-label "Returns"
        w_qoh     	format "->>>,>>>,>>9.99" Column-label "Stock Value"
        with frame fhead width 150 down.
    
    ASSIGN              
    	rcvd_tot =rcvd_tot  + w_qty_chg_rct	
	iss_tot  =iss_tot   + w_qty_chg_iss	
	m_ret_qty=m_ret_qty + w_returns    
	stk_tot  =stk_tot   + w_qoh.
end.   /* for each w_file */
 
disp	"Total"  no-label space(33)
	rcvd_tot  format "->>>,>>>,>>9.99" column-label ""
	iss_tot   format "->>>,>>>,>>9.99" column-label ""
	m_ret_qty format "->>>,>>>,>>9.99" column-label ""
	stk_tot   format "->>>,>>>,>>9.99" column-label ""
	with frame ftail width 200 down.
 /*LW {mfreset.i}*/
 /*LW*/ {mfguirex.i }.
 /*LW*/ {mfguitrl.i}.
 /*LW*/ {mfgrptrm.i} .
end. /* Repeat */
