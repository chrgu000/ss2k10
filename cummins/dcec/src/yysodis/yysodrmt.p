/* GUI CONVERTED from yysodrmt.p (converter v1.78) Thu Nov 22 14:14:21 2012 */
/* yysodrmt.p - yysodrmt.p                                                   */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 121121.1 LAST MODIFIED: 11/21/12 BY: zy                         */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "121121.1}

define variable mc-error-number like msg_nbr no-undo.

define variable del-yn        like mfc_logical initial no.
define variable i             as integer.
define variable qty_label     as character format "x(7)" extent 3.
define variable amt_label     as character format "x(14)" extent 3.
define variable list_label    as character format "x(24)".

define variable price         as character.
define variable discount      as character.
define variable markup        as character.
define variable ptable_label  as character format "x(23)".
define variable min_label     as character format "x(14)".
define variable max_label     as character format "x(14)".
define variable pcamttype     like yp_amt_type.
define variable old_db        like si_db.
define variable err_flag      as integer.
define variable base_curr1    like base_curr.
define variable base_curr2    like base_curr.
define variable glxcst_tl     like sct_cst_tot.
define variable v_prod_line   like pt_prod_line.
define variable temp_max_price like yp_max_price extent 0 decimals 10
   no-undo.
define variable disp-initial-adjust as character no-undo format "x(22)".
define variable disp-stock-um as character no-undo format "x(12)".
define variable disp-total-this-level-gl as character no-undo format "x(29)".
define variable disp-site-col as character no-undo format "x(10)".
define variable disp-total-gl-cost as character no-undo format "x(28)".
define variable msg-arg1 as character format "x(16)" no-undo.
define variable msg-arg2 as character format "x(16)" no-undo.

/* Variable added to perform delete during CIM. Record is deleted
 * Only when the value of this variable is set to "X" */
define variable batchdelete as   character format "x(1)" no-undo.
define variable l_yn        like mfc_logical             no-undo.

/*VARIABLE DEFINITIONS FOR GPFIELD.I*/
{gpfieldv.i}

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
yp_list        colon 29
   yp_curr        colon 50
   v_prod_line    colon 29
   yp_cust        colon 29
   yp_Market			colon 52
   yp_part        colon 29   pt_desc1 at 52 NO-LABEL
   yp_um          colon 29
   yp_start       colon 29   batchdelete at 52 no-label
   yp_expire      colon 29
   yp_amt_type    colon 29
   disp-initial-adjust no-label
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   /*   list_label     to 29 pt_price base_curr                  */
   /*   disp-stock-um  to 65 pt_um  at 68                        */
   /*   /*V8-*/                                                  */
   /*   disp-total-this-level-gl    to 29                        */
   /*   glxcst_tl                   to 46                        */
   /*   base_curr1 disp-site-col    to 65 pt_site                */
   /*   disp-total-gl-cost          to 29                        */
   /*   glxcst                      to 46 base_curr2             */
   /*V8+*/
        
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
disp-total-this-level-gl    at 7
   glxcst_tl                   at 31
   base_curr1 disp-site-col    at 57 pt_site at 68
   disp-total-gl-cost          at 9
   glxcst                      at 31 base_curr2   
   /*V8+*/
        
   qty_label[1]   at  2 amt_label[1] at 11
   qty_label[2]   at 27 amt_label[2] at 36
   qty_label[3]   at 52 amt_label[3] at 61   
   skip
   /*V8+*/
        
   yp_min_qty[1]  at 2  yp_amt[1]  at 10 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[6]  at 27 yp_amt[6]  at 35 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[11] at 52 yp_amt[11] at 60 format "->>>,>>>,>>9.9<<<<"
   skip
   yp_min_qty[2]  at 2  yp_amt[2]  at 10 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[7]  at 27 yp_amt[7]  at 35 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[12] at 52 yp_amt[12] at 60 format "->>>,>>>,>>9.9<<<<"
   skip
   yp_min_qty[3]  at 2  yp_amt[3]  at 10 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[8]  at 27 yp_amt[8]  at 35 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[13] at 52 yp_amt[13] at 60 format "->>>,>>>,>>9.9<<<<"
   skip
   yp_min_qty[4]  at 2  yp_amt[4]  at 10 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[9]  at 27 yp_amt[9]  at 35 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[14] at 52 yp_amt[14] at 60 format "->>>,>>>,>>9.9<<<<"
   skip
   yp_min_qty[5]  at 2  yp_amt[5]  at 10 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[10] at 27 yp_amt[10] at 35 format "->>>,>>>,>>9.9<<<<"
   yp_min_qty[15] at 52 yp_amt[15] at 60 format "->>>,>>>,>>9.9<<<<"          
   skip
 SKIP(.4)  /*GUI*/
with frame b no-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
/**************
form
   list_label     to 29 pt_price base_curr
   disp-stock-um  to 65 pt_um at 68
   /*V8-*/
   disp-total-this-level-gl    to 29
   glxcst_tl                   to 46
   base_curr1 disp-site-col    to 65 pt_site at 68
   disp-total-gl-cost          to 29
   glxcst                      to 46 base_curr2
   skip(1)
   ptable_label   to 29 yp_amt[1]
   min_label      to 29 yp_min_price
   max_label      to 29 temp_max_price
   /*V8+*/
   /*V8!
   disp-total-this-level-gl    at 7
   glxcst_tl                   at 31
   base_curr1 disp-site-col    at 57 pt_site at 68
   disp-total-gl-cost          at 9
   glxcst                      at 31 base_curr2
   skip(1)
   ptable_label at 12 yp_amt[1]      at 31
   min_label    at 17 yp_min_price   at 31
   max_label    at 17 temp_max_price at 31 */
   skip(2)
with frame c overlay no-labels row 11 width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
**/

assign
   list_label = " " + getTermLabel("ITEM_MASTER_LIST_PRICE",23) + ":"
   disp-initial-adjust =
           "I-" + getTermLabel("INITIAL",7) + " " +
           "A-" + getTermLabel("ADJUST",10)
   disp-stock-um = getTermLabelRtColon("STOCK_UM",12)
   disp-total-this-level-gl = getTermLabelRtColon("TOTAL_THIS_LEVEL_GL_COST",29)
   disp-site-col = getTermLabelRtColon("SITE",10)
   disp-total-gl-cost = getTermLabelRtColon("TOTAL_GL_COST",28).

assign
   qty_label = getTermLabel("MINIMUM_QUANTITY",7)
   price     = getTermLabelRt("PRICE",14)
   markup    = getTermLabelRt("MARKUP",13) + "%"
   discount  = getTermLabelRt("DISCOUNT",14)
   amt_label = DISCOUNT
   ptable_label = getTermLabel("PRICE_TABLE_LIST_PRICE",22) + ":"
   min_label    = getTermLabelRtColon("MINIMUM_PRICE",14)
   max_label    = getTermLabelRtColon("MAXIMUM_PRICE",14).

/* DISPLAY */
view frame a.

display
   disp-initial-adjust
   base_curr @ yp_curr
with frame a.

main-loop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Initialize batchdelete variable */
   batchdelete = "".

   prompt-for
      yp_list
      yp_curr
      yp_cust
      yp_market
			yp_part
      yp_um
      yp_start
      /* Prompt for batchdelete variable only during CIM */
      batchdelete no-label when (batchrun)
   editing:

    if frame-field = 'yp_list' then
    do:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i yp_mstr yp_list  " yp_domain = global_domain and yp_list
      "  yp_list yp_list yp_list}

      run disp_proc.

      end.
 
      else
      if frame-field = "yp_part" then do:
     {mfnp05.i yp_mstr yp_list "yp_domain = global_domain and yp_list = input yp_list " yp_part "input yp_part"}

       run disp_proc.

     end. /* if frame-field = "yp_part"  */
       else do:
         readkey.
         apply lastkey.
       end.

   end. /* editing: */
	
	 if input yp_list = "" then do:
	 		{pxmsg.i &MSGNUM=2128 &ERRORLEVEL=3 &MSGARG1=yp_list}
	 		next-prompt yp_list.
	 		undo.
	 end.	
	
   if input yp_part <> "" then do:
      /* Product Line or Item must be blank */
      find first pt_mstr no-lock where pt_domain = global_domain 
      			 and pt_part = input yp_part no-error.
      if not available pt_mstr then do:
      	{pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
      	next-prompt yp_part.
      	undo.
      end.
   end.
	
	 if input yp_cust <> "" and 
	 	  not can-find(first cm_mstr no-lock where cm_domain = global_domain
	 	  							 and cm_addr = input yp_cust) then do:
			 {pxmsg.i &MSGNUM=2264 &ERRORLEVEL=3}
      	next-prompt yp_cust.
      	undo.
	 
	 end.
	 			
	
   /* VALIDATE CURRENCY CODE */
   if input yp_curr <> base_curr then do:

      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input input yp_curr,
                  output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         /* INVALID CURRENCY CODE */
         next-prompt yp_curr.
         undo main-loop, retry.
      end. /* if mc-error-number <> 0 then do: */
   end. /* if input yp_curr <> base_curr then do: */


   /* ADD/MOD/DELETE  */

find first yp_mstr using yp_list and yp_part and yp_start
   where yp_domain = global_domain no-error.
   if not available yp_mstr then do:

      if input yp_part      = ""
      and not batchrun
      then do:

         /* PRICE LIST WILL APPLY TO ALL ITEMS. CONTINUE? */
         {pxmsg.i &MSGNUM=6720 &ERRORLEVEL=2 &CONFIRM=l_yn}

         if not l_yn
         then do:
            next-prompt
               yp_part.
            undo, retry.
         end. /* IF NOT l_yn */
      end. 

      /* ADDING NEW RECORD */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create yp_mstr. yp_domain = global_domain.
      assign
         yp_list
         yp_part
         yp_start.
   end. /* if not available yp_mstr then do: */
      assign   yp_cust
               yp_curr
               yp_market
               yp_um.



   /* STORE MODIFY DATE AND USERID */
   yp_mod_date = today.
   yp_userid = global_userid.

   if yp_curr = "" then assign yp_curr = base_curr.

   if (yp_curr <> input yp_curr) and
      (yp_curr <> "" and input yp_curr <> "" )
   then do:
      /* Currency cannot be changed */
      {pxmsg.i &MSGNUM=84 &ERRORLEVEL=3}
      undo, retry.
   end. /* then do: */

   amt_label = DISCOUNT.

   recno = recid(yp_mstr).

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry with frame a no-validate:
/*GUI*/ if global-beam-me-up then undo, leave.


      update
         yp_expire
         yp_amt_type
      go-on ("F5" "CTRL-D").

      if yp_expire <> ? and yp_start <> ? and
         yp_expire < yp_start
      then do:
         /* Expiration date precedes start date */
         {pxmsg.i &MSGNUM=6221 &ERRORLEVEL=2}
      end. /* and yp_expire < yp_start then do: */

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Delete record if batchdelete is set to "x" */
      or input batchdelete = "x"
      then do:
         del-yn = yes.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.
      end. /* then do: */

      /* MANUALLY VALIDATE PRICE LIST TYPE*/
      if index("IA", yp_amt_type) = 0 then do:
         /* VALID PRICE LIST TYPES ARE (P), (M), (D), AND (L).*/
         {pxmsg.i &MSGNUM=28000 &ERRORLEVEL=3}
         next-prompt yp_amt_type with frame a.
         undo, retry.
      end.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry with frame a no-validate: */

   if del-yn then do:

      delete yp_mstr.

      clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
      clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
/*      clear frame c. */

      display
         base_curr @ yp_curr
      with frame a.

      display
    /*     list_label */
         qty_label
         amt_label
      with frame b.

 /*      display                           */
 /*         disp-stock-um                  */
 /*         disp-total-this-level-gl       */
 /*         disp-site-col                  */
 /*         disp-total-gl-cost             */
 /*      with frame b.                     */

      del-yn = no.
      next main-loop.

   end. /* if del-yn then do: */

   else do:

      /* GET ITEM COST FROM DEFAULT SITE */
   /*   find pt_mstr where pt_domain = global_domain                         */
   /*                  and pt_part = yp_part                                 */
   /*   no-lock no-error.                                                    */
   /*                                                                        */
   /*   if available pt_mstr then do:                                        */
   /*                                                                        */
   /*      find si_mstr where si_domain = global_domain                      */
   /*                     and si_site = pt_site no-lock.                     */
   /*                                                                        */
   /*      if si_db <> global_db then do:                                    */
   /*         old_db = global_db.                                            */
   /*         {gprun.i ""gpmdas.p"" "(input si_db, output err_flag)" }       */
   /*      end. /* if si_db <> global_db then do: */                         */
   /*                                                                        */
   /*      {gprun.i ""gpsct05.p""                                            */
   /*         "(pt_part, si_site, 3, output glxcst, output curcst)" }        */
   /*      glxcst_tl = glxcst.                                               */
   /*                                                                        */
   /*      {gpsct05.i &part=pt_part &site=si_site &cost="sct_ovh_tl"}        */
   /*      glxcst_tl = glxcst_tl - glxcst.                                   */
   /*                                                                        */
   /*      {gprun.i ""gpsct05.p""                                            */
   /*         "(pt_part, si_site, 1, output glxcst, output curcst)" }        */
   /*                                                                        */
   /*      if old_db <> global_db then do:                                   */
   /*         {gprun.i ""gpmdas.p"" "(input old_db, output err_flag)" }      */
   /*      end. /* if old_db <> global_db then do: */                        */
   /*                                                                        */
   /*   end. /* if available pt_mstr then do: */                             */
   /*                                                                        */
   /*   if yp_amt_type = "I" then                                            */
   /*      amt_label = discount.                                             */
   /*   else if yp_amt_type = "A" then                                       */
         amt_label = discount.

      /* DISCOUNT TABLE */
      if index("IA", yp_amt_type) <> 0 then do:

/*         hide frame c.  */
         view frame b.
         clear frame b no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

         display
            yp_list
            yp_curr
            yp_part
            yp_cust
            v_prod_line
            yp_market
            yp_part
            yp_um
            yp_start.

         display
            /* list_label */
            qty_label
            amt_label
         with frame b.

   /*      display                                     */
   /*         disp-stock-um                            */
   /*         disp-total-this-level-gl                 */
   /*         disp-site-col                            */
   /*         disp-total-gl-cost                       */
   /*      with frame b.                               */

         display
            yp_min_qty
            yp_amt
         with frame b.

    /*    if available pt_mstr then do:                          */
    /*       display pt_desc1.                                   */
    /*       display                                             */
    /*          pt_price                                         */
    /*          base_curr                                        */
    /*          pt_um                                            */
    /*          glxcst_tl                                        */
    /*          base_curr @ base_curr1                           */
    /*          pt_site                                          */
    /*          glxcst                                           */
    /*          base_curr @ base_curr2                           */
    /*       with frame b.                                       */
    /*    end. /* if available pt_mstr then do: */               */

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            set
               yp_min_qty[01] yp_amt[01] yp_min_qty[02] yp_amt[02]
               yp_min_qty[03] yp_amt[03] yp_min_qty[04] yp_amt[04]
               yp_min_qty[05] yp_amt[05] yp_min_qty[06] yp_amt[06]
               yp_min_qty[07] yp_amt[07] yp_min_qty[08] yp_amt[08]
               yp_min_qty[09] yp_amt[09] yp_min_qty[10] yp_amt[10]
               yp_min_qty[11] yp_amt[11] yp_min_qty[12] yp_amt[12]
               yp_min_qty[13] yp_amt[13] yp_min_qty[14] yp_amt[14]
               yp_min_qty[15] yp_amt[15]
            go-on ("F5" "CTRL-D")
            with frame b width 80.

            /* DELETE */
            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:

               del-yn = yes.
               /* Please confirm delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

               if del-yn = no then undo, retry.

               delete yp_mstr.

               clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
               clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

               display
                  list_label
                  qty_label
                  amt_label
               with frame b.

               display
                  disp-stock-um
                  disp-total-this-level-gl
                  disp-site-col
                  disp-total-gl-cost
               with frame b.

               del-yn = no.
               next main-loop.

            end. /* then do: */

            do i = 1 to 15:

               if i > 1 then
               if yp_min_qty[i - 1] >= yp_min_qty[i]
                  and (yp_min_qty[i] <> 0 or yp_amt[i] <> 0)
               then do:
                  /* Min quantities must be in ascending order */
                  {pxmsg.i &MSGNUM=63 &ERRORLEVEL=3}
                  next-prompt yp_min_qty[i] with frame b.
                  undo.
               end. /* and (yp_min_qty[i] <> 0 or yp_amt[i] <> 0) then do: */

               if i > 1 then /* disallow a min qty =0 within the list */
               if (yp_min_qty[i - 1] = 0 and yp_min_qty[i] <> 0)
               then do:
                  if yp_amt[i - 1] = 0 then do:
                     /* Min quantities must be in ascending order */
                     {pxmsg.i &MSGNUM=63 &ERRORLEVEL=3}
                     next-prompt yp_min_qty[i] with frame b.
                     undo.
                  end. /* if yp_amt[i - 1] = 0 then do: */
               end.

            end. /* do i = 1 to 15: */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error retry */

/*       end. /* if p,m,d */                                                  */
/*                                                                            */
/*       /* Price Table */                                                    */
/*       else do:                                                             */
/*                                                                            */
/*          hide frame b.                                                     */
/* /*         view frame c. */                                                */
/* /*         clear frame c no-pause.  */                                     */
/*                                                                            */
/*          temp_max_price = (yp_max_price[1] +  (yp_max_price[2] / 100000)). */
/*                                                                            */
/*          display                                                           */
/*             yp_list                                                        */
/*             yp_curr                                                        */
/*             yp_part                                                        */
/*             yp_cust                                                        */
/*             yp_part                                                        */
/*             yp_um yp_start.                                                */
/*                                                                            */
/*           display                                     */
/*              disp-stock-um                            */
/*              disp-total-this-level-gl                 */
/*              disp-site-col                            */
/*              disp-total-gl-cost                       */
/*           with frame c.                               */
/*                                                       */
/*           display                                     */
/*              list_label                               */
/*              ptable_label                             */
/*              yp_amt[1]                                */
/*              min_label                                */
/*              yp_min_price                             */
/*              max_label                                */
/*              temp_max_price                           */
/*           with frame c.                               */
/*                                                       */
/*         if available pt_mstr then do:                 */
/*            display pt_desc1.                          */
/*            display                                    */
/*               pt_price                                */
/*               base_curr                               */
/*               pt_um                                   */
/*               glxcst_tl                               */
/*               base_curr @ base_curr1                  */
/*               pt_site                                 */
/*               glxcst                                  */
/*               base_curr @ base_curr2                  */
/*            with frame c.                              */
/*         end. /* if available pt_mstr then do: */      */
/*                                                       */
/*         display                                       */
/*            ptable_label                               */
/*            yp_amt[1]                                  */
/*            min_label                                  */
/*            yp_min_price                               */
/*            max_label                                  */
/*            temp_max_price                             */
/*         with frame c.                                 */
/*                                                       */
/*         do on error undo, retry:                                          */
/*                                                                           */
/*            set                                                            */
/*               yp_amt[1] yp_min_price temp_max_price                       */
/*            go-on ("F5" "CTRL-D")                                          */
/*            with frame c width 80.                                         */
/*                                                                           */
/*            yp_max_price[1] = truncate(temp_max_price,2).                  */
/*            yp_max_price[2] = (temp_max_price - yp_max_price[1]) * 100000. */
/*                                                                           */
/*            /* DELETE */                                                   */
/*            if lastkey = keycode("F5")                                     */
/*            or lastkey = keycode("CTRL-D")                                 */
/*            then do:                                                       */
/*               del-yn = yes.                                               */
/*               /* Please confirm delete */                                 */
/*               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}          */
/*               if del-yn = no then undo, retry.                            */
/*               delete yp_mstr.                                             */
/*               clear frame a.                                              */
/*               display base_curr @ yp_curr "" @ pt_desc1.                  */
/*               del-yn = no.                                                */
/*               next main-loop.                                             */
/*            end. /* then do: */                                            */
/*                                                                           */
/*            /* VERIFICATIONS */                                            */
/*            if temp_max_price > 0 then do:                                 */
/*               if yp_min_price > temp_max_price then do:                   */
/*                  /* MINIMUM EXCEEDS MAXIMUM */                            */
/*                  {pxmsg.i &MSGNUM=460 &ERRORLEVEL=3 }                     */
/*                  next-prompt yp_min_price with frame c.                   */
/*                  undo, retry.                                             */
/*               end. /* if yp_min_price > temp_max_price then do: */        */
/*            end. /* if temp_max_price > 0 then do: */                      */
/*                                                                           */
/*            if yp_amt[1] > 0 then do:                                      */
/*                                                                           */
/*               if yp_min_price > 0 then do:                                */
/*                  if yp_amt[1] < yp_min_price then do:                     */
/*                     msg-arg1 = string(yp_amt[1],">>>>>9.99<<<").          */
/*                     msg-arg2 = string(yp_min_price,">>>>>9.99<<<").       */
/*                     /* LIST PRICE IS BELOW PRICE TABLE MINIMUM. */        */
/*                     {pxmsg.i &MSGNUM=6208 &ERRORLEVEL=4                   */
/*                              &MSGARG1=yp_part                             */
/*                              &MSGARG2=msg-arg1                            */
/*                              &MSGARG3=msg-arg2}                           */
/*                     next-prompt yp_amt[1] with frame c.                   */
/*                     undo, retry.                                          */
/*                  end. /* if yp_amt[1] < yp_min_price then do: */          */
/*               end. /* if yp_min_price > 0 then do: */                     */
/*                                                                           */
/*               if temp_max_price > 0 then do:                              */
/*                  if yp_amt[1] > temp_max_price then do:                   */
/*                     msg-arg1 = string(yp_amt[1],">>>>>9.99<<<").          */
/*                     msg-arg2 = string(temp_max_price,">>>>>9.99<<<").     */
/*                     /* LIST PRICE IS ABOVE PRICE TABLE MAXIMUM */         */
/*                     {pxmsg.i &MSGNUM=6209 &ERRORLEVEL=4                   */
/*                              &MSGARG1=yp_part                             */
/*                              &MSGARG2=msg-arg1                            */
/*                              &MSGARG3=msg-arg2}                           */
/*                     next-prompt yp_amt[1] with frame c.                   */
/*                     undo, retry.                                          */
/*                  end. /* if yp_amt[1] > temp_max_price then do: */        */
/*               end. /* if temp_max_price > 0 then do: */                   */
/*                                                                           */
/*            end. /* if yp_amt[1] > 0 then do: */                           */
/*                                                                           */
/*         end. /* do on error retry */                                      */

    end. /* else do: /* PRICE TABLE */ */

   end.  /* else do: */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat with frame a: */

procedure disp_proc:
 if recno <> ? then do:

         find pt_mstr where pt_mstr.pt_domain = global_domain
                        and pt_mstr.pt_part = yp_mstr.yp_part
         no-lock no-error.
			if available pt_mstr then do:
		  	 assign v_prod_line =  pt_prod_line.
		  end.
         display
            yp_list
            yp_curr
            yp_cust
            yp_market
            v_prod_line
            yp_part
            yp_um
            yp_start
            yp_expire
            yp_amt_type
         with frame a.

      amt_label = discount.
      display  qty_label
               amt_label
               yp_min_qty yp_amt with frame b.
         /* Get item cost from default site */
/*        if available pt_mstr then do:                                       */
/*                                                                            */
/*           find si_mstr where si_domain = global_domain                     */
/*                          and si_site = pt_site                             */
/*           no-lock.                                                         */
/*                                                                            */
/*           if si_db <> global_db then do:                                   */
/*              old_db = global_db.                                           */
/*              {gprun.i ""gpmdas.p"" "(input si_db, output err_flag)" }      */
/*           end. /* if si_db <> global_db then do: */                        */
/*                                                                            */
/*           {gprun.i ""gpsct05.p""                                           */
/*              "(pt_part, si_site, 3, output glxcst, output curcst)" }       */
/*           glxcst_tl = glxcst.                                              */
/*                                                                            */
/*           {gpsct05.i                                                       */
/*              &part=pt_part &site=si_site &cost="sct_ovh_tl"}               */
/*           glxcst_tl = glxcst_tl - glxcst.                                  */
/*                                                                            */
/*           {gprun.i ""gpsct05.p""                                           */
/*              "(pt_part, si_site, 1, output glxcst, output curcst)" }       */
/*                                                                            */
/*           if old_db <> global_db then do:                                  */
/*              {gprun.i ""gpmdas.p"" "(input old_db, output err_flag)" }     */
/*           end. /* if old_db <> global_db then do: */                       */
/*                                                                            */
/*        end. /* if available pt_mstr then do: */                            */
/*                                                                            */
/*         if index("IA", yp_amt_type) <> 0 then do:                           */
/*                                                                             */
/* /*           hide frame c.   */                                             */
/*            view frame b.                                                    */
/*            clear frame b no-pause.                                          */
/*                                                                             */
/*            display                                                          */
/*               disp-stock-um                                                 */
/*               disp-total-this-level-gl                                      */
/*               disp-site-col                                                 */
/*               disp-total-gl-cost                                            */
/*            with frame b.                                                    */
/*                                                                             */
/*            display                                                          */
/*               list_label                                                    */
/*               qty_label                                                     */
/*               amt_label                                                     */
/*            with frame b.                                                    */
/*                                                                             */
/*            display yp_min_qty yp_amt with frame b.                          */
/*                                                                             */
/*            if available pt_mstr then do:                                    */
/*               display pt_desc1 with frame a.                                */
/*               display                                                       */
/*                  pt_price                                                   */
/*                  base_curr                                                  */
/*                  pt_um                                                      */
/*                  glxcst_tl                                                  */
/*                  base_curr @ base_curr1                                     */
/*                  pt_site                                                    */
/*                  glxcst                                                     */
/*                  base_curr @ base_curr2                                     */
/*               with frame b.                                                 */
/*            end. /* if available pt_mstr then do: */                         */
/*                                                                             */
/*            else do:                                                         */
/*               display "" @ pt_desc1 with frame a.                           */
/*            end. /* else do: */                                              */
/*                                                                             */
/*         end. /* if index("IA", yp_amt_type) <> 0 then do: */                */
/*         else do:                                                            */
/*                                                                             */
/*            hide frame b.                                                    */
/*/*            view frame c. */                                               */
/*/*            clear frame c no-pause.  */                                    */
/*                                                                             */
/*            temp_max_price = (yp_max_price[1] + (yp_max_price[2] / 100000)). */
/*            display                                                          */
/*               disp-stock-um                                                 */
/*               disp-total-this-level-gl                                      */
/*               disp-site-col                                                 */
/*               disp-total-gl-cost                                            */
/*            with frame c.                                                    */
/*                                                                             */
/*            display                                                          */
/*               list_label                                                    */
/*               ptable_label                                                  */
/*               min_label                                                     */
/*               max_label                                                     */
/*            with frame c.                                                    */
/*                                                                             */
/*            display                                                          */
/*               yp_amt[1]                                                     */
/*               yp_min_price                                                  */
/*               temp_max_price                                                */
/*            with frame c.                                                    */
/*                                                                             */
/*            if available pt_mstr then do:                                    */
/*               display pt_desc1 with frame a.                                */
/*               display                                                       */
/*                  pt_price                                                   */
/*                  base_curr                                                  */
/*                  pt_um                                                      */
/*                  glxcst_tl                                                  */
/*                  base_curr @ base_curr1                                     */
/*                  pt_site                                                    */
/*                  glxcst                                                     */
/*                  base_curr @ base_curr2                                     */
/*               with frame c.                                                 */
/*            end. /* if available pt_mstr then do: */                         */
/*                                                                             */
/*            else do:                                                         */
/*               display "" @ pt_desc1 with frame a.                           */
/*            end. /* else do: */                                              */
/*                                                                             */
/*         end. /* else do: */                                                 */

      end.  /* if recno <> ? */


end.


status input.
