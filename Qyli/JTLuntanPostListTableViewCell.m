//
//  JTLuntanPostListTableViewCell.m
//  清一丽
//
//  Created by 小七 on 15-4-14.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import "JTLuntanPostListTableViewCell.h"

@implementation JTLuntanPostListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        _photoImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10,30, 30)];
        _photoImgView.layer.masksToBounds=YES;
        _photoImgView.layer.cornerRadius=15;
        [self addSubview:_photoImgView];
        
        _nameLab=[[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.bounds.size.width-50-120-10, 20)];
        _nameLab.textColor=[UIColor brownColor];
        _nameLab.font=[UIFont systemFontOfSize:14];
        [self addSubview:_nameLab];
        
        _dateLab=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-120-10, 15, 120, 20)];
        _dateLab.textColor=[UIColor grayColor];
        _dateLab.font=[UIFont systemFontOfSize:13];
        [self addSubview:_dateLab];
        
        
        _contentLab=[[TQRichTextView alloc] initWithFrame:CGRectMake(50, 40, self.bounds.size.width-50-10, 60)];
        _contentLab.textColor=[UIColor grayColor];
        _contentLab.font=[UIFont systemFontOfSize:14];
        _contentLab.backgroundColor=[UIColor clearColor];
        [self addSubview:_contentLab];
        
        
        self.bounds=CGRectMake(0, 0, self.bounds.size.width,100+10);
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
