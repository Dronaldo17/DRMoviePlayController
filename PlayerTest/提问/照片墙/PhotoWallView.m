
//
//  PhotoWallView.m
//  PicDemo
//
//  Created by doujingxuan on 12-12-14.
//  Copyright (c) 2012年 XLHT Inc. All rights reserved.
//

#import "PhotoWallView.h"
#import "AskUploadView.h"
#define PHOTOWALLHEIGHT 72
#define BASEBUTTONTAG 1000

@implementation PhotoWallView
-(id)init
{
    self = [super init];
    if (self) {
        _maxPhotoNum = 4;
        _btnViewType = PHOTOWALLVIEW;
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
-(void)createPhotoWithPhotoNum:(NSUInteger)photoNumber
{
    [super createPhotoWithPhotoNum:photoNumber];
    if (_maxPhotoNum <= photoNumber) {
        return;
    }
    NSLog(@"_modPhotoNum is %d,_photoNumOfLine is %d",_modPhotoNum,_photoNumOfLine);
    for (int h = _modPhotoNum; h < _photoNumOfLine;h++) {
        NSLog(@"_lineNumber is %d",_lineNumber);
        int tag = (_lineNumber-1) * _photoNumOfLine  + h + 1  + BASEBUTTONTAG;
        NSLog(@"tag is %d",tag);
       AskUploadView *  photo = (AskUploadView*)[self viewWithTag:tag];
        NSLog(@"photo.tag is %d",photo.tag);
        [photo removeFromSuperview];
        [self setNeedsDisplay];
    }
    _lastButtonTag = (_lineNumber - 1)* _photoNumOfLine + _modPhotoNum  + BASEBUTTONTAG;
    NSLog(@"lastTag is %d",_lastButtonTag);
    AskUploadView *  photo = (AskUploadView*)[self viewWithTag:_lastButtonTag];
    photo.imageView.image = [UIImage imageNamed:@"test10@2x.png"];
    [self setNeedsDisplay];
}
-(void)addPhoto:(id)sender
{
    NSLog(@"addPhoto");
}
-(void)createSingleAddButton
{
    self.userInteractionEnabled = YES;
    self.frame = CGRectMake(0, 0, 320, 100);
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, 100, 80)];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"添加图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button release];
}
-(void)buttonPressed:(id)sender
{
    [super buttonPressed:sender];
    UIButton * button = (UIButton*)sender;
    int tag = button.tag - BASEBUTTONTAG;
    NSLog(@"tag is %d",tag);
    if(tag > [_dataArray count] - 1){
        NSLog(@"添加图片");
    }
    else{
        NSLog(@"点击图片");
    }
}
-(void)doInitWithPhotoNumbers:(NSMutableArray *)dataArray
{
    [super doInitWithPhotoNumbers:dataArray];
    if ([dataArray count] == 0) {
        [self createSingleAddButton];
        return;
    }
}
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
