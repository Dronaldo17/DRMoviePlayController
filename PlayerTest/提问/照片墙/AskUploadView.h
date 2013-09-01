//
//  AskUploadView.h
//  PlayerTest
//
//  Created by doujingxuan on 13-8-30.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskPictureModel.h"

@interface AskUploadView : UIView
@property (nonatomic,retain)UIImageView * imageView;
@property (nonatomic,retain)UIButton * delButton;
@property (nonatomic,retain)NSMutableDictionary * dict;
@property (nonatomic,assign)NSInteger photoCount;
@property (nonatomic,retain)AskPictureModel * model;
-(id)initWithUserInfo:(NSMutableDictionary*)userInfo;
-(void)addImageAndTouch:(int)tag  photoArray:(NSMutableArray*)photoArray;
@end
