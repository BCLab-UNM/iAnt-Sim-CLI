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
        logFilePath = [_logFilePath stringByExpandingTildeInPath];
        simulation = [[Simulation alloc] init];
        [simulation setDelegate:self];
    }
    return self;
}

-(void)start {
    logBestParameters = [NSString stringWithFormat:@"%@/bestParameters_localizationError=%3.2f_tagReadError=%3.2f.csv", logFilePath,[simulation localizationError],[simulation tagReadError]];
    logMeanParameters = [NSString stringWithFormat:@"%@/meanParameters_localizationError=%3.2f_tagReadError=%3.2f.csv", logFilePath,[simulation localizationError],[simulation tagReadError]];
    
    //Initialize log file with appropriate column headings
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* headers = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                         @"pheromoneDecayRate",
                         @"travelGiveUpProbability",
                         @"searchGiveUpProbability",
                         @"pheromoneGiveUpProbability",
                         @"uninformedSearchCorrelation",
                         @"informedSearchCorrelationDecayRate",
                         @"pheromoneLayingRate",
                         @"siteFidelityRate",
                         @"pheromoneFollowingRate",
                         @"tagsCollected"];
    
    [fileManager removeItemAtPath:logBestParameters error:NULL];
    [fileManager removeItemAtPath:logMeanParameters error:NULL];
    
    [Utilities appendText:headers toFile:logBestParameters];
    [Utilities appendText:headers toFile:logMeanParameters];
}

-(void) finishedGeneration:(int)generation {
    Colony *colony = [[Colony alloc] init];
    NSMutableDictionary *evolvedParameters = [[NSMutableDictionary alloc] init];
    
    //Write best parameters to file using comma-delimited format
    colony = [simulation bestColony];
    evolvedParameters = [colony getParameters];
    [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%f\n",
                           [evolvedParameters objectForKey:@"pheromoneDecayRate"],
                           [evolvedParameters objectForKey:@"travelGiveUpProbability"],
                           [evolvedParameters objectForKey:@"searchGiveUpProbability"],
                           [evolvedParameters objectForKey:@"pheromoneGiveUpProbability"],
                           [evolvedParameters objectForKey:@"uninformedSearchCorrelation"],
                           [evolvedParameters objectForKey:@"informedSearchCorrelationDecayRate"],
                           [evolvedParameters objectForKey:@"pheromoneLayingRate"],
                           [evolvedParameters objectForKey:@"siteFidelityRate"],
                           [evolvedParameters objectForKey:@"pheromoneFollowingRate"],
                           colony.tagsCollected]
                   toFile:logBestParameters];
    
    //Write averaged parameters to file using comma-delimited format
    colony = [simulation averageColony];
    evolvedParameters = [colony getParameters];
    [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%f\n",
                           [evolvedParameters objectForKey:@"pheromoneDecayRate"],
                           [evolvedParameters objectForKey:@"travelGiveUpProbability"],
                           [evolvedParameters objectForKey:@"searchGiveUpProbability"],
                           [evolvedParameters objectForKey:@"pheromoneGiveUpProbability"],
                           [evolvedParameters objectForKey:@"uninformedSearchCorrelation"],
                           [evolvedParameters objectForKey:@"informedSearchCorrelationDecayRate"],
                           [evolvedParameters objectForKey:@"pheromoneLayingRate"],
                           [evolvedParameters objectForKey:@"siteFidelityRate"],
                           [evolvedParameters objectForKey:@"pheromoneFollowingRate"],
                           colony.tagsCollected]
                   toFile:logMeanParameters];
    
    //If run has completed, add new line to each log file
    if (generation == [simulation generationCount] - 1) {
        [Utilities appendText:@"\n" toFile:logBestParameters];
        [Utilities appendText:@"\n" toFile:logMeanParameters];
    }
}

@end