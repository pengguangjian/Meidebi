//
//  MyAccountBalanceViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/10.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountBalanceViewController.h"

#import "TiXianShuoMingViewController.h"

#import "MyAccountBalanceView.h"

@interface MyAccountBalanceViewController ()
{
    MyAccountBalanceView *mview;
    
}
@end

@implementation MyAccountBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户余额";
    
    [self drawNavRightbt];
    
    [self drawUI];
    
}

-(void)drawNavRightbt
{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setTitle:@"提现说明" forState:UIControlStateNormal];
    [btnright setTitleColor:RGB(150, 150, 150) forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [btnright setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btnright setTag:1];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem];
}


-(void)drawUI
{
    mview = [[MyAccountBalanceView alloc] init];
    [mview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mview];
    
    [mview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
//            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
            make.edges.equalTo(self.view);
        }
    }];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [mview loadData];
    
}

-(void)rightAction
{
    TiXianShuoMingViewController *gvc = [[TiXianShuoMingViewController alloc] init];
    [self.navigationController pushViewController:gvc animated:YES];
    
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
