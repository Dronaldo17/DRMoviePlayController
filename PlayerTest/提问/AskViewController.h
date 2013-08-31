//
//  AskViewController.h
//  PlayerTest
//
//  Created by doujingxuan on 13-8-30.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POVoiceHUD.h"

@interface AskViewController : UIViewController<POVoiceHUDDelegate>

@property (nonatomic, retain) POVoiceHUD *voiceHud;
@end
