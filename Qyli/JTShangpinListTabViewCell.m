//
//  JTShangpinListTabViewCell.m
//  Qyli
//
//  Created by 小七 on 14-11-25.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTShangpinListTabViewCell.h"


@implementation JTShangpinListTabViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 110)];
        _bgImgView.image=[UIImage imageNamed:@"背景框.png"];
        [self addSubview:_bgImgView];
        
        self.hezuoImgView=[[UIImageView alloc] init];
        self.hezuoImgView.image=[UIImage imageNamed:@"合作.png"];
        [self addSubview:self.hezuoImgView];
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 45, 80, 60)];
        [self.bgImgView addSubview:self.imgView];
        
        
        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.bounds.size.width-20-55-3-15-25, 30)];
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        [self.bgImgView addSubview:self.titleLab];
        
        UILabel * lineLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-55-3, 15, 0.5, 10)];
        lineLab.backgroundColor=[UIColor grayColor];
        [self.bgImgView addSubview:lineLab];
        
        self.distanceLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-55,5, 65, 30)];
        self.distanceLab.font=[UIFont systemFontOfSize:13];
        self.distanceLab.textColor=[UIColor grayColor];
        self.distanceLab.textAlignment=NSTextAlignmentLeft;
        [self.bgImgView addSubview:self.distanceLab];
        
        UILabel * bigLinLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 35, self.bounds.size.width-20, 1)];
        bigLinLab.backgroundColor=[UIColor grayColor];
        [self.bgImgView addSubview:bigLinLab];
        
        self.shangjiaNameLab=[[UILabel alloc] initWithFrame:CGRectMake(105,45, self.frame.size.width-105-10, 20)];
        self.shangjiaNameLab.textColor=[UIColor blackColor];
        self.shangjiaNameLab.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.shangjiaNameLab];
        
        
        self.lab1=[[UILabel alloc] initWithFrame:CGRectMake(105, 65, 45, 20)];
        self.lab1.textColor=[UIColor blackColor];
        self.lab1.text=@"类别:";
        self.lab1.font=[UIFont systemFontOfSize:14];
        [self.bgImgView addSubview:self.lab1];
        
        
        self.typeLab=[[UILabel alloc] initWithFrame:CGRectMake(150, 65, self.bounds.size.width-10-150-70, 20)];
        self.typeLab.textColor=[UIColor grayColor];
        self.typeLab.numberOfLines=0;
        self.typeLab.font=[UIFont systemFontOfSize:13];
        [self.bgImgView addSubview:self.typeLab];
        
        
        self.quLab=[[UILabel alloc] initWithFrame:CGRectMake(105, 85, self.bounds.size.width-10-105-70, 20)];
        self.quLab.textColor=[UIColor grayColor];
        self.quLab.font=[UIFont systemFontOfSize:13];
        self.quLab.numberOfLines=0;
        [self.bgImgView addSubview:self.quLab];
     
        
        self.priceLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-20-50-5, 60, 70, 20)];
        self.priceLab.font=[UIFont systemFontOfSize:14];
        self.priceLab.textColor=[UIColor redColor];
        [self.bgImgView addSubview:self.priceLab];
        
        
        self.bounds=CGRectMake(0,0, self.bounds.size.width,90+self.typeLab.frame.size.height+self.quLab.frame.size.height);
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
