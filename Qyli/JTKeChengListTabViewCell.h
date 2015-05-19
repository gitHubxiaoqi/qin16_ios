//
//  JTKeChengListTabViewCell.h
//  Qyli
//
//  Created by 小七 on 14-11-25.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTKeChengListTabViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * hezuoImgView;
@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)UILabel * titleLab;
@property(nonatomic,strong)UILabel * fuTitleLab;
@property(nonatomic,strong)UILabel * priceLab;

@property(nonatomic,strong)UILabel * scroeLab;


@property(nonatomic,strong)UILabel * typeLab;
@property(nonatomic,strong)UILabel * ageLab;
@property(nonatomic,strong)UILabel * clickNumLab;
@property(nonatomic,strong)UIImageView * bgImgView;


//更改界面后
@property(nonatomic,strong)UILabel * quLab;
@property(nonatomic,strong)UILabel * distanceLab;
@end
