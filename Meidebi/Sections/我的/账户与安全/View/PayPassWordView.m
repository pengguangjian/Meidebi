//
//  PayPassWordView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/15.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "PayPassWordView.h"

#import "MDB_UserDefault.h"
#import "HTTPManager.h"


@interface PayPassWordView ()<UITextFieldDelegate>
{
    NSMutableArray *arrAllField;
    
    int ictype;
    
}
@end

@implementation PayPassWordView

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
        
    }
    return self;
}

-(void)loadUIType:(int)type
{
    ictype = type;
    
    NSArray *arrplaschstr = @[@"新密码（6位数字）",@"再次输入新密码"];
    if(type==1)
    {
        arrplaschstr = @[@"原密码",@"新密码（6位数字）",@"再次输入新密码"];
    }
    
    arrAllField = [NSMutableArray new];
    for(int i = 0 ; i < arrplaschstr.count; i++)
    {
        UITextField *field = [[UITextField alloc] init];
        [field setTextColor:RGB(10, 10, 10)];
        [field setTextAlignment:NSTextAlignmentLeft];
        [field setFont:[UIFont systemFontOfSize:14]];
        [field setPlaceholder:arrplaschstr[i]];
        [field setSecureTextEntry:YES];
        [field setKeyboardType:UIKeyboardTypeNumberPad];
        [field setDelegate:self];
        [self addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.offset(10+51*kScale*i);
            make.right.equalTo(self).offset(-20);
            make.height.offset(50*kScale);
        }];
        
        UIView *viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(234, 234, 234)];
        [self addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(field);
            make.top.equalTo(field.mas_bottom);
            make.height.offset(1);
        }];
        
        [arrAllField addObject:field];
        
    }
    
    
    UIButton *btok = [[UIButton alloc] init];
    [btok setTitle:@"确定" forState:UIControlStateNormal];
    [btok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btok.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btok setBackgroundColor:RadMenuColor];
    [btok.layer setMasksToBounds:YES];
    [btok.layer setCornerRadius:3];
    [self addSubview:btok];
    [btok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.offset(50*kScale);
        make.top.offset(50*kScale*arrplaschstr.count+60);
    }];
    [btok addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lbtishi = [[UILabel alloc] init];
    [lbtishi setText:@"忘记原密码请联系没得比客服QQ:3004931043"];
    [lbtishi setTextColor:RGB(180, 180, 180)];
    [lbtishi setTextAlignment:NSTextAlignmentCenter];
    [lbtishi setFont:[UIFont systemFontOfSize:12]];
    [lbtishi setNumberOfLines:2];
    [self addSubview:lbtishi];
    [lbtishi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btok);
        make.top.equalTo(btok.mas_bottom).offset(20);
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
       return YES;
    }
    if(textField.text.length>=6)
    {
        return NO;
    }
    return YES;
}

-(void)okAction
{
    [self endEditing:YES];
    NSString *strurl = nil;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    if(ictype==1)
    {
        UITextField *field0 = arrAllField[0];
        if(field0.text.length<6)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请输入正确的原密码" inView:self];
            return;
        }
        
        UITextField *field1 = arrAllField[1];
        if(field1.text.length<6)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请输入6位新密码" inView:self];
            return;
        }
        
        UITextField *field2 = arrAllField[2];
        if(![field2.text isEqualToString:field1.text])
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"确认密码错误" inView:self];
            return;
        }
        
        strurl = URL_AccountSecurity_update_pay_password;
        [dicpush setObject:field0.text forKey:@"pay_password"];
        [dicpush setObject:field1.text forKey:@"new_password"];
        [dicpush setObject:field2.text forKey:@"confirm_password"];
    }
    else
    {
        UITextField *field1 = arrAllField[0];
        if(field1.text.length<6)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请输入6位新密码" inView:self];
            return;
        }
        
        UITextField *field2 = arrAllField[1];
        if(![field2.text isEqualToString:field1.text])
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"确认密码错误" inView:self];
            return;
        }
        strurl = URL_AccountSecurity_create_pay_password;
        [dicpush setObject:field1.text forKey:@"pay_password"];
        [dicpush setObject:field2.text forKey:@"confirm_password"];
    }
    
    [HTTPManager sendRequestUrlToService:strurl withParametersDictionry:dicpush view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
       
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            NSString *strinfo = [NSString nullToString:[dicAll objectForKey:@"info"]];
            if ([[dicAll objectForKey:@"status"]intValue] == 1)
            {
                [MDB_UserDefault showNotifyHUDwithtext:strinfo inView:self];
                NSString *strback = @"支付密码添加成功";
                if(ictype==1)
                {
                    strback = @"支付密码修改成功";
                }
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:strback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                
                [self.viewController.navigationController popViewControllerAnimated:YES];
                
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:strinfo inView:self];
            }
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"网络错误" inView:self];
        }
        
    }];
    
}


@end
