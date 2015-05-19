//
//  JTShangpinListTabViewCell.h
//  Qyli
//
//  Created by 小七 on 14-11-25.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTShangpinListTabViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * hezuoImgView;
@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)UILabel * titleLab;
@property(nonatomic,strong)UILabel * shangjiaNameLab;
@property(nonatomic,strong)UILabel * typeLab;
@property(nonatomic,strong)UILabel * priceLab;


@property(nonatomic,strong)UILabel * quLab;
@property(nonatomic,strong)UIImageView * bgImgView;


//更改界面后
@property(nonatomic,strong)UILabel * distanceLab;
@property(nonatomic,strong)UILabel * lab1;

@end
