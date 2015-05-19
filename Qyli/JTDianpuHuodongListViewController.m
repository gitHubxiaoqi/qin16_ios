//
//  JTDianpuHuodongListViewController.m
//  清一丽
//
//  Created by 小七 on 15-2-12.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTDianpuHuodongListViewController.h"
#import "JTDianpuHuodongDetailViewController.h"
#import "JTHuoDongListTableViewCell.h"

@interface JTDianpuHuodongListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int p;
    int q;
    UITableView * _tableView;
    UITableView * _areaTabView;
    UITableView * _streetTabView;
    UITableView * _rankTabView;
    
    NSMutableArray * _quArr;
    NSMutableArray * _quIDArr;
    NSMutableArray * _streetArr;
    NSMutableArray * _streetIDArr;
    
    NSString * _areaID;
    NSString * _streetID;
    NSString * _rankID;
    NSString * _cityID;
    
    int clickNum;
    
    
    int pageNum;
    
    NSMutableArray * _listModelArr;
    
    NSArray * _xuanzeArr;
    
    NSArray * _distanceStrArr;
    NSArray * _distanceIDArr;
}
@end

@implementation JTDianpuHuodongListViewController

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
    _areaID=@"0";
    _streetID=@"0";
    _rankID=@"DISTANCEASC";
    //_minMaxAgeStr=@"0,18";
    clickNum=0;
    
    _quArr=[[NSMutableArray alloc] initWithCapacity:0];
    _quIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    _streetArr=[[NSMutableArray alloc] initWithCapacity:0];
    _streetIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    _cityID=appDelegate.appCityID;
    _quArr=appDelegate.appQuArr;
    _quIDArr=appDelegate.appQuIDArr;
    _streetArr=appDelegate.appShreetArr;
    _streetIDArr=appDelegate.appShreetIDArr;
    
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];

    _distanceStrArr=[[NSArray alloc] initWithObjects:@"距离最近(默认)",@"发布时间", nil];
    _distanceIDArr=[[NSArray alloc] initWithObjects:@"DISTANCEASC",@"IDDESC", nil];
    
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
    navTitailLab.text=@"快来参与吧！";
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:20];
    [navBarView addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 10, 15);
    [leftBtn addSubview:backImgView];
    

    _xuanzeArr=[[NSArray alloc] initWithObjects:@"区域",@"排序", nil];
    for (int i=0; i<2; i++)
    {
        UIButton * chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:231.0/255.0 alpha:1.0];
        chooseBtn.frame=CGRectMake(i*(self.view.frame.size.width/2.0),64, self.view.frame.size.width/2.0, 40);
        chooseBtn.tag=70+i;
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chooseBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        chooseBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        [chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:[_xuanzeArr objectAtIndex:i] forState:UIControlStateNormal];
        
        UIImageView * imgView=[[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"xiala_more.png"]];
        imgView.frame=CGRectMake(self.view.frame.size.width/2.0-10-4, 16, 10, 8);
        [chooseBtn addSubview:imgView];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0-0.5, 10, 0.5, 20)];
        lineLab.backgroundColor=[UIColor blackColor];
        lineLab.alpha=0.3;
        [chooseBtn addSubview:lineLab];
        [self.view addSubview:chooseBtn];
        
    }

    
    _areaTabView=[[UITableView alloc] initWithFrame:CGRectMake(25, 64+40+30, self.view.frame.size.width-25*2, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _areaTabView.dataSource=self;
    _areaTabView.delegate=self;
    _areaTabView.tag=101;
    [self.view addSubview:_areaTabView];
    _areaTabView.showsVerticalScrollIndicator=NO;
    
    _streetTabView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0, 64+40+30,self.view.frame.size.width/2.0-25, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _streetTabView.tag=102;
    _streetTabView.dataSource=self;
    _streetTabView.delegate=self;
    [self.view addSubview:_streetTabView];
    _streetTabView.showsVerticalScrollIndicator=NO;
    
    _rankTabView=[[UITableView alloc] initWithFrame:CGRectMake(25, 64+40+30, self.view.frame.size.width-25*2, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _rankTabView.tag=105;
    _rankTabView.dataSource=self;
    _rankTabView.delegate=self;
    [self.view addSubview:_rankTabView];
    _rankTabView.showsVerticalScrollIndicator=NO;

    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.frame.size.width, self.view.frame.size.height-64-40-TAB_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
    _tableView.tag=100;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator=NO;
    
}

-(void)leftBtnCilck
{
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController=appdelegate.tabBarViewController;
    [appdelegate.tabBarViewController readyUI];
    
}
-(void)kip:(JTSortModel *)model
{
    JTDianpuHuodongDetailViewController * zjdVC=[[JTDianpuHuodongDetailViewController alloc] init];
    zjdVC.sortmodel=[[JTSortModel alloc] init];
    zjdVC.sortmodel=model;
    zjdVC.state=1;
    [self.navigationController pushViewController:zjdVC animated:YES];
}
-(void)chooseBtn:(UIButton *)sender
{
    [self.view endEditing:YES];
    UIImageView * bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64+40+5, self.view.frame.size.width, self.view.frame.size.height-110)];
    [self.view addSubview:bgImgView];
    switch (sender.tag-70)
    {
        case 0:
        {
            bgImgView.image=[UIImage imageNamed:@"first_pop_bg.9.png"];
            [self.view bringSubviewToFront:_tableView];
            [self.view bringSubviewToFront:bgImgView];
            [self.view bringSubviewToFront:_areaTabView];
        }
            break;
        case 1:
        {
            
            bgImgView.image=[UIImage imageNamed:@"four_pop_bg.9.png"];
            [self.view bringSubviewToFront:_tableView];
            [self.view bringSubviewToFront:bgImgView];
            [self.view bringSubviewToFront:_rankTabView];
            
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - 表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag-100)
    {
        case 0:
        { return [_listModelArr count];
        }
            break;
        case 1:
        { return [_quArr count];
        }
            break;
        case 2:
        {
            if (_streetArr.count==0)
            {
                return 0;
            }
            return [[_streetArr objectAtIndex:clickNum] count];
        }
            break;
        case 5:
        {
            return [_distanceIDArr count];
        }
            break;

        default:
            return 100;
            break;
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag-100)
    {
        case 0:
        {
            return 100;
            
        }
            break;
            
        default: return 40;
            break;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==100)
    {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        JTHuoDongListTableViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
        if (!customCell)
        {
            customCell=[[JTHuoDongListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
            customCell.selectionStyle=UITableViewCellSelectionStyleNone;
            customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
            
        }
        JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
        [customCell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        customCell.titleLab.text=model.title;
        CGSize titleSize=CGSizeMake(SCREEN_WIDTH-130-15-25, 30);
        CGSize titleAutoSize=[customCell.titleLab.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: customCell.titleLab.font} context:nil].size;
        customCell.hezuoImgView.frame=CGRectMake(15+titleAutoSize.width+5, 10, 20, 20);
        
        if ([model.isCanSeal intValue]==1)
        {
            customCell.hezuoImgView.hidden=NO;
        }
        else
        {
            customCell.hezuoImgView.hidden=YES;
        }
        if ([[NSString stringWithFormat:@"%@",model.registTime] isEqualToString:@"0"])
        {
            model.registTime=@"不限";
        }
        customCell.fabuDateLab.text=[NSString stringWithFormat:@"总名额:%@",model.registTime];
        NSString * opentmeStr=[model.openTime stringByReplacingOccurrencesOfString:@" " withString:@""];
        customCell.huodongDateLab.text=[NSString stringWithFormat:@"%@",opentmeStr];
        customCell.adressLab.text=[NSString stringWithFormat:@"%@%@%@",model.quStr,model.street,model.infoAddress];
        customCell.pelopeNumLab.text=[NSString stringWithFormat:@"已报名:%@人",model.cost];
        if (model.distance!=nil)
        {
            customCell.distanceLab.text=[NSString stringWithFormat:@"%.2fKm", [model.distance floatValue]];
        }
        else if(model.distance==nil||[[NSString stringWithFormat:@"%@",model.distance] isEqualToString:@""]||[[NSString stringWithFormat:@"%@",model.distance] intValue]==0)
        {
            customCell.distanceLab.text=@"距离不详";
        }
        if ([model.styleID intValue]<=0)
        {
            customCell.smallImgView.image=[UIImage imageNamed:@"灰.png"];
            customCell.styleLab.text=@"已结束";
            [customCell bringSubviewToFront:customCell.smallImgView];
        }
        else
        {
            customCell.smallImgView.image=[UIImage imageNamed:@"红.png"];
            customCell.styleLab.text=[NSString stringWithFormat:@"还有%@天结束",model.styleID];
            [customCell bringSubviewToFront:customCell.smallImgView];
        }
        
        return customCell;
    }
    else
    {
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        switch (tableView.tag-100)
        {
            case 1:
            {
                cell.textLabel.text=[_quArr objectAtIndex:indexPath.row];
            }
                break;
            case 2:
            {
                cell.textLabel.text=[[_streetArr objectAtIndex: clickNum] objectAtIndex:indexPath.row];
            }
                break;
            case 5:
            {
                
                cell.textLabel.text=[_distanceStrArr objectAtIndex:indexPath.row];
            }
                break;

            default:
                break;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIButton * btn1=(UIButton *)[self.view viewWithTag:70];
    UIButton * btn3=(UIButton *)[self.view viewWithTag:71];
    
    
    switch (tableView.tag-100)
    {
        case 0:
        {
            JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
            [self kip:model];
        }
            break;
        case 1:
        {
            
            if (indexPath.row==0)
            {
                [self.view bringSubviewToFront:_tableView];
                [btn1 setTitle:[_xuanzeArr objectAtIndex:btn1.tag-70] forState:UIControlStateNormal];
                btn1.titleLabel.font=[UIFont systemFontOfSize:18];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _areaID=@"0";
                _streetID=@"0";
                [self sendPost];
            }
            else
            {
                [self.view bringSubviewToFront:_streetTabView];
                _areaID=[_quIDArr objectAtIndex:indexPath.row];
                clickNum=indexPath.row;
                [_streetTabView reloadData];
            }
            
        }
            break;
        case 2:
        {
            if (indexPath.row==0)
            {
                [btn1 setTitle:[_quArr objectAtIndex:clickNum] forState:UIControlStateNormal];
                _streetID=@"0";
            }
            else
            {
                [btn1 setTitle:[[_streetArr objectAtIndex:clickNum] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                _streetID=[[_streetIDArr objectAtIndex:clickNum] objectAtIndex:indexPath.row];
            }
            
            btn1.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:_tableView];
            [self sendPost];
        }
            break;
        case 5:
        {
            if (indexPath.row==0)
            {
                [btn3 setTitle:[_xuanzeArr objectAtIndex:btn3.tag-70] forState:UIControlStateNormal];
                btn3.titleLabel.font=[UIFont systemFontOfSize:18];
                [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _rankID=@"DISTANCEASC";
            }
            else
            {
                [btn3 setTitle:[_distanceStrArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                btn3.titleLabel.font=[UIFont systemFontOfSize:13];
                [btn3 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                _rankID=[_distanceIDArr objectAtIndex:indexPath.row];
            }
            
            [self.view bringSubviewToFront:_tableView];
            [self sendPost];
        }
            break;
        default:
            break;
    }
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
        JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_areaID,@"regionId",_streetID,@"streetId",_rankID,@"sortType",@"1",@"page",@"20",@"pageSize",[NSString stringWithFormat:@"%@,%@",appdelegate.appLat,appdelegate.appLng],@"location",appdelegate.appCityID,@"cityId", nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_HuoDong_shopActivityPage] jsonDic:jsondic]];
        
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"shopActivityPage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"shopActivityPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                    sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"registedCount"];
                    sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"quota"];
                    NSString * beginDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startDate"]substringToIndex:10];
                    NSString * endDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endDate"]substringToIndex:10];
                    sortModel.openTime=[NSString stringWithFormat:@"%@至%@",beginDate,endDate];
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                    sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                    sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"];
                    sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                    sortModel.styleID=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"expiration"];
                    sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"] ;
                    sortModel.isCanSeal=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"cooperation"] ;
                    
                    [_listModelArr addObject:sortModel];
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"shopActivityPage"] objectForKey:@"list"];
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
                        sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"registedCount"];
                        sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"quota"];
                        NSString * beginDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startDate"]substringToIndex:10];
                        NSString * endDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endDate"]substringToIndex:10];
                        sortModel.openTime=[NSString stringWithFormat:@"%@至%@",beginDate,endDate];
                        sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                        sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                        sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"];
                        sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                        sortModel.styleID=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"expiration"];
                        sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"] ;
                        sortModel.isCanSeal=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"cooperation"] ;
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
        JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_areaID,@"regionId",_streetID,@"streetId",_rankID,@"sortType",[NSString stringWithFormat:@"%d",pageNum],@"page",@"20",@"pageSize",[NSString stringWithFormat:@"%@,%@",appdelegate.appLat,appdelegate.appLng],@"location",appdelegate.appCityID,@"cityId", nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_HuoDong_shopActivityPage] jsonDic:jsondic]];
        
        if ([[zaojiaoListDic objectForKey:@"resultCode"] intValue]==1000)
        {
            if ([[[zaojiaoListDic objectForKey:@"shopActivityPage"] objectForKey:@"list"] count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"shopActivityPage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"registedCount"];
                sortModel.registTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"quota"];
                NSString * beginDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startDate"]substringToIndex:10];
                NSString * endDate=[[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endDate"]substringToIndex:10];
                sortModel.openTime=[NSString stringWithFormat:@"%@至%@",beginDate,endDate];
                sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"];
                sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                sortModel.styleID=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"expiration"];
                sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"] ;
                sortModel.isCanSeal=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"cooperation"] ;
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
