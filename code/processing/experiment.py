'''
This module includes classes for representing and manipulating
experiment and eye-position data.
'''

import bisect
import csv
import json
import re
import time

DATE_FORMAT = '%m/%d/%Y %H:%M:%S %p'


class EyePosition:
    ''' Represents one eye position sample '''

    def __init__(self, exp, **kwargs):
        self.raw = kwargs
        self.exp = exp

        self.timestamp_rel = self.get(Timestamp=float) / 1000
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
        x = self.get(GazePointX=int)
        y = self.get(GazePointY=int)
        if None in (x, y):
            return None
        # Compensate for screen/window offset
        offset_x, offset_y = self.exp.offset
        return (x - offset_x, y - offset_y)

    def get(self, **kwargs):
        '''
        Get raw property with type-casting (for internal use only)
        Example: get(Timestamp=float) => float(raw["Timestamp"])
        '''
        if len(kwargs) != 1:
            raise TypeError("Only 1 argument supported: " + kwargs)
        name = kwargs.keys()[0]
        if not name in self.raw or self.raw[name] == '':
            return None
        return kwargs[name](self.raw[name])


class Experiment:
    '''
    Represents a single experiment, including eye-tracking data
    and scrollbar position.

    Iterating an Experiment instance yields EyePosition instances.
    '''

    def __init__(self, eye_path, scroll_path, offset=(0, 0)):
        self.scroll_time, self.scroll_pos = self.load_scroll_log(scroll_path)

        self.load_scroll_log(scroll_path)
        self.info, self.headers, self.eye_csv = self.load_eye_csv(eye_path)

        self.start_time = self.get_start()

        self.offset = offset

    @staticmethod
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
    def load_scroll_log(scroll_path):
        ''' Load a log of scrollbar positions '''
        lst = re.findall(r'[^\r\n]+', file(scroll_path).read())
        # convert list of lines to one list
        log = reduce(lambda lst, s: lst + json.loads(s), lst, [])
        # unzip [[time,pos],...] => [[time,...], [pos,...]]
        return zip(*sorted(log))

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

    def offset_to_timestamp(self, offset):
        ''' Convert offset from experiment start to absolute timestamp '''
        return self.start_time + offset
