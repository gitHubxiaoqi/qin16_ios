//
//  JTTabBarViewController.m
//  Qyli
//
//  Created by 小七 on 14-7-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTTabBarViewController.h"
#import "JTMainViewController.h"
#import "JTPeopleViewController.h"
#import "JTLuntanViewController.h"


//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
@interface JTTabBarViewController ()<IChatManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
//,BMKMapViewDelegate,BMKLocationServiceDelegate
{
   UIView * _contentView;
    NSArray * _normalBtnImgArr;
    NSArray * _selectedBtnImgArr;
    UIButton * _selectedBtn;
    int p;

    BMKMapView* _mapView ;
    BMKLocationService *_locService;
}
@property (nonatomic,strong)NSMutableArray * viewControllers;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation JTTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    
    [self unregisterNotifications];
}
-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    //    if (_chatListVC) {
    //        if (unreadCount > 0) {
    //            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    //        }else{
    //            _chatListVC.tabBarItem.badgeValue = nil;
    //        }
    //    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}
-(void)viewDidAppear:(BOOL)animated
{
    _mapView.delegate=self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    _mapView.delegate=nil;
}
- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self readyUI];
    
    
    [self didUnreadMessagesCountChanged];
    //把self注册为SDK的delegate
    [self registerNotifications];
    [self setupUnreadMessageCount];
    
    if (SIMULATOR==0&&[CLLocationManager locationServicesEnabled])
    {
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:50.f];
        
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //启动LocationService
        [_locService startUserLocationService];
    }
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    appdelegate.appLat=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    appdelegate.appLng=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
}
// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self showNotificationWithMessage:message];
    }else {
        [self playSoundAndVibration];
    }
}

//-(void)didReceiveCmdMessage:(EMMessage *)message
//{
//    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
//}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
   // EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.alertBody = NSLocalizedString(@"您有一条新消息", @"you have a new message");
//去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}
-(void)readyUI
{
    p=3;
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    _normalBtnImgArr=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"分类1.png"],[UIImage imageNamed:@"微语1.png"],[UIImage imageNamed:@"论坛1.png"],[UIImage imageNamed:@"个人中心1.png"] ,nil];
    _selectedBtnImgArr=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"分类2.png"],[UIImage imageNamed:@"微语2.png"],[UIImage imageNamed:@"论坛2.png"],[UIImage imageNamed:@"个人中心2.png"], nil];


    
    _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _contentView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_contentView];
    
    JTAppDelegate * appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    appDelegate.tabBarView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:appDelegate.tabBarView];
    
    UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.3)];
    lineLab.backgroundColor=[UIColor lightGrayColor];
    [appDelegate.tabBarView addSubview:lineLab];
    
    
    _viewControllers=[[NSMutableArray alloc] initWithCapacity:3];
    //[self putViewController:[JTMainViewController class] inArray:_viewControllers];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:appDelegate.mainViewController];
    nav.navigationBarHidden=YES;
    [_viewControllers addObject:nav];
    //[self putViewController:[JTPeopleViewController class] inArray:_viewControllers];
    
    ListViewController* chatViewController = [[ListViewController alloc] init];
    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [_viewControllers addObject:nav1];
    
    JTLuntanViewController* luntanViewController = [[JTLuntanViewController alloc] init];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:luntanViewController];
    [_viewControllers addObject:nav2];
    
    JTPeopleViewController* peopleViewController = [[JTPeopleViewController alloc] init];
    UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:peopleViewController];
    [_viewControllers addObject:nav3];
    

    
    UIButton * defaultSelectedBtn=nil;
    NSInteger count=[_viewControllers count];
    NSInteger width=self.view.frame.size.width/4.0;
    for (int i=0; i<count; i++)
    {
        UIButton * barBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        barBtn.tag=i+10;
        barBtn.frame=CGRectMake(width*i,0.3, width, 49);
        [barBtn setImage:[_normalBtnImgArr objectAtIndex:i] forState:UIControlStateNormal];
        [barBtn setImage:[_selectedBtnImgArr objectAtIndex:i] forState:UIControlStateSelected];
        [barBtn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate.tabBarView addSubview:barBtn];
        if (i==0)
        {
            defaultSelectedBtn=barBtn;
        }
    }
    [self barBtnClick:defaultSelectedBtn];
}

-(void)barBtnClick:(UIButton *)sender
{
    if (_selectedBtn==sender)
    {
        
    }else
    {
       
        if (p==6)
        {
            UIViewController * lastContentViewController=[_viewControllers objectAtIndex:_selectedBtn.tag-10];
            [lastContentViewController.view removeFromSuperview];
        }
        if (p==3)
        {
            p=6;
         
        }
        _selectedBtn.selected=NO;
        _selectedBtn=sender;
        _selectedBtn.selected=YES;
        
        UIViewController * contentViewController=[_viewControllers objectAtIndex:sender.tag-10];
        [_contentView addSubview:contentViewController.view];

    }
}
//- (void)putViewController:(Class)class inArray:(NSMutableArray* )array {
//    
//    UIViewController* viewController = [[class alloc] init];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//    [array addObject:nav];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
