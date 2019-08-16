//
//  MyAccountCashWView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/10.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountCashWView.h"
#import "MDB_UserDefault.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import "MyAccountDataController.h"

#import "MDBPayAlterView.h"

#import "PayPassWordViewController.h"

@interface MyAccountCashWView ()<UITextFieldDelegate,MDBPayAlterViewDelegate,UIAlertViewDelegate>
{
    UILabel *lbprice;
    
    UILabel *lbpricemx;
    
    UITextField *fieldMoney;
    
    UITextField *fieldname;
    
    UITextField *fieldaccount;
    
    MyAccountDataController *dataControl;
    
    ///可提现金额
    float fktxmoney;
    
}
@end

@implementation MyAccountCashWView

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
        if(dataControl==nil)
        {
            dataControl = [MyAccountDataController new];
        }
        [self drawUI];
        [self loadData];
    }
    return self;
}


-(void)loadData
{
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                              @"tx_channel":@"alipay"
                              };
    [dataControl requestLastTiXianActionDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(state)
        {
            /*
             "real_name" : null,
             "account" : null,
             "balance" : "0.00",
             "not_balance_accounts" : "798.66"
             */
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
    NSString *strbalance = [NSString stringWithFormat:@"￥%@",[NSString nullToString:[dataControl.dicLastTixian objectForKey:@"balance"]]];
    strbalance = [strbalance stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    fktxmoney = [[strbalance stringByReplacingOccurrencesOfString:@"￥" withString:@""] floatValue];
    
    [lbprice setText:strbalance];
    
    [lbprice setAttributedText:[MDB_UserDefault arrstring:lbprice.text andstart:0 andend:1 andfont:[UIFont boldSystemFontOfSize:25] andcolor:[UIColor blackColor]]];
    
    NSString *strnot_balance_accounts = [NSString stringWithFormat:@"￥%@",[NSString nullToString:[dataControl.dicLastTixian objectForKey:@"not_balance_accounts"]]];
    strnot_balance_accounts = [strnot_balance_accounts stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    [lbpricemx setText:[NSString stringWithFormat:@"（可提现金额%@，%@待生效）",strbalance,strnot_balance_accounts]];
    
    [fieldaccount setText:[NSString nullToString:[dataControl.dicLastTixian objectForKey:@"account"]]];
    [fieldname setText:[NSString nullToString:[dataControl.dicLastTixian objectForKey:@"real_name"]]];
    
}

-(void)drawUI
{
    
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisAction)];
    [self addGestureRecognizer:tapview];
    
    
    
    UIScrollView *scvback = [[UIScrollView alloc] init];
    [self addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.offset(0);
        make.width.offset(kMainScreenW);
    }];
    [scvback setShowsVerticalScrollIndicator:NO];
    
    ///
    UIView *viewtop = [[UIView alloc] init];
    [viewtop setBackgroundColor:[UIColor whiteColor]];
    [scvback addSubview:viewtop];
    [viewtop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.right.equalTo(self).offset(-15);
    }];
    [self drawtopView:viewtop];
    
    ///
    UIView *viewtx = [[UIView alloc] init];
    [viewtx setBackgroundColor:[UIColor whiteColor]];
    [scvback addSubview:viewtx];
    [viewtx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewtop);
        make.top.equalTo(viewtop.mas_bottom).offset(10);
    }];
    [self drawtixianView:viewtx];
    
    
    UIButton *bttixian = [[UIButton alloc] init];
    [bttixian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttixian setTitle:@"提现" forState:UIControlStateNormal];
    [bttixian.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bttixian.layer setMasksToBounds:YES];
    [bttixian.layer setCornerRadius:4];
    [bttixian setBackgroundColor:RGB(11, 185, 85)];
    [scvback addSubview:bttixian];
    [bttixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(kMainScreenW*0.4, 45));
        make.top.equalTo(viewtx.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];
    [bttixian addTarget:self action:@selector(tixianAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bttixian.mas_bottom).offset(30);
    }];
    
}
///总金额
-(void)drawtopView:(UIView *)view
{
    UIImageView *imgvtop = [[UIImageView alloc] init];
    [imgvtop setImage:[UIImage imageNamed:@"myaccount_yuan_money"]];
    [view addSubview:imgvtop];
    [imgvtop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(60*kScale, 60*kScale));
        make.top.offset(40);
        make.centerX.equalTo(view);
    }];
    
    
    lbprice = [[UILabel alloc] init];
    [lbprice setText:@"￥0.00"];
    [lbprice setTextColor:[UIColor blackColor]];
    [lbprice setTextAlignment:NSTextAlignmentCenter];
    [lbprice setFont:[UIFont boldSystemFontOfSize:35]];
    [view addSubview:lbprice];
    [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(imgvtop.mas_bottom).offset(10);
        make.height.offset(40);
    }];
    [lbprice setAttributedText:[MDB_UserDefault arrstring:lbprice.text andstart:0 andend:1 andfont:[UIFont boldSystemFontOfSize:25] andcolor:[UIColor blackColor]]];
    
    lbpricemx = [[UILabel alloc] init];
    [lbpricemx setText:@"（可提现金额￥0.0，￥0.0待生效）"];
    [lbpricemx setTextColor:RGB(150, 150, 150)];
    [lbpricemx setTextAlignment:NSTextAlignmentCenter];
    [lbpricemx setFont:[UIFont systemFontOfSize:14]];
    [lbpricemx setNumberOfLines:2];
    [view addSubview:lbpricemx];
    [lbpricemx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(lbprice.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lbpricemx.mas_bottom).offset(40);
    }];
    
}

///提现
-(void)drawtixianView:(UIView *)view
{
    UIView *viewtixian = [[UIView alloc] init];
    [viewtixian setBackgroundColor:RGB(250, 250, 250)];
    [view addSubview:viewtixian];
    [viewtixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.offset(50);
    }];
    
    UILabel *lbtixian = [[UILabel alloc] init];
    [lbtixian setText:@"提现金额 （次月5-10日可申请提现）"];
    [lbtixian setTextColor:[UIColor blackColor]];
    [lbtixian setTextAlignment:NSTextAlignmentLeft];
    [lbtixian setFont:[UIFont systemFontOfSize:14]];
    [viewtixian addSubview:lbtixian];
    [lbtixian setNumberOfLines:2];
    [lbtixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.equalTo(viewtixian);
        make.right.equalTo(viewtixian).offset(-10);
    }];
    
    UILabel *lbyuan = [[UILabel alloc] init];
    [lbyuan setTextColor:[UIColor blackColor]];
    [lbyuan setTextAlignment:NSTextAlignmentLeft];
    [lbyuan setFont:[UIFont systemFontOfSize:25]];
    [lbyuan setText:@"￥"];
    [view addSubview:lbyuan];
    [lbyuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(viewtixian.mas_bottom);
        make.height.offset(60);
        make.width.offset(40);
    }];
    
    fieldMoney = [[UITextField alloc] init];
    [fieldMoney setTextColor:[UIColor blackColor]];
    [fieldMoney setTextAlignment:NSTextAlignmentLeft];
    [fieldMoney setFont:[UIFont systemFontOfSize:14]];
//    [fieldMoney setKeyboardType:UIKeyboardTypeNumberPad];
    [fieldMoney setDelegate:self];
    [fieldMoney setTag:0];
    [fieldMoney setPlaceholder:@"请输入提现金额"];
    [view addSubview:fieldMoney];
    [fieldMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(lbyuan);
        make.left.equalTo(lbyuan.mas_right);
        make.right.equalTo(view).offset(-10);
    }];
    
    UIButton *btalltixian = [[UIButton alloc] init];
    [btalltixian setTitle:@"全部提现" forState:UIControlStateNormal];
    [btalltixian setTitleColor:RGB(60, 60, 60) forState:UIControlStateNormal];
    [btalltixian.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:btalltixian];
    [btalltixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(fieldMoney);
        make.right.equalTo(fieldMoney);
        make.width.offset(60);
    }];
    [btalltixian addTarget:self action:@selector(alltixianAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *viewtixianzh = [[UIView alloc] init];
    [viewtixianzh setBackgroundColor:RGB(250, 250, 250)];
    [view addSubview:viewtixianzh];
    [viewtixianzh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(viewtixian);
        make.top.equalTo(fieldMoney.mas_bottom);
    }];
    
    UILabel *lbtixianzg = [[UILabel alloc] init];
    [lbtixianzg setText:@"提现账户(支付宝)"];
    [lbtixianzg setTextColor:[UIColor blackColor]];
    [lbtixianzg setTextAlignment:NSTextAlignmentLeft];
    [lbtixianzg setFont:[UIFont systemFontOfSize:14]];
    [viewtixianzh addSubview:lbtixianzg];
    [lbtixianzg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.equalTo(viewtixianzh);
        make.right.equalTo(viewtixianzh).offset(-10);
    }];
    
    /*
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:@"还未绑定提现微信账户哦，点击授权"];
    [noteStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, noteStr.string.length)];
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(255, 36, 36) range:NSMakeRange(0, noteStr.string.length)];
    UIButton *btshouquan = [[UIButton alloc] init];
    [btshouquan setTitleColor:RGB(255, 36, 36) forState:UIControlStateNormal];
    [btshouquan.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btshouquan setAttributedTitle:noteStr forState:UIControlStateNormal];
    [view addSubview:btshouquan];
    [btshouquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(viewtixianzh.mas_bottom).offset(20);
        make.height.offset(50);
    }];
    [btshouquan setHidden:NO];
    [btshouquan addTarget:self action:@selector(shouquanAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///
    UIView *viewacItem = [[UIView alloc] init];
    [view addSubview:viewacItem];
    [viewacItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(viewtixianzh.mas_bottom).offset(20);
        make.height.offset(50);
    }];
    [self drawtxAccount:viewacItem];
    [viewacItem setHidden:YES];
    
    
    */
    
    fieldname = [[UITextField alloc] init];
    [fieldname setTextColor:RGB(30, 30, 30)];
    [fieldname setTextAlignment:NSTextAlignmentLeft];
    [fieldname setFont:[UIFont systemFontOfSize:14]];
    [fieldname setBackgroundColor:RGB(245, 245, 245)];
    [fieldname setPlaceholder:@"支付宝收款人姓名"];
    [view addSubview:fieldname];
    [fieldname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(viewtixianzh.mas_bottom).offset(10);
        make.right.equalTo(view).offset(-15);
        make.height.offset(50*kScale);
    }];
    
    fieldaccount = [[UITextField alloc] init];
    [fieldaccount setTextColor:RGB(30, 30, 30)];
    [fieldaccount setTextAlignment:NSTextAlignmentLeft];
    [fieldaccount setFont:[UIFont systemFontOfSize:14]];
    [fieldaccount setBackgroundColor:RGB(245, 245, 245)];
    [fieldaccount setPlaceholder:@"支付宝收款账号（手机号或邮箱）"];
    [view addSubview:fieldaccount];
    [fieldaccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(fieldname);
        make.top.equalTo(fieldname.mas_bottom).offset(10);
        
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(fieldaccount.mas_bottom).offset(20);
    }];
    
    
}
////微信已绑定账号
-(void)drawtxAccount:(UIView *)view
{
    UIImageView *imgvit = [[UIImageView alloc] init];
    [imgvit setImage:[UIImage imageNamed:@"myaccount_weixin_item"]];
    [view addSubview:imgvit];
    [imgvit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.size.sizeOffset(CGSizeMake(20, 20));
        make.centerY.equalTo(view);
    }];
    
    UILabel *lbtxtype = [[UILabel alloc] init];
    [lbtxtype setText:@"微信"];
    [lbtxtype setTextColor:RGB(50, 50, 50)];
    [lbtxtype setTextAlignment:NSTextAlignmentLeft];
    [lbtxtype setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtxtype];
    [lbtxtype mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgvit.mas_right).offset(15);
        make.top.bottom.equalTo(view);
        make.width.offset(90);
    }];
    
    /*
    UILabel *lbaccount = [[UILabel alloc] init];
    [lbaccount setText:@"187****8547"];
    [lbaccount setTextColor:RGB(50, 50, 50)];
    [lbaccount setTextAlignment:NSTextAlignmentCenter];
    [lbaccount setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbaccount];
    [lbaccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.width.offset(100);
        make.centerX.equalTo(view);
    }];
    */
    
    UILabel *lbname = [[UILabel alloc] init];
    [lbname setText:@"用户名"];
    [lbname setTextColor:RGB(50, 50, 50)];
    [lbname setTextAlignment:NSTextAlignmentRight];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbname];
    [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.width.offset(100);
        make.right.equalTo(view).offset(-25);
    }];
    
    
    
    
    
}

-(void)dismisAction
{
    [fieldMoney resignFirstResponder];
    [fieldname resignFirstResponder];
    [fieldaccount resignFirstResponder];
    
    
}

#pragma mark - 授权
-(void)shouquanAction
{
    SSDKPlatformType platformType = SSDKPlatformTypeWechat;
    
    [SSEThirdPartyLoginHelper loginByPlatform:platformType
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       associateHandler(user.uid, user, user);
                                       if (user.credential) {
                                           
                                           ///进行绑定操作
                                           
                                           
                                       }else{
                                           [MDB_UserDefault showNotifyHUDwithtext:@"授权失败" inView:self];
                                       }
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    if (state == SSDKResponseStateFail)
                                    {
                                        [SSEThirdPartyLoginHelper logout:user];
                                        [MDB_UserDefault showNotifyHUDwithtext:@"授权失败" inView:self];
                                    }
                                    
                                }];
}

#pragma mark - 全部提现
-(void)alltixianAction
{
    [fieldMoney setText:[NSString stringWithFormat:@"%.2lf",fktxmoney]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        PayPassWordViewController *pvc = [[PayPassWordViewController alloc] init];
        [self.viewController.navigationController pushViewController:pvc animated:YES];
    }
}


#pragma mark - 提现
-(void)tixianAction
{
    
    if([[MDB_UserDefault defaultInstance] is_set_pay_password]==NO)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置支付密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        return;
    }
    
    if(fieldMoney.text.floatValue<0.01)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入正确的金额" inView:self];
        return;
    }
    if(fieldaccount.text.length<3)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入支付宝收款账号" inView:self];
        return;
    }
    if(fieldname.text.length<1)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入支付宝收款姓名" inView:self];
        return;
    }
    
    MDBPayAlterView *alter = [[MDBPayAlterView alloc] init];
    alter.strPrice = @"1.00";
    [alter setDelegate:self];
    [alter alterShow:self.window type:0 andfv:0.10];
    
    
    
}

///取消
-(void)cancleAction;
{
    
}
///输入完成
-(void)passAllCode:(NSString *)strvalue
{
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                              @"tx_channel":@"alipay",
                              @"money":[NSString stringWithFormat:@"%.2lf",fieldMoney.text.floatValue],
                              @"account":[NSString nullToString:fieldaccount.text],
                              @"real_name":[NSString nullToString:fieldname.text],
                              @"pay_password":strvalue};
    [dataControl requestTiXianActionDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [fieldMoney setText:@""];
            [MDB_UserDefault showNotifyHUDwithtext:@"提现申请成功" inView:self];
            [self loadData];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
    }];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        [textField setText:[NSString stringWithFormat:@"%.2lf",textField.text.floatValue]];
        
        ////判断输入的金额是否符合要求
        if(textField.text.floatValue>fktxmoney)
        {
            [textField setText:[NSString stringWithFormat:@"%.2lf",fktxmoney]];
        }
        
    }
}

@end
