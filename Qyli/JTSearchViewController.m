//
//  JTSearchViewController.m
//  Qyli
//
//  Created by 小七 on 14-7-30.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTSearchViewController.h"

#import "JTSearchTableViewCell.h"
#import "JTJiGouDetailViewController.h"
#import "JTKeChengDetailViewController.h"
#import "JTShangpinDetailViewController.h"
#import "JTDianpuDetailViewController.h"
#import "JTHuoDongDetailViewController.h"

@interface JTSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView * _tableView;
    UITableView * _reasultTabView;
    UITableView * _typeTabView;
    UITableView * _adressTabView;
    UITableView * _streetTabView;
    
    NSString * _typeStr;
    NSString * _cityStr;
    NSString * _adressStr;
    NSString * _streetStr;
    
    UITextField * textField;
    
    NSMutableArray * _historyArr;
    
    UIView * _typeAndAdressView;
    
    NSMutableArray * _typeMapArr;
    NSMutableArray * _typeMapIDArr;
    
    NSMutableArray * _adressMapArr;
    NSMutableArray * _adressIDMapArr;
    
    NSMutableArray * _streetMapArr;
    NSMutableArray * _streetIDMapArr;
    
    NSMutableArray * _listModelArr;
    
    int clickNum;
    
    int pageNum;
    int p;
    int q;

}


@end

@implementation JTSearchViewController

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _historyArr=[[NSMutableArray alloc] initWithCapacity:0];
    _historyArr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"historyTitleArr"]];
    _typeMapArr=[[NSMutableArray alloc] initWithCapacity:0];
    _typeMapIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    _adressMapArr=[[NSMutableArray alloc] initWithCapacity:0];
    _adressIDMapArr=[[NSMutableArray alloc] initWithCapacity:0];
    _streetMapArr=[[NSMutableArray alloc] initWithCapacity:0];
    _streetIDMapArr=[[NSMutableArray alloc] initWithCapacity:0];
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];

    [_typeMapArr addObject:@"不限"];
    [_typeMapArr addObject:@"机构"];
    [_typeMapArr addObject:@"商铺"];
    [_typeMapArr addObject:@"课程"];
    [_typeMapArr addObject:@"商品"];
    [_typeMapArr addObject:@"活动"];
   
    
    [_typeMapIDArr addObject:@"0"];
    [_typeMapIDArr addObject:@"1"];
    [_typeMapIDArr addObject:@"2"];
    [_typeMapIDArr addObject:@"3"];
    [_typeMapIDArr addObject:@"4"];
    [_typeMapIDArr addObject:@"5"];
   
    
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    _adressMapArr=[NSMutableArray arrayWithArray:appdelegate.appQuArr];
    _adressIDMapArr=[NSMutableArray arrayWithArray:appdelegate.appQuIDArr];
    _streetMapArr=[NSMutableArray arrayWithArray:appdelegate.appShreetArr];
    _streetIDMapArr=[NSMutableArray arrayWithArray:appdelegate.appShreetIDArr];
    _typeStr=@"0";
    _adressStr=@"0";
    _streetStr=@"0";
    _cityStr=appdelegate.appCityID;
     clickNum=0;
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
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:leftBtn];
    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 10, 15);
    [leftBtn addSubview:backImgView];
    
    
    UIImageView * textFieldBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bg.png"]];
    textFieldBgImgView.frame=CGRectMake(60, 7,self.view.frame.size.width-60-50-15, 30);
    textFieldBgImgView.userInteractionEnabled=YES;
    [navLab addSubview:textFieldBgImgView];
    
    textField=[[UITextField alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    textField.placeholder=@"请输入关键字进行搜索";
    textField.font=[UIFont systemFontOfSize:14];
    [textFieldBgImgView addSubview:textField];
    
    
    UIButton * deleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.frame=CGRectMake(self.view.frame.size.width-60-50-15-35, 0, 35, 30);
    [deleBtn addTarget:self action:@selector(deleteTextFieldText) forControlEvents:UIControlEventTouchUpInside];
    [textFieldBgImgView addSubview:deleBtn];
    
    UIImageView * deleteImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emotionstore_progresscancelbtn.png"]];
    deleteImgView.frame=CGRectMake(self.view.frame.size.width-60-50-15-16-10, 7, 16, 16);
    [textFieldBgImgView addSubview:deleteImgView];
    
    UIButton * searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(self.view.frame.size.width-40-10, 0, 50, 44);
    [searchBtn setImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 15)];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:searchBtn];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(5, 64, self.view.frame.size.width-10, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tag=100;
    [self.view addSubview:_tableView];
  
    
    _reasultTabView=[[UITableView alloc] initWithFrame:CGRectMake(5, 64+40, self.view.frame.size.width-10, self.view.frame.size.height-64-40) style:UITableViewStylePlain];
    _reasultTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _reasultTabView.hidden=YES;
    _reasultTabView.dataSource=self;
    _reasultTabView.delegate=self;
    [_reasultTabView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_reasultTabView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _reasultTabView.headerRefreshingText =@HeaderRefreshingText;
    _reasultTabView.footerRefreshingText=@FooterRefreshingText;
    _reasultTabView.tag=200;
    [self.view addSubview:_reasultTabView];
    
    _typeTabView=[[UITableView alloc] initWithFrame:CGRectMake(25, 64+40+30,self.view.frame.size.width-50, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _typeTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _typeTabView.dataSource=self;
    _typeTabView.delegate=self;
    _typeTabView.hidden=YES;
    _typeTabView.tag=300;
    [self.view addSubview:_typeTabView];
   
    
    _adressTabView=[[UITableView alloc] initWithFrame:CGRectMake(25, 64+40+30, self.view.frame.size.width-50, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _adressTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _adressTabView.dataSource=self;
    _adressTabView.delegate=self;
    _adressTabView.hidden=YES;
    _adressTabView.tag=400;
    [self.view addSubview:_adressTabView];
    
    _streetTabView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0, 64+40+30,self.view.frame.size.width/2.0-25, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _streetTabView.tag=500;
    _streetTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _streetTabView.hidden=YES;
    _streetTabView.dataSource=self;
    _streetTabView.delegate=self;
    [self.view addSubview:_streetTabView];

    _typeAndAdressView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    _typeAndAdressView.hidden=YES;
    [self.view addSubview:_typeAndAdressView];
    
    UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 0.5)];
    lineLab.backgroundColor=[UIColor grayColor];
    [_typeAndAdressView addSubview:lineLab];
    
    NSArray * xuanzeArr=[[NSArray alloc] initWithObjects:@"类型",@"区域", nil];
    for (int i=0; i<2; i++)
    {
        UIButton * chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.frame=CGRectMake(10+i*( self.view.frame.size.width/2.0-10),0, self.view.frame.size.width/2.0-10, 40);
        chooseBtn.tag=70+i;
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chooseBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        chooseBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        [chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:[xuanzeArr objectAtIndex:i] forState:UIControlStateNormal];
        
        UIImageView * imgView=[[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"xiala_more.png"]];
        imgView.frame=CGRectMake(130, 16, 10, 8);
        [chooseBtn addSubview:imgView];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(( self.view.frame.size.width/2.0-10)-0.5, 10, 0.5, 20)];
        lineLab.backgroundColor=[UIColor blackColor];
        lineLab.alpha=0.3;
        [chooseBtn addSubview:lineLab];
        [_typeAndAdressView addSubview:chooseBtn];
        
    }

    [self.view bringSubviewToFront:_tableView];
}
-(void)chooseBtn:(UIButton *)sender
{
    [self.view endEditing:YES];
    UIImageView * bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64+40+5, self.view.frame.size.width, self.view.frame.size.height-110)];
    bgImgView.userInteractionEnabled=YES;
    [self.view addSubview:bgImgView];
    
    switch (sender.tag-70)
    {
        case 0:
        {
            bgImgView.image=[UIImage imageNamed:@"first_pop_bg.9.png"];
            _typeTabView.hidden=NO;
            [self.view bringSubviewToFront:_reasultTabView];
            [self.view bringSubviewToFront:bgImgView];
            [self.view bringSubviewToFront:_typeTabView];
        }
            break;
        case 1:
        {
            bgImgView.image=[UIImage imageNamed:@"four_pop_bg.9.png"];
            _adressTabView.hidden=NO;
            [self.view bringSubviewToFront:_reasultTabView];
            [self.view bringSubviewToFront:bgImgView];
            [self.view bringSubviewToFront:_adressTabView];
        }
            break;
            default:
            break;
    }
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)search:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([textField.text isEqualToString:@""])
    {
        NSString * str=@"请填写您要搜索的类别或关键字!";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;
    }
    BOOL isExist=NO;
    
    _historyArr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"historyTitleArr"]];
    for (NSString * historyStr in _historyArr)
    {
        if ([textField.text isEqualToString:historyStr])
        {
            isExist=YES;
            break;
        }
    }
    if (isExist==NO)
    {
        [_historyArr insertObject:textField.text atIndex:0];
     
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_historyArr forKey:@"historyTitleArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_tableView reloadData];
    
    _tableView.hidden=YES;
    _reasultTabView.hidden=NO;
    _typeAndAdressView.hidden=NO;
    [self sendPost];
}
-(void)deleteTextFieldText
{
    textField.text=@"";
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}
#pragma mark - 表代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==200)
    {
         return _listModelArr.count;
    }
    else if (tableView.tag==100)
    {
         return _historyArr.count;
    }
    else if(tableView.tag==300)
    {
        return _typeMapArr.count;
    }
    else if(tableView.tag==400)
    {
        return _adressMapArr.count;
    }
    else
    {
        if (_streetMapArr.count==0)
        {
            return 0;
        }
       return [[_streetMapArr objectAtIndex:clickNum] count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==200)
    {
        JTSearchTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell=[[JTSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UILabel * lineLab=[[UILabel alloc] init];
            lineLab.tag=98;
            [cell addSubview:lineLab];
        }
        UILabel * lineLab=(UILabel *)[cell viewWithTag:98];
        lineLab.frame=CGRectMake(0, 79, self.view.frame.size.width, 0.5);
        lineLab.backgroundColor=[UIColor grayColor];
        
        JTSortModel * sortModel=[_listModelArr objectAtIndex:indexPath.row];
        cell.titleLab.text=sortModel.title;
        [cell.headImgView setImageWithURL:[NSURL URLWithString:sortModel.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        //cell.dateLab.text=sortModel.registTime;
        switch ([sortModel.typeID intValue])
        {
            case 1:
                cell.typeLab.text=@"机构";
                break;
            case 2:
                cell.typeLab.text=@"商铺";
                break;
            case 3:
                cell.typeLab.text=@"课程";
                break;
            case 4:
                cell.typeLab.text=@"商品";
                break;
            case 5:
                cell.typeLab.text=@"活动";
                break;
                
            default:
                break;
        }
        if ([sortModel.street isEqualToString:@""]||sortModel.street==nil)
        {
            sortModel.street=@"";
        }
        if ([sortModel.infoAddress isEqualToString:@""]||sortModel.infoAddress==nil)
        {
            sortModel.infoAddress=@"";
        }
       
        cell.adressLab.text=[NSString stringWithFormat:@"%@%@%@",sortModel.quStr,sortModel.street, sortModel.infoAddress];
        if ([[NSString stringWithFormat:@"%@",sortModel.distance] isEqualToString:@""]||[[NSString stringWithFormat:@"%@",sortModel.distance] intValue]==0||sortModel.distance==nil)
        {
            cell.distanceLab.text=@"距离不详";
            cell.distanceLab.textColor=[UIColor blackColor];
        }
        else
        {
            cell.distanceLab.text=[NSString stringWithFormat:@"%.1fKm",[sortModel.distance floatValue]];
            cell.distanceLab.textColor=[UIColor orangeColor];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UILabel * lineLab=[[UILabel alloc] init];
            lineLab.tag=99;
            [cell addSubview:lineLab];
            
            if (tableView.tag==100)
            {
                UIImageView * searchItemImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_item.png"]];
                searchItemImgView.frame=CGRectMake(15, 15, 14, 14);
                [cell addSubview:searchItemImgView];
                
                UILabel * historyTitleLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, self.view.frame.size.width-40-20, 24)];
                historyTitleLab.tag=indexPath.row+20;
                [cell addSubview:historyTitleLab];
            }
      
            
        }
        UILabel * lineLab=(UILabel *)[cell viewWithTag:99];
        lineLab.frame=CGRectMake(0, cell.frame.size.height-1, self.view.frame.size.width, 0.5);
        lineLab.backgroundColor=[UIColor grayColor];

        if (tableView.tag==100)
        {
            UILabel *historyTitleLab=(UILabel *)[cell viewWithTag:indexPath.row+20];
            _historyArr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"historyTitleArr"]];
            historyTitleLab.text=[_historyArr objectAtIndex:indexPath.row];
            historyTitleLab.textColor=[UIColor grayColor];
            historyTitleLab.font=[UIFont systemFontOfSize:14];
        }
        else if (tableView.tag==300)
        {
            cell.textLabel.text=[_typeMapArr objectAtIndex:indexPath.row];
        }
        else if (tableView.tag==400)
        {
            cell.textLabel.text=[_adressMapArr objectAtIndex:indexPath.row];
        }
        else
        {
            cell.textLabel.text=[[_streetMapArr objectAtIndex: clickNum] objectAtIndex:indexPath.row];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==200)
    {
        JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
        switch ([model.typeID intValue])
        {
            case 1:
            {
                JTJiGouDetailViewController * JGVC=[[JTJiGouDetailViewController alloc] init];
                JGVC.sortmodel=[[JTSortModel alloc] init];
                JGVC.sortmodel.idStr=model.idStr;
                [self.navigationController pushViewController:JGVC animated:YES];
            }
                break;
            case 2:
            {
                JTDianpuDetailViewController * JGVC=[[JTDianpuDetailViewController alloc] init];
                JGVC.sortmodel=[[JTSortModel alloc] init];
                JGVC.sortmodel.idStr=model.idStr;
                [self.navigationController pushViewController:JGVC animated:YES];
            }
                break;
            case 3:
            {
                JTKeChengDetailViewController * JGVC=[[JTKeChengDetailViewController alloc] init];
                JGVC.sortmodel=[[JTSortModel alloc] init];
                JGVC.sortmodel.idStr=model.idStr;
                JGVC.state=3;
                [self.navigationController pushViewController:JGVC animated:YES];
            }
                break;
            case 4:
            {
                JTShangpinDetailViewController * JGVC=[[JTShangpinDetailViewController alloc] init];
                JGVC.sortmodel=[[JTSortModel alloc] init];
                JGVC.sortmodel.idStr=model.idStr;
                [self.navigationController pushViewController:JGVC animated:YES];
            }
                break;
            case 5:
            {
                JTHuoDongDetailViewController* JGVC=[[JTHuoDongDetailViewController alloc] init];
                JGVC.sortmodel=[[JTSortModel alloc] init];
                JGVC.sortmodel.idStr=model.idStr;
                JGVC.state=2;
                [self.navigationController pushViewController:JGVC animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
    else if (tableView.tag==100)
    {
       textField.text=[_historyArr objectAtIndex:indexPath.row];
    }
    else if (tableView.tag==300)
    {
        UIButton * btn1=(UIButton *)[self.view viewWithTag:70];
        
        if (indexPath.row==0)
        {
            [btn1 setTitle:@"类型" forState:UIControlStateNormal];
            btn1.titleLabel.font=[UIFont systemFontOfSize:18];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _typeStr=@"0";
        }
        else
        {
            [btn1 setTitle:[_typeMapArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            btn1.titleLabel.font=[UIFont systemFontOfSize:15];
            [btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            _typeStr=[_typeMapIDArr objectAtIndex:indexPath.row];
        }
        
        [self.view bringSubviewToFront:_reasultTabView];
        [self sendPost];

    }
    else if (tableView.tag==400)
    {
        UIButton * btn2=(UIButton *)[self.view viewWithTag:71];
        if (indexPath.row==0)
        {
            [btn2 setTitle:@"区域" forState:UIControlStateNormal];
            btn2.titleLabel.font=[UIFont systemFontOfSize:18];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _adressStr=@"0";
            _streetStr=@"0";
            [self.view bringSubviewToFront:_reasultTabView];
            [self sendPost];
        }
        else
        {
            _streetTabView.hidden=NO;
            [self.view bringSubviewToFront:_streetTabView];
            _adressStr=[_adressIDMapArr objectAtIndex:indexPath.row];
            clickNum=indexPath.row;
            [_streetTabView reloadData];
            
        }
        
     
    }
    else
    {
        UIButton * btn2=(UIButton *)[self.view viewWithTag:71];
        if (indexPath.row==0)
        {
            [btn2 setTitle:[_adressMapArr objectAtIndex:clickNum] forState:UIControlStateNormal];
            _streetStr=@"0";
        }
        else
        {
            [btn2 setTitle:[[_streetMapArr objectAtIndex:clickNum] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            _streetStr=[[_streetIDMapArr objectAtIndex:clickNum] objectAtIndex:indexPath.row];
        }
        
        btn2.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.view bringSubviewToFront:_reasultTabView];
        [self sendPost];

    }
   
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==200)
    {
        return 80;
    }
    else
    {
        return 40;
    }

}
-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag==100)
    {
        return 40;
    }
    else
    {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag==100)
    {
        UIView * view=[[UIView alloc] init];
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel * lineLab1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
        lineLab1.backgroundColor=[UIColor grayColor];
        [view addSubview:lineLab1];
        
        UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_delete_post.png"]];
        imgView.frame=CGRectMake(15, 11, 15, 18);
        [view addSubview:imgView];
        
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, self.view.frame.size.width-40-20, 20)];
        lab.text=@"清空搜索历史记录";
        lab.textColor=[UIColor grayColor];
        lab.font=[UIFont systemFontOfSize:15];
        [view addSubview:lab];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 0.5)];
        lineLab.backgroundColor=[UIColor grayColor];
        [view addSubview:lineLab];
        
        UIButton * bigBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        bigBtn.frame=CGRectMake(0, 0, self.view.frame.size.width-10, 40);
        [bigBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:bigBtn];
        
        return view;

    }
    else
    {
        return nil;
    }
}

-(void)deleteBtnClick
{
    [_historyArr removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:_historyArr forKey:@"historyTitleArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_tableView reloadData];

}
-(void)sendPost
{
    pageNum=1;
    [_listModelArr removeAllObjects];
    [_reasultTabView reloadData];
    q=3;
    [_reasultTabView headerBeginRefreshing];
}
-(void)CompanyListHeaderRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新表格
        [self GetCompanyListData];
        [_reasultTabView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_reasultTabView headerEndRefreshing];
    });
}

-(void)footerRefresh
{
    pageNum++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //请求数据
        [self loadMoreData];
        // 刷新表格
        [_reasultTabView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_reasultTabView footerEndRefreshing];
    });
}
-(void)GetCompanyListData
{
    JTAppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_cityStr,@"cityId",textField.text,@"name",_adressStr,@"regionId",_streetStr,@"streetId",_typeStr,@"type",@"1",@"page",@"20",@"pageSize",[NSString stringWithFormat:@"%@,%@",appdelegate.appLat,appdelegate.appLng],@"location",appdelegate.appCityID,@"cityId",  nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Search_GetSearchSolrPage] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"searchSolrPage"] objectForKey:@"list"] count]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"searchSolrPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"infoId"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"solrName"];
                    
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                    sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"] ;
                    sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"] ;
                    sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                    sortModel.mappingId=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"searchMappingId"];
                    sortModel.typeID=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"searchType"];
                    sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"];
                    
                    [_listModelArr addObject:sortModel];

                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[zaojiaoListDic objectForKey:@"infoListResult"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    NSString * idStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"infoId"]];
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
                        sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"infoId"];
                        sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"solrName"];
                        
                        sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                        sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"] ;
                        sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"] ;
                        sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                        sortModel.mappingId=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"searchMappingId"];
                        sortModel.typeID=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"searchType"];
                        sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"];
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
        JTAppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_cityStr,@"cityId",textField.text,@"name",_adressStr,@"regionId",_streetStr,@"streetId",_typeStr,@"type",[NSString stringWithFormat:@"%d",pageNum],@"page",@"20",@"pageSize",[NSString stringWithFormat:@"%@,%@",appdelegate.appLat,appdelegate.appLng],@"location",appdelegate.appCityID,@"cityId", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Search_GetSearchSolrPage] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if ([[[zaojiaoListDic objectForKey:@"searchSolrPage"] objectForKey:@"list"]count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"searchSolrPage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"infoId"];
                sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"solrName"];
                
                sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"] ;
                sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"] ;
                sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                sortModel.mappingId=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"searchMappingId"];
                sortModel.typeID=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"searchType"];
                sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"];
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
