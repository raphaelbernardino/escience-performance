#!/usr/bin/python3
from time import sleep

def test(r):
    for i in range(r):
        print (i, 'mod 2 =', i % 2)
        sleep(1)
        
        with open('example.log', 'a') as f:
            f.write('data    ')
        with open('example.log', 'a') as f:
            f.write(str(i%10))
            f.write('\n')
        
if __name__ == '__main__':
    test(20)
