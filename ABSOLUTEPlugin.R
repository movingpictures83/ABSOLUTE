# Option 1: GitHub
#devtools::install_github("ShixiangWang/DoAbsolute")


dyn.load(paste("RPluMA", .Platform$dynlib.ext, sep=""))
source("RPluMA.R")


library(DoAbsolute)
example_path = system.file("extdata", package = "DoAbsolute", mustWork = T)


library(data.table)
# Load Test Data ----------------------------------------------------------

input <- function(inputfile) {
        pfix <<- prefix()
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
   # Need to get the three files
   #csvfile <<- paste(pfix, parameters["csvfile", 2], sep="/")

   #myData <<- read.csv(csvfile)
   #mdrrClass <<- readLines(paste(pfix, parameters["classes", 2], sep="/"))

}

run <- function() {}

output <- function(outputfile) {
# segmentation file
seg_normal =  file.path(pfix, parameters["seq_normal", 2])
seg_solid  =  file.path(pfix, parameters["seq_solid", 2])
seg_metastatic  = file.path(pfix, parameters["seq_metastatic", 2])
# MAF file
maf_solid  = file.path(pfix, parameters["maf_solid", 2])
maf_metastatic  = file.path(pfix, parameters["maf_metastatic", 2])

# read data
seg_normal = fread(seg_normal)
seg_solid = fread(seg_solid)
seg_metastatic = fread(seg_metastatic)
maf_solid = fread(maf_solid)
maf_metastatic = fread(maf_metastatic)

# merge data
Seg = Reduce(rbind, list(seg_normal, seg_solid, seg_metastatic))
Maf = Reduce(rbind, list(maf_solid, maf_metastatic))

Seg$Sample = substr(Seg$Sample, 1, 15)
Maf$Tumor_Sample_Barcode = substr(Maf$Tumor_Sample_Barcode, 1, 15)

# test function
DoAbsolute(Seg = Seg, Maf = Maf, platform = "SNP_6.0", copy.num.type = "total",
           results.dir = outputfile, keepAllResult = TRUE, verbose = TRUE)
}
