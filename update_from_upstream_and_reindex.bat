@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0.tools\update_from_remote_and_reindex.ps1" -Remote upstream %*
exit /b %errorlevel%
