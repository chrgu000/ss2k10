/* xxfldbr.p - field browse.                                                 */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* {mfdtitle.i "09Y01"} */
define variable ret as logical initial yes.
define temp-table lbls no-undo
  fields lbls_field like _field-name
  fields lbls_update as  logical initial no label "U"
  fields lbls_term   like lbl_term
  fields lbls_long   like lbl_long
  fields lbls_medium like lbl_medium
  fields lbls_short  like lbl_short
  index  lbls_field  lbls_field
  INDEX  lbls_field_term lbls_field lbls_term.

DEFINE VARIABLE VFILENAME AS CHARACTER LABEL "FileName" format "x(16)".
DEFINE VARIABLE vlanguage like lng_lang initial "CH".
DEFINE QUERY q1 FOR _file,_FIELD,lbls SCROLLING.
DEFINE BROWSE b1 QUERY q1 DISPLAY
    _field-name format "x(20)"
    lbls_update    
    lbls_term format "x(12)"
    lbls_long format "x(20)"
    lbls_medium format "x(12)"

    enable lbls_update
           lbls_term
    			 lbls_long
           lbls_medium
           
    WITH 13 DOWN no-assign separators TITLE "Field Browse"    .

DEFINE FRAME f1
             b1
             vlanguage vfilename
        WITH SIDE-LABELS AT ROW 2 COLUMN 2.
display vlanguage with frame f1.
               
on "enter":U of vfilename do:
	assign vlanguage vfilename.
	find first lbls no-lock where lbls_term <> "" no-error.
	if avail lbls then do: 
		MESSAGE "已经编辑的资料将会清除，确定要重新编辑吗？" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO title "" UPDATE ret.
  end.
  if not ret then do:
  	return.
  end.
 
	empty temp-table lbls no-error.
	for EACH _file no-lock WHERE _file-name = vfilename , EACH _field OF _FILE no-lock: 
		create lbls.
		assign lbls_field = _field-name.
		find first lbld_det no-lock where lbld_fieldname = _field-name and lbld_execname = "" no-error.
		if avail lbld_det then do:
			  assign lbls_term = lbld_term.
			  find first lbl_mstr no-lock where lbl_lang = vlanguage and lbl_term = lbld_term no-error.
			  if avail lbl_mstr then do:
			  	assign lbls_long = lbl_long
			  	       lbls_medium = lbl_medium 
			  	       lbls_short = lbl_short.
			  end.
	  end.
	END.
	OPEN QUERY q1 FOR EACH _file no-lock WHERE _file-name = vfilename ,EACH _field OF _FILE no-lock
                 ,each lbls OUTER-JOIN exclusive-lock where lbls_field = _field-name.
	
end.
ENABLE vlanguage vfilename b1 WITH FRAME f1.
/* ASSIGN b1:NUM-LOCKED-COLUMNS IN FRAME f1 = 1. */
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
