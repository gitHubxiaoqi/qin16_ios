//
//  JTRegisterViewController.m
//  Qyli
//
//  Created by 小七 on 14-7-31.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTRegisterViewController.h"
#import "JTProtocalViewController.h"
#import "KeychainItemWrapper.h"
@interface JTRegisterViewController ()<UITextFieldDelegate>
{
    UIButton * _selectedBtn;
    NSMutableArray * _zLabArr;
    NSMutableArray * _sLabArr;
    NSMutableArray * _zTextFieldArr;
    NSMutableArray * _sTextFieldArr;
    UIScrollView * _bigScrollView;
    NSMutableArray * _labArr;
    NSMutableArray * _textFieldArr;
    
    NSString * _userName;
    NSString * _passWord;
    NSString * _againPassWord;
    
    NSString * phoneKey;

}

@end

@implementation JTRegisterViewController

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
    //isAgreen=0;
    [self readyUI];
    _labArr=[[NSMutableArray alloc] initWithCapacity:0];
    _textFieldArr=[[NSMutableArray alloc] initWithCapacity:0];
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
    navTitailLab.text=@"加入清一丽";
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
    
    //背景滚动视图
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-20-NAV_HEIGHT)];
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,CGRectGetHeight(_bigScrollView.frame));
    [self.view addSubview:_bigScrollView];
    
    //自定义选项卡
    UIButton * btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"手机注册2.png"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"手机注册1.png"] forState:UIControlStateDisabled];
    btn1.frame=CGRectMake(0,0,SCREEN_WIDTH/2.0, 50);
    [btn1 addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag=10;
    _selectedBtn=btn1;
    btn1.enabled=NO;
    [_bigScrollView addSubview:btn1];

    UIButton * btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"账号注册2.png"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"账号注册1.png"] forState:UIControlStateDisabled];
    btn2.frame=CGRectMake(SCREEN_WIDTH/2.0,0, SCREEN_WIDTH/2.0, 50);
    [btn2 addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag=20;
    [_bigScrollView addSubview:btn2];
    
    //选填内容
    _zLabArr=[[NSMutableArray alloc] initWithObjects:@"用户名",@"密码",@"确认密码", nil];
    _zTextFieldArr=[[NSMutableArray alloc] initWithObjects:@"输入用户名",@"输入登录密码",@"再次输入登录密码", nil];
    _sLabArr=[[NSMutableArray alloc] initWithObjects:@"手机号",@"密码",@"验证码" ,nil];
    _sTextFieldArr=[[NSMutableArray alloc] initWithObjects:@"输入手机号码",@"输入登录密码", @"输入手机验证码",nil];

    
    
    UILabel * lab1=[[UILabel alloc] init];
    lab1.frame=CGRectMake(0, CGRectGetHeight(_bigScrollView.frame)-140, SCREEN_WIDTH, 20);
    lab1.text=@"点击【注册】,表示您已阅读并同意我们的";
    lab1.textColor=[UIColor grayColor];
    lab1.font=[UIFont systemFontOfSize:15];
    lab1.textAlignment=NSTextAlignmentCenter;
    [_bigScrollView addSubview:lab1];
    
    
    UIButton * protocalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [protocalBtn setTitle:@"《清一丽用户协议》" forState:UIControlStateNormal];
    [protocalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    protocalBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    protocalBtn.frame=CGRectMake((SCREEN_WIDTH-140)/2.0, CGRectGetHeight(_bigScrollView.frame)-110, 140, 20);
    [protocalBtn addTarget:self action:@selector(lookProtocal) forControlEvents:UIControlEventTouchUpInside];
    [_bigScrollView addSubview:protocalBtn];
    
    
    //注册按钮
    UIButton * registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"注册按钮.png"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.frame=CGRectMake((SCREEN_WIDTH-240)/2.0, CGRectGetHeight(_bigScrollView.frame)-80, 240,50);
    [_bigScrollView addSubview:registerBtn];
    
    UIButton * yanzhengBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [yanzhengBtn setImage:[UIImage imageNamed:@"获取验证码.png"] forState:UIControlStateNormal];
    [yanzhengBtn addTarget:self action:@selector(yanzheng) forControlEvents:UIControlEventTouchUpInside];
    yanzhengBtn.frame=CGRectMake(SCREEN_WIDTH-90,200,80, 30);
    yanzhengBtn.tag=50;
    yanzhengBtn.hidden=YES;
    [_bigScrollView addSubview:yanzhengBtn];
    
    for (int i=0; i<3; i++)
    {
        
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0,50+30+i*55,90, 40)];
        lab.tag=100+i;
        lab.textAlignment=NSTextAlignmentRight;
        lab.font=[UIFont systemFontOfSize:20];
        [_bigScrollView addSubview:lab];
        
        UITextField * textField=[[UITextField alloc] initWithFrame:CGRectMake(100,50+30+10+i*55, SCREEN_WIDTH-100-100, 25)];
        textField.font=[UIFont systemFontOfSize:13];
        textField.delegate=self;
        textField.tag=200+i;
        [_bigScrollView addSubview:textField];
        

        UIImageView * imgView=[[UIImageView alloc] init];
        if (i==0)
        {
            imgView.image=[UIImage imageNamed:@"输入条1.png"];
        }
        else
        {
            imgView.image=[UIImage imageNamed:@"输入条2.png"];
        }
        imgView.frame=CGRectMake(95,50+30+30+i*55,SCREEN_WIDTH-95-95,5);
        imgView.tag=300+i;
        [_bigScrollView addSubview:imgView];
        
    }
    
        [self changArr:10];
}
-(void)lookProtocal
{
    JTProtocalViewController * pVC=[[JTProtocalViewController alloc] init];
    [self presentViewController:pVC  animated:YES completion:nil];
}
-(void)leftBtnCilck
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)changeStyle:(UIButton *)sender
{
    [self.view endEditing:YES];
    for (int i=0; i<3; i++)
    {
        
        UITextField * textField=(UITextField*)[_bigScrollView viewWithTag:200+i];
        textField.text=@"";
        
    }
    _userName=@"";
    _passWord=@"";
    _againPassWord=@"";
    if (sender!=_selectedBtn)
    {
        _selectedBtn.enabled=YES;
        sender.enabled=NO;
        _selectedBtn=sender;
    }

    [self changArr:sender.tag];
    
}
-(void)changArr:(int)tag
{
    if (tag==20)
    {
        _labArr=_zLabArr;
        _textFieldArr=_zTextFieldArr;
        
        UITextField * textField2=(UITextField *)[self.view viewWithTag:201];
        UITextField * textField3=(UITextField *)[self.view viewWithTag:202];
        textField2.secureTextEntry=YES;
        textField3.secureTextEntry=YES;
        UIButton * yanzhengBtn=(UIButton *)[_bigScrollView viewWithTag:50];
        yanzhengBtn.hidden=YES;
    }
    else
    {
        _labArr=_sLabArr;
        _textFieldArr=_sTextFieldArr;
        
        UITextField * textField2=(UITextField *)[self.view viewWithTag:201];
        textField2.secureTextEntry=YES;
        UIButton * yanzhengBtn=(UIButton *)[_bigScrollView viewWithTag:50];
        yanzhengBtn.hidden=NO;

    }
    for (int i=0; i<3; i++)
    {
        UILabel * lab=(UILabel*)[_bigScrollView viewWithTag:100+i];
        lab.text=[_labArr objectAtIndex:i];
        
        UITextField * textField=(UITextField*)[_bigScrollView viewWithTag:200+i];
        textField.placeholder=[_textFieldArr objectAtIndex:i];
        
    }
}
-(void)yanzheng
{
    [self.view endEditing:YES];
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_userName,@"phone", nil];
        
        NSDictionary * yanzhengDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_Regist_SendPhoneCodeMsgURL] jsonDic:jsondic]];
        
        if ([[yanzhengDic objectForKey:@"resultCode"] intValue]!=1000)
        {
      
            if ([yanzhengDic objectForKey:@"errorMessage"]!=nil)
            {
                NSString * str=[yanzhengDic objectForKey:@"errorMessage"];
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            else if ([[yanzhengDic objectForKey:@"resultCode"] intValue]==2001)
            {
                NSString * str=@"5分钟之内发送过验证码";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            else
            {
                NSString * str=@"服务器异常，请稍后重试...";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }

        }
        else
        {
            phoneKey=[yanzhengDic objectForKey:@"phoneKey"];
        }
    }

}

-(NSString *) get_uuid
{

  
//     KeychainItemWrapper *wrapper=[[KeychainItemWrapper alloc]initWithIdentifier:@"com.QYL.Qyli" accessGroup:@"Kids First co., LTD(1558601306@qq.com)"];
//      //[wrapper resetKeychainItem];
//      //[wrapper setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
//      //[wrapper setObject:@"<帐号密码>" forKey:(__bridge id)kSecValueData];
//    NSString *password = [wrapper objectForKey:(__bridge id)kSecValueData];
     NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID~"];
    if (password==nil||[password isEqualToString:@""])
    {
        password=[self set_uuid];
        [[NSUserDefaults standardUserDefaults] setObject:[self set_uuid] forKey:@"UUID~"];
        
        //password=[self set_uuid];
        //[wrapper resetKeychainItem];
        //[wrapper setObject:@"清一丽" forKey:(__bridge id)kSecAttrAccount];
        //[wrapper setObject:password forKey:(__bridge id)kSecValueData];
    }
    return password;
}
-(NSString *) set_uuid
{
    CFUUIDRef uuid_ref=CFUUIDCreate(nil);
    CFStringRef uuid_string_ref=CFUUIDCreateString(nil, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid=[NSString stringWithFormat:@"%@",uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}
-(void)goRegister
{

    NSString * appKey=[self get_uuid];
    [self.view endEditing:YES];
    [_bigScrollView scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64-49) animated:YES];
    UITextField * textField1=(UITextField *)[self.view viewWithTag:200];
    UITextField * textField2=(UITextField *)[self.view viewWithTag:201];
    UITextField * textField3=(UITextField *)[self.view viewWithTag:202];

    if ([textField1.text isEqualToString:@""]||[textField2.text isEqualToString:@""])
    {
        NSString * str=@"请正确填写注册信息！";
        [JTAlertViewAnimation startAnimation:str view:self.view];
        return;

    }
    if (_selectedBtn.tag==20)
    {
        if (![textField2.text isEqualToString:textField3.text])
        {
            NSString * str=@"请注意：两次所输密码不一致！";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            return;
        }
        if ([SOAPRequest checkNet])
        {
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:textField1.text,@"loginName",[MyMD5 md5:textField3.text],@"password",appKey,@"appKey", nil];
            
            NSDictionary * registerDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_Regist_SaveRegisterUserURL] jsonDic:jsondic]];
            
            if ([[registerDic objectForKey:@"resultCode"] intValue]==1000)
            {
                [self login];
                [self dismissViewControllerAnimated:YES completion:nil];

            }
            else
            {
                if ([registerDic objectForKey:@"errorMessage"]!=nil)
                {
                    NSString * str=[registerDic objectForKey:@"errorMessage"];
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else if ([[registerDic objectForKey:@"resultCode"] intValue]==2002)
                {
                    NSString * str=@"用户名已存在!";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else if ([[registerDic objectForKey:@"resultCode"] intValue]==2013)
                {
                    NSString * str=@"注册失败，该设备注册次数过多！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else
                {
                    NSString * str=@"服务器异常，请稍后重试...";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }

            }
        }
        
    }
    else
    {
        if ([SOAPRequest checkNet])
        {
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:textField1.text,@"phone",[MyMD5 md5:textField2.text],@"password",textField3.text,@"phoneCode",phoneKey,@"phoneKey" ,appKey,@"appKey",nil];
            
            NSDictionary * registerPhoneDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_Regist_SaveRegisterUserPhoneURL] jsonDic:jsondic]];

            if ([registerPhoneDic isEqual:@{}])
            {
                NSString * str=@"服务器无返回数据，请稍后重试...";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            else
            {
                if ([[registerPhoneDic objectForKey:@"resultCode"] intValue]!=1000)
                {
                    
                    if ([registerPhoneDic objectForKey:@"errorMessage"]!=nil)
                    {
                        NSString * str=[registerPhoneDic objectForKey:@"errorMessage"];
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                    }
                    else if ([[registerPhoneDic objectForKey:@"resultCode"] intValue]==2000)
                    {
                        NSString * str=@"手机验证码已过期";
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                    }
                    else if ([[registerPhoneDic objectForKey:@"resultCode"] intValue]==2005)
                    {
                        NSString * str=@"手机验证码错误";
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                    }
                    else if ([[registerPhoneDic objectForKey:@"resultCode"] intValue]==2004)
                    {
                        NSString * str=@"手机号已经存在，不能重复注册！";
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                    }
                    else if ([[registerPhoneDic objectForKey:@"resultCode"] intValue]==2013)
                    {
                        NSString * str=@"注册失败，该设备注册次数过多！";
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                    }
                    else
                    {
                        NSString * str=@"服务器异常，请稍后重试...";
                        [JTAlertViewAnimation startAnimation:str view:self.view];
                    }

                }
                else
                {
                    [self login];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }

            }
            
       }
    }
}
-(void)login
{
    if([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_userName,@"loginName",[MyMD5 md5:_passWord],@"password", nil];
        NSDictionary * loginDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_LoginURL] jsonDic:jsondic]];
        if([[loginDic objectForKey:@"resultCode"] intValue]==1000)
        {
            JTUser *user=[[JTUser alloc] init];
            NSDictionary * userDic=[loginDic objectForKey:@"user"];
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
            user.createTime=[userDic objectForKey:@"createTime"];
            user.lastLoginTime=[userDic objectForKey:@"lastLoginTime"];
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

            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
 
            [[NSUserDefaults standardUserDefaults] setObject:user.loginName forKey:@"loginName"];
            [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:@"password"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            

            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"] isEqualToString:@"1"])
            {
              [APService setAlias:[NSString stringWithFormat:@"%d",user.userID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }

    
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    UIImageView * imgView1=(UIImageView *)[_bigScrollView viewWithTag:300];
    UIImageView * imgView2=(UIImageView *)[_bigScrollView viewWithTag:301];
    UIImageView * imgView3=(UIImageView *)[_bigScrollView viewWithTag:302];
    switch (textField.tag)
    {
        case 200:
        {
            imgView1.image=[UIImage imageNamed:@"输入条1.png"];
            imgView2.image=[UIImage imageNamed:@"输入条2.png"];
            imgView3.image=[UIImage imageNamed:@"输入条2.png"];
        }
            break;
        case 201:
        {
            imgView1.image=[UIImage imageNamed:@"输入条2.png"];
            imgView2.image=[UIImage imageNamed:@"输入条1.png"];
            imgView3.image=[UIImage imageNamed:@"输入条2.png"];
        }
            break;

        case 202:
        {
            imgView1.image=[UIImage imageNamed:@"输入条2.png"];
            imgView2.image=[UIImage imageNamed:@"输入条2.png"];
            imgView3.image=[UIImage imageNamed:@"输入条1.png"];
        }
            break;

            
        default:
            break;
    }
    _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 250+CGRectGetHeight(_bigScrollView.frame));
    [_bigScrollView scrollRectToVisible:CGRectMake(0, 70, SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame)) animated:NO];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    UIImageView * imgView1=(UIImageView *)[_bigScrollView viewWithTag:300];
    UIImageView * imgView2=(UIImageView *)[_bigScrollView viewWithTag:301];
    UIImageView * imgView3=(UIImageView *)[_bigScrollView viewWithTag:302];
    switch (textField.tag)
    {
        case 200:
        {
            imgView1.image=[UIImage imageNamed:@"输入条2.png"];
        }
            break;
        case 201:
        {
            imgView2.image=[UIImage imageNamed:@"输入条2.png"];
        }
            break;
            
        case 202:
        {
            imgView3.image=[UIImage imageNamed:@"输入条2.png"];
        }
            break;
            
            
        default:
            break;
    }

    if (_selectedBtn.tag==20)
    {
        switch (textField.tag)
        {
            case 200:
            {
                _userName=textField.text;
                if (textField.text.length==0)
                {
                    NSString * str=@"用户名不能为空！" ;
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
            }
                break;
            case 201:
            {
                _passWord=textField.text;
                if (textField.text.length==0)
                {
                    NSString * str=@"密码不能为空！" ;
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
            }
                break;
            case 202:
            {
                _againPassWord=textField.text;
                
                if (![_passWord isEqualToString:_againPassWord])
                {
                    NSString * str=@"请注意：两次所输密码不一致！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                
            }
                break;
            default:
                break;

         }
    }
    else
    {
        switch (textField.tag)
        {
            case 200:
            {
                _userName=textField.text;
                if (textField.text.length==0)
                {
                    NSString * str=@"手机号不能为空！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
            }
                break;
            case 201:
            {
                _passWord=textField.text;
                if (textField.text.length==0)
                {
                    NSString * str=@"密码不能为空！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
            }
                break;
            case 202:
            { 
                _againPassWord=textField.text;
                
            }
                break;
            default:
                break;
                
        }
    
    
    }
     _bigScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame));
    [_bigScrollView scrollRectToVisible:CGRectMake(0,0, SCREEN_WIDTH, CGRectGetHeight(_bigScrollView.frame)) animated:NO];

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
