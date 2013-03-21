call "%VS100COMNTOOLS%\vsvars32.bat"

set INSTALL_DIR = %2%

cd win32
@call autogen.cmd
cd libsofia-sip-ua-static

if "%1%" == "release" (
    devenv.com libsofia_sip_ua_static.vcxproj /build "Release|Win32" || goto error
	echo F | xcopy /E /Y /I Release\libsofia_sip_ua_static.lib %INSTALL_DIR%\lib\libsofia_sip_ua.lib || goto error
) else (
    devenv.com libsofia_sip_ua_static.vcxproj /build "Debug|Win32" || goto error
	echo F | xcopy /E /Y /I Debug\libsofia_sip_ua_static.lib %INSTALL_DIR%\lib\libsofia_sip_ua.lib || goto error
)

cd ..\..\libsofia-sip-ua
FOR /F %f IN ('dir *.h /b/s') DO xcopy /E /Y /I %f %INSTALL_DIR%\include\sofia-sip\

echo Sofia-SIP build OK
exit /B 0

:error
echo Sofia-SIP build FAILED
exit /B 1