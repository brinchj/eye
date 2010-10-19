import sys
import experiment


exp = experiment.Experiment(sys.argv[1])

headers = ('MicroSecondTimestamp', 'GazePointX', 'GazePointY')
for tstamp, x, y in ([ line[h] for h in headers] for line in exp):
    if tstamp:
        print tstamp, x, y

