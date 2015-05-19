//
//  JTMyDaijinquanTabviewCell.m
//  清一丽
//
//  Created by 小七 on 15-1-5.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTMyDaijinquanTabviewCell.h"

@implementation JTMyDaijinquanTabviewCell
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
        
        self.shuomingLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-150-5, 65, 150, 20)];
        self.shuomingLab.text=@"店铺代金券";
        self.shuomingLab.textAlignment=NSTextAlignmentCenter;
        self.shuomingLab.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.shuomingLab];
        
        self.finishLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-150-5+25, 37,100, 25)];
        self.finishLab.textColor=[UIColor whiteColor];
        self.finishLab.textAlignment=NSTextAlignmentCenter;
        self.finishLab.font=[UIFont systemFontOfSize:18];
        [self.bgImgView addSubview:self.finishLab];
        
    }
    return self;
}
-(void)refreshUI
{
    if (self.finishLab.hidden==NO)
    {
        self.begainDateLab.textColor=[UIColor lightGrayColor];
        self.midDateLab.textColor=[UIColor lightGrayColor];
        self.endDateLab.textColor=[UIColor lightGrayColor];
        self.shuomingLab.textColor=[UIColor lightGrayColor];
        if (self.UsedOrOvertime==1)
        {
            self.finishLab.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:77.0/255.0 blue:110.0/255.0 alpha:1];
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
        self.begainDateLab.textColor=[UIColor grayColor];
        self.midDateLab.textColor=[UIColor grayColor];
        self.endDateLab.textColor=[UIColor grayColor];
        self.shuomingLab.textColor=[UIColor purpleColor];
    }
    
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
