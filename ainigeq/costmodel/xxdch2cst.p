/* xxptsimin.p - cim_load part sim cost set                                  */

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}
{xxdcspub.i}
{xxicld01.i}
/* /* CONSIGNMENT INVENTORY VARIABLES */ */
{pocnvars.i}

DEFINE VARIABLE prid     LIKE xxdcs_period       NO-UNDO.
DEFINE VARIABLE datef    AS   date               NO-UNDO.
DEFINE VARIABLE datet    AS   date               NO-UNDO.
DEFINE VARIABLE csset    LIKE cs_set             NO-UNDO.
DEFINE VARIABLE newcs    AS   LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE fname    AS   CHARACTER          NO-UNDO.
DEFINE VARIABLE sctmtltl like sct_mtl_tl         NO-UNDO.
define variable xxdchdesc as  CHARACTER          NO-UNDO.
form
   prid  colon 20 label  "期间"
   datef colon 20 label "日期"
   datet colon 42 label "至" SKIP(1)
   csset COLON 20
   newcs      LABEL "新建成本集"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
ASSIGN fname = "xxptsim" + STRING(today,"99999999") + STRING(TIME) + ".cim".
/* ON LEAVE OF newcs IN FRAME a /* Fill 1 */ */
/* DO:                                       */
/*   ASSIGN csset newcs.                     */
/*                                           */
/*   ELSE DO:                                */
/*                                           */
/*   END.                                    */
/* END.                                      */
ON LEAVE OF prid IN FRAME a
DO:
  ASSIGN prid.
  RUN getPeriodDate(INPUT prid,OUTPUT datef,OUTPUT datet).
  DISPLAY datef datet WITH FRAME a.
END.
/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{wbrp01.i}
repeat:

/*    if period = hi_char then site1 = "". */

   if c-application-mode <> 'web' then
      UPDATE prid csset newcs with frame a.
      run getPeriodDate(input prid,output datef,output datet).
      display datef datet with fram a .
  IF newcs THEN DO:
     FIND FIRST cs_mstr NO-LOCK WHERE cs_set = csset NO-ERROR.
     IF AVAIL cs_mstr THEN DO:
         {pxmsg.i &MSGTEXT=""重复的成本集"" &ERRORLEVEL=3}
         undo,retry.
     END.
     ELSE DO:
         OUTPUT TO VALUE(fname).
            PUT UNFORMAT "@@BATCHLOAD csmsmt.p" SKIP.
            PUT UNFORMAT '"' csset '"' SKIP.
            PUT UNFORMAT '"' STRING(TODAY,"9999-99-99") + " "
                           + STRING(TIME,"hh:mm:ss") '"' SKIP.
            PUT UNFORMAT "SIM" SKIP.
            PUT UNFORMAT "@@end" SKIP.
         OUTPUT CLOSE.
     END.
  END.
  ELSE DO:
      FIND FIRST cs_mstr NO-LOCK WHERE cs_set = csset NO-ERROR.
      IF AVAIL cs_mstr AND cs_type <> "SIM" THEN DO:
         {pxmsg.i &MSGTEXT=""无可用的成本集"" &ERRORLEVEL=3}
         undo,retry.
      END.
      ELSE IF NOT AVAIL cs_mstr THEN DO:
         {pxmsg.i &MSGTEXT=""无可用的成本集"" &ERRORLEVEL=3}
         undo,retry.
      END.
  END.
  if not can-find(first xxdch_hst no-lock where xxdch_period = prid) then do:
    {pxmsg.i &MSGTEXT=""无可用的资料，请确定成本已计算"" &ERRORLEVEL=3}
    undo,retry.
  end.
    /*往系统新建成本集*/
  IF newcs THEN DO:
    batchrun  = yes.
    input from value(fname).
    output to value(fname + ".out") keep-messages.
    hide message no-pause.
    {gprun.i ""csmsmt.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.
  END.

  OUTPUT TO VALUE(fname).
  put unformat "no" skip.
  for each xxdch_hst no-lock where xxdch_period = prid,
      each code_mstr no-lock where code_fldname = "xxdcs_element"
       and code_value = xxdch_type break by xxdch_part by code_user1:
      find first pt_mstr no-lock where pt_part = xxdch_part no-error.
       /*       PUT UNFORMAT '"物料" ' .   /* material */  */
      if first-of(xxdch_part) then do:
        PUT UNFORMAT '"' pt_part '" "'  pt_site '"' SKIP.
        PUT UNFORMAT '"' csset '"' SKIP.
        for FIRST lngd_det no-lock where lngd_dataset = "sc_mstr"
              AND lngd_key4 = '1'
              and lngd_key1 = "" and lngd_key2 = "" and lngd_key3 = ""
              and lngd_field = "sc_category" and lngd_lang = global_user_lang:
              PUT UNFORMAT '"' trim(lngd_translation) '"'.
        end.
        find first sct_det no-lock where sct_sim = "Standard" and
                   sct_part = pt_part and sct_site = pt_site no-error.
        if avail sct_det then do:
           put unformat sct_mtl_tl skip.
        end.
        else do:
           put unformat 0 skip.
        end.
      end. /*  if first-of(xxdch_part) then do: */
      for FIRST lngd_det no-lock where lngd_dataset = "sc_mstr"
            AND lngd_key4 = code_user1
            and lngd_key1 = "" and lngd_key2 = "" and lngd_key3 = ""
            and lngd_field = "sc_category" and lngd_lang = global_user_lang:
            PUT UNFORMAT '"' trim(lngd_translation) '"'.
      end.
      PUT UNFORMAT xxdch_cost SKIP.
      PUT UNFORMAT "." SKIP.
  end.

  /*****
  FOR EACH xxptcs_det NO-LOCK WHERE xxptcs_period = prid:
  find first pt_mstr no-lock where pt_part = xxptcs_part no-error.
      PUT UNFORMAT '"' xxptcs_part '" "'  pt_site '"' SKIP.
      PUT UNFORMAT '"' csset '"' SKIP.
/*       PUT UNFORMAT '"物料" ' .   /* material */  */
      for FIRST lngd_det no-lock where lngd_dataset = "sc_mstr"
            AND lngd_key4 = '1'
            and lngd_key1 = "" and lngd_key2 = "" and lngd_key3 = ""
            and lngd_field = "sc_category" and lngd_lang = global_user_lang:
            PUT UNFORMAT '"' trim(lngd_translation) '"'.
      end.
      find first sct_det no-lock where sct_sim = "Standard" and
                 sct_part = pt_part and sct_site = pt_site no-error.
      if avail sct_det then do:
         put unformat sct_mtl_tl skip.
      end.
      else do:
         put unformat 0 skip.
      end.
/*       PUT UNFORMAT '"人工" ' .  /* labor */  */
      for FIRST lngd_det no-lock where lngd_dataset = "sc_mstr"
            AND lngd_key4 = '2'
            and lngd_key1 = "" and lngd_key2 = "" and lngd_key3 = ""
            and lngd_field = "sc_category" and lngd_lang = global_user_lang:
            PUT UNFORMAT '"' trim(lngd_translation) '"'.
      end.
      PUT UNFORMAT xxptcs_lbr_cst SKIP.
/*       PUT UNFORMAT '"附加" ' . /* Burden */  */
      for FIRST lngd_det no-lock where lngd_dataset = "sc_mstr"
            AND lngd_key4 = '3'
            and lngd_key1 = "" and lngd_key2 = "" and lngd_key3 = ""
            and lngd_field = "sc_category" and lngd_lang = global_user_lang:
          PUT UNFORMAT '"' trim(lngd_translation) '"'.
      end.
      PUT UNFORMAT xxptcs_bdn_cst SKIP.
/*       PUT UNFORMAT '"开销" ' . /* overhead */  */
      for FIRST lngd_det no-lock where lngd_dataset = "sc_mstr"
            AND lngd_key4 = '4'
            and lngd_key1 = "" and lngd_key2 = "" and lngd_key3 = ""
            and lngd_field = "sc_category" and lngd_lang = global_user_lang:
            PUT UNFORMAT '"' trim(lngd_translation) '"'.
      end.
      PUT UNFORMAT xxptcs_cyc_dif SKIP.
/*       PUT UNFORMAT '"转包" ' . /* subcontr */  */
      for FIRST lngd_det no-lock where lngd_dataset = "sc_mstr"
            AND lngd_key4 = '5'
            and lngd_key1 = "" and lngd_key2 = "" and lngd_key3 = ""
            and lngd_field = "sc_category" and lngd_lang = global_user_lang:
            PUT UNFORMAT '"' trim(lngd_translation) '"'.
      end.
      PUT UNFORMAT xxptcs_po_dif SKIP.
      PUT UNFORMAT "." SKIP.
  END.
  ********/
  PUT UNFORMAT "." skip.
  OUTPUT CLOSE.

  /*往系统输入数据*/
    batchrun  = yes.
    input from value(fname).
    output to value(fname + ".out") keep-messages.
    hide message no-pause.
    {gprun.i ""ppcsbtld.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.

   OS-DELETE value(fname).
   OS-DELETE value(fname + ".out").

   {wbrp06.i &command = update
             &fields = " prid datef datet csset newcs "
             &frm = "a"}

/*    if (c-application-mode <> 'web') or    */
/*       (c-application-mode = 'web' and     */
/*       (c-web-request begins 'data'))      */
/*    then do:                               */
/*       if period = "" then period = hi_char. */
/*    end.                                   */

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

FOR EACH xxdch_hst NO-LOCK WHERE xxdch_period = prid
    with frame b width 132 no-attr-space:
  find first pt_mstr no-lock where pt_part = xxdch_part no-error.
/***
  find first sct_det no-lock where sct_sim = "Standard" and
             sct_part = pt_part and sct_site = pt_site no-error.
  if avail sct_det then do:
     assign sctmtltl = sct_mtl_tl.
  end.
  else do:
     assign sctmtltl = 0.
  end.
**/
       {mfrpchk.i}
   find first code_mstr no-lock where code_fldname = "xxdcs_element"
          and code_value = xxdch_type no-error.
   if avail code_mstr then do:
      assign xxdchdesc = code_cmmt.
   end.
   else do:
      assign xxdchdesc = "".
   end.
   DISPLAY  xxdch_period xxdch_type xxdchdesc xxdch_part xxdch_qty_loc
            xxdch_qty_chg xxdch_cost_loc xxdch_cost_chg xxdch_cost
       WITH STREAM-IO 20 DOWN.
   setFrameLabels(frame b:handle).
end.
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
