//
//  JTShangpinKaquanTabviewCell.m
//  清一丽
//
//  Created by 小七 on 15-1-6.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTShangpinKaquanTabviewCell.h"

@implementation JTShangpinKaquanTabviewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, self.bounds.size.width-10, 90)];
        _bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:_bgImgView];
        
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width-10-10-150, 80)];
        //self.imgView.image=[UIImage imageNamed:@"代金券.png"];
        [self.bgImgView addSubview:self.imgView];
        
        
        self.begainDateLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-150-5, 5, 150, 20)];
        self.begainDateLab.textAlignment=NSTextAlignmentCenter;
        self.begainDateLab.font=[UIFont systemFontOfSize:13];
        [self.bgImgView addSubview:self.begainDateLab];
        
        self.midDateLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-150-5, 25, 150, 20)];
        self.midDateLab.text=@"至";
        self.midDateLab.textAlignment=NSTextAlignmentCenter;
        self.midDateLab.font=[UIFont systemFontOfSize:13];
        [self.bgImgView addSubview:self.midDateLab];
        
        self.endDateLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-150-5, 45, 150, 20)];
        self.endDateLab.textAlignment=NSTextAlignmentCenter;
        self.endDateLab.font=[UIFont systemFontOfSize:13];
        [self.bgImgView addSubview:self.endDateLab];
        
        self.begainDateLab.textColor=[UIColor grayColor];
        self.midDateLab.textColor=[UIColor grayColor];
        self.endDateLab.textColor=[UIColor grayColor];
        
        
        self.useBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.useBtn.frame=CGRectMake(self.bounds.size.width-150-5+35, 65, 80, 20);
        self.useBtn.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
        [self.useBtn setTitle:@"使    用" forState:UIControlStateNormal];
        self.useBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bgImgView addSubview:self.useBtn];
        self.bgImgView.userInteractionEnabled=YES;
        
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
