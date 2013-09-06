# Bulk install packages from bioconductor:
# v 1.0 | git.sbamin.com

args<-commandArgs(TRUE)
outFile <- paste0("/dump/",make.names(date()), ".Rout")
sink(outFile, split = TRUE)
setwd("/dump")

rlibpkgs <- rownames(installed.packages()) # alternately, export to text and double check before upgrade.
#rlibpkgs <- read.delim("packages_to_install.txt",colClasses="character")
#rlibpkgs <- unique(rlibpkgs[,1])

updatepkgs <- function (x) 
{
  if (isTRUE(x %in% .packages(TRUE,.libPaths()))) {
    Rpkg_update_log <- paste("Package ", x, " is already available in R library", sep = "")
  }
  else {
    source("http://bioconductor.org/biocLite.R")
    eval(parse(text = paste("biocLite('", x, "', ask=FALSE)", sep = ""))) #WARNING: All packages will be updated without warning. Use with caution, especially for packages which require several dependencies.
    if (isTRUE(x %in% .packages(TRUE,.libPaths()))) {
        Rpkg_update_log <- paste("Package ", x, " is now installed in R lib", sep = "")
      }
      else {
        Rpkg_update_log <- paste("Package ", x, " is not found in Bioconductor", sep = "")
  }
}}

Rlib_upgrade_log <- lapply(rlibpkgs,updatepkgs)

write.table(as.data.frame(unlist(Rlib_upgrade_log)),"/dump/Rlib_upgrade_log.txt")

sink()

# to run,
# Rscript bulk_install_packages.R >> install_stderr.txt 2>&1 >> install_stdout.txt &
#### end ####
