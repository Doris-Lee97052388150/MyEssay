@echo off
:: 获取当前时间戳，格式为：YYYY-MM-DD HH:mm:ss
for /f "delims=" %%i in ('powershell -Command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"') do set datetime=%%i

git add .
git commit -m "A New Commit! (%datetime%)"
git push origin main