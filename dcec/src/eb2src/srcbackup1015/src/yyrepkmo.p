/* repkis.p - REPETITIVE PICKLIST ISSUE                                       */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18.2.11 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: emb *G071*                */
/* Revision: 7.3      Last edit:     09/27/93   By: jcd *G247*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/*                                   08/27/94   BY: bcm *GL62*                */
/*                    LAST MODIFIED: 09/15/94   by: slm *GM63*                */
/*                                   11/06/94   by: rwl *GO29*                */
/*                                   11/08/94   by: srk *GO05*                */
/* REVISION: 8.5      LAST MODIFIED: 10/24/94   BY: mwd *J034*                */
/*                    LAST MODIFIED: 11/22/94   By: qzl  *GO59*               */
/*                    LAST MODIFIED: 12/09/94   BY: taf *J038*                */
/*                    LAST MODIFIED: 12/21/94   By: WUG  *G09R*               */
/*                    LAST MODIFIED: 12/28/94   BY: ktn *J041*                */
/*                    LAST MODIFIED: 05/17/95   BY: sxb *J04D*                */
/*                    LAST MODIFIED: 06/21/95   BY: qzl  *G0QJ*               */
/*                    LAST MODIFIED: 08/17/95   BY: qzl  *F0TC*               */
/*                                   05/01/96   BY: jzs  *H0KR*               */
/* REVISION: 8.6      LAST MODIFIED: 07/01/96   BY: bjl  *K001*               */
/*                    LAST MODIFIED: 07/16/96   BY: kxn  *J0QX*               */
/* REVISION: 8.5    LAST MODIFIED: 08/28/96 BY: *G2D7* Julie Milligan         */
/* REVISION: 8.6    LAST MODIFIED: 09/11/96 BY: *G2DP* Julie Milligan         */
/* REVISION: 8.6    LAST MODIFIED: 10/18/96 BY: *H0NG* Murli Shastri          */
/* REVISION: 8.6    LAST MODIFIED: 10/31/96 BY: *G2HG* Julie Milligan         */
/* REVISION: 8.5    LAST MODIFIED: 12/17/97 BY: *J287* Santhosh Nair          */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98 BY: *L007* A. Rahane              */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan             */
/* REVISION: 8.6E   LAST MODIFIED: 06/18/98 BY: *J2PD* A. Licha               */
/* REVISION: 8.6E   LAST MODIFIED: 08/25/98 BY: *L07B* Jean Miller            */
/* REVISION: 8.6E   LAST MODIFIED: 09/16/98 BY: *L09B* Jean Miller            */
/* REVISION: 8.6E   LAST MODIFIED: 10/14/98 BY: *J32C* Thomas Fernandes       */
/* REVISION: 9.1    LAST MODIFIED: 10/27/99 BY: *N04F* Sachin Shinde          */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane       */
/* REVISION: 9.1    LAST MODIFIED: 06/28/00 BY: *N0DM* Mudit Mehta            */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00 BY: *N0KP* myb                    */
/* REVISION: 9.1    LAST MODIFIED: 10/05/00 BY: *N0VN* Mudit Mehta            */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.18.2.6       BY: Rajesh Thomas    DATE: 08/14/01  ECO: *M1H5*  */
/* Revision: 1.18.2.7       BY: Jean Miller      DATE: 05/22/02  ECO: *P074*  */
/* Revision: 1.18.2.8       BY: Vivek Gogte      DATE: 08/06/02  ECO: *N1QQ*  */
/* Revision: 1.18.2.9       BY: Vivek Gogte      DATE: 09/12/02  ECO: *N1TN*  */
/* Revision: 1.18.2.10      BY: Hareesh V.       DATE: 09/20/02  ECO: *N1V5*  */
/* $Revision: 1.18.2.11 $     BY: Dorota Hohol    DATE: 02/25/03  ECO: *P0N6* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}
{cxcustom.i "REPKIS.P"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable nbr as character format "x(10)" label "Picklist".
define new shared variable eff_date like mfc_date.
define new shared variable use-to-loc-status like mfc_logical
   label "Use To Location Status" no-undo.
define new shared variable multi_entry like mfc_logical label "Multi Entry"
   no-undo.
define new shared variable cline as character.
define new shared variable lotserial_control like pt_lot_ser.
define new shared variable issue_or_receipt as character.
define new shared variable total_lotserial_qty like sr_qty.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable transtype as character.
define new shared variable lotref like sr_ref no-undo.

define     shared variable global_recid as recid.

define variable disp_qopen as decimal no-undo.
define variable disp_all   as decimal no-undo.
define variable disp_pick  as decimal no-undo.
define variable disp_chg   as decimal no-undo.

{&REPKIS-P-TAG1}
define variable i          as   integer.
define variable undo-input like mfc_logical.
define variable seq        as   integer format ">>>" label "Sequence".
define variable lotnext    like wo_lot_next .
define variable lotprcpt   like wo_lot_rcpt no-undo.
define variable oldnbr     like nbr no-undo.
define variable line       like op_wkctr.
define variable wkctr      like op_wkctr.
define variable comp       like ps_comp.
define variable prod_site  like lad_site.
define variable alloc      like mfc_logical label "Alloc" initial yes.
define variable picked     like mfc_logical label "Picked" initial yes.
define variable part       like lad_part.
define variable qopen      like lad_qty_all.
define variable yn         like mfc_logical.
define variable l_recno    as   recid        no-undo.
/*roger*/ def var ccat as logical.    
/*roger*/ def var wolot like wo_lot.   
/*roger*/ def var old_entry like aud_entry.  
/*roger*/ def var seq11 as integer format ">>>>9".
/*roger*/ define variable skeeper as char label "仓管员".


issue_or_receipt = getTermLabel("ISSUE",8).

/* THE FRAME E IS DEFINED SO THAT THE COMPONENTS BEING */
/* TRANSFERRED ARE NOT DISPLAYED ON THE SAME LINE.     */

define frame e
   line space(.5)
    lad_part format "x(16)"  space(.5)
   sr_site  space(.5)
   sr_loc  space(.5)
   sr_lotser format "x(15)"  space(.9)
   sr_qty    format "->>>>>>9.9<<<"  
with down no-attr-space width 80 three-d .

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

{gpglefv.i}

&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*GL62*/ 
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   space(1)
   prod_site
   nbr
   seq
   alloc
   picked
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

form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   space(1)
   eff_date
   use-to-loc-status
   space(2)
/*GO05*/   SKIP(.4)  /*GUI*/
with frame b centered row 4 overlay side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/  with frame c 6 down no-attr-space width 80 THREE-D /*GUI*/.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   line           colon 13       lotserial_qty  colon 53 pt_um
   part           colon 13       site           colon 53 location label "Loc"
   pt_desc1       colon 13       lotserial      colon 53
   pt_desc2       at 15 no-label lotref         colon 53
   multi_entry    colon 53
SKIP(.4)  /*GUI*/
with frame d side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* GLOBAL_ADDR IS INITIALISED TO BLANK WHICH PREVENTS */
/* ASSIGNMENT OF ADDRESS FROM PREVIOUS TRANSACTION.   */

assign
   eff_date          = today
   use-to-loc-status = yes
   nbr               = ""
   prod_site         = global_site
   global_addr       = ""
   transtype         = "ISS-TR".

/* DISPLAY */
mainloop:
repeat:

   assign
      nbr     = oldnbr
      part    = ""
      l_recno = 0
      line    = "".

   view frame a.
   view frame c.
   view frame d.

   display
      prod_site
      nbr
      seq
      alloc
      picked
   with frame a.

   setsite:
   do on error undo, retry with frame a:

      global_recid = ?.
      set
         prod_site
         nbr
         seq
         alloc
         picked
      with frame a editing:

         if frame-field = "prod_site"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i lad_det
                      lad_det
                     "lad_dataset = ""rps_det"""
                      substring(lad_nbr,1,8)
                      prod_site}

            if recno <> ?
            then
               display
                  substring(lad_nbr,1,8) @ prod_site with frame a.
            recno = ?.
         end. /* IF frame-field = "prod_site" */

         else if frame-field = "nbr"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i lad_det
                      lad_det
                     "lad_dataset = ""rps_det"" and
                      lad_nbr begins string(input prod_site,""x(8)"") "
                      substring(lad_nbr,1,18)
                     "string(input prod_site,""x(8)"")
                    + string(input nbr,""x(10)"") "}

            if global_recid <> ?
            then
            /*tfq added field lad__qadc01*/
               for first lad_det
                  fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                         lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
                  where recid(lad_det) = global_recid
                  no-lock:
               end. /* FOR FIRST lad_det ... */

            if recno <> ?
               or (    global_recid <> ?
                   and available lad_det)
            then
               display
                  substring(lad_nbr,9) @ nbr
                  substring(lad_nbr,1,8) @ prod_site
                  substring(lad_nbr,19) format "x(3)" @ seq
               with frame a.

            assign
               recno        = ?
               global_recid = ?.
         end. /* ELSE IF frame-field = "nbr" */

         else if frame-field = "seq"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i lad_det
                      lad_det
                     "lad_dataset = ""rps_det"" and
                      lad_nbr begins string(input prod_site,""x(8)"")
                    + string(input nbr,""x(10)"") "
                      lad_nbr
                     "string(input prod_site,""x(8)"")
                    + string(input nbr,""x(10)"")
                    + string(input seq,""999"") "}

            if recno <> ?
            then
               display
                  substring(lad_nbr,19) format "x(3)" @ seq with frame a.

            recno = ?.
         end. /* ELSE IF frame-field = "seq" */

         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */
      end. /* EDITING */

      if not can-find(si_mstr where si_site = prod_site)
      then do:

         /* SITE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
         next-prompt prod_site.
         undo, retry.
      end. /* IF NOT CAN-FIND(si_mstr WHERE si_site = prod_site) */

      {gprun.i ""gpsiver.p"" "(input prod_site,
           input ?,
           output return_int)"}

      if return_int = 0
      then do:
         /* USER DOES NOT HAVE ACCESS TO THIS SITE */
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         next-prompt prod_site with frame a.
         undo, retry.
      end. /* IF return_int = 0 */

      if not can-find(first lad_det where lad_dataset = "rps_det"
         and lad_nbr begins prod_site)
      then do:
         /* REFERENCE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=1156 &ERRORLEVEL=3}
         next-prompt prod_site.
         undo, retry.
      end. /* IF NOT CAN-FIND ... */
/*tfq added field lad__qadc01*/
      for first lad_det
         fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
         where lad_dataset = "rps_det"
           and lad_nbr begins string(prod_site,"x(8)") + nbr
         no-lock:
      end. /* FOR FIRST lad_det ... */

      if seq <> 0
      then
      /*tfq added field lad__qadc01*/
         for first lad_det
            fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                   lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
            where lad_dataset = "rps_det"
              and lad_nbr     =  string(prod_site,"x(8)") + string(nbr,"x(10)")
                               + string(seq,"999")
            no-lock:
         end. /* FOR FIRST lad_det ... */

      if not available lad_det
      then do:
         /* REFERENCE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=1156 &ERRORLEVEL=3}
         next-prompt nbr.
         undo, retry.
      end. /* IF NOT AVAILABLE lad_det */

      if seq = 0
         and substring(lad_nbr,19) <> ""
      then
         seq = integer(substring(lad_nbr,19)).

      display
         seq with frame a.
      pause 0.
    /*roger*/ if avail lad_det then do:
   /*roger*/      wolot = substring(lad__qadc01, 19).
/*roger*/ end.         
/*roger*/ ccat = no.
/**********roger added begin*******************************/
for each lad_det
         where lad_dataset = "rps_det"
         and lad_nbr = string(prod_site,"x(8)") + string(nbr,"x(10)"):     
if (lad_qty_all = 0 and (lad_qty_pick <> 0 or lad_qty_chg <> 0))  then ccat = yes.
end.
if ccat then do:
      MESSAGE "领料单已打印，不能被修改"
            VIEW-AS ALERT-BOX ERRor BUTTONS OK
                    TITLE "错误" .
            next-prompt nbr.
            undo, retry.
         end.
/*roger*/
/*******roger*added end*****************************************/
      if eff_date = ?
      then
         eff_date = today.
/*roger********************************************************
      setb:
      do with frame b on error undo:

         update
            eff_date
            use-to-loc-status.
         /* CHECK EFFECTIVE DATE */

         for first si_mstr
            fields(si_entity si_site)
            where si_site = prod_site
            no-lock:
         end. /* FOR FIRST si_mstr */

         {gpglef1.i &module = ""IC""
                    &entity = si_entity
                    &date   = eff_date
                    &prompt = "eff_date"
                    &frame  = "b"
                    &loop   = "setb"
            }
      end. /* DO WITH FRAME b ... */
      ****************roger***********************************************/
   end.  /* SETSITE:  DO: */
/*GUI*/ if global-beam-me-up then undo, leave.
   assign
      oldnbr = nbr
      nbr    = string(prod_site,"x(8)") + nbr.

   if seq <> 0
   then
      nbr = string(nbr,"x(18)") + string(seq,"999").
    {gprun.i ""repkisb.p"" "(nbr, prod_site, alloc, picked)"} 

   setd:
   do while true:

      /* DISPLAY DETAIL */
      repeat:
         clear frame c all no-pause.
         clear frame d all no-pause.
         view frame c.
         view frame d.
/*tfq added field lad__qadc01*/
         for each lad_det
            fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                   lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
            where lad_dataset = "rps_det"
              and lad_nbr     =  nbr
              and lad_line    >= line
              and lad_part    >= part
            no-lock
         break by lad_dataset by lad_nbr by lad_line by lad_part by lad_site:

            qopen = lad_qty_all + lad_qty_pick.
            accumulate qopen (total by lad_part).
            accumulate lad_qty_all (total by lad_part).
            accumulate lad_qty_pick (total by lad_part).
            accumulate lad_qty_chg (total by lad_part).

            if not last-of (lad_part)
            then
               next.

            assign
               disp_qopen = accum total by lad_part qopen
               disp_all   = accum total by lad_part lad_qty_all
               disp_pick  = accum total by lad_part lad_qty_pick
               disp_chg   = accum total by lad_part lad_qty_chg.

            display
               lad_line   @ line
               lad_part
               
               /*roger*/      substring(lad__qadc01,11,8) @ skeeper 
               /************roger added begin***************************              
               accum total by lad_part qopen
                    format "->>>>>>>9.9<<<<<<<"    label "短缺量" 
               accum total by lad_part lad_qty_all
                    format "->>>>>>>9.9<<<<<<<" label "已备料量"
               ************roger added end*******************************/
               
               disp_qopen format "->>>>>>>9.9<<<<<<<"   /*label "Qty Open"*/ 
               
               disp_all   format "->>>>>>>9.9<<<<<<<"    /*label "Qty Alloc"*/
               /**roger*****************
               disp_pick  format "->>>>>>>9.9<<<<<<<" label "Qty Picked"
               disp_chg   format "->>>>>>>9.9<<<<<<<" label "Qty to Iss"
               ******************roger**************/
            with frame c.

            if frame-line(c) = frame-down(c)
            then
               leave.

            down 1 with frame c.
         end. /* FOR EACH lad_det ... */

         /* CONDITION ADDED TO IMPROVE PERFORMANCE IN DESKTOP 2 */
         if not {gpiswrap.i}
         then
            input clear.

         hide frame b no-pause.

         run setline.

         /* TO RELEASE LOCKING OF WINDOWS WHEN ALT+X OR        */
         /* EXIT OR WINDOW CLOSE BUTTON X IS CLICKED, BEING IN */
         /* LINE FRAME OF WINDOWS VERSION.                     */
         /*V8! if global-beam-me-up then undo mainloop, leave mainloop.  */

         if return-value = "undo"
         then
            leave.

      end. /* REPEAT:  (DISPLAY DETAIL) */

      do on endkey undo mainloop, retry mainloop:

         yn = yes.
         /* DISPLAY WO LINES BEING SHIPPED? */
         {pxmsg.i &MSGNUM=636 &ERRORLEVEL=1 &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}

         if yn = yes
         then do:

            hide frame c no-pause.
            hide frame d no-pause.

            /* ADDED CHECK FOR lad_qty_chg TO DISPLAY WORK CENTER */
            /* AND PART FOR ALL COMPONENTS IN ISSUE SCREEN.       */
/*tfq added field lad__qadc01*/
            for each lad_det
               fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                      lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
               where lad_dataset = "rps_det"
               and   lad_nbr     =  nbr
               and   lad_qty_chg <> 0
            no-lock break by lad_dataset by lad_nbr by lad_line by lad_part
            with frame e:

               for each sr_wkfl
                  fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                          sr_site sr_user2 sr_userid)
                  where sr_userid = mfguser
                    and sr_lineid = string(lad_line,"x(8)") + "::" + lad_part
                    and sr_site   = lad_site
                    and sr_loc    = lad_loc
                    and sr_lotser = lad_lot
                    and sr_ref    = lad_ref
                    no-lock
               with frame e:

                  if first-of (lad_part)
                     or frame-line < 2
                  then
                     display
                        lad_line @ line
                        lad_part.

                  display
                     sr_site
                     sr_loc
                     sr_lotser
                     sr_qty.

                  if sr_ref > ""
                  then do:
                     down 1.
                     display
                        getTermLabel("REFERENCE",8) + ": " +
                           sr_ref @ sr_lotser.
                  end. /* IF sr_ref > ... */

               end. /* FOR EACH sr_wkfl ...*/
            end. /* FOR EACH lad_det ... */
         end. /* IF yn = yes ... */
      end.  /* DO ON ENDKEY... */

      do on endkey undo mainloop, retry mainloop:

         yn = yes.
/*roger**************************************************************
         /* IS ALL INFO CORRECT? */
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}
         /*V8!
         if yn = ?
         then
            undo mainloop, retry mainloop. */
*roger**************************************************************/
         /*roger if yn */
         /***************roger added begin***************************/
         if yn then do:
            pause.
            leave.
           end.
         /**********roger added end******************************/
        /*roger then do:*/
/*tfq added field lad__qadc01*/
            for each lad_det
               fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                      lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
               where lad_dataset = "rps_det"
                 and lad_nbr     = nbr
               no-lock
            break
            by lad_dataset by lad_nbr by lad_line by lad_part:

               for each sr_wkfl
                  fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                          sr_site sr_user2 sr_userid)
                  where sr_userid = mfguser
                    and sr_lineid = string(lad_line,"x(8)") + "::" + lad_part
                    and sr_site   = lad_site
                    and sr_loc    = lad_loc
                    and sr_lotser = lad_lot
                    and sr_ref    = lad_ref
                  no-lock
               with width 80:
/*GUI*/ if global-beam-me-up then undo, leave.
                  for first pt_mstr
                     fields (pt_desc1 pt_desc2 pt_lot_ser pt_part pt_um)
                     where pt_part = lad_part
                     no-lock:
                  end. /* FOR FIRST pt_mstr */

                  {gprun.i ""icedit.p"" " (""ISS-TR"",
                      sr_site,
                      sr_loc,
                      lad_part,
                      sr_lotser,
                      sr_ref,
                      sr_qty,
                      pt_um,
                      """",
                      """",
                      output undo-input )" }
/*GUI*/ if global-beam-me-up then undo, leave.
                  if not undo-input
                  then do:

                     {gprun.i ""icedit.p"" " (""RCT-TR"",
                         lad_site,
                         lad_line,
                         lad_part,
                         sr_lotser,
                         sr_ref,
                         sr_qty,
                         pt_um,
                         """",
                         """",
                         output undo-input )" }
                         /*GUI*/ if global-beam-me-up then undo, leave.
                  end. /* IF NOT undo-input ... */

                  if undo-input
                  then do:
                     assign
                        line = lad_line
                        part = lad_part.
                     next setd.
                  end. /* IF undo-input */

                  /* VALIDATE GRADE ASSAY EXPIRE & INVENTORY STATUS */
                  {gprun.i ""repkisc.p""
                     "(input sr_site,
                       input lad_site,
                       input sr_loc,
                       input lad_line,
                       input lad_part,
                       input sr_lotser,
                       input sr_ref,
                       input sr_qty,
                       input use-to-loc-status,
                       output undo-input)" }

                  if undo-input
                  then do:
                     assign
                        line = lad_line
                        part = lad_part.
                     next setd.
                  end. /* IF undo-input */

               end. /* FOR EACH sr_wkfl ... */
            end. /* FOR EACH lad_det ... */

            {&REPKIS-P-TAG2}
            /*********roger*************
            hide frame c.
            hide frame d.
            leave setd.
         end. /* IF yn THEN DO */
         *************roger**************/
      end.  /* DO ON ENDKEY... */
   end. /* SETD:  DO WHILE TRUE: */

  /*roger  {gprun.i ""repkisa.p""}*/

   {&REPKIS-P-TAG3}

   nbr = substring(nbr,9).

end.  /* MAINLOOP */
/*GUI*/ if global-beam-me-up then undo, leave.
/* DELETE STRANDED sr_wkfl and lad_det RECORDS */

for each sr_wkfl
   where sr_userid = mfguser
exclusive-lock:
   delete sr_wkfl.
end. /* FOR EACH sr_wkfl */

for each lad_det
   where lad_dataset  = "rps_det"
   and   lad_nbr     >=  string(prod_site,"x(8)")
                         + string(oldnbr,"x(10)")
   and   lad_nbr     <=  string(prod_site,"x(8)")
                         + string(oldnbr,"x(10)")
                         + hi_char
   and   lad_qty_all  = 0
   and   lad_qty_pick = 0
exclusive-lock:
   delete lad_det.
end. /* FOR EACH lad_det */

/*********START INTERNAL PROCEDURE LOGIC*************/

PROCEDURE setline:

   setline:
   do on error undo, retry on endkey undo, return "undo":

      update
         line
         part
      with frame d editing:

         if frame-field = "line"
         then do:

            if l_recno <> 0
            then
               recno = l_recno.

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i
               lad_det
               lad_det
              "lad_dataset = ""rps_det"" and lad_nbr = nbr"
               lad_line
               line}

            if recno <> ?
            then do:
               assign
                  line = lad_line
                  part = lad_part.
               display
                  line
                  part
               with frame d.
            end. /* IF recno <> ? */

            /* STORE THE recid TO RETRIEVE THE LAST VISITED WORK CENTER */
            /* THIS IS STORED HERE AS mfnp05.i CALLED BELOW             */
            /* (frame-field = "part") WILL RESET THE recno TO '?'       */
            l_recno = recid (lad_det).

         end. /* IF frame-field = "line" */

         else if frame-field = "part"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i
               lad_det
               lad_det
              "lad_dataset = ""rps_det"" and
               lad_nbr     = nbr         and
               lad_line    = line"
               lad_part
               part}

            if recno <> ?
            then do:
               part = lad_part.
               display part with frame d.
            end. /* IF recno <> ? */
            recno = ?.
         end. /* ELSE IF frame-field = "part" */

         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */

         for first pt_mstr
            fields (pt_desc1 pt_desc2 pt_lot_ser pt_part pt_um)
            where pt_part = part
            no-lock:

            display
               pt_um
               pt_desc1
               pt_desc2
            with frame d.
         end. /* FOR FIRST pt_mstr ... */

         display
            "" @ lotserial_qty
            "" @ site
            "" @ location
            "" @ lotserial
            "" @ lotref
            "" @ multi_entry
         with frame d.

      end. /* UPDATE... EDITING */

      status input.

      if part = ""
      then
         leave.

      multi_entry = no.
/*tfq added field lad__qadc01*/
      for first lad_det
         fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
         where lad_dataset = "rps_det"
           and lad_nbr     = nbr
           and lad_line    = line
           and lad_part    = part
         no-lock:
      end. /* FOR FIRST lad_det ... */

      if not available lad_det
      then do:

         for first wc_mstr
            fields (wc_wkctr)
            where wc_wkctr = line
            no-lock:
         end. /* FOR FIRST wc_mstr */

         if not available wc_mstr
         then do:
         /* WORK CENTER/MACHINE DOES NOT EXIST */
            {pxmsg.i &MSGNUM=519 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE wc_mstr */

         for first loc_mstr
            fields (loc_loc)
            where loc_loc = line
            no-lock:
         end. /* FOR FIRST loc_mstr */

         if not available loc_mstr
         then do:
            /* LOCATION DOES NOT EXIST */
            {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE loc_mstr */

         for first pt_mstr
            fields (pt_desc1 pt_desc2 pt_lot_ser pt_part pt_um)
            where pt_part = part
            no-lock:
         end. /* FOR FIRST pt_mstr */

         if not available pt_mstr
         then do:
            /* ITEM NUMBER DOES NOT EXIST */
            {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE pt_mstr */

         /* COMPONENT DOES NOT EXIST ON THIS WORK ORDER. */
         {pxmsg.i &MSGNUM=517 &ERRORLEVEL=2}
/*roger*/ find pt_mstr no-lock where pt_part = part no-error.
         create lad_det.
         assign
            lad_dataset = "rps_det"
            lad_nbr     = nbr
            lad_line    = line
            lad_part    = part
            lad_site    = prod_site
/*roger*/         substring(lad__qadc01,1,10) = substring(nbr,9,10)
/*roger*/         substring(lad__qadc01,11,8) = pt_article when (avail pt_mstr)
/*roger*/         substring(lad__qadc01,19) = wolot .
         if recid(lad_det) = -1 then .
      end. /* IF NOT AVAILABLE lad_det */

      for first pt_mstr
         fields (pt_desc1 pt_desc2 pt_lot_ser pt_part pt_um)
         where pt_part = lad_part
         no-lock:
      end. /* FOR FIRST pt_mstr */

      if not available pt_mstr
      then do with frame d:
         /* ITEM NUMBER DOES NOT EXIST */
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}
         display part
            " " @ pt_um
            " " @ pt_desc1
            " " @ pt_desc2.
      end. /* IF NOT AVAILABLE pt_mstr */

      else do with frame d:
         display
            pt_part @ part
            pt_um
            pt_desc1
            pt_desc2.
      end. /* ELSE DO ... */

      assign
         qopen         = 0
         lotserial_qty = 0.
/*tfq added field lad__qadc01*/
      for each lad_det
         fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
         where lad_dataset = "rps_det"
         and   lad_nbr     = nbr
         and   lad_line    = line
         and   lad_part    = part
      no-lock:
         assign
  /*roger*/       qopen = qopen + lad_qty_all
/*roger*/         lotserial_qty = lad_qty_all + lotserial_qty.
  /*roger             qopen         = qopen + lad_qty_all + lad_qty_pick*/
    /*roger           lotserial_qty = lad_qty_chg + lotserial_qty. */
      end. /* FOR EACH lad_det */

      assign
         total_lotserial_qty = lotserial_qty
         lotserial_control   = "".

      if available pt_mstr
      then
         lotserial_control = pt_lot_ser.

      assign
         site        = ""
         location    = ""
         lotserial   = ""
         lotref      = ""
         cline       = string(line,"x(8)") + "::" + part
         global_part = part.

      for first sr_wkfl
         fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                 sr_site sr_user2 sr_userid)
         where sr_userid = mfguser
         and   sr_lineid = cline
         no-lock:
      end. /* FOR FIRST sr_wkfl */

      if not available sr_wkfl
      then do:
/*tfq added field lad__qadc01*/
         for first lad_det
            fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                   lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site lad__qadc01)
            where lad_dataset = "rps_det"
            and   lad_nbr     = nbr
            and   lad_line    = line
            and   lad_part    = part
            no-lock:
         end. /* FOR FIRST lad_det */

         assign
            site     = lad_site
            location = lad_loc.
      end. /* IF NOT AVAILABLE sr_wkfl */

      else do:

         for first sr_wkfl
            fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                    sr_site sr_user2 sr_userid)
            where sr_userid = mfguser
            and   sr_lineid = cline
            no-lock:

            assign
               site      = sr_site
               location  = sr_loc
               lotserial = sr_lotser
               lotref    = sr_ref.
         end. /* FOR FIRST sr_wkfl */

         if not available sr_wkfl
         then
            multi_entry = yes.

      end. /* ELSE DO */

      setrest:
      do on error undo, retry on endkey undo, leave:

         update
            lotserial_qty
            site
            location
            lotserial
            lotref
            multi_entry
             go-on("F5" "CTRL-D")   /*TFQ*/
         with frame d editing:

            assign
               global_site = input site
               global_loc  = input location.

            readkey.
            apply lastkey.
         end. /* UPDATE ... */
/***********TFQ ADDED BEGIN******************************/
if lastkey = keycode("F5")
               or lastkey = keycode("CTRL-D")
               then do:
/*roger*/      MESSAGE "确认要删除该记录吗?"
            VIEW-AS ALERT-BOX question BUTTONS yes-no
                    TITLE "问题" UPDATE choice AS LOGICAL.     
/*roger*/ if choice then do:                              
/*roger*/ for each lad_det exclusive-lock where lad_dataset = "rps_det"
            and lad_nbr = nbr
            and lad_line = line 
            and lad_part = part
            and lad_site = prod_site:

               if lad_qty_all <> 0 or lad_qty_pick <> 0 then do:

                  find ld_det where ld_site = lad_site
                  and ld_loc = lad_loc
                  and ld_part = lad_part
                  and ld_lot = lad_lot
                  and ld_ref = lad_ref
                  no-error.

                  if available ld_det then
                     ld_qty_all = ld_qty_all - lad_qty_all - lad_qty_pick.

                  find in_mstr where in_site = lad_site
                  and in_part = lad_part no-error.

                  if available in_mstr then
                     in_qty_all = in_qty_all - lad_qty_all - lad_qty_pick.
               end.

               delete lad_det.

/*roger*/            end.               /*for each lad_det*/
/*roger*/            end.        /*choice*/
leave.
/*roger*/            end.        /*delete F5,Ctrl-F*/
/*******************TFQ ADDED END*************************/
         i = 0.
         for each sr_wkfl
            fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                    sr_site sr_user2 sr_userid)
            where sr_userid = mfguser
            and   sr_lineid = cline
         no-lock:

            i = i + 1.

            if i > 1
            then do:
               multi_entry = yes.
               leave.
            end. /* IF i > 1 */

         end. /* FOR EACH sr_wkfl */

         assign
            trans_um   = if available pt_mstr
                         then
                            pt_um
                         else
                            ""
            trans_conv = 1.

         if multi_entry
         then do:

            if i >= 1
            then do:

               assign
                  site      = ""
                  location  = ""
                  lotserial = ""
                  lotref    = "".
            end. /* IF i >= 1 */

            assign
               lotnext  = ""
               lotprcpt = no.

            {gprun.i ""repksrup.p"" "(input prod_site,
                 input line,
                 input use-to-loc-status,
                 input """",
                 input """",
                 input-output lotnext,
                 input lotprcpt)"}

         end. /* IF multi_entry */
         else do:

            if lotserial_qty <> 0
            then do:

               {gprun.i ""icedit.p"" "(input ""ISS-TR"",
                    input site,
                    input location,
                    input global_part,
                    input lotserial,
                    input lotref,
                    input lotserial_qty,
                    input trans_um,
                    input """",
                    input """",
                    output undo-input
                    )" }

               if undo-input
               then
                  undo, retry.

               {gprun.i ""repkisc.p""
                  "(input site,
                    input prod_site,
                    input location,
                    input line,
                    input global_part,
                    input lotserial,
                    input lotref,
                    input lotserial_qty,
                    input use-to-loc-status,
                    output undo-input)" }

               if undo-input then undo, retry.

            end. /* IF lotserial_qty <> 0 */

            find first sr_wkfl
               where sr_userid = mfguser
               and   sr_lineid = cline
               exclusive-lock
            no-error.

            if lotserial_qty <> 0
            then do:

               if not available sr_wkfl
               then
                  create sr_wkfl.

               assign
                  sr_userid = mfguser
                  sr_lineid = cline
                  sr_site   = site
                  sr_loc    = location
                  sr_lotser = lotserial
                  sr_ref    = lotref
                  sr_qty    = lotserial_qty
                  sr_rev    = line
                  sr_user2  = part.

               if recid(sr_wkfl) = -1 then .
            end.  /* IF lotserial_qty <> 0 */

            else if available sr_wkfl
               and lotserial_qty = 0
            then
               delete sr_wkfl.

         end.  /* (NOT MULTI_ENRY) */

         for each lad_det
            where lad_dataset = "rps_det"
            and   lad_nbr     = nbr
            and   lad_line    = line
            and lad_part      = part
         exclusive-lock:

            if can-find (sr_wkfl where sr_userid = mfguser
               and sr_lineid = cline
               and sr_site   = lad_site
               and sr_loc    = lad_loc
               and sr_lotser = lad_lot
               and sr_ref    = lad_ref)
            then
               next.
            lad_qty_chg = 0.
         end. /* FOR EACH lad_det */

         for each sr_wkfl
            fields (sr_lineid sr_loc   sr_lotser sr_qty sr_ref sr_rev
                    sr_site   sr_user2 sr_userid)
            where sr_userid = mfguser
            and   sr_lineid = cline
            no-lock:

            find lad_det
               where lad_dataset = "rps_det"
               and   lad_nbr     = nbr
               and   lad_line    = line
               and   lad_part    = part
               and   lad_site    = sr_site
               and   lad_loc     = sr_loc
               and   lad_lot     = sr_lot
               and   lad_ref     = sr_ref
            exclusive-lock
            no-error.

            if available lad_det
            then do:
            /*roger*/         if lad_qty_all <> sr_qty then do:
            /**********roger********************
               if lad_qty_chg <> sr_qty
               then
                  lad_qty_chg = sr_qty.
         ****************roger********************/                 
/************roger added begin*******************************/
find ld_det where ld_site = lad_site
                  and ld_loc = lad_loc
                  and ld_part = lad_part
                  and ld_lot = lad_lot
                  and ld_ref = lad_ref
                  no-error.

                  if available ld_det then
                     ld_qty_all = ld_qty_all - lad_qty_all + sr_qty.

                  find in_mstr where in_site = lad_site
                  and in_part = lad_part no-error.

                  if available in_mstr then
                     in_qty_all = in_qty_all - lad_qty_all + sr_qty.
                     /*roger*/                        
 find last aud_det no-lock no-error.
  	    if available aud_det then do:
              if aud_entry = 0 then next.
  		old_entry = aud_entry.
           end.
  	    else
  		old_entry = 0.
 find last aud_det no-lock 
 where aud_dataset = "RE_PICK" and aud_key1 = substring(nbr,9,10)
 no-error.
 if avail aud_det then seq11 = integer(aud_key2) + 1.
 else seq11 = 1.
   		

/*roger*/        create aud_det.
                 assign 
                 aud_dataset = "RE_PICK"
                 aud_userid = mfguser
                 aud_entry = old_entry + 1
                 aud_field = lad_part
                 aud_key1 = substring(nbr,9,10)
                 aud_key2 = string(seq11, "99999")
                 aud_old_data[1] = lad_site + " " + lad_loc + " " + lad_lot + " " + lad_ref + " " + string(lad_qty_all)
                 aud_new_data[1] = lad_site + " " + lad_loc + " " + lad_lot + " " + lad_ref + " " + string(sr_qty)
                 aud_date = today
                 aud_time = string(time, "hh:mm:ss").
                 
                        lad_qty_all = sr_qty.
/*roger*/ end.
/************roger added end******************************/
                                         
            end. /* IF AVAILABLE lad_det */

            else do:
            /*roger*/ find pt_mstr no-lock where pt_part = part no-error. 
               create lad_det.
               assign
                  lad_dataset = "rps_det"
                  lad_nbr     = nbr
                  lad_line    = line
                  lad_part    = part
                  lad_site    = sr_site
                  lad_loc     = sr_loc
                  lad_lot     = sr_lot
                  lad_ref     = sr_ref
                  lad_qty_chg = sr_qty
  /***********added by roger***begin**************************/                
                  /*roger*/                lad_qty_all = sr_qty
/*roger*/         substring(lad__qadc01,1,10) = substring(nbr,9,10)
/*roger*/         substring(lad__qadc01,11,8) = pt_article when (avail pt_mstr)
/*roger*/         substring(lad__qadc01,19) = wolot
.

/*roger*/

                  find ld_det where ld_site = lad_site
                  and ld_loc = lad_loc
                  and ld_part = lad_part
                  and ld_lot = lad_lot
                  and ld_ref = lad_ref
                  no-error.

                  if available ld_det then
                     ld_qty_all = ld_qty_all + lad_qty_all.

                  find in_mstr where in_site = lad_site
                  and in_part = lad_part no-error.

                  if available in_mstr then
                     in_qty_all = in_qty_all + lad_qty_all.

/***************added by roger end*******************************************/

                  recno       = recid(lad_det).
            end. /* IF NOT AVAILABLE lad_det */
         end.  /* EACH sr_wkfl */
      end. /* SETREST: DO: */
   end. /* SETLINE: DO: */

END PROCEDURE. /* PROCEDURE setline */

