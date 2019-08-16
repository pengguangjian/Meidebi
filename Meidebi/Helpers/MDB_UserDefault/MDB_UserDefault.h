//
//  MDB_UserDefault.h
//  mdb
//
//  Created by 杜非 on 14/12/16.
//  Copyright (c) 2014年 meidebi. All rights reserved.

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageManager.h>
//#import <SDWebImage/UIImageView+WebCache.h>
//#import <SDWebImage/SDWebImageManager.h>

#import <UMAnalytics/MobClick.h>

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_WIFI= 1,
    NETWORK_TYPE_WWAN= 2
}NETWORK_TYPE;

typedef NS_ENUM(NSInteger, attendanceStatus) {
    attendanceStatusNormal,
    attendanceStatusShare,
    attendanceStatusCompletion
};

@class Qqshare;
@interface MDB_UserDefault : NSObject{

}



#pragma mark - user properties

@property (nonatomic, strong, readonly) NSString * usertoken;
@property (nonatomic, strong, readonly) NSString * userID;
@property (nonatomic, strong, readonly) NSString * userName;
@property (nonatomic, strong, readonly) NSString * userphoto;
@property (nonatomic, strong, readonly) NSString * userlevel;
@property (nonatomic, strong, readonly) NSString * usercoper;
@property (nonatomic, strong, readonly) NSString * userjifen;
@property (nonatomic, strong, readonly) NSString * userFans;
@property (nonatomic, strong, readonly) NSString * userFollow;
@property (nonatomic, strong, readonly) NSString * ueserContribution;
@property (nonatomic, strong, readonly) NSString * nickName;
@property (nonatomic, assign, readonly) BOOL       userissign;

////手机号
@property (nonatomic, strong, readonly) NSString * telphone;
///用邮箱注册并确认了邮箱：1
@property (nonatomic, strong, readonly) NSString * emailcomfirm;
///用户余额
@property (nonatomic, strong, readonly) NSString *balance;
///奖励金余额
@property (nonatomic, strong, readonly) NSString *commission_balance;
///未使用商品券余额
@property (nonatomic, strong, readonly) NSString *goods_coupon_balance;
///是否已设置支付密码
@property (nonatomic,assign,readonly)   BOOL is_set_pay_password;

@property (nonatomic,assign,readonly)   BOOL       isOn;
@property (nonatomic,assign,readonly)   BOOL       userIsPhoto;

@end

@interface MDB_UserDefault (Initialization)

+ (instancetype)defaultInstance;

@end
@interface MDB_UserDefault (Login)
//用户信息
- (void)setUserWithDic:(NSDictionary *)dic token:(NSString *)token;
- (void)setUserNil;
+ (BOOL)getIsLogin;
- (void)setisSignyes:(NSString *)isSign coper:(NSString *)coper name:(NSString *)name nickName:(NSString *)nickName coin:(NSString *)coin fans:(NSString *)fans follow:(NSString *)follow contribution:(NSString *)contribution content:(NSString *)contet userPhoto:(NSString *)photoLink userID:(NSString *)userID balance:(NSString *)balance commission_balance:(NSString *)commission_balance goods_coupon_balance:(NSString *)goods_coupon_balance is_set_pay_password:(BOOL)is_set_pay_password;
- (void)setUserPhoto:(NSString *)userPhoto;
- (void)setUserName:(NSString *)userName;
- (BOOL)getisSign;
- (NSString *)getIstimeSign;

+(NSArray *)getActive;
+(void)setActive:(NSArray *)dic;
//是否新消息
+(BOOL)getMessage;
+(void)setMessage:(BOOL)mbool;

+(NSDictionary *)getLocationInfo;
+(void)setLocationInfo:(NSDictionary *)infoDict;

+(BOOL)getComment;
+(void)setComment:(BOOL)mbool;

//友盟推送
+ (void)setUmengDeviceToken:(NSString *)devicetoken;
+(NSString *)getUmengDeviceToken;
+(void)setkkSinnAll:(NSString *)intStr;
+(NSString *)getkSinnAll;

//获取字符串长高
+ (CGSize)getStrWightFont:(UIFont *)font str:(NSString *)str  hight:(float)high;
+ (CGSize)getStrhightFont:(UIFont *)font str:(NSString *)str  wight:(float)wight;

//lb计算文本的宽和高
+(CGSize)countTextSize:(CGSize)size andtextfont:(UIFont *)font andtext:(NSString *)str;

//视图
+(void)softCorner_round_clip:(UIView *)view;
//2g／3g无图
- (BOOL)getPicMode_switch;
- (void)setPicMode_swithc:(BOOL)isOn;

//搜索历史
+(void)setProcducs:(NSString *)product;
+(NSArray *)getProcducs;
+(void)removeAllProducs;

//打赏评论
+(void)setRewardComment:(NSString *)content;
+(NSArray *)getRewardComments;

//分类
+(void)setCats:(NSArray *)cats;
+(NSArray *)getCats;
//是否wifi下才上传晒单图片
+(NSNumber *)getIsPhoto;
+(void)setIsPhoto:(BOOL)bools;

//本地地名
+(NSString *)getloaction;
-(void)setloaction:(NSString *)loction;

//所有推送类别
+(NSArray *)getAllPushCats;
+(void)setAllPushCats:(NSArray *)cats;

//选择的推送类别
+(NSArray *)getPushCats;
+(void)setPushCats:(NSArray *)cats;

//商品来源
+(NSArray *)getPushSources;
+(void)setPushSources:(NSArray *)sources;

//版本号
+(NSString *)getVersionNumber;
+(void)setVersionNumber:(NSString *)number;

+ (NSString *)getCompleteWebsite:(NSString *)urlStr;

//启动次数
+(NSNumber *)getAppLaunchingNumber;
+(void)setAppLaunchingNumber:(NSNumber *)number;

// 勿扰时间开始
+(NSString *)getAaronLiStarDate;
+(void)setAaronLiStarDate:(NSString *)dateStr;

// 勿扰时间结束
+(NSString *)getAaronLiEndDate;
+(void)setAaronLiEndDate:(NSString *)dateStr;

+(BOOL)getIsUserInfoLogin;
+(void)setIsUserInfoLogin:(BOOL)isUserInfo;

+(BOOL)getThirdPartyLoginSuccess;
+(void)setThirdPartyLoginSuccess:(BOOL)statue;

+(BOOL)getUmengfirestStatue;
+(void)setUmengfirestStatue:(BOOL)isFirest;

+(BOOL)getIsShowHandle;
+(void)setIsShowHandle:(BOOL)isShowHandle;

+(BOOL)clickTaskStatue;
+(void)setClickTaskStatue:(BOOL)isClick;

+(BOOL)needPhoneStatue;
+(void)setNeedPhoneStatue:(BOOL)needPhone;

+(NSDate *)freeLottoDate;
+(NSNumber *)lottoNumber;
+(void)setFreeLottoDate:(NSDate *)lottoDate lottoNumber:(NSNumber *)number;

+(NSDate *)finishShareDate;
+(void)setFinishShareDate:(NSDate *)finishDate;

+(NSDate *)finishBaskDate;
+(void)setFinishBaskDate:(NSDate *)finishDate;

+(NSDate *)finishBrokeDate;
+(void)setFinishBrokeDate:(NSDate *)finishDate;

+(NSNumber *)pushBadgeNumber;
+(void)setPushBadgeNumber:(NSNumber *)badge;

+(NSDate *)pushKeywordsDate;
+(void)setPushKeywordsDate:(NSDate *)date;

+(BOOL)pushKeywordsStatue;
+(void)setpushKeywordsStatue:(BOOL)statue;

+ (NSInteger)attendanceLeastDate;
+ (void)setAttendanceLeastDate:(NSInteger)leastDate;

+ (NSDictionary *)lastSelectMenuPaths;
+ (void)setLastSelectMenuPath:(NSDictionary *)lastPaths;

//商品分类
+(NSArray *)filterProductTypes;
+(void)setFilterProductTypes:(NSArray *)types;

+ (NSString *)adInfo;
+ (void)setAdInfo:(NSString *)info;

// 评论
+(NSString *)remarkCache;
+(void)setRemarkCache:(NSString *)remark;
// 评论图片
+(NSArray *)remarkImages;
+(void)setRemarkImages:(NSArray *)images;

+ (BOOL)showAppIndexGuide;
+ (void)setShowAppIndexGuide:(BOOL)show;

+ (BOOL)showAppProductGuide;
+ (void)setShowAppProductGuide:(BOOL)show;

+ (BOOL)showAppPersonalInfoGuide;
+ (void)setShowAppPersonalInfoGuide:(BOOL)show;

+ (BOOL)showAppPersonalInfoFansGuide;
+ (void)setShowAppPersonalInfoFansGuide:(BOOL)show;

+ (NSInteger)hotLastNewID;
+ (void)setHotLastNewID:(NSInteger)ID;

- (UIImage*) getVideoPreViewImage:(NSURL *)path;

////功能引导虚线框
+(UIView *)drawYinDaoLine:(CGRect)rect addview:(UIView *)addview andtitel:(NSString *)title;

////功能引导收藏
+(UIView *)drawCollectYinDaoLine:(CGRect)rect andimage:(UIImage *)imageb addview:(UIView *)addview andtitel:(NSString *)title;

///设置一行显示不同字体 颜色
+(NSMutableAttributedString *)arrstring:(NSString *)str andstart:(int)istart andend:(int)length andfont:(UIFont *)font andcolor:(UIColor *)color;

@end


@interface MDB_UserDefault (IntervalFromData)
//取时间 几天前
+(NSString *)CalDateIntervalFromData:(NSDate *)paramStartDate endDate:(NSDate *)paramEndDate;
+(NSString *)strTimefromData:(NSInteger)times dataFormat:(NSString *)dataFormat;
+(NSString *)strTimefromDatas:(NSDate *)times dataFormat:(NSString *)dataFormat;
+(BOOL)isSameDay:(NSDate *)iTime1 Time2:(NSDate *)iTime2;

///获取当前时间戳
+(NSString *)getNowTimeTimestamp;

//提示
+(void)showNotifyHUDwithtext:(NSString *)notify_str inView:(UIView *)view;

#pragma mark - share
+ (void)doShareSinaWeiboUsingShareSdk:(Qqshare *)_qqshare imge:(UIImage *)images;
@end

@interface MDB_UserDefault(SDwebimage)

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;


-(void)setImageWithImage:(UIImageView *)imageV url:(NSString *)urlStr placeholderImage:(UIImage *)image options:(SDWebImageOptions)option completed:(SDExternalCompletionBlock)completedBlock;


-(void)setViewWithImage:(UIImageView *)imageV url:(NSString *)urlStr;
//options 优先下载\后台下载\这个标志可以渐进式下载,显示的图像是逐步在下载
-(void)setViewWithImage:(UIImageView *)imageV url:(NSString *)urlStr options:(SDWebImageOptions)options;
-(void)setViewWithImage:(UIImageView *)imageV url:(NSString *)urlStr options:(SDWebImageOptions)options  completed:(SDExternalCompletionBlock)completedBlock;
-(void)setViewWithImage:(UIImageView *)imageV url:(NSString *)urlStr image:(UIImage *)placeholder options:(SDWebImageOptions)options  completed:(SDExternalCompletionBlock)completedBlock;

///判断图片是否有缓存
-(BOOL)imagediskImageExistsForURL:(NSString *)strurl;
////从缓存中获取图片
-(UIImage *)getImageExistsForURL:(NSString *)strurl;

-(void)setViewImageWithURL:(NSURL *)imageUrl placeholder:(UIImage *)placeholder UIimageview:(UIImageView *)imageV;
-(void)setImageWithURL:(NSURL *)imageUrl options:(SDWebImageOptions)option;
- (void)setSaveImageToCache:(UIImage *)image forURL:(NSURL *)url;
//判断有无网络，yes有，no没有
+(BOOL)getReachilityState;
//是否wifi环境
-(BOOL)getIswifi;
//缓存大小
- (float)checkTmpSize;
//清空缓存
- (void)clearTmpPics;
-(void)clearTmpPic:(NSString *)key;

@end
@interface MDB_UserDefault(FilePhoto)
//存或者删除标记数据
-(void)isSaveDicBool:(BOOL)bools dic:(NSDictionary *)dic;
//晒单图片临时存储
-(void)saveOrDeletePhotoOnce:(BOOL)bools PhotoData:(NSData *)imageData fileName:(NSString *)fileName;//yes 存， no 删除
//上传图片存储地，存储同时并删除临时存储文件
-(void)updatePhotoSavefileName:(BOOL)bools fileName:(NSString *)fileName;//yes 存，no，删除

- (NSString *)applicationVersion;

@end

@interface MDB_UserDefault (Tools)

+ (BOOL)checkTelNumber:(NSString *) telNumber;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (UIImage*)createImageWithColor:(UIColor*) color;
@end

/*
 一，options所有选项：
 
 //失败后重试
 
 SDWebImageRetryFailed = 1 << 0,
 
 //UI交互期间开始下载，导致延迟下载比如UIScrollView减速。
 
 SDWebImageLowPriority = 1 << 1,
 
 //只进行内存缓存
 
 SDWebImageCacheMemoryOnly = 1 << 2,
 
 //这个标志可以渐进式下载,显示的图像是逐步在下载
 
 SDWebImageProgressiveDownload = 1 << 3,
 
 //刷新缓存
 
 SDWebImageRefreshCached = 1 << 4,
 
 //后台下载
 
 SDWebImageContinueInBackground = 1 << 5,
 
 //NSMutableURLRequest.HTTPShouldHandleCookies = YES;
 
 SDWebImageHandleCookies = 1 << 6,
 
 //允许使用无效的SSL证书
 
 //SDWebImageAllowInvalidSSLCertificates = 1 << 7,
 
 //优先下载
 
 SDWebImageHighPriority = 1 << 8,
 
 //延迟占位符
 
 SDWebImageDelayPlaceholder = 1 << 9,
 
 //改变动画形象
 
 SDWebImageTransformAnimatedImage = 1 << 10,
 
 */



