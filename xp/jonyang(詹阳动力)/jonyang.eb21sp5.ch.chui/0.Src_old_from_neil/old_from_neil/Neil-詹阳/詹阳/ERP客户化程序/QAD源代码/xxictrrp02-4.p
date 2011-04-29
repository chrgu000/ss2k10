/* GUI CONVERTED from ictrrp02.p (converter v1.71) Tue Oct  6 14:32:13 1998 */
/* ictrrp02.p - TRANSACTION BY ORDER REPORT                                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/* web convert ictrrp02.p (converter v1.00) Mon Oct 06 14:21:28 1997 */
/* web tag in ictrrp02.p (converter v1.00) Mon Oct 06 14:17:34 1997 */
/*F0PN*/ /*K0PG*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                      */
/* REVISION: 6.0      LAST MODIFIED: 05/12/90   BY: PML                      */
/* REVISION: 7.0      LAST MODIFIED: 06/06/92   BY: pma *F584*               */
/* REVISION: 7.3      LAST MODIFIED: 08/18/92   BY: tjs *G028*               */
/* REVISION: 7.3      LAST MODIFIED: 05/23/94   BY: pxd *FO38*               */
/* REVISION: 7.3      LAST MODIFIED: 09/18/94   BY: qzl *FR49*               */
/* REVISION: 7.3      LAST MODIFIED: 12/05/95   BY: jym *G1FN*               */
/* REVISION: 8.6      LAST MODIFIED: 10/08/96   BY: *K003* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0CW* Russ Witt         */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: gyk *K0PG*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* SS - 090524.1 By: Neil Gao */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "090524.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ictrrp02_p_1 "订单: "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable part like tr_part.
define variable part1 like tr_part.
define variable trnbr like tr_trnbr.
define variable trnbr1 like tr_trnbr.
define variable trdate like tr_effdate.
define variable trdate1 like tr_effdate.
define variable type like glt_tr_type format "x(8)".
/*K003*  define variable desc1 like pt_desc1.  *K003*/
/*K003*/ define variable desc1 like pt_desc1 format "x(49)" no-undo.
define variable old_order like tr_nbr.
define variable first_pass like mfc_logical.
define variable site like in_site.
define variable site1 like in_site.
define variable LOC like tr_LOC.
define variable LOC1 like tr_LOC.
define variable TRUSErID like TR_USERID.
define variable TRUSERID1 like TR_USERID.

define variable LINE like tr_PROD_LINE.
define variable LINE1 like tr_PROD_LINE.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   nbr            colon 20
   nbr1           label {t001.i} colon 49 skip
   trdate         colon 20
   trdate1        label {t001.i} colon 49 skip
   part           colon 20
   part1          label {t001.i} colon 49 skip
   site           colon 20
   site1          label {t001.i} colon 49 skip
   so_job         colon 20
   so_job1        label {t001.i} colon 49 skip 
   LOC         colon 20
   LOC1        label {t001.i} colon 49 skip 
   LINE         colon 20
   LINE1        label {t001.i} colon 49 skip 
   truserid         colon 20
   truserid1        label {t001.i} colon 49 skip (1)


   
   type           colon 20 skip

with overlay frame a side-labels.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).


/*K0PG*/ {wbrp01.i}

repeat:
	
    if loc1  = hi_char then loc1  = "".
    if LINE1  = hi_char then LINE1  = "".
   if truserid1 = hi_char then truserid1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.


	 update nbr nbr1 trdate trdate1 part
			part1 site site1 so_job so_job1 LOC LOC1  
/* SS 090524.1 - B */
		 	LINE LINE1 truserid truserid1 			
/* SS 090524.1 - E */
			type with frame a.

/*K0PG*/ if (c-application-mode <> 'web':u) or
/*K0PG*/ (c-application-mode = 'web':u and
/*K0PG*/ (c-web-request begins 'data':u)) then do:


   bcdparm = "".
   {mfquoter.i nbr         }
   {mfquoter.i nbr1        }
   {mfquoter.i trdate      }
   {mfquoter.i trdate1     }
   {mfquoter.i part        }
   {mfquoter.i part1       }
   {mfquoter.i site        }
   {mfquoter.i site1       }
   {mfquoter.i so_job      }
   {mfquoter.i so_job1     }
   {mfquoter.i LOC      }
   {mfquoter.i LOC1     }
   {mfquoter.i LINE      }
   {mfquoter.i LINE1     }

   {mfquoter.i truserid      }
   {mfquoter.i truserid1     }

   {mfquoter.i type        }


   if nbr1 = "" then nbr1 = hi_char.
   if  loc1  = "" then loc1  = hi_char.
   if  LINE1  = "" then LINE1  = hi_char.
   if  truserid1  = "" then truserid1  = hi_char. 
   if trdate = ? then trdate = low_date.
   if trdate1 = ? then trdate1 = hi_date.



/*K0PG*/ end.
   /* SELECT PRINTER */

					{mfselbpr.i "printer" 132}   



   {mfphead.i}

FOR each tr_hist where 
	tr_domain = global_domain and /*---Add by davild 20090205.1*/
	(tr_nbr >= nbr and (tr_nbr <= nbr1 OR nbr1 = ""))
   and (tr_effdate >= trdate and tr_effdate <= trdate1)
   and (tr_part >= part) and (tr_part <= part1 or part1 = "")
   and (tr_so_job >= so_job) and (tr_so_job <= so_job1 or so_job1 = "")
   and (tr_site >= site) and (tr_site   <= site1   or site1 = "")
   and (tr_loc >= loc and tr_loc <= loc1)
   and (tr_PROD_LINE >= LINE and tr_PROD_LINE <= LINE1)
   and (tr_userid >= truserid and tr_userid <= truserid1) 
   and (tr_type = type or type = "")
   and (tr_type <> "ORD-SO" or type = "ORD-SO")
/*G028*/ and (tr_type <> "ORD-PO" or type = "ORD-PO"),
    EACH TRGL_DET WHERE 
    trgl_domain = global_domain 
    and TRGL_TRNBR = TR_TRNBR AND TRGL_GL_AMT <> 0 
/*FO38   use-index tr_eff_trnbr    
/*FO38*/   use-index tr_nbr_eff */
   no-lock break by tr_nbr by tr_effdate by tr_part with frame b down width 620:
	 setframelabels(frame b:handle).
      if first-of(tr_nbr) then do:
     if page-size - line-counter < 4 then page.
     if not first(tr_nbr) then put skip(1).
     display WITH STREAM-IO /*GUI*/ .
     /*put {&ictrrp02_p_1}*/display tr_nbr label "订单".
      end.
      IF TR_TYPE = "ISS-WO" OR TR_TYPE = "RJCT-WO" THEN DO:
      FIND WO_MSTR WHERE 
	  wo_domain = global_domain and /*---Add by davild 20090205.1*/
	  WO_LOT = TR_LOT  no-lock no-error.
      IF available WO_MSTR THEN
      FIND FIRST RO_DET WHERE 
	  ro_domain = global_domain and /*---Add by davild 20090205.1*/
	  RO_ROUTING = WO_PART AND SUBSTRING(RO_WKCTR,1,2) <> "23"  no-lock no-error.
      END.


      desc1 = "".
      find pt_mstr where 
	  pt_domain = global_domain and /*---Add by davild 20090205.1*/
	  pt_part = tr_part no-lock no-error.
/*K003*  if available pt_mstr then desc1 = pt_desc1.  *K003*/
/*K003*/ if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.
      find IN_mstr where 
	  in_domain = global_domain and /*---Add by davild 20090205.1*/
	  IN_part = tr_part AND IN_SITE = TR_SITE no-lock no-error.

            
               
  /*  FIND TRGL_DET WHERE TRGL_TRNBR = TR_TRNBR NO-LOCK NO-ERROR.*/
   if tr_type = "rct-po"   
      then do:
      find prh_hist WHERE 
	  prh_domain = global_domain and /*---Add by davild 20090205.1*/
	  TR_LOT = PRH_RECEIVER AND TR_NBR = PRH_NBR AND TR_PART = PRH_PART and tr_line = prh_line no-lock no-error.
      find ad_mstr where 
	  ad_domain = global_domain and /*---Add by davild 20090205.1*/
	  ad_addr = tr_addr no-lock no-error.
     end.
      if page-size - line-counter < 2 then page.
         
/*K003* display  tr_part tr_LOC tr_site tr_lot
 *K003*   tr_trnbr tr_date tr_effdate tr_type tr_um tr_qty_req
 *K003* /*FR49*/          format "->>,>>>,>>9.9<<<<<<<<<"
 *K003*   /*F584*/ tr_qty_loc @
 *K003*   tr_qty_chg
 *K003*   tr_so_job tr_ship_type tr_addr 
         ad_mame  when available ad_mstr
         tr_rmks.
 *K003* if available pt_mstr then do:
 *K003* /*G1FN*         put pt_desc1 + " " + pt_desc2 format "X(49)" at 3. */
 *K003* /*G1FN*/ put pt_desc1 + " " + pt_desc2 format "X(49)" at 3 skip.
 *K003* end.
 *K003*/


/*K003*/ display
/*K003*/     tr_part 
             DESC1
             PT_BUYER WHEN AVAILABLE PT_MSTR
             tr_um
             tr_LOC 
             TR_PROD_LINE label "类别" 
             tr_lot
             tr_trnbr 
             prh_ps_nbr  when available prh_hist 
            /* tr_date */
             tr_effdate 
             tr_type 
             tr_ship_type 
             tr_addr 
          /*   ad_name when available ad_mstr and tr_type = "rct-po"*/
             tr_rmks /*K003*/    
           /*  AD_NAME WHEN AVAILABLE AD_MSTR*/
          TR_PRICE LABEL "价  格"  /** WHEN TR_TYPE = "CST-ADJ" **/
             TR_CURR
             TR_SERIAL
             TR_EX_RATE2
             WO_QTY_RJCT WHEN AVAILABLE WO_MSTR AND TR_TYPE = "RJCT-WO"
             TRGL_DR_ACCT WHEN AVAILABLE TRGL_DET 
             TRGL_DR_CC WHEN AVAILABLE TRGL_DET  
             TRGL_CR_ACCT WHEN AVAILABLE TRGL_DET 
             TRGL_CR_CC WHEN AVAILABLE TRGL_DET  
             tr_qty_loc @ tr_qty_chg 
             IN_QTY_OH label "当前库存" when available in_mstr
           /*  TR_USERID*/
/*K003*/    /*desc1 at 6 tr_ship_id tr_ship_date tr_ship_inv_mov*/ WITH STREAM-IO /*GUI*/ .

/* SS 090524.1 - B */
/*      
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
*/
/* SS 090524.1 - E */

   end.

   /* REPORT TRAILER */

/* SS 090524.1 - B */
/*
    {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .
*/
	
 	 {mfreset.i}
	 {mfgrptrm.i}
/* SS 090524.1 - E */



end.

/*K0PG*/ {wbrp04.i &frame-spec = a}
