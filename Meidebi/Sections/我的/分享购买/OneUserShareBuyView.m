//
//  OneUserShareBuyView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/18.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "OneUserShareBuyView.h"
#import "MDB_UserDefault.h"

#import "MDBwebVIew.h"

#import "MyAccountFLMXViewController.h"

#import "OneUserShareBuyController.h"

@interface OneUserShareBuyView ()<MDBwebDelegate>
{
    UIButton *btlastselect;
    MDBwebVIew *webview;
    
    UIView *viewshareone;
    UIView *viewsharetwo;
    
    ///字体大小
    float ffontsize;
    
    OneUserShareBuyController *dataControl;
    
    UIScrollView *scvback;
    ///
    UIView *viewshare;
    
    ///我的返利
    UILabel *lbfanliAll;
    ///我分享的订单
    UILabel *lbshareAll;
    ///等级折扣
    UILabel *lbdjzhekou;
    ///好友在下5单，……
    UILabel *lbonlyBuy;
    
    
    
}
@end

@implementation OneUserShareBuyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        ffontsize = 14;
        if(iPhone5)
        {
            ffontsize = 12;
        }
        else if (iPhone6_or_iphone7)
        {
            ffontsize = 13;
        }
        
        [self drawUI];
        
        dataControl = [[OneUserShareBuyController alloc] init];
        [self getdata];
    }
    return self;
}

-(void)getdata
{
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [dataControl requestDGFanLiInfoDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [self loadValue];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
    }];
}

-(void)loadValue
{
    
    
    [lbfanliAll setText:[NSString nullToString:[dataControl.dicresult objectForKey:@"commission_total"]]];
    
    [lbdjzhekou setText:[NSString stringWithFormat:@"%@/%@",[NSString nullToString:[dataControl.dicresult objectForKey:@"grade"]],[NSString nullToString:[dataControl.dicresult objectForKey:@"carriage_discount"]]]];
    
    [lbonlyBuy setText:[NSString stringWithFormat:@"好友再下%@单，您可享受国际运费%@",[NSString nullToString:[[dataControl.dicresult objectForKey:@"order_again"] objectForKey:@"order_number"]],[NSString nullToString:[[dataControl.dicresult objectForKey:@"order_again"] objectForKey:@"enjoy_carriage_discount"]]]];
    
    [lbshareAll setText:[NSString stringWithFormat:@"%@个",[NSString nullToString:[dataControl.dicresult objectForKey:@"share_order_number"]]]];
    ////
    UIView *viewdengji = [[UIView alloc] init];
    [scvback addSubview:viewdengji];
    [viewdengji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewshare);
        make.top.equalTo(viewshare.mas_bottom).offset(10);
    }];
    [self drawDengji:viewdengji];
    
    ///
    UIView *viewguizhe = [[UIView alloc] init];
    [scvback addSubview:viewguizhe];
    [viewguizhe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewdengji);
        make.top.equalTo(viewdengji.mas_bottom).offset(10);
    }];
    [self drawGuiZhe:viewguizhe];
    
    
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewguizhe.mas_bottom).offset(20);
    }];
    
    
}

-(void)drawUI
{
    
    scvback = [[UIScrollView alloc] init];
    [self addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.offset(0);
        make.width.offset(kMainScreenW);
    }];
//    [scvback setShowsVerticalScrollIndicator:NO];
    
    
    UIImage *image = [UIImage imageNamed:@"sharebuy_back"];
    UIImageView *imgvc = [[UIImageView alloc] init];
    [imgvc setImage:image];
    [scvback addSubview:imgvc];
    [imgvc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(scvback);
        make.height.offset(image.size.height*kMainScreenW/image.size.width);
        make.right.equalTo(self);
    }];
    
    ///
    UIView *viewinfo = [[UIView alloc] init];
    [scvback addSubview:viewinfo];
    [viewinfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(imgvc.mas_bottom).offset(-10*kScale);
    }];
    [self drawMyInfo:viewinfo];
    
    ///
    viewshare = [[UIView alloc] init];
    [scvback addSubview:viewshare];
    [viewshare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewinfo);
        make.top.equalTo(viewinfo.mas_bottom).offset(10);
    }];
    [self drawShareAction:viewshare];
    
}

#pragma mark - 我的信息
-(void)drawMyInfo:(UIView *)view
{
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:8];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgvhead = [[UIImageView alloc] init];
    [imgvhead setBackgroundColor:[UIColor grayColor]];
    [view addSubview:imgvhead];
    float fwidth = 55*kScale;
    [imgvhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.size.sizeOffset(CGSizeMake(fwidth, fwidth));
        
    }];
    [imgvhead.layer setMasksToBounds:YES];
    [imgvhead.layer setCornerRadius:fwidth/2.0];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:[MDB_UserDefault defaultInstance].userphoto];

//    ///
//    UIView *viewdj = [[UIView alloc]init];
//    [view addSubview:viewdj];
//    [viewdj mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imgvhead.mas_right).offset(10);
//        make.top.equalTo(imgvhead);
//        make.bottom.equalTo(imgvhead.mas_centerY);
//    }];
//    [self drawmyinfoItem:viewdj andtitle:@"我的等级" andvalue:@"VIP0"];
//
//    ///
//    UIView *viewdd = [[UIView alloc]init];
//    [view addSubview:viewdd];
//    [viewdd mas_makeConstraints:^(MASConstraintMaker *make) {
//        if(iPhone5)
//        {
//            make.left.equalTo(viewdj.mas_right).offset(30*kScale);
//        }
//        else
//        {
//            make.left.equalTo(viewdj.mas_right).offset(50*kScale);
//        }
//
//        make.top.equalTo(viewdj);
//        make.bottom.equalTo(viewdj);
//    }];
//    [self drawmyinfoItem:viewdd andtitle:@"我的订单" andvalue:@"0个"];
//
//    ///
//    UIView *viewfxdd = [[UIView alloc]init];
//    [view addSubview:viewfxdd];
//    [viewfxdd mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(viewdj);
//        make.top.equalTo(viewdj.mas_bottom);
//        make.bottom.equalTo(imgvhead);
//    }];
//    [self drawmyinfoItem:viewfxdd andtitle:@"我分享的订单" andvalue:@"9990个"];
//
//
//    ///
//    UIView *viewfl = [[UIView alloc]init];
//    [view addSubview:viewfl];
//    [viewfl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(viewdd);
//        make.top.equalTo(viewfxdd);
//        make.bottom.equalTo(viewfxdd);
//    }];
//    [self drawmyinfoItem:viewfl andtitle:@"我的返利" andvalue:@"￥9990.00"];
//
    
    ///
    UIView *viewfl = [[UIView alloc]init];
    [view addSubview:viewfl];
    [viewfl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imgvhead.mas_right).offset(20);
        make.top.equalTo(imgvhead.mas_top);
        make.bottom.equalTo(imgvhead.mas_centerY);
        make.centerX.equalTo(view);
    }];
    lbfanliAll = [self drawmyinfoItem:viewfl andtitle:@"我的返利" andvalue:@"￥0.00"];
    
    
    ////
    UIView *viewfxdd = [[UIView alloc]init];
    [view addSubview:viewfxdd];
    [viewfxdd mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(viewfl);
        make.top.equalTo(viewfl.mas_bottom);
        make.bottom.equalTo(imgvhead);
        make.centerX.equalTo(view);
    }];
    lbshareAll = [self drawmyinfoItem:viewfxdd andtitle:@"我分享的订单" andvalue:@"0个"];

    ///
    UILabel *lbdengji  =[[UILabel alloc] init];
    [lbdengji setText:@"VIP0/10折"];
    [lbdengji setTextColor:RGB(242, 157, 135)];
    [lbdengji setTextAlignment:NSTextAlignmentLeft];
    [lbdengji setFont:[UIFont boldSystemFontOfSize:ffontsize]];
    [view addSubview:lbdengji];
    [lbdengji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgvhead.mas_bottom);
        make.left.equalTo(imgvhead).offset(-10);
        make.right.equalTo(imgvhead).offset(35);
        make.height.offset(20);
        
    }];
    lbdjzhekou = lbdengji;
    
    
    UILabel *lbother  =[[UILabel alloc] init];
    [lbother setText:@"好友再下5单，您可享受国际运费98折"];
    [lbother setTextColor:RGB(200, 200, 200)];
    [lbother setTextAlignment:NSTextAlignmentCenter];
    [lbother setFont:[UIFont systemFontOfSize:ffontsize]];
    [view addSubview:lbother];
    [lbother mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(imgvhead.mas_bottom).offset(20);
        make.height.offset(20);
    }];
    lbonlyBuy = lbother;
    
    UIButton *btshowfl = [[UIButton alloc] init];
    [btshowfl setTitle:@"查看返利明细>" forState:UIControlStateNormal];
    [btshowfl setTitleColor:RGB(88, 155, 255) forState:UIControlStateNormal];
    [btshowfl.titleLabel setFont:[UIFont systemFontOfSize:ffontsize]];
    [view addSubview:btshowfl];
    [btshowfl addTarget:self action:@selector(showflAction) forControlEvents:UIControlEventTouchUpInside];
    [btshowfl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(lbother.mas_bottom).offset(20);
        make.height.offset(35);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btshowfl.mas_bottom);
    }];
    
}

-(UILabel *)drawmyinfoItem:(UIView *)view andtitle:(NSString *)title andvalue:(NSString *)value
{
    UILabel *lbtitle  =[[UILabel alloc] init];
    [lbtitle setText:title];
    [lbtitle setTextColor:RGB(10, 10, 10)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:ffontsize]];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(view);
    }];
    
    UILabel *lbvalue  =[[UILabel alloc] init];
    [lbvalue setText:value];
    [lbvalue setTextColor:RGB(242, 157, 135)];
    [lbvalue setTextAlignment:NSTextAlignmentLeft];
    [lbvalue setFont:[UIFont boldSystemFontOfSize:ffontsize]];
    [view addSubview:lbvalue];
    [lbvalue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(lbtitle.mas_right).offset(10);
        
    }];
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbvalue.mas_right);
    }];
    
    return lbvalue;
}

#pragma mark - 分享方法
-(void)drawShareAction:(UIView *)view
{
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:8];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *arrtitle = @[@"分享方法一",@"分享方法二"];
    UIView *viewlast = nil;
    for(int i = 0 ; i < arrtitle.count ; i++)
    {
        UIButton *btone = [[UIButton alloc] init];
        [btone setTitleColor:RGB(126, 112, 215) forState:UIControlStateNormal];
        [btone setTitle:arrtitle[i] forState:UIControlStateNormal];
        [btone.titleLabel setFont:[UIFont boldSystemFontOfSize:ffontsize+1]];
        [view addSubview:btone];
        [btone setTag:i];
        [btone addTarget:self action:@selector(shareactionAction:) forControlEvents:UIControlEventTouchUpInside];
        [btone mas_makeConstraints:^(MASConstraintMaker *make) {
            if(viewlast == nil)
            {
                make.left.offset(10);
            }
            else
            {
                make.left.equalTo(viewlast.mas_right);
            }
            make.top.equalTo(view);
            make.height.offset(55);
            make.width.equalTo(view).multipliedBy(0.5).offset(-10);
        }];
        UIView *viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(126, 112, 215)];
        [viewline setTag:100];
        [btone addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(btone);
            make.height.offset(1.5);
        }];
        if(i>0)
        {
            [viewline setHidden:YES];
        }
        if(i == 0)
        {
            btlastselect = btone;
        }
        viewlast = btone;
    }
    
    ////
    viewshareone = [[UIView alloc] init];
    [view addSubview:viewshareone];
    [viewshareone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.offset(70);
        make.height.offset((kMainScreenW-30)/3.0+50);
    }];
    NSArray *images = @[@"sharebay_user",@"sharebuy_shangping",@"sharebuy_lianjie"];
    NSArray *titles = @[@"登录没得比",@"选择代购商品分享给好友",@"好友通过连接下单即可"];
    [self drawShareItems:viewshareone andimages:images andtitles:titles];
    
    viewsharetwo = [[UIView alloc] init];
    [view addSubview:viewsharetwo];
    [viewsharetwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.offset(70);
        make.height.offset((kMainScreenW-30)/3.0+50);
    }];
    NSArray *images1 = @[@"sharebuy_userzhongxin",@"sharebuy_fenxiangyaoqingma",@"sharebuy_zhucetxyqm"];
    NSArray *titles1 = @[@"进入个人中心-邀请好友",@"复制邀请码给好友或分享邀请页面给好友",@"好友注册并输入您的邀请码下单即可"];
    [self drawShareItems:viewsharetwo andimages:images1 andtitles:titles1];
    [viewsharetwo setHidden:YES];
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewshareone.mas_bottom);
    }];
    
    
}

-(void)drawShareItems:(UIView *)view andimages:(NSArray *)images andtitles:(NSArray *)titles
{
    UIView *viewlast = nil;
    for(int i = 0; i < images.count; i++)
    {
        UIView *viewitems = [[UIView alloc] init];
        [view addSubview:viewitems];
        [viewitems mas_makeConstraints:^(MASConstraintMaker *make) {
            if(viewlast == nil)
            {
                make.left.offset(0);
            }
            else
            {
                make.left.equalTo(viewlast.mas_right);
            }
            make.top.bottom.equalTo(view);
            make.width.offset((kMainScreenW-30)/3.0);
        }];
        viewlast = viewitems;
        [self drawShareItem:viewitems andimage:images[i] andtitle:titles[i]];
    }
    
}
-(void)drawShareItem:(UIView *)view andimage:(NSString *)strimage andtitle:(NSString *)title
{
    UIImageView *imgv = [[UIImageView alloc] init];
    [imgv setImage:[UIImage imageNamed:strimage]];
//    [imgv setBackgroundColor:[UIColor grayColor]];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.left.offset(10);
        make.right.equalTo(view).offset(-10);
        make.height.equalTo(view.mas_width).offset(-20);
    }];
    
    UILabel *lbvalue  =[[UILabel alloc] init];
    [lbvalue setText:title];
    [lbvalue setTextColor:RGB(170, 170, 170)];
    [lbvalue setFont:[UIFont systemFontOfSize:ffontsize]];
    [lbvalue setNumberOfLines:0];
    [view addSubview:lbvalue];
    float fitemw = (kMainScreenW-30)/3.0-20;
    float fw = [MDB_UserDefault countTextSize:CGSizeMake(200, 20) andtextfont:lbvalue.font andtext:lbvalue.text].width;
    if(fw>=fitemw)
    {
        [lbvalue setTextAlignment:NSTextAlignmentLeft];
    }
    else
    {
        [lbvalue setTextAlignment:NSTextAlignmentCenter];
    }
    [lbvalue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgv.mas_bottom);
        make.left.right.equalTo(imgv);
        make.bottom.equalTo(view);
    }];
}

#pragma mark -////等级说明
-(void)drawDengji:(UIView *)view
{
    
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:8];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbvalue  =[[UILabel alloc] init];
    [lbvalue setText:@"等级说明"];
    [lbvalue setTextColor:RGB(126, 112, 215)];
    [lbvalue setTextAlignment:NSTextAlignmentCenter];
    [lbvalue setFont:[UIFont boldSystemFontOfSize:ffontsize+1]];
    [view addSubview:lbvalue];
    [lbvalue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
        make.height.offset(55);
    }];
    
    UIImageView *imgvline = [[UIImageView alloc] init];
    [imgvline setImage:[UIImage imageNamed:@"sharebuy_gbline"]];
    [imgvline setContentMode:UIViewContentModeScaleToFill];
    [view addSubview:imgvline];
    [imgvline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbvalue.mas_bottom);
        make.left.offset(10);
        make.right.equalTo(view).offset(-10);
        make.height.offset(1);
    }];
    
    NSMutableArray *arrall = [NSMutableArray new];
 
   NSArray *arrtemp = @[@{@"grade":@"等级",@"carriage_discount":@"运费折扣",@"personal_order_number":@"个人订单量",@"popularize_order_number":@"分享订单量"}];
    [arrall addObjectsFromArray:arrtemp];
    
    if([[dataControl.dicresult objectForKey:@"grade_description"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrgrade_description = [dataControl.dicresult objectForKey:@"grade_description"];
        [arrall addObjectsFromArray:arrgrade_description];
    }
    
    UIView *viewilast = imgvline;
    for(int i = 0 ; i < arrall.count; i++)
    {
        NSDictionary *dicitems = arrall[i];
        UIView *viewjlast = nil;
        for(int j = 0 ; j < 4; j++)
        {
            UILabel *lbdj = [[UILabel alloc] init];
            if(j==0)
            {
                [lbdj setText:[dicitems objectForKey:@"grade"]];
            }
            else if (j==1)
            {
                [lbdj setText:[dicitems objectForKey:@"carriage_discount"]];
            }
            else if (j==2)
            {
                [lbdj setText:[dicitems objectForKey:@"personal_order_number"]];
            }
            else if (j==3)
            {
                [lbdj setText:[dicitems objectForKey:@"popularize_order_number"]];
            }
            
            if(i==0)
            {
                [lbdj setTextColor:RGB(10, 10, 10)];
                [lbdj setFont:[UIFont boldSystemFontOfSize:ffontsize]];
            }
            else
            {
                [lbdj setTextColor:RGB(110, 110, 110)];
                [lbdj setFont:[UIFont systemFontOfSize:ffontsize]];
            }
            [lbdj setTextAlignment:NSTextAlignmentCenter];
            [view addSubview:lbdj];
            [lbdj mas_makeConstraints:^(MASConstraintMaker *make) {
                if(viewjlast==nil)
                {
                    make.left.offset(0);
                }
                else
                {
                    make.left.equalTo(viewjlast.mas_right);
                }
                make.top.equalTo(viewilast.mas_bottom).offset(10);
                if(j>0)
                {
                    make.width.offset((kMainScreenW-30)/4.0*1.1);
                }
                else
                {
                    make.width.offset((kMainScreenW-30)/4.0*0.7);
                }
                make.height.offset(20);
            }];
            viewjlast = lbdj;
            if(j==3)
            {
                viewilast = lbdj;
            }
        }
        
    }
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewilast.mas_bottom).offset(10);
    }];
    
}


#pragma mark -///规则说明
-(void)drawGuiZhe:(UIView *)view
{
    
    UILabel *lbvalue  =[[UILabel alloc] init];
    [lbvalue setText:@"规则说明"];
    [lbvalue setTextColor:RGB(255, 255, 255)];
    [lbvalue setTextAlignment:NSTextAlignmentCenter];
    [lbvalue setFont:[UIFont boldSystemFontOfSize:ffontsize+1]];
    [view addSubview:lbvalue];
    [lbvalue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
        make.height.offset(55);
    }];
    
    UIImageView *imgvline = [[UIImageView alloc] init];
    [imgvline setImage:[UIImage imageNamed:@"sharebuy_writeLine"]];
    [imgvline setContentMode:UIViewContentModeScaleToFill];
    [view addSubview:imgvline];
    [imgvline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbvalue.mas_bottom);
        make.left.offset(0);
        make.right.equalTo(view);
        make.height.offset(1);
    }];
    

    webview = [[MDBwebVIew alloc] init];
    webview.delegate = self;
    [view addSubview:webview];
    [webview setBackgroundColor:[UIColor clearColor]];
    [webview.webView setBackgroundColor:[UIColor clearColor]];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(imgvline.mas_bottom).offset(15);
        make.height.offset(10);
    }];
//    [webview loadWebByURL:@"https://www.baidu.com/"];
    [webview refreshYQHYGZHtml:[NSString stringWithFormat:@"%@",[NSString nullToString:[dataControl.dicresult objectForKey:@"rule_description"]]]];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(webview.mas_bottom);
    }];
    

}

-(void)webViewDidFinishLoad:(float)h webview:(MDBwebVIew *)webView
{
    [webview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h);
    }];
}

#pragma mark - 查看返利
-(void)showflAction
{
    MyAccountFLMXViewController *mvc = [[MyAccountFLMXViewController alloc] init];
    [self.viewController.navigationController pushViewController:mvc animated:YES];
}
#pragma mark - 分享方法
-(void)shareactionAction:(UIButton *)sender
{
    UIView *viewtemp = [btlastselect viewWithTag:100];
    [viewtemp setHidden:YES];
    btlastselect = sender;
    viewtemp = [btlastselect viewWithTag:100];
    [viewtemp setHidden:NO];
    if(btlastselect.tag == 1)
    {
        [viewshareone setHidden:YES];
        [viewsharetwo setHidden:NO];
    }
    else
    {
        [viewshareone setHidden:NO];
        [viewsharetwo setHidden:YES];
    }
    
    
}



@end
