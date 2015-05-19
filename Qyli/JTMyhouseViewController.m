//
//  JTMyhouseViewController.m
//  Qyli
//
//  Created by 小七 on 14-8-5.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTMyhouseViewController.h"
#import "JTCollectionTableViewCell.h"

#import "JTJiGouDetailViewController.h"
#import "JTSijiaoDetailViewController.h"
#import "JTDianpuDetailViewController.h"

@interface JTMyhouseViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * _tabView;
    UITextField * textField;

    UITableView * _smallTabView;
    NSArray * _smallTitleArr;
    NSArray * _smallImgNameArr;
    UIView * _searchView;
    UIView * _bottomView;
    
    BOOL isChoose[10000];
    BOOL isAllSelect;
    
    int pageNum;
    NSMutableArray * _listModelArr;
    int q;
    int p;
    
    NSString * _searchWord;
    
    NSMutableArray * _deleteIDArr;
    
}

@end

@implementation JTMyhouseViewController

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
    pageNum=1;
    p=1;
    q=3;
    isAllSelect=0;
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    _deleteIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    _searchWord=@"";
    //_rankID=@"0";
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
    navTitailLab.text=@"我的关注";
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
    rightBtn.frame=CGRectMake(self.view.frame.size.width-40-10, 0, 40, 44);
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:rightBtn];
    
    UIImageView * moreImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more.png"]];
    moreImgView.frame=CGRectMake(self.view.frame.size.width-30, 10, 3, 24);
    [navLab addSubview:moreImgView];
    
    //表视图
    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tabView.dataSource=self;
    _tabView.delegate=self;
    [_tabView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tabView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tabView.headerRefreshingText =@HeaderRefreshingText;
    _tabView.footerRefreshingText=@FooterRefreshingText;
    _tabView.tag=10;
    [self.view addSubview:_tabView];
    //更多
    _smallTabView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0, 70, 0, 0) style:UITableViewStylePlain];
    _smallTabView.layer.anchorPoint=CGPointMake(0, 0);
    _smallTabView.backgroundColor=[UIColor blackColor];
    _smallTabView.dataSource=self;
    _smallTabView.delegate=self;
    _smallTabView.tag=20;
    _smallTabView.rowHeight=40;
    _smallTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_smallTabView];
    _smallTitleArr=[[NSArray alloc] initWithObjects:@"编辑",@"搜索", nil];
    _smallImgNameArr=[[NSArray alloc] initWithObjects:@"pop_edit.png",@"pop_search.png", nil];
    
    //搜索
    _searchView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,35)];
    _searchView.hidden=YES;
    _searchView.backgroundColor=[UIColor colorWithRed:226.0/255.0 green:120.0/255.0 blue:135.0/255.0 alpha:1];
    [self.view addSubview:_searchView];
    UIImageView * searchBgimg=[[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"search_bg.png"]];
    searchBgimg.frame=CGRectMake(10, 4, self.view.frame.size.width-20-70-10, 27);
    searchBgimg.userInteractionEnabled=YES;
    [_searchView addSubview:searchBgimg];
    UIImageView * searchImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    searchImgView.frame=CGRectMake(8, 4, 20, 20);
    [searchBgimg addSubview:searchImgView];
    
   textField=[[UITextField alloc] initWithFrame:CGRectMake(35,0, self.view.frame.size.width-20-70-10-35-5, 27)];
    textField.placeholder=@"请输入关键字进行搜索";
    [searchBgimg addSubview:textField];
    
    UIButton * searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(self.view.frame.size.width-20-70, 5, 70, 25);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [_searchView addSubview:searchBtn];
    
    _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    _bottomView.backgroundColor=[UIColor whiteColor];
    _bottomView.hidden=YES;
    [self.view addSubview:_bottomView];
    
    UIButton * allSelectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [allSelectBtn setImage:[UIImage imageNamed:@"un_select_iv.png"] forState:UIControlStateNormal];
    allSelectBtn.tag=10000;
    [allSelectBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    allSelectBtn.frame=CGRectMake(10, 10, 20, 20);
    [_bottomView addSubview:allSelectBtn];
    
    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(40, 12, 60, 16)];
    lab.text=@"全部选择";
    lab.font=[UIFont systemFontOfSize:14];
    [_bottomView addSubview:lab];
    
    UIButton * deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_bg.png"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [deleteBtn addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.frame=CGRectMake(110, 5, 80, 30);
    [_bottomView addSubview:deleteBtn];
    
    UIButton * finishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"delete_bg.png"] forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.frame=CGRectMake(self.view.frame.size.width-20-80, 5, 80, 30);
    [_bottomView addSubview:finishBtn];
}
-(void)allSelect:(UIButton *)sender
{
    if (isAllSelect==0)
    {
        for (int i=0; i<_listModelArr.count; i++)
        {
            isChoose[i]=1;
            UIButton * btn=(UIButton *)[self.view viewWithTag:21+i];
            [btn setImage:[UIImage imageNamed:@"select_iv.png"] forState:UIControlStateNormal];
        }
        [sender setImage:[UIImage imageNamed:@"select_iv.png"] forState:UIControlStateNormal];
        isAllSelect=1;
    }
    else
    {
        for (int i=0; i<_listModelArr.count; i++)
        {
            isChoose[i]=0;
            UIButton * btn=(UIButton *)[self.view viewWithTag:21+i];
            [btn setImage:[UIImage imageNamed:@"un_select_iv.png"] forState:UIControlStateNormal];
        }
        [sender setImage:[UIImage imageNamed:@"un_select_iv.png"] forState:UIControlStateNormal];
        isAllSelect=0;
    }
    
}
-(void)deleteBtn
{
    BOOL isHave=0;
    for (int i=0; i<_listModelArr.count; i++)
    {
        if (isChoose[i]==1)
        {
            isHave=1;
            break;
        }
        
    }
    if (isHave==0)
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择要删除的信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
        [alertView show];
    }
    else
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，确定要删除选中信息吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if (isAllSelect==0)
        {
            for (int i=0; i<_listModelArr.count; i++)
            {
                JTSortModel * sortModel=[_listModelArr objectAtIndex:i];
                if (isChoose[i]==1)
                {
                    [_deleteIDArr addObject:sortModel.collectionId];
                }
            }
            
            NSMutableString * collectionIds=[[NSMutableString alloc] init];
            [collectionIds setString:@""];
            for (NSString * str in _deleteIDArr)
            {
           
                [collectionIds appendString:str];
                [collectionIds appendString:@","];
            }
            [collectionIds deleteCharactersInRange:NSMakeRange([collectionIds length]-1, 1)];

            JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
            
            if ([SOAPRequest checkNet])
            {
                NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:collectionIds,@"ids",[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",@"",@"targetName",@"1",@"currentPageNo",@"10",@"pageSize",nil];
                NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Follow_DeleteMemberFollow] jsonDic:jsondic]];
                if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
                {
                    [self sendPost];
                    [_tabView reloadData];
                }
                else
                {
                    NSString * str=@"服务器异常，请稍后重试...";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
            }

        }
        else
        {
            JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
            if ([SOAPRequest checkNet])
            {
                NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",nil];
                NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Follow_DeleteAllFollow] jsonDic:jsondic]];

                if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
                {
                    [self sendPost];
                    [_tabView reloadData];
                }
                else
                {
                    NSString * str=@"服务器异常，请稍后重试...";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
            }

        }
 
        
    }
    else
    {
    }
    [_deleteIDArr removeAllObjects];
}
-(void)finishBtn
{
    for (int i=0; i<_listModelArr.count; i++)
    {
        JTCollectionTableViewCell * cell=(JTCollectionTableViewCell *)[_tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIButton * editBtn=(UIButton *)[cell viewWithTag:21+i];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        editBtn.hidden=YES;
        _bottomView.hidden=YES;
        CGRect rect= cell.titleLab.frame;
        rect.origin.x=90;
        cell.titleLab.frame=rect;
        CGRect rect2= cell.picImgView.frame;
        rect2.origin.x=5;
        cell.picImgView.frame=rect2;
        CGRect rect3= cell.typeLab.frame;
        rect3.origin.x=90;
        cell.typeLab.frame=rect3;
        CGRect rect4= cell.dateLab.frame;
        rect4.origin.x=90;
        cell.dateLab.frame=rect4;
        [UIView commitAnimations];
    }
    isAllSelect=NO;
    UIButton * allSelectBtn=(UIButton *)[_bottomView viewWithTag:10000];
    [allSelectBtn setImage:[UIImage imageNamed:@"un_select_iv.png"] forState:UIControlStateNormal];
    for (int i=0; i<_listModelArr.count; i++)
    {
        isChoose[i]=0;
    }
    _bottomView.hidden=YES;
}
-(void)eidtBtn:(UIButton *)sender
{
    int count=sender.tag-21;
    sender.hidden=NO;
    if (isChoose[count]==0)
    {
        [sender setImage:[UIImage imageNamed:@"select_iv.png"] forState:UIControlStateNormal];
        isChoose[count]=1;
    
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"un_select_iv.png"] forState:UIControlStateNormal];
        isChoose[count]=0;
    }
    
    BOOL isallSelect=1;
    for (int i=0; i<_listModelArr.count; i++)
    {
        if (isChoose[i]==0)
        {
            isallSelect=0;
            break;
        }
    }
    if (isallSelect==0)
    {
        isAllSelect=0;
        UIButton * allSelectBtn=(UIButton *)[self.view viewWithTag:10000];
        [allSelectBtn setImage:[UIImage imageNamed:@"un_select_iv.png"] forState:UIControlStateNormal];
    }
    else
    {
        isAllSelect=1;
        UIButton * allSelectBtn=(UIButton *)[self.view viewWithTag:10000];
        [allSelectBtn setImage:[UIImage imageNamed:@"select_iv.png"] forState:UIControlStateNormal];
    }
}
-(void)search:(UIButton *)sender
{
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    _searchView.hidden=YES;
    CGRect rect= _tabView.frame;
    rect.origin.y-=35;
    _tabView.frame=rect;
    [UIView commitAnimations];
    _searchWord= textField.text;
    [self sendPost];
    [_tabView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==10)
    {
        return [_listModelArr count];
    }
    else
    {
        return 2;
    }
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView.tag==10)
    {
        return 90;
    }
    else
    {
        return 40;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==10)
    {
        JTCollectionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell=[[JTCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        JTSortModel * sortModel=[_listModelArr objectAtIndex:indexPath.row];
        [cell.picImgView setImageWithURL:[NSURL URLWithString:sortModel.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        cell.typeLab.text=[NSString stringWithFormat:@"类型:%@",sortModel.type];
        cell.titleLab.text=sortModel.title;
        
        cell.dateLab.text=[NSString stringWithFormat:@"关注时间:%@",sortModel.collectionTime];
        
        [cell.editBtn setImage:[UIImage imageNamed:@"un_select_iv.png"] forState:UIControlStateNormal];
        [cell.editBtn addTarget:self action:@selector(eidtBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.editBtn.tag=21+indexPath.row;
        cell.editBtn.hidden=YES;
        
        if (_bottomView.hidden==NO)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            cell.editBtn.hidden=NO;
            CGRect rect= cell.titleLab.frame;
            rect.origin.x=120;
            cell.titleLab.frame=rect;
            CGRect rect2= cell.picImgView.frame;
            rect2.origin.x=40;
            cell.picImgView.frame=rect2;
            CGRect rect3= cell.typeLab.frame;
            rect3.origin.x=120;
            cell.typeLab.frame=rect3;
            CGRect rect4= cell.dateLab.frame;
            rect4.origin.x=120;
            cell.dateLab.frame=rect4;
            [UIView commitAnimations];
            
            if (isChoose[indexPath.row]==1)
            {
                   [cell.editBtn setImage:[UIImage imageNamed:@"select_iv.png"] forState:UIControlStateNormal];
            }
 
        }
    
        return cell;
    }
    else
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor=[UIColor blackColor];
        UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[_smallImgNameArr objectAtIndex:indexPath.row]]];
        imgView.frame=CGRectMake(5, 12, 16, 15);
        [cell addSubview:imgView];
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(28, 10, self.view.frame.size.width/2.0-10-28-2, 20)];
        lab.text=[_smallTitleArr objectAtIndex:indexPath.row];
        lab.textColor=[UIColor whiteColor];
        [cell addSubview:lab];
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView.tag==20)
    {
        if (_listModelArr.count==0&&[_searchWord isEqualToString:@""])
        {
            NSString * str=@"您尚未关注任何信息";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            tableView.bounds=CGRectMake(0, 0, 0, 0);
            return;
        }
        switch (indexPath.row)
        {
            case 0:
            {
                _bottomView.hidden=NO;
                [_tabView reloadData];
            }
                break;
            case 1:
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                _searchView.hidden=NO;
                CGRect rect=_tabView.frame;
                rect.origin.y+=35;
                _tabView.frame=rect;
                [UIView commitAnimations];
                
            }
                break;
            default:
                break;
        }
        tableView.bounds=CGRectMake(0, 0, 0, 0);
    }
    else
    {
        if (_bottomView.hidden==NO)
        {
            JTCollectionTableViewCell * cell=(JTCollectionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self eidtBtn:cell.editBtn];
        }
        else
        {
            JTSortModel * model=[[JTSortModel alloc] init];
             model=[_listModelArr objectAtIndex:indexPath.row];
            
            if([model.mappingId intValue]<8)
            {
                if ([model.clickTime intValue]==0)
                {
                    JTJiGouDetailViewController * zjdVC=[[JTJiGouDetailViewController alloc] init];
                    zjdVC.sortmodel=[[JTSortModel alloc] init];
                    zjdVC.sortmodel.idStr=model.idStr;
                    [self.navigationController pushViewController:zjdVC animated:YES];
                }
                else if ([model.clickTime intValue]==1)
                {
                    JTSijiaoDetailViewController * zjdVC=[[JTSijiaoDetailViewController alloc] init];
                    zjdVC.sortmodel=[[JTSortModel alloc] init];
                    zjdVC.sortmodel.idStr=model.idStr;
                    [self.navigationController pushViewController:zjdVC animated:YES];
                }
                
            }
            else if([model.mappingId intValue]>8)
            {
                JTDianpuDetailViewController * zjdVC=[[JTDianpuDetailViewController alloc] init];
                zjdVC.sortmodel=[[JTSortModel alloc] init];
                zjdVC.sortmodel.idStr=model.idStr;
                [self.navigationController pushViewController:zjdVC animated:YES];
            }

        }
 
    }

}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnClick:(UIButton *)sender
{
    if (_searchView.hidden==NO)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        _searchView.hidden=YES;
        CGRect rect=_tabView.frame;
        rect.origin.y-=35;
        _tabView.frame=rect;
        [UIView commitAnimations];
    }
    if (_bottomView.hidden==NO)
    {
        NSString * str=@"请先结束编辑！" ;
        [JTAlertViewAnimation startAnimation:str view:self.view];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        _smallTabView.bounds=CGRectMake(0, 0, self.view.frame.size.width/2.0-5, 80);
        [UIView commitAnimations];
    }
}
-(void)sendPost
{
    pageNum=1;
    [_listModelArr removeAllObjects];
    isAllSelect=NO;
    for (int i=0; i<10000; i++)
    {
        isChoose[i]=NO;
    }
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
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",_searchWord,@"targetName",@"1",@"currentPageNo",@"10",@"pageSize",nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Follow_GetMemberFollowList] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"page"] objectForKey:@"data"] count]==0)
                {
                    NSString * str=@"未找到符合条件的数据！" ;
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"page"]objectForKey:@"data"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    
                    sortModel.collectionId=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"]];
                    sortModel.idStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetId"]];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetName"];
                    sortModel.mappingId=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"mappingId"]];
                    sortModel.collectionTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"createTimeValue"];
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetImgUrl"];
                    sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetType"];
                    sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"isPrivate"];
                    
                    
                    [_listModelArr addObject:sortModel];
  
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[zaojiaoListDic objectForKey:@"result"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    NSString * collectionIdStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"]];
                    BOOL isExist=0;
                    for (int j=0; j<[_listModelArr count]; j++)
                    {
                        JTSortModel * aModel=[_listModelArr objectAtIndex:j];
                        if ([[NSString stringWithFormat:@"%@",aModel.collectionId] isEqualToString:collectionIdStr])
                        {
                            isExist=1;
                            break;
                        }
                    }
                    if (isExist==0)
                    {
                        JTSortModel * sortModel=[[JTSortModel alloc] init];
                        
                        sortModel.collectionId=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"]];
                        sortModel.idStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetId"]];
                        sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetName"];
                        sortModel.mappingId=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"mappingId"]];
                        sortModel.collectionTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"createTimeValue"];
                        sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetImgUrl"];
                        sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetType"];
                        sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"isPrivate"];
                        
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",_searchWord,@"targetName",[NSString stringWithFormat:@"%d",pageNum],@"currentPageNo",@"10",@"pageSize",nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Follow_GetMemberFollowList] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if ([[[zaojiaoListDic objectForKey:@"page"] objectForKey:@"data"] count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"page"] objectForKey:@"data"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                
                sortModel.collectionId=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"]];
                sortModel.idStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetId"]];
                sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetName"];
                sortModel.mappingId=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"mappingId"]];
                sortModel.collectionTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"createTimeValue"];
                sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetImgUrl"];
                sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"targetType"];
                sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"isPrivate"];
                
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
