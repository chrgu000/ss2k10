/* yyglcim.i       define the temp-table for cim load */
/* Author: James Duan *GYD1* 2009-11-20               */

/* GL Header */
define {1} shared temp-table ttglt_mstr
   fields ttglt_id		as   int
   fields ttglt_dr_acct		as   char  format "x(20)"
   fields ttglt_cr_acct		as   char  format "x(20)"
   fields ttglt_cr_acct2	as   char  format "x(20)"
   fields ttglt_ref		like glt_ref
   fields ttglt_eff_date	like glt_effdate initial ?
   fields ttglt_curr		like glt_curr
   fields ttglt_corr		like glt_correction
   fields ttglt_ctrl_amt	like glt_amt
index id is primary unique ttglt_id.

define {1} shared temp-table ttgltd_det
   fields ttgltd_id		as   int
   fields ttgltd_line		like glt_line
   fields ttgltd_acct		like glt_acct
   fields ttgltd_sub		like glt_sub
   fields ttgltd_cc		like glt_cc
   fields ttgltd_project	like glt_project
   fields ttgltd_entity		like glt_entity
   fields ttgltd_desc		like glt_desc
   fields ttgltd_curr1		like glt_curr
   fields ttgltd_amt		like glt_amt
index id is primary ttgltd_id ttgltd_line.