//
//  UILabel+CalHeight.m
//  uilib
//
//  Created by doujingxuan on 12-12-10.
//  Copyright (c) 2012年 doujingxuan. All rights reserved.
//

#import "UILabel+CalHeight.h"

@implementation UILabel (CalHeight)
-(CGFloat)calculateHeightWithFont:(UIFont *)font
{
    [self setNumberOfLines:0];
    self.lineBreakMode = NSLineBreakByWordWrapping;
    
    //设置一个行高上限
    NSString * labelString = self.text;
    if ((nil != labelString) && [labelString isKindOfClass:[NSString class]]) {
    CGSize size = CGSizeMake(self.frame.size.width,MAXFLOAT);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [self.text  sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
   self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y * 2, labelsize.width, labelsize.height);
        return labelsize.height;
    }
    else{
        return 0.0f;
    }
}
@end
