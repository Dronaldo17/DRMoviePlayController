//
//  ButtonsView.h
//  PicDemo
//
//  Created by doujingxuan on 12-12-16.
//  Copyright (c) 2012年 XLHT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BASEBUTTONTAG 1000
typedef enum BUTTONVIEWTYPE{
    PHOTOWALLVIEW,
    TAGSWALLVIEW,
    BUTTONVIEWTYPECOUNT
}btnViewType;

@interface ButtonsView : UIView
{
    //view属性
    BOOL _isEdit; //是否可以编辑（区分于当前用户和好友列表）
    NSUInteger _lineNumber; //可以有几行
    NSUInteger _photoNumOfLine; //一行可以有几张照片
    CGFloat _photoWallHeight; //此PhotoWallView的高度
    CGFloat _photoWallWidth;  //此PhotoWallView的高度
    
    //照片属性
    CGFloat _widthOfPhoto;  //指定照片的宽度
    CGFloat _heightOfPhoto; //照片的高度
    CGFloat _widthForSepPhoto; //照片横向之间的距离
    CGFloat _heightForSepPhoto; //照片纵向之间的距离
    
    //私有全局变量
    NSUInteger _modPhotoNum; //一行完整时剩余的照片数
    NSUInteger _lastButtonTag; //最后一个按钮的tag值
    NSUInteger _maxPhotoNum; //本view 最多可承载的button数量
    NSMutableArray * _dataArray;
    
    btnViewType _btnViewType;
}
@property (nonatomic,assign)NSUInteger photoNumOfLine;
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,assign)CGFloat widthOfPhoto;
@property (nonatomic,assign)CGFloat heightOfPhoto;
@property (nonatomic,assign)CGFloat widthForSepPhoto;
@property (nonatomic,assign)CGFloat heightForSepPhoto;
@property (nonatomic,assign)btnViewType btnViewType;
@property (nonatomic,assign)CGFloat photoWallWidth;
-(void)doInitWithPhotoNumbers:(NSMutableArray*)dataArray;
-(void)buttonPressed:(id)sender;
-(void)createPhotoWithPhotoNum:(NSUInteger)photoNumber;
-(void)refleshDataWithPhotoNumber:(NSMutableArray*)dataArray;
@end
