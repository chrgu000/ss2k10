/* GUI CONVERTED from iclorp.p (converter v1.69) Sat Mar 30 01:15:28 1996 */
/* iclorp.p - PART LOCATION REPORT                                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 07/17/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 09/15/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 09/09/87   BY: WUG *A94**/
/* REVISION: 4.0    LAST MODIFIED: 02/24/88    BY: WUG *A175**/
/* REVISION: 6.0    LAST MODIFIED: 05/14/90    BY: WUG *D002**/
/* REVISION: 6.0    LAST MODIFIED: 07/10/90    BY: WUG *D051**/
/* REVISION: 6.0    LAST MODIFIED: 01/07/91    BY: emb *D337**/
/* REVISION: 6.0    LAST MODIFIED: 10/07/91    BY: SMM *D887*/
/* REVISION: 7.3    LAST MODIFIED: 04/16/93    BY: pma *G960*/
/*cj*/

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "f "} /*G960*/ /*GUI moved to top.*/
define variable part like pt_part.
define variable part1 like pt_part.
define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable sta like ld_sta LABEL "库位状态".
define variable sta1 like ld_sta.
define variable um like pt_um.
/*cj*/ DEF VAR keeper AS CHAR LABEL "保管员" .
/*cj*/ DEF VAR keeper1 AS CHAR .

/* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
part           colon 15
   part1          label {t001.i} colon 49 skip
   site           colon 15
   site1          label {t001.i} colon 49 skip
   loc            colon 15
   loc1           label {t001.i} colon 49 skip
   sta            colon 15
   sta1           label {t001.i} colon 49 skip
/*cj*/ keeper     COLON 15
/*cj*/ keeper1    LABEL {t001.i} COLON 49 SKIP
 SKIP(.4)  /*GUI*/
with frame a side-labels WIDTH 80 /*GUI*/ NO-BOX THREE-D /*GUI*/.

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

/*judy 07/05/05*/  /* SET EXTERNAL LABELS */
/*judy 07/05/05*/  setFrameLabels(frame a:handle).

/* REPORT BLOCK */

/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if sta1 = hi_char then sta1 = "".
/*cj*/ IF keeper1 = hi_char THEN keeper1 = "" .

   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   bcdparm = "".
   {mfquoter.i part   }
   {mfquoter.i part1  }
   {mfquoter.i site   }
   {mfquoter.i site1  }
   {mfquoter.i loc    }
   {mfquoter.i loc1   }
   {mfquoter.i sta    }
   {mfquoter.i sta1   }
/*cj*/    {mfquoter.i keeper   }
/*cj*/    {mfquoter.i keeper1  }

   if  part1 = "" then part1 = hi_char.
   if  site1 = "" then site1 = hi_char.
   if  loc1 = "" then loc1 = hi_char.
   if  sta1 = "" then sta1 = hi_char.
/*cj*/ IF keeper1 = "" THEN keeper1 = hi_char .

   /* SELECT PRINTER */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   {mfphead.i}

   for each ld_det
/*G960*/ no-lock
   WHERE ld_domain = "DCEC" AND ld_qty_oh <> 0
   AND    (ld_part >= part and ld_part <= part1)
   and (ld_site >= site and ld_site <= site1)
   and (ld_loc >= loc and ld_loc <= loc1)
   and (ld_sta >= sta and ld_sta <= sta1)
   use-index ld_loc_p_lot,
   each pt_mstr no-lock WHERE pt_domain = "DCEC" AND pt_part = ld_part,
   each loc_mstr no-lock WHERE loc_domain = "DCEC" AND loc_loc = ld_loc and loc_site = ld_site,
   each is_mstr no-lock WHERE IS_domain = "DCEC" AND is_sta = ld_sta,
/*cj*/ EACH IN_mstr NO-LOCK WHERE in_domain = "DCEC" AND IN_part = ld_part AND IN_site = ld_site 
/*cj*/                        AND IN__qadc01 >= keeper AND IN__qadc01 <= keeper1
   break by ld_site by ld_loc by ld_part by ld_lot
   with frame b width 182:

/*cj*/  setFrameLabels(frame b:handle).

      if first-of(ld_lot) and last-of(ld_lot) and ld_ref = "" then do:

	 display ld_site /*cj*/ in__qadc01 IN_user1 /*judy*/ ld_loc ld_part ld_lot column-label "批/序号!参考"
		 pt_um
		 ld_qty_oh ld_date ld_expire ld_assay ld_grade
		 ld_sta is_avail is_nettable is_overissue WITH STREAM-IO /*GUI*/ .
      end.
      else do:
	 if first-of(ld_lot) then do:
	    display ld_site  /*cj*/ in__qadc01 IN_user1 /*judy*/ ld_loc ld_part ld_lot WITH STREAM-IO /*GUI*/ .
	    down 1.
	 end.
	 display  ld_ref @ ld_lot
		  pt_um
		  ld_qty_oh ld_date ld_expire ld_assay ld_grade
		  ld_sta is_avail is_nettable is_overissue WITH STREAM-IO /*GUI*/ .
     end.


      if last-of(ld_loc) then do:
	 down 1.
      end.

      
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

   end.

   /* REPORT TRAILER  */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 site site1 loc loc1 sta sta1 keeper keeper1"} /*Drive the Report*/
