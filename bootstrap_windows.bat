@echo off
echo Generating Flutter platform files...
flutter create . --platforms=android,ios,web
if errorlevel 1 goto :error
flutter pub get
if errorlevel 1 goto :error
echo.
echo AgeCare is ready. Run: flutter run
pause
exit /b 0
:error
echo.
echo Setup failed. Make sure Flutter is installed and available in PATH.
pause
exit /b 1
