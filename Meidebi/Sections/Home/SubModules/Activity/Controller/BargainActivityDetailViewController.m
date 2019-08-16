//
//  BargainActivityDetailViewController.m
//  Meidebi
//
//  Created by leecool on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainActivityDetailViewController.h"
#import "BargainActivityDetailSubjectView.h"
#import "BargainActivityDataController.h"
#import "VKLoginViewController.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
#import "BargainRankViewController.h"
#import "BargainRecordViewController.h"
#import "AddressListViewController.h"
#import "MDBShareActionSheet.h"
#import "UIImage+Extensions.h"
#import "ShareModel.h"
#import "ProductInfoViewController.h"
#import "SVModalWebViewController.h"
//shareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface BargainActivityDetailViewController ()
<
MDBShareActionSheetDelegate,
BargainActivityDetailSubjectViewDelegate
>
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) BargainActivityDetailSubjectView *subjectView;
@property (nonatomic, strong) BargainActivityDataController *datacontroller;
@end

@implementation BargainActivityDetailViewController
- (instancetype)initWithBargainItemID:(NSString *)itemID{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _itemID = itemID;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [self setupRightBarButton];
    _subjectView = [BargainActivityDetailSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupRightBarButton{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [shareBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareItem;
}

- (void)shareBtnClicked:(UIButton *)sender{
    [self bargainActivityDetailSubjectViewDidClickShareBtn:_itemID];
}

- (void)loadData{
    [self.datacontroller requestActivityItemDetailWithID:_itemID targetView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
             _activityID = [NSString nullToString:self.datacontroller.resultDict[@"activiti_id"]];
            [_subjectView bindDataWithModel:self.datacontroller.resultDict];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
}

- (void)shareChannelType:(MDBShareType)channel{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    SSDKPlatformType platformType;
    switch (channel) {
        case MDBShareTypeWeChat:
        {
            platformType = SSDKPlatformSubTypeWechatSession;
        }
            break;
            
        case MDBShareTypeWeMoments:
        {
            platformType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
            
        case MDBShareTypeQQ:
        {
            platformType = SSDKPlatformSubTypeQQFriend;
        }
            break;
            
        case MDBShareTypeSpace:
        {
            platformType = SSDKPlatformSubTypeQZone;
        }
            break;
            
        case MDBShareTypeSinaWeibo:
        {
            platformType = SSDKPlatformTypeSinaWeibo;
        }
            break;
            
        case MDBShareTypeTencentWeibo:
        {
            platformType = SSDKPlatformTypeTencentWeibo;
        }
            break;
        default:
            break;
    }
    ShareModel *model = [ShareModel modelWithDict:self.datacontroller.resultShareInfoDict];
    UIImage *image=_subjectView.activityImage;
    if (!model || !image) return;
    [shareParams SSDKSetupShareParamsByText:model.content
                                     images:@[image]
                                        url:[NSURL URLWithString:model.url]
                                      title:model.title
                                       type:SSDKContentTypeAuto];
    
    NSString *shareStr = [NSString stringWithFormat:@"%@ %@%@",model.title,model.content,model.url];
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:shareStr title:nil image:@[image] url:[NSURL URLWithString:model.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    ///分享更改
    [shareParams SSDKSetupSinaWeiboShareParamsByText:shareStr title:nil images:@[image] video:nil url:[NSURL URLWithString:model.url] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    
    
    [shareParams SSDKSetupTencentWeiboShareParamsByText:shareStr images:@[image] latitude:0 longitude:0 type:SSDKContentTypeAuto];
//    [shareParams SSDKSetupWeChatParamsByText:model.content title:[NSString stringWithFormat:@"%@%@",model.title,model.content] url:[NSURL URLWithString:model.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    ///分享更改
    [shareParams SSDKSetupWeChatParamsByText:model.content title:[NSString stringWithFormat:@"%@%@",model.title,model.content] url:[NSURL URLWithString:model.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    //进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
     }];
    
}


#pragma mark - BargainActivityDetailSubjectViewDelegate
- (void)bargainActivityDetailSubjectViewDidClickParticipationBtn:(NSString *)itemID{
    if ([MDB_UserDefault getIsLogin]) {
        [self.datacontroller requestParticipationActivityWithID:itemID targetView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                [MDB_UserDefault showNotifyHUDwithtext:@"参与成功！" inView:self.view];
                [self loadData];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }];
    }else{
        VKLoginViewController *vc = [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)bargainActivityDetailSubjectViewDidClickBargainBtn:(NSString *)itemID{
    if (![MDB_UserDefault defaultInstance].userID) {
        [self getUserCont:^(BOOL state) {
            if (state) {
                [self.datacontroller requestBargainSelfActivityWithID:itemID
                                                           targetView:self.view
                                                             callback:^(NSError *error, BOOL state, NSString *describle) {
                                                                 if (state) {
                                                                     [MDB_UserDefault showNotifyHUDwithtext:@"比的就是速度！快喊小伙伴来帮忙吧。" inView:self.view];
                                                                     [self loadData];
                                                                 }else{
                                                                     [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                                                 }
                }];
            }
        }];
    }else{
        [self.datacontroller requestBargainSelfActivityWithID:itemID
                                                   targetView:self.view
                                                     callback:^(NSError *error, BOOL state, NSString *describle) {
                                                         if (state) {
                                                             [MDB_UserDefault showNotifyHUDwithtext:@"比的就是速度！快喊小伙伴来帮忙吧。" inView:self.view];
                                                             [self loadData];
                                                         }else{
                                                             [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                                         }
                                                     }];
    }
}

- (void)bargainActivityDetailSubjectViewDidClickRankBtn:(NSString *)itemID{
    BargainRankViewController *vc = [[BargainRankViewController alloc] initWithBargainItemID:itemID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bargainActivityDetailSubjectViewDidClickRecordBtn:(NSString *)itemID{
    BargainRecordViewController *vc = [[BargainRecordViewController alloc] initWithBargainItemID:itemID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bargainActivityDetailSubjectViewDidClickShareBtn:(NSString *)itemID{
    [self.datacontroller requestShareBargainActivityWithID:_activityID
                                                       cID:itemID
                                                targetView:self.view
                                                  callback:^(NSError *error, BOOL state, NSString *describle) {
                                                      if (state) {
                                                          MDBShareActionSheet *actionSheet = [MDBShareActionSheet new];
                                                          actionSheet.delegate = self;
                                                          [actionSheet show];
                                                      }else{
                                                          [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                                      }
    }];
}

- (void)bargainActivityDetailSubjectViewDidClickUpdateAddressBtn{
    AddressListViewController *addressVc = [[AddressListViewController alloc] init];
    [self.navigationController pushViewController:addressVc animated:YES];
}

- (void)bargainActivityDetailSubjectViewDidClickBuyBtn:(NSString *)prodictID{
    ProductInfoViewController *vc = [[ProductInfoViewController alloc] init];
    vc.productId = prodictID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bargainActivityDetailSubjectViewDidClickWebUrl:(NSString *)url{
    if (!url) return;
    SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:url];
//    svweb.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:svweb animated:NO completion:nil];
}


-(void)getUserCont:(void(^)(BOOL state))callback{
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"type":@"1"};
    [HTTPManager sendRequestUrlToService:URL_usercenter withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                if ([dicAll objectForKey: @"data"]&&[[dicAll objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    [[MDB_UserDefault defaultInstance]setisSignyes:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"isSign"]] coper:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"copper"]] name: [NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"name"]] nickName: [NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"nickname"]] coin:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"coins"]] fans:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"fansNum"]] follow:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"followNum"]] contribution:[NSString stringWithFormat:@"%@",[[dicAll objectForKey:@"data"] objectForKey:@"contribution"]] content:nil userPhoto:[[dicAll objectForKey:@"data"] objectForKey:@"headImgUrl"] userID:[[dicAll objectForKey:@"data"] objectForKey:@"userid"] balance:[[dicAll objectForKey:@"data"] objectForKey:@"balance"] commission_balance:[[dicAll objectForKey:@"data"] objectForKey:@"reward_balance"] goods_coupon_balance:[[dicAll objectForKey:@"data"] objectForKey:@"goods_coupon_balance"] is_set_pay_password:[[[dicAll objectForKey:@"data"] objectForKey:@"is_set_pay_password"] boolValue]];
                    callback(YES);
                }else{
                    callback(NO);
                }
            }else{
                callback(NO);
            }
        }
    }];
}

#pragma mark - MDBShareActionSheetDelegate
- (void)shareActionSheetDidClickedSharButtonAtType:(MDBShareType)type{
    [self shareChannelType:type];
}

#pragma mark - setters and getters
- (BargainActivityDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[BargainActivityDataController alloc] init];
    }
    return _datacontroller;
}

@end
