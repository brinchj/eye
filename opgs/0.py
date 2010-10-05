def sum(lst):
    """ Sum elements """
    val = 0
    for n in lst:
        val += n
    return val

def avg(lst):
    """ Average """
    return sum(lst) / float(len(lst))

def se(a,lst):
    """ Squared error """
    err = 0
    for elem in lst:
        err += (a-elem)**2
    return err

def mse(lst):
    """ Mean squared error """
    a = avg(lst)
    b = se(a,lst)
    return b / float(len(lst))


def is_sorted(lst):
    """ Check if list is sorted """
    for i in range(len(lst)-1):
        if lst[i] > lst[i+1]:
            return False
    return True

def min(lst):
    """ Find minimum in list """
    if len(lst) == 0:
        return 0
    m = lst[0]
    for elem in lst:
        if elem < m:
            m = elem
    return m


def rev(lst):
    """ Reverse list """
    rev_lst = []
    for elem in lst:
        rev_lst = [elem] + rev_lst
    return rev_lst


def add_lsts(bs, cs):
    """ Add numbers from two lists """
    ns = []
    for i in range(len(bs)):
        ns.append(bs[i] + cs[i])
    return ns


def acc(numbers):
    """ Accumulate list """
    accs  = [0]
    count = 0
    for n in numbers:
        count += n
        accs.append(count)
    return accs


def ins(n, lst):
    """ Insert element into sorted list """
    for i in range(len(lst)):
        if n <= lst[i]:
            return lst[:i] + [n] + lst[i:]
    return lst + [n]

def ins_sort(lst):
    """ Insertion sort """
    sort = []
    for elem in lst:
        sort = ins(elem, sort)
    return sort

print is_sorted(ins_sort(range(10000)))
