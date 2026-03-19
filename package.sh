# Delete existing zip file if it exists
if [ -f MMZAccelerationMod_2.0.3.zip ]; then
    rm MMZAccelerationMod_2.0.3.zip
fi

# Package the mod folder MMZAccelerationMod into a zip file
zip -r MMZAccelerationMod_2.0.3.zip MMZAccelerationMod

#Copy factorio mod to factorio mod folder in linux
mkdir -p ~/.factorio/mods
cp MMZAccelerationMod_2.0.3.zip ~/.factorio/mods/