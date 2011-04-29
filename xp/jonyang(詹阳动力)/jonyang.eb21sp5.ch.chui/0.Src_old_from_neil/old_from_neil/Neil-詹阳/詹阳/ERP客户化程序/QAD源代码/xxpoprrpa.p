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




&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE



&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "}



&SCOPED-DEFINE wowsrp_p_1 "子零件"





define variable part  like wod_part .
define variable part1 like wod_part.
define variable buyer like pt_buyer .
define variable buyer1 like pt_buyer.
define variable nbr like req_nbr.
define variable nbr1 like req_nbr.
define variable rel_date like req_rel_date.
define variable rel_date1 like req_rel_date.
define variable due_date like req_need.
define variable due_date1 like req_need.




&SCOPED-DEFINE PP_FRAME_NAME A

FORM
part     colon 15 part1     label {t001.i} colon 49 skip
buyer     colon 15 buyer1     label {t001.i} colon 49 skip
nbr     colon 15 nbr1     label {t001.i} colon 49 skip
rel_date     colon 15 rel_date1     label {t001.i} colon 49 skip
due_date     colon 15 due_date1     label {t001.i} colon 49 skip
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

&UNDEFINE PP_FRAME_NAME



FORM   req_NBR req_part pt_desc1 pt_desc2 req_um pt_buyer pt_vend ad_name req_qty req_pur_cost tr_price req_rel_date req_need
with STREAM-IO   down frame b width 210 no-attr-space.
setframelabels(frame b:handle).

repeat:

{wbrp01.i}
    if part1 = hi_char then part1 = "".
    if nbr1 = hi_char then nbr1 = "".
    if BUYER1 = hi_char then BUYER1 = "".
    if rel_date = low_date then rel_date = ?.
    if rel_date1 = hi_date then rel_date1 = ?.
    if due_date = low_date then due_date = ?.
    if due_date1 = hi_date then due_date1 = ?.


    update part part1  buyer buyer1 nbr nbr1 rel_date rel_date1 due_date due_date1 with frame a.

        if (c-application-mode <> 'web':u) or
        (c-application-mode = 'web':u and
        (c-web-request begins 'data':u)) then do:



            bcdparm = "".
            {mfquoter.i part   }
            {mfquoter.i part1  }
            {mfquoter.i nbr   }
            {mfquoter.i nbr1  }
            {mfquoter.i buyer  }
            {mfquoter.i buyer1  }
            {mfquoter.i rel_date  }
            {mfquoter.i rel_date1  }
            {mfquoter.i due_date  }
            {mfquoter.i due_date1  }

            if part1 = "" then part1 = hi_char.
            if nbr1 = "" then nbr1 = hi_char.
            if BUYER1 = "" then BUYER1 = hi_char.
            if  rel_date = ? then rel_date = low_date.
            if  rel_date1 = ? then rel_date1 = hi_date.
            if  due_date = ? then due_date = low_date.
            if   due_date1 = ? then due_date1 = hi_date.
        end.


{mfselbpr.i "printer" 132}

mainloop: 
do on error undo, return error on endkey undo, return error:

    define buffer wod_det1 for wod_det.


        {mfphead.i}




        for each req_det where 
            /* *ss_20090224* */  req_domain = global_domain and
            (req_part >= part and req_part <= part1)
            and (req_nbr >= nbr and req_nbr <= nbr1)
            and (req_rel_date >= rel_date and req_rel_date <= rel_date1)
            and (req_need >= due_date and req_need <= due_date1),
        each pt_mstr where 
            /* *ss_20090224* */  pt_domain = global_domain and
            pt_part = req_part and
            (pt_buyer >= buyer and pt_buyer <= buyer1)
            no-lock by req_nbr by req_part
            with frame b width 200:
            find ad_mstr where 
                /* *ss_20090224* */  ad_domain = global_domain and
                ad_addr = pt_vend no-lock no-error.
            find last TR_HIST where 
                /* *ss_20090224* */  tr_domain = global_domain and
                TR_part = req_part AND TR_TYPE = "RCT-PO" no-lock no-error .
            if page-size - line-counter < 2
            then page.

            display
            req_NBR
            req_part
            pt_desc1
            pt_desc2
            req_um
            pt_buyer
            pt_vend
            ad_name when available ad_mstr
            req_qty
            req_pur_cost
            TR_PRICE label "末次收货采购单价" when available TR_HIST
            req_rel_date
            req_need
            with frame b STREAM-IO  .
            down 1.


            {mfguirex.i }
        end.



 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


    end.

    {wbrp04.i &frame-spec = a}

end.