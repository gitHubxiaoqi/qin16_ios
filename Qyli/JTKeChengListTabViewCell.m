//
//  JTKeChengListTabViewCell.m
//  Qyli
//
//  Created by 小七 on 14-11-25.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTKeChengListTabViewCell.h"

@implementation JTKeChengListTabViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        self.bgImgView=[[UIImageView alloc] init];
        self. bgImgView.frame=CGRectMake(0, 5, SCREEN_WIDTH, 140);
        self.bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:self.bgImgView];
        
        
        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.bounds.size.width-20-55-3-15-25, 30)];
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        [self addSubview:self.titleLab];
        
        self.hezuoImgView=[[UIImageView alloc] init];
        self.hezuoImgView.image=[UIImage imageNamed:@"合作.png"];
        [self addSubview:self.hezuoImgView];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-55-3, 15, 0.5, 10)];
        lineLab.backgroundColor=[UIColor grayColor];
        [self addSubview:lineLab];
        
        
        self.distanceLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-55,5, 65, 30)];
        self.distanceLab.font=[UIFont systemFontOfSize:13];
        self.distanceLab.textColor=[UIColor grayColor];
        self.distanceLab.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.distanceLab];
        
        UILabel * bigLinLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 35, self.bounds.size.width-20, 1)];
        bigLinLab.backgroundColor=[UIColor grayColor];
        [self addSubview:bigLinLab];
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(12, 15+40, 70, 70)];
        self.imgView.layer.masksToBounds=YES;
        self.imgView.layer.cornerRadius=35;
        [self addSubview:self.imgView];
        
        self.fuTitleLab=[[UILabel alloc] initWithFrame:CGRectMake(85, 30, self.frame.size.width-85-60, 30)];
        self.fuTitleLab.textColor=[UIColor blackColor];
        self.fuTitleLab.font=[UIFont systemFontOfSize:14];
        [self addSubview:self.fuTitleLab];
        
        self.priceLab=[[UILabel alloc] initWithFrame:CGRectMake(85+self.fuTitleLab.frame.size.width, 30, 60, 30)];
        self.priceLab.font=[UIFont systemFontOfSize:12];
        self.priceLab.textAlignment=NSTextAlignmentCenter;
        self.priceLab.textColor=[UIColor redColor];
        [self addSubview:self.priceLab];
        
        self.typeLab=[[UILabel alloc] initWithFrame:CGRectMake(85, 55, self.bounds.size.width-20-85, 20)];
        self.typeLab.textColor=[UIColor grayColor];
        self.typeLab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.typeLab];
        
        self.ageLab=[[UILabel alloc] initWithFrame:CGRectMake(85, 75, self.bounds.size.width-20-85, 20)];
        self.ageLab.textColor=[UIColor grayColor];
        self.ageLab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.ageLab];
        
        self.clickNumLab=[[UILabel alloc] initWithFrame:CGRectMake(85, 95, self.bounds.size.width-20-85, 20)];
        self.clickNumLab.textColor=[UIColor grayColor];
        self.clickNumLab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.clickNumLab];
        
        self.quLab=[[UILabel alloc] initWithFrame:CGRectMake(85, 115,self.bounds.size.width-20-85, 20)];
        self.quLab.textColor=[UIColor grayColor];
        self.quLab.font=[UIFont systemFontOfSize:13];
        self.quLab.numberOfLines=0;
        [self addSubview:self.quLab];

        self.scroeLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-80, 65, 80, 20)];
        self.scroeLab.font=[UIFont systemFontOfSize:18];
        self.scroeLab.textColor=[UIColor redColor];
        [self addSubview:self.scroeLab];
        
        self.bounds=CGRectMake(0, 0, self.bounds.size.width, 150);
        
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
