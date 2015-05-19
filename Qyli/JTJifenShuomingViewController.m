//
//  JTJifenShuomingViewController.m
//  清一丽
//
//  Created by 小七 on 15-2-14.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTJifenShuomingViewController.h"

@interface JTJifenShuomingViewController ()

@end

@implementation JTJifenShuomingViewController
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
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}
- (void)viewDidLoad {
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
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"我的积分帮助信息";
    navTitailLab.textAlignment=NSTextAlignmentCenter;
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:16];
    [navLab addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:leftBtn];
    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回按钮.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 10, 15);
    [leftBtn addSubview:backImgView];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(10, 20+NAV_HEIGHT, 100, 30)];
    lab1.text=@"怎样赚取积分";
    lab1.font=[UIFont systemFontOfSize:14];
    lab1.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab1];
    
    UIImageView * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"问号2.png"]];
    imgView1.frame=CGRectMake(10+CGRectGetWidth(lab1.frame), 20+NAV_HEIGHT+6, 18, 18);
    [self.view addSubview:imgView1];
    
    UILabel * bgLab1=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(lab1.frame)+20+NAV_HEIGHT, SCREEN_WIDTH-20, 25)];
    bgLab1.backgroundColor=[UIColor blackColor];
    bgLab1.alpha=0.2;
    [self.view addSubview:bgLab1];
    
    UILabel * lab2=[[UILabel alloc] initWithFrame:CGRectMake(10, 20+NAV_HEIGHT+CGRectGetHeight(lab1.frame), 120, 25)];
    lab2.text=@"1、什么是积分？";
    lab2.font=[UIFont systemFontOfSize:14];
    lab2.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab2];
    
    UILabel * shuomingLab1=[[UILabel alloc] initWithFrame:CGRectMake(10, 20+NAV_HEIGHT+CGRectGetHeight(lab1.frame)+CGRectGetHeight(lab2.frame)+5, self.view.frame.size.width-20,70)];
    shuomingLab1.numberOfLines=0;
    shuomingLab1.textColor=[UIColor grayColor];
    shuomingLab1.font=[UIFont systemFontOfSize:14];
    shuomingLab1.text=@"      积分是本网站对用户操作行为的回馈，用户在本网站进行规定操作即产生积分，操作行为不同，获得的积分多少不等。积分可以用来在本网站的积分商城兑换实物或者优惠券。";
    CGSize autoSize=[shuomingLab1.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:shuomingLab1.font} context:nil].size;
   shuomingLab1.frame=CGRectMake(10, 20+NAV_HEIGHT+CGRectGetHeight(lab1.frame)+CGRectGetHeight(lab2.frame)+5, self.view.frame.size.width-20,autoSize.height);
    [self.view addSubview:shuomingLab1];
    
    UILabel * bgLab2=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(lab1.frame)+20+NAV_HEIGHT+CGRectGetHeight(lab2.frame)+5+CGRectGetHeight(shuomingLab1.frame)+5, SCREEN_WIDTH-20, 25)];
    bgLab2.backgroundColor=[UIColor blackColor];
    bgLab2.alpha=0.2;
    [self.view addSubview:bgLab2];
    
    UILabel * lab3=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(lab1.frame)+20+NAV_HEIGHT+CGRectGetHeight(lab2.frame)+5+CGRectGetHeight(shuomingLab1.frame)+5,120, 25)];
    lab3.text=@"2、积分细则：";
    lab3.font=[UIFont systemFontOfSize:14];
    lab3.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab3];
    
    UILabel * shuomingLab=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(lab1.frame)+20+NAV_HEIGHT+CGRectGetHeight(lab2.frame)+5+CGRectGetHeight(shuomingLab1.frame)+5+CGRectGetHeight(lab3.frame)+5, SCREEN_WIDTH-20,240)];
    shuomingLab.numberOfLines=0;
    shuomingLab.textColor=[UIColor grayColor];
    shuomingLab.font=[UIFont systemFontOfSize:14];
    //shuomingLab.text=@"1、用户注册:+20\n2、邮箱认证:+10\n3、手机认证:+20\n4、上传头像:+3\n5、完善个人信息:+5\n6、发表评论:+5\n7、删除评论:-5\n8、每日签到:+5\n9、每日首次分享:+5\n10、待完善...";
    shuomingLab.text=@"1、注册成为网站会员即可获得20积分。一次性任务。\n2、网站会员绑定手机号可以获取20积分。一次性任务。\n3、网站会员绑定邮箱可以获取10积分。一次性任务。\n4、上传头像可获取3积分，完善个人信息可获取5积分。一次性任务。\n5、发表一次评论可获取5积分，评论被删除会扣除5积分。\n6、手机端每日签到可获取5积分。每天一次。\n7、分享网站相关信息到朋友圈可获取5积分。每天一次。";
    CGSize autoSize1=[shuomingLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:shuomingLab.font} context:nil].size;
    shuomingLab.frame=CGRectMake(10, CGRectGetHeight(lab1.frame)+20+NAV_HEIGHT+CGRectGetHeight(lab2.frame)+5+CGRectGetHeight(shuomingLab1.frame)+5+CGRectGetHeight(lab3.frame)+5, self.view.frame.size.width-20,autoSize1.height);
    [self.view addSubview:shuomingLab];
    
}
-(void)leftBtnCilck
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
