@echo off

REM Start ngrok (assuming ngrok executable is in PATH)
ngrok http 3000

REM Wait for ngrok to start (adjust timeout as needed)
timeout /t 5

REM Fetch new ngrok URL
setlocal enabledelayedexpansion
for /f "tokens=3" %%i in ('curl -s http://localhost:4040/api/tunnels ^| jq -r ".tunnels[0].public_url"') do set NEW_NGROK_URL=%%i

REM Update environment variable or config file with new URL
set "REDIRECT_URL=%NEW_NGROK_URL%"
echo REDIRECT_URL=!REDIRECT_URL! > .env

REM Commit changes to Git (optional)
git add .env
git commit -m "Update ngrok URL"
git push -u origin main  

REM Restart your application or trigger deployment (if needed)

echo Updated ngrok URL: %NEW_NGROK_URL%
