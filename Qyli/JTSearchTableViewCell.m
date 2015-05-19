//
//  JTSearchTableViewCell.m
//  Qyli
//
//  Created by 小七 on 14-9-30.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTSearchTableViewCell.h"

@implementation JTSearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        self.headImgView= [[UIImageView alloc] init];
        self.headImgView.frame=CGRectMake(5, 5, 70, 60);
        [self addSubview:self.headImgView];
        
        self.titleLab=[[UILabel alloc] init];
        self.titleLab.frame=CGRectMake(80,5, self.frame.size.width-80-10, 30);
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLab];
        
        UILabel * typeKeyLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 30, 45, 20)];
        typeKeyLab.text=@"类型：";
        typeKeyLab.font=[UIFont systemFontOfSize:14];
        typeKeyLab.textColor=[UIColor blackColor];
        [self addSubview:typeKeyLab];
        
        self.typeLab=[[UILabel alloc] init];
        self.typeLab.frame=CGRectMake(120, 30, self.frame.size.width-120-10, 20);
        self.typeLab.textColor=[UIColor grayColor];
        self.typeLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.typeLab];
        
//        UILabel * dateKeyLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 35, 70, 20)];
//        dateKeyLab.text=@"发布时间：";
//        dateKeyLab.font=[UIFont systemFontOfSize:14];
//        dateKeyLab.textColor=[UIColor grayColor];
//        [self addSubview:dateKeyLab];
//        
//        self.dateLab=[[UILabel alloc] init];
//        self.dateLab.frame=CGRectMake(145, 35, self.bounds.size.width-145-10, 20);
//        self.dateLab.textColor=[UIColor grayColor];
//        self.dateLab.font=[UIFont systemFontOfSize:14];
//        [self.contentView addSubview:self.dateLab];
        
        self.adressLab=[[UILabel alloc] init];
        self.adressLab.frame=CGRectMake(80, 50,self.bounds.size.width-80-10-55, 20);
        self.adressLab.textColor=[UIColor grayColor];
        self.adressLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.adressLab];
        
        self.distanceLab=[[UILabel alloc] init];
        self.distanceLab.frame=CGRectMake(self.bounds.size.width-10-55, 50,65, 20);
        self.distanceLab.textColor=[UIColor grayColor];
        self.distanceLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.distanceLab];

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
