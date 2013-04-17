@echo on

call "%VS100COMNTOOLS%\vsvars32.bat"

set INITIAL_DIR=%cd%
set INSTALL_DIR=%2%

cd win32
@call autogen.cmd
cd libsofia-sip-ua-static

if "%1%" == "release" (
    devenv.exe libsofia_sip_ua_static_vc10.sln /build "Release|Win32" || goto error
	echo F | xcopy /E /Y /I Release\libsofia_sip_ua_static.lib %INSTALL_DIR%\lib\libsofia_sip_ua.lib || goto error
) else (
    devenv.exe libsofia_sip_ua_static_vc10.sln /build "Debug|Win32" || goto error
	echo F | xcopy /E /Y /I Debug\libsofia_sip_ua_static.lib %INSTALL_DIR%\lib\libsofia_sip_ua.lib || goto error
)
echo F | xcopy /E /Y /I ..\pthreads-win32\pthread.lib %INSTALL_DIR%\lib\pthread.lib || goto error

echo F | xcopy /E /Y /I ..\sofia-sip\su_configure.h %INSTALL_DIR%\include\sofia-sip\su_configure.h 
cd %INITIAL_DIR%\libsofia-sip-ua
FOR /F %%f IN ('dir *.h /b/s') DO echo F | xcopy /E /Y /I %%f %INSTALL_DIR%\include\sofia-sip\

cd %INITIAL_DIR%
echo Sofia-SIP build OK
exit /B 0

:error
cd %INITIAL_DIR%
echo Sofia-SIP build FAILED
exit /B 1