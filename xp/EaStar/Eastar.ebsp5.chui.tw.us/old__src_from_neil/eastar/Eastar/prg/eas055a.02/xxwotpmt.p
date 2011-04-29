/* Creation: eB.SP5.Chui    Modified: 08/14/06  By: Kaine Zhang     *ss-20060814.1* */
/* Revision: eB.SP5.Chui    Modified: 08/14/06  By: Kaine Zhang     *ss-20060818.1* */

/* ============================================================================== */
/*ss-20060818.1*  edit INDEX. USER can USE a TYPE (such AS "A") IN different site.  */
/*ss-20060814.1*  spec -- eas055a.02  */
/* ============================================================================== */

    {mfdtitle.i}
    
    DEFINE VARIABLE strXwtpType     LIKE    xwtp_type       NO-UNDO.
    DEFINE VARIABLE blnDelXwtp      AS      LOGICAL         NO-UNDO.
    
    /*ss-20060818.1*/  DEFINE VARIABLE strXwtpSite  LIKE    si_site     NO-UNDO.
    
    FORM
        SKIP(1)
        strXwtpType     COLON 15    LABEL "Wo Type"
        /*ss-20060818.1*  SKIP(1)  */
        /*ss-20060818.1*  xwtp_site       COLON 15    LABEL "Site"  */
        /*ss-20060818.1*/ strXwtpSite   COLON 15    LABEL "Site"
        si_desc         AT 30       NO-LABELS
        /*ss-20060818.1*/ SKIP(1) 
        xwtp_loc        COLON 15    LABEL "Location"
        loc_desc        AT 30       NO-LABELS
        xwtp_is_ser     COLON 15    LABEL "Series"
        xwtp_desc       COLON 15    LABEL "Description"
    WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE.
    setFrameLabels(FRAME a:HANDLE).
    
    
    
    
    mainlp:
    REPEAT ON ENDKEY UNDO, LEAVE:
        
        /* ********************ss-20060818.1 B Del*******************
         *  /*ss-20060814.1*  BLOCK.beg.update strXwtpType  */
         *  UPDATE
         *      strXwtpType
         *  WITH FRAME a EDITING:
         *      {mfnp.i
         *          xwtp_det
         *          strXwtpType
         *          xwtp_type
         *          strXwtpType
         *          xwtp_type
         *          xwtp_type
         *      }
         *      
         *      IF recno <> ? THEN DO:
         *          FOR FIRST si_mstr
         *              FIELDS (si_site si_desc)
         *              WHERE si_site = xwtp_site
         *              NO-LOCK:
         *          END.
         *          
         *          FOR FIRST loc_mstr
         *              FIELDS (loc_site loc_loc loc_desc)
         *              WHERE loc_site = xwtp_site
         *                  AND loc_loc = xwtp_loc
         *              NO-LOCK:
         *          END.
         *          
         *          DISPLAY
         *              xwtp_type @ strXwtpType
         *              xwtp_site
         *              (IF AVAILABLE si_mstr THEN si_desc ELSE "") @ si_desc
         *              xwtp_loc
         *              (IF AVAILABLE loc_mstr THEN loc_desc ELSE "") @ loc_desc
         *              xwtp_is_ser
         *              xwtp_desc
         *          WITH FRAME a.
         *      END.
         *      ELSE
         *          DISPLAY
         *              "" @ xwtp_site
         *              "" @ xwtp_site
         *              "" @ si_desc
         *              "" @ xwtp_loc
         *              "" @ loc_desc
         *              "" @ xwtp_is_ser
         *              "" @ xwtp_desc
         *          WITH FRAME a.
         *  END.
         *  /*ss-20060814.1*  BLOCK.end.update strXwtpType  */
         * ********************ss-20060818.1 E Del*******************/
         
        
        /* ***********************ss-20060818.1 B Add********************** */
        UPDATE
            strXwtpType
            strXwtpSite
        WITH FRAME a EDITING:
            IF FRAME-FIELD = "strXwtpType" THEN DO:
                {mfnp05.i
                    xwtp_det
                    xwtp_typesite
                    YES
                    xwtp_type
                    "INPUT strXwtpType"
                }
            END.
            ELSE IF FRAME-FIELD = "strXwtpSite" THEN DO:
                {mfnp05.i
                    xwtp_det
                    xwtp_typesite
                    YES
                    xwtp_site
                    "INPUT strXwtpSite"
                }
            END.
            ELSE DO:
                READKEY.
                APPLY LASTKEY.
            END.
            

            IF recno <> ? THEN DO:
                FOR FIRST si_mstr
                    FIELDS (si_site si_desc)
                    WHERE si_site = xwtp_site
                    NO-LOCK:
                END.
                
                FOR FIRST loc_mstr
                    FIELDS (loc_site loc_loc loc_desc)
                    WHERE loc_site = xwtp_site
                        AND loc_loc = xwtp_loc
                    NO-LOCK:
                END.
                
                DISPLAY
                    xwtp_type @ strXwtpType
                    xwtp_site @ strXwtpSite
                    (IF AVAILABLE si_mstr THEN si_desc ELSE "") @ si_desc
                    xwtp_loc
                    (IF AVAILABLE loc_mstr THEN loc_desc ELSE "") @ loc_desc
                    xwtp_is_ser
                    xwtp_desc
                WITH FRAME a.
                
            END.
               
        END.
        /* ***********************ss-20060818.1 E Add********************** */
        

        /*ss-20060814.1*  BLOCK.beg. DISPLAY xwtp_det BY strXwtpType  */
        FIND FIRST xwtp_det
            WHERE xwtp_type = strXwtpType
                /*ss-20060818.1*/  AND xwtp_site = strXwtpSite
            NO-ERROR.
            
        IF NOT AVAILABLE xwtp_det THEN DO:
            CREATE xwtp_det.
            ASSIGN
                xwtp_type = strXwtpType
                /*ss-20060818.1*/  xwtp_site = strXwtpSite
                .
        END.
        
        FOR FIRST si_mstr
            FIELDS (si_site si_desc)
            WHERE si_site = xwtp_site
            NO-LOCK:
        END.
        
        FOR FIRST loc_mstr
            FIELDS (loc_site loc_loc loc_desc)
            WHERE loc_site = xwtp_site
                AND loc_loc = xwtp_loc
            NO-LOCK:
        END.
        
        DISPLAY
            /*ss-20060818.1*  xwtp_site  */
            (IF AVAILABLE si_mstr THEN si_desc ELSE "") @ si_desc
            xwtp_loc
            (IF AVAILABLE loc_mstr THEN loc_desc ELSE "") @ loc_desc
            xwtp_is_ser
            xwtp_desc
        WITH FRAME a.
        /*ss-20060814.1*  BLOCK.beg. DISPLAY xwtp_det BY strXwtpType  */
        
        
        upxwtplp:
        DO ON ERROR UNDO, LEAVE
            ON ENDKEY UNDO mainlp, RETRY mainlp
            :
            
            STATUS INPUT stline[2] .
            SET
                /*ss-20060818.1*  xwtp_site  */
                xwtp_loc
                xwtp_is_ser
                xwtp_desc
            GO-ON ("F5" "CTRL-D")
            WITH FRAME a EDITING:
                READKEY.
                APPLY LASTKEY.
                
                
                /* ********************ss-20060818.1 B Del*******************
                 *  IF FRAME-FIELD = "xwtp_site" THEN DO:
                 *      FOR FIRST si_mstr
                 *          FIELDS (si_site si_desc)
                 *          WHERE si_site = INPUT xwtp_site
                 *          NO-LOCK:
                 *      END.
                 *      
                 *      DISPLAY
                 *          (
                 *              IF AVAILABLE si_mstr THEN si_desc
                 *              ELSE ""
                 *          )
                 *          @ si_desc
                 *      WITH FRAME a.
                 *  END.
                 * ********************ss-20060818.1 E Del*******************/
                 
                IF FRAME-FIELD = "xwtp_loc" THEN DO:
                    FOR FIRST loc_mstr
                        FIELDS (loc_site loc_loc loc_desc)
                        /*ss-20060818.1*  WHERE loc_site = INPUT xwtp_site  */
                        /*ss-20060818.1*/ WHERE loc_site = xwtp_site
                            AND loc_loc = INPUT xwtp_loc
                        NO-LOCK:
                    END.
                    
                    DISPLAY
                        (
                            IF AVAILABLE loc_mstr THEN loc_desc
                            ELSE ""
                        )
                        @ loc_desc
                    WITH FRAME a.
                END.
            END.
            
            IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D") THEN DO:
                blnDelXwtp = NO.
                
                {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=blnDelXwtp}
                
                IF blnDelXwtp THEN DO:
                    DELETE xwtp_det.
    
                    ASSIGN
                        strXwtpType  = ""
                        /*ss-20060818.1*/  strXwtpSite = ""
                        .
                    
                    CLEAR FRAME a ALL NO-PAUSE.
    
                    NEXT mainlp.
                END.
                ELSE DO:
                    UNDO upxwtplp, RETRY upxwtplp.
                END.
            END.
        END.
    END.
    