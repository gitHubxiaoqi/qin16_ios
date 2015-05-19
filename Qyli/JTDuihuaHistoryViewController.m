//
//  JTDuihuaHistoryViewController.m
//  清一丽
//
//  Created by 小七 on 15-2-13.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTDuihuaHistoryViewController.h"

#import "JTJifenShangchengDetailViewController.h"
#import "JTDuihuanHistoryDetailViewController.h"
#import "JTDuihuanHistoryListTableViewCell.h"

@interface JTDuihuaHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView * _tableView;
    NSMutableArray * _listModelArr;
    int p;
    int q;
    int pageNum;
    NSString * _searchWord;
    NSString * _stateId;
}


@end

@implementation JTDuihuaHistoryViewController

-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    if (p==1)
    {
        [self sendPost];
    }
    p=2;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchWord=@"";
    _stateId=@"";
    p=1;
    q=3;
    pageNum=1;
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    [self readyUI];
}

-(void)readyUI
{
    self.view.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.view.bounds.size.width-60, 44)];
    navTitailLab.text=[NSString stringWithFormat:@"历史订单"];
    navTitailLab.font=[UIFont systemFontOfSize:18];
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    [navLab addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:leftBtn];
    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 10, 15);
    [leftBtn addSubview:backImgView];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listModelArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    JTDuihuanHistoryListTableViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
    if (!customCell)
    {
        customCell=[[JTDuihuanHistoryListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
        customCell.selectionStyle=UITableViewCellSelectionStyleNone;
        customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    }
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    [customCell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
    
    customCell.titleLab.text=model.title;
    customCell.typeLab.text=[NSString stringWithFormat:@"市场价:%@元    花费积分:%@",model.cost,model.beginDate];
    customCell.dateLab.text=[NSString stringWithFormat:@"兑换时间:%@",model.registTime];
    customCell.btn1.tag=200+indexPath.row;
    [customCell.btn1 addTarget:self action:@selector(lipin:) forControlEvents:UIControlEventTouchUpInside];

    return customCell;
}
-(void)lipin:(UIButton *)sender
{
    JTSortModel * model=[[JTSortModel alloc] init];
    model=[_listModelArr objectAtIndex:sender.tag-200];
    JTJifenShangchengDetailViewController * detailVC=[[JTJifenShangchengDetailViewController alloc] init];
    detailVC.giftIdStr=model.fuId;
    [self.navigationController pushViewController:detailVC animated:YES];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSortModel * model=[[JTSortModel alloc] init];
    model=[_listModelArr objectAtIndex:indexPath.row];
    JTDuihuanHistoryDetailViewController * detailVC=[[JTDuihuanHistoryDetailViewController alloc] init];
    detailVC.orderIdStr=model.idStr;
    detailVC.orderState=model.style;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(void)sendPost
{
    pageNum=1;
    [_listModelArr removeAllObjects];
    [_tableView reloadData];
    q=3;
    [_tableView headerBeginRefreshing];
}
-(void)CompanyListHeaderRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新表格
        [self GetCompanyListData];
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}

-(void)footerRefresh
{
    pageNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //请求数据
        [self loadMoreData];
        // 刷新表格
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}
-(void)GetCompanyListData
{
    
    if ([SOAPRequest checkNet])
    {
        JTAppDelegate * appdelgate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_searchWord,@"name",[NSString stringWithFormat:@"%d",appdelgate.appUser.userID],@"userId",_stateId,@"status",@"1",@"currentPageNo",@"20",@"pageSize",nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_GetMemberPointsorderList] jsonDic:jsondic]];
        
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"pointsorderPage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsorderPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"createTimeValue"];
                    sortModel.style=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"status"];
                    
                    sortModel.fuId=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"id"];
                    sortModel.title=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"name"];
                    sortModel.cost=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"price"];
                    sortModel.imgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"image"];
                    sortModel.beginDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"redeemPoints"];
                    [_listModelArr addObject:sortModel];
    
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsorderPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    NSString * idStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"]];
                    BOOL isExist=0;
                    for (int j=0; j<[_listModelArr count]; j++)
                    {
                        JTSortModel * aModel=[_listModelArr objectAtIndex:j];
                        if ([[NSString stringWithFormat:@"%@",aModel.idStr] isEqualToString:idStr])
                        {
                            isExist=1;
                            break;
                        }
                    }
                    if (isExist==0)
                    {
                        JTSortModel * sortModel=[[JTSortModel alloc] init];
                        sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                        sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"createTimeValue"];
                        sortModel.style=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"status"];
                        
                        sortModel.fuId=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"id"];
                        sortModel.title=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"name"];
                        sortModel.cost=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"price"];
                        sortModel.imgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"image"];
                        sortModel.beginDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"redeemPoints"];
                        [_listModelArr insertObject:sortModel atIndex:0];
               
                        
                    }
                }
                
            }
            
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
    }

}
-(void)loadMoreData
{
    if ([SOAPRequest checkNet])
    {
        JTAppDelegate * appdelgate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_searchWord,@"name",[NSString stringWithFormat:@"%d",appdelgate.appUser.userID],@"userId",_stateId,@"status",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"20",@"pageSize",nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_GetMemberPointsorderList] jsonDic:jsondic]];
        
        if ([[zaojiaoListDic objectForKey:@"resultCode"] intValue]==1000)
        {
            if ([[[zaojiaoListDic objectForKey:@"pointsorderPage"] objectForKey:@"list"] count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsorderPage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"createTimeValue"];
                sortModel.style=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"status"];
                
                sortModel.fuId=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"id"];
                sortModel.title=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"name"];
                sortModel.cost=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"price"];
                sortModel.imgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"image"];
                sortModel.beginDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"pointsgift"] objectForKey:@"redeemPoints"];
                [_listModelArr addObject:sortModel];
            }
            
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
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
