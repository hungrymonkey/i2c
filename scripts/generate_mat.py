#!/usr/bin/env python2.7

import random

COL_SIZE = 1920
ROW_SIZE = 1920

OUTFILE1 = 'mat1.dat'
OUTFILE2 = 'mat2.dat'
def main():
   mat1 = open( OUTFILE1, 'w')
   mat2 = open( OUTFILE2, 'w')
   make_mat( mat1 )
   make_mat( mat2 )

def make_mat(outbuf):
   row = []
   for j in range( COL_SIZE ):
      for i in range( ROW_SIZE ):
          outbuf.write( str(random.randint(0,15))+"\n")
      #outbuf.write( ",".join( row ) )

      


if __name__ == "__main__":
    main()
