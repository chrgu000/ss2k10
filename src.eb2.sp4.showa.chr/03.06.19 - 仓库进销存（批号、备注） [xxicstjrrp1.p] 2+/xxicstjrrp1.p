/* 客户化的进销存报表                                    */
/* 增加操作时间栏，修改表格列顺序     DATE: 07/11/01     */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable nbr      like tr_nbr no-undo.
define variable nbr1     like tr_nbr no-undo.
define variable part     like tr_part no-undo.
define variable part1    like tr_part no-undo.
define variable effdate  like tr_effdate no-undo.
define variable effdate1 like tr_effdate no-undo.
define variable efftime  as char.
define variable username as char format "x(18)".
define variable site     like tr_site no-undo.
define variable site1    like tr_site no-undo.
define variable loc      like tr_loc no-undo.
define variable loc1     like tr_loc no-undo.
define variable newpage  like mfc_logical no-undo.
define variable desc1    like pt_desc1 no-undo.
define variable qtyin    like tr_qty_loc  no-undo.
define variable qtyout   like tr_qty_loc no-undo.
define variable invnbr   like so_inv_nbr no-undo.
define variable newtrloc like mfc_logical no-undo.
define variable firstprinted as logical initial false no-undo.
define variable endbalance like in_qty_oh  no-undo.
define variable receiver   as character initial "07" no-undo.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*CHAR*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
   part           colon 20
   part1          label "To" colon 49 skip
   effdate        colon 20
   effdate1       label "To" colon 49 skip
   site           colon 20
   site1          label "To" colon 49 skip
   loc            label "Location" colon 20
   loc1           label "To" colon 49 skip
   newpage        label "New Page Per Item/Location" colon 40
with frame a side-labels width 80 attr-space .
/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



setFrameLabels(frame a:handle).

FORM 
   qtyin        column-label "入库量"
   qtyout       column-label "出库量"
   endbalance   column-label "在库量"
   tr_effdate
   tr_serial
   tr_rmks
   username     column-label "操作者"
   tr_date      column-label "操作日期"
   efftime      column-label "操作时间"
   tr_type      column-label "TT"
   tr_trnbr
   tr_addr  format "x(10)"
   tr_ship_id
   invnbr
with   frame b.

setFrameLabels(frame b:handle).

{wbrp01.i &io-frame = "a"}

repeat:

   if part1 = hi_char then part1 = "".
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".

   if c-application-mode <> "WEB" then
      update
         part part1
         effdate effdate1
         site site1 loc loc1
         newpage
      with frame a.

   {wbrp06.i &command = update
      &fields  = "part part1
        effdate effdate1
        site site1 loc loc1
        newpage"
      &frm     = "a"}

   bcdparm = "".
   {mfquoter.i part    }
   {mfquoter.i part1   }
   {mfquoter.i effdate }
   {mfquoter.i effdate1}
   {mfquoter.i site    }
   {mfquoter.i site1   }
   {mfquoter.i loc     }
   {mfquoter.i loc1    }
   {mfquoter.i newpage }

   if part1 = ""   then part1 = hi_char.
   if effdate = ?  then effdate = low_date.
   if effdate1 = ? then effdate1 = hi_date.
   if site1 = ""   then site1 = hi_char.
   if loc1 = ""    then loc1 = hi_char.

   {gpselout.i &printType = "printer"
               &printWidth = 180  /* 132 */
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
	       /*
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
*/

   {mfphead.i}

   view frame b.
   for each tr_hist
      where (tr_part >= part and tr_part <= part1)
        and tr_effdate >= effdate
        and (tr_site >= site and tr_site <= site1)
        and (tr_loc >= loc  and tr_loc <= loc1)
        and tr_ship_type <> "M"
        and (tr_type <> "RCT-PO" or tr_ship_type <> "s")
   use-index tr_part_eff no-lock
      break by tr_part by tr_site by tr_loc
            by tr_effdate descending
            by tr_trnbr descending
   with frame b down width 180 no-attr-space:  

      CHK:
      do on endkey undo, leave:
         if tr_loc = "" and tr_qty_loc = 0.0 then do:
            if firstprinted = true and last-of(tr_loc) then leave CHK.
            next.
         end.
      end.

      if first-of(tr_loc) then do:

         assign
            firstprinted = true
            newtrloc     = true
            endbalance   = 0.

         for each ld_det
            where ld_part = tr_part
              and ld_site = tr_site
              and ld_loc  = tr_loc
         no-lock use-index ld_part_loc:
            endbalance = endbalance + ld_qty_oh.
         end.

      end.

      if newtrloc and tr_effdate > effdate1 then
         endbalance = endbalance - tr_qty_loc.

      if newtrloc and tr_effdate <= effdate1 then do:

         if page-size - line-counter < 6 then do:
            page.
            view frame b.
         end.

         desc1 = "".
         for first pt_mstr where pt_part = tr_part no-lock:
            assign desc1 = pt_desc1 + " " + pt_desc2.
         end.

         put
            {gplblfmt.i &FUNC=getTermLabel(""ITEM"",4) &CONCAT="":""}
            " " tr_part " "
            desc1 format "x(49)" " "
            {gplblfmt.i &FUNC=getTermLabel(""UM"",2) &CONCAT="":""}
            " " tr_um " "
            {gplblfmt.i &FUNC=getTermLabel(""SITE"",4) &CONCAT="': '"}
            tr_site " "
            {gplblfmt.i &FUNC=getTermLabel(""LOCATION"",4) &CONCAT="': '"}
            " " tr_loc skip.


         display
            getTermLabelRt("CLOSING",14) format "x(14)" @ qtyin
            getTermLabel("INVENTORY",14) format "x(14)" @ qtyout
            endbalance
         with frame b /* STREAM-IO /*GUI*/ */.
         down 1 with frame b.

      end.

      if tr_effdate <= effdate1 then newtrloc = false.

      if page-size - line-counter < 2 then page.

      assign
         qtyin  = 0
         qtyout = 0.

      if not (tr_type = "RCT-PO" and tr_ship_type = "s") then do:
         if tr_qty_loc >= 0 then qtyin  = tr_qty_loc.
         if tr_qty_loc <  0 then qtyout = tr_qty_loc.
      end.

      if qtyin <> 0 or qtyout <> 0 then do:

         invnbr = "".

         if tr_ship_id <> "" then
         for first abs_mstr
            where abs_shipfrom = tr_site and
                  abs_id begins "is" + tr_ship_id
         no-lock:
            invnbr = abs_inv_nbr.
         end.

         if invnbr = "" and (tr_type = "ISS-SO" or tr_type = "ISS-COR")
         then assign invnbr = tr_rmks.

         if invnbr = "" and  tr_type = "RCT-PO" then do:
            /* FIND THE INVOICE IN CASE OF PURCHASE */
            for first pvo_mstr where
                      pvo_lc_charge = ""               and
                      pvo_internal_ref_type = receiver and
                      pvo_internal_ref = tr_lot        and
                      pvo_line = tr_line
            no-lock:
               invnbr = pvo_last_voucher.
            end.
         end.

         if tr_effdate <= effdate1 then do:
            efftime = string(tr_time,"hh:mm:ss").
	    username = "".
	    find usr_mstr where usr_userid = tr_userid no-error.
            if available usr_mstr then username = usr_name.
	       else do:
	           find code_mstr where code_fldname = "BARCODEUSERID" and code_value = tr_userid no-error.
		   if available code_mstr then username = "条码-" + code_cmmt.
	       end.
	    display
               qtyin  when (tr_ship_type = "")
               qtyout when (tr_ship_type = "")
               endbalance
               tr_effdate
               tr_date
               efftime
	       username format "x(16)"
	       tr_type
               tr_trnbr
               tr_addr  format "x(10)"
	       tr_rmks
	       tr_serial  format "x(18)"
               tr_ship_id
               invnbr
            with frame b /* STREAM-IO /*GUI*/  */ .
            down 1 with frame b.
            end.
      end.

      /* COMPUTE THE BEGINNING BALANCE */
      if tr_effdate <= effdate1
         and not (tr_type = "RCT-PO" and tr_ship_type = "s" )
      then
         endbalance = endbalance - tr_qty_loc.

      if last-of(tr_loc) then do:
         /* DISPLAY INITIAL BALANCE */
         firstprinted = false.
         display
            getTermLabelRt("OPENING",14) format "x(14)" @ qtyin
            getTermLabel("INVENTORY",14) format "x(14)" @ qtyout
            endbalance
         with frame b /* STREAM-IO /*GUI*/  */.
         down 2 with frame b.
         if newpage then page.
      end.

      
/* /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/ */
/*GUI*/ {mfrpchk.i } /*Replace mfrpchk*/


   end.

   {mfrtrail.i}

end.
