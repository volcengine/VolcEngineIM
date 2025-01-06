/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Key of the builderMap of the routing table in the RouterModule. The format is as follows:{bundleName}_${pageName}.
export class IMPage {
  static readonly IN_MAIN: string = '@imcloud/imapp_in:main_page';
  static readonly IN_LOGIN: string = '@imcloud/imapp_in:login_page';
  static readonly IM_PREVIEW_VIDEO_PAGE: string = '@imcloud/imapp_in:preview_video_page'
  static readonly IM_PREVIEW_IMAGE_PAGE: string = '@imcloud/imapp_in:preview_image_page'
  static readonly IM_MEMBER_CREATE_SINGLE: string = '@imcloud/imapp_member:create_single_page'
  static readonly IM_MEMBER_CREATE_GROUP: string = '@imcloud/imapp_member:create_group_page'
  static readonly IM_MEMBER_CREATE_GROUP_REMOVE: string = '@imcloud/imapp_member:user_add_page'
  static readonly IM_MEMBER_DETAIL_SINGLE: string = '@imcloud/imapp_member:detail_single_page'
  static readonly IM_MEMBER_DETAIL_GROUP: string = '@imcloud/imapp_member:detail_group_page'
  static readonly IM_UI_TEXT_INPUT: string = '@imcloud/imapp_member:text_input'
  static readonly IM_UI_MEMBER_LIST: string = '@imcloud/imapp_member:member_list'
  static readonly IM_MEMBER_INTERNAL_DETAIL_CONVERSATION: string = '@imcloud/imapp_member:internal_detail_conversation_page'
  static readonly IM_MEMBER_MARK_MESSAGE: string = '@imcloud/imapp_member:mark_message_page'
  static readonly IM_MEMBER_SEARCH_TEXT: string = '@imcloud/imapp_member:search_text'

  static readonly IM_UI_MESSAGE_LIST: string = '@imcloud/im_sdk_ui:message_list_page';
  static readonly IM_UI_AT_MEMBER: string = '@imcloud/im_sdk_ui:at_member_page'
  static readonly IN_DEBUG: string = '@imcloud/imapp_in:debug_page';
  //tob
  static readonly TOB_LOGIN: string = '@imcloud/imapp_tob:login_page_tob';
  static readonly TOB_DEBUG: string = '@imcloud/imapp_tob:debug_page_tob';
  static readonly TOB_MAIN: string = '@imcloud/imapp_tob:main_page_tob';
}

// Indicates the key of the routerMap table in the RouterModule.
export class RouterNameConstants {
  static readonly ENTRY_NAME: string = 'imapp';
}