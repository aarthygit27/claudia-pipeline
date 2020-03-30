def func1(a):
    b  = 0
    c  = 0
    d  = 0
    new = ['New Money-New Services' ,'New Money-Extending Services']
    ren = ['Renegotiation-Service Replacement' , 'Renegotiation-Service Continuation']
    frame = ['Frame Agreement - New Services' , 'Frame Agreement - Renegotiation' , 'Frame Agreement - Extending Services']
    prices_list=[]
    for i in range(0,len(a)):
        if a[i] in new:
            b = b + int(float((a[i + 1])))
        if a[i] in ren:
            c = c + int(float((a[i + 1])))
        if a[i] in frame:
            d = d + int(float((a[i + 1])))
    prices_list.append(b)
    prices_list.append(c)
    prices_list.append(d)
    # return  prices_list
    return (b, c, d)
if __name__ == '__main__':
    a= func1([u'New Money-New Services', u'635.00', u'New Money-Extending Services', u'635.00', u'Frame Agreement - Extending Services', u'399.00', u'Frame Agreement - Renegotiation', u'370.00', u'Frame Agreement - Renegotiation', u'630.00'])
    # a=func1(a)
    print (a)
    # hello()