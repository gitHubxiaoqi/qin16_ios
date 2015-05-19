//
//  JTKnowLedgeListViewController.m
//  清一丽
//
//  Created by 小七 on 14-12-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTKnowLedgeListViewController.h"
#import "JTKnowLedgeListTableViewCell.h"
#import "JTKnowledgeDetailViewController.h"
@interface JTKnowLedgeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@end
@implementation JTKnowLedgeListViewController
{
    int p;
    int q;
    UITableView * _tableView;
    UITableView * _xingzhiTabView;
    UITableView * _sortTabView;
    UITableView * _rankTabView;
    NSString * _searchWord;
    NSString * _typeID;
    NSString * _rankID;
    int clickTypeNum;
    int pageNum;
    NSMutableArray * _listModelArr;
    NSMutableArray * _xingzhiTitleArr;
    NSMutableArray * _typeTitleArr;
    NSMutableArray * _typeTitleIDArr;
    NSArray * _xuanzeArr;
    NSArray * _distanceStrArr;
    NSArray * _distanceIDArr;
    NSArray * _bigTypeIDArray;
    NSString * _ageTypeStr;
}

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
    _ageTypeStr=@"";
    _searchWord=@"";
    _typeID=self.typeIDStr;
    _rankID=@"BILLDATEDESC";
    clickTypeNum=0;
    _listModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    _xingzhiTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
   _xingzhiTitleArr =[NSMutableArray arrayWithObjects:@"不限",@"婴儿期",@"幼儿期",@"学龄前",@"小学生",@"中学生", nil];
    
    NSArray * arr1=[[NSArray alloc] initWithObjects:@"不限",@"日常护理",@"健康疾病",@"饮食营养",@"行为心理", nil];
    NSArray * arr2=[[NSArray alloc] initWithObjects:@"不限",@"家庭教育",@"行为习惯",@"健康疾病", nil];
    NSArray * arr3=[[NSArray alloc] initWithObjects:@"不限",@"启蒙教育",@"习惯个性",@"感冒发烧", nil];
    NSArray * arr4=[[NSArray alloc] initWithObjects:@"不限",@"初级教育",@"才艺培养",@"兴趣爱好",@"成长发育", nil];
    NSArray * arr5=[[NSArray alloc] initWithObjects:@"不限",@"中级教育",@"成长发育", nil];
    
    NSArray * arrid1=[[NSArray alloc] initWithObjects:@"",@"100",@"101",@"102",@"103", nil];
    NSArray * arrid2=[[NSArray alloc] initWithObjects:@"",@"104",@"105",@"106", nil];
    NSArray * arrid3=[[NSArray alloc] initWithObjects:@"",@"107",@"108",@"109", nil];
    NSArray * arrid4=[[NSArray alloc] initWithObjects:@"",@"110",@"111",@"112",@"113", nil];
    NSArray * arrid5=[[NSArray alloc] initWithObjects:@"",@"114",@"115", nil];
    
    _typeTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
    _typeTitleIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray * nullArr=[[NSArray alloc] init];
     NSArray * nullidArr=[[NSArray alloc] init];
    [_typeTitleArr addObject:nullArr];
    [_typeTitleArr addObject:arr1];
    [_typeTitleArr addObject:arr2];
    [_typeTitleArr addObject:arr3];
    [_typeTitleArr addObject:arr4];
    [_typeTitleArr addObject:arr5];
    
    [_typeTitleIDArr addObject:nullidArr];
    [_typeTitleIDArr addObject:arrid1];
    [_typeTitleIDArr addObject:arrid2];
    [_typeTitleIDArr addObject:arrid3];
    [_typeTitleIDArr addObject:arrid4];
    [_typeTitleIDArr addObject:arrid5];
    
    _distanceStrArr=[[NSArray alloc] initWithObjects:@"发布时间(默认)",@"点击率最高", nil];
    _distanceIDArr=[[NSArray alloc] initWithObjects:@"BILLDATEDESC",@"VIEWS", nil];

    _bigTypeIDArray=[[NSArray alloc]initWithObjects:@"",@"95",@"96",@"97",@"98",@"99", nil];
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
    
    
     _xuanzeArr=[[NSArray alloc] initWithObjects:@"类别",@"排序", nil];
    for (int i=0; i<2; i++)
    {
        UIButton * chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.frame=CGRectMake(10+i*((self.view.frame.size.width-20)/2.0),64, (self.view.frame.size.width-20)/2.0, 40);
        chooseBtn.tag=70+i;
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chooseBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        chooseBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        [chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn setTitle:[_xuanzeArr objectAtIndex:i] forState:UIControlStateNormal];
        
        UIImageView * imgView=[[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"xiala_more.png"]];
        imgView.frame=CGRectMake((self.view.frame.size.width-20)/2.0-10-4, 16, 10, 8);
        [chooseBtn addSubview:imgView];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-20)/2.0-0.5, 10, 0.5, 20)];
        lineLab.backgroundColor=[UIColor blackColor];
        lineLab.alpha=0.3;
        [chooseBtn addSubview:lineLab];
        [self.view addSubview:chooseBtn];
        
    }
    
    switch ([self.typeIDStr intValue])
    {
        case 95:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"婴儿期" forState:UIControlStateNormal];
            _ageTypeStr=@"ages";
        }
            break;
        case 96:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"幼儿期" forState:UIControlStateNormal];
            _ageTypeStr=@"ages";
        }
            break;
        case 97:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"学龄前" forState:UIControlStateNormal];
            _ageTypeStr=@"ages";
        }
            break;
        case 98:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"小学生" forState:UIControlStateNormal];
            _ageTypeStr=@"ages";
        }
            break;
        case 99:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"中学生" forState:UIControlStateNormal];
            _ageTypeStr=@"ages";
        }
            break;
        case 100:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"婴儿期-日常护理" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 101:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"婴儿期-健康疾病" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 102:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"婴儿期-饮食营养" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 103:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"婴儿期-行为心理" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 104:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"幼儿期-家庭教育" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 105:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"幼儿期-行为习惯" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 106:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"幼儿期-健康疾病" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 107:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"学龄前-启蒙教育" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 108:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"学龄前-习惯个性" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 109:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"学龄前-感冒发烧" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 110:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"小学生-初级教育" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 111:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"小学生-才艺培养" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 112:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"小学生-兴趣爱好" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 113:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"小学生-成长发育" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 114:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"中学生-中级教育" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
        case 115:
        {
            UIButton * typeBtn=(UIButton *)[self.view viewWithTag:70];
            [typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            typeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [typeBtn setTitle:@"中学生-成长发育" forState:UIControlStateNormal];
            _ageTypeStr=@"type";
        }
            break;
            
        default:
            break;
    }
    
    
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
    
    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.frame.size.width, self.view.frame.size.height-64-40) style:UITableViewStylePlain];
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
   [self.navigationController popViewControllerAnimated:YES];
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
            [self.view bringSubviewToFront:_xingzhiTabView];
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
-(void)kip:(JTSortModel *)model
{
    JTKnowledgeDetailViewController * zjdVC=[[JTKnowledgeDetailViewController alloc] init];
    zjdVC.sortmodel=[[JTSortModel alloc] init];
    zjdVC.sortmodel=model;
    [self.navigationController pushViewController:zjdVC animated:YES];
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
            return _distanceStrArr.count;
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
            return 110;
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
        JTKnowLedgeListTableViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
        if (!customCell)
        {
            customCell=[[JTKnowLedgeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
            customCell.selectionStyle=UITableViewCellSelectionStyleNone;
            customCell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        }
        JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
        [customCell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
        
        customCell.titleLab.text=model.title;
        
        if ([model.type isEqualToString:@""]||model.type==nil)
        {
            customCell.typeLab.text=@"暂无数据";
        }
        else
        {
            customCell.typeLab.text=[NSString stringWithFormat:@"类型：%@",model.type];
        }
        
        if ([model.age isEqualToString:@""]||model.age==nil)
        {
            customCell.ageLab.text=@"暂无数据";
        }
        else
        {
            customCell.ageLab.text=[NSString stringWithFormat:@"年龄：%@",model.age];
        }
        
        if ([[NSString stringWithFormat:@"%@",model.clickTime] isEqualToString:@""]||model.clickTime==nil)
        {
            customCell.clickLab.text=[NSString stringWithFormat:@"点击率:%@次",@"0"];
        }
        else
        {
           customCell.clickLab.text=[NSString stringWithFormat:@"点击率:%@次",model.clickTime];
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
                
            default:
                break;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton * btn2=(UIButton *)[self.view viewWithTag:70];
    UIButton * btn3=(UIButton *)[self.view viewWithTag:71];
    switch (tableView.tag-100)
    {
        case 0:
        {
            JTSortModel * model=[_listModelArr objectAtIndex:indexPath.row];
            [self kip:model];
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
                _typeID=@"";
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
                _typeID=[_bigTypeIDArray objectAtIndex:clickTypeNum];
                _ageTypeStr=@"ages";
            }
            else
            {
                [btn2 setTitle:[NSString stringWithFormat:@"%@-%@",[_xingzhiTitleArr objectAtIndex:clickTypeNum],[[_typeTitleArr objectAtIndex:clickTypeNum] objectAtIndex:indexPath.row] ]forState:UIControlStateNormal];
                _typeID=[[_typeTitleIDArr objectAtIndex:clickTypeNum] objectAtIndex:indexPath.row];
                _ageTypeStr=@"type";
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
                [btn3 setTitle:[_xuanzeArr objectAtIndex:btn3.tag-70] forState:UIControlStateNormal];
                btn3.titleLabel.font=[UIFont systemFontOfSize:18];
                [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _rankID=@"BILLDATEDESC";
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
        NSDictionary * jsondic=[[NSDictionary alloc]init];
        if ([_ageTypeStr isEqualToString:@"ages"])
        {
            jsondic=[NSDictionary dictionaryWithObjectsAndKeys:_searchWord,@"name",_typeID,_ageTypeStr,@"",@"type",_rankID,@"sortType",@"1",@"page", nil];
        }
        else if ([_ageTypeStr isEqualToString:@"type"])
        {
            jsondic=[NSDictionary dictionaryWithObjectsAndKeys:_searchWord,@"name",_typeID,_ageTypeStr,@"",@"ages",_rankID,@"sortType",@"1",@"page", nil];
        }
        else if ([_ageTypeStr isEqualToString:@""])
        {
            jsondic=[NSDictionary dictionaryWithObjectsAndKeys:_searchWord,@"name",_typeID,@"type",@"",@"ages",_rankID,@"sortType",@"1",@"page", nil];
        }
        
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KnowLedge_knowledgePage] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if (q==3)
            {
                if ([[[zaojiaoListDic objectForKey:@"knowledgePage"] objectForKey:@"totalCount"] intValue]==0)
                {
                    NSString * str=@"未找到符合条件的数据！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                    return;
                }
                NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"knowledgePage"] objectForKey:@"list"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    JTSortModel * sortModel=[[JTSortModel alloc] init];
                    sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                    sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"title"];
                    sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"typeName"];
                    sortModel.age=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"ageName"];
                    sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"views"];
                    sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"image"];
                    [_listModelArr addObject:sortModel];

                }
                q=6;
            }
            else
            {
                NSArray * zaojiaoListArr=[zaojiaoListDic objectForKey:@"result"];
                for (int i=0; i<zaojiaoListArr.count; i++)
                {
                    NSString * idStr=[NSString stringWithFormat:@"%@",[[zaojiaoListArr objectAtIndex:i] objectForKey:@"dataKey"]];
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
                        sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"title"];
                        sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"typeName"];
                        sortModel.age=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"ageName"];
                        sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"views"];
                        sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"image"];
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
        
        NSDictionary * jsondic=[[NSDictionary alloc]init];
        if ([_ageTypeStr isEqualToString:@"ages"])
        {
            jsondic=[NSDictionary dictionaryWithObjectsAndKeys:_searchWord,@"name",_typeID,_ageTypeStr,@"",@"type",_rankID,@"sortType",[NSString stringWithFormat:@"%d",pageNum],@"page", nil];
        }
        else if ([_ageTypeStr isEqualToString:@"type"])
        {
            jsondic=[NSDictionary dictionaryWithObjectsAndKeys:_searchWord,@"name",_typeID,_ageTypeStr,@"",@"ages",_rankID,@"sortType",[NSString stringWithFormat:@"%d",pageNum],@"page", nil];
        }
        else if ([_ageTypeStr isEqualToString:@""])
        {
            jsondic=[NSDictionary dictionaryWithObjectsAndKeys:_searchWord,@"name",_typeID,@"type",@"",@"ages",_rankID,@"sortType",[NSString stringWithFormat:@"%d",pageNum],@"page", nil];
        }
        
        
        NSDictionary * zaojiaoListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KnowLedge_knowledgePage] jsonDic:jsondic]];
        
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            if ([[[zaojiaoListDic objectForKey:@"knowledgePage"] objectForKey:@"list"]count]==0)
            {
                NSString * str=@"已全部加载完毕！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                pageNum--;
                return;
            }
            NSArray * zaojiaoListArr=[[zaojiaoListDic objectForKey:@"knowledgePage"] objectForKey:@"list"];
            for (int i=0; i<zaojiaoListArr.count; i++)
            {
                JTSortModel * sortModel=[[JTSortModel alloc] init];
                sortModel.idStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"id"];
                sortModel.title=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"title"];
                sortModel.type=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"typeName"];
                sortModel.age=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"ageName"];
                sortModel.clickTime=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"views"];
                sortModel.imgUrlStr=[[zaojiaoListArr objectAtIndex:i] objectForKey:@"image"];
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
