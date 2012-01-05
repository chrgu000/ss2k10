/* SS - 111020.1 BY KEN */
/******************************************************************************/
/* SCHEDULE MAINTENANCE DETAIL SUBPROGRAM */
/* DISPLAYS/MAINTAINS CUSTOMER LAST RECEIPT INFO */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


define input parameter sch_recid as recid.

DEFINE VARIABLE OLD_date AS DATE LABEL "原日期".
DEFINE VARIABLE NEW_date AS DATE LABEL "新日期".
DEFINE VARIABLE v_over   AS CHARACTER LABEL "覆盖(C)/合并(M)".

DEFINE VARIABLE v_OLD_date AS DATE EXTENT 7.
DEFINE VARIABLE v_NEW_date AS DATE EXTENT 7.
DEFINE VARIABLE v_v_over   AS CHARACTER EXTENT 7 INITIAL ["C","C","C","C","C","C","C"].

DEFINE TEMP-TABLE xxschd_det
    FIELD xxschd_old_date LIKE schd_date
    FIELD xxschd_old_time LIKE schd_time
    FIELD xxschd_old_reference LIKE schd_reference
    FIELD xxschd_old_upd_qty LIKE schd_upd_qty
    FIELD xxschd_old_fc_qual LIKE schd_fc_qual

    FIELD xxschd_new_date LIKE schd_date
    FIELD xxschd_new_time LIKE schd_time
    FIELD xxschd_new_reference LIKE schd_reference
    FIELD xxschd_new_upd_qty LIKE schd_upd_qty
    FIELD xxschd_new_fc_qual LIKE schd_fc_qual
    FIELD xxschd_type LIKE schd_type
    FIELD xxschd_nbr LIKE schd_nbr
    FIELD xxschd_line LIKE schd_line
    FIELD xxschd_rlse_id LIKE schd_rlse_id
    INDEX index1 xxschd_old_date.

define variable i as integer.

FORM /*GUI*/ 
   OLD_date
   NEW_date
   v_over
with frame BATCH_date1 width 80 attr-space 7 down
title color normal (getFrameTitle("修改日期",25)) THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame BATCH_date1:handle).

/*SS - 111020.1 B*/
FOR EACH xxschd_det:
    DELETE xxschd_det.
END.

find sch_mstr where recid(sch_mstr) = sch_recid NO-LOCK.

for each schd_det NO-LOCK
     where schd_det.schd_domain = global_domain and  schd_type = sch_type
     and schd_nbr = sch_nbr
     and schd_line = sch_line
     and schd_rlse_id = sch_rlse_id:
     CREATE xxschd_det.
     ASSIGN xxschd_old_date = schd_date
           xxschd_old_time = schd_time
           xxschd_old_reference = schd_reference
           xxschd_old_upd_qty = schd_upd_qty
           xxschd_old_fc_qual = schd_fc_qual
           xxschd_type = schd_type
           xxschd_nbr = schd_nbr
           xxschd_line = schd_line
           xxschd_rlse_id = schd_rlse_id.
end.

/*SS - 111020.1 E*/

do i = 1 to 7:

   display
      v_old_date[i]     @ OLD_date
      v_new_date[i]    @ new_date
      v_v_over[i]    @ v_over
   with frame BATCH_date1.

   if i < 7 then down 1 with frame BATCH_date1.

end.

up 6 with frame BATCH_date1.

do i = 1 to 7 on error undo, leave on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.

   prompt-for
      OLD_date
      NEW_date
      v_over
   with frame BATCH_date1.

   
   assign
      v_old_date[i] = input frame BATCH_date1 old_date
      v_new_date[i] = input frame BATCH_date1 new_date
      v_v_over[i] = input frame BATCH_date1 v_over.
      
   if i < 7 then down 1 with frame BATCH_date1.


   FOR EACH xxschd_det WHERE xxschd_old_date = v_old_date[i] :


       IF upper(v_v_over[i]) = "C" THEN DO:
          ASSIGN
             xxschd_new_date = v_new_date[i]
             xxschd_new_time = xxschd_old_time
             xxschd_new_reference = xxschd_old_reference
             xxschd_new_upd_qty = xxschd_old_upd_qty
             xxschd_new_fc_qual = xxschd_old_fc_qual.
       END.

       IF upper(v_v_over[i]) = "M" THEN DO:
          ASSIGN
             xxschd_new_date = v_new_date[i]
             xxschd_new_time = xxschd_old_time
             xxschd_new_reference = xxschd_old_reference
             xxschd_new_upd_qty = xxschd_old_upd_qty
             xxschd_new_fc_qual = xxschd_old_fc_qual.

          FIND FIRST schd_det WHERE schd_domain = GLOBAL_domain 
              AND schd_type = xxschd_type
              AND schd_nbr = xxschd_nbr
              AND schd_line = xxschd_line
              AND schd_rlse_id = xxschd_rlse_id 
              AND schd_date = v_new_date[i]
              AND schd_time = xxschd_old_time
              AND schd_reference = schd_reference
              NO-LOCK NO-ERROR.
          IF AVAIL schd_det THEN DO:
              ASSIGN
                 xxschd_new_upd_qty =  xxschd_new_upd_qty + schd_upd_qty.
          END.

       END.

   END.

end.

FOR EACH xxschd_det WHERE xxschd_old_date <> v_old_date[1]
    AND xxschd_old_date <> v_old_date[2]
    AND xxschd_old_date <> v_old_date[3] 
    AND xxschd_old_date <> v_old_date[4]
    AND xxschd_old_date <> v_old_date[5]
    AND xxschd_old_date <> v_old_date[6]
    AND xxschd_old_date <> v_old_date[7]:

    DELETE xxschd_det.

END.


FOR EACH xxschd_det NO-LOCK BY xxschd_new_date DESCENDING:
    FOR EACH schd_det WHERE schd_domain = GLOBAL_domain 
        AND schd_type = xxschd_type
        AND schd_nbr = xxschd_nbr
        AND schd_line = xxschd_line
        AND schd_rlse_id = xxschd_rlse_id 
        AND schd_date = xxschd_old_date
        AND schd_time = xxschd_old_time
        AND schd_reference = xxschd_old_reference :
        DELETE schd_det.
    END.

    FOR EACH schd_det WHERE schd_domain = GLOBAL_domain 
        AND schd_type = xxschd_type
        AND schd_nbr = xxschd_nbr
        AND schd_line = xxschd_line
        AND schd_rlse_id = xxschd_rlse_id 
        AND schd_date = xxschd_new_date 
        AND schd_time = xxschd_new_time
        AND schd_reference = xxschd_new_reference:
        DELETE schd_det.
    END.

    
    IF xxschd_new_date <> ? THEN DO:
        FIND FIRST schd_det WHERE schd_domain = GLOBAL_domain 
            AND schd_type = xxschd_type
            AND schd_nbr = xxschd_nbr
            AND schd_line = xxschd_line
            AND schd_rlse_id = xxschd_rlse_id 
            AND schd_date = xxschd_new_date 
            AND schd_time = xxschd_new_time
            AND schd_reference = xxschd_new_referenc NO-LOCK NO-ERROR.    
        IF NOT AVAIL schd_det THEN DO:
            
            CREATE schd_det.
            ASSIGN schd_domain = GLOBAL_domain
                   schd_type = xxschd_type
                   schd_nbr = xxschd_nbr
                   schd_line = xxschd_line
                   schd_rlse_id = xxschd_rlse_id
                   schd_date = xxschd_new_date
                   schd_time = xxschd_new_time
                   schd_reference = xxschd_new_reference
                   schd_discr_qty = xxschd_new_upd_qty
                   schd_upd_qty = xxschd_new_upd_qty
                   schd_fc_qual = xxschd_new_fc_qual.
    
        END.
    END.
    
END.

/*
FOR EACH schd_det WHERE schd_domain = GLOBAL_domain AND CAN-FIND(FIRST xxschd_det WHERE xxschd_type =schd_type AND xxschd_nbr = schd_nbr
                                                                 AND xxschd_line =schd_line AND xxschd_rlse_id = schd_rlse_id):

END.
*/

HIDE FRAME BATCH_date1.
/*GUI*/ if global-beam-me-up then undo, leave.

