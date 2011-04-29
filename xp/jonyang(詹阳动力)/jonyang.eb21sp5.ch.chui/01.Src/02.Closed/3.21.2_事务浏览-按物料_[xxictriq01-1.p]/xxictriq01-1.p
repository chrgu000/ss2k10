/* xxictriq01.p - TRANSACTION INQUIRY                                     */
/* GUI CONVERTED from ictriq01.p (converter v1.71) Tue Oct  6 14:32:06 1998 */
/* ictriq01.p - TRANSACTION INQUIRY                                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert ictriq01.p (converter v1.00) Fri Oct 10 13:57:47 1997 */
/* web tag in ictriq01.p (converter v1.00) Mon Oct 06 14:18:22 1997 */
/*F0PN*/ /*K1HD*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 6.0      LAST MODIFIED: 05/11/90   BY: PML                 */
/* REVISION: 7.0      LAST MODIFIED: 02/07/92   BY: pma *F188*          */
/* REVISION: 7.0      LAST MODIFIED: 06/06/92   BY: pma *F583*          */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: pma *F619*          */
/* REVISION: 7.0      LAST MODIFIED: 07/10/92   BY: pma *F751*          */
/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F768*          */
/* REVISION: 7.3      LAST MODIFIED: 08/11/92   BY: tjs *G028*          */
/* REVISION: 7.3      LAST MODIFIED: 10/23/92   BY: pma *G225*          */
/* Revision: 7.3      Last edit:     11/19/92   By: jcd *G345*          */
/* REVISION: 7.3      LAST MODIFIED: 03/20/93   BY: pma *G851*          */
/* REVISION: 7.3      LAST MODIFIED: 07/23/93   BY: qzl *GD65*          */
/*           7.3                     09/10/94   BY: bcm *GM02*          */
/*           7.3                     09/18/94   BY: qzl *FR49*          */
/*           7.3                     10/18/94   BY: qzl *GN38*          */
/* REVISION: 7.3      LAST MODIFIED: 02/01/95   BY: pxd *F0GN*          */
/* REVISION: 8.6      LAST MODIFIED: 02/13/98   BY: *K1HD* Beena Mol    */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */


/*----rev history-------------------------------------------------------------------------------------*/
/*升级后版本*/
/* SS - 100601.1  By: Roger Xiao */  /*加字段tr__chr01:领料单号*/
/* SS - 101020.1  By: Roger Xiao */  /*加领料单号宽度到10位*/
/*-Revision end---------------------------------------------------------------*/


/*K1HD*/ /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*K1HD*/ {mfdtitle.i "101020.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ictriq01_p_1 "库存量"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictriq01_p_2 "地点:"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictriq01_p_3 "      期末结余"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable part like tr_part.
     define variable qty_oh like in_qty_oh.
     define variable tr_end like tr_begin label {&ictriq01_p_3}.
     define variable site like in_site.

/*K1HD* /* DISPLAY TITLE */
 *   {mfdtitle.i "e+ "} /*GD65*/ */

     part = global_part.
/*F751*/ site = global_site.

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        part
        site
        qty_oh  label {&ictriq01_p_1}
        pt_um
/*F583*/    no-label
        skip
/*GM02**    pt_desc1 no-label **/
/*GM02*/    pt_desc1 no-label at 2
        pt_desc2 no-label
     with frame a side-labels  width 80 attr-space.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*K1HD*/ {wbrp01.i}

        repeat:

/*K1HD*/ if c-application-mode <> 'web':u then
         update part site with frame a editing:

           if frame-field = "part" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i in_mstr part in_part part in_part  in_part}
          if recno <> ? then do:
             find pt_mstr no-lock where 
			 pt_domain = global_domain and /*---Add by davild 20090205.1*/
			 pt_part = in_part
/*F619*/             no-error.
/*F619               part = pt_part. */
             qty_oh = in_qty_oh
/*G851*/              + in_qty_nonet.
             display
/*F619*/             in_part @
             part in_site @ site qty_oh
/*F619               pt_desc1 pt_desc2 qty_oh pt_um  */
             with frame a.
/*F619*/             if available pt_mstr then
/*F619*/                display pt_desc1 pt_desc2 pt_um with frame a.
/*F619*/             else
/*F619*/                display "" @ pt_desc1 "" @ pt_desc2 "" @ pt_um
/*F619*/                with frame a.
          end.
           end.
           else do:
          status input.
          readkey.
          apply lastkey.
           end.
        end.

/*K1HD*/ {wbrp06.i &command = update &fields = "  part site" &frm = "a"}

/*K1HD*/ if (c-application-mode <> 'web':u) or
/*K1HD*/ (c-application-mode = 'web':u and
/*K1HD*/ (c-web-request begins 'data':u)) then do:

        find in_mstr where 
		in_domain = global_domain and /*---Add by davild 20090205.1*/
		in_part = part and in_site = site
        no-lock no-error.
        qty_oh = 0.
        if available in_mstr then do:
           qty_oh = in_qty_oh
/*F188*/              + in_qty_nonet.
/*F188*/       tr_end = qty_oh.
           find pt_mstr no-lock where 
		   pt_domain = global_domain and /*---Add by davild 20090205.1*/
		   pt_part = in_part
/*F619*/       no-error.
           display qty_oh
/*F619         pt_desc1 pt_um pt_desc2 */
           with frame a.
/*F619*/       if available pt_mstr then
/*F619*/          display pt_desc1 pt_desc2 pt_um with frame a.
/*F619*/       else
/*F619*/          display "" @ pt_desc1 "" @ pt_desc2 "" @ pt_um
/*F619*/          with frame a.
        end.
        else display "" @  pt_desc1 "" @ qty_oh "" @  pt_um "" @ pt_Desc2
        with frame a.

        hide frame b.

/*K1HD*/ end.

          /* SELECT PRINTER */
          {mfselprt.i "terminal" 100}


        for 
/*F0GN/*F768*/    each si_mstr where si_site = site or site = "",  */
/*F0GN*/    each si_mstr where 
		si_domain = global_domain and /*---Add by davild 20090205.1*/
		si_site = site or site = "" no-lock,
        each tr_hist where 
		tr_domain = global_domain and /*---Add by davild 20090205.1*/
		tr_part = part
/*F768      and tr_site = site */
/*F768*/    and tr_site = si_site
        no-lock use-index tr_part_trn
/*F768*/    break by si_site
        by tr_part desc by tr_trnbr
        descending with frame b width 110 no-attr-space:

           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                                      /*G345*/

/*F768*/       FORM /*GUI*/ 
/*F768*/          tr_date
/*F768*/          tr_type
/*JY000*/         tr_loc
/*F768*/          tr_qty_loc
/*F768*/          tr_ship_type
/*F768*/          tr_end
/*GN38*/          format "->>,>>>,>>9.9<<<<"
/*F768*/          tr_nbr format "x(18)"
/*GN38* /*FR49*/      format "->>,>>>,>>9.9<<<<" */
                  tr_LOT format "x(8)"
/*F768*/          tr_trnbr format ">>>>>>>>"
/*JY000*/         tr_rmks format "x(10)"
/* SS - 100601.1 - B */
                    tr__chr01 format "x(10)" label "领料单"
/* SS - 100601.1 - E */
/*F768*/       with STREAM-IO /*GUI*/  frame b down
/*JY000**  /*K1HD*/       width 80.  **/
/* SS - 100601.1 - B 
/*JY000*/       width 110
   SS - 100601.1 - E */
/* SS - 100601.1 - B */
width 120
/* SS - 100601.1 - E */
.  

setFrameLabels(frame b:handle).


/*G225*/       /*MODIFIED FOLLOWING TO MATCH F768 IN RELEASE 7.2*/
/*F768*/       if first-of (si_site) then do with frame b:
/*F768*/          find in_mstr where 
				in_domain = global_domain and /*---Add by davild 20090205.1*/
				in_part = part and in_site = si_site
/*GD65*/    /*  /*F768*/          no-lock.   */
/*GD65*/          no-lock no-error.
/*GD65*/          if available in_mstr then
/*F768*/          tr_end = in_qty_oh + in_qty_nonet.
/*F768*/          if page-size = 0 then do:
/*F768*/             do while frame-down - frame-line < 3:
/*F768*/                down 1.
/*F768*/             end.
/*F768*/             if frame-down - frame-line = 0 then up 1.
/*F768*/             if first (si_site) then up 1.
/*F768*/             display {&ictriq01_p_2} @ tr_date si_site @ tr_type WITH STREAM-IO /*GUI*/ .
/*F768*/             down.
/*F768*/          end.
/*F768*/          else do:
/*F768*/             if page-size - line-counter < 3 then page.
/*F768*/             display {&ictriq01_p_2} @ tr_date si_site @ tr_type WITH STREAM-IO /*GUI*/ .
/*F768*/             down.
/*F768*/          end.
/*F768*/       end.

/*F768*/       else do with frame b:
/*F768*/          if page-size = 0 then do with frame b:
/*F768*/             if frame-down - frame-line = 0 then do:
/*F768*/                down 1.
/*F768*/                display {&ictriq01_p_2} @ tr_date si_site @ tr_type WITH STREAM-IO /*GUI*/ .
/*F768*/                down.
/*F768*/             end.
/*F768*/          end.
/*F768*/          else do with frame b:
/*F768*/             if page-size - line-counter < 3 then do:
/*F768*/                page.
/*F768*/                display {&ictriq01_p_2} @ tr_date si_site @ tr_type WITH STREAM-IO /*GUI*/ .
/*F768*/                down.
/*F768*/             end.
/*F768*/          end.
/*F768*/       end.

/*G028*        if tr_type <> "ORD-SO" then do: */
/*G028*/       if tr_type <> "ORD-SO" and tr_type <> "ORD-PO" then do:
/*F188            tr_end = tr_begin + tr_qty_chg.  */
          display tr_date
          tr_type tr_loc tr_qty_loc tr_ship_type tr_end
/*K1HD* /*F583*/ when tr_ship_type = "" */
/*K1HD*/        when (tr_ship_type = "")
/* SS - 100601.1 - B */
            tr__chr01 
/* SS - 100601.1 - E */
          tr_nbr tr_lot tr_trnbr tr_rmks  skip(1) WITH STREAM-IO /*GUI*/ .
/*F583*/          if tr_ship_type = "" then
/*F188*/          tr_end = tr_end - tr_qty_loc.
           end.

/*F768*/       if last-of(si_site) then do:
/*F768*/          page.
/*F768*/          if frame-down - frame-line <> 0 then down 1.
/*F768*/       end.

        end.

 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .

     end.
     global_part = part.
/*F751*/ global_site = site.

/*K1HD*/ {wbrp04.i &frame-spec = a}
