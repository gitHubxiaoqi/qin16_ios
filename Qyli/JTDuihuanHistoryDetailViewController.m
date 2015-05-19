//
//  JTDuihuanHistoryDetailViewController.m
//  清一丽
//
//  Created by 小七 on 15-2-13.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTDuihuanHistoryDetailViewController.h"

@interface JTDuihuanHistoryDetailViewController ()
{
    JTSortModel * _model;
    UIScrollView * _bigScrollView;
}
@end

@implementation JTDuihuanHistoryDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self sendPost];
    [self readyUIAgain];
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
    _model=[[JTSortModel alloc] init];
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
    navTitailLab.text=@"历史订单详情";
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
    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 1000);
    _bigScrollView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [self.view addSubview:_bigScrollView];
    
}
-(void)readyUIAgain
{
    UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    view1.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view1];
    
    UILabel * greyLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    greyLab.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [view1 addSubview:greyLab];
    
    UIImageView * logoImgView=[[UIImageView alloc] initWithFrame:CGRectMake(25, 15, self.view.frame.size.width-25*2, 120)];
    logoImgView.contentMode=UIViewContentModeScaleAspectFit;
    [logoImgView setImageWithURL:[NSURL URLWithString:_model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
    [view1 addSubview:logoImgView];
    
    UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0,150, self.view.frame.size.width,100)];
    view2.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view2];
    
    UILabel * descriptionLab1=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 20)];
    descriptionLab1.text=@"礼品信息";
    descriptionLab1.font=[UIFont systemFontOfSize:16];
    descriptionLab1.textColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
    [view2 addSubview:descriptionLab1];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 20)];
    lab1.text=_model.title;
    lab1.font=[UIFont systemFontOfSize:16];
    lab1.textColor=[UIColor blackColor];
    [view2 addSubview:lab1];
    
    UILabel * lab2=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, 20)];
    lab2.text=[NSString stringWithFormat:@"市场价:%@元    花费积分:%@",_model.cost,_model.beginDate];
    lab2.font=[UIFont systemFontOfSize:14];
    lab2.textColor=[UIColor grayColor];
    [view2 addSubview:lab2];
    
    UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 1)];
    lineLab.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
    [lab2 addSubview:lineLab];
    
    UILabel * lab3=[[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 20)];
    lab3.text=[NSString stringWithFormat:@"兑换时间:%@",_model.registTime];
    lab3.font=[UIFont systemFontOfSize:14];
    lab3.textColor=[UIColor grayColor];
    [view2 addSubview:lab3];
    
    UIView * view3=[[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height+view2.frame.size.height+10, self.view.frame.size.width, 80)];
    view3.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view3];
    
    UILabel * descriptionLab2=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 20)];
    descriptionLab2.text=@"订单信息";
    descriptionLab2.font=[UIFont systemFontOfSize:16];
    descriptionLab2.textColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
    [view3 addSubview:descriptionLab2];
    
    UILabel * lab21=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 20)];
    lab21.text=[NSString stringWithFormat:@"件数:共%@件",_model.commentCount];
    lab21.font=[UIFont systemFontOfSize:14];
    lab21.textColor=[UIColor grayColor];
    [view3 addSubview:lab21];
    
    
    UILabel * lab22=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, 20)];
    if ([[NSString stringWithFormat:@"%@",self.orderState] isEqualToString:@"1"])
    {
         lab22.text=@"待发货";
    }
    else if ([[NSString stringWithFormat:@"%@",self.orderState] isEqualToString:@"2"])
    {
     lab22.text=[NSString stringWithFormat:@"快递单号:%@(%@)",_model.collectionId,_model.collectionCount];
    }
   
    lab22.font=[UIFont systemFontOfSize:14];
    lab22.textColor=[UIColor grayColor];
    [view3 addSubview:lab22];
    
    UIView * view4=[[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height+view2.frame.size.height+10+view3.frame.size.height+10, self.view.frame.size.width, 100)];
    view4.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view4];
    
    UILabel * descriptionLab3=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 20)];
    descriptionLab3.text=@"收件人信息";
    descriptionLab3.font=[UIFont systemFontOfSize:16];
    descriptionLab3.textColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
    [view4 addSubview:descriptionLab3];
    
    UILabel * lab31=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 20)];
    lab31.text=[NSString stringWithFormat:@"姓名:%@",_model.name];
    lab31.font=[UIFont systemFontOfSize:16];
    lab31.textColor=[UIColor grayColor];
    [view4 addSubview:lab31];
    
    UILabel * lab32=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, 20)];
    lab32.text=[NSString stringWithFormat:@"电话:%@",_model.tel];
    lab32.font=[UIFont systemFontOfSize:14];
    lab32.textColor=[UIColor grayColor];
    [view4 addSubview:lab32];
    
    UILabel * lab33=[[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 20)];
    lab33.text=[NSString stringWithFormat:@"收货地址:%@",_model.infoAddress];
    lab33.font=[UIFont systemFontOfSize:14];
    lab33.textColor=[UIColor grayColor];
    [view4 addSubview:lab33];
    
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+view4.frame.size.height+30);

}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendPost
{

    
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.orderIdStr,@"id", nil];
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_GetPointsorderInfo] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            NSDictionary * resultDic=[[NSDictionary alloc] initWithDictionary:[zaojiaoDic objectForKey:@"pointsorder"]];

            _model.registTime=[resultDic  objectForKey:@"createTimeValue"];
            _model.commentCount=[resultDic objectForKey:@"num"];
            _model.collectionCount=[resultDic objectForKey:@"express"];
            _model.collectionId=[resultDic objectForKey:@"expressNo"];
            
            _model.title=[[resultDic objectForKey:@"pointsgift"] objectForKey:@"name"];
            _model.cost=[[resultDic objectForKey:@"pointsgift"] objectForKey:@"price"];
            _model.beginDate=[[resultDic objectForKey:@"pointsgift"] objectForKey:@"redeemPoints"];
            _model.imgUrlStr=[[resultDic objectForKey:@"pointsgift"] objectForKey:@"image"];


            _model.name=[[resultDic objectForKey:@"consigneeAddress"] objectForKey:@"name"];
            _model.infoAddress=[[resultDic objectForKey:@"consigneeAddress"] objectForKey:@"addressValue"];
            _model.tel=[[resultDic objectForKey:@"consigneeAddress"] objectForKey:@"phone"];
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];

        }
    }
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
