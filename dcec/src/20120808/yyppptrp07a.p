/* GUI CONVERTED from ppptrp07.p (converter v1.69) Sat Mar 30 01:19:35 1996 
*/

/* ppptrp07.p - INVENTORY VAL AS OF DATE BY LOCATION                    */

/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */

/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */

/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*          */

/* REVISION: 7.0      LAST MODIFIED: 02/03/92   BY: pma *F134*          */

/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F280*          */

/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F770*          */

/* REVISION: 7.0      LAST MODIFIED: 08/03/92   BY: pma *F828*          */

/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: pma *F893*          */

/* Revision: 7.3      Last modified: 10/31/92   By: jcd *G259*          */

/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: pma *G869*          */

/* REVISION: 7.3      LAST MODIFIED: 02/18/94   BY: pxd *FM27*          */

/* Oracle changes (share-locks)      09/12/94   BY: rwl *GM42*          */

/* REVISION: 7.2      LAST MODIFIED: 01/09/95   BY: ais *F0DB*          */

/* REVISION: 7.3      LAST MODIFIED: 06/02/95   by: dzs *G0NZ*          */

/* REVISION: 7.3      LAST MODIFIED: 10/13/95   by: str *G0ZG*          */

/* Modified by Casen 2004.01.05 for modify display format */
/*Last modified: 02/05/2004, By: Kevin to increase the width of the report*/


	 /* DISPLAY TITLE */



/*GUI global preprocessor directive settings */

&GLOBAL-DEFINE PP_PGM_RP TRUE

&GLOBAL-DEFINE PP_ENV_GUI TRUE





/*GUI preprocessor directive settings */

&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT



	 {mfdtitle.i "f+ "} /*FM27*/



	 define variable abc like pt_abc.

	 define variable abc1 like pt_abc.

	 define variable loc like ld_loc.

	 define variable loc1 like ld_loc.

	 define variable site like ld_site.

	 define variable site1 like ld_site.

	 define variable part like pt_part.

	 define variable part1 like pt_part.

	 define variable vend like pt_vend.

	 define variable vend1 like pt_vend.

	 define variable line like pt_prod_line.

	 define variable line1 like pt_prod_line.

	 define variable ext_std as decimal label "总帐成本合计"

	    format "->>>,>>>,>>9.99" no-undo.

	 define variable ext_cur as decimal label "当期成本合计"

	    format "->>>,>>>,>>9.99" no-undo.

	 define variable cost_var as decimal label "   差异 % "

	    format "->>>,>>9.9%" no-undo.

	 define variable acc as decimal extent 2

	    format "->>>,>>>,>>9.99" no-undo.

/*G0ZG*	 define variable neg_qty like mfc_logical initial no                 
  */

/*G0ZG*/ define variable neg_qty like mfc_logical initial yes

	    label "包括负值库存量".

	 define variable total_qty_oh like in_qty_oh.

	 define variable ld-printed like mfc_logical no-undo.

	 define variable first-loc like mfc_logical no-undo.

	 define variable net_qty like mfc_logical initial yes

	    label "包括无效库位库存量".

	 define variable inc_zero_qty like mfc_logical initial no

	    label "包括零库存量".

	 define variable parts_printed as integer.

	 define variable locations_printed as integer.

	 define variable as_of_date like tr_effdate.

/*F770*/

/* /*F828*/ define shared variable mfguser as character.  *G259*/

/*G869*/ define variable tr_recno as recid.

/*F0DB*/ define variable trrecno as recid.

/*F003*/ define variable std_as_of like glxcst.

	 define variable part_group like pt_group.       /*F280*/

	 define variable part_group1 like pt_group.      /*F280*/

	 define variable part_type like pt_part_type.    /*F280*/

	 define variable part_type1 like pt_part_type.   /*F280*/

/*F0DB*/ define variable cst_date like tr_effdate.

/*G0NZ*/ define variable ldrecno as recid.

/*G0NZ*/ define variable ref like ld_ref.

/*G0ZG*/ define variable zero_cost like mfc_logical initial yes

/*G0ZG*/    label "接受零初期成本" no-undo.



	 /* SELECT FORM */



/*GUI preprocessor Frame A define */

&SCOPED-DEFINE PP_FRAME_NAME A



FORM /*GUI*/



RECT-FRAME       AT ROW 1.4 COLUMN 1.25

RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL

SKIP(.1)  /*GUI*/

part           colon 15

	    part1          label {t001.i} colon 49 skip

	    line           colon 15

	    line1          label {t001.i} colon 49 skip

	    vend           colon 15

	    vend1          label {t001.i} colon 49 skip

	    abc            colon 15

	    abc1           label {t001.i} colon 49

	    site           colon 15

	    site1          label {t001.i} colon 49

	    loc            colon 15

	    loc1           label {t001.i} colon 49

	    part_group     colon 15                             /*F280*/

	    part_group1    label {t001.i} colon 49 skip         /*F280*/

	    part_type      colon 15                             /*F280*/

	    part_type1     label {t001.i} colon 49 skip(1)      /*F280*/

/*F770*/    as_of_date     colon 35

	    neg_qty        colon 35 skip

/*F770*/    net_qty        colon 35

	    inc_zero_qty   colon 35

/*F770      as_of_date     colon 35   */

/*G0ZG*/    zero_cost      colon 35

	  SKIP(.4)  /*GUI*/

with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.



DEFINE VARIABLE F-a-title AS CHARACTER.

F-a-title = " 选择条件 ".

RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.

RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =

  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(

  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).

RECT-FRAME:HEIGHT-PIXELS in frame a =

  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/



/*GUI preprocessor Frame A undefine */

&UNDEFINE PP_FRAME_NAME







	 /* REPORT BLOCK */





/*GUI*/ {mfguirpa.i true  "printer" 132 }



/*GUI repeat : */

/*GUI*/ procedure p-enable-ui:





	    if part1 = hi_char then part1 = "".

	    if line1 = hi_char then line1 = "".

	    if vend1 = hi_char then vend1 = "".

	    if abc1 = hi_char then abc1 = "".

	    if site1 = hi_char then site1 = "".

	    if loc1 = hi_char then loc1 = "".

	    if part_group1 = hi_char then part_group1 = "".     /*F280*/

	    if part_type1 = hi_char then part_type1 = "".       /*F280*/

	    if as_of_date = ? then as_of_date = today.





run p-action-fields (input "display").

run p-action-fields (input "enable").

end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/



/*GUI*/ procedure p-report-quote:





	    bcdparm = "".

	    {mfquoter.i part   }

	    {mfquoter.i part1  }

	    {mfquoter.i line   }

	    {mfquoter.i line1  }

	    {mfquoter.i vend   }

	    {mfquoter.i vend1  }

	    {mfquoter.i abc    }

	    {mfquoter.i abc1   }

	    {mfquoter.i site   }

	    {mfquoter.i site1  }

	    {mfquoter.i loc    }

	    {mfquoter.i loc1   }

	    {mfquoter.i part_group  }           /*F280*/

	    {mfquoter.i part_group1 }           /*F280*/

	    {mfquoter.i part_type}              /*F280*/

	    {mfquoter.i part_type1}             /*F280*/

/*F770*/    {mfquoter.i as_of_date}

	    {mfquoter.i neg_qty}

/*F770*/    {mfquoter.i net_qty}

	    {mfquoter.i inc_zero_qty}

/*F770      {mfquoter.i as_of_date}  */

/*G0ZG*/    {mfquoter.i zero_cost}



	    if  part1 = "" then part1 = hi_char.

	    if  line1 = "" then line1 = hi_char.

	    if  vend1 = "" then vend1 = hi_char.

	    if  abc1 = "" then abc1 = hi_char.

	    if  site1 = "" then site1 = hi_char.

	    if  loc1 = "" then loc1 = hi_char.

	    if  part_group1 = "" then part_group1 = hi_char.     /*F280*/

	    if  part_type1 = "" then part_type1 = hi_char.       /*F280*/

	    if  as_of_date = ? then as_of_date = today.



	    /* SELECT PRINTER */



/*GUI*/ end procedure. /* p-report-quote */

/*GUI - Field Trigger Section */



/*GUI MFSELxxx removed*/

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}

/*GUI*/   mainloop: do on error undo, return error on endkey undo, return 
error:



define buffer ismstr for is_mstr.





	    {mfphead.i}



	    FORM /*GUI*/

	       header

	       "* 库存量是有效库存与无效库存之和"

/*G0ZG*	    with frame pagefoot page-bottom. */

/*G0ZG*/    with STREAM-IO /*GUI*/  frame pagefoot page-bottom width 132.

/*F770      view frame pagefoot. */



/*F770*/    FORM /*GUI*/

/*F770*/       header

/*F770*/       "* 库存量仅为有效库存之和"

/*G0ZG* /*F770*/    with frame pagefoot1 page-bottom. */

/*G0ZG*/    with STREAM-IO /*GUI*/  frame pagefoot1 page-bottom width 132.



/*F770*/    hide frame pagefoot.

/*F770*/    hide frame pagefoot1.

/*F770*/    if net_qty then view frame pagefoot.

/*F770*/    else view frame pagefoot1.



/*F134*/    /*TEMPORARILY RE-CREATE ANY NON-PERMANENT LD_DET RECORDS*/

/*F134*/    do transaction on error undo, retry:

/*F828/*F134*/ find first is_mstr no-lock.   */

/*F134*/       for each tr_hist where tr_effdate >= as_of_date no-lock:

/*F134*/          if not can-find(first ld_det where ld_site = tr_site

/*F134*/          and ld_loc = tr_loc and ld_part = tr_part)

/*F134*/          then do:





/*G0NZ********************** DELETED FOLLOWING CODE ***********************/

/*G0NZ*******      MOVED THE CREATE ld_det TRANSACTION TO ppptrp6a.p ******/

/*G0NZ /*F134*/        create ld_det.                                     */

/*G0NZ /*F134*/        assign                                             */

/*G0NZ /*F134*/        ld_part = tr_part                                  */

/*G0NZ /*F134*/        ld_site = tr_site                                  */

/*G0NZ /*F134*/        ld_loc = tr_loc                                    */

/*G0NZ /*F828/*F134*/  ld_status = is_status        */                    */

/*G0NZ /*F828*/        ld_status = tr_status                              */

/*G0NZ /*F134*/        ld_ref = fill("#",20)                              */

/*G0NZ /*F828*/                 + mfguser.                                */

/*G0NZ /*F134*/        release ld_det.                                    */

/*G0NZ*********************************************************************/

/*G0NZ****************   CREATE ld_det TRANSACTION  ***********************/

/*G0NZ*/                       ref = fill("#",20) + mfguser.

/*G0NZ*/                       {gprun.i ""ppptrp6a.p""

				      "(input tr_part,

					input tr_site,

					input tr_loc,

					input tr_status,

					input ref,

					output ldrecno)"

			       }

/*G0NZ*/                       find ld_det where recid(ld_det) = ldrecno

/*G0NZ*/                       no-error.

/*F134*/          end.

/*F134*/       end.



	       for each ld_det no-lock

	       where ld_part >= part and ld_part <= part1

	       and ld_site >= site and ld_site <= site1

	       and ld_loc >= loc and ld_loc <= loc1,

/*G0NZ         each is_mstr no-lock where is_status = ld_status     */

/*G0NZ /*F770*/and (is_net or net_qty)                              */

/*G0NZ         , each pt_mstr no-lock where pt_part = ld_part       */

/*G0NZ*/       each pt_mstr no-lock where pt_part = ld_part

	       and (pt_vend >= vend and pt_vend <= vend1)

/*F280*/       and (pt_group >= part_group and pt_group <= part_group1)

/*F280*/       and (pt_part_type >= part_type and pt_part_type <= 
part_type1)

	       and (pt_prod_line >= line and pt_prod_line <= line1)

/*F003*/       , each in_mstr

/*F893*/         no-lock

		 where in_part = ld_part and in_site = ld_site

/*F003*/       and (in_abc >= abc and in_abc <= abc1)

	       break by ld_site by ld_loc by ld_part with width 132:

		  if first-of(ld_part) then do:

		     if first-of(ld_loc) then do:

			if first-of(ld_site) then do:

			   locations_printed = 0.

			end.



			parts_printed = 0.

		     end.



		     total_qty_oh = 0.

		     ext_std = 0.

		     ext_cur = 0.

		  end.



/*G0NZ*/          find is_mstr no-lock where is_status = ld_status

/*G0NZ*/          no-error.

/*G0NZ*/          if net_qty = yes or not available is_mstr

/*G0NZ*/          or (available is_mstr and is_net) then

		  total_qty_oh = total_qty_oh + ld_qty_oh.



		  if last-of(ld_part) then do:

		     /* BACK OUT TR_HIST AFTER AS-OF DATE */

		     for each tr_hist no-lock

		     where tr_part = ld_part

		     and tr_site = ld_site and tr_loc = ld_loc

		     and tr_effdate > as_of_date

/*F828*/             and tr_ship_type = ""

		     and tr_qty_loc <> 0:

/*F770*/                find ismstr no-lock where ismstr.is_status = 
tr_status

/*F770*/                no-error.

/*F770*/                if net_qty = yes or not available ismstr

/*F770*/                or (available ismstr and ismstr.is_net) then

			total_qty_oh = total_qty_oh - tr_qty_loc.

		     end.



		     if total_qty_oh > 0

		     or (total_qty_oh = 0 and inc_zero_qty)

		     or (total_qty_oh < 0 and neg_qty)

		     then do:

                        /*

			if parts_printed = 0 then do:

			   FORM /*GUI*/  header

			      "地点: "

			      ld_site

			      space(4)

			      "库位: "

			      ld_loc

/*G0ZG*			   with frame phead1 page-top. */

/*G0ZG*/		   with STREAM-IO /*GUI*/  frame phead1 page-top width 132.

			   hide frame phead1.

			   page.

			   view frame phead1.

			end.

                        */

			/*FIND THE STANDARD COST AS OF DATE*/

/*G0NZ*/                {ppptrp6a.i}



/*G0NZ***************** MOVED THE FOLLOWING CODE TO ppptrp6a.i 
**************

**G0NZ                  /*FIND THE BEGINNING COST ON THE FIRST CST-ADJ

**G0NZ                    TRANSACTION AFTER THE SELECTED DATE.

**G0NZ                    THIS COST - TR_PRICE SHOULD EQUAL

**G0NZ                    THE COST AT END OF THE AS-OF DATE*/

**G0NZ /*G869*/         /*HOWEVER, IF THIS IS THE FIRST TR_HIST RECORD,

**G0NZ                  THEN ASSUME THAT THE COST AT THE END OF THE

**G0NZ                  AS-OF DATE EQUALS THIS COST.*/

**G0NZ /*G869*/         tr_recno = -1.



**G0NZ /*G869*/         find first tr_hist where tr_part = in_part

**G0NZ /*FM27*/         and tr_effdate >= as_of_date + 1

**G0NZ /*G869*/         and tr_site = in_site

**G0NZ /*G869*/         and tr_type = "CST-ADJ"

**G0NZ /*G869*/         no-lock use-index tr_part_eff no-error.

**G0NZ /*G869*/         if available tr_hist then tr_recno = recid(tr_hist).



**G0NZ /*F003*/         find first tr_hist where tr_part = in_part

**G0NZ /*F003*/         and tr_site = in_site

**G0NZ /*F003*/         and tr_type = "CST-ADJ"

**G0NZ /*F828           and tr_date >= as_of_date + 1 */

**G0NZ /*F828*/         and tr_effdate >= as_of_date + 1

**G0NZ /*F003*/         no-lock use-index tr_part_eff no-error.

**G0NZ /*F003*/         if available tr_hist then do:

**G0NZ /*F0DB*/         /* GET THE FIRST RECORD ENTERED EVEN IF 
TR_PART_EFF*/

**G0NZ /*F0DB*/         /* ISN'T IN TRANSACTION NUMBER SEQUENCE            
*/

**G0NZ /*F0DB*/            cst_date = tr_effdate.

**G0NZ /*F0DB*/            for each tr_hist no-lock where tr_part = in_part

**G0NZ /*F0DB*/            and tr_effdate = cst_date

**G0NZ /*F0DB*/            and tr_site = in_site

**G0NZ /*F0DB*/            and tr_type = "CST-ADJ"

**G0NZ /*F0DB*/            use-index tr_part_eff

**G0NZ /*F0DB*/            by tr_trnbr.

**G0NZ /*F0DB*/               trrecno = recid(tr_hist).

**G0NZ /*F0DB*/               leave.

**G0NZ /*F0DB*/            end.

**G0NZ /*F0DB*/            find tr_hist no-lock where recid(tr_hist) = 
trrecno.

**G0NZ /*F003*/            std_as_of = (tr_mtl_std + tr_lbr_std + tr_ovh_std

**G0NZ /*F003*/                       + tr_bdn_std + tr_sub_std).

**G0NZ /*G869/*F003*/                 - tr_price.  */

**G0NZ /*G869*/            if tr_recno <> recid(tr_hist)

**G0NZ /*G869*/            or (tr_recno = recid(tr_hist)

**G0NZ /*G869*/            and tr_price <> std_as_of) then

**G0NZ /*G869*/            std_as_of = std_as_of - tr_price.

**G0NZ /*F003*/         end.

**G0NZ /*F003*/         else do:

**G0NZ /*F003*/            {gpsct03.i &cost=sct_cst_tot}

**G0NZ /*F003*/            std_as_of = glxcst.

**G0NZ /*F003*/         end.



**G0NZ                  ext_std = round(total_qty_oh * std_as_of,2).

*****************************************************************************/



			display

			pt_part

			pt_desc1 + " " + pt_desc2 format "x(49)" @ pt_desc1

			format "x(49)"

/*F003*/                in_abc

                        /*Added by Casen*/

                        ld_site

                        ld_loc



			total_qty_oh

			pt_um

			std_as_of

			ext_std WITH
			width 144                /*added by kevin,02/05/2004*/
			STREAM-IO /*GUI*/ .



			accumulate ext_std (total by ld_loc by ld_site).



			parts_printed = parts_printed + 1.

		     end.

                     /*

		     if last-of(ld_loc) then do:

			if parts_printed >= 1 then do:

			   acc[1] = accum total by ld_loc ext_std.



			   if line-count > page-size - 4 then page.



			   underline ext_std.

			   down 1.

			   display

			   "库位合计" @ std_as_of

			   acc[1] @ ext_std WITH STREAM-IO /*GUI*/ .

			   down 1.



			   locations_printed = locations_printed + 1.

			end.



			if last-of(ld_site) then do:

			   if locations_printed >= 1 then do:

			      acc[1] = accum total by ld_site ext_std.



			      if line-count > page-size - 4 then page.



			      underline ext_std.

			      down 1.

			      display

			      "地点合计" @ std_as_of

			      acc[1] @ ext_std WITH STREAM-IO /*GUI*/ .

			      down 1.

			   end.



			   if last(ld_loc) then do:

			      acc[1] = accum total ext_std.



			      if line-count > page-size - 4 then page.



			      underline ext_std.

			      down 1.

			      display

			      "报表合计" @ std_as_of

			      acc[1] @ ext_std WITH STREAM-IO /*GUI*/ .

			      down 1.

			   end.

			end.

		     end.  */

		  end.





/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/



	       end.



/*G0NZ********************** DELETED FOLLOWING CODE ***********************/

/*G0NZ*******      MOVED THE DELETE ld_det TRANSACTION TO ppptrp6b.p ******/

/*G0NZ /*F134*/    /*DELETE TEMPORARY LD_DET RECORDS*/                    */

/*G0NZ /*F134*//*GM42*/ for each ld_det exclusive where ld_ref = 
fill("#",20) */

/*G0NZ /*F828*/                                    + mfguser:             */

/*G0NZ /*F134*/          delete ld_det.                                   */

/*G0NZ /*F134*/       end.                                                */

/*G0NZ*********************************************************************/

/*G0NZ****************   DELETE ld_det TRANSACTION  ***********************/

/*G0NZ*/                       ref = fill("#",20) + mfguser.

/*G0NZ*/                       {gprun.i ""ppptrp6b.p""

				      "(input  ref,

					output ldrecno)"

			       }



/*F134*/    end.  /*do transaction*/



	    /* REPORT TRAILER */



/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/



/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/





	 end.



/*GUI*/ end procedure. /*p-report*/

/*GUI*/ {mfguirpb.i &flds=" part part1 line line1 vend vend1 abc abc1 site 
site1 loc loc1 part_group part_group1 part_type part_type1   as_of_date 
neg_qty  net_qty inc_zero_qty   zero_cost "} /*Drive the Report*/



