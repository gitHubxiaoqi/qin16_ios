//
//  JTDianpuDetailViewController.m
//  Qyli
//
//  Created by 小七 on 14-11-21.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTDianpuDetailViewController.h"
#import "JTShangpinKaquanViewController.h"
#import "JTDianpuSahngpinListTableViewCell.h"
#import "JTShangpinDetailViewController.h"
#import "JTDianpuHuodongDetailViewController.h"
#import "JTDianpuPinglunListViewController.h"

@interface JTDianpuDetailViewController ()<UIWebViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int p;
    UIScrollView * _bigScrollView;
    UIWebView * _webView;
    
    UITableView * _huodongTabView;
    UITableView * _shangpinTabView;
    
    NSMutableArray * _huodongListModelArr;
    NSMutableArray * _shangpinListModelArr;
}
@property(nonatomic ,strong)JTSortModel * model;
@end
@implementation JTDianpuDetailViewController
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
    UIButton *rightBtn1=(UIButton *)[self.view viewWithTag:100];
    if ([[NSString stringWithFormat:@"%@",_model.isCollection] isEqualToString:@"0"])
    {
        [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"未收藏.png"] forState:UIControlStateNormal];
    }
    else
    {
        [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"已收藏.png"] forState:UIControlStateNormal];
    }

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    p=1;
    _huodongListModelArr=[[NSMutableArray alloc] initWithCapacity:0];
    _shangpinListModelArr=[[NSMutableArray alloc] initWithCapacity:0];
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
    navTitailLab.text=@"店铺详情";
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
    
    UIButton * rightBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.frame=CGRectMake(SCREEN_WIDTH-80, (NAV_HEIGHT-20)/2, 20, 20);
    rightBtn1.tag=100;
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"未收藏.png"] forState:UIControlStateNormal];
    [rightBtn1 addTarget:self action:@selector(rightBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:rightBtn1];
    
    UIButton * rightBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame=CGRectMake(SCREEN_WIDTH-40, (NAV_HEIGHT-20)/2, 20, 20);
    rightBtn2.tag=200;
    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"分享新.png"] forState:UIControlStateNormal];
    [rightBtn2 addTarget:self action:@selector(rightBtnClick2) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:rightBtn2];
    
    
    _bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 1000);
    _bigScrollView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    _bigScrollView.backgroundColor=BG_COLOR;
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
    
    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 39)];
    lab1.text=@"店铺信息";
    lab1.font=[UIFont systemFontOfSize:13];
    lab1.textColor=NAV_COLOR;
    lab1.textAlignment=NSTextAlignmentCenter;
    [view1 addSubview:lab1];
    
    UIButton * kaquanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [kaquanBtn setBackgroundImage:[UIImage imageNamed:@"使用卡券.png"] forState:UIControlStateNormal];
    kaquanBtn.frame=CGRectMake(SCREEN_WIDTH-100, 10, 80, 20);
    [kaquanBtn setTitle:@"使用卡券" forState:UIControlStateNormal];
    kaquanBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    kaquanBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [kaquanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [kaquanBtn addTarget:self action:@selector(kaquanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:kaquanBtn];
    
    if ([self.model.isCanSeal intValue]==0)
    {
        kaquanBtn.hidden=YES;
    }
    
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
    
    UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+10, SCREEN_WIDTH, 30)];
    view2.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view2];
    
    for (int i=0; i<5; i++)
    {
        if (i<[[NSString stringWithFormat:@"%@",_model.score] intValue])
        {
            UIImageView  * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
            imgView1.frame=CGRectMake(5+i*10,7, 10, 10);
            [view2 addSubview:imgView1];
        }
        else
        {
            UIImageView  * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_gray.png"]];
            imgView1.frame=CGRectMake(5+i*10, 7, 10, 10);
            [view2 addSubview:imgView1];
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
    [view2 addSubview:scroelab];
    
    UIButton * pinglunBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    pinglunBtn.frame=CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [pinglunBtn setImage:[UIImage imageNamed:@"右箭头.png"] forState:UIControlStateNormal];
    [pinglunBtn setImageEdgeInsets:UIEdgeInsetsMake(10, SCREEN_WIDTH-30, 10, 20)];
    [pinglunBtn addTarget:self action:@selector(pinglun) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:pinglunBtn];
    
    UILabel * pinglunlab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200, 5, 170, 20)];
    pinglunlab.font=[UIFont systemFontOfSize:13];
    pinglunlab.textColor=[UIColor grayColor];
    pinglunlab.textAlignment=NSTextAlignmentRight;
    if (_model.commentCount==nil||[[NSString stringWithFormat:@"%@",_model.commentCount] intValue]==0)
    {
        pinglunlab.text=@"还没有人评价哦！";
        pinglunBtn.enabled=NO;
    }
    else
    {
        pinglunlab.text=[NSString stringWithFormat:@"%@人已评价",_model.commentCount];
        pinglunBtn.enabled=YES;
    }
    [view2 addSubview:pinglunlab];
    
    UIView * view3=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+15, self.view.frame.size.width, 50)];
    view3.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view3];
    
    UILabel * descriptionLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,80, 29)];
    descriptionLab.text=@"店铺描述";
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
    
    UIView * view4=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+20, self.view.frame.size.width, 30)];
    view4.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view4];
    
    UILabel * lab4=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,80, 29)];
    lab4.text=@"店铺活动";
    lab4.textColor=NAV_COLOR;
    lab4.textAlignment=NSTextAlignmentCenter;
    lab4.font=[UIFont systemFontOfSize:13];
    [view4 addSubview:lab4];
    
    UILabel * lineLab4=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(lab4.frame), SCREEN_WIDTH, 1)];
    lineLab4.backgroundColor=BG_COLOR;
    [view4 addSubview:lineLab4];
    
    if (_huodongListModelArr.count>0)
    {
        _huodongTabView=[[UITableView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, _huodongListModelArr.count*70) style:UITableViewStylePlain];
        _huodongTabView.tag=400;
        _huodongTabView.delegate=self;
        _huodongTabView.dataSource=self;
        _huodongTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _huodongTabView.scrollEnabled=NO;
        [view4 addSubview:_huodongTabView];
    }
    else
    {
        UILabel * lab4_1=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 80, 29)];
        lab4_1.textColor=[UIColor grayColor];
        lab4_1.text=@"暂无活动";
        lab4_1.textAlignment=NSTextAlignmentCenter;
        lab4_1.font=[UIFont systemFontOfSize:13];
        [view4 addSubview:lab4_1];
    
    }
    view4.frame=CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+20,SCREEN_WIDTH, 30+_huodongTabView.frame.size.height+5);
    
    UIView * view5=[[UIView alloc] initWithFrame:CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+view4.frame.size.height+25, self.view.frame.size.width, 30)];
    view5.backgroundColor=[UIColor whiteColor];
    [_bigScrollView addSubview:view5];
    
    UILabel * lab5=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,80, 29)];
    lab5.text=@"店铺商品";
    lab5.textColor=NAV_COLOR;
    lab5.textAlignment=NSTextAlignmentCenter;
    lab5.font=[UIFont systemFontOfSize:13];
    [view5 addSubview:lab5];
    
    UILabel * lineLab5=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(lab5.frame), SCREEN_WIDTH, 1)];
    lineLab5.backgroundColor=BG_COLOR;
    [view5 addSubview:lineLab5];
    
    if (_shangpinListModelArr.count>0)
    {
        _shangpinTabView=[[UITableView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, _shangpinListModelArr.count*70) style:UITableViewStylePlain];
        _shangpinTabView.tag=500;
        _shangpinTabView.delegate=self;
        _shangpinTabView.dataSource=self;
        _shangpinTabView.scrollEnabled=NO;
        _shangpinTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [view5 addSubview:_shangpinTabView];
    }
    else
    {
        UILabel * lab5_1=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 80, 29)];
        lab5_1.textColor=[UIColor grayColor];
        lab5_1.text=@"暂无商品";
        lab5_1.textAlignment=NSTextAlignmentCenter;
        lab5_1.font=[UIFont systemFontOfSize:13];
        [view5 addSubview:lab5_1];
        
    }
    view5.frame=CGRectMake(0, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+view4.frame.size.height+25,SCREEN_WIDTH, 30+_shangpinTabView.frame.size.height+5);

    
    _bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, logoImgView.frame.size.height+view1.frame.size.height+view2.frame.size.height+view3.frame.size.height+view4.frame.size.height+view5.frame.size.height+30);
    
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
    mainVC.shangjiaName=_model.title;
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
-(void)kaquanBtnClick
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"0"])
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录，请先登录。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
        [alertView show];
        JTLoginViewController * loginVC=[[JTLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    JTShangpinKaquanViewController * kqVC=[[JTShangpinKaquanViewController alloc] init];
    kqVC.shopId=self.model.idStr;
    [self.navigationController pushViewController:kqVC animated:YES];
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
-(void)rightBtnClick1:(UIButton *)sender
{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"0"])
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登录，请先登录。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK,我知道了。。", nil];
        [alertView show];
        JTLoginViewController * loginVC=[[JTLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        p=1;
        return;
    }
    JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    if ([[NSString stringWithFormat:@"%@",_model.isCollection] isEqualToString:@"0"])
    {
       
        if ([SOAPRequest checkNet])
        {
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",self.sortmodel.idStr,@"targetId",_model.mappingId,@"mappingId",_model.title,@"targetName", nil];
            NSDictionary * zaojiaoCollectionDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_FollowURL] jsonDic:jsondic]];

            if ([[NSString stringWithFormat:@"%@",[zaojiaoCollectionDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
            {
                NSString * str=@"收藏成功！";
                [JTAlertViewAnimation startAnimation:str view:self.view];
                [sender setBackgroundImage:[UIImage imageNamed:@"已收藏.png"] forState:UIControlStateNormal];
                _model.isCollection=@"1";
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
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",appDelegate.appUser.userID],@"userId",self.sortmodel.idStr,@"targetId",_model.mappingId,@"mappingId", nil];
        NSDictionary * zaojiaoCollectionDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_DeleteFollowURL] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoCollectionDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            NSString * str=@"取消收藏成功！";
            [JTAlertViewAnimation startAnimation:str view:self.view];
            [sender setBackgroundImage:[UIImage imageNamed:@"未收藏.png"] forState:UIControlStateNormal];
            _model.isCollection=@"0";
        }
        else
        {
            NSString * str=@"服务器异常，请稍后重试...";
            [JTAlertViewAnimation startAnimation:str view:self.view];
        }
        
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
-(void)pinglun
{
    JTDianpuPinglunListViewController * pinglunVc=[[JTDianpuPinglunListViewController alloc] init];
    pinglunVc.shopIdStr=_model.idStr;
    pinglunVc.state=@"店铺";
    [self.navigationController pushViewController:pinglunVc animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==400)
    {
        return _huodongListModelArr.count;
    }
    else
    {
        return _shangpinListModelArr.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if (tableView.tag==500)
        {
             JTDianpuSahngpinListTableViewCell *customCell=[[JTDianpuSahngpinListTableViewCell alloc] init];
            customCell.selectionStyle=UITableViewCellSelectionStyleNone;
            JTSortModel * model=[_shangpinListModelArr objectAtIndex:indexPath.row];
            [customCell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr] placeholderImage:[UIImage imageNamed:@"adapter_default_icon.png"]];
            
            customCell.titleLab.text=model.title;
            
            if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@""]||model.type==nil)
            {
                customCell.typeLab.text=@"暂无数据";
            }
            else
            {
                customCell.typeLab.text=[NSString stringWithFormat:@"%@",model.type];
                
            }
            return customCell;

           
        }
        else
        {
            UITableViewCell * cell=[[UITableViewCell alloc] init];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            JTSortModel * model=[_huodongListModelArr objectAtIndex:indexPath.row];
            
            UILabel * nameLab=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-120, 20)];
            nameLab.font=[UIFont systemFontOfSize:15];
            nameLab.text=model.title;
            [cell addSubview:nameLab];
            
            UILabel * dateLab=[[UILabel alloc] initWithFrame:CGRectMake(5, 25, self.view.frame.size.width-85, 20)];
            dateLab.font=[UIFont systemFontOfSize:13];
            dateLab.textColor=[UIColor grayColor];
            dateLab.text=[NSString stringWithFormat:@"活动时间:%@至%@",model.beginDate,model.endDate];
            [cell addSubview:dateLab];
            
            UILabel * applyNumLab=[[UILabel alloc] initWithFrame:CGRectMake(5, 45, self.view.frame.size.width-120, 20)];
            applyNumLab.font=[UIFont systemFontOfSize:14];
            applyNumLab.textColor=[UIColor grayColor];
            applyNumLab.text=[NSString stringWithFormat:@"报名人数:%@人",model.cost];
            [cell addSubview:applyNumLab];
            
            UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-85, 25, 80, 20)];
            [cell addSubview:imgView];
            
            UILabel * numLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, imgView.frame.size.width, 20)];
            numLab.font=[UIFont systemFontOfSize:12];
            numLab.textAlignment=NSTextAlignmentCenter;
            numLab.textColor=[UIColor whiteColor];
            [imgView addSubview:numLab];
            
            
            if ([model.styleID intValue]<=0)
            {
                imgView.image=[UIImage imageNamed:@"灰.png"];
                numLab.text=@"已结束";
            }
            else
            {
                imgView.image=[UIImage imageNamed:@"红.png"];
                numLab.text=[NSString stringWithFormat:@"还有%@天结束",model.styleID];
            }
            
            
            UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 70-1, self.view.frame.size.width, 0.5)];
            lineLab.backgroundColor=[UIColor brownColor];
            [cell addSubview:lineLab];
            return cell;
        }


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==400)
    {
        JTDianpuHuodongDetailViewController * huodongVc=[[JTDianpuHuodongDetailViewController alloc] init];
        huodongVc.sortmodel=[[JTSortModel alloc] init];
        JTSortModel *model=[_huodongListModelArr objectAtIndex:indexPath.row];
        huodongVc.state=999;
        huodongVc.sortmodel.idStr=model.idStr;
        [self.navigationController pushViewController:huodongVc animated:YES];
    }
    else
    {
        JTShangpinDetailViewController * huodongVc=[[JTShangpinDetailViewController alloc] init];
        huodongVc.sortmodel=[[JTSortModel alloc] init];
        JTSortModel *model=[_shangpinListModelArr objectAtIndex:indexPath.row];
        huodongVc.state=999;
        huodongVc.sortmodel.idStr=model.idStr;
        [self.navigationController pushViewController:huodongVc animated:YES];
    }
}
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
        
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_DianPu_shop] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]]isEqualToString:@"1000"])
        {
            NSDictionary * resultDic=[[NSDictionary alloc] initWithDictionary:[[zaojiaoDic objectForKey:@"shopDto"] objectForKey:@"shop"]];

            _model=[[JTSortModel alloc] init];
            _model=self.sortmodel;
            _model.idStr=[resultDic objectForKey:@"id"];
            _model.title=[resultDic objectForKey:@"name"];
            _model.quStr=[resultDic objectForKey:@"regionName"];
            _model.street=[resultDic objectForKey:@"streetName"];
            _model.infoAddress=[resultDic objectForKey:@"address"];
            _model.imgUrlStr=[resultDic objectForKey:@"imgUrl"];
            _model.lat=[resultDic objectForKey:@"lat"];
            _model.lng=[resultDic objectForKey:@"lng"];
            _model.description1=[resultDic objectForKey:@"descript"];
            _model.linkman=[resultDic objectForKey:@"linkman"];
            _model.tel=[resultDic objectForKey:@"tel"];
            _model.isCollection=[resultDic objectForKey:@"follow"];
            _model.mappingId=[resultDic objectForKey:@"mappingId"];
            _model.distance=[resultDic objectForKey:@"distance"];
            
            _model.score=[resultDic objectForKey:@"score"];
            _model.commentCount=[resultDic objectForKey:@"reviewCount"];
            
            _model.isCanSeal=[resultDic objectForKey:@"cooperation"];
            
            NSArray* goodsResultArr=[[NSArray alloc] initWithArray:[[zaojiaoDic objectForKey:@"shopDto"] objectForKey:@"goodsList"]];
            for (int i=0; i<goodsResultArr.count; i++)
            {
                JTSortModel * model=[[JTSortModel alloc] init];
                model.idStr=[[goodsResultArr objectAtIndex:i] objectForKey:@"id"];
                model.title=[[goodsResultArr objectAtIndex:i] objectForKey:@"name"];
                model.type=[[goodsResultArr objectAtIndex:i] objectForKey:@"type"];
                model.imgUrlStr=[[goodsResultArr objectAtIndex:i] objectForKey:@"imgUrl"];
                [_shangpinListModelArr addObject:model];
                [_shangpinTabView reloadData];
            }
            NSArray* activityResultArr=[[NSArray alloc] initWithArray:[[zaojiaoDic objectForKey:@"shopDto"] objectForKey:@"activityList"]];
            for (int i=0; i<activityResultArr.count; i++)
            {
                JTSortModel * model=[[JTSortModel alloc] init];
                model.idStr=[[activityResultArr objectAtIndex:i] objectForKey:@"id"];
                model.title=[[activityResultArr objectAtIndex:i] objectForKey:@"name"];
                model.beginDate=[[activityResultArr objectAtIndex:i] objectForKey:@"startDate"];
                model.endDate=[[activityResultArr objectAtIndex:i] objectForKey:@"endDate"];
                model.cost=[[activityResultArr objectAtIndex:i] objectForKey:@"registedCount"];
                model.registTime=[[activityResultArr objectAtIndex:i] objectForKey:@"quota"];
                model.styleID=[[activityResultArr objectAtIndex:i] objectForKey:@"expiration"];
                [_huodongListModelArr addObject:model];
                [_huodongTabView reloadData];
            }
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

@end
