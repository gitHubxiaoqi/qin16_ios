
//
//  JTKeChengListViewController.m
//  Qyli
//
//  Created by 小七 on 14-11-3.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTKeChengListViewController.h"
#import "JTKeChengDetailViewController.h"
#import "JTKeChengListTabViewCell.h"

@interface JTKeChengListViewController ()<UITableViewDataSource,UITableViewDelegate>
@end
@implementation JTKeChengListViewController
{
    int p;
    int q;
    int m;
    UITableView * _tableView;
    UITableView * _areaTabView;
    UITableView * _streetTabView;
    UITableView * _xingzhiTabView;
    UITableView * _sortTabView;
    UITableView * _rankTabView;
    
    UITableView * _ageTabView;
    NSArray * _ageArr;
    NSString * _minMaxAgeStr;

    NSMutableArray * _quArr;
    NSMutableArray * _quIDArr;
    NSMutableArray * _streetArr;
    NSMutableArray * _streetIDArr;
    
    NSString * _areaID;
    NSString * _streetID;
    NSString * _searchWord;
    NSString * _typeID;
    NSString * _rankID;
    NSString * _cityID;
    
    int clickNum;
    int clickTypeNum;
    
    int pageNum;
    
    NSMutableArray * _listModelArr;
    NSMutableArray * _xingzhiTitleArr;
    NSMutableArray * _typeTitleArr;
    NSMutableArray * _typeTitleIDArr;
    NSArray * _xuanzeArr;
    
    NSArray * _distanceStrArr;
    NSArray * _distanceIDArr;
}

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
    _areaID=@"0";
    _typeID=@"0";
    _streetID=@"0";
    _rankID=@"DISTANCEASC";
    _minMaxAgeStr=@"0,18";
    clickNum=0;
    clickTypeNum=0;
    if (self.typeIDStr!=nil)
    {
        _typeID=self.typeIDStr;
    }
   
    
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

    
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    _xingzhiTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
    _typeTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
    _typeTitleIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    _ageArr=[[NSArray alloc] initWithObjects:@"0-3岁",@"3-6岁",@"6-9岁",@"9-12岁",@"12-15岁",@"15-18岁", nil];
    _distanceStrArr=[[NSArray alloc] initWithObjects:@"距离最近(默认)",@"评分最高",@"点击率最高",@"价格由低到高",@"价格由高到低", nil];
    _distanceIDArr=[[NSArray alloc] initWithObjects:@"DISTANCEASC",@"SCOREDESC",@"VIEWTIMESDESC",@"PRICEASC",@"PRICEDESC", nil];
    
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
    
    _xuanzeArr=[[NSArray alloc] initWithObjects:@"区域",@"类别",@"年龄",@"排序", nil];
    for (int i=0; i<4; i++)
    {
        UIButton * chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.frame=CGRectMake(i*(self.view.frame.size.width/4.0),64, self.view.frame.size.width/4.0, 40);
        chooseBtn.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:231.0/255.0 alpha:1.0];
        chooseBtn.tag=70+i;
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chooseBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        chooseBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        [chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:[_xuanzeArr objectAtIndex:i] forState:UIControlStateNormal];
        
        UIImageView * imgView=[[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"xiala_more.png"]];
        imgView.frame=CGRectMake(self.view.frame.size.width/4.0-10-4, 16, 10, 8);
        [chooseBtn addSubview:imgView];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4.0-0.5, 10, 0.5, 20)];
        lineLab.backgroundColor=[UIColor blackColor];
        lineLab.alpha=0.3;
        [chooseBtn addSubview:lineLab];
        [self.view addSubview:chooseBtn];
        
    }
    if ([self.typeIDStr isEqualToString:@"8,9,10,11,12,13"])
    {
        UIButton * typeBtn=(UIButton *)[self.view viewWithTag:71];
        [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [typeBtn setTitle:@"早教" forState:UIControlStateNormal];
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
    
    _xingzhiTabView=[[UITableView alloc] initWithFrame:CGRectMake(25, 64+40+30, self.view.frame.size.width-25*2, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _xingzhiTabView.tag=103;
    _xingzhiTabView.dataSource=self;
    _xingzhiTabView.delegate=self;
    [self.view addSubview:_xingzhiTabView];
    _xingzhiTabView.showsVerticalScrollIndicator=NO;
    
    _sortTabView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0, 64+40+30,self.view.frame.size.width/2.0-25, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _sortTabView.tag=104;
    _sortTabView.dataSource=self;
    _sortTabView.delegate=self;
    [self.view addSubview:_sortTabView];
    _sortTabView.showsVerticalScrollIndicator=NO;
    
    _rankTabView=[[UITableView alloc] initWithFrame:CGRectMake(25, 64+40+30, self.view.frame.size.width-25*2, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _rankTabView.tag=105;
    _rankTabView.dataSource=self;
    _rankTabView.delegate=self;
    [self.view addSubview:_rankTabView];
    _rankTabView.showsVerticalScrollIndicator=NO;
    

    
    _ageTabView=[[UITableView alloc] initWithFrame:CGRectMake(25,64+40+30, self.view.frame.size.width-25*2, self.view.frame.size.height-64-40-100) style:UITableViewStylePlain];
    _ageTabView.tag=106;
    _ageTabView.dataSource=self;
    _ageTabView.delegate=self;
    [self.view addSubview:_ageTabView];
    _ageTabView.showsVerticalScrollIndicator=NO;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.frame.size.width, self.view.frame.size.height-64-40-TAB_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tag=100;
    [_tableView addHeaderWithTarget:self action:@selector(CompanyListHeaderRefreshing)];
    [_tableView addFooterWithTarget:self  action:@selector(footerRefresh)];
    _tableView.headerRefreshingText =@HeaderRefreshingText;
    _tableView.footerRefreshingText=@FooterRefreshingText;
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
-(void)kip:(JTSortModel *)model
{
    JTKeChengDetailViewController * zjdVC=[[JTKeChengDetailViewController alloc] init];
    zjdVC.sortmodel=[[JTSortModel alloc] init];
    zjdVC.sortmodel=model;
    zjdVC.state=1;
    [self.navigationController pushViewController:zjdVC animated:YES];
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
            [self.view bringSubviewToFront:_xingzhiTabView];
        }
            break;
        case 2:
        {
            bgImgView.image=[UIImage imageNamed:@"third_pop_bg.9.png"];
            [self.view bringSubviewToFront:_tableView];
            [self.view bringSubviewToFront:bgImgView];
            [self.view bringSubviewToFront:_ageTabView];
            
        }
            break;
        case 3:
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
        case 3:
        {
            return _xingzhiTitleArr.count;
        }
            break;
        case 4:
        {
            if (_typeTitleArr.count==0)
            {
                return 0;
            }
            return [[_typeTitleArr objectAtIndex:clickTypeNum] count];
        }
            break;
        case 5:
        {
            return [_distanceIDArr count];
        }
            break;
        case 6:
        {
            return _ageArr.count;
        }
            break;
            
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
            if (model.street==nil||[model.street isEqualToString:@""])
            {
                model.street=@"";
            }
            if (model.infoAddress==nil||[model.infoAddress isEqualToString:@""])
            {
                model.infoAddress=@"";
            }
            NSString * adressStr=[NSString stringWithFormat:@"%@%@%@",model.quStr,model.street,model.infoAddress];
            CGSize size2=CGSizeMake(self.view.frame.size.width-20-85, MAXFLOAT);
            CGSize autoSize2=[adressStr boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
            if (autoSize2.height<20)
            {
                autoSize2.height=20;
            }
            return 115+autoSize2.height+10+10;
            
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
        JTKeChengListTabViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
        if (!customCell)
        {
            customCell=[[JTKeChengListTabViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
            customCell.selectionStyle=UITableViewCellSelectionStyleNone;
            customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
            
            UILabel * fenLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-10-20, 80, 10, 10)];
            fenLab.textColor=[UIColor grayColor];
            fenLab.font=[UIFont systemFontOfSize:12];
            fenLab.hidden=YES;
            fenLab.tag=1000;
            [customCell addSubview:fenLab];
        }
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


        if ([[NSString stringWithFormat:@"%@",model.distance] isEqualToString:@""]||model.distance==nil)
        {
            customCell.distanceLab.text=@"距离不详";
        }
        else
        {
            customCell.distanceLab.text=[NSString stringWithFormat:@"%.2fKm", [model.distance floatValue]];
        }

        
        customCell.fuTitleLab.text=model.fuName;
        CGSize fuTitleAutoSize=[model.fuName boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:customCell.fuTitleLab.font} context:nil].size;
        if (fuTitleAutoSize.width>self.view.frame.size.width-85-60)
        {
            fuTitleAutoSize.width=self.view.frame.size.width-85-60;
        }
        customCell.priceLab.frame=CGRectMake(85+fuTitleAutoSize.width, 30, 60, 30);
        if ([[NSString stringWithFormat:@"%@",model.cost] intValue]==0||model.cost==nil)
        {
          
            customCell.priceLab.text=@"暂无标价";
            customCell.priceLab.textColor=[UIColor lightGrayColor];
        }
        else
        {
   
            customCell.priceLab.text=[NSString stringWithFormat:@"￥%.1f",[model.cost floatValue]];
            customCell.priceLab.textColor=[UIColor redColor];
        }
        
        if ([[NSString stringWithFormat:@"%@",model.score] isEqualToString:@"0"]||model.score==nil)
        {
            customCell.scroeLab.frame=CGRectMake(self.view.frame.size.width-70-10, 65, 70, 40);
            customCell.scroeLab.text=@"暂无评价";
            customCell.scroeLab.textColor=[UIColor orangeColor];
            customCell.scroeLab.font=[UIFont systemFontOfSize:15];
            UILabel * lab=(UILabel *)[customCell viewWithTag:1000];
            lab.text=@"分";
            lab.hidden=YES;
        }
        else
        {
            customCell.scroeLab.frame=CGRectMake(self.view.frame.size.width-30-25, 65, 30, 40);
            float scroe=[model.score floatValue];
            customCell.scroeLab.text=[NSString stringWithFormat: @"%.1f",scroe];
            customCell.scroeLab.textColor=[UIColor redColor];
            customCell.scroeLab.font=[UIFont systemFontOfSize:18];
            UILabel * lab=(UILabel *)[customCell viewWithTag:1000];
            lab.text=@"分";
            lab.hidden=NO;
            
        }

        customCell.typeLab.text=[NSString stringWithFormat:@"课程类型:%@",model.type];
        customCell.ageLab.text=[NSString stringWithFormat:@"适合年龄:%@-%@岁",model.beginDate,model.endDate];
        if ([model.clickTime intValue]==0)
        {
            model.clickTime=@"机构";
        }
        else   if ([model.clickTime intValue]==0)
        {
            model.clickTime=@"私教";
        }
        customCell.clickNumLab.text=[NSString stringWithFormat:@"性质:%@",model.clickTime];
        
        if (model.street==nil||[model.street isEqualToString:@""])
        {
            model.street=@"";
        }
        if (model.infoAddress==nil||[model.infoAddress isEqualToString:@""])
        {
            model.infoAddress=@"";
        }
        customCell.quLab.text=[NSString stringWithFormat:@"%@%@%@",model.quStr,model.street,model.infoAddress];
        CGSize size2=CGSizeMake(self.view.frame.size.width-20-85, MAXFLOAT);
        CGSize autoSize2=[ customCell.quLab.text boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: customCell.quLab.font} context:nil].size;
        if (autoSize2.height<20)
        {
            autoSize2.height=20;
        }
        customCell.quLab.frame=CGRectMake(85, 115, self.view.frame.size.width-20-85,autoSize2.height);
        customCell.bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 115+autoSize2.height+10);

        
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
            case 3:
            {
                
                cell.textLabel.text=[_xingzhiTitleArr objectAtIndex:indexPath.row];
            }
                break;
            case 4:
            {
                cell.textLabel.text=[[_typeTitleArr objectAtIndex:clickTypeNum] objectAtIndex:indexPath.row];
            }
                break;
            case 5:
            {
        
                cell.textLabel.text=[_distanceStrArr objectAtIndex:indexPath.row];
            }
                break;
            case 6:
            {
                cell.textLabel.text=[_ageArr objectAtIndex:indexPath.row];
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
    UIButton * btn4=[UIButton buttonWithType:UIButtonTypeCustom];
    btn4=(UIButton *)[self.view viewWithTag:73];
    
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
        case 3:
        {
            
            if (indexPath.row==0)
            {
                [self.view bringSubviewToFront:_tableView];
                [btn2 setTitle:[_xuanzeArr objectAtIndex:btn2.tag-70] forState:UIControlStateNormal];
                btn2.titleLabel.font=[UIFont systemFontOfSize:18];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _typeID=@"0";
                [self sendPost];
            }
            else
            {
                [self.view bringSubviewToFront:_sortTabView];
                clickTypeNum=indexPath.row;
                [_sortTabView reloadData];
            }
            
        }
            break;
            
        case 4:
        {
            
            if (indexPath.row==0)
            {
                [btn2 setTitle:[_xingzhiTitleArr objectAtIndex:clickTypeNum] forState:UIControlStateNormal];
                NSMutableArray * typeArr=[[NSMutableArray alloc] initWithArray:[_typeTitleIDArr objectAtIndex:clickTypeNum]];
                NSMutableString * typeIDStr=[[NSMutableString alloc] init];
                [typeIDStr setString:@""];
                for (int i=1; i<typeArr.count; i++)
                {
                    NSString * str= [NSString stringWithFormat:@"%@",[typeArr objectAtIndex:i]];
                    [typeIDStr appendString:str];
                    [typeIDStr appendString:@","];
                }
                [typeIDStr deleteCharactersInRange:NSMakeRange(typeIDStr.length-1, 1)];
                _typeID=typeIDStr;
            }
            else
            {
                [btn2 setTitle:[[_typeTitleArr objectAtIndex:clickTypeNum] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                _typeID=[[_typeTitleIDArr objectAtIndex:clickTypeNum] objectAtIndex:indexPath.row];
            }
            
            btn2.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:_tableView];
            [self sendPost];
            
        }
            break;
        case 5:
        {
            if (indexPath.row==0)
            {
                [btn4 setTitle:[_xuanzeArr objectAtIndex:btn4.tag-70] forState:UIControlStateNormal];
                btn4.titleLabel.font=[UIFont systemFontOfSize:18];
                [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _rankID=@"DISTANCEASC";
            }
            else
            {
                [btn4 setTitle:[_distanceStrArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                btn4.titleLabel.font=[UIFont systemFontOfSize:13];
                [btn4 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                _rankID=[_distanceIDArr objectAtIndex:indexPath.row];
            }
            
            [self.view bringSubviewToFront:_tableView];
            [self sendPost];
        }
            break;
            
        case 6:
        {
            [btn3 setTitle:[_ageArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            btn3.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn3 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            switch (indexPath.row)
            {
                case 0:
                    _minMaxAgeStr=@"0,3";
                    break;
                case 1:
                    _minMaxAgeStr=@"3,6";
                    break;
                case 2:
                    _minMaxAgeStr=@"6,9";
                    break;
                case 3:
                    _minMaxAgeStr=@"9,12";
                    break;
                case 4:
                    _minMaxAgeStr=@"12,15";
                    break;
                case 5:
                    _minMaxAgeStr=@"15,18";
                    break;
                    
                default:
                    break;
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
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:@"课外教育",@"key", nil];
        
        NSDictionary * cityAreaDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_SJLM_getItems] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[cityAreaDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            
            [_xingzhiTitleArr addObject:@"不限"];
            
            NSMutableArray * nullArr=[[NSMutableArray alloc] init];
            NSMutableArray * nullIDArr=[[NSMutableArray alloc] init];
            [_typeTitleArr addObject:nullArr];
            [_typeTitleIDArr addObject:nullIDArr];
            
            [_xingzhiTitleArr addObjectsFromArray:[[cityAreaDic objectForKey:@"itemMap"] allKeys]];
            
            for(int i=1;i<[[cityAreaDic objectForKey:@"itemMap"] count]+1;i++)
            {
                NSMutableArray * midArr=[[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray * midIDArr=[[NSMutableArray alloc] initWithCapacity:0];
                [midArr addObject:@"不限"];
                [midIDArr addObject:@"any"];
                for (int j=0; j<[[[cityAreaDic objectForKey:@"itemMap"]  objectForKey:[_xingzhiTitleArr objectAtIndex:i]] count]; j++)
                {
                    NSString * streetStr=[[[[cityAreaDic objectForKey:@"itemMap"]  objectForKey:[_xingzhiTitleArr objectAtIndex:i]] objectAtIndex:j] objectForKey:@"itemValue"];
                    [midArr addObject:streetStr];
                    
                    NSString * streetIDStr=[[[[cityAreaDic objectForKey:@"itemMap"]  objectForKey:[_xingzhiTitleArr objectAtIndex:i]] objectAtIndex:j] objectForKey:@"id"];
                    [midIDArr addObject:streetIDStr];
                }
                
                [_typeTitleArr addObject:midArr];
                [_typeTitleIDArr addObject:midIDArr];
            }
            [_xingzhiTabView reloadData];
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_searchWord,@"name",_areaID,@"regionId",_streetID,@"streetId",_typeID,@"type",_minMaxAgeStr,@"ages",_rankID,@"sortType",@"1",@"page",[NSString stringWithFormat:@"%@,%@",appdelegate.appLat,appdelegate.appLng],@"location",appdelegate.appCityID,@"cityId", nil];
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KeCheng_coursePage] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"coursePage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];

                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"coursePage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"name"];
                    sortModel.score=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"score"];
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"institutionImage"];
                    sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                    sortModel.fuName=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"institutionName"];
                    if ([[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"])
                    {
                        NSArray * typearr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                        NSMutableString *typeStr=[[NSMutableString alloc] init];
                        [typeStr setString:@""];
                        for (int i=0; i<typearr.count; i++)
                        {
                            NSString *str=[typearr objectAtIndex:i];
                            [typeStr appendString:str];
                            [typeStr appendString:@"  "];
                        }
                        sortModel.type=typeStr;
                        
                    }
                    sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startAge"];
                    sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endAge"];
                    sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                    sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                    sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"cooperation"];
                    sortModel.isCanSeal=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"property"];
                    sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"] ;
                    
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
                        sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"institutionImage"];
                        sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                        sortModel.fuName=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"institutionName"];
                        if ([[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"])
                        {
                            NSArray * typearr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                            NSMutableString *typeStr=[[NSMutableString alloc] init];
                            [typeStr setString:@""];
                            for (int i=0; i<typearr.count; i++)
                            {
                                NSString *str=[typearr objectAtIndex:i];
                                [typeStr appendString:str];
                                [typeStr appendString:@"  "];
                            }
                            sortModel.type=typeStr;
                            
                        }
                        sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startAge"];
                        sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endAge"];
                        sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                        sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                        sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"cooperation"];
                        sortModel.isCanSeal=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"property"];
                        sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"] ;                        [_listModelArr insertObject:sortModel atIndex:0];
                
                        
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_searchWord,@"name",_areaID,@"regionId",_streetID,@"streetId",_typeID,@"type",_minMaxAgeStr,@"ages",_rankID,@"sortType",[NSString stringWithFormat:@"%d",pageNum],@"page",[NSString stringWithFormat:@"%@,%@",appdelegate.appLat,appdelegate.appLng],@"location",appdelegate.appCityID,@"cityId", nil];
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KeCheng_coursePage] jsonDic:jsondic]];
        
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
                sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"institutionImage"];
                sortModel.cost=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"price"];
                sortModel.fuName=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"institutionName"];
                
                if ([[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"])
                {
                    NSArray * typearr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"type"];
                    NSMutableString *typeStr=[[NSMutableString alloc] init];
                    [typeStr setString:@""];
                    for (int i=0; i<typearr.count; i++)
                    {
                        NSString *str=[typearr objectAtIndex:i];
                        [typeStr appendString:str];
                        [typeStr appendString:@"  "];
                    }
                    sortModel.type=typeStr;
                    
                }
                sortModel.beginDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"startAge"];
                sortModel.endDate=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"endAge"];
                sortModel.infoAddress=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"address"];
                sortModel.quStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"regionName"];
                sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"cooperation"];
                sortModel.isCanSeal=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"property"];
                sortModel.distance=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"distance"] ;                [_listModelArr addObject:sortModel];
    
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
