/* GUI CONVERTED from ppptmta1.p (converter v1.69) Mon Jul  7 18:02:18 1997 */
/* ppptmta1.p - ITEM MAINTENANCE SUBROUTINE ENGINEERING DATA            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0      LAST MODIFIED: 06/22/92   BY: emb *F687*          */
/* REVISION: 7.0      LAST MODIFIED: 10/29/92   BY: pma *G249*          */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: pma *H055*          */
/* REVISION: 7.4      LAST MODIFIED: 10/07/93   BY: pma *H165*          */
/* REVISION: 7.4      LAST MODIFIED: 02/16/94   BY: pxd *FL60*          */
/* REVISION: 7.2      LAST MODIFIED: 04/07/94   BY: pma *FN30*          */
/* REVISION: 7.4      LAST MODIFIED: 05/13/94   BY: qzl *H370* sr102019 */
/* REVISION: 7.2      LAST MODIFIED: 06/06/94   BY: ais *FO63*          */
/*           7.3                     09/03/94   BY: bcm *GL93*          */
/* REVISION: 8.5      LAST MODIFIED: 02/01/95   BY: tjm *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 07/27/95   BY: kxn *J05Z*          */
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   BY: tjs *J088*          */
/* REVISION: 7.4      LAST MODIFIED: 11/27/95   BY: bcm *F0WC*          */
/* REVISION: 7.4      LAST MODIFIED: 11/30/95   BY: bcm *H0HH*          */
/* REVISION: 8.5      LAST MODIFIED: 10/30/95   by: bholmes *J0FY*      */
/* REVISION: 8.5      LAST MODIFIED: 06/26/96   BY: RWitt   *F0XC*      */
/* REVISION: 8.5   LAST MODIFIED: 03/06/97   BY: *G2LB* Jack Rief       */
/* REVISION: 8.5   LAST MODIFIED: 06/24/97   BY: *G2NM* Murli Shastri   */
/* REVISION: 8.5   LAST MODIFIED: 06/24/97   BY: *G2NS* Maryjeane Date  */
/* REVISION: 8.5      LAST MODIFIED: 01/17/04   BY: Kevin      */
/*Notes(Kevin): protect the 'product line' field. If the user of 
                product department create a new part, he/she can't
                maintain the pt_prod_line field. We just assign a
                default value "8888" to it*************************/


         {mfdeclre.i}
         define shared variable new_part like mfc_logical.
         define shared frame a1.
/*G249*/ define shared variable inrecno as recid.
/*G249*/ define shared variable sct1recno as recid.
/*G249*/ define shared variable sct2recno as recid.
/*FN30*/ define shared variable undo_all like mfc_logical no-undo.

         FORM /*GUI*/ 
         
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta2.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame a1 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a1-title AS CHARACTER.
 F-a1-title = " Áã¼þÊý¾Ý ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 = F-a1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a1 =
  FRAME a1:HEIGHT-PIXELS - RECT-FRAME:Y in frame a1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a1 = FRAME a1:WIDTH-CHARS - .5. /*GUI*/


               loopa1:
               do transaction on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J05Z*           find pt_mstr exclusive where recid(pt_mstr) = pt_recno */
/*J05Z*/          find pt_mstr exclusive-lock where recid(pt_mstr) = pt_recno
                  no-error.
                  if not available pt_mstr then leave.

                  ststatus = stline[3].
                  status input ststatus.

                     display
                        pt_prod_line pt_added pt_rev pt_draw
/*H055*/                pt_dsgn_grp pt_drwg_loc pt_drwg_size
                        pt_part_type pt_status pt_group
/*J042*/                pt_break_cat
                     with frame a1.

                     prodloop:
                     do on error undo, retry with frame a1:
/*GUI*/ if global-beam-me-up then undo, leave.


/*G2NM*                 ** BEGIN DELETE SECTION **
./*G2LB*                 ** BEGIN ADD SECTION **/
.                        assign pt_prod_line pt_added pt_dsgn_grp
.                          pt_part_type pt_status pt_group pt_draw
.			  pt_rev pt_drwg_loc pt_drwg_size pt_break_cat.
./*G2LB*                 ** END ADD SECTION   **/
*G2NM*                 ** END DELETE SECTION   **/

/*G2LB*                 set    */
/*G2NS* /*G2LB*/        update */

/*G2NS*/                set
                           /*pt_prod_line */                        /*marked by kevin,01/17/2004*/
                           pt_added
/*H055                     pt_rev pt_draw  */
/*H055*/                   pt_dsgn_grp
/*H370* DELETED SECTION **
./*H165*/                   validate
./*H165*/                   (can-find (first ecl_list where ecl_type = "30"
./*H165*/                                    and ecl_group = pt_dsgn_grp) or
./*H165*/                   not can-find (first ecl_list where ecl_type = "30"),
./*H165*/                   "DESIGN GROUP DOES NOT EXIST. Please re-enter.")
 *H370** END DELETED SECTION */
/*J088* /*J042*/           pt_break_cat */
                           pt_part_type pt_status pt_group
/*H055*/                   pt_draw pt_rev pt_drwg_loc pt_drwg_size
/*J088*/                   pt_break_cat
                        with frame a1.

/*H0HH** /*H370*/       if pt_dsgn_grp <> "" and not can-find(first ecl_list **/
/*H0HH*/                if pt_dsgn_grp <> "" and
/*H0HH*/                can-find(first ecl_list where ecl_type = "30") and
/*H0HH*/                not can-find(first ecl_list
/*H370*/                where ecl_type = "30" and ecl_group = pt_dsgn_grp)
/*H370*/                then do:
/*H370*/                   /* Desing group does not exist */
/*H370*/                   {mfmsg.i 5607 3}
/*H370*/                   next-prompt pt_dsgn_grp.
/*H370*/                   undo prodloop, retry prodloop.
/*H370*/                end.

/*F0XC*                 IF NO ITEM STATUS CODE VALIDATION RECORDS EXIST    */
/*F0XC*                 DO NOT VALIDATE STATUS ENTERED...                  */
/*F0XC*/                if can-find (first qad_wkfl
/*F0XC*/                where qad_key1 = "PT_STATUS") then do:
                           find qad_wkfl where qad_key1 = "PT_STATUS"
                           and qad_key2 = pt_status no-error.
                           if not available qad_wkfl then do:
/*F0XC*                      {mfmsg.i 362 2}  * warn: status does not exist */
/*F0XC*/                     {mfmsg.i 362 4} /* error: status does not exist */
/*F0XC*/                     next-prompt pt_status.
/*F0XC*/                     undo, retry.
/*F0XC*/                   end.
                        end.

                        /*Used share-lock status below in order to prevent */
                        /*finding a pl_mstr record that is in the process  */
                        /*of being created.                                */
                        find pl_mstr where pl_prod_line = pt_prod_line
                        no-error no-wait.
                        if locked pl_mstr then do:
                           {mfmsg.i 248 2}  /* pl_mstr being changed */
                           pause 5.
                           undo prodloop, retry.
                        end.
                     end.
/*GUI*/ if global-beam-me-up then undo, leave.


                     if new_part then do:
                        pt_taxc = pl_taxc.
                        pt_taxable = pl_taxable.
/*G249*/                find in_mstr no-lock where in_part = pt_part
/*G249*/                and in_site = pt_site no-error.
/*G249*/                if not available in_mstr then do:
/*G249*/                   create in_mstr.
/*G249*/                   assign
/*G249*/                   in_part = pt_part
/*G249*/                   in_site = pt_site
/*G249*/                   in_mrp  = yes
/*FL60*/                   in_level = 99999
/*G249*/                   pt_mrp  = yes
/*FO63*  /*G249*/          in_abc = pt_abc                      */
/*FO63*/                   in_abc = if pt_abc <> "" and pt_abc <> ?
/*F0WC*/                            then pt_abc else ""
/*F0WC** /*FO63*/                   then pt_abc else ? **/
/*G249*/                   in_avg_int = pt_avg_int
/*J0FY**** /*G249*/        in_cyc_int = pt_cyc_int.    ****/
/*J0FY*/ /* had to rem out the above and replace it with what is below.  this
        was causing a problem because the pt_cyc_int was defaulting to a value.
        When the ppptmtb.p program would check the in_mstr file it would say
        if in_mstr field = null then send the pt_mstr field.  By doing the
        below line this will force the in_mstr field to be set to the pt_mstr
        field
        */
/*J0FY*/ in_cyc_int = ?.
/*G249*/
/*G249*/                   find si_mstr where si_site = in_site
/*G249*/                   no-lock no-error.
/*G249*/                   if available si_mstr
/*G249*/                   then assign in_gl_set = si_gl_set
/*G249*/                              in_cur_set = si_cur_set.
/*G249*/


/*FL60/*G249*/ *           find ptp_det no-lock where ptp_part = pt_part
/*G249*/       *           and ptp_site = pt_site no-error.
/*G249*/       *           if available ptp_det then do:
/*G249*/       *              if ptp_pm_code = "D" then in_level = ptp_ll_drp.
/*G249*/       *              else in_level = ptp_ll_bom.
/*G249*/       *           end.
/*G249*/       *           else if pt_pm_code <> "D" then in_level = pt_ll_code.
               *                                            FL60*/

/*G249*/                end. /*if not available in_mstr*/
/*G249*/                inrecno = recid(in_mstr).

/*G249*/                {gpsct04.i &type=""GL""}
/*G249*/                sct1recno = recid(sct_det).
/*G249*/                {gpsct04.i &type=""CUR""}
/*G249*/                sct2recno = recid(sct_det).
                     end. /*if new part then do*/
/*FN30*/             undo_all = no.
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.

