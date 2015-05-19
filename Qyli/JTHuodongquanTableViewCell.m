//
//  JTHuodongquanTableViewCell.m
//  清一丽
//
//  Created by 小七 on 15-2-15.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTHuodongquanTableViewCell.h"

@implementation JTHuodongquanTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5,5, self.bounds.size.width-10, 80)];
        _bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:_bgImgView];
        
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 60)];
        [self.bgImgView addSubview:self.imgView];
        
        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 10, self.bounds.size.width-20-90, 20)];
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:15];
        [self.bgImgView addSubview:self.titleLab];
        
        self.dateLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 30, self.bounds.size.width-20-90, 20)];
        self.dateLab.textColor=[UIColor grayColor];
        self.dateLab.font=[UIFont systemFontOfSize:13];
        [self.bgImgView addSubview:self.dateLab];
        
        self.numLab=[[UILabel alloc] initWithFrame:CGRectMake(90, 50, self.bounds.size.width-20-90, 20)];
        self.numLab.textColor=[UIColor brownColor];
        self.numLab.font=[UIFont systemFontOfSize:13];
        [self.bgImgView addSubview:self.numLab];
        
        self.finishLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-70, 30,55, 20)];
        self.finishLab.textColor=[UIColor whiteColor];
        self.finishLab.textAlignment=NSTextAlignmentCenter;
        self.finishLab.font=[UIFont systemFontOfSize:15];
        [self.bgImgView addSubview:self.finishLab];
        
        self.zeBarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.zeBarBtn.frame=CGRectMake(SCREEN_WIDTH-75, 60, 60, 20);
        [self.zeBarBtn setTitle:@"二维码" forState:UIControlStateNormal];
        self.zeBarBtn.userInteractionEnabled=YES;
        self.zeBarBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.zeBarBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.zeBarBtn.backgroundColor=[UIColor clearColor];
        [self addSubview:self.zeBarBtn];
        
    }
    return self;
}
-(void)refreshUI
{
    if (self.finishLab.hidden==NO)
    {
        if (self.UsedOrOvertime==1)
        {
            self.finishLab.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1];
            self.finishLab.text=@"已使用";
        }
        else  if (self.UsedOrOvertime==2)
        {
            self.finishLab.backgroundColor=[UIColor grayColor];
            self.finishLab.text=@"已过期";
        }

    }
    else if (self.finishLab.hidden==YES)
    {

    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
