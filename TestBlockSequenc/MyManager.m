//
//  MyManager.m
//  TestBlockSequenc
//
//  Created by Hervé PEROTEAU on 14/08/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "MyManager.h"

@interface MyManager ()
@end

@implementation MyManager

+(MyManager *) sharedInstance {
    
    static dispatch_once_t onceToken;
    static MyManager *sharedMyManager;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[MyManager alloc] init];
    });
    
    return sharedMyManager;
}

//-(id) init {
//    
//    if ((self = [super init])) {
//
//    }
//    
//    return self;
//}

-(void) request1WithCompletion:(void (^)(BOOL success))completion {
    
    [self startReq:@"1" WithCompletion:completion];
}

-(void) request2WithCompletion:(void (^)(BOOL success))completion {
    
    [self startReq:@"2" WithCompletion:completion];
}

-(void) request3WithCompletion:(void (^)(BOOL success))completion {
    
    [self startReq:@"3" WithCompletion:completion];
}

-(void) startReq:(NSString *)reqId WithCompletion:(void (^)(BOOL success))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@">>>> REQ %@", reqId);

        NSLog(@"REQ %@ : sleep 5", reqId);

        sleep(3);

        NSLog(@"REQ %@ : fin du sleep", reqId);

        if (completion) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                NSLog(@"REQ %@ : launch completion in mainThread ...", reqId);

                completion (YES);
                
                NSLog(@"REQ %@ : completion ended ...", reqId);
            });
        }
        
        NSLog(@"<<<<< REQ %@", reqId);
        
    });

}


@end
