//
//  JTKnowLedgeListTableViewCell.m
//  清一丽
//
//  Created by 小七 on 14-12-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTKnowLedgeListTableViewCell.h"

@implementation JTKnowLedgeListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width-20, 100)];
        _bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:_bgImgView];
        
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        self.imgView.clipsToBounds=YES;
        self.imgView.layer.cornerRadius=5;
        [self.bgImgView addSubview:self.imgView];
        
        
        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(100, 10, self.bounds.size.width-20-100, 20)];
        self.titleLab.textColor=[UIColor brownColor];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        [self.bgImgView addSubview:self.titleLab];
        
        self.ageLab=[[UILabel alloc] initWithFrame:CGRectMake(100, 30, self.bounds.size.width-20-100, 20)];
        self.ageLab.textColor=[UIColor grayColor];
        self.ageLab.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.ageLab];
        
        self.typeLab=[[UILabel alloc] initWithFrame:CGRectMake(100, 50, self.bounds.size.width-20-100, 20)];
        self.typeLab.textColor=[UIColor grayColor];
        self.typeLab.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.typeLab];
        
        self.clickLab=[[UILabel alloc] initWithFrame:CGRectMake(100, 70, self.bounds.size.width-20-100, 20)];
        self.clickLab.textColor=[UIColor grayColor];
        self.clickLab.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.clickLab];
        
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
