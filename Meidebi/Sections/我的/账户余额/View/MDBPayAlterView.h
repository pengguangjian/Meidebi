//
//  MDBPayAlterView.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/15.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MDBPayAlterViewDelegate <NSObject>
///取消
-(void)cancleAction;
///输入完成
-(void)passAllCode:(NSString *)strvalue;

@end

@interface MDBPayAlterView : UIView

@property (nonatomic , retain) NSString *strPrice;

@property (nonatomic ,weak) id<MDBPayAlterViewDelegate>delegate;


/**
 show

 @param view super
 @param type type 1提现
 @param falv 费率
 */
-(void)alterShow:(UIView *)view type:(int)type andfv:(float)falv;

@end

NS_ASSUME_NONNULL_END
