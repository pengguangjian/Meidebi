//
//  OrderDetaileView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/8.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderDetaileView.h"

#import "OrderDetaileDataController.h"

#import "MDB_UserDefault.h"

#import "OrderDetaileModel.h"

#import "OrderLogisticsViewController.h"

#import "DaiGouZhiFuViewController.h"

#import "MyOrderMainDataController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import "ProductInfoViewController.h"

#import "OrderRefundViewController.h"

#import "YYPhotoGroupView.h"

#import "UIImage+Extensions.h"


#import "MDBEmptyView.h"

#import "ShareHongBaoView.h"
#import "Qqshare.h"

#import "PushYuanChuangViewController.h"

#import "MyInformMessageDataController.h"


@interface OrderDetaileView()<UIAlertViewDelegate,UIActionSheetDelegate>
{
    UIScrollView *scvback;
    
    UIImageView *imgvheadicon;
    
    OrderDetaileDataController *dataControl;
    
    OrderDetaileModel *orderModel;
    
    MyOrderMainDataController *otherDataControl;
    MyInformMessageDataController *dataControllink;
    
    NSString *strorderid;
    NSString *strordernos;
    
    ///第几个红包最大
    NSString *strsharecoumaxnumber;
    ///红包链接
    NSString *strsharecouurl;
    
    NSString *strgoods_id;
    
    NSMutableArray *arrshaidanyyhq;
    
}

@property (nonatomic ,retain) MDBEmptyView *emptyView;

@end


@implementation OrderDetaileView

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
        [self emptyView];
    }
    return self;
}

-(void)bindData:(NSString *)strid bindorderno:(NSString *)strorderno
{
    if(dataControl == nil)
    {
        dataControl = [[OrderDetaileDataController alloc] init];
    }
    if(strid == nil && strorderno==nil)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"订单号错误" inView:self];
        [_emptyView  setHidden:NO];
        return;
    }
    
    strorderid = strid;
    strordernos = strorderno;
    if([MDB_UserDefault defaultInstance].usertoken.length<3 || [MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请去登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
    NSDictionary *dicpush;
    if(strordernos.length>0)
    {
        dicpush = @{@"orderno":strordernos,@"userkey": [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    }
    else
    {
        dicpush = @{@"order_id":strorderid,@"userkey": [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    }
    
    
    [dataControl requestDGHomeDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        
//        NSLog(@"%@",dataControl.dicreuselt);
        if(state)
        {
            [self drawSubview:dataControl.dicreuselt];
            
            @try {
                if([[dataControl.dicreuselt objectForKey:@"goodsinfo"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrgoodsinfotemp = [dataControl.dicreuselt objectForKey:@"goodsinfo"];
                    if(arrgoodsinfotemp.count>0)
                    {
                        strgoods_id = [NSString stringWithFormat:@"%@",[arrgoodsinfotemp[0] objectForKey:@"share_id"]];
                    }
                }
                    
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            [self getshareMessage];
            
        }
        else
        {
            
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
            [_emptyView  setHidden:NO];
        }
        
        
    }];
    
}

-(void)getshareMessage
{
    if(orderModel.status.intValue == 1)
    {
        [dataControl requestShareSubjectDataWithCommodityid:strgoods_id inView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
        }];
    }
}

-(void)getyouhuiquanShare:(UIView *)view
{
    
    NSDictionary *dicpush = @{@"orderno":orderModel.orderno,@"userkey": [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [dataControl requestDGHomeHongBaoSharedicpush:dicpush InView:view Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(state)
        {
            
            [self getsherehongbao:view];
        }
        else
        {
            if(view!=nil)
            {
                [MDB_UserDefault showNotifyHUDwithtext:@"分享信息获取失败" inView:self];
            }
        }
        
    }];
}

-(void)getsherehongbao:(UIView *)view
{
    
    NSDictionary *dicpush = @{@"orderno":orderModel.orderno,@"userkey": [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [dataControl requestDGHomeHongBaoSharedicpush:dicpush InView:view Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(state)
        {
            strsharecoumaxnumber = [NSString nullToString:[dataControl.dicshare objectForKey:@"maxnumber"]];
            strsharecouurl = [NSString nullToString:[dataControl.dicshare objectForKey:@"landurl"]];
            if(strsharecouurl.length>5 && view != nil)
            {
                [self sharecaikaiAction];
            }
            else
            {
                if(view!=nil)
                {
                    [MDB_UserDefault showNotifyHUDwithtext:@"分享信息获取失败" inView:self];
                }
            }
        }
        else
        {
            if(view!=nil)
            {
                [MDB_UserDefault showNotifyHUDwithtext:@"分享信息获取失败" inView:self];
            }
        }
        
    }];
}


-(void)drawSubview:(NSDictionary *)dic
{
    scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [scvback setBackgroundColor:RGB(241,241,241)];
    [self addSubview:scvback];
    
    orderModel = [OrderDetaileModel bindModelData:dic];
    
    if([NSString nullToString:orderModel.accident_xpln].length>0)
    {
        [self.delegate orderYiChangMessage:orderModel.accident_xpln];
    }
    
    
    ////订单状态
    UIView *viewtop = [self drawtop:CGRectMake(0, 0, scvback.width, 50) andtype:orderModel.status.intValue];
    [scvback addSubview:viewtop];
    
    
    ////物流
    UIView *viewwuliu = [self drawFast:CGRectMake(0, viewtop.bottom, viewtop.width, 50)];
    [scvback addSubview:viewwuliu];
    if(orderModel.status.intValue>=4)
    {
        
    }
    else
    {
        [viewwuliu setHidden:YES];
        [viewwuliu setHeight:0];
    }
    
    
    ///收货人信息
    UIView *viewaddress = [self drawAddress:CGRectMake(0, viewwuliu.bottom, viewtop.width, 50)];
    [scvback addSubview:viewaddress];
    
    
    ///拼单信息
    UIView *viewpindan = [self drawpinDan:CGRectMake(0, viewaddress.bottom, viewtop.width, 100)];
    [scvback addSubview:viewpindan];
    if(orderModel.daigoutype.intValue == 1)
    {
        [viewpindan setHidden:YES];
        [viewpindan setHeight:0];
    }
    
    float ftempbottom = viewpindan.bottom;
    if(orderModel.couponinfortype.integerValue>0 && orderModel.num.integerValue>0 && orderModel.num.integerValue > orderModel.sendnum.integerValue)
    {
        UIView *viewshare = [self drawshareView:CGRectMake(0, viewpindan.bottom, scvback.width, 70)];
        [scvback addSubview:viewshare];
        ftempbottom = viewshare.bottom-10;
        if(orderModel.couponinfortype.integerValue == 1)
        {
            [self getyouhuiquanShare:nil];
        }
        else
        {
            [self getsherehongbao:nil];
        }
        
    }
//    ///分享红包  订单支付日起止15日
//    if((orderModel.status.integerValue == 2 ||orderModel.status.integerValue == 3 || orderModel.status.integerValue == 4 || orderModel.status.integerValue == 5) && orderModel.paytime.integerValue>0 && [self dateNowTime:orderModel.paytime]<1296000)
//    {
//        UIView *viewshare = [self drawshareView:CGRectMake(0, viewpindan.bottom, scvback.width, 70)];
//        [scvback addSubview:viewshare];
//        ftempbottom = viewshare.bottom-10;
//    }
    
    //物流提示
    if(orderModel.stris_slow.integerValue == 1)
    {
        UIView *viewwuliulay = [self drawMessageLayView:CGRectMake(0, ftempbottom-1, viewtop.width, 80)];
        [scvback addSubview:viewwuliulay];
        ftempbottom = viewwuliulay.bottom-10;
    }
    
    
    
    ////
    UIView *viewmessage = [self drawShangPin:CGRectMake(0, ftempbottom+10, viewtop.width, 100)];
    [scvback addSubview:viewmessage];
    
    float fbottom =viewmessage.bottom+10;
    
    BOOL iskong = YES;
    for(OrderDetaileGoodsModel *modeltemp in orderModel.goodsinfo)
    {
        if(modeltemp.spec_val==nil || [NSString nullToString:modeltemp.spec_val].length<1)
        {
            iskong = NO;
        }
    }
    
    if(iskong==NO)
    {
//        if(![orderModel.remark isEqualToString:@"[空]"])
//        {
            ///
            UIView *viewbeizu = [self drawBeizu:CGRectMake(0, fbottom, viewtop.width, 50)];
            [scvback addSubview:viewbeizu];
            
            fbottom =viewbeizu.bottom;
//        }
    }
    
    
    
    
    if(orderModel.idcard.length>10)
    {
        ///
        UIView *viewsfnumber = [self drawSFNumber:CGRectMake(0, fbottom+10, viewtop.width, 50)];
        [scvback addSubview:viewsfnumber];
        fbottom = viewsfnumber.bottom;
    }
    else
    {
        
    }
    
    if(orderModel.front_pic.length>5 ||orderModel.back_pic.length>5)
    {
        ///
        UIView *viewsfimage = [self drawShenFen:CGRectMake(0, fbottom+10, viewtop.width, 100) andvalue:nil];
        [scvback addSubview:viewsfimage];
        
        fbottom = viewsfimage.bottom;
    }
    
    
    
    ///
    UIView *viewpaytype = [self drawPayType:CGRectMake(0, fbottom+10, viewtop.width, 50)];
    [scvback addSubview:viewpaytype];
    
    fbottom = viewpaytype.bottom;
    
    if(orderModel.shotpics.count>0)
    {
        ///
        UIView *viewgmpz = [self drawPingZheng:CGRectMake(0, viewpaytype.bottom+10, viewtop.width, 50) andtitle:@"购买凭证" andvalue:orderModel.shotpics];
        [scvback addSubview:viewgmpz];
        [viewgmpz setTag:0];
        fbottom = viewgmpz.bottom;
    }
    
    if(orderModel.shoppics.count>0)
    {
        ///
        UIView *viewfhpz = [self drawPingZheng:CGRectMake(0, fbottom+10, viewtop.width, 50) andtitle:@"发货凭证" andvalue:orderModel.shoppics];
        [viewfhpz setTag:1];
        [scvback addSubview:viewfhpz];
        fbottom = viewfhpz.bottom;
    }
    
    
    
    
    ///
    UIView *vieworder = [self drawordermessage:CGRectMake(0, fbottom+10, viewtop.width, 100)];
    [scvback addSubview:vieworder];
    
    
    ///
    UIView *viewbottom = [self drawBottom:CGRectMake(0, vieworder.bottom, viewtop.width, 50) andtype:2];
    [self addSubview:viewbottom];
    
    [scvback setHeight:scvback.height-viewbottom.height];
    [viewbottom setTop:scvback.bottom];
    [scvback setContentSize:CGSizeMake(0, vieworder.bottom)];
    
}

#pragma mark - 头部订单状态 type 0新创建(待支付)  1未成团（拼单才有）2待下单 3待发货 4已发货 5已完成 10订单取消 ｝
-(UIView *)drawtop:(CGRect)rect andtype:(int)type
{
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGB(253,122,14)];
    NSString *strname=@"";
    NSString *strother=@"";
    if(orderModel.daigoutype.intValue == 1)
    {///直下
        switch (type) {
            case 0:
            {
                strname=@"等待买家付款";
                strother=@"10分钟未支付，订单将自动取消";
            }
                break;
            case 1:
            {
                strname=@"";
                strother=@"";
            }
                break;
            case 2:
            {
                strname=@"等待代购菌下单";
                strother=@"代购菌将尽快为您处理，请耐心等待";
            }
                break;
            case 3:
            {
                strname=@"代购菌已下单，等待卖家发货";
                strother=@"实际发货以购买平台为准";
            }
                break;
            case 4:
            {
                
                if([orderModel.strnodestatus isEqualToString:@"1"]||[orderModel.strnodestatus isEqualToString:@"2"]||[orderModel.strnodestatus isEqualToString:@"3"])
                {
                    strname=@"海外电商已发货";
                    strother=@"海淘特殊性，请随时关注物流";
                }
                else if([orderModel.strnodestatus isEqualToString:@"7"]||[orderModel.strnodestatus isEqualToString:@"810"]||[orderModel.strnodestatus isEqualToString:@"830"]||[orderModel.strnodestatus isEqualToString:@"840"])
                {
                    strname=@"商品已从转运仓库发出";
                    strother=@"发往中国，预计20-40个工作日，特殊情况除外";
                }
                else if([orderModel.strnodestatus isEqualToString:@"9"])
                {
                    strname=@"商品到达没得办公室";
                    strother=@"将在第一时间发出，请耐心等待";
                }
                else if([orderModel.strnodestatus isEqualToString:@"10"])
                {
                    strname=@"商品从没得比发出";
                    strother=@"等待买家收货，请面签";
                }
                else
                {
                    strname=@"卖家已发货，等待买家收货";
                    strother=@"海淘特殊性，请随时关注物流";
                }
                
                
            }
                break;
            case 5:
            {
                strname=@"交易完成";
                strother=@"";
            }
                break;
            default:
            {
                strname=@"订单已取消";
                strother=orderModel.remove_reason;
            }
                break;
        }
    }
    else
    {///2拼单
        switch (type) {
            case 0:
            {
                strname=@"待支付";
                strother=@"10分钟未支付，将自动取消订单";
            }
                break;
            case 1:
            {
                
                strname=[NSString stringWithFormat:@"待分享，差%@件",orderModel.remain_pindannum];
                strother=@"拼单更便宜，快邀请好友一起来买吧";
            }
                break;
            case 2:
            {
                strname=@"拼单成功，待买手下单";
                strother=@"代购菌将尽快为您处理，请耐心等待";
            }
                break;
            case 3:
            {
                strname=@"代购菌已下单，等待卖家发货";
                strother=@"实际发货以购买平台为准";
            }
                break;
            case 4:
            {
                
                if([orderModel.strnodestatus isEqualToString:@"1"]||[orderModel.strnodestatus isEqualToString:@"2"]||[orderModel.strnodestatus isEqualToString:@"3"])
                {
                    strname=@"海外电商已发货";
                    strother=@"海淘特殊性，请随时关注物流";
                }
                else if([orderModel.strnodestatus isEqualToString:@"7"]||[orderModel.strnodestatus isEqualToString:@"810"]||[orderModel.strnodestatus isEqualToString:@"830"]||[orderModel.strnodestatus isEqualToString:@"840"])
                {
                    strname=@"商品已从转运仓库发出";
                    strother=@"发往中国，预计20-40个工作日，特殊情况除外";
                }
                else if([orderModel.strnodestatus isEqualToString:@"9"])
                {
                    strname=@"商品到达没得比办公室";
                    strother=@"将在第一时间发出，请耐心等待";
                }
                else if([orderModel.strnodestatus isEqualToString:@"10"])
                {
                    strname=@"商品从没得比发出";
                    strother=@"等待买家收货，请面签";
                }
                else
                {
                    strname=@"卖家已发货，等待买家收货";
                    strother=@"海淘特殊性，请随时关注物流";
                }
            }
                break;
            case 5:
            {
                strname=@"交易完成";
                strother=@"";
            }
                break;
            default:
            {
                strname=@"订单已取消";
                strother=orderModel.remove_reason;
            }
                break;
        }
    }
    
    
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(38, 20, 250, 20)];
    [lbname setText:strname];
    [lbname setTextColor:RGB(255,255,255)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbname];
    if(strother.length > 0)
    {
        UILabel *lbother = [[UILabel alloc] initWithFrame:CGRectMake(lbname.left, lbname.bottom+5, view.width-76, 20)];
        if(type==10&&orderModel.refundstatus.intValue > 0)
        {
            [lbother setWidth:view.width-150];
        }
        [lbother setText:strother];
        [lbother setTextColor:RGB(255,255,255)];
        [lbother setTextAlignment:NSTextAlignmentLeft];
        [lbother setFont:[UIFont systemFontOfSize:12]];
        [lbother setNumberOfLines:2];
        [lbother sizeToFit];
        [view addSubview:lbother];
        
        [view setHeight:lbother.bottom+20];
    }
    else
    {
        [view setHeight:lbname.bottom+20];
    }
    
//    if(type==10&&orderModel.refundstatus.intValue > 0)
    if(orderModel.refundstatus.intValue > 0)//&&orderModel.refundstatus.intValue > 1
    {
        
        UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 150, 46*kScale)];
        [btleft.layer setMasksToBounds:YES];
        [btleft.layer setCornerRadius:6];
        [btleft.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btleft.layer setBorderWidth:1];
//        [btleft setBackgroundColor:RGB(156,156,156)];
        [btleft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btleft setTitle:[NSString stringWithFormat:@"退款详情"] forState:UIControlStateNormal];
        [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btleft sizeToFit];
        if(view.height/1.5<46*kScale)
        {
            [btleft setHeight:view.height/1.5];
        }
        else
        {
            [btleft setHeight:46*kScale];
        }
        
        [btleft setWidth:btleft.width+30];
        [btleft setCenterY:view.height/2.0];
        [btleft setRight:view.width-10];
        [view addSubview:btleft];
        [btleft addTarget:self action:@selector(btTuiKuanAction) forControlEvents:UIControlEventTouchUpInside];
        
    }

    
    
    return view;
}

#pragma mark - 快递到哪儿了
-(UIView *)drawFast:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kuaidiWuLiuAction)];
    [view addGestureRecognizer:tapview];
    
    UIImageView *imgvp = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 15, 15)];
    [imgvp setImage:[UIImage imageNamed:@"order_details_fast_wuliu"]];
    [view addSubview:imgvp];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(imgvp.right+10, imgvp.top, 250, imgvp.height)];
    [lbname setText:orderModel.logistics];
    [lbname setTextColor:RGB(101,177,84)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbname];
    
    [view setHeight:imgvp.bottom+15];
    
    UIImageView *imgvnext = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 12, 12)];
    [imgvnext setImage:[UIImage imageNamed:@"green_next"]];
    [view addSubview:imgvnext];
    [imgvnext setCenter:CGPointMake(0, view.height/2.0)];
    [imgvnext setRight:view.width-15];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
    [viewline setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewline];
    if(orderModel.logistics.length>0)
    {
        
    }
    else
    {
        [view setHeight:0];
        [view setHidden:YES];
    }
    return view;
}

#pragma mark - 地址信息
-(UIView *)drawAddress:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgvadd = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 15, 15)];
    [imgvadd setImage:[UIImage imageNamed:@"dingdan_address"]];
    [view addSubview:imgvadd];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(imgvadd.right+6, 17, view.width-60, 18)];
    [lbtext setText:[NSString stringWithFormat:@"%@，%@",orderModel.truename,orderModel.mobile]];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    UILabel *lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(lbtext.left, lbtext.bottom, lbtext.width, 25)];
    [lbtext1 setText:orderModel.address];
    [lbtext1 setTextColor:RGB(102,102,102)];
    [lbtext1 setTextAlignment:NSTextAlignmentLeft];
    [lbtext1 setFont:[UIFont systemFontOfSize:14]];
    [lbtext1 setNumberOfLines:2];
    [lbtext1 sizeToFit];
    [view addSubview:lbtext1];
    [view setHeight:lbtext1.bottom+17];
    
    
    [imgvadd setCenterY:view.height/2.0];
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    
    return view;
}

#pragma mark - 拼单
-(UIView *)drawpinDan:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    int icount = (int)orderModel.pindanusers.count;
    
    NSString *strname = @"";
    if(orderModel.status.intValue == 10)
    {
        strname = @"拼单失败";
        if(orderModel.pindanusers.count == 0)
        {
            [view setHeight:0];
            
            return view;
        }
    }
    else
    {
        if(orderModel.remain_pindannum.intValue>0 && orderModel.status.intValue > 0)
        {
            strname=[NSString stringWithFormat:@"待分享，差%@件",orderModel.remain_pindannum];
            
            icount+=1;
        }
        else
        {
            if(orderModel.pindanusers.count == 0)
            {
                [view setHeight:0];
                
                return view;
            }
            
            strname = @"拼单成功";
        }
    }
    
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(38, 15, 250, 20)];
    [lbname setText:strname];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [lbname sizeToFit];
    [lbname setHeight:20];
    [view addSubview:lbname];
    
    float fbottom = 0.0;
    
    if(icount>4)
    {
        icount = 4;
    }
    
    for(int i = 0 ; i <icount ; i++)
    {
        BOOL ishead = NO;
        if(i == 0)
        {
            ishead = YES;
        }
        
        UIImageView *imgv = [self drawimgHeader:CGRectMake(lbname.left+31*kScale*i, lbname.bottom+10, 31*kScale, 31*kScale) andhead:ishead];
        UIImageView *imgvson = [imgv viewWithTag:11];
        if(i==icount-1&&orderModel.remain_pindannum.integerValue>0)
        {
            [imgvson setImage:[UIImage imageNamed:@"pindanshenyuyonghutouxiang"]];
        }
        else
        {
            [[MDB_UserDefault defaultInstance] setViewWithImage:imgvson url:orderModel.pindanusers[i]];
        }
        [view addSubview:imgv];
        fbottom = imgv.bottom;
    }
    
    icount = (int)orderModel.pindanusers.count;
    if(orderModel.remain_pindannum.integerValue>0 && orderModel.status.intValue != 10&& orderModel.status.intValue > 0)
    {
        UILabel *lbtime = [[UILabel alloc] initWithFrame:CGRectMake(lbname.right, 25, view.width-lbname.right, 15)];
        [lbtime setText:[NSString stringWithFormat:@"%@结束",[MDB_UserDefault strTimefromData:orderModel.endtime.integerValue dataFormat:nil]]];
        [lbtime setTextColor:RGB(153,153,153)];
        [lbtime setTextAlignment:NSTextAlignmentCenter];
        [lbtime setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lbtime];
        
        UIButton *btyaoqing = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 71, 26)];
        [btyaoqing.layer setMasksToBounds:YES];
        [btyaoqing.layer setCornerRadius:4];
        [btyaoqing.layer setBorderColor:RGB(253,122,14).CGColor];
        [btyaoqing.layer setBorderWidth:1];
        [btyaoqing setTitle:@"邀请好友" forState:UIControlStateNormal];
        [btyaoqing setTitleColor:RGB(253,122,14) forState:UIControlStateNormal];
        [btyaoqing.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btyaoqing setCenter:CGPointMake(0, lbtime.bottom+13+13)];
        [btyaoqing setRight:view.width-10];
        [view addSubview:btyaoqing];
        [btyaoqing addTarget:self action:@selector(yaoqingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    [view setHeight:fbottom+15];
    
    
    UIView *viewlin3 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin3 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin3];
    
    return view;
}

-(UIImageView *)drawimgHeader:(CGRect)rect andhead:(BOOL)ishead
{
    UIImageView *imgvback = [[UIImageView alloc] initWithFrame:rect];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgvback.width, imgvback.height)];
    [imgv.layer setMasksToBounds:YES];
    [imgv.layer setCornerRadius:imgv.height/2.0];
    [imgv setClipsToBounds:YES];
    [imgvback addSubview:imgv];
    [imgv setTag:11];
    
    if(ishead)
    {
        UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, imgv.width-2, 14)];
        [lbname setText:@"团长"];
        [lbname setTextColor:RGB(255,255,255)];
        [lbname setTextAlignment:NSTextAlignmentCenter];
        [lbname setFont:[UIFont systemFontOfSize:10]];
        [lbname setBackgroundColor:RGB(253,122,14)];
        [imgvback addSubview:lbname];
    }
    
    
    
    return imgvback;
}

#pragma mark - 分享
-(UIView *)drawshareView:(CGRect)rect
{
    UIView *viewback = [[UIView alloc] initWithFrame:rect];
    [viewback setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *image = [UIImage imageNamed:@"dingdanxiagnqing_hongbao_back"];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, viewback.width, viewback.width*image.size.height/image.size.width)];
    [imgv setImage:image];
    [viewback addSubview:imgv];
    [imgv setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sharecaikaiAction)];
    [imgv addGestureRecognizer:tap];
    [viewback setHeight:imgv.bottom+15];
    
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, viewback.width-20, viewback.height-20)];
//    [view setBackgroundColor:[UIColor whiteColor]];
//    [view.layer setMasksToBounds:YES];
//    [view.layer setCornerRadius:5];
//    [view.layer setBorderColor:RGB(234, 234, 234).CGColor];
//    [view.layer setBorderWidth:1];
//    [viewback addSubview:view];
//
//    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, view.height*1.1, view.height-20)];
//    [imgv setBackgroundColor:[UIColor grayColor]];
//    [view addSubview:imgv];
//
//    UILabel *lbshop = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+10, 0, view.width-imgv.right-100, view.height)];
//    [lbshop setText:@"你有一个红包待领取"];
//    [lbshop setTextColor:RGB(30, 30, 30)];
//    [lbshop setTextAlignment:NSTextAlignmentLeft];
//    [lbshop setFont:[UIFont boldSystemFontOfSize:14]];
//    [view addSubview:lbshop];
//
//
//    UIButton *btcaikai = [[UIButton alloc] initWithFrame:CGRectMake(lbshop.right+10, 0, 70, 35)];
//    [btcaikai setBackgroundColor:RGB(234, 234, 234)];
//    [btcaikai setTitle:@"立即拆开" forState:UIControlStateNormal];
//    [btcaikai setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
//    [btcaikai.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [view addSubview:btcaikai];
//    [btcaikai setCenterY:view.height/2.0];
//    [btcaikai addTarget:self action:@selector(sharecaikaiAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewlin3 = [[UIView alloc] initWithFrame:CGRectMake(0, viewback.height-1,viewback.width , 1)];
    [viewlin3 setBackgroundColor:RGB(218,218,218)];
    [viewback addSubview:viewlin3];
    
    return viewback;
}

#pragma mark - 商品到货比较晚的提示
-(UIView *)drawMessageLayView:(CGRect)rect
{
    UIView *viewback = [[UIView alloc] initWithFrame:rect];
    [viewback setBackgroundColor:RGB(252, 247, 241)];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 15, 15)];
    [imgv setImage:[UIImage imageNamed:@"dingdanxiagnqing_laywuliu"]];
    [imgv setCenterY:viewback.height/2.0];
    [viewback addSubview:imgv];
    
    UILabel *lbcontent = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+10, 0, viewback.width-imgv.right-20, viewback.height)];
    [lbcontent setNumberOfLines:0];
    [lbcontent setTextColor:RGB(50, 50, 50)];
    [lbcontent setTextAlignment:NSTextAlignmentLeft];
    [lbcontent setFont:[UIFont systemFontOfSize:13]];
    [viewback addSubview:lbcontent];
    [self setLineSpace:5 withText:@"我理解和接受该海外电商网站及所在国家的转运公司可能因特殊情况导致订单耗时超过2个月，且部分电商不提供快递跟踪码。" inLabel:lbcontent];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewback.width, 1)];
    [viewline setBackgroundColor:RGB(252, 243, 237)];
    [viewback addSubview:viewline];
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(0, viewback.height-1, viewback.width, 1)];
    [viewline1 setBackgroundColor:RGB(252, 243, 237)];
    [viewback addSubview:viewline1];
    
    return viewback;
}

-(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

#pragma mark - 商品信息
-(UIView *)drawShangPin:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    UILabel *lbshop = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, view.width-20, 17)];
    [lbshop setText:orderModel.name];
    [lbshop setTextColor:RadMenuColor];
    [lbshop setTextAlignment:NSTextAlignmentLeft];
    [lbshop setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbshop];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, lbshop.bottom+17, view.width, 1)];
    [viewline setBackgroundColor:RGB(231,231,231)];
    [view addSubview:viewline];
    
    float fbottomtemp = viewline.bottom;
    int itag = 0;
    for(OrderDetaileGoodsModel *modeltemp in orderModel.goodsinfo)
    {
        UIView *viewgoods = [self drawgoodsInfo:modeltemp andframe:CGRectMake(0, fbottomtemp, view.width, 105)];
        [view addSubview:viewgoods];
        [viewgoods setTag:itag];
        itag++;
        
        UIView *viewlienitem = [[UIView alloc] initWithFrame:CGRectMake(0, viewgoods.bottom-1,view.width , 1)];
        [viewlienitem setBackgroundColor:RGB(218,218,218)];
        [view addSubview:viewlienitem];
        
        fbottomtemp = viewgoods.bottom;
    }
    
    
    ////邮费税费
    UILabel *lbotherprice = [[UILabel alloc] initWithFrame:CGRectMake(10, fbottomtemp+16, view.width-20, 20)];
    NSString *strsuifei = @"";
    if(orderModel.tariff.floatValue>0)
    {
        strsuifei = [NSString stringWithFormat:@"，税费%@元",orderModel.tariff];
        
    }
    [lbotherprice setText:[NSString stringWithFormat:@"国际邮费%@元%@（均为预估，多退少补）",orderModel.guoji_cost,strsuifei]];
    [lbotherprice setNumberOfLines:2];
    [lbotherprice setTextColor:RGB(153,153,153)];
    [lbotherprice setTextAlignment:NSTextAlignmentLeft];
    [lbotherprice setFont:[UIFont systemFontOfSize:12]];
    [lbotherprice sizeToFit];
    [view addSubview:lbotherprice];
    
    UIView *viewlin1 = [[UIView alloc] initWithFrame:CGRectMake(0, lbotherprice.bottom+15,view.width , 1)];
    [viewlin1 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin1];
    
    UILabel *lbkuaidi = [[UILabel alloc] initWithFrame:CGRectMake(lbotherprice.left, viewlin1.bottom+12, 70, 20)];
    [lbkuaidi setText:@"国内快递"];
    [lbkuaidi setTextColor:RGB(102,102,102)];
    [lbkuaidi setTextAlignment:NSTextAlignmentLeft];
    [lbkuaidi setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbkuaidi];
    
    UILabel *lbkuaidi1 = [[UILabel alloc] initWithFrame:CGRectMake(lbkuaidi.right, lbkuaidi.top, 270, lbkuaidi.height)];
    [lbkuaidi1 setText:[NSString stringWithFormat:@"%@（￥%@）",orderModel.express,orderModel.guonei_cost]];
    [lbkuaidi1 setTextColor:RGB(153,153,153)];
    [lbkuaidi1 setTextAlignment:NSTextAlignmentLeft];
    [lbkuaidi1 setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbkuaidi1];
    
    UIView *viewlin2 = [[UIView alloc] initWithFrame:CGRectMake(0, lbkuaidi.bottom+12,view.width , 1)];
    [viewlin2 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin2];
    
    float ftempbottom = viewlin2.bottom;
    ////
    if(orderModel.bounty_cost.floatValue>0)
    {
        
        UILabel *lbdikou = [[UILabel alloc] initWithFrame:CGRectMake(lbotherprice.left, viewlin2.bottom+12, 70, 20)];
        [lbdikou setText:@"抵扣运费"];
        [lbdikou setTextColor:RGB(102,102,102)];
        [lbdikou setTextAlignment:NSTextAlignmentLeft];
        [lbdikou setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lbdikou];
        
        UILabel *lblbdikou1 = [[UILabel alloc] initWithFrame:CGRectMake(lbdikou.right, lbdikou.top, 270, lbkuaidi.height)];
        [lblbdikou1 setText:[NSString stringWithFormat:@"￥%@", orderModel.bounty_cost]];
        [lblbdikou1 setTextColor:RGB(153,153,153)];
        [lblbdikou1 setTextAlignment:NSTextAlignmentLeft];
        [lblbdikou1 setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lblbdikou1];
        
        
        UIView *viewlin21 = [[UIView alloc] initWithFrame:CGRectMake(0, lblbdikou1.bottom+12,view.width , 1)];
        [viewlin21 setBackgroundColor:RGB(218,218,218)];
        [view addSubview:viewlin21];
        ftempbottom = viewlin21.bottom;
    }
    /////商品抵扣
    if(orderModel.coupon_cost.floatValue>0)
    {
        
        UILabel *lbdikou = [[UILabel alloc] initWithFrame:CGRectMake(lbotherprice.left, ftempbottom+12, 70, 20)];
        [lbdikou setText:@"商品抵扣"];
        [lbdikou setTextColor:RGB(102,102,102)];
        [lbdikou setTextAlignment:NSTextAlignmentLeft];
        [lbdikou setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lbdikou];
        
        UILabel *lblbdikou1 = [[UILabel alloc] initWithFrame:CGRectMake(lbdikou.right, lbdikou.top, 270, lbkuaidi.height)];
        [lblbdikou1 setText:[NSString stringWithFormat:@"￥%@", orderModel.coupon_cost]];
        [lblbdikou1 setTextColor:RGB(153,153,153)];
        [lblbdikou1 setTextAlignment:NSTextAlignmentLeft];
        [lblbdikou1 setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lblbdikou1];
        
        
        UIView *viewlin21 = [[UIView alloc] initWithFrame:CGRectMake(0, lblbdikou1.bottom+12,view.width , 1)];
        [viewlin21 setBackgroundColor:RGB(218,218,218)];
        [view addSubview:viewlin21];
        ftempbottom = viewlin21.bottom;
    }
    
    
    UILabel *lballprice = [[UILabel alloc] initWithFrame:CGRectMake(10, ftempbottom+18, view.width-20, 20)];
    if(orderModel.daigoutype.intValue == 2)
    {
        [lballprice setText:[NSString stringWithFormat:@"拼单价：¥%@",orderModel.totalprice]];
    }
    else
    {
        [lballprice setText:[NSString stringWithFormat:@"总价：¥%@",orderModel.totalprice]];
    }
    
    [lballprice setTextColor:RGB(243,93,0)];
    [lballprice setTextAlignment:NSTextAlignmentRight];
    [lballprice setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:lballprice];
    
    
    UILabel *lbpoundage_cost = [[UILabel alloc] initWithFrame:CGRectMake(10, lballprice.bottom, view.width-20, 15)];
    [lbpoundage_cost setText:[NSString stringWithFormat:@"（含手续费%@元）",orderModel.poundage_cost]];
    [lbpoundage_cost setTextColor:RGB(151,151,151)];
    [lbpoundage_cost setTextAlignment:NSTextAlignmentRight];
    [lbpoundage_cost setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbpoundage_cost];
    
    
    [view setHeight:lbpoundage_cost.bottom+18];
    
    
    UIView *viewlin3 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin3 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin3];
    
    return view;
}

///商品信息
-(UIView *)drawgoodsInfo:(OrderDetaileGoodsModel *)model andframe:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgvhead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 71, 71)];
    [imgvhead.layer setMasksToBounds:YES];
    [imgvhead.layer setCornerRadius:4];
    [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:model.image];
    [view addSubview:imgvhead];
    [imgvhead setUserInteractionEnabled:YES];
    UITapGestureRecognizer *taphead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsAction:)];
    [imgvhead addGestureRecognizer:taphead];
    [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
    imgvheadicon = imgvhead;
    
    UILabel *lbzhiyou = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 45, 17)];
    [lbzhiyou setText:@"直邮"];
    [lbzhiyou setTextColor:RGB(230,56,47)];
    [lbzhiyou setTextAlignment:NSTextAlignmentCenter];
    [lbzhiyou setFont:[UIFont systemFontOfSize:13]];
    [lbzhiyou.layer setMasksToBounds:YES];
    [lbzhiyou.layer setCornerRadius:2];
    [lbzhiyou.layer setBorderColor:RGB(230,56,47).CGColor];
    [lbzhiyou.layer setBorderWidth:1];
    [lbzhiyou sizeToFit];
    [lbzhiyou setHeight:17];
    [lbzhiyou setWidth:lbzhiyou.width+6];
    [view addSubview:lbzhiyou];
//    if([orderModel.transfertype intValue] == 2)
//    {
//        [lbzhiyou setHidden:NO];
//    }
//    else
//    {
//        [lbzhiyou setHidden:YES];
//    }
    [lbzhiyou setHidden:YES];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(imgvhead.right+10, imgvhead.top, view.width-imgvhead.right-90, 40)];
    [lbtitle setText:model.title];
    [lbtitle setTextColor:RGB(102,102,102)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:13]];
    [lbtitle setNumberOfLines:3];
    [view addSubview:lbtitle];
    [lbtitle setUserInteractionEnabled:YES];
    UITapGestureRecognizer *taptitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsAction:)];
    [lbtitle addGestureRecognizer:taptitle];
    
    UILabel *lbprice = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.right, lbtitle.top, view.width-lbtitle.right-10, lbtitle.height)];
    [lbprice setText:[NSString stringWithFormat:@"￥%@", model.price]];
    [lbprice setTextColor:RGB(243,93,0)];
    [lbprice setTextAlignment:NSTextAlignmentRight];
    [lbprice setFont:[UIFont systemFontOfSize:13]];
    [lbprice setNumberOfLines:2];
    [view addSubview:lbprice];
    
    ///颜色尺码
    UILabel *lbcmcolor = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom, lbtitle.width, 35)];
    [lbcmcolor setText:model.spec_val];
    [lbcmcolor setTextColor:RGB(153,153,153)];
    [lbcmcolor setTextAlignment:NSTextAlignmentLeft];
    [lbcmcolor setFont:[UIFont systemFontOfSize:12]];
    [lbcmcolor setNumberOfLines:2];
    [lbcmcolor sizeToFit];
    if(lbcmcolor.height<20)
    {
        [lbcmcolor setHeight:20];
    }
    [view addSubview:lbcmcolor];
    
    UILabel *lbnumber = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.right, lbcmcolor.top, lbprice.width, lbcmcolor.height)];
    [lbnumber setText:[NSString stringWithFormat:@"x%@",model.num]];
    [lbnumber setTextColor:RGB(153,153,153)];
    [lbnumber setTextAlignment:NSTextAlignmentRight];
    [lbnumber setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbnumber];
    
    
    return view;
}

#pragma mark - 订单备注
-(UIView *)drawBeizu:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, view.height)];
    [lbname setText:@"订单备注"];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbname];
    
    UILabel *lbother = [[UILabel alloc] initWithFrame:CGRectMake(lbname.right, 0, view.width-lbname.right-10, view.height)];
    [lbother setText:orderModel.remark];
    [lbother setTextColor:RGB(153,153,153)];
    [lbother setTextAlignment:NSTextAlignmentLeft];
    [lbother setFont:[UIFont systemFontOfSize:12]];
    [lbother setNumberOfLines:0];
    [lbother setHeight:lbother.height+20];
    [view addSubview:lbother];
    
    
    [view setHeight:lbother.bottom];
    [lbname setHeight:view.height];
    
    UIView *viewlin3 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin3 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin3];
    
    return view;
}


#pragma mark - 身份证号码
-(UIView *)drawSFNumber:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, view.height)];
    [lbname setText:@"身份证号"];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbname];
    
    UILabel *lbother = [[UILabel alloc] initWithFrame:CGRectMake(lbname.right, 0, view.width-lbname.right-10, view.height)];
    [lbother setText:orderModel.idcard];
    [lbother setTextColor:RGB(153,153,153)];
    [lbother setTextAlignment:NSTextAlignmentLeft];
    [lbother setFont:[UIFont systemFontOfSize:12]];
    [lbother setNumberOfLines:0];
    [lbother setHeight:lbother.height+20];
    [view addSubview:lbother];
    
    
    [view setHeight:lbother.bottom];
    [lbname setHeight:view.height];
    
    UIView *viewlin3 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin3 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin3];
    
    return view;
}

#pragma mark -///身份证信息
-(UIView *)drawShenFen:(CGRect)rect andvalue:(NSArray *)arrvalue
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 250, 25)];
    [lbtext setText:@"身份证信息（身份证正反面）"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    UILabel *lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(lbtext.left, lbtext.bottom, 250, 20)];
    [lbtext1 setText:@"身份证姓名必须与收货人一致"];
    [lbtext1 setTextColor:RGB(153,153,153)];
    [lbtext1 setTextAlignment:NSTextAlignmentLeft];
    [lbtext1 setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtext1];
    
    float fitemwh = (view.width-50)/4.0;
    
    NSMutableArray *arrtemp = [NSMutableArray arrayWithObjects:orderModel.front_pic,orderModel.back_pic, nil];
    float fbottom = 0.0;
    for(int i = 0 ; i < arrtemp.count; i++)
    {///
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10+(fitemwh+10)*i, lbtext1.bottom+12, fitemwh, fitemwh)];
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:arrtemp[i]];
        [view addSubview:imgv];
        fbottom = imgv.bottom;
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        [imgv setUserInteractionEnabled:YES];
        [imgv setTag:i];
        UITapGestureRecognizer *tapimgvsf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shenfenImageAction:)];
        [imgv addGestureRecognizer:tapimgvsf];
    }
    
    
    
    [view setHeight:fbottom+15];
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    return view;
}


#pragma mark - 支付方式
-(UIView *)drawPayType:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, view.height)];
    [lbname setText:@"支付方式"];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbname];
    
    UILabel *lbother = [[UILabel alloc] initWithFrame:CGRectMake(lbname.right, 0, view.width-lbname.right-10, view.height)];
    if(orderModel.paytype.intValue == 1)
    {
        [lbother setText:@"支付宝"];
    }
    else if(orderModel.paytype.intValue == 2)
    {
        [lbother setText:@"微信"];
    }
    else if(orderModel.paytype.intValue == 3)
    {
        [lbother setText:@"余额"];
    }
    
    [lbother setTextColor:RGB(153,153,153)];
    [lbother setTextAlignment:NSTextAlignmentLeft];
    [lbother setFont:[UIFont systemFontOfSize:12]];
    [lbother setNumberOfLines:0];
    [lbother setHeight:lbother.height+10];
    [view addSubview:lbother];
    
    [view setHeight:lbother.bottom];
    [lbname setHeight:view.height];
    
    UIView *viewlin3 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin3 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin3];
    
    return view;
}

#pragma mark - 购买凭证 发货凭证
-(UIView *)drawPingZheng:(CGRect)rect andtitle:(NSString *)strtitle andvalue:(NSArray *)arrvalue
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 170, 45)];
    [lbname setText:strtitle];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbname];
    
    UIScrollView *scvitem = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lbname.bottom, view.width, 81*kScale)];
    [view addSubview:scvitem];
    float fleft = 10;
    for(NSString *strurl in arrvalue)
    {
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(fleft, 0, 161*kScale, 81*kScale)];
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:strurl];
        [imgv.layer setMasksToBounds:YES];
        [imgv.layer setCornerRadius:4];
        [scvitem addSubview:imgv];
        [imgv setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapimagev = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
        [imgv addGestureRecognizer:tapimagev];
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        [view setHeight:scvitem.bottom+15];
        fleft = imgv.right+10;
        
    }
    [scvitem setContentSize:CGSizeMake(fleft, 0)];
    [scvitem setShowsHorizontalScrollIndicator:NO];
    [scvitem setShowsVerticalScrollIndicator:NO];
    
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    if(arrvalue.count<1)
    {
        [view setHeight:0];
        [view setHidden:YES];
    }
    
    return view;
}

#pragma mark - 订单信息
-(UIView *)drawordermessage:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGB(249,249,249)];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 45)];
    [lbname setText:[NSString stringWithFormat:@"联系没得比客服：QQ %@",orderModel.qq]];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentCenter];
    [lbname setFont:[UIFont systemFontOfSize:12]];
    [lbname setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:lbname];
    [lbname setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapname = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QQAction)];
    [lbname addGestureRecognizer:tapname];
    
    UIView *vieworder = [[UIView alloc] initWithFrame:CGRectMake(0, lbname.bottom, view.width, 100)];
    [view addSubview:vieworder];
    NSArray *arrvalue ;
    
    ////｛0新创建(待支付)  1未成团（拼单才有）2待下单 3待发货 4已发货 5已完成 10订单取消 ｝
    if(orderModel.status.intValue<4)
    {
        
        arrvalue = [NSArray arrayWithObjects:[NSString stringWithFormat:@"订单编号：%@",orderModel.orderno],[NSString stringWithFormat:@"下单时间：%@",[MDB_UserDefault strTimefromData:orderModel.addtime.integerValue dataFormat:nil]], nil];
    }
    else if (orderModel.status.intValue<=5)
    {
        if(orderModel.domestic.length<2)
        {
            arrvalue = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:@"订单编号：%@",orderModel.orderno],
                        [NSString stringWithFormat:@"下单时间：%@",[MDB_UserDefault strTimefromData:orderModel.addtime.integerValue dataFormat:nil]],
                        [NSString stringWithFormat:@"发货时间：%@",[MDB_UserDefault strTimefromData:orderModel.sendtime.integerValue dataFormat:nil]],
                        nil];//发货时间
        }
        else
        {
            arrvalue = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:@"订单编号：%@",orderModel.orderno],
                        [NSString stringWithFormat:@"下单时间：%@",[MDB_UserDefault strTimefromData:orderModel.addtime.integerValue dataFormat:nil]],
                        [NSString stringWithFormat:@"发货时间：%@",[MDB_UserDefault strTimefromData:orderModel.sendtime.integerValue dataFormat:nil]],
                        [NSString stringWithFormat:@"快递方式：%@",orderModel.domestic], nil];//发货时间
        }
    }
    else if (orderModel.status.intValue == 10)
    {
        arrvalue = [NSArray arrayWithObjects:
                    [NSString stringWithFormat:@"订单编号：%@",orderModel.orderno],
                    [NSString stringWithFormat:@"下单时间：%@",[MDB_UserDefault strTimefromData:orderModel.addtime.integerValue dataFormat:nil]],
                    [NSString stringWithFormat:@"取消时间：%@",[MDB_UserDefault strTimefromData:orderModel.removetime.integerValue dataFormat:nil]],
                    [NSString stringWithFormat:@"取消原因：%@",orderModel.remove_reason], nil];
    }
    
    
    float fbottom = lbname.bottom;
    for(int i = 0 ; i < arrvalue.count; i++)
    {
        UILabel *lb = [self draworderlb:CGRectMake(10, 5+20*i, vieworder.width-20, 20) andvalue:arrvalue[i]];
        [vieworder addSubview:lb];
        fbottom = lb.bottom+5;
    }
    [vieworder setHeight:fbottom];
    [view setHeight:vieworder.bottom];
    
    UIButton *btcopy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*kScale, 30*kScale)];
//    [btcopy setTitle:@"复制" forState:UIControlStateNormal];
//    [btcopy setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
//    [btcopy.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [btcopy.layer setMasksToBounds:YES];
//    [btcopy.layer setCornerRadius:2];
//    [btcopy.layer setBorderColor:RGB(102,102,102).CGColor];
//    [btcopy.layer setBorderWidth:1];
    [btcopy setTop:0];
    [btcopy setRight:vieworder.width-10];
    [vieworder addSubview:btcopy];
    [btcopy addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbcopy = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30*kScale, 17*kScale)];
    [lbcopy setText:@"复制"];
    [lbcopy setTextColor:RGB(51,51,51)];
    [lbcopy setFont:[UIFont systemFontOfSize:12]];
    [lbcopy setTextAlignment:NSTextAlignmentCenter];
    [lbcopy.layer setMasksToBounds:YES];
    [lbcopy.layer setCornerRadius:2];
    [lbcopy.layer setBorderColor:RGB(102,102,102).CGColor];
    [lbcopy.layer setBorderWidth:1];
    [lbcopy setTop:7];
    [lbcopy setRight:btcopy.width];
    [btcopy addSubview:lbcopy];
    
    
    return view;
}

-(UILabel *)draworderlb:(CGRect)rect andvalue:(NSString *)strvalue
{
    UILabel *lbname = [[UILabel alloc] initWithFrame:rect];
    [lbname setText:strvalue];
    [lbname setTextColor:RGB(153,153,153)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:12]];
    
    
    return lbname;
}

#pragma mark - 底部按钮 itype 1/2/3/4
-(UIView *)drawBottom:(CGRect)rect andtype:(int)itype
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    if(orderModel.daigoutype.integerValue == 1)
    {///直接下单
        
        if([orderModel.status intValue] == 0)
        {
            UIButton *btright = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 150, 46*kScale)];
            [btright.layer setMasksToBounds:YES];
            [btright.layer setCornerRadius:6];
            [btright setBackgroundColor:RGB(253,122,14)];
            [btright setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btright setTitle:[NSString stringWithFormat:@"¥%@立即支付",orderModel.totalprice] forState:UIControlStateNormal];
            [btright.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btright sizeToFit];
            [btright setHeight:46*kScale];
            [btright setWidth:btright.width+30];
            [btright setRight:view.width-10];
            [view addSubview:btright];
            [btright setTag:0];
            [btright addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 150, 46*kScale)];
            [btleft.layer setMasksToBounds:YES];
            [btleft.layer setCornerRadius:6];
            [btleft setBackgroundColor:RGB(156,156,156)];
            [btleft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btleft setTitle:[NSString stringWithFormat:@"取消订单"] forState:UIControlStateNormal];
            [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btleft sizeToFit];
            [btleft setHeight:46*kScale];
            [btleft setWidth:btleft.width+30];
            [btleft setRight:btright.left-10];
            [view addSubview:btleft];
            [btleft setTag:10];
            [btleft addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btleft.bottom+15];
        }
        else if([orderModel.status intValue] == 4)
        {
            UIButton *btright = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btright.layer setMasksToBounds:YES];
            [btright.layer setCornerRadius:6];
            [btright setBackgroundColor:RGB(253,122,14)];
            [btright setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btright setTitle:[NSString stringWithFormat:@"确认收货"] forState:UIControlStateNormal];
            [btright.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btright sizeToFit];
            [btright setHeight:46*kScale];
            [btright setWidth:btright.width+30];
            [btright setRight:view.width-10];
            [view addSubview:btright];
            [btright setTag:1];
            [btright addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btleft.layer setMasksToBounds:YES];
            [btleft.layer setCornerRadius:6];
            [btleft setBackgroundColor:RGB(156,156,156)];
            [btleft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btleft setTitle:[NSString stringWithFormat:@"查看物流"] forState:UIControlStateNormal];
            [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btleft sizeToFit];
            [btleft setHeight:46*kScale];
            [btleft setWidth:btleft.width+30];
            [btleft setRight:btright.left-10];
            [view addSubview:btleft];
            [btleft setTag:2];
            [btleft addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btleft.bottom+15];
        }
        else if([orderModel.status intValue] == 10)
        {
            UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btleft.layer setMasksToBounds:YES];
            [btleft.layer setCornerRadius:6];
            [btleft setBackgroundColor:RGB(156,156,156)];
            [btleft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btleft setTitle:[NSString stringWithFormat:@"删除订单"] forState:UIControlStateNormal];
            [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btleft sizeToFit];
            [btleft setHeight:46*kScale];
            [btleft setWidth:btleft.width+40];
            [btleft setRight:view.width-10];
            [view addSubview:btleft];
            [btleft setTag:11];
            [btleft addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btleft.bottom+15];
            
        }
        else if([orderModel.status intValue] == 5)
        {
            UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btleft.layer setMasksToBounds:YES];
            [btleft.layer setCornerRadius:6];
            [btleft.layer setBorderColor:RadMenuColor.CGColor];
            [btleft.layer setBorderWidth:1];
            [btleft setBackgroundColor:[UIColor whiteColor]];
            [btleft setTitleColor:RadMenuColor forState:UIControlStateNormal];
            [btleft setTitle:[NSString stringWithFormat:@"晒单赢优惠券"] forState:UIControlStateNormal];
            [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btleft sizeToFit];
            [btleft setHeight:46*kScale];
            [btleft setWidth:btleft.width+40];
            [btleft setRight:view.width-10];
            [view addSubview:btleft];
            [btleft setTag:5];
            [btleft addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btleft.bottom+15];
            
        }
        else
        {
            /*else if([_model.status intValue] == 2||[_model.status intValue] == 3||[_model.status intValue] == 5)
             {
             没得按钮
             }
             */
            [view setHeight:0];
        }
    }
    else
    {///拼单
        if([orderModel.status intValue] == 0)
        {
            UIButton *btright = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btright.layer setMasksToBounds:YES];
            [btright.layer setCornerRadius:6];
            [btright setBackgroundColor:RGB(253,122,14)];
            [btright setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btright setTitle:[NSString stringWithFormat:@"¥%@立即支付",orderModel.totalprice] forState:UIControlStateNormal];
            [btright.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btright sizeToFit];
            [btright setHeight:46*kScale];
            [btright setWidth:btright.width+30];
            [btright setRight:view.width-10];
            [view addSubview:btright];
            [btright setTag:0];
            [btright addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btleft.layer setMasksToBounds:YES];
            [btleft.layer setCornerRadius:6];
            [btleft setBackgroundColor:RGB(156,156,156)];
            [btleft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btleft setTitle:[NSString stringWithFormat:@"取消订单"] forState:UIControlStateNormal];
            [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btleft sizeToFit];
            [btleft setHeight:46*kScale];
            [btleft setWidth:btleft.width+30];
            [btleft setRight:btright.left-10];
            [view addSubview:btleft];
            [btleft setTag:10];
            [btleft addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btleft.bottom+15];
        }
        else if ([orderModel.status intValue] == 1)
        {
            UIButton *btright = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btright.layer setMasksToBounds:YES];
            [btright.layer setCornerRadius:6];
            [btright setBackgroundColor:RGB(253,122,14)];
            [btright setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btright setTitle:[NSString stringWithFormat:@"邀请好友"] forState:UIControlStateNormal];
            [btright.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btright sizeToFit];
            [btright setHeight:46*kScale];
            [btright setWidth:btright.width+30];
            [btright setRight:view.width-10];
            [view addSubview:btright];
            [btright setTag:3];
            [btright addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btright.bottom+15];
        }
        else if([orderModel.status intValue] == 4)
        {
            UIButton *btright = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btright.layer setMasksToBounds:YES];
            [btright.layer setCornerRadius:6];
            [btright setBackgroundColor:RGB(253,122,14)];
            [btright setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btright setTitle:[NSString stringWithFormat:@"确认收货"] forState:UIControlStateNormal];
            [btright.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btright sizeToFit];
            [btright setHeight:46*kScale];
            [btright setWidth:btright.width+30];
            [btright setRight:view.width-10];
            [view addSubview:btright];
            [btright setTag:1];
            [btright addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btleft.layer setMasksToBounds:YES];
            [btleft.layer setCornerRadius:6];
            [btleft setBackgroundColor:RGB(156,156,156)];
            [btleft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btleft setTitle:[NSString stringWithFormat:@"查看物流"] forState:UIControlStateNormal];
            [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btleft sizeToFit];
            [btleft setHeight:46*kScale];
            [btleft setWidth:btleft.width+30];
            [btleft setRight:btright.left-10];
            [view addSubview:btleft];
            [btleft setTag:2];
            [btleft addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btleft.bottom+15];
        }
        else if([orderModel.status intValue] == 10)
        {
            UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btleft.layer setMasksToBounds:YES];
            [btleft.layer setCornerRadius:6];
            [btleft setBackgroundColor:RGB(156,156,156)];
            [btleft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btleft setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
            [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btleft sizeToFit];
            [btleft setHeight:46*kScale];
            [btleft setWidth:btleft.width+40];
            [btleft setRight:view.width-10];
            [view addSubview:btleft];
            [btleft setTag:11];
            [btleft addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btleft.bottom+15];
        }
        else if([orderModel.status intValue] == 5)
        {
            UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 150, 46*kScale)];
            [btleft.layer setMasksToBounds:YES];
            [btleft.layer setCornerRadius:6];
            [btleft.layer setBorderColor:RadMenuColor.CGColor];
            [btleft.layer setBorderWidth:1];
            [btleft setBackgroundColor:[UIColor whiteColor]];
            [btleft setTitleColor:RadMenuColor forState:UIControlStateNormal];
            [btleft setTitle:[NSString stringWithFormat:@"晒单赢优惠券"] forState:UIControlStateNormal];
            [btleft.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btleft sizeToFit];
            [btleft setHeight:46*kScale];
            [btleft setWidth:btleft.width+40];
            [btleft setRight:view.width-10];
            [view addSubview:btleft];
            [btleft setTag:5];
            [btleft addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view setHeight:btleft.bottom+15];
            
        }
        else
        {
            /*else if([_model.status intValue] == 2||[_model.status intValue] == 3||[_model.status intValue] == 5)
             {
             没得按钮
             }
             */
            [view setHeight:0];
        }
    }
    
    
    return view;
}

#pragma mark - 底部按钮 0支付  1确认收货  2查看物流  3邀请好友  10取消订单  11删除
-(void)bottomAction:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 0:
        {
            DaiGouZhiFuViewController *dvc = [[DaiGouZhiFuViewController alloc] init];
            dvc.strorderid = orderModel.orderno;
            dvc.strprice = orderModel.totalprice;
            dvc.strdid = orderModel.did;
            dvc.strgoodsid = orderModel.goods_id;
            [self.viewController.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 1:
        {///1确认收货
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定收货" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag = 102;
            [alter show];
        }
            break;
        case 2:
        {
            OrderLogisticsViewController *ovc = [[OrderLogisticsViewController alloc] init];
            ovc.strorder_id = orderModel.did;
            [self.viewController.navigationController pushViewController:ovc animated:YES];
        }
            break;
        case 3:
        {///3邀请好友
            [self yaoqingAction];
        }
            break;
        case 5:
        {///5晒单赢优惠券
            
            
            if(dataControllink==nil)
            {
                dataControllink = [[MyInformMessageDataController alloc] init];
            }
            NSDictionary *dicpush = @{@"id":orderModel.did,@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
            [dataControllink requestMyInformYuanChuangKaPianInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
                if(state)
                {
                    if(dataControllink.dicmessage != nil)
                    {
                        arrshaidanyyhq = [dataControllink.dicmessage objectForKey:@"linkUrl"];
                        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"yindaoyonghushouhuohoubaoliao"] integerValue] == 1)
                        {
                            PushYuanChuangViewController *pvc = [[PushYuanChuangViewController alloc] init];
                            pvc.arrbaoliaourl = arrshaidanyyhq;
                            [self.viewController.navigationController pushViewController:pvc animated:YES];
                        }
                        else
                        {
                            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最高获得¥10.00优惠券，优惠券将在晒单审核通过后发放至账户中!" delegate:self cancelButtonTitle:@"立即晒单" otherButtonTitles:@"取消", nil];
                            [alter setTag:11110];
                            [alter show];
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"yindaoyonghushouhuohoubaoliao"];
                            
                        }
                    }
                    else
                    {
                        //                        [MDB_UserDefault showNotifyHUDwithtext:@"消息发生未知错误" inView:self.view];
                    }
                    
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                }
            }];
            
        }
            break;

        case 10:
        {///10取消订单
            if(otherDataControl==nil)
            {
                otherDataControl = [[MyOrderMainDataController alloc] init];
            }
            if(otherDataControl.arrcancleReason == nil)
            {
                
                [otherDataControl requestCancleOrderReasonDataInView:self.window dicpush:@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]} Callback:^(NSError *error, BOOL state, NSString *describle) {
                    
                    if(state)
                    {
                        NSLog(@"%@",otherDataControl.arrcancleReason);
                        UIActionSheet *ashat = [[UIActionSheet alloc] initWithTitle:@"取消订单原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                        for(NSDictionary *dic in otherDataControl.arrcancleReason)
                        {
                            [ashat addButtonWithTitle:[dic objectForKey:@"content"]];
                        }
                        [ashat addButtonWithTitle:@"其他"];
                        [ashat showInView:self];
                    }
                    else
                    {
                        [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.window];
                    }
                    
                }];
            }
            else
            {
                UIActionSheet *ashat = [[UIActionSheet alloc] initWithTitle:@"取消订单原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                for(NSDictionary *dic in otherDataControl.arrcancleReason)
                {
                    [ashat addButtonWithTitle:[dic objectForKey:@"content"]];
                }
                [ashat addButtonWithTitle:@"其他"];
                [ashat showInView:self];
                
            }
            
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单原因" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alter.alertViewStyle = UIAlertViewStylePlainTextInput;
//            alter.tag = 101;
//            [alter show];
        }
            break;
        case 11:
        {///11删除
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除该订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag = 103;
            [alter show];
        }
            break;
        default:
            break;
    }
    
    
}


#pragma mark - copy
-(void)copyAction
{
    
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string=orderModel.orderno;
    [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:self];
    
}
#pragma mark - 立即拆开
int inumshare = 0;
-(void)sharecaikaiAction
{
//    ShareHongBaoView *sview = [[ShareHongBaoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andtitle:@"恭喜获得8个红包" andcontent:@"分享给小伙伴，大家一起领"];
//    [self addSubview:sview];
//    return;
    if(inumshare>3)
    {
        
        return;
    }
    ////需要更改链接 落地页
    if(strsharecouurl.length<6)
    {
        if(orderModel.couponinfortype.integerValue == 1)
        {
            [self getyouhuiquanShare:self];
        }
        else
        {
            [self getsherehongbao:self];
        }
        inumshare++;
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *images=[UIImage imageNamed:@"icon120.png"];
    
    NSArray* imageArray = images==nil?@[]:@[images];
    
    
    NSString *strtitle = [NSString stringWithFormat:@"你有一个红包待领取！第%@个最大！",strsharecoumaxnumber];
    
    NSString *strcontent = @"没得比一键海淘，带你淘遍世界好物~";
    
    [shareParams SSDKSetupShareParamsByText:strcontent
                                     images:imageArray
                                        url:[NSURL URLWithString:strsharecouurl]
                                      title:strtitle
                                       type:SSDKContentTypeAuto];
    
//
//    
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil image:images url:[NSURL URLWithString:orderModel.link] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    
    //    [shareParams SSDKSetupTencentWeiboShareParamsByText:strcontent images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
    
    NSString *shareWeChatTitle = strtitle;
//    [shareParams SSDKSetupWeChatParamsByText:strcontent title:shareWeChatTitle url:[NSURL URLWithString:strsharecouurl] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    ///分享更改
    [shareParams SSDKSetupWeChatParamsByText:strcontent title:shareWeChatTitle url:[NSURL URLWithString:strsharecouurl] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    
    ///分享更改
    [ShareSDK showShareActionSheet:self customItems:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)] shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
    }];
    //2、分享
//    [ShareSDK showShareActionSheet:self
//                             items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   //                           [self.dataController requestShareRecordDataWithUrl:share.url callback:^(NSError *error, BOOL state, NSString *describle) {
//                   //                           }];
//                   NSLog(@"sdfasdf");
//               }];
}

#pragma mark - 邀请好友
int innumshare1 = 1;
-(void)yaoqingAction
{
    Qqshare *share = dataControl.resultShareInfo;
    if (share)
    {
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:share.image];
        
        UIImage *images=[imgv.image imageByScalingProportionallyToSize:CGSizeMake(120.0, 120.0)];
        if(images==nil)
        {
            images=[UIImage imageNamed:@"pucdNot.png"];
        }
        
        imgv = nil;
        
        
        NSArray* imageArray = images==nil?@[]:@[images];
        OrderDetaileGoodsModel *model;
        @try
        {
            model = orderModel.goodsinfo[0];
        }
        @catch (NSException *exc)
        {
            
        }
        @finally
        {
            
        }
        
        NSString *strtitle = [NSString stringWithFormat:@"代购价￥%@，%@",model.price, model.title];
        
        NSString *strprice = [NSString stringWithFormat:@"%.2lf",orderModel.price.floatValue+orderModel.tariff.floatValue+orderModel.guoji_cost.floatValue+orderModel.guonei_cost.floatValue];
        
        NSString *strcontent = [NSString nullToString:[NSString stringWithFormat:@"代购价￥%@", strprice]];
        if(orderModel.pindanusers > 0)
        {
            strcontent = [NSString nullToString:[NSString stringWithFormat:@"还差%d件成团", orderModel.remain_pindannum.intValue]];
            
            strtitle = [NSString stringWithFormat:@"拼单价￥%@，%@",model.price, model.title];
        }
        
        [shareParams SSDKSetupShareParamsByText:strcontent
                                         images:imageArray
                                            url:[NSURL URLWithString:share.url]
                                          title:strtitle
                                           type:SSDKContentTypeAuto];
        
        
        
        NSString *strimageurl =model.image;
        if(strimageurl.length>6)
        {
//            [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil image:strimageurl url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            ///分享更改
            [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil images:strimageurl video:nil url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
        }
        else
        {
//            [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil image:images url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            ///分享更改
            [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil images:images video:nil url:[NSURL URLWithString:share.url] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
        }
        
        //    [shareParams SSDKSetupTencentWeiboShareParamsByText:strcontent images:images latitude:0 longitude:0 type:SSDKContentTypeAuto];
        
        NSString *shareWeChatTitle = strtitle;
//        [shareParams SSDKSetupWeChatParamsByText:strcontent title:shareWeChatTitle url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        ///分享更改
        [shareParams SSDKSetupWeChatParamsByText:strcontent title:shareWeChatTitle url:[NSURL URLWithString:share.url] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        if(share.applet_url.length>6)
        {
            
            if([[MDB_UserDefault defaultInstance] imagediskImageExistsForURL:share.image])
            {
                images = [[MDB_UserDefault defaultInstance] getImageExistsForURL:share.image];
            }
            else
            {
                images = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:share.image]]];
                [[MDB_UserDefault defaultInstance] setSaveImageToCache:images forURL:[NSURL URLWithString:share.image]];
            }
            
            
            images=[images imageByScalingProportionallyToSize:CGSizeMake(images.size.width, images.size.width/4*3)];//
            if(UIImagePNGRepresentation(images).length>36720)
            {
                images=[images imageByScalingProportionallyToSize:CGSizeMake(images.size.width*0.8, images.size.height*0.8)];
            }
            ////小程序分享  需要判断是否需要分享小程序
//            [shareParams SSDKSetupWeChatParamsByTitle:shareWeChatTitle description:share.qqsharecontent webpageUrl:[NSURL URLWithString:share.url] path:share.applet_url thumbImage:images userName:WXXiaoChengXuID forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            ///分享更改
            [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:shareWeChatTitle description:share.qqsharecontent webpageUrl:[NSURL URLWithString:share.url] path:share.applet_url thumbImage:images hdThumbImage:nil userName:WXXiaoChengXuID withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            
        }
        ///分享更改
        [ShareSDK showShareActionSheet:self customItems:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)] shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
        }];
//        //2、分享
//        [ShareSDK showShareActionSheet:self
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       //                           [self.dataController requestShareRecordDataWithUrl:share.url callback:^(NSError *error, BOOL state, NSString *describle) {
//                       //                           }];
//                       NSLog(@"sdfasdf");
//                   }];
    }
    else
    {
        [dataControl requestShareSubjectDataWithCommodityid:strgoods_id
                                                             inView:self
                                                           callback:^(NSError *error, BOOL state, NSString *describle) {
                                                               if (!error) {
                                                                   if(innumshare1==1)
                                                                   {
                                                                       [self yaoqingAction];
                                                                       innumshare1=2;
                                                                   }
                                                                   
                                                               }
                                                           }];
    }
    
    
}

#pragma mark - 快递物流
-(void)kuaidiWuLiuAction
{
    OrderLogisticsViewController *ovc = [[OrderLogisticsViewController alloc] init];
    ovc.strorder_id = orderModel.did;
    [self.viewController.navigationController pushViewController:ovc animated:YES];
}


#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(otherDataControl==nil)
    {
        otherDataControl = [[MyOrderMainDataController alloc] init];
    }
    if((alertView.tag == 101))
    {
        if(buttonIndex  == 1)
        {
            UITextField *fieldReason = [alertView textFieldAtIndex:0];
            
            NSDictionary *dicpush = @{@"reason":fieldReason.text,
                                      @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                      @"order_id":orderModel.did
                                      };
            [otherDataControl requestCancleOrderDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
                if(state)
                {
                    [self bindData:strorderid bindorderno:strordernos];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"orderlistchange"];
                }
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                
            }];
        }
        
    }
    else if (alertView.tag == 102)
    {
        if(buttonIndex  == 1)
        {
            NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                      @"order_id":orderModel.did
                                      };
            [otherDataControl requestShouHuoOrderDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
                if(state)
                {
                    [self bindData:strorderid bindorderno:strordernos];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"orderlistchange"];
                }
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
            }];
        }
        
    }
    else if (alertView.tag == 103)
    {
        if(buttonIndex  == 1)
        {
            NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                      @"order_id":orderModel.did
                                      };
            
            [otherDataControl requestDelOrderDataInView:self.window dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
                
                if(state)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"orderlistchange"];
//                    [self.viewController.navigationController popViewControllerAnimated:YES];
                    
                    [self.delegate orderdetailAction];
                    
                    
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.window];
                }
                
            }];
        }
        
    }
    else if (alertView.tag == 11110)
    {
        if(buttonIndex  == 0)
        {////去晒单
            PushYuanChuangViewController *pvc = [[PushYuanChuangViewController alloc] init];
            pvc.arrbaoliaourl = arrshaidanyyhq;
            [self.viewController.navigationController pushViewController:pvc animated:YES];
        }
    }
    
    
    
}

#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)return;
    if(buttonIndex == otherDataControl.arrcancleReason.count+1)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单原因" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alter.alertViewStyle = UIAlertViewStylePlainTextInput;
        alter.tag = 101;
        [alter show];
        
    }
    else
    {
        NSDictionary *dic = otherDataControl.arrcancleReason[buttonIndex-1];
        NSDictionary *dicpush = @{@"reason":[dic objectForKey:@"content"],
                                  @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                  @"order_id":orderModel.did
                                  };
        
        [otherDataControl requestCancleOrderDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            if(state)
            {
                [self bindData:strorderid bindorderno:strordernos];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"orderlistchange"];
            }
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
            
        }];
        
    }
}




#pragma mark - 商品点击
-(void)goodsAction:(UIGestureRecognizer *)gesture
{
    NSInteger itag = gesture.view.superview.tag;
    @try
    {
        OrderDetaileGoodsModel *model = orderModel.goodsinfo[itag];
        ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
        pvc.productId = model.goods_id;
        [self.viewController.navigationController pushViewController:pvc animated:YES];
    }
    @catch (NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
    
}


-(void)QQAction
{
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string=orderModel.qq;
    [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:self];
}

#pragma mark - 退款详情
-(void)btTuiKuanAction
{
    OrderRefundViewController *ovc = [[OrderRefundViewController alloc] init];
    ovc.strorder_id = orderModel.did;
    [self.viewController.navigationController pushViewController:ovc animated:YES];

}

#pragma mark  - 购买凭证 发货凭证图片点击
-(void)imageAction:(UIGestureRecognizer *)gesture
{
    UIImageView *imgvc = (UIImageView *)gesture.view;
    NSMutableArray *items = [NSMutableArray new];
    
    UIView *imgView = imgvc;
    if(imgvc.superview.superview.tag == 0)
    {
        for(NSString *strurl in orderModel.shotpics)
        {
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.largeImageURL = [NSURL URLWithString:strurl];
            
            [items addObject:item];
        }
    }
    else
    {
        for(NSString *strurl in orderModel.shoppics)
        {
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.largeImageURL = [NSURL URLWithString:strurl];
            
            [items addObject:item];
        }
    }
    
    
    
    
    YYPhotoGroupView *photoGroupView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    
    [photoGroupView presentFromImageView:imgView
                             toContainer:self.viewController.tabBarController.view
                                animated:YES
                              completion:nil];
    
    
}

-(void)shenfenImageAction:(UITapGestureRecognizer *)gesture
{
    UIImageView *imgvc = (UIImageView *)gesture.view;
    NSMutableArray *items = [NSMutableArray new];
    
    UIView *imgView = imgvc;
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView = imgView;
    if(imgvc.tag == 0)
    {
        item.largeImageURL = [NSURL URLWithString:[NSString nullToString:orderModel.front_pic]];
    }
    else
    {
        item.largeImageURL = [NSURL URLWithString:[NSString nullToString:orderModel.back_pic]];
    }
    
    [items addObject:item];
    YYPhotoGroupView *photoGroupView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    
    [photoGroupView presentFromImageView:imgView
                             toContainer:self.viewController.tabBarController.view
                                animated:YES
                              completion:nil];
    
}

///计算一个时间距离当前时间相差多少s
-(float)dateNowTime:(NSString *)strdate
{
    NSString *timeStampString  = strdate;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    
    
    NSDate *nowDate = [NSDate date]; // 当前日期
    NSDate *creat = [formatter dateFromString:(dateString)];// 将传入的字符串转化成时间
    NSTimeInterval delta = [nowDate timeIntervalSinceDate:creat]; // 计算出相差多少秒
    //打印结果格式为 delta ==== 181078.541819
    float ic = delta;
    
    return ic;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self addSubview:_emptyView];
        _emptyView.remindStr = @"迷路了～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
