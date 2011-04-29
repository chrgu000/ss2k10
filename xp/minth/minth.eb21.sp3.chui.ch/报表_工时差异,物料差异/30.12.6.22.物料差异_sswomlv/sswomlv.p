/* REVISION: eb21sp3      LAST MODIFIED: 03/23/08  BY: *SS - 2008.03.23.1* Hill  Cheng  */
/* SS - 100329.1  By: Roger Xiao */  /*取消相关表的锁定*/
/* SS - 100401.1  By: Roger Xiao */  /*直接抓数,不产生gl数据再undo*/
/* SS - 100519.1  By: Roger Xiao */  /*"tt1_cc = wo_line" 直接替换为"tt1_cc = wr_wkctr"*/
/* SS - 100609.1  By: Roger Xiao */  /*xxreuvup1xp.p: 显示生产线wo_line和ln_desc说明*/



{mfdtitle.i "100609.1"}

/* DISPLAY TITLE */
/*{mfdtitle.i "s2+ "}*/
{ssvdef1.i "new" } 
{ssvdef2.i "new" } 
&SCOPED-DEFINE reuvup_p_9 "Show Zero Variance to Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvup_p_10 "Show Zero Cumulative Variance"
/* MaxLen: Comment: */


DEF VAR site                     LIKE si_site .
DEF VAR site1                    LIKE si_site  .
DEF VAR line                     LIKE wo_line LABEL  "生产线"  .
DEF VAR line1                    LIKE wo_line .
DEF VAR part                     LIKE pt_part .
DEF VAR part1                    LIKE pt_part .
DEF VAR v_year                     AS INTEGER FORMAT "9999" .
DEF VAR v_month                    AS INTEGER FORMAT "99".

DEF VAR disgn1                   LIKE pt_desc2 .
DEF VAR disgn2                   LIKE pt_desc2 .
DEF VAR v_total                 LIKE wo_qty_comp .
DEF VAR v_qty_per                LIKE ps_qty_per .
DEF VAR v_cst_tot                LIKE sct_cst_tot  .
DEF VAR v_ini_date                 AS DATE .
DEFINE  VARIABLE  zero_unposted_var  LIKE  mfc_logical
   label {&reuvup_p_9} initial YES  no-undo.
define variable zero_cum_var like mfc_logical
   label {&reuvup_p_10} initial YES  no-undo.
DEFINE VARIABLE wcdesc LIKE wc_desc .
DEFINE VARIABLE desc1  LIKE pt_desc1 .
DEFINE VARIABLE desc2  LIKE pt_desc2 .
DEFINE VARIABLE desc3  LIKE pt_desc1 .
DEFINE VARIABLE desc4  LIKE pt_desc2 .
DEFINE VARIABLE start_date AS DATE .   


    
    /* SELECT FORM */
		form
		  site         COLON 15
		  site1        COLON 49 label {t001.i}
		  line         COLON 15
		  line1        COLON 49 label {t001.i}
		  part         COLON 15 
		  part1        COLON 49 label {t001.i}
		  zero_unposted_var    colon 32
      zero_cum_var         colon 32
		  v_year       COLON 15 LABEL '年度'
		  v_month      COLON 15 LABEL '月份'
		  SKIP(1)
		WITH  FRAME  a SIDE-LABELS  ATTR-SPACE  WIDTH  80.
	
/* SET EXTERNAL LABELS */
setFrameLabels (FRAME  a:HANDLE ).
	
ASSIGN v_year = YEAR(TODAY) v_month = MONTH(TODAY) site = global_site  site1 = global_site .
{wbrp01.i}

/* REPORT BLOCK */

mainloop:
REPEAT :

    /* INPUT OPTIONS */
    IF  site1 = hi_char THEN  ASSIGN  site1 = "".
    IF  line1 = hi_char THEN  ASSIGN  line1 = "".
    IF  part1 = hi_char THEN  ASSIGN  part1 = "".


    IF  c-application-mode <> 'web' THEN 
        update 
            site   
            site1  
            line   
            line1  
            part   
            part1  
            zero_unposted_var
            zero_cum_var     

            v_year 
            v_month
            with frame a.
            
    {wbrp06.i &command = update &fields = " 
                                    site   
																		site1  
																		line   
																		line1  
																		part   
																		part1  
																		zero_unposted_var
                                    zero_cum_var     
																		v_year 
																		v_month

              " &frm = "a"}
              

	   
    IF  (c-application-mode <> 'web') OR 
       (c-application-mode = 'web' AND 
       (c-web-request begins 'data')) THEN  DO :
    
        RUN  quote-vars .

        if site1     = "" then assign site1 = hi_char.
        if line1     = "" then assign line1 = hi_char.
        if part1     = "" then assign part1 = hi_char.

    end.  /* if (c-application-mode <> 'web') ... */

    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

    /* main programmer */

    IF v_month = 12 THEN v_ini_date = DATE( 1  , 1 , v_year + 1) - 1 .
    ELSE v_ini_date = DATE(v_month + 1  , 1 , v_year) - 1 .
    ASSIGN start_date  =   DATE(v_month  , 1 , v_year) .
 	   PUT UNFORMATTED "#def REPORTPATH=$/Minth/sswomlv" SKIP.
	   PUT UNFORMATTED "#def :end" SKIP.    
	   EMPTY TEMP-TABLE tt1.
	   EMPTY TEMP-TABLE ssvdef2 .  

				{gprun.i ""ssreworp01.p"" 
					                "(input  '' ,    
					                 input  '' ,   
				                   input    part  ,
				                   input    part1 ,
				                   input    site  ,
				                   input    site1 ,
				                   input    line ,
				                   input    line1  ,
				                   input   start_date , 
				                   input   v_ini_date  
				                  )"   }
				                  
				     FOR EACH ssvdef2 NO-LOCK  :
				
                        /* SS - 100401.1 - B 
				    	{gprun.i ""ssreuvup1.p"" "(input  ssvdef2_effdate ,           
				                         input    ssvdef2_part  ,
				                         input    ssvdef2_part ,
				                         input    ssvdef2_site  ,
				                         input    ssvdef2_site ,
				                         input    ssvdef2_line ,
				                         input    ssvdef2_line  ,
				                         input zero_unposted_var ,
				                         input zero_cum_var     ,
				                         input ssvdef2_lot ,
				                         input ssvdef2_lot
				  
				                   )"   }
                           SS - 100401.1 - E */
                        /* SS - 100401.1 - B */
                            {gprun.i ""xxreuvup1xp.p"" "(input  ssvdef2_effdate ,           
                                             input    ssvdef2_part  ,
                                             input    ssvdef2_part ,
                                             input    ssvdef2_site  ,
                                             input    ssvdef2_site ,
                                             input    ssvdef2_line ,
                                             input    ssvdef2_line  ,
                                             input zero_unposted_var ,
                                             input zero_cum_var     ,
                                             input ssvdef2_lot ,
                                             input ssvdef2_lot
                      
                                       )"   }
                        /* SS - 100401.1 - E */
				                        	  
				     END.	   
	   
	/*   
    	{gprun.i ""ssreuvup1.p"" "(input  v_ini_date ,
                         input    part  ,
                         input    part1 ,
                         input    site  ,
                         input    site1 ,
                         input    line  ,
                         input    line1 ,
                         input zero_unposted_var ,
                         input zero_cum_var     
                   )"   }
  */              
  
    /* REPORT TRAILER  */
   
    {mfreset.i}
END .
{wbrp04.i &frame-spec = a}

PROCEDURE quote-vars:
    /* CREATE BATCH INPUT STRING */
    assign bcdparm = "".
    {mfquoter.i site      }
    {mfquoter.i site1         }
    {mfquoter.i line          }
    {mfquoter.i line1         }
    {mfquoter.i part          }
    {mfquoter.i part1        }
    {mfquoter.i zero_unposted_var }
    {mfquoter.i zero_cum_var }
    {mfquoter.i v_year       }
    {mfquoter.i v_month     }

END PROCEDURE.