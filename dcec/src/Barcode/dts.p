OUTPUT  TO dts.
PUT 'dtsrun /S (local) /E /N part'.
OUTPUT CLOSE.
    OS-COMMAND SILENT  VALUE('dts').
    OS-DELETE VALUE('dts').
