//
//  JTAppDelegate.h
//  Qyli
//
//  Created by 小七 on 14-7-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"JTTabBarViewController.h"
#import"JTMainViewController.h"

@interface JTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)JTTabBarViewController * tabBarViewController;
@property(strong,nonatomic)JTMainViewController * mainViewController;
@property(nonatomic,strong)UIView * tabBarView;
@property(nonatomic,strong)UIView * tabBarView2;
@property(nonatomic,strong)UIView * tabBarView3;
@property(nonatomic,strong)JTUser * appUser;
@property(nonatomic,strong)NSMutableArray * appQuArr;
@property(nonatomic,strong)NSMutableArray * appQuIDArr;
@property(nonatomic,strong)NSMutableArray * appShreetArr;
@property(nonatomic,strong)NSMutableArray * appShreetIDArr;
@property(nonatomic,strong) NSString * appCityID;
@property(nonatomic,strong) NSString * appCityName;
@property(nonatomic,strong) NSString * appProvinceID;
@property(nonatomic,strong) NSString * appLat;
@property(nonatomic,strong) NSString * appLng;

@property(nonatomic,strong)NSString * appAutoCityName;

@property(nonatomic,strong)NSString * appMarkerNum;


@property(nonatomic,strong)NSMutableArray * provinceTitleArr;
@property(nonatomic,strong)NSMutableArray *  cityTitleArr;
@property(nonatomic,strong)NSMutableArray * quTitleArr;
@property(nonatomic,strong)NSMutableArray *  streetTitleArr;
@property(nonatomic,strong)NSMutableArray *  provinceIDArr;
@property(nonatomic,strong)NSMutableArray * cityIDArr;
@property(nonatomic,strong)NSMutableArray * quIDArr;
@property(nonatomic,strong)NSMutableArray * streetIDArr;

@property(nonatomic,strong)NSMutableArray *  supportCityTitleArr;

@end
