/* repkdel.p - REPETITIVE PICKLIST ALLOCATION DELETE                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.3       LAST MODIFIED: 09/06/92   BY: emb *G071*         */
/* Oracle changes (share-locks)       09/12/94   BY: rwl *FR25*         */
/* Revision: 7.3        Last edit: 11/22/94           By: qzl *GO59*    */
/* REVISION: 7.5       LAST MODIFIED: 01/03/95   BY: mwd *J034*         */
/* REVISION: 7.5       LAST MODIFIED: 01/04/95   BY: srk *G0B8*         */
/* REVISION: 8.5       LAST MODIFIED: 06/20/96   BY: taf *J0VG*         */
/* REVISION: 8.5    LAST MODIFIED: 09/05/96 BY: *G2BR* Julie Milligan   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb              */
/************************************************************************/
/*J034*  ** MOVED MFDTITLE.I UP FROM BELOW */
         /* DISPLAY TITLE */
{mfdtitle.i "120625.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE repkdel_p_1 "Sequence"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkdel_p_2 "Picklist"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define variable nbr as character format "x(10)" label {&repkdel_p_2}.
         define variable nbr1 like nbr.
         define variable seq as integer label {&repkdel_p_1} format ">>>".
         define variable seq1 like seq.
         define variable wkctr like op_wkctr.
         define variable wkctr1 like wkctr.
         define variable comp like ps_comp.
         define variable comp1 like ps_comp.
         define variable dte   as date.
         define variable dt1  as date.
         define variable site like lad_site.
         define variable site1 like lad_site.
         define variable desc1 like pt_desc1.
         define variable desc2 like pt_desc1.

         define variable um like pt_um.
/*GO59*/  define shared variable global_recid as recid.

         form
            site           colon 20
            site1          label {t001.i} colon 49 skip
            nbr            colon 20
            nbr1           label {t001.i} colon 49 skip
            seq            colon 20
            seq1           label {t001.i} colon 49 skip
            comp           colon 20
            comp1          label {t001.i} colon 49 skip
            dte            colon 20
            dt1           label {t001.i} colon 49 skip
            wkctr          colon 20
            wkctr1         label {t001.i} colon 49 skip(1)
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         assign site = global_site
                site1 = global_site.

/*G0B8*   main: repeat on error undo, retry: */
/*G0B8*/  repeat:

            if nbr1  = hi_char then nbr1  = "".
            if comp1 = hi_char then comp1 = "".
            if wkctr1 = hi_char then wkctr1 = "".
            if site1 = hi_char then site1 = "".
            if dte = low_date then dte = ?.
            if dt1 = hi_date then dt1 = ?.
            if seq1 = 999 then seq1 = 0.

/*GO59*/ global_recid = ?.
   update site
      site1
      nbr
      nbr1
      seq
      seq1
      comp
      comp1
      dte
      dt1
      wkctr
      wkctr1
/*GO59*   with frame a. */
/*GO59*/ with frame a editing:
/*GO59*/    if frame-field = "nbr" and global_recid <> ? then do:
/*GO59*/       find lad_det where recid(lad_det) =
/*G2BR* /*GO59*/       global_recid no-lock no-error. */
/*G2BR*/       global_recid exclusive-lock no-error.
/*GO59*/       if available lad_det then
/*GO59*/       display substring(lad_nbr,9) @ nbr with frame a.
/*GO59*/       global_recid = ?.
/*GO59*/    end.
/*GO59*/    else if frame-field = "nbr1" and global_recid <> ? then do:
/*GO59*/       find lad_det where recid(lad_det) =
/*G2BR* /*GO59*/       global_recid no-lock no-error. */
/*G2BR*/       global_recid exclusive-lock no-error.
/*GO59*/       if available lad_det then
/*GO59*/       display substring(lad_nbr,9) @ nbr1 with frame a.
/*GO59*/       global_recid = ?.
/*GO59*/    end.
/*GO59*/    readkey.
/*GO59*/    apply lastkey.
/*GO59*/ end.

/*G0B8*/ bcdparm = "".
            {mfquoter.i site    }
            {mfquoter.i site1   }
            {mfquoter.i nbr     }
            {mfquoter.i nbr1    }
            {mfquoter.i seq     }
            {mfquoter.i seq1    }
            {mfquoter.i comp    }
            {mfquoter.i comp1   }
            {mfquoter.i wkctr   }
            {mfquoter.i wkctr1  }

/*J0VG********************MOVED SECTION BELOW QUOTER CALLS *******************/
/*J034*  ** MOVED HI_ VALUES SETTINGS + SITE RANGE CHECKS ABOVE QUOTER CALLS */
/*J034*/    if nbr1  = "" then nbr1  = hi_char.
/*J034*/    if comp1 = "" then comp1 = hi_char.
/*J034*/    if site1 = "" then site1 = hi_char.
/*J034*/    if wkctr1  = "" then wkctr1 = hi_char.
/*J034*/    if dte = ? then dte = low_date.
/*J034*/    if dt1 = ? then dt1 = hi_date.
/*J034*/    if seq1 = 0 then seq1 = 999.

/*J034*/    if not batchrun then do:
/*J034*/       {gprun.i ""gpsirvr.p""
                "(input site, input site1, output return_int)"}
/*J034*/       if return_int = 0 then do:
/*J034*/          next-prompt site with frame a.
/*J034*/          undo, retry.
/*J034*/       end.
/*J034*/    end.
/*J0VG********************MOVED SECTION BELOW QUOTER CALLS *******************/

/*J034*     if nbr1  = "" then nbr1  = hi_char. * MOVED UP ABOVE */
/*J034*     if comp1 = "" then comp1 = hi_char. * MOVED UP ABOVE */
/*J034*     if site1 = "" then site1 = hi_char. * MOVED UP ABOVE */
/*J034*     if wkctr1  = "" then wkctr1 = hi_char. * MOVED UP ABOVE */
/*J034*     if seq1 = 0 then seq1 = 999.           * MOVED UP ABOVE */

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

            if seq <> 0 then nbr = string(nbr,"x(10)") + string(seq,"999").
            nbr1 = string(nbr1,"x(10)") + string(seq1,"999").

            /* FIND AND DISPLAY */
         /*FR25*/ for each lad_det exclusive-lock where lad_dataset = "rps_det"
            and lad_nbr >= string(site,"x(8)") + nbr
            and lad_nbr <= string(site1,"x(8)") + nbr1
            and substring(lad_nbr,9) >= nbr
            and substring(lad_nbr,9) <= nbr1
            and lad_line >= wkctr and lad_line <= wkctr1
            and lad_part >= comp and lad_part <= comp1
            and lad_site >= site and lad_site <= site1
            break by lad_dataset by lad_nbr
            by lad_line by lad_part by lad_loc by lad_lot
            with frame b width 132 no-attr-space down:

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).

               if first-of (lad_part) then do:

                  assign desc1 = ""
                     desc2 = ""
                     um = "".

                  find pt_mstr no-lock where pt_part = lad_part no-error.
                  if available pt_mstr then assign
                     desc1 = pt_desc1
                     desc2 = pt_desc2
                     um = pt_um.

                  if (page-size - line-counter < 2 and (desc1 > "" or desc2 > ""))
                  or (page-size - line-counter < 3 and (desc1 > "" and desc2 > ""))
                  then page.

                  display
                  substring(lad_nbr,1,8) @ site
                  substring(lad_nbr,9) @ nbr
                  substring(lad_nbr,19) @ seq
                  lad_line @ wc_wkctr
                  with frame b.

                  display lad_part format "x(27)"
                  lad_site lad_loc lad_lot
                  lad_qty_all + lad_qty_pick @ lad_qty_chg
                  um
                  with frame b.

               end.
               else do:

                  if desc1 > "" then do:
                     display "   " + desc1 @ lad_part with frame b.
                     desc1 = "".
                  end.
                  else if desc2 > "" then do:
                     display "   " + desc2 @ lad_part with frame b.
                     desc2 = "".
                  end.

                  display lad_site lad_loc lad_lot
                  lad_qty_all + lad_qty_pick @ lad_qty_chg
                  um
                  with frame b.

               end.

               if lad_qty_all <> 0 or lad_qty_pick <> 0 then do:

                  find ld_det where ld_site = lad_site
                  and ld_loc = lad_loc
                  and ld_part = lad_part
                  and ld_lot = lad_lot
                  and ld_ref = lad_ref
                  no-error.

                  if available ld_det then
                     ld_qty_all = ld_qty_all - lad_qty_all - lad_qty_pick.

                  find in_mstr where in_site = lad_site
                  and in_part = lad_part no-error.

                  if available in_mstr then
                     in_qty_all = in_qty_all - lad_qty_all - lad_qty_pick.
               end.

               if last-of (lad_part)
               then do with frame b:
                  if desc1 > "" then do:
                     down 1 with frame b.
                     display "   " + desc1 @ lad_part with frame b.
                     desc1 = "".
                  end.
                  if desc2 > "" then do:
                     down 1 with frame b.
                     display "   " + desc2 @ lad_part with frame b.
                     desc2 = "".
                  end.
                  if not last (lad_dataset) then down 1.
               end.

               delete lad_det.

            end.
       for each xxwa_det exclusive-lock where
                xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
                xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and
                xxwa_part >= comp and (xxwa_part <= comp1 or comp1 = "") and
                xxwa_nbr >= nbr and (xxwa_nbr <= nbr1 or nbr1 = "") and
                xxwa_date >= dte and xxwa_date <= dt1:
          delete xxwa_det.
       end.
       for each xxwd_det exclusive-lock where 
                xxwd_nbr >= nbr and (xxwd_nbr <= nbr1 or nbr1 = "") and
                xxwd_site >= site and (xxwd_site <= site1 or site1 = ?) and
                xxwd_line >= wkctr and (xxwd_line <= wkctr1 or wkctr1 = "") and
                xxwd_date >= dte and xxwd_date <= dt1:
            delete xxwd_det.
       end.
       
for each usrw_wkfl exclusive-lock where usrw_key1 = "xxrepkup0.p":
delete usrw_wkfl.
end.

/*删除缺料明细资料*/
for each usrw_wkfl exclusive-lock where usrw_key1 = "XXMRPPORP0.P-SHORTAGELIST"
		 and usrw_key4 >= wkctr and usrw_key4 <= wkctr1
		 and usrw_datefld[1] >= dte and usrw_datefld[1] <= dt1:
		 delete usrw_wkfl.
end.

       
/*       
       for each qad_wkfl where qad_key1 = "xxrepkup0.p"
           and qad_charfld[1] >= site and qad_charfld[1] <= site1
           and qad_charfld[2] >= wkctr and qad_charfld[2] <= wkctr1:
           delete qad_wkfl.
       end.
*/
            /* REPORT TRAILER  */
            {mfrtrail.i}

         end.  /* REPEAT */
