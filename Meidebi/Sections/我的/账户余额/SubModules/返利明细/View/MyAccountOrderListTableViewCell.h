//
//  MyAccountOrderListTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/10.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountFanLiOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAccountOrderListTableViewCell : UITableViewCell

@property (nonatomic , retain) MyAccountFanLiOrderModel *model;

@end

NS_ASSUME_NONNULL_END
