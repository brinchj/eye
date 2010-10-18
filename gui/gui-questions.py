#!/usr/bin/env python
# -*- encoding: latin-1 -*-
from PyQt4 import QtGui, QtCore
from models.questions import Ui_Form
from dialog import MessageBox
import json, exceptions, session, sys, os, subprocess, shlex


NEEDED = (
    'age', 'isMale', 'isFemale', 'enrolled',
    'mainSubject',
    ) + tuple('did'+X for X in ('Python','SML','Ruby','PHP','Other','OtherWhat',
                                'Java','C','HTML','Javascript')) + \
    ('codeYears', 'codeExp')

REQUIRED = (
    ('mainSubject', 'Hovedfag'),
    )

SESSION = session.Session()


def get_value(e):
    uni = lambda s: unicode(s, 'latin-1')
    methods = (('isChecked',str),
               ('currentText', uni),
               ('text', uni),
               ('value', str))
    for attr, method in methods:
        if hasattr(e, attr):
            return method(getattr(e, attr)())
    return None

def store():
    elems = dict( (n,get_value(e))
                  for n,e in form.__dict__.items() )
    r = {}
    for name in NEEDED:
        r[name] = elems[name]
    for n,word in REQUIRED:
        if not r[n]:
            MessageBox().show_msg('Fejl','Du mangler at udfylde: %s!' % word)
            return None
    return r

def save():
    res = store()
    if not res:
        return
    SESSION.store('quest_answers', store())
    app.closeAllWindows()
    subprocess.Popen(shlex.split(
        'python gui.py ../opgs/1/out/powerplant.sml ../opgs/1/sml/questions.json resume')).wait()

def main():
    global app, widget, form
    app = QtGui.QApplication([])
    widget = QtGui.QMainWindow()
    form = Ui_Form()
    form.setupUi(widget)
    widget.connect(form.pushButton,
                   QtCore.SIGNAL('clicked()'),
                   save)
    widget.showFullScreen()
    app.exec_()


if __name__ == '__main__':
    main()
