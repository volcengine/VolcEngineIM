# -*- coding: UTF-8 -*-
import re
import os,sys
import subprocess


# 获取commit log
def opensource_get_commit_log(repo_folder_path):
    os.chdir(repo_folder_path)
    subprocess.run('git log -p > ./opensource_git_commit.log', shell=True, stdout=subprocess.PIPE)


# 删除commit log
def opensorce_rm_commit_log(repo_folder_path):
    file = 'opensource_git_commit.log'
    path = os.path.join(repo_folder_path, file)
    os.remove(path)


def should_ignore_keywords(ignore_list_keywords, line):
    for ignore_key in ignore_list_keywords:
        pattern1 = re.compile(ignore_key, flags=re.I)
        if len(pattern1.findall(line)) >0:
            return True
    return False



def check_sensitive_information(keywords_list, ignore_list_keywords, repo_folder_path, cnt, aigc_keywords_group1, aigc_keywords_group2):
    for root,dirs,files in os.walk(repo_folder_path):
        for file in files:
            if file.endswith(('.tgz','.zip','.tar','.rar','.gif','.jpg','.png','.jpeg','.svg','.tiff','.raw','.ico','.webp','.tga')) or (os.path.join(root, file).find('/.git/') > -1):
                continue
            with open(os.path.join(root, file), 'r', encoding='ISO-8859-1') as f:
                for line in f.readlines():
                    cnt += 1
                    if (should_ignore_keywords(ignore_list_keywords, line.strip()) == False):
                        for pattern in keywords_list:
                            result = re.search(pattern, line.strip(), re.I)
                            if pattern == '(tokenizer|transformer|token_id|tokenid|attention_head).{0,20}':
                                if file.endswith(('.json')):
                                    if result != None:
                                        print("\033[1;36mFile \""+ os.path.join(root, file) + ", line, " + str(cnt) + ",\"\033[0m" + " have some sensitive information: " + "\033[1;32m" + str(result.group(0)) + "\033[0m")
                                        with open('./sensitive_info_result.txt', 'a+',  encoding='utf-8') as g:
                                            g.write(os.path.join(root, file) + ", line, " + str(cnt) + " have some sensitive information: " + str(result.group(0) + '\n'))
                                    else:
                                        continue
                            else:
                                if result != None:
                                        print("\033[1;36mFile \""+ os.path.join(root, file) + ", line, " + str(cnt) + ",\"\033[0m" + " have some sensitive information: " + "\033[1;32m" + str(result.group(0)) + "\033[0m")
                                        with open('./sensitive_info_result.txt', 'a+',  encoding='utf-8') as g:
                                            g.write(os.path.join(root, file) + ", line, " + str(cnt) + " have some sensitive information: " + str(result.group(0) + '\n'))
                                else:
                                    continue
            cnt = 0

            with open(os.path.join(root, file), 'r', encoding='ISO-8859-1') as g:
                # print(file)
                if str(file).endswith('.json'):
                    file_content = g.read()
                    # 检查每组关键词是否都在文件内容中
                    if all(keyword in file_content for keyword in aigc_keywords_group1):
                        print("\033[1;36mFile \""+ os.path.join(root, file) + " have some aigc sensitive information: " + "\033[1;32m" + str(aigc_keywords_group1) + "\033[0m")
                        with open('./sensitive_info_result.txt', 'a+',  encoding='utf-8') as g:
                            g.write(os.path.join(root, file) + " have some aigc sensitive information: " + str(aigc_keywords_group1) + '\n')
                    elif all(keyword in file_content for keyword in aigc_keywords_group2):
                        print("\033[1;36mFile \""+ os.path.join(root, file) + " have some aigc sensitive information: " + "\033[1;32m" + str(aigc_keywords_group2) + "\033[0m")
                        with open('./sensitive_info_result.txt', 'a+',  encoding='utf-8') as g:
                            g.write(os.path.join(root, file) + " have some aigc sensitive information: " + str(aigc_keywords_group2) + '\n')
                else:
                    continue

def detection_result():
    if os.path.exists('./sensitive_info_result.txt'):
        pass
    else:
        print('=======Detection passed, no sensitive information found=======')


def main():
    cnt = 0
    repo_folder_path = "/Users/bytedance/workspace/imcloud/Harmony/VolcEngineIM/HarmonyOSNext/QuickStart_Demo" # 不区分操作系统，填写项目路径即可
    opensource_get_commit_log(repo_folder_path)
    keywords_list = [r"npm\s{1,20}install.{1,30}", r"AKLT\w{43,44}", r"AKAP\w{43,44}", r"(tokenizer|transformer|token_id|tokenid|attention_head).{0,20}", r"(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}", r"(LTAI)[a-z0-9]{20}", r"AKTP\w{43,44}",r"([^*<\s|:>]{0,7})(app_id|appid)([^]()!<>;/@&,]{0,10}[(=:]\s{0,6}[\"']{0,1}[0-9]{6,32}[\"']{0,1})", r".{0,15}\.?byted.org.{0,20}",r".{0,15}\.?bytedance.net.{0,20}",r".{0,20}.bytedance\.feishu\.cn.{0,50}",r".{0,20}.bytedance\.larkoffice\.com.{0,50}",r"(10\.\d{1,3}\.\d{1,3}\.\d{1,3})",r"([^*<\s|:>]{0,4})(testak|testsk|ak|sk|key|token|auth|pass|cookie|session|password|app_id|appid|secret_key|access_key|secretkey|accesskey|credential|secret|access)(\s{0,10}[(=:]\s{0,6}[\"']{0,1}(?=[a-zA-Z]*[0-9])(?=[0-9]*[a-zA-Z])[a-zA-Z0-9]{16,32}[\"']{0,1})"]
    aigc_keywords_group1 = ["token", "temp", "role"]
    aigc_keywords_group2 = ["layer", "token", "head"]
    ignore_list_keywords = [r"[^*<>]{0,6}token[^]()!<>;/@&,]{0,10}[=:].{0,1}null,", r".{0,5}user.{0,10}[=:].{ 0,1}null", r".{0,5}pass.{0,10}[=:].{0,1}null", r"passport[=:].", r"[^*<>]{0,6}key[^]()!<>;/]{0,10}[=:].{0,1}string.{0,10}", r".{0,5}user.{0,10}[=:].{0,1}string", r".{0,5}pass.{0,10}[=:].{0,1}string",r".{0,5}app_id[^]()!<>;/@&,]{0,10}[=:].{0,10}\+",r".{0,5}appid[^]()!<>;/@&,]{0,10}[=:].{0,10}\+"]
    check_sensitive_information(keywords_list, ignore_list_keywords, repo_folder_path, cnt, aigc_keywords_group1, aigc_keywords_group2)
    detection_result()
    opensorce_rm_commit_log(repo_folder_path)


if __name__=="__main__":
    main()
