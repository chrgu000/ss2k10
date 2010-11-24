/* xxgettab.p - gettable field detail                                        */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/*!
get table's fields detail.
{1} file name
{2} Where you want output

e.g. 
RUN "d:\trunk\common\xxgettab.p" "pt_mstr" "CLIPBOARD".

*/


OUTPUT TO "{2}".
FOR EACH _FILE NO-LOCK WHERE _FILE-NAME = "{1}":
    FOR EACH _FIELD OF _FILE BY _ORDER:
        DISPLAY _ORDER _FIELD-NAME _FORMAT _DATA-TYPE
                _INITIAL _LABEL _COL-LABEL _help _desc
        WITH WIDTH 312 STREAM-IO.
    END.

    FOR EACH _Index NO-LOCK where _File-recid = RECID(_File):
    		DISP _Index WITH STREAM-IO.
    		FOR EACH _INDEX-FIELD NO-LOCK WHERE _Index-recid = RECID(_INDEX):
    	  	DISPLAY _INDEX-FIELD WITH STREAM-IO.
    	  END.
    END.
END.
OUTPUT CLOSE.
