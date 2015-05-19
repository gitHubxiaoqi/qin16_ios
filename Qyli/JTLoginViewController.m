//
//  JTLoginViewController.m
//  Qyli
//
//  Created by 小七 on 14-7-31.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTLoginViewController.h"

#import "JTFindPsdViewController.h"


@interface JTLoginViewController ()<UITextFieldDelegate>
{
    UIImageView * _nameImgView;
    UIImageView * _psdImgView;
    UIScrollView * _bigScrollView;
}

@end

@implementation JTLoginViewController

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
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(50, 12, 100, 20)];
    navTitailLab.text=@"登录";
    navTitailLab.textColor=[UIColor whiteColor];
    navTitailLab.font=[UIFont systemFontOfSize:20];
    [navLab addSubview:navTitailLab];
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 80, NAV_HEIGHT);
    [leftBtn addTarget:self action:@selector(leftBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:leftBtn];
    

    
    UIImageView * backImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"]];
    backImgView.frame=CGRectMake(20, (NAV_HEIGHT-15)/2, 15, 15);
    [leftBtn addSubview:backImgView];
    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-20-NAV_HEIGHT)];
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame));
    [self.view addSubview:_bigScrollView];
    
    UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录页面背景.png"]];
    bgImgView.frame=CGRectMake(0, 0,SCREEN_WIDTH,CGRectGetHeight(_bigScrollView.frame)-185);
    [_bigScrollView addSubview:bgImgView];
    
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2.0, CGRectGetHeight(_bigScrollView.frame)-180, 60, 40)];
    lab1.text=@"账号";
    lab1.font=[UIFont systemFontOfSize:22];
    [_bigScrollView addSubview:lab1];
    
    //用户名和密码
    _nameImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"输入条1.png"]];
    _nameImgView.frame=CGRectMake((SCREEN_WIDTH-240)/2.0+60, CGRectGetHeight(_bigScrollView.frame)-150, 180, 5);
    [_bigScrollView addSubview:_nameImgView];
    
    _nameTextField=[[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2.0+65,CGRectGetHeight(_bigScrollView.frame)-175, 170, 30)];
    _nameTextField.delegate=self;
    _nameTextField.font=[UIFont systemFontOfSize:14];
    _nameTextField.placeholder=@"输入用户名/邮箱/手机号";
    //[_nameTextField becomeFirstResponder];
    [_bigScrollView addSubview:_nameTextField];
    
    UILabel * lab2=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2.0,CGRectGetHeight(_bigScrollView.frame)-130, 60, 40)];
    lab2.text=@"密码";
    lab2.font=[UIFont systemFontOfSize:22];
    [_bigScrollView addSubview:lab2];
    
    _psdImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"输入条2.png"]];
    _psdImgView.frame=CGRectMake((SCREEN_WIDTH-240)/2.0+60, CGRectGetHeight(_bigScrollView.frame)-100, 180, 5);
    [_bigScrollView addSubview:_psdImgView];
    
    _psdTextField=[[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2.0+65,  CGRectGetHeight(_bigScrollView.frame)-125, 170, 30)];
    _psdTextField.delegate=self;
    _psdTextField.font=[UIFont systemFontOfSize:14];
    _psdTextField.secureTextEntry=YES;
    _psdTextField.placeholder=@"输入登录密码";
    [_bigScrollView addSubview:_psdTextField];
    
    UIButton * findBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame=CGRectMake(SCREEN_WIDTH-120,CGRectGetHeight(_bigScrollView.frame)-220,110, 30);
    [findBtn addTarget:self action:@selector(findPsd) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    findBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [findBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bigScrollView addSubview:findBtn];
    
    UIButton * loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake((SCREEN_WIDTH-240)/2.0, CGRectGetHeight(_bigScrollView.frame)-70, 240,50);
    [loginBtn setImage:[UIImage imageNamed:@"登录按钮.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bigScrollView addSubview:loginBtn];
    

}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_nameTextField)
    {
        _nameImgView.image=[UIImage imageNamed:@"输入条1.png"];
        _psdImgView.image=[UIImage imageNamed:@"输入条2.png"];
    }
    else if (textField==_psdTextField)
    {
        _psdImgView.image=[UIImage imageNamed:@"输入条1.png"];
         _nameImgView.image=[UIImage imageNamed:@"输入条2.png"];
    }
    
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame)+230);
    [_bigScrollView scrollRectToVisible:CGRectMake(0, 230, SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame)) animated:NO];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_nameTextField)
    {
        _nameImgView.image=[UIImage imageNamed:@"输入条2.png"];
    }
    else if (textField==_psdTextField)
    {
        _psdImgView.image=[UIImage imageNamed:@"输入条2.png"];
    }
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame));
     [_bigScrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame)) animated:NO];
}

-(void)leftBtnCilck
{
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)loginBtnClick
{
    [self.view endEditing:YES];
    if ([_nameTextField.text isEqualToString:@""]||[_psdTextField.text isEqualToString:@""])
    {
        NSString * str=@"用户名或密码不能为空！";
        [JTAlertViewAnimation startAnimation:str view:self.view];
    }
    else
    {
        if ([SOAPRequest checkNet])
        {
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_nameTextField.text,@"loginName",[MyMD5 md5:_psdTextField.text],@"password", nil];
            
            NSDictionary * dic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_LoginURL] jsonDic:jsondic]];
            
            if ([[dic objectForKey:@"resultCode"] intValue]==1001)
            {
                NSString * str=@"用户名或密码已变更或过期，请检测后重新登录";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else if([[dic objectForKey:@"resultCode"] intValue]==2009)
            {
                NSString * str=@"用户名不存在";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else if([[dic objectForKey:@"resultCode"] intValue]==2010)
            {
                NSString * str=@"密码不正确";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else if([[dic objectForKey:@"resultCode"] intValue]==1000)
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录成功！" delegate:nil cancelButtonTitle:nil   otherButtonTitles:@"OK，我知道了。。", nil];
                [alertView show];

                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                JTUser * user=[[JTUser alloc] init];
                NSDictionary * userDic=[dic objectForKey:@"user"];
                user.userID=[[userDic objectForKey:@"id"] intValue];
                user.loginName=[userDic objectForKey:@"loginName"];
                user.password=[userDic objectForKey:@"password"];
                user.userName=[userDic objectForKey:@"userName"];
                NSString * sexStr=[userDic objectForKey:@"sex"];
                if ([sexStr isEqualToString:@"MALE"])
                {
                    user.sex=0;//男
                }
                else if ([sexStr isEqualToString:@"FEMALE"])
                {
                    user.sex=1;//女
                }
                user.headPortraitImgUrlStr=[userDic objectForKey:@"imageValue"];
                user.email=[userDic objectForKey:@"email"];
                user.phone=[userDic objectForKey:@"tel"];
                user.provinceID=[[userDic objectForKey:@"provinceId"] intValue];
                user.cityID=[[userDic objectForKey:@"cityId"] intValue];
                user.regionId=[[userDic objectForKey:@"regionId"] intValue];
                user.streetId=[[userDic objectForKey:@"streetId"] intValue];
                user.address=[userDic objectForKey:@"address"];

                user.isContinuous=[userDic objectForKey:@"continuous"];
                user.points=[userDic objectForKey:@"points"];
                user.availablePoints=[userDic objectForKey:@"availablePoints"];
                user.pointsTitle=[userDic objectForKey:@"pointsTitle"];
        
                
                user.provinceValue=[userDic objectForKey:@"provinceName"];
                user.cityValue=[userDic objectForKey:@"cityName"];
                user.regionName=[userDic objectForKey:@"regionName"];
                user.streetName=[userDic objectForKey:@"streetName"];
                user.isSignin=[userDic objectForKey:@"signinFlag"];
                user.EMuserLoginName=[userDic objectForKey:@"easemobUsername"];
                
                JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
                appDelegate.appUser=user;
                
                
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user.EMuserLoginName
                                                                    password:user.EMuserLoginName
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
         

                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"] isEqualToString:@"1"])
                {
                    [APService setAlias:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                }

                    [[NSUserDefaults standardUserDefaults] setObject:user.loginName forKey:@"loginName"];
                    [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:@"password"];
                
                    [[NSUserDefaults standardUserDefaults] synchronize];
                self.peopleVC.user=[[JTUser alloc] init];
                self.peopleVC.user=user;
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
            else
            {
                NSString * str=@"服务器异常，请稍后重试...";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
        }
     
      
    }
    
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

-(void)findPsd
{
    JTFindPsdViewController * findVC=[[JTFindPsdViewController alloc] init];
    findVC.loginVC=self;
    [self.navigationController pushViewController:findVC animated:YES];
    
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
