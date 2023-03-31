## Windows Font Loader for Server Core

`windowsfontloader` is designed to load system font files that were removed from the `windows/servercore` Windows Container in version `1809` and higher

### Overview 
* Installs all font files in `C:\Windows\Fonts` that exist in the full `windows` Container
* Installs Fonts Registry keys
* Installs a `fontloader.exe` Windows Service that loads fonts into the System Font Table using [AddFontResourceW](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-addfontresourcew)

### Why
* Solves issues with applications that require System Font files
* Issues commonly arise in applications generating PDF files server side
