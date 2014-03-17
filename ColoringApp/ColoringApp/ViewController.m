//
//  ViewController.m
//  ColoringApp
//
//  Created by Chris Mayer on 08/08/2012.
//  Copyright (c) 2012 CodeStore.co.uk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    // *****************************
    // ** App Configuration Begin **
	// *****************************
    
    // See the PDF guide for help adding your content to the app
    
	// NAMING YOUR FILES
    //
    // Coloring pages must be named: pageX.jpg (where 'X' is the page number)
    //
    // NOTE: Filenames are case-sensitive, and must be lowercase
	
    // Enter below the total number of coloring pages
	pageCount=10;
    
    // Play looping background music?
    // Add a file named background.mp3 to to 'Pages' folder and set the
    // option below to YES
    LoadBackgroundMusic=NO;
    
    // Use transparent PNG files instead of JPGs?
    // Transparent PNGs enable the outlines of the coloring pages to stay
    // above the user's editing, so that the outlines cannot be colored over
    // Change the option below to YES, and name your files (page1.png, page2.png, etc)
    UseTransparentPNGs=NO;
	    
    // *****************************
    // **  App Configuration End  **
    // *****************************

    pageNum=1;
    size=15;
    minsize=3;
    maxsize=25;
    if (UseTransparentPNGs==NO){
        fileExtension=@"jpg";
    }else{
        fileExtension=@"png";
        imagePage.backgroundColor=[UIColor whiteColor];
    }
    imageFade.frame=CGRectMake(0,0,1024,748);
    imageFade.alpha=0;
    viewToolAdjust.alpha=0;
    viewToolSelect.alpha=0;
    viewToolSelect.center=viewToolAdjust.center;
    sliderToolAdjust.minimumValue=minsize;
    sliderToolAdjust.maximumValue=maxsize;
    sliderToolAdjust.value=size;
    tool=1;
    viewTitlescreen.center=CGPointMake(viewPageChooser.center.x, viewPageChooser.center.y);
    [self toolAdjustMove];
    [self loadPage];
    
    //Setup the audio session
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryAmbient error: &error];
	[audioSession setActive:YES error: &error];
	uint8_t *soundBuffer[128];
	NSData *audioData;
    if (LoadBackgroundMusic==YES){
        //Load background music MP3
        audioData = [NSData dataWithContentsOfMappedFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp3"]];
        [audioData getBytes:soundBuffer length:128];
        AudioBGM = [[AVAudioPlayer alloc] initWithData:
                    audioData error:&error];
        AudioBGM.numberOfLoops = -1;
        AudioBGM.volume=0.5;
        [AudioBGM play];
    }
    [super viewDidLoad];
}

-(IBAction)begin{
    viewPageChooser.alpha=0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    viewTitlescreen.center=CGPointMake(viewPageChooser.center.x, -384);
    viewPageChooser.alpha=1;
    [UIView commitAnimations];

}

-(IBAction)pageBW{
    // if the user is not on page 1, go back a page
    if (pageNum>1) pageNum--;
    [self loadPage];
    
}

-(IBAction)pageFW{
    // if the user is not on the last page, go forward a page
    if (pageNum<pageCount) pageNum++;
    [self loadPage];
}

-(IBAction)pageSelect{
    // load the selected page into the editing canvas, then show the editing canvas
    if (UseTransparentPNGs==NO){
        imageOriginal.image=imagePage.image;
    }else{
        imagePNG.image=imagePage.image;
        imageEditing.backgroundColor=[UIColor whiteColor];
    }
    imageEditing.image=nil;
    imagePage.image=nil;
    imageTitlescreen.image=nil;
    viewEditingCanvas.center=viewPageChooser.center;
    buttonUndo.hidden=YES;
    
}

-(void)loadPage{
	
	// generate a filename and path to load the page image file
	pageFilename = [NSString stringWithFormat:@"page%d", pageNum];
	pathFilename = [[NSBundle mainBundle] pathForResource:pageFilename ofType:fileExtension];
	
	// load the file into an imageview, ready to display
	imagePage.image = [UIImage imageWithContentsOfFile:pathFilename];
    
    // show current page number on label below page
    NSString *pagenumString = [[NSString alloc] initWithFormat:@"Side %d of %d",pageNum,pageCount];
    labelPageNum.text=pagenumString;
    [pagenumString release];
    
    buttonPageBW.hidden=NO;
    buttonPageFW.hidden=NO;
    
    if (pageNum==1) buttonPageBW.hidden=YES;
    if (pageNum==pageCount) buttonPageFW.hidden=YES;
    
}

-(IBAction)showHideTools{
    // show or hide the editing tools, by adjusting the height property of the view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    if (viewEditingTools.frame.size.height>72){
        viewEditingTools.frame=CGRectMake(viewEditingTools.frame.origin.x, viewEditingTools.frame.origin.y, viewEditingTools.frame.size.width, 72);
        NSString *arrowFilename = [[NSBundle mainBundle] pathForResource:@"arrow_down" ofType:@"png"];
        [buttonShowHideTools setImage:[UIImage imageWithContentsOfFile:arrowFilename] forState:UIControlStateNormal];
    }else{
        viewEditingTools.frame=CGRectMake(viewEditingTools.frame.origin.x, viewEditingTools.frame.origin.y, viewEditingTools.frame.size.width, 768);
        NSString *arrowFilename = [[NSBundle mainBundle] pathForResource:@"arrow_up" ofType:@"png"];
        [buttonShowHideTools setImage:[UIImage imageWithContentsOfFile:arrowFilename] forState:UIControlStateNormal];
    }
    [UIView commitAnimations];
}

-(IBAction)showToolAdjust:(id)sender{
    // show the selected tool properties window (for changing brush size or color)
    tool = [sender tag];
    viewEditingTools.userInteractionEnabled=NO;
    if (tool==1){
        // brush size window
        if (viewToolAdjust.alpha==0){
            sliderToolAdjust.minimumValue=minsize;
            sliderToolAdjust.maximumValue=maxsize;
            sliderToolAdjust.value=size;
            viewToolAdjust.alpha=1;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            imageFade.alpha=1;
            [UIView commitAnimations];
        }else{
            viewToolAdjust.alpha=0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            imageFade.alpha=0;
            [UIView commitAnimations];
            viewEditingTools.userInteractionEnabled=YES;
        }
        [self toolAdjustMove];
    }else{
        // color and tool select window
        if (viewToolSelect.alpha==0){
            viewToolSelect.alpha=1;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            imageFade.alpha=1;
            [UIView commitAnimations];
        }
    }
}

-(IBAction)toolAdjustMove{
    if (tool==1){
        // adjust size
        size=sliderToolAdjust.value;
        imageSize.frame=CGRectMake(9, 215, size*2.6,size*2.6);
        imageSize.center=CGPointMake(64,290);
        imageSizeAdjust.frame=imageSize.frame;
        imageSizeAdjust.center=CGPointMake(269, 33);
    }    
}

-(IBAction)toolAdjustDone{
    // return to editing canvas
    viewEditingTools.userInteractionEnabled=YES;
    viewToolAdjust.alpha=0;
    viewToolSelect.alpha=0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    imageFade.alpha=0;
    [UIView commitAnimations];
}

-(IBAction)setColor:(id)sender{
    
    // set the brush color based on selection (each button has a tag 0-9 representing
    // either a color or the eraser tool
    
    int color = [sender tag];
    eraser=NO;
    imageTool.image = nil;
    
    if (color==1){
        imageTool.backgroundColor=buttonColor1.backgroundColor;
    }
    if (color==2){
        imageTool.backgroundColor=buttonColor2.backgroundColor;
    }
    if (color==3){
        imageTool.backgroundColor=buttonColor3.backgroundColor;
    }
    if (color==4){
        imageTool.backgroundColor=buttonColor4.backgroundColor;
    }
    if (color==5){
        imageTool.backgroundColor=buttonColor5.backgroundColor;
    }
    if (color==6){
        imageTool.backgroundColor=buttonColor6.backgroundColor;
    }
    if (color==7){
        imageTool.backgroundColor=buttonColor7.backgroundColor;
    }
    if (color==8){
        imageTool.backgroundColor=buttonColor8.backgroundColor;
    }
    if (color==9){
        imageTool.backgroundColor=buttonColor9.backgroundColor;
    }
    if (color==10){
        imageTool.backgroundColor=buttonColor10.backgroundColor;
    }
    if (color==11){
        imageTool.backgroundColor=buttonColor11.backgroundColor;
    }
    if (color==12){
        imageTool.backgroundColor=buttonColor12.backgroundColor;
    }
    if (color==13){
        imageTool.backgroundColor=buttonColor13.backgroundColor;
    }
    if (color==14){
        imageTool.backgroundColor=buttonColor14.backgroundColor;
    }
    if (color==15){
        imageTool.backgroundColor=buttonColor15.backgroundColor;
    }
    if (color==16){
        imageTool.backgroundColor=buttonColor16.backgroundColor;
    }
    if (color==0){
        eraser=YES;
        imageTool.backgroundColor=[UIColor whiteColor];
        NSString *toolFilename = [[NSBundle mainBundle] pathForResource:@"eraser" ofType:@"png"];
        imageTool.image = [UIImage imageWithContentsOfFile:toolFilename];
    }else{
        //Extract RGB values of selected color
        CGColorRef colorref = [imageTool.backgroundColor CGColor];
        int numComponents = CGColorGetNumberOfComponents(colorref);
        if (numComponents == 4) {
            const CGFloat *components = CGColorGetComponents(colorref);
            redvalue     = components[0];
            greenvalue = components[1];
            bluevalue   = components[2];
        }
    }
        
    [self toolAdjustDone];
}


-(IBAction)undo{
    // undo the last edit by restoring image from imageUndo, which is saved before each change
    buttonUndo.hidden=YES;
    imageEditing.image=imageUndo.image;
}

-(IBAction)imageSave{
    //Create image combining drawing with original coloring page
    CGSize savedimageSize = [imageEditing.image size];
    UIGraphicsBeginImageContextWithOptions(savedimageSize, NO, 0.0);
    if (UseTransparentPNGs==NO){
        [imageOriginal.image drawInRect:CGRectMake(0,0,savedimageSize.width,savedimageSize.height)];
        [imageEditing.image drawInRect:CGRectMake(0,0,savedimageSize.width,savedimageSize.height)];
    }else{
        [imageEditing.image drawInRect:CGRectMake(0,0,savedimageSize.width,savedimageSize.height)];
        [imagePNG.image drawInRect:CGRectMake(0,0,savedimageSize.width,savedimageSize.height)];
    }
    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //Save image to iOS Photo Library
    UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil);
	//Create message to explain image is saved to Photos app library
    UIAlertView *savedAlert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Your coloring page has been saved to your iPad's photo library." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	//Display message alert
    [savedAlert show];
}

-(IBAction)imagePrint{
    //Setup print job
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    [pic setDelegate:self];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Coloring";
    pic.printInfo = printInfo;
    
    //Create image combining drawing with original coloring page
    CGSize savedimageSize = [imageEditing.image size];
    UIGraphicsBeginImageContextWithOptions(savedimageSize, NO, 0.0);
    if (UseTransparentPNGs==NO){
        [imageOriginal.image drawInRect:CGRectMake(0,0,savedimageSize.width,savedimageSize.height)];
        [imageEditing.image drawInRect:CGRectMake(0,0,savedimageSize.width,savedimageSize.height)];
    }else{
        [imageEditing.image drawInRect:CGRectMake(0,0,savedimageSize.width,savedimageSize.height)];
        [imagePNG.image drawInRect:CGRectMake(0,0,savedimageSize.width,savedimageSize.height)];
    }
    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    pic.printingItem = combinedImage;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *printerror) {
        if (!completed && printerror) {
            NSLog(@"Printing Error: %@", printerror);
        }
    };
    [pic presentFromRect:CGRectMake(900,648,0,0) inView:viewEditingCanvas animated:YES completionHandler:completionHandler];

}

-(IBAction)close{
    [self loadPage];
    viewEditingCanvas.center=CGPointMake(1536,374);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save image to imageUndo before acting on edit, so that the action can be undone with the undo button
    imageUndo.image=imageEditing.image;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (viewEditingCanvas.center.x==viewPageChooser.center.x){
        
        // drawing code
        if (buttonUndo.hidden==YES) buttonUndo.hidden=NO;
        
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:imageEditing];
        if (lastPoint.x==0 || lastPoint.y==0) lastPoint=currentPoint;
        if (touchended==YES) lastPoint=currentPoint;
        touchended=NO;
        //Speed improvement for iOS7
        UIGraphicsBeginImageContextWithOptions(imageEditing.frame.size, NO, 0.5);
        
        [imageEditing.image drawInRect:CGRectMake(0, 0, imageEditing.frame.size.width, imageEditing.frame.size.height)];
        if (eraser==YES) CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        
        //Set size of crayon head.
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
        
        //Set color based on BGB values set when user selected a color
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redvalue, greenvalue, bluevalue, 1.0);
        
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        imageEditing.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	touchended=YES;
}


@end
