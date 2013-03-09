//
//  main.m
//  AntBot-GA-CLI
//
//  Created by Joshua Hecker on 3/3/13.
//  Copyright (c) 2013 Joshua Hecker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AntBot-GA/GA.h>
#import "Utilities.h"

NSString *FILE_PATH = @"~/Dropbox/School/Research/AntBot/Data/GA evolved parameters/parameters.csv";
int NUM_ITERATIONS = 10;

int main(int argc, const char * argv[]) {
    //Instantiate sim
    Simulation *simulation = [[Simulation alloc] init];
    
    //Settings
    [simulation setAntCount:6];
    [simulation setColonyCount:100];
    [simulation setGenerationCount:100];
    [simulation setTagCount:256];
    [simulation setDistributionClustered:0];
    [simulation setDistributionPowerlaw:1];
    [simulation setDistributionRandom:0];
    
    //Initialize log file with appropriate column headings
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[FILE_PATH stringByExpandingTildeInPath] error:NULL];
    
    [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
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
                           @"tagsCollected"]
                   toFile:[FILE_PATH stringByExpandingTildeInPath]];
    
    for (int i=0; i<NUM_ITERATIONS; i++) {
        //Run sim
        [simulation start];
        
        //Write parameters to file using comma-delimited format
        NSMutableDictionary *evolvedParameters = [[simulation averageColony] getParameters];
        [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%d\n",
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
                               [simulation averageColony].tagsCollected]
                       toFile:[FILE_PATH stringByExpandingTildeInPath]];
        
    }
    
    return 0;
}