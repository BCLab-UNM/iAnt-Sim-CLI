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
    //Initialize log file with appropriate column headings
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //logFilePath is the same as OUTPUT_FILE_PATH declared in main.m
    //Print the directory for error checking
    NSLog(@"%@\n", logFilePath);
    //If the path does not exist
    if(![fileManager fileExistsAtPath:logFilePath]){
        //Try to create the directory. If it fails, print an error message
        if(![fileManager createDirectoryAtPath:logFilePath withIntermediateDirectories:YES attributes:nil error:NULL]){
            NSLog(@"Error: Create folder failed %@", logFilePath);
        }
    }

    //Create the file names for the best parameters and mean parameters files.
    logBestParameters = [NSString stringWithFormat:@"%@/bestParameters_error=%d", logFilePath,[simulation realWorldError]];
    logMeanParameters = [NSString stringWithFormat:@"%@/meanParameters_error=%d", logFilePath,[simulation realWorldError]];
    
    //If the mean parameters file already exists, put underscore then a number on the end of the file name. Increment the number until the file name does not already exist.
    NSString *temp = logMeanParameters;
    int offset = 0;
    while ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.csv",temp]]) {
        temp = [NSString stringWithFormat:@"%@_%d",logMeanParameters,++offset];
    }
    logMeanParameters = [NSString stringWithFormat:@"%@.csv",temp];

    //If the best parameters file already exists, put underscore then a number on the end of the file name. Increment the number until the file name does not already exist.
    temp = logBestParameters;
    offset = 0;
    while ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.csv",temp]]) {
        temp = [NSString stringWithFormat:@"%@_%d",logBestParameters,++offset];
    }
    logBestParameters = [NSString stringWithFormat:@"%@.csv",temp];
    
    [self writeHeadersToFile:logBestParameters];
    [self writeHeadersToFile:logMeanParameters];
}


-(void) parametersToFile{
    NSString* parametersFile = [NSString stringWithFormat:@"%@/initParameters", logFilePath];
    
    //If the input parameters file already exists, put underscore then a number on the end of the file name. Increment the number until the file name does not already exist.
    NSString *temp = parametersFile;
    int offset = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    while ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@.csv",temp]]) {
        temp = [NSString stringWithFormat:@"%@_%d",parametersFile,++offset];
    }
    parametersFile = [NSString stringWithFormat:@"%@.csv",temp];

    [Utilities appendText:[NSString stringWithFormat:@"robotCount,teamCount,generationCount,tagCount,evaluationCount,distributionClustered,distributionPowerlaw,distributionRandom,realWorldError,variableStepSize,uniformDirection,adaptiveWalk,decentralizedPheromones,randomizeParameters,parameterFile\n"] toFile:parametersFile];

    NSString* textToAppend = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%f,%f,%f,%d,%d,%d,%d,%d,%@\n",
                              [simulation robotCount],
                              [simulation teamCount],
                              [simulation generationCount],
                              [simulation tagCount],
                              [simulation evaluationCount],
                              [simulation distributionClustered],
                              [simulation distributionPowerlaw],
                              [simulation distributionRandom],
                              [simulation realWorldError],
                              [simulation variableStepSize],
                              [simulation uniformDirection],
                              [simulation adaptiveWalk],
                              [simulation decentralizedPheromones],
                              [simulation parameterFile] ];
    [Utilities appendText:textToAppend toFile:parametersFile];
}


-(void) writeTeamToFile:(NSString*)file :(Team*)team{
    NSMutableDictionary *evolvedParameters;
    //Write parameters to file using comma-delimited format
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
                   toFile:file];
}


-(void) writeHeadersToFile:(NSString*)file{
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
    [Utilities appendText:headers toFile:file];
}


-(void) finishedGeneration:(int)generation {
    Team *team;
    //Write best parameters to file using comma-delimited format
    team = [simulation bestTeam];
    [self writeTeamToFile:logBestParameters :team];
        
    //Write averaged parameters to file using comma-delimited format
    team = [simulation averageTeam];
    [self writeTeamToFile:logMeanParameters :team];
    
    //If run has completed, add new line to each log file
    if (generation == [simulation generationCount] - 1) {
        [Utilities appendText:@"\n" toFile:logBestParameters];
        [Utilities appendText:@"\n" toFile:logMeanParameters];
    }
}

@end