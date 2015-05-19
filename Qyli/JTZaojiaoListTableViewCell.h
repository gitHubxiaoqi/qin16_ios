//
//  JTZaojiaoListTableViewCell.h
//  Qyli
//
//  Created by 小七 on 14-8-26.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTZaojiaoListTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)UILabel * titleLab;
@property(nonatomic,strong)UIImageView * hezuoImgView;

@property(nonatomic,strong)UILabel * typeLab;
@property(nonatomic,strong)UILabel * quLab;
@property(nonatomic,strong)UIImageView * bgImgView;


//更改界面后
@property(nonatomic,strong)UILabel * clickNumLab;
@property(nonatomic,strong)UILabel * scroeLab;
@property(nonatomic,strong)UILabel * distanceLab;
@property(nonatomic,strong)UILabel * lab1;
@property(nonatomic,strong)UILabel * lab2;

@end
