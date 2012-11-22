/* chglpst.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER -              CAS*/
/* glutrrp.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.3.12 $                                                         */
/*XXCH911*
/*V8:ConvertMode=FullGUIReport                                                */
*XXCH911*/
/*XXCH911*/ /*V8:ConvertMode=ReportAndMaintenance*/
/* REVISION: 5.0      LAST MODIFIED: 03/16/89   BY: JMS   *B066*              */
/*                                   10/06/89   by: jms   *B330*              */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   by: jms   *D034*              */
/*                                   02/20/91   by: jms   *D366*              */
/* REVISION: 7.0      LAST MODIFIED: 10/18/91   by: jjs   *F058*              */
/*                                   02/26/92   by: jms   *F231*              */
/*                                   08/15/94   by: pmf   *FQ15*              */
/*                                   09/03/94   by: srk   *FQ80*              */
/*                                   11/17/94   by: str   *FT77*              */
/*                                   12/11/96   by: bjl   *K01S*              */
/*                                   04/10/97   BY: *K0BF* E. Hughart         */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   by: bvm   *K11J*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 09/20/99   BY: *N033* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 09/29/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00 BY: *N0DJ* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown           */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00 BY: *N0VY* BalbeerS Rajput  */
/* REVISION: 9.1CH    LAST MODIFIED: 04/20/01 BY: *XXCH911* Charles Yen       */
/*                    Description for posting rules -                        */
/*                    1) No limitation for type "FX" vouchers; they          */
/*                       will be printed as "account transfer" vouchers      */
/*                    2) For type "JL" vouchers, bank or cash can't be       */
/*                       on the multiple entry side                          */
/*                    3) For other vouchers, bank or cash account can        */
/*                       appear no more than once on each side; multi-       */
/*                       ple appearence of same account will be fine.        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.3.9     BY: Ed van de Gevel       DATE: 07/04/02  ECO: *P0B4*  */
/* Revision: 1.7.3.11    BY: Pawel Grzybowski    DATE: 04/01/03  ECO: *P0PN*  */
/* $Revision: 1.7.3.12 $   BY: Narathip W.         DATE: 05/03/03  ECO: *P0R5*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/* $Revision: $ BY: XinChao Ma (SB) DATE: 10/31/03 ECO: *XXCH* */

/* ss - 121011.1 by: Steven */ /*Add filter by user_id*/  


/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/

/* DISPLAY TITLE */

/*{mfdtitle.i "2+ "}*/
{mfdtitle.i "121011.1"}

{cxcustom.i "GLUTRRP.P"}


{gldydef.i new}

define variable ref               like glt_ref     no-undo.
define variable ref1              like glt_ref     no-undo.
/*XXCH911*/  define new shared variable startref  like glt_ref.
/*XXCH911*/  define new shared variable endref like glt_ref.
define variable dt                like glt_date    no-undo.
define variable dt1               like glt_date    no-undo.
define variable effdt             like glt_effdate no-undo.
define variable effdt1            like glt_effdate no-undo.
/*XXCH911*/ def new shared var begdt like glt_effdate.
/*XXCH911*/ def new shared var enddt like glt_effdate.
define variable btch              like glt_batch   no-undo.
define variable unb               like glt_unb label "Unbalanced Only" no-undo.
define variable unb_msg           as character format "x(5)" no-undo.
define variable drtot             as decimal       no-undo
                                  format ">>>,>>>,>>>,>>>,>>>.99cr".
define variable crtot             like drtot       no-undo.
/*XXCH911* define variable type like glt_tr_type. */
/*XXCH911* define variable amt like glt_amt. */
/*XXCH911*/ def new shared var type like glt_tr_type.
/*XXCH911*/ def var amt as decimal format "->,>>>,>>>,>>9.99".
/*XXCH911*/ def var ck_yn as logical initial yes.
define variable unbflag           like mfc_logical no-undo.
define variable account           as character format "x(22)"
                                  label "Account"  no-undo.
define variable glname            like en_name     no-undo.
/*XXCH911* *FQ15* define variable entity like gltr_entity. */
/*XXCH911* *FQ15* define variable entity1 like gltr_entity. */
/*XXCH911*/ define new shared variable entity like gltr_entity.
/*XXCH911*/ define new shared variable entity1 like gltr_entity.
define variable entity_flag       like mfc_logical no-undo.
define variable displayed_effdate as logical       no-undo.

define buffer gltdet for glt_det.
/*XXCH911*/ define variable casacc as char format "x(16)".
/*XXCH911*/ define variable casdesc as char format "x(16)".
/*XXCH911*/ define variable cash_acct_dr as logical.
/*XXCH911*/ define variable cash_acct_cr as logical.
/*XXCH911*/ define variable credits_cnt  as int.
/*XXCH911*/ define variable debits_cnt   as int.
/*XXCH911*/ define variable multi_cr_dr  as logical init no.

/*XXCH911*/ define variable multi_bnc_dr as logical init no.
/*XXCH911*/ define variable multi_bnc_cr as logical init no.
/*XXCH911*/ define variable last_bnc_dr like ac_code.
/*XXCH911*/ define variable last_bnc_cr like ac_code.
/*XXCH911*/ define variable use_sub like mfc_logical.
/*XXCH911*/ define variable use_ctr like mfc_logical.
/*XXCH911*/ define variable set_ctr like mfc_logical.
/*XXCH911*/ define variable vchr_prt_ctr like mfc_logical.
/*XXCH911*/ define variable casunpost like mfc_logical.
/*XXCH911*/ define variable casunpostmsg as char format "x(9)".
/*XXCH911*/ define variable dr_cr as logical format "Dr/Cr".
/*XXCH911*/ {chacif.i}
/* ss - 121011.1 - B */ 
define variable user_id like glt_userid.    
define variable user_id1 like glt_userid. 
/* ss - 121011.1 - E */ 
{&GLUTRRP-P-TAG14}

/* GET NAME OF CURRENT ENTITY */
find en_mstr  where en_mstr.en_domain = global_domain and  en_entity = 
current_entity no-lock no-error.
if not available en_mstr then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */

   if c-application-mode <> 'web' then
      pause.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.
assign
   entity  = current_entity
   entity1 = entity.

/* SELECT FORM */
{&GLUTRRP-P-TAG15}
form
   entity   colon 25    entity1 colon 50 label {t001.i}
/*XXCH911*   ref      colon 25    ref1    colon 50 label {t001.i} */
/*XXCH911*   dtcolon 25    dt1     colon 50 label {t001.i} */
/*XXCH911*   effdt    colon 25    effdt1  colon 50 label {t001.i} */
/*XXCH911*/  startref colon 25    endref  colon 50 label {t001.i}
/*XXCH911*/  begdt    colon 25    enddt   colon 50 label {t001.i}
/*XXCH911*   btch     colon 25 */
/* ss - 121011.1 - B */ 
             user_id   colon 25    user_id1 colon 50 label {t001.i}
/* ss - 121011.1 - E */ 
   type     colon 25
/*XXCH911*   unb      colon 25 */
with frame a side-labels attr-space width 80
   title color normal glname.
{&GLUTRRP-P-TAG16}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&GLUTRRP-P-TAG7}
type = "JL".

/*XXCH911*/ enddt = today.
/*XXCH911*/ find first glc_cal  where glc_cal.glc_domain = global_domain and  
glc_year = year(today) and
/*XXCH911*/glc_per = 1 no-lock no-error.
/*XXCH911*/ if available(glc_cal) then begdt = glc_start.

/* REPORT BLOCK */

{wbrp01.i}

repeat:
   if ref1 = hi_char then ref1 = "".
   if dt =  low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.
   /* ss - 121009.1 - B */ 
   if user_id1 = hi_char then user_id1 = "".
   /* ss - 121009.1 - E */ 
/*XXCH911*/  if begdt = low_date then begdt = ?.
/*XXCH911*/  if enddt = hi_date then enddt = ?.
/*XXCH913*/  if startref = type then startref = "".
/*XXCH913*/  if endref = type + hi_char then endref = "".
   if entity1 = hi_char then entity1 = "".
   {&GLUTRRP-P-TAG17}
   unb = no.

   if c-application-mode <> 'web' then
      {&GLUTRRP-P-TAG18}
      update
         entity entity1
/*XXCH911*      ref ref1 */
/*XXCH911*      dt dt1 */
/*XXCH911*      effdt effdt1 */
/*XXCH911*/     startref endref
/*XXCH911*/     begdt enddt
/*XXCH911*      btch */
         /* ss - 121011.1 - b */
         user_id user_id1  
         /* ss - 121011.1 - e */
         type
/*XXCH911*      unb */
      with frame a.

/*XXCH911*   {wbrp06.i &command = update &fields = "   entity entity1 ref ref1 
dt dt1 effdt effdt1 btch type unb" &frm = "a"}  */
/*XXCH911*/ {wbrp06.i &command = update 
                      &fields = "entity 
                                 entity1 
                                 startref 
                                 endref begdt enddt type" &frm = "a"}


   {&GLUTRRP-P-TAG19}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {&GLUTRRP-P-TAG20}
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
/*XXCH911*/  {mfquoter.i startref  }
/*XXCH911*/  {mfquoter.i endref  }
/*XXCH911*/  {mfquoter.i begdt   }
/*XXCH911*/  {mfquoter.i enddt   }
/*XXCH911*   {mfquoter.i ref     } */
/*XXCH911*   {mfquoter.i ref1    } */
/*XXCH911*   {mfquoter.i dt      } */
/*XXCH911*   {mfquoter.i dt1     } */
/*XXCH911*   {mfquoter.i effdt   } */
/*XXCH911*   {mfquoter.i effdt1  } */
/*XXCH911*   {mfquoter.i btch    } */
/* ss - 121011.1 - B */ 
       {mfquoter.i user_id  }
       {mfquoter.i user_id1 }
       if user_id1 = "" then user_id1 = hi_char.
/* ss - 121011.1 - E */ 

      {mfquoter.i type    }
/*XXCH911*  {mfquoter.i unb     } */
      {&GLUTRRP-P-TAG21}

/*XXCH911*/  if endref = "" then endref = hi_char.
      if ref1 = "" then ref1 = hi_char.
      if dt = ?  then dt = low_date.
      if dt1 = ? then dt1 = hi_date.
      if effdt = ? then effdt = low_date.
      if effdt1 = ? then effdt1 = hi_date.
      if entity1 = "" then entity1 = hi_char.
/*XXCH911*/  if begdt = ? then begdt = low_date.
/*XXCH911*/  if enddt = ? then enddt = hi_date.

      {&GLUTRRP-P-TAG22}

      assign
         crtot = 0
         drtot = 0.
      {&GLUTRRP-P-TAG23}

   end.



/*XXCH921*/ /* GET NAME OF CURRENT ENTITY */
/*XXCH921*/ for each en_mstr  where en_mstr.en_domain = global_domain and  
en_entity >= entity 
/*XXCH921*/                    and en_entity <= entity1
/*XXCH921*/                   no-lock:
/*XXCH921*/ find xen_mstr  where xen_mstr.xen_domain = global_domain and  
xen_entity = en_entity no-lock no-error.
/*XXCH921*/ if not available xen_mstr then do:
/*XXCH921*/ /*   {pxmsg.i &MSGTEXT='Entity has not been setup in 34.3.1'*/
/*XXCH921*/    {pxmsg.i &MSGNUM=9833
                       &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
/*XXCH921*/   if c-application-mode <> 'web' then
/*XXCH921*/      pause.
/*XXCH921*/   return.
/*XXCH921*/ end.
/*XXCH921*/ end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

   {&GLUTRRP-P-TAG24}
/*XXCH911*   for each glt_det where
      glt_ref >= ref and glt_ref <= ref1 and
      glt_date >= dt and glt_date <= dt1 and
      glt_effdate >= effdt and glt_effdate <= effdt1 and
      (glt_batch = btch or btch = "")
      no-lock use-index glt_ref
         break by glt_ref
      with width 132 no-attr-space
*XXCH911*/
/*XXCH911*/  for each glt_det  where glt_det.glt_domain = global_domain and  
glt_entity >= entity and
/*XXCH911*/glt_entity <= entity1 and
/*XXCH911*/glt_ref >= startref and glt_ref <= endref and
/*XXCH911*/glt_effdate >= begdt and
/*XXCH911*/glt_effdate <= enddt
/* ss - 121011.1 - B */ 
           and glt_userid >= user_id 
           and glt_userid <= user_id1
/* ss - 121011.1 - B */ 
/*XXCH911*/no-lock use-index glt_index
/*XXCH911*/break by glt_entity by glt_ref
/*XXCH911*/                         with width 132 no-attr-space
                                    frame f-a no-box:

      {&GLUTRRP-P-TAG25}

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-a:handle).

      /* THIS ENTITY CHECK CANNOT BE IN THE FOR EACH SINCE */
      /* IF IT IS, ORACLE WILL IGNORE THE USE-INDEX PHRASE */
      if glt_entity < entity or glt_entity > entity1 then next.

      if type <> "" and substring(glt_ref, 1, 2) <> type then next.
/*XXCH911*  if unb = yes and glt_unb = no then next. */

      {&GLUTRRP-P-TAG26}
      if first-of(glt_ref) then do:
         {&GLUTRRP-P-TAG27}
         entity_flag = no.
         find first gltdet  where gltdet.glt_domain = global_domain and ( 
            gltdet.glt_ref = glt_det.glt_ref and
            (gltdet.glt_entity < entity or
             gltdet.glt_entity > entity1) ) no-lock no-error. 
         if available gltdet then do:
            entity_flag = yes.
            next.
         end.
         {&GLUTRRP-P-TAG1}
         {&GLUTRRP-P-TAG28}
         display
            glt_det.glt_ref
            {&GLUTRRP-P-TAG29}
            glt_det.glt_date column-label "Entered!Eff Date"
            glt_det.glt_userid.

         assign
            unb_msg = ""
            unbflag = no
            /* INDICATE THAT EFFDATE HAS NOT BEEN DISPLAYED */
            displayed_effdate = no.
         {&GLUTRRP-P-TAG2}
      end.

      else do:
         if entity_flag = yes then next.
         {&GLUTRRP-P-TAG5}
         {&GLUTRRP-P-TAG30}
         display "" @ glt_det.glt_ref.
         {&GLUTRRP-P-TAG31}

         /* DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE, */
         /* ON 2ND LINE OF REF IF NO ERROR ON 1ST LINE OF REF. */
         if not displayed_effdate
         then do:
            display
               glt_det.glt_effdate @ glt_det.glt_date.
            displayed_effdate = yes.
         end.
         else
            display
               "" @ glt_det.glt_date.
         display
            "" @ glt_det.glt_userid.
         {&GLUTRRP-P-TAG6}
      end.
      {&GLUTRRP-P-TAG32}
      amt = glt_det.glt_amt.
      if glt_det.glt_curr <> base_curr
      then
         amt = glt_det.glt_curr_amt.
      find ac_mstr  where ac_mstr.ac_domain = global_domain and  ac_code = 
      glt_det.glt_acc no-lock no-error.
      if not available ac_mstr then do:
         accumulate glt_det.glt_amt (total by glt_det.glt_ref).
         {&GLUTRRP-P-TAG10}
         if glt_det.glt_amt < 0
         then crtot = crtot - glt_det.glt_amt.
         else drtot = drtot + glt_det.glt_amt.
         {&GLUTRRP-P-TAG11}
      end.
      else
      if ac_type <> "S" and ac_type <> "M" then do:
         accumulate glt_det.glt_amt (total by glt_det.glt_ref).
         {&GLUTRRP-P-TAG12}
         if glt_det.glt_amt < 0
         then crtot = crtot - glt_det.glt_amt.
         else drtot = drtot + glt_det.glt_amt.
         {&GLUTRRP-P-TAG13}
      end.
      {glacct.i
         &acc=glt_det.glt_acc
         &sub=glt_det.glt_sub
         &cc=glt_det.glt_cc
         &acct=account}
      {&GLUTRRP-P-TAG3}
/*XXCH911*/      /* GENERATE CAS ACCOUNT AND DESCRIPTION */
/*XXCH911*/     {chcasacc.i &acc=glt_det.glt_acc
                            &sub=glt_det.glt_sub
                            &ctr=glt_det.glt_cc
                            &casacc=casacc
                            &casdesc=casdesc}
/*XXCH911*/     {chtramt3.i &glamt=amt
                            &coa=glt_det.glt_correction
                            &drcr=dr_cr
                            &dispamt=amt}
      display
         glt_det.glt_line
/*XXCH911*/    casacc
         account
         glt_det.glt_project
         glt_det.glt_entity
/*XXCH911*     glt_det.glt_desc */
/*XXCH911*/    dr_cr
         amt
         glt_det.glt_curr
         glt_det.glt_dy_code.
      {&GLUTRRP-P-TAG4}
      /* SECOND LINE NEEDED WHEN AN ERROR. */
      /* ALSO DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE. */
/*XXCH911*/     if glt_det.glt_desc <> "" then do:
/*XXCH911*/        down 1.
/*XXCH911*/        display glt_det.glt_desc @ casacc.
/*XXCh911*/     end.
      if glt_det.glt_error <> "" then do:
         down 1.
         if not displayed_effdate
         then do:
            {&GLUTRRP-P-TAG8}
            display
               glt_det.glt_effdate @ glt_det.glt_date.
            {&GLUTRRP-P-TAG9}
            displayed_effdate = yes.
         end.

/*XXCH911*   display glt_det.glt_error @ glt_det.glt_desc. */
/*XXCH911*/display glt_det.glt_error @ casacc.

      end.

      if daybooks-in-use and glt_det.glt_dy_code > "" and
         (glt_det.glt_dy_num = "" or glt_det.glt_dy_num = ?)
      then do:
         down 1.
         display  "* " + getTermLabel("NO_DAYBOOK_ENTRY",19) + "# *"
/*XXCH911*    @ glt_det.glt_desc.  */
/*XXCH911*/   @ casacc.
      end.

      if glt_det.glt_unb = yes then unbflag = yes.

      if last-of(glt_det.glt_ref) then do:

/*XXCH911*/        /* CHECK IF IT IS AN ILLEGAL CAS VOUCHER */
/*XXCH911*/        {chckvch1.i &ref=glt_det.glt_ref}

/*XXCH911*/        /* MAINTAIN UNPOSTED VOUCHER EXTENSION */
/*XXCH911*/        {chxgltcr.i &entity=glt_det.glt_entity
                               &ref=glt_det.glt_ref
                               &rflag=glt_det.glt_rflag
                               &trtype=glt_det.glt_tr_type
                               &userid=glt_det.glt_userid
                               &refresh=no}

         /* DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE, */
         /* ON LAST LINE OF REF IF NOT ALREADY DISPLAYED.      */
         if not displayed_effdate
         then do:
            down 1.
            {&GLUTRRP-P-TAG8}
            display
               glt_det.glt_effdate @ glt_det.glt_date.
            {&GLUTRRP-P-TAG9}
            displayed_effdate = yes.
         end.

/*XXCH911*/        /* GET CAS RELATED UNPOSTABLE VOUCHER MESSAGES */
/*XXCH911*/        {chvchrms.i &casunpost=casunpost &casunpostmsg=casunpostmsg}
/*XXCH911*/        if casunpost then unbflag = yes.

         if unbflag = yes then
/*XXCH920001*            unb_msg = "*" + getTermLabel("UNBALANCED",3) + "*". */
/*XXCH920001*/           unb_msg = "*" + getTermLabel("UNBALANCED",8) + "*".
/*XXCH911*/        if casunpost then unb_msg = casunpostmsg.
         underline amt.

         display
            accum total by glt_det.glt_ref glt_det.glt_amt @ amt
            base_curr @ glt_det.glt_curr
            unb_msg @ glt_det.glt_dy_code.
         down 1.
      end.

      {&GLUTRRP-P-TAG33}
      {mfrpchk.i}
   end.

   /* PRINT DEBIT AND CREDIT TOTALS */

   {&GLUTRRP-P-TAG34}
   put skip(2)

      {gplblfmt.i
         &FUNC=getTermLabelRtColon(""DEBIT_TOTAL"",20)
         &CONCAT="'  '"
      }  at 25 drtot space(1) base_curr

      {gplblfmt.i
         &FUNC=getTermLabelRtColon(""CREDIT_TOTAL"",20)
         &CONCAT="'  '"
      } at 75 crtot space(1) base_curr.
      {&GLUTRRP-P-TAG35}

   /* REPORT TRAILER  */
   {mfrtrail.i}
/*XXCH911*/  view frame a.
/*XXCH911*/  {mfmsg01.i 9834 1 ck_yn}
/*XXCH911*/  if ck_yn then {gprun.i ""chglpst1.p""}

end.

{wbrp04.i &frame-spec = a}
