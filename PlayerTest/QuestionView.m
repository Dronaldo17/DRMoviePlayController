//
//  QuestionView.m
//  PlayerTest
//
//  Created by doujingxuan on 13-8-29.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "QuestionView.h"
#import "UILabel+CalHeight.h"
@implementation QuestionView
- (void)dealloc
{
    [_numberLabel release];
    [_questionLabel release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _numberLabel = [[MCTopAligningLabel alloc] initWithFrame:CGRectMake(10, 5, 20, 6)];
        _questionLabel = [[MCTopAligningLabel alloc] initWithFrame:CGRectMake(30,5, self.frame.size.width - 2*15, 20)];
        [self addSubview:_numberLabel];
        [self addSubview:_questionLabel];
    }
    return self;
}
-(void)calHeightAndUpdateInfo:(NSMutableDictionary *)questionInfo
{
    [_numberLabel setTopText:questionInfo[@"number"]];
    [_questionLabel setTopText:questionInfo[@"question"]];
  
    [_numberLabel setTextColor:[UIColor whiteColor]];
    [_questionLabel setTextColor:[UIColor whiteColor]];
    
    UIFont * questionFont =    [UIFont boldSystemFontOfSize:20.0];
    UIFont * numberFont =    [UIFont boldSystemFontOfSize:20.0];
    
      [_numberLabel setFont:numberFont];
      [_questionLabel setFont:questionFont];
    
    [_numberLabel calculateHeightWithFont:numberFont];
    [_questionLabel calculateHeightWithFont:questionFont];
    
    [_numberLabel setBackgroundColor: [UIColor clearColor]];
    [_questionLabel setBackgroundColor: [UIColor clearColor]];
     self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,_questionLabel.frame.size.height +5);
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
