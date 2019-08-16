//
//  MyAccountTXJLListModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/13.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountTXJLListModel.h"


@implementation MyAccountTXJLListModel

-(void)modelValue:(NSDictionary *)dicvalue
{
    self.strtime = [NSString nullToString:[dicvalue objectForKey:@"tixian_month"]];
    
    NSMutableArray *arrtmep = [NSMutableArray new];
    @try {
        NSArray *arrdata = [dicvalue objectForKey:@"data"];
        for(NSDictionary *dictemp in arrdata)
        {
            MyAccountTXJLModel *model = [MyAccountTXJLModel new];
            [model modelValue:dictemp];
            [arrtmep addObject:model];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    self.arrmodel = arrtmep;
    
}


@end

@implementation MyAccountTXJLModel

-(void)modelValue:(NSDictionary *)dicvalue
{
    self.money = [NSString nullToString:[dicvalue objectForKey:@"money"]];
    self.tixian_time = [NSString nullToString:[dicvalue objectForKey:@"tixian_time"]];
    self.status_text = [NSString nullToString:[dicvalue objectForKey:@"status_text"]];
    self.tixian_month = [NSString nullToString:[dicvalue objectForKey:@"tixian_month"]];
}

@end
