#!/usr/bin/env python

import string
from random import choice, shuffle

symbols = '!@#$%^&*()_+-=[]{}|\''

password = []
password += choice(string.ascii_uppercase)
password += choice(string.ascii_lowercase)
password += choice(string.digits)
password += choice(symbols)
password += [choice(string.ascii_letters + string.digits + symbols) for i in range(36)]
shuffle(password)

print ''.join(password)
