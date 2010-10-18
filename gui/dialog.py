from PyQt4 import QtGui, QtCore
from PyQt4.QtGui import QMessageBox, QWidget

class MessageBox(QWidget):
    def __init__(self, parent=None):
        QWidget.__init__(self, parent)

        self.setGeometry(300, 300, 350, 80)
        self.setWindowTitle('box')

    def get_answer(self, title, question):
        answer = QMessageBox.question(self, title, question,
                                      QMessageBox.Yes, QMessageBox.No)
        return answer == QMessageBox.Yes

    def show_msg(self, title, msg):
        QMessageBox.question(self, title, msg, QMessageBox.Ok)
