//
//  AskUploadView.m
//  PlayerTest
//
//  Created by doujingxuan on 13-8-30.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "AskUploadView.h"
#import <QuartzCore/QuartzCore.h>

#define BASEBUTTONTAG 1000

@implementation AskUploadView
@synthesize imageView,dict,photoCount;
- (void)dealloc
{
    [self.imageView release];
    self.imageView = nil;
    self.dict = nil;
    [super dealloc];
}
-(id)initWithUserInfo:(NSMutableDictionary*)userInfo
{
    self = [super init];
    if (self) {
        if (nil != userInfo) {
            self.dict = userInfo;
        }
        self.imageView = [[UIImageView alloc] init];
    }
    return self;
}
-(void)addImageAndTouch:(int)tag
{
    self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delButton.frame = CGRectMake(self.frame.size.width-10, 0, 10, 10);
    [self.delButton setImage:[UIImage imageNamed:@"ask_del_button"] forState:UIControlStateNormal];
    [self.delButton setImage:[UIImage imageNamed:@"ask_del_button"] forState:UIControlStateHighlighted];
    [self setTag:tag];
    
    [self.delButton addTarget:self action:@selector(delSelfImgae:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imageView.frame = self.bounds;
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"test10@2x.png"]];
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fcnnImageViewClicked:)];
    
    [self.imageView addGestureRecognizer:singleTap];
    [singleTap release];
}
-(void)fcnnImageViewClicked:(id)sender
{
    NSLog(@"self.tag is %d",self.tag);
    int tag = self.tag - BASEBUTTONTAG;
    NSLog(@"tag is %d",tag);
    if(tag > self.photoCount - 1){
        NSLog(@"添加图片");
    }
    else{
        NSLog(@"点击图片");
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
