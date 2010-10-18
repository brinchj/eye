import os, uuid, time, json

SESSION_PATH='./sessions'

class Session:
    def __init__(self, _uuid=None):
        if not os.path.isdir(SESSION_PATH):
            os.mkdir(SESSION_PATH)
        if _uuid:
            self.uuid = _uuid
        else:
            self.uuid = '%s-%s' % (str(int(time.time())), str(uuid.uuid4()))
        self.path = '%s/%s' % (SESSION_PATH, self.uuid)
        if not os.path.isdir(self.path):
            os.mkdir(self.path)

    def store(self, key, value, mode='w'):
        print key,value
        path = '%s/%s' % (self.path, key)
        if mode=='w' and os.path.isfile(path):
            os.rename(path, path+'.old')
        file(path, mode).write(json.dumps(value)+'\n')

    def get(self, key):
        path = '%s/%s' % (self.path, key)
        return json.loads(file(path).read())
