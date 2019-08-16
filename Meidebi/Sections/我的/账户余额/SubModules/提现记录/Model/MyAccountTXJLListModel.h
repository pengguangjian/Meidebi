//
//  MyAccountTXJLListModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/13.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface MyAccountTXJLListModel : NSObject

@property (nonatomic , retain) NSMutableArray *arrmodel;

@property (nonatomic , retain) NSString *strtime;

-(void)modelValue:(NSDictionary *)dicvalue;

@end

@interface MyAccountTXJLModel : NSObject

@property (nonatomic , retain) NSString *money;

@property (nonatomic , retain) NSString *status_text;

@property (nonatomic , retain) NSString *tixian_month;

@property (nonatomic , retain) NSString *tixian_time;

-(void)modelValue:(NSDictionary *)dicvalue;

@end


NS_ASSUME_NONNULL_END
