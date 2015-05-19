//
//  JTMyScoreViewController.m
//  Qyli
//
//  Created by 小七 on 14-9-26.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTMyScoreViewController.h"
#import "JTMyScoreTableViewCell.h"
#import "JTPointsModel.h"

@interface JTMyScoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int q;
    int pageNum;
    NSMutableArray * _pointsArr;
    UITableView * _tabView;
}

@end

@implementation JTMyScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self sendPost];
}
-(void)viewWillDisappear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    q=3;
    pageNum=1;
    _pointsArr=[[NSMutableArray alloc] initWithCapacity:0];

    [self readyUI];
}
-(void)readyUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"我的积分";
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:20];
    [navLab addSubview:navTitailLab];

    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:leftBtn];
    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 10, 15);
    [leftBtn addSubview:backImgView];
    
    UIView * topView=[[UIView alloc] init];
    topView.frame=CGRectMake(0, 64, self.view.frame.size.width, 40);
    [self.view addSubview:topView];
    
    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(15, 5,80, 30)];
    lab.text=@"总积分：";
    lab.textColor=[UIColor blackColor];
    lab.font=[UIFont systemFontOfSize:20];
    [topView addSubview:lab];
    
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    UILabel * allPointsLab=[[UILabel alloc] initWithFrame:CGRectMake(85, 5, 200, 30)];
    allPointsLab.text=[NSString stringWithFormat:@"%@分",appdelegate.appUser.points];
    allPointsLab.textColor=[UIColor redColor];
    allPointsLab.font=[UIFont systemFontOfSize:22];
    [topView addSubview:allPointsLab];
    
    UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 39, topView.frame.size.width, 0.5)];
    lineLab.backgroundColor=[UIColor blueColor];
    [topView addSubview:lineLab];
    
    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.frame.size.width, self.view.frame.size.height-64-40) style:UITableViewStylePlain];
    _tabView.dataSource=self;
    _tabView.delegate=self;
    [_tabView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tabView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tabView.headerRefreshingText =@HeaderRefreshingText;
    _tabView.footerRefreshingText=@FooterRefreshingText;
    _tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabView];
    
}
-(void)leftBtnCilck
{
   
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pointsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JTMyScoreTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[JTMyScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel * lineLab=[[UILabel alloc] init];
        lineLab.tag=98;
        [cell addSubview:lineLab];
        
    }
    UILabel * lineLab=(UILabel *)[cell viewWithTag:98];
    lineLab.frame=CGRectMake(0, 59, self.view.frame.size.width, 0.5);
    lineLab.backgroundColor=[UIColor grayColor];
    JTPointsModel * model=[_pointsArr objectAtIndex:indexPath.row];
    if ([[NSString stringWithFormat:@"%@",model.changePoints] intValue]<0)
    {
        cell.changePointsLab.text=[NSString stringWithFormat:@"%@",model.changePoints];
        cell.changePointsLab.textColor=[UIColor orangeColor];
    }
    else
    {
        cell.changePointsLab.text=[NSString stringWithFormat:@"+%@",model.changePoints];
        cell.changePointsLab.textColor=[UIColor blueColor];

    }
    
    cell.remarkLab.text=[NSString stringWithFormat:@"%@",model.remark];
    cell.dateLab.text=[NSString stringWithFormat:@"%@",model.operatingTime];
    cell.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)sendPost
{
    pageNum=1;
    [_pointsArr removeAllObjects];
    [_tabView reloadData];
    q=3;
    [_tabView headerBeginRefreshing];
}
-(void)CompanyListHeaderRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新表格
        [self GetCompanyListData];
        [_tabView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tabView headerEndRefreshing];
    });
}

-(void)footerRefresh
{
    pageNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //请求数据
        [self loadMoreData];
        // 刷新表格
        [_tabView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tabView footerEndRefreshing];
    });
}
-(void)GetCompanyListData
{
    if ([SOAPRequest checkNet])
    {
        
        JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",@"1",@"currentPageNo",@"10",@"pageSize", nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Points_GetMemberPointDetailList] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"pointsPage"]objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"您当前还没有积分，快去签到吧！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTPointsModel * sortModel=[[JTPointsModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.changePoints=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"changePoints"];
                    sortModel.operatingTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"operatingTimeValue"];
                    sortModel.remark=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"remark"];
                    [_pointsArr addObject:sortModel];
    
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    NSString * idStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"]];
                    BOOL isExist=0;
                    for (int j=0; j<[_pointsArr count]; j++)
                    {
                        JTPointsModel * aModel=[_pointsArr objectAtIndex:j];
                        if ([[NSString stringWithFormat:@"%@",aModel.idStr] isEqualToString:idStr])
                        {
                            isExist=1;
                            break;
                        }
                    }
                    if (isExist==0)
                    {
                        JTPointsModel * sortModel=[[JTPointsModel alloc] init];
                        sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                        sortModel.changePoints=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"changePoints"];
                        sortModel.operatingTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"operatingTimeValue"];
                        sortModel.remark=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"remark"];
                        [_pointsArr insertObject:sortModel atIndex:0];
             
                        
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
        JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"10",@"pageSize", nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Points_GetMemberPointDetailList] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if ([[[zaojiaoListDic objectForKey:@"pointsPage"] objectForKey:@"list"]count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsPage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTPointsModel * sortModel=[[JTPointsModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.changePoints=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"changePoints"];
                sortModel.operatingTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"operatingTimeValue"];
                sortModel.remark=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"remark"];
                [_pointsArr addObject:sortModel];
         
            }
            
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
