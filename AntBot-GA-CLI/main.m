//
//  main.m
//  AntBot-GA-CLI
//
//  Created by Joshua Hecker on 3/3/13.
//  Copyright (c) 2013 Joshua Hecker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Controller.h"
#import "Utilities.h"

NSString *INPUT_FILE_PATH = @"~/Desktop";
NSString *OUTPUT_FILE_PATH = @"~/Desktop/antBotRun";
int NUM_ITERATIONS = 10;

int main(int argc, const char * argv[]) {
    //Instantiate controller
    Controller *controller = [[Controller alloc] initWithLogFile:OUTPUT_FILE_PATH];
    Simulation *simulation = [controller simulation];
    
    [simulation setRobotCount:6];
    [simulation setTeamCount:100];
    [simulation setGenerationCount:100];
    [simulation setTagCount:256];
    [simulation setEvaluationCount:8];
    [simulation setExploreTime:0];
    
    [simulation setDistributionClustered:0.];
    [simulation setDistributionPowerlaw:1.];
    [simulation setDistributionRandom:0.];
    
    [simulation setRealWorldError:FALSE];
    
    [simulation setVariableStepSize:FALSE];
    [simulation setUniformDirection:FALSE];
    [simulation setAdaptiveWalk:TRUE];
    
    [simulation setDecentralizedPheromones:FALSE];
    
    NSString *parameterFilePath = [NSString stringWithFormat:@"%@/parameters.plist",[INPUT_FILE_PATH stringByExpandingTildeInPath]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:parameterFilePath]) {
        [simulation setParameterFile:parameterFilePath];
    }
    
    if (argc >= 2){
        int realWorldError = atoi(argv[1]);
        [simulation setRealWorldError:realWorldError];
    }
    
    if (argc >= 3){
        float generationCount = atof(argv[2]);
        [simulation setGenerationCount:generationCount];
    }

    [controller start];
    
    //Write initialization parameters to file
    [controller writeParametersToFile];
    
    //Run for NUM_ITERATIONS and find best overall team
    NSNumber* mostTags = [[NSNumber alloc] initWithFloat:0.];
    Team* bestTeam = [[Team alloc] init];
    NSMutableArray* bestTagsCollected;
    
    for (int i=0; i<NUM_ITERATIONS; i++) {
        
        printf("Starting iteration %d\n",i);
        
        //Run sim
        NSMutableArray* tagsCollected = [simulation run];
        
        //Record parameters of best performing team
        NSNumber* totalTagsCollected = [tagsCollected valueForKeyPath:@"@sum.floatValue"]; //sum over tags collected array
        if (totalTagsCollected > mostTags) {
            mostTags = totalTagsCollected;
            bestTeam = [simulation averageTeam];
            bestTagsCollected = tagsCollected;
        }
    }
    
    //Write best parameters to file for later use
    NSMutableDictionary* bestParameters = [bestTeam getParameters];
    [bestParameters writeToFile:[NSString stringWithFormat:@"%@/parameters.plist",[OUTPUT_FILE_PATH stringByExpandingTildeInPath]] atomically:YES];
    
    //Write best tags collected array to file for analysis
    NSString* joinedTags = [bestTagsCollected componentsJoinedByString:@"\n"];
    [joinedTags writeToFile:[NSString stringWithFormat:@"%@/postEvaluation.txt",[OUTPUT_FILE_PATH stringByExpandingTildeInPath]] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    
    return 0;
}