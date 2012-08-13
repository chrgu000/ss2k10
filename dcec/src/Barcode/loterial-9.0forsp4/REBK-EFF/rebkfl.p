/* GUI CONVERTED from rebkfl.p (converter v1.75) Tue May  8 22:46:07 2001 */
/* rebkfl.p   - REPETITIVE   BACKFLUSH TRANSACTION                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 7.3               LAST MODIFIED: 10/31/94   BY: WUG *GN77*      */
/* REVISION: 7.3               LAST MODIFIED: 11/03/94   BY: WUG *GN98*      */
/* REVISION: 7.3               LAST MODIFIED: 12/16/94   BY: WUG *G09J*      */
/* REVISION: 7.3               LAST MODIFIED: 03/01/95   BY: WUG *G0G6*      */
/* REVISION: 8.5               LAST MODIFIED: 05/12/95   BY: pma *J04T*      */
/* REVISION: 7.3               LAST MODIFIED: 11/01/95   BY: ais *G0V9*      */
/* REVISION: 8.5               LAST MODIFIED: 11/14/95   BY: ktn *J095*      */
/* REVISION: 7.3               LAST MODIFIED: 01/23/96   BY: jym *G1G0*      */
/* REVISION: 8.5               LAST MODIFIED: 02/14/96   BY: jym *G1M9*      */
/* REVISION: 8.5               LAST MODIFIED: 01/18/96   BY: bholmes *J0FY*  */
/* REVISION: 8.5               LAST MODIFIED: 04/03/96   BY: jym *G1PZ*      */
/* REVISION: 8.5               LAST MODIFIED; 05/07/96   BY: jym *G1V4*      */
/* REVISION: 8.5               LAST MODIFIED: 05/16/96   BY: jym *G1VW*      */
/* REVISION: 8.6               LAST MODIFIED: 06/11/96   BY: ejh *K001*      */
/* REVISION: 8.5               LAST MODIFIED: 07/19/96   BY: gwm *J0ZB*      */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96 BY: *G1Z7* Julie Milligan      */
/* REVISION: 8.5      LAST MODIFIED: 08/12/96 BY: *J141* Fred Yeadon         */
/* REVISION: 8.6      LAST MODIFIED: 12/31/96 BY: *H0Q8* Julie Milligan      */
/* REVISION: 8.6      LAST MODIFIED: 12/31/96 BY: *J1DK* Julie Milligan      */
/* REVISION: 8.6      LAST MODIFIED: 08/01/97   BY: *G2P0*  Manmohan Pardesi */
/* REVISION: 8.6      LAST MODIFIED: 08/13/97   BY: *G2LF*  Murli Shastri    */
/* REVISION: 8.6      LAST MODIFIED: 09/16/97   BY: *H1F7*  Felcy D'Souza    */
/* REVISION: 8.6      LAST MODIFIED: 10/28/97   BY: *G2Q3*  Steve Nugent     */
/* REVISION: 8.6      LAST MODIFIED: 04/29/98   BY: *H1L0*  Dana Tunstall    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *H1J5* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 10/13/98   BY: *J323* G.Latha           */
/* REVISION: 8.6E     LAST MODIFIED: 11/23/98   BY: *J356*  Thomas Fernandes */
/* REVISION: 9.0      LAST MODIFIED: 12/17/98   BY: *J36Y*  G.Latha          */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 12/01/00   BY: *L0P5* Sathish Kumar     */
/* REVISION: 9.0      LAST MODIFIED: 04/09/01   BY: *M14Y* Vandna Rohira     */


         {mfdtitle.i "0+ "}

/*K001*/ {gldydef.i new}
/*K001*/ {gldynrm.i new}

         define buffer next_wr_route for wr_route.
         define buffer ptmstr for pt_mstr.
         define variable comp as character.
         define variable conv_qty_proc as decimal.
         define variable conv_qty_move as decimal.
         define variable conv_qty_rjct as decimal.
         define variable conv_qty_scrap as decimal.
         define variable cumwo_lot as character.
         define variable date_change as integer.
         define variable elapse as decimal format ">>>>>>>>.999".
         define variable ophist_recid as recid.
         define variable rejected like mfc_logical.
         define variable schedwo_lot as character.
         define variable trans_type as character initial "BACKFLSH".
         define variable undo_stat like mfc_logical no-undo.
         define variable yn like mfc_logical.
         define variable i as integer.
         define variable j as integer.
         define variable oplist as character.
         define variable lotserials_req as log.
         define variable bomcode as character.
         define variable routecode as character.
         define variable following_op_req_qty as decimal.
         define variable backflush_qty as decimal.
         define variable std_run_hrs as decimal.
         define variable msg_ct as integer.
         define variable input_que_op_to_ck as integer.
         define variable input_que_qty_chg as decimal.
         {rewrsdef.i}
         {retrform.i new}
         define new shared variable rsn_codes as character extent 10.
         define new shared variable quantities like wr_qty_comp extent 10.
         define new shared variable scrap_rsn_codes as character extent 10.
         define new shared variable scrap_quantities like wr_qty_comp extent 10.
         define new shared variable reject_rsn_codes as character extent 10.
         define new shared variable reject_quantities
            like wr_qty_comp extent 10.
/*G09J*/ define variable dont_zero_unissuable as logical initial no.
/*G0G6*/ define new shared variable wo_recno as recid.
/*G0G6*/ define new shared variable wr_recno as recid.
/*J095*/ define new shared variable lotserial like sr_lotser no-undo.
/*H0Q8*/ define            variable inv-issued as logical no-undo.
/*H0Q8* /*G0V9*/ define new shared variable inv-issued as logical no-undo. */
/*H1J5*/ define variable mfc-recid as recid     no-undo.

/*M14Y*/ define variable l_lot     like wo_lot  no-undo.

/*K001*/ if daybooks-in-use then
/*K001*/    {gprun.i ""nrm.p"" "persistent set h-nrm"}
/*GUI*/ if global-beam-me-up then undo, leave.


        /* DO NOT RUN PROGRAM UNLESS QAD_WKFL RECORDS HAVE */
        /* BEEN CONVERTED SO THAT QAD_KEY2 HAS NEW FORMAT  */
/*G1PZ*/ if can-find(first qad_wkfl where qad_key1 = "rpm_mstr") then do:
/*G1PZ*/   {mfmsg.i 5126 3}
/*G1PZ*/   message.
/*G1PZ*/   message.
/*G1PZ*/   leave.
/*G1PZ*/ end.

/*J04T*/ /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
/*J04T*/ {gpatrdef.i "new shared"}

/*J141  THE FOLLOWING VARIABLES ARE NO LONGER NEEDED BY THE W/H INTERFACE
 * /*J0FY*/ define new shared variable w-site like sod_site.
 * /*J0FY*/ define new shared variable w-loc  like sod_loc.
 * /*J0FY*/ define variable w-file-type as character format "x(25)".
 * /*J0FY*/ define variable w-te_nbr as integer.
 * /*J0FY*/ define variable w-te_type as character.
 * /*J0FY*/ define variable w-datastr as character format "x(255)".
 * /*J0FY*/ define variable w-len as integer.
 * /*J0FY*/ define variable w-counter as integer.
 * /*J0FY*/ define variable w-tstring as character format "x(50)".
 * /*J0FY*/ define variable w-group as character format "x(18)".
 * /*J0FY*/ define variable w-str-len as integer.
 * /*J0FY*/ define variable w-update as character format "x".
 * /*J0FY*/ define variable w_whl_src_dest_id like whl_mstr.whl_src_dest_id.
 * /*J0FY*/ define variable w-sent as integer initial 0.
 * /*J0FY*/ define variable w_wkctr like op_wkctr.
 * /*J0FY*/ define variable w_op_qty_cum like op_qty_com.
 *J141*/

         eff_date = today.
         find first gl_ctrl no-lock.
/*J1DK*  /*J095*/ find first clc_ctrl no-lock. */
/*J1DK*/ /* BEGIN ADD SECTION */
         find first clc_ctrl no-lock no-error.
         if not available clc_ctrl then do:
           {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

           find first clc_ctrl no-lock.
         end.
/*J1DK*/ /* END ADD SECTION */

         {gprun.i ""redflt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         main:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            /*GET EMP, EFFDATE, SHIFT, SITE, CONTROLTOTAL FROM USER*/
            {gprun.i ""retrin1.p"" "(output undo_stat)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if undo_stat then undo, leave.

/*G1M9*/    mainloop:
            repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J36Y*/       /* TO RESET LOT/SERIAL AFTER COMPLETING THE TRANSACTION */
/*J36Y*/       /* WHEN AUTO LOT NUMBERS IS SET TO NO IN ITEM MASTER    */
/*J36Y*/       /* MAINTENANCE                                          */
/*J36Y*/       lotserial = "".
               /*GET ITEM, OP, LINE FROM USER*/

               {gprun.i ""retrin2.p"" "(output undo_stat)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if undo_stat then undo, leave.

               /*FIND DEFAULT BOM AND ROUTING CODES*/
               {gprun.i ""reoptr1b.p""
               "(input site, input line, input part, input op, input eff_date,
               output routing, output bom_code, output schedwo_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1Z7*/       if schedwo_lot = "?" then do:
/*G1Z7*/            /* Unexploded schedule with consumption period */
/*G1Z7*/            {mfmsg.i 325 3}
/*G1Z7*/            next-prompt part.
/*G1Z7*/            undo, retry.
/*G1Z7*/       end.

               /*GET BOM, ROUTING FROM USER*/
               {gprun.i ""retrin3.p"" "(output undo_stat)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if undo_stat then undo, leave.

               /*FIND CUM ORDER. */
               {gprun.i ""regetwo.p"" "(input site, input part, input eff_date,
               input line, input routing, input bom_code, output cumwo_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /*VALIDATE THE OPERATION */
/*G1M9*/       {reopval.i &part = part
                          &routing = routing
                          &op = op
                          &date = eff_date
                          &prompt = op
                          &frame = "a"
                          &leave = ""no""
                          &loop = "mainloop"
               }

               /* CREATE IT IF IT DOESN'T EXIST*/
               if cumwo_lot = ? then do:
                  {gprun.i ""recrtwo.p"" "(input site, input part,
                                           input eff_date, input line,
                                           input routing, input bom_code,
                                           output cumwo_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1VW*/          if cumwo_lot = ? then next mainloop.
                  display cumwo_lot @ wo_lot with frame a.
               end.
               else do:
                  display cumwo_lot @ wo_lot with frame a.
                  find wo_mstr where wo_lot = cumwo_lot no-lock.

                  if wo_stat = "c" then do:
                     {mfmsg.i 5101 3}
                     undo, retry.
                  end.
               end.


               find wr_route where wr_lot = cumwo_lot
               and wr_op = op no-lock no-error.
               if not available wr_route then do:
                  {mfmsg.i 106 3}
                  next-prompt op with frame a.
                  undo, retry.
               end.

               if not wr_milestone then do:
                 {mfmsg.i 560 2}
               end.


               display wr_desc with frame a.


               assign
               wkctr = ""
               mch = ""
               dept = ""
               qty_proc = 0
               um = ""
               conv = 1
               qty_rjct = 0
               rjct_rsn_code = ""
               rejque_multi_entry = no
               to_op = op
               qty_scrap = 0
               scrap_rsn_code = ""
               outque_multi_entry = no
               mod_issrc = no
               start_run = ""
               act_run_hrs = 0
               stop_run = ""
               earn_code = ""
               rsn_codes = ""
               quantities = 0
               scrap_rsn_codes = ""
               scrap_quantities = 0
               reject_rsn_codes = ""
               reject_quantities = 0
               .

               {gprun.i ""resetmno.p""
               "(input cumwo_lot, input op, output move_next_op)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               wkctr = wr_wkctr.
               mch = wr_mch.
               find wc_mstr where wc_wkctr = wkctr and wc_mch = mch no-lock.

               dept = wc_dept.
               find dpt_mstr where dpt_dept = wc_dept no-lock no-error.

               find wo_mstr where wo_lot = cumwo_lot no-lock.
               find pt_mstr where pt_part = wo_part no-lock.
               um = pt_um.


               find first ea_mstr where ea_type = "1" no-lock no-error.
               if available ea_mstr then earn_code = ea_earn.



               display
               wkctr
               mch
               wc_desc
               dept
/*J095*        dpt_desc          when available dpt_mstr                  */
/*J095*        ""                when not available dpt_mstr @ dpt_desc   */
/*J095*/       dpt_desc          when (available dpt_mstr)
/*J095*/       ""                when (not available dpt_mstr) @ dpt_desc
               qty_proc
               um
               conv
               qty_rjct
               rjct_rsn_code
               rejque_multi_entry
               to_op
               qty_scrap
               scrap_rsn_code
               outque_multi_entry
               mod_issrc
               move_next_op
               start_run
               act_run_hrs
               stop_run
               earn_code
/*J095*        ea_desc when available ea_mstr                             */
/*J095*        "" when not available ea_mstr @ ea_desc                    */
/*J095*/       ea_desc when (available ea_mstr)
/*J095*/       "" when (not available ea_mstr) @ ea_desc
               with frame bkfl1.
               .

               do with frame bkfl1 on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*G2LF*/          find wr_route where wr_lot = cumwo_lot
/*G2LF*/          and wr_op = op no-lock no-error.

/*J095*           for each sr_wkfl exclusive where sr_userid = mfguser:    */
/*J095*/          for each sr_wkfl exclusive-lock where sr_userid = mfguser:
                     delete sr_wkfl.
                  end.

/*J095*           for each pk_det exclusive where pk_user = mfguser:       */
/*J095*/          for each pk_det exclusive-lock where pk_user = mfguser:
                     delete pk_det.
                  end.

/*J04T*/          /*DELETE LOTW_WKFL*/
/*J04T*/          {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


                  {gprun.i ""rebkfli1.p""
                  "(input cumwo_lot, input op, output undo_stat)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if undo_stat then undo main, retry main.

                  conv_qty_proc = qty_proc * conv.
                  conv_qty_rjct = qty_rjct * conv.
                  conv_qty_scrap = qty_scrap * conv.
                  conv_qty_move =
                     if move_next_op then
                        conv_qty_proc - conv_qty_rjct - conv_qty_scrap
                     else 0.

/*G2P0*  BEGIN ADD SECTION */
/*                IF QUANTITY PROCESSED AT THIS OPERATION IS NEGATIVE AND    */
/*                THE CUMULATIVE MOVE QUANTITY IS ZERO THEN IT IS NOT A VALID*/
/*                BACKFLUSH TRANSACTION. THE USER IS TRYING TO DO A NEGATIVE */
/*                RECEIPT BEFORE DOING ANY POSITIVE RECEIPT AT THIS OPERATION*/
/*                AND THAT IS NOT ALLOWED.                                   */

/*L0P5*/          /* UNCONDITIONALLY ALLOW REPORTING NEGATIVE QUANTITIES     */
/*L0P5** BEGIN DELETE SECTION
 *
 *                do transaction:
 *                   if conv_qty_proc < 0 then do:
 *                      {rewrsget.i &lot=wr_lot &op=wr_op}
 * /*J323*/             /* TO ALLOW NEGATIVE QUANTITY TO BE PROCESSED WHEN */
 * /*J323*/                /* COMPLETED QUANTITY RESIDES IN THE OUTPUT QUEUE  */
 * /*J323*/                /* OF THE CURRENT OPERATION                        */
 * /*J323**                if wr_qty_cummove = 0 then do : */
 *
 * /*J323*/       if (wr_qty_cummove = 0 and move_next_op) or
 * /*J323*/          (wr_qty_cumproc = 0 and not move_next_op)
 * /*J323*/       then do:
 *                         /* ERROR: CUMULATIVE MOVE QUANTITY IS ZERO. */.
 * /*G2Q3                  {mfmsg.i 9788 3} */
 * /*G2Q3*/                {mfmsg.i 2249 3}
 *                         undo main, retry main.
 *                      end. /* IF wr_qty_cummove = 0 */
 *                   end. /* IF conv_qty_proc < 0 */
 *                end. /* DO TRANSACTION */
 *
 *L0P5** END DELETE SECTION */

/*G2P0*  END ADD SECTION */

                  /*CHECK QUEUES IF WOULD GO NEGATIVE; IF SO ISSUE MESSAGES*/

                  msg_ct = 0.

                  /*DETERMINE INPUT QUE OP TO CHECK;
                  COULD BE PRIOR NONMILESTONES*/
                  {gprun.i ""reiqchg.p"" "(input cumwo_lot, input op,
                  input conv_qty_proc, output input_que_op_to_ck,
                  output input_que_qty_chg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /*CHECK INPUT QUEUE*/
                  {gprun.i ""rechkq.p"" "(input cumwo_lot,
                  input input_que_op_to_ck,
                  input ""i"",
                  input input_que_qty_chg,
                  input-output msg_ct)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /*CHECK OUTPUT QUEUE*/
                  {gprun.i ""rechkq.p"" "(input cumwo_lot, input op,
                  input ""o"",
                  input (conv_qty_proc - conv_qty_scrap
                          - conv_qty_rjct - conv_qty_move),
                  input-output msg_ct)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /*CHECK REJECT QUEUE*/
                  {gprun.i ""rechkq.p"" "(input cumwo_lot, input to_op,
                  input ""r"",
                  input conv_qty_rjct,
                  input-output msg_ct)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /*CHECK INPUT QUEUE NEXT OP IF MOVE*/
                  if move_next_op then do:
                     find first wr_route where wr_lot = cumwo_lot
                     and wr_op > op no-lock no-error.

                     if available wr_route then do:
                        {gprun.i ""rechkq.p""
                        "(input cumwo_lot, input wr_op,
                        input ""i"",
                        input conv_qty_move,
                        input-output msg_ct)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                  end.

                  /*FORCE A PAUSE IF NECESSARY*/
                  {gprun.i ""repause.p"" "(input msg_ct)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /*BUILD DEFAULT COMPONENT PART ISSUE LIST*/
                  /*G09J ADDED dont_zero_unissuable TO FOLLOWING CALL*/
                  /*H0Q8 ADDED wkctr TO FOLLOWING CALL               */
                  {gprun.i ""recrtcl.p"" "(input cumwo_lot,
                                           input op,
                                           input yes,
                                           input conv_qty_proc,
                                           input eff_date,
                                           input dont_zero_unissuable,
                                           input wkctr,
                                           output rejected,
                                           output lotserials_req)"
                  }
/*GUI*/ if global-beam-me-up then undo, leave.


/*H0Q8* * * BEGIN COMMENT OUT SECTION *
./*G1G0*/          if can-find (loc_mstr where loc_loc = wkctr and
./*G1V4* /*G1G0*/                       loc_site = wo_site) then do: */
./*G1V4*/                       loc_site = site) then do:
./*G1G0*/            for each pk_det exclusive-lock where pk_user = mfguser:
./*G1G0*/              pk_loc = wkctr.
./*G1G0*/            end.
./*G1G0*/          end. /* work center is a valid location */
.
.                  /*IF THE WORK CENTER ENTERED BY THE USER IS NOT A    */
.                  /*VALID LOCATION, THEN DEFAULT TO THE LOCATION IN THE*/
.                  /*PT_MSTR.                                           */
./*G1G0*/          else do:
./*G1G0*/            for each pk_det exclusive-lock where pk_user = mfguser
./*G1G0*/              break by pk_part:
./*G1G0*/              if first-of(pk_part) then do:
./*G1G0*/                find pt_mstr where pt_part = pk_part no-lock no-error.
./*G1G0*/              end. /* FIRST-OF PKPART */
./*G1G0*/              if available pt_mstr then pk_loc = pt_loc.
./*G1G0*/            end.
./*G1G0*/          end. /* WKCTR IS NOT A VALID LOCATION */
.*H0Q8* * * END COMMNET OUT SECTION */
                  if lotserials_req then do:
                     {mfmsg.i 1119 1}
                  end.

                  if rejected then mod_issrc = yes.


                  /*MODIFY COMPONENT PART ISSUE LIST*/
                  if mod_issrc then do:
                     hide frame bkfl1 no-pause.
                     hide frame a no-pause.

                     display
                     site
                     part
                     op
                     line
                     with frame b side-labels width 80 attr-space.

                     {gprun.i ""reisslst.p""
                     "(input cumwo_lot, input part, input site,
                     input eff_date, input wkctr,
                     input conv_qty_proc, output undo_stat)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                     hide frame b no-pause.

                     if undo_stat then do:
                        view frame a.
                        view frame bkfl1.
                        undo, retry.
                     end.
                  end.



                  /*FORCE MODIFY FINISHED PART RECEIVE LIST IF ANY COMPONENTS
                  L/S CONTROLLED, OR IF FOR SOME REASON THEY ARE NOT ISSUABLE*/
                  if move_next_op and conv_qty_move <> 0 then do:
                     find first wr_route where wr_lot = cumwo_lot
                     and wr_op > op no-lock no-error.

                     if not available wr_route then do:
                        find wo_mstr where wo_lot = cumwo_lot no-lock.
                        find pt_mstr where pt_part = wo_part no-lock.
                        rejected = no.
                        if index("LS",pt_lot_ser) = 0 then do:
/*J04T*/                   /*ADDED BLANKS FOR TRNBR AND TRLINE*/
                           {gprun.i ""icedit2.p""
                           "(input ""RCT-WO"",
                           input if wo_site > """" then wo_site
                           else pt_site,
                           input if wo_loc > """" then wo_loc
                           else pt_loc,
                           input wo_part,
                           input """",
                           input """",
                           input conv_qty_move,
                           input pt_um,
                           input """",
                           input """",
                           output rejected)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                        end.

                        if index("LS",pt_lot_ser) > 0 or mod_issrc or rejected
                        then do:
                           hide frame bkfl1 no-pause.
                           hide frame a no-pause.

                           display
                           site
                           part
                           op
                           line
                           with frame b side-labels width 80 attr-space.

                           /*MODIFY FINISHED PART RECEIVE LIST*/
                           {gprun.i ""rercvlst.p""
                           "(input cumwo_lot, input conv_qty_move,
                           output undo_stat)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                           hide frame b no-pause.

                           if undo_stat then do:
                              view frame a.
                              view frame bkfl1.
/*H1L0*/              if batchrun then undo main, leave main.
/*H1L0*/              else
                              undo, retry.
                           end.
                        end.
                        else do:
                           do transaction:
                              create sr_wkfl.

                              assign
                              sr_userid = mfguser
                              sr_lineid = "+" + wo_part
                              sr_site = wo_site
                              sr_loc = wo_loc
                              sr_qty = conv_qty_move.

                              if sr_loc = "" then sr_loc = pt_loc.
                           end.
                        end.
                     end.
                  end.


                  /*G0G6 ADD FOLLOWING SECTION*/
                  find wo_mstr where wo_lot = cumwo_lot no-lock.
                  wo_recno = recid(wo_mstr).
                  find wr_route where wr_lot = cumwo_lot and wr_op = op no-lock.
                  wr_recno = recid(wr_route).

/*J356*/          if not batchrun then do:
                     {mpwindow.i
                      wo_part
                      op
                      "if wo_routing = """" then wr_part else wo_routing"
                     }
/*J356*/          end. /* IF NOT BATCHRUN */
                  /*G0G6 END SECTION*/

                  view frame a.
                  view frame bkfl1.

                  yn = yes.
                  {mfmsg01.i 32 1 yn}
                  if yn <> yes then undo, retry.

/*M14Y*/          /* TO CHECK THE CUMULATIVE ORDER IS NOT CLOSED */
/*M14Y*/          /* DURING USER INTERFACE                       */
/*M14Y*/          if can-find(first wo_mstr
/*M14Y*/             where wo_lot    = cumwo_lot
/*M14Y*/             and   wo_status = "C"
/*M14Y*/             no-lock)
/*M14Y*/          then do:

/*M14Y*/             /* CUM ORDER IS CLOSED */
/*M14Y*/             {mfmsg.i 5101 3}
/*M14Y*/             undo main, retry main.

/*M14Y*/          end. /* IF CAN-FIND(wo_mstr ... */

/*M14Y*/          /* FIND CUM ORDER. */
/*M14Y*/          {gprun.i ""regetwo.p"" "(input site,
                                           input part,
                                           input eff_date,
                                           input line,
                                           input routing,
                                           input bom_code,
                                           output l_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*M14Y*/          /* TO CHECK THE CUMULATIVE ORDER IS NOT EXPIRED */
/*M14Y*/          /* DURING USER INTERFACE                        */
/*M14Y*/          if cumwo_lot <> l_lot
/*M14Y*/          then do:

/*M14Y*/             /* CUM ORDER HAS EXPIRED */
/*M14Y*/             {mfmsg.i 5124 3}
/*M14Y*/             undo main, retry main.

/*M14Y*/          end. /* IF cumwo_lot <> l_lot */

/*G0V9*/          /* NOW THAT WE HAVE LAST INPUT FROM USER, RECHECK INVENTORY*/
/*H0Q8*/                {gprun.i ""reoptr1f.p""
                            "(input """",
                              output inv-issued)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0Q8* /*G0V9*/          {gprun.i ""reoptr1f.p""} */
/*G0V9*/          if inv-issued then undo, retry.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


               /*************************************/
               /*  GOT ALL DATA AND VALIDATED IT,   */
               /*  NOW WE CAN DO SOMETHING WITH IT  */
               /*************************************/

               /*NO TRANSACTION SHOULD BE PENDING HERE*/
               {gprun.i ""gpistran.p"" "(input 1, input """")"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /*ISSUE COMPONENTS*/
               {gprun.i ""rebkflis.p"" "(input cumwo_lot, input eff_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.



               /*REGISTER QTY PROCESSED FOR NONMILESTONES*/
               {gprun.i ""rebkflnm.p"" "(input cumwo_lot, input op,
                                         input eff_date, input shift,
                                         input trans_type,
                                         input conv_qty_proc)"}
/*GUI*/ if global-beam-me-up then undo, leave.



               /*CREATE OP_HIST RECORD*/
               {gprun.i ""reophist.p"" "(input trans_type,
               input cumwo_lot, input op, input emp,
               input wkctr, input mch, input dept, input shift,
               input eff_date,
               output ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*H1F7*        BEGIN OF ADDED CODE                                         */
/*             REUPOPST.P IS INCLUDED TO FIND THE ALTERNATE WORK CENTER    */
/*             RUN RATE WHEN THE WORK CENTER OR MACHINE DEFINED DURING     */
/*             BACKFLUSH IS DIFFERENT FROM THE ONE DEFINED IN WORK ORDER   */
/*             ROUTING AND TO POPULATE OP_STD_RUN WITH THE CORRECT VALUE.  */
/*             IF THE RATE SET UP IN WORK CENTER/ROUTING(wcr_rate) IS ZERO,*/
/*             THE STANDARD RUN TIME IN THE OPERATION HISTORY(op_std_run)IS*/
/*             NOT CHANGED EVEN IF ALTERNATE WORK CENTER OR MACHINE IS USED*/
/*             FOR REPORTING.                                              */

               if (input wkctr <> wr_wkctr or input mch <> wr_mch) then
               do:
                   {gprun.i ""reupopst.p""
                            "(input ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /*END OF IF INPUT(INPUT WKCTR */

/*H1F7*        END OF ADDED CODE                                           */

               /*LABOR AND BURDEN TRANSACTIONS*/
               std_run_hrs = 0.

               do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

                  find wr_route where wr_lot = cumwo_lot
                  and wr_op = op no-lock.

                  {rewrsget.i &lot=wr_lot &op=wr_op}

                  if wr_auto_lbr then do:
                     std_run_hrs = conv_qty_proc * wr_run.
                  end.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


               {gprun.i ""relbra.p"" "(input cumwo_lot, input op,
               input wkctr, input mch, input dept,
               input (act_run_hrs + std_run_hrs),
               input eff_date,
               input earn_code, input emp, input true, input ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*H1J5*/       /* BEGIN OF ADDED CODE */

               if can-find(mfc_ctrl where mfc_field = "rpc_zero_bal_wip")
               then do:
                  find mfc_ctrl where mfc_field = "rpc_zero_bal_wip"
               no-lock no-error.
               end.
               else do:
                  {gprun.i ""remfccr.p"" "(output mfc-recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  find mfc_ctrl where recid(mfc_ctrl) = mfc-recid
               no-lock no-error.
               end.

               /* INCASE OF 'Zero Balance WIP' (mfc_logical = yes) LOGIC FOR */
               /* NORMAL AND NEGATIVE BKFL TRANSACTIONS, AND 'Pulling WIP'   */
               /* (mfc_logical = no) LOGIC FOR NORMAL TRANSACTIONS, CALL TO  */
               /* rebkfla.p AND removea.p ARE REQUIRED AS THESE PROGRAMS     */
               /* CALLED BY rebkflnm.p ABOVE TAKES CARE OF ONLY INCREASING/  */
               /* DECREASING THE INPUT/OUTPUT Q VALUES OF PRIOR NM OP's. SO  */
               /* INORDER TO TAKE CARE OF THE CURRENT OP's INPUT/OUTPUT Q AND*/
               /* NEXT OP's INPUT Q VALUES, THE BELOW CLLS ARE REQUIRED.     */

               /* INCASE OF 'Pulling WIP' LOGIC FOR CORRECTING TRANSACTION, */
               /* rebkfla.p and removea.p SHOULD NOT BE CALLED AS rebkfla.p  */
               /* AND removea.p CALLED BY rebkflnm.p ABOVE HANDLE THE INPUT  */
               /* OUTPUT Q VALUES OF CURRENT OP AND NEXT OP (WHEN Move To    */
               /* Next Op = true).  FOR A CORRECTING TRANSACTION IN CASE OF  */
               /* 'Pulling WIP', THE INPUT Q OF CURRENT OP IS INCREASED AND  */
               /* OUTPUT Q OF CURRENT OP IS DECREASED. SUBSEQUENTLY, INPUT Q */
               /* OF NEXT OP IS DECREASED AND OUTPUT Q OF CURRENT OP IS      */
               /* INCREASED DEPENDING ON 'Move To Next OP' FLAG. THIS IS DONE*/
               /* BY rebkflnm.p AND SO THE BELOW CALLS ARE NOT NEEDED.       */

               if (mfc_logical = yes) or
                  (mfc_logical = no and conv_qty_proc > 0) then do:

/*H1J5*/       /* END OF ADDED CODE */

                  /*REGISTER QTY PROCESSED (REDUCE INQUE, INCREASE OUTQUE)*/
                  {gprun.i ""rebkfla.p"" "(input cumwo_lot, input op,
                  input ophist_recid, input conv_qty_proc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*H1J5*/       end. /* IF mfc_logical = yes */


/*J0ZB            ONLY EXECUTE WAREHOUSE INTERFACE CODE IF WAREHOUSING  ***
 *                                 INTERFACE IS ACTIVE                  ***/

/*J0ZB*/          if can-find(first whl_mstr where whl_act = true no-lock)
/*J0ZB*/          then do:

/*J0ZB*/             for each sr_wkfl where sr_userid = mfguser no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


                        /* CREATE A TE_MSTR RECORD */
/*J141 /*J0ZB*/           {gprun.i ""wireoptr.p"" */
/*J141                           "(input 'rebkfl', */
/*J141*/                  {gprun.i ""wireoptr.p""
/*J141*/                         "(input 'wi-rebkfl',
                                   input wkctr,
                                   input sr_qty,
                                   input sr_site,
                                   input sr_loc,
                                   input eff_date,
                                   input shift,
                                   input wo_part,
                                   input sr_lotser,
                                   input sr_ref,
                                   input um,
                                   input conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0ZB*/             end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0ZB*/          end.

/*J0ZB************* REPLACED BELOW CODE WITH CALL TO WIREOPTR.P ************
 * /*J0FY*/      /* WRITE RECORD TO TE_MSTR IF LOCATION IS A 4 WALL WAREHOUSE */
 *             for each sr_wkfl where sr_userid = mfguser:
 *                 assign
 *                     w-site = sr_site
 *                     w-loc  = sr_loc
 *                     lotserial = sr_lotser
 * /*J0FY*/              w-file-type = "rebkfl"
 * /*J0FY*/              w_wkctr = wkctr
 * /*J0FY*/              w_op_qty_cum = sr_qty.
 * /*J0FY*/         {reoptr10.i }
 *             end.
 *
 * /*J0FY*/     /* END OF TE_MSTR WRITE. */
 *J0ZB*********************************************************************/

               /*MOVE TO NEXT OP IF WE NEED TO*/
               if move_next_op then do:
/*J04T*/          find first wr_route where wr_lot = cumwo_lot and wr_op > op
/*J04T*/          no-lock no-error.
/*J04T*/          if available wr_route then do:
                     {gprun.i ""removea.p"" "(input cumwo_lot, input op,
                      input eff_date, input ophist_recid, input conv_qty_move)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04T*/          end.
/*J04T*/          else do:
/*J04T*/            /*RECEIVE COMPLETED MATERIAL.                            */
/*J04T*/            /*THIS SUBPROGRAM PICKS UP INPUT FROM SR_WKFL            */
/*J04T*/             {gprun.i ""receive.p"" "(input cumwo_lot, input eff_date,
/*J04T*/                                      input ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04T*/             {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J095*/             if clc_lotlevel <> 0 and pt_lot_ser = "L" then
/*J095*/             do transaction:
/*J095*/                find wo_mstr where wo_lot = cumwo_lot exclusive-lock.
/*J095*/                if available wo_mstr and not wo_lot_rcpt then
/*J36Y** /*J095*/          wo_lot_next = lotserial. */
/*J36Y*/                   wo_lot_next = "".
/*J095*/             end.
/*J04T*/          end.
               end.

               /*PROCESS SCRAP QUANTITIES*/
               if outque_multi_entry then do:
                  do i = 1 to 10:
                     if scrap_quantities[i] <> 0 then do:
                        conv_qty_scrap = scrap_quantities[i] * conv.

                        {gprun.i ""reophist.p"" "(input trans_type,
                        input cumwo_lot, input op, input emp,
                        input wkctr, input mch, input dept, input shift,
                        input eff_date,
                        output ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                        {gprun.i ""rescrapa.p""
                        "(input cumwo_lot, input op,
                        input conv_qty_scrap, input scrap_rsn_codes[i],
                        input yes, input emp, input ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                  end.
               end.
               else
               if conv_qty_scrap <> 0 then do:
                  {gprun.i ""rescrapa.p""
                  "(input cumwo_lot, input op,
                  input conv_qty_scrap, input scrap_rsn_code,
                  input yes, input emp, input ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.


               /*PROCESS REJECT QUANTITIES*/
               {gprun.i ""rejectb.p""
               "(input cumwo_lot,
               input op,
               input to_op,
               input emp,
               input shift,
               input eff_date,
               input conv_qty_rjct,
               input trans_type)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if rejque_multi_entry then do:
                  do i = 1 to 10:
                     if reject_quantities[i] <> 0 then do:
                        conv_qty_rjct = reject_quantities[i] * conv.

                        {gprun.i ""reophist.p"" "(input trans_type,
                        input cumwo_lot, input to_op, input emp,
                        input wkctr, input mch, input dept, input shift,
                        input eff_date,
                        output ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                        {gprun.i ""rejecta.p""
                        "(input cumwo_lot, input to_op, input op,
                        input reject_rsn_codes[i],
                        input ophist_recid,
                        input conv_qty_rjct)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                  end.
               end.
               else
               if conv_qty_rjct <> 0 then do:
                  {gprun.i ""reophist.p"" "(input trans_type,
                  input cumwo_lot, input to_op, input emp,
                  input wkctr, input mch, input dept, input shift,
                  input eff_date,
                  output ophist_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  {gprun.i ""rejecta.p""
                  "(input cumwo_lot, input to_op,
                  input op,
                  input rjct_rsn_code,
                  input ophist_recid,
                  input conv_qty_rjct)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.


               global_addr = string(ophist_recid).
               {gprun.i ""reintchk.p"" "(input cumwo_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.

          end.
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*K001*/ if daybooks-in-use then delete procedure h-nrm no-error.
