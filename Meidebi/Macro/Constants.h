//
//  Constants.h
//  mdb
//
//  Created by 杜非 on 14/11/28.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//


typedef void(^completeCallback)(NSError *error, BOOL state, NSString *describle);


typedef NS_ENUM(NSInteger,RegCodeType) {
    RegCodeTypeNomal,
    RegCodeTypeRetrieve,
    RegCodeTypeBinding,
    RegCodeTypeLogin = 5
};

///http://192.168.1.117/index.php/
//#define URL_HR @"http://api.mdb6.com/new.php/"///108 102  api.mdb5.com
#define URL_HR @"http://192.168.1.218/index.php/"///108 102  api.mdb5.com
//#define URL_HR @"http://192.168.1.142/"///108 102  api.mdb5.com
//#define URL_HR @"http://api.mdb5.com/index.php/"///108 102
//#define URL_HR @"http://api.mdb6.com/"///108 102
//#define URL_HR @"http://114.55.101.95:80/new.php/"
//#define URL_HR @"https://a.meidebi.com/new.php/"

//单个链接接口（包含单品，优惠活动，优惠卷活动）
#define URL_onlink [NSString stringWithFormat:@"%@Share-onelink",URL_HR]
//必须参数  id（链接id）

//热门列表：
#define URL_allhotlist [NSString stringWithFormat:@"%@Share-allhotlist",URL_HR]
//可选参数：p（页数，不设置为第一页）
//可选参数：pagecount（每页的条数）
//可选参数：cats （分类id如：1，2，3，4）
//可选参数：type （频道id：guo，tian，hai）`

//登录
#define URL_login [NSString stringWithFormat:@"%@Customer-login.html",URL_HR]

//上传头像
#define Customer_avatar [NSString stringWithFormat:@"%@Customer-avatar.html",URL_HR]

#define URL_setjpushaddress [NSString stringWithFormat:@"%@Pushconfig-setjpushaddress",URL_HR]
//热门单品列表：
#define URL_dphotlist [NSString stringWithFormat:@"%@Share-dphotlist",URL_HR]

//全部列表：
#define URL_alllist   [NSString stringWithFormat:@"%@Share-alllist",URL_HR]
//

//晒单列表
#define URL_showdanlist [NSString stringWithFormat:@"%@v2-unboxing-index",URL_HR]

//原创关键词搜索
#define URL_showdanSearchlist [NSString stringWithFormat:@"%@V2-Unboxing-originalSearch",URL_HR]


//券交易列表
#define URL_quanlist  [NSString stringWithFormat:@"%@Share-quanlist",URL_HR]//参数:
//单个券（详情）
#define URL_onecoupon [NSString stringWithFormat:@"%@Share-onecoupon",URL_HR]

//搜索接口
//#define URL_search_h [NSString stringWithFormat:@"%@Share-search",URL_HR]
#define URL_search_h [NSString stringWithFormat:@"%@v2-search-s",URL_HR]
#define URL_search_h1 [NSString stringWithFormat:@"%@v2-search-s",URL_HR]
//上传
#define URL_uploadtoken [NSString stringWithFormat:@"%@Customer-uploadtoken",URL_HR]
///上传视频
#define URL_movieuploadtoken [NSString stringWithFormat:@"%@v2-Qiniu-getvideotoken",URL_HR]

//评论列表（新）
#define URL_comlist [NSString stringWithFormat:@"%@Discuss-clist.html",URL_HR]

//评论接口（新）
#define URL_commindex [NSString stringWithFormat:@"%@Discuss-com.html",URL_HR]
//赞评论
#define URL_commentvote [NSString stringWithFormat:@"%@Customer-commentvote.html",URL_HR]

//我的爆料
#define URL_mylink  [NSString stringWithFormat:@"%@Customer-mylink.html",URL_HR]

//我的晒单
#define URL_myshoppingexp [NSString stringWithFormat:@"%@Customer-myshoppingexp",URL_HR]

///草稿
#define URL_myshoppingexpcg [NSString stringWithFormat:@"%@V2-Unboxing-draftList",URL_HR]

//用户中心
#define URL_usercenter [NSString stringWithFormat:@"%@Customer-usercenter",URL_HR]
//我的消息
//#define URL_mymessage [NSString stringWithFormat:@"%@Customer-mymessage",URL_HR]
#define URL_mymessage [NSString stringWithFormat:@"%@Customer-sysMsg",URL_HR]
#define URL_myOrdermessage [NSString stringWithFormat:@"%@Customer-orderMsg",URL_HR]
//我的优惠券
#define URL_mycoupon [NSString stringWithFormat:@"%@Customer-mycoupon",URL_HR]
//读信息
#define URL_readmessage [NSString stringWithFormat:@"%@Customer-readmessage",URL_HR]

//获取商城
#define URL_getmall [NSString stringWithFormat:@"%@Customer-getmall",URL_HR]

//海淘直邮
#define URL_haitaodirect [NSString stringWithFormat:@"%@Share-haitaodirect",URL_HR]

//白菜价
#define URL_baicaidirect [NSString stringWithFormat:@"%@Share-baicai",URL_HR]

//优惠券直播
#define URL_tmallcoupon [NSString stringWithFormat:@"%@Share-tmallcoupon",URL_HR]

// 我的评论
//#define URL_customercomment [NSString stringWithFormat:@"%@Customer-comment",URL_HR]///.html
//#define URL_customercomment [NSString stringWithFormat:@"%@Home-Customer-newComment",URL_HR]///.html
#define URL_customercomment [NSString stringWithFormat:@"%@Home-Customer-commentv2",URL_HR]///.html

//@isbroad  0:国内 1:国外 (选填)
//@firstp   拼音大写首字母(选填)
// 获取热门商城
#define URL_Share_getmall [NSString stringWithFormat:@"%@Share-getmall",URL_HR]

//取得小分类地址：
#define URL_getcatgorys [NSString stringWithFormat:@"%@Share-getcatgorys",URL_HR]
//参数is main，is main＝1时返回主分类，否则返回所有分类

//优惠卷活动列表：
#define URL_volist    [NSString stringWithFormat:@"%@Share-volist",URL_HR]
//热门活动列表：没用
#define URL_achotlist [NSString stringWithFormat:@"%@Share-achotlist",URL_HR]
//活动列表：
#define URL_aclist    [NSString stringWithFormat:@"%@Share-aclist",URL_HR]
//热门优惠卷活动列表：
#define URL_vohotlist [NSString stringWithFormat:@"%@Share-vohotlist",URL_HR]
//单品列表：
#define URL_dplist    [NSString stringWithFormat:@"%@Share-dplist",URL_HR]
//广告:
#define URL_showactive   [NSString stringWithFormat:@"%@V2-Slide-index.html",URL_HR]
//晒单，保存或者修改
#define URL_savese [NSString stringWithFormat:@"%@Customer-savese",URL_HR]


//忘记密码
#define URL_findpass [NSString stringWithFormat:@"%@Customer-findpass.html",URL_HR]
//注册
#define URL_reg [NSString stringWithFormat:@"%@Customer-reg.html",URL_HR]


//友盟推送设置接口
#define URL_umengconfig  [NSString stringWithFormat:@"%@Pushconfig-setconfig.html",URL_HR]

//友盟推送设置接口（新）
#define URL_setumengconfig [NSString stringWithFormat:@"%@Pushconfig-setumeng",URL_HR]



//获取要给该设备的所有标签(新)
#define URL_getdevicetags [NSString stringWithFormat:@"%@Pushconfig-getdevicetags",URL_HR]

//友盟推送获取设置接口
#define URL_getumengconfig  [NSString stringWithFormat:@"%@Pushconfig-newgetconfig",URL_HR]



// 参数：userkey， devicetoken， devicetype
#define URL_GetPushconfigRecSubscribe  [NSString stringWithFormat:@"%@Pushconfig-recSubscribe",URL_HR]


//友盟获取地理位置
#define URL_setumengaddress [NSString stringWithFormat:@"%@Pushconfig-setaddress.html",URL_HR]

//新版推送接口
#define URL_newsetconfig [NSString stringWithFormat:@"%@Pushconfig-newsetconfig",URL_HR]

//发送手机验证码
//#define URL_sendverify [NSString stringWithFormat:@"%@Customer-sendverify",URL_HR]
#define URL_sendverify [NSString stringWithFormat:@"%@V2-Customer-sendverify",URL_HR]


//验证码是否正确
//#define URL_doverify [NSString stringWithFormat:@"%@Customer-doverify",URL_HR]
#define URL_doverify [NSString stringWithFormat:@"%@V2-Customer-doverify",URL_HR]

//判断用户密码是否存在
#define URL_isPwd [NSString stringWithFormat:@"%@Home-Customer-isPwd",URL_HR]

// 添加空置密码
#define URL_AddPwd [NSString stringWithFormat:@"%@Home-Customer-addPwd",URL_HR]

//手机号注册
#define URL_mobilereg [NSString stringWithFormat:@"%@Customer-mobilereg",URL_HR]
#define URL_mobileregV2 [NSString stringWithFormat:@"%@V2-Customer-mobilereg",URL_HR]

///手机快捷登录
#define URL_mobileFastLogin [NSString stringWithFormat:@"%@V2-Customer-mobilelogin",URL_HR]

//手机号找回密码
//#define URL_mobilefindpass [NSString stringWithFormat:@"%@Customer-mobilefindpass",URL_HR]
#define URL_mobilefindpass [NSString stringWithFormat:@"%@/V2-Customer-mobilefindpass",URL_HR]


//参数：userkey， umengtoken， devicetype, longitude,  latitude

//数据返回说明
//所有接口返回数据以中包含三项：1、data；2、info、返回的消息；3、status:返回状态
//其中返回状态为1表示为正常返回

//单品详细中的额外数据
#define URL_onelink [NSString stringWithFormat:@"%@Share-onelink",URL_HR]
//参数：id，type（1 晒单 2 其他（单品 活动 优惠券））

//点赞
#define URL_prace [NSString stringWithFormat:@"%@Discuss-dovote.html",URL_HR]
//收藏
#define URL_favorite [NSString stringWithFormat:@"%@Customer-favorite.html",URL_HR]

//分享链接数据来源
#define URL_getshare [NSString stringWithFormat:@"%@Share-getshare.html",URL_HR]

//购买券
#define URL_dealcoupon  [NSString stringWithFormat:@"%@Customer-dealcoupon.html",URL_HR]

//举报
#define URL_report [NSString stringWithFormat:@"%@Share-guoqi.html",URL_HR]

//参数：userkey，id

//签到post参数：userkey
#define URL_dosign [NSString stringWithFormat:@"%@Customer-dosign.html",URL_HR]

//获取爆料URL的商品信息
#define URL_shareinfo [NSString stringWithFormat:@"%@Share-getshareinfo",URL_HR]

//获取分类
#define URL_getcatetree [NSString stringWithFormat:@"%@Share-getcatetree",URL_HR]

//爆料接口
#define URL_saveshareinfo [NSString stringWithFormat:@"%@Share-saveshareinfo",URL_HR]

//检查新版本
#define URL_getversion [NSString stringWithFormat:@"%@Customer-getversion",URL_HR]

//设置订阅推送的关键词
#define URL_setsubscrib [NSString stringWithFormat:@"%@Pushconfig-setsubscrib",URL_HR]

//得到订阅推送的关键词
#define URL_getsubscrib [NSString stringWithFormat:@"%@Pushconfig-getsubscrib",URL_HR]

///是否需要提示绑定已有账号
#define url_login_IsBangding          [NSString stringWithFormat:@"%@V2-Oauth-isWarnBind",URL_HR]

#define url_login_QQ          [NSString stringWithFormat:@"%@Customer-qqauthlogin.html",URL_HR]
#define url_login_weibo       [NSString stringWithFormat:@"%@Customer-weiboauthlogin.html",URL_HR]
#define url_login_wx          [NSString stringWithFormat:@"%@customer-wechatlogin",URL_HR]
#define url_login_taobao      [NSString stringWithFormat:@"%@Customer-tbauthlogin.html",URL_HR]
#define url_skip_bind         [NSString stringWithFormat:@"%@Customer-aotureg.html",URL_HR]

////第三方账号绑定账号
#define url_loginAndBind         [NSString stringWithFormat:@"%@V2-Oauth-loginAndBind",URL_HR]

////绑定账号
#define url_bangding_QQ          [NSString stringWithFormat:@"%@V2-Oauth-bindQQ",URL_HR]
#define url_bangding_WeiBo          [NSString stringWithFormat:@"%@V2-Oauth-bindWeibo",URL_HR]
#define url_bangding_Weixin          [NSString stringWithFormat:@"%@V2-Oauth-bindWeixin",URL_HR]

///获取当前绑定状态
#define url_bangding_status          [NSString stringWithFormat:@"%@V2-Oauth-status",URL_HR]
////取消绑定
#define url_bangding_unBind          [NSString stringWithFormat:@"%@V2-Oauth-unBind",URL_HR]

// 新版签到
#define URL_dosign_new [NSString stringWithFormat:@"%@Sign-dosign",URL_HR]
// 获取签到信息
#define URL_signInfo [NSString stringWithFormat:@"%@Sign-info",URL_HR]
// 福利分享页面信息
#define URL_welfareShare [NSString stringWithFormat:@"%@Sign-share",URL_HR]
// 福利频道礼物数据
//#define URL_welfarePresent [NSString stringWithFormat:@"%@Sign-present",URL_HR]
#define URL_welfarePresent [NSString stringWithFormat:@"%@Home-Sign-present",URL_HR]


// 礼品兑换
//#define URL_giftExchange [NSString stringWithFormat:@"%@Sign-doexchange",URL_HR]
#define URL_giftExchange [NSString stringWithFormat:@"%@Home-Sign-doexchange",URL_HR]


// 获取用户的收货地址列表
#define URL_userAddresslist [NSString stringWithFormat:@"%@Resources-addresslist",URL_HR]
// 保存用户收货地址
#define URL_saveUserAddress [NSString stringWithFormat:@"%@Resources-addresssave",URL_HR]
// 删除用户收货地址
#define URL_deleteUserAddress [NSString stringWithFormat:@"%@Resources-addressdele",URL_HR]
// 兑换记录接口
#define URL_recordExchange [NSString stringWithFormat:@"%@Sign-exchangelog",URL_HR]
// 分享成功(加铜币)接口
#define URL_shareblock [NSString stringWithFormat:@"%@Sign-sharesuccess",URL_HR]
// 单个礼品接口
#define URL_singlePresent [NSString stringWithFormat:@"%@Share-onepresent",URL_HR]
// 保存收货地址
#define URL_addresssave [NSString stringWithFormat:@"%@Resources-addresssave",URL_HR]
///设置默认收货地址
#define URL_addressnomo [NSString stringWithFormat:@"%@V2-Daigouorder-set_default_addr",URL_HR]
// 获取收货地址
#define URL_addresslist [NSString stringWithFormat:@"%@Resources-addresslist",URL_HR]
// 获取收货地址
#define URL_addresslist1 [NSString stringWithFormat:@"%@V2-Daigouorder-addr_list",URL_HR]
// 删除收货地址
#define URL_addressdele [NSString stringWithFormat:@"%@Resources-addressdele",URL_HR]
// 30天签到，领券
#define URL_sign30n [NSString stringWithFormat:@"%@Sign-sign30n",URL_HR]
// 获取商城分类接口(包含图标、一、二级)
#define URL_warescategory [NSString stringWithFormat:@"%@Resources-category",URL_HR]
#define URL_filter_getmall [NSString stringWithFormat:@"%@Resources-getmall",URL_HR]
// 获取搜索关键字
#define URL_searchkeyword [NSString stringWithFormat:@"%@Share-searchkeyword",URL_HR]

///获取热搜词
#define URL_searchHotkeyword [NSString stringWithFormat:@"%@V2-Search-words",URL_HR]

#define URL_idfa [NSString stringWithFormat:@"%@Resources-unique",URL_HR]


///首页分类名称
#define Home_Items_URL [NSString stringWithFormat:@"%@V2-Main-typename",URL_HR]

////首页精选数据接口
//#define Home_JingXuan_URL [NSString stringWithFormat:@"%@V2-Main-choiceness",URL_HR]
#define Home_JingXuan_URL [NSString stringWithFormat:@"%@V2-Main-choiceness_v2",URL_HR]

///首页其他item列表数据 1:海淘 2:直邮 3:国内 4:猫实惠 5:9.9包邮 7:全网优惠
#define Home_OtherItem_URL [NSString stringWithFormat:@"%@V2-Main-typelist",URL_HR]
////7:全网优惠
#define Home_OtherQWYHItem_URL [NSString stringWithFormat:@"%@V2-Discount-all",URL_HR]
////京选 V2-Share-jdList
#define Home_OtherSharejdItem_URL [NSString stringWithFormat:@"%@V2-Share-jdList",URL_HR]

///开屏广告
#define URL_adurl [NSString stringWithFormat:@"%@Resources-adview",URL_HR]
#define URL_adurl1 [NSString stringWithFormat:@"%@Home-Resources-adview",URL_HR]


#define URL_shareRecord [NSString stringWithFormat:@"%@Customer-unionshare.html",URL_HR]
//推荐活动 评论有奖
#define URL_commentRewards [NSString stringWithFormat:@"%@V2-Subject-activityDetail.html",URL_HR]
//积赞活动参与列表
#define URL_activityList [NSString stringWithFormat:@"%@V2-Subject-activityJoinList.html",URL_HR]
//积攒活动参与详情
#define URL_activityDetail [NSString stringWithFormat:@"%@V2-Subject-activityJoinDetail.html",URL_HR]
//积攒活动参与
#define URL_activityJoinAdd [NSString stringWithFormat:@"%@V2-Subject-activityJoinAdd.html",URL_HR]
// 爆料详情
#define URL_DiscountUrl [NSString stringWithFormat:@"%@V2-Share-detail.html",URL_HR]
//#define URL_DiscountUrl [NSString stringWithFormat:@"%@V2-Share-detail.html",URL_HR]

// 首页
#define URL_HomeUrl [NSString stringWithFormat:@"%@V2-Main-index_v3",URL_HR]
// 专题推荐列表
#define URL_SpecialList [NSString stringWithFormat:@"%@V2-Subject-specials",URL_HR]
// 专题推荐详情
#define URL_SpecialDetail [NSString stringWithFormat:@"%@V2-Subject-specialDetail.html",URL_HR]
// 我的首页
#define URL_User_index [NSString stringWithFormat:@"%@V2-User-index.html",URL_HR]
//签到页面商品信息
#define URL_guessLike [NSString stringWithFormat:@"%@V2-Share-guessLike",URL_HR]
//个人资料-首页
#define URL_User_index [NSString stringWithFormat:@"%@V2-User-index.html",URL_HR]
//个人资料-修改昵称
#define URL_nickName [NSString stringWithFormat:@"%@V2-User-editUserNickname.html",URL_HR]
//个人资料-修改性别
#define URL_sex [NSString stringWithFormat:@"%@V2-User-editUserSex.html",URL_HR]
//个人资料-修改生日
#define URL_birth [NSString stringWithFormat:@"%@V2-User-editBirthDay.html",URL_HR]
//个人资料-我的支付宝
#define URL_alipay [NSString stringWithFormat:@"%@V2-User-userAlipay.html",URL_HR]
// 个人主页
#define URL_PersonalHomePage [NSString stringWithFormat:@"%@V2-Homepage-index.html",URL_HR]
// 个人主页-晒单
#define URL_PersonalShowdans [NSString stringWithFormat:@"%@V2-Homepage-myShowdan.html",URL_HR]
// 个人主页-爆料
#define URL_PersonalBrokes [NSString stringWithFormat:@"%@V2-Homepage-myBrokeTheNews.html",URL_HR]
// 邀请好友
#define URL_Invitation [NSString stringWithFormat:@"%@V2-Invitation-index.html",URL_HR]
// 邀请明细
#define URL_InvitationList [NSString stringWithFormat:@"%@V2-Invitation-invitationList.html",URL_HR]
// 加关注
#define URL_AddFollow [NSString stringWithFormat:@"%@V2-Follow-addFollow.html",URL_HR]
// 取消关注
#define URL_CancelFollow [NSString stringWithFormat:@"%@V2-Follow-delFollow.html",URL_HR]

// 关注爆料商品
#define URL_AddFollow_link [NSString stringWithFormat:@"%@V2-Follow-link",URL_HR]
///关注的爆料商品列表
#define URL_AddFollow_links [NSString stringWithFormat:@"%@V2-Follow-links",URL_HR]

///关注的商城
#define URL_FollowSitesList [NSString stringWithFormat:@"%@v2-follow-sites",URL_HR]
///关注的标签
#define URL_FollowTagsList [NSString stringWithFormat:@"%@v2-follow-tags",URL_HR]

///取消关注标签或商城
#define URL_FollowDelList [NSString stringWithFormat:@"%@v2-Follow-del",URL_HR]
///关注标签或商城
#define URL_FollowAddList [NSString stringWithFormat:@"%@v2-Follow-add",URL_HR]

///按标签搜索爆料商品列表
#define URL_FollowTagList [NSString stringWithFormat:@"%@share-tagList",URL_HR]


// 关注列表
#define URL_FollowList [NSString stringWithFormat:@"%@V2-User-myFollowList.html",URL_HR]
// 粉丝列表
#define URL_FansList [NSString stringWithFormat:@"%@V2-User-myFansList.html",URL_HR]
// 福利-动态
#define URL_WelfareDynamic [NSString stringWithFormat:@"%@V2-Welfare-dynamic.html",URL_HR]
// 福利-悬浮通知和广告
#define URL_WelfareAdvertise [NSString stringWithFormat:@"%@V2-Welfare-advertise.html",URL_HR]
// 福利-攻略
#define URL_WelfareRaiders [NSString stringWithFormat:@"%@V2-Welfare-raiders.html",URL_HR]
// 福利-我领取的福利
#define URL_WelfareMyWelfare [NSString stringWithFormat:@"%@V2-Welfare-myWelfare.html",URL_HR]
// QQ绑定
#define URL_BoundQQ [NSString stringWithFormat:@"%@V2-User-bindingQq.html",URL_HR]
// Sina绑定
#define URL_BoundSina [NSString stringWithFormat:@"%@V2-User-bindingSina.html",URL_HR]
// 绑定列表
#define URL_BoundList [NSString stringWithFormat:@"%@V2-User-bindingList.html",URL_HR]
// 解绑
#define URL_BoundRelieve [NSString stringWithFormat:@"%@V2-User-deleteBinding.html",URL_HR]
// 搜券 - 首页
#define URL_SearchCouponIndex [NSString stringWithFormat:@"%@V2-Search-index.html",URL_HR]

#define URL_SearchCoupon [NSString stringWithFormat:@"%@V2-Search-searchCoupon.html",URL_HR]
// 优惠卷直播
#define URL_CouponTmall [NSString stringWithFormat:@"%@V2-Share-couponTmall.html",URL_HR]
// 热门专题列表
#define URL_MainSpecials [NSString stringWithFormat:@"%@V2-Main-specials",URL_HR]
// 中奖记录
#define URL_LotteryRecord [NSString stringWithFormat:@"%@V2-Lottery-lotterylog",URL_HR]
// 抽奖
#define URL_LotteryDolottery [NSString stringWithFormat:@"%@V2-Lottery-dolottery",URL_HR]
// 中奖名单和今天是否还有免费机会
#define URL_LotteryList [NSString stringWithFormat:@"%@V2-Lottery-lotterylist",URL_HR]
//删除消息
#define URL_DelMessage [NSString stringWithFormat:@"%@V2-User-delMessage",URL_HR]
//打赏接口
#define URL_Reward [NSString stringWithFormat:@"%@V2-Reward-reward",URL_HR]
//打赏详情
#define URL_Rewardlog [NSString stringWithFormat:@"%@V2-Reward-rewardlog",URL_HR]
//想买和买过
#define URL_Buyinfo [NSString stringWithFormat:@"%@V2-Share-buyinfo",URL_HR]
//获取点赞消息
#define URL_Usernotice [NSString stringWithFormat:@"%@V2-User-notice",URL_HR]
//足迹
#define URL_Userfootprint [NSString stringWithFormat:@"%@v2-user-footprint",URL_HR]
//足迹banner
#define URL_Userfootprintinfo [NSString stringWithFormat:@"%@v2-user-footprintinfo",URL_HR]
//原创首页
#define URL_ShowdanIndex [NSString stringWithFormat:@"%@V2-Showdan-index",URL_HR]
//原创详情
//#define URL_ShowdanDetail [NSString stringWithFormat:@"%@V2-Showdan-detail",URL_HR]
#define URL_ShowdanDetail [NSString stringWithFormat:@"%@V2-Showdan-detailv2",URL_HR]
//首页动态
#define URL_Maintrends [NSString stringWithFormat:@"%@V2-Main-trends",URL_HR]
//根据标签查询原创
#define URL_ShowdanByTag [NSString stringWithFormat:@"%@V2-Showdan-showdanByTag",URL_HR]
//获取参与详情分享链接
#define URL_ActivityJoinShare [NSString stringWithFormat:@"%@v2-subject-activityJoinDetailShare",URL_HR]
//砍价活动详情
#define URL_BargainActivityDetail [NSString stringWithFormat:@"%@v2-bargainActivity-index",URL_HR]
//砍价活动商品信息
#define URL_BargainActivityCommodityDetail [NSString stringWithFormat:@"%@v2-bargainActivity-commodity",URL_HR]
//参与砍价活动
#define URL_BargainActivityJoin [NSString stringWithFormat:@"%@v2-bargainActivity-join",URL_HR]
//获取砍价活动分享链接
#define URL_BargainActivityShare [NSString stringWithFormat:@"%@v2-bargainActivity-share",URL_HR]
//帮忙砍价
#define URL_BargainActivityHaggle [NSString stringWithFormat:@"%@v2-bargainActivity-haggle",URL_HR]
//砍价活动排行榜
#define URL_BargainActivityRank [NSString stringWithFormat:@"%@v2-bargainActivity-rank",URL_HR]
//砍价活动参与记录
#define URL_BargainActivityJoinLog [NSString stringWithFormat:@"%@v2-bargainActivity-joinLog",URL_HR]
//砍价活动帮砍记录
#define URL_BargainActivityHelps [NSString stringWithFormat:@"%@v2-bargainActivity-helps",URL_HR]
//签到分享
#define URL_SiginShare [NSString stringWithFormat:@"%@v2-main-share",URL_HR]
//专题分享
#define URL_SpecialShare [NSString stringWithFormat:@"%@v2-subject-specialShare",URL_HR]
//排行榜
#define URL_TrendList [NSString stringWithFormat:@"%@v2-share-rank",URL_HR]
//奉节送礼
#define URL_SendGiftList [NSString stringWithFormat:@"%@v2-share-gift",URL_HR]
//话题
#define URL_TopicList [NSString stringWithFormat:@"%@v2-subject-topic",URL_HR]
//发布晒单
//#define URL_TopicPost [NSString stringWithFormat:@"%@v2-unboxing-increase",URL_HR]
//#define URL_TopicPost [NSString stringWithFormat:@"%@V2-Unboxing-newIncrease",URL_HR]
#define URL_TopicPost [NSString stringWithFormat:@"%@V2-Unboxing-increasev2",URL_HR]
#define URL_TopicPost3 [NSString stringWithFormat:@"%@V2-Unboxing-increasev3",URL_HR]

//晒单分类列表
//#define URL_TopicCategrayList [NSString stringWithFormat:@"%@v2-unboxing-lists",URL_HR]
//#define URL_TopicCategrayList [NSString stringWithFormat:@"%@V2-Unboxing-newLists",URL_HR]
#define URL_TopicCategrayList [NSString stringWithFormat:@"%@V2-Unboxing-listv2",URL_HR]

///保存草稿
#define URL_TopicCategraycaogaoSave [NSString stringWithFormat:@"%@V2-Unboxing-keepDraft",URL_HR]
#define URL_TopicCategraycaogaoSave3 [NSString stringWithFormat:@"%@V2-Unboxing-keepDraftv3",URL_HR]

///获取链接信息
#define URL_LinkGoodsMessage [NSString stringWithFormat:@"%@V2-Unboxing-getlinkinfo",URL_HR]


////获取草稿
#define URL_TopicCategraycaogaoGet [NSString stringWithFormat:@"%@V2-Unboxing-drafrDetail",URL_HR]
#define URL_TopicCategraycaogaoGet3 [NSString stringWithFormat:@"%@V2-Unboxing-drafrDetailv3",URL_HR]

///删除草稿
#define URL_TopicCategraycaogaoRemove [NSString stringWithFormat:@"%@V2-Unboxing-delDraft",URL_HR]

///6.3版本代购模块接口
///代购频道首页接口
#define MainDaiGouHomeUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-channel_index",URL_HR]
///代购频道首页好物推荐接口
#define MainDaiGouHomeListUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-goods",URL_HR]
//////代购频道首页搜索
#define MainDaiGouSearchListUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-search",URL_HR]

//////获取总规格 爬虫接口
#define DaiGouAllGuiGeUrl [NSString stringWithFormat:@"%@V2-Daigougoodsspec-getgoodsspecs",URL_HR]

//////选取规格对应的价格 爬虫接口
#define DaiGouItemGuiGeUrl [NSString stringWithFormat:@"%@V2-Daigougoodsspec-getgoodsonespec",URL_HR]

////代购排行榜
#define DaiGoupaihangbangListUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-they_buy_ranking_list",URL_HR]

///加入购物车
//#define MainDaiGouHomeAddByCarUrl [NSString stringWithFormat:@"%@V2-Daigoucart-addtocart",URL_HR]
#define MainDaiGouHomeAddByCarUrl [NSString stringWithFormat:@"%@V2-Daigoucart-addtocart",URL_HR]

///编辑商品数量 或删除
#define MainDaiGouHomeByCarListItemEditUrl [NSString stringWithFormat:@"%@V2-Daigoucart-changegoodsnum",URL_HR]

///选中|取消选中商品
#define MainDaiGouHomeByCarListItemSelectUrl [NSString stringWithFormat:@"%@V2-Daigoucart-goodschecked",URL_HR]

///购物车列表
#define MainDaiGouHomeByCarListUrl [NSString stringWithFormat:@"%@V2-Daigoucart-cartlist",URL_HR]


////购物车结算
#define MainDaiGouHomeByCarListJieSuanUrl [NSString stringWithFormat:@"%@V2-Daigoucart-checkout",URL_HR]

///购物车规格修改
#define MainDaiGouHomeByCarListChangeItemGuiGeUrl [NSString stringWithFormat:@"%@V2-Daigoucart-changecartgoodsspec",URL_HR]

///代购频道今日拼单接口
#define MainDaiGouPinDanListUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-today_pindan",URL_HR]

///代购频道热门商家接口
#define MainDaiGouHotShopUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-hot_business",URL_HR]

///代购频道按热门商家分类接口
#define MainDaiGouShopGoodsListUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-hot_business_goods",URL_HR]

////爆料详情 参与拼单弹窗信息
#define PinDaiAlterUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-part_pindan_message",URL_HR]

////判断是否能参与拼单 下单页面
//#define DaiGouXiaDanViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-checkorder",URL_HR]
#define DaiGouXiaDanViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-checkorderv2",URL_HR]

///求开团获取同款商品
#define QiuKaiYuanItemsViewUrl [NSString stringWithFormat:@"%@V2-Share-similarGoods",URL_HR]

////爆料举报
#define BaoLiaoJuBaoViewUrl [NSString stringWithFormat:@"%@Share-guoqi",URL_HR]

////求开团
#define BaoLiaodaigouwishViewUrl [NSString stringWithFormat:@"%@V2-Daigou-wish",URL_HR]

////运费计算
#define DaiGouXiaDanExpressViewUrl [NSString stringWithFormat:@"%@V2-Daigou-getpostage",URL_HR]
#define DaiGouXiaDanExpressViewUrl1 [NSString stringWithFormat:@"%@V2-Daigou-getpostagecart",URL_HR]

////获取身份证
#define DaiGouXiaDanUserInfoViewUrl [NSString stringWithFormat:@"%@V2-Daigou-getuseridcard",URL_HR]

///下单(直下和拼单)
#define DaiGouXiaDanGetOrderViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-neworder",URL_HR]
#define DaiGouXiaDanGetOrderViewUrl1 [NSString stringWithFormat:@"%@V2-Daigoucart-neworder",URL_HR]
///我的订单
//#define MyOrderMainViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-my_order",URL_HR]
#define MyOrderMainViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-my_orderv2",URL_HR]

///订单详情(直下和拼单)
//#define MyOrderDetailViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-order_detail",URL_HR]
#define MyOrderDetailViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-order_detailv2",URL_HR]

////分享红包信息
#define MyOrderDetailPopordercouponinfoUrl [NSString stringWithFormat:@"%@V2-Daigoucoupon-makeordercoupon",URL_HR]///V2-Daigoucoupon-makeordercoupon

///查看物流
#define MyOrderLogisticsViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-see_logistics",URL_HR]

///发起支付接口
//#define MyOrderZhiFuViewUrl [NSString stringWithFormat:@"%@V2-Daigoupayment-buildorder",URL_HR]
#define MyOrderZhiFuViewUrl [NSString stringWithFormat:@"%@V2-Daigoupayment-buildorderbatch",URL_HR]


///支付成功本地回调 测试
//#define MyOrderZhiFuCeShiViewUrl [NSString stringWithFormat:@"%@V2-Daigoupayment-alipayreturn",URL_HR]
#define MyOrderZhiFuCeShiViewUrl [NSString stringWithFormat:@"%@V2-Daigoupayment-alipayreturnbatch",URL_HR]

///取消订单
#define MyOrderCancleViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-remove_order",URL_HR]

///取消订单原因列表
#define MyOrderCancleReasonViewUrl [NSString stringWithFormat:@"%@v2-Daigouorder-remove_reason",URL_HR]

///  确认收货
#define MyOrderShouHuoViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-confirm_order",URL_HR]

///  删除订单
#define MyOrderDelViewUrl [NSString stringWithFormat:@"%@v2-Daigouorder-del_order",URL_HR]

///  代购攻略及海淘服务条款
#define MyDaiGouShopRaidersViewUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-shop_raiders",URL_HR]

////购物车商品数量
#define MyGoodsCarNumberUrl [NSString stringWithFormat:@"%@V2-Daigoucart-getcartgoodsnum",URL_HR]


///  退款详情
#define MyRefundOrderViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-refund_detail_v2",URL_HR]

///  订单分享信息
//#define MyOrderShareViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-shareMessage",URL_HR]
#define MyOrderShareViewUrl [NSString stringWithFormat:@"%@V2-Daigouorder-paysuccess",URL_HR]

///支付成功分享红包
#define MyOrderSharePayHongBaoViewUrl [NSString stringWithFormat:@"%@V2-Daigoucoupon-popordercouponinfo",URL_HR]

///注册成功弹窗显示 优惠券信息
#define ResignSuccessnormalcouponinfoViewUrl [NSString stringWithFormat:@"%@V2-Daigoucoupon-normalcouponinfo",URL_HR]

///@好友查询
#define AtUserUrl [NSString stringWithFormat:@"%@Home-Discuss-aboutUser",URL_HR]

///更新内容
#define APP_Upload_alter [NSString stringWithFormat:@"%@Home-Customer-getversion",URL_HR]

///用户奖励金统计
#define My_JiangLiMoney_all [NSString stringWithFormat:@"%@V2-daigoubounty-bountycount",URL_HR]

////我的商品券优惠券列表
#define My_JiangLiYouHuiQuan_all [NSString stringWithFormat:@"%@V2-Daigoucoupon-mycoupons",URL_HR]


///用户月奖励金统计
#define My_JiangLiMoney_mouth [NSString stringWithFormat:@"%@V2-daigoubounty-bountymonth",URL_HR]

///奖励明细
#define My_JiangLiMoney_detail [NSString stringWithFormat:@"%@V2-daigoubounty-bountyrecord",URL_HR]

///奖励规则
#define My_JiangLiRule [NSString stringWithFormat:@"%@V2-Daigoubounty-bountyrule",URL_HR]

///单页文章
#define WenZheng_ALL_rol [NSString stringWithFormat:@"%@V2-Aboutus-article",URL_HR]

///地址
#define mdb_Addresss [NSString stringWithFormat:@"%@V2-User-allAddress",URL_HR]

///全网优惠详情页
#define DiscountDetailUrl [NSString stringWithFormat:@"%@V2-Discount-details",URL_HR]

///代购现货列表
#define DaiGouXianHuoListUrl [NSString stringWithFormat:@"%@V2-Daigouchannel-spot",URL_HR]

///根据配置的商品库 补全搜索关键词
#define SearchfullWordUrl [NSString stringWithFormat:@"%@V2-Search-fullWord",URL_HR]


//降价直播列表
#define URL_JiangJiaZhiBo [NSString stringWithFormat:@"%@V2-Share-reductions",URL_HR]

///账号与安全修改密码
#define URL_AccountModify_Password [NSString stringWithFormat:@"%@V2-user-modify_password",URL_HR]

///账号与安全发送验证码
#define URL_AccountModify_Password_Sms [NSString stringWithFormat:@"%@V2-user-modify_password_sms",URL_HR]

///账号与安全修改手机号第一步
#define URL_AccountAnew_Bind_Mobile_Number [NSString stringWithFormat:@"%@V2-user-anew_bind_mobile_number",URL_HR]
///账号与安全修改手机号发送验证码
#define URL_AccountAnew_Bind_Mobile_Number_Sms [NSString stringWithFormat:@"%@V2-user-anew_bind_mobile_number_sms",URL_HR]

///消息 获取代购订单 晒单时要用到的信息
#define URL_Unboxing_orderShowDanData [NSString stringWithFormat:@"%@V2-Unboxing-orderShowDanData",URL_HR]

///分享购买 获取我的返利和等级信息
#define URL_Popularize_Ambassador [NSString stringWithFormat:@"%@v2-popularize-ambassador",URL_HR]

///帐户余额
#define URL_Popularize_Account_balance [NSString stringWithFormat:@"%@v2-popularize-account_balance",URL_HR]


///订单明细列表
#define URL_Popularize_Order_Detailed [NSString stringWithFormat:@"%@v2-popularize-order_detailed",URL_HR]

///返利明细主页
#define URL_Popularize_Commission_Detailed [NSString stringWithFormat:@"%@v2-popularize-commission_detailed",URL_HR]

///提现记录
#define URL_Popularize_Tixian_Record [NSString stringWithFormat:@"%@v2-popularize-tixian_record",URL_HR]


///提现
#define URL_Popularize_Tixian [NSString stringWithFormat:@"%@v2-popularize-tixian",URL_HR]

///上次提现账号等信息
#define URL_Popularize_Last_Tixian_Success_Info [NSString stringWithFormat:@"%@v2-popularize-last_tixian_success_info",URL_HR]


///余额支付
#define URL_Daigoupayment_Balancepay [NSString stringWithFormat:@"%@v2-daigoupayment-balancepay",URL_HR]

///修改支付密码
#define URL_AccountSecurity_update_pay_password [NSString stringWithFormat:@"%@v2-AccountSecurity-update_pay_password",URL_HR]


///创建支付密码
#define URL_AccountSecurity_create_pay_password [NSString stringWithFormat:@"%@v2-AccountSecurity-create_pay_password",URL_HR]

///提现规则说明
#define URL_Popularize_tixian_rule [NSString stringWithFormat:@"%@v2-popularize-tixian_rule",URL_HR]

