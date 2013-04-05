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
    
    [simulation setDistributionClustered:0.];
    [simulation setDistributionPowerlaw:1.];
    [simulation setDistributionRandom:0.];
    
    [simulation setPositionalError:0.];
    [simulation setDetectionError:0.];
    
    [simulation setTagFractionCutoff:1.];
    
    [simulation setRandomizeParameters:TRUE];
    
    [simulation setParameterFile:[NSString stringWithFormat:@"%@/parameters.csv",[FILE_PATH stringByExpandingTildeInPath]]];
    
    if (argc >= 2){
        float positionalError = atof(argv[1]);
        [simulation setPositionalError:positionalError];
    }
    
    if (argc >= 3){
        float detectionError = atof(argv[2]);
        [simulation setDetectionError:detectionError];
    }
    
    if (argc >= 4){
        float generationCount = atof(argv[3]);
        [simulation setGenerationCount:generationCount];
    }

    if (argc >= 5) {
        int randomizeParameters = atoi(argv[4]);
        [simulation setRandomizeParameters:randomizeParameters];
    }
    
    [controller start];
    
    for (int i=0; i<NUM_ITERATIONS; i++) {
        //Run sim
        [simulation start];
    }
    
    return 0;
}