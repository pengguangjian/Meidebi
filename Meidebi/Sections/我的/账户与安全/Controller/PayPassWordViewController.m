//
//  PayPassWordViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/15.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "PayPassWordViewController.h"

#import "PayPassWordView.h"

#import "MDB_UserDefault.h"

@interface PayPassWordViewController ()

@end

@implementation PayPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改支付/提现密码";
    
    
    [self drawUI];
    
}

-(void)drawUI
{
    PayPassWordView *mview = [[PayPassWordView alloc] init];
    [mview setBackgroundColor:RGB(255, 255, 255)];
    [self.view addSubview:mview];
    if([[MDB_UserDefault defaultInstance] is_set_pay_password]==NO)
    {
        self.title = @"添加支付/提现密码";
        [mview loadUIType:0];
    }
    else
    {
        self.title = @"修改支付/提现密码";
        [mview loadUIType:1];
    }
    
    
    [mview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    
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
