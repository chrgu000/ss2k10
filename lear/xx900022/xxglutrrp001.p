/* glutrrp.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER                  */
/*V8:ConvertMode=FullGUIReport                                               */
/*****************************************************************************/

{xxgltbrpdef.i}

define input parameter i_entity            like gltr_entity no-undo.
define input parameter i_entity1           like gltr_entity no-undo.
define input parameter i_ref               like glt_ref     no-undo.
define input parameter i_ref1              like glt_ref     no-undo.
define input parameter i_dt                like glt_date    no-undo.
define input parameter i_dt1               like glt_date    no-undo.
define input parameter i_effdt             like glt_effdate no-undo.
define input parameter i_effdt1            like glt_effdate no-undo.
define input parameter i_btch              like glt_batch   no-undo.
define input parameter i_type              like glt_tr_type no-undo.
define input parameter i_unb               like glt_unb no-undo.
/* SS - 090423.1 - E */

{mfdeclre.i}
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

define buffer gltdet for glt_det.
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
   ref      colon 25    ref1    colon 50 label {t001.i}
   dt       colon 25    dt1     colon 50 label {t001.i}
   effdt    colon 25    effdt1  colon 50 label {t001.i}
   btch     colon 25
   type     colon 25
   unb      colon 25
with frame a side-labels attr-space width 80
   title color normal glname.
{&GLUTRRP-P-TAG16}

/* SET EXTERNAL LABELS
setFrameLabels(frame a:handle).
 */

{&GLUTRRP-P-TAG7}
type = "JL".

/* REPORT BLOCK */

{wbrp01.i}

/* SS - 090423.1 - B
repeat:
SS - 090423.1 - E */

   /* SS - 090423.1 - B */
   ASSIGN
      entity = i_entity
      entity1 = i_entity1
      ref = i_ref
      ref1 = i_ref1
      dt = i_dt
      dt1 = i_dt1
      effdt = i_effdt
      effdt1 = i_effdt1
      btch = i_btch
      type = i_type
      unb = i_unb
      .
   /* SS - 090423.1 - E */

   if ref1 = hi_char then ref1 = "".
   if dt =  low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.
   if entity1 = hi_char then entity1 = "".
   {&GLUTRRP-P-TAG17}
   unb = no.

   /* SS - 090423.1 - B
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
      with frame a.

   {wbrp06.i &command = update &fields = "   entity entity1 ref ref1 dt dt1
        effdt effdt1 btch type unb" &frm = "a"}
   SS - 090423.1 - E */

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

   /* SS - 090423.1 - B
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
   SS - 090423.1 - E */

   {&GLUTRRP-P-TAG24}
   for each glt_det  where glt_det.glt_domain = global_domain and (
      glt_ref >= ref and glt_ref <= ref1 and
      glt_date >= dt and glt_date <= dt1 and
      glt_effdate >= effdt and glt_effdate <= effdt1 and
      (glt_batch = btch or btch = "")
      ) no-lock use-index glt_ref
         break by glt_ref
 /*     with width 132 no-attr-space frame f-a no-box */
      :

      if first-of(glt_ref)
      then
         l_first_glt_ref = yes.

      {&GLUTRRP-P-TAG25}

      /* SET EXTERNAL LABELS
      setFrameLabels(frame f-a:handle).
*/
      /* THIS ENTITY CHECK CANNOT BE IN THE FOR EACH SINCE */
      /* IF IT IS, ORACLE WILL IGNORE THE USE-INDEX PHRASE */
      if glt_entity < entity or glt_entity > entity1 then next.

      if type <> "" and substring(glt_ref, 1, 2) <> type then next.
      if unb = yes and glt_unb = no then next.

      {&GLUTRRP-P-TAG26}
      if l_first_glt_ref
      then do:

         l_first_glt_ref = no.

         {&GLUTRRP-P-TAG27}

         {&GLUTRRP-P-TAG1}
         {&GLUTRRP-P-TAG28}
         /* SS - 090423.1 - B
         display
            glt_det.glt_ref
            {&GLUTRRP-P-TAG29}
            glt_det.glt_date column-label "Entered!Eff Date"
            glt_det.glt_userid.
         SS - 090423.1 - E */

         assign
            unb_msg = ""
            unbflag = no
            /* INDICATE THAT EFFDATE HAS NOT BEEN DISPLAYED */
            displayed_effdate = no.
         {&GLUTRRP-P-TAG2}
      end.

      else do:

         /* SS - 090423.1 - B
         {&GLUTRRP-P-TAG5}
         {&GLUTRRP-P-TAG30}
         display "" @ glt_det.glt_ref.
         {&GLUTRRP-P-TAG31}
         SS - 090423.1 - E */

         /* DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE, */
         /* ON 2ND LINE OF REF IF NO ERROR ON 1ST LINE OF REF. */
         if not displayed_effdate
         then do:
            /* SS - 090423.1 - B
            display
               glt_det.glt_effdate @ glt_det.glt_date.
            SS - 090423.1 - E */
            displayed_effdate = yes.
         end.
         /* SS - 090423.1 - B
         else
            display
               "" @ glt_det.glt_date.
         display
            "" @ glt_det.glt_userid.
         {&GLUTRRP-P-TAG6}
         SS - 090423.1 - E */
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
      /* SS - 090423.1 - B
      display
         glt_det.glt_line
         account
         glt_det.glt_project
         glt_det.glt_entity
         glt_det.glt_desc
         amt
         glt_det.glt_curr
         glt_det.glt_dy_code.
      {&GLUTRRP-P-TAG4}
      SS - 090423.1 - E */
      /* SECOND LINE NEEDED WHEN AN ERROR. */
      /* ALSO DISPLAY EFFECTIVE DATE STACKED UNDER ENTERED DATE. */
      if glt_det.glt_error <> "" then do:
         /* SS - 090423.1 - B
         down 1.
         SS - 090423.1 - E */
         if not displayed_effdate
         then do:
            /* SS - 090423.1 - B
            {&GLUTRRP-P-TAG8}
            display
               glt_det.glt_effdate @ glt_det.glt_date.
            {&GLUTRRP-P-TAG9}
            SS - 090423.1 - E */
            displayed_effdate = yes.
         end.

         /* SS - 090423.1 - B
         display glt_det.glt_error @ glt_det.glt_desc.
         SS - 090423.1 - E */
      end.

      /* SS - 090423.1 - B
      if daybooks-in-use and glt_det.glt_dy_code > "" and
         (glt_det.glt_dy_num = "" or glt_det.glt_dy_num = ?)
      then do:
         down 1.
         display  "* " + getTermLabel("NO_DAYBOOK_ENTRY",19) + "# *"
            @ glt_det.glt_desc.
      end.
      SS - 090423.1 - E */

      if glt_det.glt_unb = yes then unbflag = yes.

      /* SS - 090423.1 - B
      if last-of(glt_det.glt_ref) then do:

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

         if unbflag = yes then
            unb_msg = "*" + getTermLabel("UNBALANCED",3) + "*".
         underline amt.

         display
            accum total by glt_det.glt_ref glt_det.glt_amt @ amt
            base_curr @ glt_det.glt_curr
            unb_msg @ glt_det.glt_dy_code.
         down 1.
      end.
      SS - 090423.1 - E */

      /* SS - 090423.1 - B */
      CREATE ttxxglutrrp001.
      ASSIGN
         ttxxglutrrp001_glt_ref = glt_det.glt_ref
         ttxxglutrrp001_glt_date = glt_det.glt_date
         ttxxglutrrp001_glt_userid = glt_det.glt_userid

         ttxxglutrrp001_glt_effdate = glt_det.glt_effdate

         ttxxglutrrp001_glt_line = glt_det.glt_line
         ttxxglutrrp001_glt_acc = glt_det.glt_acc
         ttxxglutrrp001_glt_sub = glt_det.glt_sub
         ttxxglutrrp001_glt_cc = glt_det.glt_cc
         ttxxglutrrp001_glt_project = glt_det.glt_project
         ttxxglutrrp001_glt_entity = glt_det.glt_entity
         ttxxglutrrp001_glt_desc = glt_det.glt_desc
         ttxxglutrrp001_glt_amt = glt_det.glt_amt
         ttxxglutrrp001_glt_curr = glt_det.glt_curr
         ttxxglutrrp001_glt_dy_code = glt_det.glt_dy_code

         ttxxglutrrp001_glt_error = glt_det.glt_error

         ttxxglutrrp001_glt_dy_num = glt_det.glt_dy_num

         ttxxglutrrp001_glt_unb = glt_det.glt_unb
         .

      IF glt_det.glt_curr <> base_curr THEN DO:
         ASSIGN
            ttxxglutrrp001_glt_amt = glt_det.glt_curr_amt
            .
      END.
      /* SS - 090423.1 - E */

   end.

   /* SS - 090423.1 - B
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
   SS - 090423.1 - E */

{wbrp04.i &frame-spec = a}
