def int2hex(number, bits=16):
    if number < 0:
        hexval = hex((1 << bits) + number)
    else:
        hexval = hex(number)
    # return hexval.split('x')[-1].split('L')[0][-2:]
    return hexval.split('x')[-1]