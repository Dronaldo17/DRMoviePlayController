//
//  CatAnswerModel.h
//  PlayerTest
//
//  Created by doujingxuan on 13-9-1.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatAnswerModel : NSObject

@property (nonatomic,retain)NSString * questionID;
@property (nonatomic,retain)NSString * questionString;
@property (nonatomic,retain)NSString * askerAvatar;
@property (nonatomic,retain)NSString * askerName;
@property (nonatomic,retain)NSString * imageArray;
@property (nonatomic,retain)NSString * voiceUrl;
@property (nonatomic,retain)NSString * answerAvatar;
@property (nonatomic,retain)NSString * answerString;
@property (nonatomic,retain)NSString * answerName;

@end
