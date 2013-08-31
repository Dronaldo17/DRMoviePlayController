//
//  ButtonsView.m
//  PicDemo
//
//  Created by doujingxuan on 12-12-16.
//  Copyright (c) 2012年 XLHT Inc. All rights reserved.
//

#import "ButtonsView.h"
#import "AskUploadView.h"


@implementation ButtonsView

@synthesize photoNumOfLine = _photoNumOfLine,heightOfPhoto = _heightOfPhoto,isEdit = _isEdit,widthOfPhoto= _widthOfPhoto,btnViewType = _btnViewType;
-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)dealloc
{
    [_dataArray release];
    [super dealloc];
}
/**Author:窦静轩 Description:计算照片墙的高度*/
-(CGFloat)calPhotoWallHeight:(NSUInteger)photoNumber
{
    _modPhotoNum = photoNumber % _photoNumOfLine;
    switch (_btnViewType) {
        case PHOTOWALLVIEW:{
            if (_maxPhotoNum == photoNumber) {
                _lineNumber = photoNumber / _photoNumOfLine;
            }
            else{
            _lineNumber =  (photoNumber / _photoNumOfLine) <= 0 ? 1 : photoNumber / (_photoNumOfLine) +1;
            }
        }
            break;
        case TAGSWALLVIEW:{
            if (_modPhotoNum == 0) {
                _lineNumber = photoNumber / _photoNumOfLine;
            }
            else{
            _lineNumber =  (photoNumber / _photoNumOfLine) <= 0 ? 1 :+ photoNumber / (_photoNumOfLine) + 1;
            }
        }
            break;
        default:
            break;
    }
    NSLog(@"_line is %d, photoNumber is %d,_photoNumOfLine is %d",_lineNumber,photoNumber,_photoNumOfLine);
    return (_lineNumber * (_heightOfPhoto +_heightForSepPhoto)) + _heightForSepPhoto;
}
-(void)buttonPressed:(id)sender
{
    
}
/**Author:窦静轩 Description:初始化 要生成的照片*/
-(void)createPhotoWithPhotoNum:(NSUInteger)photoNumber
{
    NSLog(@"modPhotoNum is %d",_modPhotoNum);
    NSLog(@"photoNumber is %d",photoNumber);
    NSLog(@"_lineNumber is %d",_lineNumber);
    for (int j = 0; j < _lineNumber; j++) {
        for (int i = 0;i < _photoNumOfLine; i++) {
            AskUploadView * photo = [[AskUploadView alloc] initWithUserInfo:nil];
            photo.frame = CGRectMake(_widthForSepPhoto+(i*(_widthForSepPhoto + _widthOfPhoto)),((_heightForSepPhoto+_heightOfPhoto)*(j+1)-_heightOfPhoto), _widthOfPhoto, _heightOfPhoto);
            photo.photoCount = photoNumber;
//            [photo addImageAndTouch:9];
            photo.tag = j * _photoNumOfLine  + BASEBUTTONTAG + i ;
            [photo setBackgroundColor:[UIColor clearColor]];
            NSLog(@"imageView.tag is %d",photo.tag);
            [self addSubview:photo];
            [photo release];
        }
    }
}
/**Author:窦静轩 Description:初始化照片墙 photo*/
-(void)doInitWithPhotoNumbers:(NSMutableArray*)dataArray
{
    _dataArray = dataArray;
    [_dataArray retain];
    NSUInteger photoNumber = [dataArray count];
    NSLog(@"photoNumber is %d",photoNumber);
    if (photoNumber == 0) {
        NSLog(@"不需要生产button");
        return ;
    }

    if (photoNumber > _maxPhotoNum) {
        NSLog(@"超出最大照片亮");
        return ;
    }
    _widthForSepPhoto = (_photoWallWidth - _widthOfPhoto * _photoNumOfLine)/(_photoNumOfLine + 1);
    _photoWallHeight = [self calPhotoWallHeight:photoNumber];
    [self createPhotoWithPhotoNum:photoNumber];
    NSLog(@"_PhotoWallHeight is %f",_photoWallHeight);
    self.frame = CGRectMake(0, 100, _photoWallWidth, _photoWallHeight);
//    self.backgroundColor = [UIColor blueColor];
}
-(void)refleshDataWithPhotoNumber:(NSMutableArray *)dataArray
{
    if (_dataArray) {
        [_dataArray release];
    }
    NSArray * viewArray = [self subviews];
    [self removeConstraints:viewArray];
    [self doInitWithPhotoNumbers:dataArray];
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
