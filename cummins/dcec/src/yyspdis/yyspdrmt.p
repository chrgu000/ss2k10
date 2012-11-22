/* yysparesdiscmt.p - spares discount maintenance */
/* ss - 121024.1 by: Steven */

/*-Revision end-------------*/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121110.1"}

/* ********** Begin Translatable Strings Definitions ********* */
define variable entity          as   char            no-undo.
define variable cust            like so_cust         no-undo.
define variable curr            as   char            no-undo.
define variable mtlovh          as   decimal         no-undo.
define variable service         as   decimal         no-undo.
define variable effdate         as   date            no-undo.
define variable duedate         as   date            no-undo.
define variable yn              as   logical         no-undo.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/
  /*RECT-FRAME       AT ROW 1 COLUMN 1.25
  RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
  SKIP(.1) */ /*GUI*/
   skip(1)
   entity           colon 20 label "会计单位" skip
   cust             colon 20 label "客户代码"
   curr             colon 50 label "货币"     skip
   mtlovh           colon 20 label "管理费用及材料费"   skip
   service          colon 20 label "服务机金额"         skip
   effdate          colon 20 label "生效日期"
   duedate          colon 50 label "截止日期" skip
   skip(1)
with frame a side-labels width 80  THREE-D title "备件折扣数据维护" /*GUI*/.
/*
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
 */
setFrameLabels(frame a:handle).

view frame a.

mainloop:
repeat:
   prompt-for
      entity validate(can-find(first en_mstr where en_domain = global_domain
             and en_entity = entity),"Entity not defined in General Ledger!")
      cust validate(can-find(first cm_mstr where cm_addr = cust ),"Customer does not exist!")
      curr validate(can-find(first cu_mstr where cu_curr = curr ),"currency does not exist!")
      mtlovh   validate(mtlovh >= 0 ,"Negative amounts not allowed!")
      service  validate(service >= 0 ,"Negative amounts not allowed!")
      effdate
      duedate
   with frame a
   editing:
      if frame-field = "cust" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i  yyspares_disc cust
          " yysparesdisc_domain = global_domain and yysparesdisc_entity = input entity and yysparesdisc_cust "
          cust yysparesdisc_cust yysparesdisc_indx}
       if recno <> ? then do:
         display
           yysparesdisc_entity  @ entity
           yysparesdisc_cust    @ cust       yysparesdisc_curr     @ curr
           yysparesdisc_ovh_mtl @ mtlovh     yysparesdisc_service  @ service
           yysparesdisc_effdate @ effdate    yysparesdisc_due_date @ duedate
         with frame a.
       end.
      end.
      else do:
         status input ststatus.
         readkey.
         apply lastkey.
      end.

   end.
   find first cm_mstr where cm_addr = input cust no-lock no-error.
   if avail cm_mstr then do:
      curr = cm_curr.
      disp curr with frame a.
   end.
   if input duedate <= input effdate then do:
      message "Due date before Effective date not allowed!"  view-as alert-box.
      next-prompt duedate with frame a.
      undo, retry.
   end.
/*   find first yyspares_disc where yysparesdisc_domain = global_domain        */
/*   and yysparesdisc_entity = input entity and yysparesdisc_cust = input cust */
/*   and input effdate >= yysparesdisc_effdate                                 */
/*   and input effdate <= yysparesdisc_due_date no-lock no-error.              */
/*   if avail yysales_disc then do:                                            */
/*     /*Unable to create.  Record already exists with effective date*/        */
/*     {pxmsg.i &MSGNUM= 950 &ERRORLEVEL=3}                                    */
/*      next-prompt effdate with frame a.                                      */
/*      undo, retry.                                                           */
/*   end.                                                                      */
/*                                                                             */
/*   yn = yes.                                                                 */
/*   /* IS ALL INFORMATION CORRECT? */                                         */
/*   {pxmsg.i &MSGNUM=12  &ERRORLEVEL=1                                        */
/*            &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}                             */
/*   if yn                                                                     */
/*   then do:                                                                  */
      do transaction:
         find first yyspares_disc where yysparesdisc_domain = global_domain
         and yysparesdisc_entity = input entity and yysparesdisc_cust = input cust
         and yysparesdisc_effdate = input effdate no-error.
         if not avail yyspares_disc then do:
            create yyspares_disc.
            assign yysparesdisc_domain      =  global_domain
                   yysparesdisc_entity      =  input entity
                   yysparesdisc_cust        =  input cust
                   yysparesdisc_effdate     =  input effdate.
         end.
            assign yysparesdisc_curr        =  input curr
                   yysparesdisc_ovh_mtl     =  input mtlovh
                   yysparesdisc_service     =  input service
                   yysparesdisc_due_date    =  input duedate
                   yysparesdisc_ovh_mtl     =  input mtlovh
                   yysparesdisc_service     =  input service.

         release yyspares_disc.
      end.
/*  end.                                */
/*  else do:                            */
/*     clear frame a all no-pause.      */
/*  end.                                */
end. /*mainloop*/
