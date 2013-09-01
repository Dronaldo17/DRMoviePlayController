//
//  CatAnswerModel.m
//  PlayerTest
//
//  Created by doujingxuan on 13-9-1.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "CatAnswerModel.h"

@implementation CatAnswerModel
@synthesize questionID,questionString,askerAvatar,askerName,answerAvatar,answerName,answerString,imageArray,voiceUrl;
- (void)dealloc
{
    self.questionID = nil;
    self.questionString = nil;
    self.askerAvatar = nil;
    self.askerName = nil;
    self.answerAvatar = nil;
    self.answerName = nil;
    self.answerString = nil;
    self.imageArray = nil;
    self.voiceUrl = nil;
    [super dealloc];
}
@end
