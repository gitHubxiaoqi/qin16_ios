//
//  NSString+Html.h
//  Qyli
//
//  Created by 小七 on 14-9-15.
//  Copyright (c) 2014年 ___清一丽___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Html)
+(NSString *)filterHTML:(NSString *)html;
+(NSDate *)dateFromString1:(NSMutableString *)dateString;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
@end
