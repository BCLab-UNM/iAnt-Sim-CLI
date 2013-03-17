//
//  Controller.h
//  AntBot-GA-CLI
//
//  Created by Joshua Hecker on 3/13/13.
//  Copyright (c) 2013 Joshua Hecker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AntBot-GA/GA.h>
#import "Utilities.h"

@interface Controller : NSObject {
    NSString* logFilePath;
}

-(id) initWithLogFile:(NSString*)_logFilePath;
-(void) start;

@property (nonatomic) Simulation* simulation;
@property (nonatomic) NSString* logBestParameters;
@property (nonatomic) NSString* logMeanParameters;

@end