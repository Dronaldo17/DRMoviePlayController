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
#import "UIImage+Resize.h"
#import "AskPictureModel.h"

#define VoicePath    [NSString stringWithFormat:@"%@/Documents/ipad_ask_voice.caf", NSHomeDirectory()]
#define BasePicturePath(A)   [NSString stringWithFormat:@"%@/Documents/ipad_ask_pic%d.png", NSHomeDirectory(),(A)]

@interface AskViewController ()<AVAudioPlayerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat _tmpFloat;
    UIView * _ansWerView;
    UIView * _topInputView;

    UIButton * _recordButton;
    
    PhotoWallView * _pwv;
    
    
    CGRect _tmpPicRect;
    
    UIButton * _delVoiceButton;  //删除视频的button
    
    BOOL _isRecorded;            //录音成功
    
    BOOL   _isPlaying;         //是否播放录音
    
    AVAudioPlayer * _player;   //播放录音的player
    
    NSMutableArray * _photoArray;   //照片数组
    
    UIPopoverController * _popover;    //相册相框
    
}   

@end

@implementation AskViewController
- (void)dealloc
{
     RELEASE_SAFELY(_ansWerView);
     RELEASE_SAFELY(_topInputView);
     RELEASE_SAFELY(_recordButton);
     RELEASE_SAFELY(_pwv);
     RELEASE_SAFELY(_delVoiceButton);
     RELEASE_SAFELY(_player);
    RELEASE_SAFELY(_photoArray);
    [self removeNotifaction];
    [super dealloc];
}

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
    
    
    //添加提交button
    [self addSubmitButton];
    
    //添加通知
    [self addNotifaction];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 添加通知
-(void)addNotifaction
{
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(addPictureClicked:) name:Add_Ask_Pic object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(delPictureClicked:) name:Del_Ask_Pic  object:nil];
}
#pragma mark 移除通知
-(void)removeNotifaction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Add_Ask_Pic object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Del_Ask_Pic object:nil];
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
    _photoArray = [[NSMutableArray alloc] initWithCapacity:0];
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
    UIImageView * topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(20, _tmpFloat + 20, _ansWerView.frame.size.width - 2* 20 , 5)];
    topLineView.image = [UIImage imageNamed:@"ask_line"];
    [_topInputView addSubview:topLineView];
    
//   _photoArray = [NSMutableArray arrayWithObjects:@"1",@"0",@"1",@"2",nil];
//    NSMutableArray * array = nil;
	// Do any additional setup after loading the view, typically from a nib.
   _pwv =[[PhotoWallView alloc] init];
    _pwv.btnViewType = PHOTOWALLVIEW;
    _pwv.isEdit = YES;
    _pwv.photoNumOfLine = 4;
    _pwv.heightForSepPhoto = 5;
    _pwv.widthOfPhoto = 80;
    _pwv.heightOfPhoto = 80;
    _pwv.photoWallWidth= 400;
    [_pwv doInitWithPhotoNumbers:_photoArray];
     _pwv.frame = CGRectMake(20, topLineView.frame.origin.y+topLineView.frame.size.height+5, 400, 90);
    NSLog(@"pwv.frame is %@",NSStringFromCGRect(_pwv.frame));
    [_topInputView addSubview:_pwv];
    
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake( 520,topLineView.frame.origin.y+topLineView.frame.size.height +10,160, 80)];

    [_recordButton setImage:[UIImage imageNamed:@"ask_record_button"] forState:UIControlStateHighlighted];
    [_recordButton setImage:[UIImage imageNamed:@"ask_record_button"] forState:UIControlStateNormal];
    [_topInputView addSubview:_recordButton];
    
    
    _delVoiceButton = [[UIButton alloc] initWithFrame:CGRectMake(_recordButton.frame.origin.x+_recordButton.frame.size.width-15, _recordButton.frame.origin.y-10, 30, 30)];
    [_delVoiceButton setImage:[UIImage imageNamed:@"ask_record_delbutton"] forState:UIControlStateNormal];
      [_delVoiceButton setImage:[UIImage imageNamed:@"ask_record_delbutton"] forState:UIControlStateHighlighted];
//    [_delVoiceButton setBackgroundColor:[UIColor redColor]];
    [_delVoiceButton setHidden:YES];
    [_delVoiceButton addTarget:self action:@selector(delVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    [_topInputView addSubview:_delVoiceButton];

    
    [_recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [topLineView release];
}
#pragma mark 添加提交按钮
-(void)addSubmitButton
{
    UIButton * submitButton  =[[UIButton alloc] initWithFrame:CGRectMake(_ansWerView.frame.size.width/2 - 90, _topInputView.frame.origin.y+_topInputView.frame.size.height + 10, 180, 50)];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"ask_submit_button"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"ask_submit_button"] forState:UIControlStateNormal];
    
    [submitButton setTitle:@"提  交" forState:UIControlStateNormal];
    [submitButton setTitle:@"提  交" forState:UIControlStateHighlighted];
    
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:24.0];

    [submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ansWerView addSubview:submitButton];
}
#pragma mark 提交按钮
-(void)submitButtonClicked:(id)sender
{
    NSLog(@"提交按钮");
}
#pragma mark 删除按钮按钮
-(void)delVoiceButton:(id)sender
{
        //stop 播放
       [self stopPlayVoiceAndClearPlayer];
        
//        删除录音
       [self delVoice];
        
        //刷新按钮
        [self updateVocieButton:NO isPlaying:NO];
}
#pragma mark 删除录音
-(void)delVoice
{
     NSError * error = nil;
     [[NSFileManager defaultManager] removeItemAtPath:VoicePath error:&error];
    _isRecorded = NO;
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
    if (_isRecorded) {
        if (_isPlaying) {
            [self stopPlayVoiceAndClearPlayer];
            [self updateVocieButton:_isRecorded isPlaying:NO];
        }
        else{
            [self playVoice];
            [self updateVocieButton:_isRecorded isPlaying:YES];
        }
    }
    else{
        [self startRecordVoice];
    }
  
}
#pragma mark 播放录音
-(void)playVoice
{
    [self stopPlayVoiceAndClearPlayer];
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:VoicePath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_player setDelegate:self];
    [_player prepareToPlay];
    [_player play];
    _isPlaying = YES;
}

#pragma mark 开始录音
-(void)startRecordVoice
{
    [self.voiceHud startForFilePath:VoicePath];
}
#pragma mark 停止录音
-(void)stopPlayVoiceAndClearPlayer
{
    _isPlaying = NO;
    [_recordButton.imageView stopAnimating];
    if (_player) {
        if([_player isPlaying]){
            [_player stop];
        }
        RELEASE_SAFELY(_player);
        [_recordButton setImage:[UIImage imageNamed:@"askv_voice_play3"] forState:UIControlStateNormal];
    }
}
#pragma mark - POVoiceHUD Delegate
- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength {
    _isRecorded = YES;
    [self updateVocieButton:_isRecorded isPlaying:NO];
    
}
- (void)voiceRecordCancelledByUser:(POVoiceHUD *)voiceHUD
{
    NSLog(@"Voice recording cancelled for HUD: %@", voiceHUD);
    _isRecorded = NO;
}

-(void)updateVocieButton:(BOOL)isRecord  isPlaying:(BOOL)isPlaying
{
    if (!isRecord) {
        [_recordButton setBackgroundColor:[UIColor clearColor]];
        [_recordButton setImage:[UIImage imageNamed:@"ask_record_button"] forState:UIControlStateHighlighted];
        [_recordButton setImage:[UIImage imageNamed:@"ask_record_button"] forState:UIControlStateNormal];
        _delVoiceButton.hidden = YES;
    }
    else{
        [_recordButton setImage:[UIImage imageNamed:@"askv_voice_play3"] forState:UIControlStateHighlighted];
        [_recordButton setImage:[UIImage imageNamed:@"askv_voice_play3"] forState:UIControlStateNormal];
        [_recordButton setBackgroundColor:[UIColor orangeColor]];
        _delVoiceButton.hidden = NO;
    }
    if (isPlaying) {
        NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"askv_voice_play1"],
                            [UIImage imageNamed:@"askv_voice_play2"],
                            [UIImage imageNamed:@"askv_voice_play3"],nil];
        _recordButton.imageView.animationImages = gifArray; //动画图片数组
        _recordButton.imageView.animationDuration = 2; //执行一次完整动画所需的时长
        _recordButton.imageView.animationRepeatCount = 9999;  //动画重复次数
        [_recordButton.imageView startAnimating];
    }
    else{
        [self stopPlayVoiceAndClearPlayer];
    }
}
#pragma mark 播完回调
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self stopPlayVoiceAndClearPlayer];
    }
}
#pragma mark 点击添加图片按钮
-(void)addPictureClicked:(NSNotification*)notification
{
    
//    UIButton * addButton = notification.object;
//    _tmpPicRect = addButton.frame;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择方式" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"从相册选择",@"照相",@"取消", nil];
    
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"index : %d" ,buttonIndex);
    switch (buttonIndex) {
        case 0:
            NSLog(@"从相册选择照片");
            [self addImage:2];
            break;
        case 1:
            NSLog(@"新照相");
            [self addImage:1];
            break;
        default:
            break;
    }
}
#pragma mark  删除照片
-(void)delPictureClicked:(NSNotification*)notification
{
    NSNumber * number = notification.object;
    int tag = number.intValue;
    [_photoArray removeObjectAtIndex:tag];
    [_pwv refleshDataWithPhotoNumber:_photoArray];
}
#pragma mark 弹出相机或者相册
-(void)addImage:(int)type
{
    //1为相机   2为相册
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    RELEASE_SAFELY(_popover);
//    picker.allowsEditing = YES;
   _popover = [[UIPopoverController alloc] initWithContentViewController:picker];
     [picker release];
    [_popover presentPopoverFromRect:_tmpPicRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma ImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([_popover isPopoverVisible]) {
        [_popover dismissPopoverAnimated:YES];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self processingSelectImage:image];
}

- (void)processingSelectImage:(UIImage *)selectImage {
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:selectImage] autorelease];
    imageView.frame = CGRectMake(0, 0, selectImage.size.width, selectImage.size.height);
    UIGraphicsBeginImageContext(imageView.bounds.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = [UIGraphicsGetImageFromCurrentImageContext() resizedImage:CGSizeMake(600, 600) interpolationQuality:kCGInterpolationDefault];
    UIGraphicsEndImageContext();
    NSData * imageData = UIImageJPEGRepresentation(saveImage, 0.8);
    
    
    AskPictureModel * model = [[AskPictureModel alloc] init];
    model.imageData = imageData;
    model.imagePath = BasePicturePath([_photoArray count]);
    [_photoArray addObject:model];
    [model release];
    
    [_pwv refleshDataWithPhotoNumber:_photoArray];
}
@end
