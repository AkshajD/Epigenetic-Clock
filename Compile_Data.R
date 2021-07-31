library(GEOquery)
library(xlsx)
## change my_id to be the dataset that you want, and get
## the data
my_id <- readline(prompt = "Enter Series Name/ID: ")
gse <- getGEO(my_id)
gse <- gse[[1]]

## Break dataset into info and expression subsets
sampleInfo <- pData(gse)
expressionData <- exprs(gse)

## Isolate information from subsets
column_names = colnames(sampleInfo)
if ('gender:ch1' %in% column_names) {
  information <- subset(sampleInfo, TRUE, c("gender:ch1", "age:ch1"))
} else if ('sex:ch1' %in% column_names) {
  information <- subset(sampleInfo, TRUE, c("sex:ch1", "age:ch1"))
}

## Isolate wanted CpG sites from expression subset
methylation <- expressionData[c("cg09809672","cg22736354", "cg02228185", "cg01820374", "cg06493994", "cg19761273"),]

## Flip columns and rows so that CpG sites are columns and
## patient names are rows
methylation <- as.data.frame(t(methylation))

## Combine both datasets into final dataframe
compiled_data <- data.frame(methylation, information)

## Write compiled dataset to csv file
file_path <- paste(my_id, "1.xlsx", sep = "")
write.xlsx(compiled_data, file_path, sheetName = "Sheet1", col.names = TRUE, row.names = TRUE, append = FALSE)
View(compiled_data)

## bad_patients <- sampleInfo[sampleInfo$characteristics_ch1.3 == "disease state: normal", ]
## sampleInfo <- sampleInfo[!(sampleInfo$characteristics_ch1.3 == "disease state: normal"), ]
## patient_names <- bad_patients$geo_accession
## expressionData <- as.data.frame(expressionData)
## newDataFrame <- expressionData[!(names(expressionData) %in% patient_names)]
## methylation <- newDataFrame[c("cg09809672","cg22736354", "cg02228185", "cg01820374", "cg06493994", "cg19761273"),]