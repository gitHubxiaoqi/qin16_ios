//
//  JTCollectionTableViewCell.m
//  Qyli
//
//  Created by 小七 on 14-9-22.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

@implementation JTCollectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        self.titleLab=[[UILabel alloc] init];
        self.titleLab.frame=CGRectMake(90,10, self.bounds.size.width-100, 25);
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLab];
        
        self.typeLab=[[UILabel alloc] init];
        self.typeLab.frame=CGRectMake(90,40, self.bounds.size.width-100, 20);
        self.typeLab.textColor=[UIColor grayColor];
        self.typeLab.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.typeLab];
        
        self.picImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 60)];
        [self.contentView addSubview:self.picImgView];
        
        self.dateLab=[[UILabel alloc] init];
        self.dateLab.frame=CGRectMake(90,60, self.bounds.size.width-100, 20);
        self.dateLab.textColor=[UIColor grayColor];
        self.dateLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.dateLab];
        
        UILabel * lineLab=[[UILabel alloc] init];
        lineLab.frame=CGRectMake(0, 89, self.bounds.size.width, 0.5);
        lineLab.backgroundColor=[UIColor brownColor];
        [self addSubview:lineLab];
        
        self.editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.editBtn.frame=CGRectMake(5, 30, 30, 30);
        [self addSubview:self.editBtn];
        
        self.bounds=CGRectMake(0, 0, self.bounds.size.width,90);
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
