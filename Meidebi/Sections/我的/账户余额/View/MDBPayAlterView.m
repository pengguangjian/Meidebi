//
//  MDBPayAlterView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/15.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MDBPayAlterView.h"
#import "IQKeyboardManager.h"

@interface MDBPayAlterView ()<UITextFieldDelegate>
{
    UIView *viewMessage;
    
    UILabel *lbprice;
    
    UITextField *field;
    
    NSMutableArray *arrallLB;
    ////服务费
    UIView *viewfuwuMoney;
    UILabel *lffalvmoney;
    UILabel *lffuwumoney;
    
}
@end

@implementation MDBPayAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.4)];
        [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[MDBPayAlterView class] didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
//        [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[MDBPayAlterView class]];
        
        viewMessage = [[UIView alloc] init];
        [viewMessage setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:viewMessage];
        [viewMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self).offset(-40*kScale);
        }];
        [viewMessage.layer setMasksToBounds:YES];
        [viewMessage.layer setCornerRadius:5];
        
        
        
        UILabel *lbtitle = [[UILabel alloc] init];
        [lbtitle setText:@"请输入密码"];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentCenter];
        [lbtitle setFont:[UIFont systemFontOfSize:15]];
        [viewMessage addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.left.right.equalTo(viewMessage);
            make.height.offset(30);
        }];
        
        UIButton *btdel = [[UIButton alloc] init];
        [btdel setImage:[UIImage imageNamed:@"pindanguanbi_X"] forState:UIControlStateNormal];
        [viewMessage addSubview:btdel];
        [btdel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(viewMessage);
            make.size.sizeOffset(CGSizeMake(40, 40));
        }];
        [btdel addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        
        lbprice = [[UILabel alloc] init];
        [lbprice setTextAlignment:NSTextAlignmentCenter];
        [lbprice setTextColor:RGB(30, 30, 30)];
        [lbprice setText:@"￥100.00"];
        [lbprice setFont:[UIFont systemFontOfSize:26]];
        [viewMessage addSubview:lbprice];
        [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(viewMessage);
            make.top.equalTo(lbtitle.mas_bottom).offset(15);
            make.height.offset(40);
        }];
        
        viewfuwuMoney = [[UIView alloc] init];
        [viewMessage addSubview:viewfuwuMoney];
        [viewfuwuMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(viewMessage);
            make.top.equalTo(lbprice.mas_bottom);
            make.height.offset(95);
        }];
        
        UIView *viewlinefw = [[UIView alloc] init];
        [viewlinefw setBackgroundColor:RGB(234, 234, 234)];
        [viewfuwuMoney addSubview:viewlinefw];
        [viewlinefw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.right.equalTo(viewfuwuMoney).offset(-15);
            make.top.offset(20);
            make.height.offset(1);
            
        }];
        
        
        UILabel *lbfuwu = [[UILabel alloc] init];
        [lbfuwu setTextAlignment:NSTextAlignmentLeft];
        [lbfuwu setText:@"服务费"];
        [lbfuwu setTextColor:RGB(120, 120, 120)];
        [lbfuwu setFont:[UIFont systemFontOfSize:14]];
        [viewfuwuMoney addSubview:lbfuwu];
        [lbfuwu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewlinefw);
            make.top.equalTo(viewlinefw.mas_bottom).offset(15);
            make.height.offset(20);
            make.width.offset(100);
        }];
        
        lffuwumoney = [[UILabel alloc] init];
        [lffuwumoney setTextAlignment:NSTextAlignmentRight];
        [lffuwumoney setText:@"￥0.02"];
        [lffuwumoney setTextColor:RGB(30, 30, 30)];
        [lffuwumoney setFont:[UIFont systemFontOfSize:14]];
        [viewfuwuMoney addSubview:lffuwumoney];
        [lffuwumoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewlinefw);
            make.top.height.equalTo(lbfuwu);
            make.width.offset(150);
        }];
        
        
        UILabel *lbfalv = [[UILabel alloc] init];
        [lbfalv setTextAlignment:NSTextAlignmentLeft];
        [lbfalv setText:@"费率"];
        [lbfalv setTextColor:RGB(120, 120, 120)];
        [lbfalv setFont:[UIFont systemFontOfSize:14]];
        [viewfuwuMoney addSubview:lbfalv];
        [lbfalv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewlinefw);
            make.top.equalTo(lbfuwu.mas_bottom).offset(5);
            make.height.offset(20);
            make.width.offset(100);
        }];
        
        lffalvmoney = [[UILabel alloc] init];
        [lffalvmoney setTextAlignment:NSTextAlignmentRight];
        [lffalvmoney setText:@"0.10%"];
        [lffalvmoney setTextColor:RGB(30, 30, 30)];
        [lffalvmoney setFont:[UIFont systemFontOfSize:14]];
        [viewfuwuMoney addSubview:lffalvmoney];
        [lffalvmoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewlinefw);
            make.top.height.equalTo(lbfalv);
            make.width.offset(150);
        }];
        
        
        ////////////////
        
        field = [[UITextField alloc] init];
        [field setTextColor:[UIColor whiteColor]];
        [field setKeyboardType:UIKeyboardTypeNumberPad];
        [field setDelegate:self];
        [viewMessage addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(40);
            make.top.equalTo(viewfuwuMoney.mas_bottom).offset(20);
            make.width.offset(50);
            make.height.offset(20);
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldChangeAction) name:UITextFieldTextDidChangeNotification object:nil];
        [field becomeFirstResponder];
        
        
        UIView *viewpass = [[UIView alloc] init];
        [viewpass.layer setBorderColor:RGB(220, 220, 220).CGColor];
        [viewpass.layer setBorderWidth:1];
        [viewpass setBackgroundColor:[UIColor whiteColor]];
        [viewMessage addSubview:viewpass];
        [viewpass mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.equalTo(viewMessage).offset(-15);
            make.top.equalTo(viewfuwuMoney.mas_bottom).offset(20);
            make.height.offset(50*kScale);
        }];
        
        UIView *viewleft = nil;
        arrallLB = [NSMutableArray new];
        for(int i = 0 ; i < 6; i++)
        {
            UILabel *lbitem = [[UILabel alloc] init];
            [lbitem setTextColor:RGB(0, 0, 0)];
            [lbitem setTextAlignment:NSTextAlignmentCenter];
            [lbitem setFont:[UIFont systemFontOfSize:18]];
            [viewpass addSubview:lbitem];
            [lbitem mas_makeConstraints:^(MASConstraintMaker *make) {
                if(viewleft==nil)
                {
                    make.left.offset(0);
                }
                else
                {
                    make.left.equalTo(viewleft.mas_right);
                }
                
                make.top.bottom.equalTo(viewpass);
                make.width.equalTo(viewpass).multipliedBy(1/6.0);
            }];
            [arrallLB addObject:lbitem];
            UIView *viewline = [[UIView alloc] init];
            [viewline setBackgroundColor:RGB(220, 220, 220)];
            [viewpass addSubview:viewline];
            [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(lbitem);
                make.width.offset(1);
            }];
            if(i==5)
            {
                [viewline setHidden:YES];
            }
            viewleft = lbitem;
        }
        
        [viewMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(viewpass.mas_bottom).offset(15);
        }];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [lbprice setText:[NSString stringWithFormat:@"￥%@",[NSString nullToString:_strPrice]]];
    
    
    
}
-(void)alterShow:(UIView *)view type:(int)type andfv:(float)falv
{
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(kMainScreenW);
        make.height.offset(kMainScreenH);
    }];
    if(type!=1)
    {
        [viewfuwuMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
            
        }];
        [viewfuwuMoney setHidden:YES];
    }
}
////
-(void)fieldChangeAction
{
    
    if(field.text.length>=6)
    {
        field.text = [field.text substringWithRange:NSMakeRange(0, 6)];
        [field resignFirstResponder];
        [self removeFromSuperview];
        [self.delegate passAllCode:field.text];
    }
    
    for(int i = 0 ; i < arrallLB.count; i++)
    {
        UILabel *lb = arrallLB[i];
        if(i<field.text.length)
        {
            [lb setText:@"*"];
        }
        else
        {
            [lb setText:@""];
        }
        
        
    }
    
}

-(void)delAction
{
    [field resignFirstResponder];
    [self removeFromSuperview];
    [self.delegate cancleAction];
}


@end
