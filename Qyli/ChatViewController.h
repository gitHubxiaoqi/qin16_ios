//
//  MainViewController.h
//  即时通讯环信Test
//
//  Created by 小七 on 15-3-30.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
@property(nonatomic,strong)NSString * shangjiaName;
@property(nonatomic,strong)NSString * shangjiaPic;
@end
