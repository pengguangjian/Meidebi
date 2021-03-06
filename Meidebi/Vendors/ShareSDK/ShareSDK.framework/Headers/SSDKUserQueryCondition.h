//
//  SSDKUserQueryCondition.h
//  ShareSDK
//
//  Created by Max on 2018/5/28.
//  Copyright © 2018年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MOBFoundation/MOBFDataModel.h>

@interface SSDKUserQueryCondition : MOBFDataModel

/**
 *  用户标志
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  用户名称
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  用户路径
 */
@property (nonatomic, copy) NSString *path;

@end
