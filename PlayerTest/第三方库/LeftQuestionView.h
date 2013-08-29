//
//  LeftQuestionView.h
//  PlayerTest
//
//  Created by doujingxuan on 13-8-29.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionView.h"
@interface LeftQuestionView : UIView
{
    UIScrollView * _questionScrollview;
    MCTopAligningLabel * _titleLabel;
    CGFloat _tmpHeight;
}
-(void)updateQuestionInfo:(NSMutableArray*)questionArray;
@end
