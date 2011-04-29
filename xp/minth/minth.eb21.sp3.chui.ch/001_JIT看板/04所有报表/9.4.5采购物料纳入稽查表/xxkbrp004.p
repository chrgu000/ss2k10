/* xxkbrp004.p  采购物料纳入稽查表                                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */


/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xmpt_part .
define var part1 like xmpt_part .
define variable supplier_from like po_vend.
define variable supplier_to   like po_vend.
define var v_buyer    like ptp_buyer   label  "计划员" .
define var v_buyer1   like ptp_buyer   label  "计划员" .
define var date_from  as date label "截止日期" .
define var date_to    as date .

/* date_to = today .                               */
/* date_from  = date(month(today),1,year(today)) . */


define var v_type as char label "采购属性" .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define variable disp_qty like schd_upd_qty.
define variable mqty like  schd_upd_qty .
define variable plannbr like pod_nbr.
define variable planline like pod_line.

define var v_qty_req  like tr_qty_loc label "需求量".
define var v_qty_rct  like tr_qty_loc label "收料量".
define var v_qty_rjt  like tr_qty_loc label "退料量".
define var v_qty_err  like tr_qty_loc label "差异量".




define temp-table plan_det no-undo
   field  plan_domain    like pt_domain
   field  plan_part      LIKE pt_part
   field  plan_nbr       like po_nbr
   field  plan_line      like pod_line

   field  plan_vend      like  po_vend
   field  plan_um        like  pod_um

   field  plan_req       like seq_qty_req 
   field  plan_rcvd      like seq_qty_req 
   field  plan_rjct      like seq_qty_req  .

/*    field  plan_date      like  pod_due_date               */
/*    field  plan_receiver  like prh_receiver format "x(39)" */
/*    field  plan_open      like pod_qty_ord                 */
/*    field  plan_avail     as  logical                      */
/*    field  plan_prh       as  logical                      */
/*    field  plan_cum_open  like pod_qty_ord                 */
/*    field  plan_cum_req   like seq_qty_req                 */
/*    field  plan_cum_rcvd  like pod_qty_ord                 */
/*    field  plan_max_rcvd   like pod_qty_ord                */
/*    field  plan_rlse_id   like  schd_rlse_id .             */
/*    index  plan1 IS PRIMARY plan_DOMAIN  ASCENDING  plan_vend                                 */
/*                 ASCENDING  plan_nbr  ASCENDING plan_line  ASCENDING   plan_date ASCENDING    */
/*    index  plan2  plan_DOMAIN  ASCENDIN    plan_vend                                          */
/*                 ascending plan_nbr  ASCENDING plan_line  ASCENDING   plan_date descending  . */




define var site  like xmpt_site .
find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .
 

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    part                      colon 18
    part1                     colon 54   label  {t001.i} 
    v_buyer                   colon 18   label  "计划员"
    v_buyer1                  colon 54   label  {t001.i} 
    supplier_from             colon 18   label  "供应商"
    supplier_to               colon 54   label  {t001.i}
    date_from                 colon 18
    date_to                   colon 54   label  {t001.i} 
    
    skip(1)

    
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part       then part1 = "".
    if supplier_to  = supplier_from         then supplier_to  = "".
    if v_buyer1  = v_buyer         then v_buyer1  = "".
    if date_to = hi_date      then date_to = ? .
    if date_from  = low_date  then date_from = ? .
    
    if c-application-mode <> 'web' then  
        update part part1 v_buyer v_buyer1 supplier_from supplier_to  date_from  date_to   with frame a.

	{wbrp06.i &command = update &fields = "  part part1 v_buyer v_buyer1 supplier_from supplier_to  date_from  date_to  "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:



        bcdparm = "".
        {mfquoter.i part     }
        {mfquoter.i part1    }
        {mfquoter.i v_buyer     }
        {mfquoter.i v_buyer1     }  
        {mfquoter.i supplier_from       }
        {mfquoter.i supplier_to      }
        {mfquoter.i date_from      }
        {mfquoter.i date_to     }

        if date_from <> low_date and date_to = ? 
                                then date_to = date_from .
        if date_from = ?        then date_from = low_date .
        if date_to = ?          then date_to = hi_date.        
        if supplier_to  = ""    then supplier_to  = supplier_from .
        if part1 = ""           then part1 = part.
        if v_buyer1 = ""        then v_buyer1 = v_buyer .

	end.  /* if c-application-mode <> 'web' */

    /* PRINTER SELECTION */
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
    mainloop: 
    do on error undo, return error on endkey undo, return error:   

/* put skip "test start: " string(time,"hh:mm:ss")skip . */
/* {mfphead.i}                                           */


PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxkbrp004" SKIP.
PUT UNFORMATTED "#def :end" SKIP. 

for each plan_det:
    delete plan_det.
end.


for each scx_ref no-lock 
              where scx_ref.scx_domain = global_domain and  scx_type = 2
              and scx_shipfrom >= supplier_from and ( scx_shipfrom <= supplier_to or supplier_to = "" )
              and scx_part >= part and ( scx_part <= part1 or part1 = "" ) ,
    each pod_det no-lock
               where pod_det.pod_domain = global_domain 
               and  pod_nbr = scx_order and pod_line = scx_line,
    each po_mstr no-lock
              where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
              and po_buyer >= v_buyer and ( po_buyer <= v_buyer1 or v_buyer1 = "" ) ,      
    each sch_mstr  where sch_mstr.sch_domain = global_domain and  sch_type = 4 
               and sch_nbr = pod_nbr and sch_line = pod_line
               /* and sch_eff_start <= date_to and (sch_eff_end >= date_from or sch_eff_end = ? ) */
               and sch_rlse_id = pod_curr_rlse_id[1] no-lock,
    each schd_det no-lock
              where schd_det.schd_domain = global_domain and  schd_type = sch_type
              and schd_nbr = sch_nbr and schd_line = sch_line and schd_rlse_id = sch_rlse_id
              and  schd_date >= date_from and schd_date <= date_to
    break by  schd_type by schd_rlse_id by schd_nbr by schd_line by schd_date :

          disp_qty = if sch_cumulative then schd_cum_qty else schd_discr_qty.
    
    
          find first plan_det 
                 where plan_domain = global_domain and plan_nbr = po_nbr 
                 and plan_line = scx_line and plan_part = scx_part 
                 /* and plan_date = schd_date */
                 exclusive-lock no-error.
          if not available plan_det then do:
                create plan_det .
                assign plan_domain = global_domain
                       plan_vend = po_vend
                       plan_nbr = po_nbr
                       plan_line = scx_line
                	   plan_part = scx_part   
                	   plan_um   = pod_um     .
    	  end.
    
          plan_req  = plan_req  + disp_qty.
    	   
     
end.  /*   for each scx_ref no-lock */

release scx_ref.
release pod_det.
release po_mstr.
release sch_mstr.
release schd_det.


for each prh_hist no-lock
           where prh_domain = global_domain
           and  prh_rcp_date >= date_from and prh_rcp_date <= date_to
           and  prh_part >= part and (prh_part <= part1 or part1 = "" )
           and  prh_vend >= supplier_from and (prh_vend <= supplier_to or supplier_to = "" )
           and  prh_buyer >= v_buyer and (prh_buyer <= v_buyer1 or v_buyer1 = "" )
           and  prh_type = ""   ,
    each pod_det no-lock
           where pod_domain = global_domain and pod_nbr = prh_nbr and pod_line = prh_line
    with frame c down width 240 no-box:

    find first plan_det where plan_domain = global_domain
                        and plan_nbr = prh_nbr
                        and plan_line = prh_line
                        and plan_part = prh_part
                        /* and plan_date = prh_rcp_date */
                        no-error.
    if available plan_det then do:
        if prh_rcvd > 0 then plan_rcvd = plan_rcvd + prh_rcvd.
        else plan_rjct = plan_rjct + prh_rcvd.
    end.
    else do:
        create plan_det .
        assign plan_domain = global_domain
               plan_vend  = prh_vend
               plan_nbr  = prh_nbr
               plan_line = prh_line
               plan_part = prh_part
               plan_um   = prh_um
               plan_rcvd = if  prh_rcvd > 0 then prh_rcvd else 0 
               plan_rjct = if  prh_rcvd < 0 then prh_rcvd else 0 
               plan_req = 0
               .
    end.
end. /*for each prh_hist*/


for each plan_det exclusive-lock break by plan_part by plan_nbr by plan_line with frame x with width 300 :
    if first-of(plan_part) then do:
        v_qty_req = 0 .
        v_qty_rct = 0 .
        v_qty_rjt = 0 .
        v_qty_err = 0 .
    end.
    v_qty_req = v_qty_req + plan_req .
    v_qty_rct = v_qty_rct + plan_rcvd .
    v_qty_rjt = v_qty_rjt + plan_rjct .
    

    if last-of(plan_part) then do:
        find first  xppt_mstr where xppt_domain =global_domain and xppt_site = site and xppt_part = plan_part no-lock no-error .
        v_type = if avail xppt_mstr then xppt_type else "" .
        find first code_mstr where code_domain = global_domain and code_fldname = "xppt_type" and code_value = v_type no-lock no-error .
        v_type =  if avail code_mstr then code_cmmt else "" .

        find first pt_mstr where pt_domain = global_domain and pt_part = plan_part no-lock no-error .
        desc1 = if avail pt_mstr then pt_desc1 else "" .
        desc2 = if avail pt_mstr then pt_desc2 else "" .

        v_qty_err = v_qty_req - ( v_qty_rct - v_qty_rjt ).


        export delimiter ";"  
            v_type    
            plan_part           
            desc1            
            desc2                     
            plan_um                  
            v_qty_req                   
            v_qty_rct               
            v_qty_rjt                
            v_qty_err 
            ""
            "" .
        
        /*         disp                                                      */
        /*                  v_type                          label "采购属性" */
        /*                  plan_part                       label "零件编号" */
        /*                  desc1                           label "说明"     */
        /*                  desc2                           label "说明"     */
        /*                  plan_um                         label "UM"       */
        /*                  v_qty_req                       label "需求量"   */
        /*                  v_qty_rct                       label "收料量"   */
        /*                  v_qty_rjt                       label "退料量"   */
        /*                  v_qty_err                       label "差异量"   */
        /*          with frame x .                                           */

    end.

    /*     disp                                                      */
    /*              plan_nbr                        label "采购单号" */
    /*              plan_line                       label "项"       */
    /*              plan_vend                       label "供应商"   */
    /*              plan_part                       label "零件编号" */
    /*              plan_um                         label "UM"       */
    /*              plan_req                        label "需求量"   */
    /*              plan_rcvd                       label "收料量"   */
    /*              plan_rjct                       label "退料量"   */
    /*      with frame x .                                           */


        /* {mfrpchk.i} */
end.  /* for each plan_det */

    for each plan_det:
        delete plan_det.
    end.
    
    /* put skip(3) "test end: " string(time,"hh:mm:ss") skip . */
        
    end. /* mainloop: */
    /* {mfrtrail.i}  REPORT TRAILER  */
    {mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
