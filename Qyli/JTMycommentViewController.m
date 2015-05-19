//
//  JTMycommentViewController.m
//  Qyli
//
//  Created by 小七 on 14-8-6.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTMycommentViewController.h"
#import "JTMyCommentTableViewCell.h"
#import "JTMyCommentDetailViewController.h"
#import "JTKeChengDetailViewController.h"
#import "JTShangpinDetailViewController.h"



@interface JTMycommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tabView;
    NSMutableArray * _sortEvaluateModelArr;
    int pageNum;
    int q;
    int p;
    BOOL isGet[2];
}

@end

@implementation JTMycommentViewController

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
-(void)viewWillDisappear:(BOOL)animated
{
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    if (p==1)
    {
      [self sendPost];
    }
    p=2;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    p=1;
    q=3;
    pageNum=1;
    _sortEvaluateModelArr=[[NSMutableArray alloc] initWithCapacity:0];
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
    navTitailLab.text=@"我的点评历史";
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
    
    //表视图
    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
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
    return [_sortEvaluateModelArr count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTMyCommentTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[JTMyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:indexPath.row];

    cell.titleLab.text=evaluateModel.title;
    cell.scroe=[evaluateModel.scroeAvg intValue];
    cell.dateLab.text=evaluateModel.reviewDate;
    cell.contentLab.text=[NSString stringWithFormat:@"      %@",evaluateModel.context];
    
    CGSize autoSize=[cell.contentLab.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.contentLab.font} context:nil].size;
    if (autoSize.height<20)
    {
        autoSize.height=20;
    }
    
    cell.contentLab.frame=CGRectMake(5, 55, self.view.frame.size.width-30, autoSize.height+10);
       
    [cell refreshStarAndUI];
    
    cell.upBtn.tag=10000+indexPath.row;
    [cell.upBtn addTarget:self action:@selector(upBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.downBtn.tag=20000+indexPath.row;
    cell.downBtn.frame=CGRectMake(0, 35, self.view.frame.size.width, 15+autoSize.height+20);
    [cell.downBtn addTarget:self action:@selector(downBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:indexPath.row];
    CGSize autoSize=[[NSString stringWithFormat:@"      %@",evaluateModel.context] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if (autoSize.height<20)
    {
        autoSize.height=20;
    }
    return 50+autoSize.height+20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)upBtn:(UIButton *)sender
{
    int count=sender.tag-10000;
    JTSortEvaluateModel * model=[[JTSortEvaluateModel alloc] init];
    model=[_sortEvaluateModelArr objectAtIndex:count];
    
    if([model.mappingIDStr intValue]==12)
    {
        JTShangpinDetailViewController * zjdVC=[[JTShangpinDetailViewController alloc] init];
        zjdVC.sortmodel=[[JTSortModel alloc] init];
        zjdVC.sortmodel.idStr=model.infoIDStr;
        [self.navigationController pushViewController:zjdVC animated:YES];
    
    }
    else if([model.mappingIDStr intValue]==11)
    {
        JTKeChengDetailViewController * zjdVC=[[JTKeChengDetailViewController alloc] init];
        zjdVC.sortmodel=[[JTSortModel alloc] init];
        zjdVC.sortmodel.idStr=model.infoIDStr;
        zjdVC.state=2;
        [self.navigationController pushViewController:zjdVC animated:YES];
    }
    


}
-(void)downBtn:(UIButton *)sender
{
    JTMyCommentDetailViewController * dVC=[[JTMyCommentDetailViewController alloc] init];
    dVC.sortEvaluateModel=[[JTSortEvaluateModel alloc] init];
    dVC.sortEvaluateModel=[_sortEvaluateModelArr objectAtIndex:sender.tag-20000];
    [self.navigationController pushViewController:dVC animated:YES];
    p=1;
}

#pragma mark-发请求
-(void)sendPost
{
    pageNum=1;
    [_sortEvaluateModelArr removeAllObjects];
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
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",@"1",@"currentPageNo",@"10",@"pageSize", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_MemberCenterReviewList] jsonDic:jsondic]];
        
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            if (q==3)
            {
                NSArray * evaluateArr=[[NSArray alloc] initWithArray:[[zaojiaoEvaluateDic objectForKey:@"reviewPage"] objectForKey:@"data"]];
                if (evaluateArr.count==0)
                {
                    NSString * str=@"您尚未针对任何信息做出评论。。";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                
                for (int i=0;i<evaluateArr.count;i++)
                {
                    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
                    evaluateModel.idStr=[[evaluateArr objectAtIndex:i] objectForKey:@"id"];
                    evaluateModel.userIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"userId"];
                    evaluateModel.mappingIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"mappingId"];
                    evaluateModel.infoIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"infoId"];
                    evaluateModel.parentIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                    evaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                    evaluateModel.title=[[evaluateArr objectAtIndex:i] objectForKey:@"infoName"];
                    evaluateModel.reviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                    evaluateModel.scroeAvg=[[evaluateArr objectAtIndex:i] objectForKey:@"scoreAvg"];
                    
                    [_sortEvaluateModelArr addObject:evaluateModel];
                }
                q=6;
                
                
            }
            else if (q==6)
            {
                NSArray * evaluateArr=[[NSArray alloc] initWithArray:[[zaojiaoEvaluateDic objectForKey:@"reviewPage"] objectForKey:@"data"]] ;
                for (int i=0;i<evaluateArr.count;i++)
                {
                    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
                    evaluateModel.idStr=[[evaluateArr objectAtIndex:i] objectForKey:@"id"];
                    evaluateModel.userIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"userId"];
                    evaluateModel.mappingIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"mappingId"];
                    evaluateModel.infoIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"infoId"];
                    evaluateModel.parentIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                    evaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                    evaluateModel.title=[[evaluateArr objectAtIndex:i] objectForKey:@"infoName"];
                    evaluateModel.reviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                    evaluateModel.scroeAvg=[[evaluateArr objectAtIndex:i] objectForKey:@"scoreAvg"];
                    BOOL isExist=0;
                    for (int i=0;i<_sortEvaluateModelArr.count;i++)
                    {
                        JTSortEvaluateModel * evaluateModel1=[[JTSortEvaluateModel alloc] init];
                        evaluateModel1=[_sortEvaluateModelArr objectAtIndex:i];
                        
                        if ([[NSString stringWithFormat:@"%@",evaluateModel1.idStr] isEqualToString:[NSString stringWithFormat:@"%@",evaluateModel.idStr]])
                        {
                            isExist=1;
                            break;
                        }
                        
                    }
                    if (isExist==0)
                    {
                        [_sortEvaluateModelArr addObject:evaluateModel];
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"10",@"pageSize", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_MemberCenterReviewList] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            NSArray * evaluateArr=[[NSArray alloc] initWithArray:[[zaojiaoEvaluateDic objectForKey:@"reviewPage"] objectForKey:@"data"]] ;
            if (evaluateArr.count==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            for (int i=0;i<evaluateArr.count;i++)
            {
                JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
                evaluateModel.idStr=[[evaluateArr objectAtIndex:i] objectForKey:@"id"];
                evaluateModel.userIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"userId"];
                evaluateModel.mappingIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"mappingId"];
                evaluateModel.infoIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"infoId"];
                evaluateModel.parentIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                evaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                evaluateModel.title=[[evaluateArr objectAtIndex:i] objectForKey:@"infoName"];
                evaluateModel.reviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                evaluateModel.scroeAvg=[[evaluateArr objectAtIndex:i] objectForKey:@"scoreAvg"];
                [_sortEvaluateModelArr addObject:evaluateModel];
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
