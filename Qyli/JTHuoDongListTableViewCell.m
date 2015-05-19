//
//  JTHuoDongListTableViewCell.m
//  Qyli
//
//  Created by 小七 on 14-12-8.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTHuoDongListTableViewCell.h"

@implementation JTHuoDongListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        UIImageView * bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 95)];
        bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:bgImgView];
        
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 80, 60)];
        [self addSubview:self.imgView];
        
        self.smallImgView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 32, 75, 15)];
        self.smallImgView.backgroundColor=[UIColor clearColor];
        [self addSubview:self.smallImgView];
        
        self.styleLab=[[UILabel alloc] initWithFrame:CGRectMake(1, 0, 75, 15)];
        self.styleLab.textColor=[UIColor whiteColor];
        self.styleLab.backgroundColor=[UIColor clearColor];
        self.styleLab.font=[UIFont systemFontOfSize:12];
        self.styleLab.textAlignment=NSTextAlignmentCenter;
        [self.smallImgView addSubview:self.styleLab];
        

        
        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.frame.size.width-15-130-25, 30)];
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        [self addSubview:self.titleLab];
        
        self.hezuoImgView=[[UIImageView alloc] init];
        self.hezuoImgView.image=[UIImage imageNamed:@"合作.png"];
        [self addSubview:self.hezuoImgView];
        
        UIImageView * imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map.png"]];
        imgView.frame=CGRectMake(100, 35, 15, 20);
        [self addSubview:imgView];
        
        self.adressLab=[[UILabel alloc] initWithFrame:CGRectMake(115, 35, self.bounds.size.width-10-115, 20)];
        self.adressLab.textColor=[UIColor blackColor];
        self.adressLab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.adressLab];
        
        self.distanceLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-120,10,110, 20)];
        self.distanceLab.font=[UIFont systemFontOfSize:14];
        self.distanceLab.textAlignment=NSTextAlignmentRight;
        self.distanceLab.textColor=[UIColor orangeColor];
        [self addSubview:self.distanceLab];
        
        self.huodongDateLab=[[UILabel alloc] initWithFrame:CGRectMake(105, 55,self.frame.size.width-15-115, 20)];
        self.huodongDateLab.textColor=[UIColor blackColor];
        self.huodongDateLab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.huodongDateLab];
        
        
        self.pelopeNumLab=[[UILabel alloc] initWithFrame:CGRectMake(105, 75, self.frame.size.width-105-130, 20)];
        self.pelopeNumLab.textColor=[UIColor blackColor];
        self.pelopeNumLab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.pelopeNumLab];
        
        self.fabuDateLab=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-130, 70, 120, 30)];
        self.fabuDateLab.font=[UIFont systemFontOfSize:14];
        self.fabuDateLab.textColor=[UIColor grayColor];
        [self addSubview:self.fabuDateLab];
        
        self.bounds=CGRectMake(0, 0, self.bounds.size.width, 100);
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
