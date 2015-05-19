//
//  JTSetSexViewController.m
//  Qyli
//
//  Created by 小七 on 14-8-4.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTSetSexViewController.h"


@interface JTSetSexViewController ()
{

    UIButton * _selectedBtn;
}

@end

@implementation JTSetSexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self readyUI];
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
    navTitailLab.text=@"性别";
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
    
    UIButton * saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setImage:[UIImage imageNamed:@"save_btn.png"] forState:UIControlStateNormal];
    saveBtn.frame=CGRectMake(10, 120, self.view.frame.size.width-20, 35);
    [saveBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    //自定义选项卡
    UIButton * btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"personal_select_bg.png"] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"personal_selected.png"] forState:UIControlStateDisabled];
    btn1.frame=CGRectMake(10, 74, (self.view.frame.size.width-20)/2.0, 30);
    [btn1 addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"男" forState:UIControlStateNormal];
    [btn1 setTitle:@"男" forState:UIControlStateDisabled];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.view addSubview:btn1];
    
    UIButton * btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"personal_select_bg.png"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"personal_selected.png"] forState:UIControlStateDisabled];
    btn2.frame=CGRectMake(self.view.frame.size.width/2.0, 74, (self.view.frame.size.width-20)/2.0,30);
    [btn2 setTitle:@"女" forState:UIControlStateNormal];
    [btn2 setTitle:@"女" forState:UIControlStateDisabled];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [btn2 addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    if(!_pVC.myUser.sex)
    {
        _selectedBtn=btn1;
        btn1.enabled=NO;
    }
    else
    {
        _selectedBtn=btn2;
        btn2.enabled=NO;
    
    }
    
}
-(void)saveBtn
{
    [self xiugai];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeStyle:(UIButton *)sender
{
    
    if (sender!=_selectedBtn)
    {
        _selectedBtn.enabled=YES;
        sender.enabled=NO;
        _selectedBtn=sender;
    }
    
}
-(void)xiugai
{
    if ([SOAPRequest checkNet])
    {
        NSString * sexStr=@"";
        if ([_selectedBtn.titleLabel.text isEqualToString:@"男"])
        {
            sexStr=@"MALE";
        }
        else
        {
           sexStr=@"FEMALE";
            
        }
        
       NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.pVC.myUser.userID],@"userId",self.pVC.myUser.userName,@"userName",self.pVC.myUser.loginName,@"loginName",sexStr,@"sex",@"",@"province",@"",@"city",@"",@"region",@"",@"street",@"",@"address",@"",@"headPortrait", nil];
        NSDictionary * editUserDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_SaveEditUserURL] jsonDic:jsondic]];
        
        
        if ([[editUserDic objectForKey:@"resultCode"] intValue]!=1000)
        {
            if ([editUserDic objectForKey:@"errorMessage"]!=nil)
            {
                NSString * str=[editUserDic objectForKey:@"errorMessage"];
                [JTAlertViewAnimation startAnimation:str view:self.view];
                
            }
            else
            {
                NSString * str=@"服务器异常，请稍后重试...";
                [JTAlertViewAnimation startAnimation:str view:self.view];
            }
            
        }
        else if ([[editUserDic objectForKey:@"resultCode"] intValue]==1000)
        {
            JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
            if ([sexStr isEqualToString:@"MALE"])
            {
                appdelegate.appUser.sex=0;//男
            }
            else if ([sexStr isEqualToString:@"FEMALE"])
            {
                appdelegate.appUser.sex=1;//女
            }
            
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
