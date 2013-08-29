//
//  QuestionView.h
//  PlayerTest
//
//  Created by doujingxuan on 13-8-29.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTopAligningLabel.h"

@interface QuestionView : UIView
{
    MCTopAligningLabel * _numberLabel;
    MCTopAligningLabel * _questionLabel;
}
-(void)calHeightAndUpdateInfo:(NSMutableDictionary*)questionInfo;
@end
