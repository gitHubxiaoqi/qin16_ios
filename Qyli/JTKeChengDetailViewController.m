//
//  JTKeChengDetailViewController.m
//  Qyli
//
//  Created by 小七 on 14-11-25.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTKeChengDetailViewController.h"
#import "JTJiGouDetailViewController.h"
#import "JTSijiaoDetailViewController.h"
#import "JTPingLunViewController.h"
@interface JTKeChengDetailViewController ()<UIWebViewDelegate>
{
    int p;
    UIScrollView * _bigScrollView;
     UIWebView * _webView;
}
@property(nonatomic ,strong)JTSortModel * model;
@end
@implementation JTKeChengDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    navTitailLab.text=@"课程详情";
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
    
    UIButton * rightBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame=CGRectMake(SCREEN_WIDTH-40, (NAV_HEIGHT-20)/2, 20, 20);
    rightBtn2.tag=200;
    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"分享新.png"] forState:UIControlStateNormal];
    [rightBtn2 addTarget:self action:@selector(rightBtnClick2) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:rightBtn2];

    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 1000);
    _bigScrollView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [self.view addSubview:_bigScrollView];
    
    
}
-(void)readyUIAgain
{
    
    UIImageView * logoImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    logoImgView.contentMode=UIViewContentModeScaleAspectFit;
    [logoImgView setImageWithURL:[NSURL URLWithString:_model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
    logoImgView.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:logoImgView];
    
    UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(logoImgView.frame)+5, SCREEN_WIDTH,40)];
    view1.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view1];
    
    UILabel * titleLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-10-100, 20)];
    titleLab.text=self.model.title;
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textColor=[UIColor grayColor];
    titleLab.numberOfLines=0;
    CGSize titleAutoSize=[self.model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLab.font} context:nil].size;
    if (titleAutoSize.height<20)
    {
        titleAutoSize.height=20;
    }
    titleLab.frame=CGRectMake(10, 10, titleAutoSize.width, titleAutoSize.height);
    [view1 addSubview:titleLab];
    
    
    view1.frame=CGRectMake(0, CGRectGetHeight(logoImgView.frame)+5, SCREEN_WIDTH, 20+titleLab.frame.size.height);
    
    UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+10, SCREEN_WIDTH, 120)];
    view2.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view2];
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-50, 20)];
    lab1.text=self.model.fuName;
    lab1.font=[UIFont systemFontOfSize:14];
    [view2 addSubview:lab1];
    
    UIButton * dianpuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [dianpuBtn setImage:[UIImage imageNamed:@"右箭头.png"] forState:UIControlStateNormal];
    dianpuBtn.frame=CGRectMake(0, 10, SCREEN_WIDTH, 20);
    [dianpuBtn setImageEdgeInsets:UIEdgeInsetsMake(3, SCREEN_WIDTH-20, 5, 12)];
    [dianpuBtn addTarget:self action:@selector(jigou) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:dianpuBtn];
    
    
    UILabel* bigLineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    bigLineLab.backgroundColor=BG_COLOR;
    [view2 addSubview:bigLineLab];
    
 
    
    UILabel * addressLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 45,SCREEN_WIDTH-10-80-65-15, 20)];
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
    addressLab.frame=CGRectMake(10, 45, SCREEN_WIDTH-10-80-65-15, addressAutoSize.height);
    [view2 addSubview:addressLab];

    
    UIButton * GPSBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    GPSBtn.frame=CGRectMake(0,  40,SCREEN_WIDTH-80, 30);
    [GPSBtn addTarget:self action:@selector(GPSBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:GPSBtn];
    
    UIImageView * gpsImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map.png"]];
    gpsImgView.frame=CGRectMake(SCREEN_WIDTH-80-65-15, 6, 12, 18);
    [GPSBtn addSubview:gpsImgView];
    
    UILabel* distanceLab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-65,  45, 65, 20)];
    distanceLab.textColor=[UIColor grayColor];
    distanceLab.font=[UIFont systemFontOfSize:12];
    distanceLab.text=[NSString stringWithFormat:@"%.2fKm",[self.model.distance floatValue]];
    [view2 addSubview:distanceLab];
    
    UILabel * telLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 45+addressAutoSize.height, SCREEN_WIDTH-10-80, 20)];
    telLab.text=[NSString stringWithFormat:@"联系方式:%@(%@)",self.model.tel,self.model.linkman];
    telLab.font=[UIFont systemFontOfSize:13];
    telLab.textColor=[UIColor grayColor];
    [view2 addSubview:telLab];
    
    UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"笑脸.png"]];
    imgView.frame=CGRectMake(10, 45+addressAutoSize.height+20+5, 10, 10);
    [view2 addSubview:imgView];
    
    UILabel * lianxiLab=[[UILabel alloc] initWithFrame:CGRectMake(20,45+addressAutoSize.height+20, SCREEN_WIDTH-20-80, 20)];
    lianxiLab.font=[UIFont systemFontOfSize:13];
    lianxiLab.textColor=NAV_COLOR;
    lianxiLab.text=@"联系时请说是在清一丽上看到的~";
    [view2 addSubview:lianxiLab];
    
    UILabel * lineLab2=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-79, 55, 0.5, 50)];
    lineLab2.backgroundColor=[UIColor grayColor];
    [view2 addSubview:lineLab2];
    
    
    UIButton * linkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [linkBtn addTarget:self action:@selector(tel) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:linkBtn];
    
    UIImageView * telImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电话图标.png"]];
    [view2 addSubview:telImgView];
    
    UIButton * chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn addTarget:self action:@selector(chatNow) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:chatBtn];
    
    UIImageView * chatImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"聊天图标.png"]];
    [view2 addSubview:chatImgView];
    
    if ([self.model.isCanSeal intValue]==1)
    {
        
        linkBtn.frame=CGRectMake(SCREEN_WIDTH-80, 45, 100, 40);
        
        telImgView.frame=CGRectMake(SCREEN_WIDTH-50, 50, 20, 20);
        
        chatBtn.frame=CGRectMake(SCREEN_WIDTH-80, 85, 100, 40);
        
        chatImgView.frame=CGRectMake(SCREEN_WIDTH-50,85, 25, 20);
        
    }
    else if ([self.model.isCanSeal intValue]==0)
    {
        linkBtn.frame=CGRectMake(SCREEN_WIDTH-80, 45, 100, 80);
        telImgView.frame=CGRectMake(SCREEN_WIDTH-50, 75, 20, 25);
        chatBtn.hidden=YES;
        chatImgView.hidden=YES;
    }
    
    view2.frame=CGRectMake(0,CGRectGetHeight(logoImgView.frame)+CGRectGetHeight(view1.frame)+10, SCREEN_WIDTH,90+addressAutoSize.height);
    
    UIView * view3=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+15,SCREEN_WIDTH, 30)];
    view3.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view3];
    
    for (int i=0; i<5; i++)
    {
        if (i<[[NSString stringWithFormat:@"%@",_model.score] intValue])
        {
            UIImageView  * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
            imgView1.frame=CGRectMake(5+i*10,7, 10, 10);
            [view3 addSubview:imgView1];
        }
        else
        {
            UIImageView  * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_gray.png"]];
            imgView1.frame=CGRectMake(5+i*10, 7, 10, 10);
            [view3 addSubview:imgView1];
        }
    }
    
    UILabel * scroelab=[[UILabel alloc] initWithFrame:CGRectMake(60, 5, 100, 20)];
    scroelab.font=[UIFont systemFontOfSize:13];
    scroelab.textColor=[UIColor grayColor];
    if (_model.score==nil||[[NSString stringWithFormat:@"%@",_model.score] intValue]==0)
    {
        scroelab.text=@"暂无评分";
    }
    else
    {
        scroelab.text=[NSString stringWithFormat:@"%.1f分",[_model.score floatValue]];
    }
    [view3 addSubview:scroelab];
    
    UIButton * pinglunBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    pinglunBtn.frame=CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [pinglunBtn setImage:[UIImage imageNamed:@"右箭头.png"] forState:UIControlStateNormal];
    [pinglunBtn setImageEdgeInsets:UIEdgeInsetsMake(10, SCREEN_WIDTH-30, 10, 20)];
    [pinglunBtn addTarget:self action:@selector(evaluetaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:pinglunBtn];
    
    UILabel * pinglunlab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200, 5, 170, 20)];
    pinglunlab.font=[UIFont systemFontOfSize:13];
    pinglunlab.textColor=[UIColor grayColor];
    pinglunlab.textAlignment=NSTextAlignmentRight;
    if (_model.commentCount==nil||[[NSString stringWithFormat:@"%@",_model.commentCount] intValue]==0)
    {
        pinglunlab.text=@"还没有人评价哦！";
    }
    else
    {
        pinglunlab.text=[NSString stringWithFormat:@"%@人已评价",_model.commentCount];
    }
    [view3 addSubview:pinglunlab];
    
    UIView * view4=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+20, SCREEN_WIDTH, 30)];
    view4.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view4];
    
    UILabel * lab4=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,80, 29)];
    lab4.text=@"课程描述";
    lab4.textColor=NAV_COLOR;
    lab4.textAlignment=NSTextAlignmentCenter;
    lab4.font=[UIFont systemFontOfSize:13];
    [view4 addSubview:lab4];
    
    UILabel * lineLab4=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(lab4.frame), SCREEN_WIDTH, 1)];
    lineLab4.backgroundColor=BG_COLOR;
    [view4 addSubview:lineLab4];
    
    
    
    while (_webView.tag!=9999)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    [view4 addSubview:_webView];
    
    view4.frame=CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+20,SCREEN_WIDTH, 30+_webView.frame.size.height+5);
    
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+view4.frame.size.height+25);
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
-(void)jigou
{

    if (self.state==999)
    {
        if([_model.clickTime intValue]==0)
        {
            //从机构课程介绍进
            if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[JTJiGouDetailViewController class]])
            {
                JTJiGouDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:1];
                [self.navigationController popToViewController:cVC animated:YES];
            }
            else if ([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[JTJiGouDetailViewController class]])
            {
                JTJiGouDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:2];
                [self.navigationController popToViewController:cVC animated:YES];
            }
            else if ([[self.navigationController.viewControllers objectAtIndex:3] isKindOfClass:[JTJiGouDetailViewController class]])
            {
                JTJiGouDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:3];
                [self.navigationController popToViewController:cVC animated:YES];
            }
            else if ([[self.navigationController.viewControllers objectAtIndex:4] isKindOfClass:[JTJiGouDetailViewController class]])
            {
                JTJiGouDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:4];
                [self.navigationController popToViewController:cVC animated:YES];
            }

        }
        else if ([_model.clickTime intValue]==1)
        {
            //从私教课程介绍进
            if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[JTSijiaoDetailViewController class]])
            {
                JTSijiaoDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:1];
                [self.navigationController popToViewController:cVC animated:YES];
            }
            else if ([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[JTSijiaoDetailViewController class]])
            {
                JTSijiaoDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:2];
                [self.navigationController popToViewController:cVC animated:YES];
            }
            else if ([[self.navigationController.viewControllers objectAtIndex:3] isKindOfClass:[JTSijiaoDetailViewController class]])
            {
                JTSijiaoDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:3];
                [self.navigationController popToViewController:cVC animated:YES];
            }
            else if ([[self.navigationController.viewControllers objectAtIndex:4] isKindOfClass:[JTSijiaoDetailViewController class]])
            {
                JTSijiaoDetailViewController * cVC=[self.navigationController.viewControllers objectAtIndex:4];
                [self.navigationController popToViewController:cVC animated:YES];
            }
        }

    }
    else
    {
     //从课程列表，个人课程评价介绍，首页搜索进
        if([_model.clickTime intValue]==0)
        {
        JTJiGouDetailViewController * zjdVC=[[JTJiGouDetailViewController alloc] init];
        zjdVC.sortmodel=[[JTSortModel alloc] init];
        zjdVC.sortmodel.idStr=_model.fuId;
        [self.navigationController pushViewController:zjdVC animated:YES];
        }
        else  if([_model.clickTime intValue]==1)
        {
            JTSijiaoDetailViewController * zjdVC=[[JTSijiaoDetailViewController alloc] init];
            zjdVC.sortmodel=[[JTSortModel alloc] init];
            zjdVC.sortmodel.idStr=_model.fuId;
            [self.navigationController pushViewController:zjdVC animated:YES];
        }
            
    }
    

}
-(void)evaluetaBtnClick
{
    JTPingLunViewController * evaluateVC=[[JTPingLunViewController alloc] init];
    evaluateVC.infoIdStr=self.sortmodel.idStr;
    evaluateVC.mappingIdStr=_model.mappingId;
    [self.navigationController pushViewController:evaluateVC animated:YES];
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
-(void)rightBtnClick2
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"iTunesArtwork@2x" ofType:@"jpg"];
    
    NSString * shareUrlStr=@"http://www.qin16.com";
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"清一丽儿童网 立志打造南京最全面的儿童门户网站找辅导、买东西。惊喜连连，和你身边朋友一起分享%@",shareUrlStr] defaultContent:@"默认分享内容，没内容时显示" image:[ShareSDK imageWithPath:imagePath] title:@"#清一丽#门户网站特约分享" url:shareUrlStr description:[NSString stringWithFormat:@"我在#清一丽#发现了N条信息：清一丽儿童网 立志打造南京最全面的儿童门户网站找辅导、买东西。惊喜连连，和你身边朋友一起分享，很不错哦！%@",shareUrlStr] mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions: nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             NSString * str=@"分享成功！";
             UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
             [alertView show];
             
             JTAppDelegate * appDelegate= [UIApplication sharedApplication].delegate;
             NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",nil];
             [SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Share_UserShareAfter] jsonDic:jsondic];
         }
         else if (state == SSResponseStateFail)
         {
             
             NSString * str=[NSString stringWithFormat:@"分享失败！原因为：%@",[error errorDescription]];
             UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK，我知道了。。", nil];
             [alertView show];
         }
         
     }];
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
        
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.sortmodel.idStr,@"id", [NSString stringWithFormat:@"%@,%@",appDelegate.appLat,appDelegate.appLng],@"location",nil];
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_KeCheng_courseInfo] jsonDic:jsondic]];

        if ([[zaojiaoDic objectForKey:@"resultCode"] intValue]==1000)
        {
            NSDictionary * resultDic=[[NSDictionary alloc] initWithDictionary:[zaojiaoDic objectForKey:@"icDTO"]];
            _model=[[JTSortModel alloc] init];
            _model=self.sortmodel;
            _model.title=[resultDic objectForKey:@"name"];
            _model.fuName=[resultDic objectForKey:@"InstitutionName"];
            _model.imgUrlStr=[resultDic objectForKey:@"insImage"];
           _model.fuId=[resultDic objectForKey:@"institutionId"];
            _model.distance=[resultDic objectForKey:@"location"];
            _model.quStr=[resultDic objectForKey:@"regionName"];
            _model.infoAddress=[resultDic objectForKey:@"address"];

            _model.linkman=[resultDic objectForKey:@"linkman"];
            _model.tel=[resultDic objectForKey:@"linkphone"];
            _model.description1=[resultDic objectForKey:@"descript"];

            _model.mappingId=[resultDic objectForKey:@"mappingId"];
            
//            _model.teatureName=[resultDic objectForKey:@"teacherName"];
//            _model.teatureId=[resultDic objectForKey:@"teacherId"];
//            _model.features=[resultDic objectForKey:@"teacherDesc"];
//            _model.cost=[resultDic objectForKey:@"price"];
//        //试听
//            _model.styleID=[resultDic objectForKey:@"taste"];
            
            _model.lat=[resultDic objectForKey:@"lat"];
            _model.lng=[resultDic objectForKey:@"lng"];
       
            
            _model.isCanSeal=[resultDic objectForKey:@"cooperation"];
            _model.score=[resultDic objectForKey:@"score"];
            _model.commentCount=[resultDic objectForKey:@"reviewCount"];
            _model.clickTime=[resultDic objectForKey:@"property"];
            
             _model.user=[[JTUser alloc] init];
            _model.user.userName=[resultDic objectForKey:@"userName"];
            _model.user.loginName=[resultDic objectForKey:@"easemobUsername"];
            _model.user.headPortraitImgUrlStr=[resultDic objectForKey:@"imgUrl"];
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
    }
}


@end
