/* xxrepkup0.p - REPETITIVE PICKLIST CALCULATION                             */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/


{mfdtitle.i "111207.1"}

define new shared variable site           like si_site.
define new shared variable site1          like si_site.
define new shared variable wkctr          like op_wkctr.
define new shared variable wkctr1         like op_wkctr.
define new shared variable part           like ps_par.
define new shared variable part1          like ps_par.
define new shared variable comp1          like ps_comp.
define new shared variable comp2          like ps_comp.
define new shared variable desc1          like pt_desc1.
define new shared variable desc2          like pt_desc1.
define new shared variable issue          like wo_rel_date
                                          label "Production Date".
define new shared variable issue1         like wo_rel_date.
define new shared variable reldate        like wo_rel_date
                                          label "Release Date" initial today.
define new shared variable reldate1       like wo_rel_date.
define new shared variable nbr            as character format "x(10)"
                                          label "Picklist Number".
define new shared variable delete_pklst   like mfc_logical initial no
                                          label "Delete When Done".
define new shared variable nbr_replace    as character format "x(10)".
define new shared variable qtyneed        like wod_qty_chg
                                          label "Qty Required".
define new shared variable netgr          like mfc_logical initial yes
                                          label "Use Work Center Inventory".
define new shared variable detail_display like mfc_logical
                  label "Detail Requirements" initial yes.
define new shared variable um             like pt_um.
define new shared variable wc_qoh         like ld_qty_oh.
define new shared variable temp_qty       like wod_qty_chg.
define new shared variable temp_nbr       like lad_nbr.
define new shared variable ord_max        like pt_ord_max.
define new shared variable comp_max       like wod_qty_chg.
define new shared variable pick-used      like mfc_logical.
define new shared variable isspol         like pt_iss_pol.
define new shared variable nbrstart       as   character format "x(10)".
define variable l_use_ord_multiple        like mfc_logical
                                          label "Use Order Multiple" no-undo.

nbr_replace = getTermLabel("TEMPORARY",10).

form
   site               colon 22
   site1              label {t001.i} colon 49 skip
   part               colon 22
   part1              label {t001.i} colon 49 skip
   comp1              colon 22
   comp2              label {t001.i} colon 49 skip
   wkctr              colon 22
   wkctr1             label {t001.i} colon 49 skip
/*   issue              colon 22                            */
/*   issue1             label {t001.i} colon 49             */
   reldate            colon 22
/*   reldate1           label {t001.i} colon 49 skip(1)     */
   netgr              colon 30
   l_use_ord_multiple colon 30
   detail_display     colon 30
   nbr                colon 30
   delete_pklst       colon 30
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

if not can-find(first rpc_ctrl) then do transaction:
   create rpc_ctrl.
   release rpc_ctrl.
end.

assign
   site  = global_site
   site1 = global_site.

/*  find first qad_wkfl exclusive-lock where qad_key1 = "xxrepkup0.p"      */
/*         and qad_key2 = "xxrepkup1.p" no-error.                          */
/*  if available qad_wkfl then do:                                         */
/*       assign qad_key3 = nbr.                                            */
/*  end.                                                                   */
/*  else do:                                                               */
/*       create qad_wkfl.                                                  */
/*       assign qad_key1 = "xxrepkup0.p"                                   */
/*              qad_key2 = "xxrepkup1.p"                                   */
/*              qad_key3 = nbr.                                            */
/*  end.                                                                   */
      assign nbrstart = nbr.
repeat:

   find first rpc_ctrl no-lock no-error.

   assign
      l_use_ord_multiple = yes
      nbr                = rpc_nbr_pre + string(rpc_nbr).

   if site1    = hi_char  then site1    = "".
   if part1    = hi_char  then part1    = "".
   if comp2    = hi_char  then comp2    = "".
   if issue    = low_date then issue    = ?.
   if wkctr1   = hi_char  then wkctr1   = "".
   if issue1   = hi_date  then issue1   = ?.
   if reldate  = low_date then reldate  = ?.
   if reldate1 = hi_date  then reldate1 = ?.

   display nbr with frame a.

   update
      site
      site1
      part
      part1
      comp1
      comp2
      wkctr
      wkctr1
/*      issue           */
/*      issue1          */
      reldate
/*      reldate1        */
      netgr
      l_use_ord_multiple
      detail_display
      nbr
      delete_pklst
   with frame a.
   assign issue = reldate
          issue1 = reldate
          reldate1 = reldate.
   if delete_pklst then nbr = mfguser.

   bcdparm = "".

   {gprun.i ""gpquote.p"" "(input-output bcdparm,
                            17,
                            site,
                            site1,
                            part,
                            part1,
                            comp1,
                            comp2,
                            wkctr,
                            wkctr1,
                            string(issue),
                            string(issue1),
                            string(reldate),
                            string(reldate1),
                            string(netgr),
                            string(l_use_ord_multiple),
                            string(detail_display),
                            nbr,
                            string(delete_pklst),
                            null_char,
                            null_char,
                            null_char)"}

   if site1    = "" then site1    = hi_char.
   if part1    = "" then part1    = hi_char.
   if comp2    = "" then comp2    = hi_char.
   if wkctr1   = "" then wkctr1   = hi_char.
   if issue    = ?  then issue    = low_date.
   if issue1   = ?  then issue1   = hi_date.
   if reldate  = ?  then reldate  = low_date.
   if reldate1 = ?  then reldate1 = hi_date.

   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site, input site1, output return_int)"}
      if return_int = 0 then do:
         next-prompt site with frame a.
         undo , retry.
      end.
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

   /* REPKUPA.P ATTEMPS TO APPLY PHANTOM USE-UP LOGIC WHICH DOES NOT    */
   /* APPLY TO THE REPETITVE MODULE.  THEREFORE, DO NOT CALL REPKUPA.P  */
   for each xxwp_mst exclusive-lock where xxwp_date = reldate:
     delete xxwp_mst.
   end.
   {gprun.i ""xxrepkupd0.p"" "(input l_use_ord_multiple)"}
   /* ADDED SECTION TO DELETE 'FLAG' lad_det, AS WELL AS PICKLISTS
      THAT WERE CREATED THIS SESSION BUT SHOULD BE DELETED         */
   {gprun.i ""repkupc.p""}
   {gprun.i ""xxrepkupu0.p""}
/* FOR EACH xxwp_mst use-index xxwp_par_part NO-LOCK WHERE : */
/*     display  xxwp_date                                    */
/*                 xxwp_site                                 */
/*                 xxwp_line                                 */
/*                 xxwp_nbr                                  */
/*                 xxwp_part                                 */
/*                 xxwp_par                                  */
/*                 xxwp_qty_req                              */
/*                 xxwp_um                                   */
/*                 xxwp_qty_oh                               */
/*                 xxwp_qty_all                              */
/*                 xxwp_op                                   */
/*                 xxwp_mch                                  */
/*                 xxwp_start                                */
/*             WITH WIDTH 200 STREAM-IO.                     */
/* END.                                                      */
/* for each xxlw_mst no-lock:                                */
/* display xxlw_mst with width 320.                          */
/* end.                                                      */


   for each xxwa_det no-lock where
            xxwa_date = issue and
            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
            xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
        with frame x width 320
        break by xxwa_date by xxwa_site by xxwa_line by xxwa_sn 
       by xxwa_part by xxwa_rtime:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwa_part no-error.
       display xxwa_nbr xxwa_recid xxwa_date xxwa_site xxwa_line xxwa_part
               string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime 
               xxwa_qty_pln
               pt_mstr.pt_ord_min pt_mstr.pt__chr10
           /*    xxwa_qty_piss xxwa_qty_siss                        */
                 string(xxwa_pstime,"hh:mm:ss") @ xxwa_pstime
                 string(xxwa_petime,"hh:mm:ss") @ xxwa_petime
           /*    xxwa_pouser xxwa_podate                            */
           /*    string(xxwa_potime,"hh:mm:ss") @ xxwa_potime       */
               string(xxwa_sstime,"hh:mm:ss") @ xxwa_sstime
               string(xxwa_setime,"hh:mm:ss") @ xxwa_setime
           /*  xxwa_souser xxwa_sodate                              */
           /*  string(xxwa_sotime,"hh:mm:ss") @  xxwa_sotime        */
               with frame x down.

       setFrameLabels(frame x:handle).
  end.
   /* REPORT TRAILER  */
    {mfrtrail.i}
/* {mfreset.i} */
   if temp_nbr = rpc_nbr_pre + string(rpc_nbr)
      and pick-used
      and not delete_pklst
   then do transaction:

      {gprun.i ""gpnbr.p"" "(16,input-output nbr)"}
      find first rpc_ctrl exclusive-lock.
      rpc_nbr = integer(substring(nbr,length(rpc_nbr_pre) + 1)).
      release rpc_ctrl.
   end.

end.  /* REPEAT */
