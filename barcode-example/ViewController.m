//
//  ViewController.m
//  barcode-example
//
//  Created by Anton Minin on 05.10.15.
//  Copyright © 2015 Anton Minin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^( BOOL granted ) {
        //
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect bounds = self.view.layer.bounds;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.bounds = bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    
    [self.session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.session stopRunning];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AVCaptureSession *)session {
    
    if (_session == nil) {
        
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        if ([session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            session.sessionPreset = AVCaptureSessionPresetHigh;
        }
        
        AVCaptureDevice *devica = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:devica error:&error];
        
        [session addInput:input];
        
        _session = session;
        
    }
    return _session;
}

@end
