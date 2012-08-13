{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
define temp-table tt_rep_flds
   field tt_rf_rec_seq   like  edxfdd_rec_seq
   field tt_rf_fld_seq   like  edxfdd_fld_seq
   field tt_rf_fld_val   as    character format "x(99)"
   index tt_rf_fld_idx   tt_rf_fld_seq.
for first edxr_mstr where recid( edxr_mstr ) = 1
no-lock:
end.

/* GET EXCHANGE FILE REPOSITORY DETAIL RECORD */

for first edxrd_det where recid( edxrd_det ) = 1 no-lock:
end.
for first edxfd_det                    where
   edxfd_exf_name = edxr_exf_name     and
   edxfd_exf_vers = edxr_exf_vers     and
   edxfd_doc_in   = edxr_doc_in       and
   edxfd_rec_seq  = edxrd_exf_rec_seq no-lock:
end.

for each edxfdd_det                  where
      edxfdd_exf_name = edxfd_exf_name and
      edxfdd_exf_vers = edxfd_exf_vers and
      edxfdd_doc_in   = edxfd_doc_in   and
      edxfdd_rec_seq  = edxfd_rec_seq  no-lock:

  create tt_rep_flds.
   
      tt_rf_rec_seq  = edxfdd_rec_seq.
      tt_rf_fld_seq  = edxfdd_fld_seq.
      tt_rf_fld_val  = edxrd_exf_fld[ edxfdd_fld_seq ].
end.
 {edswind.i
            &searchkey    = tt_rf_fld_seq
            &detfile      = tt_rep_flds
            &detkey       = tt_rf_fld_seq
            &detlink      = tt_rf_fld_seq
            &mstrfile     = edxfdd_det

            &mstrkey      = " ~
              edxfdd_exf_name = edxfd_exf_name and
              edxfdd_exf_vers = edxfd_exf_vers and
              edxfdd_doc_in   = edxfd_doc_in   and
              edxfdd_rec_seq  = tt_rf_rec_seq  and
              edxfdd_fld_seq "

            &scroll-field = tt_rf_fld_seq
            &framename    = "d"
            &framesize    = 7
            &display1     = tt_rf_fld_seq
            &display2     = "l_fldname @ edxfdd_fld_name"
            &display3     = tt_rf_fld_val
            &exitlabel    = browloop
            &exit-flag    = false
            &record-id    = 1
            &statusline   = stline[6] }
