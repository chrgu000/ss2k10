/* bmcsru.p - BOM COST ROLL-UP                                          */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 01/30/92   BY: pma *F116*          */
/* REVISION: 7.0      LAST MODIFIED: 02/18/92   BY: pma *F206*          */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: emb *F345*          */
/* REVISION: 7.0      LAST MODIFIED: 05/28/92   BY: pma *F542*          */
/* REVISION: 7.2      LAST MODIFIED: 11/09/92   BY: emb *G294*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: emb *G700*          */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: pma *G681*          */
/* REVISION: 7.3      LAST MODIFIED: 12/20/93   BY: ais *GH69*          */
/* REVISION: 7.3      LAST MODIFIED: 01/28/94   BY: pma *GI54*          */
/* REVISION: 8.5      LAST MODIFIED: 10/20/94   BY: mwd *J034*          */
/* REVISION: 7.3      LAST MODIFIED: 06/07/95   BY: str *G0N9*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99   BY: *N03B* Jyoti Thatte */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *N0PP* Jean Miller       */
/* REVISION: 9.1      LAST MODIFIED: 06/27/01   BY: *M1CD* Rajesh Thomas     */

     /* DISPLAY TITLE */
     {mfdtitle.i "130719.1"} /*GH69*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmcsru_p_1 "Print Audit Trail"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_2 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_3 "All/Changed Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_4 "All/Changed"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_5 "Low Level Labor Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_6 "Low Level Labor"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_7 "Low Level Material"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_8 "Low Level Overhead"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_9 "Low Level Setup Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_10 "Low Level Subcontract"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_11 "Low Level Burden"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsru_p_12 "Include Yield %"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define new shared variable site  like si_site.
         define new shared variable csset like sct_sim.
         define new shared variable part  like pt_part.
         define new shared variable part1 like pt_part.

/*F345*/ define new shared variable line  like pt_prod_line.
/*F345*/ define new shared variable line1 like pt_prod_line.
/*F345*/ define new shared variable type  like pt_part_type.
/*F345*/ define new shared variable type1 like pt_part_type.
/*F345*/ define new shared variable grp   like pt_group.
/*F345*/ define new shared variable grp1  like pt_group.

/*GH69*  define new shared variable eff_date like op_date initial today. */
/*GH69*/ define new shared variable eff_date as date initial today
/*GH69*/    label {&bmcsru_p_2}.
         define new shared variable part_type like pt_part_type.
         define new shared variable mtl_flag like mfc_logical initial yes
            label {&bmcsru_p_7}.
         define new shared variable lbr_flag like mfc_logical initial yes
            label {&bmcsru_p_6}.
         define new shared variable bdn_flag like mfc_logical initial yes
            label {&bmcsru_p_11}.
         define new shared variable ovh_flag like mfc_logical initial yes
            label {&bmcsru_p_8}.
         define new shared variable sub_flag like mfc_logical initial yes
            label {&bmcsru_p_10}.
         define new shared variable labor_flag like mfc_logical
            label {&bmcsru_p_5}.
         define new shared variable setup_flag like mfc_logical
            label {&bmcsru_p_9}.
/*F542   define new shared variable audit_yn as logical initial yes */
/*F542*/ define new shared variable audit_yn like mfc_logical initial yes
         label {&bmcsru_p_1}.

         define variable yn like mfc_logical.
/*N03B*/ define variable l_is_oracle like mfc_logical initial no.

         define variable i as integer.
         define variable method as character format "x(15)".
/*F116*/ define new shared variable cst_flag like mfc_logical initial yes
/*F116*/    label  {&bmcsru_p_3} format {&bmcsru_p_4}.
/*F206*/ define shared variable transtype as character format "x(7)".
/*F542*/ define new shared variable yield_flag like mfc_logical initial yes
            label {&bmcsru_p_12}.

/*G681*/ define new shared variable rollup_id like qad_key3.
/*N0PP*/ define variable frm-text as character format "x(30)" no-undo.

/*N0PP*/ frm-text = getTermLabel("SET_COST_UPDATE_FIELD_FOR",30).

/*F116*/ /*changed colon 25 below from colon 38*/
         form
            site           colon 18
            csset          colon 18
            cs_desc        colon 30 no-label
            method         no-label
/*F345*     skip(1) */
            part           colon 18 part1  label {t001.i}  colon 49
/*F345*/    line           colon 18 line1  label {t001.i} colon 49
/*F345*/    type           colon 18 type1  label {t001.i} colon 49
/*F345*/    grp            colon 18 grp1   label {t001.i} colon 49
            skip(1)
            eff_date       colon 25
            mtl_flag       colon 25
/*N0PP* /*F116*/    {t008.i}          at 40 */
/*N0PP*/    frm-text       at 40    no-label
            lbr_flag       colon 25
/*F542*/    cst_flag       colon 56
/*F542* /*F116*/    {t009.i}          at 40  */
            bdn_flag       colon 25
/*F542* /*F116*/    {t010.i}          at 40  */
            ovh_flag       colon 25
/*F542* /*F116*/    {t011.i}          at 40  */
            sub_flag       colon 25
/*F542* /*F116*/    {t012.i}          at 40  */
            skip(1)
            labor_flag     colon 25
/*F542* /*F116*/    cst_flag       colon 56  */
/*F542*/    yield_flag     colon 56
            setup_flag     colon 25
            audit_yn       colon 25
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         find first icc_ctrl no-lock.

/*N03B*/ /* IF NOT ORACLE THEN L_IS_ORACLE = NO ELSE L_IS_ORACLE = YES */
/*N03B*/ assign
/*N03B*/    l_is_oracle = (dbtype ("qaddb") = "ORACLE")
/*F345*/    site = global_site.


/*G700*/ /* Added section */
         if transtype <> "SC"
/*G681*/ and csset = ""
         then do:
            find si_mstr no-lock where si_site = site no-error.
            if available si_mstr then csset = si_cur_set.
            if csset = "" then csset = icc_cur_set.
         end.
/*G700*/ /* End of added section */

/*F345*/ display site csset
/*F345*/    part part1 line line1 type type1 grp grp1
/*F345*/    eff_date mtl_flag lbr_flag bdn_flag
/*F345*/    ovh_flag sub_flag labor_flag setup_flag audit_yn
/*F345*/    cst_flag
/*F542*/    yield_flag
/*N0PP*/    frm-text
/*F345*/ with frame a.

/*G681*/ mainloop:
         repeat:

            if part1 = hi_char then part1 = "".
/*F345*/    if line1 = hi_char then line1 = "".
/*F345*/    if type1 = hi_char then type1 = "".
/*F345*/    if grp1 = hi_char then grp1 = "".

            if not batchrun then do:
               seta1:
               do transaction on error undo, retry.
                  set site with frame a editing:
                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp.i si_mstr site si_site site si_site si_site}

                     if recno <> ? then do:
                        site = si_site.
                        display site with frame a.
                        recno = ?.
                     end.
                  end.

                  find si_mstr where si_site = site no-lock no-error.
                  if not available si_mstr then do:
                     {mfmsg.i 708 3} /*site does not exist*/
                     next-prompt site with frame a.
                     undo, retry.
                  end.

                  if si_db <> global_db then do:
                     {mfmsg.i 5421 3} /*site is not assigned to this database*/
                     next-prompt site with frame a.
                     undo, retry.
                  end.

/*J034*/          {gprun.i ""gpsiver.p""
                   "(input site, input recid(si_mstr), output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3} /* USER DOES NOT HAVE  */
                     /* ACCESS TO THIS SITE */
/*J034*/             next-prompt site with frame a.
/*J034*/             undo mainloop, retry mainloop.
/*J034*/          end.

/*G700*/          if transtype <> "SC"
/*G681*/          and csset = ""
/*G700*/          then do:
/*G700*/             if si_cur_set > "" then csset = si_cur_set.
/*G700*/             else csset = icc_cur_set.
/*G700*/             display csset with frame a.
/*G700*/          end.
               end.

               seta2:
               do transaction on error undo, retry.

                  set csset with frame a editing:
                     /* FIND NEXT/PREVIOUS RECORD */
/*F206*/             if transtype = "SC" then do:
/*F206*/                {mfnp01.i cs_mstr csset cs_set ""SIM"" cs_type cs_type}
/*F206*/             end.
/*F206*/             else do:
                        {mfnp.i cs_mstr csset cs_set csset cs_set cs_set}
/*F206*/             end.
                     if recno <> ? then do:
                        csset = cs_set.
                        display csset with frame a.
                        find cs_mstr where cs_set = csset no-lock no-error.
                        method = "".
                        if available cs_mstr then do:
                           method = "[ " + cs_method + " / " + cs_type + " ]".
                           display cs_desc method with frame a.
                        end.
                        recno = ?.
                     end.
                  end.

                  if csset = "" then do:
                     {mfmsg.i 40 3}  /*Blank not allowed*/
                     next-prompt csset.
                     undo, retry.
                  end.

                  find cs_mstr where cs_set = csset no-lock no-error.
                  if not available cs_mstr then do:
                     {mfmsg.i 5407 3} /*Cost set does not exist*/
                     next-prompt csset.
                     undo, retry.
                  end.

/*F206*/          if transtype = "SC" then do:
/*F206*/             if not can-find(first cs_mstr where cs_set = csset
/*F206*/             and cs_type = "SIM" ) then do:
/*f206*/                {mfmsg.i 5405 3} /*Not a simulation cost set*/
/*F206*/                next-prompt csset.
/*F206*/                undo, retry.
/*F206*/             end.
/*F206*/          end.

                  method = "[ " + cs_method + " / " + cs_type + " ]".
                  display cs_desc method with frame a.
                  if cs_method = "AVG" and cs_type = "CURR" then do:
                     {mfmsg.i 5419 2} /*Roll-up will invalidate avg cost*/
                  end.
                  else if cs_method = "AVG" and cs_type = "GL" then do:
                     {mfmsg.i 5419 4} /*Roll-up will invalidate avg cost*/
                     next-prompt csset.
                     undo, retry.
                  end.
               end.

               status input.
               update
                  part part1
/*F345*/          line line1 type type1 grp grp1
                  eff_date mtl_flag lbr_flag bdn_flag ovh_flag
                  sub_flag labor_flag setup_flag audit_yn
/*F116*/          cst_flag
/*F542*/          yield_flag
               with frame a.

            end. /*if not batchrun*/

            else do:
               update
                  site csset part part1
/*F345*/          line line1 type type1 grp grp1
                  eff_date mtl_flag lbr_flag bdn_flag
                  ovh_flag sub_flag labor_flag setup_flag audit_yn
/*F116*/          cst_flag
/*F542*/          yield_flag
               with frame a.
               find si_mstr where si_site = site no-lock no-error.
            end.

            bcdparm = "".
/*G0N9*/    {gprun.i ""gpquote.p"" "(input-output bcdparm,
                     20,
                     site,
                     csset,
                     part,
                     part1,
                     line,
                     line1,
                     type,
                     type1,
                     grp,
                     grp1,
                     string(eff_date),
                                     string(mtl_flag),
                     string(lbr_flag),
                     string(bdn_flag),
                     string(ovh_flag),
                     string(sub_flag),
                     string(labor_flag),
                     string(setup_flag),
                     string(audit_yn),
                     string(cst_flag))"}

/*G0N9*/    {gprun.i ""gpquote.p"" "(input-output bcdparm,
                     1,
                     string(yield_flag),
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char)"}

/*G0N9*
.
.       {mfquoter.i site       }
.       {mfquoter.i csset      }
.       {mfquoter.i part       }
.       {mfquoter.i part1      }
.
./*F345*/    {mfquoter.i line   }
./*F345*/    {mfquoter.i line1  }
./*F345*/    {mfquoter.i type   }
./*F345*/    {mfquoter.i type1  }
./*F345*/    {mfquoter.i grp  }
./*F345*/    {mfquoter.i grp1 }
.
.       {mfquoter.i eff_date   }
.       {mfquoter.i mtl_flag   }
.       {mfquoter.i lbr_flag   }
.       {mfquoter.i bdn_flag   }
.       {mfquoter.i ovh_flag   }
.       {mfquoter.i sub_flag   }
.       {mfquoter.i labor_flag }
.       {mfquoter.i setup_flag }
.       {mfquoter.i audit_yn   }
./*F116*/    {mfquoter.i cst_flag   }
./*F542*/    {mfquoter.i yield_flag }
.
*G0N9*/

            if part1 = "" then part1 = hi_char.
/*F345*/    if line1 = "" then line1 = hi_char.
/*F345*/    if type1 = "" then type1 = hi_char.
/*F345*/    if grp1 = "" then grp1 = hi_char.

/*M1CD*/    if eff_date = ?
/*M1CD*/    then do:
/*M1CD*/       eff_date =  today.
/*M1CD*/       display eff_date with frame a.
/*M1CD*/    end. /* IF eff_date ... */

/*G681*/    /*********************ADDED FOLLOWING SECTION*********************/

        /*****************************************************************/
        /*ADDED THE FOLLOWING SECTION IN ORDER TO GENERATE A UNIQUE ID   */
        /*SO THAT ONCE AN ITEM IS ROLLED UP, IT WILL NOT BE ROLLED UP    */
        /*MULTIPLE TIMES.  SIMULTANEOUS ROLLUPS WITH THE SAME EFFECTIVE  */
        /*DATE AND FLAG SETTINGS WILL SHARE THIS UNIQUE ID.  SIMULTANEOUS*/
        /*ROLLUPS FOR THE SAME SITE/COSTSET WITH DIFFERENT EFFECTIVITIES */
        /*AND/OR FLAGS ARE PROHIBITED.                                   */
        /*****************************************************************/

            /*OUTER ERROR LOOP RETRY'S EVEN THOUGH NOTHING CHANGES*/
            transloop:
            repeat:

               /*ERROR WHEN TWO PROCESSES CREATE SIMULTANEOUS QAD_WKFL*/
               repeat transaction on error undo, retry:
                  pause 0.
                  hide message no-pause.

                  /*DELETE THE NON-ACTIVE QAD_WKFL, IF ONE EXISTS*/

/*N03B*/          /* BEGIN ADD SECTION */
                  /* IF NOT ORACLE THE FIND QAD_WKFL RECORD WITH EXCL-LOCK */
                  if l_is_oracle = no then
                  do:
                     find qad_wkfl exclusive-lock
                    where qad_key1 = "BMCSRUB"
                      and qad_key2 = site + "::" + csset
                     no-error no-wait.
                     if available qad_wkfl then delete qad_wkfl.
                  end. /* IF L_IS_ORACLE = NO */
/*N03B*/          /* END ADD SECTION */

                  /*FIND THE ACTIVE QAD_WKFL, IF ONE EXISTS*/
                  find qad_wkfl share-lock where qad_key1 = "BMCSRUB"
                          and qad_key2 = site + "::" + csset
                  no-error.

                  /*TEST TO ENSURE CONFLICT CONDITIONS DON'T EXIST*/
                  if available qad_wkfl and
                     (   qad_datefld[1] <> eff_date
                      or qad_decfld[1] <> integer(mtl_flag)
                      or qad_decfld[2] <> integer(lbr_flag)
                      or qad_decfld[3] <> integer(bdn_flag)
                      or qad_decfld[4] <> integer(ovh_flag)
                      or qad_decfld[5] <> integer(sub_flag)
                      or qad_decfld[6] <> integer(labor_flag)
                      or qad_decfld[7] <> integer(setup_flag)
                      or qad_decfld[8] <> integer(cst_flag)
                      or qad_decfld[9] <> integer(yield_flag))
                  then do:

/*N03B*/             /* BEGIN ADD SECTION */
                     do on endkey undo mainloop, retry mainloop:
                        if l_is_oracle = yes then do on error undo, retry:

                           /* ARE MULTIPLE SESSIONS ROLLING COSTS  */
                           /* FOR THE SAME SITE/COST SET?          */
                           {mfmsg01.i 3336 1 yn}
                           if yn = no then do:
                              find qad_wkfl exclusive-lock
                                 where qad_key1 = "BMCSRUB"
                                 and   qad_key2 = site + "::" + csset
                              no-error no-wait.
                              if available qad_wkfl then delete qad_wkfl.
                              else yn = yes.
                           end. /* IF YN = NO */

                        end. /* IF L_IS_ORACLE = YES */
                     end. /* ON ENDKEY UNDO MAINLOOP, RETRY MAINLOOP */

                     if l_is_oracle = no or yn = yes  then do:
                        /* CONFLICTING ROLLUP IN PROGRESS */
                        {mfmsg.i 5306 4}
                        undo mainloop, retry.
                     end. /* IF L_IS_ORACLE = NO OR YN = YES */
/*N03B*/             /* END ADD SECTION */

                  end. /* IF AVAILABLE QAD_WKFL */

                  /*FIRST PROCESS CREATES NEW QAD_WKFL*/
/*N03B**          else if not available qad_wkfl then do:        */
/*N03B*/          if not available qad_wkfl then do:
                     create qad_wkfl.
                     assign
                        qad_key1       = "BMCSRUB"
                        qad_key2       = site + "::" + csset
                        qad_datefld[1] = eff_date
                        qad_decfld[1]  = integer(mtl_flag)
                        qad_decfld[2]  = integer(lbr_flag)
                        qad_decfld[3]  = integer(bdn_flag)
                        qad_decfld[4]  = integer(ovh_flag)
                        qad_decfld[5]  = integer(sub_flag)
                        qad_decfld[6]  = integer(labor_flag)
                        qad_decfld[7]  = integer(setup_flag)
                        qad_decfld[8]  = integer(cst_flag)
/*N03B*/                qad_charfld[1] = mfguser
                        qad_decfld[9]  = integer(yield_flag).

/*GI54               do i = 1 to 8:                                          */
/*GI54                  substring(qad_key3,i,1) = substring                  */
/*GI54                     ("ABCDEFGHIJKLMNOPQRSTUVWXYZ",random(1,26),1).    */
/*GI54               end.                                                    */

                     /*PROGRAM DEFINED DATE FORMAT TO AVOID CONFLICT BETWEEN */
                     /*USERS WITH A DIFFERENT -d DATE DEFAULT                */
/*GI54*/             qad_key3 = substring(string(year(today),"9999"),3,2)
/*GI54*/                      + string(month(today),"99")
/*GI54*/                      + string(day(today),"99")
/*GI54*/                      + " "
/*GI54*/                      + string(time).

                  end.

                  rollup_id = qad_key3.
                  leave transloop.

               end.

               hide message no-pause.
               pause 0.

            end.
/*G681*/    /*********************ADDED PRECEDING SECTION*********************/

            if audit_yn then do:
               {mfselbpr.i "printer" 132 }
               {mfphead.i}
            end.
            else if not batchrun then do:
               yn = yes.
               {mfmsg01.i 207 1 yn} /*Begin cost roll-up ? */
               if not yn then undo, retry.
            end.

            if mtl_flag or lbr_flag or bdn_flag or ovh_flag or sub_flag
            or labor_flag or setup_flag then do:

/*G681********************DELETE FOLLOWING SECTION***************************
 &          find first pt_mstr no-lock where pt_part < part no-error.
 *          if not available pt_mstr then
 *          find first pt_mstr no-lock where pt_part > part1 no-error.
 *          if not available pt_mstr
 * /*F345*/       /* disable this option until low-level conflicts resolved   */
 * /*F542*/       /* all patches added to bncsrub.p must be incorporated into */
 * /*F542*/       /* bmcsrua.p option is re-activated.  Included are "D" type */
 * /*F542*/       /* pt_pm_codes, ptp_det record, and revised yield % calcu-  */
 * /*F542*/       /* lations and include/exclude yield percent option.        */
 * /*F345*/       and false
 *          then do:
 *         {gprun.i ""bmcsrua.p""}
 *          end.
 *          else do:
 *         {gprun.i ""bmcsrub.p""}
 *          end.
 **G681********************DELETE PRECEDING SECTION**************************/

/*G681*/       {gprun.i ""xxbmcsrub.p""}

            end.

/*F206*/    global_type = "".

            /* REPORT TRAILER  */
            if audit_yn then do:
               {mfrtrail.i}
            end.


/*G681*/    /*SCOPE QAD_WKFL TO MAINLOOP*/

/*N03B*/    /* BEGIN ADD SECTION */
            do transaction:
               find qad_wkfl
                  where qad_key1       = "BMCSRUB" and
                        qad_key2       = site + "::" + csset and
                        qad_key3       = rollup_id and
                        qad_charfld[1] = mfguser
               exclusive-lock no-error.
               if available qad_wkfl then
                  delete qad_wkfl.
            end. /* DO TRANSACTION */
/*N03B*/    /* END ADD SECTION */

/*G681*/    release qad_wkfl.

         end.
