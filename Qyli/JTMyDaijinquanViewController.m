//
//  JTMyDaijinquanViewController.m
//  清一丽
//
//  Created by 小七 on 15-1-5.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTMyDaijinquanViewController.h"
#import "JTMyDaijinquanTabviewCell.h"
#import "JTHuodongquanTableViewCell.h"
#import "JTDianpuHuodongDetailViewController.h"
#import "JTZeBarViewController.h"
@interface JTMyDaijinquanViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _listModelArr;
    UIButton * _selectedBtn1;
    UIButton * _selectedBtn2;
    BOOL  isFinish;
    int p;
}
@end

@implementation JTMyDaijinquanViewController
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
    isFinish=0;
    p=1;
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
    navTitailLab.text=[NSString stringWithFormat:@"我的卡券"];
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
    
    _selectedBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn1.frame=CGRectMake(self.view.frame.size.width/2.0-80, 64+15, 80, 25);
    [_selectedBtn1 setImage:[UIImage imageNamed:@"当前1.png"] forState:UIControlStateSelected];
    [_selectedBtn1 setImage:[UIImage imageNamed:@"当前2.png"] forState:UIControlStateNormal];
    [_selectedBtn1 addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    _selectedBtn1.selected=YES;
    [self.view addSubview:_selectedBtn1];
    
    
    _selectedBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn2.frame=CGRectMake(self.view.frame.size.width/2.0, 64+15, 80, 25);
    [_selectedBtn2 setImage:[UIImage imageNamed:@"历史2.png"] forState:UIControlStateSelected];
    [_selectedBtn2 setImage:[UIImage imageNamed:@"历史1.png"] forState:UIControlStateNormal];
    [_selectedBtn2 addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    _selectedBtn2.selected=NO;
    [self.view addSubview:_selectedBtn2];
    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+15+25+10, self.view.frame.size.width, self.view.frame.size.height-114) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
-(void)qiehuan:(UIButton *)sender
{

    if (sender==_selectedBtn1)
    {
        _selectedBtn1.selected=YES;
        _selectedBtn2.selected=NO;
        isFinish=0;
        [self sendPost];
    }
    else if (sender==_selectedBtn2)
    {
        _selectedBtn1.selected=NO;
        _selectedBtn2.selected=YES;
        isFinish=1;
        [self sendPost];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listModelArr.count;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    if ([[NSString stringWithFormat:@"%@",model.typeID] isEqualToString:@"1"])
    {
         return 110;
    }
    else
    {
        return 90;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    if ([[NSString stringWithFormat:@"%@",model.typeID] isEqualToString:@"1"])
    {
        JTMyDaijinquanTabviewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell=[[JTMyDaijinquanTabviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=BG_COLOR;
        }

        cell.begainDateLab.text=[NSString stringWithFormat:@"%@",model.beginDate];
        cell.endDateLab.text=[NSString stringWithFormat:@"%@",model.endDate];
        if ([model.imgUrlStr isEqualToString:@""]||model.imgUrlStr==nil)
        {
            cell.imgView.image=[UIImage imageNamed:@"代金券.png"];
        }
        else
        {
            [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"代金券.png"]];
        }
        if (isFinish==0)
        {
            cell.finishLab.hidden=YES;
        }
        else if(isFinish==1)
        {
            cell.finishLab.hidden=NO;
            [cell.bgImgView bringSubviewToFront:cell.finishLab];
            if ([model.description1 isEqualToString:@"Used"])
            {
                cell.UsedOrOvertime=1;
            }
            else if ([model.description1 isEqualToString:@"OverTime"])
            {
                cell.UsedOrOvertime=2;
            }
            
        }
        [cell refreshUI];
        return cell;

    }
    else
    {
        JTHuodongquanTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell)
        {
            cell=[[JTHuodongquanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        }
        JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
        cell.titleLab.text=model.title;
        cell.numLab.text=[NSString stringWithFormat:@"入场券编号:%@",model.name];
        cell.dateLab.text=[NSString stringWithFormat:@"活动时间:%@至%@",model.beginDate,model.endDate];
        [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        
        if (isFinish==0)
        {
            cell.finishLab.hidden=YES;
            cell.zeBarBtn.hidden=NO;
            cell.zeBarBtn.tag=indexPath.row+100;
            [cell.zeBarBtn addTarget:self action:@selector(zeBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(isFinish==1)
        {
            cell.finishLab.hidden=NO;
            cell.zeBarBtn.hidden=YES;
            [cell.bgImgView bringSubviewToFront:cell.finishLab];
            if ([model.description1 isEqualToString:@"Used"])
            {
                cell.UsedOrOvertime=1;
            }
            else if ([model.description1 isEqualToString:@"OverTime"])
            {
                cell.UsedOrOvertime=2;
            }
            
        }
        [cell refreshUI];

      return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
    if ([[NSString stringWithFormat:@"%@",model.typeID] isEqualToString:@"2"])
    {
        JTSortModel * model=[[JTSortModel alloc] init];
        model=[_listModelArr objectAtIndex:indexPath.row];
        JTDianpuHuodongDetailViewController * zjdVC=[[JTDianpuHuodongDetailViewController alloc] init];
        zjdVC.sortmodel=[[JTSortModel alloc] init];
        zjdVC.sortmodel.idStr=model.fuId;
        zjdVC.state=1;
        [self.navigationController pushViewController:zjdVC animated:YES];
    }
}
-(void)zeBarBtnClick:(UIButton *)sender
{
    JTSortModel * model=[[JTSortModel alloc] init];
    model=[_listModelArr objectAtIndex:sender.tag-100];
    JTZeBarViewController * zeBarVC=[[JTZeBarViewController alloc] init];
    zeBarVC.idStr=model.name;
    [self presentViewController:zeBarVC animated:YES completion:nil];

}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendPost
{
    [_listModelArr removeAllObjects];

    NSMutableArray * statueArr=[[NSMutableArray alloc] initWithCapacity:0];
    if (isFinish==0)
    {
        [statueArr addObject:@"New"];
    }
    else if(isFinish==1)
    {
        [statueArr addObject:@"Used"];
        [statueArr addObject:@"OverTime"];
        [statueArr addObject:@"Settled"];
    }
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",statueArr,@"status", nil];
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_MyVoucher] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            

                if ([[zaojiaoDic objectForKey:@"voucherList"]count]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    [_tableView reloadData];
                    return;
                }
                NSArray * zaojiaoListArr=[zaojiaoDic objectForKey:@"voucherList"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                    sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startDate"];
                    sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endDate"];
                    if([[[zaojiaoListArr objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"Used"]||[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"Settled"])
                    {
                        sortModel.description1=@"Used";
                    }
                    else if ([[[zaojiaoListArr objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"OverTime"])
                    {
                        sortModel.description1=@"OverTime";
                    }
                    else if ([[[zaojiaoListArr objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"New"])
                    {
                        sortModel.description1=@"";
                    }
                    sortModel.fuId=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"belongId"];
                    sortModel.typeID=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                    
                    [_listModelArr addObject:sortModel];
                       [_tableView reloadData];
                   }
            
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
    }
}


@end
