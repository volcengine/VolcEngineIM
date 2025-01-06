#!/bin/sh
echo "输入切换类型 in:0 tob:1 reset:2"
read type
pwd
resetFile() {
      cp  ./imsdk/build-profile.json5.bk ./imsdk/build-profile.json5
      cp  ./imsdk/oh-package.json5.bk ./imsdk/oh-package.json5
      cp  ./entry/build-profile.json5.bk ./entry/build-profile.json5
      cp  ./entry/oh-package.json5.bk ./entry/oh-package.json5
      echo "恢复文件"
}

if [ $type = 0 ];then
  resetFile
  echo "切换到内部"
  sed -i "" 's/\"@imcloud\/imsdk_log\",//' ./imsdk/build-profile.json5
  sed -i "" "s/\"@imcloud\/imsdk_env\",//" ./imsdk/build-profile.json5
  sed -i "" "s/\"@imcloud\/imsdk_ttnet\",//" ./imsdk/build-profile.json5
  sed -i "" "s/\"@imcloud\/imsdk_ws\",//" ./imsdk/build-profile.json5
  sed -i "" "s/\"@imcloud\/imsdk_uploader\",//" ./imsdk/build-profile.json5

  sed -i "" 's/\"@imcloud\/imsdk_env\": \"file:..\/tob\/imsdk_env\",//' ./imsdk/oh-package.json5
  sed -i "" 's/\"@imcloud\/imsdk_ttnet\": \"file:..\/tob\/imsdk_ttnet\",//' ./imsdk/oh-package.json5
  sed -i "" 's/\"@imcloud\/imsdk_ws\": \"file:..\/tob\/imsdk_ws\",//' ./imsdk/oh-package.json5
  sed -i "" 's/\"@imcloud\/imsdk_uploader\": \"file:..\/tob\/imsdk_uploader\",//' ./imsdk/oh-package.json5
  sed -i "" 's/\"@imcloud\/imsdk_log\": \"file:..\/tob\/imsdk_log\",//' ./imsdk/oh-package.json5

  sed -i "" "s/\"IS_TOB\": true/\"IS_TOB\": false/" ./imsdk/build-profile.json5

  sed -i "" "s/bytedance/douyin/" ./entry/build-profile.json5
  sed -i "" 's/\"@imcloud\/imapp_tob\": \"file:..\/tob\/imapp_tob\",//' ./entry/oh-package.json5
  sed -i "" 's/\"@imcloud\/imapp_tob\",//' ./entry/build-profile.json5

  cp -f ./build-profile-in.json5 ./build-profile.json5

elif [ $type = 1 ];then
  resetFile
  echo "切换到tob"
  sed -i "" 's/\"@imcloud\/imsdk_env_in\",//' ./imsdk/build-profile.json5
  sed -i "" "s/\"@imcloud\/imsdk_ttnet_in\",//" ./imsdk/build-profile.json5
  sed -i "" "s/\"@imcloud\/imsdk_ws_in\",//" ./imsdk/build-profile.json5
  sed -i "" "s/\"@imcloud\/imsdk_uploader_in\",//" ./imsdk/build-profile.json5

  sed -i "" 's/\"@imcloud\/imsdk_env_in\": \"file:..\/in\/imsdk_env_in\",//' ./imsdk/oh-package.json5
  sed -i "" 's/\"@imcloud\/imsdk_ttnet_in\": \"file:..\/in\/imsdk_ttnet_in\",//' ./imsdk/oh-package.json5
  sed -i "" 's/\"@imcloud\/imsdk_ws_in\": \"file:..\/in\/imsdk_ws_in\",//' ./imsdk/oh-package.json5
  sed -i "" 's/\"@imcloud\/imsdk_uploader_in\": \"file:..\/in\/imsdk_uploader_in\",//' ./imsdk/oh-package.json5
  sed -i "" "s/\"IS_TOB\": false/\"IS_TOB\": true/" ./imsdk/build-profile.json5

  sed -i "" "s/douyin/bytedance/" ./entry/build-profile.json5
  sed -i "" 's/\"@imcloud\/imapp_in\": \"file:..\/in\/imapp_in\",//' ./entry/oh-package.json5
  sed -i "" 's/\"@imcloud\/imapp_in\",//' ./entry/build-profile.json5

  cp -f ./build-profile-tob.json5 ./build-profile.json5
else
  echo "恢复原状"
fi


