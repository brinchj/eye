
""" Instruments of Power Plant """
instruments = [
    ['Pressure',      10,    True ],
    ['Meter',         90,    False],
    ['Water-Level',   70,    True ],
    ['Frequency',     50,    True ],
    ['Alarm1',         0,    True ]
    ]


""" Manipulate data """
def add(ins, name, value):
    # return
    return [ [name, value, True] ] + ins

def has(ins, name):
    # for, if, return
    for i in ins:
        if i[0] == name:
            return True
    return False

def rem(ins, name):
    # if, for, return
    if len(ins) == 0:
        return []
    ins = list(ins)
    for i in range(len(ins)):
        if ins[i][0] == name:
            del ins[i]
            return ins
    return ins

def update(ins, name, value):
    # function call in function call
    if len(ins) == 0 or not has(ins, name):
        return ins
    return add(rem(ins, name), name, value)

""" Check for failures """
def first_failed(ins):
    # for, if, not, return
    i = 0
    while i < len(ins):
        elem = ins[i]
        if elem[2] == False:
            return elem
        i += 1
    return None

def too_high(ins):
    # if, else, return, recursive
    if len(ins) == 0:
        return []
    elem = ins[0]
    rest = too_high(ins[1:])
    if elem[1] > 90:
        return [elem] + rest
    else:
        return rest

""" Two instrument boards """
def diff(ins0, ins1):
    # for, if, return
    elems = []
    for elem0 in ins0:
        change = True
        for elem1 in ins1:
            if elem0 == elem1:
                change = False
        if change == True:
            elems.append(elem0)
    return elems

def diff_all(ins0, ins1):
    # return
    s  = str(diff(ins0, ins1)) + ' => '
    s += str(diff(ins1, ins0))
    return s

""" Print a status report """
def print_status(ins):
    # for, if, else
    print '===='
    print 'Name: Value: Operating:'
    for elem in ins:
        oper = ''
        if elem[2] == True:
            oper = 'Yes'
        else:
            oper = 'No'
        s = elem[0] + ', ' + str(elem[1]) + ', ' + oper
        print s
    print ''
    print 'High:', too_high(ins)
    print ''
    print 'Failed:', first_failed(ins)
    print '='*64

""" CLI for manipulating data """
def updater(ins):
    # while, if, elif, else, return, raw_input
    while True:
        print_status(ins)
        print ''
        name = raw_input('> name=')
        if name == 'quit':
            return ins
        if len(name) == 0:
            print 'No name.'
            ins_new = ins
        elif not has(ins, name):
            value = raw_input('INSERT value=')
            if len(value) == 0:
                print 'No value.'
                ins_new = ins
            else:
                ins_new = add(ins, name, int(value))
        else:
            value = raw_input('CHANGE value=')
            if value == 'REM':
                print 'REMOVE'
                ins_new = rem(ins, name)
            elif len(value) == 0:
                print 'No value.'
                ins_new = ins
            else:
                ins_new = update(ins, name, int(value))
        print diff_all(ins, ins_new)
        print ''
        ins = ins_new
