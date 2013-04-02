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
    logBestParameters = [NSString stringWithFormat:@"%@/bestParameters_positionalError=%3.2f_detectionError=%3.2f.csv", logFilePath,[simulation positionalError],[simulation detectionError]];
    logMeanParameters = [NSString stringWithFormat:@"%@/meanParameters_positionalError=%3.2f_detectionError=%3.2f.csv", logFilePath,[simulation positionalError],[simulation detectionError]];
    
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
    Team *team;
    NSMutableDictionary *evolvedParameters;
    
    //Write best parameters to file using comma-delimited format
    team = [simulation bestTeam];
    evolvedParameters = [team getParameters];
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
                           team.tagsCollected]
                   toFile:logBestParameters];
    
    //Write averaged parameters to file using comma-delimited format
    team = [simulation averageTeam];
    evolvedParameters = [team getParameters];
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
                           team.tagsCollected]
                   toFile:logMeanParameters];
    
    //If run has completed, add new line to each log file
    if (generation == [simulation generationCount] - 1) {
        [Utilities appendText:@"\n" toFile:logBestParameters];
        [Utilities appendText:@"\n" toFile:logMeanParameters];
    }
}

@end