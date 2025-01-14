:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
    
:: Set URLs and installer names
set "make_url=https://downloads.sourceforge.net/project/gnuwin32/make/3.81/make-3.81.exe"
set "make_installer=make-setup.exe"
set "gitbash_url=https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.1/Git-2.42.0-64-bit.exe"
set "gitbash_installer=gitbash-setup.exe"

:: Set installation and temporary directories
set "temp_dir=%temp%\auto_install"
set "make_install_dir=C:\Program Files (x86)\GnuWin32\bin"
set "gitbash_install_dir=C:\Program Files\Git\bin"
set "icarus_install_dir=C:\iverilog\bin"
set "gtkwave_install_dir=C:\iverilog\gtkwave\bin"
set "folder_path=C:\cocotb"
set "samples_path=C:\cocotb\sample"
if not exist "%temp_dir%" mkdir "%temp_dir%"
cd /d "%temp_dir%"



@REM :: Download and install Make
@REM echo %make_url%
@REM call :download %make_url% %temp_dir%\%make_installer%
@REM echo Installing Make...
@REM start /wait "%make_url%" "%temp_dir%\%make_installer%" /silent || (
@REM     echo Error: Make installation failed.
@REM     pause
@REM     exit /b 1
@REM )

@REM :: Add Make to PATH
@REM if exist "%make_install_dir%" (
@REM     echo Adding Make to PATH...
@REM     setx PATH "%make_install_dir%;%PATH%"
@REM ) else (
@REM     echo Warning: Make installation directory not found.
@REM )

@REM :: Download and install Git Bash
@REM call :download "%gitbash_url%" "%temp_dir%\%gitbash_installer%"
@REM echo Installing Git Bash...
@REM start /wait "" "%temp_dir%\%gitbash_installer%" /SILENT || (
@REM     echo Error: Git Bash installation failed.
@REM     pause
@REM     exit /b 1
@REM )

@REM :: Add Git Bash to PATH
@REM if exist "%gitbash_install_dir%" (
@REM     echo Adding Git Bash to PATH...
@REM     setx PATH "%gitbash_install_dir%;%PATH%" /M
@REM ) else (
@REM     echo Warning: Git Bash installation directory not found.
@REM )

@REM :: Add Icarus Verilog to PATH
@REM if exist "%icarus_install_dir%" (
@REM     echo Adding Icarus Verilog to PATH...
@REM     setx PATH "%icarus_install_dir%;%PATH%" /M
@REM ) else (
@REM     echo Warning: Icarus Verilog installation directory not found.
@REM )

@REM :: Add GTKWave to PATH
@REM if exist "%gtkwave_install_dir%" (
@REM     echo Adding GTKWave to PATH...
@REM     setx PATH "%gtkwave_install_dir%;%PATH%" /M
@REM ) else (
@REM     echo Warning: GTKWave installation directory not found.
@REM )

@REM :: Cleanup
@REM echo Cleaning up temporary files...
@REM rd /s /q "%temp_dir%"

if not exist %folder_path% mkdir %folder_path%
if not exist %samples_path% mkdir %samples_path%
cd %folder_path%

:: make a sh file with below commands
echo #!/bin/bash > C:\cocotb\setup.sh
echo echo "Checking if Python is installed..." >> C:\cocotb\setup.sh
echo py --version >> C:\cocotb\setup.sh
echo if [ $? -ne 0 ]; then >> C:\cocotb\setup.sh
echo    echo "Python is not installed. Please install Python first." >> C:\cocotb\setup.sh
echo    exit 1 >> C:\cocotb\setup.sh
echo else >> C:\cocotb\setup.sh
echo    echo "Python is installed. Version: $(py --version)" >> C:\cocotb\setup.sh
echo fi >> C:\cocotb\setup.sh

echo mkdir -p /c/cocotb >> C:\cocotb\setup.sh
echo cd /c/cocotb >> C:\cocotb\setup.sh

echo if [ ! -d ".venv" ]; then >> C:\cocotb\setup.sh
echo    echo "Creating virtual environment..." >> /cocotb/setup.sh
echo    py -m venv .venv >> /cocotb/setup.sh
echo    echo "Created virtual environment" >> /cocotb/setup.sh
echo else >> C:\cocotb\setup.sh
echo    echo "Virtual environment already exists. Skipping" >> /cocotb/setup.sh
echo fi >> C:\cocotb\setup.sh

echo source .venv/Scripts/activate >> C:\cocotb\setup.sh

echo echo "Installing cocotb..." >> C:\cocotb\setup.sh
echo if ! pip install cocotb-bus; then >> C:\cocotb\setup.sh
echo    echo "Error: Failed to install cocotb-bus." >> C:\cocotb\setup.sh
echo    read -p "Press Enter to exit..." >> C:\cocotb\setup.sh  
echo    exit 1 >> C:\cocotb\setup.sh
echo fi >> C:\cocotb\setup.sh

echo echo "Installing cocotb-bus..." >> C:\cocotb\setup.sh
echo if ! pip install cocotb-bus; then >> C:\cocotb\setup.sh
echo    echo "Error: Failed to install cocotb-bus." >> C:\cocotb\setup.sh
echo    read -p "Press Enter to exit..." >> C:\cocotb\setup.sh  
echo    exit 1 >> C:\cocotb\setup.sh
echo fi >> C:\cocotb\setup.sh
echo git clone "https://github.com/ME-TECH-ELECTRONICS/VLSI-LAB.git" >> C:\cocotb\setup.sh
echo mv "VLSI-LAB/Python/cocotb/Counter/" "./sample" >> C:\cocotb\setup.sh
echo rm -rf "VLSI-LAB" >> C:\cocotb\setup.sh
echo clear >> C:\cocotb\setup.sh
echo echo "Installation complete." >> C:\cocotb\setup.sh
echo rm -f setup.sh >> C:\cocotb\setup.sh
echo read -p "Press Enter to continue..." >> C:\cocotb\setup.sh
echo explorer . >> C:\cocotb\setup.sh 

:: Run the sh file
start "" "C:\Program Files\Git\bin\bash.exe" -c "bash C:/cocotb/setup.sh"


:: End
cls
exit

:: Function to download files
:download
echo Downloading from %~1...
curl -L %~1 -o %~2
if not exist "%2" (
    echo Error: Failed to download %~1
    pause
    exit /b 1
)
goto :eof