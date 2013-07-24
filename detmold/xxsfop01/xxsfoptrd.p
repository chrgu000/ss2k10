/* sfoptrd.p - REJECT AND REWORK QUANTITY INPUT FROM LABOR FEEDBACK     */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.0      LAST MODIFIED: 12/09/91   BY: dgh *D960*  */
/* REVISION: 7.0      LAST MODIFIED: 04/29/92   BY: emb *F445*  */
/* REVISION: 7.3      LAST MODIFIED: 12/07/92   BY: emb *G400*  */
/* REVISION: 7.3      LAST MODIFIED: 03/15/93   BY: emb *G876*  */
/* REVISION: 7.3      LAST MODIFIED: 08/05/93   BY: emb *GD95*  */
/* REVISION: 7.3      LAST MODIFIED: 09/21/94   BY: ljm *GM77*  */
/* REVISION: 7.3      LAST MODIFIED: 10/19/94   BY: ljm *GN40*  */
/* REVISION: 7.3   LAST MODIFIED: 05/16/96 BY: *G1VG* Julie Milligan         */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb                 */
     {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sfoptrd_p_1 " Rejects "
/* MaxLen: Comment: */

&SCOPED-DEFINE sfoptrd_p_2 " Reworks "
/* MaxLen: Comment: */

&SCOPED-DEFINE sfoptrd_p_3 "v_reason"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfoptrd_p_4 "Total Reworks"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfoptrd_p_5 "Total Rejects"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*G876*/ define shared variable rejects like mfc_logical.
/*G876*/ define shared variable reworks like mfc_logical.
/*G876*/ define shared workfile rejfile no-undo
        field rejv_reason like op_rsn_rjct
        field rejqty like op_qty_rjct.

/*G876*/ define shared workfile rwkfile no-undo
        field rwkv_reason like op_rsn_rwrk
        field rwkqty like op_qty_rwrk.

     define shared variable total_rej   like op_qty_rjct.
     define shared variable total_rwk   like op_qty_rwrk.
/*G876*/ define variable last_v_reason as character no-undo.
/*G876*/ define variable counter as integer no-undo.
/*G876*/ define variable yn like mfc_logical.
/*G876*/ define variable prev_qty as decimal no-undo.
/*G876*/ define variable i as integer no-undo.

/*G876*  define shared variable dept        like op_dept.
     define shared variable eff_date    like op_date.
     define shared variable emp         like op_emp.
     define shared variable lead_trans  like op_trnbr.
     define shared variable project     like op_project.
     define shared variable shift       like op_shift.
     define shared variable wr_recno    as   recid.
     define shared variable wc_recno    as   recid.
     define variable pauser as integer.
/*G400*/ define variable site like wo_site.
**G876*/

/*G876*/ /* Replaced existing logic entirely */
/*G876*/ /* New logic added */
     pause 0.

      define SHARED variable v_downtime as char format "x(09)" EXTENT 10.
     define SHARED variable v_reason like rsn_code  EXTENT 10.

    

        form
           "v_downtime"    COLON 5       "v_reason"  COLON 20
           v_downtime[1]   COLON 5  NO-LABEL    v_reason[1]   COLON 20  NO-LABEL 
           v_downtime[2]   COLON 5  NO-LABEL   v_reason[2]   COLON 20  NO-LABEL
           v_downtime[3]   COLON 5   NO-LABEL v_reason[3]   COLON 20  NO-LABEL
           v_downtime[4]   COLON 5    NO-LABEL  v_reason[4]   COLON 20   NO-LABEL
           v_downtime[5]   COLON 5  NO-LABEL   v_reason[5]   COLON 20   NO-LABEL
           v_downtime[6]   COLON 5  NO-LABEL  v_reason[6]   COLON 20 NO-LABEL
           v_downtime[7]   COLON 5  NO-LABEL   v_reason[7]   COLON 20   NO-LABEL
           v_downtime[8]   COLON 5   NO-LABEL  v_reason[8]   COLON 20  NO-LABEL
           v_downtime[9]   COLON 5   NO-LABEL  v_reason[9]   COLON 20 NO-LABEL
           v_downtime[10]   COLON 5   NO-LABEL  v_reason[10]   COLON 20   NO-LABEL
         
          
        with frame d 6 down scroll 1 overlay row 8
/*G1VG*     Title " Reworks " centered attr-space. */
/*G1VG*/    title color normal (getFrameTitle("REWORKS",18)) centered
attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

DO ON ERROR UNDO :

UPDATE 
    v_downtime[1] v_reason[1] 
     v_downtime[2] v_reason[2] 
    v_downtime[3] v_reason[3] 
     v_downtime[4] v_reason[4]
    v_downtime[5] v_reason[5]
     v_downtime[6] v_reason[6]
    v_downtime[7] v_reason[7] 
    v_downtime[8] v_reason[8]
     v_downtime[9] v_reason[9]  
   v_downtime[10] v_reason[10]   WITH FRAME d .
  
  IF v_reason[1] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[1] no-error.
      IF NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.

  
   IF v_reason[2] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[2] no-error.
      IF NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.

  

   IF v_reason[3] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[3] no-error.
      if  NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.
  
   IF v_reason[4] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[4] no-error.
      if NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.
  
   IF v_reason[5] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[5] no-error.
      IF NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.
 
  IF v_reason[6] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[6] no-error.
      if NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.
  
   IF v_reason[7] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[7] no-error.
      if NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.
  
   IF v_reason[8] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[8] no-error.
      if NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.
 
   IF v_reason[9] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[9] no-error.
      if NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.
 
   IF v_reason[10] <> ""  THEN
  find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = v_reason[10] no-error.
      if NOT available rsn_ref then DO:
             {mfmsg.i 534 1} /* Please enter reason code */
              UNDO ,RETRY .
      END.
     
  END .

  
        
  

  
                   


     /* ss - 130712.1 -b 
     rejhist:
     do with frame c1:

        form
           rejv_reason      column-label {&sfoptrd_p_3}
           rejqty
           rsn_desc       no-attr-space
           total_rej      label {&sfoptrd_p_5} no-attr-space
        with frame c 6 down scroll 1 overlay row 8
/*G1VG*     Title " Rejects " centered attr-space */
/*G1VG*/    title color normal (getFrameTitle("REJECTS",18)) centered
attr-space
/*GM77*/ /*V8!width 60 */ .

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

        form
           rejv_reason      column-label {&sfoptrd_p_3}
           rejqty
           rsn_desc       no-attr-space
           total_rej      label {&sfoptrd_p_5} no-attr-space
        with frame c1 overlay
/*GM77*/ /*V8-*/   row 18
/*GM77*/ /*V8+*/ no-underline centered attr-space
/*GM77*/ /*V8!width 60 */ .

/* SET EXTERNAL LABELS */
setFrameLabels(frame c1:handle).

/*GM77*/ /*V8!frame c1:y = frame c:y + frame c:height-pixels. */
        if rejects then repeat:

/*GD95*        if keyfunction(lastkey) = "end-error" then leave rejhist. */

           clear frame c all no-pause.
           view frame c.
           view frame c1.

           total_rej = 0.
           for each rejfile
           with frame c:
          total_rej = total_rej + rejqty.
           end.

           for each rejfile
           break by rejv_reason
           with frame c:
          display rejqty total_rej rejv_reason.
          find rsn_ref where rsn_code = rejv_reason
          and rsn_type = "reject" no-lock no-error.
          if available rsn_ref then display rsn_desc.
          else display "" @ rsn_desc.
          if not last (rejv_reason) then down 1.
           end.

           set_rejhist:
           repeat with frame c1 on error undo, retry:

/*GD95*/          if batchrun then clear frame c1 all no-pause.

          prompt-for rejv_reason editing:
             {mfnp01.i rsn_ref rejv_reason rsn_code
             ""reject"" rsn_type rsn_type}

             if recno <> ? then do:
            display rsn_code @ rejv_reason rsn_desc.
            find first rejfile where rejv_reason = rsn_code no-error.
            if available rejfile
            then display rejqty.
            else display "" @ rejqty.
             end.
          end.

          if input rejv_reason = "" then leave rejhist.

          find first rejfile where rejv_reason = input rejv_reason no-error.
          if not available rejfile then do:
             find rsn_ref where rsn_code = input rejv_reason
             and rsn_type = "reject" no-lock no-error.
             if available rsn_ref then display rsn_desc.
             else do:
            display " " @ rsn_desc.
            {mfmsg.i 655 3}
            next-prompt rejv_reason.
            undo, retry.
             end.
             create rejfile.
             assign rejv_reason.
          end.

          last_v_reason = rejv_reason.
          prev_qty = rejqty.

          display rejqty.

          status input stline[2].

          do on error undo, retry:

             prompt-for rejqty go-on (F5 CTRL-D).

             if keylabel(lastkey) = "F5"
             or keylabel(lastkey) = "CTRL-D"
             then do:
            yn = yes.
            {mfmsg01.i 11 1 yn}
            if yn = no then undo, retry.
            rejqty = 0.
             end.
          end.

          assign rejqty.

          total_rej = total_rej + rejqty - prev_qty.
          display total_rej.
          if rejqty = 0 then delete rejfile.

          clear frame c all no-pause.

          counter = 0.
          for each rejfile
          by rejv_reason descending:
             counter = counter + 1.
             if counter > frame-down(c)
             and rejv_reason < last_v_reason then leave.
             if rejv_reason < last_v_reason then last_v_reason = rejv_reason.
          end.

          for each rejfile
          where rejv_reason >= last_v_reason
          by rejv_reason
          with frame c:
             display rejv_reason rejqty total_rej.
             find rsn_ref where rsn_code = rejv_reason
             and rsn_type = "reject" no-lock no-error.
             if available rsn_ref then display rsn_desc.
             else display "" @ rsn_desc.
             if frame-line > frame-down - 1 then leave.
             down 1.
          end.
           end.

/*GD95*/       if keyfunction(lastkey) = "end-error"
/*GD95*/       or input rejv_reason = "" then leave rejhist.
           /*GD95 LEAVE IF INPUT FROM ENDKEY OR EOF*/
           if lastkey = 46 or lastkey = -2 then leave rejhist.
        end.
        else do:
           {mfdel.i "rejfile"}
        end.
     end.

/*GD95*  if batchrun = no then readkey pause 1. */

     hide frame c1.
     hide frame c.

     rwkhist:
     do with frame d1:

        form
           rwkv_reason      column-label {&sfoptrd_p_3}
           rwkqty
           rsn_desc       no-attr-space
           total_rwk      label {&sfoptrd_p_4} no-attr-space
        with frame d 6 down scroll 1 overlay row 8
/*G1VG*     Title " Reworks " centered attr-space. */
/*G1VG*/    title color normal (getFrameTitle("REWORKS",18)) centered
attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

        form
           rwkv_reason      column-label {&sfoptrd_p_3}
           rwkqty
           rsn_desc       no-attr-space
           total_rwk      label {&sfoptrd_p_4} no-attr-space
        with frame d1 overlay row 18 no-underline centered attr-space.

        /* SET EXTERNAL LABELS */
        setFrameLabels(frame d1:handle).
/*GN40*/ /*V8! frame d1:y = frame d:y + frame c:height-pixels. */
        if reworks then repeat:

/*GD95*        if keyfunction(lastkey) = "end-error" then leave rwkhist. */

           clear frame d all no-pause.
           view frame d.
           view frame d1.

           total_rwk = 0.
           for each rwkfile
           with frame d:
          total_rwk = total_rwk + rwkqty.
           end.

           for each rwkfile
           break by rwkv_reason
           with frame d:
          display rwkqty total_rwk rwkv_reason.
          find rsn_ref where rsn_code = rwkv_reason
          and rsn_type = "rework" no-lock no-error.
          if available rsn_ref then display rsn_desc.
          else display "" @ rsn_desc.
          if not last (rwkv_reason) then down 1.
           end.

           set_rwkhist:
           repeat with frame d1 on error undo, retry:

/*GD95*/          if batchrun then clear frame d1 all no-pause.

          prompt-for rwkv_reason editing:
             {mfnp01.i rsn_ref rwkv_reason rsn_code
             ""rework"" rsn_type rsn_type}

             if recno <> ? then do:
            display rsn_code @ rwkv_reason rsn_desc.
            find first rwkfile where rwkv_reason = rsn_code no-error.
            if available rwkfile
            then display rwkqty.
            else display "" @ rwkqty.
             end.
          end.

          if input rwkv_reason = "" then leave rwkhist.

          find first rwkfile where rwkv_reason = input rwkv_reason no-error.
          if not available rwkfile then do:
             find rsn_ref where rsn_code = input rwkv_reason
             and rsn_type = "rework" no-lock no-error.
             if available rsn_ref then display rsn_desc.
             else do:
            display " " @ rsn_desc.
            {mfmsg.i 655 3}
            next-prompt rwkv_reason.
            undo, retry.
             end.
             create rwkfile.
             assign rwkv_reason.
          end.

          last_v_reason = rwkv_reason.
          prev_qty = rwkqty.

          display rwkqty.

          status input stline[2].

          do on error undo, retry:

             prompt-for rwkqty go-on (F5 CTRL-D).

             if keylabel(lastkey) = "F5"
             or keylabel(lastkey) = "CTRL-D"
             then do:
            yn = yes.
            {mfmsg01.i 11 1 yn}
            if yn = no then undo, retry.
            rwkqty = 0.
             end.
          end.

          assign rwkqty.

          total_rwk = total_rwk + rwkqty - prev_qty.
          display total_rwk.
          if rwkqty = 0 then delete rwkfile.

          clear frame d all no-pause.

          counter = 0.
          for each rwkfile
          by rwkv_reason descending:
             counter = counter + 1.
             if counter > frame-down(d)
             and rwkv_reason < last_v_reason then leave.
             if rwkv_reason < last_v_reason then last_v_reason = rwkv_reason.
          end.

          for each rwkfile
          where rwkv_reason >= last_v_reason
          by rwkv_reason
          with frame d:
             display rwkv_reason rwkqty total_rwk.
             find rsn_ref where rsn_code = rwkv_reason
             and rsn_type = "rework" no-lock no-error.
             if available rsn_ref then display rsn_desc.
             else display "" @ rsn_desc.
             if frame-line > frame-down - 1 then leave.
             down 1.
          end.
           end.

/*GD95*/       if keyfunction(lastkey) = "end-error"
/*GD95*/       or input rejv_reason = "" then leave rwkhist.
           /*GD95 LEAVE IF INPUT FROM ENDKEY OR EOF*/
           if lastkey = 46 or lastkey = -2 then leave rwkhist.
        end.
        else do:
           {mfdel.i "rwkfile"}
        end.
     end.

 130712.1 -e */

   
     hide frame d.
/*G876*/ /* End of new logic added */
