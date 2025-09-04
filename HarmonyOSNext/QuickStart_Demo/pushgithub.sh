#!/bin/sh
WORK_DIR=$(cd $(dirname $0);cd ..; pwd)
OPEN_SOURCE_DIR="$WORK_DIR/VolcEngineIM"
SDK_DIR="$WORK_DIR/imsdk"
echo "工作目录: $WORK_DIR"
echo "imsdk 目录: $SDK_DIR"
echo "开源代码目录: $OPEN_SOURCE_DIR"
cd "$WORK_DIR"
if [ -d "$OPEN_SOURCE_DIR" ];then
    echo "1.项目已经存在，开始拉取"
    cd "$OPEN_SOURCE_DIR"
    git pull --rebase
  else
    echo "1.项目不存在，开始克隆"
    git clone git@github.com:volcengine/VolcEngineIM.git
    #安装提交hook脚本
    cd "$OPEN_SOURCE_DIR"
    mkdir -p ./.git/hooks && cd ./.git/hooks  && curl -L http://tosv.byted.org/obj/bytesiem/opensource_commit_hook_mac/pre-commit -o pre-commit && chmod +x pre-
fi
echo "2.代码准备完成，开始修改"
cd "$WORK_DIR"
echo "当前目录"
pwd
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/entry/src
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/im_sdk_ui/src
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/imapp_router/src
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/imapp_tob/src
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/imapp_live/src
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob_in_same/imapp_member/src

#
cp -r ./imsdk_harmony/entry/src ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/entry/
cp -r ./imsdk_harmony/im_sdk_ui/src ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/im_sdk_ui/
cp -r ./imsdk_harmony/imapp_router/src ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/imapp_router/
cp -r ./imsdk_harmony/tob/imapp_tob/src ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/imapp_tob/
cp -r ./imsdk_harmony/tob/imapp_live/src ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/imapp_live/
cp -r ./imsdk_harmony/tob_in_same/imapp_member/src ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob_in_same/imapp_member/
#
echo "3.模块拷贝完成"
pwd
sed -i "" "s/APP_ID: number = 666675/APP_ID: number = 0/g" ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/imapp_tob/src/main/ets/const/VEIMAppConst.ets
sed -i "" "s/import { BIMSMSAccountProvider } from '@imcloud\/im_sms_login';//g" ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/imapp_tob/src/main/ets/const/VEIMAppConst.ets
sed -i "" "s/BIMSMSAccountProvider/VEDefaultAccountProvider/g" ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/imapp_tob/src/main/ets/const/VEIMAppConst.ets
#
echo "4.敏感代码删除完成"
echo "需要手动检查变更并提交"