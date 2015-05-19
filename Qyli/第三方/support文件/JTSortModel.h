//
//  JTSortModel.h
//  Qyli
//
//  Created by 小七 on 14-8-26.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTSortModel : NSObject

@property(nonatomic,strong)NSString * idStr;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * score;
@property(nonatomic,strong)NSString * registTime;
@property(nonatomic,strong)NSString * cost;
@property(nonatomic,strong)NSString * street;
@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSString * imgUrlStr;
@property(nonatomic,strong)NSString * loadIDStr;
@property(nonatomic,strong)NSString * loadStr;
@property(nonatomic,strong)NSString * quIDStr;
@property(nonatomic,strong)NSString * quStr;
@property(nonatomic,strong)NSString * cityIDStr;
@property(nonatomic,strong)NSString * cityStr;
@property(nonatomic,strong)NSString * distance;
@property(nonatomic,strong)NSString * infoAddress;
@property(nonatomic,strong)NSString * lat;
@property(nonatomic,strong)NSString * lng;
@property(nonatomic,strong)NSString * tableName;


@property(nonatomic,strong)NSString * sortOneId;
@property(nonatomic,strong)NSString * sortTwoId;

//新版商品增加
@property(nonatomic,strong)NSString * fuId;
@property(nonatomic,strong)NSString * fuName;
@property(nonatomic,strong)NSString * isCanSeal;
@property(nonatomic,strong)NSString * streetIDStr;

@property(nonatomic,strong)NSString * teatureId;
@property(nonatomic,strong)NSString * teatureName;


//幼儿园列表、详细页多出数据
@property(nonatomic,strong)NSString * xingzhi;


@property(nonatomic,strong)NSString * area;
@property(nonatomic,strong)NSString * openDay;
@property(nonatomic,strong)NSString * beginDate;
@property(nonatomic,strong)NSString * endDate;
@property(nonatomic,strong)NSString * features;
@property(nonatomic,strong)NSString * admiScope;//招生范围
@property(nonatomic,strong)NSString * requirements;//招生要求
@property(nonatomic,strong)NSString * setClass;//班级设置
@property(nonatomic,strong)NSString * sortOneStr;
@property(nonatomic,strong)NSString * sortTwoStr;

//小学列表、详细页多出数据
@property(nonatomic,strong)NSString * brochure;//招生简章
@property(nonatomic,strong)NSString * entryRequirement;//入学条件
@property(nonatomic,strong)NSString * belongsSchoolDistrict;//所属学区

//初中列表、详细页多出数据
@property(nonatomic,strong)NSString * boarding;//是否提供住宿
@property(nonatomic,strong)NSString * boardingID;

//课外辅导列表、详细页多出数据
@property(nonatomic,strong)NSString * style;//授课方式
@property(nonatomic,strong)NSString * openTime;//开课时间

//个人中心收藏多出数据
@property(nonatomic,strong)NSString * collectionId;
@property(nonatomic,strong)NSString * commentCount;
@property(nonatomic,strong)NSString * collectionCount;


//个人中心帖子多出数据
@property(nonatomic,strong)NSString * fabuId;
@property(nonatomic,strong)NSArray * imgUrlArr;
@property(nonatomic,strong)NSString * xingzhiID;
@property(nonatomic,strong)NSString * typeID;
@property(nonatomic,strong)NSString * styleID;

//详细页多出数据

@property(nonatomic,strong)NSString * releaserId;
@property(nonatomic,strong)NSString * mappingId;
@property(nonatomic,strong)NSString * clickTime;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * age;
@property(nonatomic,strong)NSString * webSite;
@property(nonatomic,strong)NSString * classDate;
@property(nonatomic,strong)NSString * description1;
@property(nonatomic,strong)NSString * course;
@property(nonatomic,strong)NSString * offer;
@property(nonatomic,strong)NSString * linkman;
@property(nonatomic,strong)NSString * tel;
@property(nonatomic,strong)NSString * provinceIDStr;
@property(nonatomic,strong)NSString * provinceStr;

@property(nonatomic,strong)NSString * isCollection;
@property(nonatomic,strong)NSString * collectionTime;

@property(nonatomic,strong)JTUser * user;

@end
