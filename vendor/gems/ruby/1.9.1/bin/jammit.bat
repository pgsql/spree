@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"ruby.exe" "D:/development/projects/rubyonrails/aithsham/StyxRyvrRebuild/vendor/gems/ruby/1.9.1/bin/jammit" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"ruby.exe" "%~dpn0" %*
