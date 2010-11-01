import bisect
import csv
import json
import re
import time

DATE_FORMAT = '%m/%d/%Y %H:%M:%S %p'


class EyePosition:
    def __init__(self, exp, **kwargs):
        self.raw = kwargs
        self.exp = exp

        self.timestamp_rel = float(self.raw['Timestamp']) / 1000
        self.timestamp_abs = exp.recStart + self.timestamp_rel


    def timestamp_relative(self):
        return self.timestamp_rel

    def timestamp(self):
        return self.timestamp_abs

    def x(self):
        return self.get(GazePointX=int)

    def y(self):
        return self.get(GazePointY=int)

    def get(self, **kwargs):
        if len(kwargs) != 1:
            raise ArgumentError("Only 1 argument supported: " + kwargs)
        name = kwargs.keys()[0]
        if not name in self.raw or self.raw[name] == '':
            return None
        return kwargs[name](self.raw[name])


class Experiment:
    def __init__(self, eyePath, scrollPath):
        self.info = {}
        self.eyeCsv = None
        self.scrollTime = None
        self.scrollPos  = None

        self.load_eye_csv(eyePath)
        self.load_scroll_log(scrollPath)

    def load_eye_csv(self, eyePath):
        """ Load a csv log of eye positions """
        self.eyeCsv = csv.reader(file(eyePath), csv.excel_tab)
        # read info lines
        for line in self.eyeCsv:
            if len(line) > 10:
                # no more info
                break
            if len(line) == 2:
                n,v = line
                self.info[n.strip(' :')] = v.strip()
        self.headers = line
        self.recStart = self.get_rec_start()

    def load_scroll_log(self, scrollPath):
        """ Load a log of scrollbar positions """
        lst = re.findall(r'[^\r\n]+', file(scrollPath).read())
        # convert list of lines to one list
        log = reduce(lambda lst,s: lst + json.loads(s), lst, [])
        # unzip [[time,pos],...] => [[time,...], [pos,...]]
        time, pos = zip(*sorted(log))
        # update self
        self.scrollTime = time
        self.scrollPos  = pos


    def scroll_pos(self, ts, start=0):
        idx = bisect.bisect(self.scrollTime, ts, lo=start)
        if idx == 0:
            raise ValueError(ts)
        return self.scrollPos[idx-1]

    def __iter__(self):
        return self

    def next(self, i=0):
        line = self.eyeCsv.next()
        if not line:
            raise StopIteration()
        return EyePosition(self, **dict(zip(self.headers, line)))

    def get_rec_start(self):
        rdate = self.info['Recording date']
        rtime = self.info['Recording time']
        return time.mktime(time.strptime('%s %s' % (rdate, rtime),
                                         DATE_FORMAT))

    def time_absolute(self, offset):
        return self.recStart + offset
