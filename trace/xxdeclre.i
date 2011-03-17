/* xxtrace.i - add tracer hist                                               */
/*V8:ConvertMode=NoConvert                                                   */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11YJ LAST MODIFIED: 01/19/11   BY: zy                           */
/* REVISION END                                                              */

&IF DEFINED(NOSHARED) = 0 &THEN
   define {1} shared variable global_userid as character.
   define {1} shared variable mfguser as character.
&ENDIF