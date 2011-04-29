
/* xxxxwowarp10.p - MATERIAL ITEM ISSUE REPORT                                */
/* GUI CONVERTED from xxwowarp10.p (converter v1.71) Tue Oct  6 14:58:29 1998 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 05/01/86   BY: EMB      */
/* REVISION: 1.0      LAST MODIFIED: 09/02/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 10/16/87   BY: WUG *A94**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: WUG *A175**/
/* REVISION: 5.0      LAST MODIFIED: 04/10/89   BY: MLB *B096**/
/* REVISION: 5.0      LAST MODIFIED: 10/26/89   BY: emb *B357**/
/* REVISION: 6.0      LAST MODIFIED: 01/22/91   BY: bjb *D248*/
/* Revision: 7.3      Last edit:     11/19/92   By: jcd *G348* */
/* Revision: 7.3      Last edit:     02/09/93   By: emb *G656* */
/* REVISION: 7.2      LAST MODIFIED: 02/28/95   BY: ais *F0KM*/
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: ays *K0WP */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */
/* SS - 090924.1 By: Neil Gao */

     /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdtitle.i "090924.1"} /*G656*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE xxwowarp10_p_1 "         加工单合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxwowarp10_p_2 "子零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxwowarp10_p_3 "    短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxwowarp10_p_4 "备料量/领料量"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxwowarp10_p_5 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxwowarp10_p_6 "工作中心"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable vend like wo_vend.
     define variable nbr like wod_nbr.
     define variable nbr1 like wod_nbr.
/*F0KM   define variable part like wod_part. */
/*F0KM*/ define variable part like wod_part  label {&xxwowarp10_p_2}.
     define variable part1 like wod_part.
     define variable iss_date like wod_iss_date.
     define variable iss_date1 like wod_iss_date.
     define variable so_job like wo_so_job.
     define variable so_job1 like wo_so_job.
     define variable desc1 like pt_desc1.
     define variable open_ref like wod_qty_all label {&xxwowarp10_p_5}.
     define variable parent_part like ps_par.
     define variable so_job_nbr like wo_so_job.
     define variable all_pick like wod_qty_all label {&xxwowarp10_p_4}.
     define variable ptloc  like pt_loc.
     define variable ptloc1 like pt_loc.
     define variable wkctr  like wc_wkctr.
     define variable wkctr1 like wc_wkctr.

     define variable reqqty like wod_qty_req.
     define variable issqty like wod_qty_iss.
     define variable allqty like wod_qty_all.
     define variable openqty like open_ref.
     
/*plj*/ define variable pt_routing1 like pt_routing.   
     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        ptloc         colon 15
        ptloc1        label {t001.i} colon 49 skip
        wkctr          colon 15
        wkctr1         label {t001.i} colon 49 skip
        nbr            colon 15
        nbr1           label {t001.i} colon 49 skip
        part           colon 15 
        part1          label {t001.i} colon 49 skip(1)
      SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).


/*K0WP*/ {wbrp01.i}

repeat :

        if part1 = hi_char then part1 = "".


				update ptloc ptloc1 wkctr wkctr1 nbr nbr1 part part1 with frame a.

/*K0WP*/ if (c-application-mode <> 'web':u) or
/*K0WP*/ (c-application-mode = 'web':u and
/*K0WP*/ (c-web-request begins 'data':u)) then do:


        bcdparm = "".
        reqqty = 0.
        issqty = 0.
        allqty = 0.
        openqty = 0.        
        {mfquoter.i ptloc   }
        {mfquoter.i ptloc1  }
        {mfquoter.i wkctr    }
        {mfquoter.i wkctr1   }
        {mfquoter.i part   }
        {mfquoter.i part1  }
        {mfquoter.i nbr    }
        {mfquoter.i nbr1   }
        {mfquoter.i iss_date}
        {mfquoter.i iss_date1}

        if part1 = "" then part1 = hi_char.
        if nbr1 = "" then nbr1 = hi_char.
        if ptloc1 = "" then ptloc1 = hi_char.
        if wkctr1 = "" then wkctr1 = hi_char.


/*K0WP*/ end.

        /* SELECT PRINTER  */
					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

/* SS 090924.1 - B */
        {mfphead1.i}
/* SS 090924.1 - E */
/*plj ++++ */

	    for each wo_mstr no-lock where (wo_nbr >= nbr and wo_nbr <= nbr1)
/*SS 20090207 - B*/
			and wo_domain = global_domain
/*SS 20090207 - E*/	    
	    ,
	    each wod_det where wod_lot = wo_lot
/*SS 20090207 - B*/
			and wod_domain = global_domain
/*SS 20090207 - E*/
	    and (wod_part >= part) and (wod_part <= part1 or part1 = "")
	    exclusive-lock break by wo_nbr by wod_lot :
	    
              find first ro_det where ro_routing = wo_part 
/*SS 20090207 - B*/
								and ro_domain = global_domain
/*SS 20090207 - E*/              
              no-lock no-error.
                if available ro_det then assign wod_deliver = ro_wkctr.                   
                  else do:
                    find first pt_mstr where pt_part = wo_part 
/*SS 20090207 - B*/
										and pt_domain = global_domain
/*SS 20090207 - E*/                    
                    no-lock no-error.
                    if available pt_mstr then assign pt_routing1 = pt_routing.             
                      if pt_routing1 <> "" then do:
                        find first ro_det where ro_routing = pt_routing1 
/*SS 20090207 - B*/
												and ro_domain = global_domain
/*SS 20090207 - E*/                        
                        no-lock no-error.
                        if available ro_det then assign wod_deliver = ro_wkctr.                   
                      end.  
                end.

              find first pt_mstr where pt_part = wod_part 
/*SS 20090207 - B*/
								and pt_domain = global_domain
/*SS 20090207 - E*/              
              no-lock no-error.
                if available pt_mstr then assign wod_user1 = pt_loc.                   
   
              for each lad_det where lad_dataset = "wod_det" 
/*SS 20090207 - B*/
							and lad_domain = global_domain
/*SS 20090207 - E*/
              and lad_nbr = wod_lot and lad_part = wod_part 
              exclusive-lock use-index lad_det:
                assign lad_user1 = wod_deliver.
              end.             
            
            end.
/*plj ++++ */
        /* FIND AND DISPLAY */
/********
        for each wod_det where (wod_part >= part and wod_part <= part1)
        and (wod_nbr >= nbr) and (wod_nbr <= nbr1 or nbr1 = "")
        and (wod_iss_date >= iss_date or iss_date = ?)
        and (wod_iss_date <= iss_date1 or iss_date1 = ?)
        no-lock break by wod_part by wod_nbr
        with frame b width 132 no-attr-space:
*******/

        for each wod_det where (wod_part >= part and wod_part <= part1)
/*SS 20090207 - B*/
				and wod_domain = global_domain
/*SS 20090207 - E*/
        and (wod_nbr >= nbr) and (wod_nbr <= nbr1 or nbr1 = "")
        and (wod_deliver >= wkctr and wod_deliver <= wkctr1 )
        and (wod_user1 >= ptloc ) and (wod_user1 <= ptloc1 or ptloc1 =""),
        each wo_mstr where wo_lot = wod_lot and wo_status = "R"
/*SS 20090207 - B*/
				and wo_domain = global_domain
/*SS 20090207 - E*/
        no-lock break by wod_user1 by wod_part by wod_nbr 
        with frame b width 132 no-attr-space:
        setFrameLabels(frame b:handle).

/*G656*/   if first-of(wod_part) or first-of(wod_nbr) /*or first-of(wod_deliver)*/  then do:
              desc1 = "".

              find pt_mstr where pt_part = wod_part 
/*SS 20090207 - B*/
								and pt_domain = global_domain
/*SS 20090207 - E*/              
              no-lock no-error.
              if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.
             /*   if page-size - line-counter < 5 then do:
                  put skip(1).
                  put "计划员:__________     检查员:__________     发料人:__________     签收人:__________     发料日期:_________" at 6 skip(1). 
                  page.               
                end.  */
                put "加工单:" at 3 wod_nbr format "x(18)" at 11 /*"加 工 单 原 料 (钢材) 发 料 单" at 43*/ /* "加工中心:" at 95 wod_deliver at 106*/.
                put "子零件号:" at 1 wod_part at 10 desc1 format "x(42)" at 28 "代用子零件号:" at 70  "单位:" at 112 pt_um at 117 skip(1).
                put "  标志        父 零 件      父件需求量 父已完成量 父件短缺量 父单件用量 材料需求量 备料/领料   已发放量    短缺量    实 发" at 1.
                put "-------- ------------------ ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------" at 1.
              
           end.

           open_ref = wod_qty_req - wod_qty_iss.

/*B357*/   if wod_qty_req >= 0
/*B357*/   then open_ref = max(wod_qty_req - wod_qty_iss,0).
/*B357*/   else open_ref = min(wod_qty_req - wod_qty_iss,0).

           all_pick = wod_qty_all + wod_qty_pick.
           parent_part = "".
           so_job_nbr = "".

           accumulate wod_qty_req (total by wod_part by wod_nbr  ).
           accumulate all_pick (total by wod_part by wod_nbr  ).
           accumulate wod_qty_iss (total by wod_part by wod_nbr  ).
           accumulate open_ref (total by wod_part by wod_nbr  ).
           
           reqqty = reqqty + wod_qty_req.
           issqty = issqty + wod_qty_iss.
           allqty = allqty + all_pick.
           openqty = openqty + open_ref.

/* Only Release WO can be print */
         /*  if page-size - line-counter < 3 then do:
             put skip(1).
             put "计划员:__________     检查员:__________     发料人:__________     签收人:__________     发料日期:_________" at 6 skip(1). 
             page.    
             put "加工单:" at 3 wod_nbr format "x(18)" at 11 /*"加 工 单 原 料 (钢材) 发 料 单" at 43*/ /* "加工中心:" at 95 wod_deliver at 106*/.
             put "子零件号:" at 1 wod_part at 10 desc1 format "x(42)" at 28 "代用子零件号:" at 70  "单位:" at 112 pt_um at 117 skip(1).
             put "  标志        父 零 件      父件需求量 父已完成量 父件短缺量 父单件用量 材料需求量 备料/领料   已发放量    短缺量    实 发" at 1.
             put "-------- ------------------ ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------" at 1.
           end.  */
           put wod_lot at 1 wo_part at 10 wo_qty_ord format ">>>>>9.9<<" to 38 wo_qty_comp format "->>>>9.9<<" to 49 wo_qty_ord - wo_qty_comp - wo_qty_rjct format "->>>>9.9<<" to 60 wod_bom_qty format ">>>>9.9<<<" to 71 wod_qty_req format ">>>>9.9<<<" to 82
               all_pick format "->>>9.9<<<" to 93 wod_qty_iss format "->>>9.9<<<" to 104 open_ref format "->>>9.9<<<" to 115 "(     )" at 117.
        /*   if page-size - line-counter > 3 then do:   */
             put skip(1).
/*           end.*/
           if last-of(wod_nbr) or last-of(wod_part)  then do:
             put "---------- ---------- ---------- ----------" at 73.
             put "加工单合计:" at 61 reqqty format ">>>>9.9<<<" to 82 allqty format "->>>9.9<<<" to 93 issqty format "->>>9.9<<<" to 104 openqty format "->>>9.9<<<" to 115 "(     )" at 117 skip(2).
             reqqty = 0.      
             issqty = 0.
             allqty = 0.
             openqty = 0.        
              
          /* end.
           if page-size - line-counter < 2 then do:*/
             put "计划员:__________     检查员:__________     发料人:__________     签收人:__________     发料日期:_________" at 6 skip(1). 
             if not last(wod_nbr) then page.          
            /* put "加工单:" at 3 wod_nbr format "x(18)" at 11 /*"加 工 单 原 料 (钢材) 发 料 单" at 43*/  /*"加工中心:" at 95 wod_deliver at 106*/.
             put "子零件号:" at 1 wod_part at 10 desc1 format "x(42)" at 28 "代用子零件号:" at 70  "单位:" at 112 pt_um at 117 skip(1).
             put "  标志        父 零 件      父件需求量 父已完成量 父件短缺量 父单件用量 材料需求量 备料/领料   已发放量    短缺量    实 发" at 1.
             put "-------- ------------------ ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------" at 1.*/
           end.    
        end.
/* SS 090924.1 - B */
/*
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .
*/
	{mfreset.i}
	{mfgrptrm.i}
/* SS 090924.1 - E */

     end.

/*K0WP*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end.
