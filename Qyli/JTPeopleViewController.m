//
//  JTPeopleViewController.m
//  Qyli
//
//  Created by 小七 on 14-7-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTPeopleViewController.h"
#import "JTSignViewController.h"
#import "JTPersonalMegViewController.h"
#import "JTSettingViewController.h"
#import "JTMyhouseViewController.h"
#import "JTMycommentViewController.h"
#import "JTMyFatieListViewController.h"
#import "JTMyDaijinquanViewController.h"
#import "JTJifenShangchengViewController.h"
#import "JTRegisterViewController.h"


#import "WXApi.h"
//#import <TencentOpenAPI/QQApi.h>

@interface JTPeopleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tabView;
    
    NSArray * _titleArr;
    NSArray * _imgNameArr;

    
    UIView * view1;
    UILabel * lab1;
    UIImageView * photoImgView1;
    UILabel * lab1_2;
    UILabel * lab1_3;
    UIButton * btn1_2;

    UIView * view3;
}
@end

@implementation JTPeopleViewController

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
    
    [self readyUI];
    if (self.state==9)
    {
        
    }
    else
    {
        JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
        self.user=appDelegate.appUser;
        
        if ( [[[NSUserDefaults standardUserDefaults]objectForKey:@"isLogin"] intValue]==1)
        {

            view3.hidden=YES;
            [self.view bringSubviewToFront:view1];
            
            lab1.text=[NSString stringWithFormat:@"%@",self.user.userName];
            lab1_3.text=[NSString stringWithFormat:@"可用积分:%@",self.user.availablePoints];
            [photoImgView1 setImageWithURL:[NSURL URLWithString:self.user.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"头像.png"]];
            if (self.user.pointsTitle!=nil)
            {
                lab1_2.text=[NSString stringWithFormat:@"用户等级：%@",self.user.pointsTitle];
            }
            else
            {
                lab1_2.text=[NSString stringWithFormat:@"用户等级：%@",@"暂未开放"];
                
            }

            
        }
        else
        {
            view3.hidden=NO;
            [self.view bringSubviewToFront:view3];

        }

    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    _titleArr=@[@"我的个人信息",@"我的关注",@"我的点评",@"我的发帖",@"我的卡券包",@"积分商城",@"分享",@"设置"];
    // _smallTitleArr=@[@"我的点评历史",@"我收到的消息",@"我的曝光"];
 _imgNameArr=@[@"personal_info.png",@"my_faverite.png",@"my_comment_history.png",@"我的帖子.png",@"小代金券1.png",@"积分商城.png",@"share_icon.png",@"setting.png"];
//_smallImgNameArr=@[@"my_comment_history.png",@"personal_msg.png",@"personal_exposure.png"];
    

    self.user=[[JTUser alloc] init];
    
//    if ([WXApi isWXAppInstalled])
//    {
//        //判断是否有微信
//        NSLog(@"有微信");
//    }
//    
//    if ([QQApi isQQInstalled])
//    {
//        //判断是否有qq
//         NSLog(@"有QQ");
//    }
}
-(void)readyUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
  //会员登录
    view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT*3/10.0)];
    [self.view addSubview:view1];
    
    UIImageView *bgImgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人中心背景.png"]];
    bgImgView1.frame=CGRectMake(0, 0,SCREEN_WIDTH ,CGRectGetHeight(view1.frame));
    [view1 addSubview:bgImgView1];
    
    photoImgView1=[[UIImageView alloc] initWithFrame:CGRectMake(10, (CGRectGetHeight(view1.frame)-(SCREEN_WIDTH/4.0-20))/2.0, SCREEN_WIDTH/4.0-20, SCREEN_WIDTH/4.0-20)];
    photoImgView1.layer.masksToBounds=YES;
    photoImgView1.layer.cornerRadius=(SCREEN_WIDTH/4.0-20)/2.0;
    [view1 addSubview:photoImgView1];
    
    lab1= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(view1.frame)/4.0, 30, SCREEN_WIDTH*2/3.0,SCREEN_HEIGHT/10.0-20)];
    lab1.textColor=[UIColor whiteColor];
    lab1.font=[UIFont systemFontOfSize:24];
    [view1 addSubview:lab1];
    
    lab1_2= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(view1.frame)/4.0,SCREEN_HEIGHT/10.0+10, SCREEN_WIDTH*2/3.0-40, 20)];
    lab1_2.textColor=[UIColor whiteColor];
    lab1_2.font=[UIFont systemFontOfSize:16];
    [view1 addSubview:lab1_2];
    
    lab1_3= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(view1.frame)/4.0,SCREEN_HEIGHT/10.0+35, SCREEN_WIDTH*2/3.0-40, 20)];
    lab1_3.textColor=[UIColor whiteColor];
    lab1_3.font=[UIFont systemFontOfSize:16];
    [view1 addSubview:lab1_3];
    
    
    btn1_2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1_2 setImage:[UIImage imageNamed:@"签到.png"] forState:UIControlStateNormal];
    btn1_2.frame=CGRectMake(CGRectGetWidth(view1.frame)/4.0, SCREEN_HEIGHT/5.0+15, 80, 23);
    [btn1_2 addTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn1_2];
    
    UIImageView *imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"送积分.png"]];
    imgView1.frame=CGRectMake(CGRectGetWidth(view1.frame)/4.0+90,SCREEN_HEIGHT/5.0+15,SCREEN_WIDTH*3/4.0-110 ,SCREEN_HEIGHT/10.0-20);
    [view1 addSubview:imgView1];

    //尚未登录

    view3=[[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-TAB_HEIGHT)];
    view3.backgroundColor=BG_COLOR;
    view3.hidden=YES;
    [self.view addSubview:view3];
    
    UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景.png"]];
    bgImgView.frame=CGRectMake(0, 0,SCREEN_WIDTH,CGRectGetHeight(view3.frame)-100);
    [view3 addSubview:bgImgView];
   
    UIButton * loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(0, CGRectGetHeight(view3.frame)-100,(SCREEN_WIDTH-1)/2.0, 44);
    loginBtn.backgroundColor=[UIColor whiteColor];
    [loginBtn setTitle:@"登  录"  forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:22];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:loginBtn];
    
    UIButton * registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake((SCREEN_WIDTH-1)/2.0+1, CGRectGetHeight(view3.frame)-100,(SCREEN_WIDTH-1)/2.0, 44);
    registerBtn.backgroundColor=[UIColor whiteColor];
    [registerBtn setTitle:@"注  册"  forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:22];
    [registerBtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:registerBtn];
    
    if ([WXApi isWXAppInstalled])
    {
        //判断是否有微信
        NSLog(@"有微信");
        NSArray * imgNameArr=[[NSArray alloc] initWithObjects:@"QQ.png",@"微信.png",@"新浪微博.png", nil];
        for (int i=0; i<3; i++)
        {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:[imgNameArr objectAtIndex:i]] forState:UIControlStateNormal];
            btn.tag=50+i;
            [btn addTarget:self action:@selector(disanfang:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame=CGRectMake(SCREEN_WIDTH/3.0*i, CGRectGetHeight(view3.frame)-55, SCREEN_WIDTH/3.0, 55);
            [view3 addSubview:btn];
        }

    }
    else
    {
         NSLog(@"无微信");
        NSArray * imgNameArr=[[NSArray alloc] initWithObjects:@"QQ2.png",@"新浪微博2.png", nil];
        for (int i=0; i<2; i++)
        {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:[imgNameArr objectAtIndex:i]] forState:UIControlStateNormal];
            if(i==0)
            {
              btn.tag=50;
            }
            else
            {
             btn.tag=52;
            }
            [btn addTarget:self action:@selector(disanfang:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame=CGRectMake(SCREEN_WIDTH/2.0*i, CGRectGetHeight(view3.frame)-55, SCREEN_WIDTH/2.0, 55);
            [view3 addSubview:btn];
        }
    }
    
   
    _tabView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(view1.frame),SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(view1.frame)-NAV_HEIGHT) style:UITableViewStylePlain];
    _tabView.dataSource=self;
    _tabView.delegate=self;
    _tabView.sectionHeaderHeight=15;
    _tabView.tag=104;
    _tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabView];

}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sign
{
    JTSignViewController * signVC=[[JTSignViewController alloc] init];
    [self.navigationController pushViewController:signVC animated:YES];
}
-(void)goLogin
{
    JTLoginViewController * loginVC=[[JTLoginViewController alloc] init];
    loginVC.peopleVC=self;
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)goRegister
{
    JTRegisterViewController * registerVC=[[JTRegisterViewController alloc] init];
    [self presentViewController:registerVC animated:YES completion:nil];
}
-(void)disanfang:(UIButton *)sender
{
    switch (sender.tag-50)
    {
        case 0:
        {
            NSLog(@"QQ登录");
            [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
             {
                 if (result)
                 {
                       NSLog(@"&&&&&&&&&&&&&&&&&&&%@",[userInfo class]);//SSQZoneUser
                     NSLog(@"&&&&&&&&&&&&&&&&&&&-%@-%@-%@-%d",[userInfo uid],[userInfo nickname],[userInfo profileImage],[userInfo gender]);
                     
                     if ([SOAPRequest checkNet])
                     {
                         NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[userInfo uid],@"openid",[userInfo nickname],@"nickname",[NSString stringWithFormat:@"%d",[userInfo gender]],@"gender",[userInfo profileImage],@"figureurl_qq_2",nil];
                         
                         NSDictionary * dic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_QQLogin] jsonDic:jsondic]];
                         
                         if ([[dic objectForKey:@"resultCode"] intValue]==1000)
                         {
                             NSString * str=@"登录成功，正在跳转个人中心...";
                             [JTAlertViewAnimation startAnimation:str view:self.view];
                             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             JTAppDelegate * appdelegate=[[UIApplication sharedApplication] delegate];
                             
                             NSDictionary * userDic=[dic objectForKey:@"user"];
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
                             
                             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                             [[NSUserDefaults standardUserDefaults] setObject:appdelegate.appUser.loginName forKey:@"loginName"];
                             [[NSUserDefaults standardUserDefaults] setObject:appdelegate.appUser.password forKey:@"password"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"] isEqualToString:@"1"])
                             {
                                 [APService setAlias:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                             }
                             appdelegate.appUser=self.user;
                             view3.hidden=YES;
                             [self.view bringSubviewToFront:view1];
                             
                             lab1.text=[NSString stringWithFormat:@"%@",self.user.userName];
                             lab1_3.text=[NSString stringWithFormat:@"可用积分:%@",self.user.availablePoints];
                             [photoImgView1 setImageWithURL:[NSURL URLWithString:self.user.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"头像.png"]];
                             if (self.user.pointsTitle!=nil)
                             {
                                 lab1_2.text=[NSString stringWithFormat:@"用户等级：%@",self.user.pointsTitle];
                             }
                             else
                             {
                                 lab1_2.text=[NSString stringWithFormat:@"用户等级：%@",@"暂未开放"];
                                 
                             }
                             UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录成功！" delegate:nil cancelButtonTitle:nil   otherButtonTitles:@"OK，我知道了。。", nil];
                             [alertView show];
                             [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:appdelegate.appUser.EMuserLoginName password:appdelegate.appUser.EMuserLoginName
                          completion:
                              ^(NSDictionary *loginInfo, EMError *error) {
                                  //[self hideHud];
                                  if (loginInfo && !error) {
                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                                      //发送自动登陆状态通知
                                      [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                                      //将旧版的coredata数据导入新的数据库
                                      EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                                      if (!error) {
                                          error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                          
                                      }
                                  }else {
                                      switch (error.errorCode) {
                                          case EMErrorServerNotReachable:
                                              TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                                              break;
                                          case EMErrorServerAuthenticationFailure:
                                              TTAlertNoTitle(error.description);
                                              break;
                                          case EMErrorServerTimeout:
                                              TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                                              break;
                                          default:
                                              TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Logon failure"));
                                              break;
                                      }
                                  }
                              } onQueue:nil];
                         }
                         else
                         {
                             NSString * str=@"服务器异常，请稍后重试...";
                             [JTAlertViewAnimation startAnimation:str view:self.view];
                         }
                      }
  
                 }else
                 {
                     NSString * str=@"授权失败，请检查网络设置或稍后再试...";
                     [JTAlertViewAnimation startAnimation:str view:self.view];
                 }
             }];

        }
            break;
        case 1:
        {
             NSLog(@"微信登录");
            [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
             {
                 if (result)
                 {
                     
                     NSLog(@"&&&&&&&&&*******-----%@",[userInfo class]);//SSWeChatUser
                     NSLog(@"&&&&&&&&&&&&&&&&&&&%@-%@-%@-----%d",[userInfo uid],[userInfo nickname],[userInfo profileImage],[userInfo gender]);
                     
                     if ([SOAPRequest checkNet])
                     {
                         NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[userInfo uid],@"openid",[userInfo nickname],@"nickname",[NSString stringWithFormat:@"%d",[userInfo gender]],@"sex",[userInfo profileImage],@"headimgurl",nil];
                         
                         NSDictionary * dic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_WeixinLogin] jsonDic:jsondic]];
                         
                         if ([[dic objectForKey:@"resultCode"] intValue]==1000)
                         {
                             NSString * str=@"登录成功，正在跳转个人中心...";
                             [JTAlertViewAnimation startAnimation:str view:self.view];
                             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             JTAppDelegate * appdelegate=[[UIApplication sharedApplication] delegate];
                             
                             NSDictionary * userDic=[dic objectForKey:@"user"];
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
                             
                             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                             
                             [[NSUserDefaults standardUserDefaults] setObject:appdelegate.appUser.loginName forKey:@"loginName"];
                             [[NSUserDefaults standardUserDefaults] setObject:appdelegate.appUser.password forKey:@"password"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"] isEqualToString:@"1"])
                             {
                                 [APService setAlias:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                             }
                             appdelegate.appUser=self.user;
                              view3.hidden=YES;
                              [self.view bringSubviewToFront:view1];
                              
                              lab1.text=[NSString stringWithFormat:@"%@",self.user.userName];
                              lab1_3.text=[NSString stringWithFormat:@"可用积分:%@",self.user.availablePoints];
                              [photoImgView1 setImageWithURL:[NSURL URLWithString:self.user.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"头像.png"]];
                              if (self.user.pointsTitle!=nil)
                              {
                                  lab1_2.text=[NSString stringWithFormat:@"用户等级：%@",self.user.pointsTitle];
                              }
                              else
                              {
                                  lab1_2.text=[NSString stringWithFormat:@"用户等级：%@",@"暂未开放"];
                                  
                              }
                             UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录成功！" delegate:nil cancelButtonTitle:nil   otherButtonTitles:@"OK，我知道了。。", nil];
                             [alertView show];
                             [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:appdelegate.appUser.EMuserLoginName password:appdelegate.appUser.EMuserLoginName
                                   completion: ^(NSDictionary *loginInfo, EMError *error) {
                                  //[self hideHud];
                                  if (loginInfo && !error) {
                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                                      //发送自动登陆状态通知
                                      [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                                      //将旧版的coredata数据导入新的数据库
                                      EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                                      if (!error) {
                                          error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                          
                                      }
                                  }else {
                                      switch (error.errorCode) {
                                          case EMErrorServerNotReachable:
                                              TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                                              break;
                                          case EMErrorServerAuthenticationFailure:
                                              TTAlertNoTitle(error.description);
                                              break;
                                          case EMErrorServerTimeout:
                                              TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                                              break;
                                          default:
                                              TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Logon failure"));
                                              break;
                                      }
                                  }
                              } onQueue:nil];
                         }
                         else
                         {
                             NSString * str=@"服务器异常，请稍后重试...";
                             [JTAlertViewAnimation startAnimation:str view:self.view];
                         }
                     }
                 }
                 else
                 {
                 
                     NSString * str=@"授权失败，请检查网络设置或稍后再试...";
                     [JTAlertViewAnimation startAnimation:str view:self.view];
                 }
             }];

        }
            break;
        case 2:
        {
             NSLog(@"新浪微博登录");
            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
            {
                if (result)
                {
                    NSLog(@"&&&&&&&&&*******-----%@",[userInfo class]);//SSSinaWeiboUser
                    NSLog(@"&&&&&&&&&&&&&&&&&&&%@-%@-%@-%d",[userInfo uid],[userInfo nickname],[userInfo profileImage],[userInfo gender]);
                                           
                    if ([SOAPRequest checkNet])
                    {
                        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[userInfo uid],@"uid",[userInfo nickname],@"screen_name",[NSString stringWithFormat:@"%d",[userInfo gender]],@"gender",[userInfo profileImage],@"profile_image_url",nil];
                        
                        NSDictionary * dic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_SinaLogin] jsonDic:jsondic]];
                        
                        if ([[dic objectForKey:@"resultCode"] intValue]==1000)
                        {
                            NSString * str=@"登录成功，正在跳转个人中心...";
                            [JTAlertViewAnimation startAnimation:str view:self.view];
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            JTAppDelegate * appdelegate=[[UIApplication sharedApplication] delegate];
                            
                            NSDictionary * userDic=[dic objectForKey:@"user"];
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
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:appdelegate.appUser.loginName forKey:@"loginName"];
                            [[NSUserDefaults standardUserDefaults] setObject:appdelegate.appUser.password forKey:@"password"];
                            
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"] isEqualToString:@"1"])
                            {
                                [APService setAlias:[NSString stringWithFormat:@"%d",appdelegate.appUser.userID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                            }
                            appdelegate.appUser=self.user;
                            view3.hidden=YES;
                            [self.view bringSubviewToFront:view1];
                            
                            lab1.text=[NSString stringWithFormat:@"%@",self.user.userName];
                            lab1_3.text=[NSString stringWithFormat:@"可用积分:%@",self.user.availablePoints];
                            [photoImgView1 setImageWithURL:[NSURL URLWithString:self.user.headPortraitImgUrlStr] placeholderImage:[UIImage imageNamed:@"头像.png"]];
                            if (self.user.pointsTitle!=nil)
                            {
                                lab1_2.text=[NSString stringWithFormat:@"用户等级：%@",self.user.pointsTitle];
                            }
                            else
                            {
                                lab1_2.text=[NSString stringWithFormat:@"用户等级：%@",@"暂未开放"];
                                
                            }
                            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录成功！" delegate:nil cancelButtonTitle:nil   otherButtonTitles:@"OK，我知道了。。", nil];
                            [alertView show];
                            
                            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:appdelegate.appUser.EMuserLoginName password:appdelegate.appUser.EMuserLoginName                                                                              completion:
                             ^(NSDictionary *loginInfo, EMError *error) {
                                 //[self hideHud];
                                 if (loginInfo && !error) {
                                     [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                                     //发送自动登陆状态通知
                                     [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                                     //将旧版的coredata数据导入新的数据库
                                     EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                                     if (!error) {
                                         error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                         
                                     }
                                 }else {
                                     switch (error.errorCode) {
                                         case EMErrorServerNotReachable:
                                             TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                                             break;
                                         case EMErrorServerAuthenticationFailure:
                                             TTAlertNoTitle(error.description);
                                             break;
                                         case EMErrorServerTimeout:
                                             TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                                             break;
                                         default:
                                             TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Logon failure"));
                                             break;
                                     }
                                 }
                             } onQueue:nil];
                        }
                        else
                        {
                            NSString * str=@"服务器异常，请稍后重试...";
                            [JTAlertViewAnimation startAnimation:str view:self.view];
                        }
                    }
                }
                else
                {
                    NSString * str=@"授权失败，请检查网络设置或稍后再试...";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
            }];

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return  _titleArr.count;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] init];
    view.backgroundColor=[UIColor lightGrayColor];
    view.alpha=0.3;
    return view;
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(40, 12, 200, 20)];
    lab.font=[UIFont systemFontOfSize:14];
    lab.textColor=[UIColor grayColor];
    [cell addSubview:lab];
    UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
    [cell addSubview:imgView];
    UIImageView * imgView2=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 15, 8, 10)];
    imgView2.image=[UIImage imageNamed:@"右箭头.png"];
    [cell addSubview:imgView2];
    
    lab.text=[_titleArr objectAtIndex:indexPath.section] ;
    imgView.image=[UIImage imageNamed:[_imgNameArr objectAtIndex:indexPath.section]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
          switch (indexPath.section)
        {
            case 0:
            {
                JTPersonalMegViewController * pVC=[[JTPersonalMegViewController alloc] init];
               // pVC.peopleVC=self;
                [self.navigationController pushViewController:pVC animated:YES];
            }
                break;
            case 1:
            {
                JTMyhouseViewController * myVC=[[JTMyhouseViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];
            }
                break;
            case 2:
            {
                JTMycommentViewController * myCoVc= [[JTMycommentViewController alloc] init];
                [self.navigationController pushViewController:myCoVc animated:YES];
            }
                break;
            case 3:
            {
                JTMyFatieListViewController * tieVC=[[JTMyFatieListViewController alloc] init];
                [self.navigationController pushViewController:tieVC animated:YES];
            }
                break;
            case 4:
            {
                JTMyDaijinquanViewController * myCoVc= [[JTMyDaijinquanViewController alloc] init];
                [self.navigationController pushViewController:myCoVc animated:YES];
            }
                break;
//            case 4:
//            {
//                JTMyHuodongQuanViewController * myCoVc= [[JTMyHuodongQuanViewController alloc] init];
//                [self.navigationController pushViewController:myCoVc animated:YES];
//            }
                break;
            case 5:
            {
                JTJifenShangchengViewController * myCoVc= [[JTJifenShangchengViewController alloc] init];
                [self.navigationController pushViewController:myCoVc animated:YES];
            }
                break;
            case 6:
            {
                
                NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"iTunesArtwork@2x" ofType:@"jpg"];
                
                NSString * shareUrlStr=@"http://www.qin16.com";
                //构造分享内容
                id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"清一丽儿童网 立志打造南京最全面的儿童门户网站找辅导、买东西。惊喜连连，和你身边朋友一起分享%@",shareUrlStr] defaultContent:@"默认分享内容，没内容时显示" image:[ShareSDK imageWithPath:imagePath] title:@"#清一丽#门户网站特约分享" url:shareUrlStr description:[NSString stringWithFormat:@"我在#清一丽#发现了N条信息：清一丽儿童网 立志打造南京最全面的儿童门户网站找辅导、买东西。惊喜连连，和你身边朋友一起分享，很不错哦！%@",shareUrlStr] mediaType:SSPublishContentMediaTypeNews];
                
                [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions: nil
                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
                 {
              
                     if (state == SSResponseStateSuccess)
                     {
                         NSString * str=@"分享成功！";
                         // [JTAlertViewAnimation startAnimation:str view:self.view];
                         UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
                         [alertView show];
                         JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
                         NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",nil];
                         [SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Share_UserShareAfter] jsonDic:jsondic];
                     }
                     else if (state == SSResponseStateFail)
                     {
                         
                         NSString * str=[NSString stringWithFormat:@"分享失败！原因为：%@",[error errorDescription]];
                         //[JTAlertViewAnimation startAnimation:str view:self.view];
                         UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
                         [alertView show];
                     }
                     
                 }];
            }
                break;
            case 7:
            {
                JTSettingViewController * setVC=[[JTSettingViewController alloc] init];
                [self.navigationController pushViewController:setVC animated:YES];

            }
                break;
            default:
                break;
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
