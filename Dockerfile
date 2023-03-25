FROM mcr.microsoft.com/windows:1809 as full_windows

RUN powershell.exe -command "reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' C:\fonts.reg"
RUN powershell.exe -command "reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontMapper\FamilyDefaults' C:\font_defaults.reg"
RUN powershell.exe -command "reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink' C:\font_link.reg"

FROM mcr.microsoft.com/windows/servercore:1809

COPY --from=full_windows /Windows/Fonts /Fonts

COPY --from=full_windows /fonts.reg /fonts.reg
COPY --from=full_windows /font_defaults.reg /font_defaults.reg
COPY --from=full_windows /font_link.reg /font_link.reg

COPY fontloader.exe /fontloader.exe

RUN powershell.exe -command "Copy-Item C:\Fonts\* c:\Windows\Fonts -Exclude lucon.ttf"
RUN powershell.exe -command "reg import C:\fonts.reg"
RUN powershell.exe -command "reg import C:\font_defaults.reg"
RUN powershell.exe -command "reg import C:\font_link.reg"

RUN powershell.exe -command "sc.exe create FontLoader binpath=C:\fontloader.exe"