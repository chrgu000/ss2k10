/* xxsetvar.i - save variable list to usrw_wkfl                               */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */

/*-----------------------------------------------------------------------------
 *  API:
 *      {xxgetvar.i
 *          &KEY1         - Needed. Key field1.
 *          &KEY2         - Needed. Key field2.
 *          &KEY3~KEY6    - Optional.
 *          &CHAR1~CHAR15 - Optional.
 *          &DEC1~DEC15   - Optional.
 *          &INT1~INT15   - Optional.
 *          &LOG1~LOG15   - Optional.
 *          &DATE1~DATE4  - Optional.
 *          &USER1~USER2  - Optional.
 *          &C01          - Optional.
 *      }
 * NOTE: deffient parameter have deffient type.
 * SAMPLE:
    {mfdeclre.i}
    define variable v3 as character.
    define variable v4 as character.
    define variable v5 as character.
    define variable v6 as character.
    define variable v7 as character.
    define variable v8 as character.
    define variable v9 as character.
    define variable dc1 as decimal.
    define variable l1 as logical.
    define variable d1 as date.
    {xxgetvar.i &KEY1=global_userid
                &KEY2=execname
                &KEY3=v3
                &KEY4=v4
                &KEY5=v5
                &KEY6=v6
                &CHAR1=v7
                &DEC1=dc1
                &LOG1=l1
                &DATE1=d1
                &USER1=v8
                &C01=v9}
    message v1 v2 v3 v4 v5 v6 v7 v8 v9 dc1 l1 d1 view-as alert-box.
 *
 *----------------------------------------------------------------------------*/
&IF (DEFINED(KEY1) = 2) and (DEFINED(KEY2) = 2) &THEN
    find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
               usrw_key1 = {&KEY1} and usrw_key2 = {&KEY2} no-error.
    if available usrw_wkfl then do:
       &IF (DEFINED(KEY3) = 2) &THEN
           assign {&KEY3} = usrw_key3.
       &ENDIF
       &IF (DEFINED(KEY4) = 2) &THEN
           assign {&KEY4} = usrw_key4.
       &ENDIF
       &IF (DEFINED(KEY5) = 2) &THEN
           assign {&KEY5} = usrw_key5.
       &ENDIF
       &IF (DEFINED(KEY6) = 2) &THEN
           assign {&KEY6} = usrw_key6.
       &ENDIF
       &IF (DEFINED(CHAR1) = 2) &THEN
           assign {&CHAR1} = usrw_charfld[1].
       &ENDIF
       &IF (DEFINED(CHAR2) = 2) &THEN
           assign {&CHAR2} = usrw_charfld[2].
       &ENDIF
       &IF (DEFINED(CHAR3) = 2) &THEN
           assign {&CHAR3} = usrw_charfld[3].
       &ENDIF
       &IF (DEFINED(CHAR4) = 2) &THEN
           assign {&CHAR4} = usrw_charfld[4].
       &ENDIF
       &IF (DEFINED(CHAR5) = 2) &THEN
           assign {&CHAR5} = usrw_charfld[5].
       &ENDIF
       &IF (DEFINED(CHAR6) = 2) &THEN
           assign {&CHAR6} =usrw_charfld[6].
       &ENDIF
       &IF (DEFINED(CHAR7) = 2) &THEN
           assign {&CHAR7} = usrw_charfld[7].
       &ENDIF
       &IF (DEFINED(CHAR8) = 2) &THEN
           assign {&CHAR8} = usrw_charfld[8].
       &ENDIF
       &IF (DEFINED(CHAR9) = 2) &THEN
           assign {&CHAR9} = usrw_charfld[9].
       &ENDIF
       &IF (DEFINED(CHAR10) = 2) &THEN
           assign {&CHAR10} = usrw_charfld[10].
       &ENDIF
       &IF (DEFINED(CHAR11) = 2) &THEN
           assign {&CHAR11} = usrw_charfld[11].
       &ENDIF
       &IF (DEFINED(CHAR12) = 2) &THEN
           assign {&CHAR12} = usrw_charfld[12].
       &ENDIF
       &IF (DEFINED(CHAR13) = 2) &THEN
           assign {&CHAR13} = usrw_charfld[13].
       &ENDIF
       &IF (DEFINED(CHAR14) = 2) &THEN
           assign {&CHAR14} = usrw_charfld[14].
       &ENDIF
       &IF (DEFINED(CHAR15) = 2) &THEN
           assign {&CHAR15} = usrw_charfld[15].
       &ENDIF
       &IF (DEFINED(DEC1) = 2) &THEN
           assign {&DEC1} = usrw_decfld[1].
       &ENDIF
       &IF (DEFINED(DEC2) = 2) &THEN
           assign {&DEC2} = usrw_decfld[2].
       &ENDIF
       &IF (DEFINED(DEC3) = 2) &THEN
           assign {&DEC3} = usrw_decfld[3].
       &ENDIF
       &IF (DEFINED(DEC4) = 2) &THEN
           assign {&DEC4} = usrw_decfld[4].
       &ENDIF
       &IF (DEFINED(DEC5) = 2) &THEN
           assign {&DEC5} = usrw_decfld[5].
       &ENDIF
       &IF (DEFINED(DEC6) = 2) &THEN
           assign {&DEC6} = usrw_decfld[6].
       &ENDIF
       &IF (DEFINED(DEC7) = 2) &THEN
           assign {&DEC7} = usrw_decfld[7].
       &ENDIF
       &IF (DEFINED(DEC8) = 2) &THEN
           assign {&DEC8} = usrw_decfld[8].
       &ENDIF
       &IF (DEFINED(DEC9) = 2) &THEN
           assign {&DEC9} = usrw_decfld[9].
       &ENDIF
       &IF (DEFINED(DEC10) = 2) &THEN
           assign {&DEC10} = usrw_decfld[10].
       &ENDIF
       &IF (DEFINED(DEC11) = 2) &THEN
           assign {&DEC11} = usrw_decfld[11].
       &ENDIF
       &IF (DEFINED(DEC12) = 2) &THEN
           assign {&DEC12} = usrw_decfld[12].
       &ENDIF
       &IF (DEFINED(DEC13) = 2) &THEN
           assign {&DEC13} = usrw_decfld[13].
       &ENDIF
       &IF (DEFINED(DEC14) = 2) &THEN
           assign {&DEC14} = usrw_decfld[14].
       &ENDIF
       &IF (DEFINED(DEC15) = 2) &THEN
           assign {&DEC15} = usrw_decfld[15].
       &ENDIF
       &IF (DEFINED(INT1) = 2) &THEN
           assign {&INT1} = usrw_intfld[1].
       &ENDIF
       &IF (DEFINED(INT2) = 2) &THEN
           assign {&INT2} = usrw_intfld[2].
       &ENDIF
       &IF (DEFINED(INT3) = 2) &THEN
           assign {&INT3} = usrw_intfld[3].
       &ENDIF
       &IF (DEFINED(INT4) = 2) &THEN
           assign {&INT4} = usrw_intfld[4].
       &ENDIF
       &IF (DEFINED(INT5) = 2) &THEN
           assign {&INT5} = usrw_intfld[5].
       &ENDIF
       &IF (DEFINED(INT6) = 2) &THEN
           assign {&INT6} = usrw_intfld[6].
       &ENDIF
       &IF (DEFINED(INT7) = 2) &THEN
           assign {&INT7} = usrw_intfld[7].
       &ENDIF
       &IF (DEFINED(INT8) = 2) &THEN
           assign {&INT8} = usrw_intfld[8].
       &ENDIF
       &IF (DEFINED(INT9) = 2) &THEN
           assign {&INT9} = usrw_intfld[9].
       &ENDIF
       &IF (DEFINED(INT10) = 2) &THEN
           assign {&INT10} = usrw_intfld[10].
       &ENDIF
       &IF (DEFINED(INT11) = 2) &THEN
           assign {&INT11} = usrw_intfld[11].
       &ENDIF
       &IF (DEFINED(INT12) = 2) &THEN
           assign {&INT12} = usrw_intfld[12].
       &ENDIF
       &IF (DEFINED(INT13) = 2) &THEN
           assign {&INT13} = usrw_intfld[13].
       &ENDIF
       &IF (DEFINED(INT14) = 2) &THEN
           assign {&INT14} = usrw_intfld[14].
       &ENDIF
       &IF (DEFINED(INT15) = 2) &THEN
           assign {&INT15} = usrw_intfld[15].
       &ENDIF
       &IF (DEFINED(LOG1) = 2) &THEN
           assign {&LOG1} = usrw_logfld[1].
       &ENDIF
       &IF (DEFINED(LOG2) = 2) &THEN
           assign {&LOG2} = usrw_logfld[2].
       &ENDIF
       &IF (DEFINED(LOG3) = 2) &THEN
           assign {&LOG3} = usrw_logfld[3].
       &ENDIF
       &IF (DEFINED(LOG4) = 2) &THEN
           assign {&LOG4} = usrw_logfld[4].
       &ENDIF
       &IF (DEFINED(LOG5) = 2) &THEN
           assign {&LOG5} = usrw_logfld[5].
       &ENDIF
       &IF (DEFINED(LOG6) = 2) &THEN
           assign {&LOG6} = usrw_logfld[6].
       &ENDIF
       &IF (DEFINED(LOG7) = 2) &THEN
           assign {&LOG7} = usrw_logfld[7].
       &ENDIF
       &IF (DEFINED(LOG8) = 2) &THEN
           assign {&LOG8} = usrw_logfld[8].
       &ENDIF
       &IF (DEFINED(LOG9) = 2) &THEN
           assign {&LOG9} = usrw_logfld[9].
       &ENDIF
       &IF (DEFINED(LOG10) = 2) &THEN
           assign {&LOG10} = usrw_logfld[10].
       &ENDIF
       &IF (DEFINED(LOG11) = 2) &THEN
           assign {&LOG11} = usrw_logfld[11].
       &ENDIF
       &IF (DEFINED(LOG12) = 2) &THEN
           assign {&LOG12} = usrw_logfld[12].
       &ENDIF
       &IF (DEFINED(LOG13) = 2) &THEN
           assign {&LOG13} = usrw_logfld[13].
       &ENDIF
       &IF (DEFINED(LOG14) = 2) &THEN
           assign {&LOG14} = usrw_logfld[14].
       &ENDIF
       &IF (DEFINED(LOG15) = 2) &THEN
           assign {&LOG15} = usrw_logfld[15].
       &ENDIF
       &IF (DEFINED(DATE1) = 2) &THEN
           assign {&DATE1} = usrw_datefld[1].
       &ENDIF
       &IF (DEFINED(DATE2) = 2) &THEN
           assign {&DATE2} = usrw_datefld[2].
       &ENDIF
       &IF (DEFINED(DATE3) = 2) &THEN
           assign {&DATE3} = usrw_datefld[3].
       &ENDIF
       &IF (DEFINED(DATE4) = 2) &THEN
           assign {&DATE4} = usrw_datefld[4].
       &ENDIF
       &IF (DEFINED(USER1) = 2) &THEN
           assign {&USER1} = usrw_user1.
       &ENDIF
       &IF (DEFINED(USER2) = 2) &THEN
           assign {&USER2} = usrw_user2.
       &ENDIF
       &IF (DEFINED(C01) = 2) &THEN
           assign {&C01} = usrw__qadc01.
       &ENDIF
    end.
&ENDIF   /*&IF (DEFINED(KEY1) = 2) and (DEFINED(KEY2) = 2) &THEN*/
