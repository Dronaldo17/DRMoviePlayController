//
//  ViewController.m
//  PlayerTest
//
//  Created by doujingxuan on 13-8-26.
//  Copyright (c) 2013年 doujingxuan. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBHUDView.h"
#import <AudioToolbox/AudioSession.h>
#import "DRTools.h"
#import "QuestionView.h"
#import "LeftQuestionView.h"
#import "PopoverView.h"
#import "AskViewController.h"
#import "CatAnswerVC.h"
#import "AnswerQuestionVC.h"

#define Top_Nav_Height  70

#define Bottom_Tool_Height   120

#define Appear_Time 0.6f

#define TopViewAlpha 0.7

#define Cat_Answer_Tag 1000

#define Base_Review_Tag 2000

#define PopView_Time 3.0

@interface ViewController ()
{
    MPMoviePlayerController * _moviePlayer;  //播放器
    
    int _fullTime;                                                //视频总秒数
    
    int  _playingTime;                                        //当前播放秒数
    
    BOOL _isPlaying;                                         //当前播放中
    
    BOOL _isPause;                                           //当前暂停或未播放
    
    BOOL _isFullScreen;                                    //是否全屏
    
    BOOL _isMute;                                              //是否静音
    
    BOOL _leftViewPushed;                               //左边思考问题页面是否展现
    
    BOOL _isPopUp;                                          //弹出提示框
    
    float _volume;                                                //当前音量
    
    NSTimer * _timer;                                         //刷新界面的定时器
    
    UILabel * _timeLabel;                                   //显示时间的Label
    
    UISlider * _volumeSlider;                             //控制音量的Slider
    
    UISlider * _playBackSlider;                          //播放进度的Slider
    
    UIView * _topNavView;                               //导航上边的view
    
    UIView * _bottomToolView;                         //功能条下边的view
    
    UIView * _middleAskView;                          //中间提问的按钮
    
    UIView * _askView;                                     //提问的view
    
    UIButton * _playButton;                                //播放按钮
    
    UIButton * _muteButton;                               //静音Button\
    
    UIButton * _thinkButton;                                //思考Button\
    
    LeftQuestionView *  _questionView;             //问题View
    
    NSMutableArray * _addReviewArray;           //复习任务的Array
    
    PopoverView * _popView;                             //弹出的View
}
@end

@implementation ViewController
#pragma mark 生命周期
- (void)dealloc
{
    RELEASE_SAFELY(_muteButton);
    RELEASE_SAFELY(_moviePlayer);
    RELEASE_SAFELY(_timer);
    RELEASE_SAFELY(_timeLabel);
    RELEASE_SAFELY(_volumeSlider);
    RELEASE_SAFELY(_playBackSlider);
    RELEASE_SAFELY(_topNavView);
    RELEASE_SAFELY(_bottomToolView);
    [self removeMovieNotificationHandlers];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //创建全局变量
    [self doInitDataSource];
    
    //添加页面Controllers
    [self addControllers];
    
    //添加通知
    [self  installMovieNotificationObservers];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doInitDataSource
{
    _isPause = YES;
    _isPlaying = NO;
    _isFullScreen = NO;
    _isMute = NO;
    _leftViewPushed = YES;
    
    _volume = [MPMusicPlayerController applicationMusicPlayer].volume;
    
    _addReviewArray = [[NSMutableArray alloc] init];
    [_addReviewArray addObject:@"1"];
    [_addReviewArray addObject:@"4"];
    [_addReviewArray addObject:@"8"];
    [_addReviewArray addObject:@"12"];
    [_addReviewArray addObject:@"16"];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePlayTimes:) userInfo:nil repeats:YES];
    [_timer retain];
}
-(void)addControllers
{
    //添加播放器
    [self addPlayer];
    
    //添加上边的导航View
    [self addNavView];
    
    //添加下边的BottomView
    [self addBottomToolView];
    
    //添加暂停 播放  按钮
    [self addButtons];
    
    //添加时间Label
    [self addTimeLabel];
    
    //添加播放的进度 slider
    [self addPlayerBackSlider];
    
    
    //添加静音button
    [self  addMuteButton];
    
    //添加声音控制条
    [self addVolumeSlider];
    
    //添加思考问题View
    [self addQuestionView];
    
    //添加思考问题旁边的Button
    [self addThinkButton];
    
    //添加提问的框
    [self addAskView];
    
    //添加中间插入的button
    [self addReviewButton];
    
}
-(void)addReviewButton
{
    for (int i = 0; i < _addReviewArray.count; i++) {
        UIButton * button = [[UIButton alloc] init];
        button.tag = Base_Review_Tag + i;
        button.backgroundColor = [UIColor clearColor];
        
        UIImage * image = [UIImage imageNamed:@"playVC_play_point1"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];

        UIImage * pointImage = [UIImage imageNamed:@"playVC_play_point"];
        [button setImage:pointImage forState:UIControlStateHighlighted];
        [button setImage:pointImage forState:UIControlStateNormal];
        
        CGFloat width =  _playBackSlider.frame.size.width;
        
        int time = [[_addReviewArray objectAtIndex:i] integerValue];
        
        NSLog(@"x == %f",width*time/20);
        
        button.frame = CGRectMake(width*time/20,11.5, 9, 19);
        [button addTarget:self action:@selector(reviewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_playBackSlider addSubview:button];
    }
}
#pragma mark 添加
-(void)reviewButtonClicked:(id)sender
{
    UIButton * button = (UIButton*)sender;
    int tag = button.tag - Base_Review_Tag;
    NSLog(@"tag is %d",tag);
    
    NSLog(@"button.frame is %@",NSStringFromCGRect(button.frame));
    CGPoint  point = CGPointMake(_playBackSlider.frame.origin.x +button.frame.origin.x+button.frame.size.width/2, button.frame.origin.y - button.frame.size.height/2 + _bottomToolView.frame.origin.y);
    if (_popView) {
        [_popView dismiss];
    }
    RELEASE_SAFELY(_popView);
    _popView = [[PopoverView alloc] init];
    [_popView showAtPoint:point inView:self.view withText:@"阿里巴巴-B2B国际技术部-全球搜索 在 杭州滨江 招聘[高级Java工程师/Java技术专家],在这里你有机会开发和运维上亿访问量的大型系统，有机会面对高并发、大用户量的挑战，有机会参与未来搜索的建设，有机会成为众多小二崇拜的技术明星!"];
    _isPopUp = YES;
    [self performSelector:@selector(dissmissPopView:) withObject:nil afterDelay:PopView_Time];
//    [PopoverView showPopoverAtPoint:point inView:self.view withText:@"" delegate:nil];
}
-(void)dissmissPopView:(id)sender
{
    if (_popView) {
        [_popView dismiss];
        _isPopUp = NO;
    }
}
#pragma mark 添加导航的NavView
-(void)addNavView
{
    if (_isFullScreen) {
        _topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - Top_Nav_Height, _moviePlayer.view.frame.size.width, Top_Nav_Height)];
    }
    else{
        _topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _moviePlayer.view.frame.size.width, Top_Nav_Height)];
    }
    UIButton * popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [popButton setImage:[UIImage imageNamed:@"playVC_Back"] forState:UIControlStateNormal];
//    [popButton   setTitle:@"返回" forState:UIControlStateNormal];
//    [popButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [popButton addTarget:self action:@selector(dissmissSelf:) forControlEvents:UIControlEventTouchUpInside];
    popButton.frame = CGRectMake(30, 15, 35, 35);
    [_topNavView addSubview:popButton];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, self.view.frame.size.height - 2 * 200, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"等式的加减法则运用";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_topNavView addSubview:titleLabel];
    [titleLabel release];
    
    [_topNavView setBackgroundColor:[UIColor blackColor]];
    [_topNavView setAlpha:TopViewAlpha];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_topNavView];
    [self.view addSubview:_topNavView];
}
#pragma mark 添加下边的BottomToolView
-(void)addBottomToolView
{
    if (_isFullScreen) {
        _bottomToolView = [[UIView alloc] initWithFrame:CGRectMake(0, _moviePlayer.view.frame.size.height,_moviePlayer.view.frame.size.width, Bottom_Tool_Height)];
    }
    else{
        _bottomToolView = [[UIView alloc] initWithFrame:CGRectMake(0, _moviePlayer.view.frame.size.height-Bottom_Tool_Height,_moviePlayer.view.frame.size.width, Bottom_Tool_Height)];
    }
    [_bottomToolView setBackgroundColor:[UIColor blackColor]];
    [_bottomToolView setAlpha:TopViewAlpha];
    [self.view addSubview:_bottomToolView];
}
#pragma mark 添加播放器
-(void)addPlayer
{
//       NSString * path = [[NSBundle mainBundle] pathForResource:@"IMG_0024" ofType:@"MOV"];
     NSString * path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
        NSURL * url = [NSURL fileURLWithPath:path];
    
//    NSURL *url = [NSURL URLWithString:@"http://www.gzerodesign.com/sharksclips/video.mp4"];
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;
    
	_moviePlayer = [[MPMoviePlayerController alloc]
                    initWithContentURL:url];
    [[_moviePlayer view] setFrame:CGRectMake(0, 0, self.view.frame.size.height+statusHeight, self.view.frame.size.width)];
    
    UITapGestureRecognizer *playGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playFullScreenOrNot:)];
    playGesture.delegate = self;
    _moviePlayer.view.userInteractionEnabled = YES;
    [_moviePlayer.view addGestureRecognizer:playGesture];
    [playGesture release];
    
    [_moviePlayer setFullscreen:YES animated:YES];
    [self.view addSubview:_moviePlayer.view];
    
	//初始化视频播放器对象，并传入被播放文件的地址
	_moviePlayer.controlStyle = MPMovieControlStyleNone ;
    [_moviePlayer prepareToPlay];
	[_moviePlayer play];
}
#pragma mark 自定义的按钮
-(void)addButtons
{
    _playButton  = [[UIButton alloc] initWithFrame:CGRectMake(460, 50,50, 50)];
//    [_playButton setTitle:@"播放" forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"playVC_play"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolView addSubview:_playButton];
    
    UIButton * seekingBackButton  = [[UIButton alloc] initWithFrame:CGRectMake(320,50,70, 50)];
//    [seekingBackButton setTitle:@"快退" forState:UIControlStateNormal];
    [seekingBackButton setImage:[UIImage imageNamed:@"playVC_seekBack"] forState:UIControlStateNormal];
    [seekingBackButton addTarget:self action:@selector(seekingBackCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolView addSubview:seekingBackButton];
    [seekingBackButton release];
    
    
    UIButton * seekingForwardButton  = [[UIButton alloc] initWithFrame:CGRectMake(580, 50,70, 50)];
//    [seekingForwardButton setTitle:@"快进" forState:UIControlStateNormal];
     [seekingForwardButton setImage:[UIImage imageNamed:@"playVC_seekForward"] forState:UIControlStateNormal];
    [seekingForwardButton addTarget:self action:@selector(seekingForwardCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolView addSubview:seekingForwardButton];
    [seekingForwardButton release];
}
#pragma mark 添加显示时间的label
-(void)addTimeLabel
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 300, 50)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.text = [NSString stringWithFormat:@"00:00|00:00"];
    _timeLabel.font = [UIFont boldSystemFontOfSize:21.0];
    [_bottomToolView addSubview:_timeLabel];
}
#pragma mark 添加静音Button
-(void)addMuteButton
{
    _muteButton = [[UIButton alloc] initWithFrame:CGRectMake(800, 60, 25, 25)];
//    [_muteButton setTitle:@"静音" forState:UIControlStateNormal];
    [_muteButton setImage:[UIImage imageNamed:@"playVC_volume_button"] forState:UIControlStateNormal];
    [_muteButton addTarget:self action:@selector(muteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolView addSubview:_muteButton];
}

#pragma mark 添加显示音量的Slider
-(void)addVolumeSlider
{
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(840, 48, 140,50)];
    [_volumeSlider addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *thumbImage = [UIImage imageNamed:@"playVC_volume_slider"];
    
    [_volumeSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_volumeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [_volumeSlider setMinimumTrackTintColor:RGBCOLOR(255, 80, 8)];
    [_volumeSlider setMaximumTrackTintColor:RGBCOLOR(87, 89, 91)];
    
    float volume = [MPMusicPlayerController applicationMusicPlayer].volume;
    _volumeSlider.value = volume;
    [_bottomToolView   addSubview:_volumeSlider];
}
#pragma mark 添加显示播放进度的Slider
-(void)addPlayerBackSlider
{
    _playBackSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 10, _moviePlayer.view.frame.size.width - 148,40)];
    [_playBackSlider addTarget:self action:@selector(changePlayRate:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *thumbImage = [UIImage imageNamed:@"playVC_play_slider"];
    
    [_playBackSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_playBackSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [_playBackSlider setMinimumTrackTintColor:RGBCOLOR(255, 80, 8)];
    [_playBackSlider setMaximumTrackTintColor:RGBCOLOR(87, 89, 91)];
    
    _playBackSlider.value = 0;
    [_bottomToolView   addSubview:_playBackSlider];
}
#pragma mark 添加右侧提问按钮
-(void)addAskView
{
    _askView = [[UIView alloc] initWithFrame:CGRectMake(_moviePlayer.view.frame.size.width - 100, _moviePlayer.view.center.y-150, 100, 200)];
    UIView * askView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, _askView.frame.size.width, 90)];
    
    UITapGestureRecognizer *askGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(askButtonClicked:)];
    askGesture.delegate = self;
    askView.userInteractionEnabled = YES;
    [askView addGestureRecognizer:askGesture];
    [askGesture release];

    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 5, 30, 35)];
    imageView.image = [UIImage imageNamed:@"playVC_ask_button"];
    [askView addSubview:imageView];
    [imageView release];
    
    UILabel * askLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 70, 25)];
    askLabel.text = @"提问";
    askLabel.textColor = [UIColor whiteColor];
    askLabel.textAlignment = NSTextAlignmentCenter;
    [askLabel setBackgroundColor:[UIColor clearColor]];
    [askLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [askView addSubview:askLabel];
    [askLabel release];
    
    [_askView addSubview:askView];
    [askView release] ;
    
    
    UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, _askView.frame.size.width - 2*10, 3)];
    lineImageView.image = [UIImage imageNamed:@"playVC_line"];
    [_askView addSubview:lineImageView];
    [lineImageView release];
    
    
    UIView * catAnswerView = [[UIView alloc] initWithFrame:CGRectMake(15, 110, 70, 90)];
    [_askView addSubview:catAnswerView];
    
    UILabel * catLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 70, 40)];
    catLabel.text = @"查看";
    catLabel.textColor = [UIColor whiteColor];
    catLabel.textAlignment = NSTextAlignmentCenter;
    [catLabel setBackgroundColor:[UIColor clearColor]];
    [catLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [catAnswerView addSubview:catLabel];
    
    UILabel * answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30, 70, 40)];
    answerLabel.text = @"答疑";
    answerLabel.textColor = [UIColor whiteColor];
    answerLabel.textAlignment = NSTextAlignmentCenter;
    [answerLabel setBackgroundColor:[UIColor clearColor]];
    [answerLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [catAnswerView addSubview:answerLabel];

    
    UITapGestureRecognizer *catGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(catAnswerButtonClicked:)];
    catGesture.delegate = self;
    catAnswerView.userInteractionEnabled = YES;
    [catAnswerView addGestureRecognizer:catGesture];
    [catGesture release];

    [_askView setBackgroundColor:[UIColor blackColor]];
    [_askView setAlpha:TopViewAlpha];
    [self.view addSubview:_askView];
}
#pragma mark 添加左侧的问题View
-(void)addQuestionView
{
    if (_leftViewPushed) {
        _questionView = [[LeftQuestionView alloc] initWithFrame:CGRectMake(0, 100, 300, 500)];
    }
    else{
        _questionView = [[LeftQuestionView alloc] initWithFrame:CGRectMake(-300, 100, 300, 500)];
    }
    [_questionView setBackgroundColor:[UIColor blackColor]];
    [_questionView setAlpha:TopViewAlpha];
   
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:10];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    
    [_questionView updateQuestionInfo:array];
    [self.view addSubview:_questionView];
    
}
#pragma mark 添加左侧可以点击的Button
-(void)addThinkButton
{
    _thinkButton = [[UIButton alloc] initWithFrame:CGRectMake(_questionView.frame.size.width,_questionView.center.y - 60/2, 32, 57)];
//    [_thinkButton setTitle:@"拉起来" forState:UIControlStateNormal];
//    [_thinkButton setBackgroundColor:[UIColor blackColor]];
    [_thinkButton setImage:[UIImage imageNamed:@"playVC_pullButton"] forState:UIControlStateNormal];
     [_thinkButton setImage:[UIImage imageNamed:@"playVC_pullButton"] forState:UIControlStateHighlighted];
    [_thinkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_thinkButton addTarget:self action:@selector(thinkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_thinkButton addTarget:self action:@selector(thinkButtonClicked:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_thinkButton];
    
}
#pragma mark 左侧可以收起的按钮
-(void)thinkButtonClicked:(id)sender
{
    if (_leftViewPushed) {
        _leftViewPushed = NO;
        [self leftViewHidden];
    }
    else{
        _leftViewPushed = YES;
        [self leftViewAppear];
    }
}
-(void)leftViewAppear
{
    
    CGRect thinkButtonStartFrame = CGRectMake(0,_questionView.center.y - 60/2, _thinkButton.frame.size.width, _thinkButton.frame.size.height);
    CGRect thinkButtonEndFrame = CGRectMake(_questionView.frame.size.width,_questionView.center.y - 60/2, _thinkButton.frame.size.width, _thinkButton.frame.size.height);
    [DRTools appearViewAnimationWithView:_thinkButton duration:Appear_Time startFrame:thinkButtonStartFrame endFrame:thinkButtonEndFrame animationName:nil delegate:self];
    
    CGRect questionViewStartFrame = CGRectMake(-300, 100, 300, 500);
    CGRect  questionViewEndFrame = CGRectMake(0, 100, 300, 500);
    [DRTools appearViewAnimationWithView:_questionView duration:Appear_Time startFrame:questionViewStartFrame endFrame:questionViewEndFrame animationName:nil delegate:self];
    
    
    //    CGRect askViewStartFrame = CGRectMake(_moviePlayer.view.frame.size.width - 100, _moviePlayer.view.center.y-150, 100, 100);
    //    CGRect  askViewEndFrame = CGRectMake(_moviePlayer.view.frame.size.width - 100, _moviePlayer.view.center.y-150, 100, 200);
    //    [DRTools appearViewAnimationWithView:_askView duration:Appear_Time startFrame:askViewStartFrame endFrame:askViewEndFrame animationName:nil delegate:self];
    //
    //    UIButton * askButton =(UIButton* ) [_askView viewWithTag:Cat_Answer_Tag];
    //    [askButton setHidden:NO];
    
}
-(void)leftViewHidden
{
    CGRect thinkButtonStartFrame = CGRectMake(_questionView.frame.size.width,_questionView.center.y - 60/2, _thinkButton.frame.size.width, _thinkButton.frame.size.height);
    CGRect thinkButtonEndFrame = CGRectMake(0,_questionView.center.y - 60/2, _thinkButton.frame.size.width, _thinkButton.frame.size.height);
    [DRTools appearViewAnimationWithView:_thinkButton duration:Appear_Time startFrame:thinkButtonStartFrame endFrame:thinkButtonEndFrame animationName:nil delegate:self];
    
    CGRect questionViewStartFrame = CGRectMake(0, 100, 300, 500);
    CGRect  questionViewEndFrame = CGRectMake(-300, 100, 300, 500);
    [DRTools appearViewAnimationWithView:_questionView duration:Appear_Time startFrame:questionViewStartFrame endFrame:questionViewEndFrame animationName:nil delegate:self];
    
    //    CGRect askViewStartFrame = CGRectMake(_moviePlayer.view.frame.size.width - 100, _moviePlayer.view.center.y-150, 100, 200);
    //    CGRect  askViewEndFrame = CGRectMake(_moviePlayer.view.frame.size.width - 100, _moviePlayer.view.center.y-150, 100, 100);
    //    [DRTools appearViewAnimationWithView:_askView duration:Appear_Time startFrame:askViewStartFrame endFrame:askViewEndFrame animationName:nil delegate:self];
    //    UIButton * askButton =(UIButton* ) [_askView viewWithTag:Cat_Answer_Tag];
    //    [askButton setHidden:YES];
}

#pragma mark   右侧提问与查看答疑的
-(void)askButtonClicked:(id)sender
{
    NSLog(@"提问按钮按下");
    AskViewController * asv = [[AskViewController alloc] init];
   [self presentViewController:asv animated:YES completion:nil];
    [asv release];
}
-(void)catAnswerButtonClicked:(id)sender
{
    NSLog(@"查看答疑");
//    CatAnswerVC * cvc = [[CatAnswerVC alloc] init];
//    [self presentViewController:cvc animated:YES completion:nil];
//    [cvc release];
    
    AnswerQuestionVC * aqc = [[AnswerQuestionVC alloc] init];
    [self presentViewController:aqc animated:YES completion:nil];
    [aqc release];
}

#pragma mark 上下Nav和Bottom的View的淡出淡出
-(void)dissmissSelf:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)topNavViewAppear
{
    CGRect startFrame = CGRectMake(0, 0-Top_Nav_Height, _topNavView.frame.size.width, Top_Nav_Height);
    CGRect endFrame = CGRectMake(0, 0, _topNavView.frame.size.width, Top_Nav_Height);
    [DRTools appearViewAnimationWithView:_topNavView duration:Appear_Time startFrame:startFrame endFrame:endFrame animationName:nil delegate:self];
}
-(void)topNavViewHidden
{
    CGRect endFrame = CGRectMake(0, 0-Top_Nav_Height, _topNavView.frame.size.width, Top_Nav_Height);
    CGRect startFrame = CGRectMake(0, 0, _topNavView.frame.size.width, Top_Nav_Height);
    [DRTools appearViewAnimationWithView:_topNavView duration:Appear_Time startFrame:startFrame endFrame:endFrame animationName:nil delegate:self];
}
-(void)bottomToolViewAppear
{
    CGRect startFrame = CGRectMake(0, _moviePlayer.view.frame.size.height, _bottomToolView.frame.size.width, Bottom_Tool_Height);
    CGRect endFrame = CGRectMake(0, _moviePlayer.view.frame.size.height-Bottom_Tool_Height, _bottomToolView.frame.size.width, Bottom_Tool_Height);
    [DRTools appearViewAnimationWithView:_bottomToolView duration:Appear_Time startFrame:startFrame endFrame:endFrame animationName:nil delegate:self];
}
-(void)bottomToolViewHidden
{
    CGRect endFrame = CGRectMake(0, _moviePlayer.view.frame.size.height, _bottomToolView.frame.size.width, Bottom_Tool_Height);
    CGRect startFrame = CGRectMake(0, _moviePlayer.view.frame.size.height-Bottom_Tool_Height, _bottomToolView.frame.size.width, Bottom_Tool_Height);
    [DRTools appearViewAnimationWithView:_bottomToolView duration:Appear_Time startFrame:startFrame endFrame:endFrame animationName:nil delegate:self];
}
#pragma mark 按钮响应事件
-(void)playFullScreenOrNot:(id)sender
{
    if (_isFullScreen) {
        _isFullScreen = NO;
        NSLog(@"_isFullScreen is YES");
        
        [self topNavViewAppear];
        [self bottomToolViewAppear];
        if (_leftViewPushed) {
        }
        else{
            [self leftViewAppear];
        }
        _leftViewPushed = YES;
    }
    else{
        NSLog(@"_isFullScreen is NO");
        _isFullScreen = YES;
        [self topNavViewHidden];
        [self bottomToolViewHidden];
        if (_leftViewPushed) {
            [self leftViewHidden];
        }
        else{
        }
        _leftViewPushed = NO;
    }
}
-(void)changePlayRate:(id)sender
{
    UISlider * slider = (UISlider*)sender;
    NSLog(@"slider.value is %f",slider.value);
    _moviePlayer.currentPlaybackTime = _fullTime * slider.value;
    [_moviePlayer prepareToPlay];
    [_moviePlayer play];
}
-(void)muteButtonClicked:(id)sender
{
//    UIButton * muteButton = (UIButton*)sender;
    if (_isMute) {
        _isMute = NO;
//        [muteButton setTitle:@"静音" forState:UIControlStateNormal];
        [_muteButton setImage:[UIImage imageNamed:@"playVC_volume_button"] forState:UIControlStateNormal];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:_volume];
        [self updatePlayBackVolume:_volume];
    }
    else{
        _isMute = YES;
//        [muteButton setTitle:@"已静音" forState:UIControlStateNormal];
        [_muteButton setImage:[UIImage imageNamed:@"playVC_volume_button"] forState:UIControlStateNormal];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        [self updatePlayBackVolume:0];
    }
    if(_volume <= 0){
//        [muteButton setTitle:@"已静音" forState:UIControlStateNormal];
        [_muteButton setImage:[UIImage imageNamed:@"playVC_volume_button"] forState:UIControlStateNormal];
    }
}
-(void)changeVolume:(id)sender
{
    NSLog(@"音量控制");
    UISlider * slider = (UISlider*)sender;
    NSLog(@"slider.value is %f",slider.value);
    _volume = slider.value;
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:slider.value];
    
    if (_volume > 0) {
        [self updateMuteButton:_muteButton muteOrNot:NO];
    }
    else{
        [self updateMuteButton:_muteButton muteOrNot:YES];
    }
}
-(void)pauseCilcked:(id)sender
{
    NSLog(@"暂停");
    [_moviePlayer pause];
}
-(void)playCilcked:(id)sender
{
    UIButton * playButton = (UIButton*)sender;
    NSLog(@"播放");
    if (_isPlaying) {
        [playButton setTitle:@"播放" forState:UIControlStateNormal];
         [_playButton setImage:[UIImage imageNamed:@"playVC_play"] forState:UIControlStateNormal];
        [_moviePlayer pause];
    }
    else{
        [playButton setTitle:@"暂停" forState:UIControlStateNormal];
         [_playButton setImage:[UIImage imageNamed:@"playVC_pause"] forState:UIControlStateNormal];
        [_moviePlayer play];
    }
}
-(void)seekingForwardCilcked:(id)sender
{
    NSLog(@"快进");
    NSLog(@"_playingTime is %d",_playingTime);
    int forwardTime = _playingTime + 5;
    _moviePlayer.currentPlaybackTime = forwardTime;
}
-(void)seekingBackCilcked:(id)sender
{
    NSLog(@"快进");
    NSLog(@"_playingTime is %d",_playingTime);
    int backTime = _playingTime - 5;
    _moviePlayer.currentPlaybackTime = backTime;
}
#pragma mark 添加通知

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = _moviePlayer;
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackTimeDidChange:)
                                                 name:MPMoviePlayerTimedMetadataUpdatedNotification
                                               object:player];
    
    //添加对声音大小的判断
    OSStatus s = AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                                 audioVolumeChangeListenerCallback,
                                                 self);
    if (s == kAudioSessionNoError) {
        NSLog(@"监听音量键成功");
    }
    else{
        NSLog(@"监听音量键失败");
    }
}
#pragma mark 移除通知
/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = _moviePlayer;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerTimedMetadataUpdatedNotification object:player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerVolumeDidChangeNotification object:_volumeSlider];
}
#pragma mark 按下外部音量键的回调
void audioVolumeChangeListenerCallback (void *inUserData,
                                        AudioSessionPropertyID inPropertyID,
                                        UInt32 inPropertyValueSize,
                                        const void *inPropertyValue)
{
    if (inPropertyID != kAudioSessionProperty_CurrentHardwareOutputVolume) return;
    Float32 value = *(Float32 *)inPropertyValue;
    NSLog(@"value is %f",value);
    ViewController * viewController = (ViewController *) inUserData;
    [viewController updatePlayBackVolume:value];
}
#pragma mark 声音的更新
-(void)moviePlayVolumeChange:(NSNotification*)notification
{
    float  volume= [MPMusicPlayerController applicationMusicPlayer].volume;
    _volumeSlider.value = volume;
}
#pragma mark 播放的完成的回调通知
/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController * player = notification.object;
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	switch ([reason integerValue])
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            NSLog(@"正常播完");
            _isPause = YES;
            _isPlaying = NO;
            
            NSNumber * movieTime = [NSNumber numberWithInt:player.duration];
            [self playEndUpdate:movieTime];
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
            //            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"]
            //                                waitUntilDone:NO];
            _isPause = YES;
            _isPlaying = NO;
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
            NSLog(@"用户退出");
            _isPause = YES;
            _isPlaying = NO;
			break;
            
		default:
			break;
	}
}
#pragma mark 播放load state 的回调通知
/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
        NSLog(@"类型未知");
        _isPause = YES;
        _isPlaying = NO;
	}
	
	/* The buffer has enough data that playback can begin, but it
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
        NSLog(@"MPMovieLoadStatePlayable  可以播放 视频时间为%f 秒",player.duration);
        _isPause = NO;
        _isPlaying = YES;
        [_playButton setImage:[UIImage imageNamed:@"playVC_play"] forState:UIControlStateNormal];
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        _isPause = NO;
        _isPlaying = YES;
        [MBAlertView dismissCurrentHUD];
        // Add an overlay view on top of the movie view
        NSLog(@"MPMovieLoadStatePlaythroughOK 可以播放 视频时间为%f 秒",player.duration);
        [_playButton setImage:[UIImage imageNamed:@"playVC_pause"] forState:UIControlStateNormal];
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
        _isPause = YES;
        _isPlaying = NO;
        [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:30 show:YES];
        [_playButton setImage:[UIImage imageNamed:@"playVC_play"] forState:UIControlStateNormal];
	}
}
#pragma mark 播放StateDidChange回调通知
/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped)
	{
        NSLog(@"停止按钮");
        _isPause = YES;
        _isPlaying = NO;
	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying)
	{
        NSLog(@"播放按钮");
        _isPause = NO;
        _isPlaying = YES;
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused)
	{
        NSLog(@"暂停按钮");
        _isPause = YES;
        _isPlaying = NO;
	}
	/* Playback is temporarily interrupted, perhaps because the buffer
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted)
	{
        NSLog(@"缓冲被中断");
        _isPause = NO;
        _isPlaying = YES;
	}
}
-(void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    //    [MBAlertView dismissCurrentHUD];
}

#pragma mark 刷新播放时间
-(void)updatePlayTimes:(id)sender
{
    if (_isPlaying && !_isPause) {
        MPMoviePlayerController *player = _moviePlayer;
        NSNumber * fullTime;
        NSNumber * playingTime;
        fullTime = [NSNumber numberWithFloat:player.duration];
        playingTime = [NSNumber numberWithFloat:player.currentPlaybackTime];
        _fullTime = [fullTime intValue];
        _playingTime = [playingTime intValue];
        
        NSString * fullTimeString = [DRTools transSecondToTime:_fullTime];
        NSString * playTimeString = [DRTools transSecondToTime:_playingTime];
        _timeLabel.text = [NSString stringWithFormat:@"%@|%@",playTimeString,fullTimeString];
        
        float rate = (float)(_playingTime)/(_fullTime);
        NSLog(@"进度 %f",(float)(_playingTime)/(_fullTime));
        [self updatePlayBackSlider:rate];
        
        NSLog(@"可以播的时间 %f",player.playableDuration);
    }
}
#pragma mark 刷新播放完时间的归位
-(void)playEndUpdate:(NSNumber*)playTime
{
    NSString * fullTimeString = [DRTools transSecondToTime:_fullTime];
    _timeLabel.text = [NSString stringWithFormat:@"00:00|%@",fullTimeString];
    _playBackSlider.value = 0;
//    [_playButton setTitle:@"播放" forState:UIControlStateNormal];
   [_playButton setImage:[UIImage imageNamed:@"playVC_play"] forState:UIControlStateNormal];
}

#pragma mark 刷新音量控制
-(void)updatePlayBackVolume:(float)volume
{
    _volumeSlider.value = volume;
}
-(void)updateMuteButton:(UIButton*)muteButton muteOrNot:(BOOL)mute
{
    if (mute) {
        _isMute = NO;
//        [muteButton setTitle:@"已静音" forState:UIControlStateNormal];
        [_muteButton setImage:[UIImage imageNamed:@"playVC_volume_button"] forState:UIControlStateNormal];
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        [self updatePlayBackVolume:0];
    }
    else{
        _isMute = YES;
//        [muteButton setTitle:@"静音" forState:UIControlStateNormal];
        [_muteButton setImage:[UIImage imageNamed:@"playVC_volume_button"] forState:UIControlStateNormal];
        [self updatePlayBackVolume:_volume];
    }
}
-(void)updatePlayBackSlider:(float)value
{
    _playBackSlider.value =value;
}
#pragma mark - 触碰事件的回调
// this allows you to dispatch touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
