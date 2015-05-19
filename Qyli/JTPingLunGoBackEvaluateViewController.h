//
//  JTPingLunGoBackEvaluateViewController.h
//  Qyli
//
//  Created by 小七 on 14-12-4.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTPingLunGoBackEvaluateViewController : UIViewController
@property(nonatomic,strong)JTSortEvaluateModel * evaluateModel;
@property(nonatomic,strong)JTSortBackEvaluateModel * backEvaluateModel;
@property(nonatomic,assign)int state;
@property(nonatomic,strong)NSString * totalCount;
@end
