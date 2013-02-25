/*yyrwroauto.p for generate the routing based on bom automatically           */
/*Last modified by: Kevin, 11/09/2003                                        */
/*eb2+sp7 retrofit:tao fengqin *tfq* 11/09/2003                              */
/* $Revision:qad2011  $ BY: Jordan Lin DATE: 10/25/12  ECO:  *SS-20121025.1* */

/* DISPLAY TITLE */
{mfdtitle.i "121025.1"}

def var site like si_site.
def var sidesc like si_desc.
def var parent like bom_parent.
def var parent1 like bom_parent.
def var msg-nbr as inte.
def var comp like ps_comp.
def var level as inte.
define variable record as integer extent 100.
def var rmks as char format "x(80)" label "说明".

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /* *SS-20121025.1* site  colon 22 sidesc no-label  */
 parent colon 22       parent1 colon 45 label {t001.i}
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
/*tfq*/ setFrameLabels(frame a:handle).
repeat:
    sidesc = "".

    if parent1 = hi_char then parent1 = "".
  /* *SS-20121025.1*   -b */
/*
 *   update site parent parent1 with frame a editing:
 *        if frame-field = "site" then do:
 *            {mfnp.i si_mstr site " si_domain = global_domain and si_site " site si_site si_site}
 *            if recno <> ? then
 *                disp si_site @ site si_desc @ sidesc with frame a.
 *        end.
 *        else do:
 *            readkey.
 *            apply lastkey.
 *        end.
 *    end.
 *
 *         find si_mstr no-lock where si_domain = global_domain
 *          and si_site = site no-error.
 *         if not available si_mstr or (si_db <> global_db) then do:
 *             if not available si_mstr then msg-nbr = 708.
 *             else msg-nbr = 5421.
 *             /*tfq {mfmsg.i msg-nbr 3} */
 *             {pxmsg.i &MSGNUM=msg-nbr &ERRORLEVEL=3 }
 *             undo, retry.
 *         end.
 *
 *         disp si_site @ site si_desc @ sidesc with frame a.
 *
 *                {gprun.i ""gpsiver.p""
 *                "(input si_site, input recid(si_mstr), output return_int)"}
 * /*GUI*/ if global-beam-me-up then undo, leave.
 *
 * /*J034*/          if return_int = 0 then do:
 * /*J034*/             /*tfq {mfmsg.i 725 3}  */
 * {pxmsg.i
 *               &MSGNUM=725
 *              &ERRORLEVEL=3
 *                         }  /* USER DOES NOT HAVE */
 * /*J034*/                                /* ACCESS TO THIS SITE*/
 *  /*J034*/             undo,retry.
 * /*J034*/          end.
 */
  update parent parent1 with frame a.

   /* *SS-20121025.1* -e  */
       bcdparm = "".
  /* *SS-20121025.1*       {mfquoter.i site     }    */
       {mfquoter.i parent   }
       {mfquoter.i parent1  }

       if parent1 = "" then parent1 = hi_char.

    {mfselbpr.i "printer" 132}

    {mfphead.i}

    Do transaction:
    for each bom_mstr where bom_domain = global_domain /* *SS-20121025.1*  and bom__chr01 = site  */
        and (bom_parent >= parent and bom_parent <= parent1) no-lock:

        rmks = "".

        /*added by kevin,11/09/2003 for select the final product's bom code*/
       find pt_mstr where pt_domain = global_domain and pt_part = bom_parent no-lock no-error.
       if not available pt_mstr then do:
          find pt_mstr where pt_domain = global_domain and pt_part = bom__chr02 no-lock no-error.
          if not available pt_mstr then next.
      end.

       if not pt_prod_line begins "7" and pt_part_type <> "58" and not pt_group begins "58" then next.
        /*end added by kevin,11/09/2003*/

        find first ps_mstr where ps_domain = global_domain /* *SS-20121025.1*  and ps__chr01 = bom__chr01   */ and ps_par = bom_parent no-lock no-error.
        if not available ps_mstr then next.

        /*verify the routing record, if existing then next*/
        find first ro_det where ro_domain = global_domain and ro_routing = bom_parent no-lock no-error.
        if available ro_det then do:
            disp bom_parent bom_desc "失败:工艺流程已经存在!" @ rmks with width 132 stream-io.
            next.
        end.

   assign comp = bom_parent
          level = 1.

   find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = comp
   no-lock no-error.
   repeat:
         if not available ps_mstr then do:
      repeat:
         level = level - 1.
         if level < 1 then leave.
         find ps_mstr where recid(ps_mstr) = record[level]
         no-lock no-error.
         comp = ps_par.
         find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = comp
         no-lock no-error.
         if available ps_mstr then leave.
      end.
         end.
         if level < 1 then leave.

              record[level] = recid(ps_mstr).
/*y0222*/ assign site = "dcec-c".
/*y0222*/ if substring(ps_par,length(ps_par) - 1 , 2) = "zz" then assign site = "dcec-b".
          find first ptp_det where ptp_domain = global_domain and ptp_site = site and ptp_part = ps_comp no-lock no-error.
          if available ptp_det and ptp_phantom = no and ps_op <> 0 then do:

              find first ro_det where ro_domain = global_domain and ro_routing = bom_parent and ro_op = ps_op no-error.
              if not available ro_det then do:
                    create ro_det. ro_domain = global_domain.
                    assign ro_routing = bom_parent
                           ro_op = ps_op.
/*                         ro__chr01 = bom__chr01.                           */

                    find opm_mstr where opm_domain = global_domain and opm_std_op = string(ps_op) no-lock no-error.
                    if available opm_mstr then do:
                        assign ro_std_op = opm_std_op
                               ro_desc = opm_desc
                               ro_wkctr = opm_wkctr
                               ro_mch = opm_mch
                               ro_tran_qty = opm_tran_qty
                               ro_milestone = opm_mile
                               ro_sub_lead = opm_sub_lead
                               ro_setup = opm_setup
                               ro_run = opm_run
                               ro_move = opm_move
                               ro_yield_pct = opm_yld_pct
                               ro_tool = opm_tool
                               ro_vend = opm_vend
                               ro_inv_value = opm_inv_val
                               ro_sub_cost = opm_sub_cost
                               ro_mv_nxt_op = yes
                               ro_auto_lbr = yes.
                        find wc_mstr where wc_domain = global_domain and wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                        if available wc_mstr then do:
                               assign ro_mch_op = wc_mch_op
                                      ro_queue = wc_queue
                                      ro_wait = wc_wait
                                      ro_men_mc = wc_men_mch
                                      ro_setup_men = wc_setup_men.
                        end.
                    end.

              end. /*if not available ro_det*/
          end. /*if available ptp_det and ptp_phantom = no*/

          find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error.
          if available pt_mstr and pt_phantom = no then do:
         find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = comp
         no-lock no-error.
          end.
          else do:
               comp = ps_comp.
               level = level + 1.
         find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = comp
         no-lock no-error.
     end.
   end. /*repeat for expand the bom*/

        find first ro_det where ro_domain = global_Domain and ro_routing = bom_parent no-lock no-error.
        if available ro_det then do:
              disp bom_parent bom_desc "成功创建工艺流程!" @ rmks with width 132 stream-io.
        end.
        else do:
              disp bom_parent bom_desc "失败!" @ rmks with width 132 stream-io.
        end.

    end. /*for each bom_mstr*/
    end.

    {mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end. /*repeat*/

