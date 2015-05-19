//
//  JTZaojiaoEvaluateTableViewCell.m
//  Qyli
//
//  Created by 小七 on 14-9-3.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTZaojiaoEvaluateTableViewCell.h"

@implementation JTZaojiaoEvaluateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        self.headImgView=[[UIImageView alloc] init];
        self.headImgView.frame=CGRectMake(5, 10, 40, 40);
        [self addSubview:self.headImgView];
        
        self.userNameLab=[[UILabel alloc] init];
        self.userNameLab.frame=CGRectMake(50, 10, 60, 20);
        self.userNameLab.font=[UIFont systemFontOfSize:14];
        self.userNameLab.textColor=[UIColor magentaColor];
        [self addSubview:self.userNameLab];
        
        _middleLab=[[UILabel alloc] init];
        _middleLab.frame=CGRectMake(50+self.userNameLab.frame.size.width, 10,30, 20);
        _middleLab.font=[UIFont systemFontOfSize:14];
        _middleLab.text=@"回复";
        _middleLab.textColor=[UIColor blackColor];
        _middleLab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_middleLab];
        
        self.receiverNameLab=[[UILabel alloc] init];
        self.receiverNameLab.frame=CGRectMake(50+self.userNameLab.frame.size.width+20, 10, 60, 20);
        self.receiverNameLab.font=[UIFont systemFontOfSize:14];
        self.receiverNameLab.textColor=[UIColor magentaColor];
        [self addSubview:self.receiverNameLab];
        
        self.contentLab=[[TQRichTextView alloc] init];
        self.contentLab.backgroundColor=[UIColor clearColor];
        self.contentLab.frame=CGRectMake(50, 30, self.bounds.size.width-20-50, 40);
        self.contentLab.font=[UIFont systemFontOfSize:14];
        self.contentLab.textColor=[UIColor blackColor];
        [self addSubview:self.contentLab];
        
        self.dateLab=[[UILabel alloc] init];
        self.dateLab.frame=CGRectMake(50, 30+self.contentLab.frame.size.height+10, 150, 20);
        self.dateLab.font=[UIFont systemFontOfSize:13];
        self.dateLab.textColor=[UIColor grayColor];
        self.dateLab.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.dateLab];
        
        self.backReViewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.backReViewBtn.frame=CGRectMake(self.bounds.size.width-65-10,30+self.contentLab.frame.size.height+10, 65, 25);
        [self.backReViewBtn setBackgroundImage:[UIImage imageNamed:@"taolun_button2x.png"] forState:UIControlStateNormal];
        [self addSubview:self.backReViewBtn];
        
        UIImageView * commentImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taolun_news2x.png"]];
        commentImgView.frame=CGRectMake(10, 8, 10, 10);
        [self.backReViewBtn addSubview:commentImgView];
        
        UILabel * backReviewCountLab=[[UILabel alloc] init];
        backReviewCountLab.frame=CGRectMake(25, 0, 40, 25);
        backReviewCountLab.text=@"回复";
        backReviewCountLab.font=[UIFont systemFontOfSize:14];
        backReviewCountLab.textColor=[UIColor grayColor];
        backReviewCountLab.textAlignment=NSTextAlignmentLeft;
        [self.backReViewBtn addSubview:backReviewCountLab];
        
        self.lineLab=[[UILabel alloc] init];
        self.lineLab.backgroundColor=[UIColor lightGrayColor];
        self.lineLab.frame=CGRectMake(5,30+self.contentLab.frame.size.height+40, self.bounds.size.width-5*2, 0.5);
        [self addSubview:self.lineLab];
        self.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    }
    return self;
}
-(void)refreshUI
{
    _middleLab.frame=CGRectMake(50+self.userNameLab.frame.size.width, 10, 30, 20);
    self.dateLab.frame=CGRectMake(50, 30+self.contentLab.frame.size.height+10, 150, 20);
    self.backReViewBtn.frame=CGRectMake(self.bounds.size.width-65-10,30+self.contentLab.frame.size.height+10, 65, 25);
    self.lineLab.frame=CGRectMake(5, 30+self.contentLab.frame.size.height+40, self.bounds.size.width-5*2, 0.5);
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
