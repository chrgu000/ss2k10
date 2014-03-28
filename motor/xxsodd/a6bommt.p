/* pppsiq10.p - ITEM / SITE PRODUCT STRUCTURE INQUIRY                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K0ZR*/
/*V8:ConvertMode=Report                                        */
/* REVISION: 7.0             LAST EDIT: 12/17/91       MODIFIED BY: emb */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G345* */
/* Revision: 7.3        Last edit: 02/24/94             By: ais *FM43* */
/* Revision: 7.3        Last edit: 09/11/94             By: qzl *FR16* */
/* Revision: 7.5        Last edit: 01/16/95             By: dzs *J020* */
/* REVISION: 8.5      LAST MODIFIED: 06/26/96   BY: *G1YQ* Julie Milligan   */
/* REVISION: 7.3      LAST MODIFIED: 10/14/96   BY: *G2GV* Murli Shastri    */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: mur *K0ZR*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 9.0      LAST MODIFIED: 09/22/98   BY: *J30L* Raphael T.       */
/* REVISION: 9.0      LAST MODIFIED: 02/12/99   BY: *M080* Prashanth Narayan*/
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 07/15/99   BY: *J3J4* Jyoti Thatte     */
/* REVISION: 9.1      LAST MODIFIED: 08/31/99   BY: *N027* Prashanth Narayan*/
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MD* Mudit Mehta      */

         /* DISPLAY TITLE 
         {mfdtitle.i "b+ "}
*/
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pppsiq10_p_1 "/no"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppsiq10_p_2 "As of Dt"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppsiq10_p_3 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppsiq10_p_5 "Levels"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppsiq10_p_7 "Ph"
/* MaxLen: Comment: 
*/

&SCOPED-DEFINE pppsiq10_p_8 "Parent Item/BOM Code"
/* MaxLen:26 Comment: Parent Item or Bill Of Material Code */


/* ********** End Translatable Strings Definitions ********* */

         DEFINE  VARIABLE  site  LIKE  ptp_site .
         DEFINE  VARIABLE  comp  LIKE  ps_comp .
         DEFINE  VARIABLE  level AS    INTEGER .
         DEFINE  VARIABLE  maxlevel  AS  INTEGER  FORMAT  ">>>"  LABEL  {&pppsiq10_p_5} .
         DEFINE  VARIABLE  eff_date LIKE  ar_effdate   COLUMN-LABEL  {&pppsiq10_p_2} .
         DEFINE  VARIABLE  PARENT   LIKE  ps_par LABEL  {&pppsiq10_p_8} NO-UNDO .
         DEFINE  VARIABLE  desc1    LIKE  pt_desc1.
         DEFINE  VARIABLE  um       LIKE  pt_um.
         DEFINE  VARIABLE  phantom  LIKE  mfc_logical FORMAT  "yes" LABEL  {&pppsiq10_p_7}.
         DEFINE  VARIABLE  iss_pol  LIKE  pt_iss_pol  FORMAT  {&pppsiq10_p_1}.
         DEFINE  VARIABLE  lvl      AS   character    FORMAT  "x(7)" LABEL  {&pppsiq10_p_3}.
         DEFINE  VARIABLE  bom_code LIKE  pt_bom_code .  
         DEFINE  FRAME  heading .
         DEFINE  VARIABLE limit_level AS INTEGER INIT 1 .
         /*定义输入参数....*/
         DEFINE  VARIABLE  pm_code   LIKE pt_pm_code .
         DEFINE  VARIABLE  yld_pct   LIKE ptp_yld_pc .
         DEFINE  VARIABLE  key_part  LIKE mfc_logical .
         DEFINE  INPUT PARAMETER i_part LIKE ps_comp .
         DEFINE  INPUT PARAMETER i_site LIKE ptp_site .
         DEFINE  INPUT PARAMETER i_effdate LIKE ar_effdate . 
         DEFINE  INPUT PARAMETER i_maxlevel  AS  INTEGER .
         DEFINE  INPUT PARAMETER i_week  AS  INTEGER . 
         DEFINE  INPUT PARAMETER i_duedate   AS DATE .   
         DEFINE  INPUT PARAMETER i_rqqty     AS INTEGER FORMAT '->,>>>,>>9'   .
         DEFINE  INPUT PARAMETER i_year LIKE fcs_year  .  
       
         

         DEFINE  VARIABLE  l_textfile        AS  CHARACTER  NO-UNDO .
         DEFINE  VARIABLE  DISP_SORT         AS INTEGER .
         DEFINE  VARIABLE  lev_qty_per       LIKE ps_qty_per  EXTENT  99 .
         DEFINE  VARIABLE  lev_qty_yld       LIKE ptp_yld_pct EXTENT 99 .
         DEFINE  VARIABLE  lev_qty_scr       LIKE ps_scrp_pct EXTENT 99 .
         DEFINE  VARIABLE  comp_rel_date     LIKE wo_rel_date EXTENT 99 .
         DEFINE  VARIABLE  comp_due_date     LIKE wo_due_date EXTENT 99 .
         DEFINE  VARIABLE  pare_qty_per      LIKE ps_qty_per INIT 0 .
         DEFINE  VARIABLE  pare_qty_yld      LIKE ptp_yld_pct INIT 0 .
         DEFINE  VARIABLE  pare_qty_scr      LIKE ps_scrp_pct INIT 0.
         DEFINE  VARIABLE  comp_qty_per      LIKE ps_qty_per INIT 0 .
         DEFINE  VARIABLE  comp_qty_yld      LIKE ptp_yld_pct INIT 0 .
         DEFINE  VARIABLE  comp_qty_scr      LIKE ps_scrp_pct INIT 0.
         DEFINE  VARIABLE  val_rel_date      LIKE wo_rel_date .
         DEFINE  VARIABLE  val_due_date      LIKE wo_due_date .
         DEFINE  VARIABLE  lev_rel_date      LIKE wo_rel_date .
         DEFINE  VARIABLE  lev_due_date      LIKE wo_due_date .
         DEFINE  VARIABLE  i                 AS INTEGER INIT 1 .
         DEFINE  VARIABLE  interval          AS INTEGER INIT 0 .
         DEFINE  VARIABLE sfty_time          LIKE pt_sfty_time .
         DEFINE  VARIABLE insp_lead          LIKE pt_insp_lead .
         DEFINE  VARIABLE leadtime           LIKE pt_pur_lead .
         DEFINE  VARIABLE insp_rqd           LIKE pt_insp_rqd .
         DEFINE  VARIABLE pt_back            LIKE pt_run_seq1 .
         DEFINE  VARIABLE is_return          LIKE mfc_logical INIT NO .
         
        { mfglobal.i} 
         
         ASSIGN eff_date = TODAY .
/*
         FORM 
            space(1) 
            PARENT 
            site 
            eff_date 
            maxlevel 
/*K0ZR*/  WITH  FRAME  a  WIDTH  80 ATTR-SPACE  NO-UNDERLINE .
*/
 
/* SS - HILL - BEG   ADDED   */
       /*接受参数...*/
       ASSIGN  PARENT = i_part 
               site   = i_site 
               eff_date =  i_effdate
               maxlevel =  i_maxlevel 
               .
           
/* SS - HILL - END   ADDED */  


            FIND  pt_mstr USE-INDEX  pt_part WHERE  pt_domain = global_domain AND pt_part = PARENT  NO-LOCK  NO-ERROR .
             
	           IF  AVAILABLE  pt_mstr THEN  DO :
	               assign um = pt_um
	                   desc1 = pt_desc1
	                  parent = pt_part.
	           END .  /*IF  AVAILABLE  pt_mstr THEN  DO : */
	           ELSE  DO :
	            FIND  bom_mstr NO-LOCK  WHERE bom_domain = global_domain AND  bom_parent  = PARENT  NO-ERROR .
	            IF  AVAILABLE  bom_mstr THEN ASSIGN um = bom_batch_um  desc1 = bom_desc  parent = bom_parent .
	           END . /* IF  AVAILABLE  pt_mstr THEN  DO :....ELSE.....*/
                
/*  ss - hill - beg added   */

ASSIGN level = 1 comp = PARENT  .
/*   ss - hill - END added  */

/*N027*/    /* COMBINED FOLLOWING ASSIGNMENTS */
            FIND  ptp_det NO-LOCK  WHERE  ptp_domain = global_domain AND ptp_part = PARENT  AND ptp_site = site NO-ERROR .
            IF  AVAILABLE  ptp_det THEN ASSIGN comp    = IF  ptp_bom_code <> "" THEN  ptp_bom_code ELSE  ptp_part
/*N027*/                 phantom = ptp_phantom
/*N027*/                 iss_pol = ptp_iss_pol
                         /* ss - hill - added  -->*/
                         pm_code = ptp_pm_code
                         yld_pct = ptp_yld_pct
                         sfty_time  = ptp_sfty_tme 
                         insp_rqd   = ptp_ins_rqd
                         insp_lead  = ptp_ins_lead
                         leadtime   = IF ptp_pm_code = 'p' THEN ptp_pur_lead ELSE ptp_mfg_lead 
                         
                 
                .
            ELSE  IF  AVAILABLE  pt_mstr THEN ASSIGN  comp    = IF  pt_bom_code <> "" THEN  pt_bom_code  ELSE  pt_part
/*N027*/                 phantom = pt_phantom
/*N027*/                 iss_pol = pt_iss_pol
                          /* ss - hill - added  -->*/
                         pm_code = pt_pm_code
                         yld_pct = pt_yield_pct
                         sfty_time  = pt_sfty_time
                         insp_rqd  =  pt_insp_rqd 
                         insp_lead  = pt_insp_lead
                         leadtime   = IF pt_pm_code = 'p' THEN pt_pur_lead ELSE pt_mfg_lead 
                         
                .
            FIND pt_mstr WHERE pt_domain = global_domain AND pt_part = PARENT NO-LOCK NO-ERROR .
            IF AVAILABLE pt_mstr THEN pt_back = pt_run_seq1 .

               /*DETAIL FORM */
/*G1YQ*    FORM 
                  lvl
                  ps_comp
                  desc1
                  ps_qty_per
                  um
                  phantom
                  ps_ps_code
                  iss_pol
               WITH  FRAME  heading WIDTH  80 DOWN  NO-ATTR-SPACE  .
           */    
/*  ss - hill - beg added   */

ASSIGN pare_qty_per = 1  pare_qty_yld = yld_pct  pare_qty_per = 0  val_due_date = i_duedate  val_rel_date = i_duedate .
ASSIGN interval = sfty_time .
IF insp_rqd THEN interval = interval + insp_lead .
{a6cawkdt.i val_due_date  -1 site  interval 'm' }
ASSIGN val_rel_date = val_due_date interval = leadtime .
{a6cawkdt.i val_rel_date  -1 site  interval pm_code }
ASSIGN comp_due_date [ level ] = val_rel_date .

   ASSIGN DISP_sort  = 1 .
   /*
       CREATE a6rqd_det .
           ASSIGN a6rqd_site   =  site 
              a6rqd_cust       =  i_cust
              a6rqd_custpono   =  i_custpono
              a6rqd_custpoln   =  i_custpoln
              a6rqd_sort       =  DISP_sort 
              a6rqd_part       =  PARENT
              a6rqd_pmcode     =  pm_code 
              a6rqd_pt_code    =  phantom
              a6rqd_key        =  key_part 
              a6rqd_yld_pct    =  yld_pct
              a6rqd_scrap_pct  =  0 
              a6rqd_rel_date   = val_rel_date
              a6rqd_due_date   = val_due_date  
              a6rqd_rq_qty     = i_rqqty  * 100 / yld_pct 
              a6rqd_short_qty  = 0
              a6rqd_desc       = desc1
              a6rqd_run        = YES
              a6rqd_status     = 'S'
              a6rqd_sim_code   = 1  
               a6rqd_qty_per    = 1
               a6rqd_level      = 0 
               a6rqd_rq_date    = i_duedate
               .
     */
            IF pm_code = 'p' THEN ASSIGN is_return = YES .
            IF pm_code = 'p' AND pt_back = '' THEN DO:
                CREATE a6fcd_det .
                ASSIGN 
                       a6fcd_domain = global_domain 
                       a6fcd_part     = i_part
                       a6fcd_site     = site
                       a6fcd_year     = i_year
                       a6fcd_week     = i_week
                       a6fcd_pur_part = PARENT
                       a6fcd_pur_qty  =  i_rqqty  * 100 / yld_pct 
                       a6fcd_rel_date =  val_rel_date
                       a6fcd_due_date  = val_due_date   
                       a6fcd_rq_date    = i_duedate
                       .
                      
            END.
            ELSE ASSIGN pm_code = '' .

/*   ss - hill - END added  */
/*J30L*/   RUN  process_report IN  THIS-PROCEDURE  (INPUT  comp,INPUT  level).



/*   ss - hill - beg  remarked-->
            {mfreset.i}
<-- remarked   ss - hill - end added  */

             /* {mfmsg.i 8 1} */
/*
            global_part = PARENT .
            global_site = site .
*/
 /*   ss - hill - beg remarked-->
         end.
<-- remarked  ss - hill - end added  */

/* hill temp.. {wbrp04.i &frame-spec = a} ..*/

/*J30L*  BEGIN ADD PROCEDURE */

PROCEDURE  process_report:

        DEFINE  QUERY  q_ps_mstr FOR  ps_mstr .
        DEFINE  INPUT  PARAMETER  comp LIKE  ps_comp NO-UNDO .
        DEFINE  INPUT  PARAMETER  level AS  INTEGER  NO-UNDO .
                   /*DETAIL FORM */
        
        FIND  pt_mstr NO-LOCK  WHERE pt_domain = global_domain AND  pt_part = comp NO-ERROR .
        /*J3J4*/ if AVAILABLE  pt_mstr AND  pt_bom_code <> "" THEN /*J3J4*/    comp = pt_bom_code .
        
        OPEN  QUERY  q_ps_mstr FOR  EACH  ps_mstr USE-INDEX  ps_parcomp WHERE ps_domain = global_domain AND  ps_par = comp AND  ps_ps_code <> "J"  and ps_ps_code <> 'D' NO-LOCK .
        
        GET  FIRST  q_ps_mstr NO-LOCK .
        IF PM_CODE <> 'p' THEN ASSIGN IS_RETURN = NO .
        IF  NOT  AVAILABLE  ps_mstr THEN  RETURN .
              
        IF IS_RETURN THEN RETURN   . 
        
        
        REPEAT  WHILE  AVAIL  ps_mstr WITH  FRAME  heading  DOWN  :

          /* hill-temp {mfrpchk.i} */
        
          IF  eff_date = ? OR  (eff_date <> ? AND (ps_start = ? OR  ps_start <= eff_date) AND  (ps_end = ? OR  eff_date <= ps_end)) THEN  DO :
            ASSIGN  um = "" desc1 = "" iss_pol = no phantom = NO .
        
            FIND  pt_mstr WHERE pt_domain = global_domain AND  pt_part = ps_comp NO-LOCK  NO-ERROR .
            IF  AVAILABLE  pt_mstr THEN  DO : 
                ASSIGN  um = pt_um desc1 = pt_desc1 iss_pol = pt_iss_pol phantom = pt_phantom .
            END .
            ELSE  DO :
              FIND  bom_mstr NO-LOCK  WHERE bom_domain = global_domain AND  bom_parent = ps_comp NO-ERROR .
              IF  AVAILABLE  bom_mstr THEN ASSIGN  um = bom_batch_um  desc1 = bom_desc.
            END .
        
            ASSIGN  bom_code = ps_comp.
        
            FIND  ptp_det NO-LOCK  WHERE ptp_domain = global_domain AND  ptp_part = ps_comp AND  ptp_site = site NO-ERROR .
            IF  AVAILABLE  ptp_det THEN  ASSIGN  iss_pol = ptp_iss_pol phantom = ptp_phantom  
                /* ss - hill -> added  */ pm_code = ptp_pm_code  yld_pct = ptp_yld_pct  
                                         sfty_time  = ptp_sfty_tme 
                                         insp_rqd   = ptp_ins_rqd
                                         insp_lead  = ptp_ins_lead
                                         leadtime   = IF ptp_pm_code = 'p' THEN ptp_pur_lead ELSE ptp_mfg_lead .
            ELSE  IF  AVAILABLE  pt_mstr THEN  ASSIGN  iss_pol = pt_iss_pol phantom = pt_phantom
                 /* ss - hill -> added  */
                                        pm_code =  pt_pm_code  yld_pct  = pt_yield_pct 
                                     sfty_time  =  pt_sfty_time
                                      insp_rqd  =  pt_insp_rqd 
                                     insp_lead  =  pt_insp_lead
                                     leadtime   =  IF pt_pm_code = 'p' THEN pt_pur_lead ELSE pt_mfg_lead 
                                          .
        
            IF  AVAILABLE  ptp_det THEN bom_code = IF  ptp_bom_code <> "" THEN  ptp_bom_code ELSE  ptp_part .
            ELSE  IF  AVAILABLE  pt_mstr THEN bom_code = IF  pt_bom_code <> "" THEN  pt_bom_code ELSE  pt_part .
        
            lvl = ".......".
            lvl = SUBSTRING (lvl,1,MIN (level - 1,6)) + STRING (level).
            IF  LENGTH (lvl) > 7 THEN  lvl = SUBSTRING (lvl,LENGTH (lvl) - 6,7).
          
        
        /*  ss - hill - beg added   */
            IF level > 0 THEN  DO:
                 ASSIGN comp_qty_per = ( 1 * 100  / pare_qty_yld  )    i = 1 .
                 /* IF level = 1 THEN  ASSIGN lev_qty_per [ level ] = ps_qty_per ELSE ASSIGN lev_qty_per [ level ] = ps_qty_per * lev_qty_per [ level - 1 ] . */
                 ASSIGN    lev_qty_per [ level ] = ps_qty_per  lev_qty_yld [ level ] = yld_pct    lev_qty_scr [level] = ps_scrp_pct  .
            
                REPEAT:
                    IF i > level THEN LEAVE .
                    ASSIGN comp_qty_per = comp_qty_per * 100 * ( lev_qty_per [ i ] / ( 1 - lev_qty_scr [ i ] / 100 )) /  ( lev_qty_yld [ i ]  ) .
                    ASSIGN i = i + 1 .
                END.
            END.
            ELSE ASSIGN comp_qty_per = 1 .
           
            ASSIGN DISP_sort  = DISP_sort + 1 .

            IF level = 1 THEN  ASSIGN  lev_due_date = val_rel_date   .
            ELSE lev_due_date = comp_rel_date [ level - 1 ]  .

            ASSIGN interval = sfty_time .
            IF insp_rqd AND pm_code = 'p' THEN interval = interval + insp_lead .

            {a6cawkdt.i lev_due_date  -1 site  interval  'M' }

            
            ASSIGN lev_rel_date = lev_due_date  interval = leadtime .
            {a6cawkdt.i lev_rel_date  -1 site  interval pm_code }
            ASSIGN comp_rel_date [level] = lev_rel_date .
            
           FIND a6frc_cot WHERE a6frc_domain =  global_domain NO-LOCK NO-ERROR .
           
           FIND pt_mstr WHERE pt_domain = global_domain AND pt_part = ps_comp NO-LOCK NO-ERROR .
           IF AVAILABLE pt_mstr THEN pt_back = pt_run_seq1 .
           FIND ptp_det WHERE ptp_domain = global_domain AND  ptp_site = site AND ptp_part = ps_comp NO-LOCK  NO-ERROR .
           IF AVAILABLE ptp_det THEN pt_back = ptp_run_seq1 .  
           
            IF pm_code = 'p' THEN ASSIGN is_return = YES .
            IF pm_code = 'p' THEN DO:
            	 IF level = 1 THEN  ASSIGN  eff_date  = val_rel_date   .
               ELSE eff_date = comp_rel_date [ level - 1 ]  .
               IF eff_date <= TODAY THEN eff_date = TODAY .
            END.
            ELSE DO:
            	IF lev_rel_date >= TODAY THEN eff_date = lev_rel_date .
            	ELSE eff_date = TODAY .
            END.	
/*生产计划备料-BEG*/
   IF level <= limit_level THEN ASSIGN limit_level = 0 .
   
   IF pm_code <> 'p' AND pt_back <> '' AND limit_level = 0  THEN DO:
   	   ASSIGN limit_level = level .
   END. 
   
   
/*生产计划备料-END*/            
            
            IF   (pm_code = 'p' AND limit_level = 0 AND ((pt_back = '' AND a6frc_sele) OR (pt_back  <> '' AND ( NOT a6frc_sele )))) 
               OR 
                 (pm_code <> 'p' AND limit_level = level ) 
               THEN DO:
                CREATE a6fcd_det .
                ASSIGN a6fcd_domain = global_domain
                       a6fcd_part     = i_part
                       a6fcd_site     = site
                       a6fcd_year     = i_year
                       a6fcd_week     = i_week
                       a6fcd_pur_part = ps_comp
                       a6fcd_pur_qty  =  i_rqqty  * comp_qty_per
                       a6fcd_rel_date =  lev_rel_date 
                       a6fcd_due_date  = lev_due_date 
                       .
               IF level = 1 THEN  ASSIGN  a6fcd_rq_date  = val_rel_date   .
               ELSE a6fcd_rq_date = comp_rel_date [ level - 1 ]  .
              
            END.
            

        /*  ss - hill - end added   */      
              
              
              
        
            IF  AVAILABLE  ptp_det THEN  IF  ptp_bom_code <> "" THEN  bom_code = ptp_bom_code.
            ELSE  IF  AVAILABLE  pt_mstr AND  pt_bom_code <> "" THEN  bom_code = pt_bom_code.
        
          
        
            IF  level < maxlevel OR  maxlevel = 0 THEN  DO :
        /*J3J4** run process_report                                  */
        /*J3J4** in this-procedure (input ps_comp, input level + 1). */
        /*J3J4*/ RUN  process_report IN  THIS-PROCEDURE (INPUT  bom_code, INPUT  level + 1).
        
               GET  NEXT  q_ps_mstr NO-LOCK .
             END .
             ELSE  DO :
               GET  NEXT  q_ps_mstr NO-LOCK .
             END .
           END .  /* End of Valid date */
           ELSE  DO :
             GET  NEXT  q_ps_mstr NO-LOCK .
           END .
      
        END .  /* End of Repeat loop */
        CLOSE  QUERY  q_ps_mstr .
        
END  PROCEDURE .
/*J30L*  END ADD PROCEDURE */
