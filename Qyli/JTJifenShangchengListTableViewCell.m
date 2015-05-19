//
//  JTJifenShangchengListTableViewCell.m
//  清一丽
//
//  Created by 小七 on 15-2-13.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTJifenShangchengListTableViewCell.h"

@implementation JTJifenShangchengListTableViewCell
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

        
        self.typeLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 30, 70, 20)];
        self.typeLab.textColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.typeLab.numberOfLines=0;
        self.typeLab.font=[UIFont systemFontOfSize:15];
        [self.bgImgView addSubview:self.typeLab];
        
        self.countLab=[[UILabel alloc] initWithFrame:CGRectMake(155, 30, self.bounds.size.width-20-155-50, 20)];
        self.countLab.textColor=[UIColor grayColor];
        self.countLab.numberOfLines=0;
        self.countLab.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.countLab];

        self.btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        self.btn1.frame=CGRectMake(self.bounds.size.width-20-50, 30, 40, 30);
        self.btn1.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.btn1.layer.masksToBounds=YES;
        self.btn1.layer.cornerRadius=5;
        [self.btn1 setTitle:@"兑换" forState:UIControlStateNormal];
        [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn1.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.btn1];
        
        self.priceLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 50, self.bounds.size.width-20-90, 20)];
        self.priceLab.font=[UIFont systemFontOfSize:14];
        self.priceLab.textColor=[UIColor grayColor];
        [self.bgImgView addSubview:self.priceLab];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 60, 80, 1)];
        lineLab.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1.0];
        [self.bgImgView addSubview:lineLab];
        
        
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
