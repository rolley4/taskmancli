#! /usr/bin/python2.7
# -*- coding: utf-8 -*-
"""[application description here]"""

import argparse

def main():
  pass

if __name__ == '__main__': main()

parser = argparse.ArgumentParser(description='Task manager CLI.')

parser.add_argument('integers', metavar='N', type=int, nargs='+',
                    help='an integer for the accumulator')

parser.add_argument('--sum', dest='accumulate', action='store_const',
                    const=sum, default=max,
                    help='sum the integers (default: find the max)')

args = parser.parse_args()
print args.accumulate(args.integers)
