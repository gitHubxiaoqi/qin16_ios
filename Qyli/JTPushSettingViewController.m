//
//  JTPushSettingViewController.m
//  清一丽
//
//  Created by 小七 on 15-3-11.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTPushSettingViewController.h"

@interface JTPushSettingViewController ()

@end

@implementation JTPushSettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
    
    UISwitch * switch1=(UISwitch *)[self.view viewWithTag:100];
    UISwitch * switch2=(UISwitch *)[self.view viewWithTag:101];
    UISwitch * switch3=(UISwitch *)[self.view viewWithTag:102];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isPush"] isEqualToString:@"0"])
    {
        switch1.on=YES;
    }
    else
    {
        switch1.on=NO;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"] isEqualToString:@"0"])
    {
        switch2.on=YES;
    }
    else
    {
        switch2.on=NO;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isNight"] isEqualToString:@"0"])
    {
        switch3.on=YES;
    }
    else
    {
        switch3.on=NO;
    }
    NSLog(@"isPush%@isShopush%@isNight%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isPush"],[[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"],[[NSUserDefaults standardUserDefaults] objectForKey:@"isNight"]);
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
    self.view.backgroundColor=[UIColor colorWithRed:221.0/255.0 green:221.0/255.0  blue:221.0/255.0  alpha:1];
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航条
    
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"推送设置";
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
    
    NSArray * titleArr=[[NSArray alloc] initWithObjects:@"不接收任何推送消息",@"不接收商家推送消息",@"仅白天接收消息", nil];
    
    for (int i=0; i<3; i++)
    {
        UILabel *bgLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 20+NAV_HEIGHT+10+i*50, SCREEN_WIDTH, 40)];
        bgLab.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:bgLab];
        
        UILabel * titleLab=[[UILabel alloc] initWithFrame:CGRectMake(10,20+NAV_HEIGHT+10+10+i*50, 150,20)];
        titleLab.font=[UIFont systemFontOfSize:15];
        titleLab.textColor=[UIColor brownColor];
        titleLab.text=[titleArr objectAtIndex:i];
        titleLab.backgroundColor=[UIColor clearColor];
        [self.view addSubview:titleLab];
        
        UISwitch * swich=[[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 20+NAV_HEIGHT+10+5+i*50, 50, 30)];
        swich.tag=100+i;
        [swich addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:swich];
    }
    

    
}
-(void)switchClick:(UISwitch *)sender
{
    switch (sender.tag-100)
    {
        case 0:
        {
            if (sender.on==YES)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[UIApplication sharedApplication] unregisterForRemoteNotifications];
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                {
                    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
                    
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
                else
                {
                    //这里还是原来的代码
                    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                     (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
                }

            }
        }
            break;
        case 1:
        {
            if (sender.on==YES)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isShopPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [APService setAlias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isShopPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
               [APService setAlias:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            }
            
        }
            break;
        case 2:
        {
             JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            if (sender.on==YES)
            {
                if ([SOAPRequest checkNet])
                {
                    NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",@"3",@"flag", nil];
                    
                    NSDictionary * dic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_NoPush_OnlyDayReceiveMessage] jsonDic:jsondic]];
                    
                    if ([[dic objectForKey:@"resultCode"] intValue]==1001)
                    {
                        NSString * str=@"服务器异常，设置失败，请稍后再试";
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                        sender.on=NO;
                    }
                    else  if ([[dic objectForKey:@"resultCode"] intValue]==1000)

                    {
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isNight"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }
            else
            {
                if ([SOAPRequest checkNet])
                {
                    NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",@"0",@"flag", nil];
                    
                    NSDictionary * dic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_NoPush_OnlyDayReceiveMessage] jsonDic:jsondic]];
                    
                    if ([[dic objectForKey:@"resultCode"] intValue]==1001)
                    {
                        NSString * str=@"服务器异常，设置失败，请稍后再试";
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                        sender.on=YES;
                    }
                    else  if ([[dic objectForKey:@"resultCode"] intValue]==1000)

                    {
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isNight"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }

            }
        }
            break;
            
        default:
            break;
    }

}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
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
