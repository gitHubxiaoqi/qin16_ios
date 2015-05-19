//
//  JTMyCommentTableViewCell.m
//  Qyli
//
//  Created by 小七 on 14-10-6.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTMyCommentTableViewCell.h"

@implementation JTMyCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        self.upBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.upBtn.frame=CGRectMake(0,0, self.bounds.size.width, 35);
        [self.upBtn setBackgroundImage:[UIImage imageNamed:@"my_commnet_history_info_title_bg.png"] forState:UIControlStateNormal];
        [self addSubview:self.upBtn];
        
        UIImageView * upJiantouImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_commnet_history_info_title_yuan.png"]];
        upJiantouImgView.frame=CGRectMake(self.bounds.size.width-30, 10, 15, 15);
        [self.upBtn addSubview:upJiantouImgView];
        
        self.titleLab=[[UILabel alloc] init];
        self.titleLab.frame=CGRectMake(5,5,self.bounds.size.width-40, 25);
        self.titleLab.textColor=[UIColor blackColor];
        self.titleLab.font=[UIFont systemFontOfSize:18];
        [self.upBtn addSubview:self.titleLab];
        
        self.downBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.downBtn.frame=CGRectMake(0,35, self.bounds.size.width, 35);

        
        self.dateLab=[[UILabel alloc] init];
        self.dateLab.frame=CGRectMake(self.bounds.size.width-155, 0, 150, 15);
        self.dateLab.font=[UIFont systemFontOfSize:13];
        self.dateLab.textColor=[UIColor grayColor];
        self.dateLab.textAlignment=NSTextAlignmentRight;
        [self.downBtn addSubview:self.dateLab];
        
        self.contentLab=[[TQRichTextView alloc] init];
        self.contentLab.backgroundColor=[UIColor whiteColor];
        self.contentLab.frame=CGRectMake(5, 50, self.bounds.size.width-30, 20);
        self.contentLab.font=[UIFont systemFontOfSize:14];
        self.contentLab.textColor=[UIColor blackColor];
        [self addSubview:self.contentLab];
        
        self.downJiantouImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
        self.downJiantouImgView.frame=CGRectMake(self.bounds.size.width-20,31, 8, 8);
        [self.downBtn addSubview:self.downJiantouImgView];
        
        [self addSubview:self.downBtn];

    }
    return self;
}
-(void)refreshStarAndUI
{
    for (int i=0; i<5; i++)
    {
        if (i<self.scroe)
        {
            UIImageView  * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
            imgView1.frame=CGRectMake(5+i*10, 37, 10, 10);
            [self addSubview:imgView1];
        }
        else
        {
            UIImageView  * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_gray.png"]];
            imgView1.frame=CGRectMake(5+i*10, 37, 10, 10);
            [self addSubview:imgView1];
        }
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
