//
//  MyManager.h
//  TestBlockSequenc
//
//  Created by Hervé PEROTEAU on 14/08/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManager : NSObject


+(MyManager *) sharedInstance;

-(void) request1WithCompletion:(void (^)(BOOL success))completion;
-(void) request2WithCompletion:(void (^)(BOOL success))completion;
-(void) request3WithCompletion:(void (^)(BOOL success))completion;

@end
