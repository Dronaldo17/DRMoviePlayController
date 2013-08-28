//
//  DRTools.h
//  PlayerTest
//
//  Created by doujingxuan on 13-8-27.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRTools : NSObject
+(NSString*) transSecondToTime:(int)seconds;
+(void)appearViewAnimationWithView:(UIView*)view duration:(float)duration startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame animationName:(NSString*)animationName  delegate:(id)delegate;
@end
