//
//  JTZaojiaoEvaluateTableViewCell.h
//  Qyli
//
//  Created by 小七 on 14-9-3.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"

@interface JTZaojiaoEvaluateTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * headImgView;
@property(nonatomic,strong)UILabel * userNameLab;
@property(nonatomic,strong)UILabel * middleLab;
@property(nonatomic,strong)UILabel * receiverNameLab;
@property(nonatomic,strong)UILabel * dateLab;
@property(nonatomic,strong)UIButton * backReViewBtn;
@property(nonatomic,strong)TQRichTextView * contentLab;
@property(nonatomic,strong)UILabel * lineLab;

-(void)refreshUI;
@end
