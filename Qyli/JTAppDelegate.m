//
//  JTAppDelegate.m
//  Qyli
//
//  Created by 小七 on 14-7-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTAppDelegate.h"

#import "WeiboSDK.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "WXApi.h"
#import <RennSDK/RennSDK.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import"JTAppDelegate+EaseMob.h"

@interface JTAppDelegate()<CLLocationManagerDelegate,UIScrollViewDelegate,UIAlertViewDelegate,IChatManagerDelegate>
{
    BMKMapManager * _mapManager;
    CLLocationManager * _locationManager;
    CLLocation *  _location;
    UIPageControl * _pageControl;
    
    int yindaoyeNum;
    
    NSTimer *connectionTimer;
    BOOL done;

}

@end
@implementation JTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default@2x.png"]];
    imgView.tag=10;
    if (SCREEN_HEIGHT==480) {
        imgView.image=[UIImage imageNamed:@"Default@2x.png"];
    }else if (SCREEN_HEIGHT==568){
        imgView.image=[UIImage imageNamed:@"Default-568h@2x"];
    }else if(SCREEN_HEIGHT==667){
        imgView.image=[UIImage imageNamed:@"Default-375w-667h@2x"];
    }else if(SCREEN_HEIGHT==736){
        imgView.image=[UIImage imageNamed:@"Default-414w-736h@3x"];
        }

    imgView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.window addSubview:imgView];

    
    [self.window makeKeyAndVisible];
 

    
    //分享，第三方登录
    [ShareSDK registerApp:@"3005970f6269"];     //参数为ShareSDK官网中添加应用后得到的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK  connectSinaWeiboWithAppKey:@"3457672972"
        appSecret:@"1c55fbd869603c4dbb2bb24de604b0ff"
    redirectUri:@"http://www.qin16.com"
    weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801539386"
    appSecret:@"8c5889d85b265774b396a4c05cbd9330"
    redirectUri:@"http://store.apple.com/cn"
    wbApiCls:[WeiboApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1102502457"
    appSecret:@"iQNSCISsoa97RGcV"
    qqApiInterfaceCls:[QQApiInterface class]
    tencentOAuthCls:[TencentOAuth class]];
    id <ISSQZoneApp> app  = (id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize: YES];
    
    //添加豆瓣应用  注册网址 http://developers.douban.com
    [ShareSDK
     connectDoubanWithAppKey:@"0dbaa3d1c4ceb3c8292feb754e6c1b58"
    appSecret:@"7d74177a83cd4003"
    redirectUri:@"http://www.qin16.com"];
    
    
    //添加人人网应用 注册网址  http://dev.renren.com
    [ShareSDK connectRenRenWithAppId:@"271625"
    appKey:@"2e51425c7ae249139aca2cb6ec73f4ca"
    appSecret:@"5fd35fa5296a4870a50b732c7ae5c644"
    renrenClientClass:[RennClient class]];

    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx373a5708dd111469"
                           appSecret:@"f91da91660f265126ef3615059a25a11"
                           wechatCls:[WXApi class]];
    
    self.mainViewController=[[JTMainViewController alloc] init];
    self.tabBarViewController=[[JTTabBarViewController alloc] init];
    
    self.appQuArr=[[NSMutableArray alloc] initWithCapacity:0];
    self.appQuIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    self.appShreetArr=[[NSMutableArray alloc] initWithCapacity:0];
    self.appShreetIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    self.supportCityTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    _provinceTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
    _cityTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
    _provinceIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    _cityIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    _quTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
    _streetTitleArr=[[NSMutableArray alloc] initWithCapacity:0];
    _quIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    _streetIDArr=[[NSMutableArray alloc] initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isPush"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isShopPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isNight"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isNight"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self login];

   //地图定位
    self.appLat=@"0.0";
    self.appLng=@"0.0";

    if (SIMULATOR==1)
    {
        //模拟器加这四句
        _location=[[CLLocation alloc] initWithLatitude:31.945847 longitude:118.754101];
        self.appLat=@"31.945847";
        self.appLng=@"118.754101";
        
        // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *array, NSError *error)
         {
             if (array.count > 0)
             {
                 CLPlacemark *placemark = [array objectAtIndex:0];
                 //获取城市
                 NSString *city = placemark.locality;
                 
                 if (!city)
                 {
                     city = placemark.administrativeArea;
                 }
                 
                 [self getCityName:city];
                 
             }
         }];
    }
    else if (SIMULATOR==0)
    {
        
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = [[BMKMapManager alloc]init];
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        BOOL ret = [_mapManager start:@"pvhyq7arbRNLlAmM8QW46PsI"  generalDelegate:nil];
        if (ret)
        {
            if([CLLocationManager locationServicesEnabled])
            {
                _locationManager = [[CLLocationManager alloc] init];
                _locationManager.delegate = self;
                _locationManager.distanceFilter=100;
                [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
                {
                   [_locationManager requestWhenInUseAuthorization];
                }
                else
                {
                   [_locationManager startUpdatingLocation];
                }
                
            }

        }

        //极光推送
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
        [APService setupWithOption:launchOptions];
        
    }

    //环信注册
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    if(self.supportCityTitleArr.count==0)
    {
        self.appLat=@"0.0";
        self.appLng=@"0.0";
        [self getCityName:@"南京市"];
    }

    return YES;

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

-(void)login
{
    
    self.appUser=[[JTUser alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"]!=nil)
    {
        NSString * loginName=[[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"];
        NSString * password=[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        
        if([SOAPRequest checkNet])
        {
            NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:loginName,@"loginName",password,@"password", nil];

                NSDictionary * loginDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_People_LoginURL] jsonDic:jsondic]];
                if([[loginDic objectForKey:@"resultCode"] intValue]==1000)
                {
                    
                    NSDictionary * userDic=[loginDic objectForKey:@"user"];
                    self.appUser.userID=[[userDic objectForKey:@"id"] intValue];
                    self.appUser.loginName=[userDic objectForKey:@"loginName"];
                    self.appUser.password=[userDic objectForKey:@"password"];
                    self.appUser.userName=[userDic objectForKey:@"userName"];
                    NSString * sexStr=[userDic objectForKey:@"sex"];
                    if ([sexStr isEqualToString:@"MALE"])
                    {
                        self.appUser.sex=0;//男
                    }
                    else if ([sexStr isEqualToString:@"FEMALE"])
                    {
                        self.appUser.sex=1;//女
                    }
                    self.appUser.headPortraitImgUrlStr=[userDic objectForKey:@"imageValue"];
                    self.appUser.email=[userDic objectForKey:@"email"];
                    self.appUser.phone=[userDic objectForKey:@"tel"];
                    self.appUser.provinceID=[[userDic objectForKey:@"provinceId"] intValue];
                    self.appUser.cityID=[[userDic objectForKey:@"cityId"] intValue];
                    self.appUser.regionId=[[userDic objectForKey:@"regionId"] intValue];
                    self.appUser.streetId=[[userDic objectForKey:@"streetId"] intValue];
                    self.appUser.provinceValue=[userDic objectForKey:@"provinceName"];
                    self.appUser.cityValue=[userDic objectForKey:@"cityName"];
                    self.appUser.regionName=[userDic objectForKey:@"regionName"];
                    self.appUser.streetName=[userDic objectForKey:@"streetName"];
                    self.appUser.address=[userDic objectForKey:@"address"];
                    self.appUser.isSignin=[userDic objectForKey:@"signinFlag"];
                    self.appUser.isContinuous=[userDic objectForKey:@"continuous"];
                    self.appUser.pointsTitle=[userDic objectForKey:@"pointsTitle"];
                    self.appUser.points=[userDic objectForKey:@"points"];
                    self.appUser.availablePoints=[userDic objectForKey:@"availablePoints"];
                    self.appUser.EMuserLoginName=[userDic objectForKey:@"easemobUsername"];
                    
                    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername: self.appUser.EMuserLoginName password: self.appUser.EMuserLoginName completion:
                     ^(NSDictionary *loginInfo, EMError *error)
                     {
                         if (loginInfo && !error)
                         {
                             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                             //发送自动登陆状态通知
                             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                             //将旧版的coredata数据导入新的数据库
                             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                             if (!error)
                             {
                                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                             }
                         }
                         else
                         {
                             [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error)
                              {
                                  if (error && error.errorCode != EMErrorServerNotLogin)
                                  {
                                  }
                                  else
                                  {
                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                                  }
                              } onQueue:nil];
                             
                             [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.appUser.EMuserLoginName  password:self.appUser.EMuserLoginName
                                                                               completion:^(NSDictionary *loginInfo, EMError *error)
                              {
                                  if (loginInfo && !error)
                                  {
                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                                      //发送自动登陆状态通知
                                      [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                                      //将旧版的coredata数据导入新的数据库
                                      EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                                      if (!error)
                                      {
                                          error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                      }
                                  }
                                  else
                                  {
                                  }
                              } onQueue:nil];
                         }
                     } onQueue:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isShopPush"] isEqualToString:@"1"])
                    {
                        [APService setAlias:[NSString stringWithFormat:@"%d",self.appUser.userID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                    }
                    
                }
            
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}
#pragma mark-
#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    
    _location=newLocation;
    CLLocationCoordinate2D coor=[newLocation coordinate];//当前经纬度
    self.appLat=[NSString stringWithFormat:@"%f",coor.latitude];
    self.appLng=[NSString stringWithFormat:@"%f",coor.longitude];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *city = placemark.locality;
             
             if (!city)
             {
                 city = placemark.administrativeArea;
             }
             
             [self getCityName:city];
             
         }
     }];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

-(void)getCityName:(NSString *)locationCityName
{
    BOOL isSupport;
    isSupport=NO;
    [self.supportCityTitleArr removeAllObjects];
    if ([SOAPRequest checkNet])
    {
        NSDictionary * cityDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Area_getAllArea] jsonDic:@{}]];
        
        if ([[NSString stringWithFormat:@"%@",[cityDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {

            for (int i=0; i<[[cityDic objectForKey:@"provinces"] count]; i++)
            {
                NSString * provinceName=[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"provinceName"];
                NSString * provinceID=[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"provinceId"];
                if (provinceName!=nil)
                {
                    [_provinceTitleArr addObject:provinceName];
                }
                if (provinceID!=nil)
                {
                    [_provinceIDArr addObject:provinceID];
                }
                NSMutableArray * midArr=[[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray * midIDArr=[[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray * midArr2=[[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray * midIDArr2=[[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray * midArr3=[[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray * midIDArr3=[[NSMutableArray alloc] initWithCapacity:0];
                
                
                for (int a=0; a<[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] count]; a++)
                {
                    NSString * cityName=[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"cityName"];
                    NSString * cityID=[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"cityId"];
                    if (cityName!=nil)
                    {
                        [midArr addObject:cityName];
                    }
                    if (cityID!=nil)
                    {
                        [midIDArr addObject:cityID];
                    }
                    
                    NSMutableArray * cqMidArr=[[NSMutableArray alloc] initWithCapacity:0];
                    NSMutableArray * cqMidIDArr=[[NSMutableArray alloc] initWithCapacity:0];
                    NSMutableArray * midArr4=[[NSMutableArray alloc] initWithCapacity:0];
                    NSMutableArray * midIDArr4=[[NSMutableArray alloc] initWithCapacity:0];
                    
                    for (int b=0; b<[[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"regions"] count]; b++)
                    {
                        NSString * quName=[[[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"regions"] objectAtIndex:b] objectForKey:@"regionName"];
                        NSString * quID=[[[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"regions"] objectAtIndex:b] objectForKey:@"regionId"];
                        if (quName!=nil)
                        {
                            [cqMidArr addObject:quName];
                        }
                        if (quID!=nil)
                        {
                            [cqMidIDArr addObject:quID];
                        }
                        
                        NSMutableArray * qsMidArr=[[NSMutableArray alloc] initWithCapacity:0];
                        NSMutableArray * qsMidIDArr=[[NSMutableArray alloc] initWithCapacity:0];
                        for (int c=0; c<[[[[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"regions"] objectAtIndex:b] objectForKey:@"streets"] count]; c++)
                        {
                            NSString * streetName=[[[[[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"regions"] objectAtIndex:b] objectForKey:@"streets"] objectAtIndex:c] objectForKey:@"streetName"];
                            NSString * streetID=[[[[[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"regions"] objectAtIndex:b] objectForKey:@"streets"] objectAtIndex:c] objectForKey:@"streetId"];
                            if (streetName!=nil)
                            {
                                [qsMidArr addObject:streetName];
                            }
                            if (streetID!=nil)
                            {
                                [qsMidIDArr addObject:streetID];
                            }
                        }
                        [midArr4 addObject:qsMidArr];
                        [midIDArr4 addObject:qsMidIDArr];
                    }
                    [midArr2 addObject:cqMidArr];
                    [midIDArr2 addObject:cqMidIDArr];
                    
                    [midArr3 addObject:midArr4];
                    [midIDArr3 addObject:midIDArr4];
                    
                    
                }
                [_cityTitleArr addObject:midArr];
                [_cityIDArr addObject:midIDArr];
                [_quTitleArr addObject:midArr2];
                [_quIDArr addObject:midIDArr2];
                [_streetTitleArr addObject:midArr3];
                [_streetIDArr addObject:midIDArr3];
                
                
            }

            for (int i=0; i<[[cityDic objectForKey:@"provinces"] count]; i++)
            {
                for (int a=0; a<[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] count]; a++)
                {
                    NSString * cityName=[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"cityName"];
                    int isOnLine=[[[[[[cityDic objectForKey:@"provinces"] objectAtIndex:i] objectForKey:@"citys"] objectAtIndex:a] objectForKey:@"online"] intValue];
                    if(isOnLine==1&&cityName!=nil)
                    {
                        [_supportCityTitleArr addObject:cityName];
                    }
                }
            }
        }
    }
    
    for (int i=0; i<_supportCityTitleArr.count; i++)
    {
        if ([locationCityName isEqualToString:[_supportCityTitleArr objectAtIndex:i]])
        {
            isSupport=YES;
            break;
        }
    }
    if (isSupport==YES)
    {
        self.appAutoCityName=locationCityName;
    }
    else
    {
        NSString * str=@"当前城市暂无信息，已自动切换至南京市";
        [JTAlertViewAnimation startAnimation:str view:self.window];
        self.appAutoCityName=@"南京市";
    }
    
    [self getQuAndStreet];
    

}

-(void)getQuAndStreet
{
    if ([SOAPRequest checkNet])
    {
        NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:self.appAutoCityName,@"cityName", nil];
        NSDictionary * cityAreaDic=[[NSDictionary alloc] initWithDictionary:[SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_Area_getRegionAndStreetByCityName] jsonDic:jsondic]];
        
        if ([[NSString stringWithFormat:@"%@",[cityAreaDic objectForKey:@"resultCode"]] isEqualToString:@"1000"])
        {
            self.appCityID =[cityAreaDic objectForKey:@"cityId"];
            self.appCityName=[cityAreaDic objectForKey:@"cityName"];
            self.appProvinceID=[cityAreaDic objectForKey:@"provinceId"];
            
            [self.appQuArr addObject:@"不限"];
            [self.appQuIDArr addObject:@"any"];
            
            NSMutableArray * nullArr=[[NSMutableArray alloc] init];
            NSMutableArray * nullIDArr=[[NSMutableArray alloc] init];
            [self.appShreetArr addObject:nullArr];
            [self.appShreetIDArr addObject:nullIDArr];
            
            for(int i=0;i<[[cityAreaDic objectForKey:@"regions"] count];i++)
            {
                NSString * quStr=[[[cityAreaDic objectForKey:@"regions"] objectAtIndex:i] objectForKey:@"regionName"];
                [self.appQuArr addObject:quStr];
                
                NSString * quIDStr=[[[cityAreaDic objectForKey:@"regions"] objectAtIndex:i] objectForKey:@"regionId"];
                [self.appQuIDArr addObject:quIDStr];
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
                
                [self.appShreetArr addObject:midArr];
                [self.appShreetIDArr addObject:midIDArr];
                
            }
        }

    }
        [self jinru];
}
-(void)jinru
{
    self.appMarkerNum = @"引导页标记0_4";
    yindaoyeNum=4;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"peopleMarkerNum"]!=nil)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"peopleMarkerNum"] isEqualToString:self.appMarkerNum])
        {
            [self kip];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject: self.appMarkerNum forKey:@"peopleMarkerNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self yindaoye];
        }
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject: self.appMarkerNum forKey:@"peopleMarkerNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self yindaoye];
    }
    
}
-(void)yindaoye
{
    
    UIScrollView * scrollView=[[UIScrollView alloc] init];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    scrollView.frame=CGRectMake(0, 0, screenSize.width, screenSize.height);
    scrollView.delegate=self;
    scrollView.contentOffset=CGPointMake(0, 0);
    scrollView.contentSize = CGSizeMake(screenSize.width * yindaoyeNum, screenSize.height);
    scrollView.alwaysBounceHorizontal = YES;//横向一直可拖动
    scrollView.pagingEnabled = YES;//关键属性，打开page模式。
    scrollView.showsHorizontalScrollIndicator = NO;//不要显示滚动条~
    [self.window addSubview:scrollView];
    
    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake((self.window.frame.size.width-100)/2.0, screenSize.height-50, 100, 15)];
    _pageControl.numberOfPages=yindaoyeNum;
    _pageControl.currentPage=0;
    [_pageControl setPageIndicatorTintColor:[UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:231.0/255.0 alpha:1.0]];
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.window addSubview:_pageControl];
    
    for (int i=0; i<yindaoyeNum; i++)
    {
        UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.png",i+1]]];
        imgView.tag=100+i;
        imgView.frame=CGRectMake(screenSize.width*i, 0, screenSize.width, screenSize.height);
        [scrollView addSubview:imgView];
    }
    
    UIImageView * lastImgView=(UIImageView *)[scrollView viewWithTag:100+yindaoyeNum-1];
    lastImgView.userInteractionEnabled=YES;
    UIButton * enterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame=CGRectMake(0, SCREEN_HEIGHT*3/4.0, SCREEN_WIDTH,SCREEN_HEIGHT/4.0);
    [enterBtn addTarget:self action:@selector(kip) forControlEvents:UIControlEventTouchUpInside];
    [lastImgView addSubview:enterBtn];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage=scrollView.contentOffset.x/scrollView.frame.size.width;
    if (_pageControl.currentPage>=yindaoyeNum-1)
    {
        _pageControl.hidden=YES;
    }
    else
    {
        _pageControl.hidden=NO;
    }
}

-(void)kip
{
    UIImageView * imgView=(UIImageView *)[self.window viewWithTag:10];
    [imgView removeFromSuperview];
    self.window.rootViewController=self.tabBarViewController;
}

#pragma mark---- 注册推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}
#pragma mark ----  推送注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{

    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSString * shopIdStr=[userInfo valueForKey:@"shopId"];
    if (shopIdStr!=nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"通知" message:content delegate:self cancelButtonTitle:@"拒收该店铺消息" otherButtonTitles:@"ok,我知道了", nil];
        alert.tag=[[NSString stringWithFormat:@"%@",shopIdStr] intValue]+20000;
        alert.delegate=self;
        [alert show];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"通知" message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok,我知道了", nil];
        alert.tag=10000;
        alert.delegate=self;
        [alert show];
    }

    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    //    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (alertView.tag==10000)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];

    }
    else
    {
        if(buttonIndex==0)
        {
            if ([SOAPRequest checkNet])
            {
                NSDictionary * jsondic=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.appUser.userID],@"userId",[NSString stringWithFormat:@"%d",alertView.tag-20000],@"shopId", nil];
                [SOAPRequest getResponseByPostURL:[NSString stringWithFormat:@"%s%s",QYL_URL,NEW_QYL_NoPush_NotReceiveMessage] jsonDic:jsondic];
            }
        }
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];

    }

}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
