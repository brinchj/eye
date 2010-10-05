#!/usr/bin/env python

import time
from PyQt4 import QtGui, QtCore

from form import Ui_MainWindow

def main():
    global s, widget, app
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
    form.txtAssignment.appendHtml(file('0.txt.html').read())
    widget.show()
    time.sleep(.5)
    s.setValue(0)
    #app.exec_()


if __name__ == '__main__':
    main()
