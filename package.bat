# Create a zip file of the mod for distribution
tar.exe -a -c -f MMZAccelerationMod_2.0.4.zip MMZAccelerationMod

# Copy the zip file to the Factorio mods directory
copy MMZAccelerationMod_2.0.4.zip "%APPDATA%\Factorio\mods\MMZAccelerationMod_2.0.4.zip"