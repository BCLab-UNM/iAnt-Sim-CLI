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
    if (self = [super init]) {
        logFilePath = [_logFilePath stringByExpandingTildeInPath];
        simulation = [[Simulation alloc] init];
        [simulation setDelegate:self];
    }
    return self;
}

-(void)start {
    logBestParameters = [NSString stringWithFormat:@"%@/bestParameters_error=%d", logFilePath,[simulation realWorldError]];
    logMeanParameters = [NSString stringWithFormat:@"%@/meanParameters_error=%d", logFilePath,[simulation realWorldError]];
    
    //Initialize log file with appropriate column headings
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* headers = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                         @"pheromoneDecayRate",
                         @"travelGiveUpProbability",
                         @"searchGiveUpProbability",
                         @"uninformedSearchCorrelation",
                         @"informedSearchCorrelationDecayRate",
                         @"stepSizeVariation",
                         @"pheromoneLayingRate",
                         @"siteFidelityRate",
                         @"pheromoneFollowingRate",
                         @"tagsCollected"];
    
    NSString *temp = logMeanParameters;
    int offset = 0;
    while ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.csv",temp]]) {
        temp = [NSString stringWithFormat:@"%@__%d",logMeanParameters,++offset];
    }
    logMeanParameters = [NSString stringWithFormat:@"%@.csv",temp];
    
    temp = logBestParameters;
    offset = 0;
    while ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.csv",temp]]) {
        temp = [NSString stringWithFormat:@"%@__%d",logBestParameters,++offset];
    }
    logBestParameters = [NSString stringWithFormat:@"%@.csv",temp];
    
    [Utilities appendText:headers toFile:logBestParameters];
    [Utilities appendText:headers toFile:logMeanParameters];
}

-(void) finishedGeneration:(int)generation {
    Team *team;
    NSMutableDictionary *evolvedParameters;
    
    //Write best parameters to file using comma-delimited format
    team = [simulation bestTeam];
    evolvedParameters = [team getParameters];
    [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%f\n",
                           [evolvedParameters objectForKey:@"pheromoneDecayRate"],
                           [evolvedParameters objectForKey:@"travelGiveUpProbability"],
                           [evolvedParameters objectForKey:@"searchGiveUpProbability"],
                           [evolvedParameters objectForKey:@"uninformedSearchCorrelation"],
                           [evolvedParameters objectForKey:@"informedSearchCorrelationDecayRate"],
                           [evolvedParameters objectForKey:@"stepSizeVariation"],
                           [evolvedParameters objectForKey:@"pheromoneLayingRate"],
                           [evolvedParameters objectForKey:@"siteFidelityRate"],
                           [evolvedParameters objectForKey:@"pheromoneFollowingRate"],
                           team.tagsCollected]
                   toFile:logBestParameters];
    
    //Write averaged parameters to file using comma-delimited format
    team = [simulation averageTeam];
    evolvedParameters = [team getParameters];
    [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%f\n",
                           [evolvedParameters objectForKey:@"pheromoneDecayRate"],
                           [evolvedParameters objectForKey:@"travelGiveUpProbability"],
                           [evolvedParameters objectForKey:@"searchGiveUpProbability"],
                           [evolvedParameters objectForKey:@"uninformedSearchCorrelation"],
                           [evolvedParameters objectForKey:@"informedSearchCorrelationDecayRate"],
                           [evolvedParameters objectForKey:@"stepSizeVariation"],
                           [evolvedParameters objectForKey:@"pheromoneLayingRate"],
                           [evolvedParameters objectForKey:@"siteFidelityRate"],
                           [evolvedParameters objectForKey:@"pheromoneFollowingRate"],
                           team.tagsCollected]
                   toFile:logMeanParameters];
    
    //If run has completed, add new line to each log file
    if (generation == [simulation generationCount] - 1) {
        [Utilities appendText:@"\n" toFile:logBestParameters];
        [Utilities appendText:@"\n" toFile:logMeanParameters];
    }
}

@end