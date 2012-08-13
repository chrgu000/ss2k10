/* xwloiqrp.p - LOCATION PART report 	            by atosorigin 05/28/04    */
/* icloiq01.p - LOCATION PART INQUIRY                                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                          */
/*V8:ConvertMode=Report                                                       */
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
/* REVISION: 8.6      LAST MODIFIED: 02/17/98   BY: *K1HQ* Beena Mol          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/14/00   BY: *L0W4* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/18/00   BY: *N0S1* Dave Caveney       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.12 $    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE          */
{mfdtitle.i "C+ "}

define variable part like pt_part.
define variable part1 like pt_part.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable site like ld_site.
define variable site1 like ld_site.

define variable stat  like ld_status.
define variable lot like ld_lot.
define variable lotref like ld_ref.

/*zx*/ define variable qty_delay like in_qty_oh label "递延量".
/*zx*/define workfile xwo_wk 
		       field xwoloc like xwosd_loc
		       field xwoqty like xwosd_qty
		       field xwoconqty like xwosd_qty_consumed .  
/*zx*/ define variable qty_delayc like in_qty_oh label "递延量".
/*zx*/ define variable qty_delayc_con like in_qty_oh label "看板消耗".

form
	skip(1)
	part	   colon 20
	part1      label "至" colon 49	
	site	   colon 20
	site1      label "至" colon 49
	loc	   colon 20
	loc1      label "至" colon 49		    	

	skip(1)
with frame a side-labels 
width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:
	if site1 = hi_char then site1 = "".
	if part1 = hi_char then part1 = "".
	if loc1 = hi_char then loc1 = "".
	
	update   part part1 site site1 loc loc1
            	with frame a.
            	
	bcdparm = "".
	{mfquoter.i site   }
	{mfquoter.i site1  }   
	{mfquoter.i part   }
	{mfquoter.i part1  }             
	{mfquoter.i loc    }
	{mfquoter.i loc1   }  
	
        if site1 = "" then site1 = hi_char.
    	if part1 = "" then part1 = hi_char.
    	if loc1 = "" then loc1 = hi_char.    	

	/* SELECT PRINTER */
	{mfselbpr.i "printer" 132}
	
	{mfphead.i}

	loopa:
	for each in_mstr where (in_part >= part and in_part <= part1)
	 and (in_site >= site and  in_site <= site1)
	 and (can-find(first ld_det where ld_part = in_part
	 and ld_site = in_site
	 and (ld_loc >= loc and ld_loc <= loc1)))
	no-lock:

	{mfrpchk.i}

      find pt_mstr no-lock where pt_part = in_part.
/*zx*/for each xwo_wk :
/*zx*/	delete xwo_wk.
/*zx*/end.      
/*zx*/for each xwosd_det where xwosd_bkflh  = no and xwosd_used = yes and xwosd_site = in_site and xwosd_part = in_part and (xwosd_loc >= loc and xwosd_loc <= loc1)
/*zx*/	no-lock use-index xwosd_bkflh break by xwosd_loc:
/*zx*/	accumulate xwosd_qty (total by xwosd_loc).
/*zx*/	accumulate xwosd_qty_consumed (total by xwosd_loc).
/*zx*/	if last-of (xwosd_loc) then do:
/*zx*/		create xwo_wk.
/*zx*/		xwoloc = xwosd_loc.
/*zx*/		xwoqty = - (accum total by xwosd_loc xwosd_qty ).
/*zx*/		xwoconqty = - (accum total by xwosd_loc xwosd_qty_consumed ).
/*zx*/	end.
/*zx*/	if last (xwosd_loc) then do:
/*zx*/		create xwo_wk.
/*zx*/		xwoloc = "total".
/*zx*/		xwoqty = - (accum total xwosd_qty ).
/*zx*/		xwoconqty = - (accum total xwosd_qty_consumed ).		
/*zx*/end.
/*zx*/end.

/*zx*/find first xwo_wk where xwoloc = "total" exclusive-lock no-error.
/*zx*/if available xwo_wk then do:
/*zx*/	qty_delay = xwoqty. 
/*zx*/	delete xwo_wk.
/*zx*/end.
/*zx*/else qty_delay = 0.

      display in_part
	 pt_desc1 
         in_site
         pt_um
/*zx*/   in_qty_oh column-label "MFG 有效量" /*"QOH Nettable"*/ format "->,>>>,>>9.9<<<<<<<"
/*zx*/   in_qty_nonet column-label "MFG 无效量" format "->,>>>,>>9.9<<<<<<<"
/*zx*/   qty_delay format "->>>,>>9.9<<<<<<"
      with /*no-underline*/ frame b width 100.
/*xw0619*/ setFrameLabels(frame b:handle).

      for each ld_det no-lock where ld_part = pt_part 
            and ld_site = in_site
            and (ld_loc >= loc and ld_loc <= loc1)
            and (ld_status = stat or stat = "")
            and (ld_lot = lot or lot = "") break by ld_loc by ld_lot
      on endkey undo, leave loopa with frame c width 95:
/*xw0619*/ setFrameLabels(frame c:handle).

         {mfrpchk.i}

         find is_mstr where is_status  = ld_status no-lock no-error.
/*zx*/	 qty_delayc = 0.
/*zx*/	 qty_delayc_con = 0.
/*zx*/   if ld_lot = "" then find first xwo_wk where xwoloc = ld_loc exclusive-lock no-error.
/*zx*/   if available xwo_wk then do:
/*zx*/		qty_delayc = xwoqty.
/*zx*/		qty_delayc_con = xwoconqty.
/*zx*/		delete xwo_wk.
/*zx*/   end.		

         display
            ld_loc
            ld_lot    column-label "批/序" format "x(10)"
            ld_status
            ld_date   column-label "生效!失效"
            ld_qty_oh format "->,>>>,>>9.9<<<<<<<"
            ld_grade
/*zx*/	    qty_delayc format "->>>,>>9.9<<<<".
/*xw0619* /*zx*/	    qty_delayc_con format "->>>,>>9.9<<<<". */

         if available is_mstr then display is_net format "/no".

         if ld_ref <> "" or ld_expire <> ? then do with frame c:
            down 1.

            display
               ld_ref format "x(8)" @ ld_lot
               ld_expire            @ ld_date.
         end.
/*zx*/   if last (ld_loc) then do :
/*zx*/      for each xwo_wk with frame c:
/*zx*/      	down 1.
/*zx*/      	display xwoloc @ ld_loc xwoqty @ qty_delayc .
/*xw0619*		xwoconqty @ qty_delayc_con. */
/*zx*/	    end.
/*zx*/   end.        

      end.

   end.


	{mfrtrail.i}	


end.

