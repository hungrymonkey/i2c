#!/usr/bin/env python2.7

import sys
import csv
import numpy as np
COL_SIZE = 1920
ROW_SIZE = 1920

OUTFILE1 = 'mat1.dat'
OUTFILE2 = 'mat2.dat'
OUTPUT = 'out.txt'

def main(args):
   mat1 = open( OUTFILE1, 'r')
   mat2 = open( OUTFILE2, 'r')
   of = open( OUTPUT, 'w')
   m1 = []
   m2 = []
   for line in mat1:
          m1.append(int(line) )
   for line in mat2:
          m2.append(int(line))
   matrix1 = np.asarray( m1 )
   matrix1 = np.resize( matrix1, (1920,1920))
   matrix2 = np.asarray( m2 )
   matrix2 = np.resize( matrix2, (1920,1920))
   p = int(args[1])
   out = multiply( matrix1, matrix2, p )
   print out
   out.tofile( of, ",")

def multiply( m1, m2, p ):
   return np.dot(m1 , m2[:,:p])



if __name__ == "__main__":
    main(sys.argv)
