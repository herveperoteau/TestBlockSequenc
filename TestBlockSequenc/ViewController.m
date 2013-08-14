//
//  ViewController.m
//  TestBlockSequenc
//
//  Created by Hervé PEROTEAU on 14/08/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "ViewController.h"
#import "MyManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)startSimulation:(id)sender;

@end

@implementation ViewController {

    dispatch_queue_t queue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    queue = dispatch_queue_create("myQueue", NULL);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startSimulation:(id)sender {

    [self execSimulation];
}

-(void) execSimulation {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.textView.text = [self.textView.text stringByAppendingString:@"\n\nSTART\n"];
        self.btnStart.enabled = NO;
        [self.activityIndicator startAnimating];
    });
    
    MyManager *manager  = [MyManager sharedInstance];
    
    dispatch_async(queue, ^{

        __block BOOL stop = NO;
        
        __block dispatch_semaphore_t mySem = dispatch_semaphore_create(0);
        
        //--- req1
        [manager request1WithCompletion:^(BOOL success) {
          
            NSLog(@"completion 1 (success=%d)", success);

            self.textView.text = [self.textView.text stringByAppendingString:@"req1 ended\n"];
            
            stop = !success;
            dispatch_semaphore_signal(mySem);
        }];
        
        dispatch_semaphore_wait(mySem, DISPATCH_TIME_FOREVER);
        
        if (stop) return;
        
        //--- req2
        [manager request2WithCompletion:^(BOOL success) {
            
            NSLog(@"completion 2 (success=%d)", success);
            self.textView.text = [self.textView.text stringByAppendingString:@"req2 ended\n"];
            stop = !success;
            dispatch_semaphore_signal(mySem);
        }];
        
        dispatch_semaphore_wait(mySem, DISPATCH_TIME_FOREVER);
        
        if (stop) return;
        
        //--- req3
        [manager request3WithCompletion:^(BOOL success) {
            
            NSLog(@"completion 3 (success=%d)", success);
            self.textView.text = [self.textView.text stringByAppendingString:@"req3 ended\n"];
            stop = !success;
            dispatch_semaphore_signal(mySem);
        }];
        
        dispatch_semaphore_wait(mySem, DISPATCH_TIME_FOREVER);
        
        if (stop) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.textView.text = [self.textView.text stringByAppendingString:@"FIN\n"];
            self.btnStart.enabled = YES;
            [self.activityIndicator stopAnimating];
        });
    });
    
}


@end
