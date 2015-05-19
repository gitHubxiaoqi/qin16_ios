//
//  JTFindPsdViewController.m
//  Qyli
//
//  Created by 小七 on 14-8-1.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTFindPsdViewController.h"
#import "JTAppDelegate.h"

@interface JTFindPsdViewController ()<UITextFieldDelegate>
{
    UIView * _contentView;
    int j;
    NSString * _checkCodeNumberString;
    NSString * _phoneNum;
    NSString * _checkCodeNumber;
    int seconds;
    NSTimer * timer;
    
    NSString * _phoneKey;
    NSString * _newPsd;
    
    UIScrollView * _bigScrollView;
    UITextField * _yanzhengmaTextField;
}
@property(strong,nonatomic)UILabel * checkCodeNumberLabel;
@end

@implementation JTFindPsdViewController

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
    
    j=0;
    seconds=60;
    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    [self.view addSubview:_bigScrollView];
    
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50-14);
    
    [self readyUI];
    
    _contentView=[[UIView alloc] initWithFrame:CGRectMake(10, 125-64, self.view.bounds.size.width-20,200)];
    [_bigScrollView addSubview:_contentView];
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    view.tag=100;
    [self readySmallUI:(0) view:(view)];
    [_contentView addSubview:view];
    
}
-(void)textChangeAction:(UITextField *)sender
{
    if (sender.tag==31)
    {
        if ([sender.text isEqualToString:_checkCodeNumberString])
        {
                UIButton * btn=(UIButton *)[self.view viewWithTag:120];
                [btn setEnabled:YES];
        }
        else
        {
            UIButton * btn=(UIButton *)[self.view viewWithTag:120];
            [btn setEnabled:NO];
        }
        
     }

}
-(void)readySmallUI:(int)i view:(UIView *)view
{
    switch (i)
    {
        case 0:
        {
            //说明lab
            UILabel * explineLab=[[UILabel alloc] initWithFrame:CGRectMake(0,5, self.view.frame.size.width-20, 20)];
            explineLab.text=@"限于使用手机号注册或者绑定过手机号的用户有效";
            explineLab.font=[UIFont systemFontOfSize:13];
            explineLab.textAlignment=NSTextAlignmentCenter;
            explineLab.textColor=[UIColor lightGrayColor];
            [view addSubview:explineLab];
            
            //2输入框
            for (int i=0; i<2; i++)
            {
                UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 30+i*40, 60, 33)];
                lab.font=[UIFont systemFontOfSize:15];
                lab.textAlignment=NSTextAlignmentCenter;
                if (i==0)
                {
                    lab.text=@"手机号";
                }
                else
                {
                    lab.text=@"验证码";
                }
                [view addSubview:lab];
                
                
                UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_box_org.png"]];
                imgView.frame=CGRectMake(60, 30+i*40, self.view.frame.size.width-20-60-10, 33);
                imgView.userInteractionEnabled=YES;
                [view addSubview:imgView];
                
                UITextField * textField=[[UITextField alloc] initWithFrame:CGRectMake(65, 30+i*40, self.view.frame.size.width-20-65-10, 33)];
                textField.tag=30+i;
                textField.delegate=self;
                [textField addTarget:self action:@selector(textChangeAction:)forControlEvents:UIControlEventEditingChanged];
                if (i==0)
                {
                    textField.placeholder=@"请输入手机号";
                }
                else
                {
                    textField.placeholder=@"请输入验证码";
                }
                textField.font=[UIFont systemFontOfSize:15];
                [view addSubview:textField];
     
            }
            //验证码、50
            _checkCodeNumberLabel=[[UILabel alloc] initWithFrame:CGRectMake(70, 115,80, 30)];
            [view addSubview:_checkCodeNumberLabel];
            [self readyCheckCodeNumber];
            
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"看不清，换一张" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            btn.frame=CGRectMake(180, 122, 100, 20);
            [btn addTarget:self action:@selector(changeImg) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(180, 140, 100, 1)];
            lineLab.backgroundColor=[UIColor blueColor];
            [view addSubview:lineLab];

            //设置view和contentView的高度
            CGRect rect=view.frame;
            rect.size.height=155;
            view.frame=rect;
            CGRect rect2=_contentView.frame;
            rect2.size.height=155;
            _contentView.frame=rect2;

        }
            break;
        case 1:
        {
            UILabel * explineLab=[[UILabel alloc] initWithFrame:CGRectMake(0,5, self.view.frame.size.width-20, 20)];
            explineLab.text=[NSString stringWithFormat:@"您的手机号%@验证成功！",_phoneNum];
            explineLab.font=[UIFont systemFontOfSize:13];
            explineLab.textAlignment=NSTextAlignmentCenter;
            explineLab.textColor=[UIColor lightGrayColor];
            [view addSubview:explineLab];
            
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"获取短信验证码%d",seconds] forState:UIControlStateNormal];
            btn.tag=90;
            [btn setTintColor:[UIColor whiteColor]];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            btn.frame=CGRectMake((self.view.frame.size.width-120)/2.0, 30, 120, 30);
            [btn addTarget:self action:@selector(getMessage) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width-10, 1)];
            lineLab.backgroundColor=[UIColor lightGrayColor];
            [view addSubview:lineLab];
            
            UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 75, 60, 33)];
            lab.font=[UIFont systemFontOfSize:15];
            lab.textAlignment=NSTextAlignmentCenter;
            lab.text=@"验证码";
            [view addSubview:lab];
            
            UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_box_org.png"]];
            imgView.frame=CGRectMake(60, 75, self.view.frame.size.width-20-60-10, 33);
            imgView.userInteractionEnabled=YES;
            [view addSubview:imgView];
            
            _yanzhengmaTextField=[[UITextField alloc] initWithFrame:CGRectMake(65, 75, self.view.frame.size.width-20-65-5, 33)];
            _yanzhengmaTextField.tag=50;
            _yanzhengmaTextField.delegate=self;
           _yanzhengmaTextField.placeholder=@"请输入接收到的短信验证码";
            _yanzhengmaTextField.font=[UIFont systemFontOfSize:15];
            [view addSubview:_yanzhengmaTextField];
            
            //设置view和contentView的高度
            CGRect rect=view.frame;
            rect.size.height=110;
            view.frame=rect;
            CGRect rect2=_contentView.frame;
            rect2.size.height=110;
            _contentView.frame=rect2;

        }
            break;
        case 2:
        {
            UILabel * explineLab=[[UILabel alloc] initWithFrame:CGRectMake(0,5, self.view.frame.size.width-20, 20)];
            explineLab.text=@"您可以重新设置您的登录密码";
            explineLab.font=[UIFont systemFontOfSize:15];
            explineLab.textAlignment=NSTextAlignmentCenter;
            explineLab.textColor=[UIColor lightGrayColor];
            [view addSubview:explineLab];
            
            for (int i=0; i<2; i++)
            {
                UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 30+i*40, 60, 33)];
                lab.font=[UIFont systemFontOfSize:14];
                lab.textAlignment=NSTextAlignmentCenter;
                if (i==0)
                {
                    lab.text=@"新密码";
                }
                else
                {
                    lab.text=@"确认密码";
                }
                [view addSubview:lab];
                
                
                UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_box_org.png"]];
                imgView.frame=CGRectMake(60, 30+i*40, self.view.frame.size.width-20-60-10, 33);
                imgView.userInteractionEnabled=YES;
                [view addSubview:imgView];
                
                UITextField * textField=[[UITextField alloc] initWithFrame:CGRectMake(65, 30+i*40, self.view.frame.size.width-20-65-5, 33)];
                textField.delegate=self;
                textField.tag=60+i;
                textField.secureTextEntry=YES;
                if (i==0)
                {
                    textField.placeholder=@"2-16位密码（字母，数字，特殊字符）";
                }
                else
                {
                    textField.placeholder=@"请再次输入密码";
                }
                textField.font=[UIFont systemFontOfSize:13];
                [view addSubview:textField];
                
                //设置view和contentView的高度
                CGRect rect=view.frame;
                rect.size.height=105;
                view.frame=rect;
                CGRect rect2=_contentView.frame;
                rect2.size.height=105;
                _contentView.frame=rect2;
                
            }

        }
            break;
            
        default:
            break;
    }

}
- (void)readyCheckCodeNumber
{
    for (UIView *view in self.checkCodeNumberLabel.subviews)
    {
        [view removeFromSuperview];
    }
    // @{
    // @name 生成背景色
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [self.checkCodeNumberLabel setBackgroundColor:color];
    
    // @name 生成文字
    const int count = 5;
    char data[count];
    for (int x = 0; x < count; x++)
    {
        int s = '0' + (arc4random_uniform(75));
        if((s >= 58 && s <= 64) || (s >= 91 && s <= 96)){
            --x;
        }else{
            data[x] = (char)s;
        }
    }
    NSString *text = [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    
    _checkCodeNumberString=text;
    // 生成文字颜色
    CGSize cSize=[@"S" sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]}];
    int width = self.checkCodeNumberLabel.frame.size.width / text.length - cSize.width;
    int height = self.checkCodeNumberLabel.frame.size.height - cSize.height;
    CGPoint point;
    float pX, pY;
    for (int i = 0, count = text.length; i < count; i++)
    {
        pX = arc4random() % width + self.checkCodeNumberLabel.frame.size.width / text.length * i - 1;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(pX, pY,self.checkCodeNumberLabel.frame.size.width / 4,self.checkCodeNumberLabel.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.text = textC;
        [self.checkCodeNumberLabel addSubview:tempLabel];
    }
}
-(void)getMessage
{
   timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_phoneNum,@"phone", nil];
        
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
            _phoneKey=[yanzhengDic objectForKey:@"phoneKey"];
        }
        
    }

}
-(void)timerFireMethod:(NSTimer *)theTimer
{
    UIButton * btn=(UIButton *)[self.view viewWithTag:90];
    if (seconds == 1)
    {
        [theTimer invalidate];
        seconds = 60;
        [btn setEnabled:YES];
        [btn setTitle:[NSString stringWithFormat:@"获取短信验证码%d",seconds] forState:UIControlStateNormal];
        
    }else
    {
        seconds--;
        [btn setEnabled:NO];
        [btn setTitle:[NSString stringWithFormat:@"获取短信验证码%d",seconds] forState:UIControlStateDisabled];

    }
    
}
-(void)changeImg
{
    [self readyCheckCodeNumber];

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
    navTitailLab.text=@"找回密码";
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
    
    //3步骤
    NSArray * titleArr=[[NSArray alloc] initWithObjects:@"1验证手机",@"2手机确认",@"3密码重置", nil];
    for (int i=0; i<3; i++)
    {
        UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"找回密码-%d.png",i+1]]];
        imgView.tag=i+10;
        imgView.frame=CGRectMake(10+i*((self.view.frame.size.width-20)/3.0), 74-64, (self.view.frame.size.width-20)/3.0, 35);
        [_bigScrollView addSubview:imgView];
        
        
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(10+i*((self.view.frame.size.width-20)/3.0), 74-64, (self.view.frame.size.width-20)/3.0, 35)];
        lab.tag=20+i;
        if (i==0)
        {
            lab.textColor=[UIColor whiteColor];
        }
        lab.text=[titleArr objectAtIndex:i];
        lab.font=[UIFont systemFontOfSize:14];
        lab.textAlignment=NSTextAlignmentCenter;
        [_bigScrollView addSubview:lab];
    }
    
    //线lab
     UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 74+45-64,self.view.frame.size.width-20, 1)];
    lineLab.backgroundColor=[UIColor lightGrayColor];
    [_bigScrollView addSubview:lineLab];
    
    //下一步
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag=120;
    [btn setEnabled:NO];
    [btn setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    btn.frame=CGRectMake(10, 290-64, self.view.frame.size.width-20, 35);
    [btn addTarget:self action:@selector(Next:) forControlEvents:UIControlEventTouchUpInside];
    [_bigScrollView addSubview:btn];
    
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}
-(void)Next:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (j==2)
    {
        UIButton * btn=(UIButton *)[self.view viewWithTag:120];
        [btn setEnabled:YES];
        UITextField *textField=(UITextField *)[self.view viewWithTag:61];
        if (![textField.text isEqualToString:_newPsd])
        {
            NSString * str=@"请注意：两次所输密码不一致！";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            return;
        }

        if ([SOAPRequest checkNet])
        {
            UITextField *textField=(UITextField *)[_contentView viewWithTag:61];
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_phoneNum,@"phone",[MyMD5 md5:textField.text],@"password", nil];
            
            NSDictionary * phoneDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_ChangePasswordForgotPassword] jsonDic:jsondic]];
            if ([[phoneDic objectForKey:@"resultCode"] intValue]!=1000)
            {
                
                if ([phoneDic objectForKey:@"errorMessage"]!=nil)
                {
                    NSString * str=[phoneDic objectForKey:@"errorMessage"];
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else
                {
                    NSString * str=@"服务器异常，请稍后重试...";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                
            }
            else if([[phoneDic objectForKey:@"resultCode"] intValue]==1000)
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码重置成功！" delegate:nil cancelButtonTitle:@"OK，我知道了。。" otherButtonTitles:nil, nil];
                [alertView show];
                self.loginVC.nameTextField.text=_phoneNum;
                self.loginVC.psdTextField.text=_newPsd;
                [self.navigationController popViewControllerAnimated:YES];

            }
        }

        return;
    }
  
   
    if (j==0)
    {
        if ([SOAPRequest checkNet])
        {
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_phoneNum,@"phone", nil];
            
            NSDictionary * phoneDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_ValidatephoneBindingForgotPassword] jsonDic:jsondic]];
            
            if ([[phoneDic objectForKey:@"resultCode"] intValue]!=1000)
            {
                
                if ([phoneDic objectForKey:@"errorMessage"]!=nil)
                {
                    NSString * str=[phoneDic objectForKey:@"errorMessage"];
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else if ([[phoneDic objectForKey:@"resultCode"] intValue]==2007||[[phoneDic objectForKey:@"resultCode"] intValue]==2003)
                {
                    NSString * str=@"请输入有效的手机号码！";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else
                {
                    NSString * str=@"服务器异常，请稍后重试...";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                
            }
            else if([[phoneDic objectForKey:@"resultCode"] intValue]==1000)
            {
                UIView * laterView=[self.view viewWithTag:100];
                [laterView removeFromSuperview];
                UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
                view.tag=100;
                [_contentView addSubview:view];
                
                [self readySmallUI:1 view:view];
                UIImageView * imgView=(UIImageView *)[self.view viewWithTag:10];
                imgView.image=[UIImage imageNamed:@"找回密码-2"];
                UILabel * lab=(UILabel *)[self.view viewWithTag:20];
                lab.textColor=[UIColor blackColor];
                
                UIImageView * imgView2=(UIImageView *)[self.view viewWithTag:11];
                imgView2.image=[UIImage imageNamed:@"找回密码-1"];
                UILabel * lab2=(UILabel *)[self.view viewWithTag:21];
                lab2.textColor=[UIColor whiteColor];
                j++;

            }
        }


    }
    else if(j==1)
    {
        if ([SOAPRequest checkNet])
        {

            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:_phoneNum,@"phone",_yanzhengmaTextField.text,@"phoneCode",_phoneKey,@"phoneKey", nil];
            
            NSDictionary * phoneDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_ValidatePhoneCodeForgotPassword] jsonDic:jsondic]];
            if ([[phoneDic objectForKey:@"resultCode"] intValue]!=1000)
            {
                
                if ([phoneDic objectForKey:@"errorMessage"]!=nil)
                {
                    NSString * str=[phoneDic objectForKey:@"errorMessage"];
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else if ([[phoneDic objectForKey:@"resultCode"] intValue]==2005)
                {
                    NSString * str=@"手机验证码错误";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else if ([[phoneDic objectForKey:@"resultCode"] intValue]==2000)
                {
                    NSString * str=@"手机验证码已过期";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                else
                {
                    NSString * str=@"服务器异常，请稍后重试...";
                    [JTAlertViewAnimation startAnimation:str view:self.view];
                }
                
                UIView * laterView=[self.view viewWithTag:100];
                [laterView removeFromSuperview];
                UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
                view.tag=100;
                [_contentView addSubview:view];
                
                [self readySmallUI:1 view:view];
                UIImageView * imgView=(UIImageView *)[self.view viewWithTag:10];
                imgView.image=[UIImage imageNamed:@"找回密码-2"];
                UILabel * lab=(UILabel *)[self.view viewWithTag:20];
                lab.textColor=[UIColor blackColor];
                
                UIImageView * imgView2=(UIImageView *)[self.view viewWithTag:11];
                imgView2.image=[UIImage imageNamed:@"找回密码-1"];
                UILabel * lab2=(UILabel *)[self.view viewWithTag:21];
                lab2.textColor=[UIColor whiteColor];
                return;
                
            }
            else
            {
                UIView * laterView=[self.view viewWithTag:100];
                [laterView removeFromSuperview];
                UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
                view.tag=100;
                [_contentView addSubview:view];
                
                [self readySmallUI:2 view:view];
                
                UIImageView * imgView=(UIImageView *)[self.view viewWithTag:11];
                imgView.image=[UIImage imageNamed:@"找回密码-2"];
                UILabel * lab=(UILabel *)[self.view viewWithTag:21];
                lab.textColor=[UIColor blackColor];
                
                UIImageView * imgView2=(UIImageView *)[self.view viewWithTag:12];
                imgView2.image=[UIImage imageNamed:@"找回密码-4"];
                UILabel * lab2=(UILabel *)[self.view viewWithTag:22];
                lab2.textColor=[UIColor whiteColor];
                
                [sender setTitle:@"完成" forState:UIControlStateNormal];
                j++;
            }

        }


    }
    //[_contentView addSubview:view];
    sender.frame=CGRectMake(10, _contentView.frame.origin.y+_contentView.frame.size.height+10, self.view.frame.size.width-20, 35);

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 30:
        {
            if([textField.text isEqualToString:@""])
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"手机号不能为空！" delegate:nil cancelButtonTitle:@"OK，我知道了。。" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else
            {
                if ([SOAPRequest checkNet])
                {
                    NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:textField.text,@"phone", nil];
                    
                    NSDictionary * phoneDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_ValidatephoneBindingForgotPassword] jsonDic:jsondic]];
                    
                    if ([[phoneDic objectForKey:@"resultCode"] intValue]!=1000)
                    {
                        
                        if ([phoneDic objectForKey:@"errorMessage"]!=nil)
                        {
                            NSString * str=[phoneDic objectForKey:@"errorMessage"];
                            [JTAlertViewAnimation startAnimation:str view:self.view];
                        }
                        else if ([[phoneDic objectForKey:@"resultCode"] intValue]==2007)
                        {
                            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该手机号未经过绑定,不能用来找回密码！" delegate:nil cancelButtonTitle:@"OK，我知道了。。" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                        else
                        {
                            NSString * str=@"服务器异常，请稍后重试...";
                            [JTAlertViewAnimation startAnimation:str view:self.view];
                        }
                        
                        //isPhoneGoOn=NO;
                        
                        
                    }
                    else if([[phoneDic objectForKey:@"resultCode"] intValue]==1000)
                    {
                        //isPhoneGoOn=YES;

                    }
                }

            }
            _phoneNum=textField.text;
        }
            break;

        case 31:
        {
            if ([textField.text isEqualToString:_checkCodeNumberString])
            {
                    UIButton * btn=(UIButton *)[self.view viewWithTag:120];
                    [btn setEnabled:YES];
            }
            else
            {
                UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"验证码不正确！" delegate:nil cancelButtonTitle:@"OK，我知道了。。" otherButtonTitles:nil, nil];
                [alertView show];
                UIButton * btn=(UIButton *)[self.view viewWithTag:120];
                [btn setEnabled:NO];
            }

        }
            break;
            case 60:
        {
            if (textField.text.length==0)
            {
                NSString * str=@"密码不能为空！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            else if (textField.text.length==1||textField.text.length>16)
            {
                NSString * str=@"请注意：用户名为2—16位的字母或数字组成！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            else
            {
                _newPsd=textField.text;
            }
            
        }
            break;
    
        default:
            break;
    }

}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==50)
    {
        [timer invalidate];
        seconds=60;
        UIButton * btn=(UIButton *)[self.view viewWithTag:90];
        [btn setEnabled:YES];
       [btn setTitle:[NSString stringWithFormat:@"获取短信验证码%d",seconds] forState:UIControlStateNormal];
       
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
