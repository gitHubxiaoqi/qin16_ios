//
//  JTMyCommentDetailViewController.m
//  Qyli
//
//  Created by 小七 on 14-10-6.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTMyCommentDetailViewController.h"
#import "JTMyCommentTableViewCell.h"
#import "JTZaojiaoEvaluateTableViewCell.h"
#import "JTKeChengDetailViewController.h"
#import "JTShangpinDetailViewController.h"
#import "JTPingLunGoEvaluateViewController.h"


@interface JTMyCommentDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tabView;
    NSMutableArray * _sortBackEvaluateModelArr;
    int p;
    
    NSMutableArray * _typeArr;
    NSMutableArray * _typeIdArr;
    NSMutableArray * _scroeArr;
    NSMutableArray * _scroeIdArr;
}

@end

@implementation JTMyCommentDetailViewController

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
    
    _typeArr=[[NSMutableArray alloc] initWithCapacity:0];
    _typeIdArr=[[NSMutableArray alloc] initWithCapacity:0];
    _scroeArr=[[NSMutableArray alloc] initWithCapacity:0];
    _scroeIdArr=[[NSMutableArray alloc] initWithCapacity:0];
    
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
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    p=1;
    _sortBackEvaluateModelArr=[[NSMutableArray alloc] initWithCapacity:0];

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
    navTitailLab.text=@"点评详情";
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
    rightBtn.frame=CGRectMake(self.view.frame.size.width-50, 9, 30, 26);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:rightBtn];

    
    //表视图
    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    _tabView.dataSource=self;
    _tabView.delegate=self;
    _tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabView];
    
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnClick
{
    [self sendPostGetTypeList];
    
    JTPingLunGoEvaluateViewController * gVC=[[JTPingLunGoEvaluateViewController alloc] init];
    gVC.typeListArr=[[NSMutableArray alloc] initWithArray:_typeArr];
    gVC.typeListIDArr=[[NSMutableArray alloc] initWithArray:_typeIdArr];
    gVC.scroeArr=[[NSMutableArray alloc] initWithArray:_scroeArr];
    gVC.scroeIdArr=[[NSMutableArray alloc] initWithArray:_scroeIdArr];
    gVC.idStr=self.sortEvaluateModel.idStr;
    gVC.context=self.sortEvaluateModel.context;
    [self.navigationController pushViewController:gVC animated:YES];
    p=1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sortBackEvaluateModelArr count]+1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {

        JTMyCommentTableViewCell *  cell=[[JTMyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.titleLab.text=self.sortEvaluateModel.title;
        cell.scroe=[self.sortEvaluateModel.scroeAvg intValue];
        cell.dateLab.text=self.sortEvaluateModel.reviewDate;
        cell.contentLab.text=[NSString stringWithFormat:@"      %@",self.sortEvaluateModel.context];
        
        CGSize autoSize=[cell.contentLab.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.contentLab.font} context:nil].size;
        if (autoSize.height<20)
        {
            autoSize.height=20;
        }
        
        cell.contentLab.frame=CGRectMake(5, 55, self.view.frame.size.width-30, autoSize.height+10);
        cell.downJiantouImgView.hidden=YES;
        [cell refreshStarAndUI];
 
        [cell.upBtn addTarget:self action:@selector(upBtn) forControlEvents:UIControlEventTouchUpInside];
         return cell;
    }
    else
    {
        JTZaojiaoEvaluateTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell=[[JTZaojiaoEvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        JTSortBackEvaluateModel * backEvaluateModel=[[JTSortBackEvaluateModel alloc] init];
        backEvaluateModel=[_sortBackEvaluateModelArr objectAtIndex:indexPath.row-1];
       [cell.headImgView setImageWithURL:[NSURL URLWithString:backEvaluateModel.userHeadPortraitURLStr] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        cell.userNameLab.text=backEvaluateModel.userName;
        NSDictionary * dic1=[[NSDictionary alloc] initWithObjectsAndKeys: cell.userNameLab.font,NSFontAttributeName, nil];
        CGSize autoSize1=[cell.userNameLab.text boundingRectWithSize:CGSizeMake(120, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
        cell.userNameLab.frame=CGRectMake(50, 10, autoSize1.width, 20);
        JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
        cell.receiverNameLab.text=appdelegate.appUser.userName;
        NSDictionary * dic2=[[NSDictionary alloc] initWithObjectsAndKeys: cell.receiverNameLab.font,NSFontAttributeName, nil];
        CGSize autoSize2=[cell.receiverNameLab.text boundingRectWithSize:CGSizeMake(120, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
        cell.receiverNameLab.frame=CGRectMake(50+autoSize1.width+30, 10, autoSize2.width, 20);
        
        cell.contentLab.text=[NSString stringWithFormat:@"    %@",backEvaluateModel.context];
        NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
        CGSize autoSize=[cell.contentLab.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        cell.contentLab.frame=CGRectMake(50, 30, self.view.frame.size.width-20-50, autoSize.height+10);
        cell.dateLab.text=backEvaluateModel.backReviewDate;
        cell.backReViewBtn.hidden=YES;
        [cell refreshUI];

        return cell;
    }
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        CGSize autoSize=[[NSString stringWithFormat:@"      %@",self.sortEvaluateModel.context] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (autoSize.height<20)
        {
            autoSize.height=20;
        }
        return 50+autoSize.height+20;
    }
    else
    {
        JTSortEvaluateModel * evaluateModel=[[JTSortEvaluateModel alloc] init];
        evaluateModel=[_sortBackEvaluateModelArr objectAtIndex:indexPath.row-1];
        CGSize autoSize=[[NSString stringWithFormat:@"      %@",evaluateModel.context] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (autoSize.height<20)
        {
            autoSize.height=20;
        }
        return 50+autoSize.height+20;

    }
}
-(void)upBtn
{
    JTSortEvaluateModel * model=[[JTSortEvaluateModel alloc] init];
    model=self.sortEvaluateModel;
    
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
-(void)sendPost
{
    [_sortBackEvaluateModelArr removeAllObjects];

    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_sortEvaluateModel.idStr,@"reviewId",@"1",@"currentPageNo",@"100",@"pageSize", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_GetMemberCenterBackReview] jsonDic:jsondic]];
        

        if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {

            NSMutableArray *middleArr=[[NSMutableArray alloc] initWithArray:[[zaojiaoEvaluateDic objectForKey:@"reviewPage"] objectForKey:@"data"]];
         
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
                [_sortBackEvaluateModelArr addObject:backevaluateModel];
                
            }

            [_tabView reloadData];
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
    }
}
-(void)sendPostGetTypeList
{
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_sortEvaluateModel.idStr,@"reviewId", nil];
        NSDictionary * zaojiaoEvaluateDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Review_GetInfoMemberCenterReviewEdit] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoEvaluateDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            
            NSMutableArray * typeMapArr=[[NSMutableArray alloc] initWithArray:[[zaojiaoEvaluateDic objectForKey:@"review"] objectForKey:@"reviewScorelst"]];
            for (int i=0; i<typeMapArr.count; i++)
            {
                NSString * typename=[[typeMapArr objectAtIndex:i] objectForKey:@"typename"];
                NSString * typeId=[[typeMapArr objectAtIndex:i] objectForKey:@"type"];
                NSString * scroe=[[typeMapArr objectAtIndex:i] objectForKey:@"score"];
                NSString * scroeId=[[typeMapArr objectAtIndex:i] objectForKey:@"id"];
                [_typeArr addObject:typename];
                [_typeIdArr addObject:typeId];
                [_scroeArr addObject:scroe];
                [_scroeIdArr addObject:scroeId];
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
