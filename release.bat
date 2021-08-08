call package.bat

mkdir dist
mkdir dist\windows
mkdir dist\windows\libs
mkdir dist\win32
mkdir dist\win32\libs

copy /b dist\windows\love.exe+stackfuse.love dist\windows\stackfuse.exe
copy /b dist\win32\love.exe+stackfuse.love dist\win32\stackfuse.exe

copy libs\discord-rpc.dll dist\windows\libs
copy libs\discord-rpc.dll dist\win32\libs

copy SOURCES.md dist\windows
copy LICENSE.md dist\windows
copy SOURCES.md dist\win32
copy LICENSE.md dist\win32

cd dist\windows
tar -a -c -f ..\stackfuse-windows.zip stackfuse.exe *.dll libs *.md
cd ..\..

cd dist\win32
tar -a -c -f ..\stackfuse-win32.zip stackfuse.exe *.dll libs *.md
cd ..\..