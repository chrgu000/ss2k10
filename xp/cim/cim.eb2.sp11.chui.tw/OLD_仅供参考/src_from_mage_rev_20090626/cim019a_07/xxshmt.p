/* Creation: eB2SP11.Chui   Modified: ??    By: Davild??    *????* */
/* Revision: eB2SP11.Chui   Modified: 08/15/06      By: Kaine Zhang     *ss-20060815.1* */
/* Revision: eB2SP11.Chui   Modified: 08/17/06      By: Kaine Zhang     *ss-20060817.1* */
/* Revision: eB2SP11.Chui   Modified: 08/23/06      By: Kaine Zhang     *ss-20060823.1* */
/* Revision: eB2SP11.Chui   Modified: 08/30/06      By: Kaine Zhang     *ss-20060830.1* */
/* Revision: eB2SP11.Chui   Modified: 09/18/06      By: Kaine Zhang     *ss - 20060918.1* */
/* Revision: eB2SP11.Chui   Modified: 10/11/06      By: Kaine Zhang     *ss - 20061011.1* */
/* Revision: eB2SP11.Chui   Modified: 11/14/06      By: Kaine Zhang     *ss - 20061114.1* */
/* Revision: eB2SP11.Chui   Modified: 09/23/2008   By: Kaine Zhang     Eco: *ss_20080923* */


/* *ss_20080923* All sales order must have same shipto address. */
/*ss - 20061114.1* repeat invoice number */
/*ss - 20061011.1*  tmp_so_qty(link.xxshd_so_qty)'s DEFAULT VALUE change.  */
/*ss - 20060918.1*  IF invice belongs TO "CS", THEN dose NOT CHECK terms.  */
/*ss-20060817.1*  Lock the co.cp TYPE record that have shipment  */
/*ss-20060815.1*  ADD shipment amount IN mstr TABLE  */

{mfdtitle.i "2+ "}
{xxshdefine.i "new" }
{xxshform.i}
define variable del-yn like mfc_logical initial no. /*sam Song Add  Delete Function */

/* *ss_20080923* */  define variable strShipTo like so_ship no-undo.

VIEW FRAME a .

main-loop:
REPEAT :
    hide all no-pause .
    view frame dtitle .
    
    UPDATE invcode WITH FRAME a EDITING:
        READKEY.
        APPLY LASTKEY .
    END.
    
    RUN getcodemstr(INPUT "shipmentinvoiceno",INPUT invcode,INPUT "N" , OUTPUT tmpinvno) .
    IF tmpinvno = "" THEN DO:
        {pxmsg.i &MSGNUM=9000 &ERRORLEVEL=3}   /*input error CS CO CP*/
        NEXT main-loop .
    END.

    
    loop-invno:
    REPEAT:
    	MESSAGE "輸入空則產生新的發票號碼." .
    	
        UPDATE invno go-on(F5 CTRL-D) WITH FRAM a .
    	
    	if invno = "" then do:
            RUN getcodemstr(INPUT "shipmentinvoiceno",INPUT invcode,INPUT "Y" , OUTPUT tmpinvno) .

            ASSIGN invno = substring("00000000",1,((8 - length(trim(invcode))) - length(tmpinvno))) + tmpinvno + caps(invcode) .
            
            disp invno with frame a .
            
            FIND FIRST xxshm_mstr WHERE xxshm_inv_no = invno NO-ERROR.
            
            /*ss - 20061114.1*/   IF NOT AVAILABLE xxshm_mstr THEN DO:
                CREATE xxshm_mstr .
                ASSIGN xxshm_inv_no = invno .
            /*ss - 20061114.1*/   END.
    
    	end.
    	else do:
    
    		FIND FIRST xxshm_mstr WHERE xxshm_inv_no = invno NO-ERROR.
    		
    		/* ***********************ss-20060817.1 B Add********************** */
    		IF ((invno MATCHES "*co") OR (invno MATCHES "*cp"))
    		    AND (AVAILABLE xxshm_mstr)
    		THEN DO:
    		    IF CAN-FIND(FIRST xxshd_det WHERE (xxshd_inv_no = xxshm_inv_no) AND xxshd_log[2] NO-LOCK) THEN DO:
    		        MESSAGE "has shipment, please re-enter.".
    		        UNDO loop-invno, RETRY loop-invno.
    		    END.
            END.
            /* ***********************ss-20060817.1 E Add********************** */
    		
    		IF AVAIL xxshm_mstr THEN DO:
    		    /*Sam Song Add 20080811 - Delete Function */
                FIND FIRST xxshd_det WHERE xxshd_inv_no = invno and xxshd_log[2] = yes NO-ERROR.
                IF AVAIL xxshd_det then do:
                    message "THE SHIPPER ALREADY ISSUE ".
                END.
                ELSE DO:
                    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")  then do:
                       del-yn = yes.
                       {mfmsg01.i 11 1 del-yn}
                       if del-yn then do:
                          delete xxshm_mstr.
                          for each xxshd_det where xxshd_inv_no = invno :
                              delete xxshd_det.
                          end.
                          clear frame a.
                       end.
                    
                    end.
                END.
                /*Sam Song Add 20080811 - Delete Function  END */
                    
    		    {pxmsg.i &MSGNUM=9001 &ERRORLEVEL=1} /* "Modify exist Invoice Data!" .*/
    		END.
    		ELSE DO:
    		if substring (invno,7,2 ) <> invcode then do:
    		    undo,retry.
    		end.
    		    /*{pxmsg.i &MSGNUM=9002 &ERRORLEVEL=1}*/ /* "Add new Invoice Record !" .   */
    			message "ADD RECORDS." .
    		    CREATE xxshm_mstr .
    		    ASSIGN xxshm_inv_no = invno .
     
    		END.
    	end.
    	
        VIEW FRAME finv .
        /*ss-20060830.1*  here ss-20060830.1 USE xxshmt01.i too  */
        /*ss-20060823.1*  here ss-20060823.1 USE xxshmt01.i too  */
        /*ss-20060815.1*  here ss-20060815.1 USE xxshmt01.i too  */
        {xxshmt01.i}    /*update header data*/

        LEAVE loop-invno .
    END.   /*loop-invno*/
    
/*     CREATE xxshm_mstr.                         */
/*     ASSIGN xxshm_inv_no = INPUT xxshm_inv_no . */

/*     IF "1" = "1" THEN DO:               */
/*         UNDO main-loop,RETRY main-loop . */
/*     END.                                 */
    invno="".

END.  /*main-loop*/


PROCEDURE getcodemstr:
    DEF INPUT PARAM pro_fldname AS CHAR .
    DEF INPUT PARAM pro_value AS CHAR .
    DEF INPUT PARAM pro_update AS CHAR .
    DEF OUTPUT PARAM pro_cmmt AS CHAR .
    FIND FIRST CODE_mstr WHERE CODE_fldname = pro_fldname AND CODE_value = pro_value
         NO-ERROR.
    IF AVAIL CODE_mstr  THEN DO:
        ASSIGN pro_cmmt = CODE_cmmt .
       	if pro_update = "Y" then do:   /* samsong Add 20080808 */
            ASSIGN CODE_cmmt = STRING(INTEGER(CODE_cmmt) + 1) .
    	end.
    END.
    ELSE ASSIGN pro_cmmt = "" .
    RELEASE CODE_mstr .
END PROCEDURE .

PROCEDURE getinteger:
    DEF INPUT-OUTPUT PARAM pro_integer AS DEC.
    DEF VAR ii AS INTE.
    DEF VAR tmpchar AS CHAR INIT "".
    DO ii = 1 TO LENGTH(STRING(pro_integer)):
        IF SUBSTR(STRING(pro_integer) ,ii,1) <> "." THEN DO:
            tmpchar = tmpchar + SUBSTR(STRING(pro_integer) ,ii,1) .
        END.
        ELSE LEAVE .
    END.
    IF pro_integer > DEC(tmpchar)  THEN
        ASSIGN pro_integer = DEC(tmpchar) + 1 .
    ELSE 
        ASSIGN pro_integer = DEC(tmpchar) .
END PROCEDURE .

