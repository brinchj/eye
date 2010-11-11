'''
This module includes classes for representing and manipulating
experiment and eye-position data.
'''

import bisect
import csv
import json
import re
import time

from glob import glob
from decorators import accepts

DATE_FORMAT = '%m/%d/%Y %I:%M:%S %p'


class EyePosition:
    ''' Represents one eye position sample '''

    _attributes = {
        'timestamp_rel': ('Timestamp', lambda t: float(t) / 1000),
        'pos_x': ('GazePointX', int),
        'pos_y': ('GazePointY', int),
        }

    def __init__(self, exp, **kwargs):
        # Set local attributes
        for name, (key, fun) in EyePosition._attributes.items():
            value = None
            if key in kwargs and len(kwargs[key]) > 0:
                value = fun(kwargs[key])
            setattr(self, name, value)
        # Keep reference to experiment
        self.exp = exp
        self.timestamp_abs = exp.start_time + self.timestamp_rel

    def timestamp_relative(self):
        ''' Timestamp relative to start of experiment '''
        return self.timestamp_rel

    def timestamp(self):
        ''' Timestamp relative to Epoch '''
        return self.timestamp_abs

    def pos(self):
        ''' Position (x,y) '''
        # Extract x,y
        x = self.pos_x
        y = self.pos_y
        if None in (x, y):
            return None
        # Compensate for screen/window offset
        offset_x, offset_y = self.exp.offset
        return (x - offset_x, y - offset_y)


class Experiment:
    '''
    Represents a single experiment, including eye-tracking data,
    assignments and scrollbar position.

    Iterating an Experiment instance yields EyePosition instances.
    '''

    EYE_PATH = '*All-Data.tsv'
    SCROLL_PATH = 'session/scroll.log'

    def __init__(self, exp_path, offset=(0, 0)):
        '''
        Create a new experiment given an experiment data-folder
        The folder can contain:
        1) a *.tsv file with eye-tracking data (REQUIRED)
        2) a session/scroll.log file with scrollbar positions
        '''
        self.exp_path = exp_path

        scroll_paths = glob('%s/%s' % (exp_path, self.SCROLL_PATH))
        self.set_scroll_path(scroll_paths and scroll_paths[0] or None)

        eye_paths = glob('%s/%s' % (exp_path, self.EYE_PATH))
        self.set_eye_path(eye_paths[0])

        self.start_time = self.get_start()
        self.offset = offset

    def set_eye_path(self, path):
        ''' Set path to eye-tracking csv output file '''
        self.eye_path = path
        self.info, self.headers, self.eye_csv = self.load_eye_csv(path)

    def set_scroll_path(self, path):
        ''' Set path to scroll bar positions '''
        self.scroll_path = path
        self.scroll_time, self.scroll_pos = self.load_scroll_log(path)

    @staticmethod
    @accepts(str)
    def load_eye_csv(eye_path):
        ''' Load a csv log of eye positions '''
        # Open file
        eye_csv = csv.reader(file(eye_path), csv.excel_tab)
        # Read info lines
        info = {}
        line = None
        for line in eye_csv:
            if len(line) > 10:
                # no more info
                break
            if len(line) == 2:
                name, value = line
                info[name.strip(' :')] = value.strip()
        # Did we get any?
        if info == {} or line == None:
            raise IOError('Could not parse: ' + eye_path)
        # Output triple
        return info, line, eye_csv

    @staticmethod
    @accepts(str)
    def load_scroll_log(scroll_path=None):
        ''' Load a log of scrollbar positions '''
        if scroll_path == None:
            return [[0], [0]]
        lst = re.findall(r'[^\r\n]+', file(scroll_path).read())
        # convert list of lines to one list
        log = reduce(lambda lst, s: lst + json.loads(s), lst, [])
        # unzip [[time,pos],...] => [[time,...], [pos,...]]
        return zip(*sorted(log))

    @accepts(object, (int, float))
    def get_scrollbar_pos(self, timestamp, start=0):
        ''' Retrieve scrollbar position at given timestamp '''
        idx = bisect.bisect(self.scroll_time, timestamp, lo=start)
        if idx == 0:
            raise ValueError(timestamp)
        return self.scroll_pos[idx - 1]

    def __iter__(self):
        return self

    def next(self):
        ''' Return next element (used for iteration) '''
        return EyePosition(self, **dict(zip(self.headers,
                                            self.eye_csv.next())))

    def get_start(self):
        ''' Start time of experiment '''
        rdate = self.info['Recording date']
        rtime = self.info['Recording time']
        return time.mktime(time.strptime('%s %s' % (rdate, rtime),
                                         DATE_FORMAT))

    @accepts(object, int)
    def offset_to_timestamp(self, offset):
        ''' Convert offset from experiment start to absolute timestamp '''
        return self.start_time + offset

    @accepts(object, int, int)
    def interval(self, start, length):
        ''' Return a time-slice interval of eye-positions '''
        # generator for requested interval
        def generate():
            for elem in self:
                ts = elem.timestamp()
                if ts > start + length:
                    raise StopIteration
                if start < ts and elem.pos() != None:
                    yield elem
        # return interval generator
        return generate()
