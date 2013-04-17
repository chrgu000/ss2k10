/* repkrp.p - REPETITIVE PICKLIST REPORT                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert repkrp.p (converter v1.00) Fri Oct 10 13:57:18 1997 */
/* web tag in repkrp.p (converter v1.00) Mon Oct 06 14:17:43 1997 */
/*F0PN*/ /*K0SR*/ /*                                                    */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: emb *G071*          */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G348*  */
/* Revision: 7.3        Last edit:   11/22/94   By: qzl *GO59*          */
/* Revision: 7.3        Last edit:   02/08/95   by: srk *G0DP*          */
/* Revision: 8.6      LAST MODIFIED: 10/11/97   by: bvm *K0SR*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb              */
/* $Revision: 1.7.1.2.3.1 $      BY: Max Iles        DATE: 11/02/04   ECO: *N2YN*  */

          {mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE repkrp_p_1 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp_p_2 "Sequence"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp_p_3 "Seq"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp_p_4 "Picklist"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          define variable nbr like lad_nbr format "x(10)" label {&repkrp_p_4}.
          define variable nbr1 like lad_nbr format "x(10)".

          define variable seq as integer format ">>>" label {&repkrp_p_2}.
          define variable seq1 like seq.

          define variable wkctr like op_wkctr.
          define variable wkctr1 like wkctr.
          define variable comp like ps_comp.
          define variable comp1 like ps_comp.
          define variable site like lad_site.
          define variable site1 like lad_site.
          define variable desc1 like pt_desc1.
          define variable desc2 like pt_desc1.

          define variable um like pt_um.
          /*GO59*/ define shared variable global_recid as recid.

          site = global_site.
          site1 = global_site.

          form
             site           colon 20
             site1          label {t001.i} colon 49 skip
             nbr            colon 20
             nbr1           label {t001.i} colon 49 skip
             seq            colon 20
             seq1           label {t001.i} colon 49 skip
             comp           colon 20
             comp1          label {t001.i} colon 49 skip
             wkctr          colon 20
             wkctr1         label {t001.i} colon 49 skip(1)
          with frame a side-labels width 80 attr-space.

          /* SET EXTERNAL LABELS */
          setFrameLabels(frame a:handle).

/*K0SR*/ {wbrp01.i}

/*G0DP* main: repeat on error undo, retry: */
/*G0DP*/ repeat:

   if nbr1  = hi_char then nbr1  = "".
   if comp1 = hi_char then comp1 = "".
   if wkctr1 = hi_char then wkctr1 = "".
   if site1 = hi_char then site1 = "".
   if seq1 = 999 then seq1 = 0.

/*GO59*/ global_recid = ?.

/*K0SR*/ if c-application-mode <> 'web' then
   update site
      site1
      nbr
      nbr1
      seq
      seq1
      comp
      comp1
      wkctr
      wkctr1
/*GO59*   with frame a. */
/*GO59*/ with frame a editing:

/*GO59*/    if frame-field = "nbr" and global_recid <> ? then do:
/*GO59*/       find lad_det where recid(lad_det) =
/*GO59*/       global_recid no-lock no-error.
/*GO59*/       if available lad_det then
/*GO59*/       display substring(lad_nbr,9) @ nbr with frame a.
/*GO59*/       global_recid = ?.
/*GO59*/    end.
/*GO59*/    else if frame-field = "nbr1" and global_recid <> ? then do:
/*GO59*/       find lad_det where recid(lad_det) =
/*GO59*/       global_recid no-lock no-error.
/*GO59*/       if available lad_det then
/*GO59*/       display substring(lad_nbr,9) @ nbr1 with frame a.
/*GO59*/       global_recid = ?.
/*GO59*/    end.
/*GO59*/    readkey.
/*GO59*/    apply lastkey.
/*GO59*/ end.

/*K0SR*/ {wbrp06.i &command = update &fields = "  site site1 nbr nbr1 seq seq1 comp
comp1 wkctr wkctr1  " &frm = "a"}

/*K0SR*/ if (c-application-mode <> 'web') or
/*K0SR*/ (c-application-mode = 'web' and
/*K0SR*/ (c-web-request begins 'data')) then do:

   bcdparm = "".
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

/*G0DP*   assign nbr nbr1. */ /*UNNECESSARY*/

   if nbr1  = "" then nbr1  = hi_char.
   if comp1 = "" then comp1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if wkctr1  = "" then wkctr1 = hi_char.
   if seq1 = 0 then seq1 = 999.

/*K0SR*/ end.

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}
   {mfphead.i}

   if seq <> 0 then nbr = string(nbr,"x(10)") + string(seq,"999").

   /* FIND AND DISPLAY */
   for each lad_det no-lock where lad_dataset = "rps_det"
   and lad_nbr >= string(site,"x(8)") + nbr
   and lad_nbr <= string(site1,"x(8)") + nbr1
   and substring(lad_nbr,9) >= nbr
   and substring(lad_nbr,9) <= nbr1
   and lad_line >= wkctr and lad_line <= wkctr1
   and lad_part >= comp and lad_part <= comp1
   and lad_site >= site and lad_site <= site1
   break by lad_dataset by lad_nbr
   by lad_line by lad_part by lad_loc by lad_lot
   with frame b width 132 no-attr-space down no-box:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}                     /*G348*/

/*K0SR* form header skip(1) with frame top page-top. **/
/*K0SR*/ form header skip(1) with frame top page-top width 132.
      view frame top.

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
     substring(lad_nbr,9) @ nbr column-label {&repkrp_p_4}
     substring(lad_nbr,19) format "x(3)" label {&repkrp_p_3}
     lad_line @ wc_wkctr
     with frame b.

     display lad_part format "x(27)"
     lad_site lad_loc lad_lot
     lad_ref column-label {&repkrp_p_1}
     lad_qty_all
     lad_qty_pick
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
     lad_ref column-label {&repkrp_p_1}
     lad_qty_all
     lad_qty_pick
     um
     with frame b.

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

   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.  /* REPEAT */

/*K0SR*/ {wbrp04.i &frame-spec = a}
