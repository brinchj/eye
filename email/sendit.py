from email.MIMEText import MIMEText
import sys
import smtplib
import getpass

# Constants
TEST = True
LANG = 'SML'
COUR = 'Introduktion til Programmering'
FROM = '"Johan Brinch" <zerrez@diku.dk>'
USER = 'zerrez'

def send(smtp, to, fr, subject, msg):
    ''' Send e-mail through SMTP server '''
    msg = MIMEText(msg, _charset='utf-8')
    msg['from'] = fr
    msg['to']   = to
    msg['subject'] = subject
    smtp.sendmail(from_addr=fr, to_addrs=[to], msg=msg.as_string())

# Connect to GMail
smtp = smtplib.SMTP('smtp.googlemail.com')
smtp.starttls()
smtp.login(USER, getpass.getpass())

# Read mail subject and body
subject = file('subject').read()
body = file('body').read().replace('[SPROG]', LANG).replace('[KURSUS]', COUR)

# Just testing?
if TEST:
    print 'Sending test mail to:', FROM
    send(smtp, FROM, FROM, subject, body)
    sys.exit()

# Send e-mail to all listed users
for user,url in zip(file('users'),file('doodles')):
    user = user.strip('\n;')
    user_mail = '%s@alumni.ku.dk' % user
    print user_mail, url.strip()
    mail = body.replace('<<DOODLE>>', url.strip())
    send(smtp, FROM, user_mail, subject, mail)

# Close connection
smtp.quit()
