//
//  MyAccountTXJLTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/11.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountTXJLTableViewController.h"
#import <MJRefresh.h>
#import "MDB_UserDefault.h"

#import "MDBEmptyView.h"

#import "MyAccountTXJLTableViewCell.h"

#import "MyAccountTXJLDataController.h"

@interface MyAccountTXJLTableViewController ()
{
    int ipage;
    
    NSMutableArray *arrdata;
    
    MyAccountTXJLDataController *dataControl;
    
    NSString *strlastmouth;
    
}

@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation MyAccountTXJLTableViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    ipage = 1;
    strlastmouth = @"";
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        strlastmouth = @"";
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ipage++;
        [self loadData];
    }];

    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    dataControl = [MyAccountTXJLDataController new];
    [self loadData];
    
}

-(void)loadData
{
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"p":[NSString stringWithFormat:@"%d",ipage]};
    
    [dataControl requestTXJLInfoDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(self.tableView.mj_header.refreshing)
        {
            [self.tableView.mj_header endRefreshing];
        }
        if(self.tableView.mj_footer.refreshing)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        if(ipage==1){
            arrdata = [NSMutableArray new];
        }
        if(state)
        {
            
            NSMutableArray *arrtxListModel = [NSMutableArray new];
            ///MyAccountTXJLListModel
            for(NSDictionary *dictemp in dataControl.arrresult)
            {
                MyAccountTXJLModel *model  = [MyAccountTXJLModel new];
                [model modelValue:dictemp];
                if([strlastmouth isEqualToString:@""])
                {
                    strlastmouth = model.tixian_month;
                }
                
                if(![model.tixian_month isEqualToString:strlastmouth] && ![strlastmouth isEqualToString:@""])
                {
                    BOOL islastedit = NO;
                    if(arrdata.count>0)
                    {
                        MyAccountTXJLListModel *modeltemp = arrdata.lastObject;
                        if([modeltemp.strtime isEqualToString:strlastmouth])
                        {
                            [modeltemp.arrmodel addObjectsFromArray:arrtxListModel];
                        }
                        else
                        {
                            islastedit = YES;
                        }
                    }
                    else
                    {
                        islastedit = YES;
                    }
                    if(islastedit)
                    {
                        MyAccountTXJLListModel *model0 = [MyAccountTXJLListModel new];
                        model0.strtime = strlastmouth;
                        model0.arrmodel = arrtxListModel;
                        [arrdata addObject:model0];
                    }
                    
                    arrtxListModel = [NSMutableArray new];
                    strlastmouth = model.tixian_month;
                    
                }
                [arrtxListModel addObject:model];
                
            }
            if(arrtxListModel.count>0)
            {
                
                BOOL islastedit = NO;
                if(arrdata.count>0)
                {
                    MyAccountTXJLListModel *modeltemp = arrdata.lastObject;
                    if([modeltemp.strtime isEqualToString:strlastmouth])
                    {
                        [modeltemp.arrmodel addObjectsFromArray:arrtxListModel];
                    }
                    else
                    {
                        islastedit = YES;
                    }
                }
                else
                {
                    islastedit = YES;
                }
                if(islastedit)
                {
                    MyAccountTXJLListModel *model0 = [MyAccountTXJLListModel new];
                    model0.strtime = strlastmouth;
                    model0.arrmodel = arrtxListModel;
                    [arrdata addObject:model0];
                }
            }
        }
        
        [self.tableView reloadData];
        [_emptyView setHidden:YES];
        if(arrdata.count==0)
        {
            [_emptyView setHidden:NO];
        }
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrdata.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MyAccountTXJLListModel *model = arrdata[section];
    return model.arrmodel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strcell = @"MyAccountTXJLTableViewCell";
    MyAccountTXJLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[MyAccountTXJLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    MyAccountTXJLListModel *model = arrdata[indexPath.section];
    
    cell.model = model.arrmodel[indexPath.row];
    
    if(model.arrmodel.count == indexPath.row+1 && arrdata.count != indexPath.section+1)
    {
        cell.ishidenline = YES;
    }
    else
    {
        cell.ishidenline = NO;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 40)];
    [view setBackgroundColor:RGB(245, 244, 245)];
    
    MyAccountTXJLListModel *model = arrdata[section];
    
    UILabel *lbgjname = [[UILabel alloc] init];
    [lbgjname setText:model.strtime];
    [lbgjname setTextAlignment:NSTextAlignmentLeft];
    [lbgjname setTextColor:RGB(150, 150, 150)];
    [lbgjname setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbgjname];
    [lbgjname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.bottom.equalTo(view);
        make.width.offset(200);
        
    }];
    
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 0.1)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}

#pragma mark - getter / setter

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self.tableView addSubview:_emptyView];
        _emptyView.remindStr = @"暂无数据！";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


@end
