//
//  OneUserViewController.m
//  mdb
//  我的页面
//  Created by 杜非 on 14/12/29.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//


#import "AppDelegate.h"
#import "BindingUserInfoViewController.h"
#import "CompressImage.h"
#import "Constants.h"
#import "FSCutViewController.h"
#import "GMDCircleLoader.h"
#import "HTTPManager.h"
#import "ImageCorpperViewController.h"
#import "LXActionSheet.h"
#import "MDB_ShareExstensionUserDefault.h"
#import "MDB_UserDefault.h"
#import "MyBrokeNewsViewController.h"
#import "MyCouponsViewController.h"
#import "MyInformViewController.h"
#import "MyShareViewController.h"
#import "MyhouseViewController.h"
#import "OneUserViewController.h"
#import "PushSetingViewControoler.h"
#import "RemarkViewController.h"
#import "MyGiftViewController.h"
#import "TaskHomeViewController.h"
#import "UITabBar+badge.h"
#import "VKLoginViewController.h"
#import "oneView.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "ZLJFeaturesGuideView.h"
//#import "JoinInActivityViewController.h"

//#import "OneUserView.h"

#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import "SettingViewController.h"
#import "InviteFriendViewController.h"
#import "BindingUserInfoViewController.h"
#import <UMAnalytics/MobClick.h>


#import "MyOrderMainViewController.h"

#import "MyJiangLiMainViewController.h"

#import "WoGuanZhuMainViewController.h"

#import "OneUserMainView.h"

static NSString * const kAliFeedbackAppKey = @"23342874";

@interface OneUserViewController ()

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
@property (nonatomic ,strong) UIView *leftRemindV;
@property (nonatomic ,strong) UIView *rightrRemindV;
@property (nonatomic ,strong) OneUserMainView *subView;
@property (nonatomic ,strong) NSString *commentnum;
@property (nonatomic ,strong) NSString *zannum;
@property (nonatomic ,strong) NSString *ordernum;
@property (nonatomic, strong) NSArray *showGuideElementRects;

@end

@implementation OneUserViewController{
    float  _ScrowContentOffSet;
    NSInteger needPhone;
    NSString *unreadCountStr;
    UIImageView *imagl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubView];
    [self setLeftBarButton];
    [self setRightBarButton];
    
    
    
    
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://p.mdbimg.com/share_201805_5aea6c13d7fc1hisqzm.jpg-dpdisplay1"]]];
//    NSError *error;
//    
//    NSURLResponse *response = nil;
//    
//    NSData *datat = [NSURLConnection sendSynchronousRequest:request
//                     
//                                          returningResponse:&response
//                     
//                                                      error:&error];
//    
//    NSLog(@"%@",error);
//    
//    NSString *strtemp = [[NSString alloc] initWithData:datat encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
//    
//    if(strtemp == nil)
//    {
//        strtemp = [[NSString alloc] initWithData:datat encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    
    if ([MDB_UserDefault getIsLogin]&&[MDB_UserDefault defaultInstance].usertoken!=nil) {
        [self getUserCont];
    }else{
        [MDB_UserDefault setNeedPhoneStatue:YES];
        [self.subView loadViewUI];
        
    }
    [self fetchUnreadCount];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}

- (void)setLeftBarButton{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-10];
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 56, 44)];
    UIView *leftRemindV = [[UIView alloc] initWithFrame:CGRectMake(52, 8, 8, 8)];
    leftRemindV.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
    leftRemindV.layer.cornerRadius = 4;
    leftRemindV.clipsToBounds = YES;
    leftRemindV.hidden = YES;
    [leftV addSubview: leftRemindV];
    _leftRemindV = leftRemindV;
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 44)];
    [butleft addTarget:self action:@selector(leftBarBut) forControlEvents:UIControlEventTouchUpInside];
    [butleft setImage:[UIImage imageNamed:@"setupBtn"] forState:UIControlStateNormal];
    [butleft setTitle:@"设置" forState:UIControlStateNormal];
    [butleft setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [butleft.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [butleft setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [leftV addSubview:butleft];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:leftV];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBar];
    
}

- (void)setRightBarButton{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-7];
    
    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 56, 44)];
    UIView *rightrRemindV = [[UIView alloc] initWithFrame:CGRectMake(52, 8, 8, 8)];
    rightrRemindV.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
    rightrRemindV.layer.cornerRadius = 4;
    rightrRemindV.clipsToBounds = YES;
    [rightV addSubview: rightrRemindV];
    rightrRemindV.hidden = YES;
    _rightrRemindV = rightrRemindV;
    
    UIButton *butright=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 44)];
    [butright addTarget:self action:@selector(rightBarClicked) forControlEvents:UIControlEventTouchUpInside];
    [butright setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [butright setTitle:@"消息" forState:UIControlStateNormal];
    [butright setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [butright.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [butright setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [butright setImageEdgeInsets:UIEdgeInsetsMake(0, 0, -1, 0)];
    
    [rightV addSubview:butright];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:rightV];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBar];
}

- (void)rightBarClicked{
    if ([MDB_UserDefault getIsLogin]) {
        [MobClick event:@"wode_xiaoxi"];
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyInformViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyInformViewC"];
        mybrokenews.commentnum = _commentnum;
        mybrokenews.zannum = _zannum;
        mybrokenews.orderunm = _ordernum;
        [self.navigationController pushViewController:mybrokenews animated:YES];

    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];

    }
    
}

- (void)leftBarBut{
    SettingViewController *settingVc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)setSubView{
    
    _subView = [[OneUserMainView alloc] init];
    [self.view addSubview:_subView];
    [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - OneUserViewDelegate
///我的奖励
-(void)subjectViewJiangLiAction
{
    
    if ([MDB_UserDefault getIsLogin]) {
        MyJiangLiMainViewController *mvc = [[MyJiangLiMainViewController alloc] init];
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        
    }
     
    
}

- (void)oneUserViewDidSelectInviteFriendCell{
    [MobClick event:@"wode_yaoqing"];
    InviteFriendViewController *inviteFridendVc = [[InviteFriendViewController alloc] init];
    [self.navigationController pushViewController:inviteFridendVc animated:YES];
}

- (void)clickTofeedbackKit{
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"个人中心->反馈",
                                 @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"systemVeriosn":[NSString getSystemName]};
    
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            [MDB_UserDefault showNotifyHUDwithtext:title inView:self.view];
        }
    }];

}

- (void)pushToPushSetingViewControoler:(UIViewController *)targatVc{
    [self.navigationController pushViewController:targatVc animated:YES];
}

- (void)clickToViewController:(UIViewController *)Vc{
    if ([Vc isKindOfClass:[VKLoginViewController class]]) {
//        VKLoginViewController *vkVc = (VKLoginViewController *)Vc;
//        vkVc.LoginViewDidConfi = ^() {
//            OneUserView *subView = [[OneUserView alloc] init];
//            subView.delegate = self;
//            [self.view addSubview:subView];
//            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(self.view);
//                make.top.equalTo(self.view).offset(64);
//            }];
//            _subView = subView;
//        };
    }
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)functionSelectbyButton:(UIButton *)btn{
    if (btn.tag == 100){
        [MobClick event:@"wode_dingdan"];
        
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyOrderMainViewController *myorder=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyorderViewC"];
        [self.navigationController pushViewController:myorder animated:YES];
    }
    else if (btn.tag == 101) {
        [MobClick event:@"wode_shoucang"];
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyhouseViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyhouseViewC"];
        [self.navigationController pushViewController:mybrokenews animated:YES];
    }else if (btn.tag == 102){
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyShareViewController *myshare=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyShareViewC"];
        [self.navigationController pushViewController:myshare animated:YES];
    }else if (btn.tag == 103){
        [MobClick event:@"wode_baoliao"];
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyBrokeNewsViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyBrokeNewsViewC"];
        [self.navigationController pushViewController:mybrokenews animated:YES];

    }else if (btn.tag == 104){
        [MobClick event:@"wode_youhuiquan"];
        UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        MyCouponsViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyCouponsVC"];
        [self.navigationController pushViewController:mybrokenews animated:YES];
    }
}

- (void)subjectViewShowGuideElementRects:(NSArray *)rects{
//    NSMutableArray *frames = [NSMutableArray arrayWithArray:rects];
//    [frames addObject:[NSValue valueWithCGRect:CGRectMake(kMainScreenW-66, 26, 63, 30)]];
//    if ([MDB_UserDefault getIsLogin]) {
//        _showGuideElementRects = rects;
//    }else{
//        NSArray *tips = @[@"爆料入口在这里哦~",
//                          @"我的消息和评论搬到这里了~"];
//        [ZLJFeaturesGuideView showGuideViewWithRects:frames.mutableCopy tips:tips];
//        [MDB_UserDefault setShowAppPersonalInfoGuide:YES];
//    }
}

- (void)subjectViewShowFansWithFollowGuideElementRects:(NSArray *)rects{
//    if ([MDB_UserDefault showAppPersonalInfoGuide]) {
//        [ZLJFeaturesGuideView showGuideViewWithRects:rects tips:@[@"这里可以查看粉丝和关注列表哦~"]];
//        [MDB_UserDefault setShowAppPersonalInfoFansGuide:YES];
//    }else{
//        NSMutableArray *rect = [NSMutableArray arrayWithArray:_showGuideElementRects];
//        [rect insertObject:rects.firstObject atIndex:1];
//        NSArray *tips = @[@"爆料入口在这里哦~",
//                          @"这里可以查看粉丝和关注列表哦~",
//                          @"我的消息和评论搬到这里了~"];
//        [ZLJFeaturesGuideView showGuideViewWithRects:rect.mutableCopy tips:tips];
//        [MDB_UserDefault setShowAppPersonalInfoGuide:YES];
//        [MDB_UserDefault setShowAppPersonalInfoFansGuide:YES];
//    }
}



-(void)getUserCont{
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"type":@"1"
                        };
    [HTTPManager sendRequestUrlToService:URL_usercenter withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        [GMDCircleLoader hideFromView:self.view animated:YES];
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                if ([dicAll objectForKey: @"data"]&&[[dicAll objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"telphone"]] forKey:@"cn.com.meidebi.www.user_telphone_key"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"emailcomfirm"]] forKey:@"cn.com.meidebi.www.user_emailcomfirm_key"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"username"]] forKey:@"cn.com.meidebi.www.user_name_key"];
                    
                    [[MDB_UserDefault defaultInstance]setisSignyes:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"isSign"]] coper:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"copper"]] name: [NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"name"]] nickName: [NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"nickname"]] coin:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"coins"]] fans:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"fansNum"]] follow:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"followNum"]] contribution:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"contribution"]] content:nil userPhoto:[[dicAll objectForKey:@"data"] objectForKey:@"headImgUrl"] userID:[[dicAll objectForKey:@"data"] objectForKey:@"userid"] balance:[[dicAll objectForKey:@"data"] objectForKey:@"balance"] commission_balance:[[dicAll objectForKey:@"data"] objectForKey:@"reward_balance"] goods_coupon_balance:[[dicAll objectForKey:@"data"] objectForKey:@"goods_coupon_balance"] is_set_pay_password:[[[dicAll objectForKey:@"data"] objectForKey:@"is_set_pay_password"] boolValue]];
                }
                
                needPhone = [NSString nullToString:dicAll[@"data"][@"needPhone"]].integerValue;
                [MDB_UserDefault setNeedPhoneStatue:needPhone==1?YES:NO];
                if ([[[dicAll objectForKey:@"data"] objectForKey:@"messagenum"] integerValue] >= 1 ||
                    [[[dicAll objectForKey:@"data"] objectForKey:@"votenum"] integerValue] >= 1 ||
                    [[[dicAll objectForKey:@"data"] objectForKey:@"commentnum"] integerValue] >= 1||
                    [[[dicAll objectForKey:@"data"] objectForKey:@"ordernum"] integerValue] >= 1) {
                    _rightrRemindV.hidden = NO;
                }else{
                    _rightrRemindV.hidden = YES;
                }
                
                
                
                
                _commentnum = [[dicAll objectForKey:@"data"] objectForKey:@"commentnum"];
                _zannum = [[dicAll objectForKey:@"data"] objectForKey:@"votenum"];
                _ordernum = [[dicAll objectForKey:@"data"] objectForKey:@"ordernum"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_commentnum] forKey:@"commentnum"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_zannum] forKey:@"votenum"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_ordernum] forKey:@"ordernum"];
                
                
                NSString *strmessag = [[dicAll objectForKey:@"data"] objectForKey:@"messagenum"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:strmessag] forKey:@"messagenum"];
                
                int itemo = _commentnum.intValue+_zannum.intValue+strmessag.intValue+_ordernum.intValue;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarnumessagenum" object:[NSString nullToString:[NSString stringWithFormat:@"%d",itemo]]];
                

            }
        }
        
        
        
        [self.subView loadViewUI];
    }];
}

#pragma mark -///降价通知
-(void)jiangjiatongzhiAction
{
    WoGuanZhuMainViewController *tvc = [[WoGuanZhuMainViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
    
}
/** 查询未读数 */
- (void)fetchUnreadCount {
//    __weak typeof(self) weakSelf = self;
    [self.feedbackKit getUnreadCountWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
        unreadCountStr = nil;
        if (error == nil) {
            if (unreadCount > 0) {
                unreadCountStr = [NSString stringWithFormat:@"%ld", (long)unreadCount];
            }
        }else {
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            NSLog(@"%@",title);
        }
//        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
//        [weakSelf.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
}

//- (void)enterBindingVc{
//    [MDB_UserDefault setIsUserInfoLogin:NO];
//    [MDB_UserDefault setThirdPartyLoginSuccess:NO];
//     BindingUserInfoViewController *bindingUserInfoVc = [[BindingUserInfoViewController alloc] init];
//    [self.navigationController pushViewController:bindingUserInfoVc
//                                         animated:NO];
//}
//
//#pragma mark- headphotoUpload
//-(void)headTap{
//    if ([MDB_UserDefault defaultInstance].usertoken) {
//        LXActionSheet *lxsheet=[[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
//        [lxsheet showInView:self.tabBarController.view];
//    }
//
//}
//- (void)didClickOnButtonIndex:(NSInteger )buttonIndex{
//    UIImagePickerController * Imagepicker = [[UIImagePickerController alloc] init] ;
//    Imagepicker.delegate=self;
//    if (buttonIndex==0) {
//
//        //拍照
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            Imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self presentViewController:Imagepicker animated:YES completion:nil];
//        }else{
//
//        }
//    }else if (buttonIndex==1){
//
//        //从手机相册选择
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//            Imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentViewController:Imagepicker animated:YES completion:nil];
//        }else{
//
//        }
//    }
//}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    ImageCorpperViewController *imgCor=[[ImageCorpperViewController alloc] initWithNibName:nil bundle:nil];
//    imgCor.img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    imgCor.delegate=self;
//    [picker pushViewController:imgCor animated:YES];
//}
//
//-(void)loadimvImage:(UIImage *)image{
//    MDB_UserDefault *_userdefault=[MDB_UserDefault defaultInstance];
//    UIImage *img= [MDB_UserDefault imageWithImage:image scaledToSize:CGSizeMake(200.0 *kScale, image.size.height*200.0/image.size.width *kScale)];
//
//    NSData *data = UIImagePNGRepresentation(img);
//    NSMutableData *imageData = [NSMutableData dataWithData:data];
//    NSString* urlString = Customer_avatar;
//    NSDictionary *dics=@{@"devicetype":@"1",@"userkey":[NSString nullToString:_userdefault.usertoken]};
//
//    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
//    if (IOS_VERSION_8_OR_ABOVE) {
//    [HTTPManager sendRequestUrlToService:urlString withParametersDictionry:dics fileDate:imageData name:@"zxzpic.png" filename:@"zxzpic.png" mimeType:@"image/png" completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
//        if (responceObjct) {
//            [GMDCircleLoader hideFromView:self.view animated:YES];
//            if ([[NSString stringWithFormat:@"%@",[responceObjct objectForKey:@"status"]] integerValue]&&[responceObjct objectForKey:@"info"]&&[[responceObjct objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
//                [MDB_UserDefault showNotifyHUDwithtext:@"恭喜,上传成功" inView:self.navigationController.view];
//                [_subView setUpImageV:img];
//                [_userdefault clearTmpPic:_userdefault.userphoto];
//                [_userdefault setUserPhoto:[responceObjct objectForKey:@"data"]];
//
//            }else{
//                [MDB_UserDefault showNotifyHUDwithtext:@"上传失败了" inView:self.navigationController.view];
//            }
//        }else{
//            [GMDCircleLoader hideFromView:self.view animated:YES];
//            [MDB_UserDefault showNotifyHUDwithtext:@"上传失败了" inView:self.navigationController.view];
//        }
//    }];
//    }else{
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
//
//        [manager POST:urlString parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            [formData appendPartWithFileData:data name:@"zxzpic.png" fileName:@"zxzpic.png" mimeType:@"image/png"];
//        } success:^(AFHTTPRequestOperation *operation,id responseObject) {
//            [GMDCircleLoader hideFromView:self.view animated:YES];
//           if (responseObject) {
//               if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] integerValue]&&[responseObject objectForKey:@"info"]&&[[responseObject objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
//            [MDB_UserDefault showNotifyHUDwithtext:@"恭喜,上传成功" inView:self.navigationController.view];
//            [_subView setUpImageV:img];
//            [_userdefault clearTmpPic:_userdefault.userphoto];
//            [_userdefault setUserPhoto:[responseObject objectForKey:@"data"]];
//               }
//           }
//        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
//            [GMDCircleLoader hideFromView:self.view animated:YES];
//
//        }];
//    }
//}
//-(void)setNametitle{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (needPhone == 1 && ([MDB_UserDefault getThirdPartyLoginSuccess] && [MDB_UserDefault getIsUserInfoLogin])) {
//            [self enterBindingVc];
//        }
//    });
//    if (needPhone == 0) {
//        NSArray *array = @[@"做任务换豪礼",@"我的礼品"];
//        [tabletileArr replaceObjectAtIndex:0 withObject:array];
//        CGRect tableFrame = _tableview.frame;
//        tableFrame.size.height = 44*8+19*2;
//        [_tableview setFrame:tableFrame];
//         NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:0];
//        [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//
//    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
//    [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//
//
//    MDB_UserDefault *_userDefault=[MDB_UserDefault defaultInstance];
//
//   [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:_userDefault.userphoto] placeholder:[UIImage imageNamed:@"noavatar.png"] UIimageview:_headImv];
//
//    _hellotitle.hidden=YES;
//    _weidengtitle.hidden=YES;
//
//    float centX=CGRectGetWidth(self.view.frame);
//    CGSize nameSize=[MDB_UserDefault getStrWightFont:[UIFont systemFontOfSize:15.0] str:_userDefault.userName hight:18.0];
//    if (_nametitle) {
//        [_nametitle setHidden:NO];
//        if (![_userDefault.userName isKindOfClass:[NSNull class]]) {
//            _nametitle.text=_userDefault.userName;
//        }
//        _nametitle.frame=CGRectMake((centX-nameSize.width)/2.0-10.0, 100.0, nameSize.width, 18.0);
//    }else{
//        _nametitle=[[UILabel alloc]initWithFrame:CGRectMake((centX-nameSize.width)/2.0-10.0, 100.0, nameSize.width, 18.0)];
//        _nametitle.font=[UIFont systemFontOfSize:15.0];
//        [_nametitle setTextColor:RGB(230.0, 230.0, 230.0)];
//        if (![_userDefault.userName isKindOfClass:[NSNull class]]) {
//            _nametitle.text=_userDefault.userName;
//        }
//        [_scrollView addSubview:_nametitle];
//    }
//
//    if (_levImgeV) {
//        [_levImgeV setHidden:NO];
//        _levImgeV.frame=CGRectMake((centX-nameSize.width)/2.0-10.0+nameSize.width+2.0, 100.0, 18.0, 18.0);
//    }else{
//        _levImgeV=[[UIImageView alloc]initWithFrame:CGRectMake((centX-nameSize.width)/2.0-10.0+nameSize.width+2.0, 100.0, 18.0, 18.0)];
//        _levImgeV.image=[UIImage imageNamed:@"dengji.jpg"];
//            [_scrollView addSubview:_levImgeV];
//    }
//    if (_jifen) {
//        [_jifen setHidden:NO];
//    }else{
//    _jifen=[[UILabel alloc]initWithFrame:CGRectMake(centX/2.0-65.0,125.0 , 40.0, 18.0)];
//    _jifen.text=@"积分:";
//    [_jifen setTextColor:RGB(230.0, 230.0, 230.0)];
//        [_scrollView addSubview:_jifen];
//    }
//
//    if (_tongbi) {
//        [_tongbi setHidden:NO];
//    }else{
//        _tongbi=[[UILabel alloc]initWithFrame:CGRectMake(centX/2.0+15, 125.0, 60.0, 18.0)];
//        _tongbi.text=@"铜币:";
//        [_tongbi setTextColor:RGB(230.0, 230.0, 230.0)];
//        [_scrollView addSubview:_tongbi];
//    }
//
//    if (_jifencount) {
//        [_jifencount setHidden:NO];
//        _jifencount.text=_userDefault.userjifen;
//    }else{
//
//        _jifencount=[[UILabel alloc]initWithFrame:CGRectMake(centX/2.0-25.0,127.0 , 40.0, 16.0)];
//        if (![_userDefault.userjifen isKindOfClass:[NSNull class]]) {
//            _jifencount.text=_userDefault.userjifen;
//
//            CGSize sizel=[MDB_UserDefault getStrWightFont:[UIFont systemFontOfSize:14.0] str:_jifencount.text hight:16.0];
//            if (sizel.width>40.0) {
//                float withll=sizel.width-40.0;
//                [_jifencount setFrame:CGRectMake(centX/2.0-25.0-withll, 127.0, sizel.width, 16.0)];
//                [_jifen setFrame:CGRectMake(centX/2.0-65.0-withll,125.0 , 40.0, 18.0)];
//            }else{
//                [_jifencount setFrame:CGRectMake(centX/2.0-25.0, 127.0,40.0, 16.0)];
//                [_jifen setFrame:CGRectMake(centX/2.0-65.0,125.0 , 40.0, 18.0)];
//            }
//        }
//        [_jifencount setTextColor:RGB(230.0, 230.0, 230.0)];
//        _jifencount.font=[UIFont systemFontOfSize:14.0];
//        [_scrollView addSubview:_jifencount];
//    }
//
//    if (_tongbicount) {
//        [_tongbicount setHidden:NO];
//        if (![_userDefault.usercoper isKindOfClass:[NSNull class]]) {
//            _tongbicount.text=_userDefault.usercoper;
//        }
//    }else{
//        _tongbicount=[[UILabel alloc]initWithFrame:CGRectMake(centX/2.0+55.0, 127.0, 80.0, 16.0)];
//            if (![_userDefault.usercoper isKindOfClass:[NSNull class]]) {
//                _tongbicount.text=_userDefault.usercoper;
//            }
//        [_tongbicount setTextColor:RGB(230.0, 230.0, 230.0)];
//        _tongbicount.font=[UIFont systemFontOfSize:14.0];
//    }
//
//
//    if (_levtitle) {
//        [_levtitle setHidden:NO];
//        if (![_userDefault.userlevel isKindOfClass:[NSNull class]]) {
//            _levtitle.text=_userDefault.userlevel;
//        }
//    }else{
//        _levtitle=[[UILabel alloc]initWithFrame:CGRectMake(8.0, 9.0, 10.0, 9.0)];
//        _levtitle.font=[UIFont systemFontOfSize:8.0];
//        [_levtitle setTextAlignment:NSTextAlignmentCenter];
//            if (![_userDefault.userlevel isKindOfClass:[NSNull class]]) {
//                _levtitle.text=_userDefault.userlevel;
//            }
//        _levtitle.textColor=[UIColor whiteColor];
//        [_levImgeV addSubview:_levtitle];
//            [_scrollView addSubview:_tongbicount];
//    }
//    [_loadBut setTitle:@"签到已搬迁至福利频道" forState:UIControlStateNormal];
//
//    [self setONloadBut];
//
//}
//

//-(void)onloadbutAction{
//    if ([MDB_UserDefault defaultInstance].usertoken) {
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"您确定要退出登录吗？"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"确定", nil];
//        [alertView setTag:1000];
//        [alertView show];
//    }
//}
//-(void)loadbutAction{
//    if ([MDB_UserDefault defaultInstance].usertoken) {
//        [self.tabBarController setSelectedIndex:2];
//    }else{
//        [MDB_UserDefault setIsUserInfoLogin:YES];
//        [self intoLoginVC];
//    }
//}


- (void)intoLoginVC{
    VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
    [self.navigationController pushViewController:theViewController animated:YES ];
}


//- (void)oneView{
//    if ([MDB_UserDefault getMessage]) {
//        _oneView.yuanviewl.hidden=NO;
//    }else{
//        _oneView.commentWarningView.hidden = YES;
//    }
//    if ([MDB_UserDefault getComment]) {
//        _oneView.commentWarningView.hidden = NO;
//    }else{
//        _oneView.commentWarningView.hidden = YES;
//    }
//
//    if (![MDB_UserDefault getMessage] && ![MDB_UserDefault getComment]) {
//        _oneView.yuanviewl.hidden=YES;
//        _oneView.commentWarningView.hidden = YES;
//        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:4];
//    }
//
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     if(alertView.tag==111||alertView.tag==110 || alertView.tag == 120 || alertView.tag == 111){
        if (buttonIndex==0) {
            if(alertView.tag == 120) [MDB_UserDefault setIsUserInfoLogin:YES];
            VKLoginViewController *vkVC = [[VKLoginViewController alloc] init];
            [self clickToViewController:vkVC];
        }
    }

}



//#pragma mark onesview Delegate
//-(void)butSelect:(NSInteger)index{
//    if (![MDB_UserDefault getIsLogin]){
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"请登录后再试"
//                                                       delegate:self
//                                              cancelButtonTitle:Nil
//                                              otherButtonTitles:@"登录",@"取消", nil];
//    [alertView setTag:110];
//    [alertView show];
//
//    }else{
//    switch (index) {
//        case 0:
//        {
//            [self intoBrokeNews];
//         }   break;
//        case 1:
//        {
//            UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
//            MyShareViewController *myshare=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyShareViewC"];
//            [self.navigationController pushViewController:myshare animated:YES];
//        }   break;
//        case 2:
//        {
//            UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
//            MyCouponsViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyCouponsVC"];
//            [self.navigationController pushViewController:mybrokenews animated:YES];
//        }   break;
//        case 3:
//        {
//            UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
//            MyhouseViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyhouseViewC"];
//            [self.navigationController pushViewController:mybrokenews animated:YES];
//        }   break;
//        case 4:
//        {
//            UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
//            MyInformViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyInformViewC"];
//            [self.navigationController pushViewController:mybrokenews animated:YES];
//        }   break;
//        case 5:
//        {
//            RemarkViewController *remarkVc = [[RemarkViewController alloc] init];
//            [self.navigationController pushViewController:remarkVc animated:YES];
//        }   break;
//
//        default:
//            break;
//        }
//    }
//}
//
- (void)intoBrokeNews{
    UIStoryboard *OnesStroy=[UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
    MyBrokeNewsViewController *mybrokenews=[OnesStroy instantiateViewControllerWithIdentifier:@"com.mdb.MyBrokeNewsViewC"];
    [self.navigationController pushViewController:mybrokenews animated:YES];
}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//-(UIView *)titleView{
//
//    UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
//    UILabel *labes=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
//    labes.text=@"个人中心";
//    labes.textColor=[UIColor blackColor];
//    labes.textAlignment=NSTextAlignmentCenter;
//    [vies addSubview:labes];
//    return vies;
//}
//
//- (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
//{
//    NSDate * ValueDate = serverDate;
//    //现在的时间
//    NSDate * nowDate = endDate;
//    //计算两个中间差值(秒)
//    NSTimeInterval time = [nowDate timeIntervalSinceDate:ValueDate];
//    //开始时间和结束时间的中间相差的时间
//    int days;
//    days = ((int)time)/(3600*24);  //一天是24小时*3600秒
//    return (NSInteger)days;
//}
//
////字符串转日期
//- (NSDate *)StringTODate:(NSString *)sender
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"YYYY-MMMM-dd HH:mm:ss";
//    [dateFormatter setMonthSymbols:[NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil]];
//    NSDate * ValueDate = [dateFormatter dateFromString:sender];
//    return ValueDate;
//}
//
//#pragma mark Uitableview Delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return tabletileArr.count;
//}
////每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0;
//}
//
////每个section底部标题高度（实现这个代理方法后前面 sectionHeaderHeight 设定的高度无效）
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section < 2) {
//        return 19;
//    }else{
//        return 0;
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return [tabletileArr[section] count];
//
//}
////改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}
////绘制Cell
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
//                             SimpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier: SimpleTableIdentifier];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//
//        UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, cellHigh-1, _scrollView.frame.size.width, 1)];
//        [vies setBackgroundColor:RadLineColor];
//        [cell addSubview:vies];
//
//
//        UILabel *labels=[[UILabel alloc]init];
//        [labels setTextColor:RadCellBiaoColor];
//        labels.tag = 11;
//        [cell addSubview:labels];
//        [labels mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cell.mas_left).offset(15);
//            make.centerY.equalTo(cell.mas_centerY);
//        }];
//
//        float scoWithfloat=_scrollView.frame.size.width-65;
//        UISwitch *swiths=[[UISwitch alloc]initWithFrame:CGRectMake(scoWithfloat, 5, 80, cellHigh-10)];
//        swiths.on=[[MDB_UserDefault defaultInstance]getPicMode_switch];
//        [swiths addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
//        swiths.tag=401;
//        swiths.hidden = YES;
//        [cell addSubview:swiths];
//
//        UILabel *labl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tableView.frame)-97, 10, 80, cellHigh-20)];
//        labl.tag=233;
//        labl.textAlignment = NSTextAlignmentRight;
//        [labl setTextColor:RadshuziColor];
//        [cell addSubview:labl];
//
//        UIView *flagView = [[UIView alloc] init];
//        flagView.backgroundColor = [UIColor redColor];
//        flagView.tag = 100;
//        flagView.layer.masksToBounds = YES;
//        flagView.layer.cornerRadius = 4;
//        [cell addSubview:flagView];
//        [flagView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(labels.mas_top).offset(3);
//            make.left.equalTo(labels.mas_right).offset(5);
//            make.size.mas_equalTo(CGSizeMake(8, 8));
//        }];
//
//        UIButton *budingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cell addSubview:budingBtn];
//        [budingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(cell.mas_centerY);
//            make.right.equalTo(cell.mas_right).offset(-17);
//            make.size.mas_equalTo(CGSizeMake(71, 26));
//        }];
//        budingBtn.layer.masksToBounds = YES;
//        budingBtn.layer.cornerRadius = 13.f;
//        budingBtn.layer.borderWidth = 1.f;
//        budingBtn.layer.borderColor = [UIColor colorWithHexString:@"#FD7A0E"].CGColor;
//        budingBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        budingBtn.tag = 110;
//        [budingBtn addTarget:self action:@selector(respondsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
//
//
//        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, 1)];
//        [lineView setBackgroundColor:RadLineColor];
//        [lineView setTag:300];
//        [cell addSubview:lineView];
//
//
//        UIButton *promptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cell addSubview:promptBtn];
//        [promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(cell.mas_centerY);
//            make.left.equalTo(labels.mas_right).offset(8);
//            make.size.mas_equalTo(CGSizeMake(100, 26));
//        }];
//        [promptBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
//        [promptBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD7A0E"]];
//        [promptBtn setTitle:@"该更新关键词了" forState:UIControlStateNormal];
//        promptBtn.layer.masksToBounds = YES;
//        promptBtn.layer.cornerRadius = 13.f;
//        budingBtn.layer.borderWidth = 1.f;
//        promptBtn.layer.borderColor = [UIColor colorWithHexString:@"#FD7A0E"].CGColor;
//        promptBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        promptBtn.tag = 200;
//        [promptBtn addTarget:self action:@selector(respondsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
//
//        UIButton *unreadCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cell addSubview:unreadCountBtn];
//        [unreadCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(cell.mas_centerY);
//            make.left.equalTo(labels.mas_right).offset(8);
//            make.height.offset(15);
//        }];
//        [unreadCountBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
//        [unreadCountBtn setUserInteractionEnabled:NO];
//        [unreadCountBtn setBackgroundColor:[UIColor redColor]];
//        unreadCountBtn.layer.masksToBounds = YES;
//        unreadCountBtn.layer.cornerRadius = 7.5f;
//        unreadCountBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        unreadCountBtn.tag = 220;
//
//
//    }
//    UIView *lineView = (UIView *)[cell viewWithTag:300];
//    lineView.hidden = YES;
//    if (indexPath.row==0) {
//        lineView.hidden = NO;
//    }
//
//    UILabel *labels = (UILabel *)[cell viewWithTag:11];
//    labels.text = [NSString stringWithFormat:@"%@",tabletileArr[indexPath.section][indexPath.row]];
//
//
//    UISwitch *swith = (UISwitch *)[cell viewWithTag:401];
//    swith.hidden = YES;
//
//    UILabel *labl = (UILabel *)[cell viewWithTag:233];
//    labl.hidden = YES;
//
//    UIView *flagView = (UIView *)[cell viewWithTag:100];
//    flagView.hidden = YES;
//
//    UIButton *budingBtn = (UIButton *)[cell viewWithTag:110];
//    budingBtn.hidden = YES;
//
//    UIButton *promptBtn = (UIButton *)[cell viewWithTag:200];
//    promptBtn.hidden = YES;
//
//    UIButton *unreadCountBtn = (UIButton *)[cell viewWithTag:220];
//    unreadCountBtn.hidden = YES;
//
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.userInteractionEnabled = YES;
//
//    switch (indexPath.section) {
//        case 0:
//        {
//            if ([tabletileArr[indexPath.section] count] > 2) {
//                if (indexPath.row == 0) {
//                    budingBtn.hidden = NO;
//                    if (needPhone == 1) {
//                        flagView.hidden = NO;
//                        [budingBtn setTitle:@"300铜币" forState:UIControlStateNormal];
//                        [budingBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
//                        [budingBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD7A0E"]];
//                    }else{
//                        [budingBtn setTitle:@"已绑定" forState:UIControlStateNormal];
//                        [budingBtn setTitleColor:[UIColor colorWithHexString:@"#FD7A0E"] forState:UIControlStateNormal];
//                        [budingBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
//                    }
//                }else if (indexPath.row == 1){
//                    if (![MDB_UserDefault clickTaskStatue]) {
//                        flagView.hidden = NO;
//                    }
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                }else if (indexPath.row == 2){
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                }
//            }else{
//                if (indexPath.row == 0) {
//                    if (![MDB_UserDefault clickTaskStatue]) {
//                        flagView.hidden = NO;
//                    }
//                }
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
//        }
//            break;
//        case 1:
//        {
//            if (indexPath.row==0) {
//                if (([self getDaysFrom:[MDB_UserDefault pushKeywordsDate] To:[NSDate date]]>=14) && [MDB_UserDefault pushKeywordsStatue]) {
//                    promptBtn.hidden = NO;
//                }
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }else if (indexPath.row == 1){
//                swith.hidden = NO;
//            }else if (indexPath.row == 2){
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    float tmpSize=[[MDB_UserDefault defaultInstance] checkTmpSize];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        labl.hidden = NO;
//                        labl.text=[NSString stringWithFormat:@"%.2f M",tmpSize];
//                    });
//                });
//            }
//        }
//            break;
//        case 2:
//        {
//            if (indexPath.row==2) {
//                labl.hidden = NO;
//                NSString *appVersion =[[MDB_UserDefault defaultInstance] applicationVersion];
//                labl.text=[NSString stringWithFormat:@"Ver.%@",appVersion];
//                if (_needUpdate) {
//                    flagView.hidden = NO;
//                    cell.userInteractionEnabled = YES;
//                }else{
//                    cell.userInteractionEnabled = NO;
//                }
//
//            }else if(indexPath.row == 1){
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                if (unreadCountStr) {
//                    unreadCountBtn.hidden = NO;
//                    [unreadCountBtn setTitle:unreadCountStr forState:UIControlStateNormal];
//                }
//            }else{
//                labl.hidden = YES;
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
//        }
//            break;
//
//        default:
//            break;
//    }
//
//    return cell;
//}
//-(void)PicMode_switched:(UISwitch *)sender{
//    if (sender.tag==401) {
//          BOOL boos=sender.isOn;
//         [[MDB_UserDefault defaultInstance] setPicMode_swithc:boos];
//    }
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.section) {
//        case 0:
//        {
//
//            if ([tabletileArr[indexPath.section] count] > 2) {
//                if (indexPath.row == 0) {
//                    if (needPhone == 1) {
//                        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                        [self respondsToButtonEvents:(UIButton *)[cell viewWithTag:110]];
//                    }
//                }else if (indexPath.row == 1){
//                    TaskHomeViewController *taskHomeVc = [[TaskHomeViewController alloc] init];
//                    [self.navigationController pushViewController:taskHomeVc animated:YES];
//                }else if (indexPath.row == 2){
//                    MyGiftViewController *giftVc = [[MyGiftViewController alloc] init];
//                    [self.navigationController pushViewController:giftVc animated:YES];
//                }
//            }else{
//                if (indexPath.row == 0){
//                    TaskHomeViewController *taskHomeVc = [[TaskHomeViewController alloc] init];
//                    [self.navigationController pushViewController:taskHomeVc animated:YES];
//                }else if (indexPath.row == 1){
//                    MyGiftViewController *giftVc = [[MyGiftViewController alloc] init];
//                    [self.navigationController pushViewController:giftVc animated:YES];
//                }
//            }
//
//        }
//            break;
//        case 1:
//        {
//            if (indexPath.row==0) {
//                UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
//                if (types==UIUserNotificationTypeNone) {
//                    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                                  message:@"请到设置->通知中心->没得比开启推送服务!"
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"好"
//                                                        otherButtonTitles:nil];
//                    [alert show];
//                    return;
//                }
//
//                [MDB_UserDefault setPushKeywordsDate:[NSDate date]];
//                UIStoryboard *Oneselfboard = [UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
//                PushSetingViewControoler *signVc=[Oneselfboard instantiateViewControllerWithIdentifier:@"com.mdb.SignVC"];
//                [self.navigationController pushViewController:signVc animated:YES];
//            }
//
//            if (indexPath.row==2) {
//                [[MDB_UserDefault defaultInstance] clearTmpPics];
//                [MDB_UserDefault showNotifyHUDwithtext:@"已清空" inView:self.view];
//                [tableView reloadData];
//            }
//        }
//            break;
//        case 2:
//        {
//            if (indexPath.row == 0) {
//                if(IOS_VERSION_7_OR_ABOVE){//7.0-7.0.6只会跳到下载页，共用一套评价链接
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=659197645"]];
//                }else if (IOS_VERSION_11_OR_ABOVE){
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id659197645?mt=8"]];
//                }else{
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=659197645"]];
//                }
//            }
//
//            if (indexPath.row == 1) {
//
//                /** 设置App自定义扩展反馈数据 */
//                self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
//                                             @"visitPath":@"个人中心->反馈",
//                                             @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
//                                             @"systemVeriosn":[NSString getSystemName]};
//
//                __weak typeof(self) weakSelf = self;
//                [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
//                    if (viewController != nil) {
//                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//                        [weakSelf presentViewController:nav animated:YES completion:nil];
//                        [viewController setCloseBlock:^(UIViewController *aParentController){
//                            [aParentController dismissViewControllerAnimated:YES completion:nil];
//                        }];
//                    } else {
//                        /** 使用自定义的方式抛出error时，此部分可以注释掉 */
//                        NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
//                        [MDB_UserDefault showNotifyHUDwithtext:title inView:self.view];
//                    }
//                }];
//
//            }
//            if (indexPath.row == 2) {
//                NSString *appStoreLink = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",@"659197645"];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
//            }
//
//
//        }
//            break;
//
//        default:
//            break;
//    }
//
//
//}

//- (void)respondsToButtonEvents:(id)sender{
//    UIButton *btn = (UIButton *)sender;
//    switch (btn.tag) {
//        case 110:
//        {
//            if (needPhone==0) return;
//            if (![MDB_UserDefault getIsLogin]){
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                    message:@"请登录后再试"
//                                                                   delegate:self
//                                                          cancelButtonTitle:nil
//                                                          otherButtonTitles:@"登录",@"取消", nil];
//                [alertView setTag:120];
//                [alertView show];
//                
//            }else{
//                [MDB_UserDefault setIsUserInfoLogin:YES];
//                BindingUserInfoViewController *bindingUserInfoVc = [[BindingUserInfoViewController alloc] init];
//                [self.navigationController pushViewController:bindingUserInfoVc
//                                                     animated:YES];
//            }
//
//        }
//            break;
//        case 200:
//        {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//            [self tableView:_tableview didSelectRowAtIndexPath:indexPath];
//        }
//            break;
//        default:
//            break;
//    }
//    
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    _ScrowContentOffSet=scrollView.contentOffset.y;
//    if (_ScrowContentOffSet>0) {
//    }else if(_ScrowContentOffSet<0){
//
//        float floffset=scrollView.contentOffset.y*1.3;
//
//        imagl.frame=CGRectMake(floffset, _ScrowContentOffSet, self.view.frame.size.width-floffset*2.0, 225.0-scrollView.contentOffset.y);
//
//
//    }if (_ScrowContentOffSet==0&&scrollView.contentOffset.y!=0) {
//
//       // [UIView animateWithDuration:(_ScrowContentOffSet-scrollView.contentOffset.y)/50.0 animations:^{
//            imagl.frame=CGRectMake(0 , 0, self.view.frame.size.width, 225.0);
//       // }];
//    }else if(_ScrowContentOffSet==0){
//
//        imagl.frame=CGRectMake(0 , 0, self.view.frame.size.width, 225.0);
//
//    }
//
//
//
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    _ScrowContentOffSet=scrollView.contentOffset.y;
//
//}

#pragma mark - setters and getters
- (YWFeedbackKit *)feedbackKit{
    if (!_feedbackKit) {
      _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAliFeedbackAppKey];
    }
    return _feedbackKit;
}


@end
