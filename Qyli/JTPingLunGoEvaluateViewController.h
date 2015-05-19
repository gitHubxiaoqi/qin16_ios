//
//  JTPingLunGoEvaluateViewController.h
//  Qyli
//
//  Created by 小七 on 14-12-4.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTPingLunGoEvaluateViewController : UIViewController
@property(nonatomic,strong)NSArray * typeListArr;
@property(nonatomic,strong)NSArray * typeListIDArr;
@property(nonatomic,strong)NSString * mappingID;
@property(nonatomic,strong)NSString * infoID;

//修改新加字段
@property(nonatomic,strong)NSMutableArray * scroeArr;
@property(nonatomic,strong)NSMutableArray * scroeIdArr;
@property(nonatomic,strong)NSString * context;
@property(nonatomic,strong)NSString * idStr;
@end
