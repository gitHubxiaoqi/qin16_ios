//
//  JTUser.h
//  Qyli
//
//  Created by 小七 on 14-8-4.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTUser : NSObject

@property(assign,nonatomic)int userID;
@property(strong,nonatomic)NSString * userName;
@property(strong,nonatomic)NSString * loginName;
@property(strong,nonatomic)NSString * password;

@property(nonatomic,assign)BOOL sex;//性别（MALE：男，FEMALE：女）
@property(strong,nonatomic)NSString * headPortraitImgUrlStr;
@property(nonatomic,copy)NSString * email;
@property(strong,nonatomic)NSString * phone;

@property(assign,nonatomic)int provinceID;
@property(assign,nonatomic)int cityID;
@property(strong,nonatomic)NSString * provinceValue;
@property(strong,nonatomic)NSString * cityValue;

@property(strong,nonatomic)NSString * isSignin;//是否已签到
@property(strong,nonatomic)NSString * isContinuous;//连续签到天数

@property(strong,nonatomic)NSString * points;//积分
@property(strong,nonatomic)NSString * availablePoints;//可用积分
@property(strong,nonatomic)NSString * pointsTitle;//积分来源  新版NULL

//新版新增
@property(assign,nonatomic)int regionId;
@property(assign,nonatomic)int streetId;
@property(strong,nonatomic)NSString * regionName;
@property(strong,nonatomic)NSString * streetName;
@property(strong,nonatomic)NSString * address;

@property(strong,nonatomic)NSString * createTime;
@property(strong,nonatomic)NSString * lastLoginTime;
@property(strong,nonatomic)NSString * lastSigninDate;//上次签到时间

@property(strong,nonatomic)NSString * userType;//用户类型（USER:普通，MERCHANT:商家，ADMIN:管理员）
@property(strong,nonatomic)NSString * userShangjiaType;//用户商家类型（1:机构，2:店铺）
@property(strong,nonatomic)NSString * userShangjiaID;//用户商家Id

@property(nonatomic,assign)BOOL status;//用户是否有效

@property(strong,nonatomic)NSString * EMuserLoginName;

@end
