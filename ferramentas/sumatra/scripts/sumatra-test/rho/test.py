#!/usr/bin/python3
import sys, random, time
from rho import find_two_factors


# generate R (pseudo)random numbers of K bits using S as seed
def generate_numbers(r, k, s):
    random.seed(s)
    
    for _ in range(r):
        yield random.getrandbits(k)
    

if __name__ == '__main__':
    r = 50
    k = 42
    s = 1689441204489037473
    
    for n in generate_numbers(r, k, s):
        factors = find_two_factors(n)
        print ('number', n, 'has factors', factors)


