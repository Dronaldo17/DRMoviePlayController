//
//  DRTools.m
//  PlayerTest
//
//  Created by doujingxuan on 13-8-27.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "DRTools.h"

@implementation DRTools
+(NSString*) transSecondToTime:(int)seconds
{
    NSString * timeString = nil;
    if (seconds < 10) {
        timeString = [NSString stringWithFormat:@"0:0%d",seconds];
        return timeString;
    }
    if (10 <= seconds && seconds < 60) {
        timeString = [NSString stringWithFormat:@"0:%d",seconds];
        return timeString;
    }
    if (seconds > 60 * 60) {
        int hour = seconds / (60*60);
        int min = (seconds /60)%60;
        int sec = seconds % 60;
        
        NSString * minString = nil;
        NSString * secString = nil;
        
        if (min < 10) {
            minString = [NSString stringWithFormat:@"0%d",min];
        }
        else{
            minString = [NSString stringWithFormat:@"%d",min];
        }
        if (sec < 10) {
            secString = [NSString stringWithFormat:@"0%d",sec];
        }
        else{
            secString = [NSString  stringWithFormat:@"%d",sec];
        }
        timeString = [NSString stringWithFormat:@"%d:%@:%@",hour,minString,secString];
        return timeString;
    }
    if (seconds > 60) {
        int min = seconds / 60;
        int sec = seconds % 60;
        NSString * secString = nil;
        if (sec < 10) {
            secString = [NSString stringWithFormat:@"0%d",sec];
        }else{
            secString = [NSString  stringWithFormat:@"%d",sec];
        }
        timeString = [NSString stringWithFormat:@"%d:%@",min,secString];
        return timeString;
    }
           return timeString;
}
+(void)appearViewAnimationWithView:(UIView*)view duration:(float)duration startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame animationName:(NSString*)animationName  delegate:(id)delegate
{
    /*开始位置、结束位置、大小、速度 */
    // 开始位置
    //_middleView.frame = CGRectMake(0,67,320,10); /* 从屏幕上沿出现 */
    view.frame = startFrame;
    
    [UIView beginAnimations:nil context:view];
    // 速度
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:delegate];
    
    // 结束位置
    view.frame = endFrame;
    
    // 设置动画结束的处理事件
    [UIView commitAnimations];
}
@end
