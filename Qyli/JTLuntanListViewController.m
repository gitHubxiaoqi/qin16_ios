//
//  JTLuntanListViewController.m
//  清一丽
//
//  Created by 小七 on 15-4-10.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTLuntanListViewController.h"

#import "JTLuntanListTableViewCell.h"
#import "JTLuntanDetailViewController.h"
@interface JTLuntanListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    int p;
    int q;
    int pageNum;
    NSMutableArray * _listModelArr;
}
@end

@implementation JTLuntanListViewController
-(void)viewWillDisappear:(BOOL)animated
{
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
    if (p==1)
    {
      [self sendPost];
 
    }
    p=2;

  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    p=1;
    q=3;
    pageNum=1;
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    [self readyUI];
}
-(void)readyUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    UIView * navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navBarView.userInteractionEnabled=YES;
    navBarView.backgroundColor=NAV_COLOR;
    [self.view addSubview:navBarView];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=self.title;
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:22];
    [navBarView addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 2, 50, 40);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    UIImageView * jiantouImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    jiantouImgView.frame=CGRectMake(20, 15, 10, 14);
    [leftBtn addSubview:jiantouImgView];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator=NO;
    
}
#pragma mark - 表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [_listModelArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];

    CGSize topicAutoSize=[model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    if (topicAutoSize.height<20)
    {
        topicAutoSize.height=20;
    }
    
    CGSize contentAutoSize=[ model.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if (contentAutoSize.height<20)
    {
        contentAutoSize.height=20;
    }
    else if (contentAutoSize.height>60)
    {
        contentAutoSize.height=60;
    }

    if (model.imgUrlArr.count==0)
    {
        return 60+topicAutoSize.height+contentAutoSize.height+10+30+20;

    }
    else if (model.imgUrlArr.count==1)
    {
        return 60+topicAutoSize.height+contentAutoSize.height+10+100+10+30+20;
    }
    else if (model.imgUrlArr.count==2)
    {
        return 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20;

    }
    else if (model.imgUrlArr.count==3)
    {
        return 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20;

    }
    else if (model.imgUrlArr.count==4)
    {
        return 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20;

    }
    else
    {
        return 60+topicAutoSize.height+contentAutoSize.height+10+(SCREEN_WIDTH-20-30)/5.0+10+30+20;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    JTLuntanListTableViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
    if (!customCell)
    {
        customCell=[[JTLuntanListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
        customCell.selectionStyle=UITableViewCellSelectionStyleNone;
        customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        
    }
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    [customCell refreshCell:model];
    return customCell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTLuntanDetailViewController *detailVC=[[JTLuntanDetailViewController alloc] init];
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    detailVC.sortModel=[[JTSortModel alloc] init];
    detailVC.sortModel=model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
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
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.typeId,@"type",@"1",@"currentPageNo",@"20",@"pageSize", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_GetTopicListByType] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"topicPage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"topicPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"title"];
                    sortModel.beginDate=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"up"]];
                    sortModel.endDate=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"down"]];
                    sortModel.commentCount=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"subPostSum"]];
                    
                    sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publishTimeValue"];
                    sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"firstPostContent"];
                    sortModel.imgUrlArr=[[NSArray alloc] initWithArray:[[zaojiaoListArr objectAtIndex:i] objectForKey:@"picList"]];
                    sortModel.user=[[JTUser alloc] init];
                    sortModel.user.userName=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"userName"];
                    sortModel.user.headPortraitImgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"imageValue"];
                    
                    [_listModelArr addObject:sortModel];
        
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"topicPage"] objectForKey:@"list"];
                ;
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
                        sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"title"];
                        sortModel.beginDate=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"up"]];
                        sortModel.endDate=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"down"]];
                        sortModel.commentCount=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"subPostSum"]];
                        
                        sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publishTimeValue"];
                        sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"firstPostContent"];
                        sortModel.imgUrlArr=[[NSArray alloc] initWithArray:[[zaojiaoListArr objectAtIndex:i] objectForKey:@"picList"]];
                        sortModel.user=[[JTUser alloc] init];
                        sortModel.user.userName=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"userName"];
                        sortModel.user.headPortraitImgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"imageValue"];
                        
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.typeId,@"type",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"20",@"pageSize", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_GetTopicListByType] jsonDic:jsondic]];
        
        if ([[zaojiaoListDic objectForKey:@"resultCode"] intValue]==1000)
        {
            if ([[[zaojiaoListDic objectForKey:@"topicPage"] objectForKey:@"list"]count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"topicPage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"title"];
                sortModel.beginDate=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"up"]];
                sortModel.endDate=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"down"]];
                sortModel.commentCount=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"subPostSum"]];
                sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publishTimeValue"];
                sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"firstPostContent"];
                sortModel.imgUrlArr=[[NSArray alloc] initWithArray:[[zaojiaoListArr objectAtIndex:i] objectForKey:@"picList"]];
                sortModel.user=[[JTUser alloc] init];
                sortModel.user.userName=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"userName"];
                sortModel.user.headPortraitImgUrlStr=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"publisherUser"] objectForKey:@"imageValue"];
                
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
