//
//  JTSortEvaluateModel.h
//  Qyli
//
//  Created by 小七 on 14-9-3.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTSortEvaluateModel : NSObject

@property(nonatomic,strong)NSString * idStr;
@property(nonatomic,strong)NSString * userIDStr;
@property(nonatomic,strong)NSString * parentIdStr;
@property(nonatomic,strong)NSString * mappingIDStr;
@property(nonatomic,strong)NSString * infoIDStr;
@property(nonatomic,strong)NSString * context;
@property(nonatomic,strong)NSString * reviewDate;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,strong)NSString * userHeadPortraitURLStr;
@property(nonatomic,strong)NSString * scroeAvg;

@property(nonatomic,strong)NSString * backReviewCount;
@property(nonatomic,strong)NSMutableArray * backReviewModelArr;

//我的评论新加
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * sortOneId;
@property(nonatomic,strong)NSString * sortTwoId;
@property(nonatomic,strong)NSString * tableName;

@end
