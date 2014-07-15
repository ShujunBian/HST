__author__ = 'apple'

import glob
import os


if __name__ == '__main__':
    names = glob.glob("*");
    for name in names:
    	if not 'P4_' in name:
	    	newname = "P4_" + name
	        os.rename(name,newname)

#        newname = name.replace("@2x.png","-hd.png")

