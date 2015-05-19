//
//  JTZaojiaoEvaluateSectionHeaderView.m
//  Qyli
//
//  Created by 小七 on 14-9-2.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTZaojiaoEvaluateSectionHeaderView.h"

@implementation JTZaojiaoEvaluateSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        self.scroe=0;
        self.headImgView=[[UIImageView alloc] init];
        self.headImgView.frame=CGRectMake(5, 5, 50, 50);
        [self addSubview:self.headImgView];
        
        self.userNameLab=[[UILabel alloc] init];
        self.userNameLab.frame=CGRectMake(5, 60, 85, 30);
        self.userNameLab.font=[UIFont systemFontOfSize:15];
        self.userNameLab.textColor=[UIColor blueColor];
        self.userNameLab.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.userNameLab];
        
        self.dateLab=[[UILabel alloc] init];
        self.dateLab.frame=CGRectMake(self.bounds.size.width-150-5, 5, 150, 20);
        self.dateLab.font=[UIFont systemFontOfSize:13];
        self.dateLab.textColor=[UIColor grayColor];
        self.dateLab.textAlignment=NSTextAlignmentRight;
        [self addSubview:self.dateLab];
        
        self.contentLab=[[TQRichTextView alloc] init];
        self.contentLab.backgroundColor=[UIColor whiteColor];
        self.contentLab.frame=CGRectMake(90, 25, self.bounds.size.width-90-30, 40);
        self.contentLab.font=[UIFont systemFontOfSize:14];
        self.contentLab.textColor=[UIColor blackColor];
        [self addSubview:self.contentLab];
        
        self.backReViewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.backReViewBtn.frame=CGRectMake(self.bounds.size.width-85-10, self.contentLab.frame.size.height+30, 85, 25);
        [self.backReViewBtn setBackgroundImage:[UIImage imageNamed:@"taolun_button2x.png"] forState:UIControlStateNormal];
        [self addSubview:self.backReViewBtn];
        
        UIImageView * commentImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taolun_news2x.png"]];
        commentImgView.frame=CGRectMake(10, 8, 10, 10);
        [self.backReViewBtn addSubview:commentImgView];
        
        self.backReviewCountLab=[[UILabel alloc] init];
        self.backReviewCountLab.frame=CGRectMake(25, 0, 60, 25);
        self.backReviewCountLab.font=[UIFont systemFontOfSize:14];
        self.backReviewCountLab.textColor=[UIColor grayColor];
        self.backReviewCountLab.textAlignment=NSTextAlignmentLeft;
        [self.backReViewBtn addSubview:self.backReviewCountLab];
        
        self.openBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.openBtn setImage:[UIImage imageNamed:@"btn_arrow_down.png"] forState:UIControlStateNormal];
        self.openBtn.frame=CGRectMake((self.bounds.size.width-15)/2.0, self.contentLab.frame.size.height+40,15,15);
        [self addSubview:self.openBtn];
        
        self.lineLab=[[UILabel alloc] init];
        self.lineLab.backgroundColor=[UIColor grayColor];
        self.lineLab.frame=CGRectMake(5, self.contentLab.frame.size.height+50, self.bounds.size.width-5*2, 0.5);
        [self addSubview:self.lineLab];
        
        self.backgroundColor=[UIColor whiteColor];
                
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
            imgView1.frame=CGRectMake(90+i*10, 5, 10, 10);
            [self addSubview:imgView1];
        }
        else
        {
            UIImageView  * imgView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_gray.png"]];
            imgView1.frame=CGRectMake(90+i*10, 5, 10, 10);
            [self addSubview:imgView1];
        }
    }
    
    self.backReViewBtn.frame=CGRectMake(self.bounds.size.width-85-10, self.contentLab.frame.size.height+30, 85, 25);
    self.openBtn.frame=CGRectMake((self.bounds.size.width-15)/2.0, self.contentLab.frame.size.height+40,15,15);
    self.lineLab.frame=CGRectMake(5, self.contentLab.frame.size.height+60, self.bounds.size.width-5*2, 0.5);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
