//
//  TiXianShuoMingViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/16.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "TiXianShuoMingViewController.h"

#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@interface TiXianShuoMingViewController ()



@end

@implementation TiXianShuoMingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现说明";
    
    UIWebView *webview = [[UIWebView alloc] init];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_Popularize_tixian_rule withParametersDictionry:dicpush view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
       
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            NSString *strinfo = [NSString nullToString:[dicAll objectForKey:@"info"]];
            if ([[dicAll objectForKey:@"status"]intValue] == 1)
            {
                NSString *strtixian_rule = [[dicAll objectForKey:@"data"] objectForKey:@"tixian_rule"];
                [webview loadHTMLString:strtixian_rule baseURL:nil];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:strinfo inView:self.view];
            }
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"网络错误" inView:self.view];
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
