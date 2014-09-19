Get the Code
---

    git clone https://github.com/BCLab-UNM/AntBot-GA-CLI.git
    cd AntBot-GA-CLI
    git checkout tatiana

Compile the Code
---

Execute

    xcodebuild

From the AntBot-GA-CLI directory.

Running the Code
---

The basic command to run the GA (from the AntBot-GA-CLI directory):

    build/Release/AntBot-GA-CLI

There are a number of command line flags that control tag distribution, grid size, and other things.  To see a list of them with their default values, run:

    build/Release/AntBot-GA-CLI -h

Recommended flags for performing a single run and disabling evolution:

    build/Release/AntBot-GA-CLI -iters 1 -popSize 1 -genLimit 0 -noError

Data for all runs will be dumped to your Desktop in a folder named iAntSimulation.  Inside the folder for each run, there should be two text documents: tags.txt and pheromones.txt.  They contain comma separated matrices with tag and pheromone locations, respectively.  There is a matrix for each tick, and matrices are separated by blank lines.

Controlling Ant Behavior
---

The GA looks for a file on the desktop named `evolvedParameters.plist` to control initial colony behavior parameters.  You can find a sample `evolvedParameters.plist` file in the AntBot-GA-CLI folder.
