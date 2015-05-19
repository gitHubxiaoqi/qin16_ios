//
//  JTPeopleViewController.h
//  Qyli
//
//  Created by 小七 on 14-7-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTUser.h"

@interface JTPeopleViewController : UIViewController
@property(nonatomic,strong)JTUser * user;
@property(nonatomic,assign)int state;
@end

