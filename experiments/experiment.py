import csv, time


DATE_FORMAT = '%m/%d/%Y %H:%M:%S %p'

class Experiment:
    def __init__(self, path):
        self.info = {}
        self.csv = csv.reader(file(path), csv.excel_tab)
        for line in self.csv:
            if len(line) > 10:
                break
            if len(line) == 2:
                n,v = line
                self.info[n.strip(' :')] = v.strip()
        self.headers = line
        self.rec_start = self.get_rec_start()

    def __iter__(self):
        return self

    def next(self,i=0):
        line = self.csv.next()
        if not line:
            raise StopIteration()
        return dict(zip(self.headers, line))

    def get_rec_start(self):
        rdate = self.info['Recording date']
        rtime = self.info['Recording time']
        return time.mktime(time.strptime('%s %s' % (rdate, rtime),
                                         DATE_FORMAT))

    def get_time_absolute(self, offset):
        return self.rec_start + offset
