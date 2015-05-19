//
//  JTJifenShangchengDEtailViewController.m
//  清一丽
//
//  Created by 小七 on 15-2-13.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTJifenShangchengDetailViewController.h"

@interface JTJifenShangchengDetailViewController ()<UIWebViewDelegate>
{
    JTSortModel * _model;
    UIScrollView * _bigScrollView;
    UIWebView * _webView;
}
@end

@implementation JTJifenShangchengDetailViewController

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
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 30)];
    _webView.tag=1111;
    [_webView setScalesPageToFit:NO];
    _webView.scrollView.scrollEnabled=NO;
    _webView.backgroundColor=[UIColor whiteColor];
    [_webView loadHTMLString:_model.description1 baseURL:nil];
    _webView.delegate=self;
    
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
    navTitailLab.text=@"礼品详情";
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

    UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0,150, self.view.frame.size.width,60)];
    view2.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view2];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 20)];
    lab1.text=_model.title;
    lab1.font=[UIFont systemFontOfSize:18];
    lab1.textColor=[UIColor blackColor];
    [view2 addSubview:lab1];

    UILabel * lab2=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 20)];
    lab2.text=[NSString stringWithFormat:@"市场价:%@元    兑换所需积分:%@",_model.cost,_model.beginDate];
    lab2.font=[UIFont systemFontOfSize:14];
    lab2.textColor=[UIColor grayColor];
    [view2 addSubview:lab2];
    
    UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 1)];
    lineLab.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
    [lab2 addSubview:lineLab];
    
    UIView * view3=[[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height+view2.frame.size.height+10, self.view.frame.size.width, 60)];
    view3.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view3];
    
    UILabel * descriptionLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 20)];
    descriptionLab.text=@"礼品描述";
    descriptionLab.font=[UIFont systemFontOfSize:16];
    descriptionLab.textColor=[UIColor grayColor];
    [view3 addSubview:descriptionLab];
    
    while (_webView.tag!=9999)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    [view3 addSubview:_webView];
    
    view3.frame=CGRectMake(0, view1.frame.size.height+view2.frame.size.height+10,self.view.frame.size.width , 30+_webView.frame.size.height+10);
    
    
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+20);

    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //拦截网页图片  并修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=300;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth)*1.5;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    int height = [height_str intValue];
    
    CGRect frame = webView.frame;
    frame.size.height= height+5;
    webView.frame = frame;
    webView.tag=9999;
}

-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendPost
{
    
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.giftIdStr,@"id", nil];
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_PointsMall_GetPointsgiftInfo] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            NSDictionary * resultDic=[[NSDictionary alloc] initWithDictionary:[zaojiaoDic objectForKey:@"pointsgift"] ];
            _model.idStr=[resultDic objectForKey:@"id"];
            _model.title=[resultDic objectForKey:@"name"];
            _model.cost=[resultDic objectForKey:@"price"];
            _model.imgUrlStr=[resultDic objectForKey:@"image"];
            _model.beginDate=[resultDic objectForKey:@"redeemPoints"];
            _model.description1=[resultDic objectForKey:@"remark"];
            _model.style=[resultDic objectForKey:@"status"];

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
