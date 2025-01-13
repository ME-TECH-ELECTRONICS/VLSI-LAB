@echo off
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

if not exist "%temp_dir%" mkdir "%temp_dir%"
cd /d "%temp_dir%"



:: Download and install Make
echo %make_url%
call :download %make_url% %temp_dir%\%make_installer%
echo Installing Make...
start /wait "%make_url%" "%temp_dir%\%make_installer%" /silent || (
    echo Error: Make installation failed.
    pause
    exit /b 1
)

:: Add Make to PATH
if exist "%make_install_dir%" (
    echo Adding Make to PATH...
    setx PATH "%make_install_dir%;%PATH%"
) else (
    echo Warning: Make installation directory not found.
)

:: Download and install Git Bash
call :download "%gitbash_url%" "%temp_dir%\%gitbash_installer%"
echo Installing Git Bash...
start /wait "" "%temp_dir%\%gitbash_installer%" /SILENT || (
    echo Error: Git Bash installation failed.
    pause
    exit /b 1
)

:: Add Git Bash to PATH
if exist "%gitbash_install_dir%" (
    echo Adding Git Bash to PATH...
    setx PATH "%gitbash_install_dir%;%PATH%" /M
) else (
    echo Warning: Git Bash installation directory not found.
)

:: Add Icarus Verilog to PATH
if exist "%icarus_install_dir%" (
    echo Adding Icarus Verilog to PATH...
    setx PATH "%icarus_install_dir%;%PATH%" /M
) else (
    echo Warning: Icarus Verilog installation directory not found.
)

:: Add GTKWave to PATH
if exist "%gtkwave_install_dir%" (
    echo Adding GTKWave to PATH...
    setx PATH "%gtkwave_install_dir%;%PATH%" /M
) else (
    echo Warning: GTKWave installation directory not found.
)

:: Cleanup
echo Cleaning up temporary files...
rd /s /q "%temp_dir%"

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed. Please install Python first.
    pause
    exit /b 1
) else (
    echo Python is installed. Version:
    python --version
)

:: Install cocotb and cocotb-bus using pip
echo Installing cocotb...
pip install cocotb || (
    echo Error: Failed to install cocotb.
    pause
    exit /b 1
)

echo Installing cocotb-bus...
pip install cocotb-bus || (
    echo Error: Failed to install cocotb-bus.
    pause
    exit /b 1
)
cls
echo Installation complete. Vist https://github.com/ME-TECH-ELECTRONICS/VLSI-LAB/tree/main/Python/cocotb/Counter for cocotb example
pause
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