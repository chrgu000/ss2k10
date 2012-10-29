/* GUI CONVERTED from chglpst.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
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
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "z+ "}
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
/*XXCH911*/ define var xamt as decimal format "->,>>>,>>>,>>9.99".
/*CF*/ define var tot_xamt as decimal format "->,>>>,>>>,>>9.99".
/*CF*/ define var cfunpost as logical.

/*CF*/ define buffer gltdet1    for glt_det.
/*CF*/ define variable non-cash-bank like mfc_logical.

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

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
entity   colon 25    entity1 colon 50 label {t001.i}
/*XXCH911*   ref      colon 25    ref1    colon 50 label {t001.i} */
/*XXCH911*   dtcolon 25    dt1     colon 50 label {t001.i} */
/*XXCH911*   effdt    colon 25    effdt1  colon 50 label {t001.i} */
/*XXCH911*/  startref colon 25    endref  colon 50 label {t001.i}
/*XXCH911*/  begdt    colon 25    enddt   colon 50 label {t001.i}
/*XXCH911*   btch     colon 25 */
   type     colon 25
/*XXCH911*   unb      colon 25 */


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame a side-labels attr-space width 80
   
&IF (("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" <> "A")) &THEN
title color normal glname
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = glname.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/
&ENDIF /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

   if ref1 = hi_char then ref1 = "".
   if dt =  low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.
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
/*XXCH921*/ for each en_mstr where en_entity >= entity 
/*XXCH921*/                    and en_entity <= entity1
                               and en_domain = global_domain 
/*XXCH921*/                   no-lock:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


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
   {mfphead.i}

/*XXCH911*/  for each glt_det where glt_entity >= entity 
/*XXCH911*/                     and glt_entity <= entity1 
/*XXCH911*/                     and glt_ref >= startref 
                                and glt_ref <= endref 
/*XXCH911*/                     and glt_effdate >= begdt 
/*XXCH911*/                     and glt_effdate <= enddt
                                and glt_domain = global_domain
/*XXCH911*/        no-lock use-index glt_index
/*XXCH911*/        break by glt_entity by glt_ref by glt_line
/*XXCH911*/        with width 182 no-attr-space frame f-a no-box:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


/*XXCH911*/     FORM /*GUI*/     glt_det.glt_ref space(4)
                        glt_det.glt_date
                        glt_det.glt_userid
                        glt_det.glt_line
/*XXCH911*/             casacc
/*XXCH911*/             casdesc
/*XXLY*/                account
/*XXCH911*/             glt_det.glt_entity
/*XXCH911*/             glt_det.glt_desc
/*XXCH911*/             dr_cr
/*XXCH911*/             amt
/*XXCH911*/             glt_det.glt_curr
/*XXCH911*/             glt_det.glt_dy_code
/*XXCH911*/             with frame f-a width 182 no-attr-space no-box
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 THREE-D /*GUI*/
&ENDIF /*GUI*/
.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-a:handle).

      /* THIS ENTITY CHECK CANNOT BE IN THE FOR EACH SINCE */
      /* IF IT IS, ORACLE WILL IGNORE THE USE-INDEX PHRASE */
      if glt_entity < entity or glt_entity > entity1 then next.

      if type <> "" and substring(glt_ref, 1, 2) <> type then next.

      if first-of(glt_ref) then do:
         entity_flag = no.
         find first gltdet  where gltdet.glt_domain = global_domain and ( 
            gltdet.glt_ref = glt_det.glt_ref and
            (gltdet.glt_entity < entity or
             gltdet.glt_entity > entity1) ) use-index glt_ref no-lock no-error. 
         if available gltdet then do:
            entity_flag = yes.
            next.
         end.

         display
            glt_det.glt_ref
            glt_det.glt_date column-label "Entered!Eff Date"
            glt_det.glt_userid with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.

         assign
            unb_msg = ""
            unbflag = no
            /* INDICATE THAT EFFDATE HAS NOT BEEN DISPLAYED */
            displayed_effdate = no.

/*CF*/   assign cfunpost = no.

      end.

      else do:
         if entity_flag = yes then next.
              display "" @ glt_det.glt_ref with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.

         /* DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE, */
         /* ON 2ND LINE OF REF IF NO ERROR ON 1ST LINE OF REF. */
         if not displayed_effdate
         then do:
            display
               glt_det.glt_effdate @ glt_det.glt_date with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
            displayed_effdate = yes.
         end.
         else
            display
               "" @ glt_det.glt_date with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
/*
         display
            "" @ glt_det.glt_userid with frame f-a.
*/
      end.
      amt = glt_det.glt_amt.
      if glt_det.glt_curr <> base_curr
      then
         amt = glt_det.glt_curr_amt.
      find ac_mstr where ac_code = glt_det.glt_acc and ac_domain = global_domain 
                no-lock no-error.

/*
      if not available ac_mstr then do:
         accumulate glt_det.glt_amt (total by glt_det.glt_ref).
         if glt_det.glt_amt < 0
         then crtot = crtot - glt_det.glt_amt.
         else drtot = drtot + glt_det.glt_amt.
      end.
      else
      if ac_type <> "S" and ac_type <> "M" then do:
         accumulate glt_det.glt_amt (total by glt_det.glt_ref).
         if glt_det.glt_amt < 0
         then crtot = crtot - glt_det.glt_amt.
         else drtot = drtot + glt_det.glt_amt.
         {&GLUTRRP-P-TAG13}
      end.
*/
/*XXCH911*/     {chtramt3.i &glamt=amt
                            &coa=glt_det.glt_correction
                            &drcr=dr_cr
                            &dispamt=amt}

/*XXCH911*/     if not available ac_mstr or
/*XXCH911*/        (available ac_mstr and (ac_type <> "S" and ac_type <> "M"))
/*XXCH911*/        then do:
/*XXCH911*/        accumulate glt_det.glt_amt (total by glt_det.glt_ref).
/*XXCH911*/        if dr_cr then drtot = drtot + amt.
/*XXCH911*/                 else crtot = crtot + amt.
/*XXCH911*/     end.


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

      display
         glt_det.glt_line
         casacc
         casdesc
/*XXLY*/          account
         glt_det.glt_entity
         glt_det.glt_desc
         dr_cr
         amt
         glt_det.glt_curr
         glt_det.glt_dy_code with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.

      /* SECOND LINE NEEDED WHEN AN ERROR. */
      /* ALSO DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE. */
/*
/*XXCH911*/     if casdesc <> "" then do:
/*XXCH911*/        down 1 with frame f-a.
/*XXCH911*/        display casdesc @ casacc with frame f-a.
/*XXCh911*/     end.
*/
      if glt_det.glt_error <> "" then do:
         down 1 with frame f-a.
         if not displayed_effdate
         then do:
            {&GLUTRRP-P-TAG8}
            display
               glt_det.glt_effdate @ glt_det.glt_date with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
            {&GLUTRRP-P-TAG9}
            displayed_effdate = yes.
         end.

/*XXCH911*   display glt_det.glt_error @ glt_det.glt_desc. */
/*XXCH911*/display glt_det.glt_error @ casacc with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.

      end.

      if daybooks-in-use and glt_det.glt_dy_code > "" and
         (glt_det.glt_dy_num = "" or glt_det.glt_dy_num = ?)
      then do:
         down 1 with frame f-a.
         display  "* " + getTermLabel("NO_DAYBOOK_ENTRY",19) + "# *"
/*XXCH911*    @ glt_det.glt_desc.  */
/*XXCH911*/   @ casacc with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
      end.

/*CF*/      /* DISPLAY UNPOSTED CASH FLOW TRANSACTION */
/*CF* Add Begin */
         if not (glt_det.glt_ref begins "FX") then do:
             
         find first xcf_mstr where xcf_ac_code = glt_det.glt_acct and glt_det.glt_ref begins "JL"
                        and ( if xcf_sub <> "*" then glt_det.glt_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then glt_det.glt_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then glt_det.glt_project = xcf_pro else true ) 
                        and xcf_active = yes and xcf_domain = global_domain
                            use-index xcf_cf_mfg no-lock no-error.
                            
/*XXLY*/         find first xcf1_mstr where xcf1_mfgc_ac_code =  glt_det.glt_acct and 
                     (glt_det.glt_ref begins "AP" or glt_det.glt_ref begins "AR")
                      and ( if xcf1_mfgc_sub <> "*" then glt_det.glt_sub = xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then glt_det.glt_cc = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then glt_det.glt_project = xcf1_mfgc_pro else true )  
                      and xcf1_active = yes 
                      and xcf1_domain = global_domain
                      no-lock no-error.             
         if ( (available xcf_mstr) or (available xcf1_mstr) ) then do:

         non-cash-bank = no.
         
         for each gltdet1 where gltdet1.glt_ref = glt_det.glt_ref 
         	      and gltdet1.glt_domain = global_domain no-lock use-index glt_ref :
             find  xcf_mstr where xcf_ac_code = gltdet1.glt_acct and gltdet1.glt_ref begins "JL"
/*XXLY*/                and ( if xcf_sub <> "*" then gltdet1.glt_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then gltdet1.glt_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then gltdet1.glt_project = xcf_pro else true ) 
                        and xcf_active = yes
                        and xcf_domain = global_domain use-index xcf_cf_mfg no-lock no-error.
            
/*XXLY*/         find  xcf1_mstr where xcf1_mfgc_ac_code =  gltdet1.glt_acct and 
                     (gltdet1.glt_ref begins "AP" or gltdet1.glt_ref begins "AR")
                      and ( if xcf1_mfgc_sub <> "*" then gltdet1.glt_sub = xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then gltdet1.glt_cc = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then gltdet1.glt_project = xcf1_mfgc_pro else true )  
                      and xcf1_active = yes 
                      and xcf1_domain = global_domain
                      no-lock no-error.
             if not ( (available xcf_mstr) or (available xcf1_mstr) ) then do:

                non-cash-bank = yes.
                leave.
             end.
         end.

         if non-cash-bank = yes then do:

            for first xcft_det where xcft_entity   = glt_det.glt_entity
                                and xcft_ref      = glt_det.glt_ref
                                and xcft_rflag    = glt_det.glt_rflag
                                and xcft_ac_code  = glt_det.glt_acct
                                and xcft_sub      = glt_det.glt_sub
                                and xcft_cc       = glt_det.glt_cc
                                and xcft_pro      = glt_det.glt_project
                                and xcft_glt_line = glt_det.glt_line
                                and xcft_domain = global_domain
                                use-index xcft_ref
                                   no-lock: end.
            if available xcft_det then do:             
            down 1 with fram f-a.             
            display getTermLabel("CASHFLOW", 12) @ casacc

&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 WITH STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
   
            down 1 with fram f-a.
            tot_xamt = 0.
            for each xcft_det where xcft_entity   = glt_det.glt_entity
                                and xcft_ref      = glt_det.glt_ref
                                and xcft_rflag    = glt_det.glt_rflag
                                and xcft_ac_code  = glt_det.glt_acct
                                and xcft_sub      = glt_det.glt_sub
                                and xcft_cc       = glt_det.glt_cc
                                and xcft_pro      = glt_det.glt_project
                                and xcft_glt_line = glt_det.glt_line
                                and xcft_domain = global_domain
                                use-index xcft_ref
                                   no-lock break by xcft_line :
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


                if glt_det.glt_curr = base_curr then
                   tot_xamt = tot_xamt + xcft_amt.
                else tot_xamt = tot_xamt + xcft_curr_amt.

                   /* GENERATE DR_CR FLAG AND XAMT */
                   {chtramt1.i &glamt=xcft_amt
                               &glcurramt=xcft_curr_amt
                               &coa=glt_det.glt_correction
                               &glcurr=glt_det.glt_curr
                               &basecurr=base_curr
                               &usecurramt=yes
                               &drcr=dr_cr
                               &dispamt=xamt}

                   display xcft_line @ glt_det.glt_line
                           xcft_acct @ casacc
                           xcft_desc @ glt_det.glt_desc
                           glt_det.glt_curr
                           dr_cr
                           xamt @ amt with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
                      down 1 with frame f-a.
             end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* for each xcft_det */


             if glt_det.glt_curr = base_curr then
                if glt_det.glt_amt <> tot_xamt then cfunpost = yes.
             if glt_det.glt_curr <> base_curr then
                if glt_det.glt_curr_amt <> tot_xamt then cfunpost = yes.

            end. /* if available xcft_det */

           end. /*if non-cash-bank = yes then do:*/
          end. /* if available xcf_mstr */

         end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


/*CF* Add End */

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
            down 1 with frame f-a.
            {&GLUTRRP-P-TAG8}
            display
               glt_det.glt_effdate @ glt_det.glt_date with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
            {&GLUTRRP-P-TAG9}
            displayed_effdate = yes.
         end.

/*XXCH911*/        /* GET CAS RELATED UNPOSTABLE VOUCHER MESSAGES */
/*XXCH911*/        {chvchrms.i &casunpost=casunpost &casunpostmsg=casunpostmsg}
/*XXCH911*/        if casunpost then unbflag = yes.

/*CF*/             if cfunpost = yes then unbflag = yes.

         if unbflag = yes then
/*XXCH920001*            unb_msg = "*" + getTermLabel("UNBALANCED",3) + "*". */
/*XXCH920001*/           unb_msg = "*" + getTermLabel("UNBALANCED",8) + "*".
/*XXCH911*/        if casunpost then unb_msg = casunpostmsg.
/*CF*/      if cfunpost then unb_msg = getTermLabel("CASHFLOW_UNBALANCED",8).
         underline amt.

         display
            accum total by glt_det.glt_ref glt_det.glt_amt @ amt
            base_curr @ glt_det.glt_curr
            unb_msg @ glt_det.glt_dy_code with frame f-a
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
         down 1 with frame f-a.
      end.

      {&GLUTRRP-P-TAG33}
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


end.

{wbrp04.i &frame-spec = a}
