//
//  JTCollectionTableViewCell.h
//  Qyli
//
//  Created by 小七 on 14-9-22.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTCollectionTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * titleLab;
@property(nonatomic,strong)UIImageView * picImgView;
@property(nonatomic,strong)UILabel * typeLab;
@property(nonatomic,strong)UILabel * dateLab;

@property(nonatomic,strong)UIButton * editBtn;
@end
