/* xxexpir.p - expir crontrl                                                 */
/* REVISION: 0BYI LAST MODIFIED: 11/28/10   BY: zy                           */
/* REVISION END                                                              */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */

/*OBYI*/ define variable vdays as integer.
/*OBYI*/ assign vdays = date(6,19,2011) - today.
/*OBYI*/ if vdays < 0 then do:
/*OBYI*/     {pxmsg.i &MSGNUM=2696 &ERRORLEVEL=2}
/*OBYI*/     pause.
/*OBYI*/     RETURN.
/*OBYI*/ end.
/*OBYI*/ if vdays <= 5 then do:
/*OBYI*/      {pxmsg.i &MSGNUM=2697 &MSGARG1=vdays &ERRORLEVEL=2}
/*OBYI*/ end.
