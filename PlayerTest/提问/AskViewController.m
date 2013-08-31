//
//  AskViewController.m
//  PlayerTest
//
//  Created by doujingxuan on 13-8-30.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "AskViewController.h"
#import "SSTextView.h"
#import "PhotoWallView.h"

@interface AskViewController ()
{
    CGFloat _tmpFloat;
    UIView * _ansWerView;
    UIView * _topInputView;

    UIButton * _recordButton;
    
    PhotoWallView * _pwv;
    
    UIButton * _delVoiceButton;  //删除视频的button
    
    BOOL _isRecorded;            //录音成功
    
    BOOL   _isPlaying;         //是否播放录音
}   

@end

@implementation AskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
   
    //初始化信息
    [self doInitVCInfo];
    
    
    //初始化答题view
    [self addAnswerView];
    
    //添加输入框
    [self addInputView];
    
    
    //添加图片和录音试图
    [self addMediaSourceView];
    
    //添加录音的View
    [self addVoiceHud];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 初始化
-(void)addVoiceHud
{
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
    [self.voiceHud setDelegate:self];
    [self.view addSubview:self.voiceHud];
}


#pragma mark 初始化页面
-(void)doInitVCInfo
{
    self.title = @"提问";
    self.view.backgroundColor = [UIColor blackColor];
}
#pragma mark 初始化导航页面
-(void)addAnswerView
{
    //添加提问背景
   _ansWerView = [[UIView alloc] initWithFrame:CGRectMake(150, 20, self.view.frame.size.height - 2*150, 650)];
    [_ansWerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_ansWerView];

    
    //添加上边导航View
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _ansWerView.frame.size.width, 60)];
    _tmpFloat = view.frame.size.height;
    view.backgroundColor = [UIColor clearColor];
    [_ansWerView addSubview:view];
    
    _topInputView = [[UIView alloc] initWithFrame:CGRectMake(0, _tmpFloat, _ansWerView.frame.size.width, 300)];
    [_topInputView setBackgroundColor:RGBCOLOR(241, 241, 241)];
    [_ansWerView addSubview:_topInputView];
    
    //添加Nav背景图片
    UIImageView * bannerImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    bannerImageView.image = [UIImage imageNamed:@"ask_nav_banner"];
    bannerImageView.backgroundColor = [UIColor clearColor];
    bannerImageView.userInteractionEnabled = YES;
    [view addSubview:bannerImageView];
    
    //添加TitleLabel 
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, view.frame.size.width-2*100,50)];
    titleLabel.text = @"提问";
    titleLabel.textColor = [UIColor whiteColor];
     [titleLabel setFont:[UIFont boldSystemFontOfSize:26.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bannerImageView addSubview:titleLabel];
    
    
    //添加返回的button
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * buttonImage = [UIImage imageNamed:@"ask_pop_button"];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:buttonImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(popButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(20,15, 35,35);
    [bannerImageView addSubview:button];

    //释放变量
    [titleLabel release];
    [bannerImageView release];
    [view release];
}
#pragma mark 添加输入框
-(void)addInputView
{
    SSTextView * textView = [[SSTextView  alloc] initWithFrame:CGRectMake(20, 5, _ansWerView.frame.size.width - 2* 20, 150)];
    _tmpFloat = 155;
    textView.font = [UIFont boldSystemFontOfSize:20.0];
    textView.placeholder = @"请输入您要提出的问题";
    textView.placeholderColor = [UIColor grayColor];
    textView.backgroundColor = [UIColor redColor];
    [_topInputView addSubview:textView];
}
#pragma mark 添加富文本View
-(void)addMediaSourceView
{
    UIImageView * topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(20, _tmpFloat + 30, _ansWerView.frame.size.width - 2* 20 , 5)];
    topLineView.image = [UIImage imageNamed:@"ask_line"];
//    topLineView.backgroundColor = [UIColor blueColor];
    [_topInputView addSubview:topLineView];
    
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@"0",@"1",@"0",nil];
	// Do any additional setup after loading the view, typically from a nib.
    _pwv =[[PhotoWallView alloc] init];
//    [pwv setBackgroundColor:[UIColor blueColor]];
    _pwv.btnViewType = PHOTOWALLVIEW;
    _pwv.isEdit = YES;
    _pwv.photoNumOfLine = 4;
    _pwv.heightForSepPhoto = 30;
    _pwv.widthOfPhoto = 40;
    _pwv.heightOfPhoto = 40;
    _pwv.photoWallWidth= 300;
    [_pwv doInitWithPhotoNumbers:array];
     _pwv.frame = CGRectMake(20, topLineView.frame.origin.y+topLineView.frame.size.height + 5, 300, 80);
    NSLog(@"pwv.frame is %@",NSStringFromCGRect(_pwv.frame));
    [_topInputView addSubview:_pwv];
    
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(_pwv.frame.origin.x+_pwv.frame.size.width + 200, _pwv.frame.origin.y + 20,150, 75)];

    [_recordButton setImage:[UIImage imageNamed:@"ask_record_button"] forState:UIControlStateHighlighted];
    [_recordButton setImage:[UIImage imageNamed:@"ask_record_button"] forState:UIControlStateNormal];
    [_topInputView addSubview:_recordButton];
    
    
    _delVoiceButton = [[UIButton alloc] initWithFrame:CGRectMake(_recordButton.frame.origin.x+_recordButton.frame.size.width-10, _recordButton.frame.origin.y, 10, 10)];
    [_delVoiceButton setImage:[UIImage imageNamed:@"ask_record_delbutton"] forState:UIControlStateNormal];
      [_delVoiceButton setImage:[UIImage imageNamed:@"ask_record_delbutton"] forState:UIControlStateHighlighted];
    [_delVoiceButton setHidden:NO];
    [_recordButton addSubview:_delVoiceButton];
    
    
    
    [_recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 返回按钮按下
-(void)popButtonClicked:(id)sender
{
    NSLog(@"popButtonClicked");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 录音按键的按下
-(void)recordButtonClicked:(id)sender
{
    NSString *voiceName=[NSString stringWithFormat:@"%@/Documents/ipad_ask_voice.caf", NSHomeDirectory()];
    [self.voiceHud startForFilePath:voiceName];
}
#pragma mark - POVoiceHUD Delegate
- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength {
    //    NSLog(@"Voice recording cancelled for HUD: ");
    _isRecorded = YES;
    [self updateVocieButton:_isRecorded];
    
}
- (void)voiceRecordCancelledByUser:(POVoiceHUD *)voiceHUD
{
    NSLog(@"Voice recording cancelled for HUD: %@", voiceHUD);
    _isRecorded = NO;
}

-(void)updateVocieButton:(BOOL)isRecord
{
//    if (isRecord) {
//        [_recordButton setImage:<#(UIImage *)#> forState:<#(UIControlState)#>];
//        [_recordButton setImage:<#(UIImage *)#> forState:<#(UIControlState)#>];
//    }
//    else{
//    
//    }

}

@end
