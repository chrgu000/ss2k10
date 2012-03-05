/* poporp.p - PURCHASE ORDER REPORT BY ORDER                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0     LAST MODIFIED: 04/18/90    BY: PML *D001**/
/* REVISION: 6.0     LAST MODIFIED: 10/22/90    BY: RAM *D125**/
/* REVISION: 6.0     LAST MODIFIED: 10/31/90    BY: pml *D157**/
/* REVISION: 6.0     LAST MODIFIED: 01/02/91    BY: RAM *D282**/
/* REVISION: 6.0     LAST MODIFIED: 03/19/91    BY: bjb *D461**/
/* REVISION: 7.0     LAST MODIFIED: 03/18/92    BY: TMD *F261** (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 02/18/93    BY: tjs *G704** (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    BY: ame *GN82**/
/* REVISION: 8.5     LAST MODIFIED: 09/27/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 04/08/96    BY: jzw *G1LD**/
/* REVISION: 8.6     LAST MODIFIED: 11/21/96    BY: *K022* Tejas Modi       */
/* REVISION: 8.6     LAST MODIFIED: 04/03/97    BY: *K09K* Arul Victoria    */
/* REVISION: 8.6     LAST MODIFIED: 10/11/97    BY: mur *K0M3*              */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane        */
/* REVISION: 8.6E    LAST MODIFIED: 06/11/98    BY: *L020* Charles Yen      */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* Mark Brown       */
/* REVISION: 9.1     LAST MODIFIED: 10/25/00    BY: *N0T7* Jean Miller      */

/* 以下为版本历史 */
/* SS - 090225.1 By: Amy Wu */

/* DISPLAY TITLE */
/* SS - 090225.1 - B
禁止显示页眉
{mfdtitle.i "b+ "}
SS - 090225.1 - E */

/* SS - 090225.1 - B */
/* 固定 */
{xxmfdtitle.i "b+ "}

/* 临时表 */
{xxpoporp0001.i}

/* 定义输入参数 */
define  input parameter i_vend like po_vend.                               
define  input parameter i_vend1 like po_vend.                              
define  input parameter i_nbr like po_nbr.                                 
define  input parameter i_nbr1 like po_nbr.                                
define  input parameter i_due like pod_due_date.                           
define  input parameter i_due1 like pod_due_date.                          
define  input parameter i_perform like pod_per_date.                        
define  input parameter i_perform1 like pod_per_date.                       
define  input parameter i_ord like po_ord_date.                            
define  input parameter i_ord1 like po_ord_date.                           
define  input parameter i_cdate like po_cls_date.                           
define  input parameter i_cdate1 like po_cls_date.                          
define  input parameter i_buyer like po_buyer.                              
define  input parameter i_buyer1 like po_buyer.                             
define  input parameter i_req   like pod_req_nbr.                           
define  input parameter i_req1   like pod_req_nbr.                          
define  input parameter i_blanket  like po_blanket.                         
define  input parameter i_blanket1 like po_blanket.                         
define  input parameter i_site like pod_site.                               
define  input parameter i_site1 like pod_site.                              
define  input parameter i_open_only like mfc_logical .         
define  input parameter i_incl_b2b_po like mfc_logical.                     
define  input parameter i_sortby like mfc_logical .                          
define  input parameter i_base_rpt like po_curr.                           
define  input parameter i_mixed_rpt like mfc_logical .             
/* SS - 090225.1 - E */


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp_p_1 "Open PO's Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp_p_2 "Ext Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp_p_3 "Include EMT PO's"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp_p_4 "Sort by Buyer"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp_p_5 "Qty Open"
/* MaxLen: Comment: */

/*N0T7*/ &SCOPED-DEFINE poporp_p_6 "Mixed Currencies"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {gppopp.i}

         define  new shared variable rndmthd like rnd_rnd_mthd.
         define  new shared variable oldcurr like po_curr.
         define  new shared variable vend like po_vend.
         define  new shared variable vend1 like po_vend.
         define  new shared variable nbr like po_nbr.
         define  new shared variable nbr1 like po_nbr.
         define  new shared variable so_job like pod_so_job.
         define  new shared variable so_job1 like pod_so_job.
         define  new shared variable due like pod_due_date.
         define  new shared variable due1 like pod_due_date.
         define  new shared variable ord like po_ord_date.
         define  new shared variable ord1 like po_ord_date.
         define new shared variable ext_cost like pod_pur_cost label {&poporp_p_2}
                  format "->,>>>,>>>,>>9.99".
         define new shared variable qty_open like pod_qty_ord label {&poporp_p_5}.
         define new shared variable disp_curr as character
            format "x(1)" label "C".
         define new shared variable base_tot like pod_std_cost.
         define new shared variable desc1 like pt_desc1.
         define new shared variable desc2 like pt_desc2.
         define new shared variable open_only like mfc_logical initial yes
            label {&poporp_p_1}.
         define new shared variable cdate like po_cls_date.
         define new shared variable cdate1 like po_cls_date.
         define new shared variable perform like pod_per_date.
         define new shared variable perform1 like pod_per_date.
         define new shared variable buyer like po_buyer.
         define new shared variable buyer1 like po_buyer.
         define new shared variable req   like pod_req_nbr.
         define new shared variable req1   like pod_req_nbr.
         define new shared variable blanket  like po_blanket.
         define new shared variable blanket1 like po_blanket.
         define new shared variable sortby like mfc_logical
            label {&poporp_p_4} initial no.
         define new shared variable  base_rpt like po_curr.
         define new shared variable mixed_rpt like mfc_logical initial no
/*N0T7*                                label {gpmixlbl.i}. */
/*N0T7*/                               label {&poporp_p_6}.
         define new shared variable site like pod_site.
         define new shared variable site1 like pod_site.
         define new shared variable incl_b2b_po like mfc_logical
            label {&poporp_p_3}.
/*L020*/ define variable mc-error-number like msg_nbr no-undo.
/*L020*/ {gprunpdf.i "mcpl" "p"}

         form
            vend           colon 20
            vend1          label {t001.i} colon 49 skip
            nbr            colon 20
            nbr1           label {t001.i} colon 49 skip
            due            colon 20
            due1           label {t001.i} colon 49 skip
            perform        colon 20
            perform1       label {t001.i} colon 49 skip
            ord            colon 20
            ord1           label {t001.i} colon 49 skip
            cdate          colon 20
            cdate1         label {t001.i} colon 49 skip
            buyer          colon 20
            buyer1         label {t001.i} colon 49 skip
            req            colon 20
            req1           label {t001.i} colon 49 skip
            blanket        colon 20
            blanket1       label {t001.i} colon 49 skip
            site           colon 20
            site1          label {t001.i} colon 49 skip(1)
            open_only      colon 25 skip
            incl_b2b_po    colon 25 skip
            sortby         colon 25 skip
            base_rpt       colon 25 skip
            mixed_rpt      colon 25 skip

         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         oldcurr = "".

         {wbrp01.i}
   
/* SS - 090225.1 - B
    禁止循环执行
repeat:
SS - 090225.1 - E */

/* SS - 090225.1 - B */
/* 将输入参数的值传递给本地变量 */
    vend = i_vend.
    vend1 = i_vend1.
    nbr = i_nbr.
    nbr1 = i_nbr1.
    due = i_due.
    due1 = i_due1.
    perform = i_perform.
    perform1 = i_perform1.
    ord = i_ord.
    ord1 = i_ord1.
    cdate = i_cdate.
    cdate1 = i_cdate1.
    buyer = i_buyer.
    buyer1 = i_buyer1.
    req = i_req.
    req1 = i_req1.
    blanket = i_blanket.
    blanket1 = i_blanket1.
    site = i_site.
    site1 = i_site1.
    open_only = i_open_only.
    incl_b2b_po = i_incl_b2b_po.
    sortby = i_sortby.
    base_rpt = i_base_rpt.
    mixed_rpt = i_mixed_rpt.


/* SS - 090225.1 - E */


/*  Remove remnants from last iteration.    */
            find first po_wkfl no-error.
            if available po_wkfl then
               for each po_wkfl exclusive-lock:
                  delete po_wkfl.
               end.

            if nbr1 = hi_char then nbr1 = "".
            if vend1 = hi_char then vend1 = "".
            if ord = low_date then ord = ?.
            if ord1 = hi_date then ord1 = ?.
            if due = low_date then due = ?.
            if due1 = hi_date then due1 = ?.
            if cdate = low_date then cdate = ?.
            if cdate1 = hi_date then cdate1 = ?.
            if perform = low_date then perform = ?.
            if perform1 = hi_date then perform1 = ?.
            if buyer1 = hi_char then buyer1 = "".
            if req1   = hi_char then req1   = "".
            if blanket1 = hi_char then blanket1   = "".
            if site1 = hi_char then site1 = "".

   /* SS - 090225.1 - B
   禁止编辑本地变量
         if c-application-mode <> "WEB" then
        update
               vend vend1
               nbr nbr1
               due due1
               perform perform1
               ord ord1
               cdate cdate1
               buyer buyer1
               req req1
               blanket blanket1
               site site1
               open_only
               incl_b2b_po
               sortby
               base_rpt
               mixed_rpt
            with frame a.

/*L020*/ /* CURRENCY CODE VALIDATION */
/*L020*/ if base_rpt <> "" then do:
/*L020*/    {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
             "(input base_rpt,
               output mc-error-number)"}
/*L020*/    if mc-error-number <> 0 then do:
/*L020*/       {mfmsg.i mc-error-number 3} /* INVALID CURRENCY */
/*L020*/       next-prompt base_rpt.
/*L020*/       next.
/*L020*/    end.
/*L020*/ end.

         {wbrp06.i &command = update &fields = "  vend vend1 nbr nbr1 due due1
perform perform1 ord ord1 cdate cdate1 buyer buyer1 req req1 blanket blanket1 site site1
open_only  incl_b2b_po sortby base_rpt  mixed_rpt" &frm = "a"}

   SS - 090225.1 - E */

         if (c-application-mode <> "WEB") or
         (c-application-mode = "WEB" and
         (c-web-request begins "DATA")) then do:

            bcdparm = "".
            {mfquoter.i vend       }
            {mfquoter.i vend1      }
            {mfquoter.i nbr        }
            {mfquoter.i nbr1       }
            {mfquoter.i due        }
            {mfquoter.i due1       }
            {mfquoter.i perform    }
            {mfquoter.i perform1   }
            {mfquoter.i ord        }
            {mfquoter.i ord1       }
            {mfquoter.i cdate      }
            {mfquoter.i cdate1     }
            {mfquoter.i buyer      }
            {mfquoter.i buyer1     }
            {mfquoter.i req        }
            {mfquoter.i req1       }
            {mfquoter.i blanket    }
            {mfquoter.i blanket1   }
            {mfquoter.i site       }
            {mfquoter.i site1      }
            {mfquoter.i open_only  }
            {mfquoter.i incl_b2b_po}
            {mfquoter.i sortby     }
            {mfquoter.i base_rpt   }
            {mfquoter.i mixed_rpt  }

            if nbr1 = "" then nbr1 = hi_char.
            if vend1 = "" then vend1 = hi_char.
            if ord = ? then ord = low_date.
            if ord1 = ? then ord1 = hi_date.
            if due = ? then due = low_date.
            if due1 = ? then due1 = hi_date.
            if cdate = ? then cdate = low_date.
            if cdate1 = ? then cdate1 = hi_date.
            if perform = ? then perform = low_date.
            if perform1 = ? then perform1 = hi_date.
            if buyer1 = "" then buyer1 = hi_char.
            if req1   = "" then req1   = hi_char.
            if blanket1 = "" then blanket1  = hi_char.
            if site1  = "" then site1  = hi_char.

         end.

   /* SS - 090225.1 - B
   禁止选择打印机和显示页眉

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}

            {mfphead.i}
   SS - 090225.1 - E */

   /* SS - 090225.1 - B
            form header
            skip(1)
            with frame phead1 width 80.
            view frame phead1.
   SS - 090225.1 - E */


   /* SS - 090225.1 - B
            {gprun.i ""poporpa.p""}
   SS - 090225.1 - E */
            
  /* SS - 090225.1 - B */
            {gprun.i ""xxpoporp0001a.p""}
  /* SS - 090225.1 - E */

   /* SS - 090225.1 - B
   禁止显示页脚和循环执行
   /* REPORT TRAILER  */
   {mfrtrail.i}

end.
SS - 090225.1 - E */

         {wbrp04.i &frame-spec = a}
