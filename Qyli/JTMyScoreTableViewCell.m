//
//  JTMyScoreTableViewCell.m
//  Qyli
//
//  Created by 小七 on 14-9-30.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTMyScoreTableViewCell.h"

@implementation JTMyScoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        UILabel * bgLab=[[UILabel alloc] init];
        bgLab.frame=CGRectMake(5, 2.5, self.bounds.size.width-5*2, 55);
        bgLab.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        [self addSubview:bgLab];
        
        self.changePointsLab=[[UILabel alloc] init];
        self.changePointsLab.frame=CGRectMake(self.bounds.size.width-80-10,0, 80, 35);
        self.changePointsLab.backgroundColor=[UIColor clearColor];
        self.changePointsLab.textAlignment=NSTextAlignmentCenter;
        self.changePointsLab.font=[UIFont systemFontOfSize:20];
        [bgLab addSubview:self.changePointsLab];
        
        self.dateLab=[[UILabel alloc] init];
        self.dateLab.frame=CGRectMake(self.bounds.size.width-150-10, 35, 150, 20);
        bgLab.backgroundColor=[UIColor clearColor];
        self.dateLab.textAlignment=NSTextAlignmentRight;
        self.dateLab.textColor=[UIColor grayColor];
        self.dateLab.font=[UIFont systemFontOfSize:14];
        [bgLab addSubview:self.dateLab];
        
        self.remarkLab=[[UILabel alloc] init];
        self.remarkLab.frame=CGRectMake(5, 5,self.bounds.size.width-20-80, 30);
        self.remarkLab.backgroundColor=[UIColor clearColor];
        self.remarkLab.textColor=[UIColor blackColor];
        self.remarkLab.font=[UIFont systemFontOfSize:18];
        [bgLab addSubview:self.remarkLab];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
