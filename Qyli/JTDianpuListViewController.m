//
//  JTDianpuListViewController.m
//  Qyli
//
//  Created by 小七 on 14-11-21.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTDianpuListViewController.h"
#import "JTZaojiaoListTableViewCell.h"
#import "JTDianpuDetailViewController.h"

@interface JTDianpuListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int p;
    int q;
    int m;
    
    UITableView * _tableView;
    UITableView * _areaTabView;
    UITableView * _streetTabView;
    UITableView * _sortTabView;
    UITableView * _rankTabView;
    
    NSMutableArray * _typeMapArr;
    NSMutableArray * _typeMapIDArr;
    
    NSMutableArray * _quArr;
    NSMutableArray * _quIDArr;
    NSMutableArray * _streetArr;
    NSMutableArray * _streetIDArr;
    
    NSString * _areaID;
    NSString * _streetID;
    NSString * _typeID;
    NSString * _searchWord;
    NSString * _rankID;
    NSString * _cityID;
    
    int clickNum;
    
    int pageNum;
    
    NSMutableArray * _listModelArr;
    NSArray * _distanceStrArr;
    NSArray * _distanceIDArr;
}
@end

@implementation JTDianpuListViewController

-(void)viewDidAppear:(BOOL)animated
{
    if (p==1)
    {
        [self sendPostGetAgePriceAndSoOn];
        if (m==18)
        {
            [self sendPost];
            m=9;
        }
    }
    p=2;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    p=1;
    q=3;
    m=9;
    pageNum=1;
    _searchWord=@"";
    //_typeID=@"0";
    _typeID=self.typeIDStr;
    _areaID=@"0";
    _streetID=@"0";
    _rankID=@"DISTANCEASC";
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
    
    _typeMapArr=[[NSMutableArray alloc] initWithCapacity:0];
    _typeMapIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    _distanceStrArr=[[NSArray alloc] initWithObjects:@"距离最近(默认)",@"评分最高",@"点击率最高", nil];
    _distanceIDArr=[[NSArray alloc] initWithObjects:@"DISTANCEASC",@"SCOREDESC",@"VIEWTIMESDESC", nil];
    
    [self readyUI];
}
-(void)readyUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    
    //自定义导航条
    UIView * navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navBarView.backgroundColor=NAV_COLOR;
    [self.view addSubview:navBarView];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 10, 15);
    [navBarView addSubview:backImgView];
    
    
    UIImageView * textFieldBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bg.png"]];
    textFieldBgImgView.frame=CGRectMake(60, 7,self.view.frame.size.width-60-50-15, 30);
    textFieldBgImgView.userInteractionEnabled=YES;
    [navBarView addSubview:textFieldBgImgView];
    
    UITextField * searchTextField=[[UITextField alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    searchTextField.placeholder=@"请输入类别或关键字";
    searchTextField.tag=99;
    searchTextField.font=[UIFont systemFontOfSize:14];
    [textFieldBgImgView addSubview:searchTextField];
    
    
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
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:searchBtn];
    
    NSArray * xuanzeArr=[[NSArray alloc] initWithObjects:@"区域",@"类别",@"排序", nil];
    for (int i=0; i<3; i++)
    {
        UIButton * chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:231.0/255.0 alpha:1.0];
        chooseBtn.frame=CGRectMake(i*(self.view.frame.size.width/3.0),64, self.view.frame.size.width/3.0, 40);
        chooseBtn.tag=70+i;
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chooseBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        chooseBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        [chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:[xuanzeArr objectAtIndex:i] forState:UIControlStateNormal];
        
        UIImageView * imgView=[[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"xiala_more.png"]];
        imgView.frame=CGRectMake((self.view.frame.size.width-20)/3.0-10-4, 16, 10, 8);
        [chooseBtn addSubview:imgView];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-20)/3.0-0.5, 10, 0.5, 20)];
        lineLab.backgroundColor=[UIColor blackColor];
        lineLab.alpha=0.3;
        [chooseBtn addSubview:lineLab];
        [self.view addSubview:chooseBtn];
        
    }
    
    if ([self.typeIDStr isEqualToString:@"9"])
    {
        UIButton * typeBtn=(UIButton *)[self.view viewWithTag:71];
        [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [typeBtn setTitle:@"儿童服饰" forState:UIControlStateNormal];
    }
    else if ([self.typeIDStr isEqualToString:@"10"])
    {
        UIButton * typeBtn=(UIButton *)[self.view viewWithTag:71];
        [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [typeBtn setTitle:@"母婴用品" forState:UIControlStateNormal];
    }
    else if ([self.typeIDStr isEqualToString:@"14"])
    {
        UIButton * typeBtn=(UIButton *)[self.view viewWithTag:71];
        [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [typeBtn setTitle:@"儿童摄影" forState:UIControlStateNormal];
    }
    else if ([self.typeIDStr isEqualToString:@"15"])
    {
        UIButton * typeBtn=(UIButton *)[self.view viewWithTag:71];
        [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [typeBtn setTitle:@"亲子娱乐" forState:UIControlStateNormal];
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
    
    _sortTabView=[[UITableView alloc] initWithFrame:CGRectMake(25, 64+40+30, self.view.frame.size.width-25*2, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _sortTabView.tag=103;
    _sortTabView.dataSource=self;
    _sortTabView.delegate=self;
    [self.view addSubview:_sortTabView];
    _sortTabView.showsVerticalScrollIndicator=NO;
    
    _rankTabView=[[UITableView alloc] initWithFrame:CGRectMake(25, 64+40+30, self.view.frame.size.width-25*2, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _rankTabView.tag=104;
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
    [self.view endEditing:YES];
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController=appdelegate.tabBarViewController;
    [appdelegate.tabBarViewController readyUI];

}
-(void)search
{
    [self.view endEditing:YES];
    UITextField * textField=(UITextField *)[self.view viewWithTag:99];
    _searchWord=textField.text;
    [self sendPost];
    
}
-(void)deleteTextFieldText
{
    [self.view endEditing:YES];
    UITextField * textField=(UITextField *)[self.view viewWithTag:99];
    textField.text=@"";
    _searchWord=@"";
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
            bgImgView.image=[UIImage imageNamed:@"second_pop_bg.9.png"];
            [self.view bringSubviewToFront:_tableView];
            [self.view bringSubviewToFront:bgImgView];
            [self.view bringSubviewToFront:_sortTabView];
            
        }
            break;
        case 2:
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
        { return [_listModelArr count];}
            break;
        case 1:
        { return [_quArr count];}
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
        case 3:
        { return [_typeMapArr count];}
            break;
        case 4:
        { return _distanceStrArr.count;
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
            JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
            if ([model.type isEqualToString:@""]||model.type==nil)
            {
                model.type=@"";
            }
            CGSize size=CGSizeMake(self.view.frame.size.width-20-170, MAXFLOAT);
            CGSize autoSize=[model.type boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
            if (autoSize.height<20)
            {
                autoSize.height=20;
            }
            if (model.street==nil||[model.street isEqualToString:@""])
            {
                model.street=@"";
            }
            if (model.infoAddress==nil||[model.infoAddress isEqualToString:@""])
            {
                model.infoAddress=@"";
            }
            NSString * adressStr=[NSString stringWithFormat:@"%@%@%@",model.quStr,model.street,model.infoAddress];
            CGSize size2=CGSizeMake(self.view.frame.size.width-20-105, MAXFLOAT);
            CGSize autoSize2=[adressStr boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
            if (autoSize2.height<20)
            {
                autoSize2.height=20;
            }
            return 90+autoSize.height+autoSize2.height;

            
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
        JTZaojiaoListTableViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
        if (!customCell)
        {
            customCell=[[JTZaojiaoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
            customCell.selectionStyle=UITableViewCellSelectionStyleNone;
            customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
            
            UILabel * fenLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-10-20, 60, 10, 10)];
            fenLab.textColor=[UIColor grayColor];
            fenLab.font=[UIFont systemFontOfSize:12];
            fenLab.hidden=YES;
            fenLab.tag=1000;
            [customCell addSubview:fenLab];
        }
       customCell.lab1.text=@"店铺类型:";
        JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
        [customCell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        
        customCell.titleLab.text=model.title;
        CGSize titleSize=CGSizeMake(SCREEN_WIDTH-20-55-3-15-25, 30);
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
        //customCell.dateLab.text=model.registTime ;

        if ([[NSString stringWithFormat:@"%@",model.distance] isEqualToString:@""]||model.distance==nil)
        {
            customCell.distanceLab.text=@"距离不详";
        }
        else
        {
            customCell.distanceLab.text=[NSString stringWithFormat:@"%.2fKm", [model.distance floatValue]];
        }
        
        if ([model.type isEqualToString:@""]||model.type==nil)
        {
            customCell.typeLab.text=@"暂无数据";
            customCell.typeLab.frame=CGRectMake(170, 50,self.view.frame.size.width-20-170, 20);
        }
        else
        {
            customCell.typeLab.text=model.type;
            
        }
        CGSize size=CGSizeMake(self.view.frame.size.width-20-170, MAXFLOAT);
        CGSize autoSize=[customCell.typeLab.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: customCell.typeLab.font} context:nil].size;
        if (autoSize.height<20)
        {
            autoSize.height=20;
        }
        customCell.typeLab.frame=CGRectMake(170, 50,self.view.frame.size.width-20-170, autoSize.height);
        
        if ([[NSString stringWithFormat:@"%@",model.score] isEqualToString:@""]||model.score==nil||[[NSString stringWithFormat:@"%@",model.score] intValue]==0)
        {
            customCell.scroeLab.frame=CGRectMake(self.view.frame.size.width-70-10, 40+customCell.typeLab.frame.size.height, 70, 40);
            customCell.scroeLab.text=@"暂无评价";
            customCell.scroeLab.textColor=[UIColor orangeColor];
            customCell.scroeLab.font=[UIFont systemFontOfSize:15];
            UILabel * lab=(UILabel *)[customCell viewWithTag:1000];
            lab.text=@"分";
            lab.hidden=YES;
        }
        else
        {
            customCell.scroeLab.frame=CGRectMake(self.view.frame.size.width-30-25, 40+customCell.typeLab.frame.size.height, 30, 40);
            float scroe=[model.score floatValue];
            customCell.scroeLab.text=[NSString stringWithFormat: @"%.1f",scroe] ;
            customCell.scroeLab.textColor=[UIColor redColor];
            customCell.scroeLab.font=[UIFont systemFontOfSize:18];
            UILabel * lab=(UILabel *)[customCell viewWithTag:1000];
            lab.text=@"分";
            lab.hidden=NO;
            lab.frame=CGRectMake(self.view.frame.size.width-10-20, 60+customCell.typeLab.frame.size.height, 10, 10);
            
        }
        
        customCell.lab2.frame=CGRectMake(105, 50+customCell.typeLab.frame.size.height, 55, 20);
        customCell.clickNumLab.frame=CGRectMake(160, 50+customCell.typeLab.frame.size.height, 100, 20);
        if (model.clickTime==nil)
        {
            model.clickTime=@"0";
        }
        customCell.clickNumLab.text=[NSString stringWithFormat:@"%@次",model.clickTime];
        
        if (model.street==nil||[model.street isEqualToString:@""])
        {
            model.street=@"";
        }
        if (model.infoAddress==nil||[model.infoAddress isEqualToString:@""])
        {
            model.infoAddress=@"";
        }
        customCell.quLab.text=[NSString stringWithFormat:@"%@%@%@",model.quStr,model.street,model.infoAddress];
        CGSize size2=CGSizeMake(self.view.frame.size.width-20-105, MAXFLOAT);
        CGSize autoSize2=[ customCell.quLab.text boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: customCell.quLab.font} context:nil].size;
        if (autoSize2.height<20)
        {
            autoSize2.height=20;
        }
        customCell.quLab.frame=CGRectMake(105, 70+customCell.typeLab.frame.size.height, self.view.frame.size.width-20-105,autoSize2.height);
        customCell.bgImgView.frame=CGRectMake(0, 5, self.view.frame.size.width, 80+autoSize.height+autoSize2.height);
        
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
            case 0:
            {}
                break;
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
            case 3:
            {
                cell.textLabel.text=[_typeMapArr objectAtIndex:indexPath.row];
            }
                break;
            case 4:
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
    UIButton * btn2=(UIButton *)[self.view viewWithTag:71];
    UIButton * btn3=(UIButton *)[self.view viewWithTag:72];
    switch (tableView.tag-100)
    {
        case 0:
        {
            JTDianpuDetailViewController * zjdVC=[[JTDianpuDetailViewController alloc] init];
            JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
            zjdVC.sortmodel=[[JTSortModel alloc] init];
            zjdVC.sortmodel=model;
            [self.navigationController pushViewController:zjdVC animated:YES];
        }
            break;
        case 1:
        {
            
            if (indexPath.row==0)
            {
                [self.view bringSubviewToFront:_tableView];
                [btn1 setTitle:@"区域" forState:UIControlStateNormal];
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
        case 3:
        {
            if (indexPath.row==0)
            {
                [btn2 setTitle:@"类别" forState:UIControlStateNormal];
                btn2.titleLabel.font=[UIFont systemFontOfSize:18];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _typeID=@"";
            }
            else
            {
                [btn2 setTitle:[_typeMapArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                btn2.titleLabel.font=[UIFont systemFontOfSize:13];
                [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                _typeID=[_typeMapIDArr objectAtIndex:indexPath.row];
            }
            
            [self.view bringSubviewToFront:_tableView];
            [self sendPost];
            
        }
            break;
        case 4:
        {

            if (indexPath.row==0)
            {
                [btn3 setTitle:@"排序" forState:UIControlStateNormal];
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
-(void)sendPostGetAgePriceAndSoOn
{
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic1=[[NSDictionary alloc] initWithObjectsAndKeys:@"8",@"pid", nil];
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_SJLM_getSorts] jsonDic:jsondic1]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            [_typeMapArr addObject:@"不限"];
            [_typeMapIDArr addObject:@""];
            NSMutableArray * typeMapArr= [zaojiaoDic objectForKey:@"sortList"];
            for (int i=0; i<typeMapArr.count; i++)
            {
  
                [_typeMapArr addObject:[[typeMapArr objectAtIndex:i] objectForKey:@"name"]];
                [_typeMapIDArr addObject:[[typeMapArr objectAtIndex:i] objectForKey:@"id"]];
            }
            [_sortTabView reloadData];
            m=18;
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
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
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_searchWord,@"keyword",_areaID,@"regionId",_streetID,@"streetId",_typeID,@"mappingId",_rankID,@"sortType",@"1",@"page",@"20",@"pageSize",[NSString stringWithFormat:@"%@,%@",appdelegate.appLat,appdelegate.appLng],@"location",appdelegate.appCityID,@"cityId", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_DianPu_shopPage] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"shopPage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"shopPage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                    sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                    sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                    sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"];
                    sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                    sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"viewTimes"];
                    sortModel.score=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"score"];
                    sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"];
                    sortModel.isCanSeal=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"cooperation"] ;
                    
                    [_listModelArr addObject:sortModel];
                    
                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"shopPage"] objectForKey:@"list"];;
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
                        sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                        sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                        sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"];
                        sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                        sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                        sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"viewTimes"];
                        sortModel.score=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"score"];
                        sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"];
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_searchWord,@"keyword",_areaID,@"regionId",_streetID,@"streetId",_typeID,@"mappingId",_rankID,@"sortType",[NSString stringWithFormat:@"%d",pageNum],@"page",@"20",@"pageSize",[NSString stringWithFormat:@"%@,%@",appdelegate.appLat,appdelegate.appLng],@"location",appdelegate.appCityID,@"cityId", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_DianPu_shopPage] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if ([[[zaojiaoListDic objectForKey:@"shopPage"] objectForKey:@"list"] count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"shopPage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                sortModel.street=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"streetName"];
                sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"imgUrl"];
                sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"viewTimes"];
                sortModel.score=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"score"];
                sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"];
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
@end
