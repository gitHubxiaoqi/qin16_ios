//
//  JTMyFatieListViewController.m
//  清一丽
//
//  Created by 小七 on 15-4-15.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTMyFatieListViewController.h"
#import "JTLuntanDetailViewController.h"
#import "JTLuntanListTableViewCell.h"

@interface JTMyFatieListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView * _tableView;
    int p;
    int q;
    int pageNum;
    NSMutableArray * _listModelArr;
}

@end

@implementation JTMyFatieListViewController
-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated
{
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
    
    //[_tableView setEditing:NO];

}
-(void)viewDidAppear:(BOOL)animated
{
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
    
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"我的发帖";
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
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator=NO;
     //_tableView.editing=YES;
    
}

-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listModelArr.count;
    
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
    JTLuntanDetailViewController * detailVC=[[JTLuntanDetailViewController alloc] init];
    detailVC.sortModel=[[JTSortModel alloc] init];
    detailVC.sortModel=[_listModelArr objectAtIndex:indexPath.row];
    [self .navigationController pushViewController:detailVC animated:YES];
}
-(UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定删除该条帖子吗，同时删除相应评论？此操作不可逆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=100+indexPath.row;
        [alert show];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
        
        if ([SOAPRequest checkNet])
        {
            JTSortModel * model=[_listModelArr objectAtIndex:alertView.tag-100];
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:model.idStr,@"topicId",[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"20",@"pageSize", nil];
            
            NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_DelTopic] jsonDic:jsondic]];
            
            if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
            {
                [_listModelArr removeObjectAtIndex:alertView.tag-100];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:alertView.tag-100 inSection:0];
                [_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             
                
                if ([zaojiaoDic objectForKey:@"backTopic"]!=nil)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoDic objectForKey:@"backTopic"] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoDic objectForKey:@"backTopic"] objectForKey:@"title"];
                    sortModel.beginDate=[NSString stringWithFormat:@"%@",[[zaojiaoDic objectForKey:@"backTopic"]objectForKey:@"up"]];
                    sortModel.endDate=[NSString stringWithFormat:@"%@",[[zaojiaoDic objectForKey:@"backTopic"]objectForKey:@"down"]];
                    sortModel.commentCount=[NSString stringWithFormat:@"%@",[[zaojiaoDic objectForKey:@"backTopic"] objectForKey:@"subPostSum"]];
                    
                    sortModel.registTime=[[zaojiaoDic objectForKey:@"backTopic"]objectForKey:@"publishTimeValue"];
                    sortModel.name=[[zaojiaoDic objectForKey:@"backTopic"] objectForKey:@"firstPostContent"];
                    sortModel.imgUrlArr=[[NSArray alloc] initWithArray:[[zaojiaoDic objectForKey:@"backTopic"] objectForKey:@"picList"]];
                    sortModel.user=[[JTUser alloc] init];
                    sortModel.user.userName=[[[zaojiaoDic objectForKey:@"backTopic"] objectForKey:@"publisherUser"] objectForKey:@"userName"];
                    sortModel.user.headPortraitImgUrlStr=[[[zaojiaoDic objectForKey:@"backTopic"]objectForKey:@"publisherUser"] objectForKey:@"imageValue"];
                    
                    [_listModelArr addObject:sortModel];
                    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:_listModelArr.count-1 inSection:0];
                    [_tableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath2] withRowAnimation:UITableViewRowAnimationNone];

                }
                
            }
            else
            {
                NSString * str=@"服务器异常，请稍后重试...";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            
        }
        
     
    }
}
#pragma mark-发请求
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
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",@"1",@"currentPageNo",@"20",@"pageSize", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_GetUserTopicList] jsonDic:jsondic]];
        
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
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"20",@"pageSize", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Luntan_GetUserTopicList] jsonDic:jsondic]];
        
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
