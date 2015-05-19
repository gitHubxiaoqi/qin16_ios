//
//  JTCustomLab.m
//  Qyli
//
//  Created by 小七 on 14-8-28.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTCustomView.h"

@interface JTCustomView()<UITextFieldDelegate>



@end

@implementation JTCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        self.smallLab=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 85, 40)];
        self.smallLab.textAlignment=NSTextAlignmentCenter;
        self.smallLab.textColor=[UIColor blackColor];
        self.smallLab.font=[UIFont systemFontOfSize:17];
        [self addSubview:self.smallLab];
        
        self.textFiled=[[UITextField alloc] initWithFrame:CGRectMake(90, 5, 320-20-90-10, 30)];
        self.textFiled.text=@"";
        self.textFiled.delegate=self;
        self.textFiled.font=[UIFont systemFontOfSize:14];
        self.textFiled.textColor=[UIColor blackColor];
        [self addSubview:self.textFiled];
        
        self.backgroundColor=[UIColor whiteColor];
        self.userInteractionEnabled=YES;

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
