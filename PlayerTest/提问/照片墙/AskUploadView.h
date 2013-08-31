//
//  AskUploadView.h
//  PlayerTest
//
//  Created by doujingxuan on 13-8-30.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskUploadView : UIView
@property (nonatomic,retain)UIImageView * imageView;
@property (nonatomic,retain)UIButton * delButton;
@property (nonatomic,retain)NSMutableDictionary * dict;
@property (nonatomic,assign)NSInteger photoCount;
-(id)initWithUserInfo:(NSMutableDictionary*)userInfo;
@end
