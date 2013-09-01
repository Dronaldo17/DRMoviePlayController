//
//  AnswerQAModel.m
//  PlayerTest
//
//  Created by doujingxuan on 13-9-1.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "AnswerQAModel.h"

@implementation AnswerQAModel
@synthesize questionID,questionTopic,userChoosedArray,rightArray,tipsArray,type,type_name,isRight;
- (void)dealloc
{
    self.questionID = nil;
    self.questionTopic = nil;
    self.userChoosedArray = nil;
    self.rightArray = nil;
    self.tipsArray = nil;
    self.type_name = nil;
    self.type  = nil;
    [super dealloc];
}
@end
