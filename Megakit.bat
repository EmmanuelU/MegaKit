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

:bootup
if not exist proprietary/* goto download
cd proprietary
set dumpHC=1.27.34.3104.5456.89
if %dumpHC%==nul (goto Ureallydum4real)
echo. ==========================================================
echo *                       PHONE INFO                       *
echo *--------------------------------------------------------*
echo *   Please plug in your phone to charge only             *
echo *--------------------------------------------------------*
echo *   Turn on USB debugging                                * 
echo *--------------------------------------------------------*
echo *   Turn off Fastboot in Settings/applications           *
echo *--------------------------------------------------------*
echo **********************************************************
adb kill-server >nul
adb start-server >nul
adb wait-for-device
echo --------------
echo Device found....
::Rom Detection
for /f "tokens=*" %%a in ('adb shell getprop ro.product.version') do ( set rom="%%a" )
::Device Detection
for /f "tokens=*" %%a in ('adb shell getprop ro.product.device') do ( set device="%%a" )
::Root Detection
for /f "tokens=1 delims=, " %%a in ('adb shell id') do ( set root="%%a" )
if /i %root% == "uid=0(root)" (set root=Yes) ELSE (set root=No)

:download 
cls
echo Proprietary files not found, downloading...
echo.
curl --retry-delay 10 --retry 2 --keepalive-time 10 -o proprietary/ http://goo.im/devs/xmcwildchild22/tools/proprietary.zip
echo done - Press any key to continue
pause >nul
goto bootup