//
//  JTMapViewController.m
//  Qyli
//
//  Created by 小七 on 14-9-5.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTMapViewController.h"
#import "BMapKit.h"
#import "BMKBaseComponent.h"
@interface JTMapViewController ()<BMKMapViewDelegate>//,BMKLocationServiceDelegate

{
    BMKMapView* _mapView ;
   // BMKUserLocation * _userLocation;
    //BMKLocationViewDisplayParam * _locationViewDisplayParam;
    
    //BMKLocationService *_locService;
    //CLLocation *_updateLocation;
    
    CLLocationCoordinate2D _myCoor;
    BMKPointAnnotation* _myAnnotation;
}

@end

@implementation JTMapViewController

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
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=NO;
    appDelegate.tabBarView2.hidden=NO;
    appDelegate.tabBarView3.hidden=NO;
}
- (void) viewDidAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    JTAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.tabBarView.hidden=YES;
    appDelegate.tabBarView2.hidden=YES;
    appDelegate.tabBarView3.hidden=YES;
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.lat floatValue];
    coor.longitude = [self.lng floatValue];
    annotation.coordinate = coor;
    annotation.title = self.title;
    annotation.subtitle=self.subTitle;
    [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate:coor animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self readyUI];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width,self.view.frame.size.height-64)];
    _mapView.zoomLevel=17;
   // _mapView.zoomEnabledWithTap=YES;
    [self.view addSubview:_mapView];

    
//    //设置定位精确度，默认：kCLLocationAccuracyBest
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
//    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
//    [BMKLocationService setLocationDistanceFilter:100.f];
//    
//    //初始化BMKLocationService
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    //启动LocationService
//    [_locService startUserLocationService];
}
////实现相关delegate 处理位置信息更新
////处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"heading is %@",userLocation.heading);
//}
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    _mapView.showsUserLocation=YES;
//    [_mapView updateLocationData:userLocation];
//    userLocation.title=@"我的位置";
//    
//    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
//    appdelegate.appLat=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
//    appdelegate.appLng=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
//    
//    _updateLocation=nil;
//    _updateLocation=[[CLLocation alloc] init];
//    _updateLocation=userLocation.location;
//    
////    [_mapView updateLocationViewWithParam:_locationViewDisplayParam];
////    _locationViewDisplayParam.isAccuracyCircleShow=NO;
////    _locationViewDisplayParam.locationViewImgName=@"bnavi_icon_location_fixed@2x";
//}
-(void)readyUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden=YES;
    //自定义导航条
    
    UIView * navLab=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navLab.userInteractionEnabled=YES;
    navLab.backgroundColor=NAV_COLOR;
    [self.view addSubview:navLab];
    
    UILabel * navTitailLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navTitailLab.text=@"地图";
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
    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"定位.png"] forState:UIControlStateNormal];
    [rightBtn2 addTarget:self action:@selector(rightBtnClick2) forControlEvents:UIControlEventTouchUpInside];
    [navLab addSubview:rightBtn2];

}
-(void)leftBtnCilck
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightBtnClick2
{
    [_mapView removeAnnotation:_myAnnotation];
    _myAnnotation=nil;
    JTAppDelegate * appdelegate=[UIApplication sharedApplication].delegate;
    _myAnnotation= [[BMKPointAnnotation alloc]init];
    //CLLocationCoordinate2D coor;
    _myCoor.latitude = [appdelegate.appLat floatValue];
    _myCoor.longitude = [appdelegate.appLng floatValue];
    _myAnnotation.coordinate = _myCoor;
    _myAnnotation.title = @"我的位置";
    [_mapView addAnnotation:_myAnnotation];
    
//    CLLocationCoordinate2D coor;
//    coor.latitude=_updateLocation.coordinate.latitude;
//    coor.longitude=_updateLocation.coordinate.longitude;
  [_mapView setCenterCoordinate:_myCoor animated:YES];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView *pinView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];

    if (annotation != _myAnnotation)
    {
        pinView.pinColor = BMKPinAnnotationColorRed;
    }
    else
    {
        pinView.pinColor = BMKPinAnnotationColorGreen;
    }
    return pinView;
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
