#!/usr/bin/env python
# -*- encoding: latin-1 -*-
from PyQt4 import QtGui, QtCore
from models.questions import Ui_Form
from dialog import MessageBox
import json, exceptions, session, sys


NEEDED = (
    'age', 'sex', 'enrolled',
    'mainSubject',
    ) + tuple('did'+X for X in ('Python','SML','Ruby','PHP','Other','OtherWhat',
                                'Java','C','HTML','Javascript')) + \
    ('didYears', 'isNew', 'isSmall', 'isOK', 'isGood')

REQUIRED = (
    ('sex', 'Køn'),
    ('mainSubject', 'Hovedfag'),
    )

SESSION = session.Session()


def get_value(e):
    uni = lambda s: unicode(s, 'latin-1')
    methods = (('isChecked',str),
               ('currentText', uni),
               ('text', uni))
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
    sys.exit()

def main():
    global app, widget, form
    app = QtGui.QApplication([])
    widget = QtGui.QMainWindow()
    form = Ui_Form()
    form.setupUi(widget)
    widget.connect(form.pushButton,
                   QtCore.SIGNAL('clicked()'),
                   save)
    widget.show()


if __name__ == '__main__':
    main()
