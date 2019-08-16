//
//  DaiGouFenLeiTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/26.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouFenLeiTableViewController.h"

#import <MJRefresh.h>

#import "ProductInfoViewController.h"

#import "MDB_UserDefault.h"

#import "VKLoginViewController.h"

#import "SelectColorAndSizeView.h"

#import "MDBEmptyView.h"

#import "DaiGouHomeTableViewCell.h"

#import "JinRiPinDanListDataController.h"

#import "GoodsCarViewController.h"

#import "TKExploreSearchWriteView.h"

@interface DaiGouFenLeiTableViewController ()<DaiGouHomeTableViewCellDelegate,SelectColorAndSizeViewDelegate,UITextFieldDelegate>
{
    JinRiPinDanListDataController *dataControl;
    int ipage;
    
    NSMutableArray *arrlistData;
    
    
    NSString *strlasttimetitle;
    
    SelectColorAndSizeView *ggView;
    NSString *strdaigaouid;
    
    UIView *viewtitle;
    UITextField *fieldsearch;
    
}

@property (nonatomic , retain)MDBEmptyView *emptyView;
@property (nonatomic , retain)UILabel *lbgwcnumber;

@end

@implementation DaiGouFenLeiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _strtitle;
    [self setSubview];
    dataControl = [[JinRiPinDanListDataController alloc] init];
    ipage = 1;
    arrlistData = [NSMutableArray new];
    [self bindData];
    
    [self emptyView];
    
    if([_strtitle isEqualToString:@"现货"])
    {
        [self setNavigation];
        self.title = @"";
    }
    
}

-(void)setNavigation
{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"daigougouwuchehui"] forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"daigougouwuchehui"] forState:UIControlStateHighlighted];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(rightanvAction) forControlEvents:UIControlEventTouchUpInside];
    [btnright setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btnright setTag:1];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    _lbgwcnumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [_lbgwcnumber setTextColor:[UIColor whiteColor]];
    [_lbgwcnumber setTextAlignment:NSTextAlignmentCenter];
    [_lbgwcnumber setFont:[UIFont systemFontOfSize:10]];
    [_lbgwcnumber setBackgroundColor:[UIColor redColor]];
    [_lbgwcnumber setRight:btnright.width];
    [_lbgwcnumber.layer setMasksToBounds:YES];
    [_lbgwcnumber.layer setCornerRadius:_lbgwcnumber.height/2.0];
    [btnright addSubview:_lbgwcnumber];
    [_lbgwcnumber setHidden:YES];
    
    if ([MDB_UserDefault getIsLogin])
    {
        NSString *strtemp = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"gouwuchegoodsnumber"] intValue]];
        [self gouwuchenumchange:strtemp.intValue];
    }
    
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem];
    
    
    
    viewtitle = [[UIView alloc]initWithFrame:CGRectMake(50, 5, self.view.width-110, 34)];
    [viewtitle setBackgroundColor:RGB(233, 233, 233)];
    [viewtitle.layer setMasksToBounds:YES];
    [viewtitle.layer setCornerRadius:viewtitle.height/2.0];
    [self.navigationController.navigationBar addSubview:viewtitle];
    [self.navigationController.navigationBar bringSubviewToFront:viewtitle];
    
    fieldsearch = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, viewtitle.width-30, viewtitle.height)];
    [fieldsearch setText:@""];
    [fieldsearch setPlaceholder:@"现货搜一下看看~"];
    [fieldsearch setTextColor:RGB(30, 30, 30)];
    [fieldsearch setTextAlignment:NSTextAlignmentLeft];
    [fieldsearch setFont:[UIFont systemFontOfSize:14]];
    [fieldsearch setReturnKeyType:UIReturnKeySearch];
    [fieldsearch setDelegate:self];
    [viewtitle addSubview:fieldsearch];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [viewtitle setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [viewtitle setHidden:YES];
    [fieldsearch resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        
    }
    
    return YES;
}

-(void)rightanvAction
{
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        return;
    }
    
    GoodsCarViewController *gvc = [[GoodsCarViewController alloc] init];
    [self.navigationController pushViewController:gvc animated:YES];
    
}

-(void)gouwuchenumchange:(int)itemp
{
    NSString *strtemp = [NSString stringWithFormat:@"%d",itemp];
    if(itemp>99)
    {
        strtemp = @"99+";
    }
    [_lbgwcnumber setHidden:NO];
    [_lbgwcnumber setText:strtemp];
    if(itemp<=0)
    {
        [_lbgwcnumber setHidden:YES];
    }
}
////添加购物车
-(void)gouwucheadd
{////处理数量
    
    int itemp = _lbgwcnumber.text.intValue+1;
    NSString *strtemp = [NSString stringWithFormat:@"%d",itemp];
    if(itemp>99)
    {
        strtemp = @"99+";
    }
    [_lbgwcnumber setHidden:NO];
    [_lbgwcnumber setText:strtemp];
    
}

-(void)setSubview
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        [self bindData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ipage++;
        [self bindData];
        
    }];
}

-(void)bindData
{
    [_dicpush setObject:[NSString stringWithFormat:@"%d",ipage] forKey:@"page"];
    [dataControl requestDGHomeListDataInView:self.view pushvalue:_dicpush andurl:_strurl ipost:_ipost Callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(ipage==1)
        {
            arrlistData = [NSMutableArray new];
        }
        if(dataControl.arrListData.count>0)
        {
            for(NSDictionary *dic in dataControl.arrListData)
            {
                DaiGouHomeListModel *model = [DaiGouHomeListModel viewModelWithSubject:dic];
                if(_ishiddenxianhuo)
                {
                    model.isspotgoods = @"0";
                }
                [arrlistData addObject:model];
            }
        }
        
        if(arrlistData.count>0)
        {
            [_emptyView setHidden:YES];
        }
        else
        {
            [_emptyView setHidden:NO];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [fieldsearch resignFirstResponder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrlistData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *strcell = @"DaiGouHomeTableViewCell3";
    DaiGouHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[DaiGouHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = arrlistData[indexPath.row];
    cell.isxianhuo = _isxianhuo;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DaiGouHomeListModel *model = arrlistData[indexPath.row];
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = model.share_id;
    [self.navigationController pushViewController:pvc animated:YES];
    NSLog(@"点击");
    
}

-(void)DaiGouHomeTableViewCellAddGouWuChe:(DaiGouHomeListModel *)model
{
    
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        return;
    }
    
    if(model.dgID==nil)return;
    
    strdaigaouid = model.dgID;
    
    if(model.isspiderorder.integerValue==1)
    {
        NSMutableDictionary *dicinfo = [NSMutableDictionary new];
        [dicinfo setObject:model.dgID forKey:@"id"];
        [dicinfo setObject:model.image forKey:@"image"];
        [dicinfo setObject:model.title forKey:@"title"];
        
        SelectColorAndSizeView *svc = [[SelectColorAndSizeView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andvalue:dicinfo andtype:0];
        [svc setDelegate:self];
        [self.view.window addSubview:svc];
        [svc showView];
        ggView = svc;
    }
    else
    {
        [self addGouWuChe:@"" andnum:@"1"];
    }
    
    
    
    
    
}
#pragma mark - SelectColorAndSizeViewDelegate
///购买商品
-(void)buyGoods:(NSString *)strid andnum:(NSString *)strnum
{
}
///修改购物车规格
-(void)changeGouWuChe:(NSString *)strid andcartid:(NSString *)strcartid
{
}
///添加购物车
-(void)addGouWuChe:(NSString *)strid andnum:(NSString *)strnum;
{
    [MobClick event:@"dgliebiaojiagouwuche" label:@"代购列表加购物车"];
    NSDictionary *dicpush = @{@"id":strdaigaouid,@"num":strnum,@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"goodsdetailid":strid};
    
    [dataControl requestAddBuCarDataLine:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [ggView dismisAction];
            //动画
            if([_strtitle isEqualToString:@"现货"])
            {
                UIImageView *imgvtemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                [imgvtemp setImage:[UIImage imageNamed:@"addgouwuche_remu"]];
                [imgvtemp setCenter:CGPointMake(self.view.width/2.0, self.view.height/2.0)];
                [self.view.window addSubview:imgvtemp];
                [UIView animateWithDuration:0.5 animations:^{
                    [imgvtemp setWidth:1];
                    [imgvtemp setHeight:1];
                    [imgvtemp setTop:10];
                    [imgvtemp setRight:self.view.width-20];
                    
                    
                } completion:^(BOOL finished) {
                    [imgvtemp removeFromSuperview];
                    [self gouwucheadd];
                    
                }];
                
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:@"购物车添加成功" inView:self.view.window];
            }
             
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view.window];
        }
    }];
}


#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 110) {
        VKLoginViewController *vkVc = [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:vkVc animated:YES];
    }
}



- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self.view addSubview:_emptyView];
        _emptyView.remindStr = @"暂无相关数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
