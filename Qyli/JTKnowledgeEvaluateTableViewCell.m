//
//  JTKnowledgeEvaluateTableViewCell.m
//  清一丽
//
//  Created by 小七 on 14-12-29.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import "JTKnowledgeEvaluateTableViewCell.h"

@implementation JTKnowledgeEvaluateTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect rect=self.frame;
        rect.size.width=[UIScreen mainScreen].bounds.size.width;
        self.frame=rect;
        
        
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10,5, 60, 50)];
        self.imgView.clipsToBounds=YES;
        self.imgView.layer.cornerRadius=3;
        [self addSubview:self.imgView];
        
        
        self.titleDateLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 10, self.bounds.size.width-80-10, 20)];
        self.titleDateLab.textColor=[UIColor brownColor];
        self.titleDateLab.font=[UIFont systemFontOfSize:14];
        [self addSubview:self.titleDateLab];
        
        self.countentLab=[[TQRichTextView alloc] initWithFrame:CGRectMake(80, 30, self.bounds.size.width-80-10, 20)];
        self.countentLab.textColor=[UIColor grayColor];
        self.countentLab.font=[UIFont systemFontOfSize:12];
        self.countentLab.backgroundColor=[UIColor clearColor];
        [self addSubview:self.countentLab];
        
        self.lineLab=[[UILabel alloc] initWithFrame:CGRectMake(10,self.bounds.size.height-1, self.bounds.size.width-20, 0.5)];
        self.lineLab.backgroundColor=[UIColor brownColor];
        [self addSubview:self.lineLab];
        
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
