//
//  JTShangpinKaquanViewController.m
//  清一丽
//
//  Created by 小七 on 15-1-6.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTShangpinKaquanViewController.h"
#import "JTShangpinKaquanTabviewCell.h"
@interface JTShangpinKaquanViewController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _listModelArr;
    int pageNum;
    int q;
    UILabel * _countLab;
    int totalCount;
}
@end
@implementation JTShangpinKaquanViewController
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
    [self sendPost];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    q=3;
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
    navTitailLab.text=[NSString stringWithFormat:@"使用代金券"];
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
    
    _countLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 64+15, self.view.frame.size.width, 25)];
    _countLab.text=@"您有X张代金券可使用";
    _countLab.textColor=[UIColor orangeColor];
    _countLab.textAlignment=NSTextAlignmentCenter;
    _countLab.font=[UIFont systemFontOfSize:18];
    [self.view addSubview:_countLab];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+15+25+10, self.view.frame.size.width, self.view.frame.size.height-114) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listModelArr.count;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JTShangpinKaquanTabviewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[JTShangpinKaquanTabviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    }
    JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
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
    [cell.useBtn addTarget:self action:@selector(shiyong:) forControlEvents:UIControlEventTouchUpInside];
    cell.useBtn.tag=indexPath.row+100;
    return cell;
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)shiyong:(UIButton *)sender
{
    UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确定使用此代金券，使用后，操作将不可撤销！" delegate:self cancelButtonTitle:@"使用" otherButtonTitles:@"取消", nil];
    alertView.tag=sender.tag+100;
    [alertView show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        JTSortModel * model=[_listModelArr objectAtIndex:alertView.tag-100-100];
        NSLog(@"使用编号为%@的代金券",model.idStr);
        if ([SOAPRequest checkNet])
        {
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:model.idStr,@"id",self.shopId,@"shopId",self.goodsId,@"goodsId", nil];
            NSDictionary * zaojiaoCollectionDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_UserVoucher] jsonDic:jsondic]];
            
            if ([[NSString stringWithFormat:@"%@",[zaojiaoCollectionDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用成功，如有疑问，您可到个人中心进行核对" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
                [alertView show];
                [self.navigationController popViewControllerAnimated:YES];
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
    }
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
        
        _countLab.text=[NSString stringWithFormat:@"您有%d张代金券可使用",totalCount];
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
    NSMutableArray * statueArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    [statueArr addObject:@"New"];
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",[NSString stringWithFormat:@"%@",self.shopId],@"shopId",statueArr,@"status",@"1",@"page",@"20",@"pageSize", nil];
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_UserVoucherPage] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            
            if (q==3)
            {
                totalCount=[[[[zaojiaoDic objectForKey:@"userVoucherPage"] objectForKey:@"page"]objectForKey:@"totalCount"] intValue];
                if ([[[[zaojiaoDic objectForKey:@"userVoucherPage"] objectForKey:@"page"]objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[[zaojiaoDic objectForKey:@"userVoucherPage"] objectForKey:@"page"]objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                    sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startDate"];
                    sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endDate"];
                    
                    [_listModelArr addObject:sortModel];

                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[[zaojiaoDic objectForKey:@"userVoucherPage"] objectForKey:@"page"]objectForKey:@"list"];;
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
                        sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                        sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                        sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startDate"];
                        sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endDate"];
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
    NSMutableArray * statueArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    [statueArr addObject:@"New"];
    
    if ([SOAPRequest checkNet])
    {
        JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId",[NSString stringWithFormat:@"%@",self.shopId],@"shopId",statueArr,@"status",[NSString stringWithFormat:@"%d",pageNum],@"page",@"20",@"pageSize", nil];
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_UserVoucherPage] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if ([[[[zaojiaoDic objectForKey:@"userVoucherPage"] objectForKey:@"page"] objectForKey:@"list"] count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[[zaojiaoDic objectForKey:@"userVoucherPage"] objectForKey:@"page"]objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.name=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startDate"];
                sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endDate"];
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
@end
