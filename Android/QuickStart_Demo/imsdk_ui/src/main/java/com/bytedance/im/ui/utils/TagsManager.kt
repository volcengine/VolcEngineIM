package com.bytedance.im.demo.util

import android.content.Context
import com.bytedance.base.util.SPUtil
import com.bytedance.im.core.client.IMClient
import com.bytedance.im.core.client.IMEnum
import com.bytedance.im.core.client.callback.IRequestListener
import com.bytedance.im.core.model.*
import com.bytedance.im.core.client.IMEnum.TagType.TAG_TYPE_BUSINESS
import com.bytedance.im.core.client.IMEnum.TagType.TAG_TYPE_USER_CUSTOM
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

object TagsManager: ITagListener {
    const val DEFAULT_ALL_TAG = -1L;
    private const val SP_TAGS_KEY = "CONV_TAGS"
    private var cacheTags: TagsMetaInfo? = null

    fun init() {
        TagInfoManager.inst().addListener(this)
    }

    fun findTagInfo(tagId: Long, tagType: Long): TagInfo? {
        cacheTags?.let {
            if (tagType == TAG_TYPE_BUSINESS) {
                for (tagInfo in it.tagMetaInfoList) {
                    if (tagId == tagInfo.id) {
                        return tagInfo
                    }
                }
            } else if (tagType == TAG_TYPE_USER_CUSTOM) {
                for (tagInfo in it.userCustomTagMetaInfoList) {
                    if (tagId == tagInfo.id) {
                        return tagInfo
                    }
                }
            }
        }
        return null
    }

    fun getAllTagsFromCache(): TagsMetaInfo? {
        return cacheTags
    }

    fun getAllTags(context: Context, listener: IRequestListener<TagsMetaInfo>?) {
        if (null != cacheTags) {
            listener?.onSuccess(cacheTags)
            return
        } else {
            val jsonStr = SPUtil.getSharedPreferences(SP_TAGS_KEY + IMClient.inst().bridge.uid, context, null)

            cacheTags = try {
                Gson().fromJson<TagsMetaInfo>(jsonStr, object: TypeToken<HashMap<Long, TagInfo>>(){}.type)
            } catch (e: Throwable) {
                null
            }

            if (null != cacheTags) {
                listener?.onSuccess(cacheTags)
                return
            }

            getAllTagsFromNetAndSave(listener, context)
        }
    }

    private fun getAllTagsFromNetAndSave(listener: IRequestListener<TagsMetaInfo>?, context: Context?) {
        getAllTagsFromNet(object: IRequestListener<TagsMetaInfo>{
            override fun onSuccess(result: TagsMetaInfo?) {
                cacheTags = result
                listener?.onSuccess(result)
                context?.let {
                    saveToSp(it)
                }
            }

            override fun onFailure(error: IMError?) {
                cacheTags = null
                listener?.onFailure(error)
            }
        })
    }

    private fun getAllTagsFromNet(listener: IRequestListener<TagsMetaInfo>, filterDeleted: Boolean = true) {
        TagInfoManager.inst().getTagsMetaInfo(listener, filterDeleted);
    }

    private fun saveToSp(context: Context) {
        SPUtil.setSharedPreferences(SP_TAGS_KEY, Gson().toJson(cacheTags), context)
    }

    data class ChangeTagEvent(val tagId: Long, val tagType: Long)

    override fun onUpdate(
        userCustomTagInfo: MutableList<TagInfo>?
    ) {
        this.cacheTags?.let { it ->
            val list = it.userCustomTagMetaInfoList?.toMutableList() ?: mutableListOf()
            userCustomTagInfo?.forEach { tag ->
                val targetTag = list.find { testTag -> testTag.id == tag.id }
                if (tag.status == IMEnum.TagStatus.NORMAL && targetTag == null) {
                    list.add(tag)
                } else if (tag.status == IMEnum.TagStatus.NORMAL) {
                    list.remove(targetTag)
                    list.add(tag)
                } else if (tag.status == IMEnum.TagStatus.DELETE) {
                    list.remove(targetTag)
                }
            }
            it.userCustomTagMetaInfoList = list
        }
    }

    fun logout() {
        cacheTags = null
    }
}