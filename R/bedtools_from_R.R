#### Calling bedTools from R: ####
# v 1.1 | git.sbamin.com
#Adapted from source: http://zvfak.blogspot.com/2011/02/calling-bedtools-from-r.html

# Following function assumes that bedTools is installed on your system. If not, visit http://bedtools.readthedocs.org/en/latest/ for more.

bedTools.2in<-function(functionstring="intersectBed",bed1,bed2,opt.string="")
{
  #create temp files in working R dir
  a.file=tempfile("afile",tmpdir=".")
  b.file=tempfile("bfile",tmpdir=".")
  out   =tempfile("out",tmpdir=".")
  options(scipen =99) # not to use scientific notation when writing out
 
  #write bed formatted dataframes to tempfile
  write.table(bed1,file=a.file,quote=F,sep="\t",col.names=F,row.names=F)
  write.table(bed2,file=b.file,quote=F,sep="\t",col.names=F,row.names=F)
 
  # create the command string and call the command using system()
  command=paste(functionstring,"-a",a.file,"-b",b.file,opt.string,">",out,sep=" ")
  cat(command,"\n")
  try(system(command))
 
  res=read.delim(out,header=F) # original was read.table. I prefer read.delim to avoid errors in reading file when one or more columns are empty.
  unlink(a.file);unlink(b.file);unlink(out) #WARNING: This will delete tempfiles from disk. To preserve tempfiles, uncheck this line.
  return(res) # save output as a R object.
}

 
#bed file format: More at https://genome.ucsc.edu/FAQ/FAQformat.html#format1
	#       V1    V2      V3       V4                   V5    V6
	#1     chr1 67051161 67052451 ENST00000371026       1      -
	#2     chr1 67060631 67060788 ENST00000371026       2      -
	#3     chr1 67065090 67065317 ENST00000371026       3      -
	#4     chr1 67066082 67066181 ENST00000371026       4      -
	#5     chr1 67071855 67071977 ENST00000371026       5      -
	#6     chr1 67072261 67072419 ENST00000371026       6      -

#example: 
#bedTools.2in("intersectBed",bed1,bed2,"-wo") # equivalent to "bedIntersect -a bed1 -b bed2 -wo" on terminal
#### end ####
