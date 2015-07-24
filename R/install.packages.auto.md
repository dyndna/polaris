#### R - Install package if require("package") exits with package not found error:

Adapted from the original work by Joshua Wiley, 
http://r.789695.n4.nabble.com/Install-package-automatically-if-not-there-td2267532.html

```r
install.packages.auto <- function(x) { 
  x <- as.character(substitute(x)) 
  if(isTRUE(x %in% .packages(all.available=TRUE))) { 
    eval(parse(text = sprintf("require(\"%s\")", x)))
  } else { 
    #update.packages(ask= FALSE) #update installed packages.
    eval(parse(text = sprintf("install.packages(\"%s\", dependencies = TRUE)", x)))
  }
  if(isTRUE(x %in% .packages(all.available=TRUE))) { 
    eval(parse(text = sprintf("require(\"%s\")", x)))
  } else {
    source("http://bioconductor.org/biocLite.R")
    #biocLite(character(), ask=FALSE) #update installed packages.
    eval(parse(text = sprintf("biocLite(\"%s\")", x)))
    eval(parse(text = sprintf("require(\"%s\")", x)))
  }
}
```

##### Example:
  
  install.packages.auto(qvalue) # from bioconductor
  install.packages.auto(rNMF) # from CRAN

PS: `update.packages(ask = FALSE)` & `biocLite(character(), ask=FALSE)` will update all installed packages on the system. This can take a long time and consider it as a full R upgrade whihc may not be warranted all the time! 
