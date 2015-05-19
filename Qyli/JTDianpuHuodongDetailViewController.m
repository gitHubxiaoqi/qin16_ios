//
//  JTDianpuHuodongDetailViewController.m
//  清一丽
//
//  Created by 小七 on 15-2-13.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTDianpuHuodongDetailViewController.h"
#import "JTDianpuDetailViewController.h"
@interface JTDianpuHuodongDetailViewController ()<UIWebViewDelegate>
{
    int p;
    UIScrollView * _bigScrollView;
    UIWebView * _webView;
}
@property(nonatomic ,strong)JTSortModel * model;
@end

@implementation JTDianpuHuodongDetailViewController
-(void)viewWillDisappear:(BOOL)animated
{
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
    if (p==1)
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
    p=2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    p=1;
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
    navTitailLab.text=@"活动详情";
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
    _bigScrollView.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    [self.view addSubview:_bigScrollView];
}
-(void)readyUIAgain
{
    
    UIImageView * logoImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    logoImgView.contentMode=UIViewContentModeScaleAspectFit;
    [logoImgView setImageWithURL:[NSURL URLWithString:_model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
    logoImgView.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:logoImgView];
    
    UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(logoImgView.frame)+5, SCREEN_WIDTH,140)];
    view1.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view1];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 39)];
    lab1.text=@"活动信息";
    lab1.font=[UIFont systemFontOfSize:13];
    lab1.textColor=NAV_COLOR;
    lab1.textAlignment=NSTextAlignmentCenter;
    [view1 addSubview:lab1];
    
    
    UILabel * totalLab=[[UILabel alloc] initWithFrame:CGRectMake(70, 0, 40, 39)];
    totalLab.font=[UIFont systemFontOfSize:12];
    totalLab.textColor=[UIColor grayColor];
    totalLab.textAlignment=NSTextAlignmentCenter;
    totalLab.text=@"总名额";
    [view1 addSubview:totalLab];
    
    UILabel * totalValueLab=[[UILabel alloc] initWithFrame:CGRectMake(110, 0, 40, 39)];
    totalValueLab.font=[UIFont systemFontOfSize:12];
    totalValueLab.textColor=NAV_COLOR;
    totalValueLab.textAlignment=NSTextAlignmentCenter;
    totalValueLab.text=[NSString stringWithFormat:@"%d人",[_model.registTime intValue]];
    [view1 addSubview:totalValueLab];
    
    UILabel * shengyuLab=[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 40, 39)];
    shengyuLab.font=[UIFont systemFontOfSize:12];
    shengyuLab.textColor=[UIColor grayColor];
    shengyuLab.textAlignment=NSTextAlignmentCenter;
    shengyuLab.text=@"已报名";
    [view1 addSubview:shengyuLab];
    
    UILabel * shengyuValueLab=[[UILabel alloc] initWithFrame:CGRectMake(190, 0, 40, 39)];
    shengyuValueLab.font=[UIFont systemFontOfSize:12];
    shengyuValueLab.textColor=NAV_COLOR;
    shengyuValueLab.textAlignment=NSTextAlignmentCenter;
    shengyuValueLab.text=[NSString stringWithFormat:@"%d人",[_model.cost intValue]];
    [view1 addSubview:shengyuValueLab];
    
    UIButton * kaquanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [kaquanBtn setBackgroundImage:[UIImage imageNamed:@"我要参加.png"] forState:UIControlStateNormal];
    kaquanBtn.frame=CGRectMake(SCREEN_WIDTH-90, 7, 80, 26);
    [kaquanBtn addTarget:self action:@selector(qiangquan) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:kaquanBtn];
    
    UILabel* bigLineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    bigLineLab.backgroundColor=BG_COLOR;
    [view1 addSubview:bigLineLab];
    
    
    UILabel * titleLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 45,SCREEN_WIDTH, 25)];
    titleLab.text=self.model.title;
    titleLab.font=[UIFont systemFontOfSize:16];
    titleLab.numberOfLines=0;
    CGSize titleAutoSize=[self.model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLab.font} context:nil].size;
    if (titleAutoSize.height<25)
    {
        titleAutoSize.height=25;
    }
    titleLab.frame=CGRectMake(10, 45, SCREEN_WIDTH, titleAutoSize.height);
    [view1 addSubview:titleLab];

    
    UILabel * addressLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 45+CGRectGetHeight(titleLab.frame)+5,SCREEN_WIDTH-10-80-65-15, 20)];
    if (self.model.quStr==nil||[self.model.quStr isEqualToString:@""])
    {
        self.model.quStr=@"";
    }
    if (self.model.street==nil||[self.model.street isEqualToString:@""])
    {
        self.model.street=@"";
    }
    if (self.model.infoAddress==nil||[self.model.infoAddress isEqualToString:@""])
    {
        self.model.infoAddress=@"";
    }
    addressLab.text=[NSString stringWithFormat:@"%@%@%@",self.model.quStr,self.model.street,self.model.infoAddress];
    addressLab.textColor=[UIColor grayColor];
    addressLab.font=[UIFont systemFontOfSize:13];
    addressLab.numberOfLines=0;
    CGSize addressAutoSize=[addressLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10-80-65-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : addressLab.font} context:nil].size;
    if (addressAutoSize.height<20) {
        addressAutoSize.height=20;
    }
    addressLab.frame=CGRectMake(10, CGRectGetMaxY(titleLab.frame)+5, SCREEN_WIDTH-10-80-65-15, addressAutoSize.height);
    [view1 addSubview:addressLab];
    
    UIButton * GPSBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    GPSBtn.frame=CGRectMake(0,   45+CGRectGetHeight(titleLab.frame),SCREEN_WIDTH-80, 30);
    [GPSBtn addTarget:self action:@selector(GPSBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:GPSBtn];
    
    UIImageView * gpsImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map.png"]];
    gpsImgView.frame=CGRectMake(SCREEN_WIDTH-80-65-15, 6, 12, 18);
    [GPSBtn addSubview:gpsImgView];
    
    UILabel* distanceLab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-65,  45+CGRectGetHeight(titleLab.frame)+5, 65, 20)];
    distanceLab.textColor=[UIColor grayColor];
    distanceLab.font=[UIFont systemFontOfSize:12];
    distanceLab.text=[NSString stringWithFormat:@"%.2fKm",[self.model.distance floatValue]];
    [view1 addSubview:distanceLab];
    
    UILabel * telLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 45+CGRectGetHeight(titleLab.frame)+5+addressAutoSize.height, SCREEN_WIDTH-10-80, 20)];
    telLab.text=[NSString stringWithFormat:@"联系方式:%@(%@)",self.model.tel,self.model.linkman];
    telLab.font=[UIFont systemFontOfSize:13];
    telLab.textColor=[UIColor grayColor];
    [view1 addSubview:telLab];
    
    UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"笑脸.png"]];
    imgView.frame=CGRectMake(10, 45+CGRectGetHeight(titleLab.frame)+5+addressAutoSize.height+20+5, 10, 10);
    [view1 addSubview:imgView];
    
    UILabel * lianxiLab=[[UILabel alloc] initWithFrame:CGRectMake(20,45+CGRectGetHeight(titleLab.frame)+5+addressAutoSize.height+20, SCREEN_WIDTH-20-80, 20)];
    lianxiLab.font=[UIFont systemFontOfSize:13];
    lianxiLab.textColor=NAV_COLOR;
    lianxiLab.text=@"联系时请说是在清一丽上看到的~";
    [view1 addSubview:lianxiLab];
    
    UILabel * lineLab2=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-79, 55, 0.5, 60)];
    lineLab2.backgroundColor=[UIColor grayColor];
    [view1 addSubview:lineLab2];
    
    
    UIButton * linkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [linkBtn addTarget:self action:@selector(tel) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:linkBtn];
    
    UIImageView * telImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电话图标.png"]];
    [view1 addSubview:telImgView];
    
    UIButton * chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn addTarget:self action:@selector(chatNow) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:chatBtn];
    
    UIImageView * chatImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"聊天图标.png"]];
    [view1 addSubview:chatImgView];
    
    if ([self.model.isCanSeal intValue]==1)
    {
        
        linkBtn.frame=CGRectMake(SCREEN_WIDTH-80, 45, 100, 40);
        
        telImgView.frame=CGRectMake(SCREEN_WIDTH-50, 55, 20, 25);
        
        chatBtn.frame=CGRectMake(SCREEN_WIDTH-80, 85, 100, 40);
        
        chatImgView.frame=CGRectMake(SCREEN_WIDTH-50,95, 25, 20);
        
    }
    else if ([self.model.isCanSeal intValue]==0)
    {
        linkBtn.frame=CGRectMake(SCREEN_WIDTH-80, 45, 100, 80);
        telImgView.frame=CGRectMake(SCREEN_WIDTH-50, 75, 20, 25);
        chatBtn.hidden=YES;
        chatImgView.hidden=YES;
    }
    view1.frame=CGRectMake(0,CGRectGetHeight(logoImgView.frame)+5, SCREEN_WIDTH,95+titleLab.frame.size.height+addressAutoSize.height);
    
    
    UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+10,SCREEN_WIDTH, 80)];
    view2.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view2];
    
    UIImageView * jiGouImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"活动小1.png"]];
    jiGouImgView.frame=CGRectMake(10, 12, 15, 15);
    [view2 addSubview:jiGouImgView];
    
    UIButton * jigouBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jigouBtn.frame=CGRectMake(40, 10, self.view.frame.size.width-40-20, 20);
    [jigouBtn addTarget:self action:@selector(dianpu) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:jigouBtn];
    
    UILabel * jigouNameLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40-20, 20)];
    jigouNameLab.text=_model.fuName;
    jigouNameLab.font=[UIFont systemFontOfSize:14];
    [jigouBtn addSubview:jigouNameLab];
    
    UIImageView * jiantouImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
    jiantouImgView.frame=CGRectMake(self.view.frame.size.width-20, 15, 8, 10);
    [view2 addSubview:jiantouImgView];
    
    UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 0.5)];
    lineLab.backgroundColor=BG_COLOR;
    [view2 addSubview:lineLab];
    
    UIImageView * openTimeImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"活动小2.png"]];
    openTimeImgView.frame=CGRectMake(10, 52, 15, 15);
    [view2 addSubview:openTimeImgView];
    
    UILabel * opentimeLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 50, self.view.frame.size.width-40, 20)];
    opentimeLab.text=_model.openTime;
    opentimeLab.textColor=[UIColor grayColor];
    opentimeLab.font=[UIFont systemFontOfSize:13];
    [view2 addSubview:opentimeLab];
    
    
    UIView * view3=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+15, self.view.frame.size.width, 50)];
    view3.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view3];
    
    UILabel * descriptionLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,80, 29)];
    descriptionLab.text=@"活动介绍";
    descriptionLab.textColor=NAV_COLOR;
    descriptionLab.textAlignment=NSTextAlignmentCenter;
    descriptionLab.font=[UIFont systemFontOfSize:13];
    [view3 addSubview:descriptionLab];
    
    UILabel * lineLab3=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(descriptionLab.frame), SCREEN_WIDTH, 1)];
    lineLab3.backgroundColor=BG_COLOR;
    [view3 addSubview:lineLab3];
    
    while (_webView.tag!=9999)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    [view3 addSubview:_webView];
     view3.frame=CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+15,SCREEN_WIDTH, 30+_webView.frame.size.height+5);

    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+20);
    
}
-(void)chatNow
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"0"])
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录，请先登录。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
        [alertView show];
        JTLoginViewController * loginVC=[[JTLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    ChatViewController * mainVC=[[ChatViewController alloc] initWithChatter:_model.user.loginName isGroup:NO];
    mainVC.shangjiaName=_model.fuName;
    mainVC.shangjiaPic=_model.user.headPortraitImgUrlStr;
    mainVC.title=mainVC.shangjiaName;
    [self.navigationController pushViewController:mainVC animated:YES];
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
-(void)qiangquan
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"0"])
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录，请先登录。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
        [alertView show];
        JTLoginViewController * loginVC=[[JTLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    if ([SOAPRequest checkNet])
    {
        JTAppDelegate * apdelegate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortmodel.idStr,@"id",[NSString stringWithFormat:@"%d",apdelegate.appUser.userID],@"userId",_model.fuId,@"belongId", nil];
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_HuoDong_regist] jsonDic:jsondic]];
        
        if ([[zaojiaoDic objectForKey:@"resultCode"] intValue]==1000)
        {
            UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"恭喜，报名成功！可到个人中心我的卡券包中查验，欢迎前来参与哦！" delegate:nil cancelButtonTitle:nil   otherButtonTitles:@"OK，我知道了。。", nil];
            [alertView show];
        }
        else if ([[zaojiaoDic objectForKey:@"resultCode"] intValue]==3002)
        {
            NSString * str=@"您已经报过名了哦~~";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        else if ([[zaojiaoDic objectForKey:@"resultCode"] intValue]==3001)
        {
            NSString * str=@"哎呀！您来晚了，名额已经被抢光了，到别家去看看吧。。";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        else if ([[zaojiaoDic objectForKey:@"resultCode"] intValue]==1001)
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }

    }

}
-(void)tel
{
    NSArray * arr=[[NSArray alloc] initWithArray:[self.model.tel componentsSeparatedByString:@"/"]];
    NSString * phone=@"";
    if (arr.count>=2)
    {
        phone=[arr objectAtIndex:0];
    }
    else
    {
        phone=self.model.tel;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

-(void)dianpu
{
    if (self.state==999)
    {
        //从店铺活动介绍进
        if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[JTDianpuDetailViewController class]])
        {
            JTDianpuDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:1];
            [self.navigationController popToViewController:cVC animated:YES];
        }
        else if ([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[JTDianpuDetailViewController class]])
        {
            JTDianpuDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:2];
            [self.navigationController popToViewController:cVC animated:YES];
        }
        else if ([[self.navigationController.viewControllers objectAtIndex:3] isKindOfClass:[JTDianpuDetailViewController class]])
        {
            JTDianpuDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:3];
            [self.navigationController popToViewController:cVC animated:YES];
        }
        else if ([[self.navigationController.viewControllers objectAtIndex:4] isKindOfClass:[JTDianpuDetailViewController class]])
        {
            JTDianpuDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:4];
            [self.navigationController popToViewController:cVC animated:YES];
        }
        
    }
    else
    {
        //从活动列表，首页搜索进，
        JTDianpuDetailViewController * zjdVC=[[JTDianpuDetailViewController alloc] init];
        zjdVC.sortmodel=[[JTSortModel alloc] init];
        zjdVC.sortmodel.idStr=_model.fuId;
        [self.navigationController pushViewController:zjdVC animated:YES];
    }
    
}

-(void)GPSBtnClick
{
    if (_model.lat!=nil)
    {
        JTMapViewController * mapVC=[[JTMapViewController alloc] init];
        mapVC.title=_model.title;
        if (self.sortmodel.infoAddress==nil)
        {
            self.sortmodel.infoAddress=@"";
        }
        if (self.sortmodel.street==nil)
        {
            self.sortmodel.street=@"";
        }
        mapVC.subTitle=[NSString stringWithFormat:@"%@%@%@",self.model.quStr,self.model.street,self.sortmodel.infoAddress];
        mapVC.lat=self.model.lat;
        mapVC.lng=self.model.lng;
        [self presentViewController:mapVC animated:YES completion:nil];
    }
    else
    {
        NSString * str=@"经纬度缺失，暂不能查看地图";
        [JTAlertViewAnimation startAnimation:str view:self.view];
    }
}
-(void)leftBtnCilck
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 发请求
-(void)sendPost
{
    JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
    NSString * userID=@"";
    userID=[NSString stringWithFormat:@"%d",appDelegate.appUser.userID];
    if ([userID isEqualToString:@""])
    {
        userID=@"0";
    }
    
    if ([SOAPRequest checkNet])
    {
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortmodel.idStr,@"id",userID,@"userId",[NSString stringWithFormat:@"%@,%@",appDelegate.appLat,appDelegate.appLng],@"location", nil];
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_HuoDong_shopActivity] jsonDic:jsondic]];
        
        if ([[zaojiaoDic objectForKey:@"resultCode"] intValue]==1000)
        {
            NSDictionary * resultDic=[[NSDictionary alloc] initWithDictionary:[[zaojiaoDic objectForKey:@"model"] objectForKey:@"shopActivity"]];
            _model=[[JTSortModel alloc] init];
            _model=self.sortmodel;
            _model.imgUrlStr=[resultDic objectForKey:@"imgUrl"];
            _model.title=[resultDic objectForKey:@"name"];
            _model.description1=[resultDic objectForKey:@"description"];
            _model.openTime=[NSString stringWithFormat:@"%@至%@",[resultDic objectForKey:@"startDate"],[resultDic objectForKey:@"endDate"]];
            _model.cost=[resultDic objectForKey:@"registedCount"];
            _model.registTime=[resultDic objectForKey:@"quota"];
            
            NSDictionary * dianpaResultDic=[[NSDictionary alloc] initWithDictionary:[[zaojiaoDic objectForKey:@"model"] objectForKey:@"shop"]];
            
            _model.fuName=[dianpaResultDic objectForKey:@"name"];
            _model.fuId=[dianpaResultDic objectForKey:@"id"];
            _model.quStr=[dianpaResultDic objectForKey:@"regionName"];
            _model.street=[dianpaResultDic objectForKey:@"streetName"];
            _model.infoAddress=[dianpaResultDic objectForKey:@"address"];
             _model.lat=[dianpaResultDic objectForKey:@"lat"];
            _model.lng=[dianpaResultDic objectForKey:@"lng"];
            _model.tel=[dianpaResultDic objectForKey:@"tel"];
            _model.linkman=[dianpaResultDic objectForKey:@"linkman"];
             _model.isCanSeal=[dianpaResultDic objectForKey:@"cooperation"];
            
             _model.user=[[JTUser alloc] init];
            _model.user.userName=[[zaojiaoDic objectForKey:@"merchant"] objectForKey:@"userName"];
            _model.user.loginName=[[zaojiaoDic objectForKey:@"merchant"] objectForKey:@"easemobUsername"];
            _model.user.headPortraitImgUrlStr=[[zaojiaoDic objectForKey:@"merchant"] objectForKey:@"imgUrl"];
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
