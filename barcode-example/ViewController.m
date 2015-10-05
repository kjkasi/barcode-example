//
//  ViewController.m
//  barcode-example
//
//  Created by Anton Minin on 05.10.15.
//  Copyright © 2015 Anton Minin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureMetadataOutput *output;

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

- (AVCaptureDevice *)device {
    
    if (_device == nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _device = device;
        
    }
    
    return _device;
}

- (AVCaptureSession *)session {
    
    if (_session == nil) {
        
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        if ([session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            session.sessionPreset = AVCaptureSessionPresetHigh;
        }
        
        NSError *error = nil;
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        
        [session addInput:input];
        
        [session addOutput:self.output];
        
        NSMutableArray *types = [@[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeUPCECode,
                                   AVMetadataObjectTypeCode39Code,
                                   AVMetadataObjectTypeCode39Mod43Code,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode93Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypePDF417Code,
                                   AVMetadataObjectTypeAztecCode] mutableCopy];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [types addObjectsFromArray:@[
                                         AVMetadataObjectTypeInterleaved2of5Code,
                                         AVMetadataObjectTypeITF14Code,
                                         AVMetadataObjectTypeDataMatrixCode
                                         ]];
        }
        
        self.output.metadataObjectTypes = types;
        
        _session = session;
        
    }
    return _session;
}

- (AVCaptureMetadataOutput *)output {
    
    if (_output == nil) {
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _output = output;
    }
    
    return _output;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
}

@end
