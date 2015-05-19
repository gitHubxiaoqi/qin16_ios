//
//  JTJifenShangchengViewController.m
//  清一丽
//
//  Created by 小七 on 15-2-12.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTJifenShangchengViewController.h"
#import "JTMyScoreViewController.h"
#import "JTJifenShuomingViewController.h"
#import "JTJifenShangchengListTableViewCell.h"
#import "JTDuihuanViewController.h"
#import "JTJifenShangchengDetailViewController.h"
#import "JTDuihuaHistoryViewController.h"

@interface JTJifenShangchengViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView * _tableView;
    NSMutableArray * _listModelArr;
    int p;
    int q;
    int pageNum;
    NSString * _searchWord;
}

@end

@implementation JTJifenShangchengViewController
-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
    
    
    UILabel * lab1=(UILabel *)[self.view viewWithTag:10];
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    lab1.text=[NSString stringWithFormat:@"%@", appdelegate.appUser.availablePoints];

    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchWord=@"";
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
    navTitailLab.text=[NSString stringWithFormat:@"积分商城"];
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
    
    UIView * topView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 70)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    
    UILabel * lab1_1=[[UILabel alloc] initWithFrame:CGRectMake(10, 10,70, 25)];
    lab1_1.text=@"当前积分:";
    lab1_1.textColor=[UIColor blackColor];
    lab1_1.font=[UIFont systemFontOfSize:16];
    [topView addSubview:lab1_1];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 50, 25)];
    lab1.tag=10;
    lab1.text=[NSString stringWithFormat:@"%@", appdelegate.appUser.availablePoints];
    lab1.textColor=[UIColor orangeColor];
    lab1.textAlignment=NSTextAlignmentRight;
    lab1.font=[UIFont systemFontOfSize:18];
    [topView addSubview:lab1];
    
    UILabel * lab1_2=[[UILabel alloc] initWithFrame:CGRectMake(120, 10,20, 25)];
    lab1_2.text=@"分";
    lab1_2.textColor=[UIColor blackColor];
    lab1_2.font=[UIFont systemFontOfSize:16];
    [topView addSubview:lab1_2];
    
    
    UIButton * btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 35, 80, 35);
    btn1.tag=100;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn1];
    
    UIImageView * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"积分明细.png"]];
    imgView1.frame=CGRectMake(15, 10, 15, 20);
    [btn1 addSubview:imgView1];
    
    UILabel * mingxiLab=[[UILabel alloc] initWithFrame:CGRectMake(35, 10, 60, 20)];
    mingxiLab.text=@"积分明细";
    mingxiLab.font=[UIFont systemFontOfSize:14];
    [btn1 addSubview:mingxiLab];
    
    UIButton * btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(SCREEN_WIDTH-120, 0, 120, 35);
    btn2.tag=102;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn2];
    
    UIImageView * imgView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"兑换记录.png"]];
    imgView2.frame=CGRectMake(15, 10, 15, 20);
    [btn2 addSubview:imgView2];
    
    UILabel * jiluLab=[[UILabel alloc] initWithFrame:CGRectMake(35, 10, 60, 20)];
    jiluLab.text=@"兑换记录";
    jiluLab.font=[UIFont systemFontOfSize:14];
    jiluLab.textColor=[UIColor orangeColor];
    [btn2 addSubview:jiluLab];
    
    
    UIButton * btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(SCREEN_WIDTH-140,35, 140, 35);
    btn3.tag=101;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn3];
    
    UIImageView * imgView3=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"问号.png"]];
    imgView3.frame=CGRectMake(15, 12, 15, 15);
    [btn3 addSubview:imgView3];
    
    UILabel * zhuangquLab=[[UILabel alloc] initWithFrame:CGRectMake(35, 10, 90, 20)];
    zhuangquLab.text=@"怎样赚取积分";
    zhuangquLab.font=[UIFont systemFontOfSize:14];
    [btn3 addSubview:zhuangquLab];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+70, self.view.frame.size.width, self.view.frame.size.height-64-70) style:UITableViewStylePlain];
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

-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag-100)
    {
        case 0:
        {
            JTMyScoreViewController * scroeVC=[[JTMyScoreViewController alloc] init];
            [self.navigationController pushViewController:scroeVC animated:YES];
        }
            break;
        case 1:
        {
            JTJifenShuomingViewController * shuomingVC=[[JTJifenShuomingViewController alloc] init];
            [self presentViewController:shuomingVC animated:YES completion:nil];
        }
            break;
        case 2:
        {
            JTDuihuaHistoryViewController * historyVC=[[JTDuihuaHistoryViewController alloc] init];
            [self.navigationController pushViewController:historyVC animated:YES];
        }
            break;
            
        default:
            break;
    }

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
    JTJifenShangchengListTableViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
    if (!customCell)
    {
        customCell=[[JTJifenShangchengListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
        customCell.selectionStyle=UITableViewCellSelectionStyleNone;
        customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    }
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    [customCell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
    
    customCell.titleLab.text=model.title;
    customCell.typeLab.text=[NSString stringWithFormat:@"%@积分",model.beginDate];
    customCell.countLab.text=[NSString stringWithFormat:@"已兑换:%@次",model.endDate];
    customCell.priceLab.text=[NSString stringWithFormat:@"市场价:%@元",model.cost];
    customCell.btn1.tag=200+indexPath.row;
    [customCell.btn1 addTarget:self action:@selector(duihuan:) forControlEvents:UIControlEventTouchUpInside];
    return customCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSortModel * model=[[JTSortModel alloc] init];
    model=[_listModelArr objectAtIndex:indexPath.row];
    JTJifenShangchengDetailViewController * detailVC=[[JTJifenShangchengDetailViewController alloc] init];
    detailVC.giftIdStr=model.idStr;
    [self.navigationController pushViewController:detailVC animated:YES];

}
-(void)duihuan:(UIButton *)sender
{
    JTSortModel * model=[[JTSortModel alloc] init];
    model=[_listModelArr objectAtIndex:sender.tag-200];
    JTDuihuanViewController * duihuanVC=[[JTDuihuanViewController alloc] init];
    duihuanVC.giftIdStr=model.idStr;
    [self.navigationController pushViewController:duihuanVC animated:YES];
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_searchWord,@"name",@"1",@"currentPageNo",@"20",@"pageSize",nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_GetPointsgiftList] jsonDic:jsondic]];
        
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"pointsgiftPage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsgiftPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                    sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"image"];
                    sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"redeemPoints"];
                    sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"buySum"];
                    [_listModelArr addObject:sortModel];
            
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsgiftPage"] objectForKey:@"list"];
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
                        sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                        sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                        sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"image"];
                        sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"redeemPoints"];
                        sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"buySum"];                        [_listModelArr insertObject:sortModel atIndex:0];
                 
                        
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_searchWord,@"name",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"20",@"pageSize",nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_GetPointsgiftList] jsonDic:jsondic]];
        if ([[zaojiaoListDic objectForKey:@"resultCode"] intValue]==1000)
        {
            if ([[[zaojiaoListDic objectForKey:@"pointsgiftPage"] objectForKey:@"list"] count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"pointsgiftPage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"image"];
                sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"redeemPoints"];
                sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"buySum"];                 [_listModelArr addObject:sortModel];
            
            }
            
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
