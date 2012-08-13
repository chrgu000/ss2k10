/* GUI CONVERTED from soivmta2.p (converter v1.75) Sat May  5 08:30:58 2001 */
/* soivmta2.p - PENDING INVOICE LINE MAINTENANCE                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*V8:RunMode=Character,Windows */
/* REVISION: 7.3            CREATED: 04/07/93   BY: bcm *G889**/
/* REVISION: 7.3      LAST MODIFIED: 04/28/93   BY: tjs *G948**/
/* REVISION: 7.3      LAST MODIFIED: 05/14/93   BY: WUG *GB10**/
/* REVISION: 7.4      LAST MODIFIED: 06/16/93   BY: bcm *H002**/
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: afs *H134**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184**/
/* REVISION: 7.4      LAST MODIFIED: 02/17/94   BY: dpm *FM10**/
/* REVISION: 7.4      LAST MODIFIED: 09/02/94   BY: dpm *FQ53**/
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: dpm *FQ95**/
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: dpm *GM18**/
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: dpm *FR95**/
/* REVISION: 8.5      LAST MODIFIED: 11/22/94   BY: taf *J038**/
/* REVISION: 7.4      LAST MODIFIED: 12/12/94   BY: dpm *FT84**/
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR**/
/* REVISION: 7.4      LAST MODIFIED: 01/17/95   BY: srk *G0C1**/
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM**/
/* REVISION: 8.5      LAST MODIFIED: 04/19/95   BY: DAH *J042**/
/* REVISION: 7.4      LAST MODIFIED: 08/29/95   BY: jym *G0VQ**/
/* REVISION: 7.4      LAST MODIFIED: 09/29/95   BY: ais *F0VK**/
/* REVISION: 7.4      LAST MODIFIED: 12/11/95   BY: ais *G1FW**/
/* REVISION: 7.4      LAST MODIFIED: 12/19/95   BY: ais *G1H4**/
/* REVISION: 7.4      LAST MODIFIED: 01/24/96   BY: jzw *H0J6**/
/* REVISION: 8.5      LAST MODIFIED: 03/25/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: svs *K007**/
/* REVISION: 8.6      LAST MODIFIED: 11/07/96   BY: *K01W* Ajit Deodhar   */
/* REVISION: 8.6      LAST MODIFIED: 11/08/96   BY: *G2HM* Ajit Deodhar   */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *J17Z* Suresh Nayak   */
/* REVISION: 8.6      LAST MODIFIED: 12/31/96   BY: *K03Y* Jean Miller    */
/* REVISION: 8.6      LAST MODIFIED: 02/20/97   BY: *H0SJ* Suresh Nayak   */
/* REVISION: 8.6      LAST MODIFIED: 05/15/97   BY: *G2MG* Ajit Deodhar   */
/* REVISION: 8.6      LAST MODIFIED: 09/05/97   BY: *G2PG* Niranjan Ranka */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N5* Kieu Nguyen    */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: *G2PV* Manish K.      */
/* REVISION: 8.6      LAST MODIFIED: 11/12/97   BY: *H1FB* Aruna Patil    */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil    */
/* REVISION: 8.6      LAST MODIFIED: 01/23/98   BY: *J2BW* Nirav Parikh   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton   */
/* Old ECO marker removed, but no ECO header exists *F739*                */
/* Old ECO marker removed, but no ECO header exists *F765*                */
/* Old ECO marker removed, but no ECO header exists *G035*                */
/* Old ECO marker removed, but no ECO header exists *G416*                */
/* Old ECO marker removed, but no ECO header exists *G429*                */
/* Old ECO marker removed, but no ECO header exists *G501*                */
/* Old ECO marker removed, but no ECO header exists *G530*                */
/* Old ECO marker removed, but no ECO header exists *H404*                */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L024* Sami Kureishy  */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/98   BY: *L06M* Russ Witt      */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/99   BY: *J3JM* Kedar Deherkar */
/* REVISION: 8.6E     LAST MODIFIED: 02/17/00   BY: *J3P9* Manish K.      */
/* REVISION: 8.6E     LAST MODIFIED: 08/09/00   BY: *L12P* Rajesh Kini    */
/* REVISION: 8.6E     LAST MODIFIED: 09/25/00   BY: *L121* Gurudev C      */
/* REVISION: 9.0      LAST MODIFIED: 04/19/01   BY: *M11Z* Jean Miller      */

         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivmta2_p_1 "说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmta2_p_2 "可备料量"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

/*J3JM*/ define input parameter l_prev_um_conv like sod_um_conv no-undo.
/*J3JM*/ define input parameter l_prev_um      like sod_um      no-undo.

         define new shared variable ship_so like sod_nbr.
         define new shared variable ship_line like sod_line.

         define shared variable line like sod_line.
         define variable desc1 like pt_desc1.
         define shared variable mult_slspsn like mfc_logical no-undo.
         define shared variable cmtindx like cmt_indx.
         define shared variable sodcmmts like soc_lcmmts label {&soivmta2_p_1}.
         define shared variable so_recno as recid.
         define shared variable sod_recno as recid.
         define shared variable clines as integer.
         define shared variable ln_fmt like soc_ln_fmt.
         define variable qty_allocatable like in_qty_avail label
          {&soivmta2_p_2}.
         define shared variable new_line like mfc_logical.
         define shared variable tax_date like tax_effdate no-undo.
         define shared variable old_site like sod_site.
         define variable zone_to             like txz_tax_zone.
         define variable zone_from           like txz_tax_zone.
         define shared variable old_sod_site        like sod_site no-undo.
         define variable vtclass as character extent 3.
         define buffer sod_buff for sod_det.
         define variable j as integer.
         define shared variable undo_mta2 as logical.
         define shared variable inv_data_changed like mfc_logical.
         define variable old_sod_loc as character.
         define variable old_sod_serial as character.
         define shared variable soc_pc_line  like mfc_logical.
         define variable glvalid like mfc_logical.
         define variable valid_acct like mfc_logical.
         define shared stream bi.
         define shared frame bi.

         /* FORM DEFINITION FOR HIDDEN FRAME BI */
         {sobifrm.i}
         FORM /*GUI*/  sod_det with frame bi THREE-D /*GUI*/.


         /*IT WAS NECESSARY TO MOVE THIS DEFINITION OF SHARED FRAMES C AND */
         /*D TO A LOCATION AFTER THE DEFS OF SHARED FRAME AND STREAM BI    */
         /*BECAUSE IT DOES NOT BEHAVE CORRECTLY IN PROGRESS v7             */
         define shared frame c.
         define shared frame d.
         define variable err-flag as integer.
         define shared variable so_db like dc_name.
         define shared variable inv_db like dc_name.
         define shared variable sonbr like sod_nbr.
         define shared variable soline like sod_line.
         define shared variable location like sod_loc.
         define shared variable lotser like sod_serial.
         define shared variable lotrf like sr_ref.
         define shared variable prev_qty_chg like sod_qty_chg.
/*M11Z*  define shared variable prev_price like sod_list_pr. */
/*M11Z*/ define shared variable prev_price  like sod_price no-undo.
/*M11Z*/ define shared variable prev_listpr like sod_list_pr no-undo.
         define variable upd_ok like mfc_logical.
/*L024*  define shared variable  exch-rate like exd_ent_rate.*/
/*L024*/ define shared variable  exch-rate like exr_rate.
/*L024* *L00Y* define shared variable  exch-rate2 like exd_ent_rate.*/
/*L024*/ define shared variable  exch-rate2 like exr_rate2.
         define shared variable discount as decimal.
         define shared variable reprice_dtl like mfc_logical.
         define            variable trfind like mfc_logical no-undo.
         define     shared variable trtotqty like tr_qty_chg no-undo.
         define     shared variable noentries as integer no-undo.
         define     shared variable new_order like mfc_logical.
         define            variable undo_taxpop like mfc_logical.
         define variable l_changedb like mfc_logical no-undo.
         define variable old_ref like tr_ref no-undo.
         define variable prev_due like sod_due_date no-undo.
         define variable prev_per like sod_per_date no-undo.
/*L024*/ define variable sodstdcost like sod_std_cost no-undo.
/*L024*/ define variable mc-error-number like msg_nbr no-undo.
/*J3JM*/ define variable l_undotran      like mfc_logical no-undo.
/*L06M*/ define shared variable remote-base-curr like gl_base_curr.

         define shared workfile wf-tr-hist
             field trsite like tr_site
             field trloc like tr_loc
             field trlotserial like tr_serial
             field trref like tr_ref
             field trqtychg like tr_qty_chg
             field trum like tr_um
             field trprice like tr_price.

            {gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

     find first gl_ctrl no-lock.

     loopa2:
     do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


        /*DEFINE FORMS C AND D*/
        {soivlnfm.i}
        view frame c.
            if ln_fmt then
        view frame d.

        find so_mstr where recid(so_mstr) = so_recno.
        find sod_det where recid(sod_det) = sod_recno.
        find first soc_ctrl no-lock.
            find pt_mstr where pt_part = sod_part no-lock no-error.

            if noentries = 1 then do:
               find first wf-tr-hist no-lock no-error.
             if available wf-tr-hist then
                assign
                   sod_loc = trloc
                   sod_serial =  trlotserial.

            end. /* noentries = 1 */

            assign prev_due = sod_due_date
                   prev_per = sod_per_date
                   old_sod_loc = sod_loc.
                   old_sod_serial = sod_serial.

            old_site = input frame bi sod_site.
            if sod_site <> old_site and  new_line = no   then do:
               find si_mstr where si_site = old_site no-lock .
               if si_db <> so_db then do:
                  {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                  assign
                  sonbr  = sod_nbr
                  soline = sod_line .
/*L121**          {gprun.i ""solndel.p""}  */

/*L121*/          /* ADDED INPUT PARAMETER no TO NOT EXECUTE MFSOFC01.I */
/*L121*/          /* AND MFSOFC02.I WHEN CALLED FROM DETAIL LINE        */
/*L121*/          {gprun.i ""solndel.p""
                           "(input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* Reset the db alias to the sales order database */
                  {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                  sod_recno = recid(sod_det).
               end.
               else do:
                  assign
                  sonbr  = sod_nbr
                  soline = sod_line .
                  {gprun.i ""solndel1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
            end.
            find si_mstr where si_site = sod_site no-lock .

            /* REMEMBER, RMA RECEIPT LINES NEED SOME SIGNS SWITCHED */
        if ln_fmt then
/*L024*/   do:
/*L06M*       ROUTINE REPLACED BELOW...
./*L024*/      {gprunp.i "mcpl" "p" "mc-curr-conv"
.                        "(input base_curr,
.                          input so_curr,
.                          input exch-rate2,
.                          input exch-rate,
.                          input sod_std_cost,
.                          input false,
.                          output sodstdcost,
.                          output mc-error-number)"}
. *L06M*/

/*L06M*       CONVERT CURRENCY FROM REMOTE BASE CURRENCY TO LOCAL BASE CURRENCY */
/*L06M*/      {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input remote-base-curr,
                          input base_curr,
                          input exch-rate,
                          input exch-rate2,
                          input sod_std_cost,
                          input false,
                          output sodstdcost,
                          output mc-error-number)"}

/*L024*/      if mc-error-number <> 0 then do:
/*L024*/         {mfmsg.i mc-error-number 2}
/*L024*/      end.

              display
                 sod_loc
                 sod_serial
                 sod_bo_chg when (sod_fsm_type <> "RMA-RCT")
                 (sod_bo_chg * -1) when (sod_fsm_type = "RMA-RCT")@ sod_bo_chg
/*L024*          sod_std_cost * exch-rate @ sod_std_cost */
/*L024*/         sodstdcost @ sod_std_cost
                 sod_comm_pct[1] when (sod_slspsn[1] <> "")
                 sod_req_date
                 sod_per_date
                 sod_due_date
                 sod_acct
                 sod_cc
                 sod_dsc_acct
                 sod_dsc_cc
                 sod_project
                 sod_type when (sod_qty_inv = 0 and sod_qty_ship = 0)
                 sod_um_conv
                 sod_fr_list
                 sod_taxable
                 sod_taxc
                 sodcmmts
                 sod_fix_pr sod_crt_int
                 sod_pricing_dt
              with frame d.
/*L024*/   end.

            setc:
            do on error undo setc, retry setc:
/*GUI*/ if global-beam-me-up then undo, leave.


           /* LINE DETAIL */
               setb:
               do on error undo, retry on endkey undo , leave loopa2 :
/*GUI*/ if global-beam-me-up then undo, leave.


          if ln_fmt then do:
                     sodcmmts = sod_cmtindx <> 0 or (new_line and soc_lcmmts).

                     /* FOR RMA'S, PREVENT THE USER FROM UPDATING QTYS */
                     if noentries > 1 then
                     set
                        sod_comm_pct[1] when (sod_slspsn[1] <> "")
                        sod_acct
                        sod_cc
                        sod_dsc_acct when (new_line or reprice_dtl)
                        sod_dsc_cc   when (new_line or reprice_dtl)
                        sod_taxable sod_taxc sodcmmts with frame d.

                     else
                     UPDATE
                        sod_loc sod_serial
                        sod_std_cost when (not available pt_mstr)
                        sod_comm_pct[1] when (sod_slspsn[1] <> "")
                        sod_req_date
                        sod_per_date
                        sod_due_date
                        sod_fix_pr
                        sod_acct
                        sod_cc
                        sod_dsc_acct when (new_line or reprice_dtl)
                        sod_dsc_cc   when (new_line or reprice_dtl)
                        sod_project
                        sod_type when (sod_qty_inv = 0 and sod_qty_ship = 0
                                       and sod_type = "")
                        sod_um_conv
                        sod_fr_list
                        sod_taxable
                        sod_taxc
                        sodcmmts
                     with frame d editing:
                        if frame-field = "sod_serial" and
                           input sod_loc <> global_loc then
                           global_loc = input sod_loc.
                        readkey.
                        apply lastkey.
                     end.  /* END EDITING */
              
               if so_secondary and not new_line
               and sod_per_date <> prev_per
               and (sod_btb_type = "03" or sod_btb_type = "02") then do:
                  {mfmsg.i 2825 3}    /* NO CHANGE IS ALLOWED ON EMT SO */
                  next-prompt sod_per_date with frame d.
                  undo, retry.
               end.

               if so_secondary and not new_line
               and sod_due_date <> prev_due
               and (sod_btb_type = "03" or sod_btb_type = "02") then do:
                  {mfmsg.i 2825 3}    /* NO CHANGE IS ALLOWED ON EMT SO */
                  next-prompt sod_due_date with frame d.
                  undo, retry.
               end.

                     {gpglver1.i &acc = sod_acct     &sub = ?
                 &cc  = sod_cc       &frame = d}
                     {gpglver1.i &acc = sod_dsc_acct &sub = ?
                 &cc  = sod_dsc_cc   &frame = d}

               if so_curr <> base_curr then do:

                  find ac_mstr where
                  ac_code = substring(sod_acct,1,(8 - global_sub_len))
                  no-lock no-error.
                  if available ac_mstr and ac_curr <> so_curr
                                       and ac_curr <> base_curr then do:
                     {mfmsg.i 134 3} /*ACCT CURR MUST BE TRANS OR BASE CURR*/
                     next-prompt sod_acct with frame d.
                     undo, retry.
                  end. /* end of if available ac_mstr and ac_curr <> so_curr */

                  find ac_mstr where
                  ac_code = substring(sod_dsc_acct,1,(8 - global_sub_len))
                  no-lock no-error.
                  if available ac_mstr and ac_curr <> so_curr
                                       and ac_curr <> base_curr then do:
                     {mfmsg.i 134 3} /*ACCT CURR MUST BE TRANS OR BASE CURR*/
                     next-prompt sod_dsc_acct with frame d.
                     undo, retry.
                  end. /* end of if available ac_mstr and ac_curr <> so_curr */

               end. /* end of if so_curr <> base_curr                        */

                     {gptxcval.i &code=sod_taxc &taxable=sod_taxable
                 &date=tax_date &frame="d" &undo_label="setb"}

                     /* VALIDATE FREIGHT LIST */
                     if sod_fr_list <> "" then do:
                        find fr_mstr where fr_list = sod_fr_list and
                        fr_site = sod_site and fr_curr = so_curr
                        no-lock no-error.
                        if not available fr_mstr then
                        find fr_mstr where fr_list = sod_fr_list and
                        fr_site = sod_site and fr_curr = base_curr no-lock
                         no-error.
                        if not available fr_mstr then do:
                           /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
                           {mfmsg03.i 670 4 sod_fr_list sod_site so_curr}
                           next-prompt sod_fr_list with frame d.
                           undo, retry.
                        end.
                     end.

             /* GET TAX MANAGEMENT DATA */
             if {txnew.i} and sod_taxable then do:      /* tax92 */

            if old_sod_site <> sod_site then do:
                            /* NEW SITE SPECIFIED; CHECK TAX ENVIRONMENT */
                           {mfmsg.i 955 2}
              sod_tax_env = "".
            end.

            taxloop:
                        do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


               /* SUGGEST TAX ENVIRONMENT */
               if sod_tax_env = "" then do:

                  /* LOAD DEFAULTS */
                  find ad_mstr where ad_addr = so_ship
                  no-lock no-error.
                  if available ad_mstr then
                 zone_to = ad_tax_zone.
                  else do:
                 find ad_mstr where ad_addr = so_cust
                 no-lock no-error.
                 if available(ad_mstr) then
                     zone_to = ad_tax_zone.
                  end.

                  /* CHECK FOR SITE ADDRESS */
                  find ad_mstr where ad_addr = sod_site no-lock
                  no-error.
                  if available(ad_mstr) then
                 zone_from = ad_tax_zone.
                  else do:
                              {mfmsg.i 864 2} /* SITE ADDRESS DOES NOT EXIST */
                 zone_from = "".
                  end.

                  {gprun.i ""txtxeget.p"" "(input  zone_to,
                            input  zone_from,
                            input  so_taxc,
                            output sod_tax_env)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.  /* sod_tax_env */

                           /* TAX MANAGEMENT TRANSACTION POP-UP. */
                           /* PARAMETERS ARE 5 FIELDS */
                           /* AND UPDATEABLE FLAGS, */
                           /* STARTING ROW, AND UNDO FLAG. */
/*J3P9*/                   /* CHANGED SIXTH AND EIGHTH INPUT PARAMETER */
/*J3P9*/                   /* TO TRUE FROM FALSE                       */
                           {gprun.i ""txtrnpop.p""
                "(input-output sod_tax_usage, input true,
                  input-output sod_tax_env,   input true,
                  input-output sod_taxc,      input true,
                  input-output sod_taxable,   input true,
                  input-output sod_tax_in,    input true,
                  input 13,
                  output undo_taxpop)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                           if undo_taxpop then undo setb, retry.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* taxloop */
             end.   /* txnew and sod_taxable */

             /* VALIDATE TAXABLE AND TAXCODE*/

                     /* VALIDATE FEWER THAN 4 TAX CLASSES */
                     if gl_vat or gl_can then do:
                        {gpvatchk.i &counter = j
                    &buffer = sod_buff
                    &ref = so_nbr
                    &buffref = sod_nb
                    &file = sod_det
                    &taxc = sod_taxc
                    &frame = d
                    &undo_yn = true
                    &undo_label = setb}
                     end.
          end. /* if single line format */
                  else do: /* multi line */
                     /* VALIDATE TAXABLE AND TAXCODE */
                     {gptxcval.i &code=sod_taxc &taxable=sod_taxable
                 &date=tax_date
                 &frame="NO-FRAME" &undo_label="loopa2"}

                     /* VALIDATE ACCOUNTS AND CC AS THEY DON'T GET */
             /* VALIDATED IN MULTI LINE FORMAT             */
             {gprun.i ""gpglver.p"" "(input sod_acct, input sod_cc,
                          output glvalid)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                     if glvalid = no then undo loopa2 ,leave.

                     {gprun.i ""gpglver.p"" "(input sod_dsc_acct,
                          input sod_dsc_cc,
                          output glvalid)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                     if glvalid = no then undo  loopa2 , leave.

               if so_curr <> base_curr then do:

                  find ac_mstr where
                  ac_code = substring(sod_acct,1,(8 - global_sub_len))
                  no-lock no-error.
                  if available ac_mstr and ac_curr <> so_curr
                                       and ac_curr <> base_curr then do:
                     {mfmsg.i 134 3} /*ACCT CURR MUST BE TRANS OR BASE CURR*/
                     undo loopa2, leave.
                  end. /* end of if available ac_mstr and ac_curr <> so_curr */

                  find ac_mstr where
                  ac_code = substring(sod_dsc_acct,1,(8 - global_sub_len))
                  no-lock no-error.
                  if available ac_mstr and ac_curr <> so_curr
                                       and ac_curr <> base_curr then do:
                     {mfmsg.i 134 3} /*ACCT CURR MUST BE TRANS OR BASE CURR*/
                     undo loopa2, leave.
                  end. /* end of if available ac_mstr and ac_curr <> so_curr */

               end. /* end of if so_curr <> base_curr                        */

                  end.

                  undo_mta2 = false.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* setb */

           define variable transtype as character initial "ISS-SO".
           define variable edit_qty as decimal.
           define variable ref as character.
           define variable undotran as logical no-undo.

               assign edit_qty = 0.
               if so_fsm_type = "RMA" then transtype = "ISS-RMA".

               if noentries = 0 then edit_qty = sod_qty_chg.

               /* WHILE MODIFYING AN EXISTING INVOICE  (noentries = 1)
              EDIT THE QUANTITY DEPENDING ON THE FOLLOWING CONDITIONS
               if any of Site/Location/Lotserial is changed then
                       edit the full quantitiy.
               end.
               else
                       if Quantity is changed then edit the difference.
                   else do edit 0 quantity.
               end.
                */

               else if noentries = 1 then do:
                    if sod_site <> old_site or
                   sod_loc  <> old_sod_loc  or
                   sod_serial <> old_sod_serial then
                   edit_qty = sod_qty_chg.
                    else do:
                       if sod_qty_chg <> sod_qty_inv then
                          edit_qty = sod_qty_chg - sod_qty_inv.
                       else
                  edit_qty = 0.
                    end. /* else do: */
               end. /* if noentries = 1 */

           if sod_type = "" and can-find(pt_mstr where pt_part = sod_part)
           then do:

                  ship_so   = sod_nbr.
                  ship_line = sod_line.

                  if noentries < 2 then do:
                      find si_mstr where si_site = sod_site no-lock no-error.
                      l_changedb = (si_db <> so_db).
                      if l_changedb then
                      do:
                     {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.

/*J3JM*/          if not new_line then
/*J3JM*/          do:
/*J3JM*/             if ((old_site       <> sod_site)   or
/*J3JM*/                 (old_sod_loc    <> sod_loc)    or
/*J3JM*/                 (old_sod_serial <> sod_serial) or
/*J3JM*/                 (old_ref        <> ref))       then
/*J3JM*/             do:
/*J3JM*/                {gprun.i ""icedit.p"" "(input transtype,
                                                input old_site,
                                                input old_sod_loc,
                                                input sod_part,
                                                input old_sod_serial,
                                                input old_ref,
                                                input (-1 * prev_qty_chg *
                                                       l_prev_um_conv),
                                                input l_prev_um,
                                                """",
                                                """",
                                                output l_undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J3JM*/             end. /* IF OLD_SITE <> SOD_SITE */
/*J3JM*/             else
/*J3JM*/             if l_prev_um <> sod_um then
/*J3JM*/             do:
/*J3JM*/                {gprun.i ""icedit.p"" "(input transtype,
                                                input sod_site,
                                                input sod_loc,
                                                input sod_part,
                                                input sod_serial,
                                                input ref,
                                                input (sod_qty_chg *
                                                       sod_um_conv -
                                                       prev_qty_chg *
                                                       l_prev_um_conv),
                                                input sod_um,
                                                """",
                                                """",
                                                output l_undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J3JM*/             end. /* ELSE IF L_PREV_UM <> SOD_UM */
/*J3JM*/          end. /* IF NOT NEW_LINE */

                      {gprun.i ""icedit.p""
                       "(input transtype,
                        input sod_site,
                        input sod_loc,
                        input sod_part,
                        input sod_serial,
                        input ref,
                        input edit_qty *  sod_um_conv,
                        input sod_um,
                        """",
                        """",
                        output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J3JM*/          undotran = undotran or l_undotran.

                      if l_changedb then
                      do:
                          {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.
                  end.

          do on error undo, leave on endkey undo, leave:
             message.
             message.
          end.

          undo_mta2 = undotran.

           end.

                if sod_type = "" and undotran then undo setc, retry setc.
                if sod_type <> "" then
                   assign undo_mta2 = false
                          undotran  = false.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*setc*/

            assign location = sod_loc
                   lotser = sod_serial.
            /* DO NOT RUN SOSOMULS.P IF MULTI LOCATIONS WHERE USED */
/*L12P**    if noentries < 2 then do:                                      */
/*L12P*/    if noentries = 1 then
/*L12P*/    do:
               if (available pt_mstr and pt_lot_ser = "L" and not new_line)
               and sod_type = ""
/*M11Z*        and ((sod_qty_chg < prev_qty_chg) or (sod_list_pr <> prev_price)) */
/*M11Z*/       and ((sod_qty_chg < prev_qty_chg) or
/*M11Z*/            (sod_list_pr <> prev_listpr))
               then do:
                  upd_ok = no.

              {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


              {gprun.i ""sosomuls.p"" "(input sod_nbr,
                                        input sod_line,
                    output old_sod_loc,
                    output old_sod_serial,
                        output old_ref,
                    output upd_ok )" }
/*GUI*/ if global-beam-me-up then undo, leave.

                                                      {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


                  if not upd_ok then undo, retry.

         /* WORKFILE FIELDS trloc, trlotserial, trref ASSIGNED WITH VALUES */
         /* ENTERED IN QUANTITY RETURN TO POP-UP                           */
                   assign  wf-tr-hist.trloc       = old_sod_loc
                           wf-tr-hist.trlotserial = old_sod_serial
                           wf-tr-hist.trref       = old_ref.

               end.
            end. /* noentries = 1 */

     end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*loopa2*/
