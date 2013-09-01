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
@synthesize imageView,dict,photoCount,model;
- (void)dealloc
{
    [self.imageView release];
    self.imageView = nil;
    self.model = nil;
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
-(void)addImageAndTouch:(int)tag photoArray:(NSMutableArray *)photoArray
{
    self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delButton.frame = CGRectMake(self.frame.size.width-5, -5, 20 , 20);
    [self.imageView addSubview:self.delButton];
    [self.delButton setImage:[UIImage imageNamed:@"ask_del_button"] forState:UIControlStateNormal];
    [self.delButton setImage:[UIImage imageNamed:@"ask_del_button"] forState:UIControlStateHighlighted];
    [self setTag:tag];
    
    [self.delButton addTarget:self action:@selector(delSelfImgae:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imageView.frame = self.bounds;
    
    int index = self.tag -BASEBUTTONTAG;
    
    if (index < photoArray.count) {
        self.model = [photoArray objectAtIndex:index];
        self.imageView.image = [[UIImage alloc] initWithData:self.model.imageData scale:1.0];
    }
//    self.model = [photoArray objectAtIndex:index];
//    self.imageView.image = [[UIImage alloc] initWithData:self.model.imageData scale:1.0];
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fcnnImageViewClicked:)];
    self.imageView.userInteractionEnabled = YES;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:Add_Ask_Pic object:nil];
    }
    else{
        NSLog(@"点击图片");
    }
}
-(void)delSelfImgae:(id)sender
{
      int tag = self.tag - BASEBUTTONTAG;
    NSLog(@"删除照片 tag is %d",tag);
    NSNumber * tagNumber = [NSNumber numberWithInt:tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:Del_Ask_Pic object:tagNumber];
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
