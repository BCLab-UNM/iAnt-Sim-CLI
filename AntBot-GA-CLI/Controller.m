//
//  Controller.m
//  AntBot-GA-CLI
//
//  Created by Joshua Hecker on 3/13/13.
//  Copyright (c) 2013 Joshua Hecker. All rights reserved.
//

#import "Controller.h"

@implementation Controller

@synthesize simulation,logBestParameters,logMeanParameters;

- (id) initWithLogFile:(NSString*)_logFilePath {
    if (self == [super init]) {
        simulation = [[Simulation alloc] init];
        [simulation setDelegate:self];
        
        _logFilePath = [_logFilePath stringByExpandingTildeInPath];
        logBestParameters = [NSString stringWithFormat:@"%@/bestParameters.csv", _logFilePath];
        logMeanParameters = [NSString stringWithFormat:@"%@/meanParameters.csv", _logFilePath];
        
        //Initialize log file with appropriate column headings
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString* headers = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                             @"decayRate",
                             @"walkDropRate",
                             @"searchGiveupRate",
                             @"trailDropRate",
                             @"dirDevConst",
                             @"dirDevCoeff",
                             @"dirTimePow",
                             @"densityThreshold",
                             @"densityConstant",
                             @"densityPatchThreshold",
                             @"densityPatchConstant",
                             @"densityInfluenceThreshold",
                             @"densityInfluenceConstant",
                             @"tagsCollected"];
        
        [fileManager removeItemAtPath:logBestParameters error:NULL];
        [fileManager removeItemAtPath:logMeanParameters error:NULL];
        
        [Utilities appendText:headers toFile:logBestParameters];
        [Utilities appendText:headers toFile:logMeanParameters];
    }
    return self;
}

-(void) finishedGeneration:(int)generation {
    Colony *colony = [[Colony alloc] init];
    NSMutableDictionary *evolvedParameters = [[NSMutableDictionary alloc] init];
    
    //Write best parameters to file using comma-delimited format
    colony = [simulation bestColony];
    evolvedParameters = [colony getParameters];
    [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%f\n",
                           [evolvedParameters objectForKey:@"decayRate"],
                           [evolvedParameters objectForKey:@"walkDropRate"],
                           [evolvedParameters objectForKey:@"searchGiveupRate"],
                           [evolvedParameters objectForKey:@"trailDropRate"],
                           [evolvedParameters objectForKey:@"dirDevConst"],
                           [evolvedParameters objectForKey:@"dirDevCoeff"],
                           [evolvedParameters objectForKey:@"dirTimePow"],
                           [evolvedParameters objectForKey:@"densityThreshold"],
                           [evolvedParameters objectForKey:@"densityConstant"],
                           [evolvedParameters objectForKey:@"densityPatchThreshold"],
                           [evolvedParameters objectForKey:@"densityPatchConstant"],
                           [evolvedParameters objectForKey:@"densityInfluenceThreshold"],
                           [evolvedParameters objectForKey:@"densityInfluenceConstant"],
                           colony.tagsCollected]
                   toFile:logBestParameters];
    
    //Write averaged parameters to file using comma-delimited format
    colony = [simulation averageColony];
    evolvedParameters = [colony getParameters];
    [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%f\n",
                           [evolvedParameters objectForKey:@"decayRate"],
                           [evolvedParameters objectForKey:@"walkDropRate"],
                           [evolvedParameters objectForKey:@"searchGiveupRate"],
                           [evolvedParameters objectForKey:@"trailDropRate"],
                           [evolvedParameters objectForKey:@"dirDevConst"],
                           [evolvedParameters objectForKey:@"dirDevCoeff"],
                           [evolvedParameters objectForKey:@"dirTimePow"],
                           [evolvedParameters objectForKey:@"densityThreshold"],
                           [evolvedParameters objectForKey:@"densityConstant"],
                           [evolvedParameters objectForKey:@"densityPatchThreshold"],
                           [evolvedParameters objectForKey:@"densityPatchConstant"],
                           [evolvedParameters objectForKey:@"densityInfluenceThreshold"],
                           [evolvedParameters objectForKey:@"densityInfluenceConstant"],
                           colony.tagsCollected]
                   toFile:logMeanParameters];
}

@end
