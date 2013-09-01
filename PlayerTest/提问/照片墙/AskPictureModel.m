//
//  AskPictureModel.m
//  PlayerTest
//
//  Created by doujingxuan on 13-9-1.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "AskPictureModel.h"

@implementation AskPictureModel
@synthesize imageData,imagePath;
- (void)dealloc
{
    self.imagePath = nil;
    self.imageData = nil;
    [super dealloc];
}
@end
