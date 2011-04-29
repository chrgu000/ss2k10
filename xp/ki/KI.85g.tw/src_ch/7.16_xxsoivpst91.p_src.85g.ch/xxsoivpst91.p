/* soivpst.p - POST INVOICES TO AR AND GL REPORT                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                     */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb *                   */
/* REVISION: 6.0      LAST MODIFIED: 07/11/90   BY: wug *D051*              */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: mlb *D055*              */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: wug *D054*              */
/* REVISION: 6.0      LAST MODIFIED: 11/01/90   BY: mlb *D162*              */
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: mlb *D238*              */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: afs *D279*              */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354*              */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*              */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D424*              */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*              */
/* REVISION: 6.0      LAST MODIFIED: 03/28/91   BY: afs *D464*              */
/* REVISION: 6.0      LAST MODIFIED: 04/04/91   BY: afs *D478*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 04/29/91   BY: afs *D586*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 05/08/91   BY: afs *D628*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 08/12/91   BY: afs *D824*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: mlv *D825*              */
/* REVISION: 6.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*              */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: mlv *F029*              */
/* REVISION: 6.0      LAST MODIFIED: 11/26/91   BY: wug *D953*              */
/* REVISION: 7.0      LAST MODIFIED: 11/30/91   BY: sas *F017*              */
/* REVISION: 7.0      LAST MODIFIED: 02/19/92   BY: tjs *F213*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: tjs *F247*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/22/92   BY: tmd *F263*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: dld *F297*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: afs *F356*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: tjs *F504*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   BY: sas *F656*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 06/29/92   BY: afs *F715*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 07/20/92   BY: tjs *F739*   (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 08/13/92   BY: sas *F850*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 08/24/92   BY: tjs *G033*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047*              */
/* REVISION: 7.3      LAST MODIFIED: 10/23/92   BY: afs *G230*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: afs *G163*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 11/06/92   BY: afs *G290*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 12/04/92   BY: afs *G394*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 01/05/93   BY: mpp *G484*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 12/06/92   BY: sas *G435*              */
/* REVISION: 7.3      LAST MODIFIED: 01/24/93   BY: sas *G585*              */
/* REVISION: 7.3      LAST MODIFIED: 01/27/93   BY: sas *G613*              */
/* REVISION: 7.3      LAST MODIFIED: 04/08/93   BY: afs *G905*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: bcm *G942*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: tjs *G948*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 05/26/93   BY: kgs *GB38*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 06/07/93   BY: tjs *GA64*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 06/09/93   BY: dpm *GB71*   (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 06/16/93   BY: tjs *GA65*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 07/30/93   BY: jjs *H050*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*              */
/* REVISION: 7.4      LAST MODIFIED: 10/01/93   BY: tjs *H070*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 10/18/93   BY: tjs *H182*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 11/15/93   BY: tjs *H196*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 11/16/93   BY: bcm *H226*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 11/23/93   BY: afs *H239*   (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 05/09/94   BY: dpm *H367*              */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: dpm *GJ95*              */
/* REVISION: 7.4      LAST MODIFIED: 06/07/94   BY: dpm *FO66*              */
/* REVISION: 7.4      LAST MODIFIED: 06/22/95   BY: rvw *H0F0*              */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*              */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: *J04C* Sue Poland       */
/* REVISION: 8.5      LAST MODIFIED: 08/26/96   BY: *G2CR* Ajit Deodhar     */
/* REVISION: 8.5      LAST MODIFIED: 12/08/97   BY: *J27M* Seema Varma      */
/* REVISION: 8.5      LAST MODIFIED: 01/12/98   BY: *J29S* Jim Williams     */

/*J0DV*/  /* REFORMATTED PROGRAM FOR READABILITY */

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090707.1 By: Roger Xiao */


/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090707.1 - RNB
详见SPEC:E-Sign Interface_KIV101D.DOC
SS - 090707.1 - RNE */


{mfdtitle.i "090707.1"}
/*{mfdtitle.i "f+ "}*/

/* SS - 090707.1 - B 
        {soivpst.i "new shared"} 
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
{xxsoivpst91.i "new shared"} 
define variable tax_date like so_tax_date.
/* SS - 090707.1 - E */

/*F017*/  {fsdeclr.i new}
/*F458    define new shared variable tax_date like tax_effdate. */
/*G2CR*/  define new shared variable prog_name as character
                          initial "soivpst.p" no-undo.

/*J27M*/ /* THE TEMP-TABLE WORK_TRNBR STORES THE VALUES OF FIRST AND LAST  */
/*J27M*/ /* TRANSACTION NUMBER WHICH IS USED WHEN INVOICE IS POSTED VIA    */
/*J27M*/ /* SHIPPER CONFIRM, FOR ASSIGNING THE TR_RMRKS AND TR_GL_DATE     */
/*J27M*/ /* FIELDS. PREVIOUSLY, THIS WAS BEING DONE IN RCSOISB1.P PRIOR TO */
/*J27M*/ /* INVOICE POST. THIS TEMP-TABLE IS HOWEVER NOT USED BY SOIVPST.P */
/*J27M*/ /* AND HAS BEEN DEFINED HERE SINCE SOIVPSTA.P, WHICH IS SHARED    */
/*J27M*/ /* BETWEEN RCSOIS.P AND SOIVPST.P USES IT.                        */

/*J27M*/  define new shared temp-table work_trnbr
/*J27M*/      field work_sod_nbr  like sod_nbr
/*J27M*/      field work_sod_line like sod_line
/*J27M*/      field work_first_tr like tr_trnbr
/*J27M*/      field work_last_tr like tr_trnbr
/*J27M*/      index work_sod_nbr work_sod_nbr ascending.

          /* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
/*J0DV*/  {gpglefv.i}

/*J0DV*   /*H039*/  {gpglefdf.i} */


          post = yes.


/* SS - 090707.1 - B 
          form
             inv                  colon 15
             inv1                 label {t001.i} colon 49 skip
/*G047*/     cust                 colon 15
/*G047*/     cust1                label {t001.i} colon 49 skip
/*G047*/     bill                 colon 15
/*G047*/     bill1                label {t001.i} colon 49 skip(1)
             eff_date             colon 33 label "总帐生效日期" skip
             gl_sum               colon 33 label "C-总帐汇总/D-明细" skip
             print_lotserials     colon 33
/*H0F0*   with frame a side-labels.       */
/*H0F0*/  with frame a width 80 side-labels.
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
        form
            inv                  colon 15
            inv1                 label {t001.i} colon 49 skip
            v_inv_date           colon 15
            v_inv_date1          label {t001.i} colon 49 skip
            cust                 colon 15
            cust1                label {t001.i} colon 49 skip
            bill                 colon 15
            bill1                label {t001.i} colon 49 skip
            v_slspsn             colon 15
            v_slspsn1            label {t001.i} colon 49 skip
            v_group              colon 15
            v_group1             label {t001.i} colon 49 skip(1)

            v_all_ok             colon 33 label "全部批核"
            eff_date             colon 33 label "总帐生效日期" skip
            gl_sum               colon 33 label "C-总帐汇总/D-明细" skip
            print_lotserials     colon 33
        with frame a width 80 side-labels.
/* SS - 090707.1 - E */

          do transaction:


             insbase = no.
/*J29S* /*G585*/ fsunit = false. */


             find first svc_ctrl no-lock no-error.
             /* SVC_WARR_SVCODE IS THE WARRANTY SERVICE TYPE FOR RMA'S, */
             /* NOT A DEFAULT WARRANTY TYPE.                            */

/*J04C*/     /* WITH THE 8.5 RELEASE, LOADING THE STANDARD BOM CONTENTS */
             /* INTO THE INSTALLED BASE IS NO LONGER AN OPTION.  THIS   */
             /* DECISION WAS MADE TO PREVENT SERIALIZED ITEMS FROM      */
             /* GETTING INTO THE ISB WITHOUT SERIAL NUMBERS, AND ENSURE */
             /* THERE ARE NO ADVERSE IMPACTS TO THE COMPLIANCE SERIAL   */
             /* NUMBERING REQUIREMENTS.                                 */
             if available svc_ctrl then
                assign
/*J04C*            serialsp = svc_serial        */
/*J04C* /*G435*/   nsusebom = svc_isb_nsbom     */
/*J04C*/           serialsp = "S"       /* ALL SERIALS SHOULD LOAD */
/*J04C*/           nsusebom = no
/*G435*/           usebom   = svc_isb_bom
/*H0F0*/           needitem = svc_pt_mstr
/*J04C* /*H0F0*/   warranty = svc_warr_svcode   */
                   insbase  = svc_ship_isb.

/*G585* *BEGIN DELETED CODE****************
 * find first sac_ctrl no-lock no-error.
 * if available sac_ctrl then do:
 *     prefix = sac_sa_pre.
 *     if svc_ship_isb then insbase = yes.
 * end.
 *G585* *END DELETED CODE******************/

/*GJ95*      find first fac_ctrl no-lock. */

/*J29S* *BEGIN DELETED CODE***************************************************
 *J29S* * fac_unit_qty NO LONGER USED IN ISB UPDATE REPLACED BY pt_unit_isb **
 *      /*GJ95*/     find first fac_ctrl no-lock no-error.
 *      /*G435*/     if available fac_ctrl then
 *      /*G435*/        fsunit = fac_unit_qty.
 *      /*G435*/     else
 *      /*G435*/        fsunit = false.
 *J29S* *END DELETED CODE ***************************/

          end.

repeat:

             assign
                expcount = 999
                pageno   = 0.

             if eff_date = ? then eff_date = today.
             if inv1 = hi_char then inv1 = "".
/*G047*/     if cust1 = hi_char then cust1 = "".
/*G047*/     if bill1 = hi_char then bill1 = "".

/* SS - 090707.1 - B */
            if v_inv_date  = low_date then v_inv_date  = ? . 
            if v_inv_date1 = hi_date  then v_inv_date1 = ? . 
            if v_slspsn1  = hi_char   then v_slspsn1   = "".
            if v_group1   = hi_char   then v_group1    = "". 
/* SS - 090707.1 - E */

/* SS - 090707.1 - B 
             update
                inv inv1
                cust cust1 bill bill1
                eff_date gl_sum print_lotserials
             with frame a.
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
            view frame dtitle .
            view frame a .
            update
                inv              
                inv1             
                v_inv_date       
                v_inv_date1      
                cust             
                cust1            
                bill             
                bill1            
                v_slspsn         
                v_slspsn1        
                v_group          
                v_group1         
                                 
                v_all_ok         
                eff_date         
                gl_sum           
                print_lotserials 
            with frame a.
/* SS - 090707.1 - E */


/*J0DV*/     /* VALIDATE OPEN GL PERIOD FOR PRIMARY ENTITY - GIVE
/*J0DV*/      * A WARNING IF THE PRIMARY ENTITY IS CLOSED. WE DONT
/*J0DV*/      * WANT A HARD ERROR BECAUSE WHAT REALLY MATTERS IS
/*J0DV*/      * THE ENTITY SO_SITE OF EACH SO_SITE (WHICH IS VALIDATED
/*J0DV*/      * IN SOIVPST1.P. BUT WE AT LEAST WANT A WARNING MESSAGE
/*J0DV*/      * IN CASE, FOR EXAMPLE, THEY ACCIDENTALLY ENTERED
/*J0DV*/      * THE WRONG EFFECTIVE DATE */

             /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
/*J0DV*/     {gprun.i ""gpglef1.p""
                   "( input  ""SO"",
                      input  glentity,
                      input  eff_date,
                      output gpglef_result,
                      output gpglef_msg_nbr
                    )" }

/*J0DV*/     if gpglef_result > 0 then do:
/*J0DV*/        /* IF PERIOD CLOSED THEN WARNING ONLY */
/*J0DV*/        if gpglef_result = 2 then do:
/*J0DV*/           {mfmsg.i 3005 2}
/*J0DV*/        end.
/*J0DV*/        /* OTHERWISE REGULAR ERROR MESSAGE */
/*J0DV*/        else do:
/*J0DV*/           {mfmsg.i gpglef_msg_nbr 4}
/*J0DV*/           next-prompt eff_date with frame a.
/*J0DV*/           undo, retry.
/*J0DV*/        end.
/*J0DV*/     end.

/*H039* {mfglef.i eff_date}                          */
/*J0DV* /*H039*/ {gpglef.i ""SO"" glentity eff_date} */


             bcdparm = "".

             {mfquoter.i inv      }
             {mfquoter.i inv1     }
/*G047*/     {mfquoter.i cust     }
/*G047*/     {mfquoter.i cust1    }
/*G047*/     {mfquoter.i bill     }
/*G047*/     {mfquoter.i bill1    }
             {mfquoter.i eff_date }
             {mfquoter.i gl_sum   }
             {mfquoter.i print_lotserials}
/* SS - 090707.1 - B */
             {mfquoter.i  v_inv_date    }
             {mfquoter.i  v_inv_date1   }
             {mfquoter.i  v_slspsn      }
             {mfquoter.i  v_slspsn1     }
             {mfquoter.i  v_group       }
             {mfquoter.i  v_group1      }
             {mfquoter.i  v_all_ok      }

            if v_inv_date  = ?  then v_inv_date  = low_date. 
            if v_inv_date1 = ?  then v_inv_date1 = hi_date . 
            if v_slspsn1   = "" then v_slspsn1   = hi_char .
            if v_group1    = "" then v_group1    = hi_char .
/* SS - 090707.1 - E */

             if eff_date = ? then eff_date = today.
             if inv1 = "" then inv1 = hi_char.
/*G047*/     if cust1 = "" then cust1 = hi_char.
/*G047*/     if bill1 = "" then bill1 = hi_char.

/* SS - 090707.1 - B */
for each sls_det : delete sls_det . end.

v_manager = global_userid .
run get-sales-person-list (input v_manager ,input v_slspsn ,input v_slspsn1).
/*for each sls_det:  message sls_user view-as alert-box . end. */
/*
(   (((sod_slspsn[1] > v_slspsn and v_slspsn = "") or (sod_slspsn[1] >= v_slspsn and v_slspsn <> ""))  and sod_slspsn[1] <= v_slspsn1 ) 
 or (((sod_slspsn[2] > v_slspsn and v_slspsn = "") or (sod_slspsn[2] >= v_slspsn and v_slspsn <> ""))  and sod_slspsn[2] <= v_slspsn1 ) 
 or (((sod_slspsn[3] > v_slspsn and v_slspsn = "") or (sod_slspsn[3] >= v_slspsn and v_slspsn <> ""))  and sod_slspsn[3] <= v_slspsn1 ) 
 or (((sod_slspsn[4] > v_slspsn and v_slspsn = "") or (sod_slspsn[4] >= v_slspsn and v_slspsn <> ""))  and sod_slspsn[4] <= v_slspsn1 )
)
*/
find first gl_ctrl no-lock.
find first soc_ctrl no-lock.

v_ii = 0 .
for each temp1 : delete temp1 . end. 
for each so_mstr
    use-index so_invoice
    where so_inv_nbr > ""
    and (so_inv_nbr >= inv and so_inv_nbr <= inv1)
    and (so_invoiced = yes) /*invoice has been printed*/
    and (so_to_inv = no)    /*invoice not posted yet */
    and (so_cust >= cust and so_cust <= cust1)
    and (so_bill >= bill and so_bill <= bill1)
    and (so_inv_date >= v_inv_date and so_inv_date <= v_inv_date1)
    and can-find(  /*sod_det*/ first sod_det where sod_nbr = so_nbr 
            and can-find(first sls_det where sls_user = sod_slspsn[1] or  sls_user = sod_slspsn[2] or  sls_user = sod_slspsn[3] or  sls_user = sod_slspsn[4] no-lock )
            and can-find(first pt_mstr where pt_part = sod_part and pt_group >= v_group and pt_group <= v_group1 no-lock)
            no-lock /*sod_det*/)

no-lock
break by so_inv_nbr :
    find first temp1 where t1_nbr = so_nbr no-lock no-error .
    if not avail temp1 then do:
        find first ad_mstr where ad_addr = so_bill no-lock no-error .
        find first sod_det 
            where sod_nbr = so_nbr 
            and can-find(first sls_det where sls_user = sod_slspsn[1] or  sls_user = sod_slspsn[2] or  sls_user = sod_slspsn[3] or  sls_user = sod_slspsn[4] no-lock )
            and can-find(first pt_mstr where pt_part = sod_part and pt_group >= v_group and pt_group <= v_group1 no-lock)
        no-lock no-error .
        v_ii = v_ii + 1 .
        create temp1.
        assign t1_line    = string(v_ii) 
                t1_inv_nbr = so_inv_nbr
                t1_nbr     = so_nbr
                t1_bill    = so_bill
                t1_curr    = so_curr 
                t1_ok      = v_all_ok
                t1_slspsn  = if sod_slspsn[1] <> "" then sod_slspsn[1] 
                            else if sod_slspsn[2] <> "" then sod_slspsn[2] 
                            else if sod_slspsn[3] <> "" then sod_slspsn[3] 
                            else if sod_slspsn[4] <> "" then sod_slspsn[4] 
                            else ""
                t1_name    = if avail ad_mstr then ad_name else "" 
                .

        ext_price = 0 .  
        for each sod_det where sod_nbr = t1_nbr and sod_qty_inv <> 0 no-lock:

            net_price = sod_price.       
            tax_date = if so_tax_date <> ? then so_tax_date else so_ship_date.
            run get-price (input-output net_price , input sod_tax_in , input tax_date , input sod_taxc) .

            ext_price = ext_price + net_price * sod_qty_inv.
                 
        end. /*for each sod_det*/

        t1_amt = ext_price .


    end. /*if not avail temp1*/
end. /*for each so_mstr*/




v_counter = 0 .
for each temp1 :
    v_counter = v_counter + 1 .
end.
if v_counter = 0  then  do:
    message "无符合条件的发票." .
    undo, retry .
end.

hide all no-pause.
view frame zzz1 .
if v_counter >= 20 then message "每次最多显示20行" .
choice = no .

message "请移动光标选择,按回车键查看明细" .
sw_block:
repeat :
        /*带星号的frame - begin*******
        define var v_framesize as integer .
        v_framesize    = 17 .
        define  frame zzz1.
        form
            t1_select      column-label "*"  
            t1_line        column-label "项"
            t1_inv_nbr     column-label "发票号"
            t1_bill        column-label "票据开往"
            t1_name        column-label "名称" format "x(24)"
            t1_amt         column-label "金额"  
            t1_curr        column-label "币"
            t1_slspsn      column-label "推销员"
            t1_ok          column-label "A"
        with frame zzz1 v_framesize down width 80 
        title color normal  "待审核发票清单".  

        for first temp1 no-lock:
        end.        
        {xxsoivpst001.i
            &detfile      = temp1
            &scroll-field = t1_line
            &framename    = "zzz1"
            &framesize    = v_framesize
            &sel_on       = ""*""
            &sel_off      = """"
            &display1     = t1_select
            &display3     = t1_line 
            &display4     = t1_inv_nbr
            &display2     = t1_bill
            &display5     = t1_name
            &display6     = t1_amt
            &display7     = "t1_curr t1_slspsn"
            &display8     = t1_ok
            &exitlabel    = sw_block
            &exit-flag    = first_sw_call
            &record-id    = temp_recno
            
            
        }
        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or lastkey = keycode("ESC")
        then do:
                {mfmsg01.i 36 1 choice} /*是否退出?*/
                if choice = yes then do :
                    for each temp1 exclusive-lock:
                        delete temp1 .
                    end.
                    clear frame zzz1 all no-pause .
                    clear frame b no-pause .
                    choice = no .
                    leave .
                end.

        end.  /*if keyfunction(lastkey)*/  
        
        if keyfunction(lastkey) = "go"
        then do:
            v_yn1 = no . /*v_yn1 = yes 则不可以退出 */
            if v_yn1 = no then do :
                choice = yes .
                {mfmsg01.i 12 1 choice }  /*是否正确?*/
                if choice then     leave .
            end. 

        end.  /*if keyfunction(lastkey)*/  


        for first temp1 where t1_select = "*" exclusive-lock with frame b :
                assign t1_select = "" .
                {gprun.i  ""xxsoivpst001.p"" "(input t1_nbr)"}
                view frame zzz1 .

                message "请输入批核结果Yes/No" .
                update t1_ok with frame zzz1 .
                
            
        end. /*for first temp1*/

        temp_recno = recid(temp1) .

        find next temp1 no-lock no-error.
        if available temp1 then do:
            temp_recno = recid(temp1) .
        end.
      
        ****************带星号的frame - end */

        /*****不带星号的frame - begin********/
        define var vv_recid as recid .
        define var vv_first_recid as recid .
        define var v_framesize as integer .
        vv_recid       = ? .
        vv_first_recid = ? .
        v_framesize    = 17 .

        define frame zzz1.
        form
            t1_line        column-label "项"
            t1_inv_nbr     column-label "发票号"
            t1_bill        column-label "票据开往"
            t1_name        column-label "名称"  format "x(26)"
            t1_amt         column-label "金额"  
            t1_curr        column-label "币"
            t1_slspsn      column-label "推销员"
            t1_ok          column-label "A"
        with frame zzz1 width 80 v_framesize down 
        title color normal  "待审核发票清单".  

        scroll_loop:
        do with frame zzz1:
            {xxsoivpst003.i 
                &domain       = "true and "
                &buffer       = temp1
                &scroll-field = t1_line
                &searchkey    = "true"
                &framename    = "zzz1"
                &framesize    = v_framesize
                &display1     = t1_line
                &display2     = t1_inv_nbr
                &display3     = t1_bill       
                &display4     = t1_name       
                &display5     = t1_amt        
                &display6     = t1_curr       
                &display7     = t1_slspsn     
                &display8     = t1_ok         
                &exitlabel    = scroll_loop
                &exit-flag    = "true"
                &record-id    = vv_recid
                &first-recid  = vv_first_recid
                &logical1     = true 
            }

            /*
            &display9     = "pt__chr01"
            &index-phrase = "use-index pt_part"
            &exec_cursor  = "update pt_pm_code." 
            */
        end. /*scroll_loop*/

        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or lastkey = keycode("ESC")
        then do:
                {mfmsg01.i 36 1 choice} /*是否退出?*/
                if choice = yes then do :
                    for each temp1 exclusive-lock:
                        delete temp1 .
                    end.
                    clear frame zzz1 all no-pause .
                    clear frame b no-pause .
                    choice = no .
                    leave .
                end.
        end.  /*if keyfunction(lastkey)*/  
        
        if keyfunction(lastkey) = "go"
        then do:
            v_yn1 = no . /*v_yn1 = yes 则不可以退出 */
            vv_recid = ? . /*退出前清空vv_recid*/
            if v_yn1 = no then do :
                choice = yes .
                {mfmsg01.i 12 1 choice }  /*是否正确?*/
                if choice then     leave .
            end. 

        end.  /*if keyfunction(lastkey)*/  

        if vv_recid <> ? then do:
            find first temp1 where recid(temp1) = vv_recid no-error .
            if avail temp1 then do:
                {gprun.i  ""xxsoivpst001.p"" "(input t1_nbr)"}
                view frame zzz1 .

                message "请输入批核结果Yes/No" .
                update t1_ok with frame zzz1 .        
            end.
        end.
        /*****不带星号的frame - end********/

end. /*sw_block:*/


find first temp1 where t1_ok = yes no-error.
if not avail temp1 then do:
    message "批核者未作任何批核." .
    choice = no.
end.
else do:
    v_print = No .
    message "是否打印已批核记录?" update v_print .
end .
if choice then do :
    /*{mfmsg01.i 32 1 choice } *是否更新?*/
    if choice then do :

        /*发票过账***************************************************************begin*/

        define temp-table tt field tt_rec as recid .

        for each tt : delete tt . end .
        on create of ih_hist do:
            find first tt where tt_rec = recid(ih_hist) no-lock no-error.
            if not available tt then do:
                create tt. tt_rec = recid(ih_hist).
            end.
        end.

        v_print_file = execname 
                 + '-' + string(year(today),"9999") 
                 + string(month(today),"99") 
                 + string(day(today),"99") 
                 + entry(1,string(time,'hh:mm:ss'),':') 
                 + entry(2,string(time,'hh:mm:ss'),':') 
                 + entry(3,string(time,'hh:mm:ss'),':') 
                 + string(random(1,100),"999")
                 .

        define var v_tmp_file as char .
        v_tmp_file = v_print_file + '-' + mfguser + ".txt".
        
        v_print_file = v_print_file + ".txt". 

        output to value(v_tmp_file) .
            put "**** This is a temporary file for (" execname format "x(24)" "). You can delete it directly . ****" skip skip(5) . 
            do transaction on error undo, retry:
               {gprun.i ""sonsogl.p""}  /*取参考号*/
            end.   

            {gprun.i ""xxsoivpst191.p""}  /*实际过账子程式*/

            do transaction:
                find ba_mstr 
                    where ba_batch = batch 
                    and ba_module = "SO"
                exclusive-lock no-error.
                if available ba_mstr then do:
                    ba_total  = ba_total + batch_tot.
                    ba_ctrl   = ba_total.
                    ba_userid = global_userid.
                    ba_date   = today.
                    batch_tot = 0.
                    ba_status = " ". 
                end.
            end.
        output close .

        for each tt no-lock:
            find first ih_hist where recid(ih_hist) = tt_rec no-error .
            if avail ih_hist then do:
                find first so_mstr where so_nbr = ih_nbr no-lock no-error.
                if avail so_mstr then do:
                    assign  
                        ih_userid = global_userid
                        ih__dte01 = today
                        ih__chr01 = so__chr01
                        ih__chr02 = so__chr02
                        ih__chr03 = so__chr03
                        ih__chr04 = so__chr04
                        ih__chr05 = so__chr05
                        .
                end.
            end.
        end.
        

        run error-check (input v_tmp_file ,output v_yn2) . /*检查是否有错误或警告v_yn2*/
        if v_yn2 = no then do:
            unix silent value ( "rm -f "  + v_tmp_file).
        end. 
        /*发票过账******************************************************************end  */

        /*清单打印*****************************************************************begin*/
        output to value(v_print_file) .
                {xxsoivpst002.i}
        output close .
        
        if v_print then do:
            hide all no-pause .
            view frame dtitle .
            view frame a .
            {mfselbpr.i "printer" 132}
            {mfphead.i}

            /*
                打印方法1: 再run一遍 xxsoivpst002.i,要换frame
                打印方法2: 打印上面一段的文件即可,
            */
            /*{xxsoivpst002.i}*/
            define var v_aaa as char format "x(132)" .
            if search(v_print_file) <> ? then do:  
                input from value(v_print_file) .
                    repeat :
                        v_aaa = "" .
                        import unformatted v_aaa .
                        put v_aaa skip .        
                    end.
                input close .
            end.
            {mfrtrail.i} /* REPORT TRAILER */
            
        end. /*if v_print*/
        /*清单打印****************************************************************end  */

        for each temp1 exclusive-lock:
            delete temp1.
        end.
        clear frame zzz1 all no-pause .

    end.  /*if choice then*/
    else do:  /*if not choice then*/
        for each temp1 exclusive-lock:
            delete temp1.
        end.
        clear frame zzz1 all no-pause .
        hide frame zzz1 no-pause .

    end. /*if not choice then*/
end.  /*if choice then*/

/* SS - 090707.1 - E */

end. /*repeat*/

procedure get-sales-person-list:
    define input parameter v_user_par  as char .
    define input parameter v_user_from as char .
    define input parameter v_user_to   as char .

    for each code_mstr 
        where code_fldname = v_user_par 
        no-lock :

        if (code_value >= v_user_from and code_value <= v_user_to ) then do:
            find first sls_det where sls_user = code_value no-lock no-error .
            if not avail sls_det then do:
                find first sp_mstr where sp_addr = code_value no-lock no-error .
                if avail sp_mstr then do:
                    create sls_det .
                    assign sls_user = code_value .
                end.
            end .
        end.

        /*这一行一定要放在for each的最后*/
        run get-sales-person-list (input code_value ,input v_user_from ,input v_user_to ).
    end. /*for each code_mstr*/

end procedure . /*get-sales-person-list*/


procedure get-price:
    define input-output parameter vv_price       like idh_price  .
    define input parameter vv_include_tax like idh_tax_in .
    define input parameter vv_tax_date    like ih_tax_date .
    define input parameter vv_tax_class   like idh_taxc  .

    find first gl_ctrl no-lock no-error .
    if not avail gl_ctrl then do:
        vv_price = vv_price .
    end.
    else do:                       
        if (gl_can or gl_vat) and vv_include_tax then do:             
            find last vt_mstr 
                where vt_class =  vv_tax_class
                and vt_start <= vv_tax_date
                and vt_end   >= vv_tax_date
            no-lock no-error.
            if not available vt_mstr then
                find last vt_mstr where vt_class = vv_tax_class no-lock no-error.
            if available vt_mstr then do:
                vv_price  = vv_price  * 100 / (100 + vt_tax_pct).
            end.
        end.
    end.
end procedure . /*get-price:*/



procedure error-check. 
    define input  parameter vv_file_input as char .
    define output parameter vv_file_error as logical .
    define variable vv_tmp_input as character .

    vv_file_error = no .

    input from value(vv_file_input) .
        do while true:
            import unformatted vv_tmp_input.

            if      index (vv_tmp_input,"error:")   <> 0 or    
                    index (vv_tmp_input,"错误:")	<> 0 or           
                    index (vv_tmp_input,"warning:") <> 0 or 
                    index (vv_tmp_input,"警告:")    <> 0  
            then do:
                vv_file_error = yes .
            end.
        end. /*do while true*/
    input close.

end procedure. /*error-check*/






/*------------------------------------------the end --------------------------------------------------------------------------------------------*/








/*deleted by roger from standard program***************************************************/

/* SS - 090707.1 - B 

             /* SELECT PRINTER */
             {mfselbpr.i "printer" 132}

/*F017*/     /* If we are runing under dos then the second print file for  */
/*F017*/     /* installed base has to be to a disc file or it will get a   */
/*F017*/     /* printer error.                                             */
/*G435*      if opsys = "msdos" or dev <> "printer"  then   */
/*G585*/     if insbase then do:
/*G435*/        {gpfildel.i &filename=""ISBPST.prn""}
                output stream prt2  to "ISBPST.prn".
/*G585*/     end.

/*G435*      else                              */
/*G435*         output stream prt2 to PRINTER. */


             do transaction on error undo, retry:
                /* Create Journal Reference */
                {gprun.i ""sonsogl.p""}
             end.

             mainloop:
             do on error undo, leave:

/*FO66*/        {mfphead.i}

/*F017*/        /* Main program moved to soivpst1.p */
                {gprun.i ""soivpst1.p""}

/*H367*/        do transaction:
/*H367*/           find ba_mstr where ba_batch = batch and ba_module = "SO"
/*H367*/              exclusive-lock no-error.
/*H367*/           if available ba_mstr then do:
/*H367*/              ba_total  = ba_total + batch_tot.
/*H367*/              ba_ctrl   = ba_total.
/*H367*/              ba_userid = global_userid.
/*H367*/              ba_date   = today.
/*H367*/              batch_tot = 0.
/*H367*/              ba_status = " ". /*balanced*/
/*H367*/           end.
/*H367*/        end.

/*F017*/        /* Reset second print file */
/*G585*/        if insbase then do:
                   put stream prt2 " ".
                   output stream prt2 close.
/*G585*/        end.

                /* REPORT TRAILER */
                {mfrtrail.i}

             end. /* mainloop */
SS - 090707.1 - E */