//
//  JTLoginViewController.h
//  Qyli
//
//  Created by 小七 on 14-7-31.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTPeopleViewController.h"

@interface JTLoginViewController : UIViewController
@property(assign,nonatomic)JTPeopleViewController * peopleVC;
@property(nonatomic,strong)UITextField * nameTextField;
@property(nonatomic,strong)UITextField * psdTextField;

@end
