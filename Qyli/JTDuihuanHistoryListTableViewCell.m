//
//  JTDuihuanHistoryListTableViewCell.m
//  清一丽
//
//  Created by 小七 on 15-2-13.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTDuihuanHistoryListTableViewCell.h"

@implementation JTDuihuanHistoryListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width-20, 80)];
        _bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        _bgImgView.userInteractionEnabled=YES;
        [self addSubview:_bgImgView];
        
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 60)];
        [self.bgImgView addSubview:self.imgView];
        
        
        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 10, self.bounds.size.width-20-90, 20)];
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        [self.bgImgView addSubview:self.titleLab];
        
        
        self.typeLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 30, self.bounds.size.width-20-90, 20)];
        self.typeLab.textColor=[UIColor grayColor];
        self.typeLab.numberOfLines=0;
        self.typeLab.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.typeLab];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 40, 80, 1)];
        lineLab.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
        [self.bgImgView addSubview:lineLab];
        
        self.btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        self.btn1.frame=CGRectMake(self.bounds.size.width-20-70, 10, 60, 20);
        self.btn1.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
        [self.btn1 setTitle:@"礼品详情" forState:UIControlStateNormal];
        [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn1.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.btn1];
        
        self.dateLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 50, self.bounds.size.width-20-90, 20)];
        self.dateLab.font=[UIFont systemFontOfSize:13];
        self.dateLab.textColor=[UIColor grayColor];
        [self.bgImgView addSubview:self.dateLab];
        

        
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
