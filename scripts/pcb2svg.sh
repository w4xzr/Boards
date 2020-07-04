#!/bin/sh

  git config --global user.email "noreply@w4xzr.xyz"  > /dev/null 2>&1
  git config --global user.name "Gerber Generator"  > /dev/null 2>&1
cd ..
git checkout master  > /dev/null 2>&1
    cd scripts

for d in "$@" ; do
TEMP=$(basename "$d" | cut -d. -f1)
mkdir -p ../Images/$TEMP  > /dev/null 2>&1
mkdir -p ../Gerbers/$TEMP  > /dev/null 2>&1

python3 plot_gerbers.py "$d/$TEMP.kicad_pcb" > /dev/null 2>&1

unzip -o ../Gerbers/$TEMP/$TEMP\_gerbers.zip -d ../Gerbers/$TEMP/ > /dev/null 2>&1

if cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-Front.gtl $d/plot/$TEMP-Front.gtl && cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-Back.gbl $d/plot/$TEMP-Back.gbl && cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-B_Mask.gbs $d/plot/$TEMP-B_Mask.gbs && cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-F_Mask.gts $d/plot/$TEMP-F_Mask.gts && cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-B_Paste.gbp $d/plot/$TEMP-B_Paste.gbp && cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-F_Paste.gtp $d/plot/$TEMP-F_Paste.gtp && cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-F_SilkS.gto $d/plot/$TEMP-F_SilkS.gto && cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-B_SilkS.gbo $d/plot/$TEMP-B_SilkS.gbo && cmp -s -i 1024 ../Gerbers/$TEMP/$TEMP-Edge_Cuts.gm1 $d/plot/$TEMP-Edge_Cuts.gm1
then
    :
else
    echo "Difference in $TEMP"
python3 plot_board.py "$d/$TEMP.kicad_pcb"  > /dev/null 2>&1
mv "$d/plot/$TEMP-Front.png" "../Images/$TEMP/Front.png" > /dev/null 2>&1
mv "$d/plot/$TEMP-Back.png" "../Images/$TEMP/Back.png" > /dev/null 2>&1
    mv $d/plot/$TEMP\_gerbers.zip ../Gerbers/$TEMP/ > /dev/null 2>&1

fi
cd ..
  # Current month and year, e.g: Apr 2018
  dateAndMonth=`date`
  # Stage the modified files in dist/output
  git add Gerbers/$TEMP/$TEMP\_gerbers.zip  > /dev/null 2>&1
  # Create a new commit with a custom build message
  # with "[skip ci]" to avoid a build loop
  # and Travis build number for reference
  git commit -m "Updated $TEMP Gerbers: $dateAndMonth (Build $TRAVIS_BUILD_NUMBER)" -m "[skip ci]"  > /dev/null 2>&1
  
  cd scripts

rm $d/plot/*
rm -d $d/plot
done
