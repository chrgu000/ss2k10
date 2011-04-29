/* icloiq01.p - LOCATION PART INQUIRY                                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert icloiq01.p (converter v1.00) Fri Oct 10 13:57:46 1997 */
/* web tag in icloiq01.p (converter v1.00) Mon Oct 06 14:18:21 1997 */
/*F0PN*/ /*K1HQ*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 6.0      LAST MODIFIED: 05/11/90   BY: PML */
/* REVISION: 6.0      LAST MODIFIED: 05/18/90   BY: WUG */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887**/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: pma *F361**/
/* REVISION: 7.0      LAST MODIFIED: 05/26/92   BY: pma *F528**/
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: pma *F751**/
/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F767**/
/* REVISION: 7.0      LAST MODIFIED: 09/15/92   BY: pma *F897**/
/* Revision: 7.3        Last edit: 11/19/92     By: jcd *G339* */
/* REVISION: 7.3      LAST MODIFIED: 12/23/93   BY: ais *GI30**/
/* REVISION: 7.3      LAST MODIFIED: 09/14/94   BY: pxd *FR03**/
/* REVISION: 7.3      LAST MODIFIED: 03/09/95   BY: pxd *F0LZ**/
/* REVISION: 8.6      LAST MODIFIED: 02/17/98   BY: *K1HQ* Beena Mol  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/*K1HQ*/ /* DISPLAY TITLE */
/*K1HQ*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE icloiq01_p_1 "批/序号!参考"
/* MaxLen: Comment: */

&SCOPED-DEFINE icloiq01_p_2 "有效库存量"
/* MaxLen: Comment: */

&SCOPED-DEFINE icloiq01_p_3 "/no"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable part like pt_part.
     define variable loc like ld_loc.
     define variable site like ld_site.
     define variable stat  like ld_status.
     define variable lot like ld_lot.
     define variable lotref like ld_ref.

/*K1HQ* /* DISPLAY TITLE */
 * {mfdtitle.i "e+ "} */


/*FR03*/  find first icc_ctrl no-lock no-error.
/*FR03*/ if available icc_ctrl and global_site = "" then global_site = icc_site.

     part = global_part.
/*F751*/ site = global_site.

     form
        part
        site
        loc
        lot
        stat
/*F0LZ      with frame a no-underline.  */
/*F0LZ*/    with frame a no-underline width 80.

/*K1HQ*/ {wbrp01.i}

         repeat:

/*K1HQ*/ if c-application-mode <> 'web':u then
           update part site loc lot stat with frame a editing:

/*FR03/*F897*/       global_site = input site.                 */
/*FR03/*F897*/       global_loc = input loc.                   */


/*FR03*/         if input part <> "" then global_part = input part.
/*FR03*//*F897*/ if input site <> "" then global_site = input site.
/*FR03*//*F897*/ if input loc <>  "" then global_loc  = input loc.

           if frame-field = "part" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i pt_mstr part pt_part part pt_part pt_part}
          if recno <> ? then do:
             part = pt_part.
             display part with frame a.
          end.
           end.
           else if frame-field = "site" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i si_mstr site si_site site si_site si_site}
          if recno <> ? then do:
             site = si_site.
             display site with frame a.
          end.
           end.
           else do:
          status input.
          readkey.
          apply lastkey.
           end.
        end.

/*K1HQ*/ {wbrp06.i &command = update &fields = "  part site loc lot stat"
          &frm = "a"}

/*K1HQ*/ if (c-application-mode <> 'web':u) or
/*K1HQ*/ (c-application-mode = 'web':u and
/*K1HQ*/ (c-web-request begins 'data':u)) then do:

        /* Check for exiting item number */
        if not can-find(first pt_mstr where pt_part = part) then do:
           {mfmsg.i 16  3}
/*K1HQ*/       if c-application-mode = 'web':u then return.
/*K1HQ*/       else next-prompt part with frame a.
           undo.
        end.
        hide frame b.
        hide frame c.

/*K1HQ*/ end.

        /* SELECT PRINTER */
            {mfselprt.i "terminal" 80}

        loopa:
        for each in_mstr no-lock where in_part = part
        and (in_site = site or site = "")
        and (can-find(first ld_det where ld_part = in_part
                     and ld_site = in_site
                     and ld_loc = loc) or loc = ""):
                {mfrpchk.i}                     /*G339*/

           find pt_mstr no-lock where pt_part = in_part.
           
           display   pt_desc1  in_site pt_um
           space(3)
/*GI30*        in_qty_oh label "QOH Nettable"                             */
/*GI30*/       in_qty_oh column-label {&icloiq01_p_2}
/*F0LZ*/                                     format "->>>,>>>,>>9.9<<<<<<<<<"
           space(3)
           in_qty_nonet
/*F0LZ*/                                     format "->>>,>>>,>>9.9<<<<<<<<<"
           with no-underline frame b width 80.
/*F767/*F528*/ pause 0.  */

           for each ld_det no-lock where ld_part = pt_part
          and ld_site = in_site
          and (ld_loc = loc or loc = "" )
          and (ld_status = stat or stat = "")
          and (ld_lot = lot or lot = "")
           on endkey undo, leave loopa with frame c width 180:
                {mfrpchk.i}                     /*G339*/

/*F767/*F528*/    pause before-hide. */
          find is_mstr where is_status  = ld_status no-lock no-error.
          find loc_mstr where loc_loc = ld_loc no-lock no-error.
          display  ld_loc loc_desc ld_lot 
          column-label {&icloiq01_p_1}

/*F361            if ld_ref ne " " then down 1.         */
/*F361            display ld_ref format "x(8)" @ ld_lot */

          ld_status

/*F0LZ            ld_date ld_expire ld_qty_oh ld_grade.  */
/*F0LZ*/          ld_date 
                  /*ld_expire*/
                  ld_qty_oh
/*F0LZ*/          format "->>>,>>>,>>9.9<<<<<<<<<"
/*F0LZ*/          ld_grade.

          if available is_mstr then display is_net format {&icloiq01_p_3}.

/*F361*/          if ld_ref <> "" then do with frame c:
/*F361*/             down 1.
/*F361*/             display ld_ref format "x(8)" @ ld_lot.
/*F361*/          end.

           end.
        end.
        global_part = part.
/*F751*/    global_site = site.
 
        
        /*LW {mfreset.i}*/
 /*LW*/ {mfguirex.i }.
 /*LW*/ {mfguitrl.i}.
 /*LW*/ {mfgrptrm.i} .

        {mfmsg.i 8 1}
     end.

/*K1HQ*/ {wbrp04.i &frame-spec = a}
