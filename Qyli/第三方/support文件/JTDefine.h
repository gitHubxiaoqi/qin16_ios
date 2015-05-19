//
//  JTDefine.h
//  Qyli
//
//  Created by 小七 on 14-8-22.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

//MJRefreash
#define HeaderRefreshingText "清一丽  正在帮您刷新数据"
#define FooterRefreshingText "清一丽  正在帮您加载数据"
//获取屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//导航高度
#define NAV_HEIGHT 44
#define TAB_HEIGHT 49
// 背景颜色(RGB)
#define BG_COLOR     [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]
// 导航颜色(RGB)
#define NAV_COLOR       [UIColor colorWithRed:241.0/255.0 green:140.0/255.0 blue:157.0/255.0 alpha:1]

#define QYL_URL "http://mobile.qin16.com/"
//#define QYL_URL "http://172.20.10.86:8080/com.qin16.web.mobile/"

//1.1普通用户登录
#define NEW_QYL_People_LoginURL  "MobileLogin/CustomerLoginValidate"
//1.3QQ第三方登录接口
#define NEW_QYL_People_QQLogin  "MobileLogin/QQLogin"
//1.4Sina第三方登录接口
#define NEW_QYL_People_SinaLogin  "MobileLogin/SinaLogin"
//1.5微信第三方登录接口
#define NEW_QYL_People_WeixinLogin  "MobileLogin/WeixinLogin"
//2.1账号注册
#define NEW_QYL_People_Regist_SaveRegisterUserURL  "MobileCustomerUserOperation/SaveRegisterUser"
//2.2发送验证码到手机
#define NEW_QYL_People_Regist_SendPhoneCodeMsgURL  "MobilePhoneCode/SendPhoneCodeMsg"
//2.3手机注册
#define NEW_QYL_People_Regist_SaveRegisterUserPhoneURL  "MobileCustomerUserOperation/SaveRegisterUserPhone"
//3.1获得及时性User
#define NEW_QYL_People_GetUserInfoByIdURL  "MobileCustomerUserOperation/GetUserInfoById"
//3.2修改用户个人信息-------
#define NEW_QYL_People_SaveEditUserURL  "MobileCustomerUserOperation/SaveEditUser"
//3.3修改用户密码
#define NEW_QYL_People_SaveEditPasswordURL  "MobileCustomerUserOperation/SaveEditPassword"
//4.1未绑定手机的用户要绑定手机前验证密码---------自助判断了，没用到
//#define NEW_QYL_People_ValidatePasswordForBindingPhoneURL  "MobileCustomerUserOperation/ValidatePasswordForBindingPhone"
//4.2更改绑定手机时，发送验证码到旧手机----------同2.2
//4.3验证旧手机短信验证码
#define NEW_QYL_People_ValidateCurrentBoundPhoneCodeForBindingPhoneURL  "MobileCustomerUserOperation/ValidateCurrentBoundPhoneCodeForBindingPhone"
//4.4发送短信验证码到新手机----------同2.2
//4.5验证新手机短信验证码并解绑旧手机，绑定新手机
#define NEW_QYL_People_ValidatePhoneCodeAndSaveForBindingPhoneURL  "MobileCustomerUserOperation/ValidatePhoneCodeAndSaveForBindingPhone"
//6.1找回密码-验证手机号是否经过认证
#define NEW_QYL_People_ValidatephoneBindingForgotPassword  "MobileCustomerUserOperation/ValidatephoneBindingForgotPassword"
//6.2找回密码-发送手机验证码到手机----------同2.2
//6.3找回密码-验证手机验证码
#define NEW_QYL_People_ValidatePhoneCodeForgotPassword  "MobileCustomerUserOperation/ValidatePhoneCodeForgotPassword"
//6.4找回密码-重置密码
#define NEW_QYL_People_ChangePasswordForgotPassword  "MobileCustomerUserOperation/ChangePasswordForgotPassword"
//7.1获取评论列表和总评分
#define NEW_QYL_Review_GetReviewListAndReviewSubAvg  "MobileReview/GetReviewListAndReviewSubAvg"
//7.2获取回复列表
#define NEW_QYL_Review_GetBackReview  "MobileReview/GetBackReview"
//7.3验证用户是否参与评分
#define NEW_QYL_Review_ValidUserReview  "MobileReview/ValidUserReview"
//7.4根据mappingId获取打分评论类型列表
#define NEW_QYL_Review_GetReviewTypeMappingId  "MobileReview/GetReviewTypeMappingId"
//7.5保存回复信息
#define NEW_QYL_Review_SaveBackReview  "MobileReview/SaveBackReview"
//7.6评论保存（内容评论+分数评论）
#define NEW_QYL_Review_SaveReviewAndReviewScore  "MobileReview/SaveReviewAndReviewScore"
//7.7会员中心我的评论列表
#define NEW_QYL_Review_MemberCenterReviewList  "MobileReview/MemberCenterReviewList"
//7.8会员中心获取回复评论列表
#define NEW_QYL_Review_GetMemberCenterBackReview  "MobileReview/GetMemberCenterBackReview"
//7.9会员中心修改提供数据
#define NEW_QYL_Review_GetInfoMemberCenterReviewEdit  "MobileReview/GetInfoMemberCenterReviewEdit"
//7.10会员中心保存评论修改
#define NEW_QYL_Review_SaveMemberCenterReviewEdit  "MobileReview/SaveMemberCenterReviewEdit"
//7.11会员中心删除评论以及其回复
#define NEW_QYL_Review_DelMemberCenterReview  "MobileReview/DelMemberCenterReview"
//7.12根据shopdId获取店铺所有商品的评论列表
#define NEW_QYL_Review_GetReviewListByShopId  "MobileReview/GetReviewListByShopId"
//7.13根据institutionId获取机构所有课程的评论列表
#define NEW_QYL_Review_GetReviewListByInstitutionId  "MobileReview/GetReviewListByInstitutionId"
//8.1获取当前时间之后的七个有课的日期中的所有课表
#define NEW_QYL_KeCheng_GetCourseScheduleListByCourseId  "CourseSchedule/GetCourseScheduleListByCourseId"
//9.1保存预约表
#define NEW_QYL_KeCheng_SaveApplyAdd  "Apply/SaveApplyAdd"
//10.1获取我的关注列表
#define NEW_QYL_Follow_GetMemberFollowList  "Mobile/Follow/GetMemberFollowList"
//10.2会员中心批量取消关注
#define NEW_QYL_Follow_DeleteMemberFollow "Mobile/Follow/DeleteMemberFollow"
//10.3会员中心取消所有关注
#define NEW_QYL_Follow_DeleteAllFollow "Mobile/Follow/DeleteAllFollow"
//12.1首页搜索接口
#define NEW_QYL_Search_GetSearchSolrPage "SearchSolr/GetSearchSolrPage"
//13.1获取积分明细列表
#define NEW_QYL_Points_GetMemberPointDetailList "Points/GetMemberPointDetailList"
//14.1普通用户签到接口
#define NEW_QYL_MobileCustomerUserOperation_DoSignin "MobileCustomerUserOperation/DoSignin"

//16.1获取可兑换商品列表
#define NEW_QYL_PointsMall_GetPointsgiftList  "PointsMall/GetPointsgiftList"
//16.2获取礼品详情
#define NEW_QYL_PointsMall_GetPointsgiftInfo  "PointsMall/GetPointsgiftInfo"
//16.3获取礼品收货人信息
#define NEW_QYL_PointsMall_GetLastConsigneeAddress  "PointsMall/GetLastConsigneeAddress"
//16.4提交兑换订单
#define NEW_QYL_PointsMall_SavePointsorder  "PointsMall/SavePointsorder"
//16.5获取会员历史订单列表
#define NEW_QYL_PointsMall_GetMemberPointsorderList  "PointsMall/GetMemberPointsorderList"
//16.6会员历史订单详情
#define NEW_QYL_PointsMall_GetPointsorderInfo  "PointsMall/GetPointsorderInfo"
//17.2会员拒收某店铺推送消息
#define NEW_QYL_NoPush_NotReceiveMessage  "Jpush/NotReceiveMessage"
//17.3会员拒收某店铺推送消息
#define NEW_QYL_NoPush_OnlyDayReceiveMessage  "Jpush/OnlyDayReceiveMessage"
//18.1会员设置是否接收推送信息
#define NEW_QYL_Share_UserShareAfter  "MobileCustomerUserOperation/UserShareAfter"
//20.1手机端获取主题类型接口
#define NEW_QYL_Luntan_GetTopicTypeList  "Forum/GetTopicTypeList"
//20.2手机端获取帖子列表接口
#define NEW_QYL_Luntan_GetTopicListByType  "Forum/GetTopicListByType"
//20.3手机端获取帖子评论列表接口
#define NEW_QYL_Luntan_GetPostListByTopicId  "Forum/GetPostListByTopicId"
//20.6手机端评论帖子接口
#define NEW_QYL_Luntan_SavePostAdd  "Forum/SavePostAdd"
//20.5手机端发布帖子接口
#define NEW_QYL_Luntan_SaveTopicAdd  "Forum/SaveTopicAdd"
//21.8手机端顶踩帖子接口
#define NEW_QYL_Luntan_SavePostUpAndDown  "Forum/SavePostUpAndDown"
//21.9手机端个人中心我发布的帖子列表接口
#define NEW_QYL_Luntan_GetUserTopicList  "Forum/GetUserTopicList"
//21.11手机端个人中心删除我发布的帖子接口
#define NEW_QYL_Luntan_DelTopic  "Forum/DelTopic"
//11.2获取最新版本IOS
#define NEW_QYL_GetLastIOSVersion  "VersionUpdate/GetLastIOSVersion"

//洪叶URL
//1.2根据cityName获取当前城市的区和街道信息
#define NEW_QYL_Area_getRegionAndStreetByCityName "commons/getRegionAndStreetByCityName"
//1.3获取所有省市区街道信息
#define NEW_QYL_Area_getAllArea "commons/getAllArea"

//王超 课程URL
//1.1获取课程列表信息
#define NEW_QYL_KeCheng_coursePage "MobileCourse/coursePage"
//1.2获取课程详细信息
#define NEW_QYL_KeCheng_courseInfo "MobileCourse/courseInfo"
//2.1根据机构id获得课程列表
#define NEW_QYL_KeCheng_coursePageByInstitution "MobileCourse/coursePageByInstitution"
//2.2根据机构id获得活动列表
#define NEW_QYL_HuoDong_activityPageByInstitution "MobileActivity/activityPageByInstitution"
//3.1获取活动列表信息
#define NEW_QYL_HuoDong_activityPage "MobileActivity/activityPage"
//3.2获取活动详细信息
#define NEW_QYL_HuoDong_activityInfo "MobileActivity/activityInfo"
//1.5获取知识库列表信息
#define NEW_QYL_KnowLedge_knowledgePage "MobileKnowledge/knowledgePage"
//1.6获取知识库详细信息
#define NEW_QYL_KnowLedge_knowledgeInfo "MobileKnowledge/knowledgeInfo"
//1.7知识库获取评论列表
#define NEW_QYL_KnowLedge_knowledgeSubPage "MobileKnowledge/knowledgeSubPage"
//1.8知识库提交评价
#define NEW_QYL_KnowLedge_subSave "MobileKnowledge/subSave"
//广告轮播列表
#define NEW_QYL_Notice_noticeList "MobileNotice/noticeList"
//广告轮播详细
#define NEW_QYL_Notice_noticeInfo "MobileNotice/noticeInfo"
//用户反馈接口
#define NEW_QYL_People_SaveFeedBack "MobileFeedBack/SaveFeedBack"

//陈功 商家联盟URL
//1.1店铺分页
#define NEW_QYL_DianPu_shopPage "Mobile/Shop/shopPage"
//1.2店铺详细
#define NEW_QYL_DianPu_shop "Mobile/Shop/getShop"
//2.1商品分页
#define NEW_QYL_ShangPin_shopGoodsPage "Mobile/ShopGoods/shopGoodsPage"
//2.2商品详细
#define NEW_QYL_ShangPin_ShopGoods "Mobile/ShopGoods"
//店铺活动列表
#define NEW_QYL_HuoDong_shopActivityPage "Mobile/ShopActivity/shopActivityPage"
//店铺活动详细
#define NEW_QYL_HuoDong_shopActivity "Mobile/ShopActivity/shopActivity"
//店铺活动抢券
#define NEW_QYL_HuoDong_regist "Mobile/ShopActivity/regist"

//个人中心我的卡券包
#define NEW_QYL_People_MyVoucher "Mobile/Voucher/MyVoucher"

//3.1获取小分类列表
#define NEW_QYL_SJLM_getItems "Sys/Dtitem/getItems"
//3.2获取大分类列表
#define NEW_QYL_SJLM_getSorts "Sys/Sort/getSorts"
//4.1机构分页
#define NEW_QYL_JiGou_insPage "Mobile/Ins/insPage"
//4.2机构详细
#define NEW_QYL_JiGou_insInfo "Mobile/Ins"
//5.1添加关注
#define NEW_QYL_FollowURL "Mobile/Follow"
//5.2取消关注
#define NEW_QYL_DeleteFollowURL "Mobile/Follow/Delete"
////商家我的卡券列表
#define NEW_QYL_People_UserVoucherPage "Mobile/Voucher/UserVoucherPage"
//使用卡券
#define NEW_QYL_People_UserVoucher "Mobile/Voucher/UseVoucher"


@interface JTDefine : NSObject

@end
