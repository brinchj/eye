# -*- encoding: latin-1 -*-
#!/usr/bin/env python

import sys, re, thread, time, glob, os
from PyQt4 import QtGui, QtCore

import questions, html, session
from models.main import Ui_MainWindow
from event import ScrollLogger, MouseLogger
from dialog import MessageBox

SESSION = None


Q_NUM = 0
def resume(qs):
    global Q_NUM
    uuid = re.split(r'\\|/', list(sorted(
        glob.glob('%s/*-*' % session.SESSION_PATH), reverse=True))[0])[-1]
    print uuid
    answers = sorted(filter(lambda n: 'old' not in n,
                            glob.glob('%s/%s/answer-*' % (session.SESSION_PATH, uuid))),
                     reverse=True)
    ses = session.Session(uuid)
    if not answers:
        return ses, qs, ''
    last = answers[0]
    n = int(os.path.basename(last).split('-')[1])
    Q_NUM=n
    return ses, qs[n:], ses.get('answer-%i' % n)[1]


def load_question(path, n=0):
    return '''
    <html><body><div style="height: 100%%">
    <div style="display:table-cell; vertical-align:middle">%s</div>
    </div></body></html>
    ''' % file(path).read().replace('\n','<br/>')

def autosave(answer):
    SESSION.store('answer-%i' % Q_NUM, (time.time(), unicode(answer.toPlainText())))

def autosaver(answer):
    while True:
        autosave(answer)
        time.sleep(1)

def make_changer(answer, txt, qs):
    def clicked(*args, **kwargs):
        global Q_NUM
        if not (MessageBox().get_answer('Næste Spørgsmål?', 'Er du sikker på, at du vil gå videre?')):
            return
        print 'NEXT', Q_NUM
        autosave(answer)
        time.sleep(.2)
        if not qs:
            MessageBox().show_msg('Færdig!', 'Du har nu gennemgået alle spørgsmål :-)\nApplikationen lukker!')
            app.closeAllWindows()
            sys.exit()
        txt.clear()
        html,txtA = qs.pop(0)
        txt.appendHtml(html)
        answer.clear()
        answer.appendPlainText(txtA)
        Q_NUM += 1
    return clicked


def main():
    if len(sys.argv) not in (3,4):
        print '''Usage:
%s <code-file> <question-file> [resume]''' % sys.argv[0]
        sys.exit(0)

    code_path, quest_file = sys.argv[1:3]
    code = file(code_path).read()
    qs = list(questions.load(code, quest_file))

    global SESSION
    partialAnswer = ''
    if len(sys.argv) == 4 and sys.argv[3] in ('yes','resume','true','1'):
        SESSION, qs, partialAnswer = resume(qs)
    else:
        SESSION = session.Session()

    # Create and modify application
    global widget, app, s, form
    app = QtGui.QApplication([])
    widget = QtGui.QMainWindow()
    # Main Window
    form = Ui_MainWindow()
    form.setupUi(widget)
    form.txtSource.appendHtml(html.code_process_html(code_path+'.html'))
    # Scrollbar
    s = QtGui.QScrollBar()
    s.setStyleSheet('background-color: #bbb')
    s.setMinimumWidth(25)
    s.sizeHint = lambda : QtCore.QSize(25, 41)
    form.txtSource.setVerticalScrollBar(s)
    # Filters
    f = ScrollLogger(SESSION)
    s.installEventFilter(f)
    # Question
    htmlQ,txtA = qs.pop(0)
    form.txtAssignment.appendHtml(htmlQ)
    form.txtAnswer.appendPlainText(partialAnswer or txtA)
    # Signals
    widget.connect(form.pushButton,
                   QtCore.SIGNAL('clicked()'),
                   make_changer(form.txtAnswer, form.txtAssignment, qs))
    # Show
    widget.show()
    thread.start_new(autosaver, (form.txtAnswer,))
    widget.showFullScreen()


if __name__ == '__main__':
    main()
    while s.value() != 0:
        s.setValue(0)
    app.exec_()
    thread.exit()
