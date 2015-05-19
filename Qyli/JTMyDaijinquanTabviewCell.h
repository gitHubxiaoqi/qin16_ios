//
//  JTMyDaijinquanTabviewCell.h
//  清一丽
//
//  Created by 小七 on 15-1-5.
//  Copyright (c) 2015年 ___清一丽___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTMyDaijinquanTabviewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * bgImgView;
@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)UILabel * begainDateLab;
@property(nonatomic,strong)UILabel * midDateLab;
@property(nonatomic,strong)UILabel * endDateLab;
@property(nonatomic,strong)UILabel * shuomingLab;
@property(nonatomic,strong)UILabel * finishLab;
@property(nonatomic,assign)int UsedOrOvertime;
-(void)refreshUI;
@end
