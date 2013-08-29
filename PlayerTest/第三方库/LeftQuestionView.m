//
//  LeftQuestionView.m
//  PlayerTest
//
//  Created by doujingxuan on 13-8-29.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "LeftQuestionView.h"

@implementation LeftQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel = [[MCTopAligningLabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 2* 10, 90)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
        [_titleLabel setTopText:@"请思考这些问题?"];
        
        _titleLabel.textColor =RGBCOLOR(26, 166, 227);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        _questionScrollview.scrollEnabled = YES;
        _questionScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.size.height + 5, frame.size.width, frame.size.height-60)];
        [self addSubview:_questionScrollview];
        _tmpHeight = 0;
    }
    return self;
}
-(void)updateQuestionInfo:(NSMutableArray *)questionArray
{
    if (questionArray.count <=0) {
        self.frame = CGRectZero;
        return;
    }
    
    for (int i = 0 ;i<questionArray.count; i++) {
        QuestionView * view = [[QuestionView alloc] initWithFrame:CGRectMake(0, _tmpHeight, self.frame.size.width, 200)];
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:10];
        dict[@"number"] = [NSString stringWithFormat:@"%d.",i+1];
        dict[@"question"] = @"我相信清者自我相信清者自我相信清者自";
        [_questionScrollview setBackgroundColor:[UIColor clearColor]];
        [view  calHeightAndUpdateInfo:dict];
        _tmpHeight +=view.frame.size.height;
        [_questionScrollview addSubview:view];
        [view release];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
