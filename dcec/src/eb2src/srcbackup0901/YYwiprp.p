/* GUI CONVERTED from iclorp.p (converter v1.76) Mon Apr  8 13:49:11 2002 */
/* iclorp.p - PART LOCATION REPORT                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 07/17/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 09/15/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 09/09/87   BY: WUG *A94**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88    BY: WUG *A175**/
/* REVISION: 6.0      LAST MODIFIED: 05/14/90    BY: WUG *D002**/
/* REVISION: 6.0      LAST MODIFIED: 07/10/90    BY: WUG *D051**/
/* REVISION: 6.0      LAST MODIFIED: 01/07/91    BY: emb *D337**/
/* REVISION: 6.0      LAST MODIFIED: 10/07/91    BY: SMM *D887*/
/* REVISION: 7.3      LAST MODIFIED: 04/16/93    BY: pma *G960*/
/* REVISION: 8.6      LAST MODIFIED: 10/16/97    BY: mur *K0NQ*/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.13 $    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*Revision: Eb2 + sp7       Last modified: 08/04/2005             By: Judy Liu   */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
&SCOPED-DEFINE wiprp_p_1 "Summary/Detail"

{mfdtitle.i "b+ "}

define variable part like pt_part.
define variable part1 like pt_part.
define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable um like pt_um.
/*judy 05/08/04*/ DEFINE VAR stat LIKE IS_status.
/*judy 05/08/04*/ DEFINE VAR stat1 LIKE IS_status. 
/*judy 05/08/04*/ DEFINE VAR keeper AS CHAR.
/*judy 05/08/04*/ DEFINE VAR keeper1 AS CHAR.
/*judy 05/08/04*/ DEFINE VARIABLE  summary_only like mfc_logical
   label {&wiprp_p_1} format {&wiprp_p_1} initial no.
/*judy 05/08/04 begin added*/ 
DEFINE VAR xxstat AS CHAR FORMAT "x(14)" EXTENT 20 .
DEFINE VAR k AS INTE.
DEFINE VAR i AS INTE.
DEF VAR n AS INTE.
DEFINE TEMP-TABLE xxld
     FIELD  xxld_part LIKE pt_part
    FIELD xxld_site LIKE si_site
    FIELD xxld_keeper AS CHAR
    FIELD xxld_um LIKE pt_um
    FIELD xxld_qty LIKE ld_qty_oh
    FIELD xxld_seq AS INTE
    FIELD xxld_stat LIKE IS_status EXTENT 20
    FIELD xxld_stqty LIKE ld_qty_oh EXTENT 20.
/*judy 05/08/04 end added*/ 



/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
part           colon 15
   part1          label "To" colon 49 skip
   site           colon 15
   site1          label "To" colon 49 skip
   loc            colon 15
   loc1           label "To" colon 49 skip
/*judy 05/08/04*/   stat     COLON  15
/*judy 05/08/04*/   stat1 COLON 49 LABEL {t001.i} SKIP
/*judy 05/08/04*/   keeper COLON 15
/*judy 05/08/04*/   keeper1 COLON 49 LABEL {t001.i} SKIP
/*judy 05/08/04*/   SUMMARY_only  COLON 15

 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}

/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
/*judy 05/08/04*/   IF stat1 = hi_char  THEN stat1 = "".
/*judy 05/08/04*/   IF keeper1 = hi_char THEN keeper1 = "".

   if c-application-mode <> 'web' then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update
      &fields = "  part part1 site site1 loc loc1 stat stat1 keeper keeper1 summary_only" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i loc    }
      {mfquoter.i loc1   }
/*judy 05/08/04*/    {mfquoter.i stat   }
 /*judy 05/08/04*/    {mfquoter.i stat1  }           
 /*judy 05/08/04*/    {mfquoter.i keeper  }           
 /*judy 05/08/04*/    {mfquoter.i keeper1  }           
 /*judy 05/08/04*/    {mfquoter.i SUMMARY_only  }           
          
       if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
/*judy 05/08/04*/ IF stat1 = "" THEN stat1 = hi_char.
/*judy 05/08/04*/  IF keeper1  = "" THEN keeper1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

/*judy 05/08/04*/ FOR EACH xxld:
/*judy 05/08/04*/    DELETE xxld.
/*judy 05/08/04*/  END.

   {mfphead.i}


/*judy 05/08/04*/   IF SUMMARY_only = NO THEN DO:
   for each ld_det no-lock
      where (ld_part >= part and ld_part <= part1)
      and (ld_site >= site and ld_site <= site1)
      and (ld_loc >= loc and ld_loc <= loc1)
/*judy 05/08/04*/   AND (ld_status >= stat AND ld_status <= stat1)
      use-index ld_loc_p_lot,
      each pt_mstr no-lock where pt_part = ld_part,
      each loc_mstr no-lock where loc_loc = ld_loc and loc_site = ld_site,
/*judy 05/08/04*/  EACH IN_mstr WHERE IN_site = ld_site AND IN_part   = ld_part
/*judy 05/08/04*/     AND in__qadc01 >= keeper AND in__qadc01 <= keeper1  NO-LOCK,
      each is_mstr no-lock where is_status = ld_status
   break by ld_site by ld_loc by ld_part by ld_lot 
   with frame b width 200:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
 
    /****judy 05/08/04  begin delete****/
         /* if first-of(ld_lot) and last-of(ld_lot) and ld_ref = ""
          then do:
             display
                ld_site
                ld_loc
                ld_part
                IN__qad01
                ld_lot   column-label "Lot/Serial!Ref"
                pt_um
                ld_qty_oh
                 ld_date
                ld_expire
                ld_assay
                ld_grade 
                ld_status
                is_avail
                is_nettable
                is_overissue WITH STREAM-IO /*GUI*/ .
          end.
    
          else do:
             if first-of(ld_lot) then do:
                display ld_site ld_loc ld_part ld_lot WITH STREAM-IO /*GUI*/ .
                down 1.
             end.
             display
                ld_ref @ ld_lot
                pt_um
                ld_qty_oh
                ld_date
                ld_expire
                ld_assay
                ld_grade 
                ld_status
                is_avail
                is_nettable
                is_overissue WITH STREAM-IO /*GUI*/ .
          end.*/
   /****judy 05/08/04 end delete****/      
      display
                ld_site
                ld_loc
                ld_part
                pt_desc1 
                pt_desc2
                IN__qadc01
                ld_lot   column-label "Lot/Serial!Ref"
                pt_um
                ld_qty_oh 
                ld_status
                is_avail
                is_nettable
                is_overissue WITH STREAM-IO /*GUI*/ .

                  /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).
          
            if last-of(ld_loc) then do:
             down 1.
          end.
 /*judy 05/08/04*/ END. /*end of for each ld_det*/
   END. /*end of if summary_only = no*/
 
   ELSE   IF SUMMARY_only = YES THEN DO:
          i = 0.
          n = 0.
           FOR  each ld_det no-lock
              where (ld_part >= part and ld_part <= part1)
              and (ld_site >= site and ld_site <= site1)
              and (ld_loc >= loc and ld_loc <= loc1)
/*judy 05/08/04*/   AND (ld_status >= stat AND ld_status <= stat1)
              use-index ld_loc_p_lot,
              each pt_mstr no-lock where pt_part = ld_part,
              each loc_mstr no-lock where loc_loc = ld_loc and loc_site = ld_site,
        /*judy 05/08/04*/  EACH IN_mstr WHERE IN_site = ld_site AND IN_part   = ld_part
         /*judy 05/08/04*/     AND in__qadc01 >= keeper AND in__qadc01 <= keeper1  NO-LOCK,
              each is_mstr no-lock where is_status = ld_status
           break  by ld_status by ld_site  by ld_part :
        
              /* SET EXTERNAL LABELS */
              setFrameLabels(frame b:handle).
        
           
              IF FIRST-OF(ld_status) THEN  i =  i + 1.

                          FIND FIRST xxld WHERE xxld_site = ld_site AND xxld_part = ld_part  NO-LOCK NO-ERROR.
                          IF NOT AVAIL xxld THEN DO:
                            CREATE xxld.
                            ASSIGN xxld_site = ld_site 
                                          xxld_part = ld_part
                                          xxld_um = pt_um
                                          xxld_keeper =  IN__qadc01
                                          xxld_seq =  i 
                                          xxld_stat[xxld_seq] = ld_status
                                          xxstat [xxld_seq] = ld_status.
                                        
                        END.
                        ELSE  IF AVAIL xxld THEN DO: 
                             ASSIGN xxld_seq = i 
                                       xxld_stat[xxld_seq] = ld_status
                                        xxstat [xxld_seq] = ld_status.
                        END.
                      
            

               xxld_qty =  xxld_qty + ld_qty_oh.
                
               xxld_stqty[xxld_seq] = xxld_stqty[xxld_seq] + ld_qty_oh.
               IF n < i  THEN n = i.
             /* MESSAGE i ld_site  ld_part " ld_status="  ld_status  ld_qty_oh " xxld_stat[xxld_seq] = " xxld_stat[xxld_seq]  "xxld_stqty[xxld_seq]=" xxld_stqty[xxld_seq]  
                   "xxld_seq = " xxld_seq.
               PAUSE. */
               /*IF LAST-OF (ld_part) THEN  i = 0.*/
 
             
    END.   /* for each ld_det*/
   
    PUT "地点"  AT 1   "零件" AT 10  "UM" AT 29  "保管员  " AT 32    "当前库存量   "    AT 40.
    DO k =1 TO n  :
           PUT  xxstat[k] "　".
    END.
    PUT  "" SKIP.
    
    PUT "-------------------------------------------------------------".
    DO k =1 TO n  :
          PUT "-------------" .
    END.
   PUT "-" SKIP.

     FOR EACH xxld NO-LOCK BREAK BY xxld_site BY xxld_part with frame c width 200:
         PUT  xxld_site AT 1 xxld_part AT 10  xxld_um AT 29  xxld_keeper AT 32 xxld_qty AT 40.
         DO k =1 TO n :
              PUT  xxld_stqty[k] " " .
         END.
         PUT "" SKIP.
     END.
 

   end. /*end of else if summary = yes then do*/

   /*judy 05/08/04  end  added*/ 

   /* REPORT TRAILER  */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.  /*manin loop*/

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 site site1 loc loc1 stat stat1 keeper keeper1 summary_only "} /*Drive the Report*/
