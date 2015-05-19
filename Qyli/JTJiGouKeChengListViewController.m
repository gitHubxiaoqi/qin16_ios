//
//  JTJiGouKeChengListViewController.m
//  Qyli
//
//  Created by 小七 on 14-12-5.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTJiGouKeChengListViewController.h"
#import "JTKeChengDetailViewController.h"

@interface JTJiGouKeChengListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int p;
    int q;
    
    UITableView * _tableView;
    int pageNum;
    
    NSMutableArray * _listModelArr;
}

@end
@implementation JTJiGouKeChengListViewController

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
    navTitailLab.text=@"机构课程";
    navTitailLab.font=[UIFont systemFontOfSize:16];
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    [navBarView addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
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
    _tableView.tag=100;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}
-(void)leftBtnCilck
{
    [self.navigationController  popViewControllerAnimated:YES];
}

#pragma mark - 表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listModelArr count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UILabel * nameLab=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-120, 20)];
        nameLab.font=[UIFont systemFontOfSize:15];
        nameLab.tag=10;
        [cell addSubview:nameLab];
        
        UILabel * costLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-120+10, 5,60, 15)];
        costLab.font=[UIFont systemFontOfSize:14];
        costLab.tag=20;
        [cell addSubview:costLab];
        
        UILabel * typeLab=[[UILabel alloc] initWithFrame:CGRectMake(5, 25, 70, 20)];
        typeLab.font=[UIFont systemFontOfSize:14];
        typeLab.textColor=[UIColor grayColor];
        typeLab.tag=30;
        [cell addSubview:typeLab];
        
        UILabel * typeValueLab=[[UILabel alloc] initWithFrame:CGRectMake(75, 25, self.view.frame.size.width-80-60, 20)];
        typeValueLab.font=[UIFont systemFontOfSize:13];
        typeValueLab.textColor=[UIColor blackColor];
        typeValueLab.tag=40;
        [cell addSubview:typeValueLab];
        
        UILabel * fenLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-10-20, 25, 10, 10)];
        fenLab.textColor=[UIColor grayColor];
        fenLab.font=[UIFont systemFontOfSize:12];
        fenLab.tag=1000;
        [cell addSubview:fenLab];
        
        UILabel * scroLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 15, 60, 20)];
        scroLab.tag=50;
        [cell addSubview:scroLab];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.view.frame.size.width, 0.5)];
        lineLab.backgroundColor=[UIColor brownColor];
        [cell addSubview:lineLab];
    }
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    
    UILabel *nameLab=(UILabel *)[cell viewWithTag:10];
    nameLab.text=model.title;
    
    CGSize autoSize=[model.title boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameLab.font} context:nil].size;
    if (autoSize.width>self.view.frame.size.width-120-5)
    {
        autoSize.width=self.view.frame.size.width-120-5;
    }
    
    UILabel *costLab=(UILabel *)[cell viewWithTag:20];
    if ([[NSString stringWithFormat:@"%@",model.cost] intValue]==0||model.cost==nil)
    {
        costLab.textColor=[UIColor grayColor];
        costLab.text=@"暂无标价";
    }
    else
    {
        costLab.textColor=[UIColor redColor];
        costLab.text=[NSString stringWithFormat:@"￥%.1f元",[model.cost floatValue]];
    }
    costLab.frame=CGRectMake(autoSize.width+20, 5, self.view.frame.size.width-50-autoSize.width-20, 15);
    
    UILabel *typeLab=(UILabel *)[cell viewWithTag:30];
    typeLab.text=@"课程类型:";
    
    UILabel *typeValueLab=(UILabel *)[cell viewWithTag:40];
    if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@""]||model.type==nil)
    {
        typeValueLab.textColor=[UIColor grayColor];
        typeValueLab.text=@"暂无分类";
    }
    else
    {
        typeValueLab.textColor=[UIColor blackColor];
        typeValueLab.text=model.type;
    }
    
    UILabel * fenLab=(UILabel *)[cell viewWithTag:1000];
    fenLab.text=@"分";
    UILabel *scroeLab=(UILabel *)[cell viewWithTag:50];
    if ([[NSString stringWithFormat:@"%@",model.score] intValue]==0||model.score==nil)
    {
        scroeLab.textColor=[UIColor orangeColor];
        scroeLab.text=@"暂无评价";
        scroeLab.font=[UIFont systemFontOfSize:14];
        fenLab.hidden=YES;
    }
    else
    {
        scroeLab.textColor=[UIColor redColor];
        scroeLab.font=[UIFont systemFontOfSize:18];
        scroeLab.text=[NSString stringWithFormat:@"%.1f",[model.score floatValue]];
        fenLab.hidden=NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    JTKeChengDetailViewController * zjdVC=[[JTKeChengDetailViewController alloc] init];
    zjdVC.sortmodel=[[JTSortModel alloc] init];
    zjdVC.sortmodel=model;
    zjdVC.state=999;
    [self.navigationController pushViewController:zjdVC animated:YES];

 }
#pragma mark- 发请求
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
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.institutionIdStr,@"institutionId",@"IDDESC",@"sortType",@"1",@"page", nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KeCheng_coursePageByInstitution] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"coursePage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    
                    UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"抱歉" message:@"暂无相关课程" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"coursePage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                    sortModel.score=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"score"];
                    sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                    NSArray * typearr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                    NSMutableString *typeStr=[[NSMutableString alloc] init];
                    [typeStr setString:@""];
                    for (int i=0; i<typearr.count; i++)
                    {
                        NSString *str=[typearr objectAtIndex:i];
                        [typeStr appendString:str];
                        [typeStr appendString:@","];
                    }
                    [typeStr deleteCharactersInRange:NSMakeRange([typeStr length]-1, 1)];
                    sortModel.type=typeStr;
                    [_listModelArr addObject:sortModel];
    
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"coursePage"] objectForKey:@"list"];
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
                        sortModel.score=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"score"];
                        sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                        NSArray * typearr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                        NSMutableString *typeStr=[[NSMutableString alloc] init];
                        [typeStr setString:@""];
                        for (int i=0; i<typearr.count; i++)
                        {
                            NSString *str=[typearr objectAtIndex:i];
                            [typeStr appendString:str];
                            [typeStr appendString:@","];
                        }
                        [typeStr deleteCharactersInRange:NSMakeRange([typeStr length]-1, 1)];
                        sortModel.type=typeStr;
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
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.institutionIdStr,@"institutionId",@"IDDESC",@"sortType",[NSString stringWithFormat:@"%d",pageNum],@"page", nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KeCheng_coursePageByInstitution] jsonDic:jsondic]];
        
        if ([[zaojiaoListDic objectForKey:@"resultCode"] intValue]==1000)
        {
            if ([[[zaojiaoListDic objectForKey:@"coursePage"] objectForKey:@"list"] count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"coursePage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                sortModel.score=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"score"];
                sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                NSArray * typearr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                NSMutableString *typeStr=[[NSMutableString alloc] init];
                [typeStr setString:@""];
                for (int i=0; i<typearr.count; i++)
                {
                    NSString *str=[typearr objectAtIndex:i];
                    [typeStr appendString:str];
                    [typeStr appendString:@","];
                }
                [typeStr deleteCharactersInRange:NSMakeRange([typeStr length]-1, 1)];
                sortModel.type=typeStr;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
