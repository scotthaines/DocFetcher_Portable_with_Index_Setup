explorer.exe /e,%1\repository
rem set abc=%1
rem set abc=%abc:"=%
rem rem start gets an empty title to avoid treating the command as a title.
rem start "" "%abc%\DocFetcher-1.1.18\DocFetcher.exe"

rem start gets an empty title to avoid treating the command as a title.
start "" %1\DocFetcher-1.1.18\DocFetcher.exe
