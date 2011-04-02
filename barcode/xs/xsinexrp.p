
/* xsinexrp.p - BARCODE SYSTEM INVENTORY EXPIRE REPORT -- Softspeed Sam Song          */
/* Copyright 2006 Softspeed Conusltant Ltd.,                       */
/**Ver: 1******************************Sam Song 20060315 ***********/

{mfdtitle.i "b+ "}

define variable site  		        like ld_site        no-undo.
define variable site1		        like ld_site        no-undo.
define variable line  		        like pt_prod_line   no-undo.
define variable line1		        like pt_prod_line   no-undo.

define variable part			like ld_part        no-undo.
define variable part1		like ld_part        no-undo.
define variable loc			like ld_loc         no-undo.
define variable loc1 		like ld_loc        no-undo.
define variable includingErrorFormat      as   logical label "Including Error Format LOT".
define variable wexpiredate  as integer label "After Expire Date (Days)"  no-undo.

DEFINE VARIABLE V1500 AS CHAR FORMAT "x(25)" INIT "".  /*  LOT */
DEFINE VARIABLE V1300 LIKE pt_part .                   /*  PART */                        


/* DEFINE SELECTION FRAME */
form
   site		colon 25 label "SITE"
   site1	        colon 50 label {t001.i}
   line		colon 25 label "PROD LINE"
   line1	        colon 50 label {t001.i}
   loc                colon 25 label "LOC"
   loc1              colon 50 label {t001.i}
   part	        colon 25 label "PART"
   part1             colon 50 label {t001.i}
   skip (2)
   

   includingErrorFormat   colon 25 label "包括不規則的LOT"
   wexpiredate      colon 35        no-label   
   "天後將過期的物料"    skip (1)

with frame a width 80 side-labels.
 setFrameLabels(frame a:handle).
 
{wbrp01.i}

repeat:

   /* RESET HI CHARACTER VALUES */
   if site1     = hi_char  then site1   = "".
   if line1     = hi_char  then line1   = "".

   if loc1     = hi_char  then loc1   = "".
   if part1     = hi_char  then part1   = "".
 
   if c-application-mode <> "WEB" then
   update
      site
      site1
      line
      line1
      loc
      loc1
      part
      part1
      includingErrorFormat
      wexpiredate
   with frame a.

   {wbrp06.i &command = update
      &fields = "site site1 line line1 loc loc1
                 part      part1
		 includingErrorFormat wexpiredate"
      &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:
      /* ALLOCATION DETAIL NOT ALLOWED WITH SUMMARY REPORT */

      bcdparm = "".
      {mfquoter.i site       }
      {mfquoter.i site1     }
      {mfquoter.i line       }
      {mfquoter.i line1     }

      {mfquoter.i loc       }
      {mfquoter.i loc1     }
      {mfquoter.i part          }
      {mfquoter.i part1         }
      {mfquoter.i includingErrorFormat       }
      {mfquoter.i wexpiredate      }

      if site1     = "" then site1     = hi_char.
      if line1     = "" then line1     = hi_char.

      if loc1     = "" then loc1      = hi_char.
      if part1     = "" then part1     = hi_char.
      
   end.  /* if c-application-mode <> "WEB" ... */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
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

   {mfphead.i}
     
	for each ld_det where ld_site >= site and ld_site <= site1  and 
					   ld_loc >= loc  and ld_loc <=loc1    and 
					   ld_part >=part and ld_part <=part1 and
					   ld_qty_oh <> 0  and ld_lot <> ""  no-lock ,
	    each pt_mstr where pt_part = ld_part and pt_prod_line >= line and pt_prod_line <= line1 no-lock :
			       

       V1500 = ld_lot .
       V1300 = ld_part.
       {xsinex01.i}
       if ( expireinv = ? and includingErrorFormat = yes ) or ( expireinv - today  <  wexpiredate ) then 
       display ld_site		label "地點"  
                    ld_loc		column-label "!庫位"
		    ld_part		column-label "!料品"
		    ld_lot           column-label  "批號"
		    ld_qty_oh    column-label "庫存數"
		    wptavgint     column-label "保質期(M)" 
		    expireinv      column-label "LOT到期日"
		    if expireinv - today = ? then  0 else expireinv - today
		    column-label "過N天後過期"  WITH STREAM-IO width 200.
       
        



	end.



	   {mfrtrail.i}
	end.  /* repeat */

{wbrp04.i &frame-spec = a}
