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

NSString *FILE_PATH = @"~/Desktop";
int NUM_ITERATIONS = 10;

int main(int argc, const char * argv[]) {
    //Instantiate controller
    Controller *controller = [[Controller alloc] initWithLogFile:FILE_PATH];
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
    
    NSString *parameterFilePath = [NSString stringWithFormat:@"%@/parameters.csv",[FILE_PATH stringByExpandingTildeInPath]];
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
    
    for (int i=0; i<NUM_ITERATIONS; i++) {
        //Run sim
        [simulation start];
    }
    
    return 0;
}