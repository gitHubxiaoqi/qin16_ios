//
//  JTKnowledgeHeadpageViewcontroller.m
//  清一丽
//
//  Created by 小七 on 15-1-6.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTKnowledgeHeadpageViewcontroller.h"
#import "JTKnowLedgeListViewController.h"
@interface JTKnowledgeHeadpageViewcontroller()
{

}
@end

@implementation JTKnowledgeHeadpageViewcontroller
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
    navTitailLab.text=[NSString stringWithFormat:@"育儿宝典"];
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
    
    UIScrollView * bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 130*5);
    [self.view addSubview:bigScrollView];
    
    NSArray * arr=[[NSArray alloc] initWithObjects:@"婴儿期.png",@"幼儿期.png",@"学龄前.png",@"小学生.png",@"中学生.png", nil];
    NSArray * arr1=[[NSArray alloc] initWithObjects:@"日常护理.png",@"健康疾病.png",@"营养饮食.png",@"行为心理.png", nil];
    NSArray * arr11=[[NSArray alloc] initWithObjects:@"日常护理",@"健康疾病",@"营养饮食",@"行为心理", nil];
    NSArray * arr2=[[NSArray alloc] initWithObjects:@"家庭教育.png",@"行为习惯.png",@"健康疾病.png", nil];
    NSArray * arr22=[[NSArray alloc] initWithObjects:@"家庭教育",@"行为习惯",@"健康疾病", nil];
    NSArray * arr3=[[NSArray alloc] initWithObjects:@"启蒙教育.png",@"习惯个性.png",@"感冒发烧.png",nil];
    NSArray * arr33=[[NSArray alloc] initWithObjects:@"启蒙教育",@"习惯个性",@"感冒发烧",nil];
    NSArray * arr4=[[NSArray alloc] initWithObjects:@"初级教育.png",@"才艺培养.png",@"兴趣爱好.png",@"成长发育.png", nil];
    NSArray * arr44=[[NSArray alloc] initWithObjects:@"初级教育",@"才艺培养",@"兴趣爱好",@"成长发育", nil];
    NSArray * arr5=[[NSArray alloc] initWithObjects:@"中级教育.png",@"成长发育.png", nil];
    NSArray * arr55=[[NSArray alloc] initWithObjects:@"中级教育",@"成长发育", nil];

    for (int i=0; i<5; i++)
    {
        UIButton * bigBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        bigBtn.frame=CGRectMake(0, 130*i, self.view.frame.size.width, 30);
        [bigBtn setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
        bigBtn.tag=95+i;
        [bigBtn addTarget:self action:@selector(bigBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bigScrollView addSubview:bigBtn];
    }
    
    for (int i=0; i<4; i++)
    {
        UIButton * bigBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
        bigBtn1.frame=CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15, 50, 50);
        [bigBtn1 setBackgroundImage:[UIImage imageNamed:[arr1 objectAtIndex:i]] forState:UIControlStateNormal];
        bigBtn1.tag=100+i;
        [bigBtn1 addTarget:self action:@selector(bigBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bigScrollView addSubview:bigBtn1];
        
        UILabel *lab1=[[UILabel alloc] initWithFrame:CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+50, 50, 20)];
        lab1.font=[UIFont systemFontOfSize:12];
        lab1.textColor=[UIColor brownColor];
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.text=[arr11 objectAtIndex:i];
        [bigScrollView addSubview:lab1];
    }
    
    for (int i=0; i<3; i++)
    {
        UIButton * bigBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
        bigBtn2.frame=CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+130, 50, 50);
        [bigBtn2 setBackgroundImage:[UIImage imageNamed:[arr2 objectAtIndex:i]] forState:UIControlStateNormal];
        bigBtn2.tag=104+i;
        [bigBtn2 addTarget:self action:@selector(bigBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bigScrollView addSubview:bigBtn2];
        
        UILabel *lab2=[[UILabel alloc] initWithFrame:CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+130+50, 50, 20)];
        lab2.font=[UIFont systemFontOfSize:12];
        lab2.textColor=[UIColor brownColor];
        lab2.textAlignment=NSTextAlignmentCenter;
        lab2.text=[arr22 objectAtIndex:i];
        [bigScrollView addSubview:lab2];
    }
    
    for (int i=0; i<3; i++)
    {
        UIButton * bigBtn3=[UIButton buttonWithType:UIButtonTypeCustom];
        bigBtn3.frame=CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+130+130, 50, 50);
        [bigBtn3 setBackgroundImage:[UIImage imageNamed:[arr3 objectAtIndex:i]] forState:UIControlStateNormal];
        bigBtn3.tag=107+i;
        [bigBtn3 addTarget:self action:@selector(bigBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bigScrollView addSubview:bigBtn3];
        
        UILabel *lab3=[[UILabel alloc] initWithFrame:CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+130+130+50, 50, 20)];
        lab3.font=[UIFont systemFontOfSize:12];
        lab3.textColor=[UIColor brownColor];
        lab3.textAlignment=NSTextAlignmentCenter;
        lab3.text=[arr33 objectAtIndex:i];
        [bigScrollView addSubview:lab3];
    }
    
    for (int i=0; i<4; i++)
    {
        UIButton * bigBtn4=[UIButton buttonWithType:UIButtonTypeCustom];
        bigBtn4.frame=CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+130+130+130, 50, 50);
        [bigBtn4 setBackgroundImage:[UIImage imageNamed:[arr4 objectAtIndex:i]] forState:UIControlStateNormal];
        bigBtn4.tag=110+i;
        [bigBtn4 addTarget:self action:@selector(bigBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bigScrollView addSubview:bigBtn4];
        
        UILabel *lab4=[[UILabel alloc] initWithFrame:CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+130+130+130+50, 50, 20)];
        lab4.font=[UIFont systemFontOfSize:12];
        lab4.textColor=[UIColor brownColor];
        lab4.textAlignment=NSTextAlignmentCenter;
        lab4.text=[arr44 objectAtIndex:i];
        [bigScrollView addSubview:lab4];
    }
    
    for (int i=0; i<2; i++)
    {
        UIButton * bigBtn5=[UIButton buttonWithType:UIButtonTypeCustom];
        bigBtn5.frame=CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+130+130+130+130, 50, 50);
        [bigBtn5 setBackgroundImage:[UIImage imageNamed:[arr5 objectAtIndex:i]] forState:UIControlStateNormal];
        bigBtn5.tag=114+i;
        [bigBtn5 addTarget:self action:@selector(bigBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bigScrollView addSubview:bigBtn5];
        
        UILabel *lab5=[[UILabel alloc] initWithFrame:CGRectMake(10+(self.view.frame.size.width-200-20)/8.0+i*((self.view.frame.size.width-200-20)/4.0+50), 30+15+130+130+130+130+50, 50, 20)];
        lab5.font=[UIFont systemFontOfSize:12];
        lab5.textColor=[UIColor brownColor];
        lab5.textAlignment=NSTextAlignmentCenter;
        lab5.text=[arr55 objectAtIndex:i];
        [bigScrollView addSubview:lab5];
    }
    
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)bigBtn:(UIButton *)sender
{
    JTKnowLedgeListViewController * knowVC=[[JTKnowLedgeListViewController alloc] init];
    knowVC.typeIDStr=[NSString stringWithFormat:@"%d",sender.tag];
    [self.navigationController pushViewController:knowVC animated:YES];

}


@end
