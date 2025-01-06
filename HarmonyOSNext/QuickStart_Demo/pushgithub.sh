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
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/entry
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/im_sdk_ui
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/imapp
rm -rf ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob_in_same/imapp_member
#
cp -r ./imsdk_harmony/entry ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/
cp -r ./imsdk_harmony/im_sdk_ui ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/
cp -r ./imsdk_harmony/tob/imapp ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob/
cp -r ./imsdk_harmony/tob_in_same/imapp_member ./VolcEngineIM/HarmonyOSNext/QuickStart_Demo/tob_in_same/
#
#echo "3.模块拷贝完成"
#pwd
#sed -i "" "s/APP_ID = 666675/APP_ID = 0/g" ./VolcEngineIM/Android/QuickStart_Demo/tob/imapp/src/main/java/com/bytedance/im/app/constants/Constants.java
#sed -i "" "s/APP_ID_I18N = 889260/APP_ID_I18N = 0/g" ./VolcEngineIM/Android/QuickStart_Demo/tob/imapp/src/main/java/com/bytedance/im/app/constants/Constants.java
#sed -i "" "s/APP_ENV = -1/APP_ENV = Constants.ENV_DEFAULT/g" ./VolcEngineIM/Android/QuickStart_Demo/tob/imapp/src/main/java/com/bytedance/im/app/constants/Constants.java
#
#
#sed -i "" "s/import com.bytedance.im.smslogin.BIMSMSAccountProvider;//g" ./VolcEngineIM/Android/QuickStart_Demo/tob/imapp/src/main/java/com/bytedance/im/app/constants/Constants.java
#sed -i "" "s/BIMSMSAccountProvider/VEDefaultAccountProvider/g" ./VolcEngineIM/Android/QuickStart_Demo/tob/imapp/src/main/java/com/bytedance/im/app/constants/Constants.java
#
echo "4.敏感代码删除完成"
echo "需要手动检查变更并提交"