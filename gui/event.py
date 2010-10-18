import time, thread
from PyQt4.QtCore import QObject

class ScrollLogger(QObject):
    def __init__(self, session):
        QObject.__init__(self)
        self.session = session
        self.last = None
        self.log  = []
        self.last_flush = time.time()
        thread.start_new_thread(self.flusher, ())

    def eventFilter(self, obj, e):
        if self.last != obj.value():
            self.last = obj.value()
            self.log.append( (time.time(), self.last) )
        return False

    def flusher(self):
        while True:
            self.flush()
            time.sleep(1)

    def flush(self):
        log, self.log = list(self.log), []
        if log:
            self.session.store('scroll.log', log, mode='a')


class MouseLogger(QObject):
    def __init__(self, session):
        QObject.__init__(self)
        self.session = session

    def eventFilter(self, obj, e):
        print obj, e
        return False
