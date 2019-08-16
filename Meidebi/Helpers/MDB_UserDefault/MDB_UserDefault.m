//
//  MDB_UserDefault.m
//  mdb
//
//  Created by 杜非 on 14/12/16.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//

#import "MDB_UserDefault.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "BDKNotifyHUD.h"
#import "Reachability.h"
#import "Qqshare.h"
#import "MDB_ShareExstensionUserDefault.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import <AVFoundation/AVAsset.h>

#import <AVFoundation/AVAssetImageGenerator.h>

#import <AVFoundation/AVTime.h>

#import <iOS-WebP/UIImage+WebP.h>

//#import <YYKit.h>

#define HappyRedColor [UIColor colorWithRed:252/255.0f green:51/255.0f blue:5/255.0f alpha:1.0f]

@interface MDB_UserDefault()

@property (nonatomic, strong) NSDictionary * userConfigures;

@end

static BOOL kIsRightInit = NO;

#pragma mark - user properties keys

static NSString * const kUserTokenKey = @"cn.com.meidebi.www.user_token_key";
static NSString * const kUserNameKey = @"cn.com.meidebi.www.user_name_key";
static NSString * const kUserNickNameKey = @"cn.com.meidebi.www.user_nickname_key";
static NSString * const kUserPhotoUrlKey = @"cn.com.meidebi.www.user_photourl_key";
static NSString * const kUserLevelKey=  @"cn.com.meidebi.www.user_level_key";
static NSString * const kUserCoperKey=  @"cn.com.meidebi.www.user_coper_key";
static NSString * const kUserUserIDKey=  @"cn.com.meidebi.www.user_userid_key";
static NSString * const kUserJifenKey=  @"cn.com.meidebi.www.user_jifen_key";
static NSString * const kUserIssignKey=  @"cn.com.meidebi.www.user_issign_key";
static NSString * const kUserFansKey=  @"cn.com.meidebi.www.user_fans_key";
static NSString * const kUserFollowNumKey=  @"cn.com.meidebi.www.user_followNum_key";
static NSString * const kUserContributionKey=  @"cn.com.meidebi.www.user_contribution_key";

static NSString * const kUserTelphoneKey=  @"cn.com.meidebi.www.user_telphone_key";
static NSString * const kUserEmailcomfirmKey=  @"cn.com.meidebi.www.user_emailcomfirm_key";

static NSString * const kVisitorTokenValue =  @"BE1B8FF150DE3E78";
static NSString * const kProcdcsKey=@"cn.com.meidebi.www.Procdcs_key";
static NSString * const kCatsKey=@"cn.com.meidebi.www.Cats_key";
static NSString * const kRewardCommenKey=@"cn.com.meidebi.www.RewardCommen_key";

//2g/3g
static NSString * const kPicSwitchKey=@"cn.com.meidebi.www.pic_switch_key";
//filePhoto
static NSString * const kFilePhoto=@"cn.com.meidebi.www.pic_kFilePhoto_key";
static NSString * const kUmengDeviceToken=@"cn.com.meidebi.www.kUmengDeviceToken";
static NSString * const kSineOne=@"cn.com.meidebi.www.kUmengDevicekSineOne";
static NSString * const kLocationInfo = @"cn.com.meidebi.www.kLocationInfo";
static NSString * const kSinnAll=@"cn.com.meidebi.ksignall";
static NSString * const kActive=@"cn.com.meidebi.kActive";
static NSString * const kIsginContent=@"cn.com.meidebi.kIsginContent";
static NSString * const kIsloadPhotoWifi=@"cn.com.meidebi.kIsloadPhotoWifi";
static NSString * const kIsloadloction=@"cn.com.meidebi.kIsloadloction";
static NSString * const kIsMessageNew=@"cn.com.meidebi.kIsMessageNew";
static NSString * const kPushCats=@"cn.com.meidebi.kPushCats";
static NSString * const kPushSources=@"cn.com.meidebi.kPushSources";
static NSString * const kAllPushSources=@"cn.com.meidebi.kAllPushSources";
static NSString * const kLastVersionNumber=@"cn.com.meidebi.kLastVersionNumber";
static NSString * const kLaunchingNumber = @"cn.com.meidebi.kLaunchingNumber";
static NSString * const kIsCommentNew=@"cn.com.meidebi.kIsCommentNew";
static NSString * const kAaronLiStarTime=@"cn.com.meidebi.kAaronLiStarTime";
static NSString * const kAaronLiEndTime=@"cn.com.meidebi.kAaronLiEndTime";
static NSString * const kIsUserInfoLogin=@"cn.com.meidebi.kIsUserInfoLogin";
static NSString * const kThirdPartyLogin=@"cn.com.meidebi.kThirdPartyLogin";
static NSString * const kUmengfirestStatue=@"cn.com.meidebi.kUmengfirestStatue";
static NSString * const kShowHandle=@"cn.com.meidebi.kShowHandle";
static NSString * const kClickTask=@"cn.com.meidebi.kClickTask";
static NSString * const kNeedPhone=@"cn.com.meidebi.kNeedPhone";
static NSString * const kFreeLottoState=@"cn.com.meidebi.kFreeLottoState";
static NSString * const kLottoNumber=@"cn.com.meidebi.kLottoNumber";
static NSString * const kFinishShare=@"cn.com.meidebi.kFinishShare";
static NSString * const kFinishBroke=@"cn.com.meidebi.kFinishBroke";
static NSString * const kFinishBask=@"cn.com.meidebi.kFinishBask";
static NSString * const kPushBadge=@"cn.com.meidebi.kPushBadge";
static NSString * const kPushKeywordsDate=@"cn.com.meidebi.kPushKeywordsDate";
static NSString * const kPushKeywordsStatue=@"cn.com.meidebi.kPushKeywordsStatue";
static NSString * const kAttendanceDate = @"cn.com.meidebi.kAttendanceDate";
static NSString * const kLastSelectPath = @"cn.com.meidebi.kLastSelectPath";
static NSString * const kLastSelectProductTypes = @"cn.com.meidebi.kLastSelectProductTypes";
static NSString * const kAdinfo = @"cn.com.meidebi.kAdinfo";
static NSString * const kRemarkCache = @"cn.com.meidebi.kRemarkCache";
static NSString * const kRemarkImages = @"cn.com.meidebi.kRemarkImages";
static NSString * const kAppIndexGuide = @"cn.com.meidebi.kAppIndexGuide";
static NSString * const kAppProductGuide = @"cn.com.meidebi.kAppProductGuide";
static NSString * const kAppPersonalInfoGuide = @"cn.com.meidebi.kAppPersonalInfoGuide";
static NSString * const kAppPersonalInfoFansGuide = @"cn.com.meidebi.kAppPersonalInfoFansGuide";
static NSString * const kAppHotLastNewID = @"cn.com.meidebi.kAppHotLastNewID";



@implementation MDB_UserDefault




+ (instancetype)defaultInstance {
    static dispatch_once_t onceToken;
    static MDB_UserDefault * singleTon = nil;
    kIsRightInit = YES;
    dispatch_once(&onceToken, ^{
        singleTon = [[self alloc] init];
    });
    
    kIsRightInit = NO;
    return singleTon;
}



- (instancetype)init {
    NSAssert(kIsRightInit, @"请不要直接使用\"-init\"初始化");
    self = [super init];
    if (self) {
        [self initSomething];
    }
    return self;
}

- (void)initSomething {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if ([MDB_UserDefault getIsLogin]) {
        
        _usercoper=[userDefaults objectForKey:kUserCoperKey];
        _userjifen=[userDefaults objectForKey:kUserJifenKey];
        _userlevel=[userDefaults objectForKey:kUserLevelKey];
        _userphoto=[userDefaults objectForKey:kUserPhotoUrlKey];
        _userName=[userDefaults objectForKey:kUserNameKey];
        _usertoken=[userDefaults objectForKey:kUserTokenKey];
        
        _nickName = [userDefaults objectForKey:kUserNickNameKey];
        _userFans = [userDefaults objectForKey:kUserFansKey];
        _userFollow = [userDefaults objectForKey:kUserFollowNumKey];
        _ueserContribution = [userDefaults objectForKey:kUserContributionKey];
        
        if ([[userDefaults objectForKey:kUserIssignKey] isEqualToString:@"1"]) {
            _userissign=YES;
        }else if ([[userDefaults objectForKey:kUserIssignKey] isEqualToString:@"0"]){
            _userissign=NO;
        }
  
    }
    _isOn=[[userDefaults objectForKey:kPicSwitchKey]isEqualToString:@"1"]?YES:NO;
}
+(void)softCorner_round_clip:(UIView *)view{
    
    
    view.layer.cornerRadius=5.0;
    view.layer.masksToBounds = YES;
    
    view.layer.borderColor=HappyRedColor.CGColor;
    view.layer.borderWidth=2.0f;
    
    view.layer.shadowPath =[UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    
}
#pragma mark - user properties
//分类
+(void)setCats:(NSArray *)cats{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:kCatsKey];
    
    [userDefaults setObject:cats forKey:kCatsKey];
    [userDefaults synchronize];
}
+(NSArray *)getCats{

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kCatsKey];
}

//搜索历史
+(void)setProcducs:(NSString *)product{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];//kProcdcsKey
    
    NSMutableArray *arrs =[NSMutableArray arrayWithArray:[MDB_UserDefault getProcducs]];
    if (arrs) {
        [userDefaults removeObjectForKey:kProcdcsKey];
        [userDefaults synchronize];
        if ([arrs containsObject:product]) {
            [arrs removeObject:product];
            [arrs insertObject:product atIndex:0];
        }else{
            [arrs insertObject:product atIndex:0];
        }
    }else{
        arrs=[NSMutableArray arrayWithObject:product];
    }
    
    
    [userDefaults setObject:arrs forKey:kProcdcsKey];
    [userDefaults synchronize];    
}
+(void)removeAllProducs{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kProcdcsKey];
    [userDefaults synchronize];
    
}
+(NSArray *)getProcducs{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kProcdcsKey];
}

//打赏评论
+(void)setRewardComment:(NSString *)content{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrs =[NSMutableArray arrayWithArray:[MDB_UserDefault getRewardComments]];
    if (arrs) {
        [userDefaults removeObjectForKey:kRewardCommenKey];
        [userDefaults synchronize];
        if ([arrs containsObject:content]) {
            [arrs removeObject:content];
            [arrs addObject:content];
        }else{
            [arrs addObject:content];
        }
        // 限制最多十条，并且从第三条开始删除
        if (arrs.count > 10) {
            [arrs removeObjectAtIndex:2];
        }
    }else{
        arrs=[NSMutableArray arrayWithObject:content];
    }
    [userDefaults setObject:arrs forKey:kRewardCommenKey];
    [userDefaults synchronize];
}
+(NSArray *)getRewardComments{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kRewardCommenKey];
}

- (void)setUserWithDic:(NSDictionary *)dic token:(NSString *)token{
 
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"copper"]] forKey:kUserCoperKey];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"coins"]] forKey:kUserJifenKey];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"totallevel"]] forKey:kUserLevelKey];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"telphone"]] forKey:kUserTelphoneKey];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"emailcomfirm"]] forKey:kUserEmailcomfirmKey];
    
    [userDefaults setObject:[dic objectForKey:@"photo"] forKey:kUserPhotoUrlKey];
    if ([dic objectForKey:@"username"]&&![[dic objectForKey:@"username"]isEqualToString:@""]) {
        [userDefaults setObject:[dic objectForKey:@"username"] forKey:kUserNameKey];
    }
    
    if ([dic objectForKey:@"nickname"]&&![[dic objectForKey:@"nickname"]isEqualToString:@""]) {
        [userDefaults setObject:[dic objectForKey:@"nickname"] forKey:kUserNickNameKey];
    }
    
    [userDefaults setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"isSign"]] forKey:kUserIssignKey];
    [userDefaults setObject:token forKey:kUserTokenKey];
    [userDefaults synchronize];
    
    [[MDB_ShareExstensionUserDefault defaultInstance] saveUserToken:token];
    _usercoper=[userDefaults objectForKey:kUserCoperKey];
    _userjifen=[userDefaults objectForKey:kUserJifenKey];
    _userlevel=[userDefaults objectForKey:kUserLevelKey];
    _userphoto=[userDefaults objectForKey:kUserPhotoUrlKey];
    _userName=[userDefaults objectForKey:kUserNameKey];
    _usertoken=[userDefaults objectForKey:kUserTokenKey];
    
    _telphone = [userDefaults objectForKey:kUserTelphoneKey];
    _emailcomfirm = [userDefaults objectForKey:kUserEmailcomfirmKey];
    
    _nickName = [userDefaults objectForKey:kUserNickNameKey];
    _userFans = [userDefaults objectForKey:kUserFansKey];
    _userFollow = [userDefaults objectForKey:kUserFollowNumKey];
    _ueserContribution = [userDefaults objectForKey:kUserContributionKey];

    
    if ([[userDefaults objectForKey:kUserIssignKey] isEqualToString:@"1"]) {
        _userissign=YES;
        [userDefaults setObject:[NSString stringWithFormat:@"已连续签到%@天",[dic objectForKey:@"signtimes"]] forKey:kIsginContent];
    }else if ([[userDefaults objectForKey:kUserIssignKey] isEqualToString:@"0"]){
        _userissign=NO;
    }
}
- (void)setUserNil{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:kUserCoperKey]) {
        [userDefaults removeObjectForKey:kUserCoperKey];
    }
    if ([userDefaults objectForKey:kUserJifenKey]) {
        [userDefaults removeObjectForKey:kUserJifenKey];
    }
    if ([userDefaults objectForKey:kUserLevelKey]) {
        [userDefaults removeObjectForKey:kUserLevelKey];
    }
    if ([userDefaults objectForKey:kUserPhotoUrlKey]) {
        [userDefaults removeObjectForKey:kUserPhotoUrlKey];
    }
    if ([userDefaults objectForKey:kUserNameKey]) {
        [userDefaults removeObjectForKey:kUserNameKey];
    }
    if ([userDefaults objectForKey:kUserTokenKey]) {
        [userDefaults removeObjectForKey:kUserTokenKey];
    }
    if ([userDefaults objectForKey:kUserIssignKey]) {
        [userDefaults removeObjectForKey:kUserIssignKey];
    }
//    if ([userDefaults objectForKey:kIsgineDate]) {
//        [userDefaults removeObjectForKey:kIsgineDate];
//    }
    if ([userDefaults objectForKey:kIsginContent]) {
        [userDefaults removeObjectForKey:kIsginContent];
    }
    if ([userDefaults objectForKey:kAppHotLastNewID]) {
        [userDefaults removeObjectForKey:kAppHotLastNewID];
    }
    
    [userDefaults synchronize];
    _usercoper=nil;
    _userjifen=nil;
    _userlevel=nil;
    _userphoto=nil;
    _userName=nil;
    _usertoken=nil;
    
    _nickName = nil;
    _userFans = nil;
    _userFollow = nil;
    _ueserContribution = nil;

    _userissign=NO;

}


+(BOOL)getIsLogin{
    
    NSUserDefaults* userDefautls = [NSUserDefaults standardUserDefaults];
    NSString *strUserKey = [userDefautls objectForKey:kUserTokenKey];
    if (!strUserKey || strUserKey.length <= 0) {
        return NO;
    }
    return YES;
}



- (void)setisSignyes:(NSString *)isSign coper:(NSString *)coper name:(NSString *)name nickName:(NSString *)nickName coin:(NSString *)coin fans:(NSString *)fans follow:(NSString *)follow contribution:(NSString *)contribution content:(NSString *)contet userPhoto:(NSString *)photoLink userID:(NSString *)userID balance:(NSString *)balance commission_balance:(NSString *)commission_balance goods_coupon_balance:(NSString *)goods_coupon_balance is_set_pay_password:(BOOL)is_set_pay_password{
     NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults setObject:[NSString stringWithFormat:@"%@",isSign] forKey:kUserIssignKey];
    [userDefaults synchronize];

     [userDefaults setObject:photoLink forKey:kUserPhotoUrlKey];
    [userDefaults synchronize];

    if (coper) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",coper] forKey:kUserCoperKey];
        [userDefaults synchronize];
    }
    if (coin) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",coin] forKey:kUserJifenKey];
        [userDefaults synchronize];

    }
    if (contet) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",contet] forKey:kIsginContent];
        [userDefaults synchronize];
    }
    if (userID) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",userID] forKey:kUserUserIDKey];
        [userDefaults synchronize];
    }
    
    if (name) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",name] forKey:kUserNameKey];
        [userDefaults synchronize];
    }
    
    
    if (nickName) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",nickName] forKey:kUserNickNameKey];
        [userDefaults synchronize];
    }
    
    if (contribution) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",contribution] forKey:kUserContributionKey];
        [userDefaults synchronize];
    }
    if (follow) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",follow] forKey:kUserFollowNumKey];
        [userDefaults synchronize];
    }
    
    if (fans) {
        [userDefaults setObject:[NSString stringWithFormat:@"%@",fans] forKey:kUserFansKey];
        [userDefaults synchronize];
    }
    
    

    if ([isSign isEqualToString:@"1"]) {
        
        _userissign=YES;
        
    }else if ([isSign isEqualToString:@"0"]){
        _userissign=NO;
    }
    _usercoper=coper;
    _userjifen=coin;
    _userName = name;
    _nickName = nickName;
    _ueserContribution = contribution;
    _userFollow = follow;
    _userFans = fans;
    _userID = userID;
    
    _telphone = [userDefaults objectForKey:kUserTelphoneKey];
    _emailcomfirm = [userDefaults objectForKey:kUserEmailcomfirmKey];
    
    _balance = [self NoStringChangToNumber:balance];
    _commission_balance = [self NoStringChangToNumber:commission_balance];
    _goods_coupon_balance = [self NoStringChangToNumber:goods_coupon_balance];
    _is_set_pay_password = is_set_pay_password;
//    _userphoto = photoLink;
//    [userDefaults synchronize];
}

-(NSString *)NoStringChangToNumber:(NSString *)str
{
    if([NSString nullToString:str].length == 0)
    {
        return @"0.00";
    }
    return str;
}

- (NSString *)getIstimeSign{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kIsginContent];
}

- (BOOL)getisSign{
        return _userissign;
}
- (void)setUserPhoto:(NSString *)userPhoto{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userPhoto forKey:kUserPhotoUrlKey];
    [userDefaults synchronize];
    _userphoto=userPhoto;
}

- (void)setUserName:(NSString *)userName{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:kUserNameKey];
    [userDefaults synchronize];
    _userName=userName;
}

+(NSArray *)getActive{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kActive];
}
+(void)setActive:(NSArray *)dic{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:kActive];
}
//是否新消息
+(BOOL)getMessage{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:kIsMessageNew] boolValue];
}
+(void)setMessage:(BOOL)mbool{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:mbool] forKey:kIsMessageNew];
    [userDefaults synchronize];
}

+(BOOL)getComment{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:kIsCommentNew] boolValue];
}

+(void)setComment:(BOOL)mbool{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:mbool] forKey:kIsCommentNew];
    [userDefaults synchronize];
}

+(NSDictionary *)getLocationInfo{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kLocationInfo];
}
+(void)setLocationInfo:(NSDictionary *)infoDict{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:infoDict forKey:kLocationInfo];
    [userDefaults synchronize];
}
+ (void)setUmengDeviceToken:(NSString *)devicetoken{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:devicetoken forKey:kUmengDeviceToken];
    [userDefaults synchronize];
}
+(NSString *)getUmengDeviceToken{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *devicestoken=[userDefaults objectForKey:kUmengDeviceToken];
    return devicestoken;
}
+(void)setkkSinnAll:(NSString *)intStr{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:intStr forKey:kSinnAll];
    [userDefaults synchronize];
}
+(NSString *)getkSinnAll{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *devicestoken=[userDefaults objectForKey:kSinnAll];
    return devicestoken;
}

+ (CGSize)getStrWightFont:(UIFont *)font str:(NSString *)str  hight:(float)high{
    if(!str&&(NSNull *)str==[NSNull null]){
        str=@"nill";
    }
    
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, high) options:0 attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize;
}
+ (CGSize)getStrhightFont:(UIFont *)font str:(NSString *)str  wight:(float)wight{
    if (!str&&(NSNull *)str==[NSNull null]) {
        str=@"nill";
    }
    if(str == nil)
    {
        str = @"";
    }

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange allRange = [str rangeOfString:str];
    [attrStr addAttribute:NSFontAttributeName
                    value:font//[UIFont systemFontOfSize:13.0]
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:allRange];
    
//    NSRange destRange = [str rangeOfString:tagStr];
//    [attrStr addAttribute:NSForegroundColorAttributeName
//                    value:HEXCOLOR(0x009cdd)
//                    range:destRange];
    
    CGFloat titleHeight;
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake( wight, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    titleHeight = ceilf(rect.size.height);
    //int tlet=titleHeight;
    titleHeight=(1+titleHeight/1000.0)*(1+titleHeight/1000.0)*(1+titleHeight/1000.0)*titleHeight;
    
//    NSDictionary *attribute = @{NSFontAttributeName:font};
//    CGSize retSize = [str boundingRectWithSize:CGSizeMake(wight, 0)
//                                             options:\
//                      NSStringDrawingTruncatesLastVisibleLine |
//                      NSStringDrawingUsesLineFragmentOrigin |
//                      NSStringDrawingUsesFontLeading
//                                          attributes:attribute
//                                        context:nil].size;
    CGSize retSize=CGSizeMake(wight, titleHeight);
    return retSize;
    
}

//lb计算文本的宽和高
+(CGSize)countTextSize:(CGSize)size andtextfont:(UIFont *)font andtext:(NSString *)str
{
    CGSize detailsLabSize = size;
    NSDictionary *detailsLabAttribute = @{NSFontAttributeName: font};
    //ios7方法，获取文本需要的size
    CGSize  msize =[str boundingRectWithSize:detailsLabSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:detailsLabAttribute context:nil].size;
    return msize;
}


+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//是否wifi下才上传晒单图片
+(NSNumber *)getIsPhoto{
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:kIsloadPhotoWifi];
}
+(void)setIsPhoto:(BOOL)bools{
    NSNumber *numbes=[NSNumber numberWithBool:bools];
    [[NSUserDefaults standardUserDefaults]setObject:numbes forKey:kIsloadPhotoWifi];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


//2g／3g无图
- (BOOL)getPicMode_switch{
    return self.isOn;
    
}
- (void)setPicMode_swithc:(BOOL)isOn{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if (isOn) {
        [userDefaults setObject:@"1" forKey:kPicSwitchKey];
    }else{
        [userDefaults setObject:@"0" forKey:kPicSwitchKey];
    }
    _isOn=isOn;
    [userDefaults synchronize];
}
-(BOOL)getIswifi{
    if ([MDB_UserDefault getNETWORKtype]==NETWORK_TYPE_WWAN) {
        return NO;
    }
    return YES;
   
}
-(BOOL)notwifaLoad{
    if ([MDB_UserDefault getNETWORKtype]==NETWORK_TYPE_WIFI||[MDB_UserDefault getNETWORKtype]==NETWORK_TYPE_NONE) {
        return NO;
    }
    return _isOn;
}
//本地地名
+(NSString *)getloaction{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kIsloadloction];
}
-(void)setloaction:(NSString *)loction{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:loction forKey:kIsloadloction];
    [userDefaults synchronize];
}

+(NSArray *)getAllPushCats{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAllPushSources];
}
+(void)setAllPushCats:(NSArray *)cats{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cats forKey:kAllPushSources];
    [userDefaults synchronize];
}

//推送类别
+(NSArray *)getPushCats{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPushCats];
}
+(void)setPushCats:(NSArray *)cats{
     NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cats forKey:kPushCats];
    [userDefaults synchronize];
}

//商品来源
+(NSArray *)getPushSources{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPushSources];
}
+(void)setPushSources:(NSArray *)sources{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sources forKey:kPushSources];
    [userDefaults synchronize];
}

//版本号
+(NSString *)getVersionNumber{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastVersionNumber];
}
+(void)setVersionNumber:(NSString *)number{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:number forKey:kLastVersionNumber];
    [userDefaults synchronize];
}

+(NSNumber *)getAppLaunchingNumber{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchingNumber];
}
+(void)setAppLaunchingNumber:(NSNumber *)number{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:number forKey:kLaunchingNumber];
    [userDefaults synchronize];

}


// 勿扰时间开始
+(NSString *)getAaronLiStarDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAaronLiStarTime];
}
+(void)setAaronLiStarDate:(NSString *)dateStr{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dateStr forKey:kAaronLiStarTime];
    [userDefaults synchronize];

}

// 勿扰时间结束
+(NSString *)getAaronLiEndDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAaronLiEndTime];
}
+(void)setAaronLiEndDate:(NSString *)dateStr{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dateStr forKey:kAaronLiEndTime];
    [userDefaults synchronize];
}

+(BOOL)getIsUserInfoLogin{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsUserInfoLogin];

}
+(void)setIsUserInfoLogin:(BOOL)isUserInfo{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isUserInfo forKey:kIsUserInfoLogin];
    [userDefaults synchronize];
}

+(BOOL)getThirdPartyLoginSuccess{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kThirdPartyLogin];
}
+(void)setThirdPartyLoginSuccess:(BOOL)statue{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:statue forKey:kThirdPartyLogin];
    [userDefaults synchronize];
}

+(BOOL)getUmengfirestStatue{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUmengfirestStatue];
}
+(void)setUmengfirestStatue:(BOOL)isFirest{
     NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isFirest forKey:kUmengfirestStatue];
    [userDefaults synchronize];
}

+(BOOL)getIsShowHandle{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShowHandle];

}
+(void)setIsShowHandle:(BOOL)isShowHandle{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isShowHandle forKey:kShowHandle];
    [userDefaults synchronize];
}


+(BOOL)clickTaskStatue{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kClickTask];
}
+(void)setClickTaskStatue:(BOOL)isClick{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isClick forKey:kClickTask];
    [userDefaults synchronize];
}

+(BOOL)needPhoneStatue{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNeedPhone];
}

+(void)setNeedPhoneStatue:(BOOL)needPhone{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:needPhone forKey:kNeedPhone];
    [userDefaults synchronize];
}
+(NSDate *)freeLottoDate{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kFreeLottoState];
}
+(NSNumber *)lottoNumber{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kLottoNumber];
}
+(void)setFreeLottoDate:(NSDate *)lottoDate lottoNumber:(NSNumber *)number{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:lottoDate forKey:kFreeLottoState];
    [userDefaults setValue:number forKey:kLottoNumber];
    [userDefaults synchronize];
}
+(NSDate *)finishShareDate{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kFinishShare];
}
+(void)setFinishShareDate:(NSDate *)finishDate{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:finishDate forKey:kFinishShare];
    [userDefaults synchronize];
}

+(NSDate *)finishBaskDate{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kFinishBask];
}
+(void)setFinishBaskDate:(NSDate *)finishDate{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:finishDate forKey:kFinishBask];
    [userDefaults synchronize];
}

+(NSDate *)finishBrokeDate{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kFinishBroke];
}
+(void)setFinishBrokeDate:(NSDate *)finishDate{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:finishDate forKey:kFinishBroke];
    [userDefaults synchronize];
}

+(NSNumber *)pushBadgeNumber{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kPushBadge];
}
+(void)setPushBadgeNumber:(NSNumber *)badge{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:badge forKey:kPushBadge];
    [userDefaults synchronize];
}

+(NSDate *)pushKeywordsDate{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kPushKeywordsDate];
}
+(void)setPushKeywordsDate:(NSDate *)date{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:date forKey:kPushKeywordsDate];
    [userDefaults synchronize];
}

+(BOOL)pushKeywordsStatue{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPushKeywordsStatue];
}


+(void)setpushKeywordsStatue:(BOOL)statue{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:statue forKey:kPushKeywordsStatue];
    [userDefaults synchronize];
}


+ (NSInteger)attendanceLeastDate{
    NSInteger date = [[NSUserDefaults standardUserDefaults] integerForKey:kAttendanceDate];
    if (date == 0) {
        return 1;
    }else{
        return date;
    }
}
+ (void)setAttendanceLeastDate:(NSInteger)leastDate{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:leastDate forKey:kAttendanceDate];
    [userDefaults synchronize];
}

+ (NSDictionary *)lastSelectMenuPaths{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectPath];
}

+ (void)setLastSelectMenuPath:(NSDictionary *)lastPaths{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:lastPaths forKey:kLastSelectPath];
    [userDefaults synchronize];
}

+(NSArray *)filterProductTypes{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectProductTypes];
}

+(void)setFilterProductTypes:(NSArray *)types{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:types forKey:kLastSelectProductTypes];
    [userDefaults synchronize];
}

+ (NSString *)adInfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAdinfo];
}

+ (void)setAdInfo:(NSString *)info{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:info forKey:kAdinfo];
    [userDefaults synchronize];
}
// 评论
+(NSString *)remarkCache{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRemarkCache];
}
+(void)setRemarkCache:(NSString *)remark{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:remark forKey:kRemarkCache];
    [userDefaults synchronize];
}

// 评论图片
+ (NSArray *)remarkImages{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRemarkImages];
}
+ (void)setRemarkImages:(NSArray *)images{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:images forKey:kRemarkImages];
    [userDefaults synchronize];
}


+ (BOOL)showAppIndexGuide{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAppIndexGuide];
}
+ (void)setShowAppIndexGuide:(BOOL)show{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:show forKey:kAppIndexGuide];
    [userDefaults synchronize];
}

+ (BOOL)showAppProductGuide{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAppProductGuide];
}
+ (void)setShowAppProductGuide:(BOOL)show{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:show forKey:kAppProductGuide];
    [userDefaults synchronize];
}

+ (BOOL)showAppPersonalInfoGuide{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAppPersonalInfoGuide];
}
+ (void)setShowAppPersonalInfoGuide:(BOOL)show{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:show forKey:kAppPersonalInfoGuide];
    [userDefaults synchronize];
}

+ (BOOL)showAppPersonalInfoFansGuide{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAppPersonalInfoFansGuide];
}
+ (void)setShowAppPersonalInfoFansGuide:(BOOL)show{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:show forKey:kAppPersonalInfoFansGuide];
    [userDefaults synchronize];
}

+ (NSInteger)hotLastNewID{
    NSInteger hotID = [[NSUserDefaults standardUserDefaults] integerForKey:kAppHotLastNewID];
    if (hotID <= 0 && hotID) {
        return 0;
    }else{
        return hotID;
    }
}
+ (void)setHotLastNewID:(NSInteger)ID{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:ID forKey:kAppHotLastNewID];
    [userDefaults synchronize];
}

///给url添加http
+(NSString *)getCompleteWebsite:(NSString *)urlStr{
    urlStr = [NSString stringWithFormat:@"%@",urlStr]; 
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    if(urlStr==nil)
    {
        urlStr = @"";
        return urlStr;
    }
    assert(urlStr != nil);
    
//    @try
//    {
//        urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    }
//    @finally
//    {
//
//    }
    if ( (urlStr != nil) && (urlStr.length != 0) ) {
        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                //不支持的URL方案
                returnUrlStr = urlStr;
            }
        }
    }
    return returnUrlStr;
}

///设置一行显示不同字体 颜色
+(NSMutableAttributedString *)arrstring:(NSString *)str andstart:(int)istart andend:(int)length andfont:(UIFont *)font andcolor:(UIColor *)color
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
    @try {
        [noteStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(istart, length)];
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(istart, length)];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return noteStr;
}

#pragma mark -IntervalFromData
+(NSInteger)CalDateInterva:(NSDate *)paramEndDate{
    NSDate *paramStartDate=[NSDate date];
    NSCalendar *chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
     NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *DateComponent = [chineseClendar components:unitFlags fromDate:paramEndDate toDate:paramStartDate options:0];
    NSInteger diffDay   = [DateComponent day];
    NSInteger diffHour = [DateComponent hour];
    NSInteger diffMin    = [DateComponent minute];
    if (diffDay>0) {
        return 2;
    }else if(diffHour>0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"HH"];
        NSString *strHour = [dateFormatter stringFromDate:paramStartDate];
        
        if ([strHour integerValue]<diffHour) {
            return 1;
        }else{
            return 0;
        }
    }else if(diffMin>0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"mm"];
        NSString *strMine = [dateFormatter stringFromDate:paramStartDate];
        
        NSDateFormatter *dateFormatterS = [[NSDateFormatter alloc] init] ;
        [dateFormatterS setDateFormat:@"HH"];
        NSString *strHour = [dateFormatterS stringFromDate:paramStartDate];
        if ([strHour integerValue]>0) {
            return 0;
        }
        if ([strMine integerValue]<diffMin) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
    
}

+(BOOL)CalDateInterval:(NSDate *)paramEndDate{
    NSInteger times=[self CalDateInterva:paramEndDate];
    if (times==0) {
        return YES;
    }else if (times==1){
        return NO;
    }else{
        return NO;
    }
}
static NSDate *datelast;
/*计算日期间隔：开始日期&结束日期*/
+ (NSString *)CalDateIntervalFromData:(NSDate *)paramStartDate endDate:(NSDate *)paramEndDate{
    
    NSString *strResult=nil;
    
    
    NSCalendar *chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    if(paramStartDate>0)
    {
        datelast = paramStartDate;
    }
    if(datelast==nil||datelast==0)
    {
        datelast = [NSDate date];
    }
    NSDateComponents *DateComponent = [chineseClendar components:unitFlags fromDate:datelast toDate:paramEndDate options:0];
    
    NSInteger diffHour = [DateComponent hour];
    
    NSInteger diffMin    = [DateComponent minute];
    
    NSInteger diffSec   = [DateComponent second];
    
    NSInteger diffDay   = [DateComponent day];
    
    NSInteger diffMon  = [DateComponent month];
    
    NSInteger diffYear = [DateComponent year];
    
    if (diffYear>0) {
        strResult=[NSString stringWithFormat:@"%ld年前",(long)diffYear];
    }else if(diffMon>0){
        strResult=[NSString stringWithFormat:@"%ld月前",(long)diffMon];
    }else if(diffDay>0){
        strResult=[NSString stringWithFormat:@"%ld天前",(long)diffDay];
    }else if(diffHour>0){
        strResult=[NSString stringWithFormat:@"%ld小时前",(long)diffHour];
    }else if(diffMin>0){
        strResult=[NSString stringWithFormat:@"%ld分钟前",(long)diffMin];
    }else if(diffSec>0){
        strResult=[NSString stringWithFormat:@"%ld秒前",(long)diffSec];
    }else{
        strResult=[NSString stringWithFormat:@"刚刚"];
    }
    return strResult;
}
+(NSString *)strTimefromData:(NSInteger)times dataFormat:(NSString *)dataFormat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (dataFormat) {
        [dateFormatter setDateFormat:dataFormat];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    return  [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:times]];
}
+(NSString *)strTimefromDatas:(NSDate *)times dataFormat:(NSString *)dataFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (dataFormat) {
        [dateFormatter setDateFormat:dataFormat];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return  [dateFormatter stringFromDate:times];
}

//+ (NSString *)intervalSinceNow: (NSString *) theDate
//{
//    
//    NSDateFormatter *date=[[NSDateFormatter alloc] init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *d=[date dateFromString:theDate];
//    
//    NSTimeInterval late=[d timeIntervalSince1970]*1;
//    
//    
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval now=[dat timeIntervalSince1970]*1;
//    NSString *timeString=@"";
//    
//    NSTimeInterval cha=now-late;
//    
//    if (cha/3600<1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/60];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
//        
//    }
//    if (cha/3600>1&&cha/86400<1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/3600];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
//    }
//    if (cha/86400>1)
//    {
//        timeString = [NSString stringWithFormat:@"%f", cha/86400];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@天前", timeString];
//        
//    }
////    [date release];
//    return timeString;
//}

///获取当前时间戳
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

// 是否是同一天
+ (BOOL)isSameDay:(NSDate *)iTime1 Time2:(NSDate *)iTime2
{
    if (iTime1 == nil || iTime2 == nil) return NO;
    //传入时间毫秒数
    NSDate *pDate1 =iTime1;
    NSDate *pDate2 =iTime2;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+(void)showNotifyHUDwithtext:(NSString *)notify_str inView:(UIView *)view{
    if([notify_str isEqual:[NSNull null]])
    {
        notify_str = @"";
    }
    notify_str = [NSString nullToString:notify_str];
    if (notify_str) {
        if(view==nil)return;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10;
        hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        hud.bezelView.layer.cornerRadius = 4.f;
        hud.detailsLabel.text = notify_str;
        hud.detailsLabel.font = [UIFont systemFontOfSize:14.f];
        hud.detailsLabel.textColor = [UIColor whiteColor];
        [hud hideAnimated:YES afterDelay:2.5];
    }
}

////功能引导虚线框
+(UIView *)drawYinDaoLine:(CGRect)rect addview:(UIView *)addview andtitel:(NSString *)title
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT)];
    [view setBackgroundColor:[UIColor clearColor]];
    [view setUserInteractionEnabled:YES];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:rect];
    [imgv setBackgroundColor:[UIColor clearColor]];
    ////UIImageResizingModeTile：平铺模式  UIImageResizingModeStretch：拉伸模式
    [imgv setImage:[[UIImage imageNamed:@"gongnengyindaoxuxiankuang"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile]];
    [imgv setTag:1234560];
    [addview addSubview:imgv];
    
    
    
    
    
    UIView *superview = addview.viewController.view;
    
    
    CGRect rect1=[imgv convertRect: imgv.bounds toView:window];
    
    
    [imgv setFrame:rect1];
    [view addSubview:imgv];
    
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, rect1.origin.y)];
    [topview setBackgroundColor:RGBAlpha(100, 100, 100, 0.3)];
    [view addSubview:topview];

    UIView *viewbottom = [[UIView alloc] initWithFrame:CGRectMake(0, rect1.origin.y+rect1.size.height, view.width, BOUNDS_HEIGHT)];
    [viewbottom setBackgroundColor:RGBAlpha(100, 100, 100, 0.3)];
    [view addSubview:viewbottom];
    
    UIView *viewleft = [[UIView alloc] initWithFrame:CGRectMake(0, topview.bottom, rect1.origin.x, rect1.size.height)];
    [viewleft setBackgroundColor:RGBAlpha(100, 100, 100, 0.3)];
    [view addSubview:viewleft];
    
    UIView *viewright = [[UIView alloc] initWithFrame:CGRectMake(rect1.origin.x+rect1.size.width, topview.bottom, view.width-(rect1.origin.x+rect1.size.width), rect1.size.height)];
    [viewright setBackgroundColor:RGBAlpha(100, 100, 100, 0.3)];
    [view addSubview:viewright];
    
    
    [superview addSubview:view];
    
    
    float ftop = rect1.origin.y+rect1.size.height;
    float fbottom = 0.0;
    if(ftop>BOUNDS_HEIGHT/2.0)
    {
        fbottom = rect1.origin.y;
        ftop = 0.0;
    }
    
    
    UIImage *imageback = [UIImage imageNamed:@"yingdaokuangback"];
    UIImage *image1 = [UIImage imageNamed:@"yingdaokuangup"];
    UIImage *image2 = [UIImage imageNamed:@"yingdaokuangdown"];
    
    UIImageView *imgvtitle = [[UIImageView alloc] initWithFrame:CGRectMake((rect1.origin.x+rect1.size.width)/2.0, ftop, 100, 80)];
    [imgvtitle setBackgroundColor:[UIColor clearColor]];
    ////UIImageResizingModeTile：平铺模式  UIImageResizingModeStretch：拉伸模式
    [imgvtitle setImage:[imageback resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeTile]];
    [view addSubview:imgvtitle];
    
    UIImageView *imgvsanjiao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15*image1.size.height/image1.size.width)];
    [view addSubview:imgvsanjiao];
    
    UILabel *lbtishi = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
    [lbtishi setText:title];
    [lbtishi setTextColor:[UIColor whiteColor]];
    [lbtishi setTextAlignment:NSTextAlignmentLeft];
    [lbtishi setNumberOfLines:0];
    [lbtishi setFont:[UIFont systemFontOfSize:14]];
    [lbtishi sizeToFit];
    [imgvtitle addSubview:lbtishi];
    
    [imgvtitle setHeight:lbtishi.height+40];
    
    [imgvtitle setWidth:lbtishi.width+40];
    
    
    [imgvtitle setCenterX:rect1.origin.x+rect1.size.width/2.0];
    if(imgvtitle.left<5)
    {
        [imgvtitle setLeft:5];
    }
    else if (imgvtitle.right>BOUNDS_WIDTH-5)
    {
        [imgvtitle setRight:BOUNDS_WIDTH-5];
    }
    
    if(ftop<1)
    {
        [imgvtitle setBottom:fbottom-imgvsanjiao.height];
        [imgvsanjiao setCenterX:rect1.origin.x+rect1.size.width/2.0];
        [imgvsanjiao setTop:imgvtitle.bottom-5];
        [imgvsanjiao setImage:image2];
    }
    else
    {
        [imgvtitle setTop:ftop+imgvsanjiao.height];
        [imgvsanjiao setCenterX:rect1.origin.x+rect1.size.width/2.0];
        [imgvsanjiao setBottom:imgvtitle.top+5];
        [imgvsanjiao setImage:image1];
        
    }
    
    
    
    return view;
}

////功能引导收藏
+(UIView *)drawCollectYinDaoLine:(CGRect)rect andimage:(UIImage *)imageb addview:(UIView *)addview andtitel:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, addview.frame.size.width, addview.frame.size.height)];
    [view setBackgroundColor:RGBAlpha(100, 100, 100, 0.4)];
    [view setUserInteractionEnabled:YES];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:rect];
    [imgv setBackgroundColor:[UIColor clearColor]];
    if(imageb!=nil)
    {
        [imgv setImage:imageb];
    }
    [imgv setTag:1234560];
    [view addSubview:imgv];
    
    
    
//    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, rect1.origin.y)];
//    [topview setBackgroundColor:RGBAlpha(100, 100, 100, 0.3)];
//    [view addSubview:topview];
//
//    UIView *viewbottom = [[UIView alloc] initWithFrame:CGRectMake(0, rect1.origin.y+rect1.size.height, view.width, BOUNDS_HEIGHT)];
//    [viewbottom setBackgroundColor:RGBAlpha(100, 100, 100, 0.3)];
//    [view addSubview:viewbottom];
//
//    UIView *viewleft = [[UIView alloc] initWithFrame:CGRectMake(0, topview.bottom, rect1.origin.x, rect1.size.height)];
//    [viewleft setBackgroundColor:RGBAlpha(100, 100, 100, 0.3)];
//    [view addSubview:viewleft];
//
//    UIView *viewright = [[UIView alloc] initWithFrame:CGRectMake(rect1.origin.x+rect1.size.width, topview.bottom, view.width-(rect1.origin.x+rect1.size.width), rect1.size.height)];
//    [viewright setBackgroundColor:RGBAlpha(100, 100, 100, 0.3)];
//    [view addSubview:viewright];
    
    
    [addview addSubview:view];
    
    
    float ftop = rect.origin.y+rect.size.height+10;
    float fbottom = 0.0;
    if(ftop>BOUNDS_HEIGHT/2.0)
    {
        fbottom = rect.origin.y;
        ftop = 0.0;
    }
    
    
    UIImage *imageback = [UIImage imageNamed:@"shouchangyingdaok"];
    UIImage *image1 = [UIImage imageNamed:@"shoucangyingdaoup"];
    UIImage *image2 = [UIImage imageNamed:@"shoucangyingdaodown"];
    
    UIImageView *imgvtitle = [[UIImageView alloc] initWithFrame:CGRectMake((rect.origin.x+rect.size.width)/2.0, ftop, 100, 80)];
    [imgvtitle setBackgroundColor:[UIColor clearColor]];
    ////UIImageResizingModeTile：平铺模式  UIImageResizingModeStretch：拉伸模式
    [imgvtitle setImage:[imageback resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeTile]];
    [view addSubview:imgvtitle];
    
    UIImageView *imgvsanjiao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20*image1.size.height/image1.size.width)];
    [view addSubview:imgvsanjiao];
    
    UILabel *lbtishi = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, addview.frame.size.width*0.8, 20)];
    [lbtishi setText:title];
    [lbtishi setTextColor:RadMenuColor];
    [lbtishi setTextAlignment:NSTextAlignmentCenter];
    [lbtishi setNumberOfLines:0];
    [lbtishi setFont:[UIFont systemFontOfSize:16]];
    [lbtishi sizeToFit];
    [imgvtitle addSubview:lbtishi];
    
    [imgvtitle setHeight:lbtishi.height+40];
    
    [imgvtitle setWidth:lbtishi.width+60];
    
    
    UIImageView *imgvxx = [[UIImageView alloc] initWithFrame:CGRectMake(lbtishi.right+13, 15, 13, 13)];
    [imgvxx setImage:[UIImage imageNamed:@"pindanguanbi_X"]];
    [imgvtitle addSubview:imgvxx];
    
    
    [imgvtitle setCenterX:view.centerX];
    if(imgvtitle.left<10)
    {
        [imgvtitle setLeft:10];
    }
    else if (imgvtitle.right>BOUNDS_WIDTH-10)
    {
        [imgvtitle setRight:BOUNDS_WIDTH-10];
    }
    
    if(ftop<1)
    {
        [imgvtitle setBottom:fbottom-imgvsanjiao.height];
        [imgvsanjiao setCenterX:rect.origin.x+rect.size.width/2.0];
        [imgvsanjiao setTop:imgvtitle.bottom-5];
        [imgvsanjiao setImage:image2];
    }
    else
    {
        [imgvtitle setTop:ftop+imgvsanjiao.height];
        [imgvsanjiao setCenterX:rect.origin.x+rect.size.width/2.0];
        [imgvsanjiao setBottom:imgvtitle.top+5];
        [imgvsanjiao setImage:image1];
        
    }
    
    
    
    return view;
}

///CMTimeMakeWithSeconds(0.0, 600);
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime =1;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

#pragma mark - share
+ (void)doShareSinaWeiboUsingShareSdk:(Qqshare *)_qqshare imge:(UIImage *)images{
}

- (NSURL *)currentDiretoryForTheUnitForCurrentUser {
    NSURL * dir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return dir;
}


#pragma mark login

- (NSString *)phoneNetWork {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSArray *teleArr=[NSArray arrayWithObjects:@"CTRadioAccessTechnologyGPRS",@"CTRadioAccessTechnologyEdge",@"CTRadioAccessTechnologyCDMA1x",@"CTRadioAccessTechnologyWCDMA",@"CTRadioAccessTechnologyHSDPA",@"CTRadioAccessTechnologyHSUPA",@"CTRadioAccessTechnologyCDMAEVDORev0",@"CTRadioAccessTechnologyCDMAEVDORevA",@"CTRadioAccessTechnologyCDMAEVDORevB",@"CTRadioAccessTechnologyeHRPD",@"CTRadioAccessTechnologyLTE", nil];
    NSString *strTele=[networkInfo currentRadioAccessTechnology];
    if ([teleArr containsObject:strTele]) {
        NSInteger ssTele=[teleArr indexOfObject:strTele];
        if (ssTele<3) {
            return @"1";
        }else if(ssTele<10){
            return @"2";
        }else if(ssTele==10){
            return @"3";
        }
    }
    return @"5";
}

- (NSString *)phoneOperator {
    NSArray *arrPho=@[@"中国联通",@"中国电信",@"中国移动",@"其他"];
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier*carrier = [networkInfo subscriberCellularProvider];
    NSString * operator = @"4";
    if ([carrier.carrierName isEqualToString:[arrPho objectAtIndex:0]]) {
        operator = @"1";
    }else if ([carrier.carrierName isEqualToString:[arrPho objectAtIndex:1]]) {
        operator = @"2";
    }else if ([carrier.carrierName isEqualToString:[arrPho objectAtIndex:2]]) {
        operator = @"3";
    }else if ([carrier.carrierName isEqualToString:[arrPho objectAtIndex:3]]) {
        operator = @"4";
    }
    return operator;
}


#pragma mark - application pamameter

- (NSString *)applicationVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString * applicationVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return applicationVersion;
}

#pragma mark SDWebImageView
-(void)setImageWithImage:(UIImageView *)imageV url:(NSString *)urlStr placeholderImage:(UIImage *)image options:(SDWebImageOptions)option completed:(SDExternalCompletionBlock)completedBlock{
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:urlStr]] placeholderImage:image options:option completed:completedBlock];
   
}
-(void)setViewWithImage:(UIImageView *)imageV url:(NSString *)urlStr{
    
    if ([self notwifaLoad]) {
        imageV.image=[UIImage imageNamed:@"pucdNot.png"];
    }else{
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:urlStr]] placeholderImage:[UIImage imageNamed:@"punot.png"]];
    }
}
-(void)setViewWithImage:(UIImageView *)imageV url:(NSString *)urlStr options:(SDWebImageOptions)options{
    if ([self notwifaLoad]) {
        imageV.image=[UIImage imageNamed:@"pucdNot.png"];
    }else{
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:urlStr]] placeholderImage:[UIImage imageNamed:@"punot.png"] options:options];
        
    }
}
-(void)setViewWithImage:(UIImageView *)imageV url:(NSString *)urlStr options:(SDWebImageOptions)options  completed:(SDExternalCompletionBlock)completedBlock{
    if ([self notwifaLoad]) {
        imageV.image=[UIImage imageNamed:@"pucdNot.png"];
    }else{
//        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:urlStr]] placeholderImage:[UIImage imageNamed:@"punot.png"] options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//            if(error!= nil)
//            {
//                image = [self webpImagedatachuli:imageURL];
//                completedBlock(image,error,cacheType,imageURL);
//
//            }
//
//        }];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:urlStr]] placeholderImage:[UIImage imageNamed:@"punot.png"] options:options completed:completedBlock];
    }
}

-(UIImage *)webpImagedatachuli:(NSURL *)imageURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [paths objectAtIndex:0];
    NSString *imageDir = [NSString stringWithFormat:@"%@/pengimg", filePath];
    
    NSString *strfiel = imageURL.absoluteString.lastPathComponent;
    NSArray *arrtemp = [strfiel componentsSeparatedByString:@"."];
    if(arrtemp.count>0)
    {
        strfiel = arrtemp[0];
    }
    NSData *datatemp = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",imageDir,strfiel]];
    datatemp = [NSData dataWithContentsOfURL:imageURL];
//    if(datatemp==nil)
//    {
//
//        datatemp = [NSData dataWithContentsOfURL:imageURL];
//
//        if(datatemp!=nil)
//        {
//
//            //保存图片
//            BOOL isDir = NO;
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
//            if ( !(isDir == YES && existed == YES) )
//            {
//                [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
//            }
//            BOOL isok =  [datatemp writeToFile:[NSString stringWithFormat:@"%@/%@",imageDir,strfiel] atomically:NO];
//            if(isok == NO)
//            {
//                NSLog(@"图片保存出错");
//            }
//        }
//
//    }
    UIImage  *imagetemp = [UIImage imageWithWebPData:datatemp];
    
    return imagetemp;
}

-(void)setViewWithImage:(UIImageView *)imageV url:(NSString *)urlStr image:(UIImage *)placeholder options:(SDWebImageOptions)options  completed:(SDExternalCompletionBlock)completedBlock{
   
    if ([self notwifaLoad]) {
        imageV.image=[UIImage imageNamed:@"pucdNot.png"];
    }else{
        
//        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:urlStr]] placeholderImage:placeholder options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if(error!= nil)
//            {
//                image = [self webpImagedatachuli:imageURL];
//                completedBlock(image,error,cacheType,imageURL);
//                
//            }
//        }];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:urlStr]] placeholderImage:[UIImage imageNamed:@"punot.png"] options:options completed:completedBlock];
        
    }

}

-(void)setViewImageWithURL:(NSURL *)imageUrl placeholder:(UIImage *)placeholder UIimageview:(UIImageView *)imageV{
    if (placeholder) {
        if ([self notwifaLoad]) {
            imageV.image=[UIImage imageNamed:@"pucdNot.png"];
        }else{
            [imageV sd_setImageWithURL:imageUrl placeholderImage:placeholder];
        }
    }else{
        if ([self notwifaLoad]) {
            imageV.image=[UIImage imageNamed:@"pucdNot.png"];
        }else{
            [imageV sd_setImageWithURL:imageUrl placeholderImage:placeholder];
        }
    }
}
-(void)setImageWithURL:(NSURL *)imageUrl options:(SDWebImageOptions)option{
    if ([self notwifaLoad]) {

    }else{
//        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:imageUrl options:option progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//
//        }];
        [[SDWebImageManager sharedManager] loadImageWithURL:imageUrl options:option progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

        }];
//    [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:option progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//
//    }];
    }
}
- (void)setSaveImageToCache:(UIImage *)image forURL:(NSURL *)url{
    
    [[SDWebImageManager sharedManager]saveImageToCache:image forURL:url];
    
}

///判断图片是否有缓存
-(BOOL)imagediskImageExistsForURL:(NSString *)strurl
{

    return [[[SDWebImageManager sharedManager]imageCache] diskImageDataExistsWithKey:strurl];;
    
}
////从缓存中获取图片
-(UIImage *)getImageExistsForURL:(NSString *)strurl
{
    UIImage *imagete = nil;
    if([self imagediskImageExistsForURL:strurl])
    {
        imagete = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:strurl];
    }
    return imagete;
}

//判断有无网络，yes有，no没有
+(BOOL)getReachilityState{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==0) {
        
        return NO;
    }else{
        return YES;
    }
}


//缓存大小
- (float)checkTmpSize{
    NSInteger intSize = [[SDImageCache sharedImageCache]getSize];
    float totalSize=intSize/1024.0/1024.0;
    return totalSize;
}
//清空缓存
- (void)clearTmpPics{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    
    [self removeAutometicfile];
    
//    [SDImageCache sharedImageCache]
    //    [[SDImageCache sharedImageCache] clearMemory];//可有可无

}
//自动清理文件
-(void)removeAutometicfile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [paths objectAtIndex:0];
    NSString *strfile = [NSString stringWithFormat:@"%@/pengimg",filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //计算文件得个数
    NSArray *filecoun = [fileManager contentsOfDirectoryAtPath:strfile error:Nil];
    NSLog(@"filecoun  = %lu",(unsigned long)filecoun.count);
    if(filecoun.count > 1)
    {
        for(NSInteger i = 0; i < filecoun.count - 1 ; i ++)
        {
            NSString *strfilepath = [NSString stringWithFormat:@"%@/%@",strfile,filecoun[i]];
            [fileManager removeItemAtPath:strfilepath error:Nil];
        }
    }
    
    
}

-(void)clearTmpPic:(NSString *)key{
    [[SDImageCache sharedImageCache] removeImageForKey:key withCompletion:^{
        
    }];

}
#pragma mark File

//存或者删除标记数据//yes 存， no 删除
-(void)isSaveDicBool:(BOOL)bools dic:(NSDictionary *)dic{
    if (bools) {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arrMut=[NSMutableArray arrayWithArray:[userDefaults objectForKey:kFilePhoto]];
        [arrMut addObject:dic];
        [userDefaults setObject:[NSArray arrayWithArray:arrMut] forKey:kFilePhoto];
        [userDefaults synchronize];
    }else{
        
    
    }
}
//晒单图片临时存储//yes 存， no 删除
-(void)saveOrDeletePhotoOnce:(BOOL)bools PhotoData:(NSData *)imageData fileName:(NSString *)fileName{

}


//上传图片存储地，存储同时并删除临时存储文件//yes 存，no，删除
-(void)updatePhotoSavefileName:(BOOL)bools fileName:(NSString *)fileName{

}
#pragma mark NETWORK_TYPE
+(NETWORK_TYPE)getNETWORKtype{
    NETWORK_TYPE networkType = NETWORK_TYPE_NONE;
    
    
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    switch (internetStatus) {
        case ReachableViaWiFi:
            networkType = NETWORK_TYPE_WIFI;
            break;
            
        case ReachableViaWWAN:
            networkType = NETWORK_TYPE_WWAN;
            break;
            
        case NotReachable:
            networkType = NETWORK_TYPE_NONE;
            
        default:
            break;
    }
    
    
//     NETWORK_TYPE __block  networkType = NETWORK_TYPE_NONE;
//    //1.创建网络状态监测管理者
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    //2.监听改变
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//
//                networkType = NETWORK_TYPE_NONE;
//
//                break;
//
//            case AFNetworkReachabilityStatusNotReachable:
//
//                networkType = NETWORK_TYPE_NONE;
//
//                break;
//
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//
//                networkType = NETWORK_TYPE_WWAN;
//
//                break;
//
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//
//                networkType = NETWORK_TYPE_WIFI;
//
//                break;
//
//            default:
//
//                break;
//
//        }
//        networkCallback(networkType);
//    }];
//
//    [manager startMonitoring];//开始监听
    
//    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
//                               CTRadioAccessTechnologyGPRS,
//                               CTRadioAccessTechnologyCDMA1x];
//
//    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
//                               CTRadioAccessTechnologyWCDMA,
//                               CTRadioAccessTechnologyHSUPA,
//                               CTRadioAccessTechnologyCDMAEVDORev0,
//                               CTRadioAccessTechnologyCDMAEVDORevA,
//                               CTRadioAccessTechnologyCDMAEVDORevB,
//                               CTRadioAccessTechnologyeHRPD];
//
//    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
//    // 该 API 在 iOS7 以上系统才有效
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
//        NSString *accessString = teleInfo.currentRadioAccessTechnology;
//        if ([typeStrings4G containsObject:accessString]) {
//            NSLog(@"4G网络");
//        } else if ([typeStrings3G containsObject:accessString]) {
//            NSLog(@"3G网络");
//        } else if ([typeStrings2G containsObject:accessString]) {
//            NSLog(@"2G网络");
//        } else {
//            NSLog(@"未知网络");
//        }
//    } else {
//        NSLog(@"未知网络");
//    }
    
    /////
//    UIApplication *application = [UIApplication sharedApplication];
//    if (IS_IPHONE_X_SCREEN) {
//        NSArray *subviews = [[[[application valueForKey:@"statusBar"] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
//        NSNumber *dataNetWorkItemView = nil;
//        for (id subView in subviews) {
//            for (id object in [subView subviews]) {
//                if ([object isKindOfClass:[NSClassFromString(@"_UIStatusBarWifiSignalView") class]]) {
//                    dataNetWorkItemView = subView;
//                    break;
//                }
//            }
//        }
//        if ([[dataNetWorkItemView valueForKey:@"visible"] boolValue]) {
//            networkType = NETWORK_TYPE_WIFI;
//        }else{
//            networkType = NETWORK_TYPE_WWAN;
//        }
//    }else{
//
//        NSArray *subviews = [[[application valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
//        NSNumber *dataNetWorkItemView = nil;
//        for (id subView in subviews) {
//            if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
//                dataNetWorkItemView = subView;
//                break;
//            }
//        }
//        switch ([[dataNetWorkItemView valueForKey:@"dataNetworkType"]integerValue]) {
//            case 0:
//
//                networkType = NETWORK_TYPE_NONE;
//                break;
//
//            case 1:
//
//                networkType = NETWORK_TYPE_WWAN;
//                break;
//
//            case 2:
//
//                networkType = NETWORK_TYPE_WWAN;
//                break;
//            case 3:
//
//                networkType = NETWORK_TYPE_WWAN;
//                break;
//            default:
//
//                networkType = NETWORK_TYPE_WIFI;
//                break;
//        }
//    }
   
    return networkType;

}

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma 匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[0123456789]+[0-9]{9}";//[0123456789] [34578]
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

#pragma 验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end
