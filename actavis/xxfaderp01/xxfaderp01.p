/* xxfaderp01.p DEPRECIATION EXPENSE REPORT                                   */
/*V8:ConvertMode=FullGUIReport                                                */
/******************************************************************************/
{xxfaderp01.i "new"}
{mfdtitle.i "111208.1"}


/* DEFINE LOCAL VARIABLES */
define variable l-loc like fa_faloc_id no-undo.
define variable l-loc1 like fa_faloc_id no-undo.
define variable l-asset      like fa_id       NO-UNDO.
define variable l-asset1     like fa_id       NO-UNDO.
define variable l-book       like fabk_id     no-undo.
define variable l-book1      like fabk_id     no-undo.
define variable l-book2      like fabk_id     no-undo.
define variable l-class      like fa_facls_id no-undo.
define variable l-class1     like fa_facls_id no-undo.
define variable l-entity     like fa_entity no-undo.
define variable l-entity1    like fa_entity no-undo.
define variable l-yrper      like fabd_yrper  no-undo.
define variable l-yrper1     like fabd_yrper  no-undo.
define variable l-yrper2     like fabd_yrper  no-undo.
define variable l-authNbr    like fa_auth_number no-undo.
define variable l-authNbr1   like fa_auth_number no-undo.
define variable l-startdt    like fa_startdt no-undo initial ?.
define variable l-startdt1   like fa_startdt no-undo.
define variable l-saveas     like fa__chr01  no-undo.
define variable l-saveas1    like fa__chr01  no-undo.
define variable o_perdep     like fabd_peramt no-undo.
define variable expAmt     like fabd_peramt no-undo.
define variable yrPeriod like fabd_yrper
   label "As Of Date" no-undo.
define variable nonDepr like mfc_logical label
   "Include Non-Depreciating Assets" no-undo.
define variable fullDepr like mfc_logical label
   "Include Fully Depreciated Assets" no-undo.
define variable inclRet like mfc_logical label
   "Include Retired Assets" no-undo.
define variable entity_ok like mfc_logical.
define variable l_error   as   integer   no-undo.
define variable printTot like mfc_logical label "Print Totals Only" no-undo.
define variable l-ndep   like mfc_logical label "Include Non-Depr Assets"
                                              no-undo.
/* define variable entity_ok    like mfc_logical.*/
define variable l_printtrans like mfc_logical label "Print Transfer Details"
                                              no-undo.

define variable v_puramt  like fa_puramt no-undo.
define variable v_salvamt like fa_salvamt no-undo.
define variable v_mthDept like fa_salvamt no-undo.
define variable v_accDepr like fabd_accamt no-undo.
define variable v_netBook like fabd_peramt no-undo.
define variable comment   like fa_desc1 no-undo.
define variable dispRsn   like fa_disp_rsn no-undo.
define variable resType   as character format "x(10)" no-undo.
define variable translbl  as character no-undo.

/* DEFINE DEPRECIATION EXPENSE FORM */
form
   l-loc      colon 25
   l-loc1     colon 42 label {t001.i}
   l-asset    colon 25
   l-asset1   colon 42 label {t001.i}
   l-book     colon 25
   l-book1    colon 42 label {t001.i}
   l-class    colon 25
   l-class1   colon 42 label {t001.i}
   l-entity   colon 25
   l-entity1  colon 42 label {t001.i}
   l-yrper    colon 25
   l-yrper1   colon 42 label {t001.i}
   l-authNbr  colon 25
   l-authNbr1 colon 42 label {t001.i}
   l-startdt  colon 25
   l-startdt1 colon 42 label {t001.i}
   l-saveas   colon 25
   l-saveas1  colon 42 label {t001.i} skip(1)
   printTot   colon 54
   l-book2    colon 22 
	 nonDepr    colon 54
   l-yrper2   colon 22
   fullDepr   colon 54
   inclRet    colon 54
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* BEGIN MAINLOOP FOR DEPRECIATION EXPENSE REPORT */
mainloop:
repeat:

   /* ALLOW ENTITY, BOOK, CLASS, ASSET TO BE UPDATED. */
   if l-loc1    = hi_char then l-loc1 = "".
   if l-asset1  = hi_char then l-asset1  = "".
   if l-book1   = hi_char then l-book1   = "".
   if l-class1  = hi_char then l-class1  = "".
   if l-entity1 = hi_char then l-entity1 = "".
   if l-yrper1  = hi_char then l-yrper1  = "".
   if l-authNbr1  = hi_char then l-authNbr1  = "".
   if l-startdt  = low_date then l-startdt  = ?.
   if l-startdt1  = hi_date then l-startdt1  = ?.
   if l-saveas1  = hi_char then l-saveas1  = "".
/*
   {gprunp.i "xxfapl01" "p" "fa-get-per"
      "(input  today,
        input  """",
        output yrPeriod,
        output l_error)"}

   if l_error <> 0
   then
   */
      /* ASSIGN yrPeriod TO TODAY'S DATE */
      yrPeriod = string(year(today), "9999") + string(month(today), "99").
			l-yrper2 = string(year(today), "9999") + string(month(today), "99").
   if c-application-mode <> "WEB"
   then
      update
         l-loc
         l-loc1
         l-asset
         l-asset1
         l-book
         l-book1
         l-class
         l-class1
         l-entity
         l-entity1
         l-yrper
         l-yrper1
         l-authNbr
         l-authNbr1
         l-startdt
         l-startdt1
         l-saveas
         l-saveas1
         l-book2
         l-yrper2
         printTot
         nonDepr
         fullDepr
         inclRet

      with frame a.

   if l-yrper      = ""
      and l-yrper1 = ""
   then do:

      /* NO YR/PER VALUES ENTERED, REPORT */
      /* WILL RUN FOR ENTIRE ASSET LIFE   */
      {pxmsg.i &MSGNUM=4942 &ERRORLEVEL=2}

   end. /* IF l-yrper = "" */
   if l-book2 = "" then do:
   	  {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""l-book2""}
   	  next-prompt l-book2 with frame a.
   	  undo,retry.
   end.
   if l-yrper2 = "" then do:
   	  {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""l-yrper2""}
   	  next-prompt l-yrper2 with frame a.
   	  undo,retry.
   end.
   
   /* CHANGED yrPeriod TO l-yrper               */
   /* ADDED l-yrper1 TO &fields                 */
   /* ADDED l-ndep TO &fields AS THE LAST FIELD */
   {wbrp06.i
      &command = update
      &fields  = "l-loc l-loc1 l-asset  l-asset1  l-book  l-book1
                  l-class l-class1 l-entity l-entity1 l-yrper l-yrper1
                  l-authNbr l-authNbr1 l-startdt l-startdt1 l-saveas l-saveas1
                  l-book2 l-yrper2 printTot nonDepr fullDepr inclRet "}

   if (c-application-mode <> "WEB")
      or (c-application-mode = "WEB"
         and (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i l-loc}
      {mfquoter.i l-loc1}
      {mfquoter.i l-asset}
      {mfquoter.i l-asset1}
      {mfquoter.i l-book}
      {mfquoter.i l-book1}
      {mfquoter.i l-book2}
      {mfquoter.i l-class}
      {mfquoter.i l-class1}
      {mfquoter.i l-entity}
      {mfquoter.i l-entity1}
      {mfquoter.i l-yrper}
      {mfquoter.i l-yrper1}
      {mfquoter.i l-yrper2}
      {mfquoter.i l-authNbr}
      {mfquoter.i l-authNbr1}
      {mfquoter.i l-startdt}
      {mfquoter.i l-startdt1}
      {mfquoter.i l-saveas}
      {mfquoter.i l-saveas1}
      {mfquoter.i printTot}
      {mfquoter.i nonDepr}
      {mfquoter.i fullDepr}
      {mfquoter.i inclRet}

      /* SET THE UPPER LIMITS TO MAX VALUES IF BLANK. */
      if l-loc1 = ""          then l-loc1 = hi_char.
      if l-loc1 < l-loc       then l-loc1 = l-loc.
      if l-asset1  = ""       then l-asset1  = hi_char.
      if l-asset1  < l-asset  then l-asset1  = l-asset.
      if l-book1   = ""       then l-book1   = hi_char.
      if l-book1   < l-book   then l-book1   = l-book.
      if l-class1  = ""       then l-class1  = hi_char.
      if l-class1  < l-class  then l-class1  = l-class.
      if l-entity1 = ""       then l-entity1 = hi_char.
      if l-entity1 < l-entity then l-entity1 = l-entity.
      if l-yrper1  = ""       then l-yrper1  = hi_char.
      if l-yrper1  < l-yrper  then l-yrper1  = l-yrper.
      if l-authNbr1 = ""      then l-authNbr1 = hi_char.
      if l-authNbr1 < l-authNbr then l-authNbr1 = l-authNbr.
      if l-startdt = ?         then l-startdt = low_date.
      if l-startdt1 = ?        then l-startdt1 = hi_date.
      if l-startdt1 < l-startdt then l-startdt1 = l-startdt.
      if l-saveas1 = ""        then l-saveas1 = hi_char.
      if l-saveas1 < l-saveas then l-saveas1 = l-saveas.
   end. /* c-application-mode ... */

   /* ADDS PRINTER FOR OUTPUT WITH BATCH OPTION */
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType                = "printer"
               &printWidth               = 300
               &pagedFlag                = "nopage"
               &stream                   = " "
               &appendToFile             = " "
               &streamedOutputToTerminal = " "
               &withBatchOption          = "yes"
               &displayStatementType     = 1
               &withCancelMessage        = "yes"
               &pageBottomMargin         = 6
               &withEmail                = "yes"
               &withWinprint             = "yes"
               &defineVariables          = "yes"}


/* PRINTS PAGE HEADING FOR REPORT */
{mfphead.i}
   /* CHANGED NINTH INPUT PARAMETER yrPeriod TO l-yrper */
   /* ADDED TENTH INPUT PARAMETER l-yrper1              */
   /* ADDED l-ndep AS THE LAST INPUT PARAMETER          */
   /* CALLS THE DEPRECIATION EXPENSE REPORT PROGRAM     */

     {gprun.i ""xxfaderp01a1.p"" "(input l-loc,
        input l-loc1,
        input l-asset,
        input l-asset1,
        input l-book,
        input l-book1,
        input l-class,
        input l-class1,
        input l-entity,
        input l-entity1,
        input l-yrper,
        input l-yrper1,
        input l-authNbr,
        input l-authNbr1,
        input l-startdt,
        input l-startdt1,
        input l-saveas,
        input l-saveas1,
        input yrPeriod,
        input printTot,
        input nonDepr,
        input fullDepr,
        input inclRet)"}

/*   {gprun.i ""xxfaderp01a2.p""                            */
/*      "(input l-entity,                                   */
/*        input l-entity1,                                  */
/*        input l-book,                                     */
/*        input l-book1,                                    */
/*        input l-class,                                    */
/*        input l-class1,                                   */
/*        input l-asset,                                    */
/*        input l-asset1,                                   */
/*        input l-yrper,                                    */
/*        input l-yrper1,                                   */
/*        input printTot,                                   */
/*        input l-ndep,                                     */
/*        input l_printtrans)"}                             */

for each tmp_xfa exclusive-lock:
	 assign o_perdep = 0.
   for each fabd_det
      fields( fabd_domain fabd_fa_id  fabd_fabk_id
              fabd_yrper  fabd_peramt fabd_suspend)
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id = tx_faid
        and fabd_fabk_id =  l-book2
        and fabd_yrper  = l-yrper2
      no-lock:
      o_perdep = o_perdep + fabd_peramt.

      /* FOR THE BELOW MENTIONED REPORTS THE SUSPENDED PERIODS */
      /* WILL BE EXCLUDED WHEN CALCULATING PERIOD DEPRECIATION */
      if fabd_suspend
      then
         o_perdep = o_perdep - fabd_peramt.

   end. /* FOR EACH fabd_det */
   assign tx_mthDept = o_perdep.
end.

FOR EACH tmp_xfa EXCLUSIVE-LOCK:
    resType = "".
    find last faadj_mstr no-lock where  faadj_domain = global_domain and
              faadj_fa_id = tx_faid no-error.
    if available faadj_mstr then do:
          {gplngn2a.i &file       = ""faadj_mstr""
                      &field      = ""faadj_type""
                      &code       = faadj_type
                      &mnemonic   = resType
                      &label      = translbl}
    end.
    ASSIGN tx_restype = restype.
END.

for each tmp_xfa exclusive-lock:
    if tx_life <> 0 and tx_puramt <> 0 AND
       tx_restype <> "Suspend" AND
       tx_netBook <> tx_salvamt then do:
        assign tx_mthDeptRt=(tx_puramt - tx_salvamt) / tx_life / 12 / tx_puramt.
    end.
    if trim(tx_faid) = ""  or trim(tx_fa_loc) = "" then do:
       delete tmp_xfa.
    end.
end.

   assign v_puramt  = 0
          v_salvamt = 0
          v_mthDept = 0
          v_accDepr = 0
          v_netBook = 0.

for each tmp_xfa no-lock where tx_faid <> "" and tx_fa_loc <> ""
     with frame x width 300 break by tx_group:
    setFrameLabels(frame x:handle).
    assign v_puramt  = v_puramt  + tx_puramt
           v_salvamt = v_salvamt + tx_salvamt
           v_mthDept = v_mthDept + tx_mthDept
           v_accDepr = v_accDepr + tx_accDepr
           v_netBook = v_netBook + tx_netBook.
    assign comment = ""
           dispRsn = ""
           restype = ""
           translbl = "".
    find first fa_mstr no-lock where fa_domain = global_domain and
               fa_id = tx_faid no-error.
		        if available fa_mstr then do:
		         assign comment = trim(fa_desc1)
		                dispRsn = fa_disp_rsn.
		        end.

    display tx_faid
            comment
            tx_auth_nbr
            tx_saveas format "x(24)"
            tx_fa_loc
            tx_cstcent
            tx_resType
            dispRsn
            tx_puramt
            tx_life
            tx_startdt
            tx_mthDeptRt * 100 format "->>,>>9.99%" @ tx_mthDeptRt
            tx_salvamt
            tx_mthDept
            tx_accDepr
            tx_netBook.
    {mfrpchk.i}
    if last-of(tx_group) then do:
        down 2.
        display getTermLabel("SUMMARIES",8) @ tx_saveas
                                  v_puramt  @ tx_puramt
                                  v_salvamt @ tx_salvamt
                                  v_mthDept @ tx_mthDept
                                  v_accDepr @ tx_accDepr
                                  v_netBook @ tx_netBook
                                  .
    end.
end.

   /* ADDS REPORT TRAILER */
   {mfrtrail.i}
end. /*MAIN-LOOP*/
