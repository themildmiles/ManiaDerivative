Write-Host "Hello there! This will assume you have installed HaxeFlixel correctly. Proceed with compilation?"
Write-Host "Press [Enter] to continue or [Esc] to cancel..."

# Wait for actual keypress
do {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} while ($key.VirtualKeyCode -ne 13 -and $key.VirtualKeyCode -ne 27)

if ($key.VirtualKeyCode -eq 27) {
    Write-Host "ESC pressed. Exiting..."
    exit
}

Write-Host "Enter pressed. Continuing setup..."

haxelib setup ./.libs
haxelib install flixel
haxelib install hscript
haxelib install lime
haxelib install openfl

lime build windows