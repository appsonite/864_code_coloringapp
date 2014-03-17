//
//  ViewController.h
//  ColoringApp
//
//  Created by Chris Mayer on 08/08/2012.
//  Copyright (c) 2012 CodeStore.co.uk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<UIPrintInteractionControllerDelegate>{
    
    //Page Chooser & Titlescreen
    IBOutlet UIView *viewPageChooser;
    IBOutlet UIImageView *imagePage;
    IBOutlet UIButton *buttonPageBW;
    IBOutlet UIButton *buttonPageFW;
    IBOutlet UILabel *labelPageNum;
    IBOutlet UIView *viewTitlescreen;
    IBOutlet UIImageView *imageTitlescreen;
    
    //Editing Canvas
    IBOutlet UIView *viewEditingCanvas;
    IBOutlet UIView *viewEditingTools;
    IBOutlet UIImageView *imageOriginal;
    IBOutlet UIImageView *imageEditing;
    IBOutlet UIImageView *imagePNG;
    IBOutlet UIButton *buttonShowHideTools;
    IBOutlet UIView *viewToolSelect;
    IBOutlet UIView *viewToolAdjust;
    IBOutlet UISlider *sliderToolAdjust;
    IBOutlet UILabel *labelAdjustMin;
    IBOutlet UILabel *labelAdjustMax;
    IBOutlet UIImageView *imageFade;
    IBOutlet UIImageView *imageSize;
    IBOutlet UIImageView *imageSizeAdjust;
    IBOutlet UIButton *buttonUndo;
    IBOutlet UIImageView *imageUndo;
    IBOutlet UIImageView *imageTool;
    
    //Color Palette
    IBOutlet UIButton *buttonColor1;
    IBOutlet UIButton *buttonColor2;
    IBOutlet UIButton *buttonColor3;
    IBOutlet UIButton *buttonColor4;
    IBOutlet UIButton *buttonColor5;
    IBOutlet UIButton *buttonColor6;
    IBOutlet UIButton *buttonColor7;
    IBOutlet UIButton *buttonColor8;
    IBOutlet UIButton *buttonColor9;
    IBOutlet UIButton *buttonColor10;
    IBOutlet UIButton *buttonColor11;
    IBOutlet UIButton *buttonColor12;
    IBOutlet UIButton *buttonColor13;
    IBOutlet UIButton *buttonColor14;
    IBOutlet UIButton *buttonColor15;
    IBOutlet UIButton *buttonColor16;
    IBOutlet UIButton *buttonEraser;
    
    //Audio
    AVAudioPlayer *AudioBGM; //for playback of the background music audio file
	NSError *error; //error reporting for audio session
	
    //Variables
    int pageCount;
    int pageNum;
    int tool;
    double maxsize;
    double minsize;
    double size;
    bool touchended;
    bool eraser;
    bool UseTransparentPNGs;
    bool LoadBackgroundMusic;
    CGPoint lastPoint;
    NSString* pageFilename; //used for storing a filename to load pages
	NSString* pathFilename; //used for storing a filepath to load pages
    NSString* fileExtension; //used for storing the filename extension (either png or jpg)
	
    //Crayon color values
    float redvalue;
    float greenvalue;
    float bluevalue;
	
}

//Titlescreen
-(IBAction)begin;

//Page Chooser
-(IBAction)pageBW;
-(IBAction)pageFW;
-(IBAction)pageSelect;

//Editing Canvas
-(IBAction)showHideTools;
-(IBAction)showToolAdjust:(id)sender;
-(IBAction)toolAdjustMove;
-(IBAction)toolAdjustDone;
-(IBAction)setColor:(id)sender;
-(IBAction)undo;
-(IBAction)imageSave;
-(IBAction)imagePrint;
-(IBAction)close;

@end
