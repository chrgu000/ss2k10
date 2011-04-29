/* GUI CONVERTED from iclorp.p (converter v1.71) Tue Oct  6 14:31:34 1998 */
/* iclorp.p - PART LOCATION REPORT                                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert iclorp.p (converter v1.00) Fri Oct 10 13:57:12 1997 */
/* web tag in iclorp.p (converter v1.00) Mon Oct 06 14:17:34 1997 */
/*F0PN*/ /*K0NQ*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 07/17/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 09/15/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 09/09/87   BY: WUG *A94**/
/* REVISION: 4.0    LAST MODIFIED: 02/24/88    BY: WUG *A175**/
/* REVISION: 6.0    LAST MODIFIED: 05/14/90    BY: WUG *D002**/
/* REVISION: 6.0    LAST MODIFIED: 07/10/90    BY: WUG *D051**/
/* REVISION: 6.0    LAST MODIFIED: 01/07/91    BY: emb *D337**/
/* REVISION: 6.0    LAST MODIFIED: 10/07/91    BY: SMM *D887*/
/* REVISION: 7.3    LAST MODIFIED: 04/16/93    BY: pma *G960*/
/* REVISION: 8.6    LAST MODIFIED: 10/16/97    BY: mur *K0NQ*/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "} /*G960*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE iclorp_p_1 "Åú/ÐòºÅ!²Î¿¼"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


define variable part like pt_part.
define variable part1 like pt_part.
define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable um like pt_um.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc2.
/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
part           colon 15
   part1          label {t001.i} colon 49 skip
   site           colon 15
   site1          label {t001.i} colon 49 skip
   loc            colon 15
   loc1           label {t001.i} colon 49 skip
with frame a side-labels width 80.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).

/* REPORT BLOCK */

/*K0NQ*/ {wbrp01.i}
        
repeat:

   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".



	 update part part1 site site1 loc loc1 with frame a.

/*K0NQ*/ if (c-application-mode <> 'web':u) or
/*K0NQ*/ (c-application-mode = 'web':u and
/*K0NQ*/ (c-web-request begins 'data':u)) then do:


   bcdparm = "".
   {mfquoter.i part   }
   {mfquoter.i part1  }
   {mfquoter.i site   }
   {mfquoter.i site1  }
   {mfquoter.i loc    }
   {mfquoter.i loc1   }

   if part1 = "" then part1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if loc1 = "" then loc1 = hi_char.


/*K0NQ*/ end.

    /* SELECT PRINTER */
					{mfselbpr.i "printer" 132}
					
define buffer pt1_mstr for pt_mstr.

    {mfphead.i}

   for each ld_det
/*G960*/ no-lock
   where 
   ld_domain = global_domain and /*---Add by davild 20090205.1*/
   (ld_part >= part and ld_part <= part1)
   and (ld_site >= site and ld_site <= site1)
   and (ld_loc >= loc and ld_loc <= loc1)
   use-index ld_loc_p_lot,
   each pt_mstr no-lock where 
	pt_domain = global_domain and /*---Add by davild 20090205.1*/
	pt_part = ld_part,
   each loc_mstr no-lock where 
	loc_domain = global_domain and /*---Add by davild 20090205.1*/
	loc_loc = ld_loc and loc_site = ld_site,
   each is_mstr no-lock where 
	is_domain = global_domain and /*---Add by davild 20090205.1*/
	is_status = ld_status
   break by ld_site by ld_loc by ld_part by ld_lot
   with frame b width 185:
	setFrameLabels(frame b:handle).
      if first-of(ld_lot) and last-of(ld_lot) and ld_ref = "" then do:
       find pt1_mstr where 
	   pt1_mstr.pt_domain = global_domain and /*---Add by davild 20090205.1*/
	   pt1_mstr.pt_part=ld_part.
       if available pt1_mstr then do:
           desc1=pt1_mstr.pt_desc1.
           desc2=pt1_mstr.pt_desc2.
           end.
       else do:
           desc1="".
           desc2="".
           end.
     display ld_site ld_loc ld_part desc1 ld_lot column-label {&iclorp_p_1}
         pt1_mstr.pt_um
         ld_qty_oh ld_date ld_expire ld_assay ld_grade
         ld_status is_avail is_nettable is_overissue WITH STREAM-IO /*GUI*/ .
         down 1.
         display desc2 @ desc1.
      end.
      else do:
     if first-of(ld_lot) then do:
        display ld_site ld_loc ld_part ld_lot WITH STREAM-IO /*GUI*/ .
        down 1.
     end.
     display  ld_ref @ ld_lot
          pt1_mstr.pt_um
          ld_qty_oh ld_date ld_expire ld_assay ld_grade
          ld_status is_avail is_nettable is_overissue WITH STREAM-IO /*GUI*/ .
     end.


      if last-of(ld_loc) then do:
     down 1.
      end.

      
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

   end.

   /* REPORT TRAILER  */
   
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .

end.

/*K0NQ*/ {wbrp04.i &frame-spec = a}


