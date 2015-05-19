//
//  JTPingLunViewController.m
//  Qyli
//
//  Created by 小七 on 14-12-3.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTPingLunViewController.h"

#import "JTZaojiaoEvaluateSectionHeaderView.h"
#import "JTZaojiaoEvaluateTableViewCell.h"
#import "JTPingLunGoEvaluateViewController.h"
#import "JTPingLunGoBackEvaluateViewController.h"
#import "JTPinglunMoreBackReviewViewController.h"

@interface JTPingLunViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    
    NSMutableArray * _resultTypeListArr;
    NSMutableArray * _resultTypeListIDArr;
    NSMutableArray * _sortEvaluateModelArr;
    NSMutableArray * _boolArr;
    
    int pageNum;
    int p;
    int q;
    
    NSMutableArray * _typeArr;
    NSMutableArray * _scroeArr;
    NSString * _totalScroe;
    
    UILabel * _totalLab;

}

@end

@implementation JTPingLunViewController
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
    if (p==1)
    {
        [self getresultTypeList];
        p=2;
    }
    
    [self sendPost];
//    if (_sortEvaluateModelArr.count>0)
//    {
//        [self readyUIAgain];
//    }
//    else
//    {
//        _totalLab.text=@"";
//
//    }
    
    
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
    _totalScroe=@"";
    _typeArr=[[NSMutableArray alloc] initWithCapacity:0];
    _scroeArr=[[NSMutableArray alloc] initWithCapacity:0];
    _resultTypeListArr=[[NSMutableArray alloc] initWithCapacity:0];
    _resultTypeListIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    _sortEvaluateModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    _boolArr=[[NSMutableArray alloc] initWithCapacity:0];
    pageNum=1;
    p=1;
    q=3;
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
    navTitailLab.text=@"评价";
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
    
    UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(self.view.frame.size.width-70-6, 5, 70, 34);
    [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_btn_bg.png"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:rightBtn];
    
    _totalLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 25)];
    _totalLab.font=[UIFont systemFontOfSize:16];
    _totalLab.textColor=[UIColor blackColor];
    _totalLab.text=@"总评分:X";
    [self.view addSubview:_totalLab];
    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}
-(void)readyUIAgain
{
    _totalLab.text=[NSString stringWithFormat:@"总评分:%@",_totalScroe];
    
    for (int i=0; i<_typeArr.count; i++)
    {
        UILabel * lab=(UILabel *)[self.view viewWithTag:100+i];
        if (lab!=nil)
        {
            [lab removeFromSuperview];
        }
        
        UILabel * typeLab=[[UILabel alloc] initWithFrame:CGRectMake(10+i*70, 95,70, 20)];
        typeLab.tag=100+i;
        typeLab.text=[NSString stringWithFormat:@"%@:%@",[_typeArr objectAtIndex:i],[_scroeArr objectAtIndex:i]];
        typeLab.font=[UIFont systemFontOfSize:14];
        typeLab.textColor=[UIColor grayColor];
        [self.view addSubview:typeLab];
    }

}
#pragma mark - 表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int isOpen=[[_boolArr objectAtIndex:section] intValue];
    if (isOpen==0)
    {
        return 0;
    }
    else
    {
        JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
        evaluateModel=[_sortEvaluateModelArr objectAtIndex:section];
        return evaluateModel.backReviewModelArr.count;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sortEvaluateModelArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:section];
    
    JTZaojiaoEvaluateSectionHeaderView * view=[[JTZaojiaoEvaluateSectionHeaderView alloc] init];
    view.bounds=CGRectMake(0, 0, self.view.frame.size.width, 71);
    [view.headImgView setImageWithURL:[NSURL URLWithString:evaluateModel.userHeadPortraitURLStr] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    view.scroe=[evaluateModel.scroeAvg intValue];
    view.dateLab.text=evaluateModel.reviewDate;
    view.contentLab.text=[NSString stringWithFormat:@"    %@",evaluateModel.context];
    view.userNameLab.text=evaluateModel.userName;
    view.backReviewCountLab.text=[NSString stringWithFormat:@"回复(%@)",evaluateModel.backReviewCount];
    [view.backReViewBtn addTarget:self  action:@selector(backReView:) forControlEvents:UIControlEventTouchUpInside];
    view.backReViewBtn.tag=10000+section;
    [view.openBtn addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    view.openBtn.tag=20000+section;
    if ([[_boolArr objectAtIndex:section] intValue]==1)
    {
        view.openBtn.transform=CGAffineTransformMakeScale(1, -1);
    }
    
    NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:view.contentLab.font,NSFontAttributeName, nil];
    CGSize autoSize=[view.contentLab.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90-30-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    if (autoSize.height<40)
    {
        autoSize.height=40;
    }
    view.contentLab.frame=CGRectMake(90, 25, self.view.frame.size.width-90-30, autoSize.height+10);
    [view refreshStarAndUI];
    
    if (evaluateModel.backReviewModelArr.count>=4&&[[_boolArr objectAtIndex:section] intValue]==1)
    {
        view.backReviewCountLab.text=[NSString stringWithFormat:@"回复(%@+)",evaluateModel.backReviewCount];
        
        CGRect rect=view.frame;
        rect.size.height+=20;
        view.frame=rect;
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0,view.frame.size.height+20, view.frame.size.width, 20);
        btn.tag=30000+section;
        [btn addTarget:self action:@selector(moreReView:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"查看更早回复" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [view addSubview:btn];

    }
    return view;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:section];
    
    NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize autoSize=[[NSString stringWithFormat:@"    %@",evaluateModel.context] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90-30-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    if (autoSize.height<40)
    {
        autoSize.height=40;
    }
    if (evaluateModel.backReviewModelArr.count>=4)
    {
        return autoSize.height+71+20;
    }
    else
    {
    return autoSize.height+71;
    }
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:indexPath.section];
    JTSortBackEvaluateModel * backEvaluateModel=[[JTSortBackEvaluateModel alloc] init];
    backEvaluateModel=[evaluateModel.backReviewModelArr objectAtIndex:indexPath.row];
    
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
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:indexPath.section];
    JTSortBackEvaluateModel * backEvaluateModel=[[JTSortBackEvaluateModel alloc] init];
    backEvaluateModel=[evaluateModel.backReviewModelArr objectAtIndex:indexPath.row];
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
    [cell.backReViewBtn addTarget:self action:@selector(backBackReview:) forControlEvents:UIControlEventTouchUpInside];
    cell.backReViewBtn.tag=40000+1000*indexPath.section+indexPath.row;
    [cell refreshUI];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark-点按钮

-(void)open:(UIButton *)sender
{
    int isOpen=[[_boolArr objectAtIndex:sender.tag-20000] intValue];
    if (isOpen==0)
    {
        [_boolArr replaceObjectAtIndex:sender.tag-20000 withObject:@"1"];
    }
    else
    {
        [_boolArr replaceObjectAtIndex:sender.tag-20000 withObject:@"0"];
    }
    [_tableView reloadData];
}
-(void)moreReView:(UIButton *)sender
{
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:sender.tag-30000];
    JTPinglunMoreBackReviewViewController * moreVC=[[JTPinglunMoreBackReviewViewController alloc] init];
    moreVC.evaluateModel=[[JTSortEvaluateModel alloc] init];
    moreVC.evaluateModel=evaluateModel;
    moreVC.state=1;
    [self.navigationController pushViewController:moreVC animated:YES];

}
-(void)backReView:(UIButton *)sender
{
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:sender.tag-10000];
    JTPingLunGoBackEvaluateViewController * editReViewVC=[[JTPingLunGoBackEvaluateViewController alloc] init];
    editReViewVC.evaluateModel=evaluateModel;
    editReViewVC.state=10000;
    editReViewVC.totalCount=@"4+";
    [self.navigationController pushViewController:editReViewVC animated:YES];
    
}
-(void)backBackReview:(UIButton *)sender
{
    JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
    evaluateModel=[_sortEvaluateModelArr objectAtIndex:(sender.tag-40000)/1000];
    JTSortBackEvaluateModel * backEvaluateModel=[[JTSortBackEvaluateModel alloc] init];
    backEvaluateModel=[evaluateModel.backReviewModelArr objectAtIndex:(sender.tag-40000)%1000];
    
    JTPingLunGoBackEvaluateViewController * editReViewVC=[[JTPingLunGoBackEvaluateViewController alloc] init];
    editReViewVC.backEvaluateModel=backEvaluateModel;
    editReViewVC.state=40000;
    [self.navigationController pushViewController:editReViewVC animated:YES];
}
#pragma mark-发请求
-(void)getresultTypeList
{
    //7.4根据mappingId获取打分评论类型列表
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.mappingIdStr,@"mappingId", nil];
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_GetReviewTypeMappingId] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            NSArray * typeArr=[[NSArray alloc] initWithArray:[zaojiaoDic objectForKey:@"typeList"]];
            for (int i=0; i<typeArr.count; i++)
            {
                NSString * idStr=[[typeArr objectAtIndex:i] objectForKey:@"id"];
                NSString * nameStr=[[typeArr objectAtIndex:i] objectForKey:@"itemValue"];
                [_resultTypeListArr addObject:nameStr];
                [_resultTypeListIDArr addObject:idStr];
            }
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
    }
}
//发请求
-(void)sendPost
{
    pageNum=1;
    [_typeArr removeAllObjects];
    [_scroeArr removeAllObjects];
    [_sortEvaluateModelArr removeAllObjects];
    [_boolArr removeAllObjects];
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
        
        //7.1获取评论列表和总评分
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.infoIdStr,@"infoId",self.mappingIdStr,@"mappingId",@"1",@"currentPageNo",@"10",@"pageSize", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_GetReviewListAndReviewSubAvg] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            if (q==3)
            {
                q=6;
                
                NSArray * arr=[[NSArray alloc] initWithArray:[zaojiaoEvaluateDic objectForKey:@"typeDTOList"]];
                for (int i=0; i<arr.count; i++)
                {
                    NSString *typeStr=[[[arr objectAtIndex:i] objectForKey:@"type"] objectForKey:@"itemValue"];
                    NSString * scroeStr=[[arr objectAtIndex:i] objectForKey:@"scoreAvg"];
                    [_typeArr addObject:typeStr];
                    [_scroeArr addObject:scroeStr];
                }
                _totalScroe=[zaojiaoEvaluateDic objectForKey:@"sumScoreAvg"];
                [self readyUIAgain];
                
                NSArray * evaluateArr=[[NSArray alloc] initWithArray:[[zaojiaoEvaluateDic objectForKey:@"reviewPage"] objectForKey:@"data"]] ;
                if (evaluateArr.count==0)
                {
                    NSString * str=@"暂无评论！";
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
                    evaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                    evaluateModel.parentIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                    
                    evaluateModel.reviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                    evaluateModel.userName=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"userName"];
                    evaluateModel.userHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"imageValue"];
                    evaluateModel.scroeAvg=[[evaluateArr objectAtIndex:i] objectForKey:@"scoreAvg"];
                    NSMutableArray * middleArr=[[NSMutableArray alloc] initWithArray:[[evaluateArr objectAtIndex:i] objectForKey:@"backReview"]];
                    
                    evaluateModel.backReviewCount=[NSString stringWithFormat:@"%d",middleArr.count];
                    
                    evaluateModel.backReviewModelArr=[[NSMutableArray alloc] initWithCapacity:0];
                    for (int j=0; j<middleArr.count; j++)
                    {
                        JTSortBackEvaluateModel * backevaluateModel=[[JTSortBackEvaluateModel alloc] init];
                        backevaluateModel.idStr=[[middleArr objectAtIndex:j] objectForKey:@"id"];
                        backevaluateModel.mappingIDStr=[[middleArr objectAtIndex:j] objectForKey:@"mappingId"];
                        backevaluateModel.infoIDStr=[[middleArr objectAtIndex:j] objectForKey:@"infoId"];
                        backevaluateModel.userIdStr=[[middleArr objectAtIndex:j] objectForKey:@"userId"];
                        backevaluateModel.parentIDStr=[[middleArr objectAtIndex:j] objectForKey:@"parentId"];
                        backevaluateModel.recevierIDStr=[[middleArr objectAtIndex:j] objectForKey:@"receiverId"];
                        backevaluateModel.context=[[middleArr objectAtIndex:j] objectForKey:@"context"];
                        
                        backevaluateModel.backReviewDate=[[middleArr objectAtIndex:j] objectForKey:@"reviewDateValue"];
                        backevaluateModel.userName=[[[middleArr objectAtIndex:j] objectForKey:@"user"] objectForKey:@"userName"];
                        backevaluateModel.userHeadPortraitURLStr=[[[middleArr objectAtIndex:j] objectForKey:@"user"] objectForKey:@"imageValue"];
                        backevaluateModel.receiverName=[[[middleArr objectAtIndex:j] objectForKey:@"receiver"] objectForKey:@"userName"];
                        backevaluateModel.receiverHeadPortraitURLStr=[[[middleArr objectAtIndex:j] objectForKey:@"receiver"] objectForKey:@"imageValue"];
                        //[evaluateModel.backReviewModelArr addObject:backevaluateModel];
                        [evaluateModel.backReviewModelArr insertObject:backevaluateModel atIndex:0];
                    }
                    //[_sortEvaluateModelArr addObject:evaluateModel];
                    [_sortEvaluateModelArr insertObject:evaluateModel atIndex:0];
                    [_boolArr addObject:@"1"];
                }
            
                
                
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
                    evaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                    
                    evaluateModel.parentIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                    
                    evaluateModel.reviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                    evaluateModel.userName=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"userName"];
                    evaluateModel.userHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"imageValue"];
                    evaluateModel.scroeAvg=[[evaluateArr objectAtIndex:i] objectForKey:@"scoreAvg"];
                    NSMutableArray * middleArr=[[NSMutableArray alloc] initWithArray:[[evaluateArr objectAtIndex:i] objectForKey:@"backReview"]];
                    
                    evaluateModel.backReviewCount=[NSString stringWithFormat:@"%d",middleArr.count];
                    
                    evaluateModel.backReviewModelArr=[[NSMutableArray alloc] initWithCapacity:0];
                    for (int j=0; j<middleArr.count; j++)
                    {
                        JTSortBackEvaluateModel * backevaluateModel=[[JTSortBackEvaluateModel alloc] init];
                        backevaluateModel.idStr=[[middleArr objectAtIndex:j] objectForKey:@"id"];
                        backevaluateModel.mappingIDStr=[[middleArr objectAtIndex:j] objectForKey:@"mappingId"];
                        backevaluateModel.infoIDStr=[[middleArr objectAtIndex:j] objectForKey:@"infoId"];
                        backevaluateModel.userIdStr=[[middleArr objectAtIndex:j] objectForKey:@"userId"];
                        backevaluateModel.parentIDStr=[[middleArr objectAtIndex:j] objectForKey:@"parentId"];
                        backevaluateModel.recevierIDStr=[[middleArr objectAtIndex:j] objectForKey:@"receiverId"];
                        backevaluateModel.context=[[middleArr objectAtIndex:j] objectForKey:@"context"];
                        
                        backevaluateModel.backReviewDate=[[middleArr objectAtIndex:j] objectForKey:@"reviewDateValue"];
                        backevaluateModel.userName=[[[middleArr objectAtIndex:j] objectForKey:@"user"] objectForKey:@"userName"];
                        backevaluateModel.userHeadPortraitURLStr=[[[middleArr objectAtIndex:j] objectForKey:@"user"] objectForKey:@"imageValue"];
                        backevaluateModel.receiverName=[[[middleArr objectAtIndex:j] objectForKey:@"receiver"] objectForKey:@"userName"];
                        backevaluateModel.receiverHeadPortraitURLStr=[[[middleArr objectAtIndex:j] objectForKey:@"receiver"] objectForKey:@"imageValue"];
                        //[evaluateModel.backReviewModelArr addObject:backevaluateModel];
                        [evaluateModel.backReviewModelArr insertObject:backevaluateModel atIndex:0];
                    }
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
                        //[_sortEvaluateModelArr addObject:evaluateModel];
                        [_sortEvaluateModelArr insertObject:evaluateModel atIndex:0];
                        [_boolArr addObject:@"1"];
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.infoIdStr,@"infoId",self.mappingIdStr,@"mappingId",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"10",@"pageSize", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_GetReviewListAndReviewSubAvg] jsonDic:jsondic]];
        
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
                evaluateModel.context=[[evaluateArr objectAtIndex:i] objectForKey:@"context"];
                evaluateModel.parentIdStr=[[evaluateArr objectAtIndex:i] objectForKey:@"parentId"];
                
                evaluateModel.reviewDate=[[evaluateArr objectAtIndex:i] objectForKey:@"reviewDateValue"];
                evaluateModel.userName=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"userName"];
                evaluateModel.userHeadPortraitURLStr=[[[evaluateArr objectAtIndex:i] objectForKey:@"user"] objectForKey:@"imageValue"];
                evaluateModel.scroeAvg=[[evaluateArr objectAtIndex:i] objectForKey:@"scoreAvg"];
                NSMutableArray * middleArr=[[NSMutableArray alloc] initWithArray:[[evaluateArr objectAtIndex:i] objectForKey:@"backReview"]];
                
                evaluateModel.backReviewCount=[NSString stringWithFormat:@"%d",middleArr.count];
                
                evaluateModel.backReviewModelArr=[[NSMutableArray alloc] initWithCapacity:0];
                for (int j=0; j<middleArr.count; j++)
                {
                    JTSortBackEvaluateModel * backevaluateModel=[[JTSortBackEvaluateModel alloc] init];
                    backevaluateModel.idStr=[[middleArr objectAtIndex:j] objectForKey:@"id"];
                    backevaluateModel.mappingIDStr=[[middleArr objectAtIndex:j] objectForKey:@"mappingId"];
                    backevaluateModel.infoIDStr=[[middleArr objectAtIndex:j] objectForKey:@"infoId"];
                    backevaluateModel.userIdStr=[[middleArr objectAtIndex:j] objectForKey:@"userId"];
                    backevaluateModel.parentIDStr=[[middleArr objectAtIndex:j] objectForKey:@"parentId"];
                    backevaluateModel.recevierIDStr=[[middleArr objectAtIndex:j] objectForKey:@"receiverId"];
                    backevaluateModel.context=[[middleArr objectAtIndex:j] objectForKey:@"context"];
                    
                    backevaluateModel.backReviewDate=[[middleArr objectAtIndex:j] objectForKey:@"reviewDateValue"];
                    backevaluateModel.userName=[[[middleArr objectAtIndex:j] objectForKey:@"user"] objectForKey:@"userName"];
                    backevaluateModel.userHeadPortraitURLStr=[[[middleArr objectAtIndex:j] objectForKey:@"user"] objectForKey:@"imageValue"];
                    backevaluateModel.receiverName=[[[middleArr objectAtIndex:j] objectForKey:@"receiver"] objectForKey:@"userName"];
                    backevaluateModel.receiverHeadPortraitURLStr=[[[middleArr objectAtIndex:j] objectForKey:@"receiver"] objectForKey:@"imageValue"];
                    //[evaluateModel.backReviewModelArr addObject:backevaluateModel];
                    [evaluateModel.backReviewModelArr insertObject:backevaluateModel atIndex:0];
                }
                //[_sortEvaluateModelArr addObject:evaluateModel];
                [_sortEvaluateModelArr insertObject:evaluateModel atIndex:0];
                [_boolArr addObject:@"1"];
            }

        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"0"])
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录，请先登录。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
        [alertView show];
        JTLoginViewController * loginVC=[[JTLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }

    if (_resultTypeListArr.count==0)
    {
        NSString * str=@"数据初始化失败，请稍后重试...";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    NSString * userIDStr=[NSString stringWithFormat:@"%d",appdelegate.appUser.userID];
    
    if ([SOAPRequest checkNet])
    {
        
        //7.3验证用户是否参与评分
        
           NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.mappingIdStr,@"mappingId",self.infoIdStr,@"infoId",userIDStr,@"userId", nil];
           NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_ValidUserReview] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            JTPingLunGoEvaluateViewController * goEvaluateVC=[[JTPingLunGoEvaluateViewController alloc] init];
            goEvaluateVC.typeListArr=[[NSArray alloc] initWithArray:_resultTypeListArr];
            goEvaluateVC.typeListIDArr=[[NSArray alloc] initWithArray:_resultTypeListIDArr];
            goEvaluateVC.mappingID=self.mappingIdStr;
            goEvaluateVC.infoID=self.infoIdStr;
            [self presentViewController:goEvaluateVC animated:YES completion:nil];
        }
        else
        {
            
            if ([zaojiaoEvaluateDic objectForKey:@"errorMessage"]!=nil)
            {
                NSString * str=[zaojiaoEvaluateDic objectForKey:@"errorMessage"];
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            else if([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"2008"])
            {
                NSString * str=@"该用户已经参与过评分!";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            else
            {
                NSString * str=@"服务器异常，请稍后重试...";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
