//
//  JTZaojiaoEvaluateSectionHeaderView.h
//  Qyli
//
//  Created by 小七 on 14-9-2.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"

@interface JTZaojiaoEvaluateSectionHeaderView : UIView
@property(nonatomic,strong)UIImageView * headImgView;
@property(nonatomic,strong)UILabel * userNameLab;
@property(nonatomic,strong)UILabel * dateLab;
@property(nonatomic,strong)UIButton * backReViewBtn;
@property(nonatomic,strong)UILabel * backReviewCountLab;
@property(nonatomic,strong)TQRichTextView * contentLab;
@property(nonatomic,assign)int scroe;
@property(nonatomic,strong)UIButton * openBtn;
@property(nonatomic,strong)UILabel * lineLab;

-(void)refreshStarAndUI;

@end
