//
//  JTZaojiaoListTableViewCell.m
//  Qyli
//
//  Created by 小七 on 14-8-26.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTZaojiaoListTableViewCell.h"

@implementation JTZaojiaoListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
   
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 120)];
        _bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:_bgImgView];
        

        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 45, 80, 60)];
        [self addSubview:self.imgView];
        

        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.bounds.size.width-20-55-3-15-25, 30)];
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        [self addSubview:self.titleLab];
        
        self.hezuoImgView=[[UIImageView alloc] init];
        self.hezuoImgView.image=[UIImage imageNamed:@"合作.png"];
        [self addSubview:self.hezuoImgView];

        
        
        self.lab1=[[UILabel alloc] initWithFrame:CGRectMake(105, 50, 65, 20)];
        self.lab1.textColor=[UIColor blackColor];
        self.lab1.font=[UIFont systemFontOfSize:14];
        [self addSubview:self.lab1];
        
        _lab2=[[UILabel alloc] initWithFrame:CGRectMake(105, 70, 55, 20)];
        _lab2.textColor=[UIColor blackColor];
        _lab2.font=[UIFont systemFontOfSize:14];
        _lab2.text=@"点击量:";
        [self addSubview:_lab2];
        

        self.typeLab=[[UILabel alloc] initWithFrame:CGRectMake(170, 50, self.bounds.size.width-20-170, 20)];
        self.typeLab.textColor=[UIColor grayColor];
        self.typeLab.numberOfLines=0;
        self.typeLab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.typeLab];
        

        self.quLab=[[UILabel alloc] initWithFrame:CGRectMake(105, 90, self.bounds.size.width-20-105, 20)];
        self.quLab.textColor=[UIColor grayColor];
        self.quLab.font=[UIFont systemFontOfSize:13];
        self.quLab.numberOfLines=0;
        [self addSubview:self.quLab];
        
        
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
        
        self.clickNumLab=[[UILabel alloc] initWithFrame:CGRectMake(160, 70, 100, 20)];
        self.clickNumLab.textColor=[UIColor grayColor];
        self.clickNumLab.font=[UIFont systemFontOfSize:14];
        [self addSubview:self.clickNumLab];
        
        self.scroeLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-30, 60, 30, 40)];
        self.scroeLab.font=[UIFont systemFontOfSize:18];
        self.scroeLab.textColor=[UIColor redColor];
        [self addSubview:self.scroeLab];
        

        self.bounds=CGRectMake(0, 0, self.bounds.size.width,90+self.typeLab.frame.size.height+self.quLab.frame.size.height);
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
