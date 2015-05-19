//
//  JTLuntanPostListTableViewCell.h
//  清一丽
//
//  Created by 小七 on 15-4-14.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"
@interface JTLuntanPostListTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * photoImgView;
@property(nonatomic,strong)UILabel * nameLab;
@property(nonatomic,strong)UILabel * dateLab;
@property(nonatomic,strong)TQRichTextView * contentLab;
@end
