/* xxgtariv.p - Sales Invoice  Outpout to Txt File Format                      */
/* COPYRIGHT infopower.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */

/* REVISION: 1.0      LasT MODIFIED: 08/28/2000   BY: *IFP001* Frankie Xu      */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

  {mfdtitle.i "e+ "}

  define new shared variable ad-name as character no-undo.
  define new shared variable ad-addr  as character no-undo.
  define new shared variable ad-bankacct  as character no-undo.
  define new shared variable sod-value  as decimal no-undo.
  define new shared variable sod-discount  as decimal no-undo.
  define new shared variable sod-lines as integer no-undo.

  define new shared variable idh-value  as decimal no-undo.
  define new shared variable vt-rate  as decimal no-undo.
  define new shared variable idh-discount  as decimal no-undo.
  define new shared variable idh-lines as integer no-undo.
  define new shared variable pt-std as character no-undo.
  define new shared variable pt-name as character no-undo.
  define new shared variable ih-inv-nbr1 like ih_inv_nbr no-undo.
  define new shared variable ih-inv-nbr2 like ih_inv_nbr no-undo.

  define new shared variable ihdate  like ih_inv_date.
  define new shared variable ihdate1 like ih_inv_date.
  define new shared variable inv like ih_inv_nbr.
  define new shared variable inv1 like ih_inv_nbr.
  define new shared variable nbr like ih_nbr.
  define new shared variable nbr1 like ih_nbr.
  define new shared variable sel as logical initial yes .
  define new shared variable include  as logical initial yes .
  DEFINE NEW SHARED VARIABLE ptchr04 LIKE pt__chr04 INITIAL "1610".


  define new shared variable cust  like so_cust.
  define new shared variable cust1 like so_cust.
  define new shared variable bill  like so_bill.
  define new shared variable bill1 like so_bill.
  define new shared variable ivdate  like ih_inv_date.
  define new shared variable ivdate1 like ih_inv_date.
  define new shared variable sonbr  like ih_nbr.
  define new shared variable sonbr1 like ih_nbr.

  define variable yn as logical initial yes .

/* Access the golden tax control */
  find first co_ctrl no-lock no-error.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
             
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
       cust           colon 15 LABEL "销往"
       cust1          label "到" colon 49 skip
       bill           colon 15  LABEL "票据开往"
       bill1          label "到" colon 49 skip
       sonbr          colon 15  LABEL "订单号"
       sonbr1         label "到" colon 49 skip
       inv            colon 15  LABEL "发票号"
       inv1           label "到" colon 49 skip
       ivdate         colon 15  LABEL "发票日期"
       ivdate1        label "到" colon 49 skip(1)
       ptchr04        COLON 35 LABEL "商品类别"
       sel            colon 35 label "仅转出未转出的销项发票"       
  /*     include        colon 35 label "包括客户税号有问题的销项发票"       */
SKIP(1)
     "若为红字发票, 请按下列过程处理:" COLON 20                                             
        "1. 发票号不能为空, 而且一次只能处理一张;"       COLON 10
        "2. 红字订单的数量必须为负值;"                      COLON 10
        "3. 在红字订单的订单头栏说明中, 第一行输入下列信息:" COLON 10
        "   对应正数发票代码XXXXXXXXXX号码YYYYYYYY"           COLON 10
        "4. XXXXXXXXXX 为被核销的金税发票代码, 长度为10位, 不能为空;"           COLON 10
        "5. YYYYYYYY   为被核销的金税发票号码, 长度为 8位, 不能为空."           COLON 10
 
  skip(1)


      SKIP(.4)  /*GUI*/
 with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title as CHARACTER.
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


         find first gl_ctrl no-lock. /*D507*/

         {wbrp01.i}

         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


         if inv1 = hi_char then inv1 = "".
         if cust1 = hi_char then cust1 = "".
         if bill1 = hi_char then bill1 = "".
         if sonbr1 = hi_char then sonbr1 = "".
         if ivdate = low_date then ivdate = ?.
         if ivdate1 = hi_date then ivdate1 = ?.

    if c-application-mode <> 'web':u then
        
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:

     {wbrp06.i &command = update &fields = " cust cust1 bill bill1 
      sonbr sonbr1 inv inv1 ivdate ivdate1 ptchr04 sel /*include*/ " &frm = "a"}

     if (c-application-mode <> 'web':u) or
     (c-application-mode = 'web':u and
     (c-web-request begins 'data':u)) then do:

        bcdparm = "".
        {mfquoter.i inv      }
        {mfquoter.i inv1     }
        {mfquoter.i cust     }
        {mfquoter.i cust1    }
        {mfquoter.i bill     }
        {mfquoter.i bill1    }
        {mfquoter.i sonbr    }
        {mfquoter.i sonbr1   }
        {mfquoter.i ivdate   }
        {mfquoter.i ivdate1  }
        if inv1 = "" then inv1 = hi_char.
        if sonbr1 = "" then sonbr1 = hi_char.
        if ivdate = ? then ivdate = low_date.
        if ivdate1 = ? then ivdate1 = hi_date.
        if cust1 = "" then cust1 = hi_char.
        if bill1 = "" then bill1 = hi_char.

 end.

        /* SELECT PRINTER */
        
/*GUI*/ end procedure. /* p-report-quote */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl no-lock.

/*IFP001**   {mfphead.i} */
                          
             
             find first co_ctrl no-lock no-error.

             if co_user2 = "yes" then do:  /* Invoice before posted process */

                for each so_mstr where so_to_inv = no and so_invoiced = yes          
                and so_inv_nbr <> "" and ( so_inv_nbr >= inv and so_inv_nbr <= inv1)
                and (so_nbr >= sonbr) and (so_nbr <= sonbr1)
                and (so_cust >= cust) and (so_cust <= cust1)
                and (so_bill >= bill) and (so_bill <= bill1)
                and (so_inv_date >= ivdate) and (so_inv_date <= ivdate1)
                and (so__log01 = no or NOT sel )
                and so__chr02 = ""  :
                
                  if so__chr01 = "" then 
                     assign so__chr01 = so_inv_nbr .
                 
                end.

                /* Moved for each sod_det to xxgtarivb.p rcode limits */
                {gprun.i ""xxgtarivb.p""}

             end.
             else do:
                for each ih_hist where (ih_nbr >= sonbr) and (ih_nbr <= sonbr1)                     /*yangxing030805*/
                and ((ih__chr01 >= inv and ih__chr01 <= inv1) or ih__chr01 = "" )
                and (ih_inv_date >= ivdate) and (ih_inv_date <= ivdate1) 
                and (ih__chr02 = "" ):
                
                   if ih__chr01 = "" then 
                      assign ih__chr01 = ih_inv_nbr .
                 
                   for each idh_hist where idh_inv_nbr = ih_inv_nbr :
                      assign idh__chr01 = ih__chr01.
                   end.
                 
                end.

                /* Moved for each ih_hist to xxgtariva.p rcode limits */
             /*   {gprun.i ""xxgtariva.p""}     */

             end.
             

             /* REPORT TRAILER */
/*IFP001**
/*GUI*/      {mfguitrl.i} /*Replace mfrtrail*/
***/


/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

             if not batchrun then do:
                yn = yes.
                {mfmsg01.i 9500 1 yn}
                /* Update dump flag? */
                if not yn then undo mainloop , leave.
             end.
             
             if yn = yes and co_user2 = "yes" then do:

                for each so_mstr where so_to_inv = no and so_invoiced = yes
                and so_inv_nbr <> "" and ( so_inv_nbr >= inv and so_inv_nbr <= inv1)
                and (so_nbr >= sonbr) and (so_nbr <= sonbr1)
                and (so_cust >= cust) and (so_cust <= cust1)
                and (so_bill >= bill) and (so_bill <= bill1)
                and (so_inv_date >= ivdate) and (so_inv_date <= ivdate1)
                and (so__log01 = no or NOT sel )
                and so__chr02 = "" :
                
                   assign so__log01 = yes .
                 
               end.

             end.

             if yn = yes and co_user2 = "no" then do:
                for each ih_hist where (ih_nbr >= sonbr) and (ih_nbr <= sonbr1)
                and (ih__chr01 >= inv and ih__chr01 <= inv1)
                and (ih_inv_date >= ivdate) and (ih_inv_date <= ivdate1) 
                and (ih__chr02 = "" ) :
                   assign ih__log01 = yes .
                end.    
             end.

         end.

        {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" cust cust1 bill bill1 sonbr sonbr1 inv inv1 ivdate ivdate1 ptchr04 sel /*include*/ "} /*Drive the Report*/
