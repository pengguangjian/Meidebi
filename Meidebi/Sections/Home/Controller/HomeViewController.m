//
//  HomeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/9.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeViewController.h"
#import "FilterTypeHomeViewController.h"
#import "SearchHomeViewController.h"
#import "PushSubscibeViewController.h"
//#import "HomeSubjectView.h"

//#import "HomeMainView.h"


#import "HomeDataController.h"
#import "RecommendActivityViewController.h"
#import "CheapOrOutsideViewController.h"
#import "CommentRewardsViewController.h"
#import "SpecialInfoViewController.h"
#import "ShowActiveViewController.h"
#import "ProductInfoViewController.h"
#import "OriginalDetailViewController.h"
#import "SVModalWebViewController.h"
#import "CouponLiveViewController.h"
#import "WelfareHomeViewController.h"
#import "MDB_UserDefault.h"
#import "UITabBar+badge.h"
#import "ZLJFeaturesGuideView.h"
#import "GMDCircleLoader.h"
#import "SpecicalIndexViewController.h"
#import "DailyLottoViewController.h"
#import "OriginalDetailViewController.h"
#import "BargainActivityViewController.h"
#import "HomeNavTitleView.h"
#import "ADHandleViewController.h"
#import "TrendHomeViewController.h"
#import "SignInViewController.h"
#import "SendGiftViewController.h"
#import "TopicHomeViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK/AlibcTradeSDK.h>
#import <UMAnalytics/MobClick.h>

#import "Home644View.h"

static NSString * const kADCompleteGuidNotification = @"completeGuidNotification";
static NSString * const kADPushNotification = @"adPush";


@interface HomeViewController ()
<
//HomeMainViewDelegate,
HomeNavTitleViewDelegate,
Home644ViewDelegate
>
@property (nonatomic, strong) HomeNavTitleView *homeTitleView;

//@property (nonatomic , strong) HomeMainView *mainView;

@property (nonatomic, strong) HomeDataController *dataController;
@property (nonatomic, strong) NSArray *guideElementRects;
@property (nonatomic, strong) NSArray *tips;
@property (nonatomic, strong) NSTimer *loadNewsTimer;


@property (nonatomic , retain) Home644View *view66;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataController = [[HomeDataController alloc] init];
    [self setNewHomeView];
    
    
    [self loadBannerData];
    
    ///获取首页分类名称
    [self loadItemsData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadHotSearchKey];
    });
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    if(_view66.headerView.isHiddennav == YES)
//    {
//        UIImage *image = [MDB_UserDefault createImageWithColor:RGBAlpha(255, 255, 255, 0.99)];
//        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:nil];
//    }
//    else
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    }
    
    
    
    
    [self.loadNewsTimer setFireDate:[NSDate distantPast]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(completeGuideSidle:)
                                                 name:kADCompleteGuidNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adClickAction:)
                                                 name:kADPushNotification
                                               object:nil];
//    [_subjectView beginImageAnimation];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//
//    [self.navigationController.navigationBar setShadowImage:nil];
    
    
    [self.loadNewsTimer setFireDate:[NSDate distantFuture]];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kADCompleteGuidNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kADPushNotification
                                                  object:nil];
    [GMDCircleLoader hideFromView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 新加的首页页面

-(void)setNewHomeView
{
    [self leftBarButton];
    [self rightBarButton];
    
    HomeNavTitleView *viewtemp = [self titleView];
    viewtemp.intrinsicContentSize =  CGSizeMake(self.view.width-90, viewtemp.height);
    self.navigationItem.titleView = viewtemp;
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIImage *image = [MDB_UserDefault createImageWithColor:RGBAlpha(255, 255, 255, 0.99)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

    float ftopheith =  kStatusBarHeight+44;
    float fother = 0.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    
    _view66 = [[Home644View alloc] init];//WithFrame:CGRectMake(0, ftopheith, BOUNDS_WIDTH, BOUNDS_HEIGHT-ftopheith-fother-kTabBarHeight)
    [_view66 setDelegate:self];
    [self.view addSubview:_view66];
    [_view66 mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    
    ///去显示小红点的
    _loadNewsTimer =  [NSTimer scheduledTimerWithTimeInterval:180.f target:self selector:@selector(loadNews) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(loadNews) userInfo:nil repeats:NO];
    
}
////精选下拉刷新
-(void)jingXuanheaderRef
{
    if(self.dataController.requestBannerResults.count<1)
    {
        [self loadBannerData];
    }
    
    
    if(self.dataController.resultItemsDict.count<2)
    {
        ///获取首页分类名称
        [self loadItemsData];
    }
    
    
}


#pragma mark - 结束


#pragma mark - Private methods 老版本的 没使用了
//
//- (void)setupSubviews{
//    self.navigationItem.titleView = [self titleView];
//    [self leftBarButton];
//    [self rightBarButton];
//
//
//
//    float ftopheith =  kStatusBarHeight+44;
//    float fother = 0.0;
//    if(ftopheith<66)
//    {
//        ftopheith = 64;
//        fother = 0;
//    }
//    _mainView = [[HomeMainView alloc]initWithFrame:CGRectMake(0, ftopheith, BOUNDS_WIDTH, BOUNDS_HEIGHT-ftopheith-kTabBarHeight-fother)];
////    [_mainView setDelegate:self];
//    [self.view addSubview:_mainView];
//
//    _loadNewsTimer =  [NSTimer scheduledTimerWithTimeInterval:360.f target:self selector:@selector(loadNews) userInfo:nil repeats:YES];
//}

//////

- (void)leftBarButton{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 40, 44);
    [firstButton setImage:[UIImage imageNamed:@"home_nav_left_image"] forState:UIControlStateNormal];
    [firstButton addTarget:self action:@selector(leftBarBut)  forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3 * kScale, 0, 0)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    [negativeSpacer setWidth:-10];
//
//
//
//    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];///52
//    [butleft addTarget:self action:@selector(leftBarBut) forControlEvents:UIControlEventTouchUpInside];
//    [butleft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//
//    UIImageView *imagleft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,40,40)];
//    [imagleft setImage:[UIImage imageNamed:@"home_nav_left_image"]];
//    [imagleft setCenterX:butleft.width/2.0];
//    [imagleft setCenterY:butleft.height/2.0];
//    [imagleft setContentMode:UIViewContentModeScaleAspectFit];
//    [butleft addSubview:imagleft];
//
//
//    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
//
//    if (@available(iOS 11.0, *)) {
//        [butleft setFrame:CGRectMake(0, 0, 42, 44)];
//
//        butleft.contentEdgeInsets =UIEdgeInsetsMake(0, -7,0, 7);
//
//    }
//    self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftBar];

}

- (void)rightBarButton{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 40, 44);
    [firstButton setImage:[UIImage imageNamed:@"home_nav_right_image"] forState:UIControlStateNormal];
    [firstButton addTarget:self action:@selector(rightBarBut) forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3 *kScale)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    [negativeSpacer setWidth:-10];
//
//    UIButton *butright=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [butright addTarget:self action:@selector(rightBarBut) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imagright = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,40,40)];
//    [imagright setImage:[UIImage imageNamed:@"home_nav_right_image"]];
//    [imagright setCenterX:butright.width/2.0];
//    [imagright setCenterY:butright.height/2.0];
//    [imagright setContentMode:UIViewContentModeScaleAspectFit];
//    [butright addSubview:imagright];
//
//    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:butright];
//
//    if (@available(iOS 11.0, *)) {
//        [butright setFrame:CGRectMake(0, 0, 42, 44)];
//        [imagright setCenterX:butright.width/2.0-2];
//        [butright setContentEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 7)];
//    }
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBar];
}

- (void)leftBarBut{
    [MobClick event:@"zhuye_shaixuan"];
    FilterTypeHomeViewController *filterVc = [[FilterTypeHomeViewController alloc] init];
    if (![_homeTitleView.searchHotKeyWord isEqualToString:kDefaultHotSearchStr]) {
        filterVc.hotSearchStr = _homeTitleView.searchHotKeyWord;
    }
    [self.navigationController pushViewController:filterVc animated:YES];
}

- (void)rightBarBut{
    [MobClick event:@"zhuye_dingyue"];
    PushSubscibeViewController *subscibeVc = [[PushSubscibeViewController alloc] init];
    [self.navigationController pushViewController:subscibeVc animated:YES];
}

- (HomeNavTitleView *)titleView{
    CGRect rect = self.navigationController.navigationBar.bounds;
    HomeNavTitleView *titleView =[[HomeNavTitleView alloc] initWithFrame:CGRectMake(0, rect.origin.y, self.view.width-90, rect.size.height)];///self.navigationController.navigationBar.bounds
    [titleView setBackgroundColor:self.navigationController.view.backgroundColor];
    titleView.delegate = self;
    _homeTitleView = titleView;
    [_homeTitleView setbackColor:RGBAlpha(245, 245, 245, 0.7)];
    return titleView;
}

- (void)loadBannerData{
    
    NSData *datatemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"homebannerdata"];
    if(datatemp!= nil)
    {
        [_view66 bindBanarData:[NSJSONSerialization JSONObjectWithData:datatemp options:NSJSONReadingMutableContainers error:nil]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataController requestBannerDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                //            [_mainView bindBanarData:self.dataController.requestBannerResults];
                NSData *data = [NSJSONSerialization dataWithJSONObject:self.dataController.requestBannerResults options:NSJSONWritingPrettyPrinted error:nil];
                if(data!= nil)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"homebannerdata"];
                }
                
                [_view66 bindBanarData:self.dataController.requestBannerResults];
                
            }
        }];
        
    });
    
}

-(void)loadItemsData
{
    
    [self.dataController requestHomeItemsDataInView:self.view Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [_view66 bindItemsData:self.dataController.resultItemsDict];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
        
    }];
}
#pragma mark - ////热搜
- (void)loadHotSearchKey{
    
    _homeTitleView.searchHotKeyWord = kDefaultHotSearchStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.dataController requestSearchKeywordWithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                if ([self.dataController.resultHotSearchStr isEqualToString:@""]) {
                    _homeTitleView.searchHotKeyWord = kDefaultHotSearchStr;
                }else{
                    _homeTitleView.searchHotKeyWord = self.dataController.resultHotSearchStr;
                }
            }
        }];
    });
    
}

- (void)loadNews{
    [self.dataController requestLoadNewsWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            
            
            
            
            NSString *_commentnum = [self.dataController.resultDict  objectForKey:@"commentnum"];
            NSString *_zannum = [self.dataController.resultDict  objectForKey:@"votenum"];
            NSString *_ordernum = [self.dataController.resultDict  objectForKey:@"ordernum"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_commentnum] forKey:@"commentnum"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_zannum] forKey:@"votenum"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString nullToString:_ordernum] forKey:@"ordernum"];
            
            
            NSString *strmessag = [self.dataController.resultDict  objectForKey:@"messagenum"];
            
            int itemo = _commentnum.intValue+_zannum.intValue+strmessag.intValue+_ordernum.intValue;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarnumessagenum" object:[NSString nullToString:[NSString stringWithFormat:@"%d",itemo]]];
            
            
            /////
            @try {
                [[MDB_UserDefault defaultInstance] setisSignyes:
                 [NSString stringWithFormat:@"%@",[self.dataController.resultDict objectForKey:@"isSign"]] coper:
                 [NSString stringWithFormat:@"%@",[self.dataController.resultDict objectForKey:@"copper"]] name:
                 [NSString stringWithFormat:@"%@",[self.dataController.resultDict objectForKey:@"name"]] nickName:
                 [NSString stringWithFormat:@"%@",[self.dataController.resultDict objectForKey:@"nickname"]] coin:
                 [NSString stringWithFormat:@"%@",[self.dataController.resultDict objectForKey:@"coins"]] fans:
                 [NSString stringWithFormat:@"%@",[self.dataController.resultDict objectForKey:@"fansNum"]] follow:
                 [NSString stringWithFormat:@"%@",[self.dataController.resultDict objectForKey:@"followNum"]] contribution:
                 [NSString stringWithFormat:@"%@",[self.dataController.resultDict objectForKey:@"contribution"]] content:nil userPhoto:
                 [self.dataController.resultDict objectForKey:@"headImgUrl"] userID:
                 [self.dataController.resultDict objectForKey:@"userid"] balance:
                 [self.dataController.resultDict objectForKey:@"balance"] commission_balance:
                 [self.dataController.resultDict objectForKey:@"reward_balance"] goods_coupon_balance:
                 [self.dataController.resultDict objectForKey:@"goods_coupon_balance"] is_set_pay_password:
                 [[self.dataController.resultDict objectForKey:@"is_set_pay_password"] boolValue]];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
            //////
            
            
//            NSString *strnum = [NSString nullToString:[self.dataController.resultDict objectForKey:@"commentnum"]];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarnumessagenum" object:strnum];
            
            if ([[self.dataController.resultDict objectForKey:@"commentnum"] intValue]>0) {
                [MDB_UserDefault setComment:YES];
//                [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:4];
                
                
            }
            if ([[self.dataController.resultDict objectForKey:@"messagenum"] intValue]>0) {
                [MDB_UserDefault setMessage:YES];
//                [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:4];
                
                
            }else{
                [MDB_UserDefault setMessage:NO];
            }
        }
    }];
}



/////没使用了
//- (void)loadHomeDataShowHUD:(BOOL)show{
//    if (show) {
//        [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
//    }
//    [self.dataController requestHomeDataInView:nil Callback:^(NSError *error, BOOL state, NSString *describle) {
//        [GMDCircleLoader hideFromView:self.view animated:YES];
//        if (show) {
//            if (state) {
//                [self renderSubjectView];
//            }
//        }else{
//            [self updateSubjectView];
//        }
//    }];
//}
//
//- (void)renderSubjectView{
//    ///修改添加
//    [_mainView bindJinXuanData:self.dataController.resultDict];
//
//}
//- (void)updateSubjectView{
//    [_mainView bindJinXuanRefData:self.dataController.resultDict];
//}
/////


- (void)completeGuideSidle:(NSNotification *)notification{
//    if (![MDB_UserDefault showAppIndexGuide]) {
//        [ZLJFeaturesGuideView showGuideViewWithRects:_guideElementRects tips:self.tips];
//        [MDB_UserDefault setShowAppIndexGuide:YES];
//    }
    if(self.dataController.resultItemsDict.count<3)
    {
        
        [self loadBannerData];
        [self loadHotSearchKey];
        
        ///获取首页分类名称
        [self loadItemsData];
    }
}

- (void)adClickAction:(NSNotification *)notification{
    NSDictionary *dictInfo = (NSDictionary *)notification.object;
    if([dictInfo[@"linkType"] isEqualToString:@"0"])
    {///第三方连接
        ADHandleViewController *adVc = [[ADHandleViewController alloc] initWithAdLink:[NSString nullToString:dictInfo[@"link"]]];
        [self.navigationController pushViewController:adVc animated:YES];
    }
    else if([dictInfo[@"linkType"] isEqualToString:@"1"])
    {//：爆料
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = dictInfo[@"id"];
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productInfoVc animated:YES];
    }
    else if([dictInfo[@"linkType"] isEqualToString:@"2"])
    {//2晒单
        OriginalDetailViewController *shareContVc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",dictInfo[@"id"]]];
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareContVc animated:YES];
        
        
    }
    
    
    
//    if (![dictInfo[@"id"] isEqualToString:@""]) {
//        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
//        productInfoVc.productId = dictInfo[@"id"];
//        self.navigationController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:productInfoVc animated:YES];
//    }else if (![dictInfo[@"link"] isEqualToString:@""]) {
//        ADHandleViewController *adVc = [[ADHandleViewController alloc] initWithAdLink:[NSString nullToString:dictInfo[@"link"]]];
//        [self.navigationController pushViewController:adVc animated:YES];
//    }
}
#pragma mark - HomeNavTitleViewDelegate
- (void)titleViewDidClickSearchWithHotWord:(NSString *)keyword{
    [MobClick event:@"zhuye_sousuo"];
    SearchHomeViewController *searchHomeVc = [[SearchHomeViewController alloc] init];
    if (![keyword isEqualToString:kDefaultHotSearchStr]) {
        searchHomeVc.hotSearchStr = keyword;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchHomeVc];
    [self presentViewController:nav animated:NO completion:nil];
}

//#pragma mark - HomeMainViewDelegate  很多代理改版本没有使用
/////下拉刷新
//-(void)HomeMainViewjingxuanHeaderRefAction
//{
//    [self loadHomeDataShowHUD:NO];
//    [self loadBannerData];
//}
/////banaer点击
//-(void)HomeMainViewBanaerSelect:(NSInteger)index
//{
//
//}
/////分类点击
//-(void)HomeMainViewItemSelect:(NSInteger)index
//{
//
//}
/////比比活动点击
//-(void)HomeMainViewBiBiSelect:(NSInteger)index
//{
//
//}
///// 热门推荐点击
//- (void)HomeMainViewXuanHotViewDidClichkCurrentHotWithItem:(HomeHotSticksViewModel *)item
//{
//
//}
/////白菜精选点击
//- (void)HomeMainViewjingXuanbaiCaiDidClichkCurrentHotWithItem:(HomeCheapViewModel *)item
//{
//
//}
/////热门专题
//- (void)HomeMainViewjingXuansepcialProtalTableViewDidSelectSpecial:(NSString *)specialID
//{
//
//}
/////更多
//- (void)HomeMainViewjingXuanhomeSepcialProtalViewDidClickMoreBtn
//{
//
//}
/////精选列表点击
//-(void)HomeMainViewjingxuanListCellSelectAction:(Commodity *)item
//{
//
//}

/*
#pragma mark - HomeSubjectViewDelegate
- (void)subjectViewClickHandleViewElementWith:(HandleElementType)type{
    switch (type) {
        case HandleElementTypeLowPrice:{
            [MobClick event:@"zhuye_baoyou"];
            CheapOrOutsideViewController *cheapOrOutsideVc = [[CheapOrOutsideViewController alloc] init];
            cheapOrOutsideVc.type = @"2";
            [self.navigationController pushViewController:cheapOrOutsideVc animated:YES];
           
        }
            break;
        case HandleElementTypeCoupon:{
            [MobClick event:@"zhuye_youhuiquan"];
            CouponLiveViewController *couponLiveVc = [[CouponLiveViewController alloc] init];
            [self.navigationController pushViewController:couponLiveVc animated:YES];
        }
            break;
        case HandleElementTypeHaitao:{
            [MobClick event:@"zhuye_zhiyou"];
            CheapOrOutsideViewController *cheapOrOutsideVc = [[CheapOrOutsideViewController alloc] init];
            cheapOrOutsideVc.type = @"1";
            [self.navigationController pushViewController:cheapOrOutsideVc animated:YES];
        }
            break;
        case HandleElementTypeDistribute:{
            [MobClick event:@"zhuye_fuli"];
            WelfareHomeViewController *welfareHomeVc = [[WelfareHomeViewController alloc] init];
            [self.navigationController pushViewController:welfareHomeVc animated:YES];
        }
            
            break;
        case HandleElementTypeLotto:
        {
            [MobClick event:@"zhuye_choujiang"];
            DailyLottoViewController *lottoVc = [[DailyLottoViewController alloc] init];
            [self.navigationController pushViewController:lottoVc animated:YES];
        }
            break;
            
        case HandleElementTypeTrend:
        {
            [MobClick event:@"zhuye_paihang"];
            TrendHomeViewController *vc = [[TrendHomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case HandleElementTypeSignIn:
        {
            [MobClick event:@"zhuye_qiandao"];
            SignInViewController *vc = [[SignInViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case HandleElementTypeFJSL:
        {
            [MobClick event:@"zhuye_songli"];
            SendGiftViewController *vc = [[SendGiftViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case HandleElementTypeTopic:
        {
            [MobClick event:@"zhuye_huati"];
            TopicHomeViewController *vc = [[TopicHomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case HandleElementTypeJHS:{
            [MobClick event:@"zhuye_juhuasuan"];
            id<AlibcTradePage> page = [AlibcTradePageFactory page:@"https://s.click.taobao.com/7EVN5Zw"];
            id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
            AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
            showParams.openType = AlibcOpenTypeNative;
            showParams.linkKey = @"taobao";
            [service show:self
                     page:page
               showParams:showParams
              taoKeParams:nil
               trackParam:nil
tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
} tradeProcessFailedCallback:^(NSError * _Nullable error) {
}];
        }
            break;
            
        default:
            break;
    }
}

- (void)subjectViewClickRecommendElementWithType:(RecommendType)type activityID:(NSString *)actiID{
    [MobClick event:@"zhuye_huodong"];
    if (type == RecommendTypeComment) {
        if(actiID == nil)
        {
            return;
        }
        CommentRewardsViewController *commentRewardsVc = [[CommentRewardsViewController alloc] init];
        commentRewardsVc.activityId = actiID;
        [self.navigationController pushViewController:commentRewardsVc animated:YES];
    }else if (type == RecommendTypeAccumulate){
        if(actiID == nil)
        {
            return;
        }
        RecommendActivityViewController *recommendActivity = [[RecommendActivityViewController alloc] init];
        recommendActivity.recommendId = actiID;
        [self.navigationController pushViewController:recommendActivity animated:YES];
    }else if (type == RecommendTypeBargain){
        BargainActivityViewController *vc = [[BargainActivityViewController alloc] initWithActivityID:actiID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)subjectViewRefreshHeader{
    [self loadHomeDataShowHUD:NO];
    [self loadBannerData];
}

- (void)subjectViewClickBannerElement:(NSDictionary *)bannerInfoDict{
    [MobClick event:@"zhuye_banner"];
    if ([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"0"]) {
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:[NSString nullToString:bannerInfoDict[@"link"]]];
        svweb.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        [self presentViewController:svweb animated:NO completion:nil];
    }else if([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"1"]){
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:bannerInfoDict[@"linkId"]];
        [self.navigationController pushViewController:productInfoVc animated:YES];
    }else if([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"2"]){
        OriginalDetailViewController *shareContVc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",bannerInfoDict[@"linkId"]]];
        [self.navigationController pushViewController:shareContVc animated:YES];
    }
}

- (void)subjectViewClickSpcialElementID:(NSString *)spcialID{
    [MobClick event:@"zhuye_zhuanti"];
    SpecialInfoViewController *specialInfoVc = [[SpecialInfoViewController alloc] initWithSpecialInfo:spcialID];
    [self.navigationController pushViewController:specialInfoVc animated:YES];
}

- (void)subjectViewClickTBSpecialElement:(NSString *)content{
    [MobClick event:@"zhuye_zhuanti"];
    UIStoryboard *mainbord=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowActiveViewController *showAct=[mainbord instantiateViewControllerWithIdentifier:@"com.mbd.ShowActiveViewC"];
    showAct.url=[NSString nullToString:content];
    showAct.title= @"专题详情";
    showAct.external = YES;
    [self.navigationController pushViewController:showAct animated:YES];
}

- (void)subjectViewClickHotSpecailRecommendElement:(NSString *)recommendID{
    SpecialInfoViewController *specialInfoVc = [[SpecialInfoViewController alloc] initWithSpecialInfo:recommendID];
    [self.navigationController pushViewController:specialInfoVc animated:YES];
}

- (void)subjectViewClickHotDiscountRecommendElement:(NSString *)recommendID{
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.productId = [NSString nullToString:recommendID];
    [self.navigationController pushViewController:productInfoVc animated:YES];
}

- (void)subjectViewClickHotOriginalRecommendElement:(NSString *)recommendID{
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:recommendID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)subjectViewClickCheapFeatured:(NSString *)featureID{
    [MobClick event:@"zhuye_baicai"];
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.productId = [NSString nullToString:featureID];
    [self.navigationController pushViewController:productInfoVc animated:YES];
}

- (void)subjectViewClickCurrentHotWithHotID:(NSString *)hotID
                                      title:(NSString *)title
                                       link:(NSString *)link
                                   linkType:(NSString *)type{
    [MobClick event:@"zhuye_remen"];
    if ([[NSString nullToString:type] isEqualToString:@"0"]) {
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:[NSString nullToString:link]];
        svweb.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        [self presentViewController:svweb animated:NO completion:nil];
    }else if([[NSString nullToString:type] isEqualToString:@"1"]){
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:hotID];
        [self.navigationController pushViewController:productInfoVc animated:YES];
    }else if([[NSString nullToString:type] isEqualToString:@"2"]){
        OriginalDetailViewController *shareContVc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",hotID]];
        [self.navigationController pushViewController:shareContVc animated:YES];
    }
}

- (void)subjectViewClickMoreSpcialButton{
    [MobClick event:@"zhuye_gengduo"];
    SpecicalIndexViewController *indexVc = [[SpecicalIndexViewController alloc] init];
    [self.navigationController pushViewController:indexVc animated:YES];
}

- (void)subjectViewShowGuideElementRects:(NSArray *)rects{
//    NSMutableArray *frames = [NSMutableArray arrayWithArray:rects];
//    UITabBarItem *originalBarItem = self.tabBarController.tabBar.items[3];
//    UIView *originalTargetView = (UIView *)[originalBarItem performSelector:@selector(view)];
//    if (originalTargetView) {
//        CGRect frame = originalTargetView.frame;
//        frame.origin.x += 10;
//        frame.size.height -= 2;
//        frame.size.width -= 20;
//        frame.origin.y = CGRectGetMinY(originalTargetView.superview.frame)+1;
//        [frames insertObject:[NSValue valueWithCGRect:frame] atIndex:0];
//    };
//    UITabBarItem *barItem = self.tabBarController.tabBar.items[1];
//    UIView *targetView = (UIView *)[barItem performSelector:@selector(view)];
//    if (targetView) {
//        CGRect frame = targetView.frame;
//        frame.origin.x += 10;
//        frame.size.height -= 2;
//        frame.size.width -= 20;
//        frame.origin.y = CGRectGetMinY(targetView.superview.frame)+1;
//        [frames insertObject:[NSValue valueWithCGRect:frame] atIndex:0];
//    };
//    [frames addObject:[NSValue valueWithCGRect:CGRectMake(kMainScreenW-63, kStatusBarHeight+6, 60, 30)]];
//    _guideElementRects = frames.mutableCopy;
//    if (![MDB_UserDefault getUmengfirestStatue] && ![MDB_UserDefault showAppIndexGuide]) {
//        [ZLJFeaturesGuideView showGuideViewWithRects:_guideElementRects tips:self.tips];
//        [MDB_UserDefault setShowAppIndexGuide:YES];
//    }
}
 */

#pragma mark - setters and getters
//- (HomeDataController *)dataController{
//    if (!_dataController) {
//        _dataController = [[HomeDataController alloc] init];
//    }
//    return _dataController;
//}

- (NSArray *)tips{
    if (!_tips) {
        _tips = @[@"亲爱哒\n原优惠快报在这里哦~",
                  @"这里是购物分享、商品点评、\n 海淘攻略，给你真实的购物反馈~",
                  @"任务入口在这里哦~",
                  @"这里是平台活动聚集地\n参与活动赢好礼~左右滑动可能有更多活动哦 ",
                  @"订阅你感兴趣的商品关键词\n我们将第一时间把优惠带给您~"];

    }
    return _tips;
}

-(void)dealloc
{
    [_homeTitleView removeFromSuperview];
    [_loadNewsTimer invalidate];
    _homeTitleView = nil;
    _dataController = nil;
}

@end
