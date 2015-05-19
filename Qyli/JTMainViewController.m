//
//  JTMainViewController.m
//  Qyli
//
//  Created by 小七 on 14-7-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTMainViewController.h"
#import "JTSearchViewController.h"
#import "JTSecondTabBarViewController.h"
#import "JTThirdTabBarViewController.h"

#import "JTNoticeViewController.h"

#import "JTKnowledgeHeadpageViewcontroller.h"
#import "JTKnowLedgeListViewController.h"

@interface JTMainViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UILabel * _cityLab;
    UITableView * _popTableView;
    NSArray * _cityArr;
    UIPageControl * _pageControl;
    NSTimer * _timer;
    //NSArray * _leibieArr;
    UIScrollView * bigScrollView;
    UIScrollView * smallScrollView;
    

    int p;
    int m;
    
    NSMutableArray * _noticePicUrlArr;
    NSMutableArray * _noticeIdArr;
    NSMutableArray * _noticeTitleArr;
}

@end

@implementation JTMainViewController

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
    
    [super viewWillDisappear:YES];
    
    [_timer invalidate];
    _timer=nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(go) userInfo:nil repeats:YES];
    //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    if (p==1)
    {
        [self onCheckVersion];
        [self sendPost];
    }
    p=2;
    
    JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    _cityLab.text= appDelegate.appCityName;
    if (appDelegate.appCityName==nil&&m==18)
    {
        _cityLab.text=@"南京市";
        [self getQuAndStreet:_cityLab.text];
    }
   
}
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    if ([SOAPRequest checkNet])
    {
        NSDictionary * zaojiaoDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_GetLastIOSVersion] jsonDic:@{}]];
        if ( [[NSString stringWithFormat:@"%@",[zaojiaoDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            NSString *lastVersion =[[zaojiaoDic objectForKey:@"version"] objectForKey:@"versionCode"];
            if (![lastVersion isEqualToString:currentVersion]&&[lastVersion floatValue]>[currentVersion floatValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"更新", nil];
                [alert show];
            
            }
            
        }
        
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/qyli/id917481140?mt=8"];
        [[UIApplication sharedApplication]openURL:url];
    }
}

-(void)getQuAndStreet:(NSString *)cityNameStr
{
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:cityNameStr,@"cityName", nil];
        NSDictionary * cityAreaDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL: [NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Area_getRegionAndStreetByCityName] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[cityAreaDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.appQuArr removeAllObjects];
            [appDelegate.appQuIDArr removeAllObjects];
            [appDelegate.appShreetArr removeAllObjects];
            [appDelegate.appShreetIDArr removeAllObjects];
            
            appDelegate.appCityID =[cityAreaDic objectForKey:@"cityId"];
            appDelegate.appCityName=[cityAreaDic objectForKey:@"cityName"];
            appDelegate.appProvinceID=[cityAreaDic objectForKey:@"provinceId"];
            
            [appDelegate.appQuArr addObject:@"不限"];
            [appDelegate.appQuIDArr addObject:@"any"];
            
            NSMutableArray * nullArr=[[NSMutableArray alloc] init];
            NSMutableArray * nullIDArr=[[NSMutableArray alloc] init];
            [appDelegate.appShreetArr addObject:nullArr];
            [appDelegate.appShreetIDArr addObject:nullIDArr];
            
            for(int i=0;i<[[cityAreaDic objectForKey:@"regions"] count];i++)
            {
                NSString * quStr=[[[cityAreaDic objectForKey:@"regions"] objectAtIndex:i] objectForKey:@"regionName"];
                [appDelegate.appQuArr addObject:quStr];
                
                NSString * quIDStr=[[[cityAreaDic objectForKey:@"regions"] objectAtIndex:i] objectForKey:@"regionId"];
                [appDelegate.appQuIDArr addObject:quIDStr];
                NSMutableArray * midArr=[[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray * midIDArr=[[NSMutableArray alloc] initWithCapacity:0];
                [midArr addObject:@"不限"];
                [midIDArr addObject:@"any"];
                for (int j=0; j<[[[[cityAreaDic objectForKey:@"regions"]  objectAtIndex:i]objectForKey:@"streets"] count]; j++)
                {
                    NSString * streetStr=[[[[[cityAreaDic objectForKey:@"regions"]  objectAtIndex:i]objectForKey:@"streets"] objectAtIndex:j] objectForKey:@"streetName"];
                    [midArr addObject:streetStr];
                    
                    NSString * streetIDStr=[[[[[cityAreaDic objectForKey:@"regions"]  objectAtIndex:i]objectForKey:@"streets"] objectAtIndex:j] objectForKey:@"streetId"];
                    [midIDArr addObject:streetIDStr];
                }
                
                [appDelegate.appShreetArr addObject:midArr];
                [appDelegate.appShreetIDArr addObject:midIDArr];
                
            }
        }

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self readyUI];
    p=1;
    m=9;
    _noticePicUrlArr=[[NSMutableArray alloc] initWithCapacity:0];
    _noticeIdArr=[[NSMutableArray alloc] initWithCapacity:0];
    _noticeTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
}

-(void)readyUI
{
    self.view.backgroundColor=BG_COLOR;
    self.navigationController.navigationBar.hidden=YES;
    
    //自定义导航条
    UIView * navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navBarView.backgroundColor=NAV_COLOR;
    [self.view addSubview:navBarView];
    
  
    _cityLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 24)];
    _cityLab.text= @"南京市";
    _cityLab.textColor=[UIColor whiteColor];
    _cityLab.font=[UIFont systemFontOfSize:18];
    [navBarView addSubview:_cityLab];
    
    
    UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(20, 10, 75, 24);
    [leftBtn addTarget:self action:@selector(changeCity:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    UIImageView * btnImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_select.png"]];
    btnImg.frame=CGRectMake(80, 18, 15, 10);
    [navBarView addSubview:btnImg];
    
    UIView * shadowView=[[UIView alloc] initWithFrame:self.view.frame];
    shadowView.tag=301;
    shadowView.backgroundColor=[UIColor blackColor];
    shadowView.alpha=0.4;
    shadowView.hidden=YES;
    [self.view addSubview:shadowView];
    JTAppDelegate * appdalegate=[UIApplication sharedApplication].delegate;
  _cityArr=[[NSArray alloc] initWithArray:appdalegate.supportCityTitleArr];
    UIButton * rightBtn=[UIButton  buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(110, 8,self.view.frame.size.width-10-110, 28);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"search_bg.png"] forState:UIControlStateNormal];
    
    UIImageView * searchImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    searchImgView.frame=CGRectMake(8, 4, 20, 20);
    [rightBtn addSubview:searchImgView];
    
    UILabel * searchLab=[[UILabel alloc] initWithFrame:CGRectMake(35, 4, 150, 20)];
    searchLab.text=@"请输入类别或关键字";
    searchLab.textColor=[UIColor grayColor];
    searchLab.font=[UIFont systemFontOfSize:14];
    [rightBtn addSubview:searchLab];
    
    [rightBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    
    //背景滚动视图
    bigScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+44, self.view.frame.size.width, self.view.frame.size.height-64-49)];
    [self.view addSubview:bigScrollView];
    
    UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(5, SCREEN_HEIGHT*13.0/48.0+10, SCREEN_WIDTH-10, SCREEN_WIDTH/2.0)];
    view1.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [bigScrollView addSubview:view1];
    
    UIButton * btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"儿童市场2.png"] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor whiteColor];
    btn1.frame=CGRectMake(0, 0, (SCREEN_WIDTH-11)/3.0, SCREEN_WIDTH/2.0);
    [btn1 addTarget:self action:@selector(shangjialianmeng) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn1];
    
//    UIImageView * imgview1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"育儿宝典.png"]];
//    imgview1.frame=CGRectMake(CGRectGetWidth(btn1.frame)/8.0, CGRectGetHeight(btn1.frame)/4.0, CGRectGetWidth(btn1.frame)*3/4.0, CGRectGetHeight(btn1.frame)*2/5.0);
//    [btn1 addSubview:imgview1];
//    
//    UILabel * lab1=[[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(btn1.frame)*3/4.0, CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)/8.0)];
//    lab1.text=@"育儿宝典";
//    lab1.textAlignment=NSTextAlignmentCenter;
//    lab1.font=[UIFont systemFontOfSize:18];
//    lab1.textColor=[UIColor grayColor];
//    [btn1 addSubview:lab1];
    
    UIButton * btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"课外教育2.png"] forState:UIControlStateNormal];
    btn2.frame=CGRectMake(CGRectGetWidth(btn1.frame)+1, 0, (SCREEN_WIDTH-11)/3.0*2, (CGRectGetHeight(btn1.frame)-1)/2.0);
    btn2.backgroundColor=[UIColor whiteColor];
    [btn2 addTarget:self action:@selector(kechengjigou) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn2];
    
//    UIImageView * imgview2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"儿童市场.png"]];
//    imgview2.frame=CGRectMake(CGRectGetWidth(btn2.frame)/5.0, CGRectGetHeight(btn2.frame)/5.0, CGRectGetWidth(btn2.frame)*2/5.0, CGRectGetHeight(btn2.frame)*3/5.0);
//    [btn2 addSubview:imgview2];
//    
//    UILabel * lab2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn2.frame)*3/5.0, 0,50, CGRectGetHeight(btn2.frame))];
//    lab2.text=@"儿童市场";
//    lab2.numberOfLines=0;
//    lab2.textAlignment=NSTextAlignmentCenter;
//    lab2.font=[UIFont systemFontOfSize:18];
//    lab2.textColor=[UIColor grayColor];
//    [btn2 addSubview:lab2];
    
    UIButton * btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"育儿宝典2.png"] forState:UIControlStateNormal];
    btn3.frame=CGRectMake(CGRectGetWidth(btn1.frame)+1, CGRectGetHeight(btn2.frame)+1, (SCREEN_WIDTH-11)/3.0*2, (CGRectGetHeight(btn1.frame)-1)/2.0);
    btn3.backgroundColor=[UIColor whiteColor];
    [btn3 addTarget:self action:@selector(zhishiku) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn3];
    
//    UIImageView * imgview3=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"课外教育.png"]];
//    imgview3.frame=CGRectMake(CGRectGetWidth(btn3.frame)/5.0, CGRectGetHeight(btn3.frame)/5.0, CGRectGetWidth(btn3.frame)*2/5.0, CGRectGetHeight(btn3.frame)*3/5.0);
//    [btn3 addSubview:imgview3];
//    
//    UILabel * lab3=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn3.frame)*3/5.0, 0,50, CGRectGetHeight(btn3.frame))];
//    lab3.text=@"课外教育";
//    lab3.numberOfLines=0;
//    lab3.textAlignment=NSTextAlignmentCenter;
//    lab3.font=[UIFont systemFontOfSize:18];
//    lab3.textColor=[UIColor grayColor];
//    [btn3 addSubview:lab3];
    
    UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*13.0/48.0+10+CGRectGetHeight(view1.frame)+10, SCREEN_WIDTH, SCREEN_WIDTH/2.0+30)];
    view2.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [bigScrollView addSubview:view2];
    
    UILabel * bglab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    bglab.backgroundColor=[UIColor whiteColor];
    [view2 addSubview:bglab];
    
    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    lab.text=@"热门板块";
    lab.textColor=[UIColor brownColor];
    lab.font=[UIFont systemFontOfSize:13];
    [view2 addSubview:lab];
    
    NSArray * arr=[[NSArray alloc] initWithObjects:@"母婴用品",@"儿童摄影",@"才艺",@"启蒙教育",@"亲子娱乐",@"幼儿健康",@"早教",@"优惠卡券", nil];
    NSArray * imgNameArr=[[NSArray alloc] initWithObjects:@"母婴用品.png",@"儿童摄影.png",@"才艺.png",@"启蒙教育.png",@"亲子娱乐.png",@"幼儿健康.png",@"早教.png",@"优惠卡券.png", nil];
    
    for (int i=0; i<8; i++)
    {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i%4*(SCREEN_WIDTH-3)/4.0+i%4, 31+i/4*(CGRectGetHeight(view2.frame)-32)/2.0+i/4, (SCREEN_WIDTH-3)/4.0, (CGRectGetHeight(view2.frame)-32)/2.0);
        btn.tag=70+i;
        btn.backgroundColor=[UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:btn];
        
        UIImageView * imgview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[imgNameArr objectAtIndex:i]]];
        imgview.frame=CGRectMake(CGRectGetWidth(btn.frame)*3/10.0, CGRectGetHeight(btn.frame)/5.0, CGRectGetWidth(btn.frame)*2/5.0, CGRectGetHeight(btn.frame)*2/5.0);
        [btn addSubview:imgview];
        
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(btn.frame)*2/3.0,CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame)/4.0)];
        lab.text=[arr objectAtIndex:i];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.textColor=[UIColor grayColor];
        lab.font=[UIFont systemFontOfSize:15];
        [btn addSubview:lab];

    }
    
    bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width,SCREEN_HEIGHT*13.0/48.0+10+CGRectGetHeight(view1.frame)+10+CGRectGetHeight(view2.frame));



}
-(void)sendPost
{
    if ([SOAPRequest checkNet])
    {

        JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.appLat,@"lat",appDelegate.appLng,@"lon", nil];
        NSDictionary * noticeListDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL: [NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Notice_noticeList] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[noticeListDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            NSArray * listArr=[[NSArray alloc] initWithArray:[noticeListDic objectForKey:@"noticeList"]];
            if ([listArr count]>0)
            {
                for (int i=0; i<listArr.count; i++)
                {
                    NSString * idStr=[[listArr objectAtIndex:i] objectForKey:@"id"];
                    NSString * title=[[listArr objectAtIndex:i] objectForKey:@"title"];
                    NSString * picUrlStr=[[listArr objectAtIndex:i] objectForKey:@"pickey"];
                    [_noticeIdArr addObject:idStr];
                    [_noticeTitleArr addObject:title];
                    [_noticePicUrlArr addObject:picUrlStr];
                }
                NSString * lastIdStr=[_noticeIdArr objectAtIndex:[_noticeIdArr count]-1];
                NSString * lastTitle=[_noticeTitleArr objectAtIndex:[_noticeTitleArr count]-1];
                NSString * lastPicUrl=[_noticePicUrlArr objectAtIndex:[_noticePicUrlArr count]-1];
                [_noticeIdArr insertObject:lastIdStr atIndex:0];
                [_noticeTitleArr insertObject:lastTitle atIndex:0];
                [_noticePicUrlArr insertObject:lastPicUrl atIndex:0];
                
                NSString * firstIdStr=[_noticeIdArr objectAtIndex:0];
                NSString * firstTitle=[_noticeTitleArr objectAtIndex:0];
                NSString * firstPicUrl=[_noticePicUrlArr objectAtIndex:0];
                [_noticeIdArr addObject:firstIdStr];
                [_noticePicUrlArr addObject:firstPicUrl];
                [_noticeTitleArr addObject:firstTitle];
                [self readyUIAgain];

            }
            else
            {
                //自定义广告栏
                UIScrollView * smallScrollView1=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT*13.0/48.0)];
                smallScrollView1.tag=30;
                NSArray * imgArr3=[[NSArray alloc] initWithObjects:@"banner3.png",@"banner1.png",@"banner2.png",@"banner3.png",@"banner1.png",nil];
                smallScrollView1.contentSize=CGSizeMake(imgArr3.count*self.view.frame.size.width, CGRectGetHeight(smallScrollView1.frame));
                smallScrollView1.contentOffset=CGPointMake(self.view.frame.size.width, 0);
                smallScrollView1.pagingEnabled=YES;
                smallScrollView1.delegate=self;
                
                for (int i=0; i<[imgArr3 count]; i++)
                {
                    UIImageView * imgView=[[UIImageView alloc] init ];
                    imgView.image=[UIImage imageNamed:[imgArr3 objectAtIndex:i]];
                    imgView.frame=CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, CGRectGetHeight(smallScrollView1.frame));
                    imgView.tag=i+201;
                    [smallScrollView1 addSubview:imgView];
                }
                [bigScrollView addSubview:smallScrollView1];
                
                UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(smallScrollView1.frame)-15, self.view.frame.size.width, 15)];
                view.backgroundColor=[UIColor blackColor];
                view.alpha=0.1;
                [bigScrollView addSubview:view];
                
                _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100-20, CGRectGetHeight(smallScrollView1.frame)-15, 100, 15)];
                _pageControl.numberOfPages=imgArr3.count-2;
                _pageControl.currentPage=0;
                [_pageControl setPageIndicatorTintColor:[UIColor brownColor]];
                [bigScrollView addSubview:_pageControl];
                
                [_timer invalidate];
                _timer=nil;
                _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(go1) userInfo:nil repeats:YES];
                //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            }
   
         }
        else
        {
            //自定义广告栏
            UIScrollView * smallScrollView1=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT*13.0/48.0)];
            smallScrollView1.tag=30;
            NSArray * imgArr3=[[NSArray alloc] initWithObjects:@"banner3.png",@"banner1.png",@"banner2.png",@"banner3.png",@"banner1.png",nil];
            smallScrollView1.contentSize=CGSizeMake(imgArr3.count*self.view.frame.size.width, CGRectGetHeight(smallScrollView1.frame));
            smallScrollView1.contentOffset=CGPointMake(self.view.frame.size.width, 0);
            smallScrollView1.pagingEnabled=YES;
            smallScrollView1.delegate=self;
            
            for (int i=0; i<[imgArr3 count]; i++)
            {
                UIImageView * imgView=[[UIImageView alloc] init ];
                imgView.image=[UIImage imageNamed:[imgArr3 objectAtIndex:i]];
                imgView.frame=CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, CGRectGetHeight(smallScrollView1.frame));
                imgView.tag=i+201;
                [smallScrollView1 addSubview:imgView];
            }
            [bigScrollView addSubview:smallScrollView1];
            
            UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(smallScrollView1.frame)-15, self.view.frame.size.width, 15)];
            view.backgroundColor=[UIColor blackColor];
            view.alpha=0.1;
            [bigScrollView addSubview:view];
            
            _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100-20, CGRectGetHeight(smallScrollView1.frame)-15, 100, 15)];
            _pageControl.numberOfPages=imgArr3.count-2;
            _pageControl.currentPage=0;
            [_pageControl setPageIndicatorTintColor:[UIColor brownColor]];
            [bigScrollView addSubview:_pageControl];
            
            [_timer invalidate];
            _timer=nil;
            _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(go1) userInfo:nil repeats:YES];
            //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            
        }
         m=18;
    }
    
}

-(void)readyUIAgain
{

    //自定义广告栏
    smallScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT*13.0/48.0)];
    smallScrollView.contentSize=CGSizeMake(_noticePicUrlArr.count*self.view.frame.size.width, CGRectGetHeight(smallScrollView.frame));
    smallScrollView.contentOffset=CGPointMake(self.view.frame.size.width, 0);
    smallScrollView.pagingEnabled=YES;
    smallScrollView.tag=60;
    smallScrollView.delegate=self;
    
    for (int i=0; i<[_noticePicUrlArr count]; i++)
    {
        UIImageView * imgView=[[UIImageView alloc] init];
        
        [imgView setImageWithURL:[NSURL URLWithString:[_noticePicUrlArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]]];
        imgView.frame=CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, CGRectGetHeight(smallScrollView.frame));
        imgView.userInteractionEnabled=YES;
        imgView.tag=i+201;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notice:)];
        tap.numberOfTapsRequired=1;
        [imgView addGestureRecognizer:tap];
        
        [smallScrollView addSubview:imgView];
    }
    [bigScrollView addSubview:smallScrollView];
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(smallScrollView.frame)-15, self.view.frame.size.width, 15)];
    view.backgroundColor=[UIColor blackColor];
    view.alpha=0.1;
    [bigScrollView addSubview:view];
    
    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100-20, CGRectGetHeight(smallScrollView.frame)-15, 100, 15)];
    _pageControl.numberOfPages=_noticePicUrlArr.count-2;
    _pageControl.currentPage=0;
    [_pageControl setPageIndicatorTintColor:[UIColor brownColor]];
    [bigScrollView addSubview:_pageControl];
    
    [_timer invalidate];
    _timer=nil;
    _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(go) userInfo:nil repeats:YES];
    //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

}
-(void)go
{
    //每次便宜一屏的宽度
    CGPoint newOffset = CGPointMake(smallScrollView.contentOffset.x + CGRectGetWidth(smallScrollView.frame), smallScrollView.contentOffset.y);
    [smallScrollView setContentOffset:newOffset animated:YES];
    
}
-(void)go1
{
    UIScrollView * smallScrollView1=(UIScrollView *)[bigScrollView viewWithTag:30];
    //每次便宜一屏的宽度
    CGPoint newOffset = CGPointMake(smallScrollView1.contentOffset.x + CGRectGetWidth(smallScrollView1.frame), smallScrollView1.contentOffset.y);
    [smallScrollView1 setContentOffset:newOffset animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==30)
    {
        NSArray * imgArr3=[[NSArray alloc] initWithObjects:@"banner3.png",@"banner1.png",@"banner2.png",@"banner3.png",@"banner1.png",nil];
        //2、当偏移量达到真正展示的图片的最后一张，即imgArray.count-1的时候初始化偏移量
        if (scrollView.contentOffset.x>=self.view.frame.size.width*(imgArr3.count-1))
        {
            scrollView.contentOffset=CGPointMake(self.view.frame.size.width, 0);
        }
        else if (scrollView.contentOffset.x<=0)
        {
            scrollView.contentOffset=CGPointMake(self.view.frame.size.width*(imgArr3.count-2), 0);
        }
        _pageControl.currentPage=(scrollView.contentOffset.x)/scrollView.frame.size.width-1;
    }
    else if (scrollView.tag==60)
    {
        //2、当偏移量达到真正展示的图片的最后一张，即imgArray.count-1的时候初始化偏移量
        if (smallScrollView.contentOffset.x>=self.view.frame.size.width*(_noticePicUrlArr.count-1))
        {
            smallScrollView.contentOffset=CGPointMake(self.view.frame.size.width, 0);
        }
        else if (smallScrollView.contentOffset.x<=0)
        {
            smallScrollView.contentOffset=CGPointMake(self.view.frame.size.width*(_noticePicUrlArr.count-2), 0);
        }
        //3、总结：就是在原来的基础上把第一张图片多放一次
        _pageControl.currentPage=(smallScrollView.contentOffset.x)/smallScrollView.frame.size.width-1;
    }


}
/*已下是滑动很定时器冲突的问题，例如跳页喽：开始滑动废除定时器，滑动减速重新开启定时器*/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer=nil;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(go) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
-(void)notice:(UITapGestureRecognizer *)sender
{
    int count=sender.view.tag-201;
    NSString * idStr=[_noticeIdArr objectAtIndex:count];
    NSString * titleStr=[_noticeTitleArr objectAtIndex:count];
    JTNoticeViewController * noticeVC=[[JTNoticeViewController alloc] init];
    noticeVC.infoIdStr=idStr;
    noticeVC.infoTitleStr=titleStr;
    [self.navigationController pushViewController:noticeVC animated:YES];
}

-(void)btnClick:(UIButton *)sender
{

    switch (sender.tag-70)
    {
        case 0:
        {
            JTThirdTabBarViewController * thirdTabBarVC=[[JTThirdTabBarViewController alloc] init];
            thirdTabBarVC.SJLMBigState=2;
            [self.navigationController pushViewController:thirdTabBarVC animated:YES];
        }
            break;
        case 1:
        {
            JTThirdTabBarViewController * thirdTabBarVC=[[JTThirdTabBarViewController alloc] init];
            thirdTabBarVC.SJLMBigState=1;
            thirdTabBarVC.SJLMState=3;
            [self.navigationController pushViewController:thirdTabBarVC animated:YES];
        }
            break;
        case 2:
        {
            JTSecondTabBarViewController * secondTabBarVC=[[JTSecondTabBarViewController alloc] init];
            secondTabBarVC.KCJGBigState=1;
            secondTabBarVC.KCJGState=4;
            [self.navigationController pushViewController:secondTabBarVC animated:YES];
        }
            break;
        case 3:
        {
            JTKnowLedgeListViewController * knowledgeListVC=[[JTKnowLedgeListViewController alloc] init];
            knowledgeListVC.typeIDStr=@"107";
            [self.navigationController pushViewController:knowledgeListVC animated:YES];
        }
            break;
        case 4:
        {
            JTThirdTabBarViewController * thirdTabBarVC=[[JTThirdTabBarViewController alloc] init];
            thirdTabBarVC.SJLMBigState=1;
            thirdTabBarVC.SJLMState=4;
            [self.navigationController pushViewController:thirdTabBarVC animated:YES];

        }
            break;
        case 5:
        {
            JTKnowLedgeListViewController * knowledgeListVC=[[JTKnowLedgeListViewController alloc] init];
            knowledgeListVC.typeIDStr=@"106";
            [self.navigationController pushViewController:knowledgeListVC animated:YES];
        }
            break;
        case 6:
        {
            JTSecondTabBarViewController * secondTabBarVC=[[JTSecondTabBarViewController alloc] init];
            secondTabBarVC.KCJGBigState=2;
            secondTabBarVC.KCJGState=1;
            [self.navigationController pushViewController:secondTabBarVC animated:YES];
        }
            break;
        case 7:
        {
            JTThirdTabBarViewController * thirdTabBarVC=[[JTThirdTabBarViewController alloc] init];
            thirdTabBarVC.SJLMBigState=3;
            [self.navigationController pushViewController:thirdTabBarVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)kechengjigou
{
    JTSecondTabBarViewController * secondTabBarVC=[[JTSecondTabBarViewController alloc] init];
    secondTabBarVC.KCJGBigState=1;
    secondTabBarVC.KCJGState=0;
    [self.navigationController pushViewController:secondTabBarVC animated:YES];
}
-(void)shangjialianmeng
{
    JTThirdTabBarViewController * thirdTabBarVC=[[JTThirdTabBarViewController alloc] init];
    thirdTabBarVC.SJLMBigState=1;
    thirdTabBarVC.SJLMState=0;
    [self.navigationController pushViewController:thirdTabBarVC animated:YES];
}
-(void)zhishiku
{
    NSLog(@"进入知识库");
    JTKnowledgeHeadpageViewcontroller * knowVC=[[JTKnowledgeHeadpageViewcontroller alloc] init];
    [self.navigationController pushViewController:knowVC animated:YES];
}
-(void)searchBtn:(UIButton *)sender
{
    JTSearchViewController * sVC=[[JTSearchViewController alloc]init];
    [self.navigationController pushViewController:sVC animated:YES];
}
-(void)changeCity:(UIButton *)sender
{
    UIView * shadowView=[self.view viewWithTag:301];
    [self.view bringSubviewToFront:shadowView];
    shadowView.hidden=NO;
    if (!_popTableView)
    {
        _popTableView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0,0) style:UITableViewStylePlain];
        _popTableView.showsVerticalScrollIndicator=NO;
        _popTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _popTableView.delegate=self;
        _popTableView.dataSource=self;
        [self.view addSubview:_popTableView];
        
    }
    [self.view bringSubviewToFront:_popTableView];

    _popTableView.frame=CGRectMake(0, self.view.center.y-100,self.view.frame.size.width, 200);
    _popTableView.hidden=NO;
//    if ([SOAPRequest checkNet])
//    {
//
//        NSDictionary * cityDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Area_getAllArea] jsonDic:@{}]];
//        
//        if ([[NSString stringWithFormat:@"%@",[cityDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
//        {
//
//            for (int i=0; i<[[cityDic objectForKey:@"provinces"] count]; i++)
//            {
//
//                for (int a=0; a<[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] count]; a++)
//                {
//                    NSString * cityName=[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"cityName"];
//                     int isOnLine=[[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"online"] intValue];
//                    if(isOnLine==1&&cityName!=nil)
//                    {
//                        [_cityArr addObject:cityName];
//                    }
//                }
//            }
//             [_popTableView reloadData];
//        }
//        else
//        {
//            NSString * str=@"服务器异常，请稍后重试...";
//            [JTAlertViewAnimation startAnimation:str view:self.view];
//        }
//    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView * shadowView=[self.view viewWithTag:301];
    shadowView.hidden=YES;
    _popTableView.hidden=YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArr.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.view.frame.size.width, 0.5)];
        lineLab.backgroundColor=[UIColor grayColor];
        [cell addSubview:lineLab];
        
    }
    cell.textLabel.text=[_cityArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView * shadowView=[self.view viewWithTag:301];
    shadowView.hidden=YES;
    _popTableView.hidden=YES;
    
    _cityLab.text=[_cityArr objectAtIndex:indexPath.row];
    
    [self getQuAndStreet:_cityLab.text];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
    UILabel * lab=[[UILabel alloc] initWithFrame:view.frame];
    lab.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
    lab.text=@"切换城市";
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:20];
    [view addSubview:lab];
    return view;
    
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
