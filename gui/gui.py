#!/usr/bin/env python

import time, thread
from PyQt4 import QtGui, QtCore
from PyQt4.QtCore import QObject

from models.main import Ui_MainWindow

class ScrollLogger(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.last = 0
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
            file('session.scrl.log','a').write(
                '\n'.join( '%f    %i' % (t, pos) for (t,pos) in log)+'\n')

def main():
    global s, widget, app, f
    app = QtGui.QApplication([])
    widget = QtGui.QMainWindow()
    form = Ui_MainWindow()
    form.setupUi(widget)
    form.txtSource.appendHtml(file('data/python.html').read())
    s = QtGui.QScrollBar()
    s.setStyleSheet('background-color: #bbb')
    s.setMinimumWidth(25)
    s.sizeHint = lambda : QtCore.QSize(25, 41)
    form.txtSource.setVerticalScrollBar(s)
    form.txtAssignment.appendHtml(file('data/python.html').read())
    f = ScrollLogger()
    s.installEventFilter(f)
    widget.show()
    time.sleep(.5)
    s.setValue(0)
    #app.exec_()


if __name__ == '__main__':
    main()
