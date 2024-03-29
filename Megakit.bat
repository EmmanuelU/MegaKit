::
:: Copyright (C) 2012 The MegaKit by Xmc Wildchild22
:: Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
:: http://www.apache.org/licenses/LICENSE-2.0
:: Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
::
:: View the full GPL at http://www.gnu.org/copyleft/gpl.html
::

@echo off
title Megakit v0.1b by Xmcwildchild22
color F0
set rom=N/A

:bootup
cls
if exist *.vbs del *.vbs
if exist *.txt del *.txt
if exist */*.vbs del */*.vbs
if exist */*.txt del */*.txt
if not exist proprietary/* goto download
cd %~dp0/proprietary
for /f "tokens=*" %%a in ('type ver.txt') do ( set propver="%%a" )
set propver=%propver:"=%
cd ..
echo Checking for updates to the proprietary files...
echo xmcwildchild22>>ftp.txt
echo edude152>>ftp.txt
echo cd public_html/tools/megakit >>ftp.txt
echo get proprietaryver.txt >>ftp.txt 
echo quit >>ftp.txt
ftp -v -s:ftp.txt upload.goo.im >> fetch_log.txt
del ftp.txt
for /f "tokens=*" %%a in ('type proprietaryver.txt') do ( set remotepropver="%%a" )
set remotepropver=%remotepropver:"=%
if %remotepropver% GTR %propver% goto updateprop
del prop*.txt
cls
echo proprietary files are updated to the latest version
ping localhost -n 2 >nul
cls
echo.
cd proprietary
set dumpHC=1.27.34.3104.5456.89
if %dumpHC%==nul (goto Ureallydum4real)
echo.*=============================================================================*
echo *                             Device Connection                               *
echo *-----------------------------------------------------------------------------*
echo *                   Please plug in your phone to charge only                  *
echo *-----------------------------------------------------------------------------*
echo *                    Turn off Fastboot (If on HTC Sense)                      *
echo *-----------------------------------------------------------------------------*
echo *                          Turn on USB Debugging                              *
echo *-----------------------------------------------------------------------------*
echo *                  Make sure ADB is granted root (if on CM9)                  *
echo *-----------------------------------------------------------------------------*
echo *                                                                             *
echo *=============================================================================*
echo.
echo If stuck for more then 30 seconds try unplugging and replugging or rebooting
echo.
echo Awaiting device connection...
adb kill-server >nul
adb start-server >nul
adb wait-for-device
echo --------------
echo Device found, debugging....
for /f "tokens=*" %%a in ('adb shell getprop ro.product.brand') do ( set brand="%%a" )
for /f "tokens=*" %%a in ('adb shell getprop ro.product.model') do ( set model="%%a" )
for /f "tokens=*" %%a in ('adb get-serialno') do ( set serial="%%a" )
for /f "tokens=*" %%a in ('adb shell getprop ro.modversion') do ( set rom="%%a" )
for /f "tokens=*" %%a in ('adb shell getprop ro.product.version') do ( set rom="%%a" )
for /f "tokens=*" %%a in ('adb shell getprop ro.product.device') do ( set device="%%a" )
for /f "tokens=*" %%a in ('adb shell su -c id ^| find /I "uid=0"') do ( set rooted="%%a" )
set brand=%brand:"=%
set model=%model:"=%
set serial=%serial:"=%
set rom=%rom:"=%
set device=%device:"=%
if not defined rooted set rooted="No" ELSE set rooted="Yes"
set rooted=%rooted:"=%
if not defined rom set rom=N/A
if not defined device goto errdevice
echo.
echo DEVICE=%device% >>../"%device%_board_info.txt"
echo MODEL=%model% >>../"%device%_board_info.txt"
echo BRAND=%brand% >>../"%device%_board_info.txt"
echo SERIAL_#=%serial% >>../"%device%_board_info.txt"
echo ROM=%rom% >>../"%device%_board_info.txt"
echo ROOTED=%rooted% >>../"%device%_board_info.txt"
echo.
echo Device info fed to %device%_board_info.txt
echo.
ping localhost -n 3 >nul
goto mainmenu

:download 
cls
if exist ftp.txt del ftp.txt
if exist fetch_log.txt del fetch_log.txt
echo Downloading proprietary files... (-30s)
echo.
echo xmcwildchild22>>ftp.txt
echo edude152>>ftp.txt
echo cd public_html/tools/megakit >>ftp.txt
echo get proprietary.zip >>ftp.txt 
echo get 7z.exe >>ftp.txt 
echo quit >>ftp.txt
ftp -v -s:ftp.txt upload.goo.im >> fetch_log.txt
del ftp.txt
echo.
if not exist proprietary.zip goto errdown
7z x proprietary.zip -oproprietary
del proprietary.zip
move 7z.exe proprietary
attrib proprietary +h
cls
goto bootup

:mainmenu
cls
if not defined rom set rom=N/A
mode con:cols=100 lines=40
for /f "tokens=*" %%a in ('time /t') do ( set launchtime="%%a" )
for /f "tokens=*" %%a in ('date /t') do ( set launchdate="%%a" )
echo.
echo  Main Menu ^|                       Megakit by Xmcwildchild22     %launchdate% - %launchtime%
echo ===================================================================================================
echo                              Oh hai %USERNAME%! I see you have a %model% 
echo ===================================================================================================
echo ^| Rooted is a %rooted% ^| Serial # is %serial% ^| Rom is %rom% ^| Brand is %brand% ^|
echo ===================================================================================================
echo.
echo ^|          Developer Options     ^|          Beginner Options     ^|          Other Options     ^|
echo ---------------------------------------------------------------------------------------------------
set /p menu=
goto mainmenu

:errdown
cls
echo MsgBox "Error fetching proprietary files. Please try again later.",16,"Megakit" >>error.vbs
cscript error.vbs >>nul
exit

:errdevice
cls
echo MsgBox "Error retrieving device information",16,"Megakit" >>error.vbs
cscript error.vbs >>nul
exit

:updateprop
cls
echo Updating to the latest proprietary files... (-30s)
del /S /Q proprietary
echo.
echo xmcwildchild22>>ftp.txt
echo edude152>>ftp.txt
echo cd public_html/tools/megakit >>ftp.txt
echo get proprietary.zip >>ftp.txt 
echo get 7z.exe >>ftp.txt 
echo quit >>ftp.txt
ftp -v -s:ftp.txt upload.goo.im >> fetch_log.txt
del ftp.txt
echo.
if not exist proprietary.zip goto errdown
7z x proprietary.zip -oproprietary
del proprietary.zip
move 7z.exe proprietary
attrib proprietary +h
cls
goto bootup