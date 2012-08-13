/* xxgtptmta1.p - ITEM MAINTENANCE SUBROUTINE ENGINEERING DATA            */
/* COPYRIGHT Infopower.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 1.0     LAST MODIFIED: 09/20/2000   BY: *ifp007* Frankie Xu     */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptmta1_p_1 " 零件金税数据 "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define shared variable new_part like mfc_logical.
         define shared frame a1.
/*G249*/ define shared variable inrecno as recid.
/*G249*/ define shared variable sct1recno as recid.
/*G249*/ define shared variable sct2recno as recid.
/*FN30*/ define shared variable undo_all like mfc_logical no-undo.
/*K007*/ define shared variable promo_old like pt_promo.
/*K007*/ define variable apm-ex-prg as character format "x(10)" no-undo.
/*K017*/ define variable apm-ex-sub as character format "x(24)" no-undo.

         FORM /*GUI*/ 
         
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
    {xxgtptmta2.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame a1 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a1-title AS CHARACTER.
 F-a1-title = {&ppptmta1_p_1}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 = F-a1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a1 =
  FRAME a1:HEIGHT-PIXELS - RECT-FRAME:Y in frame a1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a1 = FRAME a1:WIDTH-CHARS - .5. /*GUI*/


               loopa1:
               do transaction on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


                  find pt_mstr exclusive-lock where recid(pt_mstr) = pt_recno  no-error.
                  if not available pt_mstr then leave.

                  ststatus = stline[3].
                  status input ststatus.

                     display 
                        pt__chr01 pt__chr02 pt__chr03
                        pt_price     
                        pt_taxable   
                        pt_taxc
                        pt__dec01    
                        pt__chr04  
                     with frame a1.

                     ptgtloop:
                     do on error undo, retry with frame a1:
/*GUI*/ if global-beam-me-up then undo, leave.

                        set
                            pt__chr01 pt__chr02 pt__chr03
                            pt_price pt_taxable pt_taxc pt__dec01 pt__chr04
                        with frame a1.
                        
/*
                        /*D055 VALIDATE TAXABLE AND TAXCODE*/
                        {xxgttxcl.i &code=pt_taxc &taxable=pt_taxable &date=today
                                    &frame="a1"}                        
**/

/*assign flag*/         assign pt__log01 = yes
                               pt__log02 = no.  
                        
                        find first gl_ctrl no-lock. 
                        if gl_vat or gl_can then find first vtc_ctrl no-lock.

                        if gl_vat or gl_can then do:
                           find last vt_mstr where vt_class = pt_taxc and
                           vt_start <= today and vt_end >= today no-lock no-error.
                           if not available vt_mstr then do:
                              if gl_vat then do:
                              {mfmsg.i 111 3}
                              /* "Error: Vat Class Must Exist."*/
                           end.
                           else if gl_can then do:
                               {mfmsg.i 131 3}
                               /*"Error: GST Class Must Exist."*/
                           end.
                           next-prompt pt_taxc with frame a1.  
                           undo , retry.  
                          
                        end.
                        else if available vt_mstr and vt_tax_pct <> 0 and pt_taxable = no then do:
                           if gl_vat then do:
                             {mfmsg.i 110 3}
                             /*"Error: Non Zero Vat Class Not Allowed if Taxable = no.".*/
                           end.
                           else if gl_can then do:
                               {mfmsg.i 132 3}
                                /*"Error: Non Zero GST Class Not Allowed if  Taxable = no."*/
                           end.
                           next-prompt pt_taxc with frame a1.  
                           undo , retry. 
                        end.
                     end.

                     end.
/*GUI*/ if global-beam-me-up then undo, leave.

                     find pl_mstr where pl_prod_line = pt_prod_line  no-error no-wait.

                     if new_part then do:
                     
                        pt_taxc = pl_taxc.
                        pt_taxable = pl_taxable.

/*G249*/                {gpsct04.i &type=""GL""}
/*G249*/                sct1recno = recid(sct_det).
/*G249*/                {gpsct04.i &type=""CUR""}
/*G249*/                sct2recno = recid(sct_det).
                     end. /*if new part then do*/
                     
/*FN30*/             undo_all = no.
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.

