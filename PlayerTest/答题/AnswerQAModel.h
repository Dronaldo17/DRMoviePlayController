//
//  AnswerQAModel.h
//  PlayerTest
//
//  Created by doujingxuan on 13-9-1.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerQAModel : NSObject

@property (nonatomic,retain)NSString * questionID;
@property (nonatomic,retain)NSString * questionTopic;
@property (nonatomic,retain)NSString * type;
@property (nonatomic,retain)NSString * type_name;
@property (nonatomic,retain)NSMutableArray * userChoosedArray;
@property (nonatomic,retain)NSMutableArray * rightArray;
@property (nonatomic,retain)NSMutableArray * tipsArray;
@property (nonatomic,assign)BOOL isRight;

@end
