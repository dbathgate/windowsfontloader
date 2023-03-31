FROM mcr.microsoft.com/windows:1809 as full_windows

RUN mkdir C:\Fonts\Files
RUN powershell.exe -command "reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' C:\Fonts\fonts.reg"
RUN powershell.exe -command "reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontMapper\FamilyDefaults' C:\Fonts\font_defaults.reg"
RUN powershell.exe -command "reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink' C:\Fonts\font_link.reg"

RUN powershell.exe -command "Copy-Item C:\Windows\Fonts\* C:\Fonts\Files -Exclude lucon.ttf"

FROM mcr.microsoft.com/windows/servercore:1809

COPY --from=full_windows /Fonts /Fonts
COPY fontloader.exe /fontloader.exe

RUN powershell.exe -command Copy-Item C:\Fonts\Files\* c:\Windows\Fonts \
    && reg import C:\Fonts\fonts.reg \
    && reg import C:\Fonts\font_defaults.reg \
    && reg import C:\Fonts\font_link.reg \
    && powershell.exe -command rm -r -fo C:\Fonts

RUN powershell.exe -command "sc.exe create FontLoader binpath=C:\fontloader.exe start=auto"