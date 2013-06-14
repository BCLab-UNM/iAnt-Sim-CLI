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
int NUM_ITERATIONS = 1;

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
    
<<<<<<< HEAD
    [simulation setRandomizeParameters:TRUE];
    [simulation setParameterFile:[NSString stringWithFormat:@"%@/parameters.csv",[INPUT_FILE_PATH stringByExpandingTildeInPath]]];

    [simulation setPostEvaluationFile:[NSString stringWithFormat:@"%@/meanAndBest.csv",[OUTPUT_FILE_PATH stringByExpandingTildeInPath]]];
=======
    NSString *parameterFilePath = [NSString stringWithFormat:@"%@/parameters.csv",[FILE_PATH stringByExpandingTildeInPath]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:parameterFilePath]) {
        [simulation setParameterFile:parameterFilePath];
    }
>>>>>>> 3a4f32b7aad74c3200166671887b8237f5f1a4d4
    
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
    [controller parametersToFile];
    
    for (int i=0; i<NUM_ITERATIONS; i++) {
        printf("Starting iteration %d\n",i);
        //Run sim
        [simulation start];
    }
    
    return 0;
}