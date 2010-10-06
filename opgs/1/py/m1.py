
""" Instruments of Power Plant """
instruments = [
    ('Pressure',      .1,    True ),
    ('Meter',         .9,    False),
    ('Water-Level',   .7,    True ),
    ('Frequency',     .5,    True ),
    ('Alarm1',         0,    True )
    ]


""" Manipulate data """
def add(ins, name, value):
    return ins + [ (name, value) ]

def has(ins, name):
    for i in ins:
        if i[0] == name:
            return True
    return False

def rem(ins, name):
    if len(ins) == 0:
        return None
    if ins[0][0] == name:
        return ins[1:]
    for i in range(len(ins))[1:]:
        if ins[i][0] == name:
            return ins[:i] + ins[i+1:]
    return None


""" Report failed systems """
def first_failed(ins):
    for elem in ins:
        if not elem[2]:
            return elem

def failed(ins):
    elems = []
    for elem in ins:
        if not elem[2]:
            elems.append(elem)
    return elems


""" Three of a kind - almost the same """
def alarm(ins):
    for elem in ins:
        name = elem[0]
        if 'ALARM' in name.upper() and elem[1] > 0:
            return True
    return False

def alarms(ins):
    count = 0
    for elem in ins:
        if 'ALARM' in name.upper() and elem[1] > 0:
            count += 1
    return count

def alarmed(ins):
    elems = []
    for elem in ins:
        if 'ALARM' in name.upper() and elem[1] > 0:
            elems.append(elem)
    return elems


""" Less than vs. greater than """
def high(ins):
    elems = []
    for elem in ins:
        if elem[1] > 0.5:
            elems.append(elem)
    return elems

def low(ins):
    elems = []
    for elem in ins:
        if elem[1] < 0.5:
            elems.append(elem)
    return elems


""" Two instrument boards """
def diff(ins0, ins1):
    elems = []
    for elem0 in ins0:
        change = True
        for elem1 in ins1:
            if elem0 == elem1:
                change = False
        if change:
            elems.append(elem0)
    return elems

def diff_all(ins0, ins1):
    return diff(ins0, ins1) + diff(ins1, ins0)

""" Print a status report """
def print_status(ins):
    print 'Name:', 'Value:', 'Operating:'
    for elem in ins:
        oper = 'Yes'
        if not elem[2]:
            oper = 'No'
        print elem[0] + ', ' + str(elem[1]) + ', ' + oper
