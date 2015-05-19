//
//  JTPinglunMoreBackReviewViewController.m
//  Qyli
//
//  Created by 小七 on 14-12-4.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTPinglunMoreBackReviewViewController.h"
#import "JTZaojiaoEvaluateSectionHeaderView.h"
#import "JTZaojiaoEvaluateTableViewCell.h"
#import "JTPingLunGoBackEvaluateViewController.h"
@interface JTPinglunMoreBackReviewViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tabView;
    int pageNum;
    int q;
    NSString * totalCount;
}
@end
@implementation JTPinglunMoreBackReviewViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView3.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView.hidden=YES;
    [self sendPost];
    JTZaojiaoEvaluateSectionHeaderView * view1=(JTZaojiaoEvaluateSectionHeaderView *)[self.view viewWithTag:200];
    view1.backReviewCountLab.text=[NSString stringWithFormat:@"回复(%@)",totalCount];
}
-(void)viewWillDisappear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView3.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView.hidden=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    totalCount=@"4+";
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
    navTitailLab.text=@"查看全部回复";
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
    
    JTZaojiaoEvaluateSectionHeaderView * view1=[[JTZaojiaoEvaluateSectionHeaderView alloc] init];
    view1.bounds=CGRectMake(0, 0, self.view.frame.size.width, 71);
    [view1.headImgView setImageWithURL:[NSURL URLWithString:_evaluateModel.userHeadPortraitURLStr] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    view1.scroe=[_evaluateModel.scroeAvg intValue];
    view1.dateLab.text=_evaluateModel.reviewDate;
    view1.contentLab.text=[NSString stringWithFormat:@"    %@",_evaluateModel.context];
    view1.userNameLab.text=_evaluateModel.userName;
    view1.backReviewCountLab.text=[NSString stringWithFormat:@"回复(%@)",_evaluateModel.backReviewCount];
    view1.tag=200;
    if (self.state==1)
    {
        [view1.backReViewBtn addTarget:self  action:@selector(backReView) forControlEvents:UIControlEventTouchUpInside];
    }
    view1.openBtn.hidden=YES;
    
    NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:view1.contentLab.font,NSFontAttributeName, nil];
    CGSize autoSize=[view1.contentLab.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    if (autoSize.height<40)
    {
        autoSize.height=40;
    }
    view1.contentLab.frame=CGRectMake(90, 25, self.view.frame.size.width-90-30, autoSize.height+10);
    [view1 refreshStarAndUI];
    view1.frame=CGRectMake(0, 64, self.view.frame.size.width, 71+autoSize.height);
    [self.view addSubview:view1];

    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+71+autoSize.height, self.view.frame.size.width, self.view.frame.size.height-(64+71+autoSize.height)) style:UITableViewStylePlain];
    _tabView.dataSource=self;
    _tabView.delegate=self;
    [_tabView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tabView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tabView.headerRefreshingText =@HeaderRefreshingText;
    _tabView.footerRefreshingText=@FooterRefreshingText;
    [self.view addSubview:_tabView];
    
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backReView
{
    JTPingLunGoBackEvaluateViewController * editReViewVC=[[JTPingLunGoBackEvaluateViewController alloc] init];
    editReViewVC.evaluateModel=[[JTSortEvaluateModel alloc] init];
    editReViewVC.evaluateModel=_evaluateModel;
    editReViewVC.state=10000;
    editReViewVC.totalCount=totalCount;
    [self.navigationController pushViewController:editReViewVC animated:YES];
}
-(void)backBackReview:(UIButton *)sender
{

    JTSortBackEvaluateModel * backEvaluateModel=[[JTSortBackEvaluateModel alloc] init];
    backEvaluateModel=[_evaluateModel.backReviewModelArr objectAtIndex:(sender.tag-40000)%1000];
    
    JTPingLunGoBackEvaluateViewController * editReViewVC=[[JTPingLunGoBackEvaluateViewController alloc] init];
    editReViewVC.backEvaluateModel=backEvaluateModel;
    editReViewVC.state=40000;
    [self.navigationController pushViewController:editReViewVC animated:YES];
}
#pragma mark - 表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _evaluateModel.backReviewModelArr.count;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JTSortBackEvaluateModel * backEvaluateModel=[[JTSortBackEvaluateModel alloc] init];
    backEvaluateModel=[_evaluateModel.backReviewModelArr objectAtIndex:indexPath.row];
    
    NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize autoSize=[[NSString stringWithFormat:@"    %@", backEvaluateModel.context] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20-50-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    //    if (autoSize.height<40)
    //    {
    //        autoSize.height=40;
    //    }
    return autoSize.height+81;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTZaojiaoEvaluateTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[JTZaojiaoEvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }

    JTSortBackEvaluateModel * backEvaluateModel=[[JTSortBackEvaluateModel alloc] init];
    backEvaluateModel=[_evaluateModel.backReviewModelArr objectAtIndex:indexPath.row];
    [cell.headImgView setImageWithURL:[NSURL URLWithString:backEvaluateModel.userHeadPortraitURLStr] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    cell.userNameLab.text=backEvaluateModel.userName;
    NSDictionary * dic1=[[NSDictionary alloc] initWithObjectsAndKeys: cell.userNameLab.font,NSFontAttributeName, nil];
    CGSize autoSize1=[cell.userNameLab.text boundingRectWithSize:CGSizeMake(120, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    cell.userNameLab.frame=CGRectMake(50, 10, autoSize1.width, 20);
    
    cell.receiverNameLab.text=backEvaluateModel.receiverName;
    NSDictionary * dic2=[[NSDictionary alloc] initWithObjectsAndKeys: cell.receiverNameLab.font,NSFontAttributeName, nil];
    CGSize autoSize2=[cell.receiverNameLab.text boundingRectWithSize:CGSizeMake(120, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    cell.receiverNameLab.frame=CGRectMake(50+autoSize1.width+30, 10, autoSize2.width, 20);
    
    cell.contentLab.text=[NSString stringWithFormat:@"    %@",backEvaluateModel.context];
    NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize autoSize=[cell.contentLab.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20-50-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    cell.contentLab.frame=CGRectMake(50, 30, self.view.frame.size.width-20-50, autoSize.height+10);
    cell.dateLab.text=backEvaluateModel.backReviewDate;
    if (self.state==1)
    {
        [cell.backReViewBtn addTarget:self action:@selector(backBackReview:) forControlEvents:UIControlEventTouchUpInside];
        cell.backReViewBtn.tag=40000+1000*indexPath.section+indexPath.row;
    }else
    {
        cell.backReViewBtn.hidden=YES;
    }

    [cell refreshUI];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark-发请求
//发请求
-(void)sendPost
{
    pageNum=1;
     //[_sortEvaluateModelArr removeAllObjects];
    _evaluateModel.backReviewModelArr=[[NSMutableArray alloc] initWithCapacity:0];
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
        
        //7.2获取回复列表
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_evaluateModel.idStr,@"reviewId",@"1",@"currentPageNo",@"10",@"pageSize", nil];
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_GetBackReview] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            totalCount=[NSString stringWithFormat:@"%@",[[zaojiaoDic objectForKey:@"reviewPage"] objectForKey:@"totalCount"]];
            if (q==3)
            {
                
                NSArray * evaluateArr=[[NSArray alloc] initWithArray:[[zaojiaoDic objectForKey:@"reviewPage"] objectForKey:@"data"]] ;
                if (evaluateArr.count==0)
                {
                    NSString * str=@"暂无评论！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                
                for (int i=0;i<evaluateArr.count;i++)
                {
                    JTSortBackEvaluateModel * backevaluateModel=[[JTSortBackEvaluateModel alloc] init];
                    backevaluateModel.idStr=[[evaluateArr objectAtIndex:i] objectForKey:@"id"];
                    backevaluateModel.mappingIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"mappingId"];
                    backevaluateModel.infoIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"infoId"];
                    backevaluateModel.userIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"userId"];
                    backevaluateModel.parentIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                    backevaluateModel.recevierIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"receiverId"];
                    backevaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                    backevaluateModel.backReviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                    
                    backevaluateModel.userName=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"userName"];
                    backevaluateModel.userHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"imageValue"];
                    backevaluateModel.receiverName=[[[evaluateArr objectAtIndex:i] objectForKey:@"receiver"] objectForKey:@"userName"];
                    backevaluateModel.receiverHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"receiver"] objectForKey:@"imageValue"];
                    //[_evaluateModel.backReviewModelArr addObject:backevaluateModel];
                    [_evaluateModel.backReviewModelArr insertObject:backevaluateModel atIndex:0];
                }
                q=6;
                
                
            }
            else if (q==6)
            {
                NSArray * evaluateArr=[[NSArray alloc] initWithArray:[[zaojiaoDic objectForKey:@"reviewPage"] objectForKey:@"data"]] ;
                for (int i=0;i<evaluateArr.count;i++)
                {
                    JTSortBackEvaluateModel * backevaluateModel=[[JTSortBackEvaluateModel alloc] init];
                    backevaluateModel.idStr=[[evaluateArr objectAtIndex:i] objectForKey:@"id"];
                    backevaluateModel.mappingIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"mappingId"];
                    backevaluateModel.infoIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"infoId"];
                    backevaluateModel.userIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"userId"];
                    backevaluateModel.parentIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                    backevaluateModel.recevierIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"receiverId"];
                    backevaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                    backevaluateModel.backReviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                    
                    backevaluateModel.userName=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"userName"];
                    backevaluateModel.userHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"imageValue"];
                    backevaluateModel.receiverName=[[[evaluateArr objectAtIndex:i] objectForKey:@"receiver"] objectForKey:@"userName"];
                    backevaluateModel.receiverHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"receiver"] objectForKey:@"imageValue"];
                    
                    
                    BOOL isExist=0;
                    for (int i=0;i<_evaluateModel.backReviewModelArr.count;i++)
                    {
                        JTSortBackEvaluateModel * evaluateModel1=[[JTSortBackEvaluateModel alloc] init];
                        evaluateModel1=[_evaluateModel.backReviewModelArr objectAtIndex:i];
                        
                        if ([[NSString stringWithFormat:@"%@",evaluateModel1.idStr] isEqualToString:[NSString stringWithFormat:@"%@",backevaluateModel.idStr]])
                        {
                            isExist=1;
                            break;
                        }
                        
                    }
                    if (isExist==0)
                    {
                        //[_evaluateModel.backReviewModelArr addObject:backevaluateModel];
                        [_evaluateModel.backReviewModelArr insertObject:backevaluateModel atIndex:0];
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_evaluateModel.idStr,@"reviewId",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"10",@"pageSize", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_GetBackReview] jsonDic:jsondic]];
        
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
                JTSortBackEvaluateModel * backevaluateModel=[[JTSortBackEvaluateModel alloc] init];
                backevaluateModel.idStr=[[evaluateArr objectAtIndex:i] objectForKey:@"id"];
                backevaluateModel.mappingIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"mappingId"];
                backevaluateModel.infoIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"infoId"];
                backevaluateModel.userIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"userId"];
                backevaluateModel.parentIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                backevaluateModel.recevierIDStr=[[evaluateArr objectAtIndex:i] objectForKey:@"receiverId"];
                backevaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                backevaluateModel.backReviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                
                backevaluateModel.userName=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"userName"];
                backevaluateModel.userHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"imageValue"];
                backevaluateModel.receiverName=[[[evaluateArr objectAtIndex:i] objectForKey:@"receiver"] objectForKey:@"userName"];
                backevaluateModel.receiverHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"receiver"] objectForKey:@"imageValue"];
                //[_evaluateModel.backReviewModelArr addObject:backevaluateModel];
                [_evaluateModel.backReviewModelArr insertObject:backevaluateModel atIndex:0+10*(pageNum-1)];
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

@end
