#!/bin/bash

if [ ! -e "TwitterColorEmoji-SVGinOT.ttf" ]; then
  echo "Prepare TwitterColorEmoji Font"
  DirName="TwitterColorEmoji-SVGinOT-13.1.0"
  curl -LO "https://github.com/eosrei/twemoji-color-font/releases/download/v13.1.0/${DirName}.zip"
  unzip "${DirName}.zip" 2>&1
  for f in $(find ./${DirName}/ -name "*.ttf"); do
    cp "${f}" ./
  done
  rm -rf "${DirName}"
  rm "${DirName}.zip"
fi

OriginalFontFileName="TwitterColorEmoji-SVGinOT.ttf"
OriginalTTXFileName="original.ttx"
ModifiedTTXFileName="modified.ttx"

# TTXファイルを出力
ttx -o "${OriginalTTXFileName}" "${OriginalFontFileName}"

cp "${OriginalTTXFileName}" "${ModifiedTTXFileName}"

Version="0.0.1"

# TTXファイルを編集
xmlstarlet ed --inplace -u "/ttFont/hmtx//mtx[@width = '2048']/@width" -v 2400 "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/hmtx//mtx[@name = 'space']/@width" -v 1200 "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/head/unitsPerEm/@value" -v 2000 "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/hhea/advanceWidthMax/@value" -v 2400 "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/OS_2/xAvgCharWidth/@value" -v 1199 "${ModifiedTTXFileName}"

xmlstarlet ed --inplace -u "/ttFont/name//namerecord[@nameID = 0]" -v "
Copyright 2022 tohgarashi (https://github.com/tohgarashi) CC-BY-4.0
Copyright 2021 Brad Erickson CC-BY-4.0
Copyright 2021 Twitter, Inc. CC-BY-4.0" "${ModifiedTTXFileName}"

xmlstarlet ed --inplace -u "/ttFont/name//namerecord[@nameID = 1]" -v "Twitter Color Emoji for JuGeM" "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/name//namerecord[@nameID = 3]" -v "${Version};Twitter Color Emoji for JuGeM SVGinOT" "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/name//namerecord[@nameID = 4]" -v "Twitter Color Emoji for JuGeM SVGinOT" "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/name//namerecord[@nameID = 5]" -v "Version ${Version}" "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/name//namerecord[@nameID = 6]" -v "TwitterColorEmoji-forJuGeM-SVGinOT" "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/name//namerecord[@nameID = 8]" -v "tohgarashi" "${ModifiedTTXFileName}"
xmlstarlet ed --inplace -u "/ttFont/name//namerecord[@nameID = 10]" -v "A SVGinOT color emoji font resized for the JuGeM font using the Twitter Color Emoji: https://github.com/tohgarashi/twemoji-color-font-forJuGeM" "${ModifiedTTXFileName}"

# 編集したTTXファイルからTTFフォントファイルを出力
ttx -o "TwitterColorEmoji-forJuGeM-SVGinOT.ttf" "${ModifiedTTXFileName}"