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
    
    [simulation setDistributionClustered:0.];
    [simulation setDistributionPowerlaw:1.];
    [simulation setDistributionRandom:0.];
    
    [simulation setRealWorldError:FALSE];
    
    [simulation setVariableStepSize:FALSE];
    [simulation setUniformDirection:FALSE];
    [simulation setAdaptiveWalk:TRUE];
    
    [simulation setDecentralizedPheromones:FALSE];
    
    [simulation setRandomizeParameters:TRUE];
    [simulation setParameterFile:[NSString stringWithFormat:@"%@/parameters.csv",[INPUT_FILE_PATH stringByExpandingTildeInPath]]];

    [simulation setPostEvaluationFile:[NSString stringWithFormat:@"%@/meanAndBest.csv",[OUTPUT_FILE_PATH stringByExpandingTildeInPath]]];
    
    if (argc >= 2){
        int realWorldError = atoi(argv[1]);
        [simulation setRealWorldError:realWorldError];
    }
    
    if (argc >= 3){
        float generationCount = atof(argv[2]);
        [simulation setGenerationCount:generationCount];
    }

    if (argc >= 4) {
        int randomizeParameters = atoi(argv[3]);
        [simulation setRandomizeParameters:randomizeParameters];
    }
    
    if (argc >= 5) {
        NUM_ITERATIONS = atoi(argv[4]);
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