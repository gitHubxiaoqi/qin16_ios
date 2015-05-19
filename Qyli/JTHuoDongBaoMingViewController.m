//
//  JTHuoDongBaoMingViewController.m
//  Qyli
//
//  Created by 小七 on 14-12-8.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTHuoDongBaoMingViewController.h"
@interface JTHuoDongBaoMingViewController()<UITableViewDataSource,UITableViewDelegate>
{
    
    UILabel * _baobaoNameLab;
    UILabel * _baobaoSexLab;
    UILabel * _baobaoBrithdayLab;
    UILabel * _jiaoZhangNameLab;
    UILabel * _phoneLab;
    UILabel * _otherWordLab;
    UITableView * _tableView;
    NSArray * _titleArr;
}
@end

@implementation JTHuoDongBaoMingViewController
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _baobaoNameLab=[[UILabel alloc] init];
    _baobaoNameLab.frame=CGRectMake(self.view.frame.size.width-30-10-120,64+5, 120, 30);
    _baobaoNameLab.textAlignment=NSTextAlignmentRight;
    _baobaoNameLab.text=@"";
    _baobaoNameLab.font=[UIFont systemFontOfSize:15];
    [self.view  addSubview:_baobaoNameLab];
    
    _baobaoSexLab=[[UILabel alloc] init];
    _baobaoSexLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 64+40+5, 120, 30);
    _baobaoSexLab.textAlignment=NSTextAlignmentRight;
    _baobaoSexLab.text=@"";
    _baobaoSexLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_baobaoSexLab];
    
    _baobaoBrithdayLab=[[UILabel alloc] init];
    _baobaoBrithdayLab.frame=CGRectMake(self.view.frame.size.width-30-10-120,64+80+ 5, 120, 30);
    _baobaoBrithdayLab.textAlignment=NSTextAlignmentRight;
    _baobaoBrithdayLab.text=@"";
    _baobaoBrithdayLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_baobaoBrithdayLab];
    
    _jiaoZhangNameLab=[[UILabel alloc] init];
    _jiaoZhangNameLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 64+120+5, 120, 30);
    _jiaoZhangNameLab.textAlignment=NSTextAlignmentRight;
    _jiaoZhangNameLab.text=@"";
    _jiaoZhangNameLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_jiaoZhangNameLab];
    
    _phoneLab=[[UILabel alloc] init];
    _phoneLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 64+160+5, 120, 30);
    _phoneLab.textAlignment=NSTextAlignmentRight;
    _phoneLab.text=@"";
    _phoneLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_phoneLab];
    
    _otherWordLab=[[UILabel alloc] init];
    _otherWordLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 64+200+5, 120, 30);
    _otherWordLab.textAlignment=NSTextAlignmentRight;
    _otherWordLab.text=@"";
    _otherWordLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_otherWordLab];
    
    _titleArr=[[NSArray alloc] initWithObjects:@"宝宝姓名",@"宝宝性别",@"宝宝生日",@"家长姓名",@"联系电话",@"备注", nil];
    
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
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.view.bounds.size.width-60, 44)];
    navTitailLab.text=[NSString stringWithFormat:@"填写报名信息%@",self.title];
    navTitailLab.font=[UIFont systemFontOfSize:14];
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
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    //_tableView.tag=100;
    [self.view addSubview:_tableView];
    //_tableView.scrollEnabled=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    UIButton * tiJiaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    tiJiaoBtn.frame=CGRectMake(20, 64+240+20, self.view.frame.size.width-40, 30);
    tiJiaoBtn.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
    [tiJiaoBtn setTitle:@"立刻报名" forState:UIControlStateNormal];
    [tiJiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tiJiaoBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [tiJiaoBtn addTarget:self action:@selector(tiJiaoBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tiJiaoBtn];
    
    
    UIView * shadowView=[[UIView alloc] initWithFrame:self.view.frame];
    shadowView.tag=1000;
    shadowView.backgroundColor=[UIColor blackColor];
    shadowView.alpha=0.3;
    shadowView.hidden=YES;
    [self.view addSubview:shadowView];
    
    UIView * bgView1=[[UIView alloc] initWithFrame:CGRectMake(5, 100, self.view.frame.size.width-10, 150)];
    bgView1.backgroundColor=[UIColor whiteColor];
    bgView1.clipsToBounds=YES;
    bgView1.layer.rasterizationScale=3;
    bgView1.tag=1100;
    bgView1.hidden=YES;
    [self.view addSubview:bgView1];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, bgView1.frame.size.width, 30)];
    lab1.text=@"宝宝姓名";
    lab1.font=[UIFont systemFontOfSize:18];
    lab1.textAlignment=NSTextAlignmentCenter;
    [bgView1 addSubview:lab1];
    
    UIImageView * imgView1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 40, bgView1.frame.size.width-10*2, 40)];
    imgView1.image=[UIImage imageNamed:@"input_box_org.png"];
    [bgView1 addSubview:imgView1];
    
    UITextField * textField1=[[UITextField alloc] initWithFrame:CGRectMake(11, 41, bgView1.frame.size.width-11*2, 38)];
    textField1.placeholder=@"输入宝宝姓名";
    textField1.tag=1110;
    [bgView1 addSubview:textField1];
    
    UIButton * btn1_1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1_1.frame=CGRectMake(15, 105, (bgView1.frame.size.width-15*2-50)/2.0, 25);
    [btn1_1 setImage:[UIImage imageNamed:@"取消.png"] forState:UIControlStateNormal];
    [btn1_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1_1.tag=1120;
    [bgView1 addSubview:btn1_1];
    
    UIButton * btn1_2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1_2.frame=CGRectMake(15+(bgView1.frame.size.width-15*2-50)/2.0+50, 105, (bgView1.frame.size.width-15*2-50)/2.0, 25);
    [btn1_2 setImage:[UIImage imageNamed:@"确定.png"] forState:UIControlStateNormal];
    [btn1_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1_2.tag=1130;
    [bgView1 addSubview:btn1_2];
    
    
    UIView * bgView2=[[UIView alloc] initWithFrame:CGRectMake(5, 200, self.view.frame.size.width-10, 120)];
    bgView2.backgroundColor=[UIColor whiteColor];
    bgView2.clipsToBounds=YES;
    bgView2.layer.rasterizationScale=3;
    bgView2.tag=1200;
    bgView2.hidden=YES;
    [self.view addSubview:bgView2];
    
    UILabel * lab2=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, bgView1.frame.size.width, 30)];
    lab2.text=@"宝宝性别";
    lab2.font=[UIFont systemFontOfSize:18];
    lab2.textAlignment=NSTextAlignmentCenter;
    [bgView2 addSubview:lab2];
    
    UILabel * linelab2=[[UILabel alloc] initWithFrame:CGRectMake(10, 39, bgView2.frame.size.width-10*2, 1)];
    linelab2.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
    [bgView2 addSubview:linelab2];
    
    UIButton * btn2_1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2_1.frame=CGRectMake(0, 40, bgView2.frame.size.width, 40);
    [btn2_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2_1.tag=1210;
    [bgView2 addSubview:btn2_1];
    
    UILabel * lab2_1 =[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 30)];
    lab2_1.text=@"女孩";
    lab2_1.font=[UIFont systemFontOfSize:14];
    [btn2_1 addSubview:lab2_1];
    
    UIButton * btn2_2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2_2.frame=CGRectMake(0, 80, bgView2.frame.size.width, 40);
    [btn2_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2_2.tag=1220;
    [bgView2 addSubview:btn2_2];
    
    UILabel * lab2_2 =[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 30)];
    lab2_2.text=@"男孩";
    lab2_2.font=[UIFont systemFontOfSize:14];
    [btn2_2 addSubview:lab2_2];
    
    
    UIView * bgView3=[[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 296)];
    bgView3.tag=1300;
    bgView3.hidden=YES;
    bgView3.backgroundColor=[UIColor whiteColor];
    bgView3.clipsToBounds=YES;
    bgView3.layer.rasterizationScale=3;
    [self.view addSubview:bgView3];
    
    UILabel * beginLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    beginLab.backgroundColor=[UIColor whiteColor];
    beginLab.text=@"请选择宝宝生日";
    beginLab.textColor=[UIColor brownColor];
    beginLab.font=[UIFont systemFontOfSize:20];
    beginLab.textAlignment=NSTextAlignmentCenter;
    [bgView3 addSubview:beginLab];
    
    UIDatePicker * dataPicker1=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 216)];
    dataPicker1.tag=100;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    dataPicker1.locale = locale;
    dataPicker1.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
    dataPicker1.datePickerMode=UIDatePickerModeDate;
    [bgView3 addSubview:dataPicker1];
    
    
    UIButton * beginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    beginBtn.frame=CGRectMake(0, 256, self.view.frame.size.width, 40);
    beginBtn.backgroundColor=[UIColor whiteColor];
    [beginBtn setTitle:@"确    定" forState:UIControlStateNormal];
    [beginBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    beginBtn.titleLabel.font=[UIFont systemFontOfSize:22];
    beginBtn.tag=1310;
    [beginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:beginBtn];

    UIView * bgView4=[[UIView alloc] initWithFrame:CGRectMake(5, 100, self.view.frame.size.width-10, 150)];
    bgView4.backgroundColor=[UIColor whiteColor];
    bgView4.clipsToBounds=YES;
    bgView4.layer.rasterizationScale=3;
    bgView4.tag=1400;
    bgView4.hidden=YES;
    [self.view addSubview:bgView4];
    
    UILabel * lab4=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, bgView1.frame.size.width, 30)];
    lab4.text=@"家长姓名";
    lab4.font=[UIFont systemFontOfSize:18];
    lab4.textAlignment=NSTextAlignmentCenter;
    [bgView4 addSubview:lab4];
    
    UIImageView * imgView4=[[UIImageView alloc] initWithFrame:CGRectMake(10, 40, bgView1.frame.size.width-10*2, 40)];
    imgView4.image=[UIImage imageNamed:@"input_box_org.png"];
    [bgView4 addSubview:imgView4];
    
    UITextField * textField4=[[UITextField alloc] initWithFrame:CGRectMake(11, 41, bgView1.frame.size.width-11*2, 38)];
    textField4.placeholder=@"输入家长姓名";
    textField4.tag=1410;
    [bgView4 addSubview:textField4];
    
    UIButton * btn4_1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn4_1.frame=CGRectMake(15, 105, (bgView1.frame.size.width-15*2-50)/2.0, 25);
    [btn4_1 setImage:[UIImage imageNamed:@"取消.png"] forState:UIControlStateNormal];
    [btn4_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn4_1.tag=1420;
    [bgView4 addSubview:btn4_1];
    
    UIButton * btn4_2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn4_2.frame=CGRectMake(15+(bgView1.frame.size.width-15*2-50)/2.0+50, 105, (bgView1.frame.size.width-15*2-50)/2.0, 25);
    [btn4_2 setImage:[UIImage imageNamed:@"确定.png"] forState:UIControlStateNormal];
    [btn4_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn4_2.tag=1430;
    [bgView4 addSubview:btn4_2];
    
    UIView * bgView5=[[UIView alloc] initWithFrame:CGRectMake(5, 100, self.view.frame.size.width-10, 150)];
    bgView5.backgroundColor=[UIColor whiteColor];
    bgView5.clipsToBounds=YES;
    bgView5.layer.rasterizationScale=3;
    bgView5.tag=1500;
    bgView5.hidden=YES;
    [self.view addSubview:bgView5];
    
    UILabel * lab5=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, bgView1.frame.size.width, 30)];
    lab5.text=@"联系电话";
    lab5.font=[UIFont systemFontOfSize:18];
    lab5.textAlignment=NSTextAlignmentCenter;
    [bgView5 addSubview:lab5];
    
    UIImageView * imgView5=[[UIImageView alloc] initWithFrame:CGRectMake(10, 40, bgView1.frame.size.width-10*2, 40)];
    imgView5.image=[UIImage imageNamed:@"input_box_org.png"];
    [bgView5 addSubview:imgView5];
    
    UITextField * textField5=[[UITextField alloc] initWithFrame:CGRectMake(11, 41, bgView1.frame.size.width-11*2, 38)];
    textField5.placeholder=@"输入联系方式";
    textField5.tag=1510;
    [bgView5 addSubview:textField5];
    
    UIButton * btn5_1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn5_1.frame=CGRectMake(15, 105, (bgView1.frame.size.width-15*2-50)/2.0, 25);
    [btn5_1 setImage:[UIImage imageNamed:@"取消.png"] forState:UIControlStateNormal];
    [btn5_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn5_1.tag=1520;
    [bgView5 addSubview:btn5_1];
    
    UIButton * btn5_2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn5_2.frame=CGRectMake(15+(bgView1.frame.size.width-15*2-50)/2.0+50, 105, (bgView1.frame.size.width-15*2-50)/2.0, 25);
    [btn5_2 setImage:[UIImage imageNamed:@"确定.png"] forState:UIControlStateNormal];
    [btn5_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn5_2.tag=1530;
    [bgView5 addSubview:btn5_2];
    
    UIView * bgView6=[[UIView alloc] initWithFrame:CGRectMake(5, 100, self.view.frame.size.width-10, 150)];
    bgView6.backgroundColor=[UIColor whiteColor];
    bgView6.clipsToBounds=YES;
    bgView6.layer.rasterizationScale=3;
    bgView6.tag=1600;
    bgView6.hidden=YES;
    [self.view addSubview:bgView6];
    
    UILabel * lab6=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, bgView1.frame.size.width, 30)];
    lab6.text=@"备注";
    lab6.font=[UIFont systemFontOfSize:18];
    lab6.textAlignment=NSTextAlignmentCenter;
    [bgView6 addSubview:lab6];
    
    UIImageView * imgView6=[[UIImageView alloc] initWithFrame:CGRectMake(10, 40, bgView1.frame.size.width-10*2, 40)];
    imgView6.image=[UIImage imageNamed:@"input_box_org.png"];
    [bgView6 addSubview:imgView6];
    
    UITextField * textField6=[[UITextField alloc] initWithFrame:CGRectMake(11, 41, bgView1.frame.size.width-11*2, 38)];
    textField6.placeholder=@"输入备注";
    textField6.tag=1610;
    [bgView6 addSubview:textField6];
    
    UIButton * btn6_1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn6_1.frame=CGRectMake(15, 105, (bgView1.frame.size.width-15*2-50)/2.0, 25);
    [btn6_1 setImage:[UIImage imageNamed:@"取消.png"] forState:UIControlStateNormal];
    [btn6_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn6_1.tag=1620;
    [bgView6 addSubview:btn6_1];
    
    UIButton * btn6_2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn6_2.frame=CGRectMake(15+(bgView1.frame.size.width-15*2-50)/2.0+50, 105, (bgView1.frame.size.width-15*2-50)/2.0, 25);
    [btn6_2 setImage:[UIImage imageNamed:@"确定.png"] forState:UIControlStateNormal];
    [btn6_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn6_2.tag=1630;
    [bgView6 addSubview:btn6_2];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

       UITableViewCell * cell=[[UITableViewCell alloc] init];
        UILabel * titleNameLab=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, 30)];
       titleNameLab.text=[_titleArr objectAtIndex:indexPath.row];
        titleNameLab.font=[UIFont systemFontOfSize:15];
        [cell addSubview:titleNameLab];
        
        switch (indexPath.row)
        {
            case 0:
            {
                _baobaoNameLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 5, 120, 30);
                _baobaoNameLab.textAlignment=NSTextAlignmentRight;
                _baobaoNameLab.font=[UIFont systemFontOfSize:15];
                [cell addSubview:_baobaoNameLab];
            }
                break;
            case 1:
            {
                _baobaoSexLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 5, 120, 30);
                _baobaoSexLab.textAlignment=NSTextAlignmentRight;
                _baobaoSexLab.font=[UIFont systemFontOfSize:15];
                [cell addSubview:_baobaoSexLab];
            }
                break;
            case 2:
            {
                _baobaoBrithdayLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 5, 120, 30);
                _baobaoBrithdayLab.textAlignment=NSTextAlignmentRight;
                _baobaoBrithdayLab.font=[UIFont systemFontOfSize:15];
                [cell addSubview:_baobaoBrithdayLab];
            }
                break;
            case 3:
            {
                _jiaoZhangNameLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 5, 120, 30);
                _jiaoZhangNameLab.textAlignment=NSTextAlignmentRight;
                _jiaoZhangNameLab.font=[UIFont systemFontOfSize:15];
                [cell addSubview:_jiaoZhangNameLab];
            }
                break;
            case 4:
            {
                _phoneLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 5, 120, 30);
                _phoneLab.textAlignment=NSTextAlignmentRight;
                _phoneLab.font=[UIFont systemFontOfSize:15];
                [cell addSubview:_phoneLab];
            }
                break;
            case 5:
            {
                _otherWordLab.frame=CGRectMake(self.view.frame.size.width-30-10-120, 5, 120, 30);
                _otherWordLab.textAlignment=NSTextAlignmentRight;
                _otherWordLab.font=[UIFont systemFontOfSize:15];
                [cell addSubview:_otherWordLab];
            }
                break;
            default:
                break;
        }
        
        UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30, 15, 8, 10)];
         imgView.image=[UIImage imageNamed:@"右箭头.png"];
        [cell addSubview:imgView];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView * shadowView=[self.view viewWithTag:1000];
    shadowView.hidden=NO;
    
    UIView * bgView1=[self.view viewWithTag:1100];
    UIView * bgView2=[self.view viewWithTag:1200];
    UIView * bgView3=[self.view viewWithTag:1300];
    UIView * bgView4=[self.view viewWithTag:1400];
    UIView * bgView5=[self.view viewWithTag:1500];
    UIView * bgView6=[self.view viewWithTag:1600];
    switch (indexPath.row)
    {
        case 0:
        {
            bgView1.hidden=NO;
            [self.view bringSubviewToFront:bgView1];
        
        }
            break;
        case 1:
        {
            bgView2.hidden=NO;
            [self.view bringSubviewToFront:bgView2];
        }
            break;
        case 2:
        {
            bgView3.hidden=NO;
           [self.view bringSubviewToFront:bgView3];
        }
            break;
        case 3:
        {
            bgView4.hidden=NO;
            [self.view bringSubviewToFront:bgView4];
        }
            break;
        case 4:
        {
            bgView5.hidden=NO;
            [self.view bringSubviewToFront:bgView5];
        }
            break;
        case 5:
        {
            bgView6.hidden=NO;
            [self.view bringSubviewToFront:bgView6];
        }
            break;
            
        default:
            break;
    }

}
-(void)btnClick:(UIButton *)sender
{
    UITextField * textField1=(UITextField *)[self.view viewWithTag:1110];
    UITextField * textField4=(UITextField *)[self.view viewWithTag:1410];
    UITextField * textField5=(UITextField *)[self.view viewWithTag:1510];
    UITextField * textField6=(UITextField *)[self.view viewWithTag:1610];
    
    UIView * bgView1=[self.view viewWithTag:1100];
    UIView * bgView2=[self.view viewWithTag:1200];
    UIView * bgView3=[self.view viewWithTag:1300];
    UIView * bgView4=[self.view viewWithTag:1400];
    UIView * bgView5=[self.view viewWithTag:1500];
    UIView * bgView6=[self.view viewWithTag:1600];
    switch (sender.tag)
    {
        case 1120:
        {
            bgView1.hidden=YES;
        }
            break;
        case 1130:
        {
           
            if ([textField1.text isEqualToString:@""])
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，宝宝名字不能为空哦！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            else
            {
               _baobaoNameLab.text=textField1.text;
                [self.view bringSubviewToFront:_baobaoNameLab];
            }
          bgView1.hidden=YES;
        }
            break;
        case 1210:
        {
            bgView2.hidden=YES;
            _baobaoSexLab.text=@"女孩";
            [self.view bringSubviewToFront:_baobaoSexLab];
        }
            break;
        case 1220:
        {
            bgView2.hidden=YES;
            _baobaoSexLab.text=@"男孩";
            [self.view bringSubviewToFront:_baobaoSexLab];
        }
            break;
        case 1310:
        {
        
            UIDatePicker *dataPicker=(UIDatePicker *)[self.view viewWithTag:100];
            NSDate *select= [dataPicker date];
            if ([select compare:[NSDate date]]==NSOrderedDescending)
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"所选时间不合法" message:@"亲，请选择早于当前时间的某个时间" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            _baobaoBrithdayLab.text= [dateFormatter stringFromDate:select];
            [self.view bringSubviewToFront:_baobaoBrithdayLab];
            bgView3.hidden=YES;
        }
            break;
        case 1420:
        {
            bgView4.hidden=YES;
        }
            break;
        case 1430:
        {
          
            if ([textField4.text isEqualToString:@""])
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，家长名字不能为空哦！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            else
            {
                _jiaoZhangNameLab.text=textField4.text;
                [self.view bringSubviewToFront:_jiaoZhangNameLab];
            }
              bgView4.hidden=YES;
        }
            break;
        case 1520:
        {
            bgView5.hidden=YES;
        }
            break;
        case 1530:
        {
            if ([textField5.text isEqualToString:@""])
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，联系方式不能为空哦！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            else
            {
                _phoneLab.text=textField5.text;
                [self.view bringSubviewToFront:_phoneLab];
            }
            bgView5.hidden=YES;
        }
            break;
        case 1620:
        {
            bgView6.hidden=YES;
        }
            break;
        case 1630:
        {
            if ([textField6.text isEqualToString:@""])
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，说点儿什么吧！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            else
            {
                _otherWordLab.text=textField6.text;
                [self.view bringSubviewToFront:_otherWordLab];
            }
            bgView6.hidden=YES;
        }
            break;
            
        default:
            break;
    }
    UIView * shadowView=[self.view viewWithTag:1000];
    shadowView.hidden=YES;
    [self.view endEditing:YES];
}

-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tiJiaoBtn
{
    
    JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    if ([_baobaoNameLab.text isEqualToString:@""]||[_baobaoSexLab.text isEqualToString:@""]||[_baobaoBrithdayLab.text isEqualToString:@""]||[_jiaoZhangNameLab.text isEqualToString:@""]||[_phoneLab.text isEqualToString:@""]||[_otherWordLab.text isEqualToString:@""])
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"提交失败！" message:@"亲，请完整填写以上信息" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:@"atv",@"type",self.infoID,@"infoId",[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",_jiaoZhangNameLab.text,@"linkman",_phoneLab.text,@"tel",_baobaoNameLab.text,@"babyname",_baobaoBrithdayLab.text,@"babybirthday",_baobaoSexLab.text,@"babysex",_otherWordLab.text,@"message",@"",@"reservationTime", nil];
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KeCheng_SaveApplyAdd] jsonDic:jsondic]];
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            
            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"恭喜，报名成功！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

@end
