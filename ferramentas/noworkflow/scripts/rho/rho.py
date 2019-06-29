#!/usr/bin/python3
from random import randint


def gcd(m, n):
    while n != 0:
        m, n = n, m % n
    return m


def rho(n):
    a = b = 2

    while True:
        a = pow(a, 2, n) + 1 % n
        b = pow(b, 2, n) + 1 % n
        b = pow(b, 2, n) + 1 % n
        d = gcd(a - b, n)

        if 1 < d < n:
            return d

        if d == n:
            return 1


def find_factors(n):
    l = list()

    while n % 2 == 0:
        l.append(2)
        n = n // 2

    r = rho(n)
    f = n if r == 1 else r
    l.append(f)
    n = n // r
    
    #print('R %d' % f)

    return l + find_factors(n) if r > 1 else l


def find_two_factors(n):
    if n % 2 == 0:
        return 2, n // 2

    r = rho(n)
    f = n if r == 1 else r

    return f, n // r


if __name__ == '__main__':
    # find_two_factors(161720844233529689499498448342098256937)

    # primes128 = [104886234885322983459507420328942558389, 258944132448049816428647600000802608169, 138846131360712174218176189070856607553, 196213069120630278619855713317309441375, 270193651262258175521798716957545296369, 303443603502123595331854851036075679501, 140278711689695351430248546515168364697, 248207264185641974936884365619705013627, 38693845445285424839003090866150421797, 315616169553035005651686106203097758831]

    for i in range(100):
        p = randint(2 ** 250, 2 ** 256) | 1

        # print('P: %d' % p)

        # print (find_factors(p))
        ini = time.time()
        f1, f2 = find_two_factors(p)
        elapsed_time = time.time() - ini
        # print('P: %d and factors are %d, %d in %4.8f ms' % (p, f1, f2, elapsed_time))
        print('%d ; %d, %d ; %4.8f' % (p, f1, f2, elapsed_time))
        print('i', i)
