New-Item -path "$PWD/fontloader-rel" -type directory -force

# x64
$env:GOARCH="amd64"
go build -o $PWD/fontloader-rel/fontloader.exe github.com/dbathgate/windowsfontloader