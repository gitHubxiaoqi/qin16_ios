//
//  JTDianpuSahngpinListTableViewCell.m
//  清一丽
//
//  Created by 小七 on 15-1-9.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTDianpuSahngpinListTableViewCell.h"

@implementation JTDianpuSahngpinListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width-20, 60)];
        _bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:_bgImgView];
        
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 40)];
        [self.bgImgView addSubview:self.imgView];
        
        
        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(75, 10, self.bounds.size.width-20-75, 20)];
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        [self.bgImgView addSubview:self.titleLab];
        
        self.lab1=[[UILabel alloc] initWithFrame:CGRectMake(75, 30, 45, 20)];
        self.lab1.textColor=[UIColor blackColor];
        self.lab1.text=@"类别:";
        self.lab1.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.lab1];
        
        self.typeLab=[[UILabel alloc] initWithFrame:CGRectMake(120, 30, self.bounds.size.width-20-120, 20)];
        self.typeLab.textColor=[UIColor grayColor];
        self.typeLab.numberOfLines=0;
        self.typeLab.font=[UIFont systemFontOfSize:13];
        [self.bgImgView addSubview:self.typeLab];
        
        
        
        self.bounds=CGRectMake(0, 0, self.bounds.size.width,50+self.typeLab.frame.size.height);
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
