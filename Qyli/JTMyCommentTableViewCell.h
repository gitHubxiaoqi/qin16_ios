//
//  JTMyCommentTableViewCell.h
//  Qyli
//
//  Created by 小七 on 14-10-6.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"
@interface JTMyCommentTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLab;
@property(nonatomic,strong)UILabel * dateLab;
@property(nonatomic,assign)int scroe;
@property(nonatomic,strong)TQRichTextView * contentLab;
@property(nonatomic,strong)UIButton * upBtn;
@property(nonatomic,strong)UIButton * downBtn;
@property(nonatomic,strong)UIImageView *downJiantouImgView;
-(void)refreshStarAndUI;
@end
