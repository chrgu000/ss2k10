{mfdtitle.i "2+ "}
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

define variable desc1 like pt_desc1 format "x(49)" no-undo.
define variable old_order like tr_nbr.
define variable first_pass like mfc_logical.
define variable site like in_site.
define variable site1 like in_site.

form
   nbr            colon 20
   nbr1           label "To" colon 49 skip
   trdate         colon 20
   trdate1        label "To" colon 49 skip
   part           colon 20
   part1          label "To" colon 49 skip
   site           colon 20
   site1          label "To" colon 49 skip
   so_job         colon 20
   so_job1        label "To" colon 49 skip (1)
   type           colon 20 skip
with overlay frame a side-labels.
setFrameLabels(frame a:handle).
VIEW FRAME a
