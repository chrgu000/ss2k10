/*  xxhttpput.i
  Socket routines for getting a Web Page.
*/
DEFINE INPUT PARAMETER thpurl AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER thptr AS MEMPTR NO-UNDO.
DEFINE INPUT PARAMETER thdebug AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER thrtptr AS MEMPTR NO-UNDO.
/*
DEFINE VARIABLE  thpurl AS CHARACTER NO-UNDO.
DEFINE VARIABLE  thptr1 AS MEMPTR NO-UNDO.
DEFINE VARIABLE  thptr2 AS MEMPTR NO-UNDO.
DEFINE VARIABLE  thptr3 AS MEMPTR NO-UNDO.
DEFINE VARIABLE  thdebug AS CHARACTER NO-UNDO.
DEFINE VARIABLE  thrtptr AS MEMPTR NO-UNDO.
thdebug = "99.xml.debug".
thpurl = "http://192.168.1.193:8080/testAxis/services/HelloWorldWSDD".
RUN readptrFromFile(INPUT thdebug,OUTPUT thptr1).
*/

DEFINE VARIABLE tmpptr AS MEMPTR NO-UNDO.
DEFINE VARIABLE  vSocket AS HANDLE NO-UNDO.
DEFINE VARIABLE  wloop AS LOGICAL NO-UNDO.
DEFINE VARIABLE  thhost AS CHARACTER NO-UNDO.
DEFINE VARIABLE  thport AS CHARACTER NO-UNDO.
DEFINE VARIABLE  thpath AS CHARACTER NO-UNDO.
DEFINE VARIABLE  thpos AS INTEGER NO-UNDO.

set-size(tmpptr) = 100000 .

if thdebug <> "" then RUN writeptrToFile(INPUT thdebug + ".in" , INPUT thptr).
run UrlParser(input thpurl,output thhost,output thport ,output thpath).
run HTTPPost(input thhost,input thport ,input thpath, input thptr).
if thdebug <> "" then RUN writeptrToFile(INPUT thdebug + ".out" , INPUT thrtptr).


{ xxhttpurl.i }
PROCEDURE HTTPPost:
   DEFINE INPUT PARAMETER phost AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER pport AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER ppath AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER pptr AS MEMPTR NO-UNDO.
   DEFINE VARIABLE ii AS int NO-UNDO.
   DEFINE VARIABLE wstatus AS LOGICAL NO-UNDO.
   DEFINE VARIABLE tthost AS CHARACTER NO-UNDO.
   DEFINE VARIABLE ttport AS CHARACTER NO-UNDO.
   wloop = YES.
   CREATE SOCKET vSocket.
   vSocket:SET-READ-RESPONSE-PROCEDURE ("readHandler", THIS-PROCEDURE).
   tthost = phost.
   ttport = pport.
   wstatus = vSocket:CONNECT("-H " + tthost + " -S " + ttport) NO-ERROR.
   IF wstatus = NO THEN DO:
      MESSAGE "Connection to http server:" tthost "port" ttport "is unavailable" view-as alert-box.
      DELETE OBJECT vSocket.
      RETURN.
   END.
   thpos = 1.
   vSocket:WRITE(pptr, 1, get-size(pptr) - 1 ).
   DO WHILE wloop:
      WAIT-FOR READ-RESPONSE OF vSocket.
   END.
   vSocket:DISCONNECT().
   DELETE OBJECT vSocket.
   set-size(thrtptr) =  thpos .
   ii = 1.
   do  while ii < thpos + 1:
     put-byte(thrtptr,ii) = get-byte(tmpptr,ii).
     ii = ii + 1.
   end.
END PROCEDURE.

PROCEDURE readHandler:
   DEFINE VARIABLE l AS INTEGER NO-UNDO.
   l = vSocket:GET-BYTES-AVAILABLE().
   IF l > 0 THEN DO:
      vSocket:READ(tmpptr, thpos, l, 1).
      thpos = thpos + l.
      wloop = YES.
   END.
   ELSE DO:
      wloop = NO.
   END.
end.

{ xxfileio.i }
