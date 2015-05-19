//
//  JTSignViewController.m
//  Qyli
//
//  Created by 小七 on 14-9-19.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTSignViewController.h"

@interface JTSignViewController ()

@end

@implementation JTSignViewController

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
    [self readyUI];
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
   
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"签到有礼";
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

    
    UIImageView * imgView=[[UIImageView alloc] init];
    imgView.frame=CGRectMake(60, 80, self.view.frame.size.width-60*2, self.view.frame.size.width-60*2);
    imgView.tag=20;
    [self.view addSubview:imgView];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag=30;
    btn.frame=imgView.frame;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIImageView * myImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钱袋.png"]];
    myImgView.frame=CGRectMake(100, self.view.frame.size.width-60*2+80+40,  self.view.frame.size.width-100*2,  self.view.frame.size.width-100*2);
    [self.view addSubview:myImgView];

    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100*2-80)/2.0, (self.view.frame.size.width-100*2-20)/2.0, 80, 20)];
    lab1.text=@"我的积分";
    lab1.textColor=[UIColor whiteColor];
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.font=[UIFont systemFontOfSize:18];
    lab1.backgroundColor=[UIColor clearColor];
    [myImgView addSubview:lab1];
    
    UILabel * scoreLab=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100*2-80)/2.0, (self.view.frame.size.width-100*2-20)/2.0+30, 80, 20)];
    scoreLab.tag=10;
    scoreLab.textColor=[UIColor whiteColor];
    scoreLab.textAlignment=NSTextAlignmentCenter;
    scoreLab.font=[UIFont systemFontOfSize:18];
    scoreLab.backgroundColor=[UIColor clearColor];
    [myImgView addSubview:scoreLab];
    

}
-(void)readyUI
{
    [self getNewUser];
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    UIImageView * imgView=(UIImageView *)[self.view viewWithTag:20];
    UIButton * btn=(UIButton *)[self.view viewWithTag:30];
    UILabel * scoreLab=(UILabel *)[self.view viewWithTag:10];
    if ([[NSString stringWithFormat:@"%@",appdelegate.appUser.isSignin] isEqualToString:@"0"])
    {
        imgView.image=[UIImage imageNamed:@"大圆-橙色.png"];
        [btn setEnabled:YES];
    }
    else if ([[NSString stringWithFormat:@"%@",appdelegate.appUser.isSignin] isEqualToString:@"1"])
    {
        imgView.image=[UIImage imageNamed:@"大圆-灰色.png"];
        [btn setEnabled:NO];
    }
    scoreLab.text=[NSString stringWithFormat:@"%@",appdelegate.appUser.points];
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClick
{
    NSLog(@"签到");
    UILabel * scroreLab=(UILabel *)[self.view viewWithTag:10];
    UIImageView * imgView=(UIImageView *)[self.view viewWithTag:20];
    UIButton * btn=(UIButton *)[self.view viewWithTag:30];
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
  
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId", nil];
        
        NSDictionary * signDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_MobileCustomerUserOperation_DoSignin] jsonDic:jsondic]];

        if ([[NSString stringWithFormat:@"%@",[signDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            NSString * str=@"恭喜，签到成功！";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            [self getNewUser];
            JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
            scroreLab.text=[NSString stringWithFormat:@"%@",appdelegate.appUser.points];
            imgView.image=[UIImage imageNamed:@"大圆-灰色.png"];
            [btn setEnabled:NO];
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }
    
}
-(void)getNewUser
{
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID],@"userId", nil];
        
        NSDictionary * signDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_GetUserInfoByIdURL] jsonDic:jsondic]];

        if ([[NSString stringWithFormat:@"%@",[signDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            NSDictionary * userDic=[signDic objectForKey:@"user"];
            
            appdelegate.appUser.userID=[[userDic objectForKey:@"id"] intValue];
            appdelegate.appUser.loginName=[userDic objectForKey:@"loginName"];
            appdelegate.appUser.password=[userDic objectForKey:@"password"];
            appdelegate.appUser.userName=[userDic objectForKey:@"userName"];
            NSString * sexStr=[userDic objectForKey:@"sex"];
            if ([sexStr isEqualToString:@"MALE"])
            {
                appdelegate.appUser.sex=0;//男
            }
            else if ([sexStr isEqualToString:@"FEMALE"])
            {
                appdelegate.appUser.sex=1;//女
            }
            appdelegate.appUser.headPortraitImgUrlStr=[userDic objectForKey:@"imageValue"];
            appdelegate.appUser.email=[userDic objectForKey:@"email"];
            appdelegate.appUser.phone=[userDic objectForKey:@"tel"];
            appdelegate.appUser.provinceID=[[userDic objectForKey:@"provinceId"] intValue];
            appdelegate.appUser.cityID=[[userDic objectForKey:@"cityId"] intValue];
            appdelegate.appUser.regionId=[[userDic objectForKey:@"regionId"] intValue];
            appdelegate.appUser.streetId=[[userDic objectForKey:@"streetId"] intValue];
            appdelegate.appUser.address=[userDic objectForKey:@"address"];
            appdelegate.appUser.isContinuous=[userDic objectForKey:@"continuous"];
            appdelegate.appUser.points=[userDic objectForKey:@"points"];
            appdelegate.appUser.availablePoints=[userDic objectForKey:@"availablePoints"];
            appdelegate.appUser.pointsTitle=[userDic objectForKey:@"pointsTitle"];
            
            appdelegate.appUser.provinceValue=[userDic objectForKey:@"provinceName"];
            appdelegate.appUser.cityValue=[userDic objectForKey:@"cityName"];
            appdelegate.appUser.regionName=[userDic objectForKey:@"regionName"];
            appdelegate.appUser.streetName=[userDic objectForKey:@"streetName"];
            appdelegate.appUser.isSignin=[userDic objectForKey:@"signinFlag"];
            appdelegate.appUser.EMuserLoginName=[userDic objectForKey:@"easemobUsername"];
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
