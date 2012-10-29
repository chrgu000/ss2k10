/* GUI CONVERTED from chcfutrp.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chcfutrp.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER - CAS*/
/* glutrrp.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.3.12.1.1 $                                                               */
/*V8:ConvertMode=Report                                                */
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
/* REVISION: 9.1CH    LAST MODIFIED: 05/03/01 BY: *XXCH911* Charles Yen   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.3.9     BY: Ed van de Gevel       DATE: 07/04/02  ECO: *P0B4*  */
/* Revision: 1.7.3.11    BY: Pawel Grzybowski    DATE: 04/01/03  ECO: *P0PN*  */
/* Revision: 1.7.3.12    BY: Narathip W.        DATE: 05/03/03  ECO: *P0R5*   */
/* $Revision: 1.7.3.12.1.1 $          BY: Preeti Sattur      DATE: 07/29/04  ECO: *P2CN*   */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*      */    
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
{cxcustom.i "GLUTRRP.P"}


{gldydef.i new}

define variable ref               like glt_ref     no-undo.
define variable ref1              like glt_ref     no-undo.
define variable dt                like glt_date    no-undo.
define variable dt1               like glt_date    no-undo.
define variable effdt             like glt_effdate no-undo.
define variable effdt1            like glt_effdate no-undo.
define variable btch              like glt_batch   no-undo.
define variable unb               like glt_unb label "Unbalanced Only" no-undo.
define variable unb_msg           as character format "x(5)" no-undo.
define variable drtot             as decimal       no-undo
                                  format ">>>,>>>,>>>,>>>,>>>.99cr".
define variable crtot             like drtot       no-undo.
define variable type              like glt_tr_type no-undo.
define variable amt               like glt_amt     no-undo.
define variable unbflag           like mfc_logical no-undo.
define variable account           as character format "x(22)"
                                  label "Account"  no-undo.
define variable glname            like en_name     no-undo.
define variable entity            like gltr_entity no-undo.
define variable entity1           like gltr_entity no-undo.
define variable displayed_effdate as logical       no-undo.
define variable l_first_glt_ref   like mfc_logical no-undo.
define variable valid_acct  like mfc_logical                 no-undo.
/*XXLY*/ define variable vaild_table like mfc_logical no-undo.
define buffer gltdet for glt_det.
/*CF*/ define buffer xcftdet for xcft_det.
/*XXCH911*/ define variable coa_only as logical format "Y/N".
/*XXCH911*/ define variable dr_amt as decimal format "->>,>>>,>>>.99".
/*XXCH911*/ define variable cr_amt as decimal format "->>,>>>,>>>.99".
/*XXCH911*/ define variable dr_cr as logical format "Dr/Cr".
/*XXCH911*/ define variable drcrtxt as char format "x(2)".
/*XXCH911*/ define var xamt as decimal format "->,>>>,>>>,>>9.99".
/*CF*/ define var tot_xamt as decimal format "->,>>>,>>>,>>9.99".
/*CF*/ define var cfunpost as logical.

{&GLUTRRP-P-TAG14}

/* GET NAME OF CURRENT ENTITY */
/*21*/
find en_mstr where en_entity = current_entity and en_domain = global_domain no-lock no-error.
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
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
entity   colon 25    entity1 colon 50 label {t001.i}
   ref      colon 25    ref1    colon 50 label {t001.i}
   dt       colon 25    dt1     colon 50 label {t001.i}
   effdt    colon 25    effdt1  colon 50 label {t001.i}
   btch     colon 25
   type     colon 25
   unb      colon 25
/*XXCH911*/  coa_only colon 25
with frame a side-labels attr-space width 80
    NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = glname.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&GLUTRRP-P-TAG16}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&GLUTRRP-P-TAG7}
type = "JL".

/* REPORT BLOCK */

{wbrp01.i}

repeat:
   if ref1 = hi_char then ref1 = "".
   if dt =  low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.
   if entity1 = hi_char then entity1 = "".
   {&GLUTRRP-P-TAG17}
   unb = no.
/*XXCh911*/  coa_only = no.

   if c-application-mode <> 'web' then
      {&GLUTRRP-P-TAG18}
      update
         entity entity1
         ref ref1
         dt dt1
         effdt effdt1
         btch
         type
         unb
/*XXCH911*/     coa_only
      with frame a.

/*XXCH911* {wbrp06.i &command = update &fields = "   entity entity1 ref r
ef1 dt dt1
effdt effdt1 btch type unb" &frm = "a"} */
/*XXCH911*/ {wbrp06.i &command = update 
                      &fields = "entity entity1 ref ref1 
         dt dt1 effdt effdt1 btch type unb coa_only" &frm = "a"}

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
      {mfquoter.i ref     }
      {mfquoter.i ref1    }
      {mfquoter.i dt      }
      {mfquoter.i dt1     }
      {mfquoter.i effdt   }
      {mfquoter.i effdt1  }
      {mfquoter.i btch    }
      {mfquoter.i type    }
      {mfquoter.i unb     }
/*XXCH911*/  {mfquoter.i coa_only}
      {&GLUTRRP-P-TAG21}

      if ref1 = "" then ref1 = hi_char.
      if dt = ?  then dt = low_date.
      if dt1 = ? then dt1 = hi_date.
      if effdt = ? then effdt = low_date.
      if effdt1 = ? then effdt1 = hi_date.
      if entity1 = "" then entity1 = hi_char.
      {&GLUTRRP-P-TAG22}

      assign
         crtot = 0
         drtot = 0.
      {&GLUTRRP-P-TAG23}

   end.

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

   {&GLUTRRP-P-TAG24}
    for each xcft_det where xcft_ref >= ref and xcft_ref <= ref1 exclusive-lock use-index xcft_ref:
   	  
   	   find first xcf_mstr where xcf_ac_code = xcft_ac_code and xcft_ref begins "JL"          
                        and ( if xcf_sub <> "*" then xcft_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then xcft_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then xcft_pro = xcf_pro else true )       
                        and xcf_active = yes
                        and xcf_domain = global_domain
                             no-lock no-error.
/*XXLY*/  find first xcf1_mstr where xcf1_mfgc_ac_code =  xcft_ac_code   
                      and (xcft_ref begins "AP" or xcft_ref begins "AR")
             	        and ( if xcf1_mfgc_sub <> "*" then xcft_sub= xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then xcft_cc = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then xcft_pro = xcf1_mfgc_pro else true )   
                      and xcf1_cf_acc = yes
                      and xcf1_active = yes
                      and xcf1_domain = global_domain    
                          no-lock no-error. 
/*XXLY*/     if not ( (available xcf_mstr) or (available xcf1_mstr) )  then do: 
                      delete xcft_det.  
    	            end.
   	         end.   
   for each xcftdet where 
      xcftdet.xcft_ref >= ref and xcftdet.xcft_ref <= ref1 and xcftdet.xcft_domain = global_domain,      
   each glt_det where
/*21*/      glt_ref = xcftdet.xcft_ref and glt_domain = global_domain and 
      glt_date >= dt and glt_date <= dt1 and
      glt_effdate >= effdt and glt_effdate <= effdt1 and
      (glt_batch = btch or btch = "") 
      
      no-lock use-index glt_ref
         break by glt_ref by glt_line
      with width 132 no-attr-space frame f-a no-box:
        
      if first-of(glt_ref)
      then
         l_first_glt_ref = yes.

      {&GLUTRRP-P-TAG25}

/*XXCH911*/     FORM /*GUI*/     
/*XXCH911*/             glt_det.glt_ref
                        glt_det.glt_line
/*XXCH911*/             account
/*XXCH911*/             glt_det.glt_project
/*XXCH911*/             glt_det.glt_entity
/*XXCH911*/             glt_det.glt_desc
/*XXCH911*/             dr_cr
/*XXCH911*/             amt
/*XXCH911*/             glt_det.glt_curr
/*XXCH911*/             glt_det.glt_dy_code
/*XXCH911*/             with STREAM-IO /*GUI*/  frame f-a width 132 no-attr-space no-box.
        
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-a:handle).

      /* THIS ENTITY CHECK CANNOT BE IN THE FOR EACH SINCE */
      /* IF IT IS, ORACLE WILL IGNORE THE USE-INDEX PHRASE */
      if glt_entity < entity or glt_entity > entity1 then next.

      if type <> "" and substring(glt_ref, 1, 2) <> type then next.
      if unb = yes and glt_unb = no then next.

      {&GLUTRRP-P-TAG26}
/*XXCH911*/     if coa_only and glt_correction = no then next.
      if l_first_glt_ref
      then do:

         l_first_glt_ref = no.

         {&GLUTRRP-P-TAG27}
         {&GLUTRRP-P-TAG1}
         {&GLUTRRP-P-TAG28}
         display
            glt_det.glt_ref
            {&GLUTRRP-P-TAG29}
            glt_det.glt_date column-label "Entered!Eff Date" WITH STREAM-IO /*GUI*/ .
/*XXCH911*  glt_det.glt_userid. */

         assign
            unb_msg = ""
            unbflag = no
            /* INDICATE THAT EFFDATE HAS NOT BEEN DISPLAYED */
            displayed_effdate = no.
         {&GLUTRRP-P-TAG2}
      end.

      else do:
         {&GLUTRRP-P-TAG5}
         {&GLUTRRP-P-TAG30}
         display "" @ glt_det.glt_ref WITH STREAM-IO /*GUI*/ .
         {&GLUTRRP-P-TAG31}

         /* DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE, */
         /* ON 2ND LINE OF REF IF NO ERROR ON 1ST LINE OF REF. */
         if not displayed_effdate
         then do:
            display
               glt_det.glt_effdate @ glt_det.glt_date WITH STREAM-IO /*GUI*/ .
            displayed_effdate = yes.
         end.
         else
            display
               "" @ glt_det.glt_date WITH STREAM-IO /*GUI*/ .
/*XXCH911*  display
            "" @ glt_det.glt_userid. *XXCH911*/
         {&GLUTRRP-P-TAG6}
      end.
      
      {&GLUTRRP-P-TAG32}
      amt = glt_det.glt_amt.
      if glt_det.glt_curr <> base_curr
      then
         amt = glt_det.glt_curr_amt.
/*21*/      find ac_mstr where ac_code = glt_det.glt_acc and ac_domain = global_domain 
      no-lock no-error.
    if first-of(glt_line) then do:
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
/*XXCH911*/        drcrtxt = getTermLabel(string(dr_cr, "Dr/Cr"), 2).
/*XXCH911*/     end.
      {glacct.i
         &acc=glt_det.glt_acc
         &sub=glt_det.glt_sub
         &cc=glt_det.glt_cc
         &acct=account}
      {&GLUTRRP-P-TAG3}
      
     display
         glt_det.glt_line
         account
         glt_det.glt_project
         glt_det.glt_entity
         glt_det.glt_desc
/*XXCH911*/   drcrtxt @ dr_cr
         amt
         glt_det.glt_curr
         glt_det.glt_dy_code WITH STREAM-IO /*GUI*/ .
      {&GLUTRRP-P-TAG4}
      /* SECOND LINE NEEDED WHEN AN ERROR. */
      /* ALSO DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE. */
      if glt_det.glt_error <> "" then do:
         down 1.
         if not displayed_effdate
         then do:
            {&GLUTRRP-P-TAG8}
            display
               glt_det.glt_effdate @ glt_det.glt_date WITH STREAM-IO /*GUI*/ .
            {&GLUTRRP-P-TAG9}
            displayed_effdate = yes.
         end.

         display glt_det.glt_error @ glt_det.glt_desc WITH STREAM-IO /*GUI*/ .
      end.

      if daybooks-in-use and glt_det.glt_dy_code > "" and
         (glt_det.glt_dy_num = "" or glt_det.glt_dy_num = ?)
      then do:
         down 1.
         display  "* " + getTermLabel("NO_DAYBOOK_ENTRY",19) + "# *"
            @ glt_det.glt_desc WITH STREAM-IO /*GUI*/ .
      end.
  end.   /* first-of glt_line */
/*CF*/      /* DISPLAY UNPOSTED CASH FLOW TRANSACTION */
/*CF* Add Begin */
     if first-of(glt_line) then do:

         find first xcf_mstr where xcf_ac_code = glt_det.glt_acct and glt_det.glt_ref begins "JL"          
                        and ( if xcf_sub <> "*" then glt_det.glt_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then glt_det.glt_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then glt_det.glt_project = xcf_pro else true )       
                        and xcf_active = yes
                        and xcf_domain = global_domain
                             no-lock no-error.
/*XXLY*/         find first xcf1_mstr where xcf1_mfgc_ac_code =  glt_det.glt_acct   
                      and (glt_det.glt_ref begins "AP" or glt_det.glt_ref begins "AR")
             	        and ( if xcf1_mfgc_sub <> "*" then glt_det.glt_sub = xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then glt_det.glt_cc = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then glt_det.glt_project = xcf1_mfgc_pro else true )   
                      and xcf1_cf_acc = yes
                      and xcf1_active = yes
                      and xcf1_domain = global_domain    
                          no-lock no-error. 
/*XXLY*/     if ( (available xcf_mstr) or (available xcf1_mstr) )  then do:
                      down 1 with fram f-a.
            tot_xamt = 0.
            for each xcft_det where xcft_det.xcft_entity   = glt_det.glt_entity
                                and xcft_det.xcft_ref      = glt_det.glt_ref
                                and xcft_det.xcft_rflag    = glt_det.glt_rflag
                                and xcft_det.xcft_ac_code  = glt_det.glt_acct
                                and xcft_sub      = glt_det.glt_sub
                                and xcft_cc       = glt_det.glt_cc
                                and xcft_pro      = glt_det.glt_project
                                and xcft_det.xcft_glt_line = glt_det.glt_line
                                and xcft_domain = global_domain
                                   no-lock:

                if glt_det.glt_curr = base_curr then
                   tot_xamt = tot_xamt + xcft_det.xcft_amt.
                else tot_xamt = tot_xamt + xcft_det.xcft_curr_amt.

                   /* GENERATE DR_CR FLAG AND XAMT */
                   {chtramt1.i &glamt=xcft_det.xcft_amt
                               &glcurramt=xcft_det.xcft_curr_amt
                               &coa=glt_det.glt_correction
                               &glcurr=glt_det.glt_curr
                               &basecurr=base_curr
                               &usecurramt=yes
                               &drcr=dr_cr
                               &dispamt=xamt}
/*XXCH911*/        drcrtxt = getTermLabel(string(dr_cr, "Dr/Cr"), 2).

                   display /*xcft_line @ glt_det.glt_line*/
                     getTermLabelRtColon("CASHFLOW", 9) + xcft_det.xcft_acct @ account
                           xcft_det.xcft_desc @ glt_det.glt_desc
                           glt_det.glt_curr
                           drcrtxt @ dr_cr
                           xamt @ amt with frame f-a STREAM-IO /*GUI*/ .
                     down 1 with frame f-a.  
             end. /* for each xcft_det */
             if glt_det.glt_curr = base_curr then
                if glt_det.glt_amt <> tot_xamt then cfunpost = yes.
             if glt_det.glt_curr <> base_curr then
                if glt_det.glt_curr_amt <> tot_xamt then cfunpost = yes.

          end. /* if available xcf_mstr */
/*XXLY*/             assign  vaild_table = false    . 
      if cfunpost = yes then unbflag = yes.
/*CF* Add End */
      if glt_det.glt_unb = yes then unbflag = yes.
  
      if last-of(glt_det.glt_ref) then do:

         /* DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE, */
         /* ON LAST LINE OF REF IF NOT ALREADY DISPLAYED.      */
         if not displayed_effdate
         then do:
            down 1.
            {&GLUTRRP-P-TAG8}
            display
               glt_det.glt_effdate @ glt_det.glt_date WITH STREAM-IO /*GUI*/ .
            {&GLUTRRP-P-TAG9}
            displayed_effdate = yes.
         end.

         if unbflag = yes then
            unb_msg = "*" + getTermLabel("UNBALANCED",3) + "*".
         underline amt.

         display
            accum total by glt_det.glt_ref glt_det.glt_amt @ amt
            base_curr @ glt_det.glt_curr
            unb_msg @ glt_det.glt_dy_code WITH STREAM-IO /*GUI*/ .
         down 1.
      end.
    end.   /*  first-of glt_line */
      {&GLUTRRP-P-TAG33}
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

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
end.

{wbrp04.i &frame-spec = a}
                                   