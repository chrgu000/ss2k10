/* xxsetvar.i - save variable list to usrw_wkfl                               */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */

/*-----------------------------------------------------------------------------
 *  API:
 *      {xxsetvar.i
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
    {xxsetvar.i &KEY1=global_userid
                &KEY2=Execname
                &KEY3=""KEY3""
                &KEY4=""KEY4""
                &KEY5=""KEY5""
                &KEY6=""KEY6""
                &CHAR1=""TEST----22""
                &DEC1=322.3223
                &LOG1=YES
                &DATE1=3/28/13
                &USER1=""TESTUSER1""
                &C01=""CHARACTER01""}
 *
 *----------------------------------------------------------------------------*/
do transaction:
&IF (DEFINED(KEY1) = 2) and (DEFINED(KEY2) = 2) &THEN
    find first usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
               usrw_key1 = {&KEY1} and usrw_key2 = {&KEY2} no-error.
    if not available usrw_wkfl then do:
       create usrw_wkfl. {xxusrwdom.i}.
       assign usrw_key1 = {&KEY1}
              usrw_key2 = {&KEY2}.
    end.
    &IF (DEFINED(KEY3) = 2) &THEN
        assign usrw_key3 = {&KEY3}.
    &ENDIF
    &IF (DEFINED(KEY4) = 2) &THEN
        assign usrw_key4 = {&KEY4}.
    &ENDIF
    &IF (DEFINED(KEY5) = 2) &THEN
        assign usrw_key5 = {&KEY5}.
    &ENDIF
    &IF (DEFINED(KEY6) = 2) &THEN
        assign usrw_key6 = {&KEY6}.
    &ENDIF
    &IF (DEFINED(CHAR1) = 2) &THEN
        assign usrw_charfld[1] = {&CHAR1}.
    &ENDIF
    &IF (DEFINED(CHAR2) = 2) &THEN
        assign usrw_charfld[2] = {&CHAR2}.
    &ENDIF
    &IF (DEFINED(CHAR3) = 2) &THEN
        assign usrw_charfld[3] = {&CHAR3}.
    &ENDIF
    &IF (DEFINED(CHAR4) = 2) &THEN
        assign usrw_charfld[4] = {&CHAR4}.
    &ENDIF
    &IF (DEFINED(CHAR5) = 2) &THEN
        assign usrw_charfld[5] = {&CHAR5}.
    &ENDIF
    &IF (DEFINED(CHAR6) = 2) &THEN
        assign usrw_charfld[6] = {&CHAR6}.
    &ENDIF
    &IF (DEFINED(CHAR7) = 2) &THEN
        assign usrw_charfld[7] = {&CHAR7}.
    &ENDIF
    &IF (DEFINED(CHAR8) = 2) &THEN
        assign usrw_charfld[8] = {&CHAR8}.
    &ENDIF
    &IF (DEFINED(CHAR9) = 2) &THEN
        assign usrw_charfld[9] = {&CHAR9}.
    &ENDIF
    &IF (DEFINED(CHAR10) = 2) &THEN
        assign usrw_charfld[10] = {&CHAR10}.
    &ENDIF
    &IF (DEFINED(CHAR11) = 2) &THEN
        assign usrw_charfld[11] = {&CHAR11}.
    &ENDIF
    &IF (DEFINED(CHAR12) = 2) &THEN
        assign usrw_charfld[12] = {&CHAR12}.
    &ENDIF
    &IF (DEFINED(CHAR13) = 2) &THEN
        assign usrw_charfld[13] = {&CHAR13}.
    &ENDIF
    &IF (DEFINED(CHAR14) = 2) &THEN
        assign usrw_charfld[14] = {&CHAR14}.
    &ENDIF
    &IF (DEFINED(CHAR15) = 2) &THEN
        assign usrw_charfld[15] = {&CHAR15}.
    &ENDIF
    &IF (DEFINED(DEC1) = 2) &THEN
        assign usrw_decfld[1] = {&DEC1}.
    &ENDIF
    &IF (DEFINED(DEC2) = 2) &THEN
        assign usrw_decfld[2] = {&DEC2}.
    &ENDIF
    &IF (DEFINED(DEC3) = 2) &THEN
        assign usrw_decfld[3] = {&DEC3}.
    &ENDIF
    &IF (DEFINED(DEC4) = 2) &THEN
        assign usrw_decfld[4] = {&DEC4}.
    &ENDIF
    &IF (DEFINED(DEC5) = 2) &THEN
        assign usrw_decfld[5] = {&DEC5}.
    &ENDIF
    &IF (DEFINED(DEC6) = 2) &THEN
        assign usrw_decfld[6] = {&DEC6}.
    &ENDIF
    &IF (DEFINED(DEC7) = 2) &THEN
        assign usrw_decfld[7] = {&DEC7}.
    &ENDIF
    &IF (DEFINED(DEC8) = 2) &THEN
        assign usrw_decfld[8] = {&DEC8}.
    &ENDIF
    &IF (DEFINED(DEC9) = 2) &THEN
        assign usrw_decfld[9] = {&DEC9}.
    &ENDIF
    &IF (DEFINED(DEC10) = 2) &THEN
        assign usrw_decfld[10] = {&DEC10}.
    &ENDIF
    &IF (DEFINED(DEC11) = 2) &THEN
        assign usrw_decfld[11] = {&DEC11}.
    &ENDIF
    &IF (DEFINED(DEC12) = 2) &THEN
        assign usrw_decfld[12] = {&DEC12}.
    &ENDIF
    &IF (DEFINED(DEC13) = 2) &THEN
        assign usrw_decfld[13] = {&DEC13}.
    &ENDIF
    &IF (DEFINED(DEC14) = 2) &THEN
        assign usrw_decfld[14] = {&DEC14}.
    &ENDIF
    &IF (DEFINED(DEC15) = 2) &THEN
        assign usrw_decfld[15] = {&DEC15}.
    &ENDIF
    &IF (DEFINED(INT1) = 2) &THEN
        assign usrw_intfld[1] = {&INT1}.
    &ENDIF
    &IF (DEFINED(INT2) = 2) &THEN
        assign usrw_intfld[2] = {&INT2}.
    &ENDIF
    &IF (DEFINED(INT3) = 2) &THEN
        assign usrw_intfld[3] = {&INT3}.
    &ENDIF
    &IF (DEFINED(INT4) = 2) &THEN
        assign usrw_intfld[4] = {&INT4}.
    &ENDIF
    &IF (DEFINED(INT5) = 2) &THEN
        assign usrw_intfld[5] = {&INT5}.
    &ENDIF
    &IF (DEFINED(INT6) = 2) &THEN
        assign usrw_intfld[6] = {&INT6}.
    &ENDIF
    &IF (DEFINED(INT7) = 2) &THEN
        assign usrw_intfld[7] = {&INT7}.
    &ENDIF
    &IF (DEFINED(INT8) = 2) &THEN
        assign usrw_intfld[8] = {&INT8}.
    &ENDIF
    &IF (DEFINED(INT9) = 2) &THEN
        assign usrw_intfld[9] = {&INT9}.
    &ENDIF
    &IF (DEFINED(INT10) = 2) &THEN
        assign usrw_intfld[10] = {&INT10}.
    &ENDIF
    &IF (DEFINED(INT11) = 2) &THEN
        assign usrw_intfld[11] = {&INT11}.
    &ENDIF
    &IF (DEFINED(INT12) = 2) &THEN
        assign usrw_intfld[12] = {&INT12}.
    &ENDIF
    &IF (DEFINED(INT13) = 2) &THEN
        assign usrw_intfld[13] = {&INT13}.
    &ENDIF
    &IF (DEFINED(INT14) = 2) &THEN
        assign usrw_intfld[14] = {&INT14}.
    &ENDIF
    &IF (DEFINED(INT15) = 2) &THEN
        assign usrw_intfld[15] = {&INT15}.
    &ENDIF
    &IF (DEFINED(LOG1) = 2) &THEN
        assign usrw_logfld[1] = {&LOG1}.
    &ENDIF
    &IF (DEFINED(LOG2) = 2) &THEN
        assign usrw_logfld[2] = {&LOG2}.
    &ENDIF
    &IF (DEFINED(LOG3) = 2) &THEN
        assign usrw_logfld[3] = {&LOG3}.
    &ENDIF
    &IF (DEFINED(LOG4) = 2) &THEN
        assign usrw_logfld[4] = {&LOG4}.
    &ENDIF
    &IF (DEFINED(LOG5) = 2) &THEN
        assign usrw_logfld[5] = {&LOG5}.
    &ENDIF
    &IF (DEFINED(LOG6) = 2) &THEN
        assign usrw_logfld[6] = {&LOG6}.
    &ENDIF
    &IF (DEFINED(LOG7) = 2) &THEN
        assign usrw_logfld[7] = {&LOG7}.
    &ENDIF
    &IF (DEFINED(LOG8) = 2) &THEN
        assign usrw_logfld[8] = {&LOG8}.
    &ENDIF
    &IF (DEFINED(LOG9) = 2) &THEN
        assign usrw_logfld[9] = {&LOG9}.
    &ENDIF
    &IF (DEFINED(LOG10) = 2) &THEN
        assign usrw_logfld[10] = {&LOG10}.
    &ENDIF
    &IF (DEFINED(LOG11) = 2) &THEN
        assign usrw_logfld[11] = {&LOG11}.
    &ENDIF
    &IF (DEFINED(LOG12) = 2) &THEN
        assign usrw_logfld[12] = {&LOG12}.
    &ENDIF
    &IF (DEFINED(LOG13) = 2) &THEN
        assign usrw_logfld[13] = {&LOG13}.
    &ENDIF
    &IF (DEFINED(LOG14) = 2) &THEN
        assign usrw_logfld[14] = {&LOG14}.
    &ENDIF
    &IF (DEFINED(LOG15) = 2) &THEN
        assign usrw_logfld[15] = {&LOG15}.
    &ENDIF
    &IF (DEFINED(DATE1) = 2) &THEN
        assign usrw_datefld[1] = {&DATE1}.
    &ENDIF
    &IF (DEFINED(DATE2) = 2) &THEN
        assign usrw_datefld[2] = {&DATE2}.
    &ENDIF
    &IF (DEFINED(DATE3) = 2) &THEN
        assign usrw_datefld[3] = {&DATE3}.
    &ENDIF
    &IF (DEFINED(DATE4) = 2) &THEN
        assign usrw_datefld[4] = {&DATE4}.
    &ENDIF
    &IF (DEFINED(USER1) = 2) &THEN
        assign usrw_user1 = {&USER1}.
    &ENDIF
    &IF (DEFINED(USER2) = 2) &THEN
        assign usrw_user2 = {&USER2}.
    &ENDIF
    &IF (DEFINED(C01) = 2) &THEN
        assign usrw__qadc01 = {&C01}.
    &ENDIF
    release usrw_wkfl.
&ENDIF   /*&IF (DEFINED(KEY1) = 2) and (DEFINED(KEY2) = 2) &THEN*/
end.
