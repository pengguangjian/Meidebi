//
//  DaiGouZhiFuViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouZhiFuViewController.h"

#import "PaySuccessViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "HTTPManager.h"
#import "MDB_UserDefault.h"

#import "OrderDetaileViewController.h"

//#import <WXApi.h>
#import "WXApi.h"
#import "WXApiObject.h"
//#include <WXApiObject.h>

#import "MyOrderMainViewController.h"

#import "MyAccountDataController.h"

#import "MDBPayAlterView.h"

#import "PayPassWordViewController.h"

@interface DaiGouZhiFuViewController ()<MDBPayAlterViewDelegate,UIAlertViewDelegate>
{
    
    UIScrollView *scvback;
    UIButton *btnowselect;
    
    BOOL ispay;
    
    MyAccountDataController *dataControl;
    UIButton *btyuebt;
    ///有多少余额
    float fyuemoney;
    
}
@end

@implementation DaiGouZhiFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifubaoSuccessAction:) name:@"zhifubaoSuccessAction" object:nil];
    
    [self drawSubview];
    [self setNavBarBackBtn];
    
    
    dataControl = [MyAccountDataController new];
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [dataControl requestDGAccountYEInfoDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
       if(state)
       {
           fyuemoney = [[[NSString nullToString:[dataControl.dicresult objectForKey:@"balance"]] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
           UILabel *lbtemp = [btyuebt viewWithTag:10000];
           [lbtemp setText:[NSString stringWithFormat:@"账号余额（%.2lf）",fyuemoney]];
           
           
           
       }
    }];
    
}
- (void)setNavBarBackBtn{
    //    UIImage *backButtonImage = [[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.navigationController.navigationBar.backIndicatorImage = backButtonImage;
    //    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
    
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)doClickBackAction{
    NSArray *arrvc = self.navigationController.viewControllers;
    UIViewController *vc = arrvc[arrvc.count-2];
    if([vc isKindOfClass:[OrderDetaileViewController class]] || [vc isKindOfClass:[MyOrderMainViewController class]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString *strordernos = @"";
        if(_arrordernumbers.count>0)
        {
            strordernos = [_arrordernumbers componentsJoinedByString:@","];
        }
        else
        {
            strordernos = _strorderid;
        }
        if(_arrordernumbers.count>1)
        {
            MyOrderMainViewController *mvc = [[MyOrderMainViewController alloc]init];
            [self.navigationController pushViewController:mvc animated:YES];
        }
        else
        {
            OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
            ovc.strid = _strdid;
            ovc.strorderno = strordernos;
            [self.navigationController pushViewController:ovc animated:YES];
        }
    }
}

-(void)drawSubview
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 34.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ftopheith, BOUNDS_WIDTH, BOUNDS_HEIGHT-ftopheith-fother)];
    [scvback setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scvback];
    
    
    UIView *viewddmx = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scvback.width, 50)];
    [viewddmx setBackgroundColor:RGB(245, 244, 245)];
    [scvback addSubview:viewddmx];
    UILabel *lbddmx = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, viewddmx.height)];
    [lbddmx setText:@"支付方式"];
    [lbddmx setTextAlignment:NSTextAlignmentLeft];
    [lbddmx setTextColor:RGB(20, 20, 20)];
    [lbddmx setFont:[UIFont systemFontOfSize:14]];
    [viewddmx addSubview:lbddmx];
    
    
    NSArray *arrlist = [NSArray arrayWithObjects:@"支付宝",@"微信",@"账号余额（0.00）", nil];//@"微信",
//    NSArray *arrimage = [NSArray arrayWithObjects:@"payzhifubao",@"payweixin",@"payweixin", nil];///@"payweixin",
    
    float fbottom = 0.0;
    for(int i = 0 ; i < arrlist.count; i++)
    {
        UIButton *btitem = [self drawButton:CGRectMake(0 , viewddmx.bottom + 65*kScale*i, scvback.width, 65*kScale) andtitle:arrlist[i] andimage:@""];
        [btitem setTag:i];
        [btitem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [scvback addSubview:btitem];
        fbottom = btitem.bottom;
        if(i==0)
        {
            btnowselect = btitem;
            UIImageView *imgv = [btnowselect viewWithTag:200];
            [imgv setImage:[UIImage imageNamed:@"zhifu_select_yes_green"]];
        }
        if(i==2)
        {
            btyuebt = btitem;
        }
    }
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, fbottom,scvback.width , 10)];
    [viewlin setBackgroundColor:RGB(255,255,255)];
    [scvback addSubview:viewlin];
    
    UIButton *btsend = [[UIButton alloc] initWithFrame:CGRectMake(23, viewlin.bottom+55, BOUNDS_WIDTH-46, 50)];
    [btsend.layer setMasksToBounds:YES];
    [btsend.layer setCornerRadius:4];
    [btsend setBackgroundColor:RGB(253,122,14)];
    [btsend setTitle:@"立即支付" forState:UIControlStateNormal];
    if([NSString nullToString:_strprice].length>0)
    {
        if([[_strprice substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"￥"])
        {
            [btsend setTitle:[NSString stringWithFormat:@"%@ 立即支付",_strprice] forState:UIControlStateNormal];
        }
        else
        {
            [btsend setTitle:[NSString stringWithFormat:@"￥%@ 立即支付",_strprice] forState:UIControlStateNormal];
        }
        
    }
    
    [btsend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btsend.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [btsend addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [scvback addSubview:btsend];
    
}

-(UIButton *)drawButton:(CGRect)rect andtitle:(NSString *)strtitle andimage:(NSString *)strimage
{
    UIButton *bt = [[UIButton alloc] initWithFrame:rect];
    
//    UIImageView *imgvlog = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, bt.height*0.4, bt.height*0.4)];
//    [imgvlog setImage:[UIImage imageNamed:strimage]];
//    [imgvlog setCenter:CGPointMake(0, bt.height/2.0)];
//    [imgvlog setLeft:20];
//    [bt addSubview:imgvlog];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(27, 0, 17, 17)];
    [imgv setImage:[UIImage imageNamed:@"yuan_select_no"]];
    [imgv setCenter:CGPointMake(0, bt.height/2.0)];
    [imgv setLeft:20];
    [imgv setTag:200];
    [bt addSubview:imgv];
    
    
    UILabel *lbkd = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+13, 0, 250, bt.height)];
    [lbkd setText:strtitle];
    [lbkd setTextColor:RGB(102,102,102)];
    [lbkd setTextAlignment:NSTextAlignmentLeft];
    [lbkd setFont:[UIFont systemFontOfSize:16]];
    [lbkd setTag:10000];
    [bt addSubview:lbkd];
    
    
//    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, bt.height-1,bt.width , 1)];
//    [viewlin setBackgroundColor:RGB(218,218,218)];
//    [bt addSubview:viewlin];
    
    return bt;
}

#pragma mark - 选择支付方式
-(void)itemAction:(UIButton *)sender
{
    if(sender.tag==2)
    {
        if(fyuemoney<_strprice.floatValue)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"余额不足" inView:self.view];
            return;
        }
    }
    
    if(btnowselect!=nil)
    {
        UIImageView *imgv = [btnowselect viewWithTag:200];
        [imgv setImage:[UIImage imageNamed:@"yuan_select_no"]];
    }
    btnowselect = sender;
    UIImageView *imgv = [btnowselect viewWithTag:200];
    [imgv setImage:[UIImage imageNamed:@"zhifu_select_yes_green"]];
}

#pragma mark - 提交
-(void)sendAction
{
//    NSLog(@"+-+-+-:%@",[[AlipaySDK defaultService] currentVersion]);
    
    if(btnowselect == nil)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请选择支付方式" inView:self.view];
        return;
    }
    ispay = NO;
    NSDictionary *dicpush;
    
    NSString *strordernos = @"";
    if(_arrordernumbers.count>0)
    {
        strordernos = [_arrordernumbers componentsJoinedByString:@","];
    }
    else
    {
        strordernos = _strorderid;
    }
    
    if(strordernos==nil)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"订单号错误" inView:self.view];
        return;
    }
    
    if(btnowselect.tag == 0)
    {
        dicpush = @{@"orderNos":strordernos,@"paytype":@"alipay",@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
        [self payHttpAction:dicpush];
        
    }
    else if(btnowselect.tag == 1)
    {
        
        dicpush = @{@"orderNos":strordernos,@"paytype":@"weixinpay_app",@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
        [self payHttpAction:dicpush];
    }
    else if(btnowselect.tag == 2)
    {
        if([[MDB_UserDefault defaultInstance] is_set_pay_password]==NO)
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置支付密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alter show];
            return;
        }
        
        if(fyuemoney<_strprice.floatValue)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"您的余额不足" inView:self.view];
            return;
        }
        MDBPayAlterView *alter = [[MDBPayAlterView alloc] init];
        alter.strPrice = _strprice;
        [alter setDelegate:self];
        [alter alterShow:self.view.window type:0 andfv:0];
    }
}

#pragma mark -
///取消
-(void)cancleAction
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        PayPassWordViewController *pvc = [[PayPassWordViewController alloc] init];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}
///输入完成
-(void)passAllCode:(NSString *)strvalue
{
    
    NSDictionary *dicpush;
    
    NSString *strordernos = @"";
    if(_arrordernumbers.count>0)
    {
        strordernos = [_arrordernumbers componentsJoinedByString:@","];
    }
    else
    {
        strordernos = _strorderid;
    }
    
    if(strordernos==nil)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"订单号错误" inView:self.view];
        return;
    }
    
    dicpush = @{@"order_nos":strordernos,@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"pay_password":strvalue};
    
    [self payYEHttpAction:dicpush];
    
}

////余额支付
-(void)payYEHttpAction:(NSDictionary *)dicpush
{
    [HTTPManager sendRequestUrlToService:URL_Daigoupayment_Balancepay withParametersDictionry:dicpush view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
       
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSString *strordernos = @"";
                if(_arrordernumbers.count>0)
                {
                    strordernos = [_arrordernumbers componentsJoinedByString:@","];
                }
                else
                {
                    strordernos = _strorderid;
                }
                
                PaySuccessViewController *pvc = [[PaySuccessViewController alloc] init];
                pvc.strgoodsid = _strgoodsid;
                pvc.strdid = _strdid;
                pvc.strorderno = strordernos;
                if(_arrordernumbers.count>1)
                {
                    pvc.ismoreorders = YES;
                }
                [self.navigationController pushViewController:pvc animated:YES];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                /*
                 if(_arrordernumbers.count>1)
                 {
                 MyOrderMainViewController *mvc = [[MyOrderMainViewController alloc]init];
                 [self.navigationController pushViewController:mvc animated:YES];
                 }
                 else
                 {
                 OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
                 ovc.strid = _strdid;
                 ovc.strorderno = strordernos;
                 [self.navigationController pushViewController:ovc animated:YES];
                 }
                 */
            }
        }
    }];
}


////微信和支付宝支付获取签名
-(void)payHttpAction:(NSDictionary *)dicpush
{
    [HTTPManager sendGETRequestUrlToService:MyOrderZhiFuViewUrl withParametersDictionry:dicpush view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSString *strdata = [dicAll objectForKey:@"data"];
                
                if(strdata == nil)
                {
                    
                    [MDB_UserDefault showNotifyHUDwithtext:@"网络错误" inView:self.view];
                    return ;
                }
                
                if(btnowselect.tag == 0)
                {
                    [self zhifubaoPay:strdata];
                }
                else if(btnowselect.tag == 1)
                {
                    
                    [self weixinPay:[dicAll objectForKey:@"data"]];
                }
                
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }
    }];
}

#pragma mark - 微信支付
-(void)weixinPay:(NSDictionary *)dic
{
    @try
    {
        //    // 发起微信支付，设置参数
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = [NSString nullToString:[dic objectForKey:@"partnerid"]];
        request.prepayId = [NSString nullToString:[dic objectForKey:@"prepayid"]];
        request.nonceStr = [NSString nullToString:[dic objectForKey:@"noncestr"]];
        request.timeStamp = [[NSString nullToString:[dic objectForKey:@"timestamp"]] intValue];
        request.package = [NSString nullToString:[dic objectForKey:@"package"]];
        request.sign = [NSString nullToString:[dic objectForKey:@"sign"]];
        [WXApi sendReq:request];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPayNotifi:) name:@"weixinzhifupay" object:nil];
    }
    @catch (NSException *exc)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"发起支付失败" inView:self.view];
    }
    @finally
    {
        
        
    }
    
}

-(void)weixinPayNotifi:(NSNotification *)notifi
{
    
    NSMutableDictionary *dic = notifi.object;
    NSString *strordernos = @"";
    if(_arrordernumbers.count>0)
    {
        strordernos = [_arrordernumbers componentsJoinedByString:@","];
    }
    else
    {
        strordernos = _strorderid;
    }
    if([[dic objectForKey:@"errCode"] isEqualToString:@"0"] && [[dic objectForKey:@"returnKey"] isEqualToString:@""])
    {///支付成功
        PaySuccessViewController *pvc = [[PaySuccessViewController alloc] init];
        pvc.strgoodsid = _strgoodsid;
        pvc.strdid = _strdid;
        pvc.strorderno = _strorderid;
        if(_arrordernumbers.count>1)
        {
            pvc.ismoreorders = YES;
        }
        
        pvc.strorderno = strordernos;
        
        [self.navigationController pushViewController:pvc animated:YES];
    }
    else
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"支付失败" inView:self.view.window];
        
        NSArray *arrvc = self.navigationController.viewControllers;
        UIViewController *vc = arrvc[arrvc.count-2];
        if([vc isKindOfClass:[OrderDetaileViewController class]])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if(_arrordernumbers.count>1)
            {
                MyOrderMainViewController *mvc = [[MyOrderMainViewController alloc]init];
                [self.navigationController pushViewController:mvc animated:YES];
            }
            else
            {
                OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
                ovc.strid = _strdid;
                ovc.strorderno = strordernos;
                [self.navigationController pushViewController:ovc animated:YES];
            }
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixinzhifupay" object:nil];
}

#pragma mark - 支付宝支付
-(void)zhifubaoPay:(NSString *)strdata
{
    [[AlipaySDK defaultService] payOrder:strdata fromScheme:@"safepaymdb" callback:^(NSDictionary *resultDic) {
        //                    NSLog(@"reslut = %@",resultDic);
        
        if(ispay == YES)return;
        
        ispay = YES;
        NSString *strordernos = @"";
        if(_arrordernumbers.count>0)
        {
            strordernos = [_arrordernumbers componentsJoinedByString:@","];
        }
        else
        {
            strordernos = _strorderid;
        }
        if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"])
        {///支付成功
            
            [self zhifuotherAction:resultDic];
            
            PaySuccessViewController *pvc = [[PaySuccessViewController alloc] init];
            pvc.strgoodsid = _strgoodsid;
            pvc.strdid = _strdid;
            pvc.strorderno = _strorderid;
            if(_arrordernumbers.count>1)
            {
                pvc.ismoreorders = YES;
            }
            
            pvc.strorderno = strordernos;
            [self.navigationController pushViewController:pvc animated:YES];
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:[resultDic objectForKey:@"memo"] inView:self.view.window];
            
            NSArray *arrvc = self.navigationController.viewControllers;
            UIViewController *vc = arrvc[arrvc.count-2];
            if([vc isKindOfClass:[OrderDetaileViewController class]])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if(_arrordernumbers.count>1)
                {
                    MyOrderMainViewController *mvc = [[MyOrderMainViewController alloc]init];
                    [self.navigationController pushViewController:mvc animated:YES];
                }
                else
                {
                    OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
                    ovc.strid = _strdid;
                    ovc.strorderno = strordernos;
                    [self.navigationController pushViewController:ovc animated:YES];
                }
            }
            
            
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhifubaoSuccessAction" object:nil];
        
    }];
}


///测试使用
-(void)zhifuotherAction:(NSDictionary *)dicpush
{
    
    
    [HTTPManager sendRequestUrlToService:MyOrderZhiFuCeShiViewUrl withParametersDictionry:dicpush view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
        NSDictionary *dicAll=[str JSONValue];
        NSLog(@"%@",dicAll);
//        if(error!=nil)
//        {
//            NSDictionary * errorInfo = error.userInfo;
//            if ([[errorInfo allKeys] containsObject: @"com.alamofire.serialization.response.error.data"]){
//                NSData * errorData = errorInfo[@"com.alamofire.serialization.response.error.data"];
//                NSString *strtemp = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
//                NSDictionary * errorDict =  [NSJSONSerialization JSONObjectWithData: errorData options:NSJSONReadingAllowFragments error:nil];
//                NSNumber * errorCodeNum = errorDict[@"err_code"];
//                NSLog(@"=====%@====", strtemp);
//            }
            
            
//        }
    }];
}

-(void)zhifubaoSuccessAction:(NSNotification *)notifi
{
    if(ispay == YES)return;
    
    ispay = YES;
    NSString *strordernos = @"";
    if(_arrordernumbers.count>0)
    {
        strordernos = [_arrordernumbers componentsJoinedByString:@","];
    }
    else
    {
        strordernos = _strorderid;
    }
    NSDictionary *resultDic = notifi.object;
    if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"])
    {///支付成功
        
        [self zhifuotherAction:resultDic];
        
        PaySuccessViewController *pvc = [[PaySuccessViewController alloc] init];
        pvc.strgoodsid = _strgoodsid;
        pvc.strdid = _strdid;
        pvc.strorderno = strordernos;
        if(_arrordernumbers.count>1)
        {
            pvc.ismoreorders = YES;
        }
        [self.navigationController pushViewController:pvc animated:YES];
        
    }
    else
    {
        [MDB_UserDefault showNotifyHUDwithtext:[resultDic objectForKey:@"memo"] inView:self.view];
        
        
        if(_arrordernumbers.count>1)
        {
            MyOrderMainViewController *mvc = [[MyOrderMainViewController alloc]init];
            [self.navigationController pushViewController:mvc animated:YES];
        }
        else
        {
            OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
            ovc.strid = _strdid;
            ovc.strorderno = strordernos;
            [self.navigationController pushViewController:ovc animated:YES];
        }
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhifubaoSuccessAction" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
