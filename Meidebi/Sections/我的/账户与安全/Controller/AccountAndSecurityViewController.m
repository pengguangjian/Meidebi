//
//  AccountAndSecurityViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/24.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "AccountAndSecurityViewController.h"

#import "ChangePasswordOldpassController.h"
#import "ChangePasswordPhoneViewController.h"
#import "ChangePhoneOldViewController.h"

#import "PayPassWordViewController.h"

#import "MDB_UserDefault.h"

@interface AccountAndSecurityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *tabview;
    NSArray *arrdata;
    
}
@end

@implementation AccountAndSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户与安全";
    
    
    [self drawSubview];
    
}

-(void)drawSubview
{
    
    if([[MDB_UserDefault defaultInstance] telphone].length != 11)
    {
        arrdata = @[@"修改密码",@"提现/支付密码"];
    }
    else
    {
        arrdata = @[@"修改密码",@"提现/支付密码",@"修改手机号"];
    }
    
    
    tabview = [[UITableView alloc] init];
    [tabview setDelegate:self];
    [tabview setDataSource:self];
    [tabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tabview];
    [tabview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    
    
    
    
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"UITableViewCellzhyaq";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    if(indexPath.row==0)
    {
        cell.textLabel.text = @"修改密码";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"提现/支付密码";
//        cell.detailTextLabel.text = @"修改提现/支付密码";
//        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"修改手机号";
        cell.detailTextLabel.text = @"若手机更换请尽快更改";
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    
    UIView *lineV = [[UIView alloc] init];
    [cell addSubview:lineV];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.offset(1);
    }];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 85;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        if([[MDB_UserDefault defaultInstance] telphone].length == 11)
        {
            ChangePasswordPhoneViewController *cvc = [[ChangePasswordPhoneViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
        else
        {
            if([[MDB_UserDefault defaultInstance] userName].length>0 || [[MDB_UserDefault defaultInstance] emailcomfirm].intValue==1)
            {
                ChangePasswordOldpassController *cvc = [[ChangePasswordOldpassController alloc] init];
                [self.navigationController pushViewController:cvc animated:YES];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:@"不可修改密码" inView:self.view];
            }

        }
        
    }
    else if (indexPath.row == 1)
    {
        PayPassWordViewController *pvc = [[PayPassWordViewController alloc] init];
        [self.navigationController pushViewController:pvc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        if([[MDB_UserDefault defaultInstance] telphone].length == 11)
        {
            ChangePhoneOldViewController *cvc = [[ChangePhoneOldViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请先绑定手机号" inView:self.view];
        }
    }
    
    
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
