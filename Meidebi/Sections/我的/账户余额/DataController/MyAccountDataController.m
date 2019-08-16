//
//  MyAccountDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/12.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountDataController.h"
#import "HTTPManager.h"

@implementation MyAccountDataController
// 帐户余额
- (void)requestDGAccountYEInfoDataInView:(UIView *)view
                                 dicpush:(NSDictionary *)dicpush
                                Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:URL_Popularize_Account_balance withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                self.dicresult=[dicAll objectForKey:@"data"];
                state = YES;
            }
        }
        callback(error,state,describle);
    }];
}

// 申请提现
- (void)requestTiXianActionDataInView:(UIView *)view
                              dicpush:(NSDictionary *)dicpush
                             Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:URL_Popularize_Tixian withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                self.dictixian=[dicAll objectForKey:@"data"];
                state = YES;
            }
        }
        callback(error,state,describle);
    }];
    
    
}

// 上次提现账号等信息
- (void)requestLastTiXianActionDataInView:(UIView *)view
                                  dicpush:(NSDictionary *)dicpush
                                 Callback:(completeCallback)callback
{
    [HTTPManager sendGETRequestUrlToService:URL_Popularize_Last_Tixian_Success_Info withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                self.dicLastTixian=[dicAll objectForKey:@"data"];
                state = YES;
            }
        }
        callback(error,state,describle);
    }];
}

@end
